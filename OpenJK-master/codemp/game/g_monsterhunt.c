#include "g_local.h"
#include "g_nav.h"

#define MH_MAX_WAVES			32
#define MH_MAX_ENTRIES			32
#define MH_MAX_CONFIG_TEXT		32768
#define MH_MAX_SPAWN_POINTS		128

typedef struct
{
	char	npcType[MAX_QPATH];
	int		count;
} monsterHuntEntry_t;

typedef struct
{
	monsterHuntEntry_t entries[MH_MAX_ENTRIES];
	int					numEntries;
	int					maxActive;
} monsterHuntWave_t;

static monsterHuntWave_t	mhWaves[MH_MAX_WAVES];
static char					mhConfigText[MH_MAX_CONFIG_TEXT];

static int mhWaveDelay;
static int mhSpawnInterval;
static int mhWaveTimeout;
static int mhMaxActive;
static int mhFinalWave;

static int mhCurrentWave;
static int mhCurrentEntry;
static int mhEntrySpawned;
static int mhNextSpawnTime;
static int mhNextWaveTime;
static int mhLastProgressTime;
static int mhLastLiving;
static int mhSpawnFailures;

static qboolean mhStarted;
static qboolean mhWaveActive;
static qboolean mhFinished;

extern gentity_t *NPC_Spawn_Do(gentity_t *ent);

static char *MH_ParseToken(char **text)
{
	return COM_ParseExt((const char **)text, qtrue);
}

static qboolean MH_ReadInt(char **text, int *value)
{
	char *token = MH_ParseToken(text);

	if (!token || !token[0])
	{
		return qfalse;
	}

	*value = atoi(token);
	return qtrue;
}

static qboolean MH_ParseWave(char **text, int waveNumber)
{
	monsterHuntWave_t *wave;
	char *token;

	if (waveNumber < 1 || waveNumber > MH_MAX_WAVES)
	{
		trap->Print(
			"Monster Hunt: invalid wave number %i\n",
			waveNumber
		);
		return qfalse;
	}

	wave = &mhWaves[waveNumber - 1];

	token = MH_ParseToken(text);

	if (!token || Q_stricmp(token, "{"))
	{
		trap->Print(
			"Monster Hunt: expected { after wave %i\n",
			waveNumber
		);
		return qfalse;
	}

	while (1)
	{
		token = MH_ParseToken(text);

		if (!token || !token[0])
		{
			trap->Print(
				"Monster Hunt: unexpected end of wave %i\n",
				waveNumber
			);
			return qfalse;
		}

		if (!Q_stricmp(token, "}"))
		{
			break;
		}

		if (!Q_stricmp(token, "maxActive"))
		{
			if (!MH_ReadInt(text, &wave->maxActive))
			{
				return qfalse;
			}

			if (wave->maxActive < 1)
			{
				wave->maxActive = 1;
			}
			else if (wave->maxActive > 64)
			{
				wave->maxActive = 64;
			}

			continue;
		}

		if (!Q_stricmp(token, "monster"))
		{
			monsterHuntEntry_t *entry;
			char *npcType;

			if (wave->numEntries >= MH_MAX_ENTRIES)
			{
				trap->Print(
					"Monster Hunt: too many entries in wave %i\n",
					waveNumber
				);
				return qfalse;
			}

			npcType = MH_ParseToken(text);

			if (!npcType || !npcType[0])
			{
				return qfalse;
			}

			entry = &wave->entries[wave->numEntries];

			Q_strncpyz(
				entry->npcType,
				npcType,
				sizeof(entry->npcType)
			);

			if (!MH_ReadInt(text, &entry->count))
			{
				return qfalse;
			}

			if (entry->count < 1)
			{
				trap->Print(
					"Monster Hunt: invalid count for %s\n",
					entry->npcType
				);
				return qfalse;
			}

			wave->numEntries++;
			continue;
		}

		trap->Print(
			"Monster Hunt: unknown key %s in wave %i\n",
			token,
			waveNumber
		);
		return qfalse;
	}

	return qtrue;
}

static qboolean MH_LoadConfig(const char *filename)
{
	fileHandle_t file;
	char *text;
	char *token;
	int length;
	int waveNumber;
	int i;

	memset(mhWaves, 0, sizeof(mhWaves));

	mhWaveDelay = 5000;
	mhSpawnInterval = 750;
	mhWaveTimeout = 30000;
	mhMaxActive = 8;
	mhFinalWave = 5;

	file = 0;
	length = trap->FS_Open(filename, &file, FS_READ);

	if (length <= 0 || !file)
	{
		trap->Print(
			"Monster Hunt: config not found: %s\n",
			filename
		);
		return qfalse;
	}

	if (length >= sizeof(mhConfigText))
	{
		trap->Print(
			"Monster Hunt: config is too large: %s\n",
			filename
		);
		trap->FS_Close(file);
		return qfalse;
	}

	trap->FS_Read(mhConfigText, length, file);
	trap->FS_Close(file);

	mhConfigText[length] = '\0';
	text = mhConfigText;

	while (1)
	{
		token = MH_ParseToken(&text);

		if (!token || !token[0])
		{
			break;
		}

		if (!Q_stricmp(token, "waveDelay"))
		{
			if (!MH_ReadInt(&text, &mhWaveDelay))
			{
				return qfalse;
			}
			continue;
		}

		if (!Q_stricmp(token, "spawnInterval"))
		{
			if (!MH_ReadInt(&text, &mhSpawnInterval))
			{
				return qfalse;
			}
			continue;
		}

		if (!Q_stricmp(token, "waveTimeout"))
		{
			if (!MH_ReadInt(&text, &mhWaveTimeout))
			{
				return qfalse;
			}
			continue;
		}

		if (!Q_stricmp(token, "maxActive"))
		{
			if (!MH_ReadInt(&text, &mhMaxActive))
			{
				return qfalse;
			}
			continue;
		}

		if (!Q_stricmp(token, "finalWave"))
		{
			if (!MH_ReadInt(&text, &mhFinalWave))
			{
				return qfalse;
			}
			continue;
		}

		if (!Q_stricmp(token, "wave"))
		{
			if (!MH_ReadInt(&text, &waveNumber))
			{
				return qfalse;
			}

			if (!MH_ParseWave(&text, waveNumber))
			{
				return qfalse;
			}

			continue;
		}

		trap->Print(
			"Monster Hunt: unknown config key %s\n",
			token
		);
		return qfalse;
	}

	if (mhWaveDelay < 0)
	{
		mhWaveDelay = 0;
	}

	if (mhSpawnInterval < 100)
	{
		mhSpawnInterval = 100;
	}

	if (mhWaveTimeout < 5000)
	{
		mhWaveTimeout = 5000;
	}

	if (mhMaxActive < 1)
	{
		mhMaxActive = 1;
	}
	else if (mhMaxActive > 64)
	{
		mhMaxActive = 64;
	}

	if (mhFinalWave < 1 || mhFinalWave > MH_MAX_WAVES)
	{
		trap->Print(
			"Monster Hunt: invalid finalWave %i\n",
			mhFinalWave
		);
		return qfalse;
	}

	for (i = 0; i < mhFinalWave; i++)
	{
		if (mhWaves[i].numEntries < 1)
		{
			trap->Print(
				"Monster Hunt: wave %i is empty\n",
				i + 1
			);
			return qfalse;
		}
	}

	mhCurrentWave = 0;
	mhCurrentEntry = 0;
	mhEntrySpawned = 0;
	mhNextSpawnTime = 0;
	mhNextWaveTime = 0;
	mhLastProgressTime = 0;
	mhLastLiving = 0;
	mhSpawnFailures = 0;

	mhStarted = qfalse;
	mhWaveActive = qfalse;
	mhFinished = qfalse;

	trap->Print(
		"Monster Hunt: loaded %s, waves: %i\n",
		filename,
		mhFinalWave
	);

	return qtrue;
}

static qboolean MH_HasParticipants(void)
{
	int i;

	for (i = 0; i < level.maxclients; i++)
	{
		gentity_t *player = &g_entities[i];

		if (
			!player->inuse ||
			!player->client ||
			player->client->pers.connected != CON_CONNECTED ||
			player->client->sess.sessionTeam == TEAM_SPECTATOR
		)
		{
			continue;
		}

		return qtrue;
	}

	return qfalse;
}

static qboolean MH_SpotFarFromPlayers(gentity_t *spot)
{
	int i;
	vec3_t delta;

	for (i = 0; i < level.maxclients; i++)
	{
		gentity_t *player = &g_entities[i];

		if (
			!player->inuse ||
			!player->client ||
			player->client->pers.connected != CON_CONNECTED ||
			player->client->sess.sessionTeam == TEAM_SPECTATOR ||
			player->health <= 0
		)
		{
			continue;
		}

		VectorSubtract(
			spot->s.origin,
			player->r.currentOrigin,
			delta
		);

		if (DotProduct(delta, delta) < (256.0f * 256.0f))
		{
			return qfalse;
		}
	}

	return qtrue;
}

static gentity_t *MH_FindSpawnClass(
	const char *classname,
	qboolean requireDistance
)
{
	gentity_t *spot = NULL;
	gentity_t *spots[MH_MAX_SPAWN_POINTS];
	int count = 0;

	while (
		(spot = G_Find(
			spot,
			FOFS(classname),
			classname
		)) != NULL
	)
	{
		if (SpotWouldTelefrag(spot))
		{
			continue;
		}

		if (
			requireDistance &&
			!MH_SpotFarFromPlayers(spot)
		)
		{
			continue;
		}

		spots[count++] = spot;

		if (count >= MH_MAX_SPAWN_POINTS)
		{
			break;
		}
	}

	if (!count)
	{
		return NULL;
	}

	return spots[Q_irand(0, count - 1)];
}

static gentity_t *MH_ChooseSpawnPoint(void)
{
	gentity_t *spot;

	spot = MH_FindSpawnClass(
		"info_monsterhunt_spawn",
		qtrue
	);

	if (!spot)
	{
		spot = MH_FindSpawnClass(
			"info_monsterhunt_spawn",
			qfalse
		);
	}

	if (!spot)
	{
		spot = MH_FindSpawnClass(
			"info_player_deathmatch",
			qtrue
		);
	}

	if (!spot)
	{
		spot = MH_FindSpawnClass(
			"info_player_deathmatch",
			qfalse
		);
	}

	return spot;
}

static int MH_LivingMonsterCount(void)
{
	int i;
	int count = 0;

	for (i = MAX_CLIENTS; i < level.num_entities; i++)
	{
		gentity_t *monster = &g_entities[i];

		if (
			!monster->inuse ||
			!monster->monsterHuntNPC ||
			monster->s.eType != ET_NPC ||
			!monster->client ||
			monster->health <= 0 ||
			monster->client->ps.stats[STAT_HEALTH] <= 0 ||
			(monster->client->ps.eFlags & EF_DEAD)
		)
		{
			continue;
		}

		count++;
	}

	return count;
}

static qboolean MH_SpawnMonster(const char *npcType)
{
	gentity_t *spot;
	gentity_t *spawner;
	gentity_t *monster;

	spot = MH_ChooseSpawnPoint();

	if (!spot)
	{
		return qfalse;
	}

	spawner = G_Spawn();

	if (!spawner)
	{
		return qfalse;
	}

	spawner->classname = "NPC_spawner";
	spawner->NPC_type = (char *)npcType;
	spawner->count = 1;
	spawner->wait = 500;

	G_SetOrigin(spawner, spot->s.origin);

	/*
	 * NPC_Spawn_Do reads the spawning position from s.origin,
	 * while G_SetOrigin only updates currentOrigin and trBase.
	 */
	VectorCopy(
		spawner->r.currentOrigin,
		spawner->s.origin
	);

	VectorCopy(spot->s.angles, spawner->s.angles);

	trap->LinkEntity((sharedEntity_t *)spawner);

	monster = NPC_Spawn_Do(spawner);

	if (!monster || !monster->inuse || !monster->client)
	{
		return qfalse;
	}

	monster->monsterHuntNPC = qtrue;

	monster->client->playerTeam = NPCTEAM_ENEMY;
	monster->client->enemyTeam = NPCTEAM_PLAYER;

	monster->s.teamowner = NPCTEAM_ENEMY;
	monster->client->sess.sessionTeam = TEAM_FREE;
	monster->client->ps.persistant[PERS_TEAM] = TEAM_FREE;

	return qtrue;
}

static int MH_RelocateMonsters(void)
{
	int i;
	int relocated = 0;

	for (i = MAX_CLIENTS; i < level.num_entities; i++)
	{
		gentity_t *monster = &g_entities[i];
		gentity_t *spot;

		if (
			!monster->inuse ||
			!monster->monsterHuntNPC ||
			monster->s.eType != ET_NPC ||
			!monster->client ||
			monster->health <= 0
		)
		{
			continue;
		}

		spot = MH_ChooseSpawnPoint();

		if (!spot)
		{
			continue;
		}

		trap->UnlinkEntity((sharedEntity_t *)monster);

		G_SetOrigin(monster, spot->s.origin);
		
		VectorCopy(
			monster->r.currentOrigin,
			monster->s.origin
		);

		VectorCopy(
			spot->s.origin,
			monster->client->ps.origin
		);

		VectorClear(monster->client->ps.velocity);

		monster->s.groundEntityNum = ENTITYNUM_NONE;
		monster->client->ps.groundEntityNum = ENTITYNUM_NONE;
		monster->enemy = NULL;
		monster->waypoint = WAYPOINT_NONE;

		trap->LinkEntity((sharedEntity_t *)monster);
		relocated++;
	}

	return relocated;
}

static void MH_BeginWave(void)
{
	mhCurrentEntry = 0;
	mhEntrySpawned = 0;
	mhNextSpawnTime = level.time;
	mhLastProgressTime = level.time;
	mhLastLiving = 0;
	mhSpawnFailures = 0;
	mhWaveActive = qtrue;

	trap->SendServerCommand(
		-1,
		va(
			"cp \"Monster Hunt\nWave %i of %i\"",
			mhCurrentWave + 1,
			mhFinalWave
		)
	);
}

static void MH_CompleteWave(gentity_t *controller)
{
	trap->SendServerCommand(
		-1,
		va(
			"print \"Monster Hunt: wave %i cleared.\n\"",
			mhCurrentWave + 1
		)
	);

	if (mhCurrentWave + 1 >= mhFinalWave)
	{
		mhFinished = qtrue;
		mhWaveActive = qfalse;
		level.monsterHuntFinished = qtrue;

		trap->SendServerCommand(
			-1,
			"cp \"Monster Hunt completed!\""
		);

		if (level.monsterHuntOneLife)
		{
			LogExit("Monster Hunt One Life completed.");
		}

		controller->think = NULL;
		controller->nextthink = 0;
		return;
	}

	mhCurrentWave++;
	mhWaveActive = qfalse;
	mhNextWaveTime = level.time + mhWaveDelay;
}

static void MH_ControllerThink(gentity_t *self)
{
	monsterHuntWave_t *wave;
	monsterHuntEntry_t *entry;
	int living;
	int activeLimit;

	self->nextthink = level.time + 100;

	if (
		mhFinished ||
		level.intermissiontime ||
		level.intermissionQueued ||
		level.warmupTime
	)
	{
		return;
	}

	if (!MH_HasParticipants())
	{
		return;
	}

	if (!mhStarted)
	{
		mhStarted = qtrue;
		mhCurrentWave = 0;
		mhNextWaveTime = level.time + mhWaveDelay;

		trap->SendServerCommand(
			-1,
			"print \"Monster Hunt begins.\n\""
		);
		return;
	}

	if (!mhWaveActive)
	{
		if (level.time >= mhNextWaveTime)
		{
			MH_BeginWave();
		}

		return;
	}

	wave = &mhWaves[mhCurrentWave];

	while (mhCurrentEntry < wave->numEntries)
	{
		entry = &wave->entries[mhCurrentEntry];

		if (mhEntrySpawned < entry->count)
		{
			break;
		}

		mhCurrentEntry++;
		mhEntrySpawned = 0;
		mhSpawnFailures = 0;
	}

	living = MH_LivingMonsterCount();

	if (living < mhLastLiving)
	{
		mhLastProgressTime = level.time;
	}

	mhLastLiving = living;

	if (mhCurrentEntry >= wave->numEntries)
	{
		if (living == 0)
		{
			MH_CompleteWave(self);
			return;
		}

		if (
			level.time - mhLastProgressTime >=
			mhWaveTimeout
		)
		{
			int relocated = MH_RelocateMonsters();

			mhLastProgressTime = level.time;

			trap->Print(
				"Monster Hunt: relocated %i monsters\n",
				relocated
			);
		}

		return;
	}

	activeLimit = wave->maxActive > 0
		? wave->maxActive
		: mhMaxActive;

	if (living >= activeLimit)
	{
		return;
	}

	if (level.time < mhNextSpawnTime)
	{
		return;
	}

	entry = &wave->entries[mhCurrentEntry];

	if (MH_SpawnMonster(entry->npcType))
	{
		mhEntrySpawned++;
		mhSpawnFailures = 0;
		mhLastProgressTime = level.time;
		mhLastLiving = MH_LivingMonsterCount();
		mhNextSpawnTime = level.time + mhSpawnInterval;
	}
	else
	{
		mhSpawnFailures++;
		mhNextSpawnTime = level.time + 1000;

		if (mhSpawnFailures >= 3)
		{
			trap->Print(
				"Monster Hunt: unable to spawn %s; entry skipped\n",
				entry->npcType
			);

			mhEntrySpawned = entry->count;
			mhSpawnFailures = 0;
		}
	}
}

static void MH_Enable(gentity_t *ent, qboolean oneLife)
{
	char *config;
	float delay;

	if (level.monsterHunt)
	{
		trap->Print(
			"Monster Hunt: duplicate controller ignored\n"
		);
		G_FreeEntity(ent);
		return;
	}

	if (oneLife && level.gametype != GT_TEAM)
	{
		trap->Print(
			"info_monsterhuntonelife requires Team FFA\n"
		);
		G_FreeEntity(ent);
		return;
	}

	if (!g_allowNPC.integer)
	{
		trap->Print(
			"Monster Hunt requires g_allowNPC 1\n"
		);
		G_FreeEntity(ent);
		return;
	}

	G_SpawnString(
		"config",
		"monsterwaves.cfg",
		&config
	);

	G_SpawnFloat("delay", "10", &delay);

	if (delay < 0.0f)
	{
		delay = 0.0f;
	}

	if (!MH_LoadConfig(config))
	{
		G_FreeEntity(ent);
		return;
	}

	level.monsterHunt = qtrue;
	level.monsterHuntOneLife = oneLife;
	level.monsterHuntFinished = qfalse;

	if (oneLife)
	{
		level.oneLifeTeamFFA = qtrue;
		level.oneLifeTeamFFAArmed = qfalse;
		level.oneLifeTeamFFAArmTime =
			level.time + (int)(delay * 1000.0f);
	}

	ent->think = MH_ControllerThink;
	ent->nextthink = level.time + 1000;

	trap->Print(
		"Monster Hunt enabled; one life: %i\n",
		oneLife
	);
}

void SP_info_monsterhunt(gentity_t *ent)
{
	MH_Enable(ent, qfalse);
}

void SP_info_monsterhuntonelife(gentity_t *ent)
{
	MH_Enable(ent, qtrue);
}