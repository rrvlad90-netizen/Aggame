data
align 4
LABELV playerMins
byte 4 3245342720
byte 4 3245342720
byte 4 3250585600
align 4
LABELV playerMaxs
byte 4 1097859072
byte 4 1097859072
byte 4 1107296256
export SP_info_player_deathmatch
code
proc SP_info_player_deathmatch 8 12
file "../g_client.c"
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
;23:#include "g_local.h"
;24:
;25:// g_client.c -- client functions that don't happen every frame
;26:
;27:static vec3_t	playerMins = {-15, -15, -24};
;28:static vec3_t	playerMaxs = {15, 15, 32};
;29:
;30:/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 32) initial
;31:potential spawning position for deathmatch games.
;32:The first time a player enters the game, they will be at an 'initial' spot.
;33:Targets will be fired when someone spawns in on them.
;34:"nobots" will prevent bots from using this spot.
;35:"nohumans" will prevent non-bots from using this spot.
;36:*/
;37:void SP_info_player_deathmatch( gentity_t *ent ) {
line 40
;38:	int		i;
;39:
;40:	G_SpawnInt( "nobots", "0", &i);
ADDRGP4 $53
ARGP4
ADDRGP4 $54
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 G_SpawnInt
CALLI4
pop
line 41
;41:	if ( i ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $55
line 42
;42:		ent->flags |= FL_NO_BOTS;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 536
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
line 43
;43:	}
LABELV $55
line 44
;44:	G_SpawnInt( "nohumans", "0", &i );
ADDRGP4 $57
ARGP4
ADDRGP4 $54
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 G_SpawnInt
CALLI4
pop
line 45
;45:	if ( i ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $58
line 46
;46:		ent->flags |= FL_NO_HUMANS;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
line 47
;47:	}
LABELV $58
line 48
;48:}
LABELV $52
endproc SP_info_player_deathmatch 8 12
export SP_info_player_start
proc SP_info_player_start 0 4
line 53
;49:
;50:/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 32)
;51:equivelant to info_player_deathmatch
;52:*/
;53:void SP_info_player_start(gentity_t *ent) {
line 54
;54:	ent->classname = "info_player_deathmatch";
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $61
ASGNP4
line 55
;55:	SP_info_player_deathmatch( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 SP_info_player_deathmatch
CALLV
pop
line 56
;56:}
LABELV $60
endproc SP_info_player_start 0 4
export SP_info_player_intermission
proc SP_info_player_intermission 0 0
line 61
;57:
;58:/*QUAKED info_player_intermission (1 0 1) (-16 -16 -24) (16 16 32)
;59:The intermission will be viewed from this point.  Target an info_notnull for the view direction.
;60:*/
;61:void SP_info_player_intermission( gentity_t *ent ) {
line 63
;62:
;63:}
LABELV $62
endproc SP_info_player_intermission 0 0
export SpotWouldTelefrag
proc SpotWouldTelefrag 4144 16
line 81
;64:
;65:
;66:
;67:/*
;68:=======================================================================
;69:
;70:  SelectSpawnPoint
;71:
;72:=======================================================================
;73:*/
;74:
;75:/*
;76:================
;77:SpotWouldTelefrag
;78:
;79:================
;80:*/
;81:qboolean SpotWouldTelefrag( gentity_t *spot ) {
line 87
;82:	int			i, num;
;83:	int			touch[MAX_GENTITIES];
;84:	gentity_t	*hit;
;85:	vec3_t		mins, maxs;
;86:
;87:	VectorAdd( spot->s.origin, playerMins, mins );
ADDRLP4 4132
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4108
ADDRLP4 4132
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ADDRGP4 playerMins
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4108+4
ADDRLP4 4132
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ADDRGP4 playerMins+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4108+8
ADDRFP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ADDRGP4 playerMins+8
INDIRF4
ADDF4
ASGNF4
line 88
;88:	VectorAdd( spot->s.origin, playerMaxs, maxs );
ADDRLP4 4136
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4120
ADDRLP4 4136
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ADDRGP4 playerMaxs
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4120+4
ADDRLP4 4136
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ADDRGP4 playerMaxs+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4120+8
ADDRFP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ADDRGP4 playerMaxs+8
INDIRF4
ADDF4
ASGNF4
line 89
;89:	num = trap_EntitiesInBox( mins, maxs, touch, MAX_GENTITIES );
ADDRLP4 4108
ARGP4
ADDRLP4 4120
ARGP4
ADDRLP4 12
ARGP4
CNSTI4 1024
ARGI4
ADDRLP4 4140
ADDRGP4 trap_EntitiesInBox
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 4140
INDIRI4
ASGNI4
line 91
;90:
;91:	for (i=0 ; i<num ; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $75
JUMPV
LABELV $72
line 92
;92:		hit = &g_entities[touch[i]];
ADDRLP4 4
CNSTI4 808
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 12
ADDP4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 94
;93:		//if ( hit->client && hit->client->ps.stats[STAT_HEALTH] > 0 ) {
;94:		if ( hit->client) {
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $76
line 95
;95:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $63
JUMPV
LABELV $76
line 98
;96:		}
;97:
;98:	}
LABELV $73
line 91
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $75
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $72
line 100
;99:
;100:	return qfalse;
CNSTI4 0
RETI4
LABELV $63
endproc SpotWouldTelefrag 4144 16
export SelectNearestDeathmatchSpawnPoint
proc SelectNearestDeathmatchSpawnPoint 40 12
line 111
;101:}
;102:
;103:/*
;104:================
;105:SelectNearestDeathmatchSpawnPoint
;106:
;107:Find the spot that we DON'T want to use
;108:================
;109:*/
;110:#define	MAX_SPAWN_POINTS	128
;111:gentity_t *SelectNearestDeathmatchSpawnPoint( vec3_t from ) {
line 117
;112:	gentity_t	*spot;
;113:	vec3_t		delta;
;114:	float		dist, nearestDist;
;115:	gentity_t	*nearestSpot;
;116:
;117:	nearestDist = 999999;
ADDRLP4 20
CNSTF4 1232348144
ASGNF4
line 118
;118:	nearestSpot = NULL;
ADDRLP4 24
CNSTP4 0
ASGNP4
line 119
;119:	spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $80
JUMPV
LABELV $79
line 121
;120:
;121:	while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) {
line 123
;122:
;123:		VectorSubtract( spot->s.origin, from, delta );
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ADDRLP4 32
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ADDRLP4 32
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
SUBF4
ASGNF4
line 124
;124:		dist = VectorLength( delta );
ADDRLP4 4
ARGP4
ADDRLP4 36
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 16
ADDRLP4 36
INDIRF4
ASGNF4
line 125
;125:		if ( dist < nearestDist ) {
ADDRLP4 16
INDIRF4
ADDRLP4 20
INDIRF4
GEF4 $84
line 126
;126:			nearestDist = dist;
ADDRLP4 20
ADDRLP4 16
INDIRF4
ASGNF4
line 127
;127:			nearestSpot = spot;
ADDRLP4 24
ADDRLP4 0
INDIRP4
ASGNP4
line 128
;128:		}
LABELV $84
line 129
;129:	}
LABELV $80
line 121
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $61
ARGP4
ADDRLP4 28
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 28
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $79
line 131
;130:
;131:	return nearestSpot;
ADDRLP4 24
INDIRP4
RETP4
LABELV $78
endproc SelectNearestDeathmatchSpawnPoint 40 12
export SelectRandomDeathmatchSpawnPoint
proc SelectRandomDeathmatchSpawnPoint 532 12
line 143
;132:}
;133:
;134:
;135:/*
;136:================
;137:SelectRandomDeathmatchSpawnPoint
;138:
;139:go to a random point that doesn't telefrag
;140:================
;141:*/
;142:#define	MAX_SPAWN_POINTS	128
;143:gentity_t *SelectRandomDeathmatchSpawnPoint( void ) {
line 149
;144:	gentity_t	*spot;
;145:	int			count;
;146:	int			selection;
;147:	gentity_t	*spots[MAX_SPAWN_POINTS];
;148:
;149:	count = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 150
;150:	spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $88
JUMPV
LABELV $87
line 152
;151:
;152:	while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) {
line 153
;153:		if ( SpotWouldTelefrag( spot ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 524
ADDRGP4 SpotWouldTelefrag
CALLI4
ASGNI4
ADDRLP4 524
INDIRI4
CNSTI4 0
EQI4 $90
line 154
;154:			continue;
ADDRGP4 $88
JUMPV
LABELV $90
line 156
;155:		}
;156:		spots[ count ] = spot;
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 157
;157:		count++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 158
;158:	}
LABELV $88
line 152
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $61
ARGP4
ADDRLP4 524
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 524
INDIRP4
ASGNP4
ADDRLP4 524
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $87
line 160
;159:
;160:	if ( !count ) {	// no spots that won't telefrag
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $92
line 161
;161:		return G_Find( NULL, FOFS(classname), "info_player_deathmatch");
CNSTP4 0
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $61
ARGP4
ADDRLP4 528
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 528
INDIRP4
RETP4
ADDRGP4 $86
JUMPV
LABELV $92
line 164
;162:	}
;163:
;164:	selection = rand() % count;
ADDRLP4 528
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 520
ADDRLP4 528
INDIRI4
ADDRLP4 4
INDIRI4
MODI4
ASGNI4
line 165
;165:	return spots[ selection ];
ADDRLP4 520
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
ADDP4
INDIRP4
RETP4
LABELV $86
endproc SelectRandomDeathmatchSpawnPoint 532 12
export SelectRandomFurthestSpawnPoint
proc SelectRandomFurthestSpawnPoint 572 12
line 175
;166:}
;167:
;168:/*
;169:===========
;170:SelectRandomFurthestSpawnPoint
;171:
;172:Chooses a player start, deathmatch start, etc
;173:============
;174:*/
;175:gentity_t *SelectRandomFurthestSpawnPoint ( vec3_t avoidPoint, vec3_t origin, vec3_t angles ) {
line 183
;176:	gentity_t	*spot;
;177:	vec3_t		delta;
;178:	float		dist;
;179:	float		list_dist[64];
;180:	gentity_t	*list_spot[64];
;181:	int			numSpots, rnd, i, j;
;182:
;183:	numSpots = 0;
ADDRLP4 520
CNSTI4 0
ASGNI4
line 184
;184:	spot = NULL;
ADDRLP4 528
CNSTP4 0
ASGNP4
ADDRGP4 $96
JUMPV
LABELV $95
line 186
;185:
;186:	while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) {
line 187
;187:		if ( SpotWouldTelefrag( spot ) ) {
ADDRLP4 528
INDIRP4
ARGP4
ADDRLP4 548
ADDRGP4 SpotWouldTelefrag
CALLI4
ASGNI4
ADDRLP4 548
INDIRI4
CNSTI4 0
EQI4 $98
line 188
;188:			continue;
ADDRGP4 $96
JUMPV
LABELV $98
line 190
;189:		}
;190:		VectorSubtract( spot->s.origin, avoidPoint, delta );
ADDRLP4 556
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 532
ADDRLP4 528
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ADDRLP4 556
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 532+4
ADDRLP4 528
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ADDRLP4 556
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 532+8
ADDRLP4 528
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
SUBF4
ASGNF4
line 191
;191:		dist = VectorLength( delta );
ADDRLP4 532
ARGP4
ADDRLP4 560
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 524
ADDRLP4 560
INDIRF4
ASGNF4
line 192
;192:		for (i = 0; i < numSpots; i++) {
ADDRLP4 516
CNSTI4 0
ASGNI4
ADDRGP4 $105
JUMPV
LABELV $102
line 193
;193:			if ( dist > list_dist[i] ) {
ADDRLP4 524
INDIRF4
ADDRLP4 516
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
LEF4 $106
line 194
;194:				if ( numSpots >= 64 )
ADDRLP4 520
INDIRI4
CNSTI4 64
LTI4 $108
line 195
;195:					numSpots = 64-1;
ADDRLP4 520
CNSTI4 63
ASGNI4
LABELV $108
line 196
;196:				for (j = numSpots; j > i; j--) {
ADDRLP4 0
ADDRLP4 520
INDIRI4
ASGNI4
ADDRGP4 $113
JUMPV
LABELV $110
line 197
;197:					list_dist[j] = list_dist[j-1];
ADDRLP4 564
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 564
INDIRI4
ADDRLP4 4
ADDP4
ADDRLP4 564
INDIRI4
ADDRLP4 4-4
ADDP4
INDIRF4
ASGNF4
line 198
;198:					list_spot[j] = list_spot[j-1];
ADDRLP4 568
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 568
INDIRI4
ADDRLP4 260
ADDP4
ADDRLP4 568
INDIRI4
ADDRLP4 260-4
ADDP4
INDIRP4
ASGNP4
line 199
;199:				}
LABELV $111
line 196
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $113
ADDRLP4 0
INDIRI4
ADDRLP4 516
INDIRI4
GTI4 $110
line 200
;200:				list_dist[i] = dist;
ADDRLP4 516
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
ADDRLP4 524
INDIRF4
ASGNF4
line 201
;201:				list_spot[i] = spot;
ADDRLP4 516
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 260
ADDP4
ADDRLP4 528
INDIRP4
ASGNP4
line 202
;202:				numSpots++;
ADDRLP4 520
ADDRLP4 520
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 203
;203:				if (numSpots > 64)
ADDRLP4 520
INDIRI4
CNSTI4 64
LEI4 $104
line 204
;204:					numSpots = 64;
ADDRLP4 520
CNSTI4 64
ASGNI4
line 205
;205:				break;
ADDRGP4 $104
JUMPV
LABELV $106
line 207
;206:			}
;207:		}
LABELV $103
line 192
ADDRLP4 516
ADDRLP4 516
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $105
ADDRLP4 516
INDIRI4
ADDRLP4 520
INDIRI4
LTI4 $102
LABELV $104
line 208
;208:		if (i >= numSpots && numSpots < 64) {
ADDRLP4 516
INDIRI4
ADDRLP4 520
INDIRI4
LTI4 $118
ADDRLP4 520
INDIRI4
CNSTI4 64
GEI4 $118
line 209
;209:			list_dist[numSpots] = dist;
ADDRLP4 520
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
ADDRLP4 524
INDIRF4
ASGNF4
line 210
;210:			list_spot[numSpots] = spot;
ADDRLP4 520
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 260
ADDP4
ADDRLP4 528
INDIRP4
ASGNP4
line 211
;211:			numSpots++;
ADDRLP4 520
ADDRLP4 520
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 212
;212:		}
LABELV $118
line 213
;213:	}
LABELV $96
line 186
ADDRLP4 528
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $61
ARGP4
ADDRLP4 548
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 528
ADDRLP4 548
INDIRP4
ASGNP4
ADDRLP4 548
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $95
line 214
;214:	if (!numSpots) {
ADDRLP4 520
INDIRI4
CNSTI4 0
NEI4 $120
line 215
;215:		spot = G_Find( NULL, FOFS(classname), "info_player_deathmatch");
CNSTP4 0
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $61
ARGP4
ADDRLP4 552
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 528
ADDRLP4 552
INDIRP4
ASGNP4
line 216
;216:		if (!spot)
ADDRLP4 528
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $122
line 217
;217:			G_Error( "Couldn't find a spawn point" );
ADDRGP4 $124
ARGP4
ADDRGP4 G_Error
CALLV
pop
LABELV $122
line 218
;218:		VectorCopy (spot->s.origin, origin);
ADDRFP4 4
INDIRP4
ADDRLP4 528
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 219
;219:		origin[2] += 9;
ADDRLP4 556
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 556
INDIRP4
ADDRLP4 556
INDIRP4
INDIRF4
CNSTF4 1091567616
ADDF4
ASGNF4
line 220
;220:		VectorCopy (spot->s.angles, angles);
ADDRFP4 8
INDIRP4
ADDRLP4 528
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 221
;221:		return spot;
ADDRLP4 528
INDIRP4
RETP4
ADDRGP4 $94
JUMPV
LABELV $120
line 225
;222:	}
;223:
;224:	// select a random spot from the spawn points furthest away
;225:	rnd = random() * (numSpots / 2);
ADDRLP4 552
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 544
ADDRLP4 552
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRLP4 520
INDIRI4
CNSTI4 2
DIVI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 227
;226:
;227:	VectorCopy (list_spot[rnd]->s.origin, origin);
ADDRFP4 4
INDIRP4
ADDRLP4 544
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 260
ADDP4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 228
;228:	origin[2] += 9;
ADDRLP4 556
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 556
INDIRP4
ADDRLP4 556
INDIRP4
INDIRF4
CNSTF4 1091567616
ADDF4
ASGNF4
line 229
;229:	VectorCopy (list_spot[rnd]->s.angles, angles);
ADDRFP4 8
INDIRP4
ADDRLP4 544
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 260
ADDP4
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 231
;230:
;231:	return list_spot[rnd];
ADDRLP4 544
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 260
ADDP4
INDIRP4
RETP4
LABELV $94
endproc SelectRandomFurthestSpawnPoint 572 12
export SelectSpawnPoint
proc SelectSpawnPoint 4 12
line 241
;232:}
;233:
;234:/*
;235:===========
;236:SelectSpawnPoint
;237:
;238:Chooses a player start, deathmatch start, etc
;239:============
;240:*/
;241:gentity_t *SelectSpawnPoint ( vec3_t avoidPoint, vec3_t origin, vec3_t angles ) {
line 242
;242:	return SelectRandomFurthestSpawnPoint( avoidPoint, origin, angles );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 SelectRandomFurthestSpawnPoint
CALLP4
ASGNP4
ADDRLP4 0
INDIRP4
RETP4
LABELV $125
endproc SelectSpawnPoint 4 12
export SelectBaseTeamSpawnPoint
proc SelectBaseTeamSpawnPoint 1144 12
line 288
;243:
;244:	/*
;245:	gentity_t	*spot;
;246:	gentity_t	*nearestSpot;
;247:
;248:	nearestSpot = SelectNearestDeathmatchSpawnPoint( avoidPoint );
;249:
;250:	spot = SelectRandomDeathmatchSpawnPoint ( );
;251:	if ( spot == nearestSpot ) {
;252:		// roll again if it would be real close to point of death
;253:		spot = SelectRandomDeathmatchSpawnPoint ( );
;254:		if ( spot == nearestSpot ) {
;255:			// last try
;256:			spot = SelectRandomDeathmatchSpawnPoint ( );
;257:		}		
;258:	}
;259:
;260:	// find a single player start spot
;261:	if (!spot) {
;262:		G_Error( "Couldn't find a spawn point" );
;263:	}
;264:
;265:	VectorCopy (spot->s.origin, origin);
;266:	origin[2] += 9;
;267:	VectorCopy (spot->s.angles, angles);
;268:
;269:	return spot;
;270:	*/
;271:}
;272:
;273:#define MAX_BASE_SPAWN_POINTS 128
;274:
;275:/*
;276:========================
;277:SelectBaseTeamSpawnPoint
;278:
;279:Finds two distant deathmatch spawn points and uses them as
;280:automatic red and blue base anchors. Remaining spawn points
;281:are assigned to the closest anchor.
;282:========================
;283:*/
;284:gentity_t *SelectBaseTeamSpawnPoint(
;285:	team_t team,
;286:	vec3_t origin,
;287:	vec3_t angles
;288:) {
line 306
;289:	gentity_t	*spot;
;290:	gentity_t	*spots[MAX_BASE_SPAWN_POINTS];
;291:	gentity_t	*candidates[MAX_BASE_SPAWN_POINTS];
;292:	int		numSpots;
;293:	int		numCandidates;
;294:	int		redBase;
;295:	int		blueBase;
;296:	int		i;
;297:	int		j;
;298:	float		dx;
;299:	float		dy;
;300:	float		distance;
;301:	float		bestDistance;
;302:	float		redDistance;
;303:	float		blueDistance;
;304:	qboolean	belongsToTeam;
;305:
;306:	numSpots = 0;
ADDRLP4 536
CNSTI4 0
ASGNI4
line 307
;307:	spot = NULL;
ADDRLP4 548
CNSTP4 0
ASGNP4
ADDRGP4 $128
JUMPV
LABELV $127
line 313
;308:
;309:	while( (spot = G_Find(
;310:		spot,
;311:		FOFS(classname),
;312:		"info_player_deathmatch"
;313:	)) != NULL ) {
line 314
;314:		spots[numSpots++] = spot;
ADDRLP4 1080
ADDRLP4 536
INDIRI4
ASGNI4
ADDRLP4 536
ADDRLP4 1080
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 1080
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 0
ADDP4
ADDRLP4 548
INDIRP4
ASGNP4
line 316
;315:
;316:		if( numSpots == MAX_BASE_SPAWN_POINTS ) {
ADDRLP4 536
INDIRI4
CNSTI4 128
NEI4 $130
line 317
;317:			break;
ADDRGP4 $129
JUMPV
LABELV $130
line 319
;318:		}
;319:	}
LABELV $128
line 309
ADDRLP4 548
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $61
ARGP4
ADDRLP4 1080
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 548
ADDRLP4 1080
INDIRP4
ASGNP4
ADDRLP4 1080
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $127
LABELV $129
line 324
;320:
;321:	/*
;322:	 * A base mode needs at least two ordinary spawn points.
;323:	 */
;324:	if( numSpots < 2 ) {
ADDRLP4 536
INDIRI4
CNSTI4 2
GEI4 $132
line 325
;325:		return SelectSpawnPoint(
ADDRGP4 vec3_origin
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 1084
ADDRGP4 SelectSpawnPoint
CALLP4
ASGNP4
ADDRLP4 1084
INDIRP4
RETP4
ADDRGP4 $126
JUMPV
LABELV $132
line 336
;326:			vec3_origin,
;327:			origin,
;328:			angles
;329:		);
;330:	}
;331:
;332:	/*
;333:	 * Find the two spawn points with the greatest horizontal
;334:	 * distance between them.
;335:	 */
;336:	redBase = 0;
ADDRLP4 540
CNSTI4 0
ASGNI4
line 337
;337:	blueBase = 1;
ADDRLP4 544
CNSTI4 1
ASGNI4
line 338
;338:	bestDistance = -1.0f;
ADDRLP4 532
CNSTF4 3212836864
ASGNF4
line 340
;339:
;340:	for( i = 0; i < numSpots; i++ ) {
ADDRLP4 516
CNSTI4 0
ASGNI4
ADDRGP4 $137
JUMPV
LABELV $134
line 341
;341:		for( j = i + 1; j < numSpots; j++ ) {
ADDRLP4 512
ADDRLP4 516
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRGP4 $141
JUMPV
LABELV $138
line 342
;342:			dx = spots[i]->s.origin[0] -
ADDRLP4 1084
CNSTI4 2
ASGNI4
ADDRLP4 1088
CNSTI4 92
ASGNI4
ADDRLP4 520
ADDRLP4 516
INDIRI4
ADDRLP4 1084
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1088
INDIRI4
ADDP4
INDIRF4
ADDRLP4 512
INDIRI4
ADDRLP4 1084
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1088
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 345
;343:				spots[j]->s.origin[0];
;344:
;345:			dy = spots[i]->s.origin[1] -
ADDRLP4 1092
CNSTI4 2
ASGNI4
ADDRLP4 1096
CNSTI4 96
ASGNI4
ADDRLP4 524
ADDRLP4 516
INDIRI4
ADDRLP4 1092
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1096
INDIRI4
ADDP4
INDIRF4
ADDRLP4 512
INDIRI4
ADDRLP4 1092
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1096
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 348
;346:				spots[j]->s.origin[1];
;347:
;348:			distance = dx * dx + dy * dy;
ADDRLP4 528
ADDRLP4 520
INDIRF4
ADDRLP4 520
INDIRF4
MULF4
ADDRLP4 524
INDIRF4
ADDRLP4 524
INDIRF4
MULF4
ADDF4
ASGNF4
line 350
;349:
;350:			if( distance > bestDistance ) {
ADDRLP4 528
INDIRF4
ADDRLP4 532
INDIRF4
LEF4 $142
line 351
;351:				bestDistance = distance;
ADDRLP4 532
ADDRLP4 528
INDIRF4
ASGNF4
line 352
;352:				redBase = i;
ADDRLP4 540
ADDRLP4 516
INDIRI4
ASGNI4
line 353
;353:				blueBase = j;
ADDRLP4 544
ADDRLP4 512
INDIRI4
ASGNI4
line 354
;354:			}
LABELV $142
line 355
;355:		}
LABELV $139
line 341
ADDRLP4 512
ADDRLP4 512
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $141
ADDRLP4 512
INDIRI4
ADDRLP4 536
INDIRI4
LTI4 $138
line 356
;356:	}
LABELV $135
line 340
ADDRLP4 516
ADDRLP4 516
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $137
ADDRLP4 516
INDIRI4
ADDRLP4 536
INDIRI4
LTI4 $134
line 358
;357:
;358:	numCandidates = 0;
ADDRLP4 564
CNSTI4 0
ASGNI4
line 364
;359:
;360:	/*
;361:	 * First collect spawn points that belong to this team's
;362:	 * side and do not telefrag anybody.
;363:	 */
;364:	for( i = 0; i < numSpots; i++ ) {
ADDRLP4 516
CNSTI4 0
ASGNI4
ADDRGP4 $147
JUMPV
LABELV $144
line 365
;365:		dx = spots[i]->s.origin[0] -
ADDRLP4 1084
CNSTI4 2
ASGNI4
ADDRLP4 1088
CNSTI4 92
ASGNI4
ADDRLP4 520
ADDRLP4 516
INDIRI4
ADDRLP4 1084
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1088
INDIRI4
ADDP4
INDIRF4
ADDRLP4 540
INDIRI4
ADDRLP4 1084
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1088
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 367
;366:			spots[redBase]->s.origin[0];
;367:		dy = spots[i]->s.origin[1] -
ADDRLP4 1092
CNSTI4 2
ASGNI4
ADDRLP4 1096
CNSTI4 96
ASGNI4
ADDRLP4 524
ADDRLP4 516
INDIRI4
ADDRLP4 1092
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1096
INDIRI4
ADDP4
INDIRF4
ADDRLP4 540
INDIRI4
ADDRLP4 1092
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1096
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 369
;368:			spots[redBase]->s.origin[1];
;369:		redDistance = dx * dx + dy * dy;
ADDRLP4 556
ADDRLP4 520
INDIRF4
ADDRLP4 520
INDIRF4
MULF4
ADDRLP4 524
INDIRF4
ADDRLP4 524
INDIRF4
MULF4
ADDF4
ASGNF4
line 371
;370:
;371:		dx = spots[i]->s.origin[0] -
ADDRLP4 1108
CNSTI4 2
ASGNI4
ADDRLP4 1112
CNSTI4 92
ASGNI4
ADDRLP4 520
ADDRLP4 516
INDIRI4
ADDRLP4 1108
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1112
INDIRI4
ADDP4
INDIRF4
ADDRLP4 544
INDIRI4
ADDRLP4 1108
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1112
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 373
;372:			spots[blueBase]->s.origin[0];
;373:		dy = spots[i]->s.origin[1] -
ADDRLP4 1116
CNSTI4 2
ASGNI4
ADDRLP4 1120
CNSTI4 96
ASGNI4
ADDRLP4 524
ADDRLP4 516
INDIRI4
ADDRLP4 1116
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1120
INDIRI4
ADDP4
INDIRF4
ADDRLP4 544
INDIRI4
ADDRLP4 1116
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1120
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 375
;374:			spots[blueBase]->s.origin[1];
;375:		blueDistance = dx * dx + dy * dy;
ADDRLP4 560
ADDRLP4 520
INDIRF4
ADDRLP4 520
INDIRF4
MULF4
ADDRLP4 524
INDIRF4
ADDRLP4 524
INDIRF4
MULF4
ADDF4
ASGNF4
line 377
;376:
;377:		if( team == TEAM_RED ) {
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $148
line 378
;378:			belongsToTeam =
ADDRLP4 556
INDIRF4
ADDRLP4 560
INDIRF4
GTF4 $151
ADDRLP4 1132
CNSTI4 1
ASGNI4
ADDRGP4 $152
JUMPV
LABELV $151
ADDRLP4 1132
CNSTI4 0
ASGNI4
LABELV $152
ADDRLP4 552
ADDRLP4 1132
INDIRI4
ASGNI4
line 380
;379:				redDistance <= blueDistance;
;380:		}
ADDRGP4 $149
JUMPV
LABELV $148
line 381
;381:		else if( team == TEAM_BLUE ) {
ADDRFP4 0
INDIRI4
CNSTI4 2
NEI4 $153
line 382
;382:			belongsToTeam =
ADDRLP4 560
INDIRF4
ADDRLP4 556
INDIRF4
GEF4 $156
ADDRLP4 1132
CNSTI4 1
ASGNI4
ADDRGP4 $157
JUMPV
LABELV $156
ADDRLP4 1132
CNSTI4 0
ASGNI4
LABELV $157
ADDRLP4 552
ADDRLP4 1132
INDIRI4
ASGNI4
line 384
;383:				blueDistance < redDistance;
;384:		}
ADDRGP4 $154
JUMPV
LABELV $153
line 385
;385:		else {
line 386
;386:			belongsToTeam = qfalse;
ADDRLP4 552
CNSTI4 0
ASGNI4
line 387
;387:		}
LABELV $154
LABELV $149
line 389
;388:
;389:		if( !belongsToTeam ) {
ADDRLP4 552
INDIRI4
CNSTI4 0
NEI4 $158
line 390
;390:			continue;
ADDRGP4 $145
JUMPV
LABELV $158
line 393
;391:		}
;392:
;393:		if( SpotWouldTelefrag(spots[i]) ) {
ADDRLP4 516
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ARGP4
ADDRLP4 1132
ADDRGP4 SpotWouldTelefrag
CALLI4
ASGNI4
ADDRLP4 1132
INDIRI4
CNSTI4 0
EQI4 $160
line 394
;394:			continue;
ADDRGP4 $145
JUMPV
LABELV $160
line 397
;395:		}
;396:
;397:		candidates[numCandidates++] = spots[i];
ADDRLP4 1136
ADDRLP4 564
INDIRI4
ASGNI4
ADDRLP4 564
ADDRLP4 1136
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 1140
CNSTI4 2
ASGNI4
ADDRLP4 1136
INDIRI4
ADDRLP4 1140
INDIRI4
LSHI4
ADDRLP4 568
ADDP4
ADDRLP4 516
INDIRI4
ADDRLP4 1140
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ASGNP4
line 398
;398:	}
LABELV $145
line 364
ADDRLP4 516
ADDRLP4 516
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $147
ADDRLP4 516
INDIRI4
ADDRLP4 536
INDIRI4
LTI4 $144
line 404
;399:
;400:	/*
;401:	 * If every point on this side is occupied, allow an
;402:	 * occupied point. G_KillBox will resolve the collision.
;403:	 */
;404:	if( numCandidates == 0 ) {
ADDRLP4 564
INDIRI4
CNSTI4 0
NEI4 $162
line 405
;405:		for( i = 0; i < numSpots; i++ ) {
ADDRLP4 516
CNSTI4 0
ASGNI4
ADDRGP4 $167
JUMPV
LABELV $164
line 406
;406:			dx = spots[i]->s.origin[0] -
ADDRLP4 1084
CNSTI4 2
ASGNI4
ADDRLP4 1088
CNSTI4 92
ASGNI4
ADDRLP4 520
ADDRLP4 516
INDIRI4
ADDRLP4 1084
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1088
INDIRI4
ADDP4
INDIRF4
ADDRLP4 540
INDIRI4
ADDRLP4 1084
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1088
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 408
;407:				spots[redBase]->s.origin[0];
;408:			dy = spots[i]->s.origin[1] -
ADDRLP4 1092
CNSTI4 2
ASGNI4
ADDRLP4 1096
CNSTI4 96
ASGNI4
ADDRLP4 524
ADDRLP4 516
INDIRI4
ADDRLP4 1092
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1096
INDIRI4
ADDP4
INDIRF4
ADDRLP4 540
INDIRI4
ADDRLP4 1092
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1096
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 410
;409:				spots[redBase]->s.origin[1];
;410:			redDistance = dx * dx + dy * dy;
ADDRLP4 556
ADDRLP4 520
INDIRF4
ADDRLP4 520
INDIRF4
MULF4
ADDRLP4 524
INDIRF4
ADDRLP4 524
INDIRF4
MULF4
ADDF4
ASGNF4
line 412
;411:
;412:			dx = spots[i]->s.origin[0] -
ADDRLP4 1108
CNSTI4 2
ASGNI4
ADDRLP4 1112
CNSTI4 92
ASGNI4
ADDRLP4 520
ADDRLP4 516
INDIRI4
ADDRLP4 1108
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1112
INDIRI4
ADDP4
INDIRF4
ADDRLP4 544
INDIRI4
ADDRLP4 1108
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1112
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 414
;413:				spots[blueBase]->s.origin[0];
;414:			dy = spots[i]->s.origin[1] -
ADDRLP4 1116
CNSTI4 2
ASGNI4
ADDRLP4 1120
CNSTI4 96
ASGNI4
ADDRLP4 524
ADDRLP4 516
INDIRI4
ADDRLP4 1116
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1120
INDIRI4
ADDP4
INDIRF4
ADDRLP4 544
INDIRI4
ADDRLP4 1116
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ADDRLP4 1120
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 416
;415:				spots[blueBase]->s.origin[1];
;416:			blueDistance = dx * dx + dy * dy;
ADDRLP4 560
ADDRLP4 520
INDIRF4
ADDRLP4 520
INDIRF4
MULF4
ADDRLP4 524
INDIRF4
ADDRLP4 524
INDIRF4
MULF4
ADDF4
ASGNF4
line 418
;417:
;418:			if( team == TEAM_RED ) {
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $168
line 419
;419:				belongsToTeam =
ADDRLP4 556
INDIRF4
ADDRLP4 560
INDIRF4
GTF4 $171
ADDRLP4 1132
CNSTI4 1
ASGNI4
ADDRGP4 $172
JUMPV
LABELV $171
ADDRLP4 1132
CNSTI4 0
ASGNI4
LABELV $172
ADDRLP4 552
ADDRLP4 1132
INDIRI4
ASGNI4
line 421
;420:					redDistance <= blueDistance;
;421:			}
ADDRGP4 $169
JUMPV
LABELV $168
line 422
;422:			else if( team == TEAM_BLUE ) {
ADDRFP4 0
INDIRI4
CNSTI4 2
NEI4 $173
line 423
;423:				belongsToTeam =
ADDRLP4 560
INDIRF4
ADDRLP4 556
INDIRF4
GEF4 $176
ADDRLP4 1132
CNSTI4 1
ASGNI4
ADDRGP4 $177
JUMPV
LABELV $176
ADDRLP4 1132
CNSTI4 0
ASGNI4
LABELV $177
ADDRLP4 552
ADDRLP4 1132
INDIRI4
ASGNI4
line 425
;424:					blueDistance < redDistance;
;425:			}
ADDRGP4 $174
JUMPV
LABELV $173
line 426
;426:			else {
line 427
;427:				belongsToTeam = qfalse;
ADDRLP4 552
CNSTI4 0
ASGNI4
line 428
;428:			}
LABELV $174
LABELV $169
line 430
;429:
;430:			if( belongsToTeam ) {
ADDRLP4 552
INDIRI4
CNSTI4 0
EQI4 $178
line 431
;431:				candidates[numCandidates++] =
ADDRLP4 1132
ADDRLP4 564
INDIRI4
ASGNI4
ADDRLP4 564
ADDRLP4 1132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 1136
CNSTI4 2
ASGNI4
ADDRLP4 1132
INDIRI4
ADDRLP4 1136
INDIRI4
LSHI4
ADDRLP4 568
ADDP4
ADDRLP4 516
INDIRI4
ADDRLP4 1136
INDIRI4
LSHI4
ADDRLP4 0
ADDP4
INDIRP4
ASGNP4
line 433
;432:					spots[i];
;433:			}
LABELV $178
line 434
;434:		}
LABELV $165
line 405
ADDRLP4 516
ADDRLP4 516
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $167
ADDRLP4 516
INDIRI4
ADDRLP4 536
INDIRI4
LTI4 $164
line 435
;435:	}
LABELV $162
line 437
;436:
;437:	if( numCandidates == 0 ) {
ADDRLP4 564
INDIRI4
CNSTI4 0
NEI4 $180
line 438
;438:		return SelectSpawnPoint(
ADDRGP4 vec3_origin
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 1084
ADDRGP4 SelectSpawnPoint
CALLP4
ASGNP4
ADDRLP4 1084
INDIRP4
RETP4
ADDRGP4 $126
JUMPV
LABELV $180
line 445
;439:			vec3_origin,
;440:			origin,
;441:			angles
;442:		);
;443:	}
;444:
;445:	spot = candidates[rand() % numCandidates];
ADDRLP4 1084
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 548
ADDRLP4 1084
INDIRI4
ADDRLP4 564
INDIRI4
MODI4
CNSTI4 2
LSHI4
ADDRLP4 568
ADDP4
INDIRP4
ASGNP4
line 447
;446:
;447:	VectorCopy(spot->s.origin, origin);
ADDRFP4 4
INDIRP4
ADDRLP4 548
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 448
;448:	origin[2] += 9;
ADDRLP4 1088
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 1088
INDIRP4
ADDRLP4 1088
INDIRP4
INDIRF4
CNSTF4 1091567616
ADDF4
ASGNF4
line 449
;449:	VectorCopy(spot->s.angles, angles);
ADDRFP4 8
INDIRP4
ADDRLP4 548
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 451
;450:
;451:	return spot;
ADDRLP4 548
INDIRP4
RETP4
LABELV $126
endproc SelectBaseTeamSpawnPoint 1144 12
export SelectInitialSpawnPoint
proc SelectInitialSpawnPoint 20 12
line 462
;452:}
;453:
;454:/*
;455:===========
;456:SelectInitialSpawnPoint
;457:
;458:Try to find a spawn point marked 'initial', otherwise
;459:use normal spawn selection.
;460:============
;461:*/
;462:gentity_t *SelectInitialSpawnPoint( vec3_t origin, vec3_t angles ) {
line 465
;463:	gentity_t	*spot;
;464:
;465:	spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $184
JUMPV
LABELV $183
line 466
;466:	while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) {
line 467
;467:		if ( spot->spawnflags & 1 ) {
ADDRLP4 0
INDIRP4
CNSTI4 528
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $186
line 468
;468:			break;
ADDRGP4 $185
JUMPV
LABELV $186
line 470
;469:		}
;470:	}
LABELV $184
line 466
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $61
ARGP4
ADDRLP4 4
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $183
LABELV $185
line 472
;471:
;472:	if ( !spot || SpotWouldTelefrag( spot ) ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $190
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 SpotWouldTelefrag
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $188
LABELV $190
line 473
;473:		return SelectSpawnPoint( vec3_origin, origin, angles );
ADDRGP4 vec3_origin
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 SelectSpawnPoint
CALLP4
ASGNP4
ADDRLP4 16
INDIRP4
RETP4
ADDRGP4 $182
JUMPV
LABELV $188
line 476
;474:	}
;475:
;476:	VectorCopy (spot->s.origin, origin);
ADDRFP4 0
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 477
;477:	origin[2] += 9;
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRF4
CNSTF4 1091567616
ADDF4
ASGNF4
line 478
;478:	VectorCopy (spot->s.angles, angles);
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 480
;479:
;480:	return spot;
ADDRLP4 0
INDIRP4
RETP4
LABELV $182
endproc SelectInitialSpawnPoint 20 12
export SelectSpectatorSpawnPoint
proc SelectSpectatorSpawnPoint 0 0
line 489
;481:}
;482:
;483:/*
;484:===========
;485:SelectSpectatorSpawnPoint
;486:
;487:============
;488:*/
;489:gentity_t *SelectSpectatorSpawnPoint( vec3_t origin, vec3_t angles ) {
line 490
;490:	FindIntermissionPoint();
ADDRGP4 FindIntermissionPoint
CALLV
pop
line 492
;491:
;492:	VectorCopy( level.intermission_origin, origin );
ADDRFP4 0
INDIRP4
ADDRGP4 level+9144
INDIRB
ASGNB 12
line 493
;493:	VectorCopy( level.intermission_angle, angles );
ADDRFP4 4
INDIRP4
ADDRGP4 level+9156
INDIRB
ASGNB 12
line 495
;494:
;495:	return NULL;
CNSTP4 0
RETP4
LABELV $191
endproc SelectSpectatorSpawnPoint 0 0
export InitBodyQue
proc InitBodyQue 12 0
line 511
;496:}
;497:
;498:/*
;499:=======================================================================
;500:
;501:BODYQUE
;502:
;503:=======================================================================
;504:*/
;505:
;506:/*
;507:===============
;508:InitBodyQue
;509:===============
;510:*/
;511:void InitBodyQue (void) {
line 515
;512:	int		i;
;513:	gentity_t	*ent;
;514:
;515:	level.bodyQueIndex = 0;
ADDRGP4 level+9176
CNSTI4 0
ASGNI4
line 516
;516:	for (i=0; i<BODY_QUEUE_SIZE ; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $196
line 517
;517:		ent = G_Spawn();
ADDRLP4 8
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 518
;518:		ent->classname = "bodyque";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $200
ASGNP4
line 519
;519:		ent->neverFree = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 532
ADDP4
CNSTI4 1
ASGNI4
line 520
;520:		level.bodyQue[i] = ent;
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 level+9180
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 521
;521:	}
LABELV $197
line 516
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $196
line 522
;522:}
LABELV $194
endproc InitBodyQue 12 0
export BodySink
proc BodySink 4 4
line 531
;523:
;524:/*
;525:=============
;526:BodySink
;527:
;528:After sitting around for five seconds, fall into the ground and dissapear
;529:=============
;530:*/
;531:void BodySink( gentity_t *ent ) {
line 532
;532:	if ( level.time - ent->timestamp > 6500 ) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
SUBI4
CNSTI4 6500
LEI4 $203
line 534
;533:		// the body ques are never actually freed, they are just unlinked
;534:		trap_UnlinkEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 535
;535:		ent->physicsObject = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 564
ADDP4
CNSTI4 0
ASGNI4
line 536
;536:		return;	
ADDRGP4 $202
JUMPV
LABELV $203
line 538
;537:	}
;538:	ent->nextthink = level.time + 100;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 100
ADDI4
ASGNI4
line 539
;539:	ent->s.pos.trBase[2] -= 1;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRF4
CNSTF4 1065353216
SUBF4
ASGNF4
line 540
;540:}
LABELV $202
endproc BodySink 4 4
export CopyToBodyQue
proc CopyToBodyQue 48 8
line 550
;541:
;542:/*
;543:=============
;544:CopyToBodyQue
;545:
;546:A player is respawning, so make an entity that looks
;547:just like the existing corpse to leave behind.
;548:=============
;549:*/
;550:void CopyToBodyQue( gentity_t *ent ) {
line 558
;551:#ifdef MISSIONPACK
;552:	gentity_t	*e;
;553:	int i;
;554:#endif
;555:	gentity_t		*body;
;556:	int			contents;
;557:
;558:	trap_UnlinkEntity (ent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 561
;559:
;560:	// if client is in a nodrop area, don't leave the body
;561:	contents = trap_PointContents( ent->s.origin, -1 );
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 8
ADDRGP4 trap_PointContents
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 562
;562:	if ( contents & CONTENTS_NODROP ) {
ADDRLP4 4
INDIRI4
CVIU4 4
CNSTU4 2147483648
BANDU4
CNSTU4 0
EQU4 $208
line 563
;563:		return;
ADDRGP4 $207
JUMPV
LABELV $208
line 567
;564:	}
;565:
;566:	// grab a body que and cycle to the next one
;567:	body = level.bodyQue[ level.bodyQueIndex ];
ADDRLP4 0
ADDRGP4 level+9176
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 level+9180
ADDP4
INDIRP4
ASGNP4
line 568
;568:	level.bodyQueIndex = (level.bodyQueIndex + 1) % BODY_QUEUE_SIZE;
ADDRGP4 level+9176
ADDRGP4 level+9176
INDIRI4
CNSTI4 1
ADDI4
CNSTI4 8
MODI4
ASGNI4
line 570
;569:
;570:	trap_UnlinkEntity (body);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 572
;571:
;572:	body->s = ent->s;
ADDRLP4 0
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 208
line 573
;573:	body->s.eFlags = EF_DEAD;		// clear EF_TALK, etc
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 1
ASGNI4
line 592
;574:#ifdef MISSIONPACK
;575:	if ( ent->s.eFlags & EF_KAMIKAZE ) {
;576:		body->s.eFlags |= EF_KAMIKAZE;
;577:
;578:		// check if there is a kamikaze timer around for this owner
;579:		for (i = 0; i < MAX_GENTITIES; i++) {
;580:			e = &g_entities[i];
;581:			if (!e->inuse)
;582:				continue;
;583:			if (e->activator != ent)
;584:				continue;
;585:			if (strcmp(e->classname, "kamikaze timer"))
;586:				continue;
;587:			e->activator = body;
;588:			break;
;589:		}
;590:	}
;591:#endif
;592:	body->s.powerups = 0;	// clear powerups
ADDRLP4 0
INDIRP4
CNSTI4 188
ADDP4
CNSTI4 0
ASGNI4
line 593
;593:	body->s.loopSound = 0;	// clear lava burning
ADDRLP4 0
INDIRP4
CNSTI4 156
ADDP4
CNSTI4 0
ASGNI4
line 594
;594:	body->s.number = body - g_entities;
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ASGNI4
line 595
;595:	body->timestamp = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 640
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 596
;596:	body->physicsObject = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 564
ADDP4
CNSTI4 1
ASGNI4
line 597
;597:	body->physicsBounce = 0;		// don't bounce
ADDRLP4 0
INDIRP4
CNSTI4 568
ADDP4
CNSTF4 0
ASGNF4
line 598
;598:	if ( body->s.groundEntityNum == ENTITYNUM_NONE ) {
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
CNSTI4 1023
NEI4 $215
line 599
;599:		body->s.pos.trType = TR_GRAVITY;
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 5
ASGNI4
line 600
;600:		body->s.pos.trTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 601
;601:		VectorCopy( ent->client->ps.velocity, body->s.pos.trDelta );
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 32
ADDP4
INDIRB
ASGNB 12
line 602
;602:	} else {
ADDRGP4 $216
JUMPV
LABELV $215
line 603
;603:		body->s.pos.trType = TR_STATIONARY;
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 0
ASGNI4
line 604
;604:	}
LABELV $216
line 605
;605:	body->s.event = 0;
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
CNSTI4 0
ASGNI4
line 609
;606:
;607:	// change the animation to the last-frame only, so the sequence
;608:	// doesn't repeat anew for the body
;609:	switch ( body->s.legsAnim & ~ANIM_TOGGLEBIT ) {
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
CNSTI4 -129
BANDI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
LTI4 $218
ADDRLP4 16
INDIRI4
CNSTI4 5
GTI4 $218
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $224
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $224
address $221
address $221
address $222
address $222
address $223
address $223
code
LABELV $221
line 612
;610:	case BOTH_DEATH1:
;611:	case BOTH_DEAD1:
;612:		body->s.torsoAnim = body->s.legsAnim = BOTH_DEAD1;
ADDRLP4 28
CNSTI4 1
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
ADDRLP4 28
INDIRI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 200
ADDP4
ADDRLP4 28
INDIRI4
ASGNI4
line 613
;613:		break;
ADDRGP4 $219
JUMPV
LABELV $222
line 616
;614:	case BOTH_DEATH2:
;615:	case BOTH_DEAD2:
;616:		body->s.torsoAnim = body->s.legsAnim = BOTH_DEAD2;
ADDRLP4 36
CNSTI4 3
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
ADDRLP4 36
INDIRI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 200
ADDP4
ADDRLP4 36
INDIRI4
ASGNI4
line 617
;617:		break;
ADDRGP4 $219
JUMPV
LABELV $223
LABELV $218
line 621
;618:	case BOTH_DEATH3:
;619:	case BOTH_DEAD3:
;620:	default:
;621:		body->s.torsoAnim = body->s.legsAnim = BOTH_DEAD3;
ADDRLP4 44
CNSTI4 5
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
ADDRLP4 44
INDIRI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 200
ADDP4
ADDRLP4 44
INDIRI4
ASGNI4
line 622
;622:		break;
LABELV $219
line 625
;623:	}
;624:
;625:	body->r.svFlags = ent->r.svFlags;
ADDRLP4 24
CNSTI4 424
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 626
;626:	VectorCopy (ent->r.mins, body->r.mins);
ADDRLP4 28
CNSTI4 436
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRB
ASGNB 12
line 627
;627:	VectorCopy (ent->r.maxs, body->r.maxs);
ADDRLP4 32
CNSTI4 448
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRB
ASGNB 12
line 628
;628:	VectorCopy (ent->r.absmin, body->r.absmin);
ADDRLP4 36
CNSTI4 464
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
INDIRB
ASGNB 12
line 629
;629:	VectorCopy (ent->r.absmax, body->r.absmax);
ADDRLP4 40
CNSTI4 476
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRB
ASGNB 12
line 631
;630:
;631:	body->clipmask = CONTENTS_SOLID | CONTENTS_PLAYERCLIP;
ADDRLP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 65537
ASGNI4
line 632
;632:	body->r.contents = CONTENTS_CORPSE;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 67108864
ASGNI4
line 633
;633:	body->r.ownerNum = ent->s.number;
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 635
;634:
;635:	body->nextthink = level.time + 5000;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 5000
ADDI4
ASGNI4
line 636
;636:	body->think = BodySink;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 BodySink
ASGNP4
line 638
;637:
;638:	body->die = body_die;
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 body_die
ASGNP4
line 641
;639:
;640:	// don't take more damage if already gibbed
;641:	if ( ent->health <= GIB_HEALTH ) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 -40
GTI4 $226
line 642
;642:		body->takedamage = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 643
;643:	} else {
ADDRGP4 $227
JUMPV
LABELV $226
line 644
;644:		body->takedamage = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 645
;645:	}
LABELV $227
line 648
;646:
;647:
;648:	VectorCopy ( body->s.pos.trBase, body->r.currentOrigin );
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
line 649
;649:	trap_LinkEntity (body);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 650
;650:}
LABELV $207
endproc CopyToBodyQue 48 8
export SetClientViewAngle
proc SetClientViewAngle 16 0
line 661
;651:
;652://======================================================================
;653:
;654:
;655:/*
;656:==================
;657:SetClientViewAngle
;658:
;659:==================
;660:*/
;661:void SetClientViewAngle( gentity_t *ent, vec3_t angle ) {
line 665
;662:	int			i;
;663:
;664:	// set the delta angle
;665:	for (i=0 ; i<3 ; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $229
line 668
;666:		int		cmdAngle;
;667:
;668:		cmdAngle = ANGLE2SHORT(angle[i]);
ADDRLP4 4
CNSTF4 1199570944
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRF4
MULF4
CNSTF4 1135869952
DIVF4
CVFI4 4
CNSTI4 65535
BANDI4
ASGNI4
line 669
;669:		ent->client->ps.delta_angles[i] = cmdAngle - ent->client->pers.cmd.angles[i];
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 56
ADDP4
ADDP4
ADDRLP4 4
INDIRI4
ADDRLP4 8
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 476
ADDP4
ADDP4
INDIRI4
SUBI4
ASGNI4
line 670
;670:	}
LABELV $230
line 665
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $229
line 671
;671:	VectorCopy( angle, ent->s.angles );
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 672
;672:	VectorCopy (ent->s.angles, ent->client->ps.viewangles);
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 152
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 673
;673:}
LABELV $228
endproc SetClientViewAngle 16 0
export respawn
proc respawn 12 8
line 680
;674:
;675:/*
;676:================
;677:respawn
;678:================
;679:*/
;680:void respawn( gentity_t *ent ) {
line 683
;681:	gentity_t	*tent;
;682:
;683:	CopyToBodyQue (ent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CopyToBodyQue
CALLV
pop
line 684
;684:	ClientSpawn(ent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 ClientSpawn
CALLV
pop
line 687
;685:
;686:	// add a teleportation effect
;687:	tent = G_TempEntity( ent->client->ps.origin, EV_PLAYER_TELEPORT_IN );
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
ARGP4
CNSTI4 42
ARGI4
ADDRLP4 4
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 688
;688:	tent->s.clientNum = ent->s.clientNum;
ADDRLP4 8
CNSTI4 168
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 689
;689:}
LABELV $233
endproc respawn 12 8
export TeamCount
proc TeamCount 8 0
line 698
;690:
;691:/*
;692:================
;693:TeamCount
;694:
;695:Returns number of players on a team
;696:================
;697:*/
;698:team_t TeamCount( int ignoreClientNum, int team ) {
line 700
;699:	int		i;
;700:	int		count = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 702
;701:
;702:	for ( i = 0 ; i < level.maxclients ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $238
JUMPV
LABELV $235
line 703
;703:		if ( i == ignoreClientNum ) {
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRI4
NEI4 $240
line 704
;704:			continue;
ADDRGP4 $236
JUMPV
LABELV $240
line 706
;705:		}
;706:		if ( level.clients[i].pers.connected == CON_DISCONNECTED ) {
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 0
NEI4 $242
line 707
;707:			continue;
ADDRGP4 $236
JUMPV
LABELV $242
line 709
;708:		}
;709:		if ( level.clients[i].sess.sessionTeam == team ) {
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 616
ADDP4
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $244
line 710
;710:			count++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 711
;711:		}
LABELV $244
line 712
;712:	}
LABELV $236
line 702
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $238
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $235
line 714
;713:
;714:	return count;
ADDRLP4 4
INDIRI4
RETI4
LABELV $234
endproc TeamCount 8 0
export TeamLeader
proc TeamLeader 4 0
line 724
;715:}
;716:
;717:/*
;718:================
;719:TeamLeader
;720:
;721:Returns the client number of the team leader
;722:================
;723:*/
;724:int TeamLeader( int team ) {
line 727
;725:	int		i;
;726:
;727:	for ( i = 0 ; i < level.maxclients ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $250
JUMPV
LABELV $247
line 728
;728:		if ( level.clients[i].pers.connected == CON_DISCONNECTED ) {
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 0
NEI4 $252
line 729
;729:			continue;
ADDRGP4 $248
JUMPV
LABELV $252
line 731
;730:		}
;731:		if ( level.clients[i].sess.sessionTeam == team ) {
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 616
ADDP4
INDIRI4
ADDRFP4 0
INDIRI4
NEI4 $254
line 732
;732:			if ( level.clients[i].sess.teamLeader )
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 0
EQI4 $256
line 733
;733:				return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $246
JUMPV
LABELV $256
line 734
;734:		}
LABELV $254
line 735
;735:	}
LABELV $248
line 727
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $250
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $247
line 737
;736:
;737:	return -1;
CNSTI4 -1
RETI4
LABELV $246
endproc TeamLeader 4 0
export PickTeam
proc PickTeam 24 8
line 747
;738:}
;739:
;740:
;741:/*
;742:================
;743:PickTeam
;744:
;745:================
;746:*/
;747:team_t PickTeam( int ignoreClientNum ) {
line 750
;748:	int		counts[TEAM_NUM_TEAMS];
;749:
;750:	counts[TEAM_BLUE] = TeamCount( ignoreClientNum, TEAM_BLUE );
ADDRFP4 0
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRLP4 16
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 0+8
ADDRLP4 16
INDIRI4
ASGNI4
line 751
;751:	counts[TEAM_RED] = TeamCount( ignoreClientNum, TEAM_RED );
ADDRFP4 0
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 20
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 0+4
ADDRLP4 20
INDIRI4
ASGNI4
line 753
;752:
;753:	if ( counts[TEAM_BLUE] > counts[TEAM_RED] ) {
ADDRLP4 0+8
INDIRI4
ADDRLP4 0+4
INDIRI4
LEI4 $261
line 754
;754:		return TEAM_RED;
CNSTI4 1
RETI4
ADDRGP4 $258
JUMPV
LABELV $261
line 756
;755:	}
;756:	if ( counts[TEAM_RED] > counts[TEAM_BLUE] ) {
ADDRLP4 0+4
INDIRI4
ADDRLP4 0+8
INDIRI4
LEI4 $265
line 757
;757:		return TEAM_BLUE;
CNSTI4 2
RETI4
ADDRGP4 $258
JUMPV
LABELV $265
line 760
;758:	}
;759:	// equal team count, so join the team with the lowest score
;760:	if ( level.teamScores[TEAM_BLUE] > level.teamScores[TEAM_RED] ) {
ADDRGP4 level+44+8
INDIRI4
ADDRGP4 level+44+4
INDIRI4
LEI4 $269
line 761
;761:		return TEAM_RED;
CNSTI4 1
RETI4
ADDRGP4 $258
JUMPV
LABELV $269
line 763
;762:	}
;763:	return TEAM_BLUE;
CNSTI4 2
RETI4
LABELV $258
endproc PickTeam 24 8
proc ClientCleanName 40 12
line 791
;764:}
;765:
;766:/*
;767:===========
;768:ForceClientSkin
;769:
;770:Forces a client's skin (for teamplay)
;771:===========
;772:*/
;773:/*
;774:static void ForceClientSkin( gclient_t *client, char *model, const char *skin ) {
;775:	char *p;
;776:
;777:	if ((p = Q_strrchr(model, '/')) != 0) {
;778:		*p = 0;
;779:	}
;780:
;781:	Q_strcat(model, MAX_QPATH, "/");
;782:	Q_strcat(model, MAX_QPATH, skin);
;783:}
;784:*/
;785:
;786:/*
;787:===========
;788:ClientCheckName
;789:============
;790:*/
;791:static void ClientCleanName( const char *in, char *out, int outSize ) {
line 798
;792:	int		len, colorlessLen;
;793:	char	ch;
;794:	char	*p;
;795:	int		spaces;
;796:
;797:	//save room for trailing null byte
;798:	outSize--;
ADDRFP4 8
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 800
;799:
;800:	len = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 801
;801:	colorlessLen = 0;
ADDRLP4 16
CNSTI4 0
ASGNI4
line 802
;802:	p = out;
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
line 803
;803:	*p = 0;
ADDRLP4 12
INDIRP4
CNSTI1 0
ASGNI1
line 804
;804:	spaces = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $277
JUMPV
LABELV $276
line 806
;805:
;806:	while( 1 ) {
line 807
;807:		ch = *in++;
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
ADDRLP4 20
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 20
INDIRP4
INDIRI1
ASGNI1
line 808
;808:		if( !ch ) {
ADDRLP4 0
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $279
line 809
;809:			break;
ADDRGP4 $278
JUMPV
LABELV $279
line 813
;810:		}
;811:
;812:		// don't allow leading spaces
;813:		if( !*p && ch == ' ' ) {
ADDRLP4 12
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $281
ADDRLP4 0
INDIRI1
CVII4 1
CNSTI4 32
NEI4 $281
line 814
;814:			continue;
ADDRGP4 $277
JUMPV
LABELV $281
line 818
;815:		}
;816:
;817:		// check colors
;818:		if( ch == Q_COLOR_ESCAPE ) {
ADDRLP4 0
INDIRI1
CVII4 1
CNSTI4 94
NEI4 $283
line 820
;819:			// solo trailing carat is not a color prefix
;820:			if( !*in ) {
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $285
line 821
;821:				break;
ADDRGP4 $278
JUMPV
LABELV $285
line 825
;822:			}
;823:
;824:			// don't allow black in a name, period
;825:			if( ColorIndex(*in) == 0 ) {
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
CNSTI4 7
BANDI4
CNSTI4 0
NEI4 $287
line 826
;826:				in++;
ADDRFP4 0
ADDRFP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 827
;827:				continue;
ADDRGP4 $277
JUMPV
LABELV $287
line 831
;828:			}
;829:
;830:			// make sure room in dest for both chars
;831:			if( len > outSize - 2 ) {
ADDRLP4 4
INDIRI4
ADDRFP4 8
INDIRI4
CNSTI4 2
SUBI4
LEI4 $289
line 832
;832:				break;
ADDRGP4 $278
JUMPV
LABELV $289
line 835
;833:			}
;834:
;835:			*out++ = ch;
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRFP4 4
ADDRLP4 24
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 0
INDIRI1
ASGNI1
line 836
;836:			*out++ = *in++;
ADDRLP4 28
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRFP4 4
ADDRLP4 28
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
ASGNP4
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
ADDRLP4 32
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 32
INDIRP4
INDIRI1
ASGNI1
line 837
;837:			len += 2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 2
ADDI4
ASGNI4
line 838
;838:			continue;
ADDRGP4 $277
JUMPV
LABELV $283
line 842
;839:		}
;840:
;841:		// don't allow too many consecutive spaces
;842:		if( ch == ' ' ) {
ADDRLP4 0
INDIRI1
CVII4 1
CNSTI4 32
NEI4 $291
line 843
;843:			spaces++;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 844
;844:			if( spaces > 3 ) {
ADDRLP4 8
INDIRI4
CNSTI4 3
LEI4 $292
line 845
;845:				continue;
ADDRGP4 $277
JUMPV
line 847
;846:			}
;847:		}
LABELV $291
line 848
;848:		else {
line 849
;849:			spaces = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 850
;850:		}
LABELV $292
line 852
;851:
;852:		if( len > outSize - 1 ) {
ADDRLP4 4
INDIRI4
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
LEI4 $295
line 853
;853:			break;
ADDRGP4 $278
JUMPV
LABELV $295
line 856
;854:		}
;855:
;856:		*out++ = ch;
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRFP4 4
ADDRLP4 24
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 0
INDIRI1
ASGNI1
line 857
;857:		colorlessLen++;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 858
;858:		len++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 859
;859:	}
LABELV $277
line 806
ADDRGP4 $276
JUMPV
LABELV $278
line 860
;860:	*out = 0;
ADDRFP4 4
INDIRP4
CNSTI1 0
ASGNI1
line 863
;861:
;862:	// don't allow empty names
;863:	if( *p == 0 || colorlessLen == 0 ) {
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 12
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 20
INDIRI4
EQI4 $299
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
NEI4 $297
LABELV $299
line 864
;864:		Q_strncpyz( p, "UnnamedPlayer", outSize );
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 $300
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 865
;865:	}
LABELV $297
line 866
;866:}
LABELV $275
endproc ClientCleanName 40 12
export ClientUserinfoChanged
proc ClientUserinfoChanged 6376 56
line 880
;867:
;868:
;869:/*
;870:===========
;871:ClientUserInfoChanged
;872:
;873:Called from ClientConnect when the player first connects and
;874:directly by the server system when the player updates a userinfo variable.
;875:
;876:The game can override any of the settings and call trap_SetUserinfo
;877:if desired.
;878:============
;879:*/
;880:void ClientUserinfoChanged( int clientNum ) {
line 896
;881:	gentity_t	*ent;
;882:	int		teamTask;
;883:	int		teamLeader;
;884:	int		team;
;885:	char		*s;
;886:	char		model[MAX_QPATH];
;887:	char		headModel[MAX_QPATH];
;888:	char		oldname[MAX_STRING_CHARS];
;889:	gclient_t	*client;
;890:	char		c1[MAX_INFO_STRING];
;891:	char		c2[MAX_INFO_STRING];
;892:	char		redTeam[MAX_INFO_STRING];
;893:	char		blueTeam[MAX_INFO_STRING];
;894:	char		userinfo[MAX_INFO_STRING];
;895:
;896:	ent = g_entities + clientNum;
ADDRLP4 1032
CNSTI4 808
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 897
;897:	client = ent->client;
ADDRLP4 0
ADDRLP4 1032
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 899
;898:
;899:	trap_GetUserinfo(
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetUserinfo
CALLV
pop
line 906
;900:		clientNum,
;901:		userinfo,
;902:		sizeof( userinfo )
;903:	);
;904:
;905:	// global health setting for players and bots
;906:	client->pers.maxHealth = (int)Com_Clamp(
CNSTF4 1112014848
ARGF4
CNSTF4 1125515264
ARGF4
ADDRGP4 g_playerHealth+12
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 6296
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 548
ADDP4
ADDRLP4 6296
INDIRF4
CVFI4 4
ASGNI4
line 912
;907:		50,
;908:		150,
;909:		g_playerHealth.integer
;910:	);
;911:
;912:	client->ps.stats[STAT_MAX_HEALTH] =
ADDRLP4 0
INDIRP4
CNSTI4 208
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ASGNI4
line 916
;913:		client->pers.maxHealth;
;914:
;915:	// check for malformed or illegal info strings
;916:	if( !Info_Validate( userinfo ) ) {
ADDRLP4 4
ARGP4
ADDRLP4 6304
ADDRGP4 Info_Validate
CALLI4
ASGNI4
ADDRLP4 6304
INDIRI4
CNSTI4 0
NEI4 $303
line 917
;917:		strcpy( userinfo, "\\name\\badinfo" );
ADDRLP4 4
ARGP4
ADDRGP4 $305
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 918
;918:	}
LABELV $303
line 921
;919:
;920:	// check for local client
;921:	s = Info_ValueForKey( userinfo, "ip" );
ADDRLP4 4
ARGP4
ADDRGP4 $306
ARGP4
ADDRLP4 6308
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1028
ADDRLP4 6308
INDIRP4
ASGNP4
line 922
;922:	if ( !strcmp( s, "localhost" ) ) {
ADDRLP4 1028
INDIRP4
ARGP4
ADDRGP4 $309
ARGP4
ADDRLP4 6312
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 6312
INDIRI4
CNSTI4 0
NEI4 $307
line 923
;923:		client->pers.localClient = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 496
ADDP4
CNSTI4 1
ASGNI4
line 924
;924:	}
LABELV $307
line 927
;925:
;926:	// check the item prediction
;927:	s = Info_ValueForKey( userinfo, "cg_predictItems" );
ADDRLP4 4
ARGP4
ADDRGP4 $310
ARGP4
ADDRLP4 6316
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1028
ADDRLP4 6316
INDIRP4
ASGNP4
line 928
;928:	if ( !atoi( s ) ) {
ADDRLP4 1028
INDIRP4
ARGP4
ADDRLP4 6320
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 6320
INDIRI4
CNSTI4 0
NEI4 $311
line 929
;929:		client->pers.predictItemPickup = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 504
ADDP4
CNSTI4 0
ASGNI4
line 930
;930:	} else {
ADDRGP4 $312
JUMPV
LABELV $311
line 931
;931:		client->pers.predictItemPickup = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 504
ADDP4
CNSTI4 1
ASGNI4
line 932
;932:	}
LABELV $312
line 935
;933:
;934:	// set name
;935:	Q_strncpyz ( oldname, client->pers.netname, sizeof( oldname ) );
ADDRLP4 1164
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 936
;936:	s = Info_ValueForKey (userinfo, "name");
ADDRLP4 4
ARGP4
ADDRGP4 $313
ARGP4
ADDRLP4 6324
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1028
ADDRLP4 6324
INDIRP4
ASGNP4
line 937
;937:	ClientCleanName( s, client->pers.netname, sizeof(client->pers.netname) );
ADDRLP4 1028
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
CNSTI4 36
ARGI4
ADDRGP4 ClientCleanName
CALLV
pop
line 939
;938:
;939:	if ( client->sess.sessionTeam == TEAM_SPECTATOR ) {
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $314
line 940
;940:		if ( client->sess.spectatorState == SPECTATOR_SCOREBOARD ) {
ADDRLP4 0
INDIRP4
CNSTI4 624
ADDP4
INDIRI4
CNSTI4 3
NEI4 $316
line 941
;941:			Q_strncpyz( client->pers.netname, "scoreboard", sizeof(client->pers.netname) );
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRGP4 $318
ARGP4
CNSTI4 36
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 942
;942:		}
LABELV $316
line 943
;943:	}
LABELV $314
line 945
;944:
;945:	if ( client->pers.connected == CON_CONNECTED ) {
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $319
line 946
;946:		if ( strcmp( oldname, client->pers.netname ) ) {
ADDRLP4 1164
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 6328
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 6328
INDIRI4
CNSTI4 0
EQI4 $321
line 947
;947:			trap_SendServerCommand( -1, va("print \"%s" S_COLOR_WHITE " renamed to %s\n\"", oldname, 
ADDRGP4 $323
ARGP4
ADDRLP4 1164
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 6332
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 6332
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 949
;948:				client->pers.netname) );
;949:		}
LABELV $321
line 950
;950:	}
LABELV $319
line 973
;951:
;952:	// set max health
;953:/*#ifdef MISSIONPACK
;954:	if (client->ps.powerups[PW_GUARD]) {
;955:		client->pers.maxHealth = 200;
;956:	} else {
;957:		health = atoi( Info_ValueForKey( userinfo, "handicap" ) );
;958:		client->pers.maxHealth = health;
;959:		if ( client->pers.maxHealth < 1 || client->pers.maxHealth > 100 ) {
;960:			client->pers.maxHealth = 100;
;961:		}
;962:	}
;963:#else
;964:	health = atoi( Info_ValueForKey( userinfo, "handicap" ) );
;965:	client->pers.maxHealth = health;
;966:	if ( client->pers.maxHealth < 1 || client->pers.maxHealth > 100 ) {
;967:		client->pers.maxHealth = 100;
;968:	}
;969:#endif
;970:	client->ps.stats[STAT_MAX_HEALTH] = client->pers.maxHealth;
;971:*/
;972:	// set model
;973:	if( g_gametype.integer >= GT_TEAM ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
LTI4 $324
line 974
;974:		Q_strncpyz( model, Info_ValueForKey (userinfo, "team_model"), sizeof( model ) );
ADDRLP4 4
ARGP4
ADDRGP4 $327
ARGP4
ADDRLP4 6328
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1036
ARGP4
ADDRLP4 6328
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 975
;975:		Q_strncpyz( headModel, Info_ValueForKey (userinfo, "team_headmodel"), sizeof( headModel ) );
ADDRLP4 4
ARGP4
ADDRGP4 $328
ARGP4
ADDRLP4 6332
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1100
ARGP4
ADDRLP4 6332
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 976
;976:	} else {
ADDRGP4 $325
JUMPV
LABELV $324
line 977
;977:		Q_strncpyz( model, Info_ValueForKey (userinfo, "model"), sizeof( model ) );
ADDRLP4 4
ARGP4
ADDRGP4 $329
ARGP4
ADDRLP4 6328
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1036
ARGP4
ADDRLP4 6328
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 978
;978:		Q_strncpyz( headModel, Info_ValueForKey (userinfo, "headmodel"), sizeof( headModel ) );
ADDRLP4 4
ARGP4
ADDRGP4 $330
ARGP4
ADDRLP4 6332
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1100
ARGP4
ADDRLP4 6332
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 979
;979:	}
LABELV $325
line 982
;980:
;981:	// bots set their team a few frames later
;982:	if (g_gametype.integer >= GT_TEAM && g_entities[clientNum].r.svFlags & SVF_BOT) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
LTI4 $331
CNSTI4 808
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 g_entities+208+216
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $331
line 983
;983:		s = Info_ValueForKey( userinfo, "team" );
ADDRLP4 4
ARGP4
ADDRGP4 $336
ARGP4
ADDRLP4 6328
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1028
ADDRLP4 6328
INDIRP4
ASGNP4
line 984
;984:		if ( !Q_stricmp( s, "red" ) || !Q_stricmp( s, "r" ) ) {
ADDRLP4 1028
INDIRP4
ARGP4
ADDRGP4 $339
ARGP4
ADDRLP4 6332
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 6332
INDIRI4
CNSTI4 0
EQI4 $341
ADDRLP4 1028
INDIRP4
ARGP4
ADDRGP4 $340
ARGP4
ADDRLP4 6336
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 6336
INDIRI4
CNSTI4 0
NEI4 $337
LABELV $341
line 985
;985:			team = TEAM_RED;
ADDRLP4 4244
CNSTI4 1
ASGNI4
line 986
;986:		} else if ( !Q_stricmp( s, "blue" ) || !Q_stricmp( s, "b" ) ) {
ADDRGP4 $332
JUMPV
LABELV $337
ADDRLP4 1028
INDIRP4
ARGP4
ADDRGP4 $344
ARGP4
ADDRLP4 6340
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 6340
INDIRI4
CNSTI4 0
EQI4 $346
ADDRLP4 1028
INDIRP4
ARGP4
ADDRGP4 $345
ARGP4
ADDRLP4 6344
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 6344
INDIRI4
CNSTI4 0
NEI4 $342
LABELV $346
line 987
;987:			team = TEAM_BLUE;
ADDRLP4 4244
CNSTI4 2
ASGNI4
line 988
;988:		} else {
ADDRGP4 $332
JUMPV
LABELV $342
line 990
;989:			// pick the team with the least number of players
;990:			team = PickTeam( clientNum );
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 6348
ADDRGP4 PickTeam
CALLI4
ASGNI4
ADDRLP4 4244
ADDRLP4 6348
INDIRI4
ASGNI4
line 991
;991:		}
line 992
;992:	}
ADDRGP4 $332
JUMPV
LABELV $331
line 993
;993:	else {
line 994
;994:		team = client->sess.sessionTeam;
ADDRLP4 4244
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ASGNI4
line 995
;995:	}
LABELV $332
line 1031
;996:
;997:/*	NOTE: all client side now
;998:
;999:	// team
;1000:	switch( team ) {
;1001:	case TEAM_RED:
;1002:		ForceClientSkin(client, model, "red");
;1003://		ForceClientSkin(client, headModel, "red");
;1004:		break;
;1005:	case TEAM_BLUE:
;1006:		ForceClientSkin(client, model, "blue");
;1007://		ForceClientSkin(client, headModel, "blue");
;1008:		break;
;1009:	}
;1010:	// don't ever use a default skin in teamplay, it would just waste memory
;1011:	// however bots will always join a team but they spawn in as spectator
;1012:	if ( g_gametype.integer >= GT_TEAM && team == TEAM_SPECTATOR) {
;1013:		ForceClientSkin(client, model, "red");
;1014://		ForceClientSkin(client, headModel, "red");
;1015:	}
;1016:*/
;1017:
;1018:#ifdef MISSIONPACK
;1019:	if (g_gametype.integer >= GT_TEAM) {
;1020:		client->pers.teamInfo = qtrue;
;1021:	} else {
;1022:		s = Info_ValueForKey( userinfo, "teamoverlay" );
;1023:		if ( ! *s || atoi( s ) != 0 ) {
;1024:			client->pers.teamInfo = qtrue;
;1025:		} else {
;1026:			client->pers.teamInfo = qfalse;
;1027:		}
;1028:	}
;1029:#else
;1030:	// teamInfo
;1031:	s = Info_ValueForKey( userinfo, "teamoverlay" );
ADDRLP4 4
ARGP4
ADDRGP4 $347
ARGP4
ADDRLP4 6328
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1028
ADDRLP4 6328
INDIRP4
ASGNP4
line 1032
;1032:	if ( ! *s || atoi( s ) != 0 ) {
ADDRLP4 1028
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $350
ADDRLP4 1028
INDIRP4
ARGP4
ADDRLP4 6336
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 6336
INDIRI4
CNSTI4 0
EQI4 $348
LABELV $350
line 1033
;1033:		client->pers.teamInfo = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 612
ADDP4
CNSTI4 1
ASGNI4
line 1034
;1034:	} else {
ADDRGP4 $349
JUMPV
LABELV $348
line 1035
;1035:		client->pers.teamInfo = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 612
ADDP4
CNSTI4 0
ASGNI4
line 1036
;1036:	}
LABELV $349
line 1049
;1037:#endif
;1038:	/*
;1039:	s = Info_ValueForKey( userinfo, "cg_pmove_fixed" );
;1040:	if ( !*s || atoi( s ) == 0 ) {
;1041:		client->pers.pmoveFixed = qfalse;
;1042:	}
;1043:	else {
;1044:		client->pers.pmoveFixed = qtrue;
;1045:	}
;1046:	*/
;1047:
;1048:	// team task (0 = none, 1 = offence, 2 = defence)
;1049:	teamTask = atoi(Info_ValueForKey(userinfo, "teamtask"));
ADDRLP4 4
ARGP4
ADDRGP4 $351
ARGP4
ADDRLP4 6340
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 6340
INDIRP4
ARGP4
ADDRLP4 6344
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 2188
ADDRLP4 6344
INDIRI4
ASGNI4
line 1051
;1050:	// team Leader (1 = leader, 0 is normal player)
;1051:	teamLeader = client->sess.teamLeader;
ADDRLP4 2192
ADDRLP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
ASGNI4
line 1054
;1052:
;1053:	// colors
;1054:	strcpy(c1, Info_ValueForKey( userinfo, "color1" ));
ADDRLP4 4
ARGP4
ADDRGP4 $352
ARGP4
ADDRLP4 6348
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 2196
ARGP4
ADDRLP4 6348
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1055
;1055:	strcpy(c2, Info_ValueForKey( userinfo, "color2" ));
ADDRLP4 4
ARGP4
ADDRGP4 $353
ARGP4
ADDRLP4 6352
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 3220
ARGP4
ADDRLP4 6352
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1057
;1056:
;1057:	strcpy(redTeam, Info_ValueForKey( userinfo, "g_redteam" ));
ADDRLP4 4
ARGP4
ADDRGP4 $354
ARGP4
ADDRLP4 6356
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 4248
ARGP4
ADDRLP4 6356
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1058
;1058:	strcpy(blueTeam, Info_ValueForKey( userinfo, "g_blueteam" ));
ADDRLP4 4
ARGP4
ADDRGP4 $355
ARGP4
ADDRLP4 6360
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 5272
ARGP4
ADDRLP4 6360
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1062
;1059:
;1060:	// send over a subset of the userinfo keys so other clients can
;1061:	// print scoreboards, display models, and play custom sounds
;1062:	if ( ent->r.svFlags & SVF_BOT ) {
ADDRLP4 1032
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $356
line 1063
;1063:		s = va("n\\%s\\t\\%i\\model\\%s\\hmodel\\%s\\c1\\%s\\c2\\%s\\hc\\%i\\w\\%i\\l\\%i\\skill\\%s\\tt\\%d\\tl\\%d",
ADDRLP4 4
ARGP4
ADDRGP4 $359
ARGP4
ADDRLP4 6364
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRGP4 $358
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 4244
INDIRI4
ARGI4
ADDRLP4 1036
ARGP4
ADDRLP4 1100
ARGP4
ADDRLP4 2196
ARGP4
ADDRLP4 3220
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 632
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
ARGI4
ADDRLP4 6364
INDIRP4
ARGP4
ADDRLP4 2188
INDIRI4
ARGI4
ADDRLP4 2192
INDIRI4
ARGI4
ADDRLP4 6372
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 1028
ADDRLP4 6372
INDIRP4
ASGNP4
line 1067
;1064:			client->pers.netname, team, model, headModel, c1, c2, 
;1065:			client->pers.maxHealth, client->sess.wins, client->sess.losses,
;1066:			Info_ValueForKey( userinfo, "skill" ), teamTask, teamLeader );
;1067:	} else {
ADDRGP4 $357
JUMPV
LABELV $356
line 1068
;1068:		s = va("n\\%s\\t\\%i\\model\\%s\\hmodel\\%s\\g_redteam\\%s\\g_blueteam\\%s\\c1\\%s\\c2\\%s\\hc\\%i\\w\\%i\\l\\%i\\tt\\%d\\tl\\%d",
ADDRGP4 $360
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ARGI4
ADDRLP4 1036
ARGP4
ADDRLP4 1100
ARGP4
ADDRLP4 4248
ARGP4
ADDRLP4 5272
ARGP4
ADDRLP4 2196
ARGP4
ADDRLP4 3220
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 632
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
ARGI4
ADDRLP4 2188
INDIRI4
ARGI4
ADDRLP4 2192
INDIRI4
ARGI4
ADDRLP4 6368
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 1028
ADDRLP4 6368
INDIRP4
ASGNP4
line 1071
;1069:			client->pers.netname, client->sess.sessionTeam, model, headModel, redTeam, blueTeam, c1, c2, 
;1070:			client->pers.maxHealth, client->sess.wins, client->sess.losses, teamTask, teamLeader);
;1071:	}
LABELV $357
line 1073
;1072:
;1073:	trap_SetConfigstring( CS_PLAYERS+clientNum, s );
ADDRFP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 1028
INDIRP4
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1076
;1074:
;1075:	// this is not the userinfo, more like the configstring actually
;1076:	G_LogPrintf( "ClientUserinfoChanged: %i %s\n", clientNum, s );
ADDRGP4 $361
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 1028
INDIRP4
ARGP4
ADDRGP4 G_LogPrintf
CALLV
pop
line 1077
;1077:}
LABELV $301
endproc ClientUserinfoChanged 6376 56
export ClientConnect
proc ClientConnect 1064 12
line 1100
;1078:
;1079:
;1080:/*
;1081:===========
;1082:ClientConnect
;1083:
;1084:Called when a player begins connecting to the server.
;1085:Called again for every map change or tournement restart.
;1086:
;1087:The session information will be valid after exit.
;1088:
;1089:Return NULL if the client should be allowed, otherwise return
;1090:a string with the reason for denial.
;1091:
;1092:Otherwise, the client will be sent the current gamestate
;1093:and will eventually get to ClientBegin.
;1094:
;1095:firstTime will be qtrue the very first time a client connects
;1096:to the server machine, but qfalse on map changes and tournement
;1097:restarts.
;1098:============
;1099:*/
;1100:char *ClientConnect( int clientNum, qboolean firstTime, qboolean isBot ) {
line 1107
;1101:	char		*value;
;1102://	char		*areabits;
;1103:	gclient_t	*client;
;1104:	char		userinfo[MAX_INFO_STRING];
;1105:	gentity_t	*ent;
;1106:
;1107:	ent = &g_entities[ clientNum ];
ADDRLP4 4
CNSTI4 808
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1109
;1108:
;1109:	trap_GetUserinfo( clientNum, userinfo, sizeof( userinfo ) );
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetUserinfo
CALLV
pop
line 1115
;1110:
;1111: 	// IP filtering
;1112: 	// https://zerowing.idsoftware.com/bugzilla/show_bug.cgi?id=500
;1113: 	// recommanding PB based IP / GUID banning, the builtin system is pretty limited
;1114: 	// check to see if they are on the banned IP list
;1115:	value = Info_ValueForKey (userinfo, "ip");
ADDRLP4 12
ARGP4
ADDRGP4 $306
ARGP4
ADDRLP4 1036
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 1036
INDIRP4
ASGNP4
line 1116
;1116:	if ( G_FilterPacket( value ) ) {
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 1040
ADDRGP4 G_FilterPacket
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 0
EQI4 $363
line 1117
;1117:		return "You are banned from this server.";
ADDRGP4 $365
RETP4
ADDRGP4 $362
JUMPV
LABELV $363
line 1123
;1118:	}
;1119:
;1120:  // we don't check password for bots and local client
;1121:  // NOTE: local client <-> "ip" "localhost"
;1122:  //   this means this client is not running in our current process
;1123:	if ( !( ent->r.svFlags & SVF_BOT ) && (strcmp(value, "localhost") != 0)) {
ADDRLP4 4
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
NEI4 $366
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $309
ARGP4
ADDRLP4 1044
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 1044
INDIRI4
CNSTI4 0
EQI4 $366
line 1125
;1124:		// check for a password
;1125:		value = Info_ValueForKey (userinfo, "password");
ADDRLP4 12
ARGP4
ADDRGP4 $368
ARGP4
ADDRLP4 1048
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 1048
INDIRP4
ASGNP4
line 1126
;1126:		if ( g_password.string[0] && Q_stricmp( g_password.string, "none" ) &&
ADDRGP4 g_password+16
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $369
ADDRGP4 g_password+16
ARGP4
ADDRGP4 $373
ARGP4
ADDRLP4 1052
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1052
INDIRI4
CNSTI4 0
EQI4 $369
ADDRGP4 g_password+16
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 1056
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 1056
INDIRI4
CNSTI4 0
EQI4 $369
line 1127
;1127:			strcmp( g_password.string, value) != 0) {
line 1128
;1128:			return "Invalid password";
ADDRGP4 $375
RETP4
ADDRGP4 $362
JUMPV
LABELV $369
line 1130
;1129:		}
;1130:	}
LABELV $366
line 1133
;1131:
;1132:	// they can connect
;1133:	ent->client = level.clients + clientNum;
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
CNSTI4 780
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 1134
;1134:	client = ent->client;
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 1138
;1135:
;1136://	areabits = client->areabits;
;1137:
;1138:	memset( client, 0, sizeof(*client) );
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 780
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1140
;1139:
;1140:	client->pers.connected = CON_CONNECTING;
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
CNSTI4 1
ASGNI4
line 1143
;1141:
;1142:	// read or initialize the session data
;1143:	if ( firstTime || level.newSession ) {
ADDRLP4 1048
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 1048
INDIRI4
NEI4 $379
ADDRGP4 level+64
INDIRI4
ADDRLP4 1048
INDIRI4
EQI4 $376
LABELV $379
line 1144
;1144:		G_InitSessionData( client, userinfo );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 G_InitSessionData
CALLV
pop
line 1145
;1145:	}
LABELV $376
line 1146
;1146:	G_ReadSessionData( client );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_ReadSessionData
CALLV
pop
line 1148
;1147:
;1148:	if( isBot ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
EQI4 $380
line 1149
;1149:		ent->r.svFlags |= SVF_BOT;
ADDRLP4 1052
ADDRLP4 4
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 1052
INDIRP4
ADDRLP4 1052
INDIRP4
INDIRI4
CNSTI4 8
BORI4
ASGNI4
line 1150
;1150:		ent->inuse = qtrue;
ADDRLP4 4
INDIRP4
CNSTI4 520
ADDP4
CNSTI4 1
ASGNI4
line 1151
;1151:		if( !G_BotConnect( clientNum, !firstTime ) ) {
ADDRFP4 0
INDIRI4
ARGI4
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $385
ADDRLP4 1056
CNSTI4 1
ASGNI4
ADDRGP4 $386
JUMPV
LABELV $385
ADDRLP4 1056
CNSTI4 0
ASGNI4
LABELV $386
ADDRLP4 1056
INDIRI4
ARGI4
ADDRLP4 1060
ADDRGP4 G_BotConnect
CALLI4
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
NEI4 $382
line 1152
;1152:			return "BotConnectfailed";
ADDRGP4 $387
RETP4
ADDRGP4 $362
JUMPV
LABELV $382
line 1154
;1153:		}
;1154:	}
LABELV $380
line 1157
;1155:
;1156:	// get and distribute relevent paramters
;1157:	G_LogPrintf( "ClientConnect: %i\n", clientNum );
ADDRGP4 $388
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 G_LogPrintf
CALLV
pop
line 1158
;1158:	ClientUserinfoChanged( clientNum );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 ClientUserinfoChanged
CALLV
pop
line 1161
;1159:
;1160:	// don't do the "xxx connected" messages if they were caried over from previous level
;1161:	if ( firstTime ) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $389
line 1162
;1162:		trap_SendServerCommand( -1, va("print \"%s" S_COLOR_WHITE " connected\n\"", client->pers.netname) );
ADDRGP4 $391
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 1052
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 1052
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1163
;1163:	}
LABELV $389
line 1165
;1164:
;1165:	if ( g_gametype.integer >= GT_TEAM &&
ADDRLP4 1052
CNSTI4 3
ASGNI4
ADDRGP4 g_gametype+12
INDIRI4
ADDRLP4 1052
INDIRI4
LTI4 $392
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ADDRLP4 1052
INDIRI4
EQI4 $392
line 1166
;1166:		client->sess.sessionTeam != TEAM_SPECTATOR ) {
line 1167
;1167:		BroadcastTeamChange( client, -1 );
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 BroadcastTeamChange
CALLV
pop
line 1168
;1168:	}
LABELV $392
line 1171
;1169:
;1170:	// count current clients and rank for scoreboard
;1171:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 1178
;1172:
;1173:	// for statistics
;1174://	client->areabits = areabits;
;1175://	if ( !client->areabits )
;1176://		client->areabits = G_Alloc( (trap_AAS_PointReachabilityAreaIndex( NULL ) + 7) / 8 );
;1177:
;1178:	return NULL;
CNSTP4 0
RETP4
LABELV $362
endproc ClientConnect 1064 12
export ClientBegin
proc ClientBegin 28 12
line 1190
;1179:}
;1180:
;1181:/*
;1182:===========
;1183:ClientBegin
;1184:
;1185:called when a client has finished connecting, and is ready
;1186:to be placed into the level.  This will happen every level load,
;1187:and on transition between teams, but doesn't happen on respawns
;1188:============
;1189:*/
;1190:void ClientBegin( int clientNum ) {
line 1196
;1191:	gentity_t	*ent;
;1192:	gclient_t	*client;
;1193:	gentity_t	*tent;
;1194:	int			flags;
;1195:
;1196:	ent = g_entities + clientNum;
ADDRLP4 4
CNSTI4 808
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1198
;1197:
;1198:	client = level.clients + clientNum;
ADDRLP4 0
CNSTI4 780
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 1200
;1199:
;1200:	if ( ent->r.linked ) {
ADDRLP4 4
INDIRP4
CNSTI4 416
ADDP4
INDIRI4
CNSTI4 0
EQI4 $396
line 1201
;1201:		trap_UnlinkEntity( ent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 1202
;1202:	}
LABELV $396
line 1203
;1203:	G_InitGentity( ent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 G_InitGentity
CALLV
pop
line 1204
;1204:	ent->touch = 0;
ADDRLP4 4
INDIRP4
CNSTI4 704
ADDP4
CNSTP4 0
ASGNP4
line 1205
;1205:	ent->pain = 0;
ADDRLP4 4
INDIRP4
CNSTI4 712
ADDP4
CNSTP4 0
ASGNP4
line 1206
;1206:	ent->client = client;
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 1208
;1207:
;1208:	client->pers.connected = CON_CONNECTED;
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
CNSTI4 2
ASGNI4
line 1209
;1209:	client->pers.enterTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 552
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1210
;1210:	client->pers.teamState.state = TEAM_BEGIN;
ADDRLP4 0
INDIRP4
CNSTI4 556
ADDP4
CNSTI4 0
ASGNI4
line 1217
;1211:
;1212:	// save eflags around this, because changing teams will
;1213:	// cause this to happen with a valid entity, and we
;1214:	// want to make sure the teleport bit is set right
;1215:	// so the viewpoint doesn't interpolate through the
;1216:	// world to the new position
;1217:	flags = client->ps.eFlags;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
ASGNI4
line 1218
;1218:	memset( &client->ps, 0, sizeof( client->ps ) );
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 468
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1219
;1219:	client->ps.eFlags = flags;
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 1222
;1220:
;1221:	// locate ent at a spawn point
;1222:	ClientSpawn( ent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 ClientSpawn
CALLV
pop
line 1224
;1223:
;1224:	if ( client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $399
line 1226
;1225:		// send event
;1226:		tent = G_TempEntity( ent->client->ps.origin, EV_PLAYER_TELEPORT_IN );
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
ARGP4
CNSTI4 42
ARGI4
ADDRLP4 16
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 16
INDIRP4
ASGNP4
line 1227
;1227:		tent->s.clientNum = ent->s.clientNum;
ADDRLP4 20
CNSTI4 168
ASGNI4
ADDRLP4 12
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
ADDRLP4 4
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 1229
;1228:
;1229:		if ( g_gametype.integer != GT_TOURNAMENT  ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 1
EQI4 $401
line 1230
;1230:			trap_SendServerCommand( -1, va("print \"%s" S_COLOR_WHITE " entered the game\n\"", client->pers.netname) );
ADDRGP4 $404
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 24
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1231
;1231:		}
LABELV $401
line 1232
;1232:	}
LABELV $399
line 1233
;1233:	G_LogPrintf( "ClientBegin: %i\n", clientNum );
ADDRGP4 $405
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 G_LogPrintf
CALLV
pop
line 1236
;1234:
;1235:	// count current clients and rank for scoreboard
;1236:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 1237
;1237:}
LABELV $395
endproc ClientBegin 28 12
proc GiveRandomStartWeapon 64 0
line 1245
;1238:
;1239:
;1240:/*
;1241:========================
;1242:GiveRandomStartWeapon
;1243:========================
;1244:*/
;1245:static void GiveRandomStartWeapon( gclient_t *client ) {
line 1250
;1246:	int	weapons[8];
;1247:	int	numWeapons;
;1248:	int	weapon;
;1249:
;1250:	numWeapons = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1255
;1251:
;1252:	/*
;1253:	 * Scavenger mode uses only its three core weapons.
;1254:	 */
;1255:	if( g_scavengerWeapons.integer ) {
ADDRGP4 g_scavengerWeapons+12
INDIRI4
CNSTI4 0
EQI4 $407
line 1256
;1256:		weapons[numWeapons++] = WP_MACHINEGUN;
ADDRLP4 40
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 40
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 44
CNSTI4 2
ASGNI4
ADDRLP4 40
INDIRI4
ADDRLP4 44
INDIRI4
LSHI4
ADDRLP4 4
ADDP4
ADDRLP4 44
INDIRI4
ASGNI4
line 1257
;1257:		weapons[numWeapons++] = WP_SHOTGUN;
ADDRLP4 48
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 48
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 3
ASGNI4
line 1258
;1258:		if( !g_noRailgun.integer ) {
ADDRGP4 g_noRailgun+12
INDIRI4
CNSTI4 0
NEI4 $408
line 1259
;1259:	weapons[numWeapons++] = WP_RAILGUN;
ADDRLP4 52
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 52
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 7
ASGNI4
line 1260
;1260:}
line 1261
;1261:	}
ADDRGP4 $408
JUMPV
LABELV $407
line 1262
;1262:	else {
line 1263
;1263:		weapons[numWeapons++] = WP_MACHINEGUN;
ADDRLP4 40
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 40
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 44
CNSTI4 2
ASGNI4
ADDRLP4 40
INDIRI4
ADDRLP4 44
INDIRI4
LSHI4
ADDRLP4 4
ADDP4
ADDRLP4 44
INDIRI4
ASGNI4
line 1264
;1264:		weapons[numWeapons++] = WP_SHOTGUN;
ADDRLP4 48
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 48
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 3
ASGNI4
line 1265
;1265:		if( !g_noRailgun.integer ) {
ADDRGP4 g_noRailgun+12
INDIRI4
CNSTI4 0
NEI4 $413
line 1266
;1266:	weapons[numWeapons++] = WP_RAILGUN;
ADDRLP4 52
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 52
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 7
ASGNI4
line 1267
;1267:}
LABELV $413
line 1269
;1268:
;1269:		if( !g_noGrenadeRocket.integer ) {
ADDRGP4 g_noGrenadeRocket+12
INDIRI4
CNSTI4 0
NEI4 $416
line 1270
;1270:			weapons[numWeapons++] =
ADDRLP4 52
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 52
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 4
ASGNI4
line 1272
;1271:				WP_GRENADE_LAUNCHER;
;1272:			weapons[numWeapons++] =
ADDRLP4 56
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 56
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 5
ASGNI4
line 1274
;1273:				WP_ROCKET_LAUNCHER;
;1274:		}
LABELV $416
line 1276
;1275:
;1276:		if( !g_noPlasmaBFG.integer ) {
ADDRGP4 g_noPlasmaBFG+12
INDIRI4
CNSTI4 0
NEI4 $419
line 1277
;1277:			weapons[numWeapons++] = WP_LIGHTNING;
ADDRLP4 52
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 52
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 6
ASGNI4
line 1278
;1278:			weapons[numWeapons++] = WP_PLASMAGUN;
ADDRLP4 56
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 56
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 8
ASGNI4
line 1279
;1279:			weapons[numWeapons++] = WP_BFG;
ADDRLP4 60
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 60
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 60
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
CNSTI4 9
ASGNI4
line 1280
;1280:		}
LABELV $419
line 1281
;1281:	}
LABELV $408
line 1283
;1282:
;1283:	weapon = weapons[rand() % numWeapons];
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 36
ADDRLP4 40
INDIRI4
ADDRLP4 0
INDIRI4
MODI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
ASGNI4
line 1285
;1284:
;1285:	client->ps.stats[STAT_WEAPONS] =
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 1
ADDRLP4 36
INDIRI4
LSHI4
ASGNI4
line 1288
;1286:		( 1 << weapon );
;1287:
;1288:	switch( weapon ) {
ADDRLP4 48
CNSTI4 2
ASGNI4
ADDRLP4 36
INDIRI4
ADDRLP4 48
INDIRI4
LTI4 $422
ADDRLP4 36
INDIRI4
CNSTI4 9
GTI4 $422
ADDRLP4 36
INDIRI4
ADDRLP4 48
INDIRI4
LSHI4
ADDRGP4 $433-8
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $433
address $429
address $424
address $425
address $425
address $426
address $425
address $427
address $428
code
LABELV $424
line 1290
;1289:	case WP_SHOTGUN:
;1290:		client->ps.ammo[weapon] = 10;
ADDRLP4 36
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 10
ASGNI4
line 1291
;1291:		break;
ADDRGP4 $423
JUMPV
LABELV $425
line 1296
;1292:
;1293:	case WP_GRENADE_LAUNCHER:
;1294:	case WP_ROCKET_LAUNCHER:
;1295:	case WP_RAILGUN:
;1296:		client->ps.ammo[weapon] = 10;
ADDRLP4 36
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 10
ASGNI4
line 1297
;1297:		break;
ADDRGP4 $423
JUMPV
LABELV $426
line 1300
;1298:
;1299:	case WP_LIGHTNING:
;1300:		client->ps.ammo[weapon] = 100;
ADDRLP4 36
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 100
ASGNI4
line 1301
;1301:		break;
ADDRGP4 $423
JUMPV
LABELV $427
line 1304
;1302:
;1303:	case WP_PLASMAGUN:
;1304:		client->ps.ammo[weapon] = 50;
ADDRLP4 36
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 50
ASGNI4
line 1305
;1305:		break;
ADDRGP4 $423
JUMPV
LABELV $428
line 1308
;1306:
;1307:	case WP_BFG:
;1308:		client->ps.ammo[weapon] = 20;
ADDRLP4 36
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 20
ASGNI4
line 1309
;1309:		break;
ADDRGP4 $423
JUMPV
LABELV $429
LABELV $422
line 1313
;1310:
;1311:	case WP_MACHINEGUN:
;1312:	default:
;1313:		if( g_gametype.integer == GT_TEAM ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $430
line 1314
;1314:			client->ps.ammo[weapon] = 50;
ADDRLP4 36
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 50
ASGNI4
line 1315
;1315:		}
ADDRGP4 $423
JUMPV
LABELV $430
line 1316
;1316:		else {
line 1317
;1317:			client->ps.ammo[weapon] = 100;
ADDRLP4 36
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 376
ADDP4
ADDP4
CNSTI4 100
ASGNI4
line 1318
;1318:		}
line 1319
;1319:		break;
LABELV $423
line 1321
;1320:	}
;1321:}
LABELV $406
endproc GiveRandomStartWeapon 64 0
export ClientSpawn
proc ClientSpawn 348 16
line 1332
;1322:
;1323:/*
;1324:===========
;1325:ClientSpawn
;1326:
;1327:Called every time a client is placed fresh in the world:
;1328:after the first ClientBegin, and after each respawn
;1329:Initializes all non-persistant parts of playerState
;1330:============
;1331:*/
;1332:void ClientSpawn(gentity_t *ent) {
line 1347
;1333:	int		index;
;1334:	vec3_t	spawn_origin, spawn_angles;
;1335:	gclient_t	*client;
;1336:	int		i;
;1337:	clientPersistant_t	saved;
;1338:	clientSession_t		savedSess;
;1339:	int		persistant[MAX_PERSISTANT];
;1340:	gentity_t	*spawnPoint;
;1341:	int		flags;
;1342:	int		savedPing;
;1343://	char	*savedAreaBits;
;1344:	int		accuracy_hits, accuracy_shots;
;1345:	int		eventSequence;
;1346:
;1347:	index = ent - g_entities;
ADDRLP4 100
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ASGNI4
line 1348
;1348:	client = ent->client;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
line 1353
;1349:
;1350:	// find a spawn point
;1351:	// do it before setting health back up, so farthest
;1352:	// ranging doesn't count this client
;1353:	if ( client->sess.sessionTeam == TEAM_SPECTATOR ) {
ADDRLP4 4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $436
line 1354
;1354:		spawnPoint = SelectSpectatorSpawnPoint ( 
ADDRLP4 76
ARGP4
ADDRLP4 88
ARGP4
ADDRLP4 300
ADDRGP4 SelectSpectatorSpawnPoint
CALLP4
ASGNP4
ADDRLP4 72
ADDRLP4 300
INDIRP4
ASGNP4
line 1356
;1355:						spawn_origin, spawn_angles);
;1356:	}
ADDRGP4 $437
JUMPV
LABELV $436
line 1357
;1357:	else if( g_gametype.integer == GT_TEAM ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $438
line 1358
;1358:		if( g_baseTDM.integer ) {
ADDRGP4 g_baseTDM+12
INDIRI4
CNSTI4 0
EQI4 $441
line 1359
;1359:			spawnPoint = SelectBaseTeamSpawnPoint(
ADDRLP4 4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ARGI4
ADDRLP4 76
ARGP4
ADDRLP4 88
ARGP4
ADDRLP4 300
ADDRGP4 SelectBaseTeamSpawnPoint
CALLP4
ASGNP4
ADDRLP4 72
ADDRLP4 300
INDIRP4
ASGNP4
line 1364
;1360:				client->sess.sessionTeam,
;1361:				spawn_origin,
;1362:				spawn_angles
;1363:			);
;1364:		}
ADDRGP4 $439
JUMPV
LABELV $441
line 1365
;1365:		else {
line 1369
;1366:			/*
;1367:			 * Normal TDM and TDM on CTF maps.
;1368:			 */
;1369:			spawnPoint = SelectCTFSpawnPoint(
ADDRLP4 4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 76
ARGP4
ADDRLP4 88
ARGP4
ADDRLP4 300
ADDRGP4 SelectCTFSpawnPoint
CALLP4
ASGNP4
ADDRLP4 72
ADDRLP4 300
INDIRP4
ASGNP4
line 1375
;1370:				client->sess.sessionTeam,
;1371:				TEAM_ACTIVE,
;1372:				spawn_origin,
;1373:				spawn_angles
;1374:			);
;1375:		}
line 1376
;1376:	}
ADDRGP4 $439
JUMPV
LABELV $438
line 1377
;1377:		else if( g_gametype.integer >= GT_CTF ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
LTI4 $444
line 1378
;1378:			spawnPoint = SelectCTFSpawnPoint(
ADDRLP4 4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 556
ADDP4
INDIRI4
ARGI4
ADDRLP4 76
ARGP4
ADDRLP4 88
ARGP4
ADDRLP4 304
ADDRGP4 SelectCTFSpawnPoint
CALLP4
ASGNP4
ADDRLP4 72
ADDRLP4 304
INDIRP4
ASGNP4
line 1384
;1379:				client->sess.sessionTeam,
;1380:				client->pers.teamState.state,
;1381:				spawn_origin,
;1382:				spawn_angles
;1383:			);
;1384:		}
ADDRGP4 $445
JUMPV
LABELV $444
line 1385
;1385:		else {
LABELV $447
line 1386
;1386:		do {
line 1388
;1387:			// the first spawn should be at a good looking spot
;1388:			if ( !client->pers.initialSpawn && client->pers.localClient ) {
ADDRLP4 304
CNSTI4 0
ASGNI4
ADDRLP4 4
INDIRP4
CNSTI4 500
ADDP4
INDIRI4
ADDRLP4 304
INDIRI4
NEI4 $450
ADDRLP4 4
INDIRP4
CNSTI4 496
ADDP4
INDIRI4
ADDRLP4 304
INDIRI4
EQI4 $450
line 1389
;1389:				client->pers.initialSpawn = qtrue;
ADDRLP4 4
INDIRP4
CNSTI4 500
ADDP4
CNSTI4 1
ASGNI4
line 1390
;1390:				spawnPoint = SelectInitialSpawnPoint( spawn_origin, spawn_angles );
ADDRLP4 76
ARGP4
ADDRLP4 88
ARGP4
ADDRLP4 308
ADDRGP4 SelectInitialSpawnPoint
CALLP4
ASGNP4
ADDRLP4 72
ADDRLP4 308
INDIRP4
ASGNP4
line 1391
;1391:			} else {
ADDRGP4 $451
JUMPV
LABELV $450
line 1393
;1392:				// don't spawn near existing origin if possible
;1393:				spawnPoint = SelectSpawnPoint ( 
ADDRLP4 4
INDIRP4
CNSTI4 20
ADDP4
ARGP4
ADDRLP4 76
ARGP4
ADDRLP4 88
ARGP4
ADDRLP4 308
ADDRGP4 SelectSpawnPoint
CALLP4
ASGNP4
ADDRLP4 72
ADDRLP4 308
INDIRP4
ASGNP4
line 1396
;1394:					client->ps.origin, 
;1395:					spawn_origin, spawn_angles);
;1396:			}
LABELV $451
line 1400
;1397:
;1398:			// Tim needs to prevent bots from spawning at the initial point
;1399:			// on q3dm0...
;1400:			if ( ( spawnPoint->flags & FL_NO_BOTS ) && ( ent->r.svFlags & SVF_BOT ) ) {
ADDRLP4 308
CNSTI4 0
ASGNI4
ADDRLP4 72
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 8192
BANDI4
ADDRLP4 308
INDIRI4
EQI4 $452
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
ADDRLP4 308
INDIRI4
EQI4 $452
line 1401
;1401:				continue;	// try again
ADDRGP4 $448
JUMPV
LABELV $452
line 1404
;1402:			}
;1403:			// just to be symetric, we have a nohumans option...
;1404:			if ( ( spawnPoint->flags & FL_NO_HUMANS ) && !( ent->r.svFlags & SVF_BOT ) ) {
ADDRLP4 312
CNSTI4 0
ASGNI4
ADDRLP4 72
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 16384
BANDI4
ADDRLP4 312
INDIRI4
EQI4 $449
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
ADDRLP4 312
INDIRI4
NEI4 $449
line 1405
;1405:				continue;	// try again
line 1408
;1406:			}
;1407:
;1408:			break;
LABELV $448
line 1410
;1409:
;1410:		} while ( 1 );
ADDRGP4 $447
JUMPV
LABELV $449
line 1411
;1411:	}
LABELV $445
LABELV $439
LABELV $437
line 1412
;1412:	client->pers.teamState.state = TEAM_ACTIVE;
ADDRLP4 4
INDIRP4
CNSTI4 556
ADDP4
CNSTI4 1
ASGNI4
line 1415
;1413:
;1414:	// always clear the kamikaze flag
;1415:	ent->s.eFlags &= ~EF_KAMIKAZE;
ADDRLP4 300
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 300
INDIRP4
ADDRLP4 300
INDIRP4
INDIRI4
CNSTI4 -513
BANDI4
ASGNI4
line 1419
;1416:
;1417:	// toggle the teleport bit so the client knows to not lerp
;1418:	// and never clear the voted flag
;1419:	flags = ent->client->ps.eFlags & (EF_TELEPORT_BIT | EF_VOTED | EF_TEAMVOTED);
ADDRLP4 104
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
CNSTI4 540676
BANDI4
ASGNI4
line 1420
;1420:	flags ^= EF_TELEPORT_BIT;
ADDRLP4 104
ADDRLP4 104
INDIRI4
CNSTI4 4
BXORI4
ASGNI4
line 1424
;1421:
;1422:	// clear everything but the persistant data
;1423:
;1424:	saved = client->pers;
ADDRLP4 108
ADDRLP4 4
INDIRP4
CNSTI4 468
ADDP4
INDIRB
ASGNB 148
line 1425
;1425:	savedSess = client->sess;
ADDRLP4 256
ADDRLP4 4
INDIRP4
CNSTI4 616
ADDP4
INDIRB
ASGNB 28
line 1426
;1426:	savedPing = client->ps.ping;
ADDRLP4 284
ADDRLP4 4
INDIRP4
CNSTI4 452
ADDP4
INDIRI4
ASGNI4
line 1428
;1427://	savedAreaBits = client->areabits;
;1428:	accuracy_hits = client->accuracy_hits;
ADDRLP4 288
ADDRLP4 4
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
ASGNI4
line 1429
;1429:	accuracy_shots = client->accuracy_shots;
ADDRLP4 292
ADDRLP4 4
INDIRP4
CNSTI4 716
ADDP4
INDIRI4
ASGNI4
line 1430
;1430:	for ( i = 0 ; i < MAX_PERSISTANT ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $456
line 1431
;1431:		persistant[i] = client->ps.persistant[i];
ADDRLP4 304
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 304
INDIRI4
ADDRLP4 8
ADDP4
ADDRLP4 304
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 248
ADDP4
ADDP4
INDIRI4
ASGNI4
line 1432
;1432:	}
LABELV $457
line 1430
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $456
line 1433
;1433:	eventSequence = client->ps.eventSequence;
ADDRLP4 296
ADDRLP4 4
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ASGNI4
line 1435
;1434:
;1435:	memset (client, 0, sizeof(*client)); // bk FIXME: Com_Memset?
ADDRLP4 4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 780
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1437
;1436:
;1437:	client->pers = saved;
ADDRLP4 4
INDIRP4
CNSTI4 468
ADDP4
ADDRLP4 108
INDIRB
ASGNB 148
line 1438
;1438:	client->sess = savedSess;
ADDRLP4 4
INDIRP4
CNSTI4 616
ADDP4
ADDRLP4 256
INDIRB
ASGNB 28
line 1439
;1439:	client->ps.ping = savedPing;
ADDRLP4 4
INDIRP4
CNSTI4 452
ADDP4
ADDRLP4 284
INDIRI4
ASGNI4
line 1441
;1440://	client->areabits = savedAreaBits;
;1441:	client->accuracy_hits = accuracy_hits;
ADDRLP4 4
INDIRP4
CNSTI4 720
ADDP4
ADDRLP4 288
INDIRI4
ASGNI4
line 1442
;1442:	client->accuracy_shots = accuracy_shots;
ADDRLP4 4
INDIRP4
CNSTI4 716
ADDP4
ADDRLP4 292
INDIRI4
ASGNI4
line 1443
;1443:	client->lastkilled_client = -1;
ADDRLP4 4
INDIRP4
CNSTI4 724
ADDP4
CNSTI4 -1
ASGNI4
line 1445
;1444:
;1445:	for ( i = 0 ; i < MAX_PERSISTANT ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $460
line 1446
;1446:		client->ps.persistant[i] = persistant[i];
ADDRLP4 304
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 304
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 248
ADDP4
ADDP4
ADDRLP4 304
INDIRI4
ADDRLP4 8
ADDP4
INDIRI4
ASGNI4
line 1447
;1447:	}
LABELV $461
line 1445
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $460
line 1448
;1448:	client->ps.eventSequence = eventSequence;
ADDRLP4 4
INDIRP4
CNSTI4 108
ADDP4
ADDRLP4 296
INDIRI4
ASGNI4
line 1450
;1449:	// increment the spawncount so the client will detect the respawn
;1450:	client->ps.persistant[PERS_SPAWN_COUNT]++;
ADDRLP4 304
ADDRLP4 4
INDIRP4
CNSTI4 264
ADDP4
ASGNP4
ADDRLP4 304
INDIRP4
ADDRLP4 304
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1451
;1451:	client->ps.persistant[PERS_TEAM] = client->sess.sessionTeam;
ADDRLP4 4
INDIRP4
CNSTI4 260
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ASGNI4
line 1453
;1452:
;1453:	client->airOutTime = level.time + 12000;
ADDRLP4 4
INDIRP4
CNSTI4 752
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 12000
ADDI4
ASGNI4
line 1456
;1454:
;1455:	// set global health for players and bots
;1456:	client->pers.maxHealth = (int)Com_Clamp(
CNSTF4 1112014848
ARGF4
CNSTF4 1125515264
ARGF4
ADDRGP4 g_playerHealth+12
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 312
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 548
ADDP4
ADDRLP4 312
INDIRF4
CVFI4 4
ASGNI4
line 1463
;1457:		50,
;1458:		150,
;1459:		g_playerHealth.integer
;1460:	);
;1461:
;1462:	// clear entity values
;1463:	client->ps.stats[STAT_MAX_HEALTH] =
ADDRLP4 4
INDIRP4
CNSTI4 208
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ASGNI4
line 1466
;1464:		client->pers.maxHealth;
;1465:
;1466:	client->ps.eFlags = flags;
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
ADDRLP4 104
INDIRI4
ASGNI4
line 1468
;1467:
;1468:	ent->s.groundEntityNum = ENTITYNUM_NONE;
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 1469
;1469:	ent->client = &level.clients[index];
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
CNSTI4 780
ADDRLP4 100
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 1470
;1470:	ent->takedamage = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 1471
;1471:	ent->inuse = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 520
ADDP4
CNSTI4 1
ASGNI4
line 1472
;1472:	ent->classname = "player";
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $466
ASGNP4
line 1473
;1473:	ent->r.contents = CONTENTS_BODY;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 33554432
ASGNI4
line 1474
;1474:	ent->clipmask = MASK_PLAYERSOLID;
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 33619969
ASGNI4
line 1475
;1475:	ent->die = player_die;
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 player_die
ASGNP4
line 1476
;1476:	ent->waterlevel = 0;
ADDRFP4 0
INDIRP4
CNSTI4 788
ADDP4
CNSTI4 0
ASGNI4
line 1477
;1477:	ent->watertype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
CNSTI4 0
ASGNI4
line 1478
;1478:	ent->flags = 0;
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
CNSTI4 0
ASGNI4
line 1480
;1479:	
;1480:	VectorCopy (playerMins, ent->r.mins);
ADDRFP4 0
INDIRP4
CNSTI4 436
ADDP4
ADDRGP4 playerMins
INDIRB
ASGNB 12
line 1481
;1481:	VectorCopy (playerMaxs, ent->r.maxs);
ADDRFP4 0
INDIRP4
CNSTI4 448
ADDP4
ADDRGP4 playerMaxs
INDIRB
ASGNB 12
line 1483
;1482:
;1483:client->ps.clientNum = index;
ADDRLP4 4
INDIRP4
CNSTI4 140
ADDP4
ADDRLP4 100
INDIRI4
ASGNI4
line 1488
;1484:
;1485:/*
;1486: * Give the selected starting weapon.
;1487: */
;1488:if( g_blasterMode.integer ) {
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $467
line 1489
;1489:	client->ps.stats[STAT_WEAPONS] =
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 2048
ASGNI4
line 1492
;1490:		( 1 << WP_BLASTER );
;1491:
;1492:	client->ps.ammo[WP_BLASTER] = -1;
ADDRLP4 4
INDIRP4
CNSTI4 420
ADDP4
CNSTI4 -1
ASGNI4
line 1493
;1493:}
ADDRGP4 $468
JUMPV
LABELV $467
line 1494
;1494:else if( g_randomStartWeapon.integer ||
ADDRLP4 320
CNSTI4 0
ASGNI4
ADDRGP4 g_randomStartWeapon+12
INDIRI4
ADDRLP4 320
INDIRI4
NEI4 $474
ADDRGP4 g_scavengerWeapons+12
INDIRI4
ADDRLP4 320
INDIRI4
EQI4 $470
LABELV $474
line 1495
;1495:	g_scavengerWeapons.integer ) {
line 1496
;1496:	GiveRandomStartWeapon( client );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 GiveRandomStartWeapon
CALLV
pop
line 1497
;1497:}
ADDRGP4 $471
JUMPV
LABELV $470
line 1498
;1498:else {
line 1499
;1499:	client->ps.stats[STAT_WEAPONS] =
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 4
ASGNI4
line 1502
;1500:		( 1 << WP_MACHINEGUN );
;1501:
;1502:	if( g_gametype.integer == GT_TEAM ) {
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $475
line 1503
;1503:		client->ps.ammo[WP_MACHINEGUN] = 50;
ADDRLP4 4
INDIRP4
CNSTI4 384
ADDP4
CNSTI4 50
ASGNI4
line 1504
;1504:	}
ADDRGP4 $476
JUMPV
LABELV $475
line 1505
;1505:	else {
line 1506
;1506:		client->ps.ammo[WP_MACHINEGUN] = 100;
ADDRLP4 4
INDIRP4
CNSTI4 384
ADDP4
CNSTI4 100
ASGNI4
line 1507
;1507:	}
LABELV $476
line 1508
;1508:}
LABELV $471
LABELV $468
line 1513
;1509:
;1510:/*
;1511: * Gauntlet is always available.
;1512: */
;1513:client->ps.stats[STAT_WEAPONS] |=
ADDRLP4 324
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
ASGNP4
ADDRLP4 324
INDIRP4
ADDRLP4 324
INDIRP4
INDIRI4
CNSTI4 2
BORI4
ASGNI4
line 1516
;1514:	( 1 << WP_GAUNTLET );
;1515:
;1516:client->ps.ammo[WP_GAUNTLET] = -1;
ADDRLP4 4
INDIRP4
CNSTI4 380
ADDP4
CNSTI4 -1
ASGNI4
line 1517
;1517:client->ps.ammo[WP_GRAPPLING_HOOK] = -1;
ADDRLP4 4
INDIRP4
CNSTI4 416
ADDP4
CNSTI4 -1
ASGNI4
line 1522
;1518:
;1519:/*
;1520: * Spawn with the selected global health value.
;1521: */
;1522:ent->health = client->ps.stats[STAT_HEALTH] =
ADDRLP4 332
ADDRLP4 4
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
ASGNI4
ADDRLP4 4
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 332
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
ADDRLP4 332
INDIRI4
ASGNI4
line 1525
;1523:	client->ps.stats[STAT_MAX_HEALTH];
;1524:
;1525:G_SetOrigin( ent, spawn_origin );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 76
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 1526
;1526:VectorCopy( spawn_origin, client->ps.origin );
ADDRLP4 4
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 76
INDIRB
ASGNB 12
line 1532
;1527:
;1528:/*
;1529: * The respawned flag is cleared after attack and jump
;1530: * buttons are released.
;1531: */
;1532:client->ps.pm_flags |= PMF_RESPAWNED;
ADDRLP4 336
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 336
INDIRP4
ADDRLP4 336
INDIRP4
INDIRI4
CNSTI4 512
BORI4
ASGNI4
line 1534
;1533:
;1534:trap_GetUsercmd(
ADDRLP4 4
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
ADDRFP4 0
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
line 1539
;1535:	client - level.clients,
;1536:	&ent->client->pers.cmd
;1537:);
;1538:
;1539:SetClientViewAngle( ent, spawn_angles );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 88
ARGP4
ADDRGP4 SetClientViewAngle
CALLV
pop
line 1541
;1540:
;1541:if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $478
line 1542
;1542:	G_KillBox( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_KillBox
CALLV
pop
line 1543
;1543:	trap_LinkEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1548
;1544:
;1545:	/*
;1546:	 * Select the starting weapon.
;1547:	 */
;1548:	if( g_blasterMode.integer ) {
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $480
line 1549
;1549:		client->ps.weapon = WP_BLASTER;
ADDRLP4 4
INDIRP4
CNSTI4 144
ADDP4
CNSTI4 11
ASGNI4
line 1550
;1550:	}
ADDRGP4 $481
JUMPV
LABELV $480
line 1551
;1551:else if( g_randomStartWeapon.integer ||
ADDRLP4 340
CNSTI4 0
ASGNI4
ADDRGP4 g_randomStartWeapon+12
INDIRI4
ADDRLP4 340
INDIRI4
NEI4 $487
ADDRGP4 g_scavengerWeapons+12
INDIRI4
ADDRLP4 340
INDIRI4
EQI4 $483
LABELV $487
line 1552
;1552:	g_scavengerWeapons.integer ) {
line 1553
;1553:		client->ps.weapon = WP_GAUNTLET;
ADDRLP4 4
INDIRP4
CNSTI4 144
ADDP4
CNSTI4 1
ASGNI4
line 1555
;1554:
;1555:		for( i = WP_NUM_WEAPONS - 1; i > 0; i-- ) {
ADDRLP4 0
CNSTI4 11
ASGNI4
LABELV $488
line 1556
;1556:			if( client->ps.stats[STAT_WEAPONS] &
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 1
ADDRLP4 0
INDIRI4
LSHI4
BANDI4
CNSTI4 0
EQI4 $492
line 1557
;1557:				( 1 << i ) ) {
line 1558
;1558:				client->ps.weapon = i;
ADDRLP4 4
INDIRP4
CNSTI4 144
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1559
;1559:				break;
ADDRGP4 $484
JUMPV
LABELV $492
line 1561
;1560:			}
;1561:		}
LABELV $489
line 1555
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $488
line 1562
;1562:	}
ADDRGP4 $484
JUMPV
LABELV $483
line 1563
;1563:	else {
line 1564
;1564:		client->ps.weapon = WP_MACHINEGUN;
ADDRLP4 4
INDIRP4
CNSTI4 144
ADDP4
CNSTI4 2
ASGNI4
line 1565
;1565:	}
LABELV $484
LABELV $481
line 1567
;1566:
;1567:	client->ps.weaponstate = WEAPON_READY;
ADDRLP4 4
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 0
ASGNI4
line 1568
;1568:}
LABELV $478
line 1571
;1569:
;1570:// don't allow full run speed for a bit
;1571:	client->ps.pm_flags |= PMF_TIME_KNOCKBACK;
ADDRLP4 340
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 340
INDIRP4
ADDRLP4 340
INDIRP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 1572
;1572:	client->ps.pm_time = 100;
ADDRLP4 4
INDIRP4
CNSTI4 16
ADDP4
CNSTI4 100
ASGNI4
line 1574
;1573:
;1574:	client->respawnTime = level.time;
ADDRLP4 4
INDIRP4
CNSTI4 736
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1575
;1575:	client->inactivityTime = level.time + g_inactivity.integer * 1000;
ADDRLP4 4
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
line 1576
;1576:	client->latched_buttons = 0;
ADDRLP4 4
INDIRP4
CNSTI4 668
ADDP4
CNSTI4 0
ASGNI4
line 1579
;1577:
;1578:	// set default animations
;1579:	client->ps.torsoAnim = TORSO_STAND;
ADDRLP4 4
INDIRP4
CNSTI4 84
ADDP4
CNSTI4 11
ASGNI4
line 1580
;1580:	client->ps.legsAnim = LEGS_IDLE;
ADDRLP4 4
INDIRP4
CNSTI4 76
ADDP4
CNSTI4 22
ASGNI4
line 1582
;1581:
;1582:	if ( level.intermissiontime ) {
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $497
line 1583
;1583:		MoveClientToIntermission( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 MoveClientToIntermission
CALLV
pop
line 1584
;1584:	} else {
ADDRGP4 $498
JUMPV
LABELV $497
line 1586
;1585:		// fire the targets of the spawn point
;1586:		G_UseTargets( spawnPoint, ent );
ADDRLP4 72
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_UseTargets
CALLV
pop
line 1590
;1587:
;1588:		// select the highest weapon number available, after any
;1589:		// spawn given items have fired
;1590:		client->ps.weapon = 1;
ADDRLP4 4
INDIRP4
CNSTI4 144
ADDP4
CNSTI4 1
ASGNI4
line 1591
;1591:		for ( i = WP_NUM_WEAPONS - 1 ; i > 0 ; i-- ) {
ADDRLP4 0
CNSTI4 11
ASGNI4
LABELV $500
line 1592
;1592:			if ( client->ps.stats[STAT_WEAPONS] & ( 1 << i ) ) {
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 1
ADDRLP4 0
INDIRI4
LSHI4
BANDI4
CNSTI4 0
EQI4 $504
line 1593
;1593:				client->ps.weapon = i;
ADDRLP4 4
INDIRP4
CNSTI4 144
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1594
;1594:				break;
ADDRGP4 $502
JUMPV
LABELV $504
line 1596
;1595:			}
;1596:		}
LABELV $501
line 1591
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $500
LABELV $502
line 1597
;1597:	}
LABELV $498
line 1601
;1598:
;1599:	// run a client frame to drop exactly to the floor,
;1600:	// initialize animations and other things
;1601:	client->ps.commandTime = level.time - 100;
ADDRLP4 4
INDIRP4
ADDRGP4 level+32
INDIRI4
CNSTI4 100
SUBI4
ASGNI4
line 1602
;1602:	ent->client->pers.cmd.serverTime = level.time;
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
line 1603
;1603:	ClientThink( ent-g_entities );
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ARGI4
ADDRGP4 ClientThink
CALLV
pop
line 1606
;1604:
;1605:	// positively link the client, even if the command times are weird
;1606:	if ( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $508
line 1607
;1607:		BG_PlayerStateToEntityState( &client->ps, &ent->s, qtrue );
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
line 1608
;1608:		VectorCopy( ent->client->ps.origin, ent->r.currentOrigin );
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 344
INDIRP4
CNSTI4 488
ADDP4
ADDRLP4 344
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
INDIRB
ASGNB 12
line 1609
;1609:		trap_LinkEntity( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1610
;1610:	}
LABELV $508
line 1613
;1611:
;1612:	// run the presend to set anything else
;1613:	ClientEndFrame( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 ClientEndFrame
CALLV
pop
line 1616
;1614:
;1615:	// clear entity state values
;1616:	BG_PlayerStateToEntityState( &client->ps, &ent->s, qtrue );
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
line 1617
;1617:}
LABELV $435
endproc ClientSpawn 348 16
export ClientDisconnect
proc ClientDisconnect 24 8
line 1632
;1618:
;1619:
;1620:/*
;1621:===========
;1622:ClientDisconnect
;1623:
;1624:Called when a player drops from the server.
;1625:Will not be called between levels.
;1626:
;1627:This should NOT be called directly by any game logic,
;1628:call trap_DropClient(), which will call this and do
;1629:server system housekeeping.
;1630:============
;1631:*/
;1632:void ClientDisconnect( int clientNum ) {
line 1639
;1633:	gentity_t	*ent;
;1634:	gentity_t	*tent;
;1635:	int			i;
;1636:
;1637:	// cleanup if we are kicking a bot that
;1638:	// hasn't spawned yet
;1639:	G_RemoveQueuedBotBegin( clientNum );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 G_RemoveQueuedBotBegin
CALLV
pop
line 1641
;1640:
;1641:	ent = g_entities + clientNum;
ADDRLP4 4
CNSTI4 808
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1642
;1642:	if ( !ent->client ) {
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $511
line 1643
;1643:		return;
ADDRGP4 $510
JUMPV
LABELV $511
line 1647
;1644:	}
;1645:
;1646:	// stop any following clients
;1647:	for ( i = 0 ; i < level.maxclients ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $516
JUMPV
LABELV $513
line 1648
;1648:		if ( level.clients[i].sess.sessionTeam == TEAM_SPECTATOR
ADDRLP4 12
CNSTI4 780
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $518
ADDRLP4 12
INDIRP4
CNSTI4 624
ADDP4
INDIRI4
CNSTI4 2
NEI4 $518
ADDRLP4 12
INDIRP4
CNSTI4 628
ADDP4
INDIRI4
ADDRFP4 0
INDIRI4
NEI4 $518
line 1650
;1649:			&& level.clients[i].sess.spectatorState == SPECTATOR_FOLLOW
;1650:			&& level.clients[i].sess.spectatorClient == clientNum ) {
line 1651
;1651:			StopFollowing( &g_entities[i] );
CNSTI4 808
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ARGP4
ADDRGP4 StopFollowing
CALLV
pop
line 1652
;1652:		}
LABELV $518
line 1653
;1653:	}
LABELV $514
line 1647
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $516
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $513
line 1656
;1654:
;1655:	// send effect if they were completely connected
;1656:	if ( ent->client->pers.connected == CON_CONNECTED 
ADDRLP4 12
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $520
ADDRLP4 12
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $520
line 1657
;1657:		&& ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
line 1658
;1658:		tent = G_TempEntity( ent->client->ps.origin, EV_PLAYER_TELEPORT_OUT );
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
ARGP4
CNSTI4 43
ARGI4
ADDRLP4 16
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 16
INDIRP4
ASGNP4
line 1659
;1659:		tent->s.clientNum = ent->s.clientNum;
ADDRLP4 20
CNSTI4 168
ASGNI4
ADDRLP4 8
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
ADDRLP4 4
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 1663
;1660:
;1661:		// They don't get to take powerups with them!
;1662:		// Especially important for stuff like CTF flags
;1663:		TossClientItems( ent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 TossClientItems
CALLV
pop
line 1671
;1664:#ifdef MISSIONPACK
;1665:		TossClientPersistantPowerups( ent );
;1666:		if( g_gametype.integer == GT_HARVESTER ) {
;1667:			TossClientCubes( ent );
;1668:		}
;1669:#endif
;1670:
;1671:	}
LABELV $520
line 1673
;1672:
;1673:	G_LogPrintf( "ClientDisconnect: %i\n", clientNum );
ADDRGP4 $522
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 G_LogPrintf
CALLV
pop
line 1676
;1674:
;1675:	// if we are playing in tourney mode and losing, give a win to the other player
;1676:	if ( (g_gametype.integer == GT_TOURNAMENT )
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 1
NEI4 $523
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 level+9128
INDIRI4
ADDRLP4 16
INDIRI4
NEI4 $523
ADDRGP4 level+16
INDIRI4
ADDRLP4 16
INDIRI4
NEI4 $523
ADDRGP4 level+84+4
INDIRI4
ADDRFP4 0
INDIRI4
NEI4 $523
line 1678
;1677:		&& !level.intermissiontime
;1678:		&& !level.warmupTime && level.sortedClients[1] == clientNum ) {
line 1679
;1679:		level.clients[ level.sortedClients[0] ].sess.wins++;
ADDRLP4 20
CNSTI4 780
ADDRGP4 level+84
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 632
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1680
;1680:		ClientUserinfoChanged( level.sortedClients[0] );
ADDRGP4 level+84
INDIRI4
ARGI4
ADDRGP4 ClientUserinfoChanged
CALLV
pop
line 1681
;1681:	}
LABELV $523
line 1683
;1682:
;1683:	trap_UnlinkEntity (ent);
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 1684
;1684:	ent->s.modelindex = 0;
ADDRLP4 4
INDIRP4
CNSTI4 160
ADDP4
CNSTI4 0
ASGNI4
line 1685
;1685:	ent->inuse = qfalse;
ADDRLP4 4
INDIRP4
CNSTI4 520
ADDP4
CNSTI4 0
ASGNI4
line 1686
;1686:	ent->classname = "disconnected";
ADDRLP4 4
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $532
ASGNP4
line 1687
;1687:	ent->client->pers.connected = CON_DISCONNECTED;
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
CNSTI4 0
ASGNI4
line 1688
;1688:	ent->client->ps.persistant[PERS_TEAM] = TEAM_FREE;
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 260
ADDP4
CNSTI4 0
ASGNI4
line 1689
;1689:	ent->client->sess.sessionTeam = TEAM_FREE;
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
CNSTI4 0
ASGNI4
line 1691
;1690:
;1691:	trap_SetConfigstring( CS_PLAYERS + clientNum, "");
ADDRFP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRGP4 $533
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1693
;1692:
;1693:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 1695
;1694:
;1695:	if ( ent->r.svFlags & SVF_BOT ) {
ADDRLP4 4
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $534
line 1696
;1696:		BotAIShutdownClient( clientNum, qfalse );
ADDRFP4 0
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 BotAIShutdownClient
CALLI4
pop
line 1697
;1697:	}
LABELV $534
line 1698
;1698:}
LABELV $510
endproc ClientDisconnect 24 8
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
import CalculateRanks
import AddScore
import player_die
import InitClientResp
import InitClientPersistant
import BeginIntermission
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
LABELV $533
byte 1 0
align 1
LABELV $532
byte 1 100
byte 1 105
byte 1 115
byte 1 99
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $522
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 68
byte 1 105
byte 1 115
byte 1 99
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $466
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $405
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 66
byte 1 101
byte 1 103
byte 1 105
byte 1 110
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $404
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 94
byte 1 55
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $391
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 94
byte 1 55
byte 1 32
byte 1 99
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $388
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 67
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $387
byte 1 66
byte 1 111
byte 1 116
byte 1 67
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $375
byte 1 73
byte 1 110
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 112
byte 1 97
byte 1 115
byte 1 115
byte 1 119
byte 1 111
byte 1 114
byte 1 100
byte 1 0
align 1
LABELV $373
byte 1 110
byte 1 111
byte 1 110
byte 1 101
byte 1 0
align 1
LABELV $368
byte 1 112
byte 1 97
byte 1 115
byte 1 115
byte 1 119
byte 1 111
byte 1 114
byte 1 100
byte 1 0
align 1
LABELV $365
byte 1 89
byte 1 111
byte 1 117
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 32
byte 1 98
byte 1 97
byte 1 110
byte 1 110
byte 1 101
byte 1 100
byte 1 32
byte 1 102
byte 1 114
byte 1 111
byte 1 109
byte 1 32
byte 1 116
byte 1 104
byte 1 105
byte 1 115
byte 1 32
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 46
byte 1 0
align 1
LABELV $361
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 85
byte 1 115
byte 1 101
byte 1 114
byte 1 105
byte 1 110
byte 1 102
byte 1 111
byte 1 67
byte 1 104
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 100
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
LABELV $360
byte 1 110
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 116
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 104
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 103
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 103
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 99
byte 1 49
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 99
byte 1 50
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 104
byte 1 99
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 119
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 108
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 116
byte 1 116
byte 1 92
byte 1 37
byte 1 100
byte 1 92
byte 1 116
byte 1 108
byte 1 92
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $359
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $358
byte 1 110
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 116
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 104
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 99
byte 1 49
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 99
byte 1 50
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 104
byte 1 99
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 119
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 108
byte 1 92
byte 1 37
byte 1 105
byte 1 92
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 92
byte 1 37
byte 1 115
byte 1 92
byte 1 116
byte 1 116
byte 1 92
byte 1 37
byte 1 100
byte 1 92
byte 1 116
byte 1 108
byte 1 92
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $355
byte 1 103
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $354
byte 1 103
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $353
byte 1 99
byte 1 111
byte 1 108
byte 1 111
byte 1 114
byte 1 50
byte 1 0
align 1
LABELV $352
byte 1 99
byte 1 111
byte 1 108
byte 1 111
byte 1 114
byte 1 49
byte 1 0
align 1
LABELV $351
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 116
byte 1 97
byte 1 115
byte 1 107
byte 1 0
align 1
LABELV $347
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 114
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $345
byte 1 98
byte 1 0
align 1
LABELV $344
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $340
byte 1 114
byte 1 0
align 1
LABELV $339
byte 1 114
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $336
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $330
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $329
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $328
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $327
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $323
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 94
byte 1 55
byte 1 32
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $318
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 98
byte 1 111
byte 1 97
byte 1 114
byte 1 100
byte 1 0
align 1
LABELV $313
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $310
byte 1 99
byte 1 103
byte 1 95
byte 1 112
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 0
align 1
LABELV $309
byte 1 108
byte 1 111
byte 1 99
byte 1 97
byte 1 108
byte 1 104
byte 1 111
byte 1 115
byte 1 116
byte 1 0
align 1
LABELV $306
byte 1 105
byte 1 112
byte 1 0
align 1
LABELV $305
byte 1 92
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 92
byte 1 98
byte 1 97
byte 1 100
byte 1 105
byte 1 110
byte 1 102
byte 1 111
byte 1 0
align 1
LABELV $300
byte 1 85
byte 1 110
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 100
byte 1 80
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $200
byte 1 98
byte 1 111
byte 1 100
byte 1 121
byte 1 113
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $124
byte 1 67
byte 1 111
byte 1 117
byte 1 108
byte 1 100
byte 1 110
byte 1 39
byte 1 116
byte 1 32
byte 1 102
byte 1 105
byte 1 110
byte 1 100
byte 1 32
byte 1 97
byte 1 32
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $61
byte 1 105
byte 1 110
byte 1 102
byte 1 111
byte 1 95
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 95
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 109
byte 1 97
byte 1 116
byte 1 99
byte 1 104
byte 1 0
align 1
LABELV $57
byte 1 110
byte 1 111
byte 1 104
byte 1 117
byte 1 109
byte 1 97
byte 1 110
byte 1 115
byte 1 0
align 1
LABELV $54
byte 1 48
byte 1 0
align 1
LABELV $53
byte 1 110
byte 1 111
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 0
