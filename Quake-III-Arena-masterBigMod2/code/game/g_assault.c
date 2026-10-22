#include "g_local.h"

#define ASSAULT_MIN_POINT_DISTANCE 512.0f
#define ASSAULT_MARKER_MODEL "models/powerups/teleporter/tele_exit.md3"
#define ASSAULT_MAX_POINTS 3
#define ASSAULT_DEFAULT_POINTS 2
#define ASSAULT_MODE_BASE 1
#define ASSAULT_MODE_EDITOR 2
#define ASSAULT_MODE_TDM_BASE 3
#define ASSAULT_AUTO_START_DELAY 2000
#define ASSAULT_MIDDLE_ITEM_COUNT 13

typedef enum {
	ASSAULT_SETUP,
	ASSAULT_ROUND_RED,
	ASSAULT_ROUND_BLUE,
	ASSAULT_FINISHED
} assaultPhase_t;

typedef struct {
	int completedPoints;
	int progress;
	int elapsedTime;
} assaultResult_t;

typedef struct {
	assaultPhase_t phase;

	vec3_t points[ASSAULT_MAX_POINTS];
	int pointAreas[ASSAULT_MAX_POINTS];
	qboolean pointSet[ASSAULT_MAX_POINTS];
	gentity_t *markers[ASSAULT_MAX_POINTS];
	qboolean instructionsShown[MAX_CLIENTS];

	int pointCount;

	int editorClient;
	int activeStage;
	int captureProgress;
	int announcedQuarter;

	int roundStartTime;
	int roundLimit;
	int lastFrameTime;
	int autoStartTime;

	team_t attackingTeam;

	assaultResult_t redResult;
	assaultResult_t blueResult;
} assaultState_t;

static assaultState_t assault;

static char *assaultMiddleClassnames[
	ASSAULT_MIDDLE_ITEM_COUNT
] = {
	"item_armor_body",
	"item_armor_combat",
	"item_health_mega",
	"holdable_medkit",
	"item_haste",
	"weapon_bfg",
	"weapon_railgun",
	"weapon_shotgun",
	"weapon_rocketlauncher",
	"weapon_grenadelauncher",
	"weapon_lightning",
	"holdable_teleporter",
	"weapon_plasmagun"
};

static char *assaultMiddleNames[
	ASSAULT_MIDDLE_ITEM_COUNT
] = {
	"Heavy Armor",
	"Armor",
	"Mega Health",
	"Medkit",
	"Haste",
	"BFG",
	"Railgun",
	"Shotgun",
	"Rocket Launcher",
	"Grenade Launcher",
	"Lightning Gun",
	"Personal Teleporter",
	"Plasma Gun"
};

static char *AssaultPointName( int point ) {
	switch( point ) {
	case 0:
		return "A";
	case 1:
		return "B";
	case 2:
		return "C";
	default:
		return "?";
	}
}

qboolean G_AssaultEnabled( void ) {
	return
		(
			g_assaultMode.integer == ASSAULT_MODE_BASE ||
			g_assaultMode.integer == ASSAULT_MODE_EDITOR ||
			g_assaultMode.integer == ASSAULT_MODE_TDM_BASE
		) &&
		g_gametype.integer == GT_TEAM;
}

static int AssaultActualPoint( void ) {
	if( assault.attackingTeam == TEAM_RED ) {
		return assault.activeStage;
	}

	return assault.pointCount - 1 - assault.activeStage;
}

static void AssaultSetMarkerLight(
	gentity_t *marker,
	int red,
	int green,
	int blue,
	int intensity
) {
	if( !marker ) {
		return;
	}

	marker->s.constantLight =
		red |
		(green << 8) |
		(blue << 16) |
		(intensity << 24);
}

static void AssaultUpdateMarkers( void ) {
	int activePoint;
	int i;

	activePoint = -1;

	if( assault.phase == ASSAULT_ROUND_RED ||
		assault.phase == ASSAULT_ROUND_BLUE ) {
		activePoint = AssaultActualPoint();
	}

	for( i = 0; i < ASSAULT_MAX_POINTS; i++ ) {
		if( !assault.markers[i] ) {
			continue;
		}

		if( i == activePoint ) {
			AssaultSetMarkerLight(
				assault.markers[i], 32, 255, 32, 100
			);
			continue;
		}

		if( i == 0 ) {
			AssaultSetMarkerLight(
				assault.markers[i], 255, 48, 32, 55
			);
		}
		else if( i == 1 ) {
			AssaultSetMarkerLight(
				assault.markers[i], 48, 96, 255, 55
			);
		}
		else {
			AssaultSetMarkerLight(
				assault.markers[i], 255, 192, 32, 55
			);
		}
	}
}

static void AssaultCreateOrMoveMarker( int point ) {
	gentity_t *marker;

	marker = assault.markers[point];

	if( !marker ) {
		marker = G_Spawn();
		assault.markers[point] = marker;

		marker->classname = "assault_marker";
		marker->s.eType = ET_GENERAL;
		marker->s.modelindex = G_ModelIndex( ASSAULT_MARKER_MODEL );
		marker->s.apos.trType = TR_LINEAR;
		marker->s.apos.trTime = level.time;
		VectorSet(
			marker->s.apos.trDelta,
			0.0f,
			45.0f,
			0.0f
		);

		marker->r.svFlags |= SVF_BROADCAST;
		marker->r.contents = 0;
	}

	G_SetOrigin( marker, assault.points[point] );
	trap_LinkEntity( marker );

	AssaultUpdateMarkers();
}

static int AssaultPointAreaNum( vec3_t origin ) {
	int area;
	int areas[16];
	int numAreas;
	int i;
	vec3_t start;
	vec3_t end;

	area = trap_AAS_PointAreaNum( origin );

	if( area &&
		trap_AAS_AreaReachability(area) ) {
		return area;
	}

	VectorCopy( origin, start );
	VectorCopy( origin, end );

	start[2] -= 32.0f;
	end[2] += 64.0f;

	numAreas = trap_AAS_TraceAreas(
		start,
		end,
		areas,
		NULL,
		16
	);

	for( i = 0; i < numAreas; i++ ) {
		if( trap_AAS_AreaReachability(areas[i]) ) {
			return areas[i];
		}
	}

	return 0;
}

static void AssaultGroundOrigin(
	vec3_t source,
	vec3_t result
) {
	trace_t trace;
	vec3_t start;
	vec3_t end;

	VectorCopy( source, start );
	VectorCopy( source, end );

	start[2] += 32.0f;
	end[2] -= 256.0f;

	trap_Trace(
		&trace,
		start,
		NULL,
		NULL,
		end,
		ENTITYNUM_NONE,
		MASK_SOLID
	);

	if( !trace.startsolid &&
		!trace.allsolid &&
		trace.fraction < 1.0f ) {
		VectorCopy( trace.endpos, result );
	}
	else {
		VectorCopy( source, result );
	}

	result[2] += 8.0f;
}

static void AssaultConsiderClassname(
	const char *classname,
	int itemIndex,
	int *seen,
	vec3_t selectedOrigin,
	int *selectedArea,
	int *selectedItem
) {
	gentity_t *ent;
	vec3_t origin;
	int area;

	ent = NULL;

	while( (ent = G_Find(
		ent,
		FOFS(classname),
		classname
	)) != NULL ) {
		AssaultGroundOrigin(
			ent->s.origin,
			origin
		);

		area = AssaultPointAreaNum( origin );

		if( !area ) {
			continue;
		}

		(*seen)++;

		if( rand() % (*seen) != 0 ) {
			continue;
		}

		VectorCopy( origin, selectedOrigin );
		*selectedArea = area;
		*selectedItem = itemIndex;
	}
}

static qboolean AssaultPickClassname(
	const char *classname,
	int itemIndex,
	vec3_t origin,
	int *area,
	int *selectedItem
) {
	int seen;

	seen = 0;
	*area = 0;
	*selectedItem = -1;

	AssaultConsiderClassname(
		classname,
		itemIndex,
		&seen,
		origin,
		area,
		selectedItem
	);

	return seen > 0;
}

static qboolean AssaultSelectMiddlePoint(
	vec3_t origin,
	int *area,
	int *selectedItem
) {
	int choice;
	int seen;
	int i;
	vec3_t midpoint;

	choice = g_assaultMiddleItem.integer;

	if( choice < 0 ||
		choice > ASSAULT_MIDDLE_ITEM_COUNT ) {
		choice = 0;
	}

	/*
	 * All: select uniformly from every supported entity.
	 */
	if( choice == 0 ) {
		seen = 0;
		*area = 0;
		*selectedItem = -1;

		for( i = 0;
			i < ASSAULT_MIDDLE_ITEM_COUNT;
			i++ ) {
			AssaultConsiderClassname(
				assaultMiddleClassnames[i],
				i,
				&seen,
				origin,
				area,
				selectedItem
			);
		}

		if( seen > 0 ) {
			return qtrue;
		}
	}
	else {
		/*
		 * Explicitly selected entity.
		 */
		if( AssaultPickClassname(
			assaultMiddleClassnames[choice - 1],
			choice - 1,
			origin,
			area,
			selectedItem
		) ) {
			return qtrue;
		}

		/*
		 * Selected entity is absent. Try the fallback list.
		 */
		for( i = 0;
			i < ASSAULT_MIDDLE_ITEM_COUNT;
			i++ ) {
			if( AssaultPickClassname(
				assaultMiddleClassnames[i],
				i,
				origin,
				area,
				selectedItem
			) ) {
				return qtrue;
			}
		}
	}

	/*
	 * Last fallback: midpoint between the flags.
	 */
	VectorAdd(
		assault.points[0],
		assault.points[2],
		midpoint
	);
	VectorScale( midpoint, 0.5f, midpoint );

	AssaultGroundOrigin( midpoint, origin );
	*area = AssaultPointAreaNum( origin );
	*selectedItem = -1;

	return *area != 0;
}

static void AssaultRemoveMapClass(
	const char *classname
) {
	gentity_t *ent;

	ent = NULL;

	while( (ent = G_Find(
		ent,
		FOFS(classname),
		classname
	)) != NULL ) {
		G_FreeEntity( ent );
	}
}

static qboolean AssaultSetupBasePoints( void ) {
	int selectedItem;
	int unusedItem;
	int i;

	assault.pointCount = 3;

	/*
	 * A: blue flag.
	 */
	if( !AssaultPickClassname(
		"team_CTF_blueflag",
		-1,
		assault.points[0],
		&assault.pointAreas[0],
		&unusedItem
	) ) {
		G_Printf(
			"Assault: blue flag position not found.\n"
		);
		return qfalse;
	}

	assault.pointSet[0] = qtrue;

	/*
	 * C: red flag.
	 */
	if( !AssaultPickClassname(
		"team_CTF_redflag",
		-1,
		assault.points[2],
		&assault.pointAreas[2],
		&unusedItem
	) ) {
		G_Printf(
			"Assault: red flag position not found.\n"
		);
		return qfalse;
	}

	assault.pointSet[2] = qtrue;

	/*
	 * B: selected item or automatic fallback.
	 */
	if( !AssaultSelectMiddlePoint(
		assault.points[1],
		&assault.pointAreas[1],
		&selectedItem
	) ) {
		G_Printf(
			"Assault: unable to create point B.\n"
		);
		return qfalse;
	}

	assault.pointSet[1] = qtrue;

	/*
	 * Flags are anchors only; remove their normal entities.
	 */
	AssaultRemoveMapClass(
		"team_CTF_blueflag"
	);
	AssaultRemoveMapClass(
		"team_CTF_redflag"
	);

	for( i = 0; i < assault.pointCount; i++ ) {
		AssaultCreateOrMoveMarker( i );
	}

	if( selectedItem >= 0 ) {
		G_Printf(
			"Assault: point B placed at %s.\n",
			assaultMiddleNames[selectedItem]
		);
	}
	else {
		G_Printf(
			"Assault: point B placed at map midpoint.\n"
		);
	}

	return qtrue;
}

static qboolean AssaultSetupTDMBasePoints( void ) {
	gentity_t *redSpot;
	gentity_t *blueSpot;
	int selectedItem;
	int i;

	assault.pointCount = 3;

	if( !G_FindAutomaticBaseSpots(
		&redSpot,
		&blueSpot
	) ) {
		G_Printf(
			"Assault TDM: map needs at least two spawn points.\n"
		);
		return qfalse;
	}

	/*
	 * A: blue team's automatic base.
	 */
	AssaultGroundOrigin(
		blueSpot->s.origin,
		assault.points[0]
	);

	assault.pointAreas[0] =
		AssaultPointAreaNum(assault.points[0]);

	if( !assault.pointAreas[0] ) {
		G_Printf(
			"Assault TDM: point A has no reachable AAS area.\n"
		);
		return qfalse;
	}

	assault.pointSet[0] = qtrue;

	/*
	 * C: red team's automatic base.
	 */
	AssaultGroundOrigin(
		redSpot->s.origin,
		assault.points[2]
	);

	assault.pointAreas[2] =
		AssaultPointAreaNum(assault.points[2]);

	if( !assault.pointAreas[2] ) {
		G_Printf(
			"Assault TDM: point C has no reachable AAS area.\n"
		);
		return qfalse;
	}

	assault.pointSet[2] = qtrue;

	/*
	 * B: selected map item or automatic fallback.
	 */
	if( !AssaultSelectMiddlePoint(
		assault.points[1],
		&assault.pointAreas[1],
		&selectedItem
	) ) {
		G_Printf(
			"Assault TDM: unable to create point B.\n"
		);
		return qfalse;
	}

	assault.pointSet[1] = qtrue;

	for( i = 0; i < assault.pointCount; i++ ) {
		AssaultCreateOrMoveMarker( i );
	}

	if( selectedItem >= 0 ) {
		G_Printf(
			"Assault TDM: point B placed at %s.\n",
			assaultMiddleNames[selectedItem]
		);
	}
	else {
		G_Printf(
			"Assault TDM: point B placed at map midpoint.\n"
		);
	}

	return qtrue;
}

static qboolean AssaultTracePlacement(
	gentity_t *ent,
	vec3_t result
) {
	trace_t trace;
	vec3_t start;
	vec3_t end;
	vec3_t forward;

	VectorCopy( ent->client->ps.origin, start );

	if( ent->client->ps.viewheight ) {
		start[2] += ent->client->ps.viewheight;
	}
	else {
		start[2] += 26;
	}

	AngleVectors(
		ent->client->ps.viewangles,
		forward,
		NULL,
		NULL
	);

	VectorMA( start, 8192.0f, forward, end );

	trap_Trace(
		&trace,
		start,
		NULL,
		NULL,
		end,
		ent - g_entities,
		MASK_SOLID
	);

	if( trace.startsolid ||
		trace.allsolid ||
		trace.fraction == 1.0f ||
		(trace.surfaceFlags & SURF_SKY) ) {
		return qfalse;
	}

	VectorCopy( trace.endpos, result );
	result[2] += 8.0f;

	return qtrue;
}

static qboolean AssaultClaimEditor( gentity_t *ent ) {
	int clientNum;

	clientNum = ent - g_entities;

	if( ent->r.svFlags & SVF_BOT ) {
		return qfalse;
	}

	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Point placement requires spectator mode.\n\""
		);
		return qfalse;
	}

	if( assault.editorClient == -1 ) {
		assault.editorClient = clientNum;

		trap_SendServerCommand(
			-1,
			va(
				"print \"%s is placing Assault points.\n\"",
				ent->client->pers.netname
			)
		);
	}

	if( assault.editorClient != clientNum ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Another player is placing the points.\n\""
		);
		return qfalse;
	}

	return qtrue;
}

static void AssaultPlacePoint( gentity_t *ent, int point ) {
	vec3_t origin;
	int otherPoint;
	int area;
	int clientNum;

	clientNum = ent - g_entities;

	if( assault.phase != ASSAULT_SETUP ) {
		trap_SendServerCommand(
			clientNum,
			"print \"The match has already started.\n\""
		);
		return;
	}

	if( point < 0 || point >= assault.pointCount ) {
		trap_SendServerCommand(
			clientNum,
			va(
				"print \"Point number must be from 1 to %i.\n\"",
				assault.pointCount
			)
		);
		return;
	}

	if( assault.editorClient != clientNum ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Use /assault_edit first.\n\""
		);
		return;
	}

	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Point placement requires spectator mode.\n\""
		);
		return;
	}

	if( !AssaultTracePlacement(ent, origin) ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Unable to place a point there.\n\""
		);
		return;
	}

	for( otherPoint = 0;
		otherPoint < assault.pointCount;
		otherPoint++ ) {
		if( otherPoint == point ||
			!assault.pointSet[otherPoint] ) {
			continue;
		}

		if( DistanceSquared(
			origin,
			assault.points[otherPoint]
		) <
			ASSAULT_MIN_POINT_DISTANCE *
			ASSAULT_MIN_POINT_DISTANCE ) {
			trap_SendServerCommand(
				clientNum,
				"print \"The points are too close together.\n\""
			);
			return;
		}
	}

	area = AssaultPointAreaNum( origin );

	VectorCopy( origin, assault.points[point] );
	assault.pointAreas[point] = area;
	assault.pointSet[point] = qtrue;

	AssaultCreateOrMoveMarker( point );

	trap_SendServerCommand(
		-1,
		va(
			"cp \"Assault point %s placed\"",
			AssaultPointName(point)
		)
	);

	if( !area ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Warning: the point has no AAS area; bots may not reach it.\n\""
		);
	}
}

static void AssaultRespawnTeams( void ) {
	int i;
	gentity_t *ent;

	for( i = 0; i < level.maxclients; i++ ) {
		ent = &g_entities[i];

		if( !ent->client ||
			ent->client->pers.connected != CON_CONNECTED ) {
			continue;
		}

		if( ent->client->sess.sessionTeam != TEAM_RED &&
			ent->client->sess.sessionTeam != TEAM_BLUE ) {
			continue;
		}

		ClientSpawn( ent );
	}
}

static void AssaultStartRound( team_t attackingTeam ) {
	int normalLimit;

	assault.attackingTeam = attackingTeam;
	assault.activeStage = 0;
	assault.captureProgress = 0;
	assault.announcedQuarter = 0;
	assault.roundStartTime = level.time;
	assault.lastFrameTime = level.time;

	if( g_timelimit.value > 0.0f ) {
		normalLimit =
			(int)(g_timelimit.value * 60000.0f);
	}
	else {
		normalLimit = 7 * 60 * 1000;
	}

	if( normalLimit < 30000 ) {
		normalLimit = 30000;
	}

	assault.roundLimit = normalLimit;

	if( attackingTeam == TEAM_RED ) {
		assault.phase = ASSAULT_ROUND_RED;
	}
	else {
		assault.phase = ASSAULT_ROUND_BLUE;

		/*
		 * If Red completed the route, Blue must beat Red's time.
		 */
		if( assault.redResult.completedPoints == assault.pointCount &&
			assault.redResult.elapsedTime <
			assault.roundLimit ) {
			assault.roundLimit =
				assault.redResult.elapsedTime;
		}
	}

	level.startTime = level.time;
	trap_SetConfigstring(
		CS_LEVEL_START_TIME,
		va("%i", level.startTime)
	);

	AssaultRespawnTeams();
	AssaultUpdateMarkers();

	trap_SendServerCommand(
		-1,
		va(
			"cp \"%s attacks point %s\"",
			attackingTeam == TEAM_RED ? "Red" : "Blue",
			AssaultPointName(AssaultActualPoint())
		)
	);
}

static void AssaultUpdateScores( void ) {
	level.teamScores[TEAM_RED] =
		assault.redResult.completedPoints ==
		assault.pointCount ? 1 : 0;

	level.teamScores[TEAM_BLUE] =
		assault.blueResult.completedPoints ==
		assault.pointCount ? 1 : 0;

	trap_SetConfigstring(
		CS_SCORES1,
		va("%i", level.teamScores[TEAM_RED])
	);

	trap_SetConfigstring(
		CS_SCORES2,
		va("%i", level.teamScores[TEAM_BLUE])
	);

	CalculateRanks();
}

static void AssaultFinishMatch( void ) {
	int winner;

	winner = TEAM_FREE;

	if( assault.redResult.completedPoints >
		assault.blueResult.completedPoints ) {
		winner = TEAM_RED;
	}
	else if( assault.blueResult.completedPoints >
		assault.redResult.completedPoints ) {
		winner = TEAM_BLUE;
	}
	else if( assault.redResult.completedPoints == assault.pointCount ) {
		if( assault.redResult.elapsedTime <
			assault.blueResult.elapsedTime ) {
			winner = TEAM_RED;
		}
		else if( assault.blueResult.elapsedTime <
			assault.redResult.elapsedTime ) {
			winner = TEAM_BLUE;
		}
	}
	else {
		if( assault.redResult.progress >
			assault.blueResult.progress ) {
			winner = TEAM_RED;
		}
		else if( assault.blueResult.progress >
			assault.redResult.progress ) {
			winner = TEAM_BLUE;
		}
	}

	assault.phase = ASSAULT_FINISHED;

	CalculateRanks();

	if( winner == TEAM_RED ) {
		trap_SendServerCommand(
			-1,
			"cp \"Red team wins Assault\""
		);
		LogExit( "Red team won Assault." );
	}
	else if( winner == TEAM_BLUE ) {
		trap_SendServerCommand(
			-1,
			"cp \"Blue team wins Assault\""
		);
		LogExit( "Blue team won Assault." );
	}
	else {
		trap_SendServerCommand(
			-1,
			"cp \"Assault ended in a draw\""
		);
		LogExit( "Assault draw." );
	}
}

static void AssaultStoreRoundResult( qboolean completed ) {
	assaultResult_t *result;

	if( assault.attackingTeam == TEAM_RED ) {
		result = &assault.redResult;
	}
	else {
		result = &assault.blueResult;
	}

	if( completed ) {
		result->completedPoints = assault.pointCount;
		result->progress = (int)(g_assaultHoldTime.value * 1000.0f);
		result->elapsedTime =
			level.time - assault.roundStartTime;
	}
	else {
		result->completedPoints = assault.activeStage;
		result->progress = assault.captureProgress;
		result->elapsedTime = assault.roundLimit;
	}

	/*
	 * Update team scores only after storing the round result.
	 */
	AssaultUpdateScores();

	if( assault.attackingTeam == TEAM_RED ) {
		AssaultStartRound( TEAM_BLUE );
	}
	else {
		AssaultFinishMatch();
	}
}

static void AssaultCompletePoint( void ) {
	int completedPoint;

	completedPoint = AssaultActualPoint();

	trap_SendServerCommand(
		-1,
		va(
			"cp \"Point %s captured\"",
			AssaultPointName(completedPoint)
		)
	);

	assault.activeStage++;
	assault.captureProgress = 0;
	assault.announcedQuarter = 0;

	if( assault.activeStage >= assault.pointCount ) {
		AssaultStoreRoundResult( qtrue );
		return;
	}

	AssaultUpdateMarkers();

	trap_SendServerCommand(
		-1,
		va(
			"cp \"Attack point %s\"",
			AssaultPointName(AssaultActualPoint())
		)
	);
}

static void AssaultCountPlayers(
	int point,
	int *attackers,
	int *defenders
) {
	int i;
	float radiusSquared;
	gentity_t *ent;

	*attackers = 0;
	*defenders = 0;

	radiusSquared =
		g_assaultRadius.value *
		g_assaultRadius.value;

	for( i = 0; i < level.maxclients; i++ ) {
		ent = &g_entities[i];

		if( !ent->client ||
			ent->client->pers.connected != CON_CONNECTED ||
			ent->client->ps.stats[STAT_HEALTH] <= 0 ) {
			continue;
		}

		if( ent->client->sess.sessionTeam != TEAM_RED &&
			ent->client->sess.sessionTeam != TEAM_BLUE ) {
			continue;
		}

		if( DistanceSquared(
			ent->client->ps.origin,
			assault.points[point]
		) > radiusSquared ) {
			continue;
		}

		if( ent->client->sess.sessionTeam ==
			assault.attackingTeam ) {
			(*attackers)++;
		}
		else {
			(*defenders)++;
		}
	}
}

static void AssaultStartMatch( gentity_t *ent ) {
	int clientNum;
	int i;

	clientNum = ent ? ent - g_entities : -1;

	if( g_assaultMode.integer ==
		ASSAULT_MODE_EDITOR ) {
		if( !ent ||
			assault.editorClient != clientNum ) {
			trap_SendServerCommand(
				clientNum,
				"print \"Only the point editor can start the match.\n\""
			);
			return;
		}
	}

	for( i = 0; i < assault.pointCount; i++ ) {
		if( !assault.pointSet[i] ) {
			trap_SendServerCommand(
				clientNum,
				va(
					"print \"Assault: points are invalid. Point %s is missing.\n\"",
					AssaultPointName(i)
				)
			);
			return;
		}
	}

	if( TeamCount(-1, TEAM_RED) < 1 ||
		TeamCount(-1, TEAM_BLUE) < 1 ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Both teams need at least one player.\n\""
		);
		return;
	}

	level.warmupTime = 0;
	trap_SetConfigstring( CS_WARMUP, "0" );

	memset(
		&assault.redResult,
		0,
		sizeof(assault.redResult)
	);
	memset(
		&assault.blueResult,
		0,
		sizeof(assault.blueResult)
	);
	
	level.teamScores[TEAM_RED] = 0;
	level.teamScores[TEAM_BLUE] = 0;

	trap_SetConfigstring( CS_SCORES1, "0" );
	trap_SetConfigstring( CS_SCORES2, "0" );

	AssaultStartRound( TEAM_RED );
}


static void AssaultSetPointCount(
	gentity_t *ent,
	int pointCount
) {
	int i;
	int clientNum;

	clientNum = ent - g_entities;

	if( assault.phase != ASSAULT_SETUP ) {
		trap_SendServerCommand(
			clientNum,
			"print \"The match has already started.\n\""
		);
		return;
	}

	if( ent->r.svFlags & SVF_BOT ) {
		return;
	}

	if( pointCount < 1 ||
		pointCount > ASSAULT_MAX_POINTS ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Usage: /assault_set 1|2|3\n\""
		);
		return;
	}

	if( assault.editorClient >= 0 &&
		assault.editorClient != clientNum ) {
		trap_SendServerCommand(
			clientNum,
			"print \"Another player is editing Assault.\n\""
		);
		return;
	}

	for( i = pointCount;
		i < ASSAULT_MAX_POINTS;
		i++ ) {
		if( assault.markers[i] ) {
			G_FreeEntity( assault.markers[i] );
			assault.markers[i] = NULL;
		}

		assault.pointSet[i] = qfalse;
		assault.pointAreas[i] = 0;
		VectorClear( assault.points[i] );
	}

	assault.pointCount = pointCount;

	trap_SendServerCommand(
		-1,
		va(
			"print \"Assault will use %i point%s.\n\"",
			pointCount,
			pointCount == 1 ? "" : "s"
		)
	);
}

qboolean G_AssaultClientCommand(
	gentity_t *ent,
	const char *cmd
) {
	char arg[MAX_TOKEN_CHARS];
	int value;

	if( !G_AssaultEnabled() ) {
		return qfalse;
	}

	if( !Q_stricmp(cmd, "assault_set") ) {
		trap_Argv( 1, arg, sizeof(arg) );
		AssaultSetPointCount( ent, atoi(arg) );
		return qtrue;
	}

	if( !Q_stricmp(cmd, "assault_edit") ) {
		if( assault.phase != ASSAULT_SETUP ) {
			trap_SendServerCommand(
				ent - g_entities,
				"print \"The match has already started.\n\""
			);
			return qtrue;
		}

		AssaultClaimEditor( ent );
		return qtrue;
	}

	if( !Q_stricmp(cmd, "assault_place") ) {
		trap_Argv( 1, arg, sizeof(arg) );
		value = atoi(arg) - 1;
		AssaultPlacePoint( ent, value );
		return qtrue;
	}

	if( !Q_stricmp(cmd, "assault_ready") ) {
		AssaultStartMatch( ent );
		return qtrue;
	}

	return qfalse;
}

void G_AssaultInit( void ) {
	memset( &assault, 0, sizeof(assault) );

	assault.editorClient = -1;
	assault.phase = ASSAULT_SETUP;

	if( !G_AssaultEnabled() ) {
		return;
	}

	level.warmupTime = -1;
	trap_SetConfigstring( CS_WARMUP, "-1" );

if( g_assaultMode.integer == ASSAULT_MODE_BASE ||
	g_assaultMode.integer == ASSAULT_MODE_TDM_BASE ) {
	qboolean setupResult;

	assault.pointCount = 3;

	if( g_assaultMode.integer ==
		ASSAULT_MODE_TDM_BASE ) {
		setupResult =
			AssaultSetupTDMBasePoints();
	}
	else {
		setupResult =
			AssaultSetupBasePoints();
	}

	if( setupResult ) {
		G_Printf(
			"Assault: automatic points ready; waiting for teams.\n"
		);
	}
	else {
		G_Printf(
			"Assault: automatic setup failed.\n"
		);
	}

	return;
}

	assault.pointCount = ASSAULT_DEFAULT_POINTS;

	G_Printf(
		"Assault Editor: waiting for point placement.\n"
	);
}

qboolean G_AssaultBlocksWarmup( void ) {
	return G_AssaultEnabled() &&
		assault.phase == ASSAULT_SETUP;
}

qboolean G_AssaultControlsExitRules( void ) {
	return G_AssaultEnabled();
}

qboolean G_AssaultGetActiveGoal(
	vec3_t origin,
	int *area,
	team_t *attackingTeam
) {
	int point;

	if( !G_AssaultEnabled() ||
		(assault.phase != ASSAULT_ROUND_RED &&
		 assault.phase != ASSAULT_ROUND_BLUE) ) {
		return qfalse;
	}

	point = AssaultActualPoint();

	VectorCopy( assault.points[point], origin );
	*area = assault.pointAreas[point];
	*attackingTeam = assault.attackingTeam;

	return qtrue;
}

static void AssaultShowInstructions( void ) {
	int i;
	gentity_t *ent;

	for( i = 0; i < level.maxclients; i++ ) {
		ent = &g_entities[i];

		if( !ent->client ||
			ent->client->pers.connected != CON_CONNECTED ) {
			assault.instructionsShown[i] = qfalse;
			continue;
		}

		if( ent->r.svFlags & SVF_BOT ) {
			continue;
		}

		if( assault.instructionsShown[i] ) {
			continue;
		}

		assault.instructionsShown[i] = qtrue;

		trap_SendServerCommand(
			i,
			"print \"\n=== ASSAULT SETUP ===\n\""
		);
		trap_SendServerCommand(
			i,
			"print \"Set point count: /assault_set 1, 2 or 3\n\""
		);
		trap_SendServerCommand(
			i,
			"print \"Enter spectator mode: /team spectator\n\""
		);
		trap_SendServerCommand(
			i,
			"print \"Begin editing: /assault_edit\n\""
		);
		trap_SendServerCommand(
			i,
			"print \"Aim and place points: /assault_place 1|2|3\n\""
		);
		trap_SendServerCommand(
			i,
			"print \"After placement, join Red or Blue team.\n\""
		);
		trap_SendServerCommand(
			i,
			"print \"IMPORTANT: add bots before starting the match.\n\""
		);
		trap_SendServerCommand(
			i,
			"print \"Start the match: /assault_ready\n\n\""
		);
	}
}

static int AssaultCurrentHoldTime( void ) {
	int holdTime;
	int multiplier;

	multiplier = 1 << assault.activeStage;

	holdTime = (int)(
		g_assaultHoldTime.value *
		1000.0f *
		multiplier
	);

	if( holdTime < 1000 ) {
		holdTime = 1000;
	}

	return holdTime;
}

void G_AssaultRunFrame( void ) {
	int point;
	int attackers;
	int defenders;
	int frameTime;
	int holdTime;
	int quarter;

	if( !G_AssaultEnabled() ) {
		return;
	}

if( assault.phase == ASSAULT_SETUP ) {
	if( g_assaultMode.integer ==
		ASSAULT_MODE_EDITOR ) {
		AssaultShowInstructions();

		if( assault.editorClient >= 0 &&
			level.clients[assault.editorClient].
				pers.connected != CON_CONNECTED ) {
			assault.editorClient = -1;
		}

		return;
	}

	if( !assault.pointSet[0] ||
		!assault.pointSet[1] ||
		!assault.pointSet[2] ) {
		return;
	}

	if( TeamCount(-1, TEAM_RED) < 1 ||
		TeamCount(-1, TEAM_BLUE) < 1 ) {
		assault.autoStartTime = 0;
		return;
	}

	if( !assault.autoStartTime ) {
		assault.autoStartTime =
			level.time + ASSAULT_AUTO_START_DELAY;

		trap_SendServerCommand(
			-1,
			"cp \"Base Assault starts in 2 seconds\""
		);
		return;
	}

	if( level.time >= assault.autoStartTime ) {
		assault.autoStartTime = 0;
		AssaultStartMatch( NULL );
	}

	return;
}

	if( assault.phase != ASSAULT_ROUND_RED &&
		assault.phase != ASSAULT_ROUND_BLUE ) {
		return;
	}

	if( level.time - assault.roundStartTime >=
		assault.roundLimit ) {
		trap_SendServerCommand(
			-1,
			"cp \"Assault round time expired\""
		);
		AssaultStoreRoundResult( qfalse );
		return;
	}

	frameTime = level.time - assault.lastFrameTime;
	assault.lastFrameTime = level.time;

	if( frameTime < 0 ) {
		frameTime = 0;
	}
	else if( frameTime > 200 ) {
		frameTime = 200;
	}

	point = AssaultActualPoint();

	AssaultCountPlayers(
		point,
		&attackers,
		&defenders
	);

	if( attackers > 0 && defenders == 0 ) {
		assault.captureProgress += frameTime;
	}
	else if( attackers == 0 ) {
		assault.captureProgress -= frameTime / 2;

		if( assault.captureProgress < 0 ) {
			assault.captureProgress = 0;
		}
	}

	holdTime = AssaultCurrentHoldTime();

	quarter =
		(assault.captureProgress * 4) / holdTime;

	if( quarter > assault.announcedQuarter &&
		quarter < 4 ) {
		assault.announcedQuarter = quarter;

		trap_SendServerCommand(
			-1,
			va(
				"cp \"Point %s: %i%%\"",
				AssaultPointName(point),
				quarter * 25
			)
		);
	}

	if( assault.captureProgress >= holdTime ) {
		AssaultCompletePoint();
	}
}
