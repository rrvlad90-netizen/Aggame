#ifndef BG_MONSTER_H
#define BG_MONSTER_H

#define MAX_MONSTER_MODELS       4
#define MAX_MONSTER_VARIANTS     3
#define MAX_MONSTERS_PER_TYPE    5
#define MAX_MONSTER_CONFIG_TEXT  8192

typedef enum {
	MONSTER_TYPE_OFF,
	MONSTER_TYPE_MAGIC,
	MONSTER_TYPE_TECHNICAL,
	MONSTER_TYPE_STRANGE,
	MONSTER_TYPE_MILITARY,
	MONSTER_TYPE_ADDITIONAL,
	MONSTER_TYPE_RANDOM
} monsterType_t;

typedef enum {
	MONSTER_MOVEMENT_FLYING,
	MONSTER_MOVEMENT_WALKING
} monsterMovement_t;

typedef enum {
	MONSTER_PATTERN_DIRECT,
	MONSTER_PATTERN_DRIFT
} monsterMovePattern_t;

typedef struct {

	char name[MAX_QPATH];
	char models[MAX_MONSTER_MODELS][MAX_QPATH];
	char shader[MAX_QPATH];
	char soundDir[MAX_QPATH];
	char projectile[MAX_QPATH];
	char meleeProjectile[MAX_QPATH];

	int monsterType;
	int monsterSlot;
	int movementType;
	int movePattern;

	int health;
	int scoreValue;
	float speed;
	float hoverHeight;

	vec3_t mins;
	vec3_t maxs;

	float driftAmount;
	int driftPeriod;

	qboolean hasRanged;
	qboolean hasMelee;

	float attackRange;
	int attackCooldown;
	int attackFireFrame;
	float meleeRange;
	int meleeFireFrame;
	int meleeDamage;
	int burstCount;
	int burstInterval;

	float projectileSpeed;
	int projectileDamage;
	int splashDamage;
	int splashRadius;

	int talkMinDelay;
	int talkMaxDelay;
		
	int respawnTime;
	int corpseTime;

	animation_t idleAnimation;
	animation_t moveAnimation;
	animation_t meleeAnimations[MAX_MONSTER_VARIANTS];
	animation_t rangedAnimations[MAX_MONSTER_VARIANTS];
	animation_t painAnimations[MAX_MONSTER_VARIANTS];
	animation_t deathAnimations[MAX_MONSTER_VARIANTS];
} monsterDef_t;

qboolean BG_ParseMonsterConfig(
	char *text,
	monsterDef_t *def,
	char *error,
	int errorSize
);

#endif
