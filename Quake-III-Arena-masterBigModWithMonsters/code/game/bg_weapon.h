#ifndef BG_WEAPON_H
#define BG_WEAPON_H

#define BLASTER_CONFIG_PATH \
	"models/weapons2/SWBlaster/weapon.cfg"

#define MAX_BLASTER_CONFIG_TEXT 2048

typedef struct {
	int fireInterval;
	int damage;
	int teamDamage;
	int spread;

	int tracerRed;
	int tracerGreen;
	int tracerBlue;

	int blueTracerRed;
	int blueTracerGreen;
	int blueTracerBlue;

	int tracerAlpha;
} blasterConfig_t;

extern blasterConfig_t bg_blasterConfig;

void CG_BlasterTracer(
	vec3_t source,
	vec3_t dest,
	int team
);

qboolean BG_ParseBlasterConfig(
	char *text,
	blasterConfig_t *config,
	char *error,
	int errorSize
);

qboolean BG_ParseBlasterConfigString(
	const char *text,
	blasterConfig_t *config,
	char *error,
	int errorSize
);

void BG_BuildBlasterConfigString(
	const blasterConfig_t *config,
	char *buffer,
	int bufferSize
);

#endif