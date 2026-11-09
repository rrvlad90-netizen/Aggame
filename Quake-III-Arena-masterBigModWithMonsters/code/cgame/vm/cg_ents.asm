export CG_PositionEntityOnTag
code
proc CG_PositionEntityOnTag 84 24
file "../cg_ents.c"
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
;23:// cg_ents.c -- present snapshot entities, happens every single frame
;24:
;25:#include "cg_local.h"
;26:
;27:
;28:/*
;29:======================
;30:CG_PositionEntityOnTag
;31:
;32:Modifies the entities position and axis by the given
;33:tag location
;34:======================
;35:*/
;36:void CG_PositionEntityOnTag( refEntity_t *entity, const refEntity_t *parent, 
;37:							qhandle_t parentModel, char *tagName ) {
line 42
;38:	int				i;
;39:	orientation_t	lerped;
;40:	
;41:	// lerp the tag
;42:	trap_R_LerpTag( &lerped, parentModel, parent->oldframe, parent->frame,
ADDRLP4 4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRLP4 52
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 52
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ARGI4
CNSTF4 1065353216
ADDRLP4 52
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
SUBF4
ARGF4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 trap_R_LerpTag
CALLI4
pop
line 46
;43:		1.0 - parent->backlerp, tagName );
;44:
;45:	// FIXME: allow origin offsets along tag?
;46:	VectorCopy( parent->origin, entity->origin );
ADDRLP4 56
CNSTI4 68
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
ADDRFP4 4
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
INDIRB
ASGNB 12
line 47
;47:	for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $75
line 48
;48:		VectorMA( entity->origin, lerped.origin[i], parent->axis[i], entity->origin );
ADDRLP4 60
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDP4
INDIRF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 68
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 76
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 76
INDIRP4
ADDRLP4 76
INDIRP4
INDIRF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 49
;49:	}
LABELV $76
line 47
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $75
line 52
;50:
;51:	// had to cast away the const to avoid compiler problems...
;52:	MatrixMultiply( lerped.axis, ((refEntity_t *)parent)->axis, entity->axis );
ADDRLP4 4+12
ARGP4
ADDRLP4 60
CNSTI4 28
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 60
INDIRI4
ADDP
ARGP4
ADDRFP4 0
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
ARGP4
ADDRGP4 MatrixMultiply
CALLV
pop
line 53
;53:	entity->backlerp = parent->backlerp;
ADDRLP4 64
CNSTI4 100
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
ADDRFP4 4
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRF4
ASGNF4
line 54
;54:}
LABELV $74
endproc CG_PositionEntityOnTag 84 24
export CG_PositionRotatedEntityOnTag
proc CG_PositionRotatedEntityOnTag 120 24
line 66
;55:
;56:
;57:/*
;58:======================
;59:CG_PositionRotatedEntityOnTag
;60:
;61:Modifies the entities position and axis by the given
;62:tag location
;63:======================
;64:*/
;65:void CG_PositionRotatedEntityOnTag( refEntity_t *entity, const refEntity_t *parent, 
;66:							qhandle_t parentModel, char *tagName ) {
line 73
;67:	int				i;
;68:	orientation_t	lerped;
;69:	vec3_t			tempAxis[3];
;70:
;71://AxisClear( entity->axis );
;72:	// lerp the tag
;73:	trap_R_LerpTag( &lerped, parentModel, parent->oldframe, parent->frame,
ADDRLP4 4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRLP4 88
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 88
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
ARGI4
ADDRLP4 88
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ARGI4
CNSTF4 1065353216
ADDRLP4 88
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
SUBF4
ARGF4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 trap_R_LerpTag
CALLI4
pop
line 77
;74:		1.0 - parent->backlerp, tagName );
;75:
;76:	// FIXME: allow origin offsets along tag?
;77:	VectorCopy( parent->origin, entity->origin );
ADDRLP4 92
CNSTI4 68
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
ADDRFP4 4
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRB
ASGNB 12
line 78
;78:	for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $81
line 79
;79:		VectorMA( entity->origin, lerped.origin[i], parent->axis[i], entity->origin );
ADDRLP4 96
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDP4
INDIRF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 104
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 104
INDIRP4
ADDRLP4 104
INDIRP4
INDIRF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 112
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 112
INDIRP4
ADDRLP4 112
INDIRP4
INDIRF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 80
;80:	}
LABELV $82
line 78
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $81
line 83
;81:
;82:	// had to cast away the const to avoid compiler problems...
;83:	MatrixMultiply( entity->axis, lerped.axis, tempAxis );
ADDRFP4 0
INDIRP4
CNSTI4 28
ADDP4
ARGP4
ADDRLP4 4+12
ARGP4
ADDRLP4 52
ARGP4
ADDRGP4 MatrixMultiply
CALLV
pop
line 84
;84:	MatrixMultiply( tempAxis, ((refEntity_t *)parent)->axis, entity->axis );
ADDRLP4 52
ARGP4
ADDRLP4 96
CNSTI4 28
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 96
INDIRI4
ADDP
ARGP4
ADDRFP4 0
INDIRP4
ADDRLP4 96
INDIRI4
ADDP4
ARGP4
ADDRGP4 MatrixMultiply
CALLV
pop
line 85
;85:}
LABELV $80
endproc CG_PositionRotatedEntityOnTag 120 24
export CG_SetEntitySoundPosition
proc CG_SetEntitySoundPosition 24 8
line 104
;86:
;87:
;88:
;89:/*
;90:==========================================================================
;91:
;92:FUNCTIONS CALLED EACH FRAME
;93:
;94:==========================================================================
;95:*/
;96:
;97:/*
;98:======================
;99:CG_SetEntitySoundPosition
;100:
;101:Also called by event processing code
;102:======================
;103:*/
;104:void CG_SetEntitySoundPosition( centity_t *cent ) {
line 105
;105:	if ( cent->currentState.solid == SOLID_BMODEL ) {
ADDRFP4 0
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
NEI4 $87
line 109
;106:		vec3_t	origin;
;107:		float	*v;
;108:
;109:		v = cgs.inlineModelMidpoints[ cent->currentState.modelindex ];
ADDRLP4 12
CNSTI4 12
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+37900
ADDP4
ASGNP4
line 110
;110:		VectorAdd( cent->lerpOrigin, v, origin );
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
ADDRLP4 12
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 16
INDIRP4
CNSTI4 704
ADDP4
INDIRF4
ADDRLP4 20
INDIRP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 16
INDIRP4
CNSTI4 708
ADDP4
INDIRF4
ADDRLP4 20
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRF4
ADDRLP4 12
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDF4
ASGNF4
line 111
;111:		trap_S_UpdateEntityPosition( cent->currentState.number, origin );
ADDRFP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_S_UpdateEntityPosition
CALLV
pop
line 112
;112:	} else {
ADDRGP4 $88
JUMPV
LABELV $87
line 113
;113:		trap_S_UpdateEntityPosition( cent->currentState.number, cent->lerpOrigin );
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 trap_S_UpdateEntityPosition
CALLV
pop
line 114
;114:	}
LABELV $88
line 115
;115:}
LABELV $86
endproc CG_SetEntitySoundPosition 24 8
proc CG_EntityEffects 20 20
line 124
;116:
;117:/*
;118:==================
;119:CG_EntityEffects
;120:
;121:Add continuous entity effects, like local entity emission and lighting
;122:==================
;123:*/
;124:static void CG_EntityEffects( centity_t *cent ) {
line 127
;125:
;126:	// update sound origins
;127:	CG_SetEntitySoundPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_SetEntitySoundPosition
CALLV
pop
line 130
;128:
;129:	// add loop sound
;130:	if ( cent->currentState.loopSound ) {
ADDRFP4 0
INDIRP4
CNSTI4 156
ADDP4
INDIRI4
CNSTI4 0
EQI4 $93
line 131
;131:		if (cent->currentState.eType != ET_SPEAKER) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 7
EQI4 $95
line 132
;132:			trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, 
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 vec3_origin
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 156
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_AddLoopingSound
CALLV
pop
line 134
;133:				cgs.gameSounds[ cent->currentState.loopSound ] );
;134:		} else {
ADDRGP4 $96
JUMPV
LABELV $95
line 135
;135:			trap_S_AddRealLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, 
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 vec3_origin
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 156
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_AddRealLoopingSound
CALLV
pop
line 137
;136:				cgs.gameSounds[ cent->currentState.loopSound ] );
;137:		}
LABELV $96
line 138
;138:	}
LABELV $93
line 142
;139:
;140:
;141:	// constant light glow
;142:	if ( cent->currentState.constantLight ) {
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
INDIRI4
CNSTI4 0
EQI4 $99
line 146
;143:		int		cl;
;144:		int		i, r, g, b;
;145:
;146:		cl = cent->currentState.constantLight;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
INDIRI4
ASGNI4
line 147
;147:		r = cl & 255;
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 255
BANDI4
ASGNI4
line 148
;148:		g = ( cl >> 8 ) & 255;
ADDRLP4 12
ADDRLP4 0
INDIRI4
CNSTI4 8
RSHI4
CNSTI4 255
BANDI4
ASGNI4
line 149
;149:		b = ( cl >> 16 ) & 255;
ADDRLP4 16
ADDRLP4 0
INDIRI4
CNSTI4 16
RSHI4
CNSTI4 255
BANDI4
ASGNI4
line 150
;150:		i = ( ( cl >> 24 ) & 255 ) * 4;
ADDRLP4 4
ADDRLP4 0
INDIRI4
CNSTI4 24
RSHI4
CNSTI4 255
BANDI4
CNSTI4 2
LSHI4
ASGNI4
line 151
;151:		trap_R_AddLightToScene( cent->lerpOrigin, i, r, g, b );
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 152
;152:	}
LABELV $99
line 154
;153:
;154:}
LABELV $92
endproc CG_EntityEffects 20 20
proc CG_General 144 12
line 162
;155:
;156:
;157:/*
;158:==================
;159:CG_General
;160:==================
;161:*/
;162:static void CG_General( centity_t *cent ) {
line 166
;163:	refEntity_t			ent;
;164:	entityState_t		*s1;
;165:
;166:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 169
;167:
;168:	// if set to invisible, skip
;169:	if (!s1->modelindex) {
ADDRLP4 140
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 0
NEI4 $102
line 170
;170:		return;
ADDRGP4 $101
JUMPV
LABELV $102
line 173
;171:	}
;172:
;173:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 177
;174:
;175:	// set frame
;176:
;177:	ent.frame = s1->frame;
ADDRLP4 0+80
ADDRLP4 140
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 178
;178:	ent.oldframe = ent.frame;
ADDRLP4 0+96
ADDRLP4 0+80
INDIRI4
ASGNI4
line 179
;179:	ent.backlerp = 0;
ADDRLP4 0+100
CNSTF4 0
ASGNF4
line 181
;180:
;181:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 182
;182:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 184
;183:
;184:	ent.hModel = cgs.gameModels[s1->modelindex];
ADDRLP4 0+8
ADDRLP4 140
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+34824
ADDP4
INDIRI4
ASGNI4
line 187
;185:
;186:	// player model
;187:	if (s1->number == cg.snap->ps.clientNum) {
ADDRLP4 140
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $112
line 188
;188:		ent.renderfx |= RF_THIRD_PERSON;	// only draw from mirrors
ADDRLP4 0+4
ADDRLP4 0+4
INDIRI4
CNSTI4 2
BORI4
ASGNI4
line 189
;189:	}
LABELV $112
line 192
;190:
;191:	// convert angles to axis
;192:	AnglesToAxis( cent->lerpAngles, ent.axis );
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 195
;193:
;194:	// add to refresh list
;195:	trap_R_AddRefEntityToScene (&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 196
;196:}
LABELV $101
endproc CG_General 144 12
data
align 4
LABELV $118
byte 4 0
byte 4 1096810496
byte 4 1103101952
byte 4 1108344832
byte 4 1112539136
lit
align 4
LABELV $119
byte 4 3245342720
byte 4 3245342720
byte 4 0
align 4
LABELV $120
byte 4 1097859072
byte 4 1097859072
byte 4 1073741824
code
proc CG_MonsterShadow 108 44
line 217
;197:
;198:/*
;199:==================
;200:Monster Shaders
;201:==================
;202:*/
;203:static qhandle_t cg_monsterShaders
;204:	[MONSTER_TYPE_RANDOM]
;205:	[MAX_MONSTERS_PER_TYPE];
;206:
;207:static int cg_monsterShadow
;208:	[MONSTER_TYPE_RANDOM]
;209:	[MAX_MONSTERS_PER_TYPE];
;210:
;211:#define MONSTER_SHADOW_DISTANCE 128
;212:
;213:/*
;214: * Blob shadow on the floor under a monster.
;215: * size: 1 small, 2 medium, 3 larger, 4 large
;216: */
;217:static void CG_MonsterShadow( centity_t *cent, int size ) {
line 220
;218:	static float radii[5] = { 0, 14, 24, 36, 52 };
;219:	vec3_t end;
;220:	vec3_t mins = { -15, -15, 0 };
ADDRLP4 72
ADDRGP4 $119
INDIRB
ASGNB 12
line 221
;221:	vec3_t maxs = { 15, 15, 2 };
ADDRLP4 84
ADDRGP4 $120
INDIRB
ASGNB 12
line 225
;222:	trace_t trace;
;223:	float alpha;
;224:
;225:	if( size <= 0 || !cg_shadows.integer ) {
ADDRLP4 96
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 96
INDIRI4
LEI4 $124
ADDRGP4 cg_shadows+12
INDIRI4
ADDRLP4 96
INDIRI4
NEI4 $121
LABELV $124
line 226
;226:		return;
ADDRGP4 $117
JUMPV
LABELV $121
line 229
;227:	}
;228:
;229:	if( size > 4 ) {
ADDRFP4 4
INDIRI4
CNSTI4 4
LEI4 $125
line 230
;230:		size = 4;
ADDRFP4 4
CNSTI4 4
ASGNI4
line 231
;231:	}
LABELV $125
line 233
;232:
;233:	VectorCopy( cent->lerpOrigin, end );
ADDRLP4 60
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 234
;234:	end[2] -= MONSTER_SHADOW_DISTANCE;
ADDRLP4 60+8
ADDRLP4 60+8
INDIRF4
CNSTF4 1124073472
SUBF4
ASGNF4
line 236
;235:
;236:	trap_CM_BoxTrace(
ADDRLP4 0
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 60
ARGP4
ADDRLP4 72
ARGP4
ADDRLP4 84
ARGP4
CNSTI4 0
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_CM_BoxTrace
CALLV
pop
line 246
;237:		&trace,
;238:		cent->lerpOrigin,
;239:		end,
;240:		mins,
;241:		maxs,
;242:		0,
;243:		MASK_PLAYERSOLID
;244:	);
;245:
;246:	if( trace.fraction == 1.0f ||
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $133
ADDRLP4 100
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 100
INDIRI4
NEI4 $133
ADDRLP4 0
INDIRI4
ADDRLP4 100
INDIRI4
EQI4 $128
LABELV $133
line 248
;247:		trace.startsolid ||
;248:		trace.allsolid ) {
line 249
;249:		return;
ADDRGP4 $117
JUMPV
LABELV $128
line 253
;250:	}
;251:
;252:	/* fade out with height */
;253:	alpha = 1.0f - trace.fraction;
ADDRLP4 56
CNSTF4 1065353216
ADDRLP4 0+8
INDIRF4
SUBF4
ASGNF4
line 255
;254:
;255:	CG_ImpactMark(
ADDRGP4 cgs+152340+344
INDIRI4
ARGI4
ADDRLP4 0+12
ARGP4
ADDRLP4 0+24
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
CNSTF4 1065353216
ARGF4
CNSTI4 0
ARGI4
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $118
ADDP4
INDIRF4
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 CG_ImpactMark
CALLV
pop
line 265
;256:		cgs.media.shadowMarkShader,
;257:		trace.endpos,
;258:		trace.plane.normal,
;259:		cent->lerpAngles[YAW],
;260:		alpha, alpha, alpha, 1,
;261:		qfalse,
;262:		radii[size],
;263:		qtrue
;264:	);
;265:}
LABELV $117
endproc CG_MonsterShadow 108 44
data
align 4
LABELV cg_monsterConfigFiles
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
address $149
address $150
address $151
address $152
address $153
address $154
address $155
address $156
address $157
address $158
address $159
address $160
address $161
address $162
address $163
byte 4 0
code
proc CG_LoadMonsterShader 9660 16
line 298
;266:
;267:static const char *cg_monsterConfigFiles[] = {
;268:	"models/monsters/HereticDisciple/monster.cfg",
;269:	"models/monsters/DarkKnight/monster.cfg",
;270:	"models/monsters/LionGuy/monster.cfg",
;271:	"models/monsters/D3Imp/monster.cfg",
;272:	"models/monsters/Gross/monster.cfg",
;273:	"models/monsters/Flyer/monster.cfg",
;274:	"models/monsters/Hover/monster.cfg",
;275:	"models/monsters/FlyingGuard/monster.cfg",
;276:	"models/monsters/StrongF/monster.cfg",
;277:	"models/monsters/Gunner/monster.cfg",	
;278:	"models/monsters/MongGrunt/monster.cfg",
;279:	"models/monsters/MongGruntShotgun/monster.cfg",
;280:	"models/monsters/MongGruntRifle/monster.cfg",
;281:	"models/monsters/Faust/monster.cfg",
;282:	"models/monsters/Stratos/monster.cfg",
;283:	"models/monsters/Mincer/monster.cfg",
;284:	"models/monsters/Forgotten/monster.cfg",
;285:	"models/monsters/Ghost/monster.cfg",
;286:	"models/monsters/Mancubus/monster.cfg",
;287:	"models/monsters/Frostatronach/monster.cfg",
;288:	"models/monsters/Trooper/monster.cfg",
;289:	"models/monsters/TrooperShotgun/monster.cfg",
;290:	"models/monsters/TrooperBlaster/monster.cfg",
;291:	"models/monsters/TrooperFlyer/monster.cfg",
;292:	"models/monsters/TrooperRocket/monster.cfg",	
;293:	NULL
;294:};
;295:
;296:static void CG_LoadMonsterShader(
;297:	const char *filename
;298:) {
line 305
;299:	fileHandle_t file;
;300:	char text[MAX_MONSTER_CONFIG_TEXT];
;301:	char error[256];
;302:	monsterDef_t def;
;303:	int length;
;304:
;305:	length = trap_FS_FOpenFile(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1184
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 9636
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 1180
ADDRLP4 9636
INDIRI4
ASGNI4
line 311
;306:		filename,
;307:		&file,
;308:		FS_READ
;309:	);
;310:
;311:	if( !file ) {
ADDRLP4 1184
INDIRI4
CNSTI4 0
NEI4 $165
line 312
;312:		CG_Printf(
ADDRGP4 $167
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 316
;313:			"Monster config not found: %s\n",
;314:			filename
;315:		);
;316:		return;
ADDRGP4 $164
JUMPV
LABELV $165
line 319
;317:	}
;318:
;319:	if( length <= 0 ||
ADDRLP4 1180
INDIRI4
CNSTI4 0
LEI4 $170
ADDRLP4 1180
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $168
LABELV $170
line 320
;320:		length >= sizeof(text) ) {
line 321
;321:		CG_Printf(
ADDRGP4 $171
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 326
;322:			"Invalid monster config size: %s\n",
;323:			filename
;324:		);
;325:
;326:		trap_FS_FCloseFile(file);
ADDRLP4 1184
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 327
;327:		return;
ADDRGP4 $164
JUMPV
LABELV $168
line 330
;328:	}
;329:
;330:	trap_FS_Read(text, length, file);
ADDRLP4 1188
ARGP4
ADDRLP4 1180
INDIRI4
ARGI4
ADDRLP4 1184
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 331
;331:	text[length] = '\0';
ADDRLP4 1180
INDIRI4
ADDRLP4 1188
ADDP4
CNSTI1 0
ASGNI1
line 332
;332:	trap_FS_FCloseFile(file);
ADDRLP4 1184
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 334
;333:
;334:	if( !BG_ParseMonsterConfig(
ADDRLP4 1188
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 9380
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 9644
ADDRGP4 BG_ParseMonsterConfig
CALLI4
ASGNI4
ADDRLP4 9644
INDIRI4
CNSTI4 0
NEI4 $172
line 339
;335:		text,
;336:		&def,
;337:		error,
;338:		sizeof(error)
;339:	) ) {
line 340
;340:		CG_Printf(
ADDRGP4 $174
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9380
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 345
;341:			"Monster config error in %s: %s\n",
;342:			filename,
;343:			error
;344:		);
;345:		return;
ADDRGP4 $164
JUMPV
LABELV $172
line 348
;346:	}
;347:
;348:	if( def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 9648
CNSTI4 0
ASGNI4
ADDRLP4 0+576
INDIRI4
ADDRLP4 9648
INDIRI4
LEI4 $183
ADDRLP4 0+576
INDIRI4
CNSTI4 6
GEI4 $183
ADDRLP4 0+580
INDIRI4
ADDRLP4 9648
INDIRI4
LTI4 $183
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $175
LABELV $183
line 352
;349:		def.monsterType >= MONSTER_TYPE_RANDOM ||
;350:		def.monsterSlot < 0 ||
;351:		def.monsterSlot >=
;352:			MAX_MONSTERS_PER_TYPE ) {
line 353
;353:		CG_Printf(
ADDRGP4 $184
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 357
;354:			"Invalid monster definition in %s\n",
;355:			filename
;356:		);
;357:		return;
ADDRGP4 $164
JUMPV
LABELV $175
line 360
;358:	}
;359:
;360:	cg_monsterShadow
ADDRLP4 0+580
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 20
ADDRLP4 0+576
INDIRI4
MULI4
ADDRGP4 cg_monsterShadow
ADDP4
ADDP4
ADDRLP4 0+784
INDIRI4
ASGNI4
line 364
;361:		[def.monsterType]
;362:		[def.monsterSlot] = def.shadow;
;363:
;364:	if( !def.shader[0] ||
ADDRLP4 0+320
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $193
ADDRLP4 0+320
ARGP4
ADDRGP4 $192
ARGP4
ADDRLP4 9652
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 9652
INDIRI4
CNSTI4 0
NEI4 $188
LABELV $193
line 365
;365:		!Q_stricmp(def.shader, "none") ) {
line 366
;366:		return;
ADDRGP4 $164
JUMPV
LABELV $188
line 369
;367:	}
;368:		
;369:	cg_monsterShaders[def.monsterType][def.monsterSlot] =
ADDRLP4 0+320
ARGP4
ADDRLP4 9656
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 0+580
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 20
ADDRLP4 0+576
INDIRI4
MULI4
ADDRGP4 cg_monsterShaders
ADDP4
ADDP4
ADDRLP4 9656
INDIRI4
ASGNI4
line 371
;370:		trap_R_RegisterShader(def.shader);
;371:}
LABELV $164
endproc CG_LoadMonsterShader 9660 16
export CG_InitMonsterShaders
proc CG_InitMonsterShaders 4 12
line 373
;372:
;373:void CG_InitMonsterShaders( void ) {
line 376
;374:	int i;
;375:
;376:	memset(
ADDRGP4 cg_monsterShaders
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 382
;377:		cg_monsterShaders,
;378:		0,
;379:		sizeof(cg_monsterShaders)
;380:	);
;381:
;382:	memset(
ADDRGP4 cg_monsterShadow
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 388
;383:		cg_monsterShadow,
;384:		0,
;385:		sizeof(cg_monsterShadow)
;386:	);
;387:
;388:	for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $201
JUMPV
LABELV $198
line 390
;389:		cg_monsterConfigFiles[i];
;390:		i++ ) {
line 391
;391:		CG_LoadMonsterShader(
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_monsterConfigFiles
ADDP4
INDIRP4
ARGP4
ADDRGP4 CG_LoadMonsterShader
CALLV
pop
line 394
;392:			cg_monsterConfigFiles[i]
;393:		);
;394:	}
LABELV $199
line 390
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $201
line 389
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $198
line 395
;395:}
LABELV $197
endproc CG_InitMonsterShaders 4 12
proc CG_Monster 196 12
line 402
;396:
;397:/*
;398:==================
;399:Monster
;400:==================
;401:*/
;402:static void CG_Monster( centity_t *cent ) {
line 411
;403:	refEntity_t renderEntity;
;404:	qhandle_t customShader;
;405:	int monsterType;
;406:	int monsterSlot;
;407:	int packedDefinition;
;408:	int models[4];
;409:	int i;
;410:
;411:	packedDefinition =
ADDRLP4 172
ADDRFP4 0
INDIRP4
CNSTI4 204
ADDP4
INDIRI4
ASGNI4
line 414
;412:		cent->currentState.generic1;
;413:
;414:	monsterType =
ADDRLP4 164
ADDRLP4 172
INDIRI4
CNSTI4 5
DIVI4
ASGNI4
line 417
;415:		packedDefinition / MAX_MONSTERS_PER_TYPE;
;416:
;417:	monsterSlot =
ADDRLP4 168
ADDRLP4 172
INDIRI4
CNSTI4 5
MODI4
ASGNI4
line 420
;418:		packedDefinition % MAX_MONSTERS_PER_TYPE;
;419:
;420:	customShader = 0;
ADDRLP4 160
CNSTI4 0
ASGNI4
line 422
;421:
;422:	if( monsterType > MONSTER_TYPE_OFF &&
ADDRLP4 180
CNSTI4 0
ASGNI4
ADDRLP4 164
INDIRI4
ADDRLP4 180
INDIRI4
LEI4 $203
ADDRLP4 164
INDIRI4
CNSTI4 6
GEI4 $203
ADDRLP4 168
INDIRI4
ADDRLP4 180
INDIRI4
LTI4 $203
ADDRLP4 168
INDIRI4
CNSTI4 5
GEI4 $203
line 426
;423:		monsterType < MONSTER_TYPE_RANDOM &&
;424:		monsterSlot >= 0 &&
;425:		monsterSlot <
;426:			MAX_MONSTERS_PER_TYPE ) {
line 427
;427:		customShader =
ADDRLP4 160
ADDRLP4 168
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 20
ADDRLP4 164
INDIRI4
MULI4
ADDRGP4 cg_monsterShaders
ADDP4
ADDP4
INDIRI4
ASGNI4
line 432
;428:			cg_monsterShaders
;429:				[monsterType]
;430:				[monsterSlot];
;431:
;432:		CG_MonsterShadow(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 168
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 20
ADDRLP4 164
INDIRI4
MULI4
ADDRGP4 cg_monsterShadow
ADDP4
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_MonsterShadow
CALLV
pop
line 438
;433:			cent,
;434:			cg_monsterShadow
;435:				[monsterType]
;436:				[monsterSlot]
;437:		);
;438:	}
LABELV $203
line 440
;439:
;440:	models[0] =
ADDRLP4 144
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ASGNI4
line 443
;441:		cent->currentState.modelindex;
;442:
;443:	models[1] =
ADDRLP4 144+4
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
ASGNI4
line 446
;444:		cent->currentState.modelindex2;
;445:
;446:	models[2] =
ADDRLP4 144+8
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 449
;447:		cent->currentState.otherEntityNum;
;448:
;449:	models[3] =
ADDRLP4 144+12
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 452
;450:		cent->currentState.otherEntityNum2;
;451:
;452:	for( i = 0; i < 4; i++ ) {
ADDRLP4 140
CNSTI4 0
ASGNI4
LABELV $208
line 453
;453:		if( models[i] <= 0 ) {
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 144
ADDP4
INDIRI4
CNSTI4 0
GTI4 $212
line 454
;454:			continue;
ADDRGP4 $209
JUMPV
LABELV $212
line 457
;455:		}
;456:
;457:		memset(
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 463
;458:			&renderEntity,
;459:			0,
;460:			sizeof(renderEntity)
;461:		);
;462:
;463:		renderEntity.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 465
;464:
;465:		renderEntity.hModel =
ADDRLP4 188
CNSTI4 2
ASGNI4
ADDRLP4 0+8
ADDRLP4 140
INDIRI4
ADDRLP4 188
INDIRI4
LSHI4
ADDRLP4 144
ADDP4
INDIRI4
ADDRLP4 188
INDIRI4
LSHI4
ADDRGP4 cgs+34824
ADDP4
INDIRI4
ASGNI4
line 468
;466:			cgs.gameModels[models[i]];
;467:
;468:		renderEntity.customShader =
ADDRLP4 0+112
ADDRLP4 160
INDIRI4
ASGNI4
line 471
;469:			customShader;
;470:
;471:		renderEntity.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 472
;472:		renderEntity.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 473
;473:		renderEntity.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 474
;474:		renderEntity.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 476
;475:
;476:		renderEntity.oldframe =
ADDRLP4 0+96
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 479
;477:			cent->currentState.frame;
;478:
;479:		renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 482
;480:			cent->currentState.frame;
;481:
;482:		renderEntity.backlerp = 0;
ADDRLP4 0+100
CNSTF4 0
ASGNF4
line 484
;483:
;484:		if( cent->interpolate &&
ADDRLP4 192
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 192
INDIRP4
CNSTI4 416
ADDP4
INDIRI4
CNSTI4 0
EQI4 $227
ADDRLP4 192
INDIRP4
CNSTI4 212
ADDP4
INDIRI4
CNSTI4 13
NEI4 $227
line 486
;485:			cent->nextState.eType ==
;486:				ET_MONSTER ) {
line 487
;487:			renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 380
ADDP4
INDIRI4
ASGNI4
line 490
;488:				cent->nextState.frame;
;489:
;490:			renderEntity.backlerp =
ADDRLP4 0+100
CNSTF4 1065353216
ADDRGP4 cg+107588
INDIRF4
SUBF4
ASGNF4
line 493
;491:				1.0f -
;492:				cg.frameInterpolation;
;493:		}
LABELV $227
line 495
;494:
;495:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 500
;496:			cent->lerpOrigin,
;497:			renderEntity.origin
;498:		);
;499:
;500:		VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 505
;501:			cent->lerpOrigin,
;502:			renderEntity.oldorigin
;503:		);
;504:
;505:		AnglesToAxis(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 510
;506:			cent->lerpAngles,
;507:			renderEntity.axis
;508:		);
;509:
;510:		trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 513
;511:			&renderEntity
;512:		);
;513:	}
LABELV $209
line 452
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 4
LTI4 $208
line 514
;514:}
LABELV $202
endproc CG_Monster 196 12
proc CG_Speaker 16 16
line 523
;515:
;516:/*
;517:==================
;518:CG_Speaker
;519:
;520:Speaker entities can automatically play sounds
;521:==================
;522:*/
;523:static void CG_Speaker( centity_t *cent ) {
line 524
;524:	if ( ! cent->currentState.clientNum ) {	// FIXME: use something other than clientNum...
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
CNSTI4 0
NEI4 $236
line 525
;525:		return;		// not auto triggering
ADDRGP4 $235
JUMPV
LABELV $236
line 528
;526:	}
;527:
;528:	if ( cg.time < cent->miscTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRI4
GEI4 $238
line 529
;529:		return;
ADDRGP4 $235
JUMPV
LABELV $238
line 532
;530:	}
;531:
;532:	trap_S_StartSound (NULL, cent->currentState.number, CHAN_ITEM, cgs.gameSounds[cent->currentState.eventParm] );
CNSTP4 0
ARGP4
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 536
;533:
;534:	//	ent->s.frame = ent->wait * 10;
;535:	//	ent->s.clientNum = ent->random * 10;
;536:	cent->miscTime = cg.time + cent->currentState.frame * 100 + cent->currentState.clientNum * 100 * crandom();
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
CNSTI4 100
ASGNI4
ADDRLP4 8
INDIRP4
CNSTI4 444
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 12
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
MULI4
ADDI4
CVIF4 4
ADDRLP4 12
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
MULI4
CVIF4 4
CNSTF4 1073741824
ADDRLP4 4
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
ADDF4
CVFI4 4
ASGNI4
line 537
;537:}
LABELV $235
endproc CG_Speaker 16 16
proc CG_Item 204 12
line 544
;538:
;539:/*
;540:==================
;541:CG_Item
;542:==================
;543:*/
;544:static void CG_Item( centity_t *cent ) {
line 553
;545:	refEntity_t	ent;
;546:	entityState_t	*es;
;547:	gitem_t		*item;
;548:	int		msec;
;549:	float		frac;
;550:	float		scale;
;551:	weaponInfo_t	*wi;
;552:
;553:	es = &cent->currentState;
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
line 555
;554:
;555:	if( es->modelindex >= bg_numItems ) {
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $244
line 556
;556:		CG_Error(
ADDRGP4 $246
ARGP4
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 560
;557:			"Bad item index %i on entity",
;558:			es->modelindex
;559:		);
;560:	}
LABELV $244
line 563
;561:
;562:	// if set to invisible, skip
;563:	if( !es->modelindex ||
ADDRLP4 168
CNSTI4 0
ASGNI4
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRLP4 168
INDIRI4
EQI4 $249
ADDRLP4 144
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 128
BANDI4
ADDRLP4 168
INDIRI4
EQI4 $247
LABELV $249
line 564
;564:		(es->eFlags & EF_NODRAW) ) {
line 565
;565:		return;
ADDRGP4 $243
JUMPV
LABELV $247
line 568
;566:	}
;567:
;568:	item = &bg_itemlist[es->modelindex];
ADDRLP4 140
CNSTI4 52
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
MULI4
ADDRGP4 bg_itemlist
ADDP4
ASGNP4
line 570
;569:
;570:	if( cg_simpleItems.integer &&
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
EQI4 $250
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
EQI4 $250
line 571
;571:		item->giType != IT_TEAM ) {
line 572
;572:		memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 574
;573:
;574:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 575
;575:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 579
;576:			cent->lerpOrigin,
;577:			ent.origin
;578:		);
;579:		ent.radius = 14;
ADDRLP4 0+132
CNSTF4 1096810496
ASGNF4
line 580
;580:		ent.customShader =
ADDRLP4 0+112
CNSTI4 24
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_items+20
ADDP4
INDIRI4
ASGNI4
line 582
;581:			cg_items[es->modelindex].icon;
;582:		ent.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 583
;583:		ent.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 584
;584:		ent.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 585
;585:		ent.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 587
;586:
;587:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 588
;588:		return;
ADDRGP4 $243
JUMPV
LABELV $250
line 595
;589:	}
;590:
;591:	/*
;592:	 * Normal items continuously bob up and down.
;593:	 * Static items retain their original map position.
;594:	 */
;595:	if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $264
line 596
;596:		scale =
ADDRLP4 160
CNSTF4 925353388
ADDRFP4 0
INDIRP4
INDIRI4
CVIF4 4
MULF4
CNSTF4 1000593162
ADDF4
ASGNF4
line 600
;597:			0.005 +
;598:			cent->currentState.number * 0.00001;
;599:
;600:		cent->lerpOrigin[2] +=
ADDRGP4 cg+107604
INDIRI4
CNSTI4 1000
ADDI4
CVIF4 4
ADDRLP4 160
INDIRF4
MULF4
ARGF4
ADDRLP4 172
ADDRGP4 cos
CALLF4
ASGNF4
ADDRLP4 176
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
ASGNP4
ADDRLP4 176
INDIRP4
ADDRLP4 176
INDIRP4
INDIRF4
CNSTF4 1082130432
ADDRLP4 172
INDIRF4
MULF4
CNSTF4 1082130432
ADDF4
ADDF4
ASGNF4
line 603
;601:			4 +
;602:			cos((cg.time + 1000) * scale) * 4;
;603:	}
LABELV $264
line 605
;604:
;605:	memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 611
;606:
;607:	/*
;608:	 * Static items use a fixed identity axis.
;609:	 * Normal items use the original automatic rotation.
;610:	 */
;611:	if( cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
EQI4 $268
line 612
;612:		VectorClear( cent->lerpAngles );
ADDRLP4 172
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 176
CNSTF4 0
ASGNF4
ADDRLP4 172
INDIRP4
CNSTI4 724
ADDP4
ADDRLP4 176
INDIRF4
ASGNF4
ADDRLP4 172
INDIRP4
CNSTI4 720
ADDP4
ADDRLP4 176
INDIRF4
ASGNF4
ADDRLP4 172
INDIRP4
CNSTI4 716
ADDP4
ADDRLP4 176
INDIRF4
ASGNF4
line 613
;613:		AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 614
;614:	}
ADDRGP4 $269
JUMPV
LABELV $268
line 615
;615:	else if( item->giType == IT_HEALTH ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 4
NEI4 $272
line 616
;616:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108996
INDIRB
ASGNB 12
line 620
;617:			cg.autoAnglesFast,
;618:			cent->lerpAngles
;619:		);
;620:		AxisCopy(
ADDRGP4 cg+109008
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 624
;621:			cg.autoAxisFast,
;622:			ent.axis
;623:		);
;624:	}
ADDRGP4 $273
JUMPV
LABELV $272
line 625
;625:	else {
line 626
;626:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108948
INDIRB
ASGNB 12
line 630
;627:			cg.autoAngles,
;628:			cent->lerpAngles
;629:		);
;630:		AxisCopy(
ADDRGP4 cg+108960
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 634
;631:			cg.autoAxis,
;632:			ent.axis
;633:		);
;634:	}
LABELV $273
LABELV $269
line 636
;635:
;636:	wi = NULL;
ADDRLP4 152
CNSTP4 0
ASGNP4
line 642
;637:
;638:	/*
;639:	 * Weapon models have their origin at the attachment point,
;640:	 * so compensate using the weapon midpoint.
;641:	 */
;642:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $280
line 643
;643:		wi = &cg_weapons[item->giTag];
ADDRLP4 152
CNSTI4 136
ADDRLP4 140
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons
ADDP4
ASGNP4
line 645
;644:
;645:		cent->lerpOrigin[0] -=
ADDRLP4 172
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ASGNP4
ADDRLP4 172
INDIRP4
ADDRLP4 172
INDIRP4
INDIRF4
ADDRLP4 152
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 0+28
INDIRF4
MULF4
ADDRLP4 152
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 0+28+12
INDIRF4
MULF4
ADDF4
ADDRLP4 152
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ADDRLP4 0+28+24
INDIRF4
MULF4
ADDF4
SUBF4
ASGNF4
line 650
;646:			wi->weaponMidpoint[0] * ent.axis[0][0] +
;647:			wi->weaponMidpoint[1] * ent.axis[1][0] +
;648:			wi->weaponMidpoint[2] * ent.axis[2][0];
;649:
;650:		cent->lerpOrigin[1] -=
ADDRLP4 180
ADDRFP4 0
INDIRP4
CNSTI4 708
ADDP4
ASGNP4
ADDRLP4 180
INDIRP4
ADDRLP4 180
INDIRP4
INDIRF4
ADDRLP4 152
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 0+28+4
INDIRF4
MULF4
ADDRLP4 152
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 0+28+12+4
INDIRF4
MULF4
ADDF4
ADDRLP4 152
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ADDRLP4 0+28+24+4
INDIRF4
MULF4
ADDF4
SUBF4
ASGNF4
line 655
;651:			wi->weaponMidpoint[0] * ent.axis[0][1] +
;652:			wi->weaponMidpoint[1] * ent.axis[1][1] +
;653:			wi->weaponMidpoint[2] * ent.axis[2][1];
;654:
;655:		cent->lerpOrigin[2] -=
ADDRLP4 188
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
ASGNP4
ADDRLP4 188
INDIRP4
ADDRLP4 188
INDIRP4
INDIRF4
ADDRLP4 152
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 0+28+8
INDIRF4
MULF4
ADDRLP4 152
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 0+28+12+8
INDIRF4
MULF4
ADDF4
ADDRLP4 152
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ADDRLP4 0+28+24+8
INDIRF4
MULF4
ADDF4
SUBF4
ASGNF4
line 660
;656:			wi->weaponMidpoint[0] * ent.axis[0][2] +
;657:			wi->weaponMidpoint[1] * ent.axis[1][2] +
;658:			wi->weaponMidpoint[2] * ent.axis[2][2];
;659:
;660:		cent->lerpOrigin[2] += 8;
ADDRLP4 196
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
ASGNP4
ADDRLP4 196
INDIRP4
ADDRLP4 196
INDIRP4
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 661
;661:	}
LABELV $280
line 663
;662:
;663:	ent.hModel =
ADDRLP4 0+8
CNSTI4 24
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_items+4
ADDP4
INDIRI4
ASGNI4
line 666
;664:		cg_items[es->modelindex].models[0];
;665:
;666:	VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 670
;667:		cent->lerpOrigin,
;668:		ent.origin
;669:	);
;670:	VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 675
;671:		cent->lerpOrigin,
;672:		ent.oldorigin
;673:	);
;674:
;675:	ent.nonNormalizedAxes = qfalse;
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 681
;676:
;677:	/*
;678:	 * Static items appear immediately at full size.
;679:	 * Normal items retain the respawn scale animation.
;680:	 */
;681:	msec = cg.time - cent->miscTime;
ADDRLP4 156
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRI4
SUBI4
ASGNI4
line 683
;682:
;683:	if( !cg_staticItems.integer &&
ADDRLP4 172
CNSTI4 0
ASGNI4
ADDRGP4 cg_staticItems+12
INDIRI4
ADDRLP4 172
INDIRI4
NEI4 $309
ADDRLP4 156
INDIRI4
ADDRLP4 172
INDIRI4
LTI4 $309
ADDRLP4 156
INDIRI4
CNSTI4 1000
GEI4 $309
line 685
;684:		msec >= 0 &&
;685:		msec < ITEM_SCALEUP_TIME ) {
line 686
;686:		frac = (float)msec /
ADDRLP4 148
ADDRLP4 156
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 689
;687:			ITEM_SCALEUP_TIME;
;688:
;689:		VectorScale(
ADDRLP4 0+28
ADDRLP4 0+28
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+4
ADDRLP4 0+28+4
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+8
ADDRLP4 0+28+8
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
line 694
;690:			ent.axis[0],
;691:			frac,
;692:			ent.axis[0]
;693:		);
;694:		VectorScale(
ADDRLP4 0+28+12
ADDRLP4 0+28+12
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+12+4
ADDRLP4 0+28+12+4
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+12+8
ADDRLP4 0+28+12+8
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
line 699
;695:			ent.axis[1],
;696:			frac,
;697:			ent.axis[1]
;698:		);
;699:		VectorScale(
ADDRLP4 0+28+24
ADDRLP4 0+28+24
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+24+4
ADDRLP4 0+28+24+4
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+24+8
ADDRLP4 0+28+24+8
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
line 705
;700:			ent.axis[2],
;701:			frac,
;702:			ent.axis[2]
;703:		);
;704:
;705:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 706
;706:	}
ADDRGP4 $310
JUMPV
LABELV $309
line 707
;707:	else {
line 708
;708:		frac = 1.0f;
ADDRLP4 148
CNSTF4 1065353216
ASGNF4
line 709
;709:	}
LABELV $310
line 714
;710:
;711:	/*
;712:	 * Items without glow textures need a minimum light value.
;713:	 */
;714:	if( item->giType == IT_WEAPON ||
ADDRLP4 180
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 1
EQI4 $357
ADDRLP4 180
INDIRI4
CNSTI4 3
NEI4 $355
LABELV $357
line 715
;715:		item->giType == IT_ARMOR ) {
line 716
;716:		ent.renderfx |= RF_MINLIGHT;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 717
;717:	}
LABELV $355
line 720
;718:
;719:	// increase the size of weapon pickup models
;720:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $359
line 721
;721:		VectorScale(
ADDRLP4 0+28
CNSTF4 1069547520
ADDRLP4 0+28
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+4
CNSTF4 1069547520
ADDRLP4 0+28+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+8
CNSTF4 1069547520
ADDRLP4 0+28+8
INDIRF4
MULF4
ASGNF4
line 726
;722:			ent.axis[0],
;723:			1.5f,
;724:			ent.axis[0]
;725:		);
;726:		VectorScale(
ADDRLP4 0+28+12
CNSTF4 1069547520
ADDRLP4 0+28+12
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+12+4
CNSTF4 1069547520
ADDRLP4 0+28+12+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+12+8
CNSTF4 1069547520
ADDRLP4 0+28+12+8
INDIRF4
MULF4
ASGNF4
line 731
;727:			ent.axis[1],
;728:			1.5f,
;729:			ent.axis[1]
;730:		);
;731:		VectorScale(
ADDRLP4 0+28+24
CNSTF4 1069547520
ADDRLP4 0+28+24
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+24+4
CNSTF4 1069547520
ADDRLP4 0+28+24+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+24+8
CNSTF4 1069547520
ADDRLP4 0+28+24+8
INDIRF4
MULF4
ASGNF4
line 737
;732:			ent.axis[2],
;733:			1.5f,
;734:			ent.axis[2]
;735:		);
;736:
;737:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 749
;738:
;739:#ifdef MISSIONPACK
;740:		if( !cg_staticItems.integer ) {
;741:			trap_S_AddLoopingSound(
;742:				cent->currentState.number,
;743:				cent->lerpOrigin,
;744:				vec3_origin,
;745:				cgs.media.weaponHoverSound
;746:			);
;747:		}
;748:#endif
;749:	}
LABELV $359
line 775
;750:
;751:#ifdef MISSIONPACK
;752:	if( item->giType == IT_HOLDABLE &&
;753:		item->giTag == HI_KAMIKAZE ) {
;754:		VectorScale(
;755:			ent.axis[0],
;756:			2,
;757:			ent.axis[0]
;758:		);
;759:		VectorScale(
;760:			ent.axis[1],
;761:			2,
;762:			ent.axis[1]
;763:		);
;764:		VectorScale(
;765:			ent.axis[2],
;766:			2,
;767:			ent.axis[2]
;768:		);
;769:
;770:		ent.nonNormalizedAxes = qtrue;
;771:	}
;772:#endif
;773:
;774:	// add main model
;775:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 822
;776:
;777:#ifdef MISSIONPACK
;778:	if( item->giType == IT_WEAPON &&
;779:		wi->barrelModel ) {
;780:		refEntity_t barrel;
;781:
;782:		memset(
;783:			&barrel,
;784:			0,
;785:			sizeof(barrel)
;786:		);
;787:
;788:		barrel.hModel = wi->barrelModel;
;789:
;790:		VectorCopy(
;791:			ent.lightingOrigin,
;792:			barrel.lightingOrigin
;793:		);
;794:
;795:		barrel.shadowPlane =
;796:			ent.shadowPlane;
;797:		barrel.renderfx =
;798:			ent.renderfx;
;799:
;800:		CG_PositionRotatedEntityOnTag(
;801:			&barrel,
;802:			&ent,
;803:			wi->weaponModel,
;804:			"tag_barrel"
;805:		);
;806:
;807:		AxisCopy(
;808:			ent.axis,
;809:			barrel.axis
;810:		);
;811:
;812:		barrel.nonNormalizedAxes =
;813:			ent.nonNormalizedAxes;
;814:
;815:		trap_R_AddRefEntityToScene(
;816:			&barrel
;817:		);
;818:	}
;819:#endif
;820:
;821:	// accompanying rings and spheres for powerups
;822:	if( !cg_simpleItems.integer ) {
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
NEI4 $404
line 825
;823:		vec3_t spinAngles;
;824:
;825:		VectorClear( spinAngles );
ADDRLP4 196
CNSTF4 0
ASGNF4
ADDRLP4 184+8
ADDRLP4 196
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 196
INDIRF4
ASGNF4
ADDRLP4 184
ADDRLP4 196
INDIRF4
ASGNF4
line 827
;826:
;827:		if( item->giType == IT_HEALTH ||
ADDRLP4 200
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 200
INDIRI4
CNSTI4 4
EQI4 $411
ADDRLP4 200
INDIRI4
CNSTI4 5
NEI4 $409
LABELV $411
line 828
;828:			item->giType == IT_POWERUP ) {
line 829
;829:			ent.hModel =
ADDRLP4 0+8
CNSTI4 24
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_items+4+4
ADDP4
INDIRI4
ASGNI4
line 834
;830:				cg_items[
;831:					es->modelindex
;832:				].models[1];
;833:
;834:			if( ent.hModel ) {
ADDRLP4 0+8
INDIRI4
CNSTI4 0
EQI4 $415
line 835
;835:				if( item->giType ==
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $418
line 836
;836:					IT_POWERUP ) {
line 837
;837:					ent.origin[2] += 12;
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
CNSTF4 1094713344
ADDF4
ASGNF4
line 839
;838:
;839:					if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $422
line 840
;840:						spinAngles[1] =
ADDRLP4 184+4
CNSTI4 360
ADDRGP4 cg+107604
INDIRI4
CNSTI4 1023
BANDI4
MULI4
CVIF4 4
CNSTF4 3296722944
DIVF4
ASGNF4
line 844
;841:							(cg.time & 1023) *
;842:							360 /
;843:							-1024.0f;
;844:					}
LABELV $422
line 845
;845:				}
LABELV $418
line 847
;846:
;847:				AnglesToAxis(
ADDRLP4 184
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 852
;848:					spinAngles,
;849:					ent.axis
;850:				);
;851:
;852:				if( frac != 1.0f ) {
ADDRLP4 148
INDIRF4
CNSTF4 1065353216
EQF4 $428
line 853
;853:					VectorScale(
ADDRLP4 0+28
ADDRLP4 0+28
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+4
ADDRLP4 0+28+4
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+8
ADDRLP4 0+28+8
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
line 858
;854:						ent.axis[0],
;855:						frac,
;856:						ent.axis[0]
;857:					);
;858:					VectorScale(
ADDRLP4 0+28+12
ADDRLP4 0+28+12
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+12+4
ADDRLP4 0+28+12+4
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+12+8
ADDRLP4 0+28+12+8
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
line 863
;859:						ent.axis[1],
;860:						frac,
;861:						ent.axis[1]
;862:					);
;863:					VectorScale(
ADDRLP4 0+28+24
ADDRLP4 0+28+24
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+24+4
ADDRLP4 0+28+24+4
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+28+24+8
ADDRLP4 0+28+24+8
INDIRF4
ADDRLP4 148
INDIRF4
MULF4
ASGNF4
line 869
;864:						ent.axis[2],
;865:						frac,
;866:						ent.axis[2]
;867:					);
;868:
;869:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 871
;870:						qtrue;
;871:				}
ADDRGP4 $429
JUMPV
LABELV $428
line 872
;872:				else {
line 873
;873:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 875
;874:						qfalse;
;875:				}
LABELV $429
line 877
;876:
;877:				trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 880
;878:					&ent
;879:				);
;880:			}
LABELV $415
line 881
;881:		}
LABELV $409
line 882
;882:	}
LABELV $404
line 883
;883:}
LABELV $243
endproc CG_Item 204 12
proc CG_Missile 172 20
line 892
;884:
;885://============================================================================
;886:
;887:/*
;888:===============
;889:CG_Missile
;890:===============
;891:*/
;892:static void CG_Missile( centity_t *cent ) {
line 898
;893:	refEntity_t			ent;
;894:	entityState_t		*s1;
;895:	const weaponInfo_t		*weapon;
;896://	int	col;
;897:
;898:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 899
;899:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $475
line 900
;900:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 901
;901:	}
LABELV $475
line 906
;902:	/*
;903:	 * Lazy weapon registration: monster projectiles may
;904:	 * arrive for a weapon the local player never picked up
;905:	 */
;906:	if ( s1->weapon > WP_NONE &&
ADDRLP4 148
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ASGNI4
ADDRLP4 152
CNSTI4 0
ASGNI4
ADDRLP4 148
INDIRI4
ADDRLP4 152
INDIRI4
LEI4 $477
ADDRLP4 148
INDIRI4
CNSTI4 12
GEI4 $477
CNSTI4 136
ADDRLP4 148
INDIRI4
MULI4
ADDRGP4 cg_weapons+80
ADDP4
INDIRI4
ADDRLP4 152
INDIRI4
NEI4 $477
line 908
;907:		s1->weapon < WP_NUM_WEAPONS &&
;908:		!cg_weapons[s1->weapon].missileModel ) {
line 909
;909:		CG_RegisterWeapon( s1->weapon );
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_RegisterWeapon
CALLV
pop
line 910
;910:	}
LABELV $477
line 912
;911:
;912:	weapon = &cg_weapons[s1->weapon];
ADDRLP4 144
CNSTI4 136
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons
ADDP4
ASGNP4
line 915
;913:
;914:	// calculate the axis
;915:	VectorCopy( s1->angles, cent->lerpAngles);
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRLP4 140
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 918
;916:
;917:	// add trails
;918:	if ( weapon->missileTrailFunc ) 
ADDRLP4 144
INDIRP4
CNSTI4 88
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $480
line 919
;919:	{
line 920
;920:		weapon->missileTrailFunc( cent, weapon );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
CNSTI4 88
ADDP4
INDIRP4
CALLV
pop
line 921
;921:	}
LABELV $480
line 940
;922:/*
;923:	if ( cent->currentState.modelindex == TEAM_RED ) {
;924:		col = 1;
;925:	}
;926:	else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;927:		col = 2;
;928:	}
;929:	else {
;930:		col = 0;
;931:	}
;932:
;933:	// add dynamic light
;934:	if ( weapon->missileDlight ) {
;935:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
;936:			weapon->missileDlightColor[col][0], weapon->missileDlightColor[col][1], weapon->missileDlightColor[col][2] );
;937:	}
;938:*/
;939:	// add dynamic light
;940:	if ( weapon->missileDlight ) {
ADDRLP4 144
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
CNSTF4 0
EQF4 $482
line 941
;941:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 144
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ARGF4
ADDRLP4 144
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ARGF4
ADDRLP4 144
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ARGF4
ADDRLP4 144
INDIRP4
CNSTI4 104
ADDP4
INDIRF4
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 943
;942:			weapon->missileDlightColor[0], weapon->missileDlightColor[1], weapon->missileDlightColor[2] );
;943:	}
LABELV $482
line 946
;944:
;945:	// add missile sound
;946:	if ( weapon->missileSound ) {
ADDRLP4 144
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 0
EQI4 $484
line 949
;947:		vec3_t	velocity;
;948:
;949:		BG_EvaluateTrajectoryDelta( &cent->currentState.pos, cg.time, velocity );
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 156
ARGP4
ADDRGP4 BG_EvaluateTrajectoryDelta
CALLV
pop
line 951
;950:
;951:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, velocity, weapon->missileSound );
ADDRLP4 168
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 168
INDIRP4
INDIRI4
ARGI4
ADDRLP4 168
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 156
ARGP4
ADDRLP4 144
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_AddLoopingSound
CALLV
pop
line 952
;952:	}
LABELV $484
line 955
;953:
;954:	// create the render entity
;955:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 956
;956:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 957
;957:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 959
;958:
;959:	if ( cent->currentState.weapon == WP_PLASMAGUN ) {
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 8
NEI4 $489
line 960
;960:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 961
;961:		ent.radius = 16;
ADDRLP4 0+132
CNSTF4 1098907648
ASGNF4
line 962
;962:		ent.rotation = 0;
ADDRLP4 0+136
CNSTF4 0
ASGNF4
line 963
;963:		ent.customShader = cgs.media.plasmaBallShader;
ADDRLP4 0+112
ADDRGP4 cgs+152340+288
INDIRI4
ASGNI4
line 964
;964:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 965
;965:		return;
ADDRGP4 $474
JUMPV
LABELV $489
line 969
;966:	}
;967:
;968:	// flicker between two skins
;969:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 970
;970:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 971
;971:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 982
;972:
;973:#ifdef MISSIONPACK
;974:	if ( cent->currentState.weapon == WP_PROX_LAUNCHER ) {
;975:		if (s1->generic1 == TEAM_BLUE) {
;976:			ent.hModel = cgs.media.blueProxMine;
;977:		}
;978:	}
;979:#endif
;980:
;981:	// convert direction of travel into axis
;982:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
ARGP4
ADDRLP4 0+28
ARGP4
ADDRLP4 156
ADDRGP4 VectorNormalize2
CALLF4
ASGNF4
ADDRLP4 156
INDIRF4
CNSTF4 0
NEF4 $499
line 983
;983:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 984
;984:	}
LABELV $499
line 987
;985:
;986:	// spin as it moves
;987:	if ( s1->pos.trType != TR_STATIONARY ) {
ADDRLP4 140
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 0
EQI4 $504
line 988
;988:		RotateAroundDirection( ent.axis, cg.time / 4 );
ADDRLP4 0+28
ARGP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 4
DIVI4
CVIF4 4
ARGF4
ADDRGP4 RotateAroundDirection
CALLV
pop
line 989
;989:	} else {
ADDRGP4 $505
JUMPV
LABELV $504
line 996
;990:#ifdef MISSIONPACK
;991:		if ( s1->weapon == WP_PROX_LAUNCHER ) {
;992:			AnglesToAxis( cent->lerpAngles, ent.axis );
;993:		}
;994:		else
;995:#endif
;996:		{
line 997
;997:			RotateAroundDirection( ent.axis, s1->time );
ADDRLP4 0+28
ARGP4
ADDRLP4 140
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 RotateAroundDirection
CALLV
pop
line 998
;998:		}
line 999
;999:	}
LABELV $505
line 1002
;1000:
;1001:	// add to refresh list, possibly with quad glow
;1002:	CG_AddRefEntityWithPowerups( &ent, s1, TEAM_FREE );
ADDRLP4 0
ARGP4
ADDRLP4 140
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 CG_AddRefEntityWithPowerups
CALLV
pop
line 1003
;1003:}
LABELV $474
endproc CG_Missile 172 20
proc CG_Grapple 152 12
line 1012
;1004:
;1005:/*
;1006:===============
;1007:CG_Grapple
;1008:
;1009:This is called when the grapple is sitting up against the wall
;1010:===============
;1011:*/
;1012:static void CG_Grapple( centity_t *cent ) {
line 1017
;1013:	refEntity_t			ent;
;1014:	entityState_t		*s1;
;1015:	const weaponInfo_t		*weapon;
;1016:
;1017:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1018
;1018:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $510
line 1019
;1019:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 1020
;1020:	}
LABELV $510
line 1021
;1021:	weapon = &cg_weapons[s1->weapon];
ADDRLP4 144
CNSTI4 136
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons
ADDP4
ASGNP4
line 1024
;1022:
;1023:	// calculate the axis
;1024:	VectorCopy( s1->angles, cent->lerpAngles);
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRLP4 140
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 1034
;1025:
;1026:#if 0 // FIXME add grapple pull sound here..?
;1027:	// add missile sound
;1028:	if ( weapon->missileSound ) {
;1029:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, weapon->missileSound );
;1030:	}
;1031:#endif
;1032:
;1033:	// Will draw cable if needed
;1034:	CG_GrappleTrail ( cent, weapon );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRGP4 CG_GrappleTrail
CALLV
pop
line 1037
;1035:
;1036:	// create the render entity
;1037:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1038
;1038:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1039
;1039:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1042
;1040:
;1041:	// flicker between two skins
;1042:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 1043
;1043:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 1044
;1044:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 1047
;1045:
;1046:	// convert direction of travel into axis
;1047:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
ARGP4
ADDRLP4 0+28
ARGP4
ADDRLP4 148
ADDRGP4 VectorNormalize2
CALLF4
ASGNF4
ADDRLP4 148
INDIRF4
CNSTF4 0
NEF4 $517
line 1048
;1048:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 1049
;1049:	}
LABELV $517
line 1051
;1050:
;1051:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1052
;1052:}
LABELV $509
endproc CG_Grapple 152 12
proc CG_Mover 144 12
line 1059
;1053:
;1054:/*
;1055:===============
;1056:CG_Mover
;1057:===============
;1058:*/
;1059:static void CG_Mover( centity_t *cent ) {
line 1063
;1060:	refEntity_t			ent;
;1061:	entityState_t		*s1;
;1062:
;1063:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1066
;1064:
;1065:	// create the render entity
;1066:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1067
;1067:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1068
;1068:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1069
;1069:	AnglesToAxis( cent->lerpAngles, ent.axis );
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1071
;1070:
;1071:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 1074
;1072:
;1073:	// flicker between two skins (FIXME?)
;1074:	ent.skinNum = ( cg.time >> 6 ) & 1;
ADDRLP4 0+104
ADDRGP4 cg+107604
INDIRI4
CNSTI4 6
RSHI4
CNSTI4 1
BANDI4
ASGNI4
line 1077
;1075:
;1076:	// get the model, either as a bmodel or a modelindex
;1077:	if ( s1->solid == SOLID_BMODEL ) {
ADDRLP4 140
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
NEI4 $529
line 1078
;1078:		ent.hModel = cgs.inlineDrawModel[s1->modelindex];
ADDRLP4 0+8
ADDRLP4 140
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+36876
ADDP4
INDIRI4
ASGNI4
line 1079
;1079:	} else {
ADDRGP4 $530
JUMPV
LABELV $529
line 1080
;1080:		ent.hModel = cgs.gameModels[s1->modelindex];
ADDRLP4 0+8
ADDRLP4 140
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+34824
ADDP4
INDIRI4
ASGNI4
line 1081
;1081:	}
LABELV $530
line 1084
;1082:
;1083:	// add to refresh list
;1084:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1087
;1085:
;1086:	// add the secondary model
;1087:	if ( s1->modelindex2 ) {
ADDRLP4 140
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $535
line 1088
;1088:		ent.skinNum = 0;
ADDRLP4 0+104
CNSTI4 0
ASGNI4
line 1089
;1089:		ent.hModel = cgs.gameModels[s1->modelindex2];
ADDRLP4 0+8
ADDRLP4 140
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+34824
ADDP4
INDIRI4
ASGNI4
line 1090
;1090:		trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1091
;1091:	}
LABELV $535
line 1093
;1092:
;1093:}
LABELV $522
endproc CG_Mover 144 12
export CG_Beam
proc CG_Beam 144 12
line 1102
;1094:
;1095:/*
;1096:===============
;1097:CG_Beam
;1098:
;1099:Also called as an event
;1100:===============
;1101:*/
;1102:void CG_Beam( centity_t *cent ) {
line 1106
;1103:	refEntity_t			ent;
;1104:	entityState_t		*s1;
;1105:
;1106:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1109
;1107:
;1108:	// create the render entity
;1109:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1110
;1110:	VectorCopy( s1->pos.trBase, ent.origin );
ADDRLP4 0+68
ADDRLP4 140
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
line 1111
;1111:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1112
;1112:	AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 1113
;1113:	ent.reType = RT_BEAM;
ADDRLP4 0
CNSTI4 3
ASGNI4
line 1115
;1114:
;1115:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 1118
;1116:
;1117:	// add to refresh list
;1118:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1119
;1119:}
LABELV $540
endproc CG_Beam 144 12
proc CG_Portal 144 12
line 1127
;1120:
;1121:
;1122:/*
;1123:===============
;1124:CG_Portal
;1125:===============
;1126:*/
;1127:static void CG_Portal( centity_t *cent ) {
line 1131
;1128:	refEntity_t			ent;
;1129:	entityState_t		*s1;
;1130:
;1131:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1134
;1132:
;1133:	// create the render entity
;1134:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1135
;1135:	VectorCopy( cent->lerpOrigin, ent.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1136
;1136:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1137
;1137:	ByteToDir( s1->eventParm, ent.axis[0] );
ADDRLP4 140
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 0+28
ARGP4
ADDRGP4 ByteToDir
CALLV
pop
line 1138
;1138:	PerpendicularVector( ent.axis[1], ent.axis[0] );
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 1142
;1139:
;1140:	// negating this tends to get the directions like they want
;1141:	// we really should have a camera roll value
;1142:	VectorSubtract( vec3_origin, ent.axis[1], ent.axis[1] );
ADDRLP4 0+28+12
ADDRGP4 vec3_origin
INDIRF4
ADDRLP4 0+28+12
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+28+12+4
ADDRGP4 vec3_origin+4
INDIRF4
ADDRLP4 0+28+12+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+28+12+8
ADDRGP4 vec3_origin+8
INDIRF4
ADDRLP4 0+28+12+8
INDIRF4
SUBF4
ASGNF4
line 1144
;1143:
;1144:	CrossProduct( ent.axis[0], ent.axis[1], ent.axis[2] );
ADDRLP4 0+28
ARGP4
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28+24
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 1145
;1145:	ent.reType = RT_PORTALSURFACE;
ADDRLP4 0
CNSTI4 7
ASGNI4
line 1146
;1146:	ent.oldframe = s1->powerups;
ADDRLP4 0+96
ADDRLP4 140
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
ASGNI4
line 1147
;1147:	ent.frame = s1->frame;		// rotation speed
ADDRLP4 0+80
ADDRLP4 140
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 1148
;1148:	ent.skinNum = s1->clientNum/256.0 * 360;	// roll offset
ADDRLP4 0+104
CNSTF4 1135869952
ADDRLP4 140
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
CVIF4 4
CNSTF4 1132462080
DIVF4
MULF4
CVFI4 4
ASGNI4
line 1151
;1149:
;1150:	// add to refresh list
;1151:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1152
;1152:}
LABELV $545
endproc CG_Portal 144 12
export CG_AdjustPositionForMover
proc CG_AdjustPositionForMover 92 12
line 1162
;1153:
;1154:
;1155:/*
;1156:=========================
;1157:CG_AdjustPositionForMover
;1158:
;1159:Also called by client movement prediction code
;1160:=========================
;1161:*/
;1162:void CG_AdjustPositionForMover( const vec3_t in, int moverNum, int fromTime, int toTime, vec3_t out ) {
line 1167
;1163:	centity_t	*cent;
;1164:	vec3_t	oldOrigin, origin, deltaOrigin;
;1165:	vec3_t	oldAngles, angles, deltaAngles;
;1166:
;1167:	if ( moverNum <= 0 || moverNum >= ENTITYNUM_MAX_NORMAL ) {
ADDRLP4 76
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
LEI4 $581
ADDRLP4 76
INDIRI4
CNSTI4 1022
LTI4 $579
LABELV $581
line 1168
;1168:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1169
;1169:		return;
ADDRGP4 $578
JUMPV
LABELV $579
line 1172
;1170:	}
;1171:
;1172:	cent = &cg_entities[ moverNum ];
ADDRLP4 0
CNSTI4 728
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 1173
;1173:	if ( cent->currentState.eType != ET_MOVER ) {
ADDRLP4 80
CNSTI4 4
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
INDIRI4
ADDRLP4 80
INDIRI4
EQI4 $582
line 1174
;1174:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1175
;1175:		return;
ADDRGP4 $578
JUMPV
LABELV $582
line 1178
;1176:	}
;1177:
;1178:	BG_EvaluateTrajectory( &cent->currentState.pos, fromTime, oldOrigin );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1179
;1179:	BG_EvaluateTrajectory( &cent->currentState.apos, fromTime, oldAngles );
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRLP4 40
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1181
;1180:
;1181:	BG_EvaluateTrajectory( &cent->currentState.pos, toTime, origin );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRFP4 12
INDIRI4
ARGI4
ADDRLP4 28
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1182
;1182:	BG_EvaluateTrajectory( &cent->currentState.apos, toTime, angles );
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ARGP4
ADDRFP4 12
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1184
;1183:
;1184:	VectorSubtract( origin, oldOrigin, deltaOrigin );
ADDRLP4 4
ADDRLP4 28
INDIRF4
ADDRLP4 16
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 28+4
INDIRF4
ADDRLP4 16+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 28+8
INDIRF4
ADDRLP4 16+8
INDIRF4
SUBF4
ASGNF4
line 1185
;1185:	VectorSubtract( angles, oldAngles, deltaAngles );
ADDRLP4 64
ADDRLP4 52
INDIRF4
ADDRLP4 40
INDIRF4
SUBF4
ASGNF4
ADDRLP4 64+4
ADDRLP4 52+4
INDIRF4
ADDRLP4 40+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 64+8
ADDRLP4 52+8
INDIRF4
ADDRLP4 40+8
INDIRF4
SUBF4
ASGNF4
line 1187
;1186:
;1187:	VectorAdd( in, deltaOrigin, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRF4
ADDRLP4 4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 84
CNSTI4 4
ASGNI4
ADDRFP4 16
INDIRP4
ADDRLP4 84
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 84
INDIRI4
ADDP4
INDIRF4
ADDRLP4 4+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 88
CNSTI4 8
ASGNI4
ADDRFP4 16
INDIRP4
ADDRLP4 88
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 88
INDIRI4
ADDP4
INDIRF4
ADDRLP4 4+8
INDIRF4
ADDF4
ASGNF4
line 1190
;1188:
;1189:	// FIXME: origin change when on a rotating object
;1190:}
LABELV $578
endproc CG_AdjustPositionForMover 92 12
proc CG_InterpolateEntityPosition 44 12
line 1198
;1191:
;1192:
;1193:/*
;1194:=============================
;1195:CG_InterpolateEntityPosition
;1196:=============================
;1197:*/
;1198:static void CG_InterpolateEntityPosition( centity_t *cent ) {
line 1204
;1199:	vec3_t		current, next;
;1200:	float		f;
;1201:
;1202:	// it would be an internal error to find an entity that interpolates without
;1203:	// a snapshot ahead of the current one
;1204:	if ( cg.nextSnap == NULL ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $599
line 1205
;1205:		CG_Error( "CG_InterpoateEntityPosition: cg.nextSnap == NULL" );
ADDRGP4 $602
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 1206
;1206:	}
LABELV $599
line 1208
;1207:
;1208:	f = cg.frameInterpolation;
ADDRLP4 24
ADDRGP4 cg+107588
INDIRF4
ASGNF4
line 1212
;1209:
;1210:	// this will linearize a sine or parabolic curve, but it is important
;1211:	// to not extrapolate player positions if more recent data is available
;1212:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.snap->serverTime, current );
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1213
;1213:	BG_EvaluateTrajectory( &cent->nextState.pos, cg.nextSnap->serverTime, next );
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
ARGP4
ADDRGP4 cg+40
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1215
;1214:
;1215:	cent->lerpOrigin[0] = current[0] + f * ( next[0] - current[0] );
ADDRLP4 28
ADDRLP4 0
INDIRF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ADDRLP4 28
INDIRF4
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDRLP4 28
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 1216
;1216:	cent->lerpOrigin[1] = current[1] + f * ( next[1] - current[1] );
ADDRFP4 0
INDIRP4
CNSTI4 708
ADDP4
ADDRLP4 0+4
INDIRF4
ADDRLP4 24
INDIRF4
ADDRLP4 12+4
INDIRF4
ADDRLP4 0+4
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 1217
;1217:	cent->lerpOrigin[2] = current[2] + f * ( next[2] - current[2] );
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
ADDRLP4 0+8
INDIRF4
ADDRLP4 24
INDIRF4
ADDRLP4 12+8
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 1219
;1218:
;1219:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.snap->serverTime, current );
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1220
;1220:	BG_EvaluateTrajectory( &cent->nextState.apos, cg.nextSnap->serverTime, next );
ADDRFP4 0
INDIRP4
CNSTI4 256
ADDP4
ARGP4
ADDRGP4 cg+40
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1222
;1221:
;1222:	cent->lerpAngles[0] = LerpAngle( current[0], next[0], f );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRF4
ARGF4
ADDRLP4 32
ADDRGP4 LerpAngle
CALLF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRLP4 32
INDIRF4
ASGNF4
line 1223
;1223:	cent->lerpAngles[1] = LerpAngle( current[1], next[1], f );
ADDRLP4 0+4
INDIRF4
ARGF4
ADDRLP4 12+4
INDIRF4
ARGF4
ADDRLP4 24
INDIRF4
ARGF4
ADDRLP4 36
ADDRGP4 LerpAngle
CALLF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
line 1224
;1224:	cent->lerpAngles[2] = LerpAngle( current[2], next[2], f );
ADDRLP4 0+8
INDIRF4
ARGF4
ADDRLP4 12+8
INDIRF4
ARGF4
ADDRLP4 24
INDIRF4
ARGF4
ADDRLP4 40
ADDRGP4 LerpAngle
CALLF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 724
ADDP4
ADDRLP4 40
INDIRF4
ASGNF4
line 1226
;1225:
;1226:}
LABELV $598
endproc CG_InterpolateEntityPosition 44 12
proc CG_CalcEntityLerpPositions 24 20
line 1234
;1227:
;1228:/*
;1229:===============
;1230:CG_CalcEntityLerpPositions
;1231:
;1232:===============
;1233:*/
;1234:static void CG_CalcEntityLerpPositions( centity_t *cent ) {
line 1237
;1235:
;1236:	// if this player does not want to see extrapolated players
;1237:	if ( !cg_smoothClients.integer ) {
ADDRGP4 cg_smoothClients+12
INDIRI4
CNSTI4 0
NEI4 $619
line 1239
;1238:		// make sure the clients use TR_INTERPOLATE
;1239:		if ( cent->currentState.number < MAX_CLIENTS ) {
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $622
line 1240
;1240:			cent->currentState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 1241
;1241:			cent->nextState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
CNSTI4 1
ASGNI4
line 1242
;1242:		}
LABELV $622
line 1243
;1243:	}
LABELV $619
line 1245
;1244:
;1245:	if ( cent->interpolate && cent->currentState.pos.trType == TR_INTERPOLATE ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 416
ADDP4
INDIRI4
CNSTI4 0
EQI4 $624
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 1
NEI4 $624
line 1246
;1246:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1247
;1247:		return;
ADDRGP4 $618
JUMPV
LABELV $624
line 1252
;1248:	}
;1249:
;1250:	// first see if we can interpolate between two snaps for
;1251:	// linear extrapolated clients
;1252:	if ( cent->interpolate && cent->currentState.pos.trType == TR_LINEAR_STOP &&
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 416
ADDP4
INDIRI4
CNSTI4 0
EQI4 $626
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 3
NEI4 $626
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $626
line 1253
;1253:											cent->currentState.number < MAX_CLIENTS) {
line 1254
;1254:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1255
;1255:		return;
ADDRGP4 $618
JUMPV
LABELV $626
line 1259
;1256:	}
;1257:
;1258:	// just use the current frame and evaluate as best we can
;1259:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.time, cent->lerpOrigin );
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 8
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1260
;1260:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.time, cent->lerpAngles );
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 48
ADDP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1264
;1261:
;1262:	// adjust for riding a mover if it wasn't rolled into the predicted
;1263:	// player state
;1264:	if ( cent != &cg.predictedPlayerEntity ) {
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 cg+108104
CVPU4 4
EQU4 $630
line 1265
;1265:		CG_AdjustPositionForMover( cent->lerpOrigin, cent->currentState.groundEntityNum, 
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
ADDRLP4 16
INDIRP4
CNSTI4 704
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 16
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
ARGI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 CG_AdjustPositionForMover
CALLV
pop
line 1267
;1266:		cg.snap->serverTime, cg.time, cent->lerpOrigin );
;1267:	}
LABELV $630
line 1268
;1268:}
LABELV $618
endproc CG_CalcEntityLerpPositions 24 20
proc CG_TeamBase 140 12
line 1275
;1269:
;1270:/*
;1271:===============
;1272:CG_TeamBase
;1273:===============
;1274:*/
;1275:static void CG_TeamBase( centity_t *cent ) {
line 1284
;1276:	refEntity_t model;
;1277:#ifdef MISSIONPACK
;1278:	vec3_t angles;
;1279:	int t, h;
;1280:	float c;
;1281:
;1282:	if ( cgs.gametype == GT_CTF || cgs.gametype == GT_1FCTF ) {
;1283:#else
;1284:	if ( cgs.gametype == GT_CTF) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $636
line 1287
;1285:#endif
;1286:		// show the flag base
;1287:		memset(&model, 0, sizeof(model));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1288
;1288:		model.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1289
;1289:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1290
;1290:		VectorCopy( cent->lerpOrigin, model.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1291
;1291:		AnglesToAxis( cent->currentState.angles, model.axis );
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1292
;1292:		if ( cent->currentState.modelindex == TEAM_RED ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $642
line 1293
;1293:			model.hModel = cgs.media.redFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+108
INDIRI4
ASGNI4
line 1294
;1294:		}
ADDRGP4 $643
JUMPV
LABELV $642
line 1295
;1295:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
NEI4 $647
line 1296
;1296:			model.hModel = cgs.media.blueFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+112
INDIRI4
ASGNI4
line 1297
;1297:		}
ADDRGP4 $648
JUMPV
LABELV $647
line 1298
;1298:		else {
line 1299
;1299:			model.hModel = cgs.media.neutralFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+116
INDIRI4
ASGNI4
line 1300
;1300:		}
LABELV $648
LABELV $643
line 1301
;1301:		trap_R_AddRefEntityToScene( &model );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1302
;1302:	}
LABELV $636
line 1421
;1303:#ifdef MISSIONPACK
;1304:	else if ( cgs.gametype == GT_OBELISK ) {
;1305:		// show the obelisk
;1306:		memset(&model, 0, sizeof(model));
;1307:		model.reType = RT_MODEL;
;1308:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1309:		VectorCopy( cent->lerpOrigin, model.origin );
;1310:		AnglesToAxis( cent->currentState.angles, model.axis );
;1311:
;1312:		model.hModel = cgs.media.overloadBaseModel;
;1313:		trap_R_AddRefEntityToScene( &model );
;1314:		// if hit
;1315:		if ( cent->currentState.frame == 1) {
;1316:			// show hit model
;1317:			// modelindex2 is the health value of the obelisk
;1318:			c = cent->currentState.modelindex2;
;1319:			model.shaderRGBA[0] = 0xff;
;1320:			model.shaderRGBA[1] = c;
;1321:			model.shaderRGBA[2] = c;
;1322:			model.shaderRGBA[3] = 0xff;
;1323:			//
;1324:			model.hModel = cgs.media.overloadEnergyModel;
;1325:			trap_R_AddRefEntityToScene( &model );
;1326:		}
;1327:		// if respawning
;1328:		if ( cent->currentState.frame == 2) {
;1329:			if ( !cent->miscTime ) {
;1330:				cent->miscTime = cg.time;
;1331:			}
;1332:			t = cg.time - cent->miscTime;
;1333:			h = (cg_obeliskRespawnDelay.integer - 5) * 1000;
;1334:			//
;1335:			if (t > h) {
;1336:				c = (float) (t - h) / h;
;1337:				if (c > 1)
;1338:					c = 1;
;1339:			}
;1340:			else {
;1341:				c = 0;
;1342:			}
;1343:			// show the lights
;1344:			AnglesToAxis( cent->currentState.angles, model.axis );
;1345:			//
;1346:			model.shaderRGBA[0] = c * 0xff;
;1347:			model.shaderRGBA[1] = c * 0xff;
;1348:			model.shaderRGBA[2] = c * 0xff;
;1349:			model.shaderRGBA[3] = c * 0xff;
;1350:
;1351:			model.hModel = cgs.media.overloadLightsModel;
;1352:			trap_R_AddRefEntityToScene( &model );
;1353:			// show the target
;1354:			if (t > h) {
;1355:				if ( !cent->muzzleFlashTime ) {
;1356:					trap_S_StartSound (cent->lerpOrigin, ENTITYNUM_NONE, CHAN_BODY,  cgs.media.obeliskRespawnSound);
;1357:					cent->muzzleFlashTime = 1;
;1358:				}
;1359:				VectorCopy(cent->currentState.angles, angles);
;1360:				angles[YAW] += (float) 16 * acos(1-c) * 180 / M_PI;
;1361:				AnglesToAxis( angles, model.axis );
;1362:
;1363:				VectorScale( model.axis[0], c, model.axis[0]);
;1364:				VectorScale( model.axis[1], c, model.axis[1]);
;1365:				VectorScale( model.axis[2], c, model.axis[2]);
;1366:
;1367:				model.shaderRGBA[0] = 0xff;
;1368:				model.shaderRGBA[1] = 0xff;
;1369:				model.shaderRGBA[2] = 0xff;
;1370:				model.shaderRGBA[3] = 0xff;
;1371:				//
;1372:				model.origin[2] += 56;
;1373:				model.hModel = cgs.media.overloadTargetModel;
;1374:				trap_R_AddRefEntityToScene( &model );
;1375:			}
;1376:			else {
;1377:				//FIXME: show animated smoke
;1378:			}
;1379:		}
;1380:		else {
;1381:			cent->miscTime = 0;
;1382:			cent->muzzleFlashTime = 0;
;1383:			// modelindex2 is the health value of the obelisk
;1384:			c = cent->currentState.modelindex2;
;1385:			model.shaderRGBA[0] = 0xff;
;1386:			model.shaderRGBA[1] = c;
;1387:			model.shaderRGBA[2] = c;
;1388:			model.shaderRGBA[3] = 0xff;
;1389:			// show the lights
;1390:			model.hModel = cgs.media.overloadLightsModel;
;1391:			trap_R_AddRefEntityToScene( &model );
;1392:			// show the target
;1393:			model.origin[2] += 56;
;1394:			model.hModel = cgs.media.overloadTargetModel;
;1395:			trap_R_AddRefEntityToScene( &model );
;1396:		}
;1397:	}
;1398:	else if ( cgs.gametype == GT_HARVESTER ) {
;1399:		// show harvester model
;1400:		memset(&model, 0, sizeof(model));
;1401:		model.reType = RT_MODEL;
;1402:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1403:		VectorCopy( cent->lerpOrigin, model.origin );
;1404:		AnglesToAxis( cent->currentState.angles, model.axis );
;1405:
;1406:		if ( cent->currentState.modelindex == TEAM_RED ) {
;1407:			model.hModel = cgs.media.harvesterModel;
;1408:			model.customSkin = cgs.media.harvesterRedSkin;
;1409:		}
;1410:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;1411:			model.hModel = cgs.media.harvesterModel;
;1412:			model.customSkin = cgs.media.harvesterBlueSkin;
;1413:		}
;1414:		else {
;1415:			model.hModel = cgs.media.harvesterNeutralModel;
;1416:			model.customSkin = 0;
;1417:		}
;1418:		trap_R_AddRefEntityToScene( &model );
;1419:	}
;1420:#endif
;1421:}
LABELV $635
endproc CG_TeamBase 140 12
proc CG_AddCEntity 8 8
line 1429
;1422:
;1423:/*
;1424:===============
;1425:CG_AddCEntity
;1426:
;1427:===============
;1428:*/
;1429:static void CG_AddCEntity( centity_t *cent ) {
line 1431
;1430:	// event-only entities will have been dealt with already
;1431:	if ( cent->currentState.eType >= ET_EVENTS ) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 14
LTI4 $656
line 1432
;1432:		return;
ADDRGP4 $655
JUMPV
LABELV $656
line 1436
;1433:	}
;1434:
;1435:	// calculate the current origin
;1436:	CG_CalcEntityLerpPositions( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CalcEntityLerpPositions
CALLV
pop
line 1439
;1437:
;1438:	// add automatic effects
;1439:	CG_EntityEffects( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_EntityEffects
CALLV
pop
line 1441
;1440:
;1441:	switch ( cent->currentState.eType ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $658
ADDRLP4 0
INDIRI4
CNSTI4 13
GTI4 $658
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $674
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $674
address $663
address $664
address $665
address $666
address $667
address $668
address $669
address $670
address $659
address $659
address $659
address $671
address $672
address $673
code
LABELV $658
line 1443
;1442:	default:
;1443:		CG_Error( "Bad entity type: %i\n", cent->currentState.eType );
ADDRGP4 $661
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 1444
;1444:		break;
ADDRGP4 $659
JUMPV
line 1448
;1445:	case ET_INVISIBLE:
;1446:	case ET_PUSH_TRIGGER:
;1447:	case ET_TELEPORT_TRIGGER:
;1448:		break;
LABELV $663
line 1450
;1449:	case ET_GENERAL:
;1450:		CG_General( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_General
CALLV
pop
line 1451
;1451:		break;
ADDRGP4 $659
JUMPV
LABELV $664
line 1453
;1452:	case ET_PLAYER:
;1453:		CG_Player( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Player
CALLV
pop
line 1454
;1454:		break;
ADDRGP4 $659
JUMPV
LABELV $665
line 1456
;1455:	case ET_ITEM:
;1456:		CG_Item( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Item
CALLV
pop
line 1457
;1457:		break;
ADDRGP4 $659
JUMPV
LABELV $666
line 1459
;1458:	case ET_MISSILE:
;1459:		CG_Missile( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Missile
CALLV
pop
line 1460
;1460:		break;
ADDRGP4 $659
JUMPV
LABELV $667
line 1462
;1461:	case ET_MOVER:
;1462:		CG_Mover( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Mover
CALLV
pop
line 1463
;1463:		break;
ADDRGP4 $659
JUMPV
LABELV $668
line 1465
;1464:	case ET_BEAM:
;1465:		CG_Beam( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Beam
CALLV
pop
line 1466
;1466:		break;
ADDRGP4 $659
JUMPV
LABELV $669
line 1468
;1467:	case ET_PORTAL:
;1468:		CG_Portal( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Portal
CALLV
pop
line 1469
;1469:		break;
ADDRGP4 $659
JUMPV
LABELV $670
line 1471
;1470:	case ET_SPEAKER:
;1471:		CG_Speaker( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Speaker
CALLV
pop
line 1472
;1472:		break;
ADDRGP4 $659
JUMPV
LABELV $671
line 1474
;1473:	case ET_GRAPPLE:
;1474:		CG_Grapple( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Grapple
CALLV
pop
line 1475
;1475:		break;
ADDRGP4 $659
JUMPV
LABELV $672
line 1477
;1476:	case ET_TEAM:
;1477:		CG_TeamBase( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_TeamBase
CALLV
pop
line 1478
;1478:		break;
ADDRGP4 $659
JUMPV
LABELV $673
line 1480
;1479:	case ET_MONSTER:
;1480:		CG_Monster(cent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Monster
CALLV
pop
line 1481
;1481:		break;	
LABELV $659
line 1483
;1482:	}
;1483:}
LABELV $655
endproc CG_AddCEntity 8 8
export CG_AddPacketEntities
proc CG_AddPacketEntities 20 12
line 1491
;1484:
;1485:/*
;1486:===============
;1487:CG_AddPacketEntities
;1488:
;1489:===============
;1490:*/
;1491:void CG_AddPacketEntities( void ) {
line 1497
;1492:	int					num;
;1493:	centity_t			*cent;
;1494:	playerState_t		*ps;
;1495:
;1496:	// set cg.frameInterpolation
;1497:	if ( cg.nextSnap ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $676
line 1500
;1498:		int		delta;
;1499:
;1500:		delta = (cg.nextSnap->serverTime - cg.snap->serverTime);
ADDRLP4 16
CNSTI4 8
ASGNI4
ADDRLP4 12
ADDRGP4 cg+40
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
SUBI4
ASGNI4
line 1501
;1501:		if ( delta == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $681
line 1502
;1502:			cg.frameInterpolation = 0;
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1503
;1503:		} else {
ADDRGP4 $677
JUMPV
LABELV $681
line 1504
;1504:			cg.frameInterpolation = (float)( cg.time - cg.snap->serverTime ) / delta;
ADDRGP4 cg+107588
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 12
INDIRI4
CVIF4 4
DIVF4
ASGNF4
line 1505
;1505:		}
line 1506
;1506:	} else {
ADDRGP4 $677
JUMPV
LABELV $676
line 1507
;1507:		cg.frameInterpolation = 0;	// actually, it should never be used, because 
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1509
;1508:									// no entities should be marked as interpolating
;1509:	}
LABELV $677
line 1512
;1510:
;1511:	// the auto-rotating items will all have the same axis
;1512:	cg.autoAngles[0] = 0;
ADDRGP4 cg+108948
CNSTF4 0
ASGNF4
line 1513
;1513:	cg.autoAngles[1] = ( cg.time & 2047 ) * 360 / 2048.0;
ADDRGP4 cg+108948+4
CNSTI4 360
ADDRGP4 cg+107604
INDIRI4
CNSTI4 2047
BANDI4
MULI4
CVIF4 4
CNSTF4 1157627904
DIVF4
ASGNF4
line 1514
;1514:	cg.autoAngles[2] = 0;
ADDRGP4 cg+108948+8
CNSTF4 0
ASGNF4
line 1516
;1515:
;1516:	cg.autoAnglesFast[0] = 0;
ADDRGP4 cg+108996
CNSTF4 0
ASGNF4
line 1517
;1517:	cg.autoAnglesFast[1] = ( cg.time & 1023 ) * 360 / 1024.0f;
ADDRGP4 cg+108996+4
CNSTI4 360
ADDRGP4 cg+107604
INDIRI4
CNSTI4 1023
BANDI4
MULI4
CVIF4 4
CNSTF4 1149239296
DIVF4
ASGNF4
line 1518
;1518:	cg.autoAnglesFast[2] = 0;
ADDRGP4 cg+108996+8
CNSTF4 0
ASGNF4
line 1520
;1519:
;1520:	AnglesToAxis( cg.autoAngles, cg.autoAxis );
ADDRGP4 cg+108948
ARGP4
ADDRGP4 cg+108960
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1521
;1521:	AnglesToAxis( cg.autoAnglesFast, cg.autoAxisFast );
ADDRGP4 cg+108996
ARGP4
ADDRGP4 cg+109008
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1524
;1522:
;1523:	// generate and add the entity from the playerstate
;1524:	ps = &cg.predictedPlayerState;
ADDRLP4 8
ADDRGP4 cg+107636
ASGNP4
line 1525
;1525:	BG_PlayerStateToEntityState( ps, &cg.predictedPlayerEntity.currentState, qfalse );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 cg+108104
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
line 1526
;1526:	CG_AddCEntity( &cg.predictedPlayerEntity );
ADDRGP4 cg+108104
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1529
;1527:
;1528:	// lerp the non-predicted value for lightning gun origins
;1529:	CG_CalcEntityLerpPositions( &cg_entities[ cg.snap->ps.clientNum ] );
CNSTI4 728
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ARGP4
ADDRGP4 CG_CalcEntityLerpPositions
CALLV
pop
line 1532
;1530:
;1531:	// add each entity sent over by the server
;1532:	for ( num = 0 ; num < cg.snap->numEntities ; num++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $711
JUMPV
LABELV $708
line 1533
;1533:		cent = &cg_entities[ cg.snap->entities[ num ].number ];
ADDRLP4 4
CNSTI4 728
CNSTI4 208
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 516
ADDP4
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 1534
;1534:		CG_AddCEntity( cent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1535
;1535:	}
LABELV $709
line 1532
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $711
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
LTI4 $708
line 1536
;1536:}
LABELV $675
endproc CG_AddPacketEntities 20 12
bss
align 4
LABELV cg_monsterShadow
skip 120
align 4
LABELV cg_monsterShaders
skip 120
import CG_NewParticleArea
import initparticles
import CG_ParticleExplosion
import CG_ParticleMisc
import CG_ParticleDust
import CG_ParticleSparks
import CG_ParticleBulletDebris
import CG_ParticleSnowFlurry
import CG_AddParticleShrapnel
import CG_ParticleSmoke
import CG_ParticleSnow
import CG_AddParticles
import CG_ClearParticles
import trap_GetEntityToken
import trap_getCameraInfo
import trap_startCamera
import trap_loadCamera
import trap_SnapVector
import trap_CIN_SetExtents
import trap_CIN_DrawCinematic
import trap_CIN_RunCinematic
import trap_CIN_StopCinematic
import trap_CIN_PlayCinematic
import trap_Key_GetKey
import trap_Key_SetCatcher
import trap_Key_GetCatcher
import trap_Key_IsDown
import trap_R_RegisterFont
import trap_MemoryRemaining
import testPrintFloat
import testPrintInt
import trap_SetUserCmdValue
import trap_GetUserCmd
import trap_GetCurrentCmdNumber
import trap_GetServerCommand
import trap_GetSnapshot
import trap_GetCurrentSnapshotNumber
import trap_GetGameState
import trap_GetGlconfig
import trap_R_RemapShader
import trap_R_LerpTag
import trap_R_ModelBounds
import trap_R_DrawStretchPic
import trap_R_SetColor
import trap_R_RenderScene
import trap_R_LightForPoint
import trap_R_AddLightToScene
import trap_R_AddPolysToScene
import trap_R_AddPolyToScene
import trap_R_AddRefEntityToScene
import trap_R_ClearScene
import trap_R_RegisterShaderNoMip
import trap_R_RegisterShader
import trap_R_RegisterSkin
import trap_R_RegisterModel
import trap_R_LoadWorldMap
import trap_S_StopBackgroundTrack
import trap_S_StartBackgroundTrack
import trap_S_RegisterSound
import trap_S_Respatialize
import trap_S_UpdateEntityPosition
import trap_S_AddRealLoopingSound
import trap_S_AddLoopingSound
import trap_S_ClearLoopingSounds
import trap_S_StartLocalSound
import trap_S_StopLoopingSound
import trap_S_StartSound
import trap_CM_MarkFragments
import trap_CM_TransformedBoxTrace
import trap_CM_BoxTrace
import trap_CM_TransformedPointContents
import trap_CM_PointContents
import trap_CM_TempBoxModel
import trap_CM_InlineModel
import trap_CM_NumInlineModels
import trap_CM_LoadMap
import trap_UpdateScreen
import trap_SendClientCommand
import trap_AddCommand
import trap_SendConsoleCommand
import trap_FS_Seek
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Args
import trap_Argv
import trap_Argc
import trap_Cvar_VariableStringBuffer
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_Milliseconds
import trap_Error
import trap_Print
import CG_CheckChangedPredictableEvents
import CG_TransitionPlayerState
import CG_Respawn
import CG_PlayBufferedVoiceChats
import CG_VoiceChatLocal
import CG_ShaderStateChanged
import CG_LoadVoiceChats
import CG_SetConfigValues
import CG_ParseServerinfo
import CG_ExecuteNewServerCommands
import CG_InitConsoleCommands
import CG_ConsoleCommand
import CG_DrawOldTourneyScoreboard
import CG_DrawOldScoreboard
import CG_DrawInformation
import CG_LoadingClient
import CG_LoadingItem
import CG_LoadingString
import CG_ProcessSnapshots
import CG_MakeExplosion
import CG_Bleed
import CG_BigExplode
import CG_GibPlayer
import CG_ScorePlum
import CG_SpawnEffect
import CG_BubbleTrail
import CG_SmokePuff
import CG_AddLocalEntities
import CG_AllocLocalEntity
import CG_InitLocalEntities
import CG_ImpactMark
import CG_AddMarks
import CG_InitMarkPolys
import CG_OutOfAmmoChange
import CG_BlasterTracer
import CG_DrawWeaponSelect
import CG_AddPlayerWeapon
import CG_AddViewWeapon
import CG_GrappleTrail
import CG_RailTrail
import CG_Bullet
import CG_ShotgunFire
import CG_MissileHitPlayer
import CG_MissileHitWall
import CG_FireWeapon
import CG_RegisterItemVisuals
import CG_RegisterWeapon
import CG_Weapon_f
import CG_PrevWeapon_f
import CG_NextWeapon_f
import CG_PainEvent
import CG_EntityEvent
import CG_PlaceString
import CG_CheckEvents
import CG_LoadDeferredPlayers
import CG_PredictPlayerState
import CG_Trace
import CG_PointContents
import CG_BuildSolidList
import CG_CustomSound
import CG_NewClientInfo
import CG_AddRefEntityWithPowerups
import CG_ResetPlayerEntity
import CG_Player
import CG_StatusHandle
import CG_OtherTeamHasFlag
import CG_YourTeamHasFlag
import CG_GameTypeString
import CG_CheckOrderPending
import CG_Text_PaintChar
import CG_Draw3DModel
import CG_GetKillerText
import CG_GetGameStatusText
import CG_GetTeamColor
import CG_InitTeamChat
import CG_SetPrintString
import CG_ShowResponseHead
import CG_RunMenuScript
import CG_OwnerDrawVisible
import CG_GetValue
import CG_SelectNextPlayer
import CG_SelectPrevPlayer
import CG_Text_Height
import CG_Text_Width
import CG_Text_Paint
import CG_OwnerDraw
import CG_DrawTeamBackground
import CG_DrawFlagModel
import CG_DrawActive
import CG_DrawHead
import CG_CenterPrint
import CG_AddLagometerSnapshotInfo
import CG_AddLagometerFrameInfo
import teamChat2
import teamChat1
import systemChat
import drawTeamOverlayModificationCount
import numSortedTeamPlayers
import sortedTeamPlayers
import CG_DrawTopBottom
import CG_DrawSides
import CG_DrawRect
import UI_DrawProportionalString
import CG_GetColorForHealth
import CG_ColorForHealth
import CG_TileClear
import CG_TeamColor
import CG_FadeColor
import CG_DrawStrlen
import CG_DrawSmallStringColor
import CG_DrawSmallString
import CG_DrawBigStringColor
import CG_DrawBigString
import CG_DrawStringExt
import CG_DrawString
import CG_DrawPic
import CG_FillRect
import CG_AdjustFrom640
import CG_DrawActiveFrame
import CG_AddBufferedSound
import CG_ZoomUp_f
import CG_ZoomDown_f
import CG_TestModelPrevSkin_f
import CG_TestModelNextSkin_f
import CG_TestModelPrevFrame_f
import CG_TestModelNextFrame_f
import CG_TestGun_f
import CG_TestModel_f
import CG_BuildSpectatorString
import CG_GetSelectedScore
import CG_SetScoreSelection
import CG_RankRunFrame
import CG_EventHandling
import CG_MouseEvent
import CG_KeyEvent
import CG_LoadMenus
import CG_LastAttacker
import CG_CrosshairPlayer
import CG_UpdateCvars
import CG_StartMusic
import CG_Error
import CG_Printf
import CG_Argv
import CG_ConfigString
import cg_trueLightning
import cg_oldPlasma
import cg_oldRocket
import cg_oldRail
import cg_noProjectileTrail
import cg_noTaunt
import cg_bigFont
import cg_smallFont
import cg_cameraMode
import cg_timescale
import cg_timescaleFadeSpeed
import cg_timescaleFadeEnd
import cg_cameraOrbitDelay
import cg_cameraOrbit
import pmove_msec
import pmove_fixed
import cg_smoothClients
import cg_scorePlum
import cg_noVoiceText
import cg_noVoiceChats
import cg_teamChatsOnly
import cg_drawRailTrail
import cg_cleanView
import cg_drawFriend
import cg_deferPlayers
import cg_predictItems
import cg_blood
import cg_paused
import cg_buildScript
import cg_forceModel
import cg_stats
import cg_teamChatHeight
import cg_teamChatTime
import cg_synchronousClients
import cg_drawAttacker
import cg_lagometer
import cg_stereoSeparation
import cg_thirdPerson
import cg_thirdPersonAngle
import cg_thirdPersonRange
import cg_zoomFov
import cg_fov
import cg_staticItems
import cg_simpleItems
import cg_ignore
import cg_autoswitch
import cg_tracerLength
import cg_tracerWidth
import cg_tracerChance
import cg_viewsize
import cg_drawGun
import cg_gun_z
import cg_gun_y
import cg_gun_x
import cg_gun_frame
import cg_brassTime
import cg_addMarks
import cg_footsteps
import cg_showmiss
import cg_noPlayerAnims
import cg_nopredict
import cg_errorDecay
import cg_railTrailTime
import cg_debugEvents
import cg_debugPosition
import cg_debugAnim
import cg_animSpeed
import cg_draw2D
import cg_drawStatus
import cg_crosshairHealth
import cg_crosshairSize
import cg_crosshairY
import cg_crosshairX
import cg_teamOverlayUserinfo
import cg_drawTeamOverlay
import cg_drawRewards
import cg_drawCrosshairNames
import cg_drawCrosshair
import cg_drawAmmoWarning
import cg_drawIcons
import cg_draw3dIcons
import cg_drawSnapshot
import cg_drawFPS
import cg_drawTimer
import cg_gibs
import cg_shadows
import cg_swingSpeed
import cg_bobroll
import cg_bobpitch
import cg_bobup
import cg_runroll
import cg_runpitch
import cg_centertime
import cg_markPolys
import cg_items
import cg_weapons
import cg_entities
import cg
import cgs
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
LABELV $661
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $602
byte 1 67
byte 1 71
byte 1 95
byte 1 73
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 112
byte 1 111
byte 1 97
byte 1 116
byte 1 101
byte 1 69
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 80
byte 1 111
byte 1 115
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 58
byte 1 32
byte 1 99
byte 1 103
byte 1 46
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 78
byte 1 85
byte 1 76
byte 1 76
byte 1 0
align 1
LABELV $246
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 32
byte 1 105
byte 1 110
byte 1 100
byte 1 101
byte 1 120
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $192
byte 1 110
byte 1 111
byte 1 110
byte 1 101
byte 1 0
align 1
LABELV $184
byte 1 73
byte 1 110
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 100
byte 1 101
byte 1 102
byte 1 105
byte 1 110
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $174
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 105
byte 1 103
byte 1 32
byte 1 101
byte 1 114
byte 1 114
byte 1 111
byte 1 114
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 37
byte 1 115
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $171
byte 1 73
byte 1 110
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 105
byte 1 103
byte 1 32
byte 1 115
byte 1 105
byte 1 122
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $167
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 105
byte 1 103
byte 1 32
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $163
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 82
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $162
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 70
byte 1 108
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $161
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 66
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $160
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $159
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $158
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 70
byte 1 114
byte 1 111
byte 1 115
byte 1 116
byte 1 97
byte 1 116
byte 1 114
byte 1 111
byte 1 110
byte 1 97
byte 1 99
byte 1 104
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $157
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 77
byte 1 97
byte 1 110
byte 1 99
byte 1 117
byte 1 98
byte 1 117
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $156
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 71
byte 1 104
byte 1 111
byte 1 115
byte 1 116
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $155
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 70
byte 1 111
byte 1 114
byte 1 103
byte 1 111
byte 1 116
byte 1 116
byte 1 101
byte 1 110
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $154
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 77
byte 1 105
byte 1 110
byte 1 99
byte 1 101
byte 1 114
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $153
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 83
byte 1 116
byte 1 114
byte 1 97
byte 1 116
byte 1 111
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $152
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 70
byte 1 97
byte 1 117
byte 1 115
byte 1 116
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $151
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 77
byte 1 111
byte 1 110
byte 1 103
byte 1 71
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 82
byte 1 105
byte 1 102
byte 1 108
byte 1 101
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $150
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 77
byte 1 111
byte 1 110
byte 1 103
byte 1 71
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $149
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 77
byte 1 111
byte 1 110
byte 1 103
byte 1 71
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $148
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 71
byte 1 117
byte 1 110
byte 1 110
byte 1 101
byte 1 114
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $147
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 83
byte 1 116
byte 1 114
byte 1 111
byte 1 110
byte 1 103
byte 1 70
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $146
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 70
byte 1 108
byte 1 121
byte 1 105
byte 1 110
byte 1 103
byte 1 71
byte 1 117
byte 1 97
byte 1 114
byte 1 100
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $145
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 72
byte 1 111
byte 1 118
byte 1 101
byte 1 114
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $144
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 70
byte 1 108
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $143
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 71
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $142
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 68
byte 1 51
byte 1 73
byte 1 109
byte 1 112
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $141
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 76
byte 1 105
byte 1 111
byte 1 110
byte 1 71
byte 1 117
byte 1 121
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $140
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 68
byte 1 97
byte 1 114
byte 1 107
byte 1 75
byte 1 110
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $139
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 72
byte 1 101
byte 1 114
byte 1 101
byte 1 116
byte 1 105
byte 1 99
byte 1 68
byte 1 105
byte 1 115
byte 1 99
byte 1 105
byte 1 112
byte 1 108
byte 1 101
byte 1 47
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
