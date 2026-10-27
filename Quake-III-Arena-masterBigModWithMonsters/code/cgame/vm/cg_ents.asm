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
LABELV cg_monsterConfigFiles
address $117
address $118
address $119
byte 4 0
code
proc CG_LoadMonsterShader 9584 16
line 216
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
;207:static const char *cg_monsterConfigFiles[] = {
;208:	"models/monsters/HereticDisciple/monster.cfg",
;209:	"models/monsters/DarkKnight/monster.cfg",
;210:	"models/monsters/LionGuy/monster.cfg",
;211:	NULL
;212:};
;213:
;214:static void CG_LoadMonsterShader(
;215:	const char *filename
;216:) {
line 223
;217:	fileHandle_t file;
;218:	char text[MAX_MONSTER_CONFIG_TEXT];
;219:	char error[256];
;220:	monsterDef_t def;
;221:	int length;
;222:
;223:	length = trap_FS_FOpenFile(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1108
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 9560
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 1104
ADDRLP4 9560
INDIRI4
ASGNI4
line 229
;224:		filename,
;225:		&file,
;226:		FS_READ
;227:	);
;228:
;229:	if( !file ) {
ADDRLP4 1108
INDIRI4
CNSTI4 0
NEI4 $121
line 230
;230:		CG_Printf(
ADDRGP4 $123
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 234
;231:			"Monster config not found: %s\n",
;232:			filename
;233:		);
;234:		return;
ADDRGP4 $120
JUMPV
LABELV $121
line 237
;235:	}
;236:
;237:	if( length <= 0 ||
ADDRLP4 1104
INDIRI4
CNSTI4 0
LEI4 $126
ADDRLP4 1104
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $124
LABELV $126
line 238
;238:		length >= sizeof(text) ) {
line 239
;239:		CG_Printf(
ADDRGP4 $127
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 244
;240:			"Invalid monster config size: %s\n",
;241:			filename
;242:		);
;243:
;244:		trap_FS_FCloseFile(file);
ADDRLP4 1108
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 245
;245:		return;
ADDRGP4 $120
JUMPV
LABELV $124
line 248
;246:	}
;247:
;248:	trap_FS_Read(text, length, file);
ADDRLP4 1112
ARGP4
ADDRLP4 1104
INDIRI4
ARGI4
ADDRLP4 1108
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 249
;249:	text[length] = '\0';
ADDRLP4 1104
INDIRI4
ADDRLP4 1112
ADDP4
CNSTI1 0
ASGNI1
line 250
;250:	trap_FS_FCloseFile(file);
ADDRLP4 1108
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 252
;251:
;252:	if( !BG_ParseMonsterConfig(
ADDRLP4 1112
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 9304
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 9568
ADDRGP4 BG_ParseMonsterConfig
CALLI4
ASGNI4
ADDRLP4 9568
INDIRI4
CNSTI4 0
NEI4 $128
line 257
;253:		text,
;254:		&def,
;255:		error,
;256:		sizeof(error)
;257:	) ) {
line 258
;258:		CG_Printf(
ADDRGP4 $130
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9304
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 263
;259:			"Monster config error in %s: %s\n",
;260:			filename,
;261:			error
;262:		);
;263:		return;
ADDRGP4 $120
JUMPV
LABELV $128
line 266
;264:	}
;265:
;266:	if( def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 9572
CNSTI4 0
ASGNI4
ADDRLP4 0+576
INDIRI4
ADDRLP4 9572
INDIRI4
LEI4 $139
ADDRLP4 0+576
INDIRI4
CNSTI4 6
GEI4 $139
ADDRLP4 0+580
INDIRI4
ADDRLP4 9572
INDIRI4
LTI4 $139
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $131
LABELV $139
line 270
;267:		def.monsterType >= MONSTER_TYPE_RANDOM ||
;268:		def.monsterSlot < 0 ||
;269:		def.monsterSlot >=
;270:			MAX_MONSTERS_PER_TYPE ) {
line 271
;271:		CG_Printf(
ADDRGP4 $140
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 275
;272:			"Invalid monster definition in %s\n",
;273:			filename
;274:		);
;275:		return;
ADDRGP4 $120
JUMPV
LABELV $131
line 278
;276:	}
;277:
;278:	if( !def.shader[0] ||
ADDRLP4 0+320
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $146
ADDRLP4 0+320
ARGP4
ADDRGP4 $145
ARGP4
ADDRLP4 9576
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 9576
INDIRI4
CNSTI4 0
NEI4 $141
LABELV $146
line 279
;279:		!Q_stricmp(def.shader, "none") ) {
line 280
;280:		return;
ADDRGP4 $120
JUMPV
LABELV $141
line 283
;281:	}
;282:
;283:	cg_monsterShaders
ADDRLP4 0+320
ARGP4
ADDRLP4 9580
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
ADDRLP4 9580
INDIRI4
ASGNI4
line 287
;284:		[def.monsterType]
;285:		[def.monsterSlot] =
;286:		trap_R_RegisterShader(def.shader);
;287:}
LABELV $120
endproc CG_LoadMonsterShader 9584 16
export CG_InitMonsterShaders
proc CG_InitMonsterShaders 4 12
line 289
;288:
;289:void CG_InitMonsterShaders( void ) {
line 292
;290:	int i;
;291:
;292:	memset(
ADDRGP4 cg_monsterShaders
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 298
;293:		cg_monsterShaders,
;294:		0,
;295:		sizeof(cg_monsterShaders)
;296:	);
;297:
;298:	for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $154
JUMPV
LABELV $151
line 300
;299:		cg_monsterConfigFiles[i];
;300:		i++ ) {
line 301
;301:		CG_LoadMonsterShader(
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
line 304
;302:			cg_monsterConfigFiles[i]
;303:		);
;304:	}
LABELV $152
line 300
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $154
line 299
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $151
line 305
;305:}
LABELV $150
endproc CG_InitMonsterShaders 4 12
proc CG_Monster 196 12
line 312
;306:
;307:/*
;308:==================
;309:Monster
;310:==================
;311:*/
;312:static void CG_Monster( centity_t *cent ) {
line 321
;313:	refEntity_t renderEntity;
;314:	qhandle_t customShader;
;315:	int monsterType;
;316:	int monsterSlot;
;317:	int packedDefinition;
;318:	int models[4];
;319:	int i;
;320:
;321:	packedDefinition =
ADDRLP4 172
ADDRFP4 0
INDIRP4
CNSTI4 204
ADDP4
INDIRI4
ASGNI4
line 324
;322:		cent->currentState.generic1;
;323:
;324:	monsterType =
ADDRLP4 164
ADDRLP4 172
INDIRI4
CNSTI4 255
BANDI4
ASGNI4
line 327
;325:		packedDefinition & 255;
;326:
;327:	monsterSlot =
ADDRLP4 168
ADDRLP4 172
INDIRI4
CNSTI4 8
RSHI4
CNSTI4 255
BANDI4
ASGNI4
line 330
;328:		(packedDefinition >> 8) & 255;
;329:
;330:	customShader = 0;
ADDRLP4 160
CNSTI4 0
ASGNI4
line 332
;331:
;332:	if( monsterType > MONSTER_TYPE_OFF &&
ADDRLP4 180
CNSTI4 0
ASGNI4
ADDRLP4 164
INDIRI4
ADDRLP4 180
INDIRI4
LEI4 $156
ADDRLP4 164
INDIRI4
CNSTI4 6
GEI4 $156
ADDRLP4 168
INDIRI4
ADDRLP4 180
INDIRI4
LTI4 $156
ADDRLP4 168
INDIRI4
CNSTI4 5
GEI4 $156
line 336
;333:		monsterType < MONSTER_TYPE_RANDOM &&
;334:		monsterSlot >= 0 &&
;335:		monsterSlot <
;336:			MAX_MONSTERS_PER_TYPE ) {
line 337
;337:		customShader =
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
line 341
;338:			cg_monsterShaders
;339:				[monsterType]
;340:				[monsterSlot];
;341:	}
LABELV $156
line 343
;342:
;343:	models[0] =
ADDRLP4 144
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ASGNI4
line 346
;344:		cent->currentState.modelindex;
;345:
;346:	models[1] =
ADDRLP4 144+4
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
ASGNI4
line 349
;347:		cent->currentState.modelindex2;
;348:
;349:	models[2] =
ADDRLP4 144+8
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 352
;350:		cent->currentState.otherEntityNum;
;351:
;352:	models[3] =
ADDRLP4 144+12
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 355
;353:		cent->currentState.otherEntityNum2;
;354:
;355:	for( i = 0; i < 4; i++ ) {
ADDRLP4 140
CNSTI4 0
ASGNI4
LABELV $161
line 356
;356:		if( models[i] <= 0 ) {
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 144
ADDP4
INDIRI4
CNSTI4 0
GTI4 $165
line 357
;357:			continue;
ADDRGP4 $162
JUMPV
LABELV $165
line 360
;358:		}
;359:
;360:		memset(
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 366
;361:			&renderEntity,
;362:			0,
;363:			sizeof(renderEntity)
;364:		);
;365:
;366:		renderEntity.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 368
;367:
;368:		renderEntity.hModel =
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
line 371
;369:			cgs.gameModels[models[i]];
;370:
;371:		renderEntity.customShader =
ADDRLP4 0+112
ADDRLP4 160
INDIRI4
ASGNI4
line 374
;372:			customShader;
;373:
;374:		renderEntity.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 375
;375:		renderEntity.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 376
;376:		renderEntity.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 377
;377:		renderEntity.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 379
;378:
;379:		renderEntity.oldframe =
ADDRLP4 0+96
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 382
;380:			cent->currentState.frame;
;381:
;382:		renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 385
;383:			cent->currentState.frame;
;384:
;385:		renderEntity.backlerp = 0;
ADDRLP4 0+100
CNSTF4 0
ASGNF4
line 387
;386:
;387:		if( cent->interpolate &&
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
EQI4 $180
ADDRLP4 192
INDIRP4
CNSTI4 212
ADDP4
INDIRI4
CNSTI4 13
NEI4 $180
line 389
;388:			cent->nextState.eType ==
;389:				ET_MONSTER ) {
line 390
;390:			renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 380
ADDP4
INDIRI4
ASGNI4
line 393
;391:				cent->nextState.frame;
;392:
;393:			renderEntity.backlerp =
ADDRLP4 0+100
CNSTF4 1065353216
ADDRGP4 cg+107588
INDIRF4
SUBF4
ASGNF4
line 396
;394:				1.0f -
;395:				cg.frameInterpolation;
;396:		}
LABELV $180
line 398
;397:
;398:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 403
;399:			cent->lerpOrigin,
;400:			renderEntity.origin
;401:		);
;402:
;403:		VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 408
;404:			cent->lerpOrigin,
;405:			renderEntity.oldorigin
;406:		);
;407:
;408:		AnglesToAxis(
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
line 413
;409:			cent->lerpAngles,
;410:			renderEntity.axis
;411:		);
;412:
;413:		trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 416
;414:			&renderEntity
;415:		);
;416:	}
LABELV $162
line 355
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 4
LTI4 $161
line 417
;417:}
LABELV $155
endproc CG_Monster 196 12
proc CG_Speaker 16 16
line 426
;418:
;419:/*
;420:==================
;421:CG_Speaker
;422:
;423:Speaker entities can automatically play sounds
;424:==================
;425:*/
;426:static void CG_Speaker( centity_t *cent ) {
line 427
;427:	if ( ! cent->currentState.clientNum ) {	// FIXME: use something other than clientNum...
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
CNSTI4 0
NEI4 $189
line 428
;428:		return;		// not auto triggering
ADDRGP4 $188
JUMPV
LABELV $189
line 431
;429:	}
;430:
;431:	if ( cg.time < cent->miscTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRI4
GEI4 $191
line 432
;432:		return;
ADDRGP4 $188
JUMPV
LABELV $191
line 435
;433:	}
;434:
;435:	trap_S_StartSound (NULL, cent->currentState.number, CHAN_ITEM, cgs.gameSounds[cent->currentState.eventParm] );
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
line 439
;436:
;437:	//	ent->s.frame = ent->wait * 10;
;438:	//	ent->s.clientNum = ent->random * 10;
;439:	cent->miscTime = cg.time + cent->currentState.frame * 100 + cent->currentState.clientNum * 100 * crandom();
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
line 440
;440:}
LABELV $188
endproc CG_Speaker 16 16
proc CG_Item 204 12
line 447
;441:
;442:/*
;443:==================
;444:CG_Item
;445:==================
;446:*/
;447:static void CG_Item( centity_t *cent ) {
line 456
;448:	refEntity_t	ent;
;449:	entityState_t	*es;
;450:	gitem_t		*item;
;451:	int		msec;
;452:	float		frac;
;453:	float		scale;
;454:	weaponInfo_t	*wi;
;455:
;456:	es = &cent->currentState;
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
line 458
;457:
;458:	if( es->modelindex >= bg_numItems ) {
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $197
line 459
;459:		CG_Error(
ADDRGP4 $199
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
line 463
;460:			"Bad item index %i on entity",
;461:			es->modelindex
;462:		);
;463:	}
LABELV $197
line 466
;464:
;465:	// if set to invisible, skip
;466:	if( !es->modelindex ||
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
EQI4 $202
ADDRLP4 144
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 128
BANDI4
ADDRLP4 168
INDIRI4
EQI4 $200
LABELV $202
line 467
;467:		(es->eFlags & EF_NODRAW) ) {
line 468
;468:		return;
ADDRGP4 $196
JUMPV
LABELV $200
line 471
;469:	}
;470:
;471:	item = &bg_itemlist[es->modelindex];
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
line 473
;472:
;473:	if( cg_simpleItems.integer &&
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
EQI4 $203
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
EQI4 $203
line 474
;474:		item->giType != IT_TEAM ) {
line 475
;475:		memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 477
;476:
;477:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 478
;478:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 482
;479:			cent->lerpOrigin,
;480:			ent.origin
;481:		);
;482:		ent.radius = 14;
ADDRLP4 0+132
CNSTF4 1096810496
ASGNF4
line 483
;483:		ent.customShader =
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
line 485
;484:			cg_items[es->modelindex].icon;
;485:		ent.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 486
;486:		ent.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 487
;487:		ent.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 488
;488:		ent.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 490
;489:
;490:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 491
;491:		return;
ADDRGP4 $196
JUMPV
LABELV $203
line 498
;492:	}
;493:
;494:	/*
;495:	 * Normal items continuously bob up and down.
;496:	 * Static items retain their original map position.
;497:	 */
;498:	if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $217
line 499
;499:		scale =
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
line 503
;500:			0.005 +
;501:			cent->currentState.number * 0.00001;
;502:
;503:		cent->lerpOrigin[2] +=
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
line 506
;504:			4 +
;505:			cos((cg.time + 1000) * scale) * 4;
;506:	}
LABELV $217
line 508
;507:
;508:	memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 514
;509:
;510:	/*
;511:	 * Static items use a fixed identity axis.
;512:	 * Normal items use the original automatic rotation.
;513:	 */
;514:	if( cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
EQI4 $221
line 515
;515:		VectorClear( cent->lerpAngles );
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
line 516
;516:		AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 517
;517:	}
ADDRGP4 $222
JUMPV
LABELV $221
line 518
;518:	else if( item->giType == IT_HEALTH ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 4
NEI4 $225
line 519
;519:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108996
INDIRB
ASGNB 12
line 523
;520:			cg.autoAnglesFast,
;521:			cent->lerpAngles
;522:		);
;523:		AxisCopy(
ADDRGP4 cg+109008
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 527
;524:			cg.autoAxisFast,
;525:			ent.axis
;526:		);
;527:	}
ADDRGP4 $226
JUMPV
LABELV $225
line 528
;528:	else {
line 529
;529:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108948
INDIRB
ASGNB 12
line 533
;530:			cg.autoAngles,
;531:			cent->lerpAngles
;532:		);
;533:		AxisCopy(
ADDRGP4 cg+108960
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 537
;534:			cg.autoAxis,
;535:			ent.axis
;536:		);
;537:	}
LABELV $226
LABELV $222
line 539
;538:
;539:	wi = NULL;
ADDRLP4 152
CNSTP4 0
ASGNP4
line 545
;540:
;541:	/*
;542:	 * Weapon models have their origin at the attachment point,
;543:	 * so compensate using the weapon midpoint.
;544:	 */
;545:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $233
line 546
;546:		wi = &cg_weapons[item->giTag];
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
line 548
;547:
;548:		cent->lerpOrigin[0] -=
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
line 553
;549:			wi->weaponMidpoint[0] * ent.axis[0][0] +
;550:			wi->weaponMidpoint[1] * ent.axis[1][0] +
;551:			wi->weaponMidpoint[2] * ent.axis[2][0];
;552:
;553:		cent->lerpOrigin[1] -=
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
line 558
;554:			wi->weaponMidpoint[0] * ent.axis[0][1] +
;555:			wi->weaponMidpoint[1] * ent.axis[1][1] +
;556:			wi->weaponMidpoint[2] * ent.axis[2][1];
;557:
;558:		cent->lerpOrigin[2] -=
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
line 563
;559:			wi->weaponMidpoint[0] * ent.axis[0][2] +
;560:			wi->weaponMidpoint[1] * ent.axis[1][2] +
;561:			wi->weaponMidpoint[2] * ent.axis[2][2];
;562:
;563:		cent->lerpOrigin[2] += 8;
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
line 564
;564:	}
LABELV $233
line 566
;565:
;566:	ent.hModel =
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
line 569
;567:		cg_items[es->modelindex].models[0];
;568:
;569:	VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 573
;570:		cent->lerpOrigin,
;571:		ent.origin
;572:	);
;573:	VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 578
;574:		cent->lerpOrigin,
;575:		ent.oldorigin
;576:	);
;577:
;578:	ent.nonNormalizedAxes = qfalse;
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 584
;579:
;580:	/*
;581:	 * Static items appear immediately at full size.
;582:	 * Normal items retain the respawn scale animation.
;583:	 */
;584:	msec = cg.time - cent->miscTime;
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
line 586
;585:
;586:	if( !cg_staticItems.integer &&
ADDRLP4 172
CNSTI4 0
ASGNI4
ADDRGP4 cg_staticItems+12
INDIRI4
ADDRLP4 172
INDIRI4
NEI4 $262
ADDRLP4 156
INDIRI4
ADDRLP4 172
INDIRI4
LTI4 $262
ADDRLP4 156
INDIRI4
CNSTI4 1000
GEI4 $262
line 588
;587:		msec >= 0 &&
;588:		msec < ITEM_SCALEUP_TIME ) {
line 589
;589:		frac = (float)msec /
ADDRLP4 148
ADDRLP4 156
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 592
;590:			ITEM_SCALEUP_TIME;
;591:
;592:		VectorScale(
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
line 597
;593:			ent.axis[0],
;594:			frac,
;595:			ent.axis[0]
;596:		);
;597:		VectorScale(
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
line 602
;598:			ent.axis[1],
;599:			frac,
;600:			ent.axis[1]
;601:		);
;602:		VectorScale(
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
line 608
;603:			ent.axis[2],
;604:			frac,
;605:			ent.axis[2]
;606:		);
;607:
;608:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 609
;609:	}
ADDRGP4 $263
JUMPV
LABELV $262
line 610
;610:	else {
line 611
;611:		frac = 1.0f;
ADDRLP4 148
CNSTF4 1065353216
ASGNF4
line 612
;612:	}
LABELV $263
line 617
;613:
;614:	/*
;615:	 * Items without glow textures need a minimum light value.
;616:	 */
;617:	if( item->giType == IT_WEAPON ||
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
EQI4 $310
ADDRLP4 180
INDIRI4
CNSTI4 3
NEI4 $308
LABELV $310
line 618
;618:		item->giType == IT_ARMOR ) {
line 619
;619:		ent.renderfx |= RF_MINLIGHT;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 620
;620:	}
LABELV $308
line 623
;621:
;622:	// increase the size of weapon pickup models
;623:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $312
line 624
;624:		VectorScale(
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
line 629
;625:			ent.axis[0],
;626:			1.5f,
;627:			ent.axis[0]
;628:		);
;629:		VectorScale(
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
line 634
;630:			ent.axis[1],
;631:			1.5f,
;632:			ent.axis[1]
;633:		);
;634:		VectorScale(
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
line 640
;635:			ent.axis[2],
;636:			1.5f,
;637:			ent.axis[2]
;638:		);
;639:
;640:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 652
;641:
;642:#ifdef MISSIONPACK
;643:		if( !cg_staticItems.integer ) {
;644:			trap_S_AddLoopingSound(
;645:				cent->currentState.number,
;646:				cent->lerpOrigin,
;647:				vec3_origin,
;648:				cgs.media.weaponHoverSound
;649:			);
;650:		}
;651:#endif
;652:	}
LABELV $312
line 678
;653:
;654:#ifdef MISSIONPACK
;655:	if( item->giType == IT_HOLDABLE &&
;656:		item->giTag == HI_KAMIKAZE ) {
;657:		VectorScale(
;658:			ent.axis[0],
;659:			2,
;660:			ent.axis[0]
;661:		);
;662:		VectorScale(
;663:			ent.axis[1],
;664:			2,
;665:			ent.axis[1]
;666:		);
;667:		VectorScale(
;668:			ent.axis[2],
;669:			2,
;670:			ent.axis[2]
;671:		);
;672:
;673:		ent.nonNormalizedAxes = qtrue;
;674:	}
;675:#endif
;676:
;677:	// add main model
;678:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 725
;679:
;680:#ifdef MISSIONPACK
;681:	if( item->giType == IT_WEAPON &&
;682:		wi->barrelModel ) {
;683:		refEntity_t barrel;
;684:
;685:		memset(
;686:			&barrel,
;687:			0,
;688:			sizeof(barrel)
;689:		);
;690:
;691:		barrel.hModel = wi->barrelModel;
;692:
;693:		VectorCopy(
;694:			ent.lightingOrigin,
;695:			barrel.lightingOrigin
;696:		);
;697:
;698:		barrel.shadowPlane =
;699:			ent.shadowPlane;
;700:		barrel.renderfx =
;701:			ent.renderfx;
;702:
;703:		CG_PositionRotatedEntityOnTag(
;704:			&barrel,
;705:			&ent,
;706:			wi->weaponModel,
;707:			"tag_barrel"
;708:		);
;709:
;710:		AxisCopy(
;711:			ent.axis,
;712:			barrel.axis
;713:		);
;714:
;715:		barrel.nonNormalizedAxes =
;716:			ent.nonNormalizedAxes;
;717:
;718:		trap_R_AddRefEntityToScene(
;719:			&barrel
;720:		);
;721:	}
;722:#endif
;723:
;724:	// accompanying rings and spheres for powerups
;725:	if( !cg_simpleItems.integer ) {
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
NEI4 $357
line 728
;726:		vec3_t spinAngles;
;727:
;728:		VectorClear( spinAngles );
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
line 730
;729:
;730:		if( item->giType == IT_HEALTH ||
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
EQI4 $364
ADDRLP4 200
INDIRI4
CNSTI4 5
NEI4 $362
LABELV $364
line 731
;731:			item->giType == IT_POWERUP ) {
line 732
;732:			ent.hModel =
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
line 737
;733:				cg_items[
;734:					es->modelindex
;735:				].models[1];
;736:
;737:			if( ent.hModel ) {
ADDRLP4 0+8
INDIRI4
CNSTI4 0
EQI4 $368
line 738
;738:				if( item->giType ==
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $371
line 739
;739:					IT_POWERUP ) {
line 740
;740:					ent.origin[2] += 12;
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
CNSTF4 1094713344
ADDF4
ASGNF4
line 742
;741:
;742:					if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $375
line 743
;743:						spinAngles[1] =
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
line 747
;744:							(cg.time & 1023) *
;745:							360 /
;746:							-1024.0f;
;747:					}
LABELV $375
line 748
;748:				}
LABELV $371
line 750
;749:
;750:				AnglesToAxis(
ADDRLP4 184
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 755
;751:					spinAngles,
;752:					ent.axis
;753:				);
;754:
;755:				if( frac != 1.0f ) {
ADDRLP4 148
INDIRF4
CNSTF4 1065353216
EQF4 $381
line 756
;756:					VectorScale(
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
line 761
;757:						ent.axis[0],
;758:						frac,
;759:						ent.axis[0]
;760:					);
;761:					VectorScale(
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
line 766
;762:						ent.axis[1],
;763:						frac,
;764:						ent.axis[1]
;765:					);
;766:					VectorScale(
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
line 772
;767:						ent.axis[2],
;768:						frac,
;769:						ent.axis[2]
;770:					);
;771:
;772:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 774
;773:						qtrue;
;774:				}
ADDRGP4 $382
JUMPV
LABELV $381
line 775
;775:				else {
line 776
;776:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 778
;777:						qfalse;
;778:				}
LABELV $382
line 780
;779:
;780:				trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 783
;781:					&ent
;782:				);
;783:			}
LABELV $368
line 784
;784:		}
LABELV $362
line 785
;785:	}
LABELV $357
line 786
;786:}
LABELV $196
endproc CG_Item 204 12
proc CG_Missile 164 20
line 795
;787:
;788://============================================================================
;789:
;790:/*
;791:===============
;792:CG_Missile
;793:===============
;794:*/
;795:static void CG_Missile( centity_t *cent ) {
line 801
;796:	refEntity_t			ent;
;797:	entityState_t		*s1;
;798:	const weaponInfo_t		*weapon;
;799://	int	col;
;800:
;801:	s1 = &cent->currentState;
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
line 802
;802:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 144
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $428
line 803
;803:		s1->weapon = 0;
ADDRLP4 144
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 804
;804:	}
LABELV $428
line 805
;805:	weapon = &cg_weapons[s1->weapon];
ADDRLP4 140
CNSTI4 136
ADDRLP4 144
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons
ADDP4
ASGNP4
line 808
;806:
;807:	// calculate the axis
;808:	VectorCopy( s1->angles, cent->lerpAngles);
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRLP4 144
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
line 811
;809:
;810:	// add trails
;811:	if ( weapon->missileTrailFunc ) 
ADDRLP4 140
INDIRP4
CNSTI4 88
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $430
line 812
;812:	{
line 813
;813:		weapon->missileTrailFunc( cent, weapon );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
INDIRP4
ARGP4
ADDRLP4 140
INDIRP4
CNSTI4 88
ADDP4
INDIRP4
CALLV
pop
line 814
;814:	}
LABELV $430
line 833
;815:/*
;816:	if ( cent->currentState.modelindex == TEAM_RED ) {
;817:		col = 1;
;818:	}
;819:	else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;820:		col = 2;
;821:	}
;822:	else {
;823:		col = 0;
;824:	}
;825:
;826:	// add dynamic light
;827:	if ( weapon->missileDlight ) {
;828:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
;829:			weapon->missileDlightColor[col][0], weapon->missileDlightColor[col][1], weapon->missileDlightColor[col][2] );
;830:	}
;831:*/
;832:	// add dynamic light
;833:	if ( weapon->missileDlight ) {
ADDRLP4 140
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
CNSTF4 0
EQF4 $432
line 834
;834:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 140
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ARGF4
ADDRLP4 140
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ARGF4
ADDRLP4 140
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ARGF4
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRF4
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 836
;835:			weapon->missileDlightColor[0], weapon->missileDlightColor[1], weapon->missileDlightColor[2] );
;836:	}
LABELV $432
line 839
;837:
;838:	// add missile sound
;839:	if ( weapon->missileSound ) {
ADDRLP4 140
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 0
EQI4 $434
line 842
;840:		vec3_t	velocity;
;841:
;842:		BG_EvaluateTrajectoryDelta( &cent->currentState.pos, cg.time, velocity );
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 148
ARGP4
ADDRGP4 BG_EvaluateTrajectoryDelta
CALLV
pop
line 844
;843:
;844:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, velocity, weapon->missileSound );
ADDRLP4 160
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 160
INDIRP4
INDIRI4
ARGI4
ADDRLP4 160
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 148
ARGP4
ADDRLP4 140
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_AddLoopingSound
CALLV
pop
line 845
;845:	}
LABELV $434
line 848
;846:
;847:	// create the render entity
;848:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 849
;849:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 850
;850:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 852
;851:
;852:	if ( cent->currentState.weapon == WP_PLASMAGUN ) {
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 8
NEI4 $439
line 853
;853:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 854
;854:		ent.radius = 16;
ADDRLP4 0+132
CNSTF4 1098907648
ASGNF4
line 855
;855:		ent.rotation = 0;
ADDRLP4 0+136
CNSTF4 0
ASGNF4
line 856
;856:		ent.customShader = cgs.media.plasmaBallShader;
ADDRLP4 0+112
ADDRGP4 cgs+152340+288
INDIRI4
ASGNI4
line 857
;857:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 858
;858:		return;
ADDRGP4 $427
JUMPV
LABELV $439
line 862
;859:	}
;860:
;861:	// flicker between two skins
;862:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 863
;863:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 140
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 864
;864:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 140
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 875
;865:
;866:#ifdef MISSIONPACK
;867:	if ( cent->currentState.weapon == WP_PROX_LAUNCHER ) {
;868:		if (s1->generic1 == TEAM_BLUE) {
;869:			ent.hModel = cgs.media.blueProxMine;
;870:		}
;871:	}
;872:#endif
;873:
;874:	// convert direction of travel into axis
;875:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
ADDRLP4 144
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
NEF4 $449
line 876
;876:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 877
;877:	}
LABELV $449
line 880
;878:
;879:	// spin as it moves
;880:	if ( s1->pos.trType != TR_STATIONARY ) {
ADDRLP4 144
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 0
EQI4 $454
line 881
;881:		RotateAroundDirection( ent.axis, cg.time / 4 );
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
line 882
;882:	} else {
ADDRGP4 $455
JUMPV
LABELV $454
line 889
;883:#ifdef MISSIONPACK
;884:		if ( s1->weapon == WP_PROX_LAUNCHER ) {
;885:			AnglesToAxis( cent->lerpAngles, ent.axis );
;886:		}
;887:		else
;888:#endif
;889:		{
line 890
;890:			RotateAroundDirection( ent.axis, s1->time );
ADDRLP4 0+28
ARGP4
ADDRLP4 144
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 RotateAroundDirection
CALLV
pop
line 891
;891:		}
line 892
;892:	}
LABELV $455
line 895
;893:
;894:	// add to refresh list, possibly with quad glow
;895:	CG_AddRefEntityWithPowerups( &ent, s1, TEAM_FREE );
ADDRLP4 0
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 CG_AddRefEntityWithPowerups
CALLV
pop
line 896
;896:}
LABELV $427
endproc CG_Missile 164 20
proc CG_Grapple 152 12
line 905
;897:
;898:/*
;899:===============
;900:CG_Grapple
;901:
;902:This is called when the grapple is sitting up against the wall
;903:===============
;904:*/
;905:static void CG_Grapple( centity_t *cent ) {
line 910
;906:	refEntity_t			ent;
;907:	entityState_t		*s1;
;908:	const weaponInfo_t		*weapon;
;909:
;910:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 911
;911:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $460
line 912
;912:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 913
;913:	}
LABELV $460
line 914
;914:	weapon = &cg_weapons[s1->weapon];
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
line 917
;915:
;916:	// calculate the axis
;917:	VectorCopy( s1->angles, cent->lerpAngles);
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
line 927
;918:
;919:#if 0 // FIXME add grapple pull sound here..?
;920:	// add missile sound
;921:	if ( weapon->missileSound ) {
;922:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, weapon->missileSound );
;923:	}
;924:#endif
;925:
;926:	// Will draw cable if needed
;927:	CG_GrappleTrail ( cent, weapon );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRGP4 CG_GrappleTrail
CALLV
pop
line 930
;928:
;929:	// create the render entity
;930:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 931
;931:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 932
;932:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 935
;933:
;934:	// flicker between two skins
;935:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 936
;936:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 937
;937:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 940
;938:
;939:	// convert direction of travel into axis
;940:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
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
NEF4 $467
line 941
;941:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 942
;942:	}
LABELV $467
line 944
;943:
;944:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 945
;945:}
LABELV $459
endproc CG_Grapple 152 12
proc CG_Mover 144 12
line 952
;946:
;947:/*
;948:===============
;949:CG_Mover
;950:===============
;951:*/
;952:static void CG_Mover( centity_t *cent ) {
line 956
;953:	refEntity_t			ent;
;954:	entityState_t		*s1;
;955:
;956:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 959
;957:
;958:	// create the render entity
;959:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 960
;960:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 961
;961:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 962
;962:	AnglesToAxis( cent->lerpAngles, ent.axis );
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
line 964
;963:
;964:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 967
;965:
;966:	// flicker between two skins (FIXME?)
;967:	ent.skinNum = ( cg.time >> 6 ) & 1;
ADDRLP4 0+104
ADDRGP4 cg+107604
INDIRI4
CNSTI4 6
RSHI4
CNSTI4 1
BANDI4
ASGNI4
line 970
;968:
;969:	// get the model, either as a bmodel or a modelindex
;970:	if ( s1->solid == SOLID_BMODEL ) {
ADDRLP4 140
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
NEI4 $479
line 971
;971:		ent.hModel = cgs.inlineDrawModel[s1->modelindex];
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
line 972
;972:	} else {
ADDRGP4 $480
JUMPV
LABELV $479
line 973
;973:		ent.hModel = cgs.gameModels[s1->modelindex];
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
line 974
;974:	}
LABELV $480
line 977
;975:
;976:	// add to refresh list
;977:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 980
;978:
;979:	// add the secondary model
;980:	if ( s1->modelindex2 ) {
ADDRLP4 140
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $485
line 981
;981:		ent.skinNum = 0;
ADDRLP4 0+104
CNSTI4 0
ASGNI4
line 982
;982:		ent.hModel = cgs.gameModels[s1->modelindex2];
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
line 983
;983:		trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 984
;984:	}
LABELV $485
line 986
;985:
;986:}
LABELV $472
endproc CG_Mover 144 12
export CG_Beam
proc CG_Beam 144 12
line 995
;987:
;988:/*
;989:===============
;990:CG_Beam
;991:
;992:Also called as an event
;993:===============
;994:*/
;995:void CG_Beam( centity_t *cent ) {
line 999
;996:	refEntity_t			ent;
;997:	entityState_t		*s1;
;998:
;999:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1002
;1000:
;1001:	// create the render entity
;1002:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1003
;1003:	VectorCopy( s1->pos.trBase, ent.origin );
ADDRLP4 0+68
ADDRLP4 140
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
line 1004
;1004:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1005
;1005:	AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 1006
;1006:	ent.reType = RT_BEAM;
ADDRLP4 0
CNSTI4 3
ASGNI4
line 1008
;1007:
;1008:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 1011
;1009:
;1010:	// add to refresh list
;1011:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1012
;1012:}
LABELV $490
endproc CG_Beam 144 12
proc CG_Portal 144 12
line 1020
;1013:
;1014:
;1015:/*
;1016:===============
;1017:CG_Portal
;1018:===============
;1019:*/
;1020:static void CG_Portal( centity_t *cent ) {
line 1024
;1021:	refEntity_t			ent;
;1022:	entityState_t		*s1;
;1023:
;1024:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1027
;1025:
;1026:	// create the render entity
;1027:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1028
;1028:	VectorCopy( cent->lerpOrigin, ent.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1029
;1029:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1030
;1030:	ByteToDir( s1->eventParm, ent.axis[0] );
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
line 1031
;1031:	PerpendicularVector( ent.axis[1], ent.axis[0] );
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 1035
;1032:
;1033:	// negating this tends to get the directions like they want
;1034:	// we really should have a camera roll value
;1035:	VectorSubtract( vec3_origin, ent.axis[1], ent.axis[1] );
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
line 1037
;1036:
;1037:	CrossProduct( ent.axis[0], ent.axis[1], ent.axis[2] );
ADDRLP4 0+28
ARGP4
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28+24
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 1038
;1038:	ent.reType = RT_PORTALSURFACE;
ADDRLP4 0
CNSTI4 7
ASGNI4
line 1039
;1039:	ent.oldframe = s1->powerups;
ADDRLP4 0+96
ADDRLP4 140
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
ASGNI4
line 1040
;1040:	ent.frame = s1->frame;		// rotation speed
ADDRLP4 0+80
ADDRLP4 140
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 1041
;1041:	ent.skinNum = s1->clientNum/256.0 * 360;	// roll offset
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
line 1044
;1042:
;1043:	// add to refresh list
;1044:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1045
;1045:}
LABELV $495
endproc CG_Portal 144 12
export CG_AdjustPositionForMover
proc CG_AdjustPositionForMover 92 12
line 1055
;1046:
;1047:
;1048:/*
;1049:=========================
;1050:CG_AdjustPositionForMover
;1051:
;1052:Also called by client movement prediction code
;1053:=========================
;1054:*/
;1055:void CG_AdjustPositionForMover( const vec3_t in, int moverNum, int fromTime, int toTime, vec3_t out ) {
line 1060
;1056:	centity_t	*cent;
;1057:	vec3_t	oldOrigin, origin, deltaOrigin;
;1058:	vec3_t	oldAngles, angles, deltaAngles;
;1059:
;1060:	if ( moverNum <= 0 || moverNum >= ENTITYNUM_MAX_NORMAL ) {
ADDRLP4 76
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
LEI4 $531
ADDRLP4 76
INDIRI4
CNSTI4 1022
LTI4 $529
LABELV $531
line 1061
;1061:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1062
;1062:		return;
ADDRGP4 $528
JUMPV
LABELV $529
line 1065
;1063:	}
;1064:
;1065:	cent = &cg_entities[ moverNum ];
ADDRLP4 0
CNSTI4 728
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 1066
;1066:	if ( cent->currentState.eType != ET_MOVER ) {
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
EQI4 $532
line 1067
;1067:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1068
;1068:		return;
ADDRGP4 $528
JUMPV
LABELV $532
line 1071
;1069:	}
;1070:
;1071:	BG_EvaluateTrajectory( &cent->currentState.pos, fromTime, oldOrigin );
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
line 1072
;1072:	BG_EvaluateTrajectory( &cent->currentState.apos, fromTime, oldAngles );
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
line 1074
;1073:
;1074:	BG_EvaluateTrajectory( &cent->currentState.pos, toTime, origin );
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
line 1075
;1075:	BG_EvaluateTrajectory( &cent->currentState.apos, toTime, angles );
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
line 1077
;1076:
;1077:	VectorSubtract( origin, oldOrigin, deltaOrigin );
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
line 1078
;1078:	VectorSubtract( angles, oldAngles, deltaAngles );
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
line 1080
;1079:
;1080:	VectorAdd( in, deltaOrigin, out );
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
line 1083
;1081:
;1082:	// FIXME: origin change when on a rotating object
;1083:}
LABELV $528
endproc CG_AdjustPositionForMover 92 12
proc CG_InterpolateEntityPosition 44 12
line 1091
;1084:
;1085:
;1086:/*
;1087:=============================
;1088:CG_InterpolateEntityPosition
;1089:=============================
;1090:*/
;1091:static void CG_InterpolateEntityPosition( centity_t *cent ) {
line 1097
;1092:	vec3_t		current, next;
;1093:	float		f;
;1094:
;1095:	// it would be an internal error to find an entity that interpolates without
;1096:	// a snapshot ahead of the current one
;1097:	if ( cg.nextSnap == NULL ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $549
line 1098
;1098:		CG_Error( "CG_InterpoateEntityPosition: cg.nextSnap == NULL" );
ADDRGP4 $552
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 1099
;1099:	}
LABELV $549
line 1101
;1100:
;1101:	f = cg.frameInterpolation;
ADDRLP4 24
ADDRGP4 cg+107588
INDIRF4
ASGNF4
line 1105
;1102:
;1103:	// this will linearize a sine or parabolic curve, but it is important
;1104:	// to not extrapolate player positions if more recent data is available
;1105:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.snap->serverTime, current );
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
line 1106
;1106:	BG_EvaluateTrajectory( &cent->nextState.pos, cg.nextSnap->serverTime, next );
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
line 1108
;1107:
;1108:	cent->lerpOrigin[0] = current[0] + f * ( next[0] - current[0] );
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
line 1109
;1109:	cent->lerpOrigin[1] = current[1] + f * ( next[1] - current[1] );
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
line 1110
;1110:	cent->lerpOrigin[2] = current[2] + f * ( next[2] - current[2] );
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
line 1112
;1111:
;1112:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.snap->serverTime, current );
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
line 1113
;1113:	BG_EvaluateTrajectory( &cent->nextState.apos, cg.nextSnap->serverTime, next );
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
line 1115
;1114:
;1115:	cent->lerpAngles[0] = LerpAngle( current[0], next[0], f );
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
line 1116
;1116:	cent->lerpAngles[1] = LerpAngle( current[1], next[1], f );
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
line 1117
;1117:	cent->lerpAngles[2] = LerpAngle( current[2], next[2], f );
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
line 1119
;1118:
;1119:}
LABELV $548
endproc CG_InterpolateEntityPosition 44 12
proc CG_CalcEntityLerpPositions 24 20
line 1127
;1120:
;1121:/*
;1122:===============
;1123:CG_CalcEntityLerpPositions
;1124:
;1125:===============
;1126:*/
;1127:static void CG_CalcEntityLerpPositions( centity_t *cent ) {
line 1130
;1128:
;1129:	// if this player does not want to see extrapolated players
;1130:	if ( !cg_smoothClients.integer ) {
ADDRGP4 cg_smoothClients+12
INDIRI4
CNSTI4 0
NEI4 $569
line 1132
;1131:		// make sure the clients use TR_INTERPOLATE
;1132:		if ( cent->currentState.number < MAX_CLIENTS ) {
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $572
line 1133
;1133:			cent->currentState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 1134
;1134:			cent->nextState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
CNSTI4 1
ASGNI4
line 1135
;1135:		}
LABELV $572
line 1136
;1136:	}
LABELV $569
line 1138
;1137:
;1138:	if ( cent->interpolate && cent->currentState.pos.trType == TR_INTERPOLATE ) {
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
EQI4 $574
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 1
NEI4 $574
line 1139
;1139:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1140
;1140:		return;
ADDRGP4 $568
JUMPV
LABELV $574
line 1145
;1141:	}
;1142:
;1143:	// first see if we can interpolate between two snaps for
;1144:	// linear extrapolated clients
;1145:	if ( cent->interpolate && cent->currentState.pos.trType == TR_LINEAR_STOP &&
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
EQI4 $576
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 3
NEI4 $576
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $576
line 1146
;1146:											cent->currentState.number < MAX_CLIENTS) {
line 1147
;1147:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1148
;1148:		return;
ADDRGP4 $568
JUMPV
LABELV $576
line 1152
;1149:	}
;1150:
;1151:	// just use the current frame and evaluate as best we can
;1152:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.time, cent->lerpOrigin );
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
line 1153
;1153:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.time, cent->lerpAngles );
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
line 1157
;1154:
;1155:	// adjust for riding a mover if it wasn't rolled into the predicted
;1156:	// player state
;1157:	if ( cent != &cg.predictedPlayerEntity ) {
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 cg+108104
CVPU4 4
EQU4 $580
line 1158
;1158:		CG_AdjustPositionForMover( cent->lerpOrigin, cent->currentState.groundEntityNum, 
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
line 1160
;1159:		cg.snap->serverTime, cg.time, cent->lerpOrigin );
;1160:	}
LABELV $580
line 1161
;1161:}
LABELV $568
endproc CG_CalcEntityLerpPositions 24 20
proc CG_TeamBase 140 12
line 1168
;1162:
;1163:/*
;1164:===============
;1165:CG_TeamBase
;1166:===============
;1167:*/
;1168:static void CG_TeamBase( centity_t *cent ) {
line 1177
;1169:	refEntity_t model;
;1170:#ifdef MISSIONPACK
;1171:	vec3_t angles;
;1172:	int t, h;
;1173:	float c;
;1174:
;1175:	if ( cgs.gametype == GT_CTF || cgs.gametype == GT_1FCTF ) {
;1176:#else
;1177:	if ( cgs.gametype == GT_CTF) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $586
line 1180
;1178:#endif
;1179:		// show the flag base
;1180:		memset(&model, 0, sizeof(model));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1181
;1181:		model.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1182
;1182:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1183
;1183:		VectorCopy( cent->lerpOrigin, model.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1184
;1184:		AnglesToAxis( cent->currentState.angles, model.axis );
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
line 1185
;1185:		if ( cent->currentState.modelindex == TEAM_RED ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $592
line 1186
;1186:			model.hModel = cgs.media.redFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+108
INDIRI4
ASGNI4
line 1187
;1187:		}
ADDRGP4 $593
JUMPV
LABELV $592
line 1188
;1188:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
NEI4 $597
line 1189
;1189:			model.hModel = cgs.media.blueFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+112
INDIRI4
ASGNI4
line 1190
;1190:		}
ADDRGP4 $598
JUMPV
LABELV $597
line 1191
;1191:		else {
line 1192
;1192:			model.hModel = cgs.media.neutralFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+116
INDIRI4
ASGNI4
line 1193
;1193:		}
LABELV $598
LABELV $593
line 1194
;1194:		trap_R_AddRefEntityToScene( &model );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1195
;1195:	}
LABELV $586
line 1314
;1196:#ifdef MISSIONPACK
;1197:	else if ( cgs.gametype == GT_OBELISK ) {
;1198:		// show the obelisk
;1199:		memset(&model, 0, sizeof(model));
;1200:		model.reType = RT_MODEL;
;1201:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1202:		VectorCopy( cent->lerpOrigin, model.origin );
;1203:		AnglesToAxis( cent->currentState.angles, model.axis );
;1204:
;1205:		model.hModel = cgs.media.overloadBaseModel;
;1206:		trap_R_AddRefEntityToScene( &model );
;1207:		// if hit
;1208:		if ( cent->currentState.frame == 1) {
;1209:			// show hit model
;1210:			// modelindex2 is the health value of the obelisk
;1211:			c = cent->currentState.modelindex2;
;1212:			model.shaderRGBA[0] = 0xff;
;1213:			model.shaderRGBA[1] = c;
;1214:			model.shaderRGBA[2] = c;
;1215:			model.shaderRGBA[3] = 0xff;
;1216:			//
;1217:			model.hModel = cgs.media.overloadEnergyModel;
;1218:			trap_R_AddRefEntityToScene( &model );
;1219:		}
;1220:		// if respawning
;1221:		if ( cent->currentState.frame == 2) {
;1222:			if ( !cent->miscTime ) {
;1223:				cent->miscTime = cg.time;
;1224:			}
;1225:			t = cg.time - cent->miscTime;
;1226:			h = (cg_obeliskRespawnDelay.integer - 5) * 1000;
;1227:			//
;1228:			if (t > h) {
;1229:				c = (float) (t - h) / h;
;1230:				if (c > 1)
;1231:					c = 1;
;1232:			}
;1233:			else {
;1234:				c = 0;
;1235:			}
;1236:			// show the lights
;1237:			AnglesToAxis( cent->currentState.angles, model.axis );
;1238:			//
;1239:			model.shaderRGBA[0] = c * 0xff;
;1240:			model.shaderRGBA[1] = c * 0xff;
;1241:			model.shaderRGBA[2] = c * 0xff;
;1242:			model.shaderRGBA[3] = c * 0xff;
;1243:
;1244:			model.hModel = cgs.media.overloadLightsModel;
;1245:			trap_R_AddRefEntityToScene( &model );
;1246:			// show the target
;1247:			if (t > h) {
;1248:				if ( !cent->muzzleFlashTime ) {
;1249:					trap_S_StartSound (cent->lerpOrigin, ENTITYNUM_NONE, CHAN_BODY,  cgs.media.obeliskRespawnSound);
;1250:					cent->muzzleFlashTime = 1;
;1251:				}
;1252:				VectorCopy(cent->currentState.angles, angles);
;1253:				angles[YAW] += (float) 16 * acos(1-c) * 180 / M_PI;
;1254:				AnglesToAxis( angles, model.axis );
;1255:
;1256:				VectorScale( model.axis[0], c, model.axis[0]);
;1257:				VectorScale( model.axis[1], c, model.axis[1]);
;1258:				VectorScale( model.axis[2], c, model.axis[2]);
;1259:
;1260:				model.shaderRGBA[0] = 0xff;
;1261:				model.shaderRGBA[1] = 0xff;
;1262:				model.shaderRGBA[2] = 0xff;
;1263:				model.shaderRGBA[3] = 0xff;
;1264:				//
;1265:				model.origin[2] += 56;
;1266:				model.hModel = cgs.media.overloadTargetModel;
;1267:				trap_R_AddRefEntityToScene( &model );
;1268:			}
;1269:			else {
;1270:				//FIXME: show animated smoke
;1271:			}
;1272:		}
;1273:		else {
;1274:			cent->miscTime = 0;
;1275:			cent->muzzleFlashTime = 0;
;1276:			// modelindex2 is the health value of the obelisk
;1277:			c = cent->currentState.modelindex2;
;1278:			model.shaderRGBA[0] = 0xff;
;1279:			model.shaderRGBA[1] = c;
;1280:			model.shaderRGBA[2] = c;
;1281:			model.shaderRGBA[3] = 0xff;
;1282:			// show the lights
;1283:			model.hModel = cgs.media.overloadLightsModel;
;1284:			trap_R_AddRefEntityToScene( &model );
;1285:			// show the target
;1286:			model.origin[2] += 56;
;1287:			model.hModel = cgs.media.overloadTargetModel;
;1288:			trap_R_AddRefEntityToScene( &model );
;1289:		}
;1290:	}
;1291:	else if ( cgs.gametype == GT_HARVESTER ) {
;1292:		// show harvester model
;1293:		memset(&model, 0, sizeof(model));
;1294:		model.reType = RT_MODEL;
;1295:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1296:		VectorCopy( cent->lerpOrigin, model.origin );
;1297:		AnglesToAxis( cent->currentState.angles, model.axis );
;1298:
;1299:		if ( cent->currentState.modelindex == TEAM_RED ) {
;1300:			model.hModel = cgs.media.harvesterModel;
;1301:			model.customSkin = cgs.media.harvesterRedSkin;
;1302:		}
;1303:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;1304:			model.hModel = cgs.media.harvesterModel;
;1305:			model.customSkin = cgs.media.harvesterBlueSkin;
;1306:		}
;1307:		else {
;1308:			model.hModel = cgs.media.harvesterNeutralModel;
;1309:			model.customSkin = 0;
;1310:		}
;1311:		trap_R_AddRefEntityToScene( &model );
;1312:	}
;1313:#endif
;1314:}
LABELV $585
endproc CG_TeamBase 140 12
proc CG_AddCEntity 8 8
line 1322
;1315:
;1316:/*
;1317:===============
;1318:CG_AddCEntity
;1319:
;1320:===============
;1321:*/
;1322:static void CG_AddCEntity( centity_t *cent ) {
line 1324
;1323:	// event-only entities will have been dealt with already
;1324:	if ( cent->currentState.eType >= ET_EVENTS ) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 14
LTI4 $606
line 1325
;1325:		return;
ADDRGP4 $605
JUMPV
LABELV $606
line 1329
;1326:	}
;1327:
;1328:	// calculate the current origin
;1329:	CG_CalcEntityLerpPositions( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CalcEntityLerpPositions
CALLV
pop
line 1332
;1330:
;1331:	// add automatic effects
;1332:	CG_EntityEffects( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_EntityEffects
CALLV
pop
line 1334
;1333:
;1334:	switch ( cent->currentState.eType ) {
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
LTI4 $608
ADDRLP4 0
INDIRI4
CNSTI4 13
GTI4 $608
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $624
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $624
address $613
address $614
address $615
address $616
address $617
address $618
address $619
address $620
address $609
address $609
address $609
address $621
address $622
address $623
code
LABELV $608
line 1336
;1335:	default:
;1336:		CG_Error( "Bad entity type: %i\n", cent->currentState.eType );
ADDRGP4 $611
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
line 1337
;1337:		break;
ADDRGP4 $609
JUMPV
line 1341
;1338:	case ET_INVISIBLE:
;1339:	case ET_PUSH_TRIGGER:
;1340:	case ET_TELEPORT_TRIGGER:
;1341:		break;
LABELV $613
line 1343
;1342:	case ET_GENERAL:
;1343:		CG_General( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_General
CALLV
pop
line 1344
;1344:		break;
ADDRGP4 $609
JUMPV
LABELV $614
line 1346
;1345:	case ET_PLAYER:
;1346:		CG_Player( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Player
CALLV
pop
line 1347
;1347:		break;
ADDRGP4 $609
JUMPV
LABELV $615
line 1349
;1348:	case ET_ITEM:
;1349:		CG_Item( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Item
CALLV
pop
line 1350
;1350:		break;
ADDRGP4 $609
JUMPV
LABELV $616
line 1352
;1351:	case ET_MISSILE:
;1352:		CG_Missile( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Missile
CALLV
pop
line 1353
;1353:		break;
ADDRGP4 $609
JUMPV
LABELV $617
line 1355
;1354:	case ET_MOVER:
;1355:		CG_Mover( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Mover
CALLV
pop
line 1356
;1356:		break;
ADDRGP4 $609
JUMPV
LABELV $618
line 1358
;1357:	case ET_BEAM:
;1358:		CG_Beam( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Beam
CALLV
pop
line 1359
;1359:		break;
ADDRGP4 $609
JUMPV
LABELV $619
line 1361
;1360:	case ET_PORTAL:
;1361:		CG_Portal( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Portal
CALLV
pop
line 1362
;1362:		break;
ADDRGP4 $609
JUMPV
LABELV $620
line 1364
;1363:	case ET_SPEAKER:
;1364:		CG_Speaker( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Speaker
CALLV
pop
line 1365
;1365:		break;
ADDRGP4 $609
JUMPV
LABELV $621
line 1367
;1366:	case ET_GRAPPLE:
;1367:		CG_Grapple( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Grapple
CALLV
pop
line 1368
;1368:		break;
ADDRGP4 $609
JUMPV
LABELV $622
line 1370
;1369:	case ET_TEAM:
;1370:		CG_TeamBase( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_TeamBase
CALLV
pop
line 1371
;1371:		break;
ADDRGP4 $609
JUMPV
LABELV $623
line 1373
;1372:	case ET_MONSTER:
;1373:		CG_Monster(cent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Monster
CALLV
pop
line 1374
;1374:		break;	
LABELV $609
line 1376
;1375:	}
;1376:}
LABELV $605
endproc CG_AddCEntity 8 8
export CG_AddPacketEntities
proc CG_AddPacketEntities 20 12
line 1384
;1377:
;1378:/*
;1379:===============
;1380:CG_AddPacketEntities
;1381:
;1382:===============
;1383:*/
;1384:void CG_AddPacketEntities( void ) {
line 1390
;1385:	int					num;
;1386:	centity_t			*cent;
;1387:	playerState_t		*ps;
;1388:
;1389:	// set cg.frameInterpolation
;1390:	if ( cg.nextSnap ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $626
line 1393
;1391:		int		delta;
;1392:
;1393:		delta = (cg.nextSnap->serverTime - cg.snap->serverTime);
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
line 1394
;1394:		if ( delta == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $631
line 1395
;1395:			cg.frameInterpolation = 0;
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1396
;1396:		} else {
ADDRGP4 $627
JUMPV
LABELV $631
line 1397
;1397:			cg.frameInterpolation = (float)( cg.time - cg.snap->serverTime ) / delta;
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
line 1398
;1398:		}
line 1399
;1399:	} else {
ADDRGP4 $627
JUMPV
LABELV $626
line 1400
;1400:		cg.frameInterpolation = 0;	// actually, it should never be used, because 
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1402
;1401:									// no entities should be marked as interpolating
;1402:	}
LABELV $627
line 1405
;1403:
;1404:	// the auto-rotating items will all have the same axis
;1405:	cg.autoAngles[0] = 0;
ADDRGP4 cg+108948
CNSTF4 0
ASGNF4
line 1406
;1406:	cg.autoAngles[1] = ( cg.time & 2047 ) * 360 / 2048.0;
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
line 1407
;1407:	cg.autoAngles[2] = 0;
ADDRGP4 cg+108948+8
CNSTF4 0
ASGNF4
line 1409
;1408:
;1409:	cg.autoAnglesFast[0] = 0;
ADDRGP4 cg+108996
CNSTF4 0
ASGNF4
line 1410
;1410:	cg.autoAnglesFast[1] = ( cg.time & 1023 ) * 360 / 1024.0f;
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
line 1411
;1411:	cg.autoAnglesFast[2] = 0;
ADDRGP4 cg+108996+8
CNSTF4 0
ASGNF4
line 1413
;1412:
;1413:	AnglesToAxis( cg.autoAngles, cg.autoAxis );
ADDRGP4 cg+108948
ARGP4
ADDRGP4 cg+108960
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1414
;1414:	AnglesToAxis( cg.autoAnglesFast, cg.autoAxisFast );
ADDRGP4 cg+108996
ARGP4
ADDRGP4 cg+109008
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1417
;1415:
;1416:	// generate and add the entity from the playerstate
;1417:	ps = &cg.predictedPlayerState;
ADDRLP4 8
ADDRGP4 cg+107636
ASGNP4
line 1418
;1418:	BG_PlayerStateToEntityState( ps, &cg.predictedPlayerEntity.currentState, qfalse );
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
line 1419
;1419:	CG_AddCEntity( &cg.predictedPlayerEntity );
ADDRGP4 cg+108104
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1422
;1420:
;1421:	// lerp the non-predicted value for lightning gun origins
;1422:	CG_CalcEntityLerpPositions( &cg_entities[ cg.snap->ps.clientNum ] );
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
line 1425
;1423:
;1424:	// add each entity sent over by the server
;1425:	for ( num = 0 ; num < cg.snap->numEntities ; num++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $661
JUMPV
LABELV $658
line 1426
;1426:		cent = &cg_entities[ cg.snap->entities[ num ].number ];
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
line 1427
;1427:		CG_AddCEntity( cent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1428
;1428:	}
LABELV $659
line 1425
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $661
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
LTI4 $658
line 1429
;1429:}
LABELV $625
endproc CG_AddPacketEntities 20 12
bss
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
LABELV $611
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
LABELV $552
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
LABELV $199
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
LABELV $145
byte 1 110
byte 1 111
byte 1 110
byte 1 101
byte 1 0
align 1
LABELV $140
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
LABELV $130
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
LABELV $127
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
LABELV $123
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
LABELV $119
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
LABELV $118
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
LABELV $117
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
