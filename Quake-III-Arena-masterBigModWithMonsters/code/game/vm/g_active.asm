export P_DamageFeedback
code
proc P_DamageFeedback 36 12
file "../g_active.c"
line 37
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
;23:
;24:#include "g_local.h"
;25:
;26:
;27:/*
;28:===============
;29:G_DamageFeedback
;30:
;31:Called just before a snapshot is sent to the given player.
;32:Totals up all damage and generates both the player_state_t
;33:damage values to that client for pain blends and kicks, and
;34:global pain sound events for all clients.
;35:===============
;36:*/
;37:void P_DamageFeedback( gentity_t *player ) {
line 42
;38:	gclient_t	*client;
;39:	float	count;
;40:	vec3_t	angles;
;41:
;42:	client = player->client;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 43
;43:	if ( client->ps.pm_type == PM_DEAD ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 3
NEI4 $57
line 44
;44:		return;
ADDRGP4 $56
JUMPV
LABELV $57
line 48
;45:	}
;46:
;47:	// total points of damage shot at the player this frame
;48:	count = client->damage_blood + client->damage_armor;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 684
ADDP4
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 49
;49:	if ( count == 0 ) {
ADDRLP4 4
INDIRF4
CNSTF4 0
NEF4 $59
line 50
;50:		return;		// didn't take any damage
ADDRGP4 $56
JUMPV
LABELV $59
line 53
;51:	}
;52:
;53:	if ( count > 255 ) {
ADDRLP4 4
INDIRF4
CNSTF4 1132396544
LEF4 $61
line 54
;54:		count = 255;
ADDRLP4 4
CNSTF4 1132396544
ASGNF4
line 55
;55:	}
LABELV $61
line 61
;56:
;57:	// send the information to the client
;58:
;59:	// world damage (falling, slime, etc) uses a special code
;60:	// to make the blend blob centered instead of positional
;61:	if ( client->damage_fromWorld ) {
ADDRLP4 0
INDIRP4
CNSTI4 708
ADDP4
INDIRI4
CNSTI4 0
EQI4 $63
line 62
;62:		client->ps.damagePitch = 255;
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
CNSTI4 255
ASGNI4
line 63
;63:		client->ps.damageYaw = 255;
ADDRLP4 0
INDIRP4
CNSTI4 172
ADDP4
CNSTI4 255
ASGNI4
line 65
;64:
;65:		client->damage_fromWorld = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 708
ADDP4
CNSTI4 0
ASGNI4
line 66
;66:	} else {
ADDRGP4 $64
JUMPV
LABELV $63
line 67
;67:		vectoangles( client->damage_from, angles );
ADDRLP4 0
INDIRP4
CNSTI4 696
ADDP4
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 68
;68:		client->ps.damagePitch = angles[PITCH]/360.0 * 256;
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
CNSTF4 1132462080
ADDRLP4 8
INDIRF4
CNSTF4 1135869952
DIVF4
MULF4
CVFI4 4
ASGNI4
line 69
;69:		client->ps.damageYaw = angles[YAW]/360.0 * 256;
ADDRLP4 0
INDIRP4
CNSTI4 172
ADDP4
CNSTF4 1132462080
ADDRLP4 8+4
INDIRF4
CNSTF4 1135869952
DIVF4
MULF4
CVFI4 4
ASGNI4
line 70
;70:	}
LABELV $64
line 73
;71:
;72:	// play an apropriate pain sound
;73:	if ( (level.time > player->pain_debounce_time) && !(player->flags & FL_GODMODE) ) {
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 24
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
LEI4 $66
ADDRLP4 24
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
NEI4 $66
line 74
;74:		player->pain_debounce_time = level.time + 700;
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 700
ADDI4
ASGNI4
line 75
;75:		G_AddEvent( player, EV_PAIN, player->health );
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
CNSTI4 56
ARGI4
ADDRLP4 28
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 76
;76:		client->ps.damageEvent++;
ADDRLP4 32
ADDRLP4 0
INDIRP4
CNSTI4 168
ADDP4
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 77
;77:	}
LABELV $66
line 80
;78:
;79:
;80:	client->ps.damageCount = count;
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
ADDRLP4 4
INDIRF4
CVFI4 4
ASGNI4
line 85
;81:
;82:	//
;83:	// clear totals
;84:	//
;85:	client->damage_blood = 0;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 86
;86:	client->damage_armor = 0;
ADDRLP4 0
INDIRP4
CNSTI4 684
ADDP4
CNSTI4 0
ASGNI4
line 87
;87:	client->damage_knockback = 0;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTI4 0
ASGNI4
line 88
;88:}
LABELV $56
endproc P_DamageFeedback 36 12
export P_WorldEffects
proc P_WorldEffects 40 32
line 99
;89:
;90:
;91:
;92:/*
;93:=============
;94:P_WorldEffects
;95:
;96:Check for lava / slime contents and drowning
;97:=============
;98:*/
;99:void P_WorldEffects( gentity_t *ent ) {
line 103
;100:	qboolean	envirosuit;
;101:	int			waterlevel;
;102:
;103:	if ( ent->client->noclip ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 648
ADDP4
INDIRI4
CNSTI4 0
EQI4 $71
line 104
;104:		ent->client->airOutTime = level.time + 12000;	// don't need air
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 752
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 12000
ADDI4
ASGNI4
line 105
;105:		return;
ADDRGP4 $70
JUMPV
LABELV $71
line 108
;106:	}
;107:
;108:	waterlevel = ent->waterlevel;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 788
ADDP4
INDIRI4
ASGNI4
line 110
;109:
;110:	envirosuit = ent->client->ps.powerups[PW_BATTLESUIT] > level.time;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 320
ADDP4
INDIRI4
ADDRGP4 level+32
INDIRI4
LEI4 $76
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $77
JUMPV
LABELV $76
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $77
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 115
;111:
;112:	//
;113:	// check for drowning
;114:	//
;115:	if ( waterlevel == 3 ) {
ADDRLP4 0
INDIRI4
CNSTI4 3
NEI4 $78
line 117
;116:		// envirosuit give air
;117:		if ( envirosuit ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $80
line 118
;118:			ent->client->airOutTime = level.time + 10000;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 752
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 10000
ADDI4
ASGNI4
line 119
;119:		}
LABELV $80
line 122
;120:
;121:		// if out of air, start drowning
;122:		if ( ent->client->airOutTime < level.time) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 752
ADDP4
INDIRI4
ADDRGP4 level+32
INDIRI4
GEI4 $79
line 124
;123:			// drown!
;124:			ent->client->airOutTime += 1000;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 752
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 125
;125:			if ( ent->health > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
LEI4 $79
line 127
;126:				// take more damage the longer underwater
;127:				ent->damage += 2;
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 740
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 2
ADDI4
ASGNI4
line 128
;128:				if (ent->damage > 15)
ADDRFP4 0
INDIRP4
CNSTI4 740
ADDP4
INDIRI4
CNSTI4 15
LEI4 $88
line 129
;129:					ent->damage = 15;
ADDRFP4 0
INDIRP4
CNSTI4 740
ADDP4
CNSTI4 15
ASGNI4
LABELV $88
line 132
;130:
;131:				// play a gurp sound instead of a normal pain sound
;132:				if (ent->health <= ent->damage) {
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 20
INDIRP4
CNSTI4 740
ADDP4
INDIRI4
GTI4 $90
line 133
;133:					G_Sound(ent, CHAN_VOICE, G_SoundIndex("*drown.wav"));
ADDRGP4 $92
ARGP4
ADDRLP4 24
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 3
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 G_Sound
CALLV
pop
line 134
;134:				} else if (rand()&1) {
ADDRGP4 $91
JUMPV
LABELV $90
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $93
line 135
;135:					G_Sound(ent, CHAN_VOICE, G_SoundIndex("sound/player/gurp1.wav"));
ADDRGP4 $95
ARGP4
ADDRLP4 28
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 3
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 G_Sound
CALLV
pop
line 136
;136:				} else {
ADDRGP4 $94
JUMPV
LABELV $93
line 137
;137:					G_Sound(ent, CHAN_VOICE, G_SoundIndex("sound/player/gurp2.wav"));
ADDRGP4 $96
ARGP4
ADDRLP4 28
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 3
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 G_Sound
CALLV
pop
line 138
;138:				}
LABELV $94
LABELV $91
line 141
;139:
;140:				// don't play a normal pain sound
;141:				ent->pain_debounce_time = level.time + 200;
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 200
ADDI4
ASGNI4
line 143
;142:
;143:				G_Damage (ent, NULL, NULL, NULL, NULL, 
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 32
CNSTP4 0
ASGNP4
ADDRLP4 32
INDIRP4
ARGP4
ADDRLP4 32
INDIRP4
ARGP4
ADDRLP4 36
CNSTP4 0
ASGNP4
ADDRLP4 36
INDIRP4
ARGP4
ADDRLP4 36
INDIRP4
ARGP4
ADDRLP4 28
INDIRP4
CNSTI4 740
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
CNSTI4 14
ARGI4
ADDRGP4 G_Damage
CALLV
pop
line 145
;144:					ent->damage, DAMAGE_NO_ARMOR, MOD_WATER);
;145:			}
line 146
;146:		}
line 147
;147:	} else {
ADDRGP4 $79
JUMPV
LABELV $78
line 148
;148:		ent->client->airOutTime = level.time + 12000;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 752
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 12000
ADDI4
ASGNI4
line 149
;149:		ent->damage = 2;
ADDRFP4 0
INDIRP4
CNSTI4 740
ADDP4
CNSTI4 2
ASGNI4
line 150
;150:	}
LABELV $79
line 155
;151:
;152:	//
;153:	// check for sizzle damage (move to pmove?)
;154:	//
;155:	if (waterlevel && 
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $99
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRI4
CNSTI4 24
BANDI4
ADDRLP4 12
INDIRI4
EQI4 $99
line 156
;156:		(ent->watertype&(CONTENTS_LAVA|CONTENTS_SLIME)) ) {
line 157
;157:		if (ent->health > 0
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
LEI4 $101
ADDRLP4 16
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
ADDRGP4 level+32
INDIRI4
GTI4 $101
line 158
;158:			&& ent->pain_debounce_time <= level.time	) {
line 160
;159:
;160:			if ( envirosuit ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $104
line 161
;161:				G_AddEvent( ent, EV_POWERUP_BATTLESUIT, 0 );
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
line 162
;162:			} else {
ADDRGP4 $105
JUMPV
LABELV $104
line 163
;163:				if (ent->watertype & CONTENTS_LAVA) {
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $106
line 164
;164:					G_Damage (ent, NULL, NULL, NULL, NULL, 
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
CNSTP4 0
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 20
INDIRP4
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
CNSTI4 30
ADDRLP4 0
INDIRI4
MULI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 16
ARGI4
ADDRGP4 G_Damage
CALLV
pop
line 166
;165:						30*waterlevel, 0, MOD_LAVA);
;166:				}
LABELV $106
line 168
;167:
;168:				if (ent->watertype & CONTENTS_SLIME) {
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $108
line 169
;169:					G_Damage (ent, NULL, NULL, NULL, NULL, 
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
CNSTP4 0
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 20
INDIRP4
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
CNSTI4 10
ADDRLP4 0
INDIRI4
MULI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 15
ARGI4
ADDRGP4 G_Damage
CALLV
pop
line 171
;170:						10*waterlevel, 0, MOD_SLIME);
;171:				}
LABELV $108
line 172
;172:			}
LABELV $105
line 173
;173:		}
LABELV $101
line 174
;174:	}
LABELV $99
line 175
;175:}
LABELV $70
endproc P_WorldEffects 40 32
export G_SetClientSound
proc G_SetClientSound 8 0
line 184
;176:
;177:
;178:
;179:/*
;180:===============
;181:G_SetClientSound
;182:===============
;183:*/
;184:void G_SetClientSound( gentity_t *ent ) {
line 191
;185:#ifdef MISSIONPACK
;186:	if( ent->s.eFlags & EF_TICKING ) {
;187:		ent->client->ps.loopSound = G_SoundIndex( "sound/weapons/proxmine/wstbtick.wav");
;188:	}
;189:	else
;190:#endif
;191:	if (ent->waterlevel && (ent->watertype&(CONTENTS_LAVA|CONTENTS_SLIME)) ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 788
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $111
ADDRLP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRI4
CNSTI4 24
BANDI4
ADDRLP4 4
INDIRI4
EQI4 $111
line 192
;192:		ent->client->ps.loopSound = level.snd_fry;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 444
ADDP4
ADDRGP4 level+348
INDIRI4
ASGNI4
line 193
;193:	} else {
ADDRGP4 $112
JUMPV
LABELV $111
line 194
;194:		ent->client->ps.loopSound = 0;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 444
ADDP4
CNSTI4 0
ASGNI4
line 195
;195:	}
LABELV $112
line 196
;196:}
LABELV $110
endproc G_SetClientSound 8 0
export ClientImpacts
proc ClientImpacts 76 12
line 207
;197:
;198:
;199:
;200://==============================================================
;201:
;202:/*
;203:==============
;204:ClientImpacts
;205:==============
;206:*/
;207:void ClientImpacts( gentity_t *ent, pmove_t *pm ) {
line 212
;208:	int		i, j;
;209:	trace_t	trace;
;210:	gentity_t	*other;
;211:
;212:	memset( &trace, 0, sizeof( trace ) );
ADDRLP4 12
ARGP4
CNSTI4 0
ARGI4
CNSTI4 56
ARGI4
ADDRGP4 memset
CALLP4
pop
line 213
;213:	for (i=0 ; i<pm->numtouch ; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $118
JUMPV
LABELV $115
line 214
;214:		for (j=0 ; j<i ; j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $122
JUMPV
LABELV $119
line 215
;215:			if (pm->touchents[j] == pm->touchents[i] ) {
ADDRLP4 68
CNSTI4 2
ASGNI4
ADDRLP4 72
ADDRFP4 4
INDIRP4
CNSTI4 52
ADDP4
ASGNP4
ADDRLP4 0
INDIRI4
ADDRLP4 68
INDIRI4
LSHI4
ADDRLP4 72
INDIRP4
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDRLP4 68
INDIRI4
LSHI4
ADDRLP4 72
INDIRP4
ADDP4
INDIRI4
NEI4 $123
line 216
;216:				break;
ADDRGP4 $121
JUMPV
LABELV $123
line 218
;217:			}
;218:		}
LABELV $120
line 214
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $122
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $119
LABELV $121
line 219
;219:		if (j != i) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $125
line 220
;220:			continue;	// duplicated
ADDRGP4 $116
JUMPV
LABELV $125
line 222
;221:		}
;222:		other = &g_entities[ pm->touchents[i] ];
ADDRLP4 8
CNSTI4 884
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 52
ADDP4
ADDP4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 224
;223:
;224:		if ( ( ent->r.svFlags & SVF_BOT ) && ( ent->touch ) ) {
ADDRLP4 68
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 68
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $127
ADDRLP4 68
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $127
line 225
;225:			ent->touch( ent, other, &trace );
ADDRLP4 72
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 72
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 72
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CALLV
pop
line 226
;226:		}
LABELV $127
line 228
;227:
;228:		if ( !other->touch ) {
ADDRLP4 8
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $129
line 229
;229:			continue;
ADDRGP4 $116
JUMPV
LABELV $129
line 232
;230:		}
;231:
;232:		other->touch( other, ent, &trace );
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CALLV
pop
line 233
;233:	}
LABELV $116
line 213
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $118
ADDRLP4 4
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
LTI4 $115
line 235
;234:
;235:}
LABELV $114
endproc ClientImpacts 76 12
data
align 4
LABELV $132
byte 4 1109393408
byte 4 1109393408
byte 4 1112539136
export G_TouchTriggers
code
proc G_TouchTriggers 4240 16
line 245
;236:
;237:/*
;238:============
;239:G_TouchTriggers
;240:
;241:Find all trigger entities that ent's current position touches.
;242:Spectators will only interact with teleporters.
;243:============
;244:*/
;245:void	G_TouchTriggers( gentity_t *ent ) {
line 253
;246:	int			i, num;
;247:	int			touch[MAX_GENTITIES];
;248:	gentity_t	*hit;
;249:	trace_t		trace;
;250:	vec3_t		mins, maxs;
;251:	static vec3_t	range = { 40, 40, 52 };
;252:
;253:	if ( !ent->client ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $133
line 254
;254:		return;
ADDRGP4 $131
JUMPV
LABELV $133
line 258
;255:	}
;256:
;257:	// dead clients don't activate triggers!
;258:	if ( ent->client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $135
line 259
;259:		return;
ADDRGP4 $131
JUMPV
LABELV $135
line 262
;260:	}
;261:
;262:	VectorSubtract( ent->client->ps.origin, range, mins );
ADDRLP4 4188
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
ASGNP4
ADDRLP4 64
ADDRLP4 4188
INDIRP4
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRGP4 $132
INDIRF4
SUBF4
ASGNF4
ADDRLP4 64+4
ADDRLP4 4188
INDIRP4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRGP4 $132+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 64+8
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRGP4 $132+8
INDIRF4
SUBF4
ASGNF4
line 263
;263:	VectorAdd( ent->client->ps.origin, range, maxs );
ADDRLP4 4192
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
ASGNP4
ADDRLP4 76
ADDRLP4 4192
INDIRP4
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRGP4 $132
INDIRF4
ADDF4
ASGNF4
ADDRLP4 76+4
ADDRLP4 4192
INDIRP4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRGP4 $132+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 76+8
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRGP4 $132+8
INDIRF4
ADDF4
ASGNF4
line 265
;264:
;265:	num = trap_EntitiesInBox( mins, maxs, touch, MAX_GENTITIES );
ADDRLP4 64
ARGP4
ADDRLP4 76
ARGP4
ADDRLP4 92
ARGP4
CNSTI4 1024
ARGI4
ADDRLP4 4196
ADDRGP4 trap_EntitiesInBox
CALLI4
ASGNI4
ADDRLP4 88
ADDRLP4 4196
INDIRI4
ASGNI4
line 268
;266:
;267:	// can't use ent->absmin, because that has a one unit pad
;268:	VectorAdd( ent->client->ps.origin, ent->r.mins, mins );
ADDRLP4 4200
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4204
ADDRLP4 4200
INDIRP4
CNSTI4 516
ADDP4
ASGNP4
ADDRLP4 64
ADDRLP4 4204
INDIRP4
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRLP4 4200
INDIRP4
CNSTI4 436
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 64+4
ADDRLP4 4204
INDIRP4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 4200
INDIRP4
CNSTI4 440
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4208
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 64+8
ADDRLP4 4208
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 4208
INDIRP4
CNSTI4 444
ADDP4
INDIRF4
ADDF4
ASGNF4
line 269
;269:	VectorAdd( ent->client->ps.origin, ent->r.maxs, maxs );
ADDRLP4 4212
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4216
ADDRLP4 4212
INDIRP4
CNSTI4 516
ADDP4
ASGNP4
ADDRLP4 76
ADDRLP4 4216
INDIRP4
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRLP4 4212
INDIRP4
CNSTI4 448
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 76+4
ADDRLP4 4216
INDIRP4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 4212
INDIRP4
CNSTI4 452
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4220
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 76+8
ADDRLP4 4220
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 4220
INDIRP4
CNSTI4 456
ADDP4
INDIRF4
ADDF4
ASGNF4
line 271
;270:
;271:	for ( i=0 ; i<num ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $152
JUMPV
LABELV $149
line 272
;272:		hit = &g_entities[touch[i]];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 92
ADDP4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 274
;273:
;274:		if ( !hit->touch && !ent->touch ) {
ADDRLP4 4224
CNSTI4 704
ASGNI4
ADDRLP4 4228
CNSTU4 0
ASGNU4
ADDRLP4 0
INDIRP4
ADDRLP4 4224
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4228
INDIRU4
NEU4 $153
ADDRFP4 0
INDIRP4
ADDRLP4 4224
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4228
INDIRU4
NEU4 $153
line 275
;275:			continue;
ADDRGP4 $150
JUMPV
LABELV $153
line 277
;276:		}
;277:		if ( !( hit->r.contents & CONTENTS_TRIGGER ) ) {
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
INDIRI4
CNSTI4 1073741824
BANDI4
CNSTI4 0
NEI4 $155
line 278
;278:			continue;
ADDRGP4 $150
JUMPV
LABELV $155
line 282
;279:		}
;280:
;281:		// ignore most entities if a spectator
;282:		if ( ent->client->sess.sessionTeam == TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $157
line 283
;283:			if ( hit->s.eType != ET_TELEPORT_TRIGGER &&
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 9
EQI4 $159
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 Touch_DoorTrigger
CVPU4 4
EQU4 $159
line 286
;284:				// this is ugly but adding a new ET_? type will
;285:				// most likely cause network incompatibilities
;286:				hit->touch != Touch_DoorTrigger) {
line 287
;287:				continue;
ADDRGP4 $150
JUMPV
LABELV $159
line 289
;288:			}
;289:		}
LABELV $157
line 293
;290:
;291:		// use seperate code for determining if an item is picked up
;292:		// so you don't have to actually contact its bounding box
;293:		if ( hit->s.eType == ET_ITEM ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 2
NEI4 $161
line 294
;294:			if ( !BG_PlayerTouchesItem( &ent->client->ps, &hit->s, level.time ) ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 level+32
INDIRI4
ARGI4
ADDRLP4 4232
ADDRGP4 BG_PlayerTouchesItem
CALLI4
ASGNI4
ADDRLP4 4232
INDIRI4
CNSTI4 0
NEI4 $162
line 295
;295:				continue;
ADDRGP4 $150
JUMPV
line 297
;296:			}
;297:		} else {
LABELV $161
line 298
;298:			if ( !trap_EntityContact( mins, maxs, hit ) ) {
ADDRLP4 64
ARGP4
ADDRLP4 76
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4232
ADDRGP4 trap_EntityContact
CALLI4
ASGNI4
ADDRLP4 4232
INDIRI4
CNSTI4 0
NEI4 $166
line 299
;299:				continue;
ADDRGP4 $150
JUMPV
LABELV $166
line 301
;300:			}
;301:		}
LABELV $162
line 303
;302:
;303:		memset( &trace, 0, sizeof(trace) );
ADDRLP4 8
ARGP4
CNSTI4 0
ARGI4
CNSTI4 56
ARGI4
ADDRGP4 memset
CALLP4
pop
line 305
;304:
;305:		if ( hit->touch ) {
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $168
line 306
;306:			hit->touch (hit, ent, &trace);
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CALLV
pop
line 307
;307:		}
LABELV $168
line 309
;308:
;309:		if ( ( ent->r.svFlags & SVF_BOT ) && ( ent->touch ) ) {
ADDRLP4 4232
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4232
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $170
ADDRLP4 4232
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $170
line 310
;310:			ent->touch( ent, hit, &trace );
ADDRLP4 4236
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4236
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 4236
INDIRP4
CNSTI4 704
ADDP4
INDIRP4
CALLV
pop
line 311
;311:		}
LABELV $170
line 312
;312:	}
LABELV $150
line 271
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $152
ADDRLP4 4
INDIRI4
ADDRLP4 88
INDIRI4
LTI4 $149
line 315
;313:
;314:	// if we didn't touch a jump pad this pmove frame
;315:	if ( ent->client->ps.jumppad_frame != ent->client->ps.pmove_framecount ) {
ADDRLP4 4224
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 4224
INDIRP4
CNSTI4 460
ADDP4
INDIRI4
ADDRLP4 4224
INDIRP4
CNSTI4 456
ADDP4
INDIRI4
EQI4 $172
line 316
;316:		ent->client->ps.jumppad_frame = 0;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 317
;317:		ent->client->ps.jumppad_ent = 0;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 448
ADDP4
CNSTI4 0
ASGNI4
line 318
;318:	}
LABELV $172
line 319
;319:}
LABELV $131
endproc G_TouchTriggers 4240 16
export SpectatorThink
proc SpectatorThink 252 12
line 326
;320:
;321:/*
;322:=================
;323:SpectatorThink
;324:=================
;325:*/
;326:void SpectatorThink( gentity_t *ent, usercmd_t *ucmd ) {
line 330
;327:	pmove_t	pm;
;328:	gclient_t	*client;
;329:
;330:	client = ent->client;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 332
;331:
;332:	if ( client->sess.spectatorState != SPECTATOR_FOLLOW ) {
ADDRLP4 0
INDIRP4
CNSTI4 624
ADDP4
INDIRI4
CNSTI4 2
EQI4 $175
line 333
;333:		client->ps.pm_type = PM_SPECTATOR;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 2
ASGNI4
line 334
;334:		client->ps.speed = 400;	// faster than normal
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 400
ASGNI4
line 337
;335:
;336:		// set up for pmove
;337:		memset (&pm, 0, sizeof(pm));
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 232
ARGI4
ADDRGP4 memset
CALLP4
pop
line 338
;338:		pm.ps = &client->ps;
ADDRLP4 4
ADDRLP4 0
INDIRP4
ASGNP4
line 339
;339:		pm.cmd = *ucmd;
ADDRLP4 4+4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 24
line 340
;340:		pm.tracemask = MASK_PLAYERSOLID & ~CONTENTS_BODY;	// spectators can fly through bodies
ADDRLP4 4+28
CNSTI4 65537
ASGNI4
line 341
;341:		pm.trace = trap_Trace;
ADDRLP4 4+224
ADDRGP4 trap_Trace
ASGNP4
line 342
;342:		pm.pointcontents = trap_PointContents;
ADDRLP4 4+228
ADDRGP4 trap_PointContents
ASGNP4
line 345
;343:
;344:		// perform a pmove
;345:		Pmove (&pm);
ADDRLP4 4
ARGP4
ADDRGP4 Pmove
CALLV
pop
line 347
;346:		// save results of pmove
;347:		VectorCopy( client->ps.origin, ent->s.origin );
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRB
ASGNB 12
line 349
;348:
;349:		G_TouchTriggers( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_TouchTriggers
CALLV
pop
line 350
;350:		trap_UnlinkEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 351
;351:	}
LABELV $175
line 353
;352:
;353:	client->oldbuttons = client->buttons;
ADDRLP4 0
INDIRP4
CNSTI4 664
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 660
ADDP4
INDIRI4
ASGNI4
line 354
;354:	client->buttons = ucmd->buttons;
ADDRLP4 0
INDIRP4
CNSTI4 660
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 357
;355:
;356:	// attack button cycles through spectators
;357:	if ( ( client->buttons & BUTTON_ATTACK ) && ! ( client->oldbuttons & BUTTON_ATTACK ) ) {
ADDRLP4 244
CNSTI4 1
ASGNI4
ADDRLP4 248
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 660
ADDP4
INDIRI4
ADDRLP4 244
INDIRI4
BANDI4
ADDRLP4 248
INDIRI4
EQI4 $181
ADDRLP4 0
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
ADDRLP4 244
INDIRI4
BANDI4
ADDRLP4 248
INDIRI4
NEI4 $181
line 358
;358:		Cmd_FollowCycle_f( ent, 1 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 Cmd_FollowCycle_f
CALLV
pop
line 359
;359:	}
LABELV $181
line 360
;360:}
LABELV $174
endproc SpectatorThink 252 12
export ClientInactivityTimer
proc ClientInactivityTimer 12 8
line 371
;361:
;362:
;363:
;364:/*
;365:=================
;366:ClientInactivityTimer
;367:
;368:Returns qfalse if the client is dropped
;369:=================
;370:*/
;371:qboolean ClientInactivityTimer( gclient_t *client ) {
line 372
;372:	if ( ! g_inactivity.integer ) {
ADDRGP4 g_inactivity+12
INDIRI4
CNSTI4 0
NEI4 $184
line 375
;373:		// give everyone some time, so if the operator sets g_inactivity during
;374:		// gameplay, everyone isn't kicked
;375:		client->inactivityTime = level.time + 60 * 1000;
ADDRFP4 0
INDIRP4
CNSTI4 740
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 60000
ADDI4
ASGNI4
line 376
;376:		client->inactivityWarning = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 744
ADDP4
CNSTI4 0
ASGNI4
line 377
;377:	} else if ( client->pers.cmd.forwardmove || 
ADDRGP4 $185
JUMPV
LABELV $184
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 493
ADDP4
INDIRI1
CVII4 1
ADDRLP4 4
INDIRI4
NEI4 $192
ADDRLP4 0
INDIRP4
CNSTI4 494
ADDP4
INDIRI1
CVII4 1
ADDRLP4 4
INDIRI4
NEI4 $192
ADDRLP4 0
INDIRP4
CNSTI4 495
ADDP4
INDIRI1
CVII4 1
ADDRLP4 4
INDIRI4
NEI4 $192
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRI4
CNSTI4 1
BANDI4
ADDRLP4 4
INDIRI4
EQI4 $188
LABELV $192
line 380
;378:		client->pers.cmd.rightmove || 
;379:		client->pers.cmd.upmove ||
;380:		(client->pers.cmd.buttons & BUTTON_ATTACK) ) {
line 381
;381:		client->inactivityTime = level.time + g_inactivity.integer * 1000;
ADDRFP4 0
INDIRP4
CNSTI4 740
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDRGP4 g_inactivity+12
INDIRI4
MULI4
ADDI4
ASGNI4
line 382
;382:		client->inactivityWarning = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 744
ADDP4
CNSTI4 0
ASGNI4
line 383
;383:	} else if ( !client->pers.localClient ) {
ADDRGP4 $189
JUMPV
LABELV $188
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRI4
CNSTI4 0
NEI4 $195
line 384
;384:		if ( level.time > client->inactivityTime ) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 740
ADDP4
INDIRI4
LEI4 $197
line 385
;385:			trap_DropClient( client - level.clients, "Dropped due to inactivity" );
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 level
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 780
DIVI4
ARGI4
ADDRGP4 $200
ARGP4
ADDRGP4 trap_DropClient
CALLV
pop
line 386
;386:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $183
JUMPV
LABELV $197
line 388
;387:		}
;388:		if ( level.time > client->inactivityTime - 10000 && !client->inactivityWarning ) {
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 740
ADDP4
INDIRI4
CNSTI4 10000
SUBI4
LEI4 $201
ADDRLP4 8
INDIRP4
CNSTI4 744
ADDP4
INDIRI4
CNSTI4 0
NEI4 $201
line 389
;389:			client->inactivityWarning = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 744
ADDP4
CNSTI4 1
ASGNI4
line 390
;390:			trap_SendServerCommand( client - level.clients, "cp \"Ten seconds until inactivity drop!\n\"" );
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 level
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 780
DIVI4
ARGI4
ADDRGP4 $204
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 391
;391:		}
LABELV $201
line 392
;392:	}
LABELV $195
LABELV $189
LABELV $185
line 393
;393:	return qtrue;
CNSTI4 1
RETI4
LABELV $183
endproc ClientInactivityTimer 12 8
export ClientTimerActions
proc ClientTimerActions 20 12
line 403
;394:}
;395:
;396:/*
;397:==================
;398:ClientTimerActions
;399:
;400:Actions that happen once a second
;401:==================
;402:*/
;403:void ClientTimerActions( gentity_t *ent, int msec ) {
line 409
;404:	gclient_t	*client;
;405:#ifdef MISSIONPACK
;406:	int			maxHealth;
;407:#endif
;408:
;409:	client = ent->client;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 410
;410:	client->timeResidual += msec;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 772
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
ADDRFP4 4
INDIRI4
ADDI4
ASGNI4
ADDRGP4 $207
JUMPV
LABELV $206
line 412
;411:
;412:	while ( client->timeResidual >= 1000 ) {
line 413
;413:		client->timeResidual -= 1000;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 772
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1000
SUBI4
ASGNI4
line 441
;414:
;415:		// regenerate
;416:#ifdef MISSIONPACK
;417:		if( bg_itemlist[client->ps.stats[STAT_PERSISTANT_POWERUP]].giTag == PW_GUARD ) {
;418:			maxHealth = client->ps.stats[STAT_MAX_HEALTH] / 2;
;419:		}
;420:		else if ( client->ps.powerups[PW_REGEN] ) {
;421:			maxHealth = client->ps.stats[STAT_MAX_HEALTH];
;422:		}
;423:		else {
;424:			maxHealth = 0;
;425:		}
;426:		if( maxHealth ) {
;427:			if ( ent->health < maxHealth ) {
;428:				ent->health += 15;
;429:				if ( ent->health > maxHealth * 1.1 ) {
;430:					ent->health = maxHealth * 1.1;
;431:				}
;432:				G_AddEvent( ent, EV_POWERUP_REGEN, 0 );
;433:			} else if ( ent->health < maxHealth * 2) {
;434:				ent->health += 5;
;435:				if ( ent->health > maxHealth * 2 ) {
;436:					ent->health = maxHealth * 2;
;437:				}
;438:				G_AddEvent( ent, EV_POWERUP_REGEN, 0 );
;439:			}
;440:#else
;441:		if ( client->ps.powerups[PW_REGEN] ) {
ADDRLP4 0
INDIRP4
CNSTI4 332
ADDP4
INDIRI4
CNSTI4 0
EQI4 $209
line 442
;442:			if ( ent->health < client->ps.stats[STAT_MAX_HEALTH]) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
GEI4 $211
line 443
;443:				ent->health += 15;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 15
ADDI4
ASGNI4
line 444
;444:				if ( ent->health > client->ps.stats[STAT_MAX_HEALTH] * 1.1 ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CVIF4 4
CNSTF4 1066192077
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CVIF4 4
MULF4
LEF4 $213
line 445
;445:					ent->health = client->ps.stats[STAT_MAX_HEALTH] * 1.1;
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
CNSTF4 1066192077
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 446
;446:				}
LABELV $213
line 447
;447:				G_AddEvent( ent, EV_POWERUP_REGEN, 0 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 63
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 448
;448:			} else if ( ent->health < client->ps.stats[STAT_MAX_HEALTH] * 2) {
ADDRGP4 $210
JUMPV
LABELV $211
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 1
LSHI4
GEI4 $210
line 449
;449:				ent->health += 5;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 5
ADDI4
ASGNI4
line 450
;450:				if ( ent->health > client->ps.stats[STAT_MAX_HEALTH] * 2 ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 1
LSHI4
LEI4 $217
line 451
;451:					ent->health = client->ps.stats[STAT_MAX_HEALTH] * 2;
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 1
LSHI4
ASGNI4
line 452
;452:				}
LABELV $217
line 453
;453:				G_AddEvent( ent, EV_POWERUP_REGEN, 0 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 63
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 G_AddEvent
CALLV
pop
line 454
;454:			}
line 456
;455:#endif
;456:		} else {
ADDRGP4 $210
JUMPV
LABELV $209
line 458
;457:			// count down health when over max
;458:			if ( ent->health > client->ps.stats[STAT_MAX_HEALTH] ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
LEI4 $219
line 459
;459:				ent->health--;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 460
;460:			}
LABELV $219
line 461
;461:		}
LABELV $210
line 464
;462:
;463:		// count down armor when over max
;464:		if ( client->ps.stats[STAT_ARMOR] > client->ps.stats[STAT_MAX_HEALTH] ) {
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
LEI4 $221
line 465
;465:			client->ps.stats[STAT_ARMOR]--;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 466
;466:		}
LABELV $221
line 467
;467:	}
LABELV $207
line 412
ADDRLP4 0
INDIRP4
CNSTI4 772
ADDP4
INDIRI4
CNSTI4 1000
GEI4 $206
line 506
;468:#ifdef MISSIONPACK
;469:	if( bg_itemlist[client->ps.stats[STAT_PERSISTANT_POWERUP]].giTag == PW_AMMOREGEN ) {
;470:		int w, max, inc, t, i;
;471:    int weapList[]={WP_MACHINEGUN,WP_SHOTGUN,WP_GRENADE_LAUNCHER,WP_ROCKET_LAUNCHER,WP_LIGHTNING,WP_RAILGUN,WP_PLASMAGUN,WP_BFG,WP_NAILGUN,WP_PROX_LAUNCHER,WP_CHAINGUN};
;472:    int weapCount = sizeof(weapList) / sizeof(int);
;473:		//
;474:    for (i = 0; i < weapCount; i++) {
;475:		  w = weapList[i];
;476:
;477:		  switch(w) {
;478:			  case WP_MACHINEGUN: max = 50; inc = 4; t = 1000; break;
;479:			  case WP_SHOTGUN: max = 10; inc = 1; t = 1500; break;
;480:			  case WP_GRENADE_LAUNCHER: max = 10; inc = 1; t = 2000; break;
;481:			  case WP_ROCKET_LAUNCHER: max = 10; inc = 1; t = 1750; break;
;482:			  case WP_LIGHTNING: max = 50; inc = 5; t = 1500; break;
;483:			  case WP_RAILGUN: max = 10; inc = 1; t = 1750; break;
;484:			  case WP_PLASMAGUN: max = 50; inc = 5; t = 1500; break;
;485:			  case WP_BFG: max = 10; inc = 1; t = 4000; break;
;486:			  case WP_NAILGUN: max = 10; inc = 1; t = 1250; break;
;487:			  case WP_PROX_LAUNCHER: max = 5; inc = 1; t = 2000; break;
;488:			  case WP_CHAINGUN: max = 100; inc = 5; t = 1000; break;
;489:			  default: max = 0; inc = 0; t = 1000; break;
;490:		  }
;491:		  client->ammoTimes[w] += msec;
;492:		  if ( client->ps.ammo[w] >= max ) {
;493:			  client->ammoTimes[w] = 0;
;494:		  }
;495:		  if ( client->ammoTimes[w] >= t ) {
;496:			  while ( client->ammoTimes[w] >= t )
;497:				  client->ammoTimes[w] -= t;
;498:			  client->ps.ammo[w] += inc;
;499:			  if ( client->ps.ammo[w] > max ) {
;500:				  client->ps.ammo[w] = max;
;501:			  }
;502:		  }
;503:    }
;504:	}
;505:#endif
;506:}
LABELV $205
endproc ClientTimerActions 20 12
export ClientIntermissionThink
proc ClientIntermissionThink 24 0
line 513
;507:
;508:/*
;509:====================
;510:ClientIntermissionThink
;511:====================
;512:*/
;513:void ClientIntermissionThink( gclient_t *client ) {
line 514
;514:	client->ps.eFlags &= ~EF_TALK;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 -4097
BANDI4
ASGNI4
line 515
;515:	client->ps.eFlags &= ~EF_FIRING;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 -257
BANDI4
ASGNI4
line 520
;516:
;517:	// the level will exit when everyone wants to or after timeouts
;518:
;519:	// swap and latch button actions
;520:	client->oldbuttons = client->buttons;
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 664
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 660
ADDP4
INDIRI4
ASGNI4
line 521
;521:	client->buttons = client->pers.cmd.buttons;
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 660
ADDP4
ADDRLP4 12
INDIRP4
CNSTI4 488
ADDP4
INDIRI4
ASGNI4
line 522
;522:	if ( client->buttons & ( BUTTON_ATTACK | BUTTON_USE_HOLDABLE ) & ( client->oldbuttons ^ client->buttons ) ) {
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
ADDRLP4 16
INDIRP4
CNSTI4 660
ADDP4
INDIRI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 5
BANDI4
ADDRLP4 16
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
BXORI4
BANDI4
CNSTI4 0
EQI4 $224
line 524
;523:		// this used to be an ^1 but once a player says ready, it should stick
;524:		client->readyToExit = 1;
ADDRFP4 0
INDIRP4
CNSTI4 644
ADDP4
CNSTI4 1
ASGNI4
line 525
;525:	}
LABELV $224
line 526
;526:}
LABELV $223
endproc ClientIntermissionThink 24 0
export ClientEvents
proc ClientEvents 92 32
line 537
;527:
;528:
;529:/*
;530:================
;531:ClientEvents
;532:
;533:Events will be passed on to the clients for presentation,
;534:but any server game effects are handled here
;535:================
;536:*/
;537:void ClientEvents( gentity_t *ent, int oldEventSequence ) {
line 548
;538:	int		i, j;
;539:	int		event;
;540:	gclient_t *client;
;541:	int		damage;
;542:	vec3_t	dir;
;543:	vec3_t	origin, angles;
;544://	qboolean	fired;
;545:	gitem_t *item;
;546:	gentity_t *drop;
;547:
;548:	client = ent->client;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 550
;549:
;550:	if ( oldEventSequence < client->ps.eventSequence - MAX_PS_EVENTS ) {
ADDRFP4 4
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 2
SUBI4
GEI4 $227
line 551
;551:		oldEventSequence = client->ps.eventSequence - MAX_PS_EVENTS;
ADDRFP4 4
ADDRLP4 8
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 2
SUBI4
ASGNI4
line 552
;552:	}
LABELV $227
line 553
;553:	for ( i = oldEventSequence ; i < client->ps.eventSequence ; i++ ) {
ADDRLP4 0
ADDRFP4 4
INDIRI4
ASGNI4
ADDRGP4 $232
JUMPV
LABELV $229
line 554
;554:		event = client->ps.events[ i & (MAX_PS_EVENTS-1) ];
ADDRLP4 4
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 2
LSHI4
ADDRLP4 8
INDIRP4
CNSTI4 112
ADDP4
ADDP4
INDIRI4
ASGNI4
line 556
;555:
;556:		switch ( event ) {
ADDRLP4 68
CNSTI4 11
ASGNI4
ADDRLP4 4
INDIRI4
ADDRLP4 68
INDIRI4
EQI4 $235
ADDRLP4 4
INDIRI4
CNSTI4 12
EQI4 $235
ADDRLP4 4
INDIRI4
ADDRLP4 68
INDIRI4
LTI4 $234
LABELV $260
ADDRLP4 4
INDIRI4
CNSTI4 23
EQI4 $246
ADDRLP4 4
INDIRI4
CNSTI4 25
EQI4 $247
ADDRLP4 4
INDIRI4
CNSTI4 26
EQI4 $259
ADDRGP4 $234
JUMPV
LABELV $235
line 559
;557:		case EV_FALL_MEDIUM:
;558:		case EV_FALL_FAR:
;559:			if ( ent->s.eType != ET_PLAYER ) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
EQI4 $236
line 560
;560:				break;		// not in the player model
ADDRGP4 $234
JUMPV
LABELV $236
line 562
;561:			}
;562:			if ( g_dmflags.integer & DF_NO_FALLING ) {
ADDRGP4 g_dmflags+12
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $238
line 563
;563:				break;
ADDRGP4 $234
JUMPV
LABELV $238
line 565
;564:			}
;565:			if ( event == EV_FALL_FAR ) {
ADDRLP4 4
INDIRI4
CNSTI4 12
NEI4 $241
line 566
;566:				damage = 10;
ADDRLP4 32
CNSTI4 10
ASGNI4
line 567
;567:			} else {
ADDRGP4 $242
JUMPV
LABELV $241
line 568
;568:				damage = 5;
ADDRLP4 32
CNSTI4 5
ASGNI4
line 569
;569:			}
LABELV $242
line 570
;570:			VectorSet (dir, 0, 0, 1);
ADDRLP4 76
CNSTF4 0
ASGNF4
ADDRLP4 16
ADDRLP4 76
INDIRF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 76
INDIRF4
ASGNF4
ADDRLP4 16+8
CNSTF4 1065353216
ASGNF4
line 571
;571:			ent->pain_debounce_time = level.time + 200;	// no normal pain sound
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 200
ADDI4
ASGNI4
line 572
;572:			G_Damage (ent, NULL, NULL, NULL, NULL, damage, 0, MOD_FALLING);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 80
CNSTP4 0
ASGNP4
ADDRLP4 80
INDIRP4
ARGP4
ADDRLP4 80
INDIRP4
ARGP4
ADDRLP4 84
CNSTP4 0
ASGNP4
ADDRLP4 84
INDIRP4
ARGP4
ADDRLP4 84
INDIRP4
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 19
ARGI4
ADDRGP4 G_Damage
CALLV
pop
line 573
;573:			break;
ADDRGP4 $234
JUMPV
LABELV $246
line 576
;574:
;575:		case EV_FIRE_WEAPON:
;576:			FireWeapon( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 FireWeapon
CALLV
pop
line 577
;577:			break;
ADDRGP4 $234
JUMPV
LABELV $247
line 581
;578:
;579:		case EV_USE_ITEM1:		// teleporter
;580:			// drop flags in CTF
;581:			item = NULL;
ADDRLP4 12
CNSTP4 0
ASGNP4
line 582
;582:			j = 0;
ADDRLP4 28
CNSTI4 0
ASGNI4
line 584
;583:
;584:			if ( ent->client->ps.powerups[ PW_REDFLAG ] ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 340
ADDP4
INDIRI4
CNSTI4 0
EQI4 $248
line 585
;585:				item = BG_FindItemForPowerup( PW_REDFLAG );
CNSTI4 7
ARGI4
ADDRLP4 88
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 88
INDIRP4
ASGNP4
line 586
;586:				j = PW_REDFLAG;
ADDRLP4 28
CNSTI4 7
ASGNI4
line 587
;587:			} else if ( ent->client->ps.powerups[ PW_BLUEFLAG ] ) {
ADDRGP4 $249
JUMPV
LABELV $248
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
CNSTI4 0
EQI4 $250
line 588
;588:				item = BG_FindItemForPowerup( PW_BLUEFLAG );
CNSTI4 8
ARGI4
ADDRLP4 88
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 88
INDIRP4
ASGNP4
line 589
;589:				j = PW_BLUEFLAG;
ADDRLP4 28
CNSTI4 8
ASGNI4
line 590
;590:			} else if ( ent->client->ps.powerups[ PW_NEUTRALFLAG ] ) {
ADDRGP4 $251
JUMPV
LABELV $250
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
CNSTI4 0
EQI4 $252
line 591
;591:				item = BG_FindItemForPowerup( PW_NEUTRALFLAG );
CNSTI4 9
ARGI4
ADDRLP4 88
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 88
INDIRP4
ASGNP4
line 592
;592:				j = PW_NEUTRALFLAG;
ADDRLP4 28
CNSTI4 9
ASGNI4
line 593
;593:			}
LABELV $252
LABELV $251
LABELV $249
line 595
;594:
;595:			if ( item ) {
ADDRLP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $254
line 596
;596:				drop = Drop_Item( ent, item, 0 );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 12
INDIRP4
ARGP4
CNSTF4 0
ARGF4
ADDRLP4 88
ADDRGP4 Drop_Item
CALLP4
ASGNP4
ADDRLP4 60
ADDRLP4 88
INDIRP4
ASGNP4
line 598
;597:				// decide how many seconds it has left
;598:				drop->count = ( ent->client->ps.powerups[ j ] - level.time ) / 1000;
ADDRLP4 60
INDIRP4
CNSTI4 760
ADDP4
ADDRLP4 28
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
line 599
;599:				if ( drop->count < 1 ) {
ADDRLP4 60
INDIRP4
CNSTI4 760
ADDP4
INDIRI4
CNSTI4 1
GEI4 $257
line 600
;600:					drop->count = 1;
ADDRLP4 60
INDIRP4
CNSTI4 760
ADDP4
CNSTI4 1
ASGNI4
line 601
;601:				}
LABELV $257
line 603
;602:
;603:				ent->client->ps.powerups[ j ] = 0;
ADDRLP4 28
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
CNSTI4 0
ASGNI4
line 604
;604:			}
LABELV $254
line 628
;605:
;606:#ifdef MISSIONPACK
;607:			if ( g_gametype.integer == GT_HARVESTER ) {
;608:				if ( ent->client->ps.generic1 > 0 ) {
;609:					if ( ent->client->sess.sessionTeam == TEAM_RED ) {
;610:						item = BG_FindItem( "Blue Cube" );
;611:					} else {
;612:						item = BG_FindItem( "Red Cube" );
;613:					}
;614:					if ( item ) {
;615:						for ( j = 0; j < ent->client->ps.generic1; j++ ) {
;616:							drop = Drop_Item( ent, item, 0 );
;617:							if ( ent->client->sess.sessionTeam == TEAM_RED ) {
;618:								drop->spawnflags = TEAM_BLUE;
;619:							} else {
;620:								drop->spawnflags = TEAM_RED;
;621:							}
;622:						}
;623:					}
;624:					ent->client->ps.generic1 = 0;
;625:				}
;626:			}
;627:#endif
;628:			SelectSpawnPoint( ent->client->ps.origin, origin, angles );
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 48
ARGP4
ADDRGP4 SelectSpawnPoint
CALLP4
pop
line 629
;629:			TeleportPlayer( ent, origin, angles );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 48
ARGP4
ADDRGP4 TeleportPlayer
CALLV
pop
line 630
;630:			break;
ADDRGP4 $234
JUMPV
LABELV $259
line 633
;631:
;632:		case EV_USE_ITEM2:		// medkit
;633:			ent->health = ent->client->ps.stats[STAT_MAX_HEALTH] + 25;
ADDRLP4 88
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 88
INDIRP4
CNSTI4 732
ADDP4
ADDRLP4 88
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 25
ADDI4
ASGNI4
line 635
;634:
;635:			break;
line 659
;636:
;637:#ifdef MISSIONPACK
;638:		case EV_USE_ITEM3:		// kamikaze
;639:			// make sure the invulnerability is off
;640:			ent->client->invulnerabilityTime = 0;
;641:			// start the kamikze
;642:			G_StartKamikaze( ent );
;643:			break;
;644:
;645:		case EV_USE_ITEM4:		// portal
;646:			if( ent->client->portalID ) {
;647:				DropPortalSource( ent );
;648:			}
;649:			else {
;650:				DropPortalDestination( ent );
;651:			}
;652:			break;
;653:		case EV_USE_ITEM5:		// invulnerability
;654:			ent->client->invulnerabilityTime = level.time + 10000;
;655:			break;
;656:#endif
;657:
;658:		default:
;659:			break;
LABELV $234
line 661
;660:		}
;661:	}
LABELV $230
line 553
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $232
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
LTI4 $229
line 663
;662:
;663:}
LABELV $226
endproc ClientEvents 92 32
export SendPendingPredictableEvents
proc SendPendingPredictableEvents 44 12
line 715
;664:
;665:#ifdef MISSIONPACK
;666:/*
;667:==============
;668:StuckInOtherClient
;669:==============
;670:*/
;671:static int StuckInOtherClient(gentity_t *ent) {
;672:	int i;
;673:	gentity_t	*ent2;
;674:
;675:	ent2 = &g_entities[0];
;676:	for ( i = 0; i < MAX_CLIENTS; i++, ent2++ ) {
;677:		if ( ent2 == ent ) {
;678:			continue;
;679:		}
;680:		if ( !ent2->inuse ) {
;681:			continue;
;682:		}
;683:		if ( !ent2->client ) {
;684:			continue;
;685:		}
;686:		if ( ent2->health <= 0 ) {
;687:			continue;
;688:		}
;689:		//
;690:		if (ent2->r.absmin[0] > ent->r.absmax[0])
;691:			continue;
;692:		if (ent2->r.absmin[1] > ent->r.absmax[1])
;693:			continue;
;694:		if (ent2->r.absmin[2] > ent->r.absmax[2])
;695:			continue;
;696:		if (ent2->r.absmax[0] < ent->r.absmin[0])
;697:			continue;
;698:		if (ent2->r.absmax[1] < ent->r.absmin[1])
;699:			continue;
;700:		if (ent2->r.absmax[2] < ent->r.absmin[2])
;701:			continue;
;702:		return qtrue;
;703:	}
;704:	return qfalse;
;705:}
;706:#endif
;707:
;708:void BotTestSolid(vec3_t origin);
;709:
;710:/*
;711:==============
;712:SendPendingPredictableEvents
;713:==============
;714:*/
;715:void SendPendingPredictableEvents( playerState_t *ps ) {
line 721
;716:	gentity_t *t;
;717:	int event, seq;
;718:	int extEvent, number;
;719:
;720:	// if there are still events pending
;721:	if ( ps->entityEventSequence < ps->eventSequence ) {
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 464
ADDP4
INDIRI4
ADDRLP4 20
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
GEI4 $262
line 724
;722:		// create a temporary entity for this event which is sent to everyone
;723:		// except the client who generated the event
;724:		seq = ps->entityEventSequence & (MAX_PS_EVENTS-1);
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 464
ADDP4
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 725
;725:		event = ps->events[ seq ] | ( ( ps->entityEventSequence & 3 ) << 8 );
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 24
INDIRP4
CNSTI4 112
ADDP4
ADDP4
INDIRI4
ADDRLP4 24
INDIRP4
CNSTI4 464
ADDP4
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 8
LSHI4
BORI4
ASGNI4
line 727
;726:		// set external event to zero before calling BG_PlayerStateToEntityState
;727:		extEvent = ps->externalEvent;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
INDIRI4
ASGNI4
line 728
;728:		ps->externalEvent = 0;
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
CNSTI4 0
ASGNI4
line 730
;729:		// create temporary entity for event
;730:		t = G_TempEntity( ps->origin, event );
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 28
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 28
INDIRP4
ASGNP4
line 731
;731:		number = t->s.number;
ADDRLP4 16
ADDRLP4 0
INDIRP4
INDIRI4
ASGNI4
line 732
;732:		BG_PlayerStateToEntityState( ps, &t->s, qtrue );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
line 733
;733:		t->s.number = number;
ADDRLP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ASGNI4
line 734
;734:		t->s.eType = ET_EVENTS + event;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 14
ADDI4
ASGNI4
line 735
;735:		t->s.eFlags |= EF_PLAYER_EVENT;
ADDRLP4 32
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 736
;736:		t->s.otherEntityNum = ps->clientNum;
ADDRLP4 36
CNSTI4 140
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 738
;737:		// send to everyone except the client who generated the event
;738:		t->r.svFlags |= SVF_NOTSINGLECLIENT;
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 2048
BORI4
ASGNI4
line 739
;739:		t->r.singleClient = ps->clientNum;
ADDRLP4 0
INDIRP4
CNSTI4 428
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 741
;740:		// set back external event
;741:		ps->externalEvent = extEvent;
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
ADDRLP4 12
INDIRI4
ASGNI4
line 742
;742:	}
LABELV $262
line 743
;743:}
LABELV $261
endproc SendPendingPredictableEvents 44 12
proc OneLifeModeActive 0 0
line 758
;744:
;745:/*
;746:==============
;747:ClientThink
;748:
;749:This will be called once for each client frame, which will
;750:usually be a couple times for each server frame on fast clients.
;751:
;752:If "g_synchronousClients 1" is set, this will be called exactly
;753:once for each server frame, which makes for smooth demo recording.
;754:==============
;755:*/
;756:
;757:/*OneLifeMod*/
;758:static qboolean OneLifeModeActive( void ) {
line 759
;759:	if( g_oneLifeTDM.integer &&
ADDRGP4 g_oneLifeTDM+12
INDIRI4
CNSTI4 0
EQI4 $265
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $265
line 760
;760:		g_gametype.integer == GT_TEAM ) {
line 761
;761:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $264
JUMPV
LABELV $265
line 764
;762:	}
;763:
;764:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 2
NEI4 $269
line 765
;765:		MONSTER_HUNT_ONE_LIFE ) {
line 766
;766:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $264
JUMPV
LABELV $269
line 769
;767:	}
;768:
;769:	return qfalse;
CNSTI4 0
RETI4
LABELV $264
endproc OneLifeModeActive 0 0
proc OneLifeBecomeSpectator 4 8
line 776
;770:}
;771:/*
;772:========================
;773:OneLifeBecomeSpectator
;774:========================
;775:*/
;776:static void OneLifeBecomeSpectator( gentity_t *ent ) {
line 779
;777:	gclient_t	*client;
;778:
;779:	client = ent->client;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 781
;780:
;781:	if( client->oneLifeEliminated ) {
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $273
line 782
;782:		return;
ADDRGP4 $272
JUMPV
LABELV $273
line 788
;783:	}
;784:
;785:	/*
;786:	 * Preserve a visible corpse before hiding the real client entity.
;787:	 */
;788:	CopyToBodyQue( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CopyToBodyQue
CALLV
pop
line 790
;789:
;790:	client->oneLifeEliminated = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
CNSTI4 1
ASGNI4
line 791
;791:	client->ps.pm_type = PM_SPECTATOR;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 2
ASGNI4
line 793
;792:
;793:	ent->takedamage = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 794
;794:	ent->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 795
;795:	ent->s.eType = ET_INVISIBLE;
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 10
ASGNI4
line 797
;796:
;797:	trap_UnlinkEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 799
;798:
;799:	client->sess.spectatorState = SPECTATOR_FREE;
ADDRLP4 0
INDIRP4
CNSTI4 624
ADDP4
CNSTI4 1
ASGNI4
line 800
;800:	client->sess.spectatorClient = ent - g_entities;
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 884
DIVI4
ASGNI4
line 805
;801:
;802:	/*
;803:	 * Select the first living teammate.
;804:	 */
;805:	Cmd_FollowCycle_f( ent, 1 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 Cmd_FollowCycle_f
CALLV
pop
line 806
;806:}
LABELV $272
endproc OneLifeBecomeSpectator 4 8
export ClientThink_real
proc ClientThink_real 312 16
line 808
;807:
;808:void ClientThink_real( gentity_t *ent ) {
line 815
;809:	gclient_t	*client;
;810:	pmove_t		pm;
;811:	int		oldEventSequence;
;812:	int		msec;
;813:	usercmd_t	*ucmd;
;814:
;815:	client = ent->client;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 818
;816:
;817:	// don't think if the client is not yet connected
;818:	if( client->pers.connected != CON_CONNECTED ) {
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $276
line 819
;819:		return;
ADDRGP4 $275
JUMPV
LABELV $276
line 823
;820:	}
;821:
;822:	// mark the time, so the connection sprite can be removed
;823:	ucmd = &ent->client->pers.cmd;
ADDRLP4 236
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 472
ADDP4
ASGNP4
line 826
;824:
;825:	// sanity check command time to prevent speedup cheating
;826:	if( ucmd->serverTime > level.time + 200 ) {
ADDRLP4 236
INDIRP4
INDIRI4
ADDRGP4 level+32
INDIRI4
CNSTI4 200
ADDI4
LEI4 $278
line 827
;827:		ucmd->serverTime = level.time + 200;
ADDRLP4 236
INDIRP4
ADDRGP4 level+32
INDIRI4
CNSTI4 200
ADDI4
ASGNI4
line 828
;828:	}
LABELV $278
line 830
;829:
;830:	if( ucmd->serverTime < level.time - 1000 ) {
ADDRLP4 236
INDIRP4
INDIRI4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
SUBI4
GEI4 $282
line 831
;831:		ucmd->serverTime = level.time - 1000;
ADDRLP4 236
INDIRP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
SUBI4
ASGNI4
line 832
;832:	}
LABELV $282
line 834
;833:
;834:	msec = ucmd->serverTime - client->ps.commandTime;
ADDRLP4 240
ADDRLP4 236
INDIRP4
INDIRI4
ADDRLP4 0
INDIRP4
INDIRI4
SUBI4
ASGNI4
line 840
;835:
;836:	/*
;837:	 * Following others may result in bad times, but we still
;838:	 * want to check for follow toggles.
;839:	 */
;840:	if( msec < 1 &&
ADDRLP4 240
INDIRI4
CNSTI4 1
GEI4 $286
ADDRLP4 0
INDIRP4
CNSTI4 624
ADDP4
INDIRI4
CNSTI4 2
EQI4 $286
line 841
;841:		client->sess.spectatorState != SPECTATOR_FOLLOW ) {
line 842
;842:		return;
ADDRGP4 $275
JUMPV
LABELV $286
line 845
;843:	}
;844:
;845:	if( msec > 200 ) {
ADDRLP4 240
INDIRI4
CNSTI4 200
LEI4 $288
line 846
;846:		msec = 200;
ADDRLP4 240
CNSTI4 200
ASGNI4
line 847
;847:	}
LABELV $288
line 849
;848:
;849:	if( pmove_msec.integer < 8 ) {
ADDRGP4 pmove_msec+12
INDIRI4
CNSTI4 8
GEI4 $290
line 850
;850:		trap_Cvar_Set( "pmove_msec", "8" );
ADDRGP4 $293
ARGP4
ADDRGP4 $294
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 851
;851:	}
ADDRGP4 $291
JUMPV
LABELV $290
line 852
;852:	else if( pmove_msec.integer > 33 ) {
ADDRGP4 pmove_msec+12
INDIRI4
CNSTI4 33
LEI4 $295
line 853
;853:		trap_Cvar_Set( "pmove_msec", "33" );
ADDRGP4 $293
ARGP4
ADDRGP4 $298
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 854
;854:	}
LABELV $295
LABELV $291
line 856
;855:
;856:	if( pmove_fixed.integer ||
ADDRLP4 248
CNSTI4 0
ASGNI4
ADDRGP4 pmove_fixed+12
INDIRI4
ADDRLP4 248
INDIRI4
NEI4 $302
ADDRLP4 0
INDIRP4
CNSTI4 508
ADDP4
INDIRI4
ADDRLP4 248
INDIRI4
EQI4 $299
LABELV $302
line 857
;857:		client->pers.pmoveFixed ) {
line 858
;858:		ucmd->serverTime =
ADDRLP4 236
INDIRP4
ADDRLP4 236
INDIRP4
INDIRI4
ADDRGP4 pmove_msec+12
INDIRI4
ADDI4
CNSTI4 1
SUBI4
ADDRGP4 pmove_msec+12
INDIRI4
DIVI4
ADDRGP4 pmove_msec+12
INDIRI4
MULI4
ASGNI4
line 863
;859:			((ucmd->serverTime +
;860:			  pmove_msec.integer - 1) /
;861:			 pmove_msec.integer) *
;862:			pmove_msec.integer;
;863:	}
LABELV $299
line 868
;864:
;865:	//
;866:	// check for exiting intermission
;867:	//
;868:	if( level.intermissiontime ) {
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $306
line 869
;869:		ClientIntermissionThink( client );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 ClientIntermissionThink
CALLV
pop
line 870
;870:		return;
ADDRGP4 $275
JUMPV
LABELV $306
line 874
;871:	}
;872:
;873:	// spectators and eliminated One Life players
;874:	if( client->sess.sessionTeam == TEAM_SPECTATOR ||
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $311
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $309
LABELV $311
line 875
;875:		client->oneLifeEliminated ) {
line 876
;876:		if( client->sess.spectatorState ==
ADDRLP4 0
INDIRP4
CNSTI4 624
ADDP4
INDIRI4
CNSTI4 3
NEI4 $312
line 877
;877:			SPECTATOR_SCOREBOARD ) {
line 878
;878:			return;
ADDRGP4 $275
JUMPV
LABELV $312
line 881
;879:		}
;880:
;881:		SpectatorThink( ent, ucmd );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 236
INDIRP4
ARGP4
ADDRGP4 SpectatorThink
CALLV
pop
line 882
;882:		return;
ADDRGP4 $275
JUMPV
LABELV $309
line 889
;883:	}
;884:
;885:	/*
;886:	 * Check inactivity timer, but never drop the local client
;887:	 * of a non-dedicated server.
;888:	 */
;889:	if( !ClientInactivityTimer(client) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 256
ADDRGP4 ClientInactivityTimer
CALLI4
ASGNI4
ADDRLP4 256
INDIRI4
CNSTI4 0
NEI4 $314
line 890
;890:		return;
ADDRGP4 $275
JUMPV
LABELV $314
line 894
;891:	}
;892:
;893:	// clear rewards if their display time has expired
;894:	if( level.time > client->rewardTime ) {
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
INDIRI4
LEI4 $316
line 895
;895:		client->ps.eFlags &=
ADDRLP4 260
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 260
INDIRP4
ADDRLP4 260
INDIRP4
INDIRI4
CNSTI4 -231497
BANDI4
ASGNI4
line 902
;896:			~(EF_AWARD_IMPRESSIVE |
;897:			  EF_AWARD_EXCELLENT |
;898:			  EF_AWARD_GAUNTLET |
;899:			  EF_AWARD_ASSIST |
;900:			  EF_AWARD_DEFEND |
;901:			  EF_AWARD_CAP);
;902:	}
LABELV $316
line 904
;903:
;904:	if( client->noclip ) {
ADDRLP4 0
INDIRP4
CNSTI4 648
ADDP4
INDIRI4
CNSTI4 0
EQI4 $319
line 905
;905:		client->ps.pm_type = PM_NOCLIP;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 1
ASGNI4
line 906
;906:	}
ADDRGP4 $320
JUMPV
LABELV $319
line 907
;907:	else if( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $321
line 908
;908:		client->ps.pm_type = PM_DEAD;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 3
ASGNI4
line 909
;909:	}
ADDRGP4 $322
JUMPV
LABELV $321
line 910
;910:	else {
line 911
;911:		client->ps.pm_type = PM_NORMAL;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 0
ASGNI4
line 912
;912:	}
LABELV $322
LABELV $320
line 914
;913:
;914:	client->ps.gravity = g_gravity.value;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDRGP4 g_gravity+8
INDIRF4
CVFI4 4
ASGNI4
line 917
;915:
;916:	// set movement speed
;917:	client->ps.speed = g_speed.value;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRGP4 g_speed+8
INDIRF4
CVFI4 4
ASGNI4
line 927
;918:
;919:#ifdef MISSIONPACK
;920:	if( bg_itemlist[
;921:		client->ps.stats[STAT_PERSISTANT_POWERUP]
;922:	].giTag == PW_SCOUT ) {
;923:		client->ps.speed *= 1.5;
;924:	}
;925:	else
;926:#endif
;927:	if( client->ps.powerups[PW_HASTE] ) {
ADDRLP4 0
INDIRP4
CNSTI4 324
ADDP4
INDIRI4
CNSTI4 0
EQI4 $325
line 928
;928:		client->ps.speed *= 1.3;
ADDRLP4 260
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ASGNP4
ADDRLP4 260
INDIRP4
CNSTF4 1067869798
ADDRLP4 260
INDIRP4
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 929
;929:	}
LABELV $325
line 932
;930:
;931:	// Let go of the hook if we aren't firing
;932:	if( client->ps.weapon == WP_GRAPPLING_HOOK &&
ADDRLP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
CNSTI4 10
NEI4 $327
ADDRLP4 0
INDIRP4
CNSTI4 764
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $327
ADDRLP4 236
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $327
line 934
;933:		client->hook &&
;934:		!(ucmd->buttons & BUTTON_ATTACK) ) {
line 935
;935:		Weapon_HookFree( client->hook );
ADDRLP4 0
INDIRP4
CNSTI4 764
ADDP4
INDIRP4
ARGP4
ADDRGP4 Weapon_HookFree
CALLV
pop
line 936
;936:	}
LABELV $327
line 939
;937:
;938:	// set up for pmove
;939:	oldEventSequence = client->ps.eventSequence;
ADDRLP4 244
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ASGNI4
line 941
;940:
;941:	memset( &pm, 0, sizeof(pm) );
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 232
ARGI4
ADDRGP4 memset
CALLP4
pop
line 947
;942:
;943:	/*
;944:	 * Check for the hit-scan gauntlet. Don't allow the attack
;945:	 * unless it actually hits something.
;946:	 */
;947:	if( client->ps.weapon == WP_GAUNTLET &&
ADDRLP4 268
CNSTI4 1
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ADDRLP4 268
INDIRI4
NEI4 $329
ADDRLP4 272
ADDRLP4 236
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
ADDRLP4 276
CNSTI4 0
ASGNI4
ADDRLP4 272
INDIRI4
CNSTI4 2
BANDI4
ADDRLP4 276
INDIRI4
NEI4 $329
ADDRLP4 272
INDIRI4
ADDRLP4 268
INDIRI4
BANDI4
ADDRLP4 276
INDIRI4
EQI4 $329
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
ADDRLP4 276
INDIRI4
GTI4 $329
line 950
;948:		!(ucmd->buttons & BUTTON_TALK) &&
;949:		(ucmd->buttons & BUTTON_ATTACK) &&
;950:		client->ps.weaponTime <= 0 ) {
line 951
;951:		pm.gauntletHit = CheckGauntletAttack( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
ADDRGP4 CheckGauntletAttack
CALLI4
ASGNI4
ADDRLP4 4+40
ADDRLP4 280
INDIRI4
ASGNI4
line 952
;952:	}
LABELV $329
line 954
;953:
;954:	if( ent->flags & FL_FORCE_GESTURE ) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 32768
BANDI4
CNSTI4 0
EQI4 $332
line 955
;955:		ent->flags &= ~FL_FORCE_GESTURE;
ADDRLP4 280
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 280
INDIRP4
ADDRLP4 280
INDIRP4
INDIRI4
CNSTI4 -32769
BANDI4
ASGNI4
line 956
;956:		ent->client->pers.cmd.buttons |=
ADDRLP4 284
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 488
ADDP4
ASGNP4
ADDRLP4 284
INDIRP4
ADDRLP4 284
INDIRP4
INDIRI4
CNSTI4 8
BORI4
ASGNI4
line 958
;957:			BUTTON_GESTURE;
;958:	}
LABELV $332
line 1009
;959:
;960:#ifdef MISSIONPACK
;961:	// check for invulnerability expansion before Pmove
;962:	if( client->ps.powerups[PW_INVULNERABILITY] ) {
;963:		if( !(client->ps.pm_flags &
;964:			PMF_INVULEXPAND) ) {
;965:			vec3_t mins = {-42, -42, -42};
;966:			vec3_t maxs = {42, 42, 42};
;967:			vec3_t oldmins;
;968:			vec3_t oldmaxs;
;969:
;970:			VectorCopy(
;971:				ent->r.mins,
;972:				oldmins
;973:			);
;974:			VectorCopy(
;975:				ent->r.maxs,
;976:				oldmaxs
;977:			);
;978:
;979:			VectorCopy(
;980:				mins,
;981:				ent->r.mins
;982:			);
;983:			VectorCopy(
;984:				maxs,
;985:				ent->r.maxs
;986:			);
;987:
;988:			trap_LinkEntity( ent );
;989:
;990:			if( !StuckInOtherClient(ent) ) {
;991:				client->ps.pm_flags |=
;992:					PMF_INVULEXPAND;
;993:			}
;994:
;995:			VectorCopy(
;996:				oldmins,
;997:				ent->r.mins
;998:			);
;999:			VectorCopy(
;1000:				oldmaxs,
;1001:				ent->r.maxs
;1002:			);
;1003:
;1004:			trap_LinkEntity( ent );
;1005:		}
;1006:	}
;1007:#endif
;1008:
;1009:	pm.ps = &client->ps;
ADDRLP4 4
ADDRLP4 0
INDIRP4
ASGNP4
line 1010
;1010:	pm.cmd = *ucmd;
ADDRLP4 4+4
ADDRLP4 236
INDIRP4
INDIRB
ASGNB 24
line 1012
;1011:
;1012:	if( pm.ps->pm_type == PM_DEAD ) {
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 3
NEI4 $335
line 1013
;1013:		pm.tracemask =
ADDRLP4 4+28
CNSTI4 65537
ASGNI4
line 1015
;1014:			MASK_PLAYERSOLID & ~CONTENTS_BODY;
;1015:	}
ADDRGP4 $336
JUMPV
LABELV $335
line 1016
;1016:	else if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $338
line 1017
;1017:		pm.tracemask =
ADDRLP4 4+28
CNSTI4 37814273
ASGNI4
line 1020
;1018:			MASK_PLAYERSOLID |
;1019:			CONTENTS_BOTCLIP;
;1020:	}
ADDRGP4 $339
JUMPV
LABELV $338
line 1021
;1021:	else {
line 1022
;1022:		pm.tracemask = MASK_PLAYERSOLID;
ADDRLP4 4+28
CNSTI4 33619969
ASGNI4
line 1023
;1023:	}
LABELV $339
LABELV $336
line 1025
;1024:
;1025:	pm.trace = trap_Trace;
ADDRLP4 4+224
ADDRGP4 trap_Trace
ASGNP4
line 1026
;1026:	pm.pointcontents = trap_PointContents;
ADDRLP4 4+228
ADDRGP4 trap_PointContents
ASGNP4
line 1027
;1027:	pm.debugLevel = g_debugMove.integer;
ADDRLP4 4+32
ADDRGP4 g_debugMove+12
INDIRI4
ASGNI4
line 1028
;1028:	pm.noFootsteps =
ADDRGP4 g_dmflags+12
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
LEI4 $349
ADDRLP4 280
CNSTI4 1
ASGNI4
ADDRGP4 $350
JUMPV
LABELV $349
ADDRLP4 280
CNSTI4 0
ASGNI4
LABELV $350
ADDRLP4 4+36
ADDRLP4 280
INDIRI4
ASGNI4
line 1031
;1029:		(g_dmflags.integer & DF_NO_FOOTSTEPS) > 0;
;1030:
;1031:	pm.pmove_fixed =
ADDRLP4 4+216
ADDRGP4 pmove_fixed+12
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 508
ADDP4
INDIRI4
BORI4
ASGNI4
line 1035
;1032:		pmove_fixed.integer |
;1033:		client->pers.pmoveFixed;
;1034:
;1035:	pm.pmove_msec = pmove_msec.integer;
ADDRLP4 4+220
ADDRGP4 pmove_msec+12
INDIRI4
ASGNI4
line 1037
;1036:
;1037:	VectorCopy(
ADDRLP4 0
INDIRP4
CNSTI4 672
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRB
ASGNB 12
line 1069
;1038:		client->ps.origin,
;1039:		client->oldOrigin
;1040:	);
;1041:
;1042:#ifdef MISSIONPACK
;1043:	if( level.intermissionQueued != 0 &&
;1044:		g_singlePlayer.integer ) {
;1045:		if( level.time -
;1046:			level.intermissionQueued >= 1000 ) {
;1047:			pm.cmd.buttons = 0;
;1048:			pm.cmd.forwardmove = 0;
;1049:			pm.cmd.rightmove = 0;
;1050:			pm.cmd.upmove = 0;
;1051:
;1052:			if( level.time -
;1053:				level.intermissionQueued >= 2000 &&
;1054:				level.time -
;1055:				level.intermissionQueued <= 2500 ) {
;1056:				trap_SendConsoleCommand(
;1057:					EXEC_APPEND,
;1058:					"centerview\n"
;1059:				);
;1060:			}
;1061:
;1062:			ent->client->ps.pm_type =
;1063:				PM_SPINTERMISSION;
;1064:		}
;1065:	}
;1066:
;1067:	Pmove( &pm );
;1068:#else
;1069:	Pmove( &pm );
ADDRLP4 4
ARGP4
ADDRGP4 Pmove
CALLV
pop
line 1073
;1070:#endif
;1071:
;1072:	// save results of pmove
;1073:	if( ent->client->ps.eventSequence !=
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ADDRLP4 244
INDIRI4
EQI4 $355
line 1074
;1074:		oldEventSequence ) {
line 1075
;1075:		ent->eventTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 552
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1076
;1076:	}
LABELV $355
line 1078
;1077:
;1078:	if( g_smoothClients.integer ) {
ADDRGP4 g_smoothClients+12
INDIRI4
CNSTI4 0
EQI4 $358
line 1079
;1079:		BG_PlayerStateToEntityStateExtraPolate(
ADDRLP4 288
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 292
ADDRLP4 288
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 292
INDIRP4
ARGP4
ADDRLP4 288
INDIRP4
ARGP4
ADDRLP4 292
INDIRP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 BG_PlayerStateToEntityStateExtraPolate
CALLV
pop
line 1085
;1080:			&ent->client->ps,
;1081:			&ent->s,
;1082:			ent->client->ps.commandTime,
;1083:			qtrue
;1084:		);
;1085:	}
ADDRGP4 $359
JUMPV
LABELV $358
line 1086
;1086:	else {
line 1087
;1087:		BG_PlayerStateToEntityState(
ADDRLP4 288
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 288
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ARGP4
ADDRLP4 288
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
line 1092
;1088:			&ent->client->ps,
;1089:			&ent->s,
;1090:			qtrue
;1091:		);
;1092:	}
LABELV $359
line 1094
;1093:
;1094:	SendPendingPredictableEvents(
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ARGP4
ADDRGP4 SendPendingPredictableEvents
CALLV
pop
line 1098
;1095:		&ent->client->ps
;1096:	);
;1097:
;1098:	if( !(ent->client->ps.eFlags & EF_FIRING) ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
NEI4 $361
line 1099
;1099:		client->fireHeld = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 760
ADDP4
CNSTI4 0
ASGNI4
line 1100
;1100:	}
LABELV $361
line 1106
;1101:
;1102:	/*
;1103:	 * Use the snapped origin for linking so it matches client
;1104:	 * predicted versions.
;1105:	 */
;1106:	VectorCopy(
ADDRLP4 288
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 288
INDIRP4
CNSTI4 488
ADDP4
ADDRLP4 288
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
line 1111
;1107:		ent->s.pos.trBase,
;1108:		ent->r.currentOrigin
;1109:	);
;1110:
;1111:	VectorCopy( pm.mins, ent->r.mins );
ADDRFP4 0
INDIRP4
CNSTI4 436
ADDP4
ADDRLP4 4+180
INDIRB
ASGNB 12
line 1112
;1112:	VectorCopy( pm.maxs, ent->r.maxs );
ADDRFP4 0
INDIRP4
CNSTI4 448
ADDP4
ADDRLP4 4+192
INDIRB
ASGNB 12
line 1114
;1113:
;1114:	ent->waterlevel = pm.waterlevel;
ADDRFP4 0
INDIRP4
CNSTI4 788
ADDP4
ADDRLP4 4+208
INDIRI4
ASGNI4
line 1115
;1115:	ent->watertype = pm.watertype;
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
ADDRLP4 4+204
INDIRI4
ASGNI4
line 1118
;1116:
;1117:	// execute client events
;1118:	ClientEvents( ent, oldEventSequence );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 244
INDIRI4
ARGI4
ADDRGP4 ClientEvents
CALLV
pop
line 1124
;1119:
;1120:	/*
;1121:	 * Link entity now, after personal teleporters have been
;1122:	 * used.
;1123:	 */
;1124:	trap_LinkEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1126
;1125:
;1126:	if( !ent->client->noclip ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 648
ADDP4
INDIRI4
CNSTI4 0
NEI4 $367
line 1127
;1127:		G_TouchTriggers( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_TouchTriggers
CALLV
pop
line 1128
;1128:	}
LABELV $367
line 1134
;1129:
;1130:	/*
;1131:	 * Copy the exact origin to avoid clients being snapped
;1132:	 * into solid areas.
;1133:	 */
;1134:	VectorCopy(
ADDRLP4 292
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 292
INDIRP4
CNSTI4 488
ADDP4
ADDRLP4 292
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
INDIRB
ASGNB 12
line 1140
;1135:		ent->client->ps.origin,
;1136:		ent->r.currentOrigin
;1137:	);
;1138:
;1139:	// test for solid areas in the AAS file
;1140:	BotTestAAS( ent->r.currentOrigin );
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRGP4 BotTestAAS
CALLV
pop
line 1143
;1141:
;1142:	// touch other objects
;1143:	ClientImpacts( ent, &pm );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 ClientImpacts
CALLV
pop
line 1146
;1144:
;1145:	// save trigger and client event results
;1146:	if( ent->client->ps.eventSequence !=
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ADDRLP4 244
INDIRI4
EQI4 $369
line 1147
;1147:		oldEventSequence ) {
line 1148
;1148:		ent->eventTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 552
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1149
;1149:	}
LABELV $369
line 1152
;1150:
;1151:	// swap and latch button actions
;1152:	client->oldbuttons = client->buttons;
ADDRLP4 0
INDIRP4
CNSTI4 664
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 660
ADDP4
INDIRI4
ASGNI4
line 1153
;1153:	client->buttons = ucmd->buttons;
ADDRLP4 0
INDIRP4
CNSTI4 660
ADDP4
ADDRLP4 236
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 1154
;1154:	client->latched_buttons |=
ADDRLP4 304
ADDRLP4 0
INDIRP4
CNSTI4 668
ADDP4
ASGNP4
ADDRLP4 304
INDIRP4
ADDRLP4 304
INDIRP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 660
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
BCOMI4
BANDI4
BORI4
ASGNI4
line 1158
;1155:		client->buttons & ~client->oldbuttons;
;1156:
;1157:	// check for respawning
;1158:	if( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $372
line 1159
;1159:		if( OneLifeModeActive() ) {
ADDRLP4 308
ADDRGP4 OneLifeModeActive
CALLI4
ASGNI4
ADDRLP4 308
INDIRI4
CNSTI4 0
EQI4 $374
line 1164
;1160:			/*
;1161:			 * respawnTime already contains the normal death delay.
;1162:			 * Give the model another 800 ms to finish its animation.
;1163:			 */
;1164:			if( level.time > client->respawnTime + 800 ) {
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
CNSTI4 800
ADDI4
LEI4 $275
line 1165
;1165:				OneLifeBecomeSpectator( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 OneLifeBecomeSpectator
CALLV
pop
line 1166
;1166:			}
line 1168
;1167:
;1168:			return;
ADDRGP4 $275
JUMPV
LABELV $374
line 1175
;1169:		}
;1170:		
;1171:		/*
;1172:		 * A positive g_respawnTime enables automatic respawning.
;1173:		 * One Life has already returned above.
;1174:		 */
;1175:		if( g_respawnTime.value > 0.0f ) {
ADDRGP4 g_respawnTime+8
INDIRF4
CNSTF4 0
LEF4 $379
line 1176
;1176:			if( level.time >= client->respawnTime ) {
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
LTI4 $275
line 1177
;1177:				respawn( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 respawn
CALLV
pop
line 1178
;1178:			}
line 1180
;1179:
;1180:			return;
ADDRGP4 $275
JUMPV
LABELV $379
line 1184
;1181:		}
;1182:
;1183:		// wait for the attack button to be pressed
;1184:		if( level.time > client->respawnTime ) {
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
LEI4 $275
line 1189
;1185:			/*
;1186:			 * Force respawn prevents players from waiting
;1187:			 * out powerups.
;1188:			 */
;1189:			if( g_forcerespawn.integer > 0 &&
ADDRGP4 g_forcerespawn+12
INDIRI4
CNSTI4 0
LEI4 $388
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
SUBI4
CNSTI4 1000
ADDRGP4 g_forcerespawn+12
INDIRI4
MULI4
LEI4 $388
line 1193
;1190:				(level.time -
;1191:				 client->respawnTime) >
;1192:				g_forcerespawn.integer *
;1193:				1000 ) {
line 1194
;1194:				respawn( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 respawn
CALLV
pop
line 1195
;1195:				return;
ADDRGP4 $275
JUMPV
LABELV $388
line 1199
;1196:			}
;1197:
;1198:			// attack or use is the normal respawn method
;1199:			if( ucmd->buttons &
ADDRLP4 236
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 5
BANDI4
CNSTI4 0
EQI4 $275
line 1201
;1200:				(BUTTON_ATTACK |
;1201:				 BUTTON_USE_HOLDABLE) ) {
line 1202
;1202:				respawn( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 respawn
CALLV
pop
line 1203
;1203:			}
line 1204
;1204:		}
line 1206
;1205:
;1206:		return;
ADDRGP4 $275
JUMPV
LABELV $372
line 1210
;1207:	}
;1208:
;1209:	// perform once-a-second actions
;1210:	ClientTimerActions( ent, msec );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 240
INDIRI4
ARGI4
ADDRGP4 ClientTimerActions
CALLV
pop
line 1211
;1211:}
LABELV $275
endproc ClientThink_real 312 16
export ClientThink
proc ClientThink 8 8
line 1220
;1212:
;1213:/*
;1214:==================
;1215:ClientThink
;1216:
;1217:A new command has arrived from the client
;1218:==================
;1219:*/
;1220:void ClientThink( int clientNum ) {
line 1223
;1221:	gentity_t *ent;
;1222:
;1223:	ent = g_entities + clientNum;
ADDRLP4 0
CNSTI4 884
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1224
;1224:	trap_GetUsercmd( clientNum, &ent->client->pers.cmd );
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 472
ADDP4
ARGP4
ADDRGP4 trap_GetUsercmd
CALLV
pop
line 1228
;1225:
;1226:	// mark the time we got info, so we can display the
;1227:	// phone jack if they don't get any for a while
;1228:	ent->client->lastCmdTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 656
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1230
;1229:
;1230:	if ( !(ent->r.svFlags & SVF_BOT) && !g_synchronousClients.integer ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
ADDRLP4 4
INDIRI4
NEI4 $397
ADDRGP4 g_synchronousClients+12
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $397
line 1231
;1231:		ClientThink_real( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 ClientThink_real
CALLV
pop
line 1232
;1232:	}
LABELV $397
line 1233
;1233:}
LABELV $395
endproc ClientThink 8 8
export G_RunClient
proc G_RunClient 4 4
line 1236
;1234:
;1235:
;1236:void G_RunClient( gentity_t *ent ) {
line 1237
;1237:	if ( !(ent->r.svFlags & SVF_BOT) && !g_synchronousClients.integer ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
ADDRLP4 0
INDIRI4
NEI4 $401
ADDRGP4 g_synchronousClients+12
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $401
line 1238
;1238:		return;
ADDRGP4 $400
JUMPV
LABELV $401
line 1240
;1239:	}
;1240:	ent->client->pers.cmd.serverTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 472
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1241
;1241:	ClientThink_real( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 ClientThink_real
CALLV
pop
line 1242
;1242:}
LABELV $400
endproc G_RunClient 4 4
export SpectatorClientEndFrame
proc SpectatorClientEndFrame 44 8
line 1251
;1243:
;1244:
;1245:/*
;1246:==================
;1247:SpectatorClientEndFrame
;1248:
;1249:==================
;1250:*/
;1251:void SpectatorClientEndFrame( gentity_t *ent ) {
line 1254
;1252:	gclient_t	*cl;
;1253:
;1254:	if( ent->client->sess.spectatorState ==
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 624
ADDP4
INDIRI4
CNSTI4 2
NEI4 $406
line 1255
;1255:		SPECTATOR_FOLLOW ) {
line 1259
;1256:		int	clientNum;
;1257:		int	flags;
;1258:
;1259:		clientNum =
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 628
ADDP4
INDIRI4
ASGNI4
line 1262
;1260:			ent->client->sess.spectatorClient;
;1261:
;1262:		if( clientNum == -1 ) {
ADDRLP4 4
INDIRI4
CNSTI4 -1
NEI4 $408
line 1263
;1263:			clientNum = level.follow1;
ADDRLP4 4
ADDRGP4 level+340
INDIRI4
ASGNI4
line 1264
;1264:		}
ADDRGP4 $409
JUMPV
LABELV $408
line 1265
;1265:		else if( clientNum == -2 ) {
ADDRLP4 4
INDIRI4
CNSTI4 -2
NEI4 $411
line 1266
;1266:			clientNum = level.follow2;
ADDRLP4 4
ADDRGP4 level+344
INDIRI4
ASGNI4
line 1267
;1267:		}
LABELV $411
LABELV $409
line 1269
;1268:
;1269:		if( clientNum >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $414
line 1270
;1270:			cl = &level.clients[clientNum];
ADDRLP4 0
CNSTI4 780
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 1272
;1271:
;1272:			if( cl->pers.connected ==
ADDRLP4 12
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $416
ADDRLP4 16
CNSTI4 616
ASGNI4
ADDRLP4 20
ADDRLP4 12
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 3
EQI4 $416
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 28
CNSTI4 652
ASGNI4
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRLP4 24
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $418
ADDRLP4 20
INDIRI4
ADDRLP4 24
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
NEI4 $416
ADDRLP4 12
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $416
ADDRLP4 12
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
LEI4 $416
LABELV $418
line 1284
;1273:					CON_CONNECTED &&
;1274:				cl->sess.sessionTeam !=
;1275:					TEAM_SPECTATOR &&
;1276:				(
;1277:					!ent->client->oneLifeEliminated ||
;1278:					(
;1279:						cl->sess.sessionTeam ==
;1280:							ent->client->sess.sessionTeam &&
;1281:						!cl->oneLifeEliminated &&
;1282:						cl->ps.stats[STAT_HEALTH] > 0
;1283:					)
;1284:				) ) {
line 1285
;1285:				flags =
ADDRLP4 36
CNSTI4 104
ASGNI4
ADDRLP4 8
ADDRLP4 0
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
INDIRI4
CNSTI4 -540673
BANDI4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
INDIRI4
CNSTI4 540672
BANDI4
BORI4
ASGNI4
line 1293
;1286:					(cl->ps.eFlags &
;1287:					 ~(EF_VOTED |
;1288:					   EF_TEAMVOTED)) |
;1289:					(ent->client->ps.eFlags &
;1290:					 (EF_VOTED |
;1291:					  EF_TEAMVOTED));
;1292:
;1293:				ent->client->ps = cl->ps;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ADDRLP4 0
INDIRP4
INDIRB
ASGNB 468
line 1294
;1294:				ent->client->ps.pm_flags |=
ADDRLP4 40
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1296
;1295:					PMF_FOLLOW;
;1296:				ent->client->ps.eFlags = flags;
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 1297
;1297:				return;
ADDRGP4 $405
JUMPV
LABELV $416
line 1304
;1298:			}
;1299:
;1300:			/*
;1301:			 * Never pass an eliminated player through
;1302:			 * ClientBegin(), because that respawns them.
;1303:			 */
;1304:			if( ent->client->oneLifeEliminated ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $419
line 1305
;1305:				Cmd_FollowCycle_f( ent, 1 );
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 Cmd_FollowCycle_f
CALLV
pop
line 1306
;1306:				return;
ADDRGP4 $405
JUMPV
LABELV $419
line 1309
;1307:			}
;1308:
;1309:			if( ent->client->sess.spectatorClient >= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 628
ADDP4
INDIRI4
CNSTI4 0
LTI4 $421
line 1310
;1310:				ent->client->sess.spectatorState =
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 624
ADDP4
CNSTI4 1
ASGNI4
line 1313
;1311:					SPECTATOR_FREE;
;1312:
;1313:				ClientBegin(
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 level
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 780
DIVI4
ARGI4
ADDRGP4 ClientBegin
CALLV
pop
line 1316
;1314:					ent->client - level.clients
;1315:				);
;1316:			}
LABELV $421
line 1317
;1317:		}
LABELV $414
line 1318
;1318:	}
LABELV $406
line 1320
;1319:
;1320:	if( ent->client->sess.spectatorState ==
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 624
ADDP4
INDIRI4
CNSTI4 3
NEI4 $423
line 1321
;1321:		SPECTATOR_SCOREBOARD ) {
line 1322
;1322:		ent->client->ps.pm_flags |=
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 8192
BORI4
ASGNI4
line 1324
;1323:			PMF_SCOREBOARD;
;1324:	}
ADDRGP4 $424
JUMPV
LABELV $423
line 1325
;1325:	else {
line 1326
;1326:		ent->client->ps.pm_flags &=
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 -8193
BANDI4
ASGNI4
line 1328
;1327:			~PMF_SCOREBOARD;
;1328:	}
LABELV $424
line 1329
;1329:}
LABELV $405
endproc SpectatorClientEndFrame 44 8
export ClientEndFrame
proc ClientEndFrame 24 16
line 1340
;1330:
;1331:/*
;1332:==============
;1333:ClientEndFrame
;1334:
;1335:Called at the end of each server frame for each connected client
;1336:A fast client will have multiple ClientThink for each ClientEdFrame,
;1337:while a slow client may have multiple ClientEndFrame between ClientThink.
;1338:==============
;1339:*/
;1340:void ClientEndFrame( gentity_t *ent ) {
line 1344
;1341:	int			i;
;1342:	clientPersistant_t	*pers;
;1343:
;1344:	if( ent->client->sess.sessionTeam == TEAM_SPECTATOR ||
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $428
ADDRLP4 8
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $426
LABELV $428
line 1345
;1345:		ent->client->oneLifeEliminated ) {
line 1346
;1346:		SpectatorClientEndFrame( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 SpectatorClientEndFrame
CALLV
pop
line 1347
;1347:		return;
ADDRGP4 $425
JUMPV
LABELV $426
line 1350
;1348:	}
;1349:
;1350:	pers = &ent->client->pers;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
ASGNP4
line 1353
;1351:
;1352:	// turn off any expired powerups
;1353:	for( i = 0; i < MAX_POWERUPS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $429
line 1354
;1354:		if( ent->client->ps.powerups[i] < level.time ) {
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
GEI4 $433
line 1355
;1355:			ent->client->ps.powerups[i] = 0;
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
CNSTI4 0
ASGNI4
line 1356
;1356:		}
LABELV $433
line 1357
;1357:	}
LABELV $430
line 1353
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $429
line 1410
;1358:
;1359:#ifdef MISSIONPACK
;1360:	// set powerup for player animation
;1361:	if( bg_itemlist[
;1362:		ent->client->ps.stats[STAT_PERSISTANT_POWERUP]
;1363:	].giTag == PW_GUARD ) {
;1364:		ent->client->ps.powerups[PW_GUARD] =
;1365:			level.time;
;1366:	}
;1367:
;1368:	if( bg_itemlist[
;1369:		ent->client->ps.stats[STAT_PERSISTANT_POWERUP]
;1370:	].giTag == PW_SCOUT ) {
;1371:		ent->client->ps.powerups[PW_SCOUT] =
;1372:			level.time;
;1373:	}
;1374:
;1375:	if( bg_itemlist[
;1376:		ent->client->ps.stats[STAT_PERSISTANT_POWERUP]
;1377:	].giTag == PW_DOUBLER ) {
;1378:		ent->client->ps.powerups[PW_DOUBLER] =
;1379:			level.time;
;1380:	}
;1381:
;1382:	if( bg_itemlist[
;1383:		ent->client->ps.stats[STAT_PERSISTANT_POWERUP]
;1384:	].giTag == PW_AMMOREGEN ) {
;1385:		ent->client->ps.powerups[PW_AMMOREGEN] =
;1386:			level.time;
;1387:	}
;1388:
;1389:	if( ent->client->invulnerabilityTime >
;1390:		level.time ) {
;1391:		ent->client->ps.powerups[PW_INVULNERABILITY] =
;1392:			level.time;
;1393:	}
;1394:#endif
;1395:
;1396:	// save network bandwidth
;1397:#if 0
;1398:	if( !g_synchronousClients->integer &&
;1399:		ent->client->ps.pm_type == PM_NORMAL ) {
;1400:		VectorClear(
;1401:			ent->client->ps.viewangles
;1402:		);
;1403:	}
;1404:#endif
;1405:
;1406:	/*
;1407:	 * If the end of unit layout is displayed, don't give
;1408:	 * the player any normal movement attributes.
;1409:	 */
;1410:	if( level.intermissiontime ) {
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $436
line 1411
;1411:		return;
ADDRGP4 $425
JUMPV
LABELV $436
line 1415
;1412:	}
;1413:
;1414:	// burn from lava, etc
;1415:	P_WorldEffects( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 P_WorldEffects
CALLV
pop
line 1418
;1416:
;1417:	// apply all the damage taken this frame
;1418:	P_DamageFeedback( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 P_DamageFeedback
CALLV
pop
line 1421
;1419:
;1420:	// add the connection flag for delayed commands
;1421:	if( level.time - ent->client->lastCmdTime > 1000 ) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 656
ADDP4
INDIRI4
SUBI4
CNSTI4 1000
LEI4 $439
line 1422
;1422:		ent->s.eFlags |= EF_CONNECTION;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 8192
BORI4
ASGNI4
line 1423
;1423:	}
ADDRGP4 $440
JUMPV
LABELV $439
line 1424
;1424:	else {
line 1425
;1425:		ent->s.eFlags &= ~EF_CONNECTION;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 -8193
BANDI4
ASGNI4
line 1426
;1426:	}
LABELV $440
line 1428
;1427:
;1428:	ent->client->ps.stats[STAT_HEALTH] =
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 12
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ASGNI4
line 1431
;1429:		ent->health;
;1430:
;1431:	G_SetClientSound( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_SetClientSound
CALLV
pop
line 1433
;1432:
;1433:	if( g_smoothClients.integer ) {
ADDRGP4 g_smoothClients+12
INDIRI4
CNSTI4 0
EQI4 $442
line 1434
;1434:		BG_PlayerStateToEntityStateExtraPolate(
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
ADDRLP4 16
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 20
INDIRP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 BG_PlayerStateToEntityStateExtraPolate
CALLV
pop
line 1440
;1435:			&ent->client->ps,
;1436:			&ent->s,
;1437:			ent->client->ps.commandTime,
;1438:			qtrue
;1439:		);
;1440:	}
ADDRGP4 $443
JUMPV
LABELV $442
line 1441
;1441:	else {
line 1442
;1442:		BG_PlayerStateToEntityState(
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
line 1447
;1443:			&ent->client->ps,
;1444:			&ent->s,
;1445:			qtrue
;1446:		);
;1447:	}
LABELV $443
line 1449
;1448:
;1449:	SendPendingPredictableEvents(
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ARGP4
ADDRGP4 SendPendingPredictableEvents
CALLV
pop
line 1464
;1450:		&ent->client->ps
;1451:	);
;1452:
;1453:	/*
;1454:	 * Reachability-area code from the original game remains
;1455:	 * intentionally disabled.
;1456:	 */
;1457:	/*
;1458:	i = trap_AAS_PointReachabilityAreaIndex(
;1459:		ent->client->ps.origin
;1460:	);
;1461:	ent->client->areabits[i >> 3] |=
;1462:		1 << (i & 7);
;1463:	*/
;1464:}
LABELV $425
endproc ClientEndFrame 24 16
import BotTestSolid
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
LABELV $298
byte 1 51
byte 1 51
byte 1 0
align 1
LABELV $294
byte 1 56
byte 1 0
align 1
LABELV $293
byte 1 112
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 95
byte 1 109
byte 1 115
byte 1 101
byte 1 99
byte 1 0
align 1
LABELV $204
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 84
byte 1 101
byte 1 110
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 32
byte 1 117
byte 1 110
byte 1 116
byte 1 105
byte 1 108
byte 1 32
byte 1 105
byte 1 110
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 100
byte 1 114
byte 1 111
byte 1 112
byte 1 33
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $200
byte 1 68
byte 1 114
byte 1 111
byte 1 112
byte 1 112
byte 1 101
byte 1 100
byte 1 32
byte 1 100
byte 1 117
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 105
byte 1 110
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 105
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $96
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 103
byte 1 117
byte 1 114
byte 1 112
byte 1 50
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $95
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 103
byte 1 117
byte 1 114
byte 1 112
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $92
byte 1 42
byte 1 100
byte 1 114
byte 1 111
byte 1 119
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
