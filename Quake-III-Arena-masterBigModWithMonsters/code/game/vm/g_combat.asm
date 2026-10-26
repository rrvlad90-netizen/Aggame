export ScorePlum
code
proc ScorePlum 12 8
file "../g_combat.c"
line 33
;1:/*
;2:===========================================================================
;3:Copyright (C) 1999-2005 Id Software, Inc.
;4:
;5:This file is part of Quake III Arena source code.
;6:
;7:Quake III Arena source code is free software; you can redistribute it
;8:and/or modify it under the terms of the GNU General Public License as
;9:published by the Free Software Foundation; either version 2 of the License,
;10:or (at your option) any later version.
;11:
;12:Quake III Arena source code is distributed in the hope that it will be
;13:useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
;14:MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;15:GNU General Public License for more details.
;16:
;17:You should have received a copy of the GNU General Public License
;18:along with Foobar; if not, write to the Free Software
;19:Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;20:===========================================================================
;21:*/
;22://
;23:// g_combat.c
;24:
;25:#include "g_local.h"
;26:
;27:
;28:/*
;29:============
;30:ScorePlum
;31:============
;32:*/
;33:void ScorePlum( gentity_t *ent, vec3_t origin, int score ) {
line 36
;34:	gentity_t *plum;
;35:
;36:	plum = G_TempEntity( origin, EV_SCOREPLUM );
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 65
ARGI4
ADDRLP4 4
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 38
;37:	// only send this temp entity to a single client
;38:	plum->r.svFlags |= SVF_SINGLECLIENT;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 256
BORI4
ASGNI4
line 39
;39:	plum->r.singleClient = ent->s.number;
ADDRLP4 0
INDIRP4
CNSTI4 428
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 41
;40:	//
;41:	plum->s.otherEntityNum = ent->s.number;
ADDRLP4 0
INDIRP4
CNSTI4 140
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 42
;42:	plum->s.time = score;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 43
;43:}
LABELV $56
endproc ScorePlum 12 8
export AddScore
proc AddScore 8 12
line 52
;44:
;45:/*
;46:============
;47:AddScore
;48:
;49:Adds score to both the client and his team
;50:============
;51:*/
;52:void AddScore( gentity_t *ent, vec3_t origin, int score ) {
line 53
;53:	if ( !ent->client ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $58
line 54
;54:		return;
ADDRGP4 $57
JUMPV
LABELV $58
line 57
;55:	}
;56:	// no scoring during pre-match warmup
;57:	if ( level.warmupTime ) {
ADDRGP4 level+16
INDIRI4
CNSTI4 0
EQI4 $60
line 58
;58:		return;
ADDRGP4 $57
JUMPV
LABELV $60
line 61
;59:	}
;60:	// show score plum
;61:	ScorePlum(ent, origin, score);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 ScorePlum
CALLV
pop
line 63
;62:	//
;63:	ent->client->ps.persistant[PERS_SCORE] += score;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 248
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
ASGNI4
line 64
;64:	if ( g_gametype.integer == GT_TEAM )
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $63
line 65
;65:		level.teamScores[ ent->client->ps.persistant[PERS_TEAM] ] += score;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 260
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 level+44
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
ASGNI4
LABELV $63
line 66
;66:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 67
;67:}
LABELV $57
endproc AddScore 8 12
export TossClientItems
proc TossClientItems 44 12
line 76
;68:
;69:/*
;70:=================
;71:TossClientItems
;72:
;73:Toss the weapon and powerups for the killed player
;74:=================
;75:*/
;76:void TossClientItems( gentity_t *self ) {
line 84
;77:	gitem_t		*item;
;78:	int			weapon;
;79:	float		angle;
;80:	int			i;
;81:	gentity_t	*drop;
;82:
;83:	// drop the weapon if not a gauntlet or machinegun
;84:	weapon = self->s.weapon;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ASGNI4
line 90
;85:
;86:	// make a special check to see if they are changing to a new
;87:	// weapon that isn't the mg or gauntlet.  Without this, a client
;88:	// can pick up a weapon, be killed, and not drop the weapon because
;89:	// their weapon change hasn't completed yet and they are still holding the MG.
;90:	if ( weapon == WP_MACHINEGUN || weapon == WP_GRAPPLING_HOOK ) {
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $70
ADDRLP4 12
INDIRI4
CNSTI4 10
NEI4 $68
LABELV $70
line 91
;91:		if ( self->client->ps.weaponstate == WEAPON_DROPPING ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
CNSTI4 2
NEI4 $71
line 92
;92:			weapon = self->client->pers.cmd.weapon;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 492
ADDP4
INDIRU1
CVUI4 1
ASGNI4
line 93
;93:		}
LABELV $71
line 94
;94:		if ( !( self->client->ps.stats[STAT_WEAPONS] & ( 1 << weapon ) ) ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 1
ADDRLP4 12
INDIRI4
LSHI4
BANDI4
CNSTI4 0
NEI4 $73
line 95
;95:			weapon = WP_NONE;
ADDRLP4 12
CNSTI4 0
ASGNI4
line 96
;96:		}
LABELV $73
line 97
;97:	}
LABELV $68
line 103
;98:
;99:	/*
;100:	 * Machinegun can also be dropped in Scavenger mode.
;101:	 */
;102:	if(
;103:		(
ADDRLP4 28
CNSTI4 2
ASGNI4
ADDRLP4 12
INDIRI4
ADDRLP4 28
INDIRI4
GTI4 $78
ADDRGP4 g_scavengerWeapons+12
INDIRI4
CNSTI4 0
EQI4 $75
ADDRLP4 12
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $75
LABELV $78
ADDRLP4 12
INDIRI4
CNSTI4 10
EQI4 $75
ADDRLP4 12
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 376
ADDP4
ADDP4
INDIRI4
CNSTI4 0
EQI4 $75
line 112
;104:			weapon > WP_MACHINEGUN ||
;105:			(
;106:				g_scavengerWeapons.integer &&
;107:				weapon == WP_MACHINEGUN
;108:			)
;109:		) &&
;110:		weapon != WP_GRAPPLING_HOOK &&
;111:		self->client->ps.ammo[weapon]
;112:	) {
line 114
;113:		// find the item type for this weapon
;114:		item = BG_FindItemForWeapon( weapon );
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 BG_FindItemForWeapon
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 36
INDIRP4
ASGNP4
line 117
;115:
;116:		// spawn the item
;117:		Drop_Item( self, item, 0 );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 Drop_Item
CALLP4
pop
line 118
;118:	}
LABELV $75
line 121
;119:
;120:	// drop all the powerups if not in teamplay
;121:	if ( g_gametype.integer != GT_TEAM ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
EQI4 $79
line 122
;122:		angle = 45;
ADDRLP4 16
CNSTF4 1110704128
ASGNF4
line 123
;123:		for ( i = 1 ; i < PW_NUM_POWERUPS ; i++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $82
line 124
;124:			if ( self->client->ps.powerups[ i ] > level.time ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
ADDRGP4 level+32
INDIRI4
LEI4 $86
line 125
;125:				item = BG_FindItemForPowerup( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 36
INDIRP4
ASGNP4
line 126
;126:				if ( !item ) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $89
line 127
;127:					continue;
ADDRGP4 $83
JUMPV
LABELV $89
line 129
;128:				}
;129:				drop = Drop_Item( self, item, angle );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 40
ADDRGP4 Drop_Item
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 40
INDIRP4
ASGNP4
line 131
;130:				// decide how many seconds it has left
;131:				drop->count = ( self->client->ps.powerups[ i ] - level.time ) / 1000;
ADDRLP4 4
INDIRP4
CNSTI4 760
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
ADDRGP4 level+32
INDIRI4
SUBI4
CNSTI4 1000
DIVI4
ASGNI4
line 132
;132:				if ( drop->count < 1 ) {
ADDRLP4 4
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
CNSTI4 1
GEI4 $92
line 133
;133:					drop->count = 1;
ADDRLP4 4
INDIRP4
CNSTI4 760
ADDP4
CNSTI4 1
ASGNI4
line 134
;134:				}
LABELV $92
line 135
;135:				angle += 45;
ADDRLP4 16
ADDRLP4 16
INDIRF4
CNSTF4 1110704128
ADDF4
ASGNF4
line 136
;136:			}
LABELV $86
line 137
;137:		}
LABELV $83
line 123
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 15
LTI4 $82
line 138
;138:	}
LABELV $79
line 139
;139:}
LABELV $67
endproc TossClientItems 44 12
export LookAtKiller
proc LookAtKiller 52 4
line 229
;140:
;141:#ifdef MISSIONPACK
;142:
;143:/*
;144:=================
;145:TossClientCubes
;146:=================
;147:*/
;148:extern gentity_t	*neutralObelisk;
;149:
;150:void TossClientCubes( gentity_t *self ) {
;151:	gitem_t		*item;
;152:	gentity_t	*drop;
;153:	vec3_t		velocity;
;154:	vec3_t		angles;
;155:	vec3_t		origin;
;156:
;157:	self->client->ps.generic1 = 0;
;158:
;159:	// this should never happen but we should never
;160:	// get the server to crash due to skull being spawned in
;161:	if (!G_EntitiesFree()) {
;162:		return;
;163:	}
;164:
;165:	if( self->client->sess.sessionTeam == TEAM_RED ) {
;166:		item = BG_FindItem( "Red Cube" );
;167:	}
;168:	else {
;169:		item = BG_FindItem( "Blue Cube" );
;170:	}
;171:
;172:	angles[YAW] = (float)(level.time % 360);
;173:	angles[PITCH] = 0;	// always forward
;174:	angles[ROLL] = 0;
;175:
;176:	AngleVectors( angles, velocity, NULL, NULL );
;177:	VectorScale( velocity, 150, velocity );
;178:	velocity[2] += 200 + crandom() * 50;
;179:
;180:	if( neutralObelisk ) {
;181:		VectorCopy( neutralObelisk->s.pos.trBase, origin );
;182:		origin[2] += 44;
;183:	} else {
;184:		VectorClear( origin ) ;
;185:	}
;186:
;187:	drop = LaunchItem( item, origin, velocity );
;188:
;189:	drop->nextthink = level.time + g_cubeTimeout.integer * 1000;
;190:	drop->think = G_FreeEntity;
;191:	drop->spawnflags = self->client->sess.sessionTeam;
;192:}
;193:
;194:
;195:/*
;196:=================
;197:TossClientPersistantPowerups
;198:=================
;199:*/
;200:void TossClientPersistantPowerups( gentity_t *ent ) {
;201:	gentity_t	*powerup;
;202:
;203:	if( !ent->client ) {
;204:		return;
;205:	}
;206:
;207:	if( !ent->client->persistantPowerup ) {
;208:		return;
;209:	}
;210:
;211:	powerup = ent->client->persistantPowerup;
;212:
;213:	powerup->r.svFlags &= ~SVF_NOCLIENT;
;214:	powerup->s.eFlags &= ~EF_NODRAW;
;215:	powerup->r.contents = CONTENTS_TRIGGER;
;216:	trap_LinkEntity( powerup );
;217:
;218:	ent->client->ps.stats[STAT_PERSISTANT_POWERUP] = 0;
;219:	ent->client->persistantPowerup = NULL;
;220:}
;221:#endif
;222:
;223:
;224:/*
;225:==================
;226:LookAtKiller
;227:==================
;228:*/
;229:void LookAtKiller( gentity_t *self, gentity_t *inflictor, gentity_t *attacker ) {
line 233
;230:	vec3_t		dir;
;231:	vec3_t		angles;
;232:
;233:	if ( attacker && attacker != self ) {
ADDRLP4 24
ADDRFP4 8
INDIRP4
CVPU4 4
ASGNU4
ADDRLP4 24
INDIRU4
CNSTU4 0
EQU4 $95
ADDRLP4 24
INDIRU4
ADDRFP4 0
INDIRP4
CVPU4 4
EQU4 $95
line 234
;234:		VectorSubtract (attacker->s.pos.trBase, self->s.pos.trBase, dir);
ADDRLP4 28
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 32
CNSTI4 24
ASGNI4
ADDRLP4 36
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 28
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
ADDRLP4 36
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 40
CNSTI4 28
ASGNI4
ADDRLP4 0+4
ADDRLP4 28
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRF4
ADDRLP4 36
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 44
CNSTI4 32
ASGNI4
ADDRLP4 0+8
ADDRFP4 8
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 235
;235:	} else if ( inflictor && inflictor != self ) {
ADDRGP4 $96
JUMPV
LABELV $95
ADDRLP4 28
ADDRFP4 4
INDIRP4
CVPU4 4
ASGNU4
ADDRLP4 28
INDIRU4
CNSTU4 0
EQU4 $99
ADDRLP4 28
INDIRU4
ADDRFP4 0
INDIRP4
CVPU4 4
EQU4 $99
line 236
;236:		VectorSubtract (inflictor->s.pos.trBase, self->s.pos.trBase, dir);
ADDRLP4 32
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 36
CNSTI4 24
ASGNI4
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 32
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
INDIRF4
ADDRLP4 40
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 44
CNSTI4 28
ASGNI4
ADDRLP4 0+4
ADDRLP4 32
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
ADDRLP4 40
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 48
CNSTI4 32
ASGNI4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 237
;237:	} else {
ADDRGP4 $100
JUMPV
LABELV $99
line 238
;238:		self->client->ps.stats[STAT_DEAD_YAW] = self->s.angles[YAW];
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 32
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 200
ADDP4
ADDRLP4 32
INDIRP4
CNSTI4 120
ADDP4
INDIRF4
CVFI4 4
ASGNI4
line 239
;239:		return;
ADDRGP4 $94
JUMPV
LABELV $100
LABELV $96
line 242
;240:	}
;241:
;242:	self->client->ps.stats[STAT_DEAD_YAW] = vectoyaw ( dir );
ADDRLP4 0
ARGP4
ADDRLP4 32
ADDRGP4 vectoyaw
CALLF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 200
ADDP4
ADDRLP4 32
INDIRF4
CVFI4 4
ASGNI4
line 244
;243:
;244:	angles[YAW] = vectoyaw ( dir );
ADDRLP4 0
ARGP4
ADDRLP4 36
ADDRGP4 vectoyaw
CALLF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 36
INDIRF4
ASGNF4
line 245
;245:	angles[PITCH] = 0; 
ADDRLP4 12
CNSTF4 0
ASGNF4
line 246
;246:	angles[ROLL] = 0;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 247
;247:}
LABELV $94
endproc LookAtKiller 52 4
export GibEntity
proc GibEntity 12 12
line 254
;248:
;249:/*
;250:==================
;251:GibEntity
;252:==================
;253:*/
;254:void GibEntity( gentity_t *self, int killer ) {
line 259
;255:	gentity_t *ent;
;256:	int i;
;257:
;258:	//if this entity still has kamikaze
;259:	if (self->s.eFlags & EF_KAMIKAZE) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 512
BANDI4
CNSTI4 0
EQI4 $106
line 261
;260:		// check if there is a kamikaze timer around for this owner
;261:		for (i = 0; i < MAX_GENTITIES; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $108
line 262
;262:			ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 263
;263:			if (!ent->inuse)
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $112
line 264
;264:				continue;
ADDRGP4 $109
JUMPV
LABELV $112
line 265
;265:			if (ent->activator != self)
ADDRLP4 0
INDIRP4
CNSTI4 772
ADDP4
INDIRP4
CVPU4 4
ADDRFP4 0
INDIRP4
CVPU4 4
EQU4 $114
line 266
;266:				continue;
ADDRGP4 $109
JUMPV
LABELV $114
line 267
;267:			if (strcmp(ent->classname, "kamikaze timer"))
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRP4
ARGP4
ADDRGP4 $118
ARGP4
ADDRLP4 8
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $116
line 268
;268:				continue;
ADDRGP4 $109
JUMPV
LABELV $116
line 269
;269:			G_FreeEntity(ent);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 270
;270:			break;
ADDRGP4 $110
JUMPV
LABELV $109
line 261
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 1024
LTI4 $108
LABELV $110
line 272
;271:		}
;272:	}
LABELV $106
line 273
;273:	G_AddEvent( self, EV_GIB_PLAYER, killer );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 274
;274:	self->takedamage = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 275
;275:	self->s.eType = ET_INVISIBLE;
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 10
ASGNI4
line 276
;276:	self->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 277
;277:}
LABELV $105
endproc GibEntity 12 12
export body_die
proc body_die 0 8
line 284
;278:
;279:/*
;280:==================
;281:body_die
;282:==================
;283:*/
;284:void body_die( gentity_t *self, gentity_t *inflictor, gentity_t *attacker, int damage, int meansOfDeath ) {
line 285
;285:	if ( self->health > GIB_HEALTH ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -40
LEI4 $120
line 286
;286:		return;
ADDRGP4 $119
JUMPV
LABELV $120
line 288
;287:	}
;288:	if ( !g_blood.integer ) {
ADDRGP4 g_blood+12
INDIRI4
CNSTI4 0
NEI4 $122
line 289
;289:		self->health = GIB_HEALTH+1;
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
CNSTI4 -39
ASGNI4
line 290
;290:		return;
ADDRGP4 $119
JUMPV
LABELV $122
line 293
;291:	}
;292:
;293:	GibEntity( self, 0 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 GibEntity
CALLV
pop
line 294
;294:}
LABELV $119
endproc body_die 0 8
data
export modNames
align 4
LABELV modNames
address $125
address $126
address $127
address $128
address $129
address $130
address $131
address $132
address $133
address $134
address $135
address $136
address $137
address $138
address $139
address $140
address $141
address $142
address $143
address $144
address $145
address $146
address $147
address $148
export CheckAlmostCapture
code
proc CheckAlmostCapture 56 12
line 368
;295:
;296:
;297:// these are just for logging, the client prints its own messages
;298:char	*modNames[] = {
;299:	"MOD_UNKNOWN",
;300:	"MOD_SHOTGUN",
;301:	"MOD_GAUNTLET",
;302:	"MOD_MACHINEGUN",
;303:	"MOD_GRENADE",
;304:	"MOD_GRENADE_SPLASH",
;305:	"MOD_ROCKET",
;306:	"MOD_ROCKET_SPLASH",
;307:	"MOD_PLASMA",
;308:	"MOD_PLASMA_SPLASH",
;309:	"MOD_RAILGUN",
;310:	"MOD_LIGHTNING",
;311:	"MOD_BFG",
;312:	"MOD_BFG_SPLASH",
;313:	"MOD_WATER",
;314:	"MOD_SLIME",
;315:	"MOD_LAVA",
;316:	"MOD_CRUSH",
;317:	"MOD_TELEFRAG",
;318:	"MOD_FALLING",
;319:	"MOD_SUICIDE",
;320:	"MOD_TARGET_LASER",
;321:	"MOD_TRIGGER_HURT",
;322:#ifdef MISSIONPACK
;323:	"MOD_NAIL",
;324:	"MOD_CHAINGUN",
;325:	"MOD_PROXIMITY_MINE",
;326:	"MOD_KAMIKAZE",
;327:	"MOD_JUICED",
;328:#endif
;329:	"MOD_GRAPPLE"
;330:};
;331:
;332:#ifdef MISSIONPACK
;333:/*
;334:==================
;335:Kamikaze_DeathActivate
;336:==================
;337:*/
;338:void Kamikaze_DeathActivate( gentity_t *ent ) {
;339:	G_StartKamikaze(ent);
;340:	G_FreeEntity(ent);
;341:}
;342:
;343:/*
;344:==================
;345:Kamikaze_DeathTimer
;346:==================
;347:*/
;348:void Kamikaze_DeathTimer( gentity_t *self ) {
;349:	gentity_t *ent;
;350:
;351:	ent = G_Spawn();
;352:	ent->classname = "kamikaze timer";
;353:	VectorCopy(self->s.pos.trBase, ent->s.pos.trBase);
;354:	ent->r.svFlags |= SVF_NOCLIENT;
;355:	ent->think = Kamikaze_DeathActivate;
;356:	ent->nextthink = level.time + 5 * 1000;
;357:
;358:	ent->activator = self;
;359:}
;360:
;361:#endif
;362:
;363:/*
;364:==================
;365:CheckAlmostCapture
;366:==================
;367:*/
;368:void CheckAlmostCapture( gentity_t *self, gentity_t *attacker ) {
line 374
;369:	gentity_t	*ent;
;370:	vec3_t		dir;
;371:	char		*classname;
;372:
;373:	// if this player was carrying a flag
;374:	if ( self->client->ps.powerups[PW_REDFLAG] ||
ADDRLP4 20
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRLP4 20
INDIRP4
CNSTI4 340
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $153
ADDRLP4 20
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $153
ADDRLP4 20
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
EQI4 $150
LABELV $153
line 376
;375:		self->client->ps.powerups[PW_BLUEFLAG] ||
;376:		self->client->ps.powerups[PW_NEUTRALFLAG] ) {
line 378
;377:		// get the goal flag this player should have been going for
;378:		if ( g_gametype.integer == GT_CTF ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
NEI4 $154
line 379
;379:			if ( self->client->sess.sessionTeam == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 2
NEI4 $157
line 380
;380:				classname = "team_CTF_blueflag";
ADDRLP4 4
ADDRGP4 $159
ASGNP4
line 381
;381:			}
ADDRGP4 $155
JUMPV
LABELV $157
line 382
;382:			else {
line 383
;383:				classname = "team_CTF_redflag";
ADDRLP4 4
ADDRGP4 $160
ASGNP4
line 384
;384:			}
line 385
;385:		}
ADDRGP4 $155
JUMPV
LABELV $154
line 386
;386:		else {
line 387
;387:			if ( self->client->sess.sessionTeam == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 2
NEI4 $161
line 388
;388:				classname = "team_CTF_redflag";
ADDRLP4 4
ADDRGP4 $160
ASGNP4
line 389
;389:			}
ADDRGP4 $162
JUMPV
LABELV $161
line 390
;390:			else {
line 391
;391:				classname = "team_CTF_blueflag";
ADDRLP4 4
ADDRGP4 $159
ASGNP4
line 392
;392:			}
LABELV $162
line 393
;393:		}
LABELV $155
line 394
;394:		ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
LABELV $163
line 396
;395:		do
;396:		{
line 397
;397:			ent = G_Find(ent, FOFS(classname), classname);
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 28
INDIRP4
ASGNP4
line 398
;398:		} while (ent && (ent->flags & FL_DROPPED_ITEM));
LABELV $164
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $166
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
NEI4 $163
LABELV $166
line 400
;399:		// if we found the destination flag and it's not picked up
;400:		if (ent && !(ent->r.svFlags & SVF_NOCLIENT) ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $167
ADDRLP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $167
line 402
;401:			// if the player was *very* close
;402:			VectorSubtract( self->client->ps.origin, ent->s.origin, dir );
ADDRLP4 36
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
ASGNP4
ADDRLP4 8
ADDRLP4 36
INDIRP4
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 8+4
ADDRLP4 36
INDIRP4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 8+8
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
SUBF4
ASGNF4
line 403
;403:			if ( VectorLength(dir) < 200 ) {
ADDRLP4 8
ARGP4
ADDRLP4 44
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 44
INDIRF4
CNSTF4 1128792064
GEF4 $171
line 404
;404:				self->client->ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_HOLYSHIT;
ADDRLP4 48
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 268
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRI4
CNSTI4 4
BXORI4
ASGNI4
line 405
;405:				if ( attacker->client ) {
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $173
line 406
;406:					attacker->client->ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_HOLYSHIT;
ADDRLP4 52
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 268
ADDP4
ASGNP4
ADDRLP4 52
INDIRP4
ADDRLP4 52
INDIRP4
INDIRI4
CNSTI4 4
BXORI4
ASGNI4
line 407
;407:				}
LABELV $173
line 408
;408:			}
LABELV $171
line 409
;409:		}
LABELV $167
line 410
;410:	}
LABELV $150
line 411
;411:}
LABELV $149
endproc CheckAlmostCapture 56 12
export CheckAlmostScored
proc CheckAlmostScored 44 12
line 418
;412:
;413:/*
;414:==================
;415:CheckAlmostScored
;416:==================
;417:*/
;418:void CheckAlmostScored( gentity_t *self, gentity_t *attacker ) {
line 424
;419:	gentity_t	*ent;
;420:	vec3_t		dir;
;421:	char		*classname;
;422:
;423:	// if the player was carrying cubes
;424:	if ( self->client->ps.generic1 ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 440
ADDP4
INDIRI4
CNSTI4 0
EQI4 $176
line 425
;425:		if ( self->client->sess.sessionTeam == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 2
NEI4 $178
line 426
;426:			classname = "team_redobelisk";
ADDRLP4 16
ADDRGP4 $180
ASGNP4
line 427
;427:		}
ADDRGP4 $179
JUMPV
LABELV $178
line 428
;428:		else {
line 429
;429:			classname = "team_blueobelisk";
ADDRLP4 16
ADDRGP4 $181
ASGNP4
line 430
;430:		}
LABELV $179
line 431
;431:		ent = G_Find(NULL, FOFS(classname), classname);
CNSTP4 0
ARGP4
CNSTI4 524
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20
INDIRP4
ASGNP4
line 433
;432:		// if we found the destination obelisk
;433:		if ( ent ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $182
line 435
;434:			// if the player was *very* close
;435:			VectorSubtract( self->client->ps.origin, ent->s.origin, dir );
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
ASGNP4
ADDRLP4 28
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 24
INDIRP4
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRLP4 28
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 24
INDIRP4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 28
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
SUBF4
ASGNF4
line 436
;436:			if ( VectorLength(dir) < 200 ) {
ADDRLP4 4
ARGP4
ADDRLP4 32
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 32
INDIRF4
CNSTF4 1128792064
GEF4 $186
line 437
;437:				self->client->ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_HOLYSHIT;
ADDRLP4 36
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 268
ADDP4
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 36
INDIRP4
INDIRI4
CNSTI4 4
BXORI4
ASGNI4
line 438
;438:				if ( attacker->client ) {
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $188
line 439
;439:					attacker->client->ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_HOLYSHIT;
ADDRLP4 40
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 268
ADDP4
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 4
BXORI4
ASGNI4
line 440
;440:				}
LABELV $188
line 441
;441:			}
LABELV $186
line 442
;442:		}
LABELV $182
line 443
;443:	}
LABELV $176
line 444
;444:}
LABELV $175
endproc CheckAlmostScored 44 12
bss
align 4
LABELV $277
skip 4
export player_die
code
proc player_die 100 28
line 457
;445:
;446:/*
;447:==================
;448:player_die
;449:==================
;450:*/
;451:void player_die(
;452:	gentity_t *self,
;453:	gentity_t *inflictor,
;454:	gentity_t *attacker,
;455:	int damage,
;456:	int meansOfDeath
;457:) {
line 466
;458:	gentity_t	*ent;
;459:	int			anim;
;460:	int			contents;
;461:	int			killer;
;462:	int			i;
;463:	char		*killerName;
;464:	char		*obit;
;465:
;466:	if (self->client->ps.pm_type == PM_DEAD) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 3
NEI4 $191
line 467
;467:		return;
ADDRGP4 $190
JUMPV
LABELV $191
line 470
;468:	}
;469:
;470:	if (level.intermissiontime) {
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $193
line 471
;471:		return;
ADDRGP4 $190
JUMPV
LABELV $193
line 475
;472:	}
;473:
;474:	// check for an almost capture
;475:	CheckAlmostCapture(self, attacker);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CheckAlmostCapture
CALLV
pop
line 476
;476:	CheckAlmostScored(self, attacker);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CheckAlmostScored
CALLV
pop
line 478
;477:
;478:	if (self->client && self->client->hook) {
ADDRLP4 28
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 32
CNSTU4 0
ASGNU4
ADDRLP4 28
INDIRP4
CVPU4 4
ADDRLP4 32
INDIRU4
EQU4 $196
ADDRLP4 28
INDIRP4
CNSTI4 764
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 32
INDIRU4
EQU4 $196
line 479
;479:		Weapon_HookFree(self->client->hook);
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 764
ADDP4
INDIRP4
ARGP4
ADDRGP4 Weapon_HookFree
CALLV
pop
line 480
;480:	}
LABELV $196
line 491
;481:
;482:#ifdef MISSIONPACK
;483:	if ((self->client->ps.eFlags & EF_TICKING) &&
;484:		self->activator) {
;485:		self->client->ps.eFlags &= ~EF_TICKING;
;486:		self->activator->think = G_FreeEntity;
;487:		self->activator->nextthink = level.time;
;488:	}
;489:#endif
;490:
;491:	self->client->ps.pm_type = PM_DEAD;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 3
ASGNI4
line 493
;492:
;493:	if (attacker) {
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $198
line 494
;494:		killer = attacker->s.number;
ADDRLP4 4
ADDRFP4 8
INDIRP4
INDIRI4
ASGNI4
line 496
;495:
;496:		if (attacker->client) {
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $200
line 497
;497:			killerName =
ADDRLP4 16
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 512
ADDP4
ASGNP4
line 499
;498:				attacker->client->pers.netname;
;499:		}
ADDRGP4 $199
JUMPV
LABELV $200
line 500
;500:		else if (attacker->s.eType == ET_MONSTER) {
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
NEI4 $202
line 501
;501:			killerName = "<monster>";
ADDRLP4 16
ADDRGP4 $204
ASGNP4
line 502
;502:		}
ADDRGP4 $199
JUMPV
LABELV $202
line 503
;503:		else {
line 504
;504:			killerName = "<non-client>";
ADDRLP4 16
ADDRGP4 $205
ASGNP4
line 505
;505:		}
line 506
;506:	}
ADDRGP4 $199
JUMPV
LABELV $198
line 507
;507:	else {
line 508
;508:		killer = ENTITYNUM_WORLD;
ADDRLP4 4
CNSTI4 1022
ASGNI4
line 509
;509:		killerName = "<world>";
ADDRLP4 16
ADDRGP4 $206
ASGNP4
line 510
;510:	}
LABELV $199
line 512
;511:
;512:	if (killer < 0 || killer >= MAX_CLIENTS) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $209
ADDRLP4 4
INDIRI4
CNSTI4 64
LTI4 $207
LABELV $209
line 513
;513:		killer = ENTITYNUM_WORLD;
ADDRLP4 4
CNSTI4 1022
ASGNI4
line 514
;514:	}
LABELV $207
line 516
;515:
;516:	if (meansOfDeath < 0 ||
ADDRLP4 40
ADDRFP4 16
INDIRI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
LTI4 $212
ADDRLP4 40
INDIRI4
CVIU4 4
CNSTU4 24
LTU4 $210
LABELV $212
line 518
;517:		meansOfDeath >=
;518:			sizeof(modNames) / sizeof(modNames[0])) {
line 519
;519:		obit = "<bad obituary>";
ADDRLP4 20
ADDRGP4 $213
ASGNP4
line 520
;520:	}
ADDRGP4 $211
JUMPV
LABELV $210
line 521
;521:	else {
line 522
;522:		obit = modNames[meansOfDeath];
ADDRLP4 20
ADDRFP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 modNames
ADDP4
INDIRP4
ASGNP4
line 523
;523:	}
LABELV $211
line 525
;524:
;525:	G_LogPrintf(
ADDRGP4 $214
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 44
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 44
INDIRP4
INDIRI4
ARGI4
ADDRFP4 16
INDIRI4
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 44
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 G_LogPrintf
CALLV
pop
line 536
;526:		"Kill: %i %i %i: %s killed %s by %s\n",
;527:		killer,
;528:		self->s.number,
;529:		meansOfDeath,
;530:		killerName,
;531:		self->client->pers.netname,
;532:		obit
;533:	);
;534:
;535:	// broadcast the death event to everyone
;536:	ent = G_TempEntity(
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
CNSTI4 60
ARGI4
ADDRLP4 48
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 48
INDIRP4
ASGNP4
line 541
;537:		self->r.currentOrigin,
;538:		EV_OBITUARY
;539:	);
;540:
;541:	ent->s.eventParm = meansOfDeath;
ADDRLP4 8
INDIRP4
CNSTI4 184
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
line 542
;542:	ent->s.otherEntityNum = self->s.number;
ADDRLP4 8
INDIRP4
CNSTI4 140
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 543
;543:	ent->s.otherEntityNum2 = killer;
ADDRLP4 8
INDIRP4
CNSTI4 144
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 544
;544:	ent->r.svFlags = SVF_BROADCAST;
ADDRLP4 8
INDIRP4
CNSTI4 424
ADDP4
CNSTI4 32
ASGNI4
line 546
;545:
;546:	self->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 548
;547:
;548:	self->client->ps.persistant[PERS_KILLED]++;
ADDRLP4 52
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 280
ADDP4
ASGNP4
ADDRLP4 52
INDIRP4
ADDRLP4 52
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 550
;549:
;550:	if( attacker && attacker->client ) {
ADDRLP4 56
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 60
CNSTU4 0
ASGNU4
ADDRLP4 56
INDIRP4
CVPU4 4
ADDRLP4 60
INDIRU4
EQU4 $215
ADDRLP4 56
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 60
INDIRU4
EQU4 $215
line 551
;551:	attacker->client->lastkilled_client =
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 724
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 554
;552:		self->s.number;
;553:
;554:	if( attacker == self ||
ADDRLP4 64
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 68
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 64
INDIRP4
CVPU4 4
ADDRLP4 68
INDIRP4
CVPU4 4
EQU4 $219
ADDRLP4 68
INDIRP4
ARGP4
ADDRLP4 64
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 OnSameTeam
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $217
LABELV $219
line 555
;555:		OnSameTeam(self, attacker) ) {
line 560
;556:		/*
;557:		 * Monster Hunt One Life preserves the player's
;558:		 * contribution score after any death.
;559:		 */
;560:		if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 2
EQI4 $216
line 561
;561:			MONSTER_HUNT_ONE_LIFE ) {
line 562
;562:			AddScore(
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 AddScore
CALLV
pop
line 567
;563:				attacker,
;564:				self->r.currentOrigin,
;565:				-1
;566:			);
;567:		}
line 568
;568:	}
ADDRGP4 $216
JUMPV
LABELV $217
line 569
;569:	else {
line 570
;570:		AddScore(
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 AddScore
CALLV
pop
line 576
;571:			attacker,
;572:			self->r.currentOrigin,
;573:			1
;574:		);
;575:
;576:		if( meansOfDeath == MOD_GAUNTLET ) {
ADDRFP4 16
INDIRI4
CNSTI4 2
NEI4 $223
line 577
;577:			attacker->client->ps.persistant[
ADDRLP4 76
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 300
ADDP4
ASGNP4
ADDRLP4 76
INDIRP4
ADDRLP4 76
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 581
;578:				PERS_GAUNTLET_FRAG_COUNT
;579:			]++;
;580:
;581:			attacker->client->ps.eFlags &=
ADDRLP4 80
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 80
INDIRP4
ADDRLP4 80
INDIRP4
INDIRI4
CNSTI4 -231497
BANDI4
ASGNI4
line 589
;582:				~(EF_AWARD_IMPRESSIVE |
;583:				  EF_AWARD_EXCELLENT |
;584:				  EF_AWARD_GAUNTLET |
;585:				  EF_AWARD_ASSIST |
;586:				  EF_AWARD_DEFEND |
;587:				  EF_AWARD_CAP);
;588:
;589:			attacker->client->ps.eFlags |=
ADDRLP4 84
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 592
;590:				EF_AWARD_GAUNTLET;
;591:
;592:			attacker->client->rewardTime =
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 748
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 2000
ADDI4
ASGNI4
line 596
;593:				level.time +
;594:				REWARD_SPRITE_TIME;
;595:
;596:			self->client->ps.persistant[
ADDRLP4 88
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 268
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRI4
CNSTI4 2
BXORI4
ASGNI4
line 599
;597:				PERS_PLAYEREVENTS
;598:			] ^= PLAYEREVENT_GAUNTLETREWARD;
;599:		}
LABELV $223
line 601
;600:
;601:		if( level.time -
ADDRGP4 level+32
INDIRI4
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 756
ADDP4
INDIRI4
SUBI4
CNSTI4 3000
GEI4 $226
line 603
;602:			attacker->client->lastKillTime <
;603:			CARNAGE_REWARD_TIME ) {
line 604
;604:			attacker->client->ps.persistant[
ADDRLP4 76
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 288
ADDP4
ASGNP4
ADDRLP4 76
INDIRP4
ADDRLP4 76
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 608
;605:				PERS_EXCELLENT_COUNT
;606:			]++;
;607:
;608:			attacker->client->ps.eFlags &=
ADDRLP4 80
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 80
INDIRP4
ADDRLP4 80
INDIRP4
INDIRI4
CNSTI4 -231497
BANDI4
ASGNI4
line 616
;609:				~(EF_AWARD_IMPRESSIVE |
;610:				  EF_AWARD_EXCELLENT |
;611:				  EF_AWARD_GAUNTLET |
;612:				  EF_AWARD_ASSIST |
;613:				  EF_AWARD_DEFEND |
;614:				  EF_AWARD_CAP);
;615:
;616:			attacker->client->ps.eFlags |=
ADDRLP4 84
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRI4
CNSTI4 8
BORI4
ASGNI4
line 619
;617:				EF_AWARD_EXCELLENT;
;618:
;619:			attacker->client->rewardTime =
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 748
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 2000
ADDI4
ASGNI4
line 622
;620:				level.time +
;621:				REWARD_SPRITE_TIME;
;622:		}
LABELV $226
line 624
;623:
;624:		attacker->client->lastKillTime =
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 756
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 626
;625:			level.time;
;626:	}
line 627
;627:}
ADDRGP4 $216
JUMPV
LABELV $215
line 628
;628:else {
line 634
;629:	/*
;630:	 * Classic Monster Hunt treats monsters and world
;631:	 * damage like ordinary hazards. One Life preserves
;632:	 * the player's contribution score.
;633:	 */
;634:	if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 2
EQI4 $231
line 635
;635:		MONSTER_HUNT_ONE_LIFE ) {
line 636
;636:		AddScore(
ADDRLP4 64
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 64
INDIRP4
ARGP4
ADDRLP4 64
INDIRP4
CNSTI4 488
ADDP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 AddScore
CALLV
pop
line 641
;637:			self,
;638:			self->r.currentOrigin,
;639:			-1
;640:		);
;641:	}
LABELV $231
line 642
;642:}
LABELV $216
line 645
;643:
;644:// Add standard team bonuses.
;645:	Team_FragBonuses(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 Team_FragBonuses
CALLV
pop
line 652
;646:		self,
;647:		inflictor,
;648:		attacker
;649:	);
;650:
;651:	// if I committed suicide, the flag does not fall
;652:	if (meansOfDeath == MOD_SUICIDE) {
ADDRFP4 16
INDIRI4
CNSTI4 20
NEI4 $234
line 653
;653:		if (self->client->ps.powerups[PW_NEUTRALFLAG]) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
CNSTI4 0
EQI4 $236
line 654
;654:			Team_ReturnFlag(TEAM_FREE);
CNSTI4 0
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 655
;655:			self->client->ps.powerups[
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 348
ADDP4
CNSTI4 0
ASGNI4
line 658
;656:				PW_NEUTRALFLAG
;657:			] = 0;
;658:		}
ADDRGP4 $237
JUMPV
LABELV $236
line 659
;659:		else if (self->client->ps.powerups[PW_REDFLAG]) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 340
ADDP4
INDIRI4
CNSTI4 0
EQI4 $238
line 660
;660:			Team_ReturnFlag(TEAM_RED);
CNSTI4 1
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 661
;661:			self->client->ps.powerups[
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 340
ADDP4
CNSTI4 0
ASGNI4
line 664
;662:				PW_REDFLAG
;663:			] = 0;
;664:		}
ADDRGP4 $239
JUMPV
LABELV $238
line 665
;665:		else if (self->client->ps.powerups[PW_BLUEFLAG]) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
CNSTI4 0
EQI4 $240
line 666
;666:			Team_ReturnFlag(TEAM_BLUE);
CNSTI4 2
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 667
;667:			self->client->ps.powerups[
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 344
ADDP4
CNSTI4 0
ASGNI4
line 670
;668:				PW_BLUEFLAG
;669:			] = 0;
;670:		}
LABELV $240
LABELV $239
LABELV $237
line 671
;671:	}
LABELV $234
line 673
;672:
;673:	contents = trap_PointContents(
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 64
ADDRGP4 trap_PointContents
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 64
INDIRI4
ASGNI4
line 678
;674:		self->r.currentOrigin,
;675:		-1
;676:	);
;677:
;678:	if (!(contents & CONTENTS_NODROP)) {
ADDRLP4 12
INDIRI4
CVIU4 4
CNSTU4 2147483648
BANDU4
CNSTU4 0
NEU4 $242
line 679
;679:		TossClientItems(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 TossClientItems
CALLV
pop
line 680
;680:	}
ADDRGP4 $243
JUMPV
LABELV $242
line 681
;681:	else {
line 682
;682:		if (self->client->ps.powerups[
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
CNSTI4 0
EQI4 $244
line 684
;683:			PW_NEUTRALFLAG
;684:		]) {
line 685
;685:			Team_ReturnFlag(TEAM_FREE);
CNSTI4 0
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 686
;686:		}
ADDRGP4 $245
JUMPV
LABELV $244
line 687
;687:		else if (self->client->ps.powerups[
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 340
ADDP4
INDIRI4
CNSTI4 0
EQI4 $246
line 689
;688:			PW_REDFLAG
;689:		]) {
line 690
;690:			Team_ReturnFlag(TEAM_RED);
CNSTI4 1
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 691
;691:		}
ADDRGP4 $247
JUMPV
LABELV $246
line 692
;692:		else if (self->client->ps.powerups[
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
CNSTI4 0
EQI4 $248
line 694
;693:			PW_BLUEFLAG
;694:		]) {
line 695
;695:			Team_ReturnFlag(TEAM_BLUE);
CNSTI4 2
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 696
;696:		}
LABELV $248
LABELV $247
LABELV $245
line 697
;697:	}
LABELV $243
line 707
;698:
;699:#ifdef MISSIONPACK
;700:	TossClientPersistantPowerups(self);
;701:
;702:	if (g_gametype.integer == GT_HARVESTER) {
;703:		TossClientCubes(self);
;704:	}
;705:#endif
;706:
;707:	Cmd_Score_f(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 Cmd_Score_f
CALLV
pop
line 709
;708:
;709:	for (i = 0; i < level.maxclients; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $253
JUMPV
LABELV $250
line 712
;710:		gclient_t *client;
;711:
;712:		client = &level.clients[i];
ADDRLP4 68
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 714
;713:
;714:		if (client->pers.connected != CON_CONNECTED) {
ADDRLP4 68
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $255
line 715
;715:			continue;
ADDRGP4 $251
JUMPV
LABELV $255
line 718
;716:		}
;717:
;718:		if (client->sess.sessionTeam !=
ADDRLP4 68
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $257
line 719
;719:			TEAM_SPECTATOR) {
line 720
;720:			continue;
ADDRGP4 $251
JUMPV
LABELV $257
line 723
;721:		}
;722:
;723:		if (client->sess.spectatorClient ==
ADDRLP4 68
INDIRP4
CNSTI4 628
ADDP4
INDIRI4
ADDRFP4 0
INDIRP4
INDIRI4
NEI4 $259
line 724
;724:			self->s.number) {
line 725
;725:			Cmd_Score_f(g_entities + i);
CNSTI4 884
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ARGP4
ADDRGP4 Cmd_Score_f
CALLV
pop
line 726
;726:		}
LABELV $259
line 727
;727:	}
LABELV $251
line 709
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $253
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $250
line 730
;728:
;729:	// corpse can still be gibbed
;730:	self->takedamage = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 732
;731:
;732:	self->s.weapon = WP_NONE;
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 733
;733:	self->s.powerups = 0;
ADDRFP4 0
INDIRP4
CNSTI4 188
ADDP4
CNSTI4 0
ASGNI4
line 734
;734:	self->r.contents = CONTENTS_CORPSE;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 67108864
ASGNI4
line 736
;735:
;736:	self->s.angles[0] = 0;
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTF4 0
ASGNF4
line 737
;737:	self->s.angles[2] = 0;
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
CNSTF4 0
ASGNF4
line 739
;738:
;739:	LookAtKiller(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 LookAtKiller
CALLV
pop
line 745
;740:		self,
;741:		inflictor,
;742:		attacker
;743:	);
;744:
;745:	VectorCopy(
ADDRLP4 68
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 68
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 152
ADDP4
ADDRLP4 68
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 750
;746:		self->s.angles,
;747:		self->client->ps.viewangles
;748:	);
;749:
;750:	self->s.loopSound = 0;
ADDRFP4 0
INDIRP4
CNSTI4 156
ADDP4
CNSTI4 0
ASGNI4
line 751
;751:	self->r.maxs[2] = -8;
ADDRFP4 0
INDIRP4
CNSTI4 456
ADDP4
CNSTF4 3238002688
ASGNF4
line 756
;752:	/*
;753:	 * Monster Hunt One Life uses a fixed corpse delay.
;754:	 * The configurable respawn delay must not postpone elimination.
;755:	 */
;756:	if( g_monsterHunt.integer == MONSTER_HUNT_ONE_LIFE ) {
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 2
NEI4 $261
line 757
;757:		self->client->respawnTime = level.time + 1700;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 736
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1700
ADDI4
ASGNI4
line 758
;758:	}
ADDRGP4 $262
JUMPV
LABELV $261
line 759
;759:	else if( g_respawnTime.value > 0.0f ) {
ADDRGP4 g_respawnTime+8
INDIRF4
CNSTF4 0
LEF4 $265
line 760
;760:		self->client->respawnTime =
CNSTF4 1056964608
ARGF4
CNSTF4 1114636288
ARGF4
ADDRGP4 g_respawnTime+8
INDIRF4
ARGF4
ADDRLP4 72
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 736
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTF4 1148846080
ADDRLP4 72
INDIRF4
MULF4
CVFI4 4
ADDI4
ASGNI4
line 769
;761:			level.time +
;762:			(int)(
;763:				Com_Clamp(
;764:					0.5f,
;765:					60.0f,
;766:					g_respawnTime.value
;767:				) * 1000.0f
;768:			);
;769:	}
ADDRGP4 $266
JUMPV
LABELV $265
line 770
;770:	else {
line 771
;771:		self->client->respawnTime = level.time + 1700;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 736
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1700
ADDI4
ASGNI4
line 772
;772:	}
LABELV $266
LABELV $262
line 774
;773:
;774:	memset(
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 312
ADDP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 64
ARGI4
ADDRGP4 memset
CALLP4
pop
line 780
;775:		self->client->ps.powerups,
;776:		0,
;777:		sizeof(self->client->ps.powerups)
;778:	);
;779:
;780:	if ((self->health <= GIB_HEALTH &&
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -40
GTI4 $276
ADDRLP4 12
INDIRI4
CVIU4 4
CNSTU4 2147483648
BANDU4
CNSTU4 0
NEU4 $276
ADDRGP4 g_blood+12
INDIRI4
CNSTI4 0
NEI4 $274
LABELV $276
ADDRFP4 16
INDIRI4
CNSTI4 20
NEI4 $271
LABELV $274
line 783
;781:		 !(contents & CONTENTS_NODROP) &&
;782:		 g_blood.integer) ||
;783:		meansOfDeath == MOD_SUICIDE) {
line 784
;784:		GibEntity(self, killer);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 GibEntity
CALLV
pop
line 785
;785:	}
ADDRGP4 $272
JUMPV
LABELV $271
line 786
;786:	else {
line 790
;787:		static int deathAnimation;
;788:		int selectedAnimation;
;789:
;790:		switch (deathAnimation) {
ADDRLP4 76
ADDRGP4 $277
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $280
ADDRLP4 76
INDIRI4
CNSTI4 1
EQI4 $281
ADDRLP4 76
INDIRI4
CNSTI4 2
EQI4 $282
ADDRGP4 $278
JUMPV
LABELV $280
line 792
;791:		case 0:
;792:			selectedAnimation = BOTH_DEATH1;
ADDRLP4 72
CNSTI4 0
ASGNI4
line 793
;793:			break;
ADDRGP4 $279
JUMPV
LABELV $281
line 796
;794:
;795:		case 1:
;796:			selectedAnimation = BOTH_DEATH2;
ADDRLP4 72
CNSTI4 2
ASGNI4
line 797
;797:			break;
ADDRGP4 $279
JUMPV
LABELV $282
LABELV $278
line 801
;798:
;799:		case 2:
;800:		default:
;801:			selectedAnimation = BOTH_DEATH3;
ADDRLP4 72
CNSTI4 4
ASGNI4
line 802
;802:			break;
LABELV $279
line 805
;803:		}
;804:
;805:		if (self->health <= GIB_HEALTH) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -40
GTI4 $283
line 806
;806:			self->health = GIB_HEALTH + 1;
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
CNSTI4 -39
ASGNI4
line 807
;807:		}
LABELV $283
line 809
;808:
;809:		self->client->ps.legsAnim =
ADDRLP4 80
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 84
CNSTI4 128
ASGNI4
ADDRLP4 80
INDIRP4
ADDRLP4 80
INDIRP4
INDIRI4
ADDRLP4 84
INDIRI4
BANDI4
ADDRLP4 84
INDIRI4
BXORI4
ADDRLP4 72
INDIRI4
BORI4
ASGNI4
line 815
;810:			((self->client->ps.legsAnim &
;811:			  ANIM_TOGGLEBIT) ^
;812:			 ANIM_TOGGLEBIT) |
;813:			selectedAnimation;
;814:
;815:		self->client->ps.torsoAnim =
ADDRLP4 88
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 84
ADDP4
ASGNP4
ADDRLP4 92
CNSTI4 128
ASGNI4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRI4
ADDRLP4 92
INDIRI4
BANDI4
ADDRLP4 92
INDIRI4
BXORI4
ADDRLP4 72
INDIRI4
BORI4
ASGNI4
line 821
;816:			((self->client->ps.torsoAnim &
;817:			  ANIM_TOGGLEBIT) ^
;818:			 ANIM_TOGGLEBIT) |
;819:			selectedAnimation;
;820:
;821:		G_AddEvent(
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $277
INDIRI4
CNSTI4 57
ADDI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 827
;822:			self,
;823:			EV_DEATH1 + deathAnimation,
;824:			killer
;825:		);
;826:
;827:		self->die = body_die;
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 body_die
ASGNP4
line 829
;828:
;829:		deathAnimation =
ADDRLP4 96
ADDRGP4 $277
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
CNSTI4 3
MODI4
ASGNI4
line 837
;830:			(deathAnimation + 1) % 3;
;831:
;832:#ifdef MISSIONPACK
;833:		if (self->s.eFlags & EF_KAMIKAZE) {
;834:			Kamikaze_DeathTimer(self);
;835:		}
;836:#endif
;837:	}
LABELV $272
line 839
;838:
;839:	trap_LinkEntity(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 840
;840:}
LABELV $190
endproc player_die 100 28
export CheckArmor
proc CheckArmor 20 4
line 849
;841:
;842:
;843:/*
;844:================
;845:CheckArmor
;846:================
;847:*/
;848:int CheckArmor (gentity_t *ent, int damage, int dflags)
;849:{
line 854
;850:	gclient_t	*client;
;851:	int			save;
;852:	int			count;
;853:
;854:	if (!damage)
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $286
line 855
;855:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $286
line 857
;856:
;857:	client = ent->client;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 859
;858:
;859:	if (!client)
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $288
line 860
;860:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $288
line 862
;861:
;862:	if (dflags & DAMAGE_NO_ARMOR)
ADDRFP4 8
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $290
line 863
;863:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $290
line 866
;864:
;865:	// armor
;866:	count = client->ps.stats[STAT_ARMOR];
ADDRLP4 8
ADDRLP4 4
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ASGNI4
line 867
;867:	save = ceil( damage * ARMOR_PROTECTION );
CNSTF4 1059648963
ADDRFP4 4
INDIRI4
CVIF4 4
MULF4
ARGF4
ADDRLP4 12
ADDRGP4 ceil
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 12
INDIRF4
CVFI4 4
ASGNI4
line 868
;868:	if (save >= count)
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $292
line 869
;869:		save = count;
ADDRLP4 0
ADDRLP4 8
INDIRI4
ASGNI4
LABELV $292
line 871
;870:
;871:	if (!save)
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $294
line 872
;872:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $294
line 874
;873:
;874:	client->ps.stats[STAT_ARMOR] -= save;
ADDRLP4 16
ADDRLP4 4
INDIRP4
CNSTI4 196
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
ADDRLP4 0
INDIRI4
SUBI4
ASGNI4
line 876
;875:
;876:	return save;
ADDRLP4 0
INDIRI4
RETI4
LABELV $285
endproc CheckArmor 20 4
export RaySphereIntersections
proc RaySphereIntersections 96 4
line 884
;877:}
;878:
;879:/*
;880:================
;881:RaySphereIntersections
;882:================
;883:*/
;884:int RaySphereIntersections( vec3_t origin, float radius, vec3_t point, vec3_t dir, vec3_t intersections[2] ) {
line 893
;885:	float b, c, d, t;
;886:
;887:	//	| origin - (point + t * dir) | = radius
;888:	//	a = dir[0]^2 + dir[1]^2 + dir[2]^2;
;889:	//	b = 2 * (dir[0] * (point[0] - origin[0]) + dir[1] * (point[1] - origin[1]) + dir[2] * (point[2] - origin[2]));
;890:	//	c = (point[0] - origin[0])^2 + (point[1] - origin[1])^2 + (point[2] - origin[2])^2 - radius^2;
;891:
;892:	// normalize dir so a = 1
;893:	VectorNormalize(dir);
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 894
;894:	b = 2 * (dir[0] * (point[0] - origin[0]) + dir[1] * (point[1] - origin[1]) + dir[2] * (point[2] - origin[2]));
ADDRLP4 16
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 20
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
CNSTI4 4
ASGNI4
ADDRLP4 32
CNSTI4 8
ASGNI4
ADDRLP4 4
CNSTF4 1073741824
ADDRLP4 16
INDIRP4
INDIRF4
ADDRLP4 20
INDIRP4
INDIRF4
ADDRLP4 24
INDIRP4
INDIRF4
SUBF4
MULF4
ADDRLP4 16
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRF4
ADDRLP4 20
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRF4
ADDRLP4 24
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRF4
SUBF4
MULF4
ADDF4
ADDRLP4 16
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
ADDRLP4 20
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
ADDRLP4 24
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
SUBF4
MULF4
ADDF4
MULF4
ASGNF4
line 895
;895:	c = (point[0] - origin[0]) * (point[0] - origin[0]) +
ADDRLP4 36
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 44
ADDRLP4 36
INDIRP4
INDIRF4
ADDRLP4 40
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 48
CNSTI4 4
ASGNI4
ADDRLP4 52
ADDRLP4 36
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
ADDRLP4 40
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56
CNSTI4 8
ASGNI4
ADDRLP4 60
ADDRLP4 36
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
INDIRF4
ADDRLP4 40
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 64
ADDRFP4 4
INDIRF4
ASGNF4
ADDRLP4 12
ADDRLP4 44
INDIRF4
ADDRLP4 44
INDIRF4
MULF4
ADDRLP4 52
INDIRF4
ADDRLP4 52
INDIRF4
MULF4
ADDF4
ADDRLP4 60
INDIRF4
ADDRLP4 60
INDIRF4
MULF4
ADDF4
ADDRLP4 64
INDIRF4
ADDRLP4 64
INDIRF4
MULF4
SUBF4
ASGNF4
line 900
;896:		(point[1] - origin[1]) * (point[1] - origin[1]) +
;897:		(point[2] - origin[2]) * (point[2] - origin[2]) -
;898:		radius * radius;
;899:
;900:	d = b * b - 4 * c;
ADDRLP4 8
ADDRLP4 4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
CNSTF4 1082130432
ADDRLP4 12
INDIRF4
MULF4
SUBF4
ASGNF4
line 901
;901:	if (d > 0) {
ADDRLP4 8
INDIRF4
CNSTF4 0
LEF4 $297
line 902
;902:		t = (- b + sqrt(d)) / 2;
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 72
ADDRGP4 sqrt
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
NEGF4
ADDRLP4 72
INDIRF4
ADDF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 903
;903:		VectorMA(point, t, dir, intersections[0]);
ADDRFP4 16
INDIRP4
ADDRFP4 8
INDIRP4
INDIRF4
ADDRFP4 12
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 76
CNSTI4 4
ASGNI4
ADDRFP4 16
INDIRP4
ADDRLP4 76
INDIRI4
ADDP4
ADDRFP4 8
INDIRP4
ADDRLP4 76
INDIRI4
ADDP4
INDIRF4
ADDRFP4 12
INDIRP4
ADDRLP4 76
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 80
CNSTI4 8
ASGNI4
ADDRFP4 16
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
ADDRFP4 8
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
INDIRF4
ADDRFP4 12
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
line 904
;904:		t = (- b - sqrt(d)) / 2;
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 84
ADDRGP4 sqrt
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
NEGF4
ADDRLP4 84
INDIRF4
SUBF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 905
;905:		VectorMA(point, t, dir, intersections[1]);
ADDRFP4 16
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 8
INDIRP4
INDIRF4
ADDRFP4 12
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 88
CNSTI4 4
ASGNI4
ADDRFP4 16
INDIRP4
CNSTI4 16
ADDP4
ADDRFP4 8
INDIRP4
ADDRLP4 88
INDIRI4
ADDP4
INDIRF4
ADDRFP4 12
INDIRP4
ADDRLP4 88
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 92
CNSTI4 8
ASGNI4
ADDRFP4 16
INDIRP4
CNSTI4 20
ADDP4
ADDRFP4 8
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRF4
ADDRFP4 12
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
line 906
;906:		return 2;
CNSTI4 2
RETI4
ADDRGP4 $296
JUMPV
LABELV $297
line 908
;907:	}
;908:	else if (d == 0) {
ADDRLP4 8
INDIRF4
CNSTF4 0
NEF4 $299
line 909
;909:		t = (- b ) / 2;
ADDRLP4 0
ADDRLP4 4
INDIRF4
NEGF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 910
;910:		VectorMA(point, t, dir, intersections[0]);
ADDRFP4 16
INDIRP4
ADDRFP4 8
INDIRP4
INDIRF4
ADDRFP4 12
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 72
CNSTI4 4
ASGNI4
ADDRFP4 16
INDIRP4
ADDRLP4 72
INDIRI4
ADDP4
ADDRFP4 8
INDIRP4
ADDRLP4 72
INDIRI4
ADDP4
INDIRF4
ADDRFP4 12
INDIRP4
ADDRLP4 72
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 76
CNSTI4 8
ASGNI4
ADDRFP4 16
INDIRP4
ADDRLP4 76
INDIRI4
ADDP4
ADDRFP4 8
INDIRP4
ADDRLP4 76
INDIRI4
ADDP4
INDIRF4
ADDRFP4 12
INDIRP4
ADDRLP4 76
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
line 911
;911:		return 1;
CNSTI4 1
RETI4
ADDRGP4 $296
JUMPV
LABELV $299
line 913
;912:	}
;913:	return 0;
CNSTI4 0
RETI4
LABELV $296
endproc RaySphereIntersections 96 4
export G_Damage
proc G_Damage 104 24
line 980
;914:}
;915:
;916:#ifdef MISSIONPACK
;917:/*
;918:================
;919:G_InvulnerabilityEffect
;920:================
;921:*/
;922:int G_InvulnerabilityEffect( gentity_t *targ, vec3_t dir, vec3_t point, vec3_t impactpoint, vec3_t bouncedir ) {
;923:	gentity_t	*impact;
;924:	vec3_t		intersections[2], vec;
;925:	int			n;
;926:
;927:	if ( !targ->client ) {
;928:		return qfalse;
;929:	}
;930:	VectorCopy(dir, vec);
;931:	VectorInverse(vec);
;932:	// sphere model radius = 42 units
;933:	n = RaySphereIntersections( targ->client->ps.origin, 42, point, vec, intersections);
;934:	if (n > 0) {
;935:		impact = G_TempEntity( targ->client->ps.origin, EV_INVUL_IMPACT );
;936:		VectorSubtract(intersections[0], targ->client->ps.origin, vec);
;937:		vectoangles(vec, impact->s.angles);
;938:		impact->s.angles[0] += 90;
;939:		if (impact->s.angles[0] > 360)
;940:			impact->s.angles[0] -= 360;
;941:		if ( impactpoint ) {
;942:			VectorCopy( intersections[0], impactpoint );
;943:		}
;944:		if ( bouncedir ) {
;945:			VectorCopy( vec, bouncedir );
;946:			VectorNormalize( bouncedir );
;947:		}
;948:		return qtrue;
;949:	}
;950:	else {
;951:		return qfalse;
;952:	}
;953:}
;954:#endif
;955:/*
;956:============
;957:T_Damage
;958:
;959:targ		entity that is being damaged
;960:inflictor	entity that is causing the damage
;961:attacker	entity that caused the inflictor to damage targ
;962:	example: targ=monster, inflictor=rocket, attacker=player
;963:
;964:dir			direction of the attack for knockback
;965:point		point at which the damage is being inflicted, used for headshots
;966:damage		amount of damage being inflicted
;967:knockback	force to be applied against targ as a result of the damage
;968:
;969:inflictor, attacker, dir, and point can be NULL for environmental effects
;970:
;971:dflags		these flags are used to control how T_Damage works
;972:	DAMAGE_RADIUS			damage was indirect (from a nearby explosion)
;973:	DAMAGE_NO_ARMOR			armor does not protect from this damage
;974:	DAMAGE_NO_KNOCKBACK		do not affect velocity, just view angles
;975:	DAMAGE_NO_PROTECTION	kills godmode, armor, everything
;976:============
;977:*/
;978:
;979:void G_Damage( gentity_t *targ, gentity_t *inflictor, gentity_t *attacker,
;980:			   vec3_t dir, vec3_t point, int damage, int dflags, int mod ) {
line 991
;981:	gclient_t	*client;
;982:	int			take;
;983:	int			save;
;984:	int			asave;
;985:	int			knockback;
;986:	int			max;
;987:#ifdef MISSIONPACK
;988:	vec3_t		bouncedir, impactpoint;
;989:#endif
;990:
;991:	if (!targ->takedamage) {
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
CNSTI4 0
NEI4 $302
line 992
;992:		return;
ADDRGP4 $301
JUMPV
LABELV $302
line 997
;993:	}
;994:
;995:	// the intermission has allready been qualified for, so don't
;996:	// allow any extra scoring
;997:	if ( level.intermissionQueued ) {
ADDRGP4 level+9124
INDIRI4
CNSTI4 0
EQI4 $304
line 998
;998:		return;
ADDRGP4 $301
JUMPV
LABELV $304
line 1010
;999:	}
;1000:#ifdef MISSIONPACK
;1001:	if ( targ->client && mod != MOD_JUICED) {
;1002:		if ( targ->client->invulnerabilityTime > level.time) {
;1003:			if ( dir && point ) {
;1004:				G_InvulnerabilityEffect( targ, dir, point, impactpoint, bouncedir );
;1005:			}
;1006:			return;
;1007:		}
;1008:	}
;1009:#endif
;1010:	if ( !inflictor ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $307
line 1011
;1011:		inflictor = &g_entities[ENTITYNUM_WORLD];
ADDRFP4 4
ADDRGP4 g_entities+903448
ASGNP4
line 1012
;1012:	}
LABELV $307
line 1013
;1013:	if ( !attacker ) {
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $310
line 1014
;1014:		attacker = &g_entities[ENTITYNUM_WORLD];
ADDRFP4 8
ADDRGP4 g_entities+903448
ASGNP4
line 1015
;1015:	}
LABELV $310
line 1022
;1016:
;1017:/*
;1018:	 * Cooperative Monster Hunt:
;1019:	 * players and bots are always allies.
;1020:	 * Self-damage remains enabled.
;1021:	 */
;1022:	if (g_monsterHunt.integer &&
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $313
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
CVPU4 4
ADDRLP4 28
INDIRP4
CVPU4 4
EQU4 $313
ADDRLP4 32
CNSTI4 516
ASGNI4
ADDRLP4 36
CNSTU4 0
ASGNU4
ADDRLP4 24
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 36
INDIRU4
EQU4 $313
ADDRLP4 28
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 36
INDIRU4
EQU4 $313
line 1025
;1023:		targ != attacker &&
;1024:		targ->client &&
;1025:		attacker->client) {
line 1026
;1026:		return;
ADDRGP4 $301
JUMPV
LABELV $313
line 1033
;1027:	}
;1028:
;1029:	/*
;1030:	 * Monsters must not kill each other with direct
;1031:	 * or splash damage.
;1032:	 */
;1033:	if (g_monsterHunt.integer &&
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $316
ADDRLP4 40
CNSTI4 4
ASGNI4
ADDRLP4 44
CNSTI4 13
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRI4
ADDRLP4 44
INDIRI4
NEI4 $316
ADDRFP4 8
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRI4
ADDRLP4 44
INDIRI4
NEI4 $316
line 1035
;1034:		targ->s.eType == ET_MONSTER &&
;1035:		attacker->s.eType == ET_MONSTER) {
line 1036
;1036:		return;
ADDRGP4 $301
JUMPV
LABELV $316
line 1040
;1037:	}
;1038:
;1039:	// shootable doors / buttons don't actually have any health
;1040:	if ( targ->s.eType == ET_MOVER ) {
ADDRLP4 48
CNSTI4 4
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
NEI4 $319
line 1041
;1041:		if ( targ->use && targ->moverState == MOVER_POS1 ) {
ADDRLP4 52
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 52
INDIRP4
CNSTI4 708
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $301
ADDRLP4 52
INDIRP4
CNSTI4 576
ADDP4
INDIRI4
CNSTI4 0
NEI4 $301
line 1042
;1042:			targ->use( targ, inflictor, attacker );
ADDRLP4 56
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 56
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 56
INDIRP4
CNSTI4 708
ADDP4
INDIRP4
CALLV
pop
line 1043
;1043:		}
line 1044
;1044:		return;
ADDRGP4 $301
JUMPV
LABELV $319
line 1053
;1045:	}
;1046:#ifdef MISSIONPACK
;1047:	if( g_gametype.integer == GT_OBELISK && CheckObeliskAttack( targ, attacker ) ) {
;1048:		return;
;1049:	}
;1050:#endif
;1051:	// reduce damage by the attacker's handicap value
;1052:	// unless they are rocket jumping
;1053:	if ( attacker->client && attacker != targ ) {
ADDRLP4 52
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 52
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $323
ADDRLP4 52
INDIRP4
CVPU4 4
ADDRFP4 0
INDIRP4
CVPU4 4
EQU4 $323
line 1054
;1054:		max = attacker->client->ps.stats[STAT_MAX_HEALTH];
ADDRLP4 20
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
ASGNI4
line 1060
;1055:#ifdef MISSIONPACK
;1056:		if( bg_itemlist[attacker->client->ps.stats[STAT_PERSISTANT_POWERUP]].giTag == PW_GUARD ) {
;1057:			max /= 2;
;1058:		}
;1059:#endif
;1060:		damage = damage * max / 100;
ADDRFP4 20
ADDRFP4 20
INDIRI4
ADDRLP4 20
INDIRI4
MULI4
CNSTI4 100
DIVI4
ASGNI4
line 1061
;1061:	}
LABELV $323
line 1063
;1062:
;1063:	client = targ->client;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 1065
;1064:
;1065:	if ( client ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $325
line 1066
;1066:		if ( client->noclip ) {
ADDRLP4 0
INDIRP4
CNSTI4 648
ADDP4
INDIRI4
CNSTI4 0
EQI4 $327
line 1067
;1067:			return;
ADDRGP4 $301
JUMPV
LABELV $327
line 1069
;1068:		}
;1069:	}
LABELV $325
line 1071
;1070:
;1071:	if ( !dir ) {
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $329
line 1072
;1072:		dflags |= DAMAGE_NO_KNOCKBACK;
ADDRFP4 24
ADDRFP4 24
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 1073
;1073:	} else {
ADDRGP4 $330
JUMPV
LABELV $329
line 1074
;1074:		VectorNormalize(dir);
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 1075
;1075:	}
LABELV $330
line 1077
;1076:
;1077:	knockback = damage;
ADDRLP4 4
ADDRFP4 20
INDIRI4
ASGNI4
line 1078
;1078:	if ( knockback > 200 ) {
ADDRLP4 4
INDIRI4
CNSTI4 200
LEI4 $331
line 1079
;1079:		knockback = 200;
ADDRLP4 4
CNSTI4 200
ASGNI4
line 1080
;1080:	}
LABELV $331
line 1081
;1081:	if ( targ->flags & FL_NO_KNOCKBACK ) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 2048
BANDI4
CNSTI4 0
EQI4 $333
line 1082
;1082:		knockback = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1083
;1083:	}
LABELV $333
line 1084
;1084:	if ( dflags & DAMAGE_NO_KNOCKBACK ) {
ADDRFP4 24
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $335
line 1085
;1085:		knockback = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1086
;1086:	}
LABELV $335
line 1089
;1087:
;1088:	// figure momentum add, even if the damage won't be taken
;1089:	if ( knockback && targ->client ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $337
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $337
line 1093
;1090:		vec3_t	kvel;
;1091:		float	mass;
;1092:
;1093:		mass = 200;
ADDRLP4 68
CNSTF4 1128792064
ASGNF4
line 1095
;1094:
;1095:		VectorScale (dir, g_knockback.value * (float)knockback / mass, kvel);
ADDRLP4 72
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 76
ADDRLP4 4
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 80
ADDRLP4 68
INDIRF4
ASGNF4
ADDRLP4 56
ADDRLP4 72
INDIRP4
INDIRF4
ADDRGP4 g_knockback+8
INDIRF4
ADDRLP4 76
INDIRF4
MULF4
ADDRLP4 80
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 56+4
ADDRLP4 72
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 g_knockback+8
INDIRF4
ADDRLP4 76
INDIRF4
MULF4
ADDRLP4 80
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 56+8
ADDRFP4 12
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 g_knockback+8
INDIRF4
ADDRLP4 4
INDIRI4
CVIF4 4
MULF4
ADDRLP4 68
INDIRF4
DIVF4
MULF4
ASGNF4
line 1096
;1096:		VectorAdd (targ->client->ps.velocity, kvel, targ->client->ps.velocity);
ADDRLP4 84
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 32
ADDP4
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRF4
ADDRLP4 56
INDIRF4
ADDF4
ASGNF4
ADDRLP4 88
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 36
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRF4
ADDRLP4 56+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 92
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 40
ADDP4
ASGNP4
ADDRLP4 92
INDIRP4
ADDRLP4 92
INDIRP4
INDIRF4
ADDRLP4 56+8
INDIRF4
ADDF4
ASGNF4
line 1100
;1097:
;1098:		// set the timer so that the other client can't cancel
;1099:		// out the movement immediately
;1100:		if ( !targ->client->ps.pm_time ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 0
NEI4 $346
line 1103
;1101:			int		t;
;1102:
;1103:			t = knockback * 2;
ADDRLP4 96
ADDRLP4 4
INDIRI4
CNSTI4 1
LSHI4
ASGNI4
line 1104
;1104:			if ( t < 50 ) {
ADDRLP4 96
INDIRI4
CNSTI4 50
GEI4 $348
line 1105
;1105:				t = 50;
ADDRLP4 96
CNSTI4 50
ASGNI4
line 1106
;1106:			}
LABELV $348
line 1107
;1107:			if ( t > 200 ) {
ADDRLP4 96
INDIRI4
CNSTI4 200
LEI4 $350
line 1108
;1108:				t = 200;
ADDRLP4 96
CNSTI4 200
ASGNI4
line 1109
;1109:			}
LABELV $350
line 1110
;1110:			targ->client->ps.pm_time = t;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 16
ADDP4
ADDRLP4 96
INDIRI4
ASGNI4
line 1111
;1111:			targ->client->ps.pm_flags |= PMF_TIME_KNOCKBACK;
ADDRLP4 100
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 100
INDIRP4
ADDRLP4 100
INDIRP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 1112
;1112:		}
LABELV $346
line 1113
;1113:	}
LABELV $337
line 1116
;1114:
;1115:	// check for completely getting out of the damage
;1116:	if ( !(dflags & DAMAGE_NO_PROTECTION) ) {
ADDRFP4 24
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
NEI4 $352
line 1123
;1117:
;1118:		// if TF_NO_FRIENDLY_FIRE is set, don't do damage to the target
;1119:		// if the attacker was on the same team
;1120:#ifdef MISSIONPACK
;1121:		if ( mod != MOD_JUICED && targ != attacker && !(dflags & DAMAGE_NO_TEAM_PROTECTION) && OnSameTeam (targ, attacker)  ) {
;1122:#else	
;1123:		if ( targ != attacker && OnSameTeam (targ, attacker)  ) {
ADDRLP4 56
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 60
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 56
INDIRP4
CVPU4 4
ADDRLP4 60
INDIRP4
CVPU4 4
EQU4 $354
ADDRLP4 56
INDIRP4
ARGP4
ADDRLP4 60
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 OnSameTeam
CALLI4
ASGNI4
ADDRLP4 64
INDIRI4
CNSTI4 0
EQI4 $354
line 1125
;1124:#endif
;1125:			if ( !g_friendlyFire.integer ) {
ADDRGP4 g_friendlyFire+12
INDIRI4
CNSTI4 0
NEI4 $356
line 1126
;1126:				return;
ADDRGP4 $301
JUMPV
LABELV $356
line 1128
;1127:			}
;1128:		}
LABELV $354
line 1141
;1129:#ifdef MISSIONPACK
;1130:		if (mod == MOD_PROXIMITY_MINE) {
;1131:			if (inflictor && inflictor->parent && OnSameTeam(targ, inflictor->parent)) {
;1132:				return;
;1133:			}
;1134:			if (targ == attacker) {
;1135:				return;
;1136:			}
;1137:		}
;1138:#endif
;1139:
;1140:		// check for godmode
;1141:		if ( targ->flags & FL_GODMODE ) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $359
line 1142
;1142:			return;
ADDRGP4 $301
JUMPV
LABELV $359
line 1144
;1143:		}
;1144:	}
LABELV $352
line 1148
;1145:
;1146:	// battlesuit protects from all radius damage (but takes knockback)
;1147:	// and protects 50% against all damage
;1148:	if ( client && client->ps.powerups[PW_BATTLESUIT] ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $361
ADDRLP4 0
INDIRP4
CNSTI4 320
ADDP4
INDIRI4
CNSTI4 0
EQI4 $361
line 1149
;1149:		G_AddEvent( targ, EV_POWERUP_BATTLESUIT, 0 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 62
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 1150
;1150:		if ( ( dflags & DAMAGE_RADIUS ) || ( mod == MOD_FALLING ) ) {
ADDRFP4 24
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $365
ADDRFP4 28
INDIRI4
CNSTI4 19
NEI4 $363
LABELV $365
line 1151
;1151:			return;
ADDRGP4 $301
JUMPV
LABELV $363
line 1153
;1152:		}
;1153:		damage *= 0.5;
ADDRFP4 20
CNSTF4 1056964608
ADDRFP4 20
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 1154
;1154:	}
LABELV $361
line 1158
;1155:
;1156:	// add to the attacker's hit counter (if the target isn't a general entity like a prox mine)
;1157:	//if ( attacker->client && targ != attacker && targ->health > 0
;1158:	if ( attacker->client && targ->client && targ != attacker && targ->health > 0
ADDRLP4 60
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 64
CNSTI4 516
ASGNI4
ADDRLP4 68
CNSTU4 0
ASGNU4
ADDRLP4 60
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 68
INDIRU4
EQU4 $366
ADDRLP4 72
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 72
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 68
INDIRU4
EQU4 $366
ADDRLP4 72
INDIRP4
CVPU4 4
ADDRLP4 60
INDIRP4
CVPU4 4
EQU4 $366
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 72
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 76
INDIRI4
LEI4 $366
ADDRLP4 80
ADDRLP4 72
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 3
EQI4 $366
ADDRLP4 80
INDIRI4
ADDRLP4 76
INDIRI4
EQI4 $366
line 1160
;1159:			&& targ->s.eType != ET_MISSILE
;1160:			&& targ->s.eType != ET_GENERAL) {
line 1161
;1161:		if ( OnSameTeam( targ, attacker ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 84
ADDRGP4 OnSameTeam
CALLI4
ASGNI4
ADDRLP4 84
INDIRI4
CNSTI4 0
EQI4 $368
line 1162
;1162:			attacker->client->ps.persistant[PERS_HITS]--;
ADDRLP4 88
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 252
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1163
;1163:		} else {
ADDRGP4 $369
JUMPV
LABELV $368
line 1164
;1164:			attacker->client->ps.persistant[PERS_HITS]++;
ADDRLP4 88
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 252
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1165
;1165:		}
LABELV $369
line 1166
;1166:		attacker->client->ps.persistant[PERS_ATTACKEE_ARMOR] = (targ->health<<8)|(client->ps.stats[STAT_ARMOR]);
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 276
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 8
LSHI4
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
BORI4
ASGNI4
line 1167
;1167:	}
LABELV $366
line 1171
;1168:
;1169:	// always give half damage if hurting self
;1170:	// calculated after knockback, so rocket jumping works
;1171:	if ( targ == attacker) {
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRFP4 8
INDIRP4
CVPU4 4
NEU4 $370
line 1172
;1172:		damage *= 0.5;
ADDRFP4 20
CNSTF4 1056964608
ADDRFP4 20
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 1173
;1173:	}
LABELV $370
line 1175
;1174:
;1175:	if ( damage < 1 ) {
ADDRFP4 20
INDIRI4
CNSTI4 1
GEI4 $372
line 1176
;1176:		damage = 1;
ADDRFP4 20
CNSTI4 1
ASGNI4
line 1177
;1177:	}
LABELV $372
line 1178
;1178:	take = damage;
ADDRLP4 8
ADDRFP4 20
INDIRI4
ASGNI4
line 1179
;1179:	save = 0;
ADDRLP4 16
CNSTI4 0
ASGNI4
line 1182
;1180:
;1181:	// save some from armor
;1182:	asave = CheckArmor (targ, take, dflags);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRFP4 24
INDIRI4
ARGI4
ADDRLP4 84
ADDRGP4 CheckArmor
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 84
INDIRI4
ASGNI4
line 1183
;1183:	take -= asave;
ADDRLP4 8
ADDRLP4 8
INDIRI4
ADDRLP4 12
INDIRI4
SUBI4
ASGNI4
line 1185
;1184:
;1185:	if ( g_debugDamage.integer ) {
ADDRGP4 g_debugDamage+12
INDIRI4
CNSTI4 0
EQI4 $374
line 1186
;1186:		G_Printf( "%i: client:%i health:%i damage:%i armor:%i\n", level.time, targ->s.number,
ADDRGP4 $377
ARGP4
ADDRGP4 level+32
INDIRI4
ARGI4
ADDRLP4 88
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 88
INDIRP4
INDIRI4
ARGI4
ADDRLP4 88
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 1188
;1187:			targ->health, take, asave );
;1188:	}
LABELV $374
line 1193
;1189:
;1190:	// add to the damage inflicted on a player this frame
;1191:	// the total will be turned into screen blends and view angle kicks
;1192:	// at the end of the frame
;1193:	if ( client ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $379
line 1194
;1194:		if ( attacker ) {
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $381
line 1195
;1195:			client->ps.persistant[PERS_ATTACKER] = attacker->s.number;
ADDRLP4 0
INDIRP4
CNSTI4 272
ADDP4
ADDRFP4 8
INDIRP4
INDIRI4
ASGNI4
line 1196
;1196:		} else {
ADDRGP4 $382
JUMPV
LABELV $381
line 1197
;1197:			client->ps.persistant[PERS_ATTACKER] = ENTITYNUM_WORLD;
ADDRLP4 0
INDIRP4
CNSTI4 272
ADDP4
CNSTI4 1022
ASGNI4
line 1198
;1198:		}
LABELV $382
line 1199
;1199:		client->damage_armor += asave;
ADDRLP4 88
ADDRLP4 0
INDIRP4
CNSTI4 684
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRI4
ADDRLP4 12
INDIRI4
ADDI4
ASGNI4
line 1200
;1200:		client->damage_blood += take;
ADDRLP4 92
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ASGNP4
ADDRLP4 92
INDIRP4
ADDRLP4 92
INDIRP4
INDIRI4
ADDRLP4 8
INDIRI4
ADDI4
ASGNI4
line 1201
;1201:		client->damage_knockback += knockback;
ADDRLP4 96
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDI4
ASGNI4
line 1202
;1202:		if ( dir ) {
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $383
line 1203
;1203:			VectorCopy ( dir, client->damage_from );
ADDRLP4 0
INDIRP4
CNSTI4 696
ADDP4
ADDRFP4 12
INDIRP4
INDIRB
ASGNB 12
line 1204
;1204:			client->damage_fromWorld = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 708
ADDP4
CNSTI4 0
ASGNI4
line 1205
;1205:		} else {
ADDRGP4 $384
JUMPV
LABELV $383
line 1206
;1206:			VectorCopy ( targ->r.currentOrigin, client->damage_from );
ADDRLP4 0
INDIRP4
CNSTI4 696
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1207
;1207:			client->damage_fromWorld = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 708
ADDP4
CNSTI4 1
ASGNI4
line 1208
;1208:		}
LABELV $384
line 1209
;1209:	}
LABELV $379
line 1215
;1210:
;1211:	// See if it's the player hurting the emeny flag carrier
;1212:#ifdef MISSIONPACK
;1213:	if( g_gametype.integer == GT_CTF || g_gametype.integer == GT_1FCTF ) {
;1214:#else	
;1215:	if( g_gametype.integer == GT_CTF) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
NEI4 $385
line 1217
;1216:#endif
;1217:		Team_CheckHurtCarrier(targ, attacker);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 Team_CheckHurtCarrier
CALLV
pop
line 1218
;1218:	}
LABELV $385
line 1220
;1219:
;1220:	if (targ->client) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $388
line 1222
;1221:		// set the last client who damaged the target
;1222:		targ->client->lasthurt_client = attacker->s.number;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 728
ADDP4
ADDRFP4 8
INDIRP4
INDIRI4
ASGNI4
line 1223
;1223:		targ->client->lasthurt_mod = mod;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 732
ADDP4
ADDRFP4 28
INDIRI4
ASGNI4
line 1224
;1224:	}
LABELV $388
line 1227
;1225:
;1226:	// do the damage
;1227:	if (take) {
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $390
line 1228
;1228:		targ->health = targ->health - take;
ADDRLP4 88
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRI4
ADDRLP4 8
INDIRI4
SUBI4
ASGNI4
line 1229
;1229:		if ( targ->client ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $392
line 1230
;1230:			targ->client->ps.stats[STAT_HEALTH] = targ->health;
ADDRLP4 92
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 92
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 92
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ASGNI4
line 1231
;1231:		}
LABELV $392
line 1233
;1232:			
;1233:		if ( targ->health <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $394
line 1234
;1234:			if ( client )
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $396
line 1235
;1235:				targ->flags |= FL_NO_KNOCKBACK;
ADDRLP4 92
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 92
INDIRP4
ADDRLP4 92
INDIRP4
INDIRI4
CNSTI4 2048
BORI4
ASGNI4
LABELV $396
line 1237
;1236:
;1237:			if (targ->health < -999)
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -999
GEI4 $398
line 1238
;1238:				targ->health = -999;
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
CNSTI4 -999
ASGNI4
LABELV $398
line 1240
;1239:
;1240:			targ->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 1241
;1241:			targ->die (targ, inflictor, attacker, take, mod);
ADDRLP4 96
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 96
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRFP4 28
INDIRI4
ARGI4
ADDRLP4 96
INDIRP4
CNSTI4 716
ADDP4
INDIRP4
CALLV
pop
line 1242
;1242:			return;
ADDRGP4 $301
JUMPV
LABELV $394
line 1243
;1243:		} else if ( targ->pain ) {
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $400
line 1244
;1244:			targ->pain (targ, attacker, take);
ADDRLP4 92
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 92
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 92
INDIRP4
CNSTI4 712
ADDP4
INDIRP4
CALLV
pop
line 1245
;1245:		}
LABELV $400
line 1246
;1246:	}
LABELV $390
line 1248
;1247:
;1248:}
LABELV $301
endproc G_Damage 104 24
export CanDamage
proc CanDamage 112 28
line 1259
;1249:
;1250:
;1251:/*
;1252:============
;1253:CanDamage
;1254:
;1255:Returns qtrue if the inflictor can directly damage the target.  Used for
;1256:explosions and melee attacks.
;1257:============
;1258:*/
;1259:qboolean CanDamage (gentity_t *targ, vec3_t origin) {
line 1266
;1260:	vec3_t	dest;
;1261:	trace_t	tr;
;1262:	vec3_t	midpoint;
;1263:
;1264:	// use the midpoint of the bounds instead of the origin, because
;1265:	// bmodels may have their origin is 0,0,0
;1266:	VectorAdd (targ->r.absmin, targ->r.absmax, midpoint);
ADDRLP4 80
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 80
INDIRP4
CNSTI4 464
ADDP4
INDIRF4
ADDRLP4 80
INDIRP4
CNSTI4 476
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 80
INDIRP4
CNSTI4 468
ADDP4
INDIRF4
ADDRLP4 80
INDIRP4
CNSTI4 480
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 84
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12+8
ADDRLP4 84
INDIRP4
CNSTI4 472
ADDP4
INDIRF4
ADDRLP4 84
INDIRP4
CNSTI4 484
ADDP4
INDIRF4
ADDF4
ASGNF4
line 1267
;1267:	VectorScale (midpoint, 0.5, midpoint);
ADDRLP4 88
CNSTF4 1056964608
ASGNF4
ADDRLP4 12
ADDRLP4 88
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 88
INDIRF4
ADDRLP4 12+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 12+8
CNSTF4 1056964608
ADDRLP4 12+8
INDIRF4
MULF4
ASGNF4
line 1269
;1268:
;1269:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1270
;1270:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
ADDRLP4 24
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 92
ADDRGP4 vec3_origin
ASGNP4
ADDRLP4 92
INDIRP4
ARGP4
ADDRLP4 92
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1271
;1271:	if (tr.fraction == 1.0 || tr.entityNum == targ->s.number)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
EQF4 $413
ADDRLP4 24+52
INDIRI4
ADDRFP4 0
INDIRP4
INDIRI4
NEI4 $409
LABELV $413
line 1272
;1272:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $402
JUMPV
LABELV $409
line 1276
;1273:
;1274:	// this should probably check in the plane of projection, 
;1275:	// rather than in world coordinate, and also include Z
;1276:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1277
;1277:	dest[0] += 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1278
;1278:	dest[1] += 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1279
;1279:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
ADDRLP4 24
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 96
ADDRGP4 vec3_origin
ASGNP4
ADDRLP4 96
INDIRP4
ARGP4
ADDRLP4 96
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1280
;1280:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $415
line 1281
;1281:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $402
JUMPV
LABELV $415
line 1283
;1282:
;1283:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1284
;1284:	dest[0] += 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1285
;1285:	dest[1] -= 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1286
;1286:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
ADDRLP4 24
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 100
ADDRGP4 vec3_origin
ASGNP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1287
;1287:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $419
line 1288
;1288:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $402
JUMPV
LABELV $419
line 1290
;1289:
;1290:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1291
;1291:	dest[0] -= 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1292
;1292:	dest[1] += 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1293
;1293:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
ADDRLP4 24
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 104
ADDRGP4 vec3_origin
ASGNP4
ADDRLP4 104
INDIRP4
ARGP4
ADDRLP4 104
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1294
;1294:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $423
line 1295
;1295:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $402
JUMPV
LABELV $423
line 1297
;1296:
;1297:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1298
;1298:	dest[0] -= 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1299
;1299:	dest[1] -= 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1300
;1300:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
ADDRLP4 24
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 108
ADDRGP4 vec3_origin
ASGNP4
ADDRLP4 108
INDIRP4
ARGP4
ADDRLP4 108
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1301
;1301:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $427
line 1302
;1302:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $402
JUMPV
LABELV $427
line 1305
;1303:
;1304:
;1305:	return qfalse;
CNSTI4 0
RETI4
LABELV $402
endproc CanDamage 112 28
export G_RadiusDamage
proc G_RadiusDamage 4196 32
line 1315
;1306:}
;1307:
;1308:
;1309:/*
;1310:============
;1311:G_RadiusDamage
;1312:============
;1313:*/
;1314:qboolean G_RadiusDamage ( vec3_t origin, gentity_t *attacker, float damage, float radius,
;1315:					 gentity_t *ignore, int mod) {
line 1324
;1316:	float		points, dist;
;1317:	gentity_t	*ent;
;1318:	int			entityList[MAX_GENTITIES];
;1319:	int			numListedEntities;
;1320:	vec3_t		mins, maxs;
;1321:	vec3_t		v;
;1322:	vec3_t		dir;
;1323:	int			i, e;
;1324:	qboolean	hitClient = qfalse;
ADDRLP4 4168
CNSTI4 0
ASGNI4
line 1326
;1325:
;1326:	if ( radius < 1 ) {
ADDRFP4 12
INDIRF4
CNSTF4 1065353216
GEF4 $431
line 1327
;1327:		radius = 1;
ADDRFP4 12
CNSTF4 1065353216
ASGNF4
line 1328
;1328:	}
LABELV $431
line 1330
;1329:
;1330:	for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $433
line 1331
;1331:		mins[i] = origin[i] - radius;
ADDRLP4 4172
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 4172
INDIRI4
ADDRLP4 4144
ADDP4
ADDRLP4 4172
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRF4
ADDRFP4 12
INDIRF4
SUBF4
ASGNF4
line 1332
;1332:		maxs[i] = origin[i] + radius;
ADDRLP4 4176
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 4176
INDIRI4
ADDRLP4 4156
ADDP4
ADDRLP4 4176
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRF4
ADDRFP4 12
INDIRF4
ADDF4
ASGNF4
line 1333
;1333:	}
LABELV $434
line 1330
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $433
line 1335
;1334:
;1335:	numListedEntities = trap_EntitiesInBox( mins, maxs, entityList, MAX_GENTITIES );
ADDRLP4 4144
ARGP4
ADDRLP4 4156
ARGP4
ADDRLP4 44
ARGP4
CNSTI4 1024
ARGI4
ADDRLP4 4172
ADDRGP4 trap_EntitiesInBox
CALLI4
ASGNI4
ADDRLP4 4140
ADDRLP4 4172
INDIRI4
ASGNI4
line 1337
;1336:
;1337:	for ( e = 0 ; e < numListedEntities ; e++ ) {
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRGP4 $440
JUMPV
LABELV $437
line 1338
;1338:		ent = &g_entities[entityList[ e ]];
ADDRLP4 4
CNSTI4 884
ADDRLP4 20
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 44
ADDP4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1340
;1339:
;1340:		if (ent == ignore)
ADDRLP4 4
INDIRP4
CVPU4 4
ADDRFP4 16
INDIRP4
CVPU4 4
NEU4 $441
line 1341
;1341:			continue;
ADDRGP4 $438
JUMPV
LABELV $441
line 1342
;1342:		if (!ent->takedamage)
ADDRLP4 4
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
CNSTI4 0
NEI4 $443
line 1343
;1343:			continue;
ADDRGP4 $438
JUMPV
LABELV $443
line 1346
;1344:
;1345:		// find the distance from the edge of the bounding box
;1346:		for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $445
line 1347
;1347:			if ( origin[i] < ent->r.absmin[i] ) {
ADDRLP4 4176
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 4176
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRF4
ADDRLP4 4176
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 464
ADDP4
ADDP4
INDIRF4
GEF4 $449
line 1348
;1348:				v[i] = ent->r.absmin[i] - origin[i];
ADDRLP4 4180
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 4180
INDIRI4
ADDRLP4 8
ADDP4
ADDRLP4 4180
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 464
ADDP4
ADDP4
INDIRF4
ADDRLP4 4180
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1349
;1349:			} else if ( origin[i] > ent->r.absmax[i] ) {
ADDRGP4 $450
JUMPV
LABELV $449
ADDRLP4 4180
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 4180
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRF4
ADDRLP4 4180
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 476
ADDP4
ADDP4
INDIRF4
LEF4 $451
line 1350
;1350:				v[i] = origin[i] - ent->r.absmax[i];
ADDRLP4 4184
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 4184
INDIRI4
ADDRLP4 8
ADDP4
ADDRLP4 4184
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRF4
ADDRLP4 4184
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 476
ADDP4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1351
;1351:			} else {
ADDRGP4 $452
JUMPV
LABELV $451
line 1352
;1352:				v[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
ADDP4
CNSTF4 0
ASGNF4
line 1353
;1353:			}
LABELV $452
LABELV $450
line 1354
;1354:		}
LABELV $446
line 1346
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $445
line 1356
;1355:
;1356:		dist = VectorLength( v );
ADDRLP4 8
ARGP4
ADDRLP4 4176
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 24
ADDRLP4 4176
INDIRF4
ASGNF4
line 1357
;1357:		if ( dist >= radius ) {
ADDRLP4 24
INDIRF4
ADDRFP4 12
INDIRF4
LTF4 $453
line 1358
;1358:			continue;
ADDRGP4 $438
JUMPV
LABELV $453
line 1361
;1359:		}
;1360:
;1361:		points = damage * ( 1.0 - dist / radius );
ADDRLP4 40
ADDRFP4 8
INDIRF4
CNSTF4 1065353216
ADDRLP4 24
INDIRF4
ADDRFP4 12
INDIRF4
DIVF4
SUBF4
MULF4
ASGNF4
line 1363
;1362:
;1363:		if( CanDamage (ent, origin) ) {
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4180
ADDRGP4 CanDamage
CALLI4
ASGNI4
ADDRLP4 4180
INDIRI4
CNSTI4 0
EQI4 $455
line 1364
;1364:			if( LogAccuracyHit( ent, attacker ) ) {
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 4184
ADDRGP4 LogAccuracyHit
CALLI4
ASGNI4
ADDRLP4 4184
INDIRI4
CNSTI4 0
EQI4 $457
line 1365
;1365:				hitClient = qtrue;
ADDRLP4 4168
CNSTI4 1
ASGNI4
line 1366
;1366:			}
LABELV $457
line 1367
;1367:			VectorSubtract (ent->r.currentOrigin, origin, dir);
ADDRLP4 4192
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
ADDRLP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 4192
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 28+4
ADDRLP4 4
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
ADDRLP4 4192
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 28+8
ADDRLP4 4
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1370
;1368:			// push the center of mass higher than the origin so players
;1369:			// get knocked into the air more
;1370:			dir[2] += 24;
ADDRLP4 28+8
ADDRLP4 28+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 1371
;1371:			G_Damage (ent, NULL, attacker, dir, origin, (int)points, DAMAGE_RADIUS, mod);
ADDRLP4 4
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 28
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 40
INDIRF4
CVFI4 4
ARGI4
CNSTI4 1
ARGI4
ADDRFP4 20
INDIRI4
ARGI4
ADDRGP4 G_Damage
CALLV
pop
line 1372
;1372:		}
LABELV $455
line 1373
;1373:	}
LABELV $438
line 1337
ADDRLP4 20
ADDRLP4 20
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $440
ADDRLP4 20
INDIRI4
ADDRLP4 4140
INDIRI4
LTI4 $437
line 1375
;1374:
;1375:	return hitClient;
ADDRLP4 4168
INDIRI4
RETI4
LABELV $430
endproc G_RadiusDamage 4196 32
import G_MonsterTryReplaceItem
import G_FindAutomaticBaseSpots
import G_MonsterRunFrame
import G_MonsterInitDefinitions
import g_monsterDefLoaded
import g_monsterDefs
import G_AutoCTFInit
import trap_SnapVector
import trap_GeneticParentsAndChildSelection
import trap_BotResetWeaponState
import trap_BotFreeWeaponState
import trap_BotAllocWeaponState
import trap_BotLoadWeaponWeights
import trap_BotGetWeaponInfo
import trap_BotChooseBestFightWeapon
import trap_BotAddAvoidSpot
import trap_BotInitMoveState
import trap_BotFreeMoveState
import trap_BotAllocMoveState
import trap_BotPredictVisiblePosition
import trap_BotMovementViewTarget
import trap_BotReachabilityArea
import trap_BotResetLastAvoidReach
import trap_BotResetAvoidReach
import trap_BotMoveInDirection
import trap_BotMoveToGoal
import trap_BotResetMoveState
import trap_BotFreeGoalState
import trap_BotAllocGoalState
import trap_BotMutateGoalFuzzyLogic
import trap_BotSaveGoalFuzzyLogic
import trap_BotInterbreedGoalFuzzyLogic
import trap_BotFreeItemWeights
import trap_BotLoadItemWeights
import trap_BotUpdateEntityItems
import trap_BotInitLevelItems
import trap_BotSetAvoidGoalTime
import trap_BotAvoidGoalTime
import trap_BotGetLevelItemGoal
import trap_BotGetMapLocationGoal
import trap_BotGetNextCampSpotGoal
import trap_BotItemGoalInVisButNotVisible
import trap_BotTouchingGoal
import trap_BotChooseNBGItem
import trap_BotChooseLTGItem
import trap_BotGetSecondGoal
import trap_BotGetTopGoal
import trap_BotGoalName
import trap_BotDumpGoalStack
import trap_BotDumpAvoidGoals
import trap_BotEmptyGoalStack
import trap_BotPopGoal
import trap_BotPushGoal
import trap_BotResetAvoidGoals
import trap_BotRemoveFromAvoidGoals
import trap_BotResetGoalState
import trap_BotSetChatName
import trap_BotSetChatGender
import trap_BotLoadChatFile
import trap_BotReplaceSynonyms
import trap_UnifyWhiteSpaces
import trap_BotMatchVariable
import trap_BotFindMatch
import trap_StringContains
import trap_BotGetChatMessage
import trap_BotEnterChat
import trap_BotChatLength
import trap_BotReplyChat
import trap_BotNumInitialChats
import trap_BotInitialChat
import trap_BotNumConsoleMessages
import trap_BotNextConsoleMessage
import trap_BotRemoveConsoleMessage
import trap_BotQueueConsoleMessage
import trap_BotFreeChatState
import trap_BotAllocChatState
import trap_Characteristic_String
import trap_Characteristic_BInteger
import trap_Characteristic_Integer
import trap_Characteristic_BFloat
import trap_Characteristic_Float
import trap_BotFreeCharacter
import trap_BotLoadCharacter
import trap_EA_ResetInput
import trap_EA_GetInput
import trap_EA_EndRegular
import trap_EA_View
import trap_EA_Move
import trap_EA_DelayedJump
import trap_EA_Jump
import trap_EA_SelectWeapon
import trap_EA_MoveRight
import trap_EA_MoveLeft
import trap_EA_MoveBack
import trap_EA_MoveForward
import trap_EA_MoveDown
import trap_EA_MoveUp
import trap_EA_Crouch
import trap_EA_Respawn
import trap_EA_Use
import trap_EA_Attack
import trap_EA_Talk
import trap_EA_Gesture
import trap_EA_Action
import trap_EA_Command
import trap_EA_SayTeam
import trap_EA_Say
import trap_AAS_PredictClientMovement
import trap_AAS_Swimming
import trap_AAS_AlternativeRouteGoals
import trap_AAS_PredictRoute
import trap_AAS_EnableRoutingArea
import trap_AAS_AreaTravelTimeToGoalArea
import trap_AAS_AreaReachability
import trap_AAS_IntForBSPEpairKey
import trap_AAS_FloatForBSPEpairKey
import trap_AAS_VectorForBSPEpairKey
import trap_AAS_ValueForBSPEpairKey
import trap_AAS_NextBSPEntity
import trap_AAS_PointContents
import trap_AAS_TraceAreas
import trap_AAS_PointReachabilityAreaIndex
import trap_AAS_PointAreaNum
import trap_AAS_Time
import trap_AAS_PresenceTypeBoundingBox
import trap_AAS_Initialized
import trap_AAS_EntityInfo
import trap_AAS_AreaInfo
import trap_AAS_BBoxAreas
import trap_BotUserCommand
import trap_BotGetServerCommand
import trap_BotGetSnapshotEntity
import trap_BotLibTest
import trap_BotLibUpdateEntity
import trap_BotLibLoadMap
import trap_BotLibStartFrame
import trap_BotLibDefine
import trap_BotLibVarGet
import trap_BotLibVarSet
import trap_BotLibShutdown
import trap_BotLibSetup
import trap_DebugPolygonDelete
import trap_DebugPolygonCreate
import trap_GetEntityToken
import trap_GetUsercmd
import trap_BotFreeClient
import trap_BotAllocateClient
import trap_EntityContact
import trap_EntitiesInBox
import trap_UnlinkEntity
import trap_LinkEntity
import trap_AreasConnected
import trap_AdjustAreaPortalState
import trap_InPVSIgnorePortals
import trap_InPVS
import trap_PointContents
import trap_Trace
import trap_SetBrushModel
import trap_GetServerinfo
import trap_SetUserinfo
import trap_GetUserinfo
import trap_GetConfigstring
import trap_SetConfigstring
import trap_SendServerCommand
import trap_DropClient
import trap_LocateGameData
import trap_Cvar_VariableStringBuffer
import trap_Cvar_VariableValue
import trap_Cvar_VariableIntegerValue
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_SendConsoleCommand
import trap_FS_Seek
import trap_FS_GetFileList
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Args
import trap_Argv
import trap_Argc
import trap_Milliseconds
import trap_Error
import trap_Printf
import g_proxMineTimeout
import g_singlePlayer
import g_enableBreath
import g_enableDust
import g_rankings
import pmove_msec
import pmove_fixed
import g_smoothClients
import g_blueteam
import g_redteam
import g_cubeTimeout
import g_obeliskRespawnDelay
import g_obeliskRegenAmount
import g_obeliskRegenPeriod
import g_obeliskHealth
import g_filterBan
import g_banIPs
import g_teamForceBalance
import g_teamAutoJoin
import g_allowVote
import g_blood
import g_doWarmup
import g_warmup
import g_motd
import g_synchronousClients
import g_weaponTeamRespawn
import g_weaponRespawn
import g_debugDamage
import g_debugAlloc
import g_debugMove
import g_inactivity
import g_forcerespawn
import g_quadfactor
import g_knockback
import g_speed
import g_gravity
import g_needpass
import g_password
import g_friendlyFire
import g_capturelimit
import g_timelimit
import g_fraglimit
import g_dmflags
import g_restarted
import g_maxGameClients
import g_maxclients
import g_cheats
import g_dedicated
import g_gametype
import g_noPowerups
import g_noMedkit
import g_noMegaHealth
import g_noGrenadeRocket
import g_noPlasmaBFG
import g_noRailgun
import g_noPersonalTeleporter
import g_blasterMode
import g_baseTDM
import g_oneLifeTDM
import g_noArmor
import g_noHealth
import g_playerHealth
import g_randomStartWeapon
import g_scavengerWeapons
import g_assaultMiddleItem
import g_assaultRadius
import g_assaultRoundTime
import g_assaultHoldTime
import g_assaultMode
import g_autoCTF
import g_respawnTime
import g_monsterHunt
import G_AssaultGetActiveGoal
import G_AssaultClientCommand
import G_AssaultRunFrame
import G_AssaultInit
import G_AssaultControlsExitRules
import G_AssaultBlocksWarmup
import G_AssaultEnabled
import g_entities
import level
import Pickup_Team
import CheckTeamStatus
import TeamplayInfoMessage
import Team_GetLocationMsg
import Team_GetLocation
import SelectCTFSpawnPoint
import Team_FreeEntity
import Team_ReturnFlag
import Team_InitGame
import Team_CheckHurtCarrier
import Team_FragBonuses
import Team_DroppedFlagThink
import AddTeamScore
import TeamColorString
import OtherTeamName
import TeamName
import OtherTeam
import BotTestAAS
import BotAIStartFrame
import BotAIShutdownClient
import BotAISetupClient
import BotAILoadMap
import BotAIShutdown
import BotAISetup
import BotInterbreedEndMatch
import Svcmd_BotList_f
import Svcmd_AddBot_f
import G_BotConnect
import G_RemoveQueuedBotBegin
import G_CheckBotSpawn
import G_GetBotInfoByName
import G_GetBotInfoByNumber
import G_InitBots
import Svcmd_AbortPodium_f
import SpawnModelsOnVictoryPads
import UpdateTournamentInfo
import G_WriteSessionData
import G_InitWorldSession
import G_InitSessionData
import G_ReadSessionData
import Svcmd_GameMem_f
import G_InitMemory
import G_Alloc
import CheckObeliskAttack
import Team_CheckDroppedItem
import OnSameTeam
import G_RunClient
import ClientEndFrame
import ClientThink
import ClientCommand
import ClientBegin
import ClientDisconnect
import ClientUserinfoChanged
import ClientConnect
import G_Error
import G_Printf
import SendScoreboardMessageToAllClients
import LogExit
import G_LogPrintf
import G_RunThink
import CheckTeamLeader
import SetLeader
import FindIntermissionPoint
import DeathmatchScoreboardMessage
import G_SetStats
import MoveClientToIntermission
import FireWeapon
import G_FilterPacket
import G_ProcessIPBans
import ConsoleCommand
import SpotWouldTelefrag
import CalculateRanks
import ClientSpawn
import InitBodyQue
import InitClientResp
import InitClientPersistant
import BeginIntermission
import respawn
import CopyToBodyQue
import SelectSpawnPoint
import SetClientViewAngle
import PickTeam
import TeamLeader
import TeamCount
import Weapon_HookThink
import Weapon_HookFree
import CheckGauntletAttack
import SnapVectorTowards
import CalcMuzzlePoint
import LogAccuracyHit
import TeleportPlayer
import trigger_teleporter_touch
import Touch_DoorTrigger
import G_RunMover
import fire_grapple
import fire_bfg
import fire_rocket
import fire_grenade
import fire_plasma
import fire_blaster
import G_RunMissile
import TossClientCubes
import G_InvulnerabilityEffect
import BuildShaderStateConfig
import AddRemap
import G_SetOrigin
import G_AddEvent
import G_AddPredictableEvent
import vectoyaw
import vtos
import tv
import G_TouchSolids
import G_TouchTriggers
import G_EntitiesFree
import G_FreeEntity
import G_Sound
import G_TempEntity
import G_Spawn
import G_InitGentity
import G_SetMovedir
import G_UseTargets
import G_PickTarget
import G_Find
import G_KillBox
import G_TeamCommand
import G_SoundIndex
import G_ModelIndex
import SaveRegisteredItems
import RegisterItem
import ClearRegisteredItems
import Touch_Item
import Add_Ammo
import ArmorIndex
import Think_Weapon
import FinishSpawningItem
import G_SpawnItem
import SetRespawn
import LaunchItem
import Drop_Item
import PrecacheItem
import UseHoldableItem
import RespawnItem
import G_RunItem
import G_CheckTeamItems
import Cmd_FollowCycle_f
import SetTeam
import BroadcastTeamChange
import StopFollowing
import Cmd_Score_f
import G_NewString
import G_SpawnEntitiesFromString
import G_SpawnVector
import G_SpawnInt
import G_SpawnFloat
import G_SpawnString
import BG_ParseMonsterConfig
import BG_PlayerTouchesItem
import BG_PlayerStateToEntityStateExtraPolate
import BG_PlayerStateToEntityState
import BG_TouchJumpPad
import BG_AddPredictableEventToPlayerstate
import BG_EvaluateTrajectoryDelta
import BG_EvaluateTrajectory
import BG_CanItemBeGrabbed
import BG_FindItemForHoldable
import BG_FindItemForPowerup
import BG_FindItemForWeapon
import BG_FindItem
import bg_numItems
import bg_itemlist
import Pmove
import PM_UpdateViewAngles
import Com_Printf
import Com_Error
import Info_NextPair
import Info_Validate
import Info_SetValueForKey_Big
import Info_SetValueForKey
import Info_RemoveKey_big
import Info_RemoveKey
import Info_ValueForKey
import va
import Q_CleanStr
import Q_PrintStrlen
import Q_strcat
import Q_strncpyz
import Q_strrchr
import Q_strupr
import Q_strlwr
import Q_stricmpn
import Q_strncmp
import Q_stricmp
import Q_isalpha
import Q_isupper
import Q_islower
import Q_isprint
import Com_sprintf
import Parse3DMatrix
import Parse2DMatrix
import Parse1DMatrix
import SkipRestOfLine
import SkipBracedSection
import COM_MatchToken
import COM_ParseWarning
import COM_ParseError
import COM_Compress
import COM_ParseExt
import COM_Parse
import COM_GetCurrentParseLine
import COM_BeginParseSession
import COM_DefaultExtension
import COM_StripExtension
import COM_SkipPath
import Com_Clamp
import PerpendicularVector
import AngleVectors
import MatrixMultiply
import MakeNormalVectors
import RotateAroundDirection
import RotatePointAroundVector
import ProjectPointOnPlane
import PlaneFromPoints
import AngleDelta
import AngleNormalize180
import AngleNormalize360
import AnglesSubtract
import AngleSubtract
import LerpAngle
import AngleMod
import BoxOnPlaneSide
import SetPlaneSignbits
import AxisCopy
import AxisClear
import AnglesToAxis
import vectoangles
import Q_crandom
import Q_random
import Q_rand
import Q_acos
import Q_log2
import VectorRotate
import Vector4Scale
import VectorNormalize2
import VectorNormalize
import CrossProduct
import VectorInverse
import VectorNormalizeFast
import DistanceSquared
import Distance
import VectorLengthSquared
import VectorLength
import VectorCompare
import AddPointToBounds
import ClearBounds
import RadiusFromBounds
import NormalizeColor
import ColorBytes4
import ColorBytes3
import _VectorMA
import _VectorScale
import _VectorCopy
import _VectorAdd
import _VectorSubtract
import _DotProduct
import ByteToDir
import DirToByte
import ClampShort
import ClampChar
import Q_rsqrt
import Q_fabs
import axisDefault
import vec3_origin
import g_color_table
import colorDkGrey
import colorMdGrey
import colorLtGrey
import colorWhite
import colorCyan
import colorMagenta
import colorYellow
import colorBlue
import colorGreen
import colorRed
import colorBlack
import bytedirs
import Com_Memcpy
import Com_Memset
import Hunk_Alloc
import FloatSwap
import LongSwap
import ShortSwap
import acos
import fabs
import abs
import tan
import atan2
import cos
import sin
import sqrt
import floor
import ceil
import memcpy
import memset
import memmove
import sscanf
import vsprintf
import _atoi
import atoi
import _atof
import atof
import toupper
import tolower
import strncpy
import strstr
import strchr
import strcmp
import strcpy
import strcat
import strlen
import rand
import srand
import qsort
lit
align 1
LABELV $377
byte 1 37
byte 1 105
byte 1 58
byte 1 32
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 100
byte 1 97
byte 1 109
byte 1 97
byte 1 103
byte 1 101
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 97
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 58
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $214
byte 1 75
byte 1 105
byte 1 108
byte 1 108
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 105
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 98
byte 1 121
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $213
byte 1 60
byte 1 98
byte 1 97
byte 1 100
byte 1 32
byte 1 111
byte 1 98
byte 1 105
byte 1 116
byte 1 117
byte 1 97
byte 1 114
byte 1 121
byte 1 62
byte 1 0
align 1
LABELV $206
byte 1 60
byte 1 119
byte 1 111
byte 1 114
byte 1 108
byte 1 100
byte 1 62
byte 1 0
align 1
LABELV $205
byte 1 60
byte 1 110
byte 1 111
byte 1 110
byte 1 45
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 62
byte 1 0
align 1
LABELV $204
byte 1 60
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 62
byte 1 0
align 1
LABELV $181
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 111
byte 1 98
byte 1 101
byte 1 108
byte 1 105
byte 1 115
byte 1 107
byte 1 0
align 1
LABELV $180
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 111
byte 1 98
byte 1 101
byte 1 108
byte 1 105
byte 1 115
byte 1 107
byte 1 0
align 1
LABELV $160
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $159
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $148
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 71
byte 1 82
byte 1 65
byte 1 80
byte 1 80
byte 1 76
byte 1 69
byte 1 0
align 1
LABELV $147
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 84
byte 1 82
byte 1 73
byte 1 71
byte 1 71
byte 1 69
byte 1 82
byte 1 95
byte 1 72
byte 1 85
byte 1 82
byte 1 84
byte 1 0
align 1
LABELV $146
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 84
byte 1 65
byte 1 82
byte 1 71
byte 1 69
byte 1 84
byte 1 95
byte 1 76
byte 1 65
byte 1 83
byte 1 69
byte 1 82
byte 1 0
align 1
LABELV $145
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 83
byte 1 85
byte 1 73
byte 1 67
byte 1 73
byte 1 68
byte 1 69
byte 1 0
align 1
LABELV $144
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 70
byte 1 65
byte 1 76
byte 1 76
byte 1 73
byte 1 78
byte 1 71
byte 1 0
align 1
LABELV $143
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 84
byte 1 69
byte 1 76
byte 1 69
byte 1 70
byte 1 82
byte 1 65
byte 1 71
byte 1 0
align 1
LABELV $142
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 67
byte 1 82
byte 1 85
byte 1 83
byte 1 72
byte 1 0
align 1
LABELV $141
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 76
byte 1 65
byte 1 86
byte 1 65
byte 1 0
align 1
LABELV $140
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 83
byte 1 76
byte 1 73
byte 1 77
byte 1 69
byte 1 0
align 1
LABELV $139
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 87
byte 1 65
byte 1 84
byte 1 69
byte 1 82
byte 1 0
align 1
LABELV $138
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 66
byte 1 70
byte 1 71
byte 1 95
byte 1 83
byte 1 80
byte 1 76
byte 1 65
byte 1 83
byte 1 72
byte 1 0
align 1
LABELV $137
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $136
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 76
byte 1 73
byte 1 71
byte 1 72
byte 1 84
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 0
align 1
LABELV $135
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 82
byte 1 65
byte 1 73
byte 1 76
byte 1 71
byte 1 85
byte 1 78
byte 1 0
align 1
LABELV $134
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 80
byte 1 76
byte 1 65
byte 1 83
byte 1 77
byte 1 65
byte 1 95
byte 1 83
byte 1 80
byte 1 76
byte 1 65
byte 1 83
byte 1 72
byte 1 0
align 1
LABELV $133
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 80
byte 1 76
byte 1 65
byte 1 83
byte 1 77
byte 1 65
byte 1 0
align 1
LABELV $132
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 82
byte 1 79
byte 1 67
byte 1 75
byte 1 69
byte 1 84
byte 1 95
byte 1 83
byte 1 80
byte 1 76
byte 1 65
byte 1 83
byte 1 72
byte 1 0
align 1
LABELV $131
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 82
byte 1 79
byte 1 67
byte 1 75
byte 1 69
byte 1 84
byte 1 0
align 1
LABELV $130
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 71
byte 1 82
byte 1 69
byte 1 78
byte 1 65
byte 1 68
byte 1 69
byte 1 95
byte 1 83
byte 1 80
byte 1 76
byte 1 65
byte 1 83
byte 1 72
byte 1 0
align 1
LABELV $129
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 71
byte 1 82
byte 1 69
byte 1 78
byte 1 65
byte 1 68
byte 1 69
byte 1 0
align 1
LABELV $128
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 77
byte 1 65
byte 1 67
byte 1 72
byte 1 73
byte 1 78
byte 1 69
byte 1 71
byte 1 85
byte 1 78
byte 1 0
align 1
LABELV $127
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 71
byte 1 65
byte 1 85
byte 1 78
byte 1 84
byte 1 76
byte 1 69
byte 1 84
byte 1 0
align 1
LABELV $126
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 83
byte 1 72
byte 1 79
byte 1 84
byte 1 71
byte 1 85
byte 1 78
byte 1 0
align 1
LABELV $125
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 85
byte 1 78
byte 1 75
byte 1 78
byte 1 79
byte 1 87
byte 1 78
byte 1 0
align 1
LABELV $118
byte 1 107
byte 1 97
byte 1 109
byte 1 105
byte 1 107
byte 1 97
byte 1 122
byte 1 101
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 114
byte 1 0
