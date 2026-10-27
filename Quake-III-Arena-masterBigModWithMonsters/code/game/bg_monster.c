#include "q_shared.h"
#include "bg_public.h"
#include "bg_monster.h"

static void MonsterParseError(
	char *error,
	int errorSize,
	const char *message
) {
	Com_sprintf(error, errorSize, "%s", message);
}

static qboolean MonsterReadToken(
	char **text,
	char *result,
	int resultSize,
	char *error,
	int errorSize
) {
	char *token;

	token = COM_Parse(text);
	if (!token[0]) {
		MonsterParseError(
			error,
			errorSize,
			"Unexpected end of monster.cfg"
		);
		return qfalse;
	}

	Q_strncpyz(result, token, resultSize);
	return qtrue;
}

static qboolean MonsterReadString(
	char **text,
	char *result,
	int resultSize,
	char *error,
	int errorSize
) {
	if (!MonsterReadToken(
		text,
		result,
		resultSize,
		error,
		errorSize
	)) {
		return qfalse;
	}

	if (!Q_stricmp(result, "none")) {
		result[0] = '\0';
	}

	return qtrue;
}

static qboolean MonsterReadInt(
	char **text,
	int *result,
	char *error,
	int errorSize
) {
	char token[64];

	if (!MonsterReadToken(
		text,
		token,
		sizeof(token),
		error,
		errorSize
	)) {
		return qfalse;
	}

	*result = atoi(token);
	return qtrue;
}

static qboolean MonsterReadFloat(
	char **text,
	float *result,
	char *error,
	int errorSize
) {
	char token[64];

	if (!MonsterReadToken(
		text,
		token,
		sizeof(token),
		error,
		errorSize
	)) {
		return qfalse;
	}

	*result = (float)atof(token);
	return qtrue;
}

static qboolean MonsterReadVector(
	char **text,
	vec3_t result,
	char *error,
	int errorSize
) {
	int i;

	for (i = 0; i < 3; i++) {
		if (!MonsterReadFloat(
			text,
			&result[i],
			error,
			errorSize
		)) {
			return qfalse;
		}
	}

	return qtrue;
}

static qboolean MonsterReadAnimation(
	char **text,
	animation_t *animation,
	char *error,
	int errorSize
) {
	int fps;

	memset(animation, 0, sizeof(*animation));

	if (!MonsterReadInt(
		text,
		&animation->firstFrame,
		error,
		errorSize
	)) {
		return qfalse;
	}

	if (!MonsterReadInt(
		text,
		&animation->numFrames,
		error,
		errorSize
	)) {
		return qfalse;
	}

	if (!MonsterReadInt(
		text,
		&animation->loopFrames,
		error,
		errorSize
	)) {
		return qfalse;
	}

	if (!MonsterReadInt(
		text,
		&fps,
		error,
		errorSize
	)) {
		return qfalse;
	}

	if (fps <= 0) {
		MonsterParseError(
			error,
			errorSize,
			"Monster animation FPS must be positive"
		);
		return qfalse;
	}

	animation->frameLerp = 1000 / fps;
	animation->initialLerp = animation->frameLerp;
	animation->reversed = qfalse;
	animation->flipflop = qfalse;

	return qtrue;
}

static int MonsterParseType(const char *value) {
	if (!Q_stricmp(value, "magic"))
		return MONSTER_TYPE_MAGIC;
	if (!Q_stricmp(value, "technical"))
		return MONSTER_TYPE_TECHNICAL;
	if (!Q_stricmp(value, "strange"))
		return MONSTER_TYPE_STRANGE;
	if (!Q_stricmp(value, "military"))
		return MONSTER_TYPE_MILITARY;
	if (!Q_stricmp(value, "additional"))
		return MONSTER_TYPE_ADDITIONAL;

	return -1;
}

static int MonsterParseMovement(const char *value) {
	if (!Q_stricmp(value, "flying"))
		return MONSTER_MOVEMENT_FLYING;
	if (!Q_stricmp(value, "walking"))
		return MONSTER_MOVEMENT_WALKING;

	return -1;
}

static int MonsterParsePattern(const char *value) {
	if (!Q_stricmp(value, "direct"))
		return MONSTER_PATTERN_DIRECT;
	if (!Q_stricmp(value, "drift"))
		return MONSTER_PATTERN_DRIFT;

	return -1;
}

qboolean BG_ParseMonsterConfig(
	char *text,
	monsterDef_t *def,
	char *error,
	int errorSize
) {
	char key[64];
	char value[MAX_QPATH];

	memset(def, 0, sizeof(*def));
	error[0] = '\0';

	def->health = 100;
	def->scoreValue = 1;
	def->respawnTime = 20000;
	def->corpseTime = 3000;
	def->painChance = 100;
	def->speed = 160.0f;
	def->hoverHeight = 48.0f;
	def->attackCooldown = 1800;
	def->attackFireFrame = 0;
	
	def->meleeRange = 96.0f;
	def->meleeFireFrame = 0;
	def->meleeDamage = 10;

	Q_strncpyz(
		def->meleeProjectile,
		"plasma",
		sizeof(def->meleeProjectile)
	);	
	
	def->burstCount = 1;
	def->burstInterval = 120;
	def->talkMinDelay = 5000;
	def->talkMaxDelay = 12000;

	VectorSet(def->mins, -15, -15, -24);
	VectorSet(def->maxs, 15, 15, 32);

	while (1) {
		char *token;

		token = COM_Parse(&text);
		if (!token[0]) {
			break;
		}

		Q_strncpyz(key, token, sizeof(key));

		if (!Q_stricmp(key, "name")) {
			if (!MonsterReadString(
				&text, def->name, sizeof(def->name),
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "model1")) {
			if (!MonsterReadString(
				&text, def->models[0], MAX_QPATH,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "model2")) {
			if (!MonsterReadString(
				&text, def->models[1], MAX_QPATH,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "model3")) {
			if (!MonsterReadString(
				&text, def->models[2], MAX_QPATH,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "model4")) {
			if (!MonsterReadString(
				&text, def->models[3], MAX_QPATH,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "shader")) {
			if (!MonsterReadString(
				&text, def->shader, MAX_QPATH,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "soundDir")) {
			if (!MonsterReadString(
				&text, def->soundDir, MAX_QPATH,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "projectile")) {
			if (!MonsterReadString(
				&text, def->projectile, MAX_QPATH,
				error, errorSize
			)) return qfalse;
		}
		
		else if (!Q_stricmp(key, "meleeProjectile")) {
			if (!MonsterReadString(
				&text,
				def->meleeProjectile,
				MAX_QPATH,
				error,
				errorSize
			)) return qfalse;
		}
		
		else if (!Q_stricmp(key, "monsterType")) {
			if (!MonsterReadToken(
				&text, value, sizeof(value),
				error, errorSize
			)) return qfalse;

			def->monsterType = MonsterParseType(value);
			if (def->monsterType < 0) {
				MonsterParseError(
					error, errorSize,
					"Unknown monsterType"
				);
				return qfalse;
			}
		}
		else if (!Q_stricmp(key, "movementType")) {
			if (!MonsterReadToken(
				&text, value, sizeof(value),
				error, errorSize
			)) return qfalse;

			def->movementType = MonsterParseMovement(value);
			if (def->movementType < 0) {
				MonsterParseError(
					error, errorSize,
					"Unknown movementType"
				);
				return qfalse;
			}
		}
		else if (!Q_stricmp(key, "movePattern")) {
			if (!MonsterReadToken(
				&text, value, sizeof(value),
				error, errorSize
			)) return qfalse;

			def->movePattern = MonsterParsePattern(value);
			if (def->movePattern < 0) {
				MonsterParseError(
					error, errorSize,
					"Unknown movePattern"
				);
				return qfalse;
			}
		}
		else if (!Q_stricmp(key, "monsterSlot")) {
			if (!MonsterReadInt(
				&text, &def->monsterSlot,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "health")) {
			if (!MonsterReadInt(
				&text, &def->health,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "scoreValue")) {
			if (!MonsterReadInt(
				&text, &def->scoreValue,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "respawnTime")) {
			if (!MonsterReadInt(
				&text, &def->respawnTime,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "corpseTime")) {
			if (!MonsterReadInt(
				&text,
				&def->corpseTime,
				error,
				errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "painChance")) {
			if (!MonsterReadInt(
				&text, &def->painChance,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "speed")) {
			if (!MonsterReadFloat(
				&text, &def->speed,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "hoverHeight")) {
			if (!MonsterReadFloat(
				&text, &def->hoverHeight,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "mins")) {
			if (!MonsterReadVector(
				&text, def->mins,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "maxs")) {
			if (!MonsterReadVector(
				&text, def->maxs,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "driftAmount")) {
			if (!MonsterReadFloat(
				&text, &def->driftAmount,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "driftPeriod")) {
			if (!MonsterReadInt(
				&text, &def->driftPeriod,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "hasRanged")) {
			if (!MonsterReadInt(
				&text, &def->hasRanged,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "hasMelee")) {
			if (!MonsterReadInt(
				&text, &def->hasMelee,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "attackRange")) {
			if (!MonsterReadFloat(
				&text, &def->attackRange,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "attackCooldown")) {
			if (!MonsterReadInt(
				&text, &def->attackCooldown,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "attackFireFrame")) {
			if (!MonsterReadInt(
				&text, &def->attackFireFrame,
				error, errorSize
			)) return qfalse;
		}
		
		else if (!Q_stricmp(key, "meleeRange")) {
			if (!MonsterReadFloat(
				&text,
				&def->meleeRange,
				error,
				errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "meleeFireFrame")) {
			if (!MonsterReadInt(
				&text,
				&def->meleeFireFrame,
				error,
				errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "meleeDamage")) {
			if (!MonsterReadInt(
				&text,
				&def->meleeDamage,
				error,
				errorSize
			)) return qfalse;
		}
		
		else if (!Q_stricmp(key, "burstCount")) {
			if (!MonsterReadInt(
				&text, &def->burstCount,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "burstInterval")) {
			if (!MonsterReadInt(
				&text, &def->burstInterval,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "projectileSpeed")) {
			if (!MonsterReadFloat(
				&text, &def->projectileSpeed,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "projectileDamage")) {
			if (!MonsterReadInt(
				&text, &def->projectileDamage,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "splashDamage")) {
			if (!MonsterReadInt(
				&text, &def->splashDamage,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "splashRadius")) {
			if (!MonsterReadInt(
				&text, &def->splashRadius,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "talkMinDelay")) {
			if (!MonsterReadInt(
				&text, &def->talkMinDelay,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "talkMaxDelay")) {
			if (!MonsterReadInt(
				&text, &def->talkMaxDelay,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animIdle")) {
			if (!MonsterReadAnimation(
				&text, &def->idleAnimation,
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animMove")) {
			if (!MonsterReadAnimation(
				&text, &def->moveAnimation,
				error, errorSize
			)) return qfalse;
		}
		
		else if (!Q_stricmp(key, "animMelee1")) {
			if (!MonsterReadAnimation(
				&text,
				&def->meleeAnimations[0],
				error,
				errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animMelee2")) {
			if (!MonsterReadAnimation(
				&text,
				&def->meleeAnimations[1],
				error,
				errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animMelee3")) {
			if (!MonsterReadAnimation(
				&text,
				&def->meleeAnimations[2],
				error,
				errorSize
			)) return qfalse;
		}
		
		else if (!Q_stricmp(key, "animRanged1")) {
			if (!MonsterReadAnimation(
				&text, &def->rangedAnimations[0],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animRanged2")) {
			if (!MonsterReadAnimation(
				&text, &def->rangedAnimations[1],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animRanged3")) {
			if (!MonsterReadAnimation(
				&text, &def->rangedAnimations[2],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animPain1")) {
			if (!MonsterReadAnimation(
				&text, &def->painAnimations[0],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animPain2")) {
			if (!MonsterReadAnimation(
				&text, &def->painAnimations[1],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animPain3")) {
			if (!MonsterReadAnimation(
				&text, &def->painAnimations[2],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animDeath1")) {
			if (!MonsterReadAnimation(
				&text, &def->deathAnimations[0],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animDeath2")) {
			if (!MonsterReadAnimation(
				&text, &def->deathAnimations[1],
				error, errorSize
			)) return qfalse;
		}
		else if (!Q_stricmp(key, "animDeath3")) {
			if (!MonsterReadAnimation(
				&text, &def->deathAnimations[2],
				error, errorSize
			)) return qfalse;
		}
		else {
			Com_sprintf(
				error,
				errorSize,
				"Unknown monster.cfg key: %s",
				key
			);
			return qfalse;
		}
	}

	if (!def->name[0]) {
		MonsterParseError(error, errorSize, "Missing monster name");
		return qfalse;
	}

	if (!def->models[0][0]) {
		MonsterParseError(error, errorSize, "Missing model1");
		return qfalse;
	}

	if (def->monsterSlot < 0 ||
		def->monsterSlot >= MAX_MONSTERS_PER_TYPE) {
		MonsterParseError(error, errorSize, "Invalid monsterSlot");
		return qfalse;
	}

	if (def->health <= 0 || def->speed <= 0.0f) {
		MonsterParseError(
			error,
			errorSize,
			"Invalid monster health or speed"
		);
		return qfalse;
	}
	
	if (def->corpseTime < 0) {
		def->corpseTime = 0;
	}
	
	if (def->painChance < 0) {
		def->painChance = 0;
	}
	if (def->painChance > 100) {
		def->painChance = 100;
	}

	return qtrue;
}
