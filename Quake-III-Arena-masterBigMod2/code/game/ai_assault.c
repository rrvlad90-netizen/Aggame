#include "g_local.h"
#include "botlib.h"
#include "be_aas.h"
#include "be_ea.h"
#include "be_ai_char.h"
#include "be_ai_chat.h"
#include "be_ai_gen.h"
#include "be_ai_goal.h"
#include "be_ai_move.h"
#include "be_ai_weap.h"

#include "ai_main.h"
#include "ai_assault.h"

/*
 * BotTeam is implemented in ai_dmq3.c.
 * Declaring it here avoids including the large ai_dmq3.h.
 */
int BotTeam( bot_state_t *bs );

void BotAssaultSeekGoals( bot_state_t *bs ) {
	vec3_t origin;
	int area;
	team_t attackingTeam;
	int team;

	if( !G_AssaultGetActiveGoal(
		origin,
		&area,
		&attackingTeam
	) ) {
		if( bs->ltgtype == LTG_ASSAULT_ATTACK ||
			bs->ltgtype == LTG_ASSAULT_DEFEND ) {
			bs->ltgtype = 0;
		}

		return;
	}

	team = BotTeam( bs );

	memset(
		&bs->teamgoal,
		0,
		sizeof(bs->teamgoal)
	);

	VectorCopy(
		origin,
		bs->teamgoal.origin
	);

	VectorSet(
		bs->teamgoal.mins,
		-32,
		-32,
		-24
	);

	VectorSet(
		bs->teamgoal.maxs,
		32,
		32,
		48
	);

	bs->teamgoal.areanum = area;
	bs->teamgoal.entitynum = ENTITYNUM_NONE;
	bs->teamgoal_time = FloatTime() + 3600;
	bs->ordered = qfalse;
	bs->decisionmaker = bs->client;

	if( team == attackingTeam ) {
		bs->ltgtype = LTG_ASSAULT_ATTACK;
	}
	else {
		bs->ltgtype = LTG_ASSAULT_DEFEND;
	}
}
