#include "g_local.h"

typedef enum {
	MONSTER_STATE_IDLE,
	MONSTER_STATE_MOVE,
	MONSTER_STATE_MELEE,
	MONSTER_STATE_RANGED,
	MONSTER_STATE_PAIN,
	MONSTER_STATE_DEATH
} monsterState_t;

static void G_MonsterPain(
	gentity_t *self,
	gentity_t *attacker,
	int damage
);

static qboolean G_MonsterCanSeeTarget(
	gentity_t *monster,
	gentity_t *target
);

static void G_MonsterDie(
	gentity_t *self,
	gentity_t *inflictor,
	gentity_t *attacker,
	int damage,
	int mod
);

static int monsterItemCounter;
static int monsterActiveCount;
static void G_MonsterThink(gentity_t *ent);


#define MAX_MONSTER_WAVES		32
#define DEFAULT_MONSTER_WAVES		5
#define MAX_MONSTERS_IN_WAVE		8
#define MAX_MONSTER_WAVE_TEXT		8192

typedef struct {
	int	monsterType;
	int	monsterSlot;
	int	count;
} monsterWaveEntry_t;

typedef struct {
	monsterWaveEntry_t entries[MAX_MONSTERS_IN_WAVE];
	int	numEntries;
	qboolean repeat;
} monsterWaveDef_t;

static monsterWaveDef_t monsterWaves[MAX_MONSTER_WAVES];

static int monsterWaveDelay;
static int monsterWaveSpawnInterval;
static int monsterWaveTimeout;
static int monsterWaveMaxActive;
static int monsterWaveFinal;
static qboolean monsterWavesLoaded;

static int monsterCurrentWave;
static int monsterWaveEntry;
static int monsterWaveEntrySpawned;
static int monsterWaveNextSpawn;
static int monsterWaveNextStart;
static int monsterWaveLastProgress;

static qboolean monsterWaveActive;
static qboolean monsterWaveStarted;
static qboolean monsterWaveCombatStarted;
static qboolean monsterWaveFinished;

static qboolean G_LoadMonsterWaveConfig(
	const char *filename
);


static void G_MonsterSetAnimation(
	gentity_t *monster,
	int animation,
	int variant
);

static int G_MonsterTalkDelay(monsterDef_t *def);

static void G_MonsterSound(
	gentity_t *monster,
	monsterDef_t *def,
	const char *group,
	int variant
);

monsterDef_t g_monsterDefs
	[MONSTER_TYPE_RANDOM]
	[MAX_MONSTERS_PER_TYPE];

qboolean g_monsterDefLoaded
	[MONSTER_TYPE_RANDOM]
	[MAX_MONSTERS_PER_TYPE];

static const char *monsterConfigFiles[] = {
	"models/monsters/HereticDisciple/monster.cfg",
	"models/monsters/DarkKnight/monster.cfg",
	"models/monsters/LionGuy/monster.cfg",
	"models/monsters/D3Imp/monster.cfg",
	"models/monsters/Gross/monster.cfg",
	"models/monsters/Flyer/monster.cfg",
	"models/monsters/Hover/monster.cfg",
	"models/monsters/FlyingGuard/monster.cfg",
	"models/monsters/StrongF/monster.cfg",
	"models/monsters/Gunner/monster.cfg",	
	"models/monsters/MongGrunt/monster.cfg",
	"models/monsters/MongGruntShotgun/monster.cfg",
	"models/monsters/MongGruntRifle/monster.cfg",
	"models/monsters/Faust/monster.cfg",
	"models/monsters/Stratos/monster.cfg",
	"models/monsters/Mincer/monster.cfg",
	"models/monsters/Forgotten/monster.cfg",
	"models/monsters/Ghost/monster.cfg",
	"models/monsters/Mancubus/monster.cfg",
	"models/monsters/Frostatronach/monster.cfg",
	"models/monsters/Trooper/monster.cfg",
	"models/monsters/TrooperShotgun/monster.cfg",
	"models/monsters/TrooperBlaster/monster.cfg",
	"models/monsters/TrooperFlyer/monster.cfg",
	"models/monsters/TrooperRocket/monster.cfg",	
	NULL
};

static qboolean G_LoadMonsterConfig(const char *filename) {
	fileHandle_t file;
	char text[MAX_MONSTER_CONFIG_TEXT];
	char error[256];
	monsterDef_t def;
	int length;

	length = trap_FS_FOpenFile(filename, &file, FS_READ);

	if (!file) {
		G_Printf(
			S_COLOR_RED "Monster config not found: %s\n",
			filename
		);
		return qfalse;
	}

	if (length <= 0 || length >= sizeof(text)) {
		G_Printf(
			S_COLOR_RED "Invalid monster config size: %s\n",
			filename
		);
		trap_FS_FCloseFile(file);
		return qfalse;
	}

	trap_FS_Read(text, length, file);
	text[length] = '\0';
	trap_FS_FCloseFile(file);

	if (!BG_ParseMonsterConfig(
		text,
		&def,
		error,
		sizeof(error)
	)) {
		G_Printf(
			S_COLOR_RED "Monster config error in %s: %s\n",
			filename,
			error
		);
		return qfalse;
	}

	if (def.monsterType <= MONSTER_TYPE_OFF ||
		def.monsterType >= MONSTER_TYPE_RANDOM) {
		G_Printf(
			S_COLOR_RED "Invalid monster type in %s\n",
			filename
		);
		return qfalse;
	}

	if (def.monsterSlot < 0 ||
		def.monsterSlot >= MAX_MONSTERS_PER_TYPE) {
		G_Printf(
			S_COLOR_RED "Invalid monster slot in %s\n",
			filename
		);
		return qfalse;
	}

	g_monsterDefs[def.monsterType][def.monsterSlot] = def;
	g_monsterDefLoaded[def.monsterType][def.monsterSlot] = qtrue;

	G_Printf(
		S_COLOR_GREEN
		"Loaded monster: %s, type %i, slot %i\n",
		def.name,
		def.monsterType,
		def.monsterSlot
	);

	return qtrue;
}


static qboolean G_MonsterWaveReadInt(
	char **text,
	int *value
) {
	char *token;

	token = COM_Parse(text);

	if( !token[0] ) {
		return qfalse;
	}

	*value = atoi(token);
	return qtrue;
}

static qboolean G_MonsterWaveFindDefinition(
	const char *name,
	int *monsterType,
	int *monsterSlot
) {
	int type;
	int slot;

	for( type = MONSTER_TYPE_OFF + 1;
		type < MONSTER_TYPE_RANDOM;
		type++ ) {
		for( slot = 0;
			slot < MAX_MONSTERS_PER_TYPE;
			slot++ ) {
			if( !g_monsterDefLoaded[type][slot] ) {
				continue;
			}

			if( !Q_stricmp(
				g_monsterDefs[type][slot].name,
				name
			) ) {
				*monsterType = type;
				*monsterSlot = slot;
				return qtrue;
			}
		}
	}

	return qfalse;
}

static qboolean G_MonsterWaveParseWave(
	char **text,
	int waveNumber
) {
	monsterWaveDef_t *wave;
	char *token;

	if( waveNumber < 1 ||
		waveNumber > MAX_MONSTER_WAVES ) {
		G_Printf(
			S_COLOR_RED
			"Monster waves: invalid wave %i\n",
			waveNumber
		);
		return qfalse;
	}

	wave = &monsterWaves[waveNumber - 1];

	token = COM_Parse(text);

	if( Q_stricmp(token, "{") ) {
		G_Printf(
			S_COLOR_RED
			"Monster waves: expected { after wave %i\n",
			waveNumber
		);
		return qfalse;
	}

	while( 1 ) {
		token = COM_Parse(text);

		if( !token[0] ) {
			G_Printf(
				S_COLOR_RED
				"Monster waves: unexpected end of wave %i\n",
				waveNumber
			);
			return qfalse;
		}

		if( !Q_stricmp(token, "}") ) {
			break;
		}

		if( !Q_stricmp(token, "monster") ) {
			monsterWaveEntry_t *entry;
			char monsterName[MAX_QPATH];

			if( wave->numEntries >=
				MAX_MONSTERS_IN_WAVE ) {
				G_Printf(
					S_COLOR_RED
					"Monster waves: too many entries in wave %i\n",
					waveNumber
				);
				return qfalse;
			}

			token = COM_Parse(text);

			if( !token[0] ) {
				return qfalse;
			}

			Q_strncpyz(
				monsterName,
				token,
				sizeof(monsterName)
			);

			entry =
				&wave->entries[wave->numEntries];

			if( !G_MonsterWaveFindDefinition(
				monsterName,
				&entry->monsterType,
				&entry->monsterSlot
			) ) {
				G_Printf(
					S_COLOR_RED
					"Monster waves: unknown monster %s\n",
					monsterName
				);
				return qfalse;
			}

			if( !G_MonsterWaveReadInt(
				text,
				&entry->count
			) ) {
				return qfalse;
			}

			if( entry->count < 1 ) {
				G_Printf(
					S_COLOR_RED
					"Monster waves: invalid count for %s\n",
					monsterName
				);
				return qfalse;
			}

			wave->numEntries++;
			continue;
		}

		if( !Q_stricmp(token, "repeat") ) {
			token = COM_Parse(text);

			if( !token[0] ) {
				return qfalse;
			}

			wave->repeat =
				!Q_stricmp(token, "true") ||
				atoi(token) != 0;

			continue;
		}

		G_Printf(
			S_COLOR_RED
			"Monster waves: unknown key %s in wave %i\n",
			token,
			waveNumber
		);
		return qfalse;
	}

	return qtrue;
}

static qboolean G_LoadMonsterWaveConfig(
	const char *filename
) {
	fileHandle_t file;
	char buffer[MAX_MONSTER_WAVE_TEXT];
	char *text;
	char *token;
	int length;
	int value;
	int i;

	memset(
		monsterWaves,
		0,
		sizeof(monsterWaves)
	);

	/*
	 * Default values used when a key is absent
	 * from monsterwaves.cfg.
	 */
	monsterWaveDelay = 5000;
	monsterWaveSpawnInterval = 750;
	monsterWaveTimeout = 30000;
	monsterWaveMaxActive = 8;
	monsterWaveFinal = DEFAULT_MONSTER_WAVES;

	length = trap_FS_FOpenFile(
		filename,
		&file,
		FS_READ
	);

	if( !file ) {
		G_Printf(
			S_COLOR_RED
			"Monster wave config not found: %s\n",
			filename
		);
		return qfalse;
	}

	if( length <= 0 ||
		length >= sizeof(buffer) ) {
		G_Printf(
			S_COLOR_RED
			"Invalid monster wave config size: %s\n",
			filename
		);

		trap_FS_FCloseFile(file);
		return qfalse;
	}

	trap_FS_Read(buffer, length, file);
	buffer[length] = '\0';
	trap_FS_FCloseFile(file);

	text = buffer;

	while( 1 ) {
		token = COM_Parse(&text);

		if( !token[0] ) {
			break;
		}

		if( !Q_stricmp(token, "waveDelay") ) {
			if( !G_MonsterWaveReadInt(
				&text,
				&monsterWaveDelay
			) ) {
				return qfalse;
			}

			continue;
		}

		if( !Q_stricmp(token, "spawnInterval") ) {
			if( !G_MonsterWaveReadInt(
				&text,
				&monsterWaveSpawnInterval
			) ) {
				return qfalse;
			}

			continue;
		}

		if( !Q_stricmp(token, "waveTimeout") ) {
			if( !G_MonsterWaveReadInt(
				&text,
				&monsterWaveTimeout
			) ) {
				return qfalse;
			}

			continue;
		}

		if( !Q_stricmp(token, "maxActive") ) {
			if( !G_MonsterWaveReadInt(
				&text,
				&monsterWaveMaxActive
			) ) {
				return qfalse;
			}

			continue;
		}

		if( !Q_stricmp(token, "finalWave") ) {
			if( !G_MonsterWaveReadInt(
				&text,
				&monsterWaveFinal
			) ) {
				return qfalse;
			}

			continue;
		}

		if( !Q_stricmp(token, "wave") ) {
			if( !G_MonsterWaveReadInt(
				&text,
				&value
			) ) {
				return qfalse;
			}

			if( !G_MonsterWaveParseWave(
				&text,
				value
			) ) {
				return qfalse;
			}

			continue;
		}

		G_Printf(
			S_COLOR_RED
			"Monster waves: unknown key %s\n",
			token
		);

		return qfalse;
	}

	/*
	 * Sanitize timing and entity limits.
	 */
	if( monsterWaveDelay < 0 ) {
		monsterWaveDelay = 0;
	}

	if( monsterWaveSpawnInterval < 100 ) {
		monsterWaveSpawnInterval = 100;
	}

	if( monsterWaveTimeout < 5000 ) {
		monsterWaveTimeout = 5000;
	}

	if( monsterWaveMaxActive < 1 ) {
		monsterWaveMaxActive = 1;
	}
	else if( monsterWaveMaxActive > 64 ) {
		monsterWaveMaxActive = 64;
	}

	if( monsterWaveFinal < 1 ||
		monsterWaveFinal >
			MAX_MONSTER_WAVES ) {
		monsterWaveFinal =
			DEFAULT_MONSTER_WAVES;
	}

	/*
	 * Every enabled wave must contain at least
	 * one monster definition.
	 */
	for( i = 0;
		i < monsterWaveFinal;
		i++ ) {
		if( monsterWaves[i].numEntries == 0 ) {
			G_Printf(
				S_COLOR_RED
				"Monster waves: wave %i is empty\n",
				i + 1
			);

			return qfalse;
		}
	}

	G_Printf(
		S_COLOR_GREEN
		"Loaded monsterwaves.cfg: %i waves, "
		"max %i active, timeout %i ms\n",
		monsterWaveFinal,
		monsterWaveMaxActive,
		monsterWaveTimeout
	);

	return qtrue;
}


void G_MonsterInitDefinitions(void) {
	int i;
	
	monsterItemCounter = 0;
	monsterActiveCount = 0;
	
	monsterCurrentWave = 0;
	monsterWaveEntry = 0;
	monsterWaveEntrySpawned = 0;
	monsterWaveNextSpawn = 0;
	monsterWaveNextStart = 0;
	monsterWaveLastProgress = 0;

	monsterWaveActive = qfalse;
	monsterWaveStarted = qfalse;
	monsterWaveCombatStarted = qfalse;
	monsterWaveFinished = qfalse;

	memset(g_monsterDefs, 0, sizeof(g_monsterDefs));
	memset(g_monsterDefLoaded, 0, sizeof(g_monsterDefLoaded));

	for (i = 0; monsterConfigFiles[i]; i++) {
		G_LoadMonsterConfig(monsterConfigFiles[i]);
	}
	
	monsterWavesLoaded = qfalse;

	/*
	 * Both Monster Hunt modes use monsterwaves.cfg.
	 */
	if( g_monsterHunt.integer !=
		MONSTER_HUNT_OFF ) {
		monsterWavesLoaded =
			G_LoadMonsterWaveConfig(
				"monsterwaves.cfg"
			);
	}
}

static qboolean G_MonsterEligibleItem(gentity_t *item) {
	if (!item || !item->item) {
		return qfalse;
	}

	if (item->flags & FL_DROPPED_ITEM) {
		return qfalse;
	}

	if (item->team || item->targetname || item->wait == -1) {
		return qfalse;
	}

	switch (item->item->giType) {
	case IT_WEAPON:
	case IT_AMMO:
	case IT_ARMOR:
	case IT_HEALTH:
	case IT_POWERUP:
		return qtrue;

	default:
		return qfalse;
	}
}

static void G_MonsterSetOrigin(
	gentity_t *monster,
	const vec3_t origin
) {
	G_SetOrigin(monster, (float *)origin);

	/*
	 * The client interpolates monsters between snapshots.
	 * G_SetOrigin resets trType to TR_STATIONARY.
	 */
	monster->s.pos.trType = TR_INTERPOLATE;
	monster->s.pos.trTime = level.time;
}

static qboolean G_MonsterSpawnAtOrigin(
	gentity_t *item,
	monsterDef_t *def,
	vec3_t spawnOrigin,
	qboolean waveSpawn
) {
	gentity_t *monster;
	vec3_t origin;

	if( waveSpawn ) {
		if( monsterActiveCount >=
			monsterWaveMaxActive ) {
			return qfalse;
		}
	}
	else if( monsterActiveCount >= 8 ) {
		return qfalse;
	}

	if( !def ) {
		return qfalse;
	}

	monster = G_Spawn();

	monster->classname = "monster";
	monster->s.eType = ET_MONSTER;

	if( def->models[0][0] ) {
		monster->s.modelindex =
			G_ModelIndex(def->models[0]);
	}

	if( def->models[1][0] ) {
		monster->s.modelindex2 =
			G_ModelIndex(def->models[1]);
	}

	if( def->models[2][0] ) {
		monster->s.otherEntityNum =
			G_ModelIndex(def->models[2]);
	}

	if( def->models[3][0] ) {
		monster->s.otherEntityNum2 =
			G_ModelIndex(def->models[3]);
	}

	monster->s.frame =
		def->moveAnimation.firstFrame;

	monster->s.groundEntityNum =
		ENTITYNUM_NONE;

	monster->s.apos.trType =
		TR_STATIONARY;

	monster->monsterType =
		def->monsterType;

	monster->monsterSlot =
		def->monsterSlot;
		
	/*
	 * Send monster definition identity to cgame.
	 * Packed into a single byte: type * MAX_MONSTERS_PER_TYPE + slot.
	 * (entityState generic1 is only 8 bits on the network.)
	 */
	monster->s.generic1 =
		def->monsterType * MAX_MONSTERS_PER_TYPE +
		def->monsterSlot;	

	monster->monsterItem = item;
	monster->monsterWaveSpawn = waveSpawn;
	monster->monsterDead = qfalse;

	monster->health = def->health;
	monster->takedamage = qtrue;
	monster->pain = G_MonsterPain;
	monster->die = G_MonsterDie;

	monster->monsterNextAttack =
		level.time + 500;

	monster->monsterNextShot = 0;
	monster->monsterShotsRemaining = 0;

	G_MonsterSetAnimation(
		monster,
		MONSTER_STATE_IDLE,
		0
	);

	monster->monsterNextTalk =
		level.time +
		G_MonsterTalkDelay(def);

	VectorCopy(
		def->mins,
		monster->r.mins
	);

	VectorCopy(
		def->maxs,
		monster->r.maxs
	);

	monster->r.contents = CONTENTS_BODY;
	monster->clipmask = MASK_PLAYERSOLID;

	VectorCopy(spawnOrigin, origin);
	origin[2] += def->hoverHeight;

	G_MonsterSetOrigin(
		monster,
		origin
	);
	
	monster->monsterProgressTime =
	level.time;

	VectorCopy(
		monster->r.currentOrigin,
		monster->monsterProgressOrigin
	);

	monster->monsterLastThink =
		level.time;

	monster->monsterDriftPhase =
		monster->s.number * 0.73f;

	monster->think = G_MonsterThink;
	monster->nextthink = level.time + 50;

	trap_LinkEntity(monster);

	/*
	 * Classic Monster Hunt replaces and hides a map item.
	 * Wave monsters are independent from map items.
	 */
	if( item && !waveSpawn ) {
		item->monsterType =
			def->monsterType;

		item->monsterSlot =
			def->monsterSlot;

		item->s.eFlags |= EF_NODRAW;
		item->r.svFlags |= SVF_NOCLIENT;
		item->r.contents = 0;
		item->touch = 0;
		item->think = 0;
		item->nextthink = 0;

		trap_UnlinkEntity(item);
	}

	monsterActiveCount++;

/*	G_Printf(
		"Spawned %smonster %s at %s\n",
		waveSpawn ? "wave " : "",
		def->name,
		vtos(origin)
	);*/

	return qtrue;
}

static qboolean G_MonsterSpawnFromItem(
	gentity_t *item,
	monsterDef_t *def
) {
	if( !item || !def ) {
		return qfalse;
	}

	return G_MonsterSpawnAtOrigin(
		item,
		def,
		item->s.pos.trBase,
		qfalse
	);
}

static void G_MonsterRespawnThink(gentity_t *item) {
	monsterDef_t *def;

	if (item->monsterType <= MONSTER_TYPE_OFF ||
		item->monsterType >= MONSTER_TYPE_RANDOM ||
		item->monsterSlot < 0 ||
		item->monsterSlot >= MAX_MONSTERS_PER_TYPE) {
		item->think = 0;
		item->nextthink = 0;
		return;
	}

	if (!g_monsterDefLoaded
		[item->monsterType]
		[item->monsterSlot]) {
		item->think = 0;
		item->nextthink = 0;
		return;
	}

	if (monsterActiveCount >= 8) {
		item->nextthink = level.time + 1000;
		return;
	}

	def = &g_monsterDefs
		[item->monsterType]
		[item->monsterSlot];

	if (!G_MonsterSpawnFromItem(item, def)) {
		item->nextthink = level.time + 1000;
	}
}

static qboolean G_MonsterWaveHasPlayers( void ) {
	gclient_t *client;
	int i;

	for( i = 0; i < level.maxclients; i++ ) {
		client = &level.clients[i];

		if( client->pers.connected !=
			CON_CONNECTED ) {
			continue;
		}

		if( client->sess.sessionTeam ==
			TEAM_SPECTATOR ) {
			continue;
		}

		if( client->oneLifeEliminated ) {
			continue;
		}

		if( client->ps.stats[STAT_HEALTH] <= 0 ) {
			continue;
		}

		return qtrue;
	}

	return qfalse;
}

static int G_MonsterWaveLivingCount( void ) {
	gentity_t *ent;
	int count;
	int i;

	count = 0;

	for( i = MAX_CLIENTS;
		i < level.num_entities;
		i++ ) {
		ent = &g_entities[i];

		if( !ent->inuse ) {
			continue;
		}

		if( ent->s.eType != ET_MONSTER ) {
			continue;
		}

		if( !ent->monsterWaveSpawn ) {
			continue;
		}

		if( ent->monsterDead ) {
			continue;
		}

		count++;
	}

	return count;
}

static qboolean G_MonsterWaveSpotSafe(
	gentity_t *spot,
	monsterDef_t *def,
	qboolean requireDistance
) {
	gentity_t *player;
	trace_t trace;
	vec3_t origin;
	int i;

	if( !spot || !def ) {
		return qfalse;
	}

	if( SpotWouldTelefrag(spot) ) {
		return qfalse;
	}

	VectorCopy(spot->s.origin, origin);
	origin[2] += 9 + def->hoverHeight;

	trap_Trace(
		&trace,
		origin,
		def->mins,
		def->maxs,
		origin,
		ENTITYNUM_NONE,
		MASK_PLAYERSOLID
	);

	if( trace.startsolid || trace.allsolid ) {
		return qfalse;
	}

	if( !requireDistance ) {
		return qtrue;
	}

	for( i = 0; i < level.maxclients; i++ ) {
		player = &g_entities[i];

		if( !player->client ) {
			continue;
		}

		if( player->client->pers.connected !=
			CON_CONNECTED ) {
			continue;
		}

		if( player->client->sess.sessionTeam ==
			TEAM_SPECTATOR ) {
			continue;
		}

		if( player->health <= 0 ) {
			continue;
		}

		if( DistanceSquared(
			spot->s.origin,
			player->r.currentOrigin
		) < 256.0f * 256.0f ) {
			return qfalse;
		}
	}

	return qtrue;
}

static qboolean G_MonsterWaveChooseSpawn(
	monsterDef_t *def,
	vec3_t origin
) {
	gentity_t *spots[128];
	gentity_t *spot;
	int count;
	int pass;

	for( pass = 0; pass < 2; pass++ ) {
		count = 0;
		spot = NULL;

		while( (spot = G_Find(
			spot,
			FOFS(classname),
			"info_player_deathmatch"
		)) != NULL ) {
			if( !G_MonsterWaveSpotSafe(
				spot,
				def,
				pass == 0
			) ) {
				continue;
			}

			spots[count++] = spot;

			if( count >= 128 ) {
				break;
			}
		}

		if( count > 0 ) {
			spot = spots[rand() % count];

			VectorCopy(
				spot->s.origin,
				origin
			);

			origin[2] += 9;
			return qtrue;
		}
	}

	return qfalse;
}

static void G_MonsterWaveBegin( void ) {
	monsterWaveActive = qtrue;
	monsterWaveCombatStarted = qtrue;
	monsterWaveEntry = 0;
	monsterWaveEntrySpawned = 0;
	monsterWaveNextSpawn = level.time;
	monsterWaveLastProgress = level.time;

	trap_SendServerCommand(
		-1,
		va(
			"cp \"Wave %i\n\"",
			monsterCurrentWave
		)
	);

	trap_SendServerCommand(
		-1,
		va(
			"print \"Monster Hunt: wave %i started.\n\"",
			monsterCurrentWave
		)
	);

	G_Printf(
		"Monster Hunt: wave %i started.\n",
		monsterCurrentWave
	);
}

static void G_MonsterWaveComplete( void ) {
	trap_SendServerCommand(
		-1,
		va(
			"print \"Monster Hunt: wave %i cleared.\n\"",
			monsterCurrentWave
		)
	);

	monsterWaveActive = qfalse;

	if( monsterCurrentWave <
		monsterWaveFinal ) {
		monsterCurrentWave++;

		monsterWaveNextStart =
			level.time +
			monsterWaveDelay;

		return;
	}

	/*
	 * Classic Monster Hunt repeats the final wave until
	 * fraglimit or timelimit ends the match.
	 */
	if( g_monsterHunt.integer ==
		MONSTER_HUNT_CLASSIC ) {
		monsterWaveNextStart =
			level.time +
			monsterWaveDelay;

		trap_SendServerCommand(
			-1,
			"print \"Monster Hunt: final wave restarting.\n\""
		);

		return;
	}

	/*
	 * One Life ends after clearing the final wave.
	 */
	monsterWaveFinished = qtrue;

	trap_SendServerCommand(
		-1,
		"cp \"Monster Hunt completed!\n\""
	);

	trap_SendServerCommand(
		-1,
		"print \"Monster Hunt: all waves cleared.\n\""
	);

	LogExit(
		"Monster Hunt completed."
	);
}

static int G_MonsterWaveRelocateStuck( void ) {
	gentity_t *monster;
	monsterDef_t *def;
	vec3_t origin;
	int relocated;
	int i;

	relocated = 0;

	for( i = MAX_CLIENTS;
		i < level.num_entities;
		i++ ) {
		monster = &g_entities[i];

		if( !monster->inuse ) {
			continue;
		}

		if( monster->s.eType != ET_MONSTER ) {
			continue;
		}

		if( !monster->monsterWaveSpawn ||
			monster->monsterDead ) {
			continue;
		}

		/*
		 * Relocate only monsters that have neither moved,
		 * fired nor received damage for the timeout period.
		 */
		if( level.time -
			monster->monsterProgressTime <
			monsterWaveTimeout ) {
			continue;
		}

		def = &g_monsterDefs
			[monster->monsterType]
			[monster->monsterSlot];

		if( !G_MonsterWaveChooseSpawn(
			def,
			origin
		) ) {
			continue;
		}

		/*
		 * ChooseSpawn returns the base position.
		 * Apply the monster's configured hovering height.
		 */
		origin[2] += def->hoverHeight;

		G_MonsterSetOrigin(
			monster,
			origin
		);

		monster->monsterProgressTime =
			level.time;

		VectorCopy(
			monster->r.currentOrigin,
			monster->monsterProgressOrigin
		);

		monster->enemy = NULL;
		monster->monsterShotsRemaining = 0;
		monster->monsterNextAttack =
			level.time + 500;
		monster->monsterLastThink =
			level.time;

		G_MonsterSetAnimation(
			monster,
			MONSTER_STATE_MOVE,
			0
		);

		trap_LinkEntity(monster);
		relocated++;
	}

	return relocated;
}

void G_MonsterRunFrame( void ) {
	monsterWaveDef_t *wave;
	monsterWaveEntry_t *entry;
	monsterDef_t *def;
	vec3_t origin;
	int living;

	if( g_monsterHunt.integer ==
		MONSTER_HUNT_OFF ) {
		return;
	}

	if( !monsterWavesLoaded ||
		monsterWaveFinished ) {
		return;
	}

	if( level.intermissiontime ||
		level.intermissionQueued ||
		level.warmupTime ) {
		return;
	}

	if( !G_MonsterWaveHasPlayers() ) {
		return;
	}

	if( !monsterWaveStarted ) {
		monsterWaveStarted = qtrue;
		monsterCurrentWave = 1;
		monsterWaveNextStart =
			level.time + monsterWaveDelay;

		trap_SendServerCommand(
			-1,
			"print \"Monster Hunt begins.\n\""
		);

		return;
	}

	if( !monsterWaveActive ) {
		if( level.time >= monsterWaveNextStart ) {
			G_MonsterWaveBegin();
		}

		return;
	}

	wave =
		&monsterWaves[monsterCurrentWave - 1];

	while( monsterWaveEntry <
		wave->numEntries ) {
		entry =
			&wave->entries[monsterWaveEntry];

		if( monsterWaveEntrySpawned <
			entry->count ) {
			break;
		}

		monsterWaveEntry++;
		monsterWaveEntrySpawned = 0;
	}

	living = G_MonsterWaveLivingCount();

	/*
	 * Every configured monster has been spawned.
	 * Complete the wave after the last living monster dies.
	 */
	if( monsterWaveEntry >=
		wave->numEntries ) {
		if( living == 0 ) {
			G_MonsterWaveComplete();
			return;
		}

		if( level.time - monsterWaveLastProgress >=
			monsterWaveTimeout ) {
			int relocated;

			relocated =
				G_MonsterWaveRelocateStuck();

			monsterWaveLastProgress = level.time;

			/*trap_SendServerCommand(
				-1,
				va(
					"print \"Monster Hunt: relocated %i lost monsters.\n\"",
					relocated
				)
			);

			G_Printf(
				"Monster Hunt: wave %i still has %i living monsters; relocated %i.\n",
				monsterCurrentWave,
				living,
				relocated
			);*/
		}

		return;
	}

	if( living >= monsterWaveMaxActive ) {
		return;
	}

	if( level.time < monsterWaveNextSpawn ) {
		return;
	}

	entry = &wave->entries[monsterWaveEntry];

	def = &g_monsterDefs
		[entry->monsterType]
		[entry->monsterSlot];

	if( !G_MonsterWaveChooseSpawn(
		def,
		origin
	) ) {
		monsterWaveNextSpawn =
			level.time + 1000;
		return;
	}

	if( G_MonsterSpawnAtOrigin(
		NULL,
		def,
		origin,
		qtrue
	) ) {
	monsterWaveEntrySpawned++;
	monsterWaveLastProgress = level.time;

	monsterWaveNextSpawn =
		level.time +
			monsterWaveSpawnInterval;
	}
	else {
		monsterWaveNextSpawn =
			level.time + 500;
	}
}

qboolean G_MonsterTryReplaceItem(
	gentity_t *item
) {
	/*
	 * Both Monster Hunt modes now receive monsters
	 * exclusively from the wave controller.
	 */
	return qfalse;
}

static gentity_t *G_MonsterFindTarget(gentity_t *monster) {
	gentity_t *player;
	gentity_t *best;
	float bestDistance;
	int i;

	best = NULL;
	bestDistance = 99999999.0f;

	for (i = 0; i < level.maxclients; i++) {
		float distance;

		player = &g_entities[i];

		if (!player->client) {
			continue;
		}

		if (player->client->pers.connected != CON_CONNECTED) {
			continue;
		}

		if (player->client->sess.sessionTeam == TEAM_SPECTATOR) {
			continue;
		}

		if (player->health <= 0) {
			continue;
		}

		distance = DistanceSquared(
			monster->r.currentOrigin,
			player->r.currentOrigin
		);

		if (distance < bestDistance) {
			bestDistance = distance;
			best = player;
		}
	}

	return best;
}

static animation_t *G_MonsterAnimation(
	gentity_t *monster,
	monsterDef_t *def
) {
	int variant;

	variant = monster->monsterAnimationVariant;

	if (variant < 0 || variant >= MAX_MONSTER_VARIANTS) {
		variant = 0;
	}

	switch (monster->monsterAnimation) {
	case MONSTER_STATE_IDLE:
		return &def->idleAnimation;

	case MONSTER_STATE_MOVE:
		return &def->moveAnimation;

	case MONSTER_STATE_MELEE:
		return &def->meleeAnimations[variant];

	case MONSTER_STATE_RANGED:
		return &def->rangedAnimations[variant];

	case MONSTER_STATE_PAIN:
		return &def->painAnimations[variant];

	case MONSTER_STATE_DEATH:
		return &def->deathAnimations[variant];

	default:
		return &def->idleAnimation;
	}
}

static void G_MonsterSetAnimation(
	gentity_t *monster,
	int animation,
	int variant
) {
	monster->monsterAnimation = animation;
	monster->monsterAnimationVariant = variant;
	monster->monsterAnimationStart = level.time;
}

static void G_MonsterUpdateAnimation(
	gentity_t *monster,
	monsterDef_t *def
) {
	animation_t *animation;
	int elapsed;
	int frame;

	animation = G_MonsterAnimation(monster, def);

	if (animation->numFrames <= 0 ||
		animation->frameLerp <= 0) {
		return;
	}

	elapsed = level.time - monster->monsterAnimationStart;
	frame = elapsed / animation->frameLerp;

	if (frame >= animation->numFrames) {
		if (animation->loopFrames > 0) {
			frame =
				animation->numFrames -
				animation->loopFrames +
				(frame - animation->numFrames) %
				animation->loopFrames;
		}
		else {
			frame = animation->numFrames - 1;

		if( monster->monsterAnimation ==
				MONSTER_STATE_PAIN ||
			((monster->monsterAnimation ==
					MONSTER_STATE_RANGED ||
			  monster->monsterAnimation ==
					MONSTER_STATE_MELEE) &&
			 monster->monsterShotsRemaining <= 0) ) {
				G_MonsterSetAnimation(
					monster,
					MONSTER_STATE_IDLE,
					0
				);

				animation = &def->idleAnimation;
				frame = 0;
			}
		}
	}

	monster->s.frame =
		animation->firstFrame + frame;
}

static void G_MonsterGroundWalker(
	gentity_t *monster,
	monsterDef_t *def,
	int msec
) {
	trace_t trace;
	vec3_t destination;
	float fallDistance;

	if( def->movementType !=
		MONSTER_MOVEMENT_WALKING ) {
		return;
	}

	VectorCopy(
		monster->r.currentOrigin,
		destination
	);

	destination[2] -= 64;

	trap_Trace(
		&trace,
		monster->r.currentOrigin,
		monster->r.mins,
		monster->r.maxs,
		destination,
		monster->s.number,
		MASK_PLAYERSOLID
	);

	if( !trace.startsolid &&
		!trace.allsolid &&
		trace.fraction < 1.0f ) {
		G_MonsterSetOrigin(
			monster,
			trace.endpos
		);

		monster->s.groundEntityNum =
			trace.entityNum;

		return;
	}

	/*
	 * No nearby floor: apply simple falling movement.
	 */
	fallDistance =
		400.0f * msec / 1000.0f;

	VectorCopy(
		monster->r.currentOrigin,
		destination
	);

	destination[2] -= fallDistance;

	trap_Trace(
		&trace,
		monster->r.currentOrigin,
		monster->r.mins,
		monster->r.maxs,
		destination,
		monster->s.number,
		MASK_PLAYERSOLID
	);

	if( !trace.startsolid &&
		!trace.allsolid ) {
		G_MonsterSetOrigin(
			monster,
			trace.endpos
		);
	}

	if( trace.fraction < 1.0f ) {
		monster->s.groundEntityNum =
			trace.entityNum;
	}
	else {
		monster->s.groundEntityNum =
			ENTITYNUM_NONE;
	}
}

static void G_MonsterFaceTarget(
	gentity_t *monster,
	gentity_t *target
) {
	vec3_t direction;
	vec3_t angles;

	if( !monster || !target ) {
		return;
	}

	VectorSubtract(
		target->r.currentOrigin,
		monster->r.currentOrigin,
		direction
	);

	if( VectorNormalize(direction) <= 0.0f ) {
		return;
	}

	vectoangles(direction, angles);
	angles[PITCH] = 0;
	angles[ROLL] = 0;

	VectorCopy(angles, monster->s.angles);
	VectorCopy(angles, monster->s.apos.trBase);
	VectorCopy(angles, monster->r.currentAngles);
}


static void G_MonsterMove(
	gentity_t *monster,
	gentity_t *target,
	monsterDef_t *def,
	int msec
) {
	trace_t trace;
	trace_t slideTrace;
	vec3_t targetOrigin;
	vec3_t direction;
	vec3_t right;
	vec3_t wishDirection;
	vec3_t velocity;
	vec3_t move;
	vec3_t destination;
	vec3_t slideMove;
	vec3_t slideDestination;
	vec3_t angles;
	float phase;
	float drift;
	float distance;
	float dot;
	qboolean shouldMove;

	VectorCopy(
		target->r.currentOrigin,
		targetOrigin
	);

	if( def->movementType ==
		MONSTER_MOVEMENT_WALKING ) {
		/*
		 * Walking monsters chase only horizontally.
		 */
		targetOrigin[2] =
			monster->r.currentOrigin[2];
	}
	else {
		targetOrigin[2] += 16;
	}

	VectorSubtract(
		targetOrigin,
		monster->r.currentOrigin,
		direction
	);

	distance = VectorNormalize(direction);

	if (distance <= 0.0f) {
		return;
	}
	/*
	 * A nearby target behind a wall is not yet a valid
	 * firing position, so continue moving toward it.
	 */
	shouldMove =
		distance > def->attackRange ||
		!G_MonsterCanSeeTarget(
			monster,
			target
		);
	
	/*
	 * Switch between standing and movement animations
	 * without interrupting attacks, pain or death.
	 */
	if( monster->monsterAnimation ==
			MONSTER_STATE_IDLE ||
		monster->monsterAnimation ==
			MONSTER_STATE_MOVE ) {
		if( shouldMove ||
			def->movePattern ==
				MONSTER_PATTERN_DRIFT ) {
			if( monster->monsterAnimation !=
				MONSTER_STATE_MOVE ) {
				G_MonsterSetAnimation(
					monster,
					MONSTER_STATE_MOVE,
					0
				);
			}
		}
		else if( monster->monsterAnimation !=
			MONSTER_STATE_IDLE ) {
			G_MonsterSetAnimation(
				monster,
				MONSTER_STATE_IDLE,
				0
			);
		}
	}

	VectorSet(
		right,
		-direction[1],
		direction[0],
		0
	);

	if (VectorNormalize(right) <= 0.0f) {
		VectorSet(right, 1, 0, 0);
	}

	drift = 0.0f;

	if (def->movePattern == MONSTER_PATTERN_DRIFT &&
		def->driftPeriod > 0) {
		phase =
			(level.time % def->driftPeriod) /
			(float)def->driftPeriod;

		phase *= 6.2831853f;
		phase += monster->monsterDriftPhase;

		drift =
			sin(phase) *
			def->driftAmount;
	}

	VectorClear(velocity);

	if (shouldMove) {
		VectorCopy(direction, wishDirection);

		if (def->movePattern ==
			MONSTER_PATTERN_DRIFT) {
			VectorMA(
				wishDirection,
				drift,
				right,
				wishDirection
			);
		}

		if (VectorNormalize(wishDirection) <= 0.0f) {
			return;
		}

		VectorScale(
			wishDirection,
			def->speed,
			velocity
		);
	}
	else if (def->movePattern ==
		MONSTER_PATTERN_DRIFT) {
		/*
		 * Inside attack range, smoothly strafe.
		 * Do not normalize this vector: driftAmount must
		 * affect the actual lateral speed.
		 */
		VectorScale(
			right,
			drift * def->speed,
			velocity
		);
	}
	else {
		return;
	}

	VectorScale(
		velocity,
		msec / 1000.0f,
		move
	);

	if (VectorLengthSquared(move) <= 0.0001f) {
		return;
	}

VectorAdd(
		monster->r.currentOrigin,
		move,
		destination
	);

	trap_Trace(
		&trace,
		monster->r.currentOrigin,
		monster->r.mins,
		monster->r.maxs,
		destination,
		monster->s.number,
		MASK_PLAYERSOLID
	);

	/*
	 * Step-up: if horizontal move was blocked,
	 * try to climb a stair. Q3 player step size
	 * is 18 units; use the same for monsters.
	 */
	if( trace.fraction < 1.0f &&
		!trace.startsolid &&
		!trace.allsolid ) {
		vec3_t stepUp;
		vec3_t stepDest;
		vec3_t downDest;
		trace_t stepTrace;
		trace_t downTrace;
		const float stepHeight = 18.0f;

		VectorCopy(
			monster->r.currentOrigin,
			stepUp
		);

		stepUp[2] += stepHeight;

		trap_Trace(
			&stepTrace,
			monster->r.currentOrigin,
			monster->r.mins,
			monster->r.maxs,
			stepUp,
			monster->s.number,
			MASK_PLAYERSOLID
		);

		if( !stepTrace.startsolid &&
			!stepTrace.allsolid &&
			stepTrace.fraction > 0.9f ) {

			VectorCopy(
				destination,
				stepDest
			);

			stepDest[2] = stepUp[2];

			trap_Trace(
				&stepTrace,
				stepUp,
				monster->r.mins,
				monster->r.maxs,
				stepDest,
				monster->s.number,
				MASK_PLAYERSOLID
			);

			if( !stepTrace.startsolid &&
				!stepTrace.allsolid ) {

				VectorCopy(
					stepTrace.endpos,
					downDest
				);

				downDest[2] -= stepHeight;

				trap_Trace(
					&downTrace,
					stepTrace.endpos,
					monster->r.mins,
					monster->r.maxs,
					downDest,
					monster->s.number,
					MASK_PLAYERSOLID
				);

				if( !downTrace.startsolid &&
					!downTrace.allsolid &&
					downTrace.fraction < 1.0f ) {

					G_MonsterSetOrigin(
						monster,
						downTrace.endpos
					);

					monster->s.groundEntityNum =
						downTrace.entityNum;

					vectoangles(
						direction,
						angles
					);

					angles[PITCH] = 0;
					angles[ROLL] = 0;

					VectorCopy(
						angles,
						monster->s.angles
					);

					VectorCopy(
						angles,
						monster->s.apos.trBase
					);

					VectorCopy(
						angles,
						monster->r.currentAngles
					);

					trap_LinkEntity(monster);

					return;
				}
			}
		}
	}

	G_MonsterSetOrigin(monster, trace.endpos);

	if (trace.fraction < 1.0f &&
		!trace.startsolid &&
		!trace.allsolid) {
		/* slide logic ... (без изменений) */
	}

	if (trace.fraction < 1.0f &&
		!trace.startsolid &&
		!trace.allsolid) {
		/*
		 * Slide only for the uncompleted part of movement.
		 */
		VectorScale(
			move,
			1.0f - trace.fraction,
			slideMove
		);

		dot = DotProduct(
			slideMove,
			trace.plane.normal
		);

		VectorMA(
			slideMove,
			-dot,
			trace.plane.normal,
			slideMove
		);

		if (VectorLengthSquared(slideMove) > 0.0001f) {
			VectorAdd(
				monster->r.currentOrigin,
				slideMove,
				slideDestination
			);

			trap_Trace(
				&slideTrace,
				monster->r.currentOrigin,
				monster->r.mins,
				monster->r.maxs,
				slideDestination,
				monster->s.number,
				MASK_PLAYERSOLID
			);

			G_MonsterSetOrigin(
				monster,
				slideTrace.endpos
			);
		}
	}

	vectoangles(direction, angles);
	angles[PITCH] = 0;
	angles[ROLL] = 0;

	VectorCopy(angles, monster->s.angles);
	VectorCopy(angles, monster->s.apos.trBase);
	VectorCopy(angles, monster->r.currentAngles);

	trap_LinkEntity(monster);
}

static qboolean G_MonsterValidTarget(gentity_t *target) {
	if (!target || !target->client) {
		return qfalse;
	}

	if (target->client->pers.connected != CON_CONNECTED) {
		return qfalse;
	}

	if (target->client->sess.sessionTeam == TEAM_SPECTATOR) {
		return qfalse;
	}

	if (target->health <= 0) {
		return qfalse;
	}

	return qtrue;
}

/*
 * Hitscan-based monster attack with tracer.
 * weaponType:
 *   "hitscan"  - machinegun-like, 1 pellet, small spread
 *   "rifle"    - accurate rifle, 1 pellet, no spread
 *   "shotgun"  - shotgun, multiple pellets, wide spread
 *
 * damage is per pellet (for shotgun, total = damage * pellets).
 */
static void G_MonsterHitscan(
	gentity_t *monster,
	gentity_t *target,
	monsterDef_t *def,
	const char *weaponType,
	int damage,
	int splashDamage,
	int splashRadius
) {
	vec3_t start;
	vec3_t forward;
	vec3_t right;
	vec3_t up;
	int pellets;
	float spread;
	int mod;
	int i;

	VectorCopy( monster->r.currentOrigin, start );

	if( def->movementType == MONSTER_MOVEMENT_WALKING ) {
		start[2] += 36;
	}
	else {
		start[2] += 8;
	}

	VectorSubtract(
		target->r.currentOrigin,
		start,
		forward
	);

	VectorNormalize( forward );

	PerpendicularVector( right, forward );
	CrossProduct( forward, right, up );

	if( !Q_stricmp( weaponType, "shotgun" ) ) {
		pellets = 11;
		spread = 0.15f;
		mod = MOD_SHOTGUN;
	}
	else if( !Q_stricmp( weaponType, "rifle" ) ) {
		pellets = 1;
		spread = 0.0f;
		mod = MOD_MACHINEGUN;
	}
	else if( !Q_stricmp( weaponType, "lightning" ) ) {
		pellets = 1;
		spread = 0.0f;
		mod = MOD_LIGHTNING;
	}
	else if( !Q_stricmp( weaponType, "blaster" ) ) {
		/*
		 * Enemy blaster: hitscan like machinegun, but
		 * a red Star Wars tracer is drawn on the client.
		 * MOD_BLASTER doesn't exist, use MOD_MACHINEGUN.
		 */
		pellets = 1;
		spread = 0.02f;
		mod = MOD_MACHINEGUN;
	}
	else {
		/* "hitscan" / machinegun */
		pellets = 1;
		spread = 0.02f;
		mod = MOD_MACHINEGUN;
	}

	for( i = 0; i < pellets; i++ ) {
		vec3_t dir;
		vec3_t end;
		trace_t trace;

		VectorCopy( forward, dir );

		if( spread > 0.0f ) {
			VectorMA( dir, crandom() * spread, right, dir );
			VectorMA( dir, crandom() * spread, up, dir );
			VectorNormalize( dir );
		}

		//VectorMA( start, 8192.0f, dir, end );
		if( !Q_stricmp( weaponType, "lightning" ) ) {
			VectorMA( start, 768.0f, dir, end );
		}
		else {
			VectorMA( start, 8192.0f, dir, end );
		}

		trap_Trace(
			&trace,
			start,
			NULL,
			NULL,
			end,
			monster->s.number,
			MASK_SHOT
		);
		
		/*
		 * Enemy blaster tracer: spawn a temp entity
		 * that the client draws as a red Star Wars bolt.
		 * origin2 = muzzle (start), pos.trBase = impact (trace.endpos).
		 */
		if( !Q_stricmp( weaponType, "blaster" ) ) {
			gentity_t *tent;
			vec3_t snappedEnd;

			VectorCopy( trace.endpos, snappedEnd );
			SnapVector( snappedEnd );

			tent = G_TempEntity( snappedEnd, EV_ENEMY_BLASTER_TRACER );
			VectorCopy( start, tent->s.origin2 );
			tent->s.eventParm = DirToByte( trace.plane.normal );
		}

		/* Damage only if we actually hit a player. */
		if( trace.fraction < 1.0f &&
			trace.entityNum < MAX_CLIENTS ) {
			gentity_t *hit = &g_entities[trace.entityNum];

			if( hit->client && hit->health > 0 ) {
				G_Damage(
					hit,
					monster,
					monster,
					NULL,
					trace.endpos,
					damage,
					0,
					mod
				);
			}
		}

		/* Splash (usually 0 for hitscan; keep for flexibility). */
		if( splashDamage > 0 && splashRadius > 0 ) {
			G_RadiusDamage(
				trace.endpos,
				monster,
				splashDamage,
				splashRadius,
				monster,
				mod
			);
		}
	}

	/* Mark progress for wave relocation. */
	if( monster->monsterWaveSpawn ) {
		monster->monsterProgressTime = level.time;

		VectorCopy(
			monster->r.currentOrigin,
			monster->monsterProgressOrigin
		);
	}
}

static void G_MonsterFireProjectile(
	gentity_t *monster,
	gentity_t *target,
	monsterDef_t *def,
	const char *projectile,
	int damage,
	int splashDamage,
	int splashRadius
) {
	gentity_t *bolt;
	vec3_t start;
	vec3_t targetOrigin;
	vec3_t direction;

	/*
	 * Hitscan branch: instant hit with tracer.
	 * projectile can be "hitscan", "rifle" or "shotgun".
	 */
	if( projectile &&
		( !Q_stricmp(projectile, "hitscan") ||
		  !Q_stricmp(projectile, "rifle") ||
		  !Q_stricmp(projectile, "shotgun") ||
		  !Q_stricmp(projectile, "lightning") ||
		  !Q_stricmp(projectile, "blaster") ) ) {
		G_MonsterHitscan(
			monster,
			target,
			def,
			projectile,
			damage,
			splashDamage,
			splashRadius
		);

		return;
	}

	VectorCopy(
		monster->r.currentOrigin,
		start
	);

	if( def->movementType ==
		MONSTER_MOVEMENT_WALKING ) {
		start[2] += 36;
	}
	else {
		start[2] += 8;
	}

	VectorCopy(
		target->r.currentOrigin,
		targetOrigin
	);

	targetOrigin[2] +=
		DEFAULT_VIEWHEIGHT * 0.5f;

	VectorSubtract(
		targetOrigin,
		start,
		direction
	);

	VectorNormalize(direction);

	VectorMA(
		start,
		24,
		direction,
		start
	);

	if( projectile &&
		!Q_stricmp(projectile, "rocket") ) {
		bolt = fire_rocket(
			monster,
			start,
			direction
		);
	}
	else if( projectile &&
		!Q_stricmp(projectile, "grenade") ) {
		/*
		 * Ballistic arc: add elevation so the grenade
		 * reaches a ground target instead of hitting
		 * the floor immediately.
		 * fire_grenade itself sets trType = TR_GRAVITY.
		 */
		direction[2] += 0.35f;
		VectorNormalize( direction );

		bolt = fire_grenade(
			monster,
			start,
			direction
		);
	}
	else {
		bolt = fire_plasma(
			monster,
			start,
			direction
		);
	}

	bolt->damage = damage;
	bolt->splashDamage = splashDamage;
	bolt->splashRadius = splashRadius;

	VectorScale(
		direction,
		def->projectileSpeed,
		bolt->s.pos.trDelta
	);

	SnapVector(bolt->s.pos.trDelta);

	if( monster->monsterWaveSpawn ) {
		monster->monsterProgressTime =
			level.time;

		VectorCopy(
			monster->r.currentOrigin,
			monster->monsterProgressOrigin
		);
	}
}

static void G_MonsterStartRangedAttack(
	gentity_t *monster,
	gentity_t *target,
	monsterDef_t *def
) {
	animation_t *animation;
	int variant;
	int fireFrame;
	int windup;
	vec3_t direction;
	vec3_t angles;

	variant = rand() % MAX_MONSTER_VARIANTS;
	animation = &def->rangedAnimations[variant];

	fireFrame = def->attackFireFrame;

	if (fireFrame < 0) {
		fireFrame = 0;
	}

	if (animation->numFrames > 0 &&
		fireFrame >= animation->numFrames) {
		fireFrame = animation->numFrames - 1;
	}

	windup = fireFrame * animation->frameLerp;

	/*
	 * Face the target when the attack animation begins.
	 */
	VectorSubtract(
		target->r.currentOrigin,
		monster->r.currentOrigin,
		direction
	);

	if( VectorNormalize(direction) > 0.0f ) {
		vectoangles(direction, angles);

		angles[PITCH] = 0;
		angles[ROLL] = 0;

		VectorCopy(
			angles,
			monster->s.angles
		);

		VectorCopy(
			angles,
			monster->s.apos.trBase
		);

		VectorCopy(
			angles,
			monster->r.currentAngles
		);
	}

	monster->enemy = target;
	monster->monsterShotsRemaining = def->burstCount;
	monster->monsterNextShot = level.time + windup;

	G_MonsterSetAnimation(
		monster,
		MONSTER_STATE_RANGED,
		variant
	);
}

static void G_MonsterStartMeleeAttack(
	gentity_t *monster,
	gentity_t *target,
	monsterDef_t *def
) {
	animation_t *animation;
	int variant;
	int fireFrame;
	int windup;

	variant =
		rand() % MAX_MONSTER_VARIANTS;

	animation =
		&def->meleeAnimations[variant];

	fireFrame = def->meleeFireFrame;

	if( fireFrame < 0 ) {
		fireFrame = 0;
	}

	if( animation->numFrames > 0 &&
		fireFrame >= animation->numFrames ) {
		fireFrame =
			animation->numFrames - 1;
	}

	windup =
		fireFrame *
		animation->frameLerp;

	monster->enemy = target;
	monster->monsterShotsRemaining = 1;
	monster->monsterNextShot =
		level.time + windup;

	G_MonsterSetAnimation(
		monster,
		MONSTER_STATE_MELEE,
		variant
	);
}

static qboolean G_MonsterCanSeeTarget(
	gentity_t *monster,
	gentity_t *target
) {
	trace_t trace;
	vec3_t start;
	vec3_t end;

	if (!G_MonsterValidTarget(target)) {
		return qfalse;
	}

	VectorCopy(monster->r.currentOrigin, start);
	start[2] += 8;

	VectorCopy(target->r.currentOrigin, end);
	end[2] += DEFAULT_VIEWHEIGHT * 0.5f;

	trap_Trace(
		&trace,
		start,
		NULL,
		NULL,
		end,
		monster->s.number,
		MASK_SHOT
	);

	return trace.fraction == 1.0f ||
		trace.entityNum == target->s.number;
}

static void G_MonsterRunAttack(
	gentity_t *monster,
	monsterDef_t *def
) {
	qboolean meleeAttack;

	if( monster->monsterShotsRemaining <= 0 ) {
		return;
	}

	if( !G_MonsterValidTarget(monster->enemy) ||
		!G_MonsterCanSeeTarget(
			monster,
			monster->enemy
		) ) {
		monster->monsterShotsRemaining = 0;

		monster->monsterNextAttack =
			level.time +
			def->attackCooldown;

		return;
	}

	if( level.time <
		monster->monsterNextShot ) {
		return;
	}

	meleeAttack =
		monster->monsterAnimation ==
		MONSTER_STATE_MELEE;

	if( meleeAttack ) {
		G_MonsterSound(
			monster,
			def,
			"melee",
			monster->monsterAnimationVariant
		);

		/*
		 * meleeProjectile "none" (parser turns it into an
		 * empty string) enables instant melee via G_Damage.
		 * Any other value keeps the old projectile-based
		 * melee behavior (plasma / rocket).
		 */
		if( def->meleeProjectile[0] ) {
			G_MonsterFireProjectile(
				monster,
				monster->enemy,
				def,
				def->meleeProjectile,
				def->meleeDamage,
				0,
				0
			);
		}
		else {
			vec3_t delta;
			float dist;

			VectorSubtract(
				monster->enemy->r.currentOrigin,
				monster->r.currentOrigin,
				delta
			);

			dist = VectorLength( delta );

			/*
			 * 1.25f tolerance: during the attack windup the
			 * target may have moved slightly; still allow the
			 * hit if it is roughly within melee range.
			 */
			if( dist <= def->meleeRange * 1.25f &&
				G_MonsterCanSeeTarget(
					monster,
					monster->enemy
				) ) {
				G_Damage(
					monster->enemy,
					monster,
					monster,
					NULL,
					monster->r.currentOrigin,
					def->meleeDamage,
					0,
					MOD_CRUSH
				);
			}
		}
	}
	else {
		G_MonsterSound(
			monster,
			def,
			"ranged",
			monster->monsterAnimationVariant
		);

		G_MonsterFireProjectile(
			monster,
			monster->enemy,
			def,
			def->projectile,
			def->projectileDamage,
			def->splashDamage,
			def->splashRadius
		);
	}

	monster->monsterShotsRemaining--;

	if( monster->monsterShotsRemaining > 0 ) {
		monster->monsterNextShot =
			level.time +
			def->burstInterval;
	}
	else {
		monster->monsterNextAttack =
			level.time +
			def->attackCooldown;
	}
}

static void G_MonsterAttack(
	gentity_t *monster,
	gentity_t *target,
	monsterDef_t *def
) {
	float distanceSquared;

	if( monster->monsterShotsRemaining > 0 ) {
		G_MonsterRunAttack(
			monster,
			def
		);
		return;
	}

	if( monster->monsterAnimation !=
			MONSTER_STATE_MOVE &&
		monster->monsterAnimation !=
			MONSTER_STATE_IDLE ) {
		return;
	}

	if( level.time <
		monster->monsterNextAttack ) {
		return;
	}

	distanceSquared = DistanceSquared(
		monster->r.currentOrigin,
		target->r.currentOrigin
	);

	if( !G_MonsterCanSeeTarget(
		monster,
		target
	) ) {
		return;
	}

	/*
	 * Prefer melee whenever the target is close enough.
	 */
	if( def->hasMelee &&
		distanceSquared <=
			def->meleeRange *
			def->meleeRange ) {
		G_MonsterStartMeleeAttack(
			monster,
			target,
			def
		);

		G_MonsterRunAttack(
			monster,
			def
		);

		return;
	}

	if( !def->hasRanged ) {
		return;
	}

	if( distanceSquared >
		def->attackRange *
		def->attackRange ) {
		return;
	}

	G_MonsterStartRangedAttack(
		monster,
		target,
		def
	);

	G_MonsterRunAttack(
		monster,
		def
	);
}

static void G_MonsterThink(gentity_t *monster) {
	monsterDef_t *def;
	gentity_t *target;
	int msec;

	def = &g_monsterDefs
		[monster->monsterType]
		[monster->monsterSlot];

	G_MonsterUpdateAnimation(monster, def);

	if (monster->monsterDead) {
		if (level.time >= monster->monsterDeathTime) {
			if (monsterActiveCount > 0) {
				monsterActiveCount--;
			}

			G_FreeEntity(monster);
			return;
		}

		monster->nextthink = level.time + 50;
		return;
	}

	msec = level.time - monster->monsterLastThink;

	if (msec < 1) {
		msec = 1;
	}
	else if (msec > 100) {
		msec = 100;
	}

	monster->monsterLastThink = level.time;

	target = G_MonsterFindTarget(monster);

	/*
	 * During an attack, keep facing the target selected
	 * at the beginning of the attack.
	 */
	if ((monster->monsterAnimation ==
			MONSTER_STATE_RANGED ||
		 monster->monsterAnimation ==
			MONSTER_STATE_MELEE) &&
		G_MonsterValidTarget(monster->enemy)) {
		target = monster->enemy;
	}

	if (target) {
		G_MonsterFaceTarget(
			monster,
			target
		);

			G_MonsterMove(
				monster,
				target,
				def,
				msec
			);
		G_MonsterAttack(monster, target, def);

		if (monster->monsterAnimation == MONSTER_STATE_MOVE &&
			level.time >= monster->monsterNextTalk) {
			int variant;

			variant =
				rand() % MAX_MONSTER_VARIANTS;

			G_MonsterSound(
				monster,
				def,
				"talk",
				variant
			);

			monster->monsterNextTalk =
				level.time +
				G_MonsterTalkDelay(def);
		}
	}
	
	else if( monster->monsterAnimation ==
		MONSTER_STATE_MOVE ) {
		G_MonsterSetAnimation(
			monster,
			MONSTER_STATE_IDLE,
			0
		);
	}

	/*
	 * Walking monsters remain attached to the floor
	 * and fall when moving over an edge.
	 */
	G_MonsterGroundWalker(
		monster,
		def,
		msec
	);
	
	/*
	 * Remember meaningful movement so an active monster
	 * is not mistaken for a lost one.
	 */
	if( monster->monsterWaveSpawn &&
		DistanceSquared(
			monster->r.currentOrigin,
			monster->monsterProgressOrigin
		) >= 32.0f * 32.0f ) {
		VectorCopy(
			monster->r.currentOrigin,
			monster->monsterProgressOrigin
		);

		monster->monsterProgressTime =
			level.time;
	}

	trap_LinkEntity(monster);

	monster->nextthink = level.time + 50;
}

static void G_MonsterSound(
	gentity_t *monster,
	monsterDef_t *def,
	const char *group,
	int variant
) {
	char filename[MAX_QPATH];

	Com_sprintf(
		filename,
		sizeof(filename),
		"%s/%s%i.wav",
		def->soundDir,
		group,
		variant + 1
	);

	G_Sound(
		monster,
		CHAN_VOICE,
		G_SoundIndex(filename)
	);
}

static int G_MonsterTalkDelay(monsterDef_t *def) {
	int range;

	range = def->talkMaxDelay - def->talkMinDelay;

	if (range <= 0) {
		return def->talkMinDelay;
	}

	return def->talkMinDelay + rand() % (range + 1);
}

/*
 * Standard flesh-hit blood spray, if the monster definition
 * has blood enabled (noblood/blood 1 in monster.cfg).
 */
static void G_MonsterBleed(gentity_t *monster) {
	monsterDef_t *def;
	gentity_t *tent;
	vec3_t origin;
	int i;

	def = &g_monsterDefs
		[monster->monsterType]
		[monster->monsterSlot];

	if (!def->blood) {
		return;
	}

	for (i = 0; i < 3; i++) {
		origin[i] =
			monster->r.currentOrigin[i] +
			crandom() *
			(monster->r.maxs[i] - monster->r.mins[i]) *
			0.25f;
	}

	/* Lift blood to chest level. */
	origin[2] +=
		(monster->r.maxs[2] - monster->r.mins[2]) * 0.5f;

	tent = G_TempEntity(origin, EV_BULLET_HIT_FLESH);
	tent->s.eventParm = monster->s.number;
	tent->s.otherEntityNum = ENTITYNUM_NONE;
}

static void G_MonsterPain(
	gentity_t *self,
	gentity_t *attacker,
	int damage
) {
	monsterDef_t *def;
	int variant;

	if (self->monsterDead) {
		return;
	}
	G_MonsterBleed(self);
	
	if( self->monsterWaveSpawn ) {
	self->monsterProgressTime =
		level.time;

	VectorCopy(
		self->r.currentOrigin,
		self->monsterProgressOrigin
	);
}

	if (level.time < self->pain_debounce_time) {
		return;
	}

	def = &g_monsterDefs
		[self->monsterType]
		[self->monsterSlot];
			

	/*
	 * painChance: probability (0..100) that a hit actually
	 * triggers the pain animation. 100 keeps the old behavior.
	 */
	if( def->painChance <= 0 ) {
		return;
	}

	if( def->painChance < 100 &&
		(rand() % 100) >= def->painChance ) {
		return;
	}

	variant = rand() % MAX_MONSTER_VARIANTS;

	self->monsterShotsRemaining = 0;
	self->monsterNextAttack = level.time + def->attackCooldown;

	G_MonsterSetAnimation(
		self,
		MONSTER_STATE_PAIN,
		variant
	);

	G_MonsterSound(
		self,
		def,
		"pain",
		variant
	);

	self->pain_debounce_time = level.time + 700;
}

static void G_MonsterDropItem(gentity_t *monster) {
	vec3_t velocity;

	if (!monster->monsterItem ||
		!monster->monsterItem->item) {
		return;
	}

	if (rand() % 100 >= 50) {
		return;
	}

	VectorSet(
		velocity,
		crandom() * 60,
		crandom() * 60,
		140
	);

	LaunchItem(
		monster->monsterItem->item,
		monster->r.currentOrigin,
		velocity
	);
}

static void G_MonsterDie(
	gentity_t *self,
	gentity_t *inflictor,
	gentity_t *attacker,
	int damage,
	int mod
) {
	monsterDef_t *def;
	animation_t *animation;
	int variant;
	int duration;

	if (self->monsterDead) {
		return;
	}

	def = &g_monsterDefs
		[self->monsterType]
		[self->monsterSlot];

	variant = rand() % MAX_MONSTER_VARIANTS;

	G_MonsterBleed(self);
	self->monsterDead = qtrue;
	if( self->monsterWaveSpawn ) {
		monsterWaveLastProgress = level.time;
	}
	
	self->s.eFlags |= EF_DEAD;
	self->takedamage = qfalse;
	self->enemy = attacker;
	self->monsterShotsRemaining = 0;

	self->r.contents = 0;
	self->clipmask = 0;
	trap_LinkEntity(self);

	G_MonsterSetAnimation(
		self,
		MONSTER_STATE_DEATH,
		variant
	);

	/*
	 * Optional death explosion, configured per-monster
	 * via 'deathExplosion' in monster.cfg.
	 * Supported values: rocket, grenade, plasma, bfg, none.
	 */
	if( def->deathExplosion[0] ) {
		int explosionWeapon = WP_NONE;

		if( !Q_stricmp( def->deathExplosion, "rocket" ) ) {
			explosionWeapon = WP_ROCKET_LAUNCHER;
		}
		else if( !Q_stricmp( def->deathExplosion, "grenade" ) ) {
			explosionWeapon = WP_GRENADE_LAUNCHER;
		}
		else if( !Q_stricmp( def->deathExplosion, "plasma" ) ) {
			explosionWeapon = WP_PLASMAGUN;
		}
		else if( !Q_stricmp( def->deathExplosion, "bfg" ) ) {
			explosionWeapon = WP_BFG;
		}

		if( explosionWeapon != WP_NONE ) {
			gentity_t *tent;
			vec3_t snappedOrigin;

			VectorCopy( self->r.currentOrigin, snappedOrigin );
			SnapVector( snappedOrigin );

			tent = G_TempEntity( snappedOrigin, EV_MISSILE_HIT );
			tent->s.weapon = explosionWeapon;
			tent->s.eventParm = DirToByte( tv( 0, 0, 1 ) );
			tent->s.otherEntityNum = self->s.number;
		}
	}

	G_MonsterSound(
		self,
		def,
		"death",
		variant
	);

	animation = &def->deathAnimations[variant];
	duration = animation->numFrames *
		animation->frameLerp;

	self->monsterDeathTime =
		level.time +
		duration +
		def->corpseTime;

	/*
	 * Monster Hunt score is awarded only for a monster
	 * killed by a real player or bot client.
	 */
	if (g_monsterHunt.integer &&
		attacker &&
		attacker->client &&
		def->scoreValue > 0) {
		AddScore(
			attacker,
			self->r.currentOrigin,
			def->scoreValue
		);
	}

	G_MonsterDropItem(self);
	/*
	 * Only classic item-bound monsters respawn independently.
	 * Wave monsters are controlled by the wave director.
	 */
	if( !self->monsterWaveSpawn &&
		self->monsterItem &&
		self->monsterItem->inuse &&
		def->respawnTime > 0 ) {
		self->monsterItem->think =
			G_MonsterRespawnThink;

		self->monsterItem->nextthink =
			level.time + def->respawnTime;
	}
}
