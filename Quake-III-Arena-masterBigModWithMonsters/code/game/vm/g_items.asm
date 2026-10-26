export Pickup_Powerup
code
proc Pickup_Powerup 132 28
file "../g_items.c"
line 49
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
;23:#include "g_local.h"
;24:
;25:/*
;26:
;27:  Items are any object that a player can touch to gain some effect.
;28:
;29:  Pickup will return the number of seconds until they should respawn.
;30:
;31:  all items should pop when dropped in lava or slime
;32:
;33:  Respawnable items don't actually go away when picked up, they are
;34:  just made invisible and untouchable.  This allows them to ride
;35:  movers and respawn apropriately.
;36:*/
;37:
;38:
;39:#define	RESPAWN_ARMOR		25
;40:#define	RESPAWN_HEALTH		35
;41:#define	RESPAWN_AMMO		40
;42:#define	RESPAWN_HOLDABLE	60
;43:#define	RESPAWN_MEGAHEALTH	35//120
;44:#define	RESPAWN_POWERUP		120
;45:
;46:
;47://======================================================================
;48:
;49:int Pickup_Powerup( gentity_t *ent, gentity_t *other ) {
line 54
;50:	int			quantity;
;51:	int			i;
;52:	gclient_t	*client;
;53:
;54:	if ( !other->client->ps.powerups[ent->item->giTag] ) {
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
CNSTI4 0
NEI4 $57
line 57
;55:		// round timing to seconds to make multiple powerup timers
;56:		// count in sync
;57:		other->client->ps.powerups[ent->item->giTag] = 
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 312
ADDP4
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
MODI4
SUBI4
ASGNI4
line 59
;58:			level.time - ( level.time % 1000 );
;59:	}
LABELV $57
line 61
;60:
;61:	if ( ent->count ) {
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $61
line 62
;62:		quantity = ent->count;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
ASGNI4
line 63
;63:	} else {
ADDRGP4 $62
JUMPV
LABELV $61
line 64
;64:		quantity = ent->item->quantity;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ASGNI4
line 65
;65:	}
LABELV $62
line 67
;66:
;67:	other->client->ps.powerups[ent->item->giTag] += quantity * 1000;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 312
ADDP4
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 1000
ADDRLP4 8
INDIRI4
MULI4
ADDI4
ASGNI4
line 70
;68:
;69:	// give any nearby players a "denied" anti-reward
;70:	for ( i = 0 ; i < level.maxclients ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $66
JUMPV
LABELV $63
line 76
;71:		vec3_t		delta;
;72:		float		len;
;73:		vec3_t		forward;
;74:		trace_t		tr;
;75:
;76:		client = &level.clients[i];
ADDRLP4 0
CNSTI4 780
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 77
;77:		if ( client == other->client ) {
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
NEU4 $68
line 78
;78:			continue;
ADDRGP4 $64
JUMPV
LABELV $68
line 80
;79:		}
;80:		if ( client->pers.connected == CON_DISCONNECTED ) {
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 0
NEI4 $70
line 81
;81:			continue;
ADDRGP4 $64
JUMPV
LABELV $70
line 83
;82:		}
;83:		if ( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $72
line 84
;84:			continue;
ADDRGP4 $64
JUMPV
LABELV $72
line 89
;85:		}
;86:
;87:    // if same team in team game, no sound
;88:    // cannot use OnSameTeam as it expects to g_entities, not clients
;89:  	if ( g_gametype.integer >= GT_TEAM && other->client->sess.sessionTeam == client->sess.sessionTeam  ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
LTI4 $74
ADDRLP4 100
CNSTI4 616
ASGNI4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ADDRLP4 100
INDIRI4
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
ADDRLP4 100
INDIRI4
ADDP4
INDIRI4
NEI4 $74
line 90
;90:      continue;
ADDRGP4 $64
JUMPV
LABELV $74
line 94
;91:    }
;92:
;93:		// if too far away, no sound
;94:		VectorSubtract( ent->s.pos.trBase, client->ps.origin, delta );
ADDRLP4 104
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 108
CNSTI4 24
ASGNI4
ADDRLP4 16
ADDRLP4 104
INDIRP4
ADDRLP4 108
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 104
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
ADDRLP4 108
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 16+8
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
SUBF4
ASGNF4
line 95
;95:		len = VectorNormalize( delta );
ADDRLP4 16
ARGP4
ADDRLP4 116
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 40
ADDRLP4 116
INDIRF4
ASGNF4
line 96
;96:		if ( len > 192 ) {
ADDRLP4 40
INDIRF4
CNSTF4 1128267776
LEF4 $79
line 97
;97:			continue;
ADDRGP4 $64
JUMPV
LABELV $79
line 101
;98:		}
;99:
;100:		// if not facing, no sound
;101:		AngleVectors( client->ps.viewangles, forward, NULL, NULL );
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
ARGP4
ADDRLP4 28
ARGP4
ADDRLP4 120
CNSTP4 0
ASGNP4
ADDRLP4 120
INDIRP4
ARGP4
ADDRLP4 120
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 102
;102:		if ( DotProduct( delta, forward ) < 0.4 ) {
ADDRLP4 16
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ADDRLP4 16+4
INDIRF4
ADDRLP4 28+4
INDIRF4
MULF4
ADDF4
ADDRLP4 16+8
INDIRF4
ADDRLP4 28+8
INDIRF4
MULF4
ADDF4
CNSTF4 1053609165
GEF4 $81
line 103
;103:			continue;
ADDRGP4 $64
JUMPV
LABELV $81
line 107
;104:		}
;105:
;106:		// if not line of sight, no sound
;107:		trap_Trace( &tr, client->ps.origin, NULL, NULL, ent->s.pos.trBase, ENTITYNUM_NONE, CONTENTS_SOLID );
ADDRLP4 44
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ARGP4
ADDRLP4 124
CNSTP4 0
ASGNP4
ADDRLP4 124
INDIRP4
ARGP4
ADDRLP4 124
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 108
;108:		if ( tr.fraction != 1.0 ) {
ADDRLP4 44+8
INDIRF4
CNSTF4 1065353216
EQF4 $87
line 109
;109:			continue;
ADDRGP4 $64
JUMPV
LABELV $87
line 113
;110:		}
;111:
;112:		// anti-reward
;113:		client->ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_DENIEDREWARD;
ADDRLP4 128
ADDRLP4 0
INDIRP4
CNSTI4 268
ADDP4
ASGNP4
ADDRLP4 128
INDIRP4
ADDRLP4 128
INDIRP4
INDIRI4
CNSTI4 1
BXORI4
ASGNI4
line 114
;114:	}
LABELV $64
line 70
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $66
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $63
line 115
;115:	return RESPAWN_POWERUP;
CNSTI4 120
RETI4
LABELV $56
endproc Pickup_Powerup 132 28
export Pickup_Holdable
proc Pickup_Holdable 4 0
line 195
;116:}
;117:
;118://======================================================================
;119:
;120:#ifdef MISSIONPACK
;121:int Pickup_PersistantPowerup( gentity_t *ent, gentity_t *other ) {
;122:	int		clientNum;
;123:	char	userinfo[MAX_INFO_STRING];
;124:	float	handicap;
;125:	int		max;
;126:
;127:	other->client->ps.stats[STAT_PERSISTANT_POWERUP] = ent->item - bg_itemlist;
;128:	other->client->persistantPowerup = ent;
;129:
;130:	switch( ent->item->giTag ) {
;131:	case PW_GUARD:
;132:		clientNum = other->client->ps.clientNum;
;133:		trap_GetUserinfo( clientNum, userinfo, sizeof(userinfo) );
;134:		handicap = atof( Info_ValueForKey( userinfo, "handicap" ) );
;135:		if( handicap<=0.0f || handicap>100.0f) {
;136:			handicap = 100.0f;
;137:		}
;138:		max = (int)(2 *  handicap);
;139:
;140:		other->health = max;
;141:		other->client->ps.stats[STAT_HEALTH] = max;
;142:		other->client->ps.stats[STAT_MAX_HEALTH] = max;
;143:		other->client->ps.stats[STAT_ARMOR] = max;
;144:		other->client->pers.maxHealth = max;
;145:
;146:		break;
;147:
;148:	case PW_SCOUT:
;149:		clientNum = other->client->ps.clientNum;
;150:		trap_GetUserinfo( clientNum, userinfo, sizeof(userinfo) );
;151:		handicap = atof( Info_ValueForKey( userinfo, "handicap" ) );
;152:		if( handicap<=0.0f || handicap>100.0f) {
;153:			handicap = 100.0f;
;154:		}
;155:		other->client->pers.maxHealth = handicap;
;156:		other->client->ps.stats[STAT_ARMOR] = 0;
;157:		break;
;158:
;159:	case PW_DOUBLER:
;160:		clientNum = other->client->ps.clientNum;
;161:		trap_GetUserinfo( clientNum, userinfo, sizeof(userinfo) );
;162:		handicap = atof( Info_ValueForKey( userinfo, "handicap" ) );
;163:		if( handicap<=0.0f || handicap>100.0f) {
;164:			handicap = 100.0f;
;165:		}
;166:		other->client->pers.maxHealth = handicap;
;167:		break;
;168:	case PW_AMMOREGEN:
;169:		clientNum = other->client->ps.clientNum;
;170:		trap_GetUserinfo( clientNum, userinfo, sizeof(userinfo) );
;171:		handicap = atof( Info_ValueForKey( userinfo, "handicap" ) );
;172:		if( handicap<=0.0f || handicap>100.0f) {
;173:			handicap = 100.0f;
;174:		}
;175:		other->client->pers.maxHealth = handicap;
;176:		memset(other->client->ammoTimes, 0, sizeof(other->client->ammoTimes));
;177:		break;
;178:	default:
;179:		clientNum = other->client->ps.clientNum;
;180:		trap_GetUserinfo( clientNum, userinfo, sizeof(userinfo) );
;181:		handicap = atof( Info_ValueForKey( userinfo, "handicap" ) );
;182:		if( handicap<=0.0f || handicap>100.0f) {
;183:			handicap = 100.0f;
;184:		}
;185:		other->client->pers.maxHealth = handicap;
;186:		break;
;187:	}
;188:
;189:	return -1;
;190:}
;191:
;192://======================================================================
;193:#endif
;194:
;195:int Pickup_Holdable( gentity_t *ent, gentity_t *other ) {
line 197
;196:
;197:	other->client->ps.stats[STAT_HOLDABLE_ITEM] = ent->item - bg_itemlist;
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 188
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
ASGNI4
line 199
;198:
;199:	if( ent->item->giTag == HI_KAMIKAZE ) {
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 3
NEI4 $91
line 200
;200:		other->client->ps.eFlags |= EF_KAMIKAZE;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 512
BORI4
ASGNI4
line 201
;201:	}
LABELV $91
line 203
;202:
;203:	return RESPAWN_HOLDABLE;
CNSTI4 60
RETI4
LABELV $90
endproc Pickup_Holdable 4 0
export Add_Ammo
proc Add_Ammo 4 0
line 210
;204:}
;205:
;206:
;207://======================================================================
;208:
;209:void Add_Ammo (gentity_t *ent, int weapon, int count)
;210:{
line 211
;211:	ent->client->ps.ammo[weapon] += count;
ADDRLP4 0
ADDRFP4 4
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
line 212
;212:	if ( ent->client->ps.ammo[weapon] > 200 ) {
ADDRFP4 4
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
CNSTI4 200
LEI4 $94
line 213
;213:		ent->client->ps.ammo[weapon] = 200;
ADDRFP4 4
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
CNSTI4 200
ASGNI4
line 214
;214:	}
LABELV $94
line 215
;215:}
LABELV $93
endproc Add_Ammo 4 0
export Pickup_Ammo
proc Pickup_Ammo 4 12
line 218
;216:
;217:int Pickup_Ammo (gentity_t *ent, gentity_t *other)
;218:{
line 221
;219:	int		quantity;
;220:
;221:	if ( ent->count ) {
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $97
line 222
;222:		quantity = ent->count;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
ASGNI4
line 223
;223:	} else {
ADDRGP4 $98
JUMPV
LABELV $97
line 224
;224:		quantity = ent->item->quantity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ASGNI4
line 225
;225:	}
LABELV $98
line 227
;226:
;227:	Add_Ammo (other, ent->item->giTag, quantity);
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 Add_Ammo
CALLV
pop
line 229
;228:
;229:	return RESPAWN_AMMO;
CNSTI4 40
RETI4
LABELV $96
endproc Pickup_Ammo 4 12
export Pickup_Weapon
proc Pickup_Weapon 8 12
line 235
;230:}
;231:
;232://======================================================================
;233:
;234:
;235:int Pickup_Weapon (gentity_t *ent, gentity_t *other) {
line 238
;236:	int		quantity;
;237:
;238:	if ( ent->count < 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
CNSTI4 0
GEI4 $100
line 239
;239:		quantity = 0; // None for you, sir!
ADDRLP4 0
CNSTI4 0
ASGNI4
line 240
;240:	} else {
ADDRGP4 $101
JUMPV
LABELV $100
line 241
;241:		if ( ent->count ) {
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $102
line 242
;242:			quantity = ent->count;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
ASGNI4
line 243
;243:		} else {
ADDRGP4 $103
JUMPV
LABELV $102
line 244
;244:			quantity = ent->item->quantity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ASGNI4
line 245
;245:		}
LABELV $103
line 248
;246:
;247:		// dropped items and teamplay weapons always have full ammo
;248:		if ( ! (ent->flags & FL_DROPPED_ITEM) && g_gametype.integer != GT_TEAM ) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
NEI4 $104
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
EQI4 $104
line 251
;249:			// respawning rules
;250:			// drop the quantity if the already have over the minimum
;251:			if ( other->client->ps.ammo[ ent->item->giTag ] < quantity ) {
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 376
ADDP4
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
GEI4 $107
line 252
;252:				quantity = quantity - other->client->ps.ammo[ ent->item->giTag ];
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 376
ADDP4
ADDP4
INDIRI4
SUBI4
ASGNI4
line 253
;253:			} else {
ADDRGP4 $108
JUMPV
LABELV $107
line 254
;254:				quantity = 1;		// only add a single shot
ADDRLP4 0
CNSTI4 1
ASGNI4
line 255
;255:			}
LABELV $108
line 256
;256:		}
LABELV $104
line 257
;257:	}
LABELV $101
line 260
;258:
;259:	// add the weapon
;260:	other->client->ps.stats[STAT_WEAPONS] |= ( 1 << ent->item->giTag );
ADDRLP4 4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 192
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
LSHI4
BORI4
ASGNI4
line 262
;261:
;262:	Add_Ammo( other, ent->item->giTag, quantity );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 Add_Ammo
CALLV
pop
line 264
;263:
;264:	if (ent->item->giTag == WP_GRAPPLING_HOOK)
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 10
NEI4 $109
line 265
;265:		other->client->ps.ammo[ent->item->giTag] = -1; // unlimited ammo
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 -1
ASGNI4
LABELV $109
line 268
;266:
;267:	// team deathmatch has slow weapon respawns
;268:	if ( g_gametype.integer == GT_TEAM ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $111
line 269
;269:		return g_weaponTeamRespawn.integer;
ADDRGP4 g_weaponTeamRespawn+12
INDIRI4
RETI4
ADDRGP4 $99
JUMPV
LABELV $111
line 272
;270:	}
;271:
;272:	return g_weaponRespawn.integer;
ADDRGP4 g_weaponRespawn+12
INDIRI4
RETI4
LABELV $99
endproc Pickup_Weapon 8 12
export Pickup_Health
proc Pickup_Health 20 0
line 278
;273:}
;274:
;275:
;276://======================================================================
;277:
;278:int Pickup_Health (gentity_t *ent, gentity_t *other) {
line 289
;279:	int			max;
;280:	int			quantity;
;281:
;282:	// small and mega healths will go over the max
;283:#ifdef MISSIONPACK
;284:	if( other->client && bg_itemlist[other->client->ps.stats[STAT_PERSISTANT_POWERUP]].giTag == PW_GUARD ) {
;285:		max = other->client->ps.stats[STAT_MAX_HEALTH];
;286:	}
;287:	else
;288:#endif
;289:	if ( ent->item->quantity != 5 && ent->item->quantity != 100 ) {
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 5
EQI4 $117
ADDRLP4 8
INDIRI4
CNSTI4 100
EQI4 $117
line 290
;290:		max = other->client->ps.stats[STAT_MAX_HEALTH];
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
ASGNI4
line 291
;291:	} else {
ADDRGP4 $118
JUMPV
LABELV $117
line 292
;292:		max = other->client->ps.stats[STAT_MAX_HEALTH] * 2;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 1
LSHI4
ASGNI4
line 293
;293:	}
LABELV $118
line 295
;294:
;295:	if ( ent->count ) {
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $119
line 296
;296:		quantity = ent->count;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
ASGNI4
line 297
;297:	} else {
ADDRGP4 $120
JUMPV
LABELV $119
line 298
;298:		quantity = ent->item->quantity;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ASGNI4
line 299
;299:	}
LABELV $120
line 301
;300:
;301:	other->health += quantity;
ADDRLP4 12
ADDRFP4 4
INDIRP4
CNSTI4 732
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDI4
ASGNI4
line 303
;302:
;303:	if (other->health > max ) {
ADDRFP4 4
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
LEI4 $121
line 304
;304:		other->health = max;
ADDRFP4 4
INDIRP4
CNSTI4 732
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 305
;305:	}
LABELV $121
line 306
;306:	other->client->ps.stats[STAT_HEALTH] = other->health;
ADDRLP4 16
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 16
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ASGNI4
line 308
;307:
;308:	if ( ent->item->quantity == 100 ) {		// mega health respawns slow
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
CNSTI4 100
NEI4 $123
line 309
;309:		return RESPAWN_MEGAHEALTH;
CNSTI4 35
RETI4
ADDRGP4 $116
JUMPV
LABELV $123
line 312
;310:	}
;311:
;312:	return RESPAWN_HEALTH;
CNSTI4 35
RETI4
LABELV $116
endproc Pickup_Health 20 0
export Pickup_Armor
proc Pickup_Armor 12 0
line 317
;313:}
;314:
;315://======================================================================
;316:
;317:int Pickup_Armor( gentity_t *ent, gentity_t *other ) {
line 334
;318:#ifdef MISSIONPACK
;319:	int		upperBound;
;320:
;321:	other->client->ps.stats[STAT_ARMOR] += ent->item->quantity;
;322:
;323:	if( other->client && bg_itemlist[other->client->ps.stats[STAT_PERSISTANT_POWERUP]].giTag == PW_GUARD ) {
;324:		upperBound = other->client->ps.stats[STAT_MAX_HEALTH];
;325:	}
;326:	else {
;327:		upperBound = other->client->ps.stats[STAT_MAX_HEALTH] * 2;
;328:	}
;329:
;330:	if ( other->client->ps.stats[STAT_ARMOR] > upperBound ) {
;331:		other->client->ps.stats[STAT_ARMOR] = upperBound;
;332:	}
;333:#else
;334:	other->client->ps.stats[STAT_ARMOR] += ent->item->quantity;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 196
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDI4
ASGNI4
line 335
;335:	if ( other->client->ps.stats[STAT_ARMOR] > other->client->ps.stats[STAT_MAX_HEALTH] * 2 ) {
ADDRLP4 4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 1
LSHI4
LEI4 $126
line 336
;336:		other->client->ps.stats[STAT_ARMOR] = other->client->ps.stats[STAT_MAX_HEALTH] * 2;
ADDRLP4 8
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 196
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 1
LSHI4
ASGNI4
line 337
;337:	}
LABELV $126
line 340
;338:#endif
;339:
;340:	return RESPAWN_ARMOR;
CNSTI4 25
RETI4
LABELV $125
endproc Pickup_Armor 12 0
export RespawnItem
proc RespawnItem 24 12
line 350
;341:}
;342:
;343://======================================================================
;344:
;345:/*
;346:===============
;347:RespawnItem
;348:===============
;349:*/
;350:void RespawnItem( gentity_t *ent ) {
line 352
;351:	// randomly select from teamed entities
;352:	if (ent->team) {
ADDRFP4 0
INDIRP4
CNSTI4 656
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $129
line 357
;353:		gentity_t	*master;
;354:		int	count;
;355:		int choice;
;356:
;357:		if ( !ent->teammaster ) {
ADDRFP4 0
INDIRP4
CNSTI4 780
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $131
line 358
;358:			G_Error( "RespawnItem: bad teammaster");
ADDRGP4 $133
ARGP4
ADDRGP4 G_Error
CALLV
pop
line 359
;359:		}
LABELV $131
line 360
;360:		master = ent->teammaster;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 780
ADDP4
INDIRP4
ASGNP4
line 362
;361:
;362:		for (count = 0, ent = master; ent; ent = ent->teamchain, count++)
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRFP4 0
ADDRLP4 8
INDIRP4
ASGNP4
ADDRGP4 $137
JUMPV
LABELV $134
line 363
;363:			;
LABELV $135
line 362
ADDRFP4 0
ADDRFP4 0
INDIRP4
CNSTI4 776
ADDP4
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $137
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $134
line 365
;364:
;365:		choice = rand() % count;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
ADDRLP4 0
INDIRI4
MODI4
ASGNI4
line 367
;366:
;367:		for (count = 0, ent = master; count < choice; ent = ent->teamchain, count++)
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRFP4 0
ADDRLP4 8
INDIRP4
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $138
line 368
;368:			;
LABELV $139
line 367
ADDRFP4 0
ADDRFP4 0
INDIRP4
CNSTI4 776
ADDP4
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $141
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $138
line 369
;369:	}
LABELV $129
line 371
;370:
;371:	ent->r.contents = CONTENTS_TRIGGER;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 1073741824
ASGNI4
line 372
;372:	ent->s.eFlags &= ~EF_NODRAW;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 -129
BANDI4
ASGNI4
line 373
;373:	ent->r.svFlags &= ~SVF_NOCLIENT;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 -2
BANDI4
ASGNI4
line 374
;374:	trap_LinkEntity (ent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 376
;375:
;376:	if ( ent->item->giType == IT_POWERUP ) {
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $142
line 381
;377:		// play powerup spawn sound to all clients
;378:		gentity_t	*te;
;379:
;380:		// if the powerup respawn sound should Not be global
;381:		if (ent->speed) {
ADDRFP4 0
INDIRP4
CNSTI4 672
ADDP4
INDIRF4
CNSTF4 0
EQF4 $144
line 382
;382:			te = G_TempEntity( ent->s.pos.trBase, EV_GENERAL_SOUND );
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 45
ARGI4
ADDRLP4 12
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 12
INDIRP4
ASGNP4
line 383
;383:		}
ADDRGP4 $145
JUMPV
LABELV $144
line 384
;384:		else {
line 385
;385:			te = G_TempEntity( ent->s.pos.trBase, EV_GLOBAL_SOUND );
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 46
ARGI4
ADDRLP4 12
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 12
INDIRP4
ASGNP4
line 386
;386:		}
LABELV $145
line 387
;387:		te->s.eventParm = G_SoundIndex( "sound/items/poweruprespawn.wav" );
ADDRGP4 $146
ARGP4
ADDRLP4 12
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRLP4 8
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 12
INDIRI4
ASGNI4
line 388
;388:		te->r.svFlags |= SVF_BROADCAST;
ADDRLP4 16
ADDRLP4 8
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 389
;389:	}
LABELV $142
line 391
;390:
;391:	if ( ent->item->giType == IT_HOLDABLE && ent->item->giTag == HI_KAMIKAZE ) {
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 6
NEI4 $147
ADDRLP4 8
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 3
NEI4 $147
line 396
;392:		// play powerup spawn sound to all clients
;393:		gentity_t	*te;
;394:
;395:		// if the powerup respawn sound should Not be global
;396:		if (ent->speed) {
ADDRFP4 0
INDIRP4
CNSTI4 672
ADDP4
INDIRF4
CNSTF4 0
EQF4 $149
line 397
;397:			te = G_TempEntity( ent->s.pos.trBase, EV_GENERAL_SOUND );
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 45
ARGI4
ADDRLP4 16
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 16
INDIRP4
ASGNP4
line 398
;398:		}
ADDRGP4 $150
JUMPV
LABELV $149
line 399
;399:		else {
line 400
;400:			te = G_TempEntity( ent->s.pos.trBase, EV_GLOBAL_SOUND );
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 46
ARGI4
ADDRLP4 16
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 16
INDIRP4
ASGNP4
line 401
;401:		}
LABELV $150
line 402
;402:		te->s.eventParm = G_SoundIndex( "sound/items/kamikazerespawn.wav" );
ADDRGP4 $151
ARGP4
ADDRLP4 16
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRLP4 12
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 16
INDIRI4
ASGNI4
line 403
;403:		te->r.svFlags |= SVF_BROADCAST;
ADDRLP4 20
ADDRLP4 12
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 404
;404:	}
LABELV $147
line 407
;405:
;406:	// play the normal respawn sound only to nearby clients
;407:	G_AddEvent( ent, EV_ITEM_RESPAWN, 0 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 40
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 409
;408:
;409:	ent->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 410
;410:}
LABELV $128
endproc RespawnItem 24 12
export Touch_Item
proc Touch_Item 48 12
line 418
;411:
;412:
;413:/*
;414:===============
;415:Touch_Item
;416:===============
;417:*/
;418:void Touch_Item (gentity_t *ent, gentity_t *other, trace_t *trace) {
line 422
;419:	int			respawn;
;420:	qboolean	predict;
;421:
;422:	if (!other->client)
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $153
line 423
;423:		return;
ADDRGP4 $152
JUMPV
LABELV $153
line 424
;424:	if (other->health < 1)
ADDRFP4 4
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 1
GEI4 $155
line 425
;425:		return;		// dead people can't pickup
ADDRGP4 $152
JUMPV
LABELV $155
line 428
;426:
;427:	// the same pickup rules are used for client side and server side
;428:	if ( !BG_CanItemBeGrabbed( g_gametype.integer, &ent->s, &other->client->ps ) ) {
ADDRGP4 g_gametype+12
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 BG_CanItemBeGrabbed
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $157
line 429
;429:		return;
ADDRGP4 $152
JUMPV
LABELV $157
line 432
;430:	}
;431:
;432:	G_LogPrintf( "Item: %i %s\n", other->s.number, ent->item->classname );
ADDRGP4 $160
ARGP4
ADDRFP4 4
INDIRP4
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
INDIRP4
ARGP4
ADDRGP4 G_LogPrintf
CALLV
pop
line 434
;433:
;434:	predict = other->client->pers.predictItemPickup;
ADDRLP4 4
ADDRFP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 504
ADDP4
INDIRI4
ASGNI4
line 437
;435:
;436:	// call the item-specific pickup function
;437:	switch( ent->item->giType ) {
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 1
LTI4 $152
ADDRLP4 12
INDIRI4
CNSTI4 8
GTI4 $152
ADDRLP4 12
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $171-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $171
address $164
address $165
address $166
address $167
address $168
address $170
address $152
address $169
code
LABELV $164
line 439
;438:	case IT_WEAPON:
;439:		respawn = Pickup_Weapon(ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 Pickup_Weapon
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 20
INDIRI4
ASGNI4
line 441
;440://		predict = qfalse;
;441:		break;
ADDRGP4 $162
JUMPV
LABELV $165
line 443
;442:	case IT_AMMO:
;443:		respawn = Pickup_Ammo(ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 Pickup_Ammo
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 24
INDIRI4
ASGNI4
line 445
;444://		predict = qfalse;
;445:		break;
ADDRGP4 $162
JUMPV
LABELV $166
line 447
;446:	case IT_ARMOR:
;447:		respawn = Pickup_Armor(ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 Pickup_Armor
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 28
INDIRI4
ASGNI4
line 448
;448:		break;
ADDRGP4 $162
JUMPV
LABELV $167
line 450
;449:	case IT_HEALTH:
;450:		respawn = Pickup_Health(ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 Pickup_Health
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 32
INDIRI4
ASGNI4
line 451
;451:		break;
ADDRGP4 $162
JUMPV
LABELV $168
line 453
;452:	case IT_POWERUP:
;453:		respawn = Pickup_Powerup(ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 36
ADDRGP4 Pickup_Powerup
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 36
INDIRI4
ASGNI4
line 454
;454:		predict = qfalse;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 455
;455:		break;
ADDRGP4 $162
JUMPV
LABELV $169
line 462
;456:#ifdef MISSIONPACK
;457:	case IT_PERSISTANT_POWERUP:
;458:		respawn = Pickup_PersistantPowerup(ent, other);
;459:		break;
;460:#endif
;461:	case IT_TEAM:
;462:		respawn = Pickup_Team(ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 Pickup_Team
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 40
INDIRI4
ASGNI4
line 463
;463:		break;
ADDRGP4 $162
JUMPV
LABELV $170
line 465
;464:	case IT_HOLDABLE:
;465:		respawn = Pickup_Holdable(ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 44
ADDRGP4 Pickup_Holdable
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 44
INDIRI4
ASGNI4
line 466
;466:		break;
line 468
;467:	default:
;468:		return;
LABELV $162
line 471
;469:	}
;470:
;471:	if ( !respawn ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $173
line 472
;472:		return;
ADDRGP4 $152
JUMPV
LABELV $173
line 476
;473:	}
;474:
;475:	// play the normal pickup sound
;476:	if (predict) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $175
line 477
;477:		G_AddPredictableEvent( other, EV_ITEM_PICKUP, ent->s.modelindex );
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 19
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_AddPredictableEvent
CALLV
pop
line 478
;478:	} else {
ADDRGP4 $176
JUMPV
LABELV $175
line 479
;479:		G_AddEvent( other, EV_ITEM_PICKUP, ent->s.modelindex );
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 19
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 480
;480:	}
LABELV $176
line 483
;481:
;482:	// powerup pickups are global broadcasts
;483:	if ( ent->item->giType == IT_POWERUP || ent->item->giType == IT_TEAM) {
ADDRLP4 20
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 5
EQI4 $179
ADDRLP4 20
INDIRI4
CNSTI4 8
NEI4 $177
LABELV $179
line 485
;484:		// if we want the global sound to play
;485:		if (!ent->speed) {
ADDRFP4 0
INDIRP4
CNSTI4 672
ADDP4
INDIRF4
CNSTF4 0
NEF4 $180
line 488
;486:			gentity_t	*te;
;487:
;488:			te = G_TempEntity( ent->s.pos.trBase, EV_GLOBAL_ITEM_PICKUP );
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 20
ARGI4
ADDRLP4 28
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 28
INDIRP4
ASGNP4
line 489
;489:			te->s.eventParm = ent->s.modelindex;
ADDRLP4 24
INDIRP4
CNSTI4 184
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ASGNI4
line 490
;490:			te->r.svFlags |= SVF_BROADCAST;
ADDRLP4 32
ADDRLP4 24
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 491
;491:		} else {
ADDRGP4 $181
JUMPV
LABELV $180
line 494
;492:			gentity_t	*te;
;493:
;494:			te = G_TempEntity( ent->s.pos.trBase, EV_GLOBAL_ITEM_PICKUP );
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 20
ARGI4
ADDRLP4 28
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 28
INDIRP4
ASGNP4
line 495
;495:			te->s.eventParm = ent->s.modelindex;
ADDRLP4 24
INDIRP4
CNSTI4 184
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ASGNI4
line 497
;496:			// only send this temp entity to a single client
;497:			te->r.svFlags |= SVF_SINGLECLIENT;
ADDRLP4 32
ADDRLP4 24
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRI4
CNSTI4 256
BORI4
ASGNI4
line 498
;498:			te->r.singleClient = other->s.number;
ADDRLP4 24
INDIRP4
CNSTI4 428
ADDP4
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
line 499
;499:		}
LABELV $181
line 500
;500:	}
LABELV $177
line 503
;501:
;502:	// fire item targets
;503:	G_UseTargets (ent, other);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 G_UseTargets
CALLV
pop
line 506
;504:
;505:	// wait of -1 will not respawn
;506:	if ( ent->wait == -1 ) {
ADDRFP4 0
INDIRP4
CNSTI4 796
ADDP4
INDIRF4
CNSTF4 3212836864
NEF4 $182
line 507
;507:		ent->r.svFlags |= SVF_NOCLIENT;
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 508
;508:		ent->s.eFlags |= EF_NODRAW;
ADDRLP4 28
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 509
;509:		ent->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 510
;510:		ent->unlinkAfterEvent = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 560
ADDP4
CNSTI4 1
ASGNI4
line 511
;511:		return;
ADDRGP4 $152
JUMPV
LABELV $182
line 515
;512:	}
;513:
;514:	// non zero wait overrides respawn time
;515:	if ( ent->wait ) {
ADDRFP4 0
INDIRP4
CNSTI4 796
ADDP4
INDIRF4
CNSTF4 0
EQF4 $184
line 516
;516:		respawn = ent->wait;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 796
ADDP4
INDIRF4
CVFI4 4
ASGNI4
line 517
;517:	}
LABELV $184
line 520
;518:
;519:	// random can be used to vary the respawn time
;520:	if ( ent->random ) {
ADDRFP4 0
INDIRP4
CNSTI4 800
ADDP4
INDIRF4
CNSTF4 0
EQF4 $186
line 521
;521:		respawn += crandom() * ent->random;
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CVIF4 4
CNSTF4 1073741824
ADDRLP4 24
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 0
INDIRP4
CNSTI4 800
ADDP4
INDIRF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 522
;522:		if ( respawn < 1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
GEI4 $188
line 523
;523:			respawn = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 524
;524:		}
LABELV $188
line 525
;525:	}
LABELV $186
line 528
;526:
;527:	// dropped items will not respawn
;528:	if ( ent->flags & FL_DROPPED_ITEM ) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $190
line 529
;529:		ent->freeAfterEvent = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 556
ADDP4
CNSTI4 1
ASGNI4
line 530
;530:	}
LABELV $190
line 535
;531:
;532:	// picked up items still stay around, they just don't
;533:	// draw anything.  This allows respawnable items
;534:	// to be placed on movers.
;535:	ent->r.svFlags |= SVF_NOCLIENT;
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 536
;536:	ent->s.eFlags |= EF_NODRAW;
ADDRLP4 28
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 537
;537:	ent->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 543
;538:
;539:	// ZOID
;540:	// A negative respawn times means to never respawn this item (but don't 
;541:	// delete it).  This is used by items that are respawned by third party 
;542:	// events such as ctf flags
;543:	if ( respawn <= 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $192
line 544
;544:		ent->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 545
;545:		ent->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 546
;546:	} else {
ADDRGP4 $193
JUMPV
LABELV $192
line 547
;547:		ent->nextthink = level.time + respawn * 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDRLP4 0
INDIRI4
MULI4
ADDI4
ASGNI4
line 548
;548:		ent->think = RespawnItem;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 RespawnItem
ASGNP4
line 549
;549:	}
LABELV $193
line 550
;550:	trap_LinkEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 551
;551:}
LABELV $152
endproc Touch_Item 48 12
export LaunchItem
proc LaunchItem 12 8
line 563
;552:
;553:
;554://======================================================================
;555:
;556:/*
;557:================
;558:LaunchItem
;559:
;560:Spawns an item and tosses it forward
;561:================
;562:*/
;563:gentity_t *LaunchItem( gitem_t *item, vec3_t origin, vec3_t velocity ) {
line 566
;564:	gentity_t	*dropped;
;565:
;566:	dropped = G_Spawn();
ADDRLP4 4
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 568
;567:
;568:	dropped->s.eType = ET_ITEM;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 2
ASGNI4
line 569
;569:	dropped->s.modelindex = item - bg_itemlist;	// store item number in modelindex
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
ASGNI4
line 570
;570:	dropped->s.modelindex2 = 1; // This is non-zero is it's a dropped item
ADDRLP4 0
INDIRP4
CNSTI4 164
ADDP4
CNSTI4 1
ASGNI4
line 572
;571:
;572:	dropped->classname = item->classname;
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRFP4 0
INDIRP4
INDIRP4
ASGNP4
line 573
;573:	dropped->item = item;
ADDRLP4 0
INDIRP4
CNSTI4 804
ADDP4
ADDRFP4 0
INDIRP4
ASGNP4
line 574
;574:	VectorSet (dropped->r.mins, -ITEM_RADIUS, -ITEM_RADIUS, -ITEM_RADIUS);
ADDRLP4 0
INDIRP4
CNSTI4 436
ADDP4
CNSTF4 3245342720
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 440
ADDP4
CNSTF4 3245342720
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 444
ADDP4
CNSTF4 3245342720
ASGNF4
line 575
;575:	VectorSet (dropped->r.maxs, ITEM_RADIUS, ITEM_RADIUS, ITEM_RADIUS);
ADDRLP4 0
INDIRP4
CNSTI4 448
ADDP4
CNSTF4 1097859072
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 452
ADDP4
CNSTF4 1097859072
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 456
ADDP4
CNSTF4 1097859072
ASGNF4
line 576
;576:	dropped->r.contents = CONTENTS_TRIGGER;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 1073741824
ASGNI4
line 578
;577:
;578:	dropped->touch = Touch_Item;
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
ADDRGP4 Touch_Item
ASGNP4
line 580
;579:
;580:	G_SetOrigin( dropped, origin );
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 581
;581:	dropped->s.pos.trType = TR_GRAVITY;
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 5
ASGNI4
line 582
;582:	dropped->s.pos.trTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 583
;583:	VectorCopy( velocity, dropped->s.pos.trDelta );
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRFP4 8
INDIRP4
INDIRB
ASGNB 12
line 585
;584:
;585:	dropped->s.eFlags |= EF_BOUNCE_HALF;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 589
;586:#ifdef MISSIONPACK
;587:	if ((g_gametype.integer == GT_CTF || g_gametype.integer == GT_1FCTF)			&& item->giType == IT_TEAM) { // Special case for CTF flags
;588:#else
;589:	if (g_gametype.integer == GT_CTF && item->giType == IT_TEAM) { // Special case for CTF flags
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
NEI4 $197
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
NEI4 $197
line 591
;590:#endif
;591:		dropped->think = Team_DroppedFlagThink;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 Team_DroppedFlagThink
ASGNP4
line 592
;592:		dropped->nextthink = level.time + 30000;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 30000
ADDI4
ASGNI4
line 593
;593:		Team_CheckDroppedItem( dropped );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Team_CheckDroppedItem
CALLV
pop
line 594
;594:	} else { // auto-remove after 30 seconds
ADDRGP4 $198
JUMPV
LABELV $197
line 595
;595:		dropped->think = G_FreeEntity;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_FreeEntity
ASGNP4
line 596
;596:		dropped->nextthink = level.time + 30000;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 30000
ADDI4
ASGNI4
line 597
;597:	}
LABELV $198
line 599
;598:
;599:	dropped->flags = FL_DROPPED_ITEM;
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
CNSTI4 4096
ASGNI4
line 601
;600:
;601:	trap_LinkEntity (dropped);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 603
;602:
;603:	return dropped;
ADDRLP4 0
INDIRP4
RETP4
LABELV $195
endproc LaunchItem 12 8
export Drop_Item
proc Drop_Item 40 16
line 613
;604:}
;605:
;606:/*
;607:================
;608:Drop_Item
;609:
;610:Spawns an item and tosses it forward
;611:================
;612:*/
;613:gentity_t *Drop_Item( gentity_t *ent, gitem_t *item, float angle ) {
line 617
;614:	vec3_t	velocity;
;615:	vec3_t	angles;
;616:
;617:	VectorCopy( ent->s.apos.trBase, angles );
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRB
ASGNB 12
line 618
;618:	angles[YAW] += angle;
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
ADDRFP4 8
INDIRF4
ADDF4
ASGNF4
line 619
;619:	angles[PITCH] = 0;	// always forward
ADDRLP4 12
CNSTF4 0
ASGNF4
line 621
;620:
;621:	AngleVectors( angles, velocity, NULL, NULL );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 24
CNSTP4 0
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 622
;622:	VectorScale( velocity, 150, velocity );
ADDRLP4 28
CNSTF4 1125515264
ASGNF4
ADDRLP4 0
ADDRLP4 28
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 28
INDIRF4
ADDRLP4 0+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+8
CNSTF4 1125515264
ADDRLP4 0+8
INDIRF4
MULF4
ASGNF4
line 623
;623:	velocity[2] += 200 + crandom() * 50;
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1112014848
CNSTF4 1073741824
ADDRLP4 32
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1128792064
ADDF4
ADDF4
ASGNF4
line 625
;624:	
;625:	return LaunchItem( item, ent->s.pos.trBase, velocity );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 36
ADDRGP4 LaunchItem
CALLP4
ASGNP4
ADDRLP4 36
INDIRP4
RETP4
LABELV $202
endproc Drop_Item 40 16
export Use_Item
proc Use_Item 0 4
line 636
;626:}
;627:
;628:
;629:/*
;630:================
;631:Use_Item
;632:
;633:Respawn the item
;634:================
;635:*/
;636:void Use_Item( gentity_t *ent, gentity_t *other, gentity_t *activator ) {
line 637
;637:	RespawnItem( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 RespawnItem
CALLV
pop
line 638
;638:}
LABELV $209
endproc Use_Item 0 4
export FinishSpawningItem
proc FinishSpawningItem 92 28
line 650
;639:
;640://======================================================================
;641:
;642:/*
;643:================
;644:FinishSpawningItem
;645:
;646:Traces down to find where an item should rest, instead of letting them
;647:free fall from their spawn points
;648:================
;649:*/
;650:void FinishSpawningItem( gentity_t *ent ) {
line 654
;651:	trace_t		tr;
;652:	vec3_t		dest;
;653:
;654:	VectorSet( ent->r.mins, -ITEM_RADIUS, -ITEM_RADIUS, -ITEM_RADIUS );
ADDRFP4 0
INDIRP4
CNSTI4 436
ADDP4
CNSTF4 3245342720
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 440
ADDP4
CNSTF4 3245342720
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
CNSTF4 3245342720
ASGNF4
line 655
;655:	VectorSet( ent->r.maxs, ITEM_RADIUS, ITEM_RADIUS, ITEM_RADIUS );
ADDRFP4 0
INDIRP4
CNSTI4 448
ADDP4
CNSTF4 1097859072
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 452
ADDP4
CNSTF4 1097859072
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 456
ADDP4
CNSTF4 1097859072
ASGNF4
line 657
;656:
;657:	ent->s.eType = ET_ITEM;
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 2
ASGNI4
line 658
;658:	ent->s.modelindex = ent->item - bg_itemlist;		// store item number in modelindex
ADDRLP4 68
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 68
INDIRP4
CNSTI4 160
ADDP4
ADDRLP4 68
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
ASGNI4
line 659
;659:	ent->s.modelindex2 = 0; // zero indicates this isn't a dropped item
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
CNSTI4 0
ASGNI4
line 661
;660:
;661:	ent->r.contents = CONTENTS_TRIGGER;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 1073741824
ASGNI4
line 662
;662:	ent->touch = Touch_Item;
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ADDRGP4 Touch_Item
ASGNP4
line 664
;663:	// useing an item causes it to respawn
;664:	ent->use = Use_Item;
ADDRFP4 0
INDIRP4
CNSTI4 708
ADDP4
ADDRGP4 Use_Item
ASGNP4
line 666
;665:
;666:	if ( ent->spawnflags & 1 ) {
ADDRFP4 0
INDIRP4
CNSTI4 528
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $211
line 668
;667:		// suspended
;668:		G_SetOrigin( ent, ent->s.origin );
ADDRLP4 72
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 72
INDIRP4
ARGP4
ADDRLP4 72
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 669
;669:	} else {
ADDRGP4 $212
JUMPV
LABELV $211
line 671
;670:		// drop to floor
;671:		VectorSet( dest, ent->s.origin[0], ent->s.origin[1], ent->s.origin[2] - 4096 );
ADDRLP4 72
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 56
ADDRLP4 72
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ASGNF4
ADDRLP4 56+4
ADDRLP4 72
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ASGNF4
ADDRLP4 56+8
ADDRFP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
CNSTF4 1166016512
SUBF4
ASGNF4
line 672
;672:		trap_Trace( &tr, ent->s.origin, ent->r.mins, ent->r.maxs, dest, ent->s.number, MASK_SOLID );
ADDRLP4 0
ARGP4
ADDRLP4 76
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 76
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 76
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 76
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 76
INDIRP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 673
;673:		if ( tr.startsolid ) {
ADDRLP4 0+4
INDIRI4
CNSTI4 0
EQI4 $215
line 674
;674:			G_Printf ("FinishSpawningItem: %s startsolid at %s\n", ent->classname, vtos(ent->s.origin));
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 80
ADDRGP4 vtos
CALLP4
ASGNP4
ADDRGP4 $218
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRP4
ARGP4
ADDRLP4 80
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 675
;675:			G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 676
;676:			return;
ADDRGP4 $210
JUMPV
LABELV $215
line 680
;677:		}
;678:
;679:		// allow to ride movers
;680:		ent->s.groundEntityNum = tr.entityNum;
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 682
;681:
;682:		G_SetOrigin( ent, tr.endpos );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 683
;683:	}
LABELV $212
line 686
;684:
;685:	// team slaves and targeted items aren't present at start
;686:	if ( ( ent->flags & FL_TEAMSLAVE ) || ent->targetname ) {
ADDRLP4 72
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 72
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
NEI4 $223
ADDRLP4 72
INDIRP4
CNSTI4 652
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $221
LABELV $223
line 687
;687:		ent->s.eFlags |= EF_NODRAW;
ADDRLP4 76
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 76
INDIRP4
ADDRLP4 76
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 688
;688:		ent->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 689
;689:		return;
ADDRGP4 $210
JUMPV
LABELV $221
line 693
;690:	}
;691:
;692:
;693:	if (G_MonsterTryReplaceItem(ent)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 76
ADDRGP4 G_MonsterTryReplaceItem
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $224
line 694
;694:			return;
ADDRGP4 $210
JUMPV
LABELV $224
line 697
;695:		}
;696:	// powerups don't spawn in for a while
;697:	if ( ent->item->giType == IT_POWERUP ) {
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $226
line 700
;698:		float	respawn;
;699:
;700:		respawn = 45 + crandom() * 15;
ADDRLP4 84
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 80
CNSTF4 1097859072
CNSTF4 1073741824
ADDRLP4 84
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1110704128
ADDF4
ASGNF4
line 701
;701:		ent->s.eFlags |= EF_NODRAW;
ADDRLP4 88
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 702
;702:		ent->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 703
;703:		ent->nextthink = level.time + respawn * 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CVIF4 4
CNSTF4 1148846080
ADDRLP4 80
INDIRF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 704
;704:		ent->think = RespawnItem;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 RespawnItem
ASGNP4
line 705
;705:		return;
ADDRGP4 $210
JUMPV
LABELV $226
line 709
;706:	}
;707:
;708:
;709:	trap_LinkEntity (ent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 710
;710:}
LABELV $210
endproc FinishSpawningItem 92 28
export G_CheckTeamItems
proc G_CheckTeamItems 20 4
line 720
;711:
;712:
;713:qboolean	itemRegistered[MAX_ITEMS];
;714:
;715:/*
;716:==================
;717:G_CheckTeamItems
;718:==================
;719:*/
;720:void G_CheckTeamItems( void ) {
line 723
;721:
;722:	// Set up team stuff
;723:	Team_InitGame();
ADDRGP4 Team_InitGame
CALLV
pop
line 725
;724:
;725:	if( g_gametype.integer == GT_CTF ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
NEI4 $230
line 729
;726:		gitem_t	*item;
;727:
;728:		// check for the two flags
;729:		item = BG_FindItem( "Red Flag" );
ADDRGP4 $233
ARGP4
ADDRLP4 4
ADDRGP4 BG_FindItem
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 730
;730:		if ( !item || !itemRegistered[ item - bg_itemlist ] ) {
ADDRLP4 8
ADDRLP4 0
INDIRP4
CVPU4 4
ASGNU4
ADDRLP4 8
INDIRU4
CNSTU4 0
EQU4 $236
ADDRLP4 8
INDIRU4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
CNSTI4 2
LSHI4
ADDRGP4 itemRegistered
ADDP4
INDIRI4
CNSTI4 0
NEI4 $234
LABELV $236
line 731
;731:			G_Printf( S_COLOR_YELLOW "WARNING: No team_CTF_redflag in map" );
ADDRGP4 $237
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 732
;732:		}
LABELV $234
line 733
;733:		item = BG_FindItem( "Blue Flag" );
ADDRGP4 $238
ARGP4
ADDRLP4 12
ADDRGP4 BG_FindItem
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 734
;734:		if ( !item || !itemRegistered[ item - bg_itemlist ] ) {
ADDRLP4 16
ADDRLP4 0
INDIRP4
CVPU4 4
ASGNU4
ADDRLP4 16
INDIRU4
CNSTU4 0
EQU4 $241
ADDRLP4 16
INDIRU4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
CNSTI4 2
LSHI4
ADDRGP4 itemRegistered
ADDP4
INDIRI4
CNSTI4 0
NEI4 $239
LABELV $241
line 735
;735:			G_Printf( S_COLOR_YELLOW "WARNING: No team_CTF_blueflag in map" );
ADDRGP4 $242
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 736
;736:		}
LABELV $239
line 737
;737:	}
LABELV $230
line 797
;738:#ifdef MISSIONPACK
;739:	if( g_gametype.integer == GT_1FCTF ) {
;740:		gitem_t	*item;
;741:
;742:		// check for all three flags
;743:		item = BG_FindItem( "Red Flag" );
;744:		if ( !item || !itemRegistered[ item - bg_itemlist ] ) {
;745:			G_Printf( S_COLOR_YELLOW "WARNING: No team_CTF_redflag in map" );
;746:		}
;747:		item = BG_FindItem( "Blue Flag" );
;748:		if ( !item || !itemRegistered[ item - bg_itemlist ] ) {
;749:			G_Printf( S_COLOR_YELLOW "WARNING: No team_CTF_blueflag in map" );
;750:		}
;751:		item = BG_FindItem( "Neutral Flag" );
;752:		if ( !item || !itemRegistered[ item - bg_itemlist ] ) {
;753:			G_Printf( S_COLOR_YELLOW "WARNING: No team_CTF_neutralflag in map" );
;754:		}
;755:	}
;756:
;757:	if( g_gametype.integer == GT_OBELISK ) {
;758:		gentity_t	*ent;
;759:
;760:		// check for the two obelisks
;761:		ent = NULL;
;762:		ent = G_Find( ent, FOFS(classname), "team_redobelisk" );
;763:		if( !ent ) {
;764:			G_Printf( S_COLOR_YELLOW "WARNING: No team_redobelisk in map" );
;765:		}
;766:
;767:		ent = NULL;
;768:		ent = G_Find( ent, FOFS(classname), "team_blueobelisk" );
;769:		if( !ent ) {
;770:			G_Printf( S_COLOR_YELLOW "WARNING: No team_blueobelisk in map" );
;771:		}
;772:	}
;773:
;774:	if( g_gametype.integer == GT_HARVESTER ) {
;775:		gentity_t	*ent;
;776:
;777:		// check for all three obelisks
;778:		ent = NULL;
;779:		ent = G_Find( ent, FOFS(classname), "team_redobelisk" );
;780:		if( !ent ) {
;781:			G_Printf( S_COLOR_YELLOW "WARNING: No team_redobelisk in map" );
;782:		}
;783:
;784:		ent = NULL;
;785:		ent = G_Find( ent, FOFS(classname), "team_blueobelisk" );
;786:		if( !ent ) {
;787:			G_Printf( S_COLOR_YELLOW "WARNING: No team_blueobelisk in map" );
;788:		}
;789:
;790:		ent = NULL;
;791:		ent = G_Find( ent, FOFS(classname), "team_neutralobelisk" );
;792:		if( !ent ) {
;793:			G_Printf( S_COLOR_YELLOW "WARNING: No team_neutralobelisk in map" );
;794:		}
;795:	}
;796:#endif
;797:}
LABELV $229
endproc G_CheckTeamItems 20 4
export ClearRegisteredItems
proc ClearRegisteredItems 8 12
line 804
;798:
;799:/*
;800:==============
;801:ClearRegisteredItems
;802:==============
;803:*/
;804:void ClearRegisteredItems( void ) {
line 805
;805:	memset( itemRegistered, 0, sizeof( itemRegistered ) );
ADDRGP4 itemRegistered
ARGP4
CNSTI4 0
ARGI4
CNSTI4 1024
ARGI4
ADDRGP4 memset
CALLP4
pop
line 808
;806:
;807:	// players always start with the base weapon
;808:	RegisterItem( BG_FindItemForWeapon( WP_MACHINEGUN ) );
CNSTI4 2
ARGI4
ADDRLP4 0
ADDRGP4 BG_FindItemForWeapon
CALLP4
ASGNP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 RegisterItem
CALLV
pop
line 809
;809:	RegisterItem( BG_FindItemForWeapon( WP_GAUNTLET ) );
CNSTI4 1
ARGI4
ADDRLP4 4
ADDRGP4 BG_FindItemForWeapon
CALLP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 RegisterItem
CALLV
pop
line 816
;810:#ifdef MISSIONPACK
;811:	if( g_gametype.integer == GT_HARVESTER ) {
;812:		RegisterItem( BG_FindItem( "Red Cube" ) );
;813:		RegisterItem( BG_FindItem( "Blue Cube" ) );
;814:	}
;815:#endif
;816:}
LABELV $243
endproc ClearRegisteredItems 8 12
export RegisterItem
proc RegisterItem 0 4
line 825
;817:
;818:/*
;819:===============
;820:RegisterItem
;821:
;822:The item will be added to the precache list
;823:===============
;824:*/
;825:void RegisterItem( gitem_t *item ) {
line 826
;826:	if ( !item ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $245
line 827
;827:		G_Error( "RegisterItem: NULL" );
ADDRGP4 $247
ARGP4
ADDRGP4 G_Error
CALLV
pop
line 828
;828:	}
LABELV $245
line 829
;829:	itemRegistered[ item - bg_itemlist ] = qtrue;
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
CNSTI4 2
LSHI4
ADDRGP4 itemRegistered
ADDP4
CNSTI4 1
ASGNI4
line 830
;830:}
LABELV $244
endproc RegisterItem 0 4
export SaveRegisteredItems
proc SaveRegisteredItems 268 8
line 841
;831:
;832:
;833:/*
;834:===============
;835:SaveRegisteredItems
;836:
;837:Write the needed items to a config string
;838:so the client will know which ones to precache
;839:===============
;840:*/
;841:void SaveRegisteredItems( void ) {
line 846
;842:	char	string[MAX_ITEMS+1];
;843:	int		i;
;844:	int		count;
;845:
;846:	count = 0;
ADDRLP4 264
CNSTI4 0
ASGNI4
line 847
;847:	for ( i = 0 ; i < bg_numItems ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $252
JUMPV
LABELV $249
line 848
;848:		if ( itemRegistered[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 itemRegistered
ADDP4
INDIRI4
CNSTI4 0
EQI4 $253
line 849
;849:			count++;
ADDRLP4 264
ADDRLP4 264
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 850
;850:			string[i] = '1';
ADDRLP4 0
INDIRI4
ADDRLP4 4
ADDP4
CNSTI1 49
ASGNI1
line 851
;851:		} else {
ADDRGP4 $254
JUMPV
LABELV $253
line 852
;852:			string[i] = '0';
ADDRLP4 0
INDIRI4
ADDRLP4 4
ADDP4
CNSTI1 48
ASGNI1
line 853
;853:		}
LABELV $254
line 854
;854:	}
LABELV $250
line 847
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $252
ADDRLP4 0
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $249
line 855
;855:	string[ bg_numItems ] = 0;
ADDRGP4 bg_numItems
INDIRI4
ADDRLP4 4
ADDP4
CNSTI1 0
ASGNI1
line 857
;856:
;857:	G_Printf( "%i items registered\n", count );
ADDRGP4 $255
ARGP4
ADDRLP4 264
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 858
;858:	trap_SetConfigstring(CS_ITEMS, string);
CNSTI4 27
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 859
;859:}
LABELV $248
endproc SaveRegisteredItems 268 8
export G_ItemDisabled
proc G_ItemDisabled 132 16
line 866
;860:
;861:/*
;862:============
;863:G_ItemDisabled
;864:============
;865:*/
;866:int G_ItemDisabled( gitem_t *item ) {
line 870
;867:
;868:	char name[128];
;869:
;870:	Com_sprintf(name, sizeof(name), "disable_%s", item->classname);
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $257
ARGP4
ADDRFP4 0
INDIRP4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 871
;871:	return trap_Cvar_VariableIntegerValue( name );
ADDRLP4 0
ARGP4
ADDRLP4 128
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRLP4 128
INDIRI4
RETI4
LABELV $256
endproc G_ItemDisabled 132 16
export G_SpawnItem
proc G_SpawnItem 28 12
line 884
;872:}
;873:
;874:/*
;875:============
;876:G_SpawnItem
;877:
;878:Sets the clipping size and plants the object on the floor.
;879:
;880:Items can't be immediately dropped to floor, because they might
;881:be on an entity that hasn't spawned yet.
;882:============
;883:*/
;884:void G_SpawnItem( gentity_t *ent, gitem_t *item ) {
line 890
;885:	
;886:	
;887:	/*
;888:	 * Remove Railgun and its ammunition.
;889:	 */
;890:	if( g_noRailgun.integer &&
ADDRGP4 g_noRailgun+12
INDIRI4
CNSTI4 0
EQI4 $259
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
EQI4 $262
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $259
LABELV $262
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 7
NEI4 $259
line 895
;891:		(
;892:			item->giType == IT_WEAPON ||
;893:			item->giType == IT_AMMO
;894:		) &&
;895:		item->giTag == WP_RAILGUN ) {
line 896
;896:		G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 897
;897:		return;
ADDRGP4 $258
JUMPV
LABELV $259
line 905
;898:	}
;899:	
;900:	/*
;901:	 * Scavenger mode removes placed map weapons.
;902:	 * Dropped player weapons do not pass through G_SpawnItem,
;903:	 * so they remain available.
;904:	 */
;905:	if( g_scavengerWeapons.integer &&
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 g_scavengerWeapons+12
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $263
ADDRGP4 g_blasterMode+12
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $263
line 906
;906:		!g_blasterMode.integer ) {
line 907
;907:		if( item->giType == IT_WEAPON ) {
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $267
line 908
;908:			G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 909
;909:			return;
ADDRGP4 $258
JUMPV
LABELV $267
line 915
;910:		}
;911:
;912:		/*
;913:		 * Keep only bullets, shells and slugs.
;914:		 */
;915:		if( item->giType == IT_AMMO &&
ADDRLP4 8
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
CNSTI4 2
ASGNI4
ADDRLP4 8
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $269
ADDRLP4 16
ADDRLP4 8
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $269
ADDRLP4 16
INDIRI4
CNSTI4 3
EQI4 $269
ADDRLP4 16
INDIRI4
CNSTI4 7
EQI4 $269
line 918
;916:			item->giTag != WP_MACHINEGUN &&
;917:			item->giTag != WP_SHOTGUN &&
;918:			item->giTag != WP_RAILGUN ) {
line 919
;919:			G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 920
;920:			return;
ADDRGP4 $258
JUMPV
LABELV $269
line 922
;921:		}
;922:	}	
LABELV $263
line 924
;923:	
;924:	if( g_noHealth.integer &&
ADDRGP4 g_noHealth+12
INDIRI4
CNSTI4 0
EQI4 $271
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 4
NEI4 $271
line 925
;925:		item->giType == IT_HEALTH ) {
line 926
;926:		return;
ADDRGP4 $258
JUMPV
LABELV $271
line 929
;927:	}
;928:
;929:	if( g_noArmor.integer &&
ADDRGP4 g_noArmor+12
INDIRI4
CNSTI4 0
EQI4 $274
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 3
NEI4 $274
line 930
;930:		item->giType == IT_ARMOR ) {
line 931
;931:		return;
ADDRGP4 $258
JUMPV
LABELV $274
line 934
;932:	}
;933:	
;934:	if( g_noPersonalTeleporter.integer &&
ADDRGP4 g_noPersonalTeleporter+12
INDIRI4
CNSTI4 0
EQI4 $277
ADDRLP4 8
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 6
NEI4 $277
ADDRLP4 8
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 1
NEI4 $277
line 936
;935:			item->giType == IT_HOLDABLE &&
;936:			item->giTag == HI_TELEPORTER ) {
line 937
;937:			return;
ADDRGP4 $258
JUMPV
LABELV $277
line 939
;938:		}	
;939:	if( g_noPlasmaBFG.integer ) {
ADDRGP4 g_noPlasmaBFG+12
INDIRI4
CNSTI4 0
EQI4 $280
line 940
;940:			if( item->giType == IT_WEAPON &&
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $283
ADDRLP4 16
ADDRLP4 12
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 6
EQI4 $286
ADDRLP4 16
INDIRI4
CNSTI4 8
EQI4 $286
ADDRLP4 16
INDIRI4
CNSTI4 9
NEI4 $283
LABELV $286
line 943
;941:				( item->giTag == WP_LIGHTNING ||
;942:				  item->giTag == WP_PLASMAGUN ||
;943:				  item->giTag == WP_BFG ) ) {
line 944
;944:				return;
ADDRGP4 $258
JUMPV
LABELV $283
line 947
;945:			}
;946:
;947:			if( item->giType == IT_AMMO &&
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 2
NEI4 $287
ADDRLP4 24
ADDRLP4 20
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 6
EQI4 $290
ADDRLP4 24
INDIRI4
CNSTI4 8
EQI4 $290
ADDRLP4 24
INDIRI4
CNSTI4 9
NEI4 $287
LABELV $290
line 950
;948:				( item->giTag == WP_LIGHTNING ||
;949:				  item->giTag == WP_PLASMAGUN ||
;950:				  item->giTag == WP_BFG ) ) {
line 951
;951:				return;
ADDRGP4 $258
JUMPV
LABELV $287
line 953
;952:			}
;953:		}
LABELV $280
line 955
;954:
;955:	if( g_noGrenadeRocket.integer ) {
ADDRGP4 g_noGrenadeRocket+12
INDIRI4
CNSTI4 0
EQI4 $291
line 956
;956:		if( item->giType == IT_WEAPON &&
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $294
ADDRLP4 16
ADDRLP4 12
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 4
EQI4 $296
ADDRLP4 16
INDIRI4
CNSTI4 5
NEI4 $294
LABELV $296
line 958
;957:			( item->giTag == WP_GRENADE_LAUNCHER ||
;958:			  item->giTag == WP_ROCKET_LAUNCHER ) ) {
line 959
;959:			return;
ADDRGP4 $258
JUMPV
LABELV $294
line 962
;960:		}
;961:
;962:		if( item->giType == IT_AMMO &&
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 2
NEI4 $297
ADDRLP4 24
ADDRLP4 20
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 4
EQI4 $299
ADDRLP4 24
INDIRI4
CNSTI4 5
NEI4 $297
LABELV $299
line 964
;963:			( item->giTag == WP_GRENADE_LAUNCHER ||
;964:			  item->giTag == WP_ROCKET_LAUNCHER ) ) {
line 965
;965:			return;
ADDRGP4 $258
JUMPV
LABELV $297
line 967
;966:		}
;967:	}
LABELV $291
line 968
;968:if( g_blasterMode.integer ) {
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $300
line 970
;969:		if(
;970:			item->giType == IT_WEAPON &&
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $303
ADDRLP4 12
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 3
NEI4 $303
line 975
;971:			(
;972:				item->giTag == WP_SHOTGUN //||
;973://				item->giTag == WP_PLASMAGUN
;974:			)
;975:		) {
line 976
;976:			G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 977
;977:			return;
ADDRGP4 $258
JUMPV
LABELV $303
line 981
;978:		}
;979:
;980:		if(
;981:			item->giType == IT_AMMO &&
ADDRLP4 16
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 2
NEI4 $305
ADDRLP4 16
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 3
NEI4 $305
line 986
;982:			(
;983:				item->giTag == WP_SHOTGUN //||
;984:				//item->giTag == WP_PLASMAGUN
;985:			)
;986:		) {
line 987
;987:			G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 988
;988:			return;
ADDRGP4 $258
JUMPV
LABELV $305
line 990
;989:		}
;990:	}
LABELV $300
line 992
;991:
;992:	if( g_gametype.integer == GT_TEAM &&
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $307
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
NEI4 $307
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 1
EQI4 $307
line 994
;993:		item->giType == IT_TEAM &&
;994:		g_assaultMode.integer != 1 ) {
line 995
;995:		G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 996
;996:		return;
ADDRGP4 $258
JUMPV
LABELV $307
line 999
;997:	}
;998:	
;999:	if( g_noPowerups.integer && item->giType == IT_POWERUP ) {
ADDRGP4 g_noPowerups+12
INDIRI4
CNSTI4 0
EQI4 $311
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $311
line 1000
;1000:		G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 1001
;1001:		return;
ADDRGP4 $258
JUMPV
LABELV $311
line 1004
;1002:	}
;1003:
;1004:	if( g_noMegaHealth.integer &&
ADDRGP4 g_noMegaHealth+12
INDIRI4
CNSTI4 0
EQI4 $314
ADDRFP4 4
INDIRP4
INDIRP4
ARGP4
ADDRGP4 $317
ARGP4
ADDRLP4 12
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $314
line 1005
;1005:		Q_stricmp( item->classname, "item_health_mega" ) == 0 ) {
line 1006
;1006:		G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 1007
;1007:		return;
ADDRGP4 $258
JUMPV
LABELV $314
line 1010
;1008:	}
;1009:
;1010:	if( g_noMedkit.integer &&
ADDRGP4 g_noMedkit+12
INDIRI4
CNSTI4 0
EQI4 $318
ADDRLP4 16
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 6
NEI4 $318
ADDRLP4 16
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
NEI4 $318
line 1012
;1011:		item->giType == IT_HOLDABLE &&
;1012:		item->giTag == HI_MEDKIT ) {
line 1013
;1013:		G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 1014
;1014:		return;
ADDRGP4 $258
JUMPV
LABELV $318
line 1017
;1015:	}
;1016:
;1017:if( g_noPowerups.integer && item->giType == IT_POWERUP ) {
ADDRGP4 g_noPowerups+12
INDIRI4
CNSTI4 0
EQI4 $321
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $321
line 1018
;1018:		G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 1019
;1019:		return;
ADDRGP4 $258
JUMPV
LABELV $321
line 1022
;1020:	}
;1021:
;1022:	RegisterItem( item );
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 RegisterItem
CALLV
pop
line 1023
;1023:	if ( G_ItemDisabled(item) )
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 G_ItemDisabled
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $324
line 1024
;1024:		return;
ADDRGP4 $258
JUMPV
LABELV $324
line 1026
;1025:
;1026:	ent->item = item;
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 1029
;1027:	// some movers spawn on the second frame, so delay item
;1028:	// spawns until the third frame so they can ride trains
;1029:	ent->nextthink = level.time + FRAMETIME * 2;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 200
ADDI4
ASGNI4
line 1030
;1030:	ent->think = FinishSpawningItem;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 FinishSpawningItem
ASGNP4
line 1032
;1031:
;1032:	ent->physicsBounce = 0.50;		// items are bouncy
ADDRFP4 0
INDIRP4
CNSTI4 568
ADDP4
CNSTF4 1056964608
ASGNF4
line 1034
;1033:
;1034:	if ( item->giType == IT_POWERUP ) {
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $327
line 1035
;1035:		G_SoundIndex( "sound/items/poweruprespawn.wav" );
ADDRGP4 $146
ARGP4
ADDRGP4 G_SoundIndex
CALLI4
pop
line 1036
;1036:		G_SpawnFloat( "noglobalsound", "0", &ent->speed);
ADDRGP4 $329
ARGP4
ADDRGP4 $330
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 672
ADDP4
ARGP4
ADDRGP4 G_SpawnFloat
CALLI4
pop
line 1037
;1037:	}
LABELV $327
line 1044
;1038:
;1039:#ifdef MISSIONPACK
;1040:	if ( item->giType == IT_PERSISTANT_POWERUP ) {
;1041:		ent->s.generic1 = ent->spawnflags;
;1042:	}
;1043:#endif
;1044:}
LABELV $258
endproc G_SpawnItem 28 12
export G_BounceItem
proc G_BounceItem 64 12
line 1053
;1045:
;1046:
;1047:/*
;1048:================
;1049:G_BounceItem
;1050:
;1051:================
;1052:*/
;1053:void G_BounceItem( gentity_t *ent, trace_t *trace ) {
line 1059
;1054:	vec3_t	velocity;
;1055:	float	dot;
;1056:	int		hitTime;
;1057:
;1058:	// reflect the velocity on the trace plane
;1059:	hitTime = level.previousTime + ( level.time - level.previousTime ) * trace->fraction;
ADDRLP4 16
ADDRGP4 level+36
INDIRI4
CVIF4 4
ADDRGP4 level+32
INDIRI4
ADDRGP4 level+36
INDIRI4
SUBI4
CVIF4 4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 1060
;1060:	BG_EvaluateTrajectoryDelta( &ent->s.pos, hitTime, velocity );
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BG_EvaluateTrajectoryDelta
CALLV
pop
line 1061
;1061:	dot = DotProduct( velocity, trace->plane.normal );
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 0
INDIRF4
ADDRLP4 20
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
MULF4
ADDRLP4 0+4
INDIRF4
ADDRLP4 20
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+8
INDIRF4
ADDRLP4 20
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 1062
;1062:	VectorMA( velocity, -2*dot, trace->plane.normal, ent->s.pos.trDelta );
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 0
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
CNSTF4 3221225472
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 0+4
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
CNSTF4 3221225472
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 0+8
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
CNSTF4 3221225472
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 1065
;1063:
;1064:	// cut the velocity to keep from bouncing forever
;1065:	VectorScale( ent->s.pos.trDelta, ent->physicsBounce, ent->s.pos.trDelta );
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
ADDRLP4 24
INDIRP4
CNSTI4 36
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRF4
ADDRLP4 24
INDIRP4
CNSTI4 568
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 36
ADDRLP4 32
INDIRP4
CNSTI4 40
ADDP4
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 36
INDIRP4
INDIRF4
ADDRLP4 32
INDIRP4
CNSTI4 568
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 44
ADDRLP4 40
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRF4
ADDRLP4 40
INDIRP4
CNSTI4 568
ADDP4
INDIRF4
MULF4
ASGNF4
line 1068
;1066:
;1067:	// check for stop
;1068:	if ( trace->plane.normal[2] > 0 && ent->s.pos.trDelta[2] < 40 ) {
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
CNSTF4 0
LEF4 $339
ADDRFP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRF4
CNSTF4 1109393408
GEF4 $339
line 1069
;1069:		trace->endpos[2] += 1.0;	// make sure it is off ground
ADDRLP4 48
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 1070
;1070:		SnapVector( trace->endpos );
ADDRLP4 52
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 52
INDIRP4
ADDRLP4 52
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 56
ADDRFP4 4
INDIRP4
CNSTI4 16
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 60
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
line 1071
;1071:		G_SetOrigin( ent, trace->endpos );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 1072
;1072:		ent->s.groundEntityNum = trace->entityNum;
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 52
ADDP4
INDIRI4
ASGNI4
line 1073
;1073:		return;
ADDRGP4 $331
JUMPV
LABELV $339
line 1076
;1074:	}
;1075:
;1076:	VectorAdd( ent->r.currentOrigin, trace->plane.normal, ent->r.currentOrigin);
ADDRLP4 48
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 52
ADDRFP4 0
INDIRP4
CNSTI4 492
ADDP4
ASGNP4
ADDRLP4 52
INDIRP4
ADDRLP4 52
INDIRP4
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ADDF4
ASGNF4
line 1077
;1077:	VectorCopy( ent->r.currentOrigin, ent->s.pos.trBase );
ADDRLP4 60
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 60
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 60
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1078
;1078:	ent->s.pos.trTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1079
;1079:}
LABELV $331
endproc G_BounceItem 64 12
export G_RunItem
proc G_RunItem 88 28
line 1088
;1080:
;1081:
;1082:/*
;1083:================
;1084:G_RunItem
;1085:
;1086:================
;1087:*/
;1088:void G_RunItem( gentity_t *ent ) {
line 1095
;1089:	vec3_t		origin;
;1090:	trace_t		tr;
;1091:	int			contents;
;1092:	int			mask;
;1093:
;1094:	// if groundentity has been set to -1, it may have been pushed off an edge
;1095:	if ( ent->s.groundEntityNum == -1 ) {
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
CNSTI4 -1
NEI4 $343
line 1096
;1096:		if ( ent->s.pos.trType != TR_GRAVITY ) {
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 5
EQI4 $345
line 1097
;1097:			ent->s.pos.trType = TR_GRAVITY;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 5
ASGNI4
line 1098
;1098:			ent->s.pos.trTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1099
;1099:		}
LABELV $345
line 1100
;1100:	}
LABELV $343
line 1102
;1101:
;1102:	if ( ent->s.pos.trType == TR_STATIONARY ) {
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 0
NEI4 $348
line 1104
;1103:		// check think function
;1104:		G_RunThink( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_RunThink
CALLV
pop
line 1105
;1105:		return;
ADDRGP4 $342
JUMPV
LABELV $348
line 1109
;1106:	}
;1107:
;1108:	// get current position
;1109:	BG_EvaluateTrajectory( &ent->s.pos, level.time, origin );
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 level+32
INDIRI4
ARGI4
ADDRLP4 56
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1112
;1110:
;1111:	// trace a line from the previous position to the current position
;1112:	if ( ent->clipmask ) {
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
INDIRI4
CNSTI4 0
EQI4 $351
line 1113
;1113:		mask = ent->clipmask;
ADDRLP4 72
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
INDIRI4
ASGNI4
line 1114
;1114:	} else {
ADDRGP4 $352
JUMPV
LABELV $351
line 1115
;1115:		mask = MASK_PLAYERSOLID & ~CONTENTS_BODY;//MASK_SOLID;
ADDRLP4 72
CNSTI4 65537
ASGNI4
line 1116
;1116:	}
LABELV $352
line 1117
;1117:	trap_Trace( &tr, ent->r.currentOrigin, ent->r.mins, ent->r.maxs, origin, 
ADDRLP4 0
ARGP4
ADDRLP4 76
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 76
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 76
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 76
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 76
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
ARGI4
ADDRLP4 72
INDIRI4
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1120
;1118:		ent->r.ownerNum, mask );
;1119:
;1120:	VectorCopy( tr.endpos, ent->r.currentOrigin );
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 1122
;1121:
;1122:	if ( tr.startsolid ) {
ADDRLP4 0+4
INDIRI4
CNSTI4 0
EQI4 $354
line 1123
;1123:		tr.fraction = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1124
;1124:	}
LABELV $354
line 1126
;1125:
;1126:	trap_LinkEntity( ent );	// FIXME: avoid this for stationary?
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1129
;1127:
;1128:	// check think function
;1129:	G_RunThink( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_RunThink
CALLV
pop
line 1131
;1130:
;1131:	if ( tr.fraction == 1 ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
NEF4 $358
line 1132
;1132:		return;
ADDRGP4 $342
JUMPV
LABELV $358
line 1136
;1133:	}
;1134:
;1135:	// if it is in a nodrop volume, remove it
;1136:	contents = trap_PointContents( ent->r.currentOrigin, -1 );
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 80
ADDRGP4 trap_PointContents
CALLI4
ASGNI4
ADDRLP4 68
ADDRLP4 80
INDIRI4
ASGNI4
line 1137
;1137:	if ( contents & CONTENTS_NODROP ) {
ADDRLP4 68
INDIRI4
CVIU4 4
CNSTU4 2147483648
BANDU4
CNSTU4 0
EQU4 $361
line 1138
;1138:		if (ent->item && ent->item->giType == IT_TEAM) {
ADDRLP4 84
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
ASGNP4
ADDRLP4 84
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $363
ADDRLP4 84
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
NEI4 $363
line 1139
;1139:			Team_FreeEntity(ent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 Team_FreeEntity
CALLV
pop
line 1140
;1140:		} else {
ADDRGP4 $342
JUMPV
LABELV $363
line 1141
;1141:			G_FreeEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 1142
;1142:		}
line 1143
;1143:		return;
ADDRGP4 $342
JUMPV
LABELV $361
line 1146
;1144:	}
;1145:
;1146:	G_BounceItem( ent, &tr );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 G_BounceItem
CALLV
pop
line 1147
;1147:}
LABELV $342
endproc G_RunItem 88 28
bss
export itemRegistered
align 4
LABELV itemRegistered
skip 1024
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
import AddScore
import player_die
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
import TossClientItems
import body_die
import G_InvulnerabilityEffect
import G_RadiusDamage
import G_Damage
import CanDamage
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
import ArmorIndex
import Think_Weapon
import SetRespawn
import PrecacheItem
import UseHoldableItem
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
LABELV $330
byte 1 48
byte 1 0
align 1
LABELV $329
byte 1 110
byte 1 111
byte 1 103
byte 1 108
byte 1 111
byte 1 98
byte 1 97
byte 1 108
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $317
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 95
byte 1 109
byte 1 101
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $257
byte 1 100
byte 1 105
byte 1 115
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 95
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $255
byte 1 37
byte 1 105
byte 1 32
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 32
byte 1 114
byte 1 101
byte 1 103
byte 1 105
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 101
byte 1 100
byte 1 10
byte 1 0
align 1
LABELV $247
byte 1 82
byte 1 101
byte 1 103
byte 1 105
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 58
byte 1 32
byte 1 78
byte 1 85
byte 1 76
byte 1 76
byte 1 0
align 1
LABELV $242
byte 1 94
byte 1 51
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 58
byte 1 32
byte 1 78
byte 1 111
byte 1 32
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
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $238
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $237
byte 1 94
byte 1 51
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 58
byte 1 32
byte 1 78
byte 1 111
byte 1 32
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
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $233
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $218
byte 1 70
byte 1 105
byte 1 110
byte 1 105
byte 1 115
byte 1 104
byte 1 83
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 115
byte 1 111
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $160
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $151
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 107
byte 1 97
byte 1 109
byte 1 105
byte 1 107
byte 1 97
byte 1 122
byte 1 101
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $146
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $133
byte 1 82
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 58
byte 1 32
byte 1 98
byte 1 97
byte 1 100
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 109
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
