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
LABELV $52
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
NEU4 $54
line 54
;54:		return;
ADDRGP4 $53
JUMPV
LABELV $54
line 57
;55:	}
;56:	// no scoring during pre-match warmup
;57:	if ( level.warmupTime ) {
ADDRGP4 level+16
INDIRI4
CNSTI4 0
EQI4 $56
line 58
;58:		return;
ADDRGP4 $53
JUMPV
LABELV $56
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
NEI4 $59
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
LABELV $59
line 66
;66:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 67
;67:}
LABELV $53
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
EQI4 $66
ADDRLP4 12
INDIRI4
CNSTI4 10
NEI4 $64
LABELV $66
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
NEI4 $67
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
LABELV $67
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
NEI4 $69
line 95
;95:			weapon = WP_NONE;
ADDRLP4 12
CNSTI4 0
ASGNI4
line 96
;96:		}
LABELV $69
line 97
;97:	}
LABELV $64
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
GTI4 $74
ADDRGP4 g_scavengerWeapons+12
INDIRI4
CNSTI4 0
EQI4 $71
ADDRLP4 12
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $71
LABELV $74
ADDRLP4 12
INDIRI4
CNSTI4 10
EQI4 $71
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
EQI4 $71
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
LABELV $71
line 121
;119:
;120:	// drop all the powerups if not in teamplay
;121:	if ( g_gametype.integer != GT_TEAM ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
EQI4 $75
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
LABELV $78
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
LEI4 $82
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
NEU4 $85
line 127
;127:					continue;
ADDRGP4 $79
JUMPV
LABELV $85
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
GEI4 $88
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
LABELV $88
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
LABELV $82
line 137
;137:		}
LABELV $79
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
LTI4 $78
line 138
;138:	}
LABELV $75
line 139
;139:}
LABELV $63
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
EQU4 $91
ADDRLP4 24
INDIRU4
ADDRFP4 0
INDIRP4
CVPU4 4
EQU4 $91
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
ADDRGP4 $92
JUMPV
LABELV $91
ADDRLP4 28
ADDRFP4 4
INDIRP4
CVPU4 4
ASGNU4
ADDRLP4 28
INDIRU4
CNSTU4 0
EQU4 $95
ADDRLP4 28
INDIRU4
ADDRFP4 0
INDIRP4
CVPU4 4
EQU4 $95
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
ADDRGP4 $96
JUMPV
LABELV $95
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
ADDRGP4 $90
JUMPV
LABELV $96
LABELV $92
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
LABELV $90
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
EQI4 $102
line 261
;260:		// check if there is a kamikaze timer around for this owner
;261:		for (i = 0; i < MAX_GENTITIES; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $104
line 262
;262:			ent = &g_entities[i];
ADDRLP4 0
CNSTI4 808
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
NEI4 $108
line 264
;264:				continue;
ADDRGP4 $105
JUMPV
LABELV $108
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
EQU4 $110
line 266
;266:				continue;
ADDRGP4 $105
JUMPV
LABELV $110
line 267
;267:			if (strcmp(ent->classname, "kamikaze timer"))
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRP4
ARGP4
ADDRGP4 $114
ARGP4
ADDRLP4 8
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $112
line 268
;268:				continue;
ADDRGP4 $105
JUMPV
LABELV $112
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
ADDRGP4 $106
JUMPV
LABELV $105
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
LTI4 $104
LABELV $106
line 272
;271:		}
;272:	}
LABELV $102
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
LABELV $101
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
LEI4 $116
line 286
;286:		return;
ADDRGP4 $115
JUMPV
LABELV $116
line 288
;287:	}
;288:	if ( !g_blood.integer ) {
ADDRGP4 g_blood+12
INDIRI4
CNSTI4 0
NEI4 $118
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
ADDRGP4 $115
JUMPV
LABELV $118
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
LABELV $115
endproc body_die 0 8
data
export modNames
align 4
LABELV modNames
address $121
address $122
address $123
address $124
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
NEI4 $149
ADDRLP4 20
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $149
ADDRLP4 20
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
EQI4 $146
LABELV $149
line 376
;375:		self->client->ps.powerups[PW_BLUEFLAG] ||
;376:		self->client->ps.powerups[PW_NEUTRALFLAG] ) {
line 378
;377:		// get the goal flag this player should have been going for
;378:		if ( g_gametype.integer == GT_CTF ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
NEI4 $150
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
NEI4 $153
line 380
;380:				classname = "team_CTF_blueflag";
ADDRLP4 4
ADDRGP4 $155
ASGNP4
line 381
;381:			}
ADDRGP4 $151
JUMPV
LABELV $153
line 382
;382:			else {
line 383
;383:				classname = "team_CTF_redflag";
ADDRLP4 4
ADDRGP4 $156
ASGNP4
line 384
;384:			}
line 385
;385:		}
ADDRGP4 $151
JUMPV
LABELV $150
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
NEI4 $157
line 388
;388:				classname = "team_CTF_redflag";
ADDRLP4 4
ADDRGP4 $156
ASGNP4
line 389
;389:			}
ADDRGP4 $158
JUMPV
LABELV $157
line 390
;390:			else {
line 391
;391:				classname = "team_CTF_blueflag";
ADDRLP4 4
ADDRGP4 $155
ASGNP4
line 392
;392:			}
LABELV $158
line 393
;393:		}
LABELV $151
line 394
;394:		ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
LABELV $159
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
LABELV $160
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $162
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
NEI4 $159
LABELV $162
line 400
;399:		// if we found the destination flag and it's not picked up
;400:		if (ent && !(ent->r.svFlags & SVF_NOCLIENT) ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $163
ADDRLP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $163
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
GEF4 $167
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
EQU4 $169
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
LABELV $169
line 408
;408:			}
LABELV $167
line 409
;409:		}
LABELV $163
line 410
;410:	}
LABELV $146
line 411
;411:}
LABELV $145
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
EQI4 $172
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
NEI4 $174
line 426
;426:			classname = "team_redobelisk";
ADDRLP4 16
ADDRGP4 $176
ASGNP4
line 427
;427:		}
ADDRGP4 $175
JUMPV
LABELV $174
line 428
;428:		else {
line 429
;429:			classname = "team_blueobelisk";
ADDRLP4 16
ADDRGP4 $177
ASGNP4
line 430
;430:		}
LABELV $175
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
EQU4 $178
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
GEF4 $182
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
EQU4 $184
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
LABELV $184
line 441
;441:			}
LABELV $182
line 442
;442:		}
LABELV $178
line 443
;443:	}
LABELV $172
line 444
;444:}
LABELV $171
endproc CheckAlmostScored 44 12
bss
align 4
LABELV $255
skip 4
export player_die
code
proc player_die 96 28
line 451
;445:
;446:/*
;447:==================
;448:player_die
;449:==================
;450:*/
;451:void player_die( gentity_t *self, gentity_t *inflictor, gentity_t *attacker, int damage, int meansOfDeath ) {
line 459
;452:	gentity_t	*ent;
;453:	int			anim;
;454:	int			contents;
;455:	int			killer;
;456:	int			i;
;457:	char		*killerName, *obit;
;458:
;459:	if ( self->client->ps.pm_type == PM_DEAD ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 3
NEI4 $187
line 460
;460:		return;
ADDRGP4 $186
JUMPV
LABELV $187
line 463
;461:	}
;462:
;463:	if ( level.intermissiontime ) {
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $189
line 464
;464:		return;
ADDRGP4 $186
JUMPV
LABELV $189
line 468
;465:	}
;466:
;467:	// check for an almost capture
;468:	CheckAlmostCapture( self, attacker );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CheckAlmostCapture
CALLV
pop
line 470
;469:	// check for a player that almost brought in cubes
;470:	CheckAlmostScored( self, attacker );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CheckAlmostScored
CALLV
pop
line 472
;471:
;472:	if (self->client && self->client->hook) {
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
EQU4 $192
ADDRLP4 28
INDIRP4
CNSTI4 764
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 32
INDIRU4
EQU4 $192
line 473
;473:		Weapon_HookFree(self->client->hook);
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
line 474
;474:	}
LABELV $192
line 482
;475:#ifdef MISSIONPACK
;476:	if ((self->client->ps.eFlags & EF_TICKING) && self->activator) {
;477:		self->client->ps.eFlags &= ~EF_TICKING;
;478:		self->activator->think = G_FreeEntity;
;479:		self->activator->nextthink = level.time;
;480:	}
;481:#endif
;482:	self->client->ps.pm_type = PM_DEAD;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 3
ASGNI4
line 484
;483:
;484:	if ( attacker ) {
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $194
line 485
;485:		killer = attacker->s.number;
ADDRLP4 4
ADDRFP4 8
INDIRP4
INDIRI4
ASGNI4
line 486
;486:		if ( attacker->client ) {
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $196
line 487
;487:			killerName = attacker->client->pers.netname;
ADDRLP4 16
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 512
ADDP4
ASGNP4
line 488
;488:		} else {
ADDRGP4 $195
JUMPV
LABELV $196
line 489
;489:			killerName = "<non-client>";
ADDRLP4 16
ADDRGP4 $198
ASGNP4
line 490
;490:		}
line 491
;491:	} else {
ADDRGP4 $195
JUMPV
LABELV $194
line 492
;492:		killer = ENTITYNUM_WORLD;
ADDRLP4 4
CNSTI4 1022
ASGNI4
line 493
;493:		killerName = "<world>";
ADDRLP4 16
ADDRGP4 $199
ASGNP4
line 494
;494:	}
LABELV $195
line 496
;495:
;496:	if ( killer < 0 || killer >= MAX_CLIENTS ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $202
ADDRLP4 4
INDIRI4
CNSTI4 64
LTI4 $200
LABELV $202
line 497
;497:		killer = ENTITYNUM_WORLD;
ADDRLP4 4
CNSTI4 1022
ASGNI4
line 498
;498:		killerName = "<world>";
ADDRLP4 16
ADDRGP4 $199
ASGNP4
line 499
;499:	}
LABELV $200
line 501
;500:
;501:	if ( meansOfDeath < 0 || meansOfDeath >= sizeof( modNames ) / sizeof( modNames[0] ) ) {
ADDRLP4 40
ADDRFP4 16
INDIRI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
LTI4 $205
ADDRLP4 40
INDIRI4
CVIU4 4
CNSTU4 24
LTU4 $203
LABELV $205
line 502
;502:		obit = "<bad obituary>";
ADDRLP4 20
ADDRGP4 $206
ASGNP4
line 503
;503:	} else {
ADDRGP4 $204
JUMPV
LABELV $203
line 504
;504:		obit = modNames[ meansOfDeath ];
ADDRLP4 20
ADDRFP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 modNames
ADDP4
INDIRP4
ASGNP4
line 505
;505:	}
LABELV $204
line 507
;506:
;507:	G_LogPrintf("Kill: %i %i %i: %s killed %s by %s\n", 
ADDRGP4 $207
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
line 512
;508:		killer, self->s.number, meansOfDeath, killerName, 
;509:		self->client->pers.netname, obit );
;510:
;511:	// broadcast the death event to everyone
;512:	ent = G_TempEntity( self->r.currentOrigin, EV_OBITUARY );
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
line 513
;513:	ent->s.eventParm = meansOfDeath;
ADDRLP4 8
INDIRP4
CNSTI4 184
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
line 514
;514:	ent->s.otherEntityNum = self->s.number;
ADDRLP4 8
INDIRP4
CNSTI4 140
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 515
;515:	ent->s.otherEntityNum2 = killer;
ADDRLP4 8
INDIRP4
CNSTI4 144
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 516
;516:	ent->r.svFlags = SVF_BROADCAST;	// send to everyone
ADDRLP4 8
INDIRP4
CNSTI4 424
ADDP4
CNSTI4 32
ASGNI4
line 518
;517:
;518:	self->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 520
;519:
;520:	self->client->ps.persistant[PERS_KILLED]++;
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
line 522
;521:
;522:	if (attacker && attacker->client) {
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
EQU4 $208
ADDRLP4 56
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 60
INDIRU4
EQU4 $208
line 523
;523:		attacker->client->lastkilled_client = self->s.number;
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
line 525
;524:
;525:		if ( attacker == self || OnSameTeam (self, attacker ) ) {
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
EQU4 $212
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
EQI4 $210
LABELV $212
line 526
;526:			AddScore( attacker, self->r.currentOrigin, -1 );
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
line 527
;527:		} else {
ADDRGP4 $209
JUMPV
LABELV $210
line 528
;528:			AddScore( attacker, self->r.currentOrigin, 1 );
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
line 530
;529:
;530:			if( meansOfDeath == MOD_GAUNTLET ) {
ADDRFP4 16
INDIRI4
CNSTI4 2
NEI4 $213
line 533
;531:				
;532:				// play humiliation on player
;533:				attacker->client->ps.persistant[PERS_GAUNTLET_FRAG_COUNT]++;
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
line 536
;534:
;535:				// add the sprite over the player's head
;536:				attacker->client->ps.eFlags &= ~(EF_AWARD_IMPRESSIVE | EF_AWARD_EXCELLENT | EF_AWARD_GAUNTLET | EF_AWARD_ASSIST | EF_AWARD_DEFEND | EF_AWARD_CAP );
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
line 537
;537:				attacker->client->ps.eFlags |= EF_AWARD_GAUNTLET;
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
line 538
;538:				attacker->client->rewardTime = level.time + REWARD_SPRITE_TIME;
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
line 541
;539:
;540:				// also play humiliation on target
;541:				self->client->ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_GAUNTLETREWARD;
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
line 542
;542:			}
LABELV $213
line 546
;543:
;544:			// check for two kills in a short amount of time
;545:			// if this is close enough to the last kill, give a reward sound
;546:			if ( level.time - attacker->client->lastKillTime < CARNAGE_REWARD_TIME ) {
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
GEI4 $216
line 548
;547:				// play excellent on player
;548:				attacker->client->ps.persistant[PERS_EXCELLENT_COUNT]++;
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
line 551
;549:
;550:				// add the sprite over the player's head
;551:				attacker->client->ps.eFlags &= ~(EF_AWARD_IMPRESSIVE | EF_AWARD_EXCELLENT | EF_AWARD_GAUNTLET | EF_AWARD_ASSIST | EF_AWARD_DEFEND | EF_AWARD_CAP );
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
line 552
;552:				attacker->client->ps.eFlags |= EF_AWARD_EXCELLENT;
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
line 553
;553:				attacker->client->rewardTime = level.time + REWARD_SPRITE_TIME;
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
line 554
;554:			}
LABELV $216
line 555
;555:			attacker->client->lastKillTime = level.time;
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
line 557
;556:
;557:		}
line 558
;558:	} else {
ADDRGP4 $209
JUMPV
LABELV $208
line 559
;559:		AddScore( self, self->r.currentOrigin, -1 );
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
line 560
;560:	}
LABELV $209
line 563
;561:
;562:	// Add team bonuses
;563:	Team_FragBonuses(self, inflictor, attacker);
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
line 566
;564:
;565:	// if I committed suicide, the flag does not fall, it returns.
;566:	if (meansOfDeath == MOD_SUICIDE) {
ADDRFP4 16
INDIRI4
CNSTI4 20
NEI4 $221
line 567
;567:		if ( self->client->ps.powerups[PW_NEUTRALFLAG] ) {		// only happens in One Flag CTF
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
CNSTI4 0
EQI4 $223
line 568
;568:			Team_ReturnFlag( TEAM_FREE );
CNSTI4 0
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 569
;569:			self->client->ps.powerups[PW_NEUTRALFLAG] = 0;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 348
ADDP4
CNSTI4 0
ASGNI4
line 570
;570:		}
ADDRGP4 $224
JUMPV
LABELV $223
line 571
;571:		else if ( self->client->ps.powerups[PW_REDFLAG] ) {		// only happens in standard CTF
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 340
ADDP4
INDIRI4
CNSTI4 0
EQI4 $225
line 572
;572:			Team_ReturnFlag( TEAM_RED );
CNSTI4 1
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 573
;573:			self->client->ps.powerups[PW_REDFLAG] = 0;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 340
ADDP4
CNSTI4 0
ASGNI4
line 574
;574:		}
ADDRGP4 $226
JUMPV
LABELV $225
line 575
;575:		else if ( self->client->ps.powerups[PW_BLUEFLAG] ) {	// only happens in standard CTF
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
CNSTI4 0
EQI4 $227
line 576
;576:			Team_ReturnFlag( TEAM_BLUE );
CNSTI4 2
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 577
;577:			self->client->ps.powerups[PW_BLUEFLAG] = 0;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 344
ADDP4
CNSTI4 0
ASGNI4
line 578
;578:		}
LABELV $227
LABELV $226
LABELV $224
line 579
;579:	}
LABELV $221
line 582
;580:
;581:	// if client is in a nodrop area, don't drop anything (but return CTF flags!)
;582:	contents = trap_PointContents( self->r.currentOrigin, -1 );
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
line 583
;583:	if ( !( contents & CONTENTS_NODROP )) {
ADDRLP4 12
INDIRI4
CVIU4 4
CNSTU4 2147483648
BANDU4
CNSTU4 0
NEU4 $229
line 584
;584:		TossClientItems( self );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 TossClientItems
CALLV
pop
line 585
;585:	}
ADDRGP4 $230
JUMPV
LABELV $229
line 586
;586:	else {
line 587
;587:		if ( self->client->ps.powerups[PW_NEUTRALFLAG] ) {		// only happens in One Flag CTF
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
CNSTI4 0
EQI4 $231
line 588
;588:			Team_ReturnFlag( TEAM_FREE );
CNSTI4 0
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 589
;589:		}
ADDRGP4 $232
JUMPV
LABELV $231
line 590
;590:		else if ( self->client->ps.powerups[PW_REDFLAG] ) {		// only happens in standard CTF
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 340
ADDP4
INDIRI4
CNSTI4 0
EQI4 $233
line 591
;591:			Team_ReturnFlag( TEAM_RED );
CNSTI4 1
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 592
;592:		}
ADDRGP4 $234
JUMPV
LABELV $233
line 593
;593:		else if ( self->client->ps.powerups[PW_BLUEFLAG] ) {	// only happens in standard CTF
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
CNSTI4 0
EQI4 $235
line 594
;594:			Team_ReturnFlag( TEAM_BLUE );
CNSTI4 2
ARGI4
ADDRGP4 Team_ReturnFlag
CALLV
pop
line 595
;595:		}
LABELV $235
LABELV $234
LABELV $232
line 596
;596:	}
LABELV $230
line 604
;597:#ifdef MISSIONPACK
;598:	TossClientPersistantPowerups( self );
;599:	if( g_gametype.integer == GT_HARVESTER ) {
;600:		TossClientCubes( self );
;601:	}
;602:#endif
;603:
;604:	Cmd_Score_f( self );		// show scores
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 Cmd_Score_f
CALLV
pop
line 607
;605:	// send updated scores to any clients that are following this one,
;606:	// or they would get stale scoreboards
;607:	for ( i = 0 ; i < level.maxclients ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $240
JUMPV
LABELV $237
line 610
;608:		gclient_t	*client;
;609:
;610:		client = &level.clients[i];
ADDRLP4 68
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 611
;611:		if ( client->pers.connected != CON_CONNECTED ) {
ADDRLP4 68
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $242
line 612
;612:			continue;
ADDRGP4 $238
JUMPV
LABELV $242
line 614
;613:		}
;614:		if ( client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRLP4 68
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $244
line 615
;615:			continue;
ADDRGP4 $238
JUMPV
LABELV $244
line 617
;616:		}
;617:		if ( client->sess.spectatorClient == self->s.number ) {
ADDRLP4 68
INDIRP4
CNSTI4 628
ADDP4
INDIRI4
ADDRFP4 0
INDIRP4
INDIRI4
NEI4 $246
line 618
;618:			Cmd_Score_f( g_entities + i );
CNSTI4 808
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ARGP4
ADDRGP4 Cmd_Score_f
CALLV
pop
line 619
;619:		}
LABELV $246
line 620
;620:	}
LABELV $238
line 607
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $240
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $237
line 622
;621:
;622:	self->takedamage = qtrue;	// can still be gibbed
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 624
;623:
;624:	self->s.weapon = WP_NONE;
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 625
;625:	self->s.powerups = 0;
ADDRFP4 0
INDIRP4
CNSTI4 188
ADDP4
CNSTI4 0
ASGNI4
line 626
;626:	self->r.contents = CONTENTS_CORPSE;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 67108864
ASGNI4
line 628
;627:
;628:	self->s.angles[0] = 0;
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTF4 0
ASGNF4
line 629
;629:	self->s.angles[2] = 0;
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
CNSTF4 0
ASGNF4
line 630
;630:	LookAtKiller (self, inflictor, attacker);
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
line 632
;631:
;632:	VectorCopy( self->s.angles, self->client->ps.viewangles );
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
line 634
;633:
;634:	self->s.loopSound = 0;
ADDRFP4 0
INDIRP4
CNSTI4 156
ADDP4
CNSTI4 0
ASGNI4
line 636
;635:
;636:	self->r.maxs[2] = -8;
ADDRFP4 0
INDIRP4
CNSTI4 456
ADDP4
CNSTF4 3238002688
ASGNF4
line 640
;637:
;638:	// don't allow respawn until the death anim is done
;639:	// g_forcerespawn may force spawning at some later time
;640:	self->client->respawnTime = level.time + 1700;
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
line 643
;641:
;642:	// remove powerups
;643:	memset( self->client->ps.powerups, 0, sizeof(self->client->ps.powerups) );
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
line 646
;644:
;645:	// never gib in a nodrop
;646:	if ( (self->health <= GIB_HEALTH && !(contents & CONTENTS_NODROP) && g_blood.integer) || meansOfDeath == MOD_SUICIDE) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -40
GTI4 $254
ADDRLP4 12
INDIRI4
CVIU4 4
CNSTU4 2147483648
BANDU4
CNSTU4 0
NEU4 $254
ADDRGP4 g_blood+12
INDIRI4
CNSTI4 0
NEI4 $252
LABELV $254
ADDRFP4 16
INDIRI4
CNSTI4 20
NEI4 $249
LABELV $252
line 648
;647:		// gib death
;648:		GibEntity( self, killer );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 GibEntity
CALLV
pop
line 649
;649:	} else {
ADDRGP4 $250
JUMPV
LABELV $249
line 653
;650:		// normal death
;651:		static int i;
;652:
;653:		switch ( i ) {
ADDRLP4 72
ADDRGP4 $255
INDIRI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $258
ADDRLP4 72
INDIRI4
CNSTI4 1
EQI4 $259
ADDRLP4 72
INDIRI4
CNSTI4 2
EQI4 $260
ADDRGP4 $256
JUMPV
LABELV $258
line 655
;654:		case 0:
;655:			anim = BOTH_DEATH1;
ADDRLP4 24
CNSTI4 0
ASGNI4
line 656
;656:			break;
ADDRGP4 $257
JUMPV
LABELV $259
line 658
;657:		case 1:
;658:			anim = BOTH_DEATH2;
ADDRLP4 24
CNSTI4 2
ASGNI4
line 659
;659:			break;
ADDRGP4 $257
JUMPV
LABELV $260
LABELV $256
line 662
;660:		case 2:
;661:		default:
;662:			anim = BOTH_DEATH3;
ADDRLP4 24
CNSTI4 4
ASGNI4
line 663
;663:			break;
LABELV $257
line 668
;664:		}
;665:
;666:		// for the no-blood option, we need to prevent the health
;667:		// from going to gib level
;668:		if ( self->health <= GIB_HEALTH ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -40
GTI4 $261
line 669
;669:			self->health = GIB_HEALTH+1;
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
CNSTI4 -39
ASGNI4
line 670
;670:		}
LABELV $261
line 672
;671:
;672:		self->client->ps.legsAnim = 
ADDRLP4 76
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 80
CNSTI4 128
ASGNI4
ADDRLP4 76
INDIRP4
ADDRLP4 76
INDIRP4
INDIRI4
ADDRLP4 80
INDIRI4
BANDI4
ADDRLP4 80
INDIRI4
BXORI4
ADDRLP4 24
INDIRI4
BORI4
ASGNI4
line 674
;673:			( ( self->client->ps.legsAnim & ANIM_TOGGLEBIT ) ^ ANIM_TOGGLEBIT ) | anim;
;674:		self->client->ps.torsoAnim = 
ADDRLP4 84
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 84
ADDP4
ASGNP4
ADDRLP4 88
CNSTI4 128
ASGNI4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRI4
ADDRLP4 88
INDIRI4
BANDI4
ADDRLP4 88
INDIRI4
BXORI4
ADDRLP4 24
INDIRI4
BORI4
ASGNI4
line 677
;675:			( ( self->client->ps.torsoAnim & ANIM_TOGGLEBIT ) ^ ANIM_TOGGLEBIT ) | anim;
;676:
;677:		G_AddEvent( self, EV_DEATH1 + i, killer );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $255
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
line 680
;678:
;679:		// the body can still be gibbed
;680:		self->die = body_die;
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 body_die
ASGNP4
line 683
;681:
;682:		// globally cycle through the different death animations
;683:		i = ( i + 1 ) % 3;
ADDRLP4 92
ADDRGP4 $255
ASGNP4
ADDRLP4 92
INDIRP4
ADDRLP4 92
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
CNSTI4 3
MODI4
ASGNI4
line 690
;684:
;685:#ifdef MISSIONPACK
;686:		if (self->s.eFlags & EF_KAMIKAZE) {
;687:			Kamikaze_DeathTimer( self );
;688:		}
;689:#endif
;690:	}
LABELV $250
line 692
;691:
;692:	trap_LinkEntity (self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 694
;693:
;694:}
LABELV $186
endproc player_die 96 28
export CheckArmor
proc CheckArmor 20 4
line 703
;695:
;696:
;697:/*
;698:================
;699:CheckArmor
;700:================
;701:*/
;702:int CheckArmor (gentity_t *ent, int damage, int dflags)
;703:{
line 708
;704:	gclient_t	*client;
;705:	int			save;
;706:	int			count;
;707:
;708:	if (!damage)
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $264
line 709
;709:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $263
JUMPV
LABELV $264
line 711
;710:
;711:	client = ent->client;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 713
;712:
;713:	if (!client)
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $266
line 714
;714:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $263
JUMPV
LABELV $266
line 716
;715:
;716:	if (dflags & DAMAGE_NO_ARMOR)
ADDRFP4 8
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $268
line 717
;717:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $263
JUMPV
LABELV $268
line 720
;718:
;719:	// armor
;720:	count = client->ps.stats[STAT_ARMOR];
ADDRLP4 8
ADDRLP4 4
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ASGNI4
line 721
;721:	save = ceil( damage * ARMOR_PROTECTION );
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
line 722
;722:	if (save >= count)
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $270
line 723
;723:		save = count;
ADDRLP4 0
ADDRLP4 8
INDIRI4
ASGNI4
LABELV $270
line 725
;724:
;725:	if (!save)
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $272
line 726
;726:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $263
JUMPV
LABELV $272
line 728
;727:
;728:	client->ps.stats[STAT_ARMOR] -= save;
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
line 730
;729:
;730:	return save;
ADDRLP4 0
INDIRI4
RETI4
LABELV $263
endproc CheckArmor 20 4
export RaySphereIntersections
proc RaySphereIntersections 96 4
line 738
;731:}
;732:
;733:/*
;734:================
;735:RaySphereIntersections
;736:================
;737:*/
;738:int RaySphereIntersections( vec3_t origin, float radius, vec3_t point, vec3_t dir, vec3_t intersections[2] ) {
line 747
;739:	float b, c, d, t;
;740:
;741:	//	| origin - (point + t * dir) | = radius
;742:	//	a = dir[0]^2 + dir[1]^2 + dir[2]^2;
;743:	//	b = 2 * (dir[0] * (point[0] - origin[0]) + dir[1] * (point[1] - origin[1]) + dir[2] * (point[2] - origin[2]));
;744:	//	c = (point[0] - origin[0])^2 + (point[1] - origin[1])^2 + (point[2] - origin[2])^2 - radius^2;
;745:
;746:	// normalize dir so a = 1
;747:	VectorNormalize(dir);
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 748
;748:	b = 2 * (dir[0] * (point[0] - origin[0]) + dir[1] * (point[1] - origin[1]) + dir[2] * (point[2] - origin[2]));
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
line 749
;749:	c = (point[0] - origin[0]) * (point[0] - origin[0]) +
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
line 754
;750:		(point[1] - origin[1]) * (point[1] - origin[1]) +
;751:		(point[2] - origin[2]) * (point[2] - origin[2]) -
;752:		radius * radius;
;753:
;754:	d = b * b - 4 * c;
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
line 755
;755:	if (d > 0) {
ADDRLP4 8
INDIRF4
CNSTF4 0
LEF4 $275
line 756
;756:		t = (- b + sqrt(d)) / 2;
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
line 757
;757:		VectorMA(point, t, dir, intersections[0]);
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
line 758
;758:		t = (- b - sqrt(d)) / 2;
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
line 759
;759:		VectorMA(point, t, dir, intersections[1]);
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
line 760
;760:		return 2;
CNSTI4 2
RETI4
ADDRGP4 $274
JUMPV
LABELV $275
line 762
;761:	}
;762:	else if (d == 0) {
ADDRLP4 8
INDIRF4
CNSTF4 0
NEF4 $277
line 763
;763:		t = (- b ) / 2;
ADDRLP4 0
ADDRLP4 4
INDIRF4
NEGF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 764
;764:		VectorMA(point, t, dir, intersections[0]);
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
line 765
;765:		return 1;
CNSTI4 1
RETI4
ADDRGP4 $274
JUMPV
LABELV $277
line 767
;766:	}
;767:	return 0;
CNSTI4 0
RETI4
LABELV $274
endproc RaySphereIntersections 96 4
export G_Damage
proc G_Damage 80 24
line 834
;768:}
;769:
;770:#ifdef MISSIONPACK
;771:/*
;772:================
;773:G_InvulnerabilityEffect
;774:================
;775:*/
;776:int G_InvulnerabilityEffect( gentity_t *targ, vec3_t dir, vec3_t point, vec3_t impactpoint, vec3_t bouncedir ) {
;777:	gentity_t	*impact;
;778:	vec3_t		intersections[2], vec;
;779:	int			n;
;780:
;781:	if ( !targ->client ) {
;782:		return qfalse;
;783:	}
;784:	VectorCopy(dir, vec);
;785:	VectorInverse(vec);
;786:	// sphere model radius = 42 units
;787:	n = RaySphereIntersections( targ->client->ps.origin, 42, point, vec, intersections);
;788:	if (n > 0) {
;789:		impact = G_TempEntity( targ->client->ps.origin, EV_INVUL_IMPACT );
;790:		VectorSubtract(intersections[0], targ->client->ps.origin, vec);
;791:		vectoangles(vec, impact->s.angles);
;792:		impact->s.angles[0] += 90;
;793:		if (impact->s.angles[0] > 360)
;794:			impact->s.angles[0] -= 360;
;795:		if ( impactpoint ) {
;796:			VectorCopy( intersections[0], impactpoint );
;797:		}
;798:		if ( bouncedir ) {
;799:			VectorCopy( vec, bouncedir );
;800:			VectorNormalize( bouncedir );
;801:		}
;802:		return qtrue;
;803:	}
;804:	else {
;805:		return qfalse;
;806:	}
;807:}
;808:#endif
;809:/*
;810:============
;811:T_Damage
;812:
;813:targ		entity that is being damaged
;814:inflictor	entity that is causing the damage
;815:attacker	entity that caused the inflictor to damage targ
;816:	example: targ=monster, inflictor=rocket, attacker=player
;817:
;818:dir			direction of the attack for knockback
;819:point		point at which the damage is being inflicted, used for headshots
;820:damage		amount of damage being inflicted
;821:knockback	force to be applied against targ as a result of the damage
;822:
;823:inflictor, attacker, dir, and point can be NULL for environmental effects
;824:
;825:dflags		these flags are used to control how T_Damage works
;826:	DAMAGE_RADIUS			damage was indirect (from a nearby explosion)
;827:	DAMAGE_NO_ARMOR			armor does not protect from this damage
;828:	DAMAGE_NO_KNOCKBACK		do not affect velocity, just view angles
;829:	DAMAGE_NO_PROTECTION	kills godmode, armor, everything
;830:============
;831:*/
;832:
;833:void G_Damage( gentity_t *targ, gentity_t *inflictor, gentity_t *attacker,
;834:			   vec3_t dir, vec3_t point, int damage, int dflags, int mod ) {
line 845
;835:	gclient_t	*client;
;836:	int			take;
;837:	int			save;
;838:	int			asave;
;839:	int			knockback;
;840:	int			max;
;841:#ifdef MISSIONPACK
;842:	vec3_t		bouncedir, impactpoint;
;843:#endif
;844:
;845:	if (!targ->takedamage) {
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
CNSTI4 0
NEI4 $280
line 846
;846:		return;
ADDRGP4 $279
JUMPV
LABELV $280
line 851
;847:	}
;848:
;849:	// the intermission has allready been qualified for, so don't
;850:	// allow any extra scoring
;851:	if ( level.intermissionQueued ) {
ADDRGP4 level+9124
INDIRI4
CNSTI4 0
EQI4 $282
line 852
;852:		return;
ADDRGP4 $279
JUMPV
LABELV $282
line 864
;853:	}
;854:#ifdef MISSIONPACK
;855:	if ( targ->client && mod != MOD_JUICED) {
;856:		if ( targ->client->invulnerabilityTime > level.time) {
;857:			if ( dir && point ) {
;858:				G_InvulnerabilityEffect( targ, dir, point, impactpoint, bouncedir );
;859:			}
;860:			return;
;861:		}
;862:	}
;863:#endif
;864:	if ( !inflictor ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $285
line 865
;865:		inflictor = &g_entities[ENTITYNUM_WORLD];
ADDRFP4 4
ADDRGP4 g_entities+825776
ASGNP4
line 866
;866:	}
LABELV $285
line 867
;867:	if ( !attacker ) {
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $288
line 868
;868:		attacker = &g_entities[ENTITYNUM_WORLD];
ADDRFP4 8
ADDRGP4 g_entities+825776
ASGNP4
line 869
;869:	}
LABELV $288
line 872
;870:
;871:	// shootable doors / buttons don't actually have any health
;872:	if ( targ->s.eType == ET_MOVER ) {
ADDRLP4 24
CNSTI4 4
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $291
line 873
;873:		if ( targ->use && targ->moverState == MOVER_POS1 ) {
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 708
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $279
ADDRLP4 28
INDIRP4
CNSTI4 576
ADDP4
INDIRI4
CNSTI4 0
NEI4 $279
line 874
;874:			targ->use( targ, inflictor, attacker );
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 32
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 32
INDIRP4
CNSTI4 708
ADDP4
INDIRP4
CALLV
pop
line 875
;875:		}
line 876
;876:		return;
ADDRGP4 $279
JUMPV
LABELV $291
line 885
;877:	}
;878:#ifdef MISSIONPACK
;879:	if( g_gametype.integer == GT_OBELISK && CheckObeliskAttack( targ, attacker ) ) {
;880:		return;
;881:	}
;882:#endif
;883:	// reduce damage by the attacker's handicap value
;884:	// unless they are rocket jumping
;885:	if ( attacker->client && attacker != targ ) {
ADDRLP4 28
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $295
ADDRLP4 28
INDIRP4
CVPU4 4
ADDRFP4 0
INDIRP4
CVPU4 4
EQU4 $295
line 886
;886:		max = attacker->client->ps.stats[STAT_MAX_HEALTH];
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
line 892
;887:#ifdef MISSIONPACK
;888:		if( bg_itemlist[attacker->client->ps.stats[STAT_PERSISTANT_POWERUP]].giTag == PW_GUARD ) {
;889:			max /= 2;
;890:		}
;891:#endif
;892:		damage = damage * max / 100;
ADDRFP4 20
ADDRFP4 20
INDIRI4
ADDRLP4 20
INDIRI4
MULI4
CNSTI4 100
DIVI4
ASGNI4
line 893
;893:	}
LABELV $295
line 895
;894:
;895:	client = targ->client;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 897
;896:
;897:	if ( client ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $297
line 898
;898:		if ( client->noclip ) {
ADDRLP4 0
INDIRP4
CNSTI4 648
ADDP4
INDIRI4
CNSTI4 0
EQI4 $299
line 899
;899:			return;
ADDRGP4 $279
JUMPV
LABELV $299
line 901
;900:		}
;901:	}
LABELV $297
line 903
;902:
;903:	if ( !dir ) {
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $301
line 904
;904:		dflags |= DAMAGE_NO_KNOCKBACK;
ADDRFP4 24
ADDRFP4 24
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 905
;905:	} else {
ADDRGP4 $302
JUMPV
LABELV $301
line 906
;906:		VectorNormalize(dir);
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 907
;907:	}
LABELV $302
line 909
;908:
;909:	knockback = damage;
ADDRLP4 4
ADDRFP4 20
INDIRI4
ASGNI4
line 910
;910:	if ( knockback > 200 ) {
ADDRLP4 4
INDIRI4
CNSTI4 200
LEI4 $303
line 911
;911:		knockback = 200;
ADDRLP4 4
CNSTI4 200
ASGNI4
line 912
;912:	}
LABELV $303
line 913
;913:	if ( targ->flags & FL_NO_KNOCKBACK ) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 2048
BANDI4
CNSTI4 0
EQI4 $305
line 914
;914:		knockback = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 915
;915:	}
LABELV $305
line 916
;916:	if ( dflags & DAMAGE_NO_KNOCKBACK ) {
ADDRFP4 24
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $307
line 917
;917:		knockback = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 918
;918:	}
LABELV $307
line 921
;919:
;920:	// figure momentum add, even if the damage won't be taken
;921:	if ( knockback && targ->client ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $309
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $309
line 925
;922:		vec3_t	kvel;
;923:		float	mass;
;924:
;925:		mass = 200;
ADDRLP4 44
CNSTF4 1128792064
ASGNF4
line 927
;926:
;927:		VectorScale (dir, g_knockback.value * (float)knockback / mass, kvel);
ADDRLP4 48
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 52
ADDRLP4 4
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 56
ADDRLP4 44
INDIRF4
ASGNF4
ADDRLP4 32
ADDRLP4 48
INDIRP4
INDIRF4
ADDRGP4 g_knockback+8
INDIRF4
ADDRLP4 52
INDIRF4
MULF4
ADDRLP4 56
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 32+4
ADDRLP4 48
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 g_knockback+8
INDIRF4
ADDRLP4 52
INDIRF4
MULF4
ADDRLP4 56
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 32+8
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
ADDRLP4 44
INDIRF4
DIVF4
MULF4
ASGNF4
line 928
;928:		VectorAdd (targ->client->ps.velocity, kvel, targ->client->ps.velocity);
ADDRLP4 60
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 32
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
ADDRLP4 32
INDIRF4
ADDF4
ASGNF4
ADDRLP4 64
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 36
ADDP4
ASGNP4
ADDRLP4 64
INDIRP4
ADDRLP4 64
INDIRP4
INDIRF4
ADDRLP4 32+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 68
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 40
ADDP4
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRF4
ADDRLP4 32+8
INDIRF4
ADDF4
ASGNF4
line 932
;929:
;930:		// set the timer so that the other client can't cancel
;931:		// out the movement immediately
;932:		if ( !targ->client->ps.pm_time ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 0
NEI4 $318
line 935
;933:			int		t;
;934:
;935:			t = knockback * 2;
ADDRLP4 72
ADDRLP4 4
INDIRI4
CNSTI4 1
LSHI4
ASGNI4
line 936
;936:			if ( t < 50 ) {
ADDRLP4 72
INDIRI4
CNSTI4 50
GEI4 $320
line 937
;937:				t = 50;
ADDRLP4 72
CNSTI4 50
ASGNI4
line 938
;938:			}
LABELV $320
line 939
;939:			if ( t > 200 ) {
ADDRLP4 72
INDIRI4
CNSTI4 200
LEI4 $322
line 940
;940:				t = 200;
ADDRLP4 72
CNSTI4 200
ASGNI4
line 941
;941:			}
LABELV $322
line 942
;942:			targ->client->ps.pm_time = t;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 16
ADDP4
ADDRLP4 72
INDIRI4
ASGNI4
line 943
;943:			targ->client->ps.pm_flags |= PMF_TIME_KNOCKBACK;
ADDRLP4 76
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 76
INDIRP4
ADDRLP4 76
INDIRP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 944
;944:		}
LABELV $318
line 945
;945:	}
LABELV $309
line 948
;946:
;947:	// check for completely getting out of the damage
;948:	if ( !(dflags & DAMAGE_NO_PROTECTION) ) {
ADDRFP4 24
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
NEI4 $324
line 955
;949:
;950:		// if TF_NO_FRIENDLY_FIRE is set, don't do damage to the target
;951:		// if the attacker was on the same team
;952:#ifdef MISSIONPACK
;953:		if ( mod != MOD_JUICED && targ != attacker && !(dflags & DAMAGE_NO_TEAM_PROTECTION) && OnSameTeam (targ, attacker)  ) {
;954:#else	
;955:		if ( targ != attacker && OnSameTeam (targ, attacker)  ) {
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 36
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 32
INDIRP4
CVPU4 4
ADDRLP4 36
INDIRP4
CVPU4 4
EQU4 $326
ADDRLP4 32
INDIRP4
ARGP4
ADDRLP4 36
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 OnSameTeam
CALLI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
EQI4 $326
line 957
;956:#endif
;957:			if ( !g_friendlyFire.integer ) {
ADDRGP4 g_friendlyFire+12
INDIRI4
CNSTI4 0
NEI4 $328
line 958
;958:				return;
ADDRGP4 $279
JUMPV
LABELV $328
line 960
;959:			}
;960:		}
LABELV $326
line 973
;961:#ifdef MISSIONPACK
;962:		if (mod == MOD_PROXIMITY_MINE) {
;963:			if (inflictor && inflictor->parent && OnSameTeam(targ, inflictor->parent)) {
;964:				return;
;965:			}
;966:			if (targ == attacker) {
;967:				return;
;968:			}
;969:		}
;970:#endif
;971:
;972:		// check for godmode
;973:		if ( targ->flags & FL_GODMODE ) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $331
line 974
;974:			return;
ADDRGP4 $279
JUMPV
LABELV $331
line 976
;975:		}
;976:	}
LABELV $324
line 980
;977:
;978:	// battlesuit protects from all radius damage (but takes knockback)
;979:	// and protects 50% against all damage
;980:	if ( client && client->ps.powerups[PW_BATTLESUIT] ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $333
ADDRLP4 0
INDIRP4
CNSTI4 320
ADDP4
INDIRI4
CNSTI4 0
EQI4 $333
line 981
;981:		G_AddEvent( targ, EV_POWERUP_BATTLESUIT, 0 );
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
line 982
;982:		if ( ( dflags & DAMAGE_RADIUS ) || ( mod == MOD_FALLING ) ) {
ADDRFP4 24
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $337
ADDRFP4 28
INDIRI4
CNSTI4 19
NEI4 $335
LABELV $337
line 983
;983:			return;
ADDRGP4 $279
JUMPV
LABELV $335
line 985
;984:		}
;985:		damage *= 0.5;
ADDRFP4 20
CNSTF4 1056964608
ADDRFP4 20
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 986
;986:	}
LABELV $333
line 989
;987:
;988:	// add to the attacker's hit counter (if the target isn't a general entity like a prox mine)
;989:	if ( attacker->client && targ != attacker && targ->health > 0
ADDRLP4 36
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 36
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $338
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 40
INDIRP4
CVPU4 4
ADDRLP4 36
INDIRP4
CVPU4 4
EQU4 $338
ADDRLP4 44
CNSTI4 0
ASGNI4
ADDRLP4 40
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 44
INDIRI4
LEI4 $338
ADDRLP4 48
ADDRLP4 40
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 3
EQI4 $338
ADDRLP4 48
INDIRI4
ADDRLP4 44
INDIRI4
EQI4 $338
line 991
;990:			&& targ->s.eType != ET_MISSILE
;991:			&& targ->s.eType != ET_GENERAL) {
line 992
;992:		if ( OnSameTeam( targ, attacker ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 52
ADDRGP4 OnSameTeam
CALLI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 0
EQI4 $340
line 993
;993:			attacker->client->ps.persistant[PERS_HITS]--;
ADDRLP4 56
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 252
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 994
;994:		} else {
ADDRGP4 $341
JUMPV
LABELV $340
line 995
;995:			attacker->client->ps.persistant[PERS_HITS]++;
ADDRLP4 56
ADDRFP4 8
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 252
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 996
;996:		}
LABELV $341
line 997
;997:		attacker->client->ps.persistant[PERS_ATTACKEE_ARMOR] = (targ->health<<8)|(client->ps.stats[STAT_ARMOR]);
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
line 998
;998:	}
LABELV $338
line 1002
;999:
;1000:	// always give half damage if hurting self
;1001:	// calculated after knockback, so rocket jumping works
;1002:	if ( targ == attacker) {
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRFP4 8
INDIRP4
CVPU4 4
NEU4 $342
line 1003
;1003:		damage *= 0.5;
ADDRFP4 20
CNSTF4 1056964608
ADDRFP4 20
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 1004
;1004:	}
LABELV $342
line 1006
;1005:
;1006:	if ( damage < 1 ) {
ADDRFP4 20
INDIRI4
CNSTI4 1
GEI4 $344
line 1007
;1007:		damage = 1;
ADDRFP4 20
CNSTI4 1
ASGNI4
line 1008
;1008:	}
LABELV $344
line 1009
;1009:	take = damage;
ADDRLP4 8
ADDRFP4 20
INDIRI4
ASGNI4
line 1010
;1010:	save = 0;
ADDRLP4 16
CNSTI4 0
ASGNI4
line 1013
;1011:
;1012:	// save some from armor
;1013:	asave = CheckArmor (targ, take, dflags);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRFP4 24
INDIRI4
ARGI4
ADDRLP4 52
ADDRGP4 CheckArmor
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 52
INDIRI4
ASGNI4
line 1014
;1014:	take -= asave;
ADDRLP4 8
ADDRLP4 8
INDIRI4
ADDRLP4 12
INDIRI4
SUBI4
ASGNI4
line 1016
;1015:
;1016:	if ( g_debugDamage.integer ) {
ADDRGP4 g_debugDamage+12
INDIRI4
CNSTI4 0
EQI4 $346
line 1017
;1017:		G_Printf( "%i: client:%i health:%i damage:%i armor:%i\n", level.time, targ->s.number,
ADDRGP4 $349
ARGP4
ADDRGP4 level+32
INDIRI4
ARGI4
ADDRLP4 56
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 56
INDIRP4
INDIRI4
ARGI4
ADDRLP4 56
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
line 1019
;1018:			targ->health, take, asave );
;1019:	}
LABELV $346
line 1024
;1020:
;1021:	// add to the damage inflicted on a player this frame
;1022:	// the total will be turned into screen blends and view angle kicks
;1023:	// at the end of the frame
;1024:	if ( client ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $351
line 1025
;1025:		if ( attacker ) {
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $353
line 1026
;1026:			client->ps.persistant[PERS_ATTACKER] = attacker->s.number;
ADDRLP4 0
INDIRP4
CNSTI4 272
ADDP4
ADDRFP4 8
INDIRP4
INDIRI4
ASGNI4
line 1027
;1027:		} else {
ADDRGP4 $354
JUMPV
LABELV $353
line 1028
;1028:			client->ps.persistant[PERS_ATTACKER] = ENTITYNUM_WORLD;
ADDRLP4 0
INDIRP4
CNSTI4 272
ADDP4
CNSTI4 1022
ASGNI4
line 1029
;1029:		}
LABELV $354
line 1030
;1030:		client->damage_armor += asave;
ADDRLP4 56
ADDRLP4 0
INDIRP4
CNSTI4 684
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRI4
ADDRLP4 12
INDIRI4
ADDI4
ASGNI4
line 1031
;1031:		client->damage_blood += take;
ADDRLP4 60
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRI4
ADDRLP4 8
INDIRI4
ADDI4
ASGNI4
line 1032
;1032:		client->damage_knockback += knockback;
ADDRLP4 64
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ASGNP4
ADDRLP4 64
INDIRP4
ADDRLP4 64
INDIRP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDI4
ASGNI4
line 1033
;1033:		if ( dir ) {
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $355
line 1034
;1034:			VectorCopy ( dir, client->damage_from );
ADDRLP4 0
INDIRP4
CNSTI4 696
ADDP4
ADDRFP4 12
INDIRP4
INDIRB
ASGNB 12
line 1035
;1035:			client->damage_fromWorld = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 708
ADDP4
CNSTI4 0
ASGNI4
line 1036
;1036:		} else {
ADDRGP4 $356
JUMPV
LABELV $355
line 1037
;1037:			VectorCopy ( targ->r.currentOrigin, client->damage_from );
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
line 1038
;1038:			client->damage_fromWorld = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 708
ADDP4
CNSTI4 1
ASGNI4
line 1039
;1039:		}
LABELV $356
line 1040
;1040:	}
LABELV $351
line 1046
;1041:
;1042:	// See if it's the player hurting the emeny flag carrier
;1043:#ifdef MISSIONPACK
;1044:	if( g_gametype.integer == GT_CTF || g_gametype.integer == GT_1FCTF ) {
;1045:#else	
;1046:	if( g_gametype.integer == GT_CTF) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
NEI4 $357
line 1048
;1047:#endif
;1048:		Team_CheckHurtCarrier(targ, attacker);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 Team_CheckHurtCarrier
CALLV
pop
line 1049
;1049:	}
LABELV $357
line 1051
;1050:
;1051:	if (targ->client) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $360
line 1053
;1052:		// set the last client who damaged the target
;1053:		targ->client->lasthurt_client = attacker->s.number;
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
line 1054
;1054:		targ->client->lasthurt_mod = mod;
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
line 1055
;1055:	}
LABELV $360
line 1058
;1056:
;1057:	// do the damage
;1058:	if (take) {
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $362
line 1059
;1059:		targ->health = targ->health - take;
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRI4
ADDRLP4 8
INDIRI4
SUBI4
ASGNI4
line 1060
;1060:		if ( targ->client ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $364
line 1061
;1061:			targ->client->ps.stats[STAT_HEALTH] = targ->health;
ADDRLP4 60
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 60
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 60
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ASGNI4
line 1062
;1062:		}
LABELV $364
line 1064
;1063:			
;1064:		if ( targ->health <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $366
line 1065
;1065:			if ( client )
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $368
line 1066
;1066:				targ->flags |= FL_NO_KNOCKBACK;
ADDRLP4 60
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRI4
CNSTI4 2048
BORI4
ASGNI4
LABELV $368
line 1068
;1067:
;1068:			if (targ->health < -999)
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -999
GEI4 $370
line 1069
;1069:				targ->health = -999;
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
CNSTI4 -999
ASGNI4
LABELV $370
line 1071
;1070:
;1071:			targ->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 1072
;1072:			targ->die (targ, inflictor, attacker, take, mod);
ADDRLP4 64
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 64
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
ADDRLP4 64
INDIRP4
CNSTI4 716
ADDP4
INDIRP4
CALLV
pop
line 1073
;1073:			return;
ADDRGP4 $279
JUMPV
LABELV $366
line 1074
;1074:		} else if ( targ->pain ) {
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $372
line 1075
;1075:			targ->pain (targ, attacker, take);
ADDRLP4 60
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 60
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 60
INDIRP4
CNSTI4 712
ADDP4
INDIRP4
CALLV
pop
line 1076
;1076:		}
LABELV $372
line 1077
;1077:	}
LABELV $362
line 1079
;1078:
;1079:}
LABELV $279
endproc G_Damage 80 24
export CanDamage
proc CanDamage 112 28
line 1090
;1080:
;1081:
;1082:/*
;1083:============
;1084:CanDamage
;1085:
;1086:Returns qtrue if the inflictor can directly damage the target.  Used for
;1087:explosions and melee attacks.
;1088:============
;1089:*/
;1090:qboolean CanDamage (gentity_t *targ, vec3_t origin) {
line 1097
;1091:	vec3_t	dest;
;1092:	trace_t	tr;
;1093:	vec3_t	midpoint;
;1094:
;1095:	// use the midpoint of the bounds instead of the origin, because
;1096:	// bmodels may have their origin is 0,0,0
;1097:	VectorAdd (targ->r.absmin, targ->r.absmax, midpoint);
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
line 1098
;1098:	VectorScale (midpoint, 0.5, midpoint);
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
line 1100
;1099:
;1100:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1101
;1101:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
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
line 1102
;1102:	if (tr.fraction == 1.0 || tr.entityNum == targ->s.number)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
EQF4 $385
ADDRLP4 24+52
INDIRI4
ADDRFP4 0
INDIRP4
INDIRI4
NEI4 $381
LABELV $385
line 1103
;1103:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $374
JUMPV
LABELV $381
line 1107
;1104:
;1105:	// this should probably check in the plane of projection, 
;1106:	// rather than in world coordinate, and also include Z
;1107:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1108
;1108:	dest[0] += 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1109
;1109:	dest[1] += 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1110
;1110:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
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
line 1111
;1111:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $387
line 1112
;1112:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $374
JUMPV
LABELV $387
line 1114
;1113:
;1114:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1115
;1115:	dest[0] += 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1116
;1116:	dest[1] -= 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1117
;1117:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
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
line 1118
;1118:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $391
line 1119
;1119:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $374
JUMPV
LABELV $391
line 1121
;1120:
;1121:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1122
;1122:	dest[0] -= 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1123
;1123:	dest[1] += 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
ADDF4
ASGNF4
line 1124
;1124:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
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
line 1125
;1125:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $395
line 1126
;1126:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $374
JUMPV
LABELV $395
line 1128
;1127:
;1128:	VectorCopy (midpoint, dest);
ADDRLP4 0
ADDRLP4 12
INDIRB
ASGNB 12
line 1129
;1129:	dest[0] -= 15.0;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1130
;1130:	dest[1] -= 15.0;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1097859072
SUBF4
ASGNF4
line 1131
;1131:	trap_Trace ( &tr, origin, vec3_origin, vec3_origin, dest, ENTITYNUM_NONE, MASK_SOLID);
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
line 1132
;1132:	if (tr.fraction == 1.0)
ADDRLP4 24+8
INDIRF4
CNSTF4 1065353216
NEF4 $399
line 1133
;1133:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $374
JUMPV
LABELV $399
line 1136
;1134:
;1135:
;1136:	return qfalse;
CNSTI4 0
RETI4
LABELV $374
endproc CanDamage 112 28
export G_RadiusDamage
proc G_RadiusDamage 4196 32
line 1146
;1137:}
;1138:
;1139:
;1140:/*
;1141:============
;1142:G_RadiusDamage
;1143:============
;1144:*/
;1145:qboolean G_RadiusDamage ( vec3_t origin, gentity_t *attacker, float damage, float radius,
;1146:					 gentity_t *ignore, int mod) {
line 1155
;1147:	float		points, dist;
;1148:	gentity_t	*ent;
;1149:	int			entityList[MAX_GENTITIES];
;1150:	int			numListedEntities;
;1151:	vec3_t		mins, maxs;
;1152:	vec3_t		v;
;1153:	vec3_t		dir;
;1154:	int			i, e;
;1155:	qboolean	hitClient = qfalse;
ADDRLP4 4168
CNSTI4 0
ASGNI4
line 1157
;1156:
;1157:	if ( radius < 1 ) {
ADDRFP4 12
INDIRF4
CNSTF4 1065353216
GEF4 $403
line 1158
;1158:		radius = 1;
ADDRFP4 12
CNSTF4 1065353216
ASGNF4
line 1159
;1159:	}
LABELV $403
line 1161
;1160:
;1161:	for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $405
line 1162
;1162:		mins[i] = origin[i] - radius;
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
line 1163
;1163:		maxs[i] = origin[i] + radius;
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
line 1164
;1164:	}
LABELV $406
line 1161
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $405
line 1166
;1165:
;1166:	numListedEntities = trap_EntitiesInBox( mins, maxs, entityList, MAX_GENTITIES );
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
line 1168
;1167:
;1168:	for ( e = 0 ; e < numListedEntities ; e++ ) {
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRGP4 $412
JUMPV
LABELV $409
line 1169
;1169:		ent = &g_entities[entityList[ e ]];
ADDRLP4 4
CNSTI4 808
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
line 1171
;1170:
;1171:		if (ent == ignore)
ADDRLP4 4
INDIRP4
CVPU4 4
ADDRFP4 16
INDIRP4
CVPU4 4
NEU4 $413
line 1172
;1172:			continue;
ADDRGP4 $410
JUMPV
LABELV $413
line 1173
;1173:		if (!ent->takedamage)
ADDRLP4 4
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
CNSTI4 0
NEI4 $415
line 1174
;1174:			continue;
ADDRGP4 $410
JUMPV
LABELV $415
line 1177
;1175:
;1176:		// find the distance from the edge of the bounding box
;1177:		for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $417
line 1178
;1178:			if ( origin[i] < ent->r.absmin[i] ) {
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
GEF4 $421
line 1179
;1179:				v[i] = ent->r.absmin[i] - origin[i];
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
line 1180
;1180:			} else if ( origin[i] > ent->r.absmax[i] ) {
ADDRGP4 $422
JUMPV
LABELV $421
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
LEF4 $423
line 1181
;1181:				v[i] = origin[i] - ent->r.absmax[i];
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
line 1182
;1182:			} else {
ADDRGP4 $424
JUMPV
LABELV $423
line 1183
;1183:				v[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
ADDP4
CNSTF4 0
ASGNF4
line 1184
;1184:			}
LABELV $424
LABELV $422
line 1185
;1185:		}
LABELV $418
line 1177
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $417
line 1187
;1186:
;1187:		dist = VectorLength( v );
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
line 1188
;1188:		if ( dist >= radius ) {
ADDRLP4 24
INDIRF4
ADDRFP4 12
INDIRF4
LTF4 $425
line 1189
;1189:			continue;
ADDRGP4 $410
JUMPV
LABELV $425
line 1192
;1190:		}
;1191:
;1192:		points = damage * ( 1.0 - dist / radius );
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
line 1194
;1193:
;1194:		if( CanDamage (ent, origin) ) {
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
EQI4 $427
line 1195
;1195:			if( LogAccuracyHit( ent, attacker ) ) {
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
EQI4 $429
line 1196
;1196:				hitClient = qtrue;
ADDRLP4 4168
CNSTI4 1
ASGNI4
line 1197
;1197:			}
LABELV $429
line 1198
;1198:			VectorSubtract (ent->r.currentOrigin, origin, dir);
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
line 1201
;1199:			// push the center of mass higher than the origin so players
;1200:			// get knocked into the air more
;1201:			dir[2] += 24;
ADDRLP4 28+8
ADDRLP4 28+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 1202
;1202:			G_Damage (ent, NULL, attacker, dir, origin, (int)points, DAMAGE_RADIUS, mod);
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
line 1203
;1203:		}
LABELV $427
line 1204
;1204:	}
LABELV $410
line 1168
ADDRLP4 20
ADDRLP4 20
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $412
ADDRLP4 20
INDIRI4
ADDRLP4 4140
INDIRI4
LTI4 $409
line 1206
;1205:
;1206:	return hitClient;
ADDRLP4 4168
INDIRI4
RETI4
LABELV $402
endproc G_RadiusDamage 4196 32
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
LABELV $349
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
LABELV $207
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
LABELV $206
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
LABELV $199
byte 1 60
byte 1 119
byte 1 111
byte 1 114
byte 1 108
byte 1 100
byte 1 62
byte 1 0
align 1
LABELV $198
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
LABELV $177
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
LABELV $176
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
LABELV $156
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
LABELV $155
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
LABELV $144
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
LABELV $143
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
LABELV $142
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
LABELV $141
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
LABELV $140
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
LABELV $139
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
LABELV $138
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
LABELV $137
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
LABELV $136
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
LABELV $135
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
LABELV $134
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
LABELV $133
byte 1 77
byte 1 79
byte 1 68
byte 1 95
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $132
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
LABELV $131
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
LABELV $130
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
LABELV $129
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
LABELV $128
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
LABELV $127
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
LABELV $126
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
LABELV $125
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
LABELV $124
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
LABELV $123
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
LABELV $122
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
LABELV $121
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
LABELV $114
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
