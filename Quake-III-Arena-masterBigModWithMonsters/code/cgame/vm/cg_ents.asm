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
address $120
address $121
address $122
byte 4 0
code
proc CG_LoadMonsterShader 9588 16
line 219
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
;211:	"models/monsters/D3Imp/monster.cfg",
;212:	"models/monsters/Gross/monster.cfg",
;213:	"models/monsters/Mancubus/monster.cfg",
;214:	NULL
;215:};
;216:
;217:static void CG_LoadMonsterShader(
;218:	const char *filename
;219:) {
line 226
;220:	fileHandle_t file;
;221:	char text[MAX_MONSTER_CONFIG_TEXT];
;222:	char error[256];
;223:	monsterDef_t def;
;224:	int length;
;225:
;226:	length = trap_FS_FOpenFile(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1112
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 9564
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 1108
ADDRLP4 9564
INDIRI4
ASGNI4
line 232
;227:		filename,
;228:		&file,
;229:		FS_READ
;230:	);
;231:
;232:	if( !file ) {
ADDRLP4 1112
INDIRI4
CNSTI4 0
NEI4 $124
line 233
;233:		CG_Printf(
ADDRGP4 $126
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 237
;234:			"Monster config not found: %s\n",
;235:			filename
;236:		);
;237:		return;
ADDRGP4 $123
JUMPV
LABELV $124
line 240
;238:	}
;239:
;240:	if( length <= 0 ||
ADDRLP4 1108
INDIRI4
CNSTI4 0
LEI4 $129
ADDRLP4 1108
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $127
LABELV $129
line 241
;241:		length >= sizeof(text) ) {
line 242
;242:		CG_Printf(
ADDRGP4 $130
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 247
;243:			"Invalid monster config size: %s\n",
;244:			filename
;245:		);
;246:
;247:		trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 248
;248:		return;
ADDRGP4 $123
JUMPV
LABELV $127
line 251
;249:	}
;250:
;251:	trap_FS_Read(text, length, file);
ADDRLP4 1116
ARGP4
ADDRLP4 1108
INDIRI4
ARGI4
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 252
;252:	text[length] = '\0';
ADDRLP4 1108
INDIRI4
ADDRLP4 1116
ADDP4
CNSTI1 0
ASGNI1
line 253
;253:	trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 255
;254:
;255:	if( !BG_ParseMonsterConfig(
ADDRLP4 1116
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 9308
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 9572
ADDRGP4 BG_ParseMonsterConfig
CALLI4
ASGNI4
ADDRLP4 9572
INDIRI4
CNSTI4 0
NEI4 $131
line 260
;256:		text,
;257:		&def,
;258:		error,
;259:		sizeof(error)
;260:	) ) {
line 261
;261:		CG_Printf(
ADDRGP4 $133
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9308
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 266
;262:			"Monster config error in %s: %s\n",
;263:			filename,
;264:			error
;265:		);
;266:		return;
ADDRGP4 $123
JUMPV
LABELV $131
line 269
;267:	}
;268:
;269:	if( def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 9576
CNSTI4 0
ASGNI4
ADDRLP4 0+576
INDIRI4
ADDRLP4 9576
INDIRI4
LEI4 $142
ADDRLP4 0+576
INDIRI4
CNSTI4 6
GEI4 $142
ADDRLP4 0+580
INDIRI4
ADDRLP4 9576
INDIRI4
LTI4 $142
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $134
LABELV $142
line 273
;270:		def.monsterType >= MONSTER_TYPE_RANDOM ||
;271:		def.monsterSlot < 0 ||
;272:		def.monsterSlot >=
;273:			MAX_MONSTERS_PER_TYPE ) {
line 274
;274:		CG_Printf(
ADDRGP4 $143
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 278
;275:			"Invalid monster definition in %s\n",
;276:			filename
;277:		);
;278:		return;
ADDRGP4 $123
JUMPV
LABELV $134
line 281
;279:	}
;280:
;281:	if( !def.shader[0] ||
ADDRLP4 0+320
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $149
ADDRLP4 0+320
ARGP4
ADDRGP4 $148
ARGP4
ADDRLP4 9580
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 9580
INDIRI4
CNSTI4 0
NEI4 $144
LABELV $149
line 282
;282:		!Q_stricmp(def.shader, "none") ) {
line 283
;283:		return;
ADDRGP4 $123
JUMPV
LABELV $144
line 286
;284:	}
;285:
;286:	cg_monsterShaders
ADDRLP4 0+320
ARGP4
ADDRLP4 9584
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
ADDRLP4 9584
INDIRI4
ASGNI4
line 290
;287:		[def.monsterType]
;288:		[def.monsterSlot] =
;289:		trap_R_RegisterShader(def.shader);
;290:}
LABELV $123
endproc CG_LoadMonsterShader 9588 16
export CG_InitMonsterShaders
proc CG_InitMonsterShaders 4 12
line 292
;291:
;292:void CG_InitMonsterShaders( void ) {
line 295
;293:	int i;
;294:
;295:	memset(
ADDRGP4 cg_monsterShaders
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 301
;296:		cg_monsterShaders,
;297:		0,
;298:		sizeof(cg_monsterShaders)
;299:	);
;300:
;301:	for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $157
JUMPV
LABELV $154
line 303
;302:		cg_monsterConfigFiles[i];
;303:		i++ ) {
line 304
;304:		CG_LoadMonsterShader(
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
line 307
;305:			cg_monsterConfigFiles[i]
;306:		);
;307:	}
LABELV $155
line 303
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $157
line 302
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $154
line 308
;308:}
LABELV $153
endproc CG_InitMonsterShaders 4 12
proc CG_Monster 196 12
line 315
;309:
;310:/*
;311:==================
;312:Monster
;313:==================
;314:*/
;315:static void CG_Monster( centity_t *cent ) {
line 324
;316:	refEntity_t renderEntity;
;317:	qhandle_t customShader;
;318:	int monsterType;
;319:	int monsterSlot;
;320:	int packedDefinition;
;321:	int models[4];
;322:	int i;
;323:
;324:	packedDefinition =
ADDRLP4 172
ADDRFP4 0
INDIRP4
CNSTI4 204
ADDP4
INDIRI4
ASGNI4
line 327
;325:		cent->currentState.generic1;
;326:
;327:	monsterType =
ADDRLP4 164
ADDRLP4 172
INDIRI4
CNSTI4 255
BANDI4
ASGNI4
line 330
;328:		packedDefinition & 255;
;329:
;330:	monsterSlot =
ADDRLP4 168
ADDRLP4 172
INDIRI4
CNSTI4 8
RSHI4
CNSTI4 255
BANDI4
ASGNI4
line 333
;331:		(packedDefinition >> 8) & 255;
;332:
;333:	customShader = 0;
ADDRLP4 160
CNSTI4 0
ASGNI4
line 335
;334:
;335:	if( monsterType > MONSTER_TYPE_OFF &&
ADDRLP4 180
CNSTI4 0
ASGNI4
ADDRLP4 164
INDIRI4
ADDRLP4 180
INDIRI4
LEI4 $159
ADDRLP4 164
INDIRI4
CNSTI4 6
GEI4 $159
ADDRLP4 168
INDIRI4
ADDRLP4 180
INDIRI4
LTI4 $159
ADDRLP4 168
INDIRI4
CNSTI4 5
GEI4 $159
line 339
;336:		monsterType < MONSTER_TYPE_RANDOM &&
;337:		monsterSlot >= 0 &&
;338:		monsterSlot <
;339:			MAX_MONSTERS_PER_TYPE ) {
line 340
;340:		customShader =
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
line 344
;341:			cg_monsterShaders
;342:				[monsterType]
;343:				[monsterSlot];
;344:	}
LABELV $159
line 346
;345:
;346:	models[0] =
ADDRLP4 144
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ASGNI4
line 349
;347:		cent->currentState.modelindex;
;348:
;349:	models[1] =
ADDRLP4 144+4
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
ASGNI4
line 352
;350:		cent->currentState.modelindex2;
;351:
;352:	models[2] =
ADDRLP4 144+8
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 355
;353:		cent->currentState.otherEntityNum;
;354:
;355:	models[3] =
ADDRLP4 144+12
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 358
;356:		cent->currentState.otherEntityNum2;
;357:
;358:	for( i = 0; i < 4; i++ ) {
ADDRLP4 140
CNSTI4 0
ASGNI4
LABELV $164
line 359
;359:		if( models[i] <= 0 ) {
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 144
ADDP4
INDIRI4
CNSTI4 0
GTI4 $168
line 360
;360:			continue;
ADDRGP4 $165
JUMPV
LABELV $168
line 363
;361:		}
;362:
;363:		memset(
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 369
;364:			&renderEntity,
;365:			0,
;366:			sizeof(renderEntity)
;367:		);
;368:
;369:		renderEntity.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 371
;370:
;371:		renderEntity.hModel =
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
line 374
;372:			cgs.gameModels[models[i]];
;373:
;374:		renderEntity.customShader =
ADDRLP4 0+112
ADDRLP4 160
INDIRI4
ASGNI4
line 377
;375:			customShader;
;376:
;377:		renderEntity.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 378
;378:		renderEntity.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 379
;379:		renderEntity.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 380
;380:		renderEntity.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 382
;381:
;382:		renderEntity.oldframe =
ADDRLP4 0+96
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 385
;383:			cent->currentState.frame;
;384:
;385:		renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 388
;386:			cent->currentState.frame;
;387:
;388:		renderEntity.backlerp = 0;
ADDRLP4 0+100
CNSTF4 0
ASGNF4
line 390
;389:
;390:		if( cent->interpolate &&
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
EQI4 $183
ADDRLP4 192
INDIRP4
CNSTI4 212
ADDP4
INDIRI4
CNSTI4 13
NEI4 $183
line 392
;391:			cent->nextState.eType ==
;392:				ET_MONSTER ) {
line 393
;393:			renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 380
ADDP4
INDIRI4
ASGNI4
line 396
;394:				cent->nextState.frame;
;395:
;396:			renderEntity.backlerp =
ADDRLP4 0+100
CNSTF4 1065353216
ADDRGP4 cg+107588
INDIRF4
SUBF4
ASGNF4
line 399
;397:				1.0f -
;398:				cg.frameInterpolation;
;399:		}
LABELV $183
line 401
;400:
;401:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 406
;402:			cent->lerpOrigin,
;403:			renderEntity.origin
;404:		);
;405:
;406:		VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 411
;407:			cent->lerpOrigin,
;408:			renderEntity.oldorigin
;409:		);
;410:
;411:		AnglesToAxis(
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
line 416
;412:			cent->lerpAngles,
;413:			renderEntity.axis
;414:		);
;415:
;416:		trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 419
;417:			&renderEntity
;418:		);
;419:	}
LABELV $165
line 358
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 4
LTI4 $164
line 420
;420:}
LABELV $158
endproc CG_Monster 196 12
proc CG_Speaker 16 16
line 429
;421:
;422:/*
;423:==================
;424:CG_Speaker
;425:
;426:Speaker entities can automatically play sounds
;427:==================
;428:*/
;429:static void CG_Speaker( centity_t *cent ) {
line 430
;430:	if ( ! cent->currentState.clientNum ) {	// FIXME: use something other than clientNum...
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
CNSTI4 0
NEI4 $192
line 431
;431:		return;		// not auto triggering
ADDRGP4 $191
JUMPV
LABELV $192
line 434
;432:	}
;433:
;434:	if ( cg.time < cent->miscTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRI4
GEI4 $194
line 435
;435:		return;
ADDRGP4 $191
JUMPV
LABELV $194
line 438
;436:	}
;437:
;438:	trap_S_StartSound (NULL, cent->currentState.number, CHAN_ITEM, cgs.gameSounds[cent->currentState.eventParm] );
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
line 442
;439:
;440:	//	ent->s.frame = ent->wait * 10;
;441:	//	ent->s.clientNum = ent->random * 10;
;442:	cent->miscTime = cg.time + cent->currentState.frame * 100 + cent->currentState.clientNum * 100 * crandom();
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
line 443
;443:}
LABELV $191
endproc CG_Speaker 16 16
proc CG_Item 204 12
line 450
;444:
;445:/*
;446:==================
;447:CG_Item
;448:==================
;449:*/
;450:static void CG_Item( centity_t *cent ) {
line 459
;451:	refEntity_t	ent;
;452:	entityState_t	*es;
;453:	gitem_t		*item;
;454:	int		msec;
;455:	float		frac;
;456:	float		scale;
;457:	weaponInfo_t	*wi;
;458:
;459:	es = &cent->currentState;
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
line 461
;460:
;461:	if( es->modelindex >= bg_numItems ) {
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $200
line 462
;462:		CG_Error(
ADDRGP4 $202
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
line 466
;463:			"Bad item index %i on entity",
;464:			es->modelindex
;465:		);
;466:	}
LABELV $200
line 469
;467:
;468:	// if set to invisible, skip
;469:	if( !es->modelindex ||
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
EQI4 $205
ADDRLP4 144
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 128
BANDI4
ADDRLP4 168
INDIRI4
EQI4 $203
LABELV $205
line 470
;470:		(es->eFlags & EF_NODRAW) ) {
line 471
;471:		return;
ADDRGP4 $199
JUMPV
LABELV $203
line 474
;472:	}
;473:
;474:	item = &bg_itemlist[es->modelindex];
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
line 476
;475:
;476:	if( cg_simpleItems.integer &&
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
EQI4 $206
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
EQI4 $206
line 477
;477:		item->giType != IT_TEAM ) {
line 478
;478:		memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 480
;479:
;480:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 481
;481:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 485
;482:			cent->lerpOrigin,
;483:			ent.origin
;484:		);
;485:		ent.radius = 14;
ADDRLP4 0+132
CNSTF4 1096810496
ASGNF4
line 486
;486:		ent.customShader =
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
line 488
;487:			cg_items[es->modelindex].icon;
;488:		ent.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 489
;489:		ent.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 490
;490:		ent.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 491
;491:		ent.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 493
;492:
;493:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 494
;494:		return;
ADDRGP4 $199
JUMPV
LABELV $206
line 501
;495:	}
;496:
;497:	/*
;498:	 * Normal items continuously bob up and down.
;499:	 * Static items retain their original map position.
;500:	 */
;501:	if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $220
line 502
;502:		scale =
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
line 506
;503:			0.005 +
;504:			cent->currentState.number * 0.00001;
;505:
;506:		cent->lerpOrigin[2] +=
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
line 509
;507:			4 +
;508:			cos((cg.time + 1000) * scale) * 4;
;509:	}
LABELV $220
line 511
;510:
;511:	memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 517
;512:
;513:	/*
;514:	 * Static items use a fixed identity axis.
;515:	 * Normal items use the original automatic rotation.
;516:	 */
;517:	if( cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
EQI4 $224
line 518
;518:		VectorClear( cent->lerpAngles );
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
line 519
;519:		AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 520
;520:	}
ADDRGP4 $225
JUMPV
LABELV $224
line 521
;521:	else if( item->giType == IT_HEALTH ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 4
NEI4 $228
line 522
;522:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108996
INDIRB
ASGNB 12
line 526
;523:			cg.autoAnglesFast,
;524:			cent->lerpAngles
;525:		);
;526:		AxisCopy(
ADDRGP4 cg+109008
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 530
;527:			cg.autoAxisFast,
;528:			ent.axis
;529:		);
;530:	}
ADDRGP4 $229
JUMPV
LABELV $228
line 531
;531:	else {
line 532
;532:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108948
INDIRB
ASGNB 12
line 536
;533:			cg.autoAngles,
;534:			cent->lerpAngles
;535:		);
;536:		AxisCopy(
ADDRGP4 cg+108960
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 540
;537:			cg.autoAxis,
;538:			ent.axis
;539:		);
;540:	}
LABELV $229
LABELV $225
line 542
;541:
;542:	wi = NULL;
ADDRLP4 152
CNSTP4 0
ASGNP4
line 548
;543:
;544:	/*
;545:	 * Weapon models have their origin at the attachment point,
;546:	 * so compensate using the weapon midpoint.
;547:	 */
;548:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $236
line 549
;549:		wi = &cg_weapons[item->giTag];
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
line 551
;550:
;551:		cent->lerpOrigin[0] -=
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
line 556
;552:			wi->weaponMidpoint[0] * ent.axis[0][0] +
;553:			wi->weaponMidpoint[1] * ent.axis[1][0] +
;554:			wi->weaponMidpoint[2] * ent.axis[2][0];
;555:
;556:		cent->lerpOrigin[1] -=
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
line 561
;557:			wi->weaponMidpoint[0] * ent.axis[0][1] +
;558:			wi->weaponMidpoint[1] * ent.axis[1][1] +
;559:			wi->weaponMidpoint[2] * ent.axis[2][1];
;560:
;561:		cent->lerpOrigin[2] -=
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
line 566
;562:			wi->weaponMidpoint[0] * ent.axis[0][2] +
;563:			wi->weaponMidpoint[1] * ent.axis[1][2] +
;564:			wi->weaponMidpoint[2] * ent.axis[2][2];
;565:
;566:		cent->lerpOrigin[2] += 8;
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
line 567
;567:	}
LABELV $236
line 569
;568:
;569:	ent.hModel =
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
line 572
;570:		cg_items[es->modelindex].models[0];
;571:
;572:	VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 576
;573:		cent->lerpOrigin,
;574:		ent.origin
;575:	);
;576:	VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 581
;577:		cent->lerpOrigin,
;578:		ent.oldorigin
;579:	);
;580:
;581:	ent.nonNormalizedAxes = qfalse;
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 587
;582:
;583:	/*
;584:	 * Static items appear immediately at full size.
;585:	 * Normal items retain the respawn scale animation.
;586:	 */
;587:	msec = cg.time - cent->miscTime;
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
line 589
;588:
;589:	if( !cg_staticItems.integer &&
ADDRLP4 172
CNSTI4 0
ASGNI4
ADDRGP4 cg_staticItems+12
INDIRI4
ADDRLP4 172
INDIRI4
NEI4 $265
ADDRLP4 156
INDIRI4
ADDRLP4 172
INDIRI4
LTI4 $265
ADDRLP4 156
INDIRI4
CNSTI4 1000
GEI4 $265
line 591
;590:		msec >= 0 &&
;591:		msec < ITEM_SCALEUP_TIME ) {
line 592
;592:		frac = (float)msec /
ADDRLP4 148
ADDRLP4 156
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 595
;593:			ITEM_SCALEUP_TIME;
;594:
;595:		VectorScale(
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
line 600
;596:			ent.axis[0],
;597:			frac,
;598:			ent.axis[0]
;599:		);
;600:		VectorScale(
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
line 605
;601:			ent.axis[1],
;602:			frac,
;603:			ent.axis[1]
;604:		);
;605:		VectorScale(
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
line 611
;606:			ent.axis[2],
;607:			frac,
;608:			ent.axis[2]
;609:		);
;610:
;611:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 612
;612:	}
ADDRGP4 $266
JUMPV
LABELV $265
line 613
;613:	else {
line 614
;614:		frac = 1.0f;
ADDRLP4 148
CNSTF4 1065353216
ASGNF4
line 615
;615:	}
LABELV $266
line 620
;616:
;617:	/*
;618:	 * Items without glow textures need a minimum light value.
;619:	 */
;620:	if( item->giType == IT_WEAPON ||
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
EQI4 $313
ADDRLP4 180
INDIRI4
CNSTI4 3
NEI4 $311
LABELV $313
line 621
;621:		item->giType == IT_ARMOR ) {
line 622
;622:		ent.renderfx |= RF_MINLIGHT;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 623
;623:	}
LABELV $311
line 626
;624:
;625:	// increase the size of weapon pickup models
;626:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $315
line 627
;627:		VectorScale(
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
line 632
;628:			ent.axis[0],
;629:			1.5f,
;630:			ent.axis[0]
;631:		);
;632:		VectorScale(
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
line 637
;633:			ent.axis[1],
;634:			1.5f,
;635:			ent.axis[1]
;636:		);
;637:		VectorScale(
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
line 643
;638:			ent.axis[2],
;639:			1.5f,
;640:			ent.axis[2]
;641:		);
;642:
;643:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 655
;644:
;645:#ifdef MISSIONPACK
;646:		if( !cg_staticItems.integer ) {
;647:			trap_S_AddLoopingSound(
;648:				cent->currentState.number,
;649:				cent->lerpOrigin,
;650:				vec3_origin,
;651:				cgs.media.weaponHoverSound
;652:			);
;653:		}
;654:#endif
;655:	}
LABELV $315
line 681
;656:
;657:#ifdef MISSIONPACK
;658:	if( item->giType == IT_HOLDABLE &&
;659:		item->giTag == HI_KAMIKAZE ) {
;660:		VectorScale(
;661:			ent.axis[0],
;662:			2,
;663:			ent.axis[0]
;664:		);
;665:		VectorScale(
;666:			ent.axis[1],
;667:			2,
;668:			ent.axis[1]
;669:		);
;670:		VectorScale(
;671:			ent.axis[2],
;672:			2,
;673:			ent.axis[2]
;674:		);
;675:
;676:		ent.nonNormalizedAxes = qtrue;
;677:	}
;678:#endif
;679:
;680:	// add main model
;681:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 728
;682:
;683:#ifdef MISSIONPACK
;684:	if( item->giType == IT_WEAPON &&
;685:		wi->barrelModel ) {
;686:		refEntity_t barrel;
;687:
;688:		memset(
;689:			&barrel,
;690:			0,
;691:			sizeof(barrel)
;692:		);
;693:
;694:		barrel.hModel = wi->barrelModel;
;695:
;696:		VectorCopy(
;697:			ent.lightingOrigin,
;698:			barrel.lightingOrigin
;699:		);
;700:
;701:		barrel.shadowPlane =
;702:			ent.shadowPlane;
;703:		barrel.renderfx =
;704:			ent.renderfx;
;705:
;706:		CG_PositionRotatedEntityOnTag(
;707:			&barrel,
;708:			&ent,
;709:			wi->weaponModel,
;710:			"tag_barrel"
;711:		);
;712:
;713:		AxisCopy(
;714:			ent.axis,
;715:			barrel.axis
;716:		);
;717:
;718:		barrel.nonNormalizedAxes =
;719:			ent.nonNormalizedAxes;
;720:
;721:		trap_R_AddRefEntityToScene(
;722:			&barrel
;723:		);
;724:	}
;725:#endif
;726:
;727:	// accompanying rings and spheres for powerups
;728:	if( !cg_simpleItems.integer ) {
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
NEI4 $360
line 731
;729:		vec3_t spinAngles;
;730:
;731:		VectorClear( spinAngles );
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
line 733
;732:
;733:		if( item->giType == IT_HEALTH ||
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
EQI4 $367
ADDRLP4 200
INDIRI4
CNSTI4 5
NEI4 $365
LABELV $367
line 734
;734:			item->giType == IT_POWERUP ) {
line 735
;735:			ent.hModel =
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
line 740
;736:				cg_items[
;737:					es->modelindex
;738:				].models[1];
;739:
;740:			if( ent.hModel ) {
ADDRLP4 0+8
INDIRI4
CNSTI4 0
EQI4 $371
line 741
;741:				if( item->giType ==
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $374
line 742
;742:					IT_POWERUP ) {
line 743
;743:					ent.origin[2] += 12;
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
CNSTF4 1094713344
ADDF4
ASGNF4
line 745
;744:
;745:					if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $378
line 746
;746:						spinAngles[1] =
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
line 750
;747:							(cg.time & 1023) *
;748:							360 /
;749:							-1024.0f;
;750:					}
LABELV $378
line 751
;751:				}
LABELV $374
line 753
;752:
;753:				AnglesToAxis(
ADDRLP4 184
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 758
;754:					spinAngles,
;755:					ent.axis
;756:				);
;757:
;758:				if( frac != 1.0f ) {
ADDRLP4 148
INDIRF4
CNSTF4 1065353216
EQF4 $384
line 759
;759:					VectorScale(
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
line 764
;760:						ent.axis[0],
;761:						frac,
;762:						ent.axis[0]
;763:					);
;764:					VectorScale(
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
line 769
;765:						ent.axis[1],
;766:						frac,
;767:						ent.axis[1]
;768:					);
;769:					VectorScale(
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
line 775
;770:						ent.axis[2],
;771:						frac,
;772:						ent.axis[2]
;773:					);
;774:
;775:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 777
;776:						qtrue;
;777:				}
ADDRGP4 $385
JUMPV
LABELV $384
line 778
;778:				else {
line 779
;779:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 781
;780:						qfalse;
;781:				}
LABELV $385
line 783
;782:
;783:				trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 786
;784:					&ent
;785:				);
;786:			}
LABELV $371
line 787
;787:		}
LABELV $365
line 788
;788:	}
LABELV $360
line 789
;789:}
LABELV $199
endproc CG_Item 204 12
proc CG_Missile 172 20
line 798
;790:
;791://============================================================================
;792:
;793:/*
;794:===============
;795:CG_Missile
;796:===============
;797:*/
;798:static void CG_Missile( centity_t *cent ) {
line 804
;799:	refEntity_t			ent;
;800:	entityState_t		*s1;
;801:	const weaponInfo_t		*weapon;
;802://	int	col;
;803:
;804:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 805
;805:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $431
line 806
;806:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 807
;807:	}
LABELV $431
line 812
;808:	/*
;809:	 * Lazy weapon registration: monster projectiles may
;810:	 * arrive for a weapon the local player never picked up
;811:	 */
;812:	if ( s1->weapon > WP_NONE &&
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
LEI4 $433
ADDRLP4 148
INDIRI4
CNSTI4 12
GEI4 $433
CNSTI4 136
ADDRLP4 148
INDIRI4
MULI4
ADDRGP4 cg_weapons+80
ADDP4
INDIRI4
ADDRLP4 152
INDIRI4
NEI4 $433
line 814
;813:		s1->weapon < WP_NUM_WEAPONS &&
;814:		!cg_weapons[s1->weapon].missileModel ) {
line 815
;815:		CG_RegisterWeapon( s1->weapon );
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_RegisterWeapon
CALLV
pop
line 816
;816:	}
LABELV $433
line 818
;817:
;818:	weapon = &cg_weapons[s1->weapon];
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
line 821
;819:
;820:	// calculate the axis
;821:	VectorCopy( s1->angles, cent->lerpAngles);
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
line 824
;822:
;823:	// add trails
;824:	if ( weapon->missileTrailFunc ) 
ADDRLP4 144
INDIRP4
CNSTI4 88
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $436
line 825
;825:	{
line 826
;826:		weapon->missileTrailFunc( cent, weapon );
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
line 827
;827:	}
LABELV $436
line 846
;828:/*
;829:	if ( cent->currentState.modelindex == TEAM_RED ) {
;830:		col = 1;
;831:	}
;832:	else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;833:		col = 2;
;834:	}
;835:	else {
;836:		col = 0;
;837:	}
;838:
;839:	// add dynamic light
;840:	if ( weapon->missileDlight ) {
;841:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
;842:			weapon->missileDlightColor[col][0], weapon->missileDlightColor[col][1], weapon->missileDlightColor[col][2] );
;843:	}
;844:*/
;845:	// add dynamic light
;846:	if ( weapon->missileDlight ) {
ADDRLP4 144
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
CNSTF4 0
EQF4 $438
line 847
;847:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
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
line 849
;848:			weapon->missileDlightColor[0], weapon->missileDlightColor[1], weapon->missileDlightColor[2] );
;849:	}
LABELV $438
line 852
;850:
;851:	// add missile sound
;852:	if ( weapon->missileSound ) {
ADDRLP4 144
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 0
EQI4 $440
line 855
;853:		vec3_t	velocity;
;854:
;855:		BG_EvaluateTrajectoryDelta( &cent->currentState.pos, cg.time, velocity );
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
line 857
;856:
;857:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, velocity, weapon->missileSound );
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
line 858
;858:	}
LABELV $440
line 861
;859:
;860:	// create the render entity
;861:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 862
;862:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 863
;863:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 865
;864:
;865:	if ( cent->currentState.weapon == WP_PLASMAGUN ) {
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 8
NEI4 $445
line 866
;866:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 867
;867:		ent.radius = 16;
ADDRLP4 0+132
CNSTF4 1098907648
ASGNF4
line 868
;868:		ent.rotation = 0;
ADDRLP4 0+136
CNSTF4 0
ASGNF4
line 869
;869:		ent.customShader = cgs.media.plasmaBallShader;
ADDRLP4 0+112
ADDRGP4 cgs+152340+288
INDIRI4
ASGNI4
line 870
;870:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 871
;871:		return;
ADDRGP4 $430
JUMPV
LABELV $445
line 875
;872:	}
;873:
;874:	// flicker between two skins
;875:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 876
;876:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 877
;877:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 888
;878:
;879:#ifdef MISSIONPACK
;880:	if ( cent->currentState.weapon == WP_PROX_LAUNCHER ) {
;881:		if (s1->generic1 == TEAM_BLUE) {
;882:			ent.hModel = cgs.media.blueProxMine;
;883:		}
;884:	}
;885:#endif
;886:
;887:	// convert direction of travel into axis
;888:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
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
NEF4 $455
line 889
;889:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 890
;890:	}
LABELV $455
line 893
;891:
;892:	// spin as it moves
;893:	if ( s1->pos.trType != TR_STATIONARY ) {
ADDRLP4 140
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 0
EQI4 $460
line 894
;894:		RotateAroundDirection( ent.axis, cg.time / 4 );
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
line 895
;895:	} else {
ADDRGP4 $461
JUMPV
LABELV $460
line 902
;896:#ifdef MISSIONPACK
;897:		if ( s1->weapon == WP_PROX_LAUNCHER ) {
;898:			AnglesToAxis( cent->lerpAngles, ent.axis );
;899:		}
;900:		else
;901:#endif
;902:		{
line 903
;903:			RotateAroundDirection( ent.axis, s1->time );
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
line 904
;904:		}
line 905
;905:	}
LABELV $461
line 908
;906:
;907:	// add to refresh list, possibly with quad glow
;908:	CG_AddRefEntityWithPowerups( &ent, s1, TEAM_FREE );
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
line 909
;909:}
LABELV $430
endproc CG_Missile 172 20
proc CG_Grapple 152 12
line 918
;910:
;911:/*
;912:===============
;913:CG_Grapple
;914:
;915:This is called when the grapple is sitting up against the wall
;916:===============
;917:*/
;918:static void CG_Grapple( centity_t *cent ) {
line 923
;919:	refEntity_t			ent;
;920:	entityState_t		*s1;
;921:	const weaponInfo_t		*weapon;
;922:
;923:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 924
;924:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $466
line 925
;925:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 926
;926:	}
LABELV $466
line 927
;927:	weapon = &cg_weapons[s1->weapon];
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
line 930
;928:
;929:	// calculate the axis
;930:	VectorCopy( s1->angles, cent->lerpAngles);
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
line 940
;931:
;932:#if 0 // FIXME add grapple pull sound here..?
;933:	// add missile sound
;934:	if ( weapon->missileSound ) {
;935:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, weapon->missileSound );
;936:	}
;937:#endif
;938:
;939:	// Will draw cable if needed
;940:	CG_GrappleTrail ( cent, weapon );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRGP4 CG_GrappleTrail
CALLV
pop
line 943
;941:
;942:	// create the render entity
;943:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 944
;944:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 945
;945:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 948
;946:
;947:	// flicker between two skins
;948:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 949
;949:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 950
;950:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 953
;951:
;952:	// convert direction of travel into axis
;953:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
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
NEF4 $473
line 954
;954:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 955
;955:	}
LABELV $473
line 957
;956:
;957:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 958
;958:}
LABELV $465
endproc CG_Grapple 152 12
proc CG_Mover 144 12
line 965
;959:
;960:/*
;961:===============
;962:CG_Mover
;963:===============
;964:*/
;965:static void CG_Mover( centity_t *cent ) {
line 969
;966:	refEntity_t			ent;
;967:	entityState_t		*s1;
;968:
;969:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 972
;970:
;971:	// create the render entity
;972:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 973
;973:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 974
;974:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 975
;975:	AnglesToAxis( cent->lerpAngles, ent.axis );
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
line 977
;976:
;977:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 980
;978:
;979:	// flicker between two skins (FIXME?)
;980:	ent.skinNum = ( cg.time >> 6 ) & 1;
ADDRLP4 0+104
ADDRGP4 cg+107604
INDIRI4
CNSTI4 6
RSHI4
CNSTI4 1
BANDI4
ASGNI4
line 983
;981:
;982:	// get the model, either as a bmodel or a modelindex
;983:	if ( s1->solid == SOLID_BMODEL ) {
ADDRLP4 140
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
NEI4 $485
line 984
;984:		ent.hModel = cgs.inlineDrawModel[s1->modelindex];
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
line 985
;985:	} else {
ADDRGP4 $486
JUMPV
LABELV $485
line 986
;986:		ent.hModel = cgs.gameModels[s1->modelindex];
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
line 987
;987:	}
LABELV $486
line 990
;988:
;989:	// add to refresh list
;990:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 993
;991:
;992:	// add the secondary model
;993:	if ( s1->modelindex2 ) {
ADDRLP4 140
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $491
line 994
;994:		ent.skinNum = 0;
ADDRLP4 0+104
CNSTI4 0
ASGNI4
line 995
;995:		ent.hModel = cgs.gameModels[s1->modelindex2];
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
line 996
;996:		trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 997
;997:	}
LABELV $491
line 999
;998:
;999:}
LABELV $478
endproc CG_Mover 144 12
export CG_Beam
proc CG_Beam 144 12
line 1008
;1000:
;1001:/*
;1002:===============
;1003:CG_Beam
;1004:
;1005:Also called as an event
;1006:===============
;1007:*/
;1008:void CG_Beam( centity_t *cent ) {
line 1012
;1009:	refEntity_t			ent;
;1010:	entityState_t		*s1;
;1011:
;1012:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1015
;1013:
;1014:	// create the render entity
;1015:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1016
;1016:	VectorCopy( s1->pos.trBase, ent.origin );
ADDRLP4 0+68
ADDRLP4 140
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
line 1017
;1017:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1018
;1018:	AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 1019
;1019:	ent.reType = RT_BEAM;
ADDRLP4 0
CNSTI4 3
ASGNI4
line 1021
;1020:
;1021:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 1024
;1022:
;1023:	// add to refresh list
;1024:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1025
;1025:}
LABELV $496
endproc CG_Beam 144 12
proc CG_Portal 144 12
line 1033
;1026:
;1027:
;1028:/*
;1029:===============
;1030:CG_Portal
;1031:===============
;1032:*/
;1033:static void CG_Portal( centity_t *cent ) {
line 1037
;1034:	refEntity_t			ent;
;1035:	entityState_t		*s1;
;1036:
;1037:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1040
;1038:
;1039:	// create the render entity
;1040:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1041
;1041:	VectorCopy( cent->lerpOrigin, ent.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1042
;1042:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1043
;1043:	ByteToDir( s1->eventParm, ent.axis[0] );
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
line 1044
;1044:	PerpendicularVector( ent.axis[1], ent.axis[0] );
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 1048
;1045:
;1046:	// negating this tends to get the directions like they want
;1047:	// we really should have a camera roll value
;1048:	VectorSubtract( vec3_origin, ent.axis[1], ent.axis[1] );
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
line 1050
;1049:
;1050:	CrossProduct( ent.axis[0], ent.axis[1], ent.axis[2] );
ADDRLP4 0+28
ARGP4
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28+24
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 1051
;1051:	ent.reType = RT_PORTALSURFACE;
ADDRLP4 0
CNSTI4 7
ASGNI4
line 1052
;1052:	ent.oldframe = s1->powerups;
ADDRLP4 0+96
ADDRLP4 140
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
ASGNI4
line 1053
;1053:	ent.frame = s1->frame;		// rotation speed
ADDRLP4 0+80
ADDRLP4 140
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 1054
;1054:	ent.skinNum = s1->clientNum/256.0 * 360;	// roll offset
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
line 1057
;1055:
;1056:	// add to refresh list
;1057:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1058
;1058:}
LABELV $501
endproc CG_Portal 144 12
export CG_AdjustPositionForMover
proc CG_AdjustPositionForMover 92 12
line 1068
;1059:
;1060:
;1061:/*
;1062:=========================
;1063:CG_AdjustPositionForMover
;1064:
;1065:Also called by client movement prediction code
;1066:=========================
;1067:*/
;1068:void CG_AdjustPositionForMover( const vec3_t in, int moverNum, int fromTime, int toTime, vec3_t out ) {
line 1073
;1069:	centity_t	*cent;
;1070:	vec3_t	oldOrigin, origin, deltaOrigin;
;1071:	vec3_t	oldAngles, angles, deltaAngles;
;1072:
;1073:	if ( moverNum <= 0 || moverNum >= ENTITYNUM_MAX_NORMAL ) {
ADDRLP4 76
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
LEI4 $537
ADDRLP4 76
INDIRI4
CNSTI4 1022
LTI4 $535
LABELV $537
line 1074
;1074:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1075
;1075:		return;
ADDRGP4 $534
JUMPV
LABELV $535
line 1078
;1076:	}
;1077:
;1078:	cent = &cg_entities[ moverNum ];
ADDRLP4 0
CNSTI4 728
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 1079
;1079:	if ( cent->currentState.eType != ET_MOVER ) {
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
EQI4 $538
line 1080
;1080:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1081
;1081:		return;
ADDRGP4 $534
JUMPV
LABELV $538
line 1084
;1082:	}
;1083:
;1084:	BG_EvaluateTrajectory( &cent->currentState.pos, fromTime, oldOrigin );
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
line 1085
;1085:	BG_EvaluateTrajectory( &cent->currentState.apos, fromTime, oldAngles );
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
line 1087
;1086:
;1087:	BG_EvaluateTrajectory( &cent->currentState.pos, toTime, origin );
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
line 1088
;1088:	BG_EvaluateTrajectory( &cent->currentState.apos, toTime, angles );
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
line 1090
;1089:
;1090:	VectorSubtract( origin, oldOrigin, deltaOrigin );
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
line 1091
;1091:	VectorSubtract( angles, oldAngles, deltaAngles );
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
line 1093
;1092:
;1093:	VectorAdd( in, deltaOrigin, out );
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
line 1096
;1094:
;1095:	// FIXME: origin change when on a rotating object
;1096:}
LABELV $534
endproc CG_AdjustPositionForMover 92 12
proc CG_InterpolateEntityPosition 44 12
line 1104
;1097:
;1098:
;1099:/*
;1100:=============================
;1101:CG_InterpolateEntityPosition
;1102:=============================
;1103:*/
;1104:static void CG_InterpolateEntityPosition( centity_t *cent ) {
line 1110
;1105:	vec3_t		current, next;
;1106:	float		f;
;1107:
;1108:	// it would be an internal error to find an entity that interpolates without
;1109:	// a snapshot ahead of the current one
;1110:	if ( cg.nextSnap == NULL ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $555
line 1111
;1111:		CG_Error( "CG_InterpoateEntityPosition: cg.nextSnap == NULL" );
ADDRGP4 $558
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 1112
;1112:	}
LABELV $555
line 1114
;1113:
;1114:	f = cg.frameInterpolation;
ADDRLP4 24
ADDRGP4 cg+107588
INDIRF4
ASGNF4
line 1118
;1115:
;1116:	// this will linearize a sine or parabolic curve, but it is important
;1117:	// to not extrapolate player positions if more recent data is available
;1118:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.snap->serverTime, current );
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
line 1119
;1119:	BG_EvaluateTrajectory( &cent->nextState.pos, cg.nextSnap->serverTime, next );
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
line 1121
;1120:
;1121:	cent->lerpOrigin[0] = current[0] + f * ( next[0] - current[0] );
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
line 1122
;1122:	cent->lerpOrigin[1] = current[1] + f * ( next[1] - current[1] );
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
line 1123
;1123:	cent->lerpOrigin[2] = current[2] + f * ( next[2] - current[2] );
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
line 1125
;1124:
;1125:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.snap->serverTime, current );
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
line 1126
;1126:	BG_EvaluateTrajectory( &cent->nextState.apos, cg.nextSnap->serverTime, next );
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
line 1128
;1127:
;1128:	cent->lerpAngles[0] = LerpAngle( current[0], next[0], f );
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
line 1129
;1129:	cent->lerpAngles[1] = LerpAngle( current[1], next[1], f );
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
line 1130
;1130:	cent->lerpAngles[2] = LerpAngle( current[2], next[2], f );
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
line 1132
;1131:
;1132:}
LABELV $554
endproc CG_InterpolateEntityPosition 44 12
proc CG_CalcEntityLerpPositions 24 20
line 1140
;1133:
;1134:/*
;1135:===============
;1136:CG_CalcEntityLerpPositions
;1137:
;1138:===============
;1139:*/
;1140:static void CG_CalcEntityLerpPositions( centity_t *cent ) {
line 1143
;1141:
;1142:	// if this player does not want to see extrapolated players
;1143:	if ( !cg_smoothClients.integer ) {
ADDRGP4 cg_smoothClients+12
INDIRI4
CNSTI4 0
NEI4 $575
line 1145
;1144:		// make sure the clients use TR_INTERPOLATE
;1145:		if ( cent->currentState.number < MAX_CLIENTS ) {
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $578
line 1146
;1146:			cent->currentState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 1147
;1147:			cent->nextState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
CNSTI4 1
ASGNI4
line 1148
;1148:		}
LABELV $578
line 1149
;1149:	}
LABELV $575
line 1151
;1150:
;1151:	if ( cent->interpolate && cent->currentState.pos.trType == TR_INTERPOLATE ) {
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
EQI4 $580
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 1
NEI4 $580
line 1152
;1152:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1153
;1153:		return;
ADDRGP4 $574
JUMPV
LABELV $580
line 1158
;1154:	}
;1155:
;1156:	// first see if we can interpolate between two snaps for
;1157:	// linear extrapolated clients
;1158:	if ( cent->interpolate && cent->currentState.pos.trType == TR_LINEAR_STOP &&
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
EQI4 $582
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 3
NEI4 $582
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $582
line 1159
;1159:											cent->currentState.number < MAX_CLIENTS) {
line 1160
;1160:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1161
;1161:		return;
ADDRGP4 $574
JUMPV
LABELV $582
line 1165
;1162:	}
;1163:
;1164:	// just use the current frame and evaluate as best we can
;1165:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.time, cent->lerpOrigin );
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
line 1166
;1166:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.time, cent->lerpAngles );
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
line 1170
;1167:
;1168:	// adjust for riding a mover if it wasn't rolled into the predicted
;1169:	// player state
;1170:	if ( cent != &cg.predictedPlayerEntity ) {
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 cg+108104
CVPU4 4
EQU4 $586
line 1171
;1171:		CG_AdjustPositionForMover( cent->lerpOrigin, cent->currentState.groundEntityNum, 
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
line 1173
;1172:		cg.snap->serverTime, cg.time, cent->lerpOrigin );
;1173:	}
LABELV $586
line 1174
;1174:}
LABELV $574
endproc CG_CalcEntityLerpPositions 24 20
proc CG_TeamBase 140 12
line 1181
;1175:
;1176:/*
;1177:===============
;1178:CG_TeamBase
;1179:===============
;1180:*/
;1181:static void CG_TeamBase( centity_t *cent ) {
line 1190
;1182:	refEntity_t model;
;1183:#ifdef MISSIONPACK
;1184:	vec3_t angles;
;1185:	int t, h;
;1186:	float c;
;1187:
;1188:	if ( cgs.gametype == GT_CTF || cgs.gametype == GT_1FCTF ) {
;1189:#else
;1190:	if ( cgs.gametype == GT_CTF) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $592
line 1193
;1191:#endif
;1192:		// show the flag base
;1193:		memset(&model, 0, sizeof(model));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1194
;1194:		model.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1195
;1195:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1196
;1196:		VectorCopy( cent->lerpOrigin, model.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1197
;1197:		AnglesToAxis( cent->currentState.angles, model.axis );
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
line 1198
;1198:		if ( cent->currentState.modelindex == TEAM_RED ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $598
line 1199
;1199:			model.hModel = cgs.media.redFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+108
INDIRI4
ASGNI4
line 1200
;1200:		}
ADDRGP4 $599
JUMPV
LABELV $598
line 1201
;1201:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
NEI4 $603
line 1202
;1202:			model.hModel = cgs.media.blueFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+112
INDIRI4
ASGNI4
line 1203
;1203:		}
ADDRGP4 $604
JUMPV
LABELV $603
line 1204
;1204:		else {
line 1205
;1205:			model.hModel = cgs.media.neutralFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+116
INDIRI4
ASGNI4
line 1206
;1206:		}
LABELV $604
LABELV $599
line 1207
;1207:		trap_R_AddRefEntityToScene( &model );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1208
;1208:	}
LABELV $592
line 1327
;1209:#ifdef MISSIONPACK
;1210:	else if ( cgs.gametype == GT_OBELISK ) {
;1211:		// show the obelisk
;1212:		memset(&model, 0, sizeof(model));
;1213:		model.reType = RT_MODEL;
;1214:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1215:		VectorCopy( cent->lerpOrigin, model.origin );
;1216:		AnglesToAxis( cent->currentState.angles, model.axis );
;1217:
;1218:		model.hModel = cgs.media.overloadBaseModel;
;1219:		trap_R_AddRefEntityToScene( &model );
;1220:		// if hit
;1221:		if ( cent->currentState.frame == 1) {
;1222:			// show hit model
;1223:			// modelindex2 is the health value of the obelisk
;1224:			c = cent->currentState.modelindex2;
;1225:			model.shaderRGBA[0] = 0xff;
;1226:			model.shaderRGBA[1] = c;
;1227:			model.shaderRGBA[2] = c;
;1228:			model.shaderRGBA[3] = 0xff;
;1229:			//
;1230:			model.hModel = cgs.media.overloadEnergyModel;
;1231:			trap_R_AddRefEntityToScene( &model );
;1232:		}
;1233:		// if respawning
;1234:		if ( cent->currentState.frame == 2) {
;1235:			if ( !cent->miscTime ) {
;1236:				cent->miscTime = cg.time;
;1237:			}
;1238:			t = cg.time - cent->miscTime;
;1239:			h = (cg_obeliskRespawnDelay.integer - 5) * 1000;
;1240:			//
;1241:			if (t > h) {
;1242:				c = (float) (t - h) / h;
;1243:				if (c > 1)
;1244:					c = 1;
;1245:			}
;1246:			else {
;1247:				c = 0;
;1248:			}
;1249:			// show the lights
;1250:			AnglesToAxis( cent->currentState.angles, model.axis );
;1251:			//
;1252:			model.shaderRGBA[0] = c * 0xff;
;1253:			model.shaderRGBA[1] = c * 0xff;
;1254:			model.shaderRGBA[2] = c * 0xff;
;1255:			model.shaderRGBA[3] = c * 0xff;
;1256:
;1257:			model.hModel = cgs.media.overloadLightsModel;
;1258:			trap_R_AddRefEntityToScene( &model );
;1259:			// show the target
;1260:			if (t > h) {
;1261:				if ( !cent->muzzleFlashTime ) {
;1262:					trap_S_StartSound (cent->lerpOrigin, ENTITYNUM_NONE, CHAN_BODY,  cgs.media.obeliskRespawnSound);
;1263:					cent->muzzleFlashTime = 1;
;1264:				}
;1265:				VectorCopy(cent->currentState.angles, angles);
;1266:				angles[YAW] += (float) 16 * acos(1-c) * 180 / M_PI;
;1267:				AnglesToAxis( angles, model.axis );
;1268:
;1269:				VectorScale( model.axis[0], c, model.axis[0]);
;1270:				VectorScale( model.axis[1], c, model.axis[1]);
;1271:				VectorScale( model.axis[2], c, model.axis[2]);
;1272:
;1273:				model.shaderRGBA[0] = 0xff;
;1274:				model.shaderRGBA[1] = 0xff;
;1275:				model.shaderRGBA[2] = 0xff;
;1276:				model.shaderRGBA[3] = 0xff;
;1277:				//
;1278:				model.origin[2] += 56;
;1279:				model.hModel = cgs.media.overloadTargetModel;
;1280:				trap_R_AddRefEntityToScene( &model );
;1281:			}
;1282:			else {
;1283:				//FIXME: show animated smoke
;1284:			}
;1285:		}
;1286:		else {
;1287:			cent->miscTime = 0;
;1288:			cent->muzzleFlashTime = 0;
;1289:			// modelindex2 is the health value of the obelisk
;1290:			c = cent->currentState.modelindex2;
;1291:			model.shaderRGBA[0] = 0xff;
;1292:			model.shaderRGBA[1] = c;
;1293:			model.shaderRGBA[2] = c;
;1294:			model.shaderRGBA[3] = 0xff;
;1295:			// show the lights
;1296:			model.hModel = cgs.media.overloadLightsModel;
;1297:			trap_R_AddRefEntityToScene( &model );
;1298:			// show the target
;1299:			model.origin[2] += 56;
;1300:			model.hModel = cgs.media.overloadTargetModel;
;1301:			trap_R_AddRefEntityToScene( &model );
;1302:		}
;1303:	}
;1304:	else if ( cgs.gametype == GT_HARVESTER ) {
;1305:		// show harvester model
;1306:		memset(&model, 0, sizeof(model));
;1307:		model.reType = RT_MODEL;
;1308:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1309:		VectorCopy( cent->lerpOrigin, model.origin );
;1310:		AnglesToAxis( cent->currentState.angles, model.axis );
;1311:
;1312:		if ( cent->currentState.modelindex == TEAM_RED ) {
;1313:			model.hModel = cgs.media.harvesterModel;
;1314:			model.customSkin = cgs.media.harvesterRedSkin;
;1315:		}
;1316:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;1317:			model.hModel = cgs.media.harvesterModel;
;1318:			model.customSkin = cgs.media.harvesterBlueSkin;
;1319:		}
;1320:		else {
;1321:			model.hModel = cgs.media.harvesterNeutralModel;
;1322:			model.customSkin = 0;
;1323:		}
;1324:		trap_R_AddRefEntityToScene( &model );
;1325:	}
;1326:#endif
;1327:}
LABELV $591
endproc CG_TeamBase 140 12
proc CG_AddCEntity 8 8
line 1335
;1328:
;1329:/*
;1330:===============
;1331:CG_AddCEntity
;1332:
;1333:===============
;1334:*/
;1335:static void CG_AddCEntity( centity_t *cent ) {
line 1337
;1336:	// event-only entities will have been dealt with already
;1337:	if ( cent->currentState.eType >= ET_EVENTS ) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 14
LTI4 $612
line 1338
;1338:		return;
ADDRGP4 $611
JUMPV
LABELV $612
line 1342
;1339:	}
;1340:
;1341:	// calculate the current origin
;1342:	CG_CalcEntityLerpPositions( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CalcEntityLerpPositions
CALLV
pop
line 1345
;1343:
;1344:	// add automatic effects
;1345:	CG_EntityEffects( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_EntityEffects
CALLV
pop
line 1347
;1346:
;1347:	switch ( cent->currentState.eType ) {
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
LTI4 $614
ADDRLP4 0
INDIRI4
CNSTI4 13
GTI4 $614
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $630
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $630
address $619
address $620
address $621
address $622
address $623
address $624
address $625
address $626
address $615
address $615
address $615
address $627
address $628
address $629
code
LABELV $614
line 1349
;1348:	default:
;1349:		CG_Error( "Bad entity type: %i\n", cent->currentState.eType );
ADDRGP4 $617
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
line 1350
;1350:		break;
ADDRGP4 $615
JUMPV
line 1354
;1351:	case ET_INVISIBLE:
;1352:	case ET_PUSH_TRIGGER:
;1353:	case ET_TELEPORT_TRIGGER:
;1354:		break;
LABELV $619
line 1356
;1355:	case ET_GENERAL:
;1356:		CG_General( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_General
CALLV
pop
line 1357
;1357:		break;
ADDRGP4 $615
JUMPV
LABELV $620
line 1359
;1358:	case ET_PLAYER:
;1359:		CG_Player( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Player
CALLV
pop
line 1360
;1360:		break;
ADDRGP4 $615
JUMPV
LABELV $621
line 1362
;1361:	case ET_ITEM:
;1362:		CG_Item( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Item
CALLV
pop
line 1363
;1363:		break;
ADDRGP4 $615
JUMPV
LABELV $622
line 1365
;1364:	case ET_MISSILE:
;1365:		CG_Missile( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Missile
CALLV
pop
line 1366
;1366:		break;
ADDRGP4 $615
JUMPV
LABELV $623
line 1368
;1367:	case ET_MOVER:
;1368:		CG_Mover( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Mover
CALLV
pop
line 1369
;1369:		break;
ADDRGP4 $615
JUMPV
LABELV $624
line 1371
;1370:	case ET_BEAM:
;1371:		CG_Beam( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Beam
CALLV
pop
line 1372
;1372:		break;
ADDRGP4 $615
JUMPV
LABELV $625
line 1374
;1373:	case ET_PORTAL:
;1374:		CG_Portal( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Portal
CALLV
pop
line 1375
;1375:		break;
ADDRGP4 $615
JUMPV
LABELV $626
line 1377
;1376:	case ET_SPEAKER:
;1377:		CG_Speaker( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Speaker
CALLV
pop
line 1378
;1378:		break;
ADDRGP4 $615
JUMPV
LABELV $627
line 1380
;1379:	case ET_GRAPPLE:
;1380:		CG_Grapple( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Grapple
CALLV
pop
line 1381
;1381:		break;
ADDRGP4 $615
JUMPV
LABELV $628
line 1383
;1382:	case ET_TEAM:
;1383:		CG_TeamBase( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_TeamBase
CALLV
pop
line 1384
;1384:		break;
ADDRGP4 $615
JUMPV
LABELV $629
line 1386
;1385:	case ET_MONSTER:
;1386:		CG_Monster(cent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Monster
CALLV
pop
line 1387
;1387:		break;	
LABELV $615
line 1389
;1388:	}
;1389:}
LABELV $611
endproc CG_AddCEntity 8 8
export CG_AddPacketEntities
proc CG_AddPacketEntities 20 12
line 1397
;1390:
;1391:/*
;1392:===============
;1393:CG_AddPacketEntities
;1394:
;1395:===============
;1396:*/
;1397:void CG_AddPacketEntities( void ) {
line 1403
;1398:	int					num;
;1399:	centity_t			*cent;
;1400:	playerState_t		*ps;
;1401:
;1402:	// set cg.frameInterpolation
;1403:	if ( cg.nextSnap ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $632
line 1406
;1404:		int		delta;
;1405:
;1406:		delta = (cg.nextSnap->serverTime - cg.snap->serverTime);
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
line 1407
;1407:		if ( delta == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $637
line 1408
;1408:			cg.frameInterpolation = 0;
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1409
;1409:		} else {
ADDRGP4 $633
JUMPV
LABELV $637
line 1410
;1410:			cg.frameInterpolation = (float)( cg.time - cg.snap->serverTime ) / delta;
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
line 1411
;1411:		}
line 1412
;1412:	} else {
ADDRGP4 $633
JUMPV
LABELV $632
line 1413
;1413:		cg.frameInterpolation = 0;	// actually, it should never be used, because 
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1415
;1414:									// no entities should be marked as interpolating
;1415:	}
LABELV $633
line 1418
;1416:
;1417:	// the auto-rotating items will all have the same axis
;1418:	cg.autoAngles[0] = 0;
ADDRGP4 cg+108948
CNSTF4 0
ASGNF4
line 1419
;1419:	cg.autoAngles[1] = ( cg.time & 2047 ) * 360 / 2048.0;
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
line 1420
;1420:	cg.autoAngles[2] = 0;
ADDRGP4 cg+108948+8
CNSTF4 0
ASGNF4
line 1422
;1421:
;1422:	cg.autoAnglesFast[0] = 0;
ADDRGP4 cg+108996
CNSTF4 0
ASGNF4
line 1423
;1423:	cg.autoAnglesFast[1] = ( cg.time & 1023 ) * 360 / 1024.0f;
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
line 1424
;1424:	cg.autoAnglesFast[2] = 0;
ADDRGP4 cg+108996+8
CNSTF4 0
ASGNF4
line 1426
;1425:
;1426:	AnglesToAxis( cg.autoAngles, cg.autoAxis );
ADDRGP4 cg+108948
ARGP4
ADDRGP4 cg+108960
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1427
;1427:	AnglesToAxis( cg.autoAnglesFast, cg.autoAxisFast );
ADDRGP4 cg+108996
ARGP4
ADDRGP4 cg+109008
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1430
;1428:
;1429:	// generate and add the entity from the playerstate
;1430:	ps = &cg.predictedPlayerState;
ADDRLP4 8
ADDRGP4 cg+107636
ASGNP4
line 1431
;1431:	BG_PlayerStateToEntityState( ps, &cg.predictedPlayerEntity.currentState, qfalse );
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
line 1432
;1432:	CG_AddCEntity( &cg.predictedPlayerEntity );
ADDRGP4 cg+108104
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1435
;1433:
;1434:	// lerp the non-predicted value for lightning gun origins
;1435:	CG_CalcEntityLerpPositions( &cg_entities[ cg.snap->ps.clientNum ] );
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
line 1438
;1436:
;1437:	// add each entity sent over by the server
;1438:	for ( num = 0 ; num < cg.snap->numEntities ; num++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $667
JUMPV
LABELV $664
line 1439
;1439:		cent = &cg_entities[ cg.snap->entities[ num ].number ];
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
line 1440
;1440:		CG_AddCEntity( cent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1441
;1441:	}
LABELV $665
line 1438
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $667
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
LTI4 $664
line 1442
;1442:}
LABELV $631
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
LABELV $617
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
LABELV $558
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
LABELV $202
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
LABELV $148
byte 1 110
byte 1 111
byte 1 110
byte 1 101
byte 1 0
align 1
LABELV $143
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
LABELV $133
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
LABELV $130
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
LABELV $126
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
LABELV $122
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
LABELV $121
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
LABELV $120
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
