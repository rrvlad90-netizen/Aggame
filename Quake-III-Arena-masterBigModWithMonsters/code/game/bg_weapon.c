#include "q_shared.h"
#include "bg_weapon.h"

blasterConfig_t bg_blasterConfig;

static void BlasterConfigError(
	char *error,
	int errorSize,
	const char *message
) {
	Com_sprintf(error, errorSize, "%s", message);
}

static qboolean BlasterReadInt(
	char **text,
	int *result,
	char *error,
	int errorSize
) {
	char *token;

	token = COM_Parse(text);

	if (!token[0]) {
		BlasterConfigError(
			error,
			errorSize,
			"Expected integer value"
		);
		return qfalse;
	}

	*result = atoi(token);
	return qtrue;
}

void BG_SetDefaultBlasterConfig(
	blasterConfig_t *config
) {
	config->fireInterval = 154;
	config->damage = 14;
	config->teamDamage = 10;
	config->spread = 200;

	config->tracerRed = 255;
	config->tracerGreen = 32;
	config->tracerBlue = 32;

	config->blueTracerRed = 32;
	config->blueTracerGreen = 96;
	config->blueTracerBlue = 255;

	config->tracerAlpha = 200;
}

static qboolean BG_ValidateBlasterConfig(
	const blasterConfig_t *config,
	char *error,
	int errorSize
) {
	if (config->fireInterval < 20 ||
		config->fireInterval > 5000) {
		BlasterConfigError(
			error,
			errorSize,
			"fireInterval must be between 20 and 5000"
		);
		return qfalse;
	}

	if (config->damage < 0 ||
		config->damage > 1000) {
		BlasterConfigError(
			error,
			errorSize,
			"damage must be between 0 and 1000"
		);
		return qfalse;
	}

	if (config->teamDamage < 0 ||
		config->teamDamage > 1000) {
		BlasterConfigError(
			error,
			errorSize,
			"teamDamage must be between 0 and 1000"
		);
		return qfalse;
	}

	if (config->spread < 0 ||
		config->spread > 5000) {
		BlasterConfigError(
			error,
			errorSize,
			"spread must be between 0 and 5000"
		);
		return qfalse;
	}

	if (config->tracerRed < 0 ||
		config->tracerRed > 255 ||
		config->tracerGreen < 0 ||
		config->tracerGreen > 255 ||
		config->tracerBlue < 0 ||
		config->tracerBlue > 255) {
		BlasterConfigError(
			error,
			errorSize,
			"Tracer color must be between 0 and 255"
		);
		return qfalse;
	}

	if (config->blueTracerRed < 0 ||
		config->blueTracerRed > 255 ||
		config->blueTracerGreen < 0 ||
		config->blueTracerGreen > 255 ||
		config->blueTracerBlue < 0 ||
		config->blueTracerBlue > 255) {
		BlasterConfigError(
			error,
			errorSize,
			"Blue tracer color must be between 0 and 255"
		);
		return qfalse;
	}

	if (config->tracerAlpha < 0 ||
		config->tracerAlpha > 255) {
		BlasterConfigError(
			error,
			errorSize,
			"tracerAlpha must be between 0 and 255"
		);
		return qfalse;
	}

	return qtrue;
}

qboolean BG_ParseBlasterConfig(
	char *text,
	blasterConfig_t *config,
	char *error,
	int errorSize
) {
	char key[64];

	BG_SetDefaultBlasterConfig(config);
	error[0] = '\0';

	while (1) {
		char *token;

		token = COM_Parse(&text);

		if (!token[0]) {
			break;
		}

		Q_strncpyz(key, token, sizeof(key));

		if (!Q_stricmp(key, "fireInterval")) {
			if (!BlasterReadInt(
				&text,
				&config->fireInterval,
				error,
				errorSize
			)) {
				return qfalse;
			}
		}
		else if (!Q_stricmp(key, "damage")) {
			if (!BlasterReadInt(
				&text,
				&config->damage,
				error,
				errorSize
			)) {
				return qfalse;
			}
		}
		else if (!Q_stricmp(key, "teamDamage")) {
			if (!BlasterReadInt(
				&text,
				&config->teamDamage,
				error,
				errorSize
			)) {
				return qfalse;
			}
		}
		else if (!Q_stricmp(key, "spread")) {
			if (!BlasterReadInt(
				&text,
				&config->spread,
				error,
				errorSize
			)) {
				return qfalse;
			}
		}
		else if (!Q_stricmp(key, "tracerRed")) {
	if (!BlasterReadInt(
		&text,
		&config->tracerRed,
		error,
		errorSize
	)) return qfalse;
	}
	else if (!Q_stricmp(key, "tracerGreen")) {
		if (!BlasterReadInt(
			&text,
			&config->tracerGreen,
			error,
			errorSize
		)) return qfalse;
	}
	else if (!Q_stricmp(key, "tracerBlue")) {
		if (!BlasterReadInt(
			&text,
			&config->tracerBlue,
			error,
			errorSize
		)) return qfalse;
	}
	else if (!Q_stricmp(key, "blueTracerRed")) {
		if (!BlasterReadInt(
			&text,
			&config->blueTracerRed,
			error,
			errorSize
		)) return qfalse;
	}
	else if (!Q_stricmp(key, "blueTracerGreen")) {
		if (!BlasterReadInt(
			&text,
			&config->blueTracerGreen,
			error,
			errorSize
		)) return qfalse;
	}
	else if (!Q_stricmp(key, "blueTracerBlue")) {
		if (!BlasterReadInt(
			&text,
			&config->blueTracerBlue,
			error,
			errorSize
		)) return qfalse;
	}
	else if (!Q_stricmp(key, "tracerAlpha")) {
		if (!BlasterReadInt(
			&text,
			&config->tracerAlpha,
			error,
			errorSize
		)) return qfalse;
	}
		else {
			Com_sprintf(
				error,
				errorSize,
				"Unknown blaster parameter: %s",
				key
			);
			return qfalse;
		}
	}

	return BG_ValidateBlasterConfig(
		config,
		error,
		errorSize
	);
}

static qboolean BlasterReadInfoInt(
	const char *text,
	const char *key,
	int *result,
	char *error,
	int errorSize
) {
	const char *value;

	value = Info_ValueForKey(text, key);

	if (!value[0]) {
		Com_sprintf(
			error,
			errorSize,
			"Missing %s",
			key
		);
		return qfalse;
	}

	*result = atoi(value);
	return qtrue;
}

qboolean BG_ParseBlasterConfigString(
	const char *text,
	blasterConfig_t *config,
	char *error,
	int errorSize
) {
	BG_SetDefaultBlasterConfig(config);
	error[0] = '\0';

	if (!BlasterReadInfoInt(
		text, "fireInterval",
		&config->fireInterval,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "damage",
		&config->damage,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "teamDamage",
		&config->teamDamage,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "spread",
		&config->spread,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "tracerRed",
		&config->tracerRed,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "tracerGreen",
		&config->tracerGreen,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "tracerBlue",
		&config->tracerBlue,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "blueTracerRed",
		&config->blueTracerRed,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "blueTracerGreen",
		&config->blueTracerGreen,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "blueTracerBlue",
		&config->blueTracerBlue,
		error, errorSize
	)) return qfalse;

	if (!BlasterReadInfoInt(
		text, "tracerAlpha",
		&config->tracerAlpha,
		error, errorSize
	)) return qfalse;

	return BG_ValidateBlasterConfig(
		config,
		error,
		errorSize
	);
}

void BG_BuildBlasterConfigString(
	const blasterConfig_t *config,
	char *buffer,
	int bufferSize
) {
	Com_sprintf(
		buffer,
		bufferSize,
		"\\fireInterval\\%i"
		"\\damage\\%i"
		"\\teamDamage\\%i"
		"\\spread\\%i"
		"\\tracerRed\\%i"
		"\\tracerGreen\\%i"
		"\\tracerBlue\\%i"
		"\\blueTracerRed\\%i"
		"\\blueTracerGreen\\%i"
		"\\blueTracerBlue\\%i"
		"\\tracerAlpha\\%i",
		config->fireInterval,
		config->damage,
		config->teamDamage,
		config->spread,
		config->tracerRed,
		config->tracerGreen,
		config->tracerBlue,
		config->blueTracerRed,
		config->blueTracerGreen,
		config->blueTracerBlue,
		config->tracerAlpha
	);
}