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
address $123
address $124
address $125
address $126
address $127
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
byte 4 0
code
proc CG_LoadMonsterShader 9592 16
line 239
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
;214:	"models/monsters/Mancubus2/monster.cfg",
;215:	"models/monsters/Mancubus3/monster.cfg",
;216:	"models/monsters/Mancubus4/monster.cfg",
;217:	"models/monsters/Mancubus5/monster.cfg",	
;218:	"models/monsters/MongGrunt/monster.cfg",
;219:	"models/monsters/MongGrunt/monster.cfg",
;220:	"models/monsters/MongGruntShotgun/monster.cfg",
;221:	"models/monsters/MongGruntRifle/monster.cfg",
;222:	"models/monsters/Faust/monster.cfg",
;223:	"models/monsters/Stratos/monster.cfg",
;224:	"models/monsters/Mincer/monster.cfg",
;225:	"models/monsters/Forgotten/monster.cfg",
;226:	"models/monsters/Ghost/monster.cfg",
;227:	"models/monsters/Ghost2/monster.cfg",
;228:	"models/monsters/Ghost3/monster.cfg",
;229:	"models/monsters/MongGrunt2/monster.cfg",
;230:	"models/monsters/MongGruntShotgun2/monster.cfg",
;231:	"models/monsters/MongGruntRifle2/monster.cfg",
;232:	"models/monsters/Stratos2/monster.cfg",
;233:	"models/monsters/Faust2/monster.cfg",	
;234:	NULL
;235:};
;236:
;237:static void CG_LoadMonsterShader(
;238:	const char *filename
;239:) {
line 246
;240:	fileHandle_t file;
;241:	char text[MAX_MONSTER_CONFIG_TEXT];
;242:	char error[256];
;243:	monsterDef_t def;
;244:	int length;
;245:
;246:	length = trap_FS_FOpenFile(
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
line 252
;247:		filename,
;248:		&file,
;249:		FS_READ
;250:	);
;251:
;252:	if( !file ) {
ADDRLP4 1112
INDIRI4
CNSTI4 0
NEI4 $143
line 253
;253:		CG_Printf(
ADDRGP4 $145
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 257
;254:			"Monster config not found: %s\n",
;255:			filename
;256:		);
;257:		return;
ADDRGP4 $142
JUMPV
LABELV $143
line 260
;258:	}
;259:
;260:	if( length <= 0 ||
ADDRLP4 1108
INDIRI4
CNSTI4 0
LEI4 $148
ADDRLP4 1108
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $146
LABELV $148
line 261
;261:		length >= sizeof(text) ) {
line 262
;262:		CG_Printf(
ADDRGP4 $149
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 267
;263:			"Invalid monster config size: %s\n",
;264:			filename
;265:		);
;266:
;267:		trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 268
;268:		return;
ADDRGP4 $142
JUMPV
LABELV $146
line 271
;269:	}
;270:
;271:	trap_FS_Read(text, length, file);
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
line 272
;272:	text[length] = '\0';
ADDRLP4 1108
INDIRI4
ADDRLP4 1116
ADDP4
CNSTI1 0
ASGNI1
line 273
;273:	trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 275
;274:
;275:	if( !BG_ParseMonsterConfig(
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
NEI4 $150
line 280
;276:		text,
;277:		&def,
;278:		error,
;279:		sizeof(error)
;280:	) ) {
line 281
;281:		CG_Printf(
ADDRGP4 $152
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9308
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 286
;282:			"Monster config error in %s: %s\n",
;283:			filename,
;284:			error
;285:		);
;286:		return;
ADDRGP4 $142
JUMPV
LABELV $150
line 289
;287:	}
;288:
;289:	if( def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 9576
CNSTI4 0
ASGNI4
ADDRLP4 0+576
INDIRI4
ADDRLP4 9576
INDIRI4
LEI4 $161
ADDRLP4 0+576
INDIRI4
CNSTI4 6
GEI4 $161
ADDRLP4 0+580
INDIRI4
ADDRLP4 9576
INDIRI4
LTI4 $161
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $153
LABELV $161
line 293
;290:		def.monsterType >= MONSTER_TYPE_RANDOM ||
;291:		def.monsterSlot < 0 ||
;292:		def.monsterSlot >=
;293:			MAX_MONSTERS_PER_TYPE ) {
line 294
;294:		CG_Printf(
ADDRGP4 $162
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 298
;295:			"Invalid monster definition in %s\n",
;296:			filename
;297:		);
;298:		return;
ADDRGP4 $142
JUMPV
LABELV $153
line 301
;299:	}
;300:
;301:	if( !def.shader[0] ||
ADDRLP4 0+320
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $168
ADDRLP4 0+320
ARGP4
ADDRGP4 $167
ARGP4
ADDRLP4 9580
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 9580
INDIRI4
CNSTI4 0
NEI4 $163
LABELV $168
line 302
;302:		!Q_stricmp(def.shader, "none") ) {
line 303
;303:		return;
ADDRGP4 $142
JUMPV
LABELV $163
line 306
;304:	}
;305:
;306:	cg_monsterShaders
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
line 311
;307:		[def.monsterType]
;308:		[def.monsterSlot] =
;309:		trap_R_RegisterShader(def.shader);
;310:		
;311:	cg_monsterShaders[def.monsterType][def.monsterSlot] =
ADDRLP4 0+320
ARGP4
ADDRLP4 9588
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
ADDRLP4 9588
INDIRI4
ASGNI4
line 313
;312:		trap_R_RegisterShader(def.shader);
;313:}
LABELV $142
endproc CG_LoadMonsterShader 9592 16
export CG_InitMonsterShaders
proc CG_InitMonsterShaders 4 12
line 315
;314:
;315:void CG_InitMonsterShaders( void ) {
line 318
;316:	int i;
;317:
;318:	memset(
ADDRGP4 cg_monsterShaders
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 324
;319:		cg_monsterShaders,
;320:		0,
;321:		sizeof(cg_monsterShaders)
;322:	);
;323:
;324:	for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $179
JUMPV
LABELV $176
line 326
;325:		cg_monsterConfigFiles[i];
;326:		i++ ) {
line 327
;327:		CG_LoadMonsterShader(
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
line 330
;328:			cg_monsterConfigFiles[i]
;329:		);
;330:	}
LABELV $177
line 326
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $179
line 325
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $176
line 331
;331:}
LABELV $175
endproc CG_InitMonsterShaders 4 12
proc CG_Monster 196 12
line 338
;332:
;333:/*
;334:==================
;335:Monster
;336:==================
;337:*/
;338:static void CG_Monster( centity_t *cent ) {
line 347
;339:	refEntity_t renderEntity;
;340:	qhandle_t customShader;
;341:	int monsterType;
;342:	int monsterSlot;
;343:	int packedDefinition;
;344:	int models[4];
;345:	int i;
;346:
;347:	packedDefinition =
ADDRLP4 172
ADDRFP4 0
INDIRP4
CNSTI4 204
ADDP4
INDIRI4
ASGNI4
line 350
;348:		cent->currentState.generic1;
;349:
;350:	monsterType =
ADDRLP4 164
ADDRLP4 172
INDIRI4
CNSTI4 255
BANDI4
ASGNI4
line 353
;351:		packedDefinition & 255;
;352:
;353:	monsterSlot =
ADDRLP4 168
ADDRLP4 172
INDIRI4
CNSTI4 8
RSHI4
CNSTI4 255
BANDI4
ASGNI4
line 356
;354:		(packedDefinition >> 8) & 255;
;355:
;356:	customShader = 0;
ADDRLP4 160
CNSTI4 0
ASGNI4
line 358
;357:
;358:	if( monsterType > MONSTER_TYPE_OFF &&
ADDRLP4 180
CNSTI4 0
ASGNI4
ADDRLP4 164
INDIRI4
ADDRLP4 180
INDIRI4
LEI4 $181
ADDRLP4 164
INDIRI4
CNSTI4 6
GEI4 $181
ADDRLP4 168
INDIRI4
ADDRLP4 180
INDIRI4
LTI4 $181
ADDRLP4 168
INDIRI4
CNSTI4 5
GEI4 $181
line 362
;359:		monsterType < MONSTER_TYPE_RANDOM &&
;360:		monsterSlot >= 0 &&
;361:		monsterSlot <
;362:			MAX_MONSTERS_PER_TYPE ) {
line 363
;363:		customShader =
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
line 367
;364:			cg_monsterShaders
;365:				[monsterType]
;366:				[monsterSlot];
;367:	}
LABELV $181
line 369
;368:
;369:	models[0] =
ADDRLP4 144
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ASGNI4
line 372
;370:		cent->currentState.modelindex;
;371:
;372:	models[1] =
ADDRLP4 144+4
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
ASGNI4
line 375
;373:		cent->currentState.modelindex2;
;374:
;375:	models[2] =
ADDRLP4 144+8
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 378
;376:		cent->currentState.otherEntityNum;
;377:
;378:	models[3] =
ADDRLP4 144+12
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 381
;379:		cent->currentState.otherEntityNum2;
;380:
;381:	for( i = 0; i < 4; i++ ) {
ADDRLP4 140
CNSTI4 0
ASGNI4
LABELV $186
line 382
;382:		if( models[i] <= 0 ) {
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 144
ADDP4
INDIRI4
CNSTI4 0
GTI4 $190
line 383
;383:			continue;
ADDRGP4 $187
JUMPV
LABELV $190
line 386
;384:		}
;385:
;386:		memset(
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 392
;387:			&renderEntity,
;388:			0,
;389:			sizeof(renderEntity)
;390:		);
;391:
;392:		renderEntity.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 394
;393:
;394:		renderEntity.hModel =
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
line 397
;395:			cgs.gameModels[models[i]];
;396:
;397:		renderEntity.customShader =
ADDRLP4 0+112
ADDRLP4 160
INDIRI4
ASGNI4
line 400
;398:			customShader;
;399:
;400:		renderEntity.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 401
;401:		renderEntity.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 402
;402:		renderEntity.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 403
;403:		renderEntity.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 405
;404:
;405:		renderEntity.oldframe =
ADDRLP4 0+96
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 408
;406:			cent->currentState.frame;
;407:
;408:		renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 411
;409:			cent->currentState.frame;
;410:
;411:		renderEntity.backlerp = 0;
ADDRLP4 0+100
CNSTF4 0
ASGNF4
line 413
;412:
;413:		if( cent->interpolate &&
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
EQI4 $205
ADDRLP4 192
INDIRP4
CNSTI4 212
ADDP4
INDIRI4
CNSTI4 13
NEI4 $205
line 415
;414:			cent->nextState.eType ==
;415:				ET_MONSTER ) {
line 416
;416:			renderEntity.frame =
ADDRLP4 0+80
ADDRFP4 0
INDIRP4
CNSTI4 380
ADDP4
INDIRI4
ASGNI4
line 419
;417:				cent->nextState.frame;
;418:
;419:			renderEntity.backlerp =
ADDRLP4 0+100
CNSTF4 1065353216
ADDRGP4 cg+107588
INDIRF4
SUBF4
ASGNF4
line 422
;420:				1.0f -
;421:				cg.frameInterpolation;
;422:		}
LABELV $205
line 424
;423:
;424:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 429
;425:			cent->lerpOrigin,
;426:			renderEntity.origin
;427:		);
;428:
;429:		VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 434
;430:			cent->lerpOrigin,
;431:			renderEntity.oldorigin
;432:		);
;433:
;434:		AnglesToAxis(
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
line 439
;435:			cent->lerpAngles,
;436:			renderEntity.axis
;437:		);
;438:
;439:		trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 442
;440:			&renderEntity
;441:		);
;442:	}
LABELV $187
line 381
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 4
LTI4 $186
line 443
;443:}
LABELV $180
endproc CG_Monster 196 12
proc CG_Speaker 16 16
line 452
;444:
;445:/*
;446:==================
;447:CG_Speaker
;448:
;449:Speaker entities can automatically play sounds
;450:==================
;451:*/
;452:static void CG_Speaker( centity_t *cent ) {
line 453
;453:	if ( ! cent->currentState.clientNum ) {	// FIXME: use something other than clientNum...
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
CNSTI4 0
NEI4 $214
line 454
;454:		return;		// not auto triggering
ADDRGP4 $213
JUMPV
LABELV $214
line 457
;455:	}
;456:
;457:	if ( cg.time < cent->miscTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRI4
GEI4 $216
line 458
;458:		return;
ADDRGP4 $213
JUMPV
LABELV $216
line 461
;459:	}
;460:
;461:	trap_S_StartSound (NULL, cent->currentState.number, CHAN_ITEM, cgs.gameSounds[cent->currentState.eventParm] );
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
line 465
;462:
;463:	//	ent->s.frame = ent->wait * 10;
;464:	//	ent->s.clientNum = ent->random * 10;
;465:	cent->miscTime = cg.time + cent->currentState.frame * 100 + cent->currentState.clientNum * 100 * crandom();
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
line 466
;466:}
LABELV $213
endproc CG_Speaker 16 16
proc CG_Item 204 12
line 473
;467:
;468:/*
;469:==================
;470:CG_Item
;471:==================
;472:*/
;473:static void CG_Item( centity_t *cent ) {
line 482
;474:	refEntity_t	ent;
;475:	entityState_t	*es;
;476:	gitem_t		*item;
;477:	int		msec;
;478:	float		frac;
;479:	float		scale;
;480:	weaponInfo_t	*wi;
;481:
;482:	es = &cent->currentState;
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
line 484
;483:
;484:	if( es->modelindex >= bg_numItems ) {
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $222
line 485
;485:		CG_Error(
ADDRGP4 $224
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
line 489
;486:			"Bad item index %i on entity",
;487:			es->modelindex
;488:		);
;489:	}
LABELV $222
line 492
;490:
;491:	// if set to invisible, skip
;492:	if( !es->modelindex ||
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
EQI4 $227
ADDRLP4 144
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 128
BANDI4
ADDRLP4 168
INDIRI4
EQI4 $225
LABELV $227
line 493
;493:		(es->eFlags & EF_NODRAW) ) {
line 494
;494:		return;
ADDRGP4 $221
JUMPV
LABELV $225
line 497
;495:	}
;496:
;497:	item = &bg_itemlist[es->modelindex];
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
line 499
;498:
;499:	if( cg_simpleItems.integer &&
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
EQI4 $228
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
EQI4 $228
line 500
;500:		item->giType != IT_TEAM ) {
line 501
;501:		memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 503
;502:
;503:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 504
;504:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 508
;505:			cent->lerpOrigin,
;506:			ent.origin
;507:		);
;508:		ent.radius = 14;
ADDRLP4 0+132
CNSTF4 1096810496
ASGNF4
line 509
;509:		ent.customShader =
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
line 511
;510:			cg_items[es->modelindex].icon;
;511:		ent.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 512
;512:		ent.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 513
;513:		ent.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 514
;514:		ent.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 516
;515:
;516:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 517
;517:		return;
ADDRGP4 $221
JUMPV
LABELV $228
line 524
;518:	}
;519:
;520:	/*
;521:	 * Normal items continuously bob up and down.
;522:	 * Static items retain their original map position.
;523:	 */
;524:	if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $242
line 525
;525:		scale =
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
line 529
;526:			0.005 +
;527:			cent->currentState.number * 0.00001;
;528:
;529:		cent->lerpOrigin[2] +=
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
line 532
;530:			4 +
;531:			cos((cg.time + 1000) * scale) * 4;
;532:	}
LABELV $242
line 534
;533:
;534:	memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 540
;535:
;536:	/*
;537:	 * Static items use a fixed identity axis.
;538:	 * Normal items use the original automatic rotation.
;539:	 */
;540:	if( cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
EQI4 $246
line 541
;541:		VectorClear( cent->lerpAngles );
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
line 542
;542:		AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 543
;543:	}
ADDRGP4 $247
JUMPV
LABELV $246
line 544
;544:	else if( item->giType == IT_HEALTH ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 4
NEI4 $250
line 545
;545:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108996
INDIRB
ASGNB 12
line 549
;546:			cg.autoAnglesFast,
;547:			cent->lerpAngles
;548:		);
;549:		AxisCopy(
ADDRGP4 cg+109008
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 553
;550:			cg.autoAxisFast,
;551:			ent.axis
;552:		);
;553:	}
ADDRGP4 $251
JUMPV
LABELV $250
line 554
;554:	else {
line 555
;555:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108948
INDIRB
ASGNB 12
line 559
;556:			cg.autoAngles,
;557:			cent->lerpAngles
;558:		);
;559:		AxisCopy(
ADDRGP4 cg+108960
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 563
;560:			cg.autoAxis,
;561:			ent.axis
;562:		);
;563:	}
LABELV $251
LABELV $247
line 565
;564:
;565:	wi = NULL;
ADDRLP4 152
CNSTP4 0
ASGNP4
line 571
;566:
;567:	/*
;568:	 * Weapon models have their origin at the attachment point,
;569:	 * so compensate using the weapon midpoint.
;570:	 */
;571:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $258
line 572
;572:		wi = &cg_weapons[item->giTag];
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
line 574
;573:
;574:		cent->lerpOrigin[0] -=
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
line 579
;575:			wi->weaponMidpoint[0] * ent.axis[0][0] +
;576:			wi->weaponMidpoint[1] * ent.axis[1][0] +
;577:			wi->weaponMidpoint[2] * ent.axis[2][0];
;578:
;579:		cent->lerpOrigin[1] -=
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
line 584
;580:			wi->weaponMidpoint[0] * ent.axis[0][1] +
;581:			wi->weaponMidpoint[1] * ent.axis[1][1] +
;582:			wi->weaponMidpoint[2] * ent.axis[2][1];
;583:
;584:		cent->lerpOrigin[2] -=
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
line 589
;585:			wi->weaponMidpoint[0] * ent.axis[0][2] +
;586:			wi->weaponMidpoint[1] * ent.axis[1][2] +
;587:			wi->weaponMidpoint[2] * ent.axis[2][2];
;588:
;589:		cent->lerpOrigin[2] += 8;
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
line 590
;590:	}
LABELV $258
line 592
;591:
;592:	ent.hModel =
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
line 595
;593:		cg_items[es->modelindex].models[0];
;594:
;595:	VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 599
;596:		cent->lerpOrigin,
;597:		ent.origin
;598:	);
;599:	VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 604
;600:		cent->lerpOrigin,
;601:		ent.oldorigin
;602:	);
;603:
;604:	ent.nonNormalizedAxes = qfalse;
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 610
;605:
;606:	/*
;607:	 * Static items appear immediately at full size.
;608:	 * Normal items retain the respawn scale animation.
;609:	 */
;610:	msec = cg.time - cent->miscTime;
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
line 612
;611:
;612:	if( !cg_staticItems.integer &&
ADDRLP4 172
CNSTI4 0
ASGNI4
ADDRGP4 cg_staticItems+12
INDIRI4
ADDRLP4 172
INDIRI4
NEI4 $287
ADDRLP4 156
INDIRI4
ADDRLP4 172
INDIRI4
LTI4 $287
ADDRLP4 156
INDIRI4
CNSTI4 1000
GEI4 $287
line 614
;613:		msec >= 0 &&
;614:		msec < ITEM_SCALEUP_TIME ) {
line 615
;615:		frac = (float)msec /
ADDRLP4 148
ADDRLP4 156
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 618
;616:			ITEM_SCALEUP_TIME;
;617:
;618:		VectorScale(
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
line 623
;619:			ent.axis[0],
;620:			frac,
;621:			ent.axis[0]
;622:		);
;623:		VectorScale(
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
line 628
;624:			ent.axis[1],
;625:			frac,
;626:			ent.axis[1]
;627:		);
;628:		VectorScale(
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
line 634
;629:			ent.axis[2],
;630:			frac,
;631:			ent.axis[2]
;632:		);
;633:
;634:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 635
;635:	}
ADDRGP4 $288
JUMPV
LABELV $287
line 636
;636:	else {
line 637
;637:		frac = 1.0f;
ADDRLP4 148
CNSTF4 1065353216
ASGNF4
line 638
;638:	}
LABELV $288
line 643
;639:
;640:	/*
;641:	 * Items without glow textures need a minimum light value.
;642:	 */
;643:	if( item->giType == IT_WEAPON ||
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
EQI4 $335
ADDRLP4 180
INDIRI4
CNSTI4 3
NEI4 $333
LABELV $335
line 644
;644:		item->giType == IT_ARMOR ) {
line 645
;645:		ent.renderfx |= RF_MINLIGHT;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 646
;646:	}
LABELV $333
line 649
;647:
;648:	// increase the size of weapon pickup models
;649:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $337
line 650
;650:		VectorScale(
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
line 655
;651:			ent.axis[0],
;652:			1.5f,
;653:			ent.axis[0]
;654:		);
;655:		VectorScale(
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
line 660
;656:			ent.axis[1],
;657:			1.5f,
;658:			ent.axis[1]
;659:		);
;660:		VectorScale(
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
line 666
;661:			ent.axis[2],
;662:			1.5f,
;663:			ent.axis[2]
;664:		);
;665:
;666:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 678
;667:
;668:#ifdef MISSIONPACK
;669:		if( !cg_staticItems.integer ) {
;670:			trap_S_AddLoopingSound(
;671:				cent->currentState.number,
;672:				cent->lerpOrigin,
;673:				vec3_origin,
;674:				cgs.media.weaponHoverSound
;675:			);
;676:		}
;677:#endif
;678:	}
LABELV $337
line 704
;679:
;680:#ifdef MISSIONPACK
;681:	if( item->giType == IT_HOLDABLE &&
;682:		item->giTag == HI_KAMIKAZE ) {
;683:		VectorScale(
;684:			ent.axis[0],
;685:			2,
;686:			ent.axis[0]
;687:		);
;688:		VectorScale(
;689:			ent.axis[1],
;690:			2,
;691:			ent.axis[1]
;692:		);
;693:		VectorScale(
;694:			ent.axis[2],
;695:			2,
;696:			ent.axis[2]
;697:		);
;698:
;699:		ent.nonNormalizedAxes = qtrue;
;700:	}
;701:#endif
;702:
;703:	// add main model
;704:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 751
;705:
;706:#ifdef MISSIONPACK
;707:	if( item->giType == IT_WEAPON &&
;708:		wi->barrelModel ) {
;709:		refEntity_t barrel;
;710:
;711:		memset(
;712:			&barrel,
;713:			0,
;714:			sizeof(barrel)
;715:		);
;716:
;717:		barrel.hModel = wi->barrelModel;
;718:
;719:		VectorCopy(
;720:			ent.lightingOrigin,
;721:			barrel.lightingOrigin
;722:		);
;723:
;724:		barrel.shadowPlane =
;725:			ent.shadowPlane;
;726:		barrel.renderfx =
;727:			ent.renderfx;
;728:
;729:		CG_PositionRotatedEntityOnTag(
;730:			&barrel,
;731:			&ent,
;732:			wi->weaponModel,
;733:			"tag_barrel"
;734:		);
;735:
;736:		AxisCopy(
;737:			ent.axis,
;738:			barrel.axis
;739:		);
;740:
;741:		barrel.nonNormalizedAxes =
;742:			ent.nonNormalizedAxes;
;743:
;744:		trap_R_AddRefEntityToScene(
;745:			&barrel
;746:		);
;747:	}
;748:#endif
;749:
;750:	// accompanying rings and spheres for powerups
;751:	if( !cg_simpleItems.integer ) {
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
NEI4 $382
line 754
;752:		vec3_t spinAngles;
;753:
;754:		VectorClear( spinAngles );
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
line 756
;755:
;756:		if( item->giType == IT_HEALTH ||
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
EQI4 $389
ADDRLP4 200
INDIRI4
CNSTI4 5
NEI4 $387
LABELV $389
line 757
;757:			item->giType == IT_POWERUP ) {
line 758
;758:			ent.hModel =
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
line 763
;759:				cg_items[
;760:					es->modelindex
;761:				].models[1];
;762:
;763:			if( ent.hModel ) {
ADDRLP4 0+8
INDIRI4
CNSTI4 0
EQI4 $393
line 764
;764:				if( item->giType ==
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $396
line 765
;765:					IT_POWERUP ) {
line 766
;766:					ent.origin[2] += 12;
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
CNSTF4 1094713344
ADDF4
ASGNF4
line 768
;767:
;768:					if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $400
line 769
;769:						spinAngles[1] =
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
line 773
;770:							(cg.time & 1023) *
;771:							360 /
;772:							-1024.0f;
;773:					}
LABELV $400
line 774
;774:				}
LABELV $396
line 776
;775:
;776:				AnglesToAxis(
ADDRLP4 184
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 781
;777:					spinAngles,
;778:					ent.axis
;779:				);
;780:
;781:				if( frac != 1.0f ) {
ADDRLP4 148
INDIRF4
CNSTF4 1065353216
EQF4 $406
line 782
;782:					VectorScale(
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
line 787
;783:						ent.axis[0],
;784:						frac,
;785:						ent.axis[0]
;786:					);
;787:					VectorScale(
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
line 792
;788:						ent.axis[1],
;789:						frac,
;790:						ent.axis[1]
;791:					);
;792:					VectorScale(
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
line 798
;793:						ent.axis[2],
;794:						frac,
;795:						ent.axis[2]
;796:					);
;797:
;798:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 800
;799:						qtrue;
;800:				}
ADDRGP4 $407
JUMPV
LABELV $406
line 801
;801:				else {
line 802
;802:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 804
;803:						qfalse;
;804:				}
LABELV $407
line 806
;805:
;806:				trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 809
;807:					&ent
;808:				);
;809:			}
LABELV $393
line 810
;810:		}
LABELV $387
line 811
;811:	}
LABELV $382
line 812
;812:}
LABELV $221
endproc CG_Item 204 12
proc CG_Missile 172 20
line 821
;813:
;814://============================================================================
;815:
;816:/*
;817:===============
;818:CG_Missile
;819:===============
;820:*/
;821:static void CG_Missile( centity_t *cent ) {
line 827
;822:	refEntity_t			ent;
;823:	entityState_t		*s1;
;824:	const weaponInfo_t		*weapon;
;825://	int	col;
;826:
;827:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 828
;828:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $453
line 829
;829:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 830
;830:	}
LABELV $453
line 835
;831:	/*
;832:	 * Lazy weapon registration: monster projectiles may
;833:	 * arrive for a weapon the local player never picked up
;834:	 */
;835:	if ( s1->weapon > WP_NONE &&
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
LEI4 $455
ADDRLP4 148
INDIRI4
CNSTI4 12
GEI4 $455
CNSTI4 136
ADDRLP4 148
INDIRI4
MULI4
ADDRGP4 cg_weapons+80
ADDP4
INDIRI4
ADDRLP4 152
INDIRI4
NEI4 $455
line 837
;836:		s1->weapon < WP_NUM_WEAPONS &&
;837:		!cg_weapons[s1->weapon].missileModel ) {
line 838
;838:		CG_RegisterWeapon( s1->weapon );
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_RegisterWeapon
CALLV
pop
line 839
;839:	}
LABELV $455
line 841
;840:
;841:	weapon = &cg_weapons[s1->weapon];
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
line 844
;842:
;843:	// calculate the axis
;844:	VectorCopy( s1->angles, cent->lerpAngles);
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
line 847
;845:
;846:	// add trails
;847:	if ( weapon->missileTrailFunc ) 
ADDRLP4 144
INDIRP4
CNSTI4 88
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $458
line 848
;848:	{
line 849
;849:		weapon->missileTrailFunc( cent, weapon );
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
line 850
;850:	}
LABELV $458
line 869
;851:/*
;852:	if ( cent->currentState.modelindex == TEAM_RED ) {
;853:		col = 1;
;854:	}
;855:	else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;856:		col = 2;
;857:	}
;858:	else {
;859:		col = 0;
;860:	}
;861:
;862:	// add dynamic light
;863:	if ( weapon->missileDlight ) {
;864:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
;865:			weapon->missileDlightColor[col][0], weapon->missileDlightColor[col][1], weapon->missileDlightColor[col][2] );
;866:	}
;867:*/
;868:	// add dynamic light
;869:	if ( weapon->missileDlight ) {
ADDRLP4 144
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
CNSTF4 0
EQF4 $460
line 870
;870:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
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
line 872
;871:			weapon->missileDlightColor[0], weapon->missileDlightColor[1], weapon->missileDlightColor[2] );
;872:	}
LABELV $460
line 875
;873:
;874:	// add missile sound
;875:	if ( weapon->missileSound ) {
ADDRLP4 144
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 0
EQI4 $462
line 878
;876:		vec3_t	velocity;
;877:
;878:		BG_EvaluateTrajectoryDelta( &cent->currentState.pos, cg.time, velocity );
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
line 880
;879:
;880:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, velocity, weapon->missileSound );
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
line 881
;881:	}
LABELV $462
line 884
;882:
;883:	// create the render entity
;884:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 885
;885:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 886
;886:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 888
;887:
;888:	if ( cent->currentState.weapon == WP_PLASMAGUN ) {
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 8
NEI4 $467
line 889
;889:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 890
;890:		ent.radius = 16;
ADDRLP4 0+132
CNSTF4 1098907648
ASGNF4
line 891
;891:		ent.rotation = 0;
ADDRLP4 0+136
CNSTF4 0
ASGNF4
line 892
;892:		ent.customShader = cgs.media.plasmaBallShader;
ADDRLP4 0+112
ADDRGP4 cgs+152340+288
INDIRI4
ASGNI4
line 893
;893:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 894
;894:		return;
ADDRGP4 $452
JUMPV
LABELV $467
line 898
;895:	}
;896:
;897:	// flicker between two skins
;898:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 899
;899:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 900
;900:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 911
;901:
;902:#ifdef MISSIONPACK
;903:	if ( cent->currentState.weapon == WP_PROX_LAUNCHER ) {
;904:		if (s1->generic1 == TEAM_BLUE) {
;905:			ent.hModel = cgs.media.blueProxMine;
;906:		}
;907:	}
;908:#endif
;909:
;910:	// convert direction of travel into axis
;911:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
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
NEF4 $477
line 912
;912:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 913
;913:	}
LABELV $477
line 916
;914:
;915:	// spin as it moves
;916:	if ( s1->pos.trType != TR_STATIONARY ) {
ADDRLP4 140
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 0
EQI4 $482
line 917
;917:		RotateAroundDirection( ent.axis, cg.time / 4 );
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
line 918
;918:	} else {
ADDRGP4 $483
JUMPV
LABELV $482
line 925
;919:#ifdef MISSIONPACK
;920:		if ( s1->weapon == WP_PROX_LAUNCHER ) {
;921:			AnglesToAxis( cent->lerpAngles, ent.axis );
;922:		}
;923:		else
;924:#endif
;925:		{
line 926
;926:			RotateAroundDirection( ent.axis, s1->time );
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
line 927
;927:		}
line 928
;928:	}
LABELV $483
line 931
;929:
;930:	// add to refresh list, possibly with quad glow
;931:	CG_AddRefEntityWithPowerups( &ent, s1, TEAM_FREE );
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
line 932
;932:}
LABELV $452
endproc CG_Missile 172 20
proc CG_Grapple 152 12
line 941
;933:
;934:/*
;935:===============
;936:CG_Grapple
;937:
;938:This is called when the grapple is sitting up against the wall
;939:===============
;940:*/
;941:static void CG_Grapple( centity_t *cent ) {
line 946
;942:	refEntity_t			ent;
;943:	entityState_t		*s1;
;944:	const weaponInfo_t		*weapon;
;945:
;946:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 947
;947:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $488
line 948
;948:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 949
;949:	}
LABELV $488
line 950
;950:	weapon = &cg_weapons[s1->weapon];
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
line 953
;951:
;952:	// calculate the axis
;953:	VectorCopy( s1->angles, cent->lerpAngles);
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
line 963
;954:
;955:#if 0 // FIXME add grapple pull sound here..?
;956:	// add missile sound
;957:	if ( weapon->missileSound ) {
;958:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, weapon->missileSound );
;959:	}
;960:#endif
;961:
;962:	// Will draw cable if needed
;963:	CG_GrappleTrail ( cent, weapon );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRGP4 CG_GrappleTrail
CALLV
pop
line 966
;964:
;965:	// create the render entity
;966:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 967
;967:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 968
;968:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 971
;969:
;970:	// flicker between two skins
;971:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 972
;972:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 973
;973:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 976
;974:
;975:	// convert direction of travel into axis
;976:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
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
NEF4 $495
line 977
;977:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 978
;978:	}
LABELV $495
line 980
;979:
;980:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 981
;981:}
LABELV $487
endproc CG_Grapple 152 12
proc CG_Mover 144 12
line 988
;982:
;983:/*
;984:===============
;985:CG_Mover
;986:===============
;987:*/
;988:static void CG_Mover( centity_t *cent ) {
line 992
;989:	refEntity_t			ent;
;990:	entityState_t		*s1;
;991:
;992:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 995
;993:
;994:	// create the render entity
;995:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 996
;996:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 997
;997:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 998
;998:	AnglesToAxis( cent->lerpAngles, ent.axis );
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
line 1000
;999:
;1000:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 1003
;1001:
;1002:	// flicker between two skins (FIXME?)
;1003:	ent.skinNum = ( cg.time >> 6 ) & 1;
ADDRLP4 0+104
ADDRGP4 cg+107604
INDIRI4
CNSTI4 6
RSHI4
CNSTI4 1
BANDI4
ASGNI4
line 1006
;1004:
;1005:	// get the model, either as a bmodel or a modelindex
;1006:	if ( s1->solid == SOLID_BMODEL ) {
ADDRLP4 140
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
NEI4 $507
line 1007
;1007:		ent.hModel = cgs.inlineDrawModel[s1->modelindex];
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
line 1008
;1008:	} else {
ADDRGP4 $508
JUMPV
LABELV $507
line 1009
;1009:		ent.hModel = cgs.gameModels[s1->modelindex];
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
line 1010
;1010:	}
LABELV $508
line 1013
;1011:
;1012:	// add to refresh list
;1013:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1016
;1014:
;1015:	// add the secondary model
;1016:	if ( s1->modelindex2 ) {
ADDRLP4 140
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $513
line 1017
;1017:		ent.skinNum = 0;
ADDRLP4 0+104
CNSTI4 0
ASGNI4
line 1018
;1018:		ent.hModel = cgs.gameModels[s1->modelindex2];
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
line 1019
;1019:		trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1020
;1020:	}
LABELV $513
line 1022
;1021:
;1022:}
LABELV $500
endproc CG_Mover 144 12
export CG_Beam
proc CG_Beam 144 12
line 1031
;1023:
;1024:/*
;1025:===============
;1026:CG_Beam
;1027:
;1028:Also called as an event
;1029:===============
;1030:*/
;1031:void CG_Beam( centity_t *cent ) {
line 1035
;1032:	refEntity_t			ent;
;1033:	entityState_t		*s1;
;1034:
;1035:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1038
;1036:
;1037:	// create the render entity
;1038:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1039
;1039:	VectorCopy( s1->pos.trBase, ent.origin );
ADDRLP4 0+68
ADDRLP4 140
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
line 1040
;1040:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1041
;1041:	AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 1042
;1042:	ent.reType = RT_BEAM;
ADDRLP4 0
CNSTI4 3
ASGNI4
line 1044
;1043:
;1044:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 1047
;1045:
;1046:	// add to refresh list
;1047:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1048
;1048:}
LABELV $518
endproc CG_Beam 144 12
proc CG_Portal 144 12
line 1056
;1049:
;1050:
;1051:/*
;1052:===============
;1053:CG_Portal
;1054:===============
;1055:*/
;1056:static void CG_Portal( centity_t *cent ) {
line 1060
;1057:	refEntity_t			ent;
;1058:	entityState_t		*s1;
;1059:
;1060:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 1063
;1061:
;1062:	// create the render entity
;1063:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1064
;1064:	VectorCopy( cent->lerpOrigin, ent.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1065
;1065:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 1066
;1066:	ByteToDir( s1->eventParm, ent.axis[0] );
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
line 1067
;1067:	PerpendicularVector( ent.axis[1], ent.axis[0] );
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 1071
;1068:
;1069:	// negating this tends to get the directions like they want
;1070:	// we really should have a camera roll value
;1071:	VectorSubtract( vec3_origin, ent.axis[1], ent.axis[1] );
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
line 1073
;1072:
;1073:	CrossProduct( ent.axis[0], ent.axis[1], ent.axis[2] );
ADDRLP4 0+28
ARGP4
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28+24
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 1074
;1074:	ent.reType = RT_PORTALSURFACE;
ADDRLP4 0
CNSTI4 7
ASGNI4
line 1075
;1075:	ent.oldframe = s1->powerups;
ADDRLP4 0+96
ADDRLP4 140
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
ASGNI4
line 1076
;1076:	ent.frame = s1->frame;		// rotation speed
ADDRLP4 0+80
ADDRLP4 140
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 1077
;1077:	ent.skinNum = s1->clientNum/256.0 * 360;	// roll offset
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
line 1080
;1078:
;1079:	// add to refresh list
;1080:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1081
;1081:}
LABELV $523
endproc CG_Portal 144 12
export CG_AdjustPositionForMover
proc CG_AdjustPositionForMover 92 12
line 1091
;1082:
;1083:
;1084:/*
;1085:=========================
;1086:CG_AdjustPositionForMover
;1087:
;1088:Also called by client movement prediction code
;1089:=========================
;1090:*/
;1091:void CG_AdjustPositionForMover( const vec3_t in, int moverNum, int fromTime, int toTime, vec3_t out ) {
line 1096
;1092:	centity_t	*cent;
;1093:	vec3_t	oldOrigin, origin, deltaOrigin;
;1094:	vec3_t	oldAngles, angles, deltaAngles;
;1095:
;1096:	if ( moverNum <= 0 || moverNum >= ENTITYNUM_MAX_NORMAL ) {
ADDRLP4 76
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
LEI4 $559
ADDRLP4 76
INDIRI4
CNSTI4 1022
LTI4 $557
LABELV $559
line 1097
;1097:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1098
;1098:		return;
ADDRGP4 $556
JUMPV
LABELV $557
line 1101
;1099:	}
;1100:
;1101:	cent = &cg_entities[ moverNum ];
ADDRLP4 0
CNSTI4 728
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 1102
;1102:	if ( cent->currentState.eType != ET_MOVER ) {
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
EQI4 $560
line 1103
;1103:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1104
;1104:		return;
ADDRGP4 $556
JUMPV
LABELV $560
line 1107
;1105:	}
;1106:
;1107:	BG_EvaluateTrajectory( &cent->currentState.pos, fromTime, oldOrigin );
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
line 1108
;1108:	BG_EvaluateTrajectory( &cent->currentState.apos, fromTime, oldAngles );
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
line 1110
;1109:
;1110:	BG_EvaluateTrajectory( &cent->currentState.pos, toTime, origin );
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
line 1111
;1111:	BG_EvaluateTrajectory( &cent->currentState.apos, toTime, angles );
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
line 1113
;1112:
;1113:	VectorSubtract( origin, oldOrigin, deltaOrigin );
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
line 1114
;1114:	VectorSubtract( angles, oldAngles, deltaAngles );
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
line 1116
;1115:
;1116:	VectorAdd( in, deltaOrigin, out );
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
line 1119
;1117:
;1118:	// FIXME: origin change when on a rotating object
;1119:}
LABELV $556
endproc CG_AdjustPositionForMover 92 12
proc CG_InterpolateEntityPosition 44 12
line 1127
;1120:
;1121:
;1122:/*
;1123:=============================
;1124:CG_InterpolateEntityPosition
;1125:=============================
;1126:*/
;1127:static void CG_InterpolateEntityPosition( centity_t *cent ) {
line 1133
;1128:	vec3_t		current, next;
;1129:	float		f;
;1130:
;1131:	// it would be an internal error to find an entity that interpolates without
;1132:	// a snapshot ahead of the current one
;1133:	if ( cg.nextSnap == NULL ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $577
line 1134
;1134:		CG_Error( "CG_InterpoateEntityPosition: cg.nextSnap == NULL" );
ADDRGP4 $580
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 1135
;1135:	}
LABELV $577
line 1137
;1136:
;1137:	f = cg.frameInterpolation;
ADDRLP4 24
ADDRGP4 cg+107588
INDIRF4
ASGNF4
line 1141
;1138:
;1139:	// this will linearize a sine or parabolic curve, but it is important
;1140:	// to not extrapolate player positions if more recent data is available
;1141:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.snap->serverTime, current );
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
line 1142
;1142:	BG_EvaluateTrajectory( &cent->nextState.pos, cg.nextSnap->serverTime, next );
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
line 1144
;1143:
;1144:	cent->lerpOrigin[0] = current[0] + f * ( next[0] - current[0] );
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
line 1145
;1145:	cent->lerpOrigin[1] = current[1] + f * ( next[1] - current[1] );
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
line 1146
;1146:	cent->lerpOrigin[2] = current[2] + f * ( next[2] - current[2] );
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
line 1148
;1147:
;1148:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.snap->serverTime, current );
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
line 1149
;1149:	BG_EvaluateTrajectory( &cent->nextState.apos, cg.nextSnap->serverTime, next );
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
line 1151
;1150:
;1151:	cent->lerpAngles[0] = LerpAngle( current[0], next[0], f );
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
line 1152
;1152:	cent->lerpAngles[1] = LerpAngle( current[1], next[1], f );
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
line 1153
;1153:	cent->lerpAngles[2] = LerpAngle( current[2], next[2], f );
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
line 1155
;1154:
;1155:}
LABELV $576
endproc CG_InterpolateEntityPosition 44 12
proc CG_CalcEntityLerpPositions 24 20
line 1163
;1156:
;1157:/*
;1158:===============
;1159:CG_CalcEntityLerpPositions
;1160:
;1161:===============
;1162:*/
;1163:static void CG_CalcEntityLerpPositions( centity_t *cent ) {
line 1166
;1164:
;1165:	// if this player does not want to see extrapolated players
;1166:	if ( !cg_smoothClients.integer ) {
ADDRGP4 cg_smoothClients+12
INDIRI4
CNSTI4 0
NEI4 $597
line 1168
;1167:		// make sure the clients use TR_INTERPOLATE
;1168:		if ( cent->currentState.number < MAX_CLIENTS ) {
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $600
line 1169
;1169:			cent->currentState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 1170
;1170:			cent->nextState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
CNSTI4 1
ASGNI4
line 1171
;1171:		}
LABELV $600
line 1172
;1172:	}
LABELV $597
line 1174
;1173:
;1174:	if ( cent->interpolate && cent->currentState.pos.trType == TR_INTERPOLATE ) {
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
EQI4 $602
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 1
NEI4 $602
line 1175
;1175:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1176
;1176:		return;
ADDRGP4 $596
JUMPV
LABELV $602
line 1181
;1177:	}
;1178:
;1179:	// first see if we can interpolate between two snaps for
;1180:	// linear extrapolated clients
;1181:	if ( cent->interpolate && cent->currentState.pos.trType == TR_LINEAR_STOP &&
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
EQI4 $604
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 3
NEI4 $604
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $604
line 1182
;1182:											cent->currentState.number < MAX_CLIENTS) {
line 1183
;1183:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 1184
;1184:		return;
ADDRGP4 $596
JUMPV
LABELV $604
line 1188
;1185:	}
;1186:
;1187:	// just use the current frame and evaluate as best we can
;1188:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.time, cent->lerpOrigin );
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
line 1189
;1189:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.time, cent->lerpAngles );
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
line 1193
;1190:
;1191:	// adjust for riding a mover if it wasn't rolled into the predicted
;1192:	// player state
;1193:	if ( cent != &cg.predictedPlayerEntity ) {
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 cg+108104
CVPU4 4
EQU4 $608
line 1194
;1194:		CG_AdjustPositionForMover( cent->lerpOrigin, cent->currentState.groundEntityNum, 
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
line 1196
;1195:		cg.snap->serverTime, cg.time, cent->lerpOrigin );
;1196:	}
LABELV $608
line 1197
;1197:}
LABELV $596
endproc CG_CalcEntityLerpPositions 24 20
proc CG_TeamBase 140 12
line 1204
;1198:
;1199:/*
;1200:===============
;1201:CG_TeamBase
;1202:===============
;1203:*/
;1204:static void CG_TeamBase( centity_t *cent ) {
line 1213
;1205:	refEntity_t model;
;1206:#ifdef MISSIONPACK
;1207:	vec3_t angles;
;1208:	int t, h;
;1209:	float c;
;1210:
;1211:	if ( cgs.gametype == GT_CTF || cgs.gametype == GT_1FCTF ) {
;1212:#else
;1213:	if ( cgs.gametype == GT_CTF) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $614
line 1216
;1214:#endif
;1215:		// show the flag base
;1216:		memset(&model, 0, sizeof(model));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1217
;1217:		model.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1218
;1218:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1219
;1219:		VectorCopy( cent->lerpOrigin, model.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1220
;1220:		AnglesToAxis( cent->currentState.angles, model.axis );
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
line 1221
;1221:		if ( cent->currentState.modelindex == TEAM_RED ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $620
line 1222
;1222:			model.hModel = cgs.media.redFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+108
INDIRI4
ASGNI4
line 1223
;1223:		}
ADDRGP4 $621
JUMPV
LABELV $620
line 1224
;1224:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
NEI4 $625
line 1225
;1225:			model.hModel = cgs.media.blueFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+112
INDIRI4
ASGNI4
line 1226
;1226:		}
ADDRGP4 $626
JUMPV
LABELV $625
line 1227
;1227:		else {
line 1228
;1228:			model.hModel = cgs.media.neutralFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+116
INDIRI4
ASGNI4
line 1229
;1229:		}
LABELV $626
LABELV $621
line 1230
;1230:		trap_R_AddRefEntityToScene( &model );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1231
;1231:	}
LABELV $614
line 1350
;1232:#ifdef MISSIONPACK
;1233:	else if ( cgs.gametype == GT_OBELISK ) {
;1234:		// show the obelisk
;1235:		memset(&model, 0, sizeof(model));
;1236:		model.reType = RT_MODEL;
;1237:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1238:		VectorCopy( cent->lerpOrigin, model.origin );
;1239:		AnglesToAxis( cent->currentState.angles, model.axis );
;1240:
;1241:		model.hModel = cgs.media.overloadBaseModel;
;1242:		trap_R_AddRefEntityToScene( &model );
;1243:		// if hit
;1244:		if ( cent->currentState.frame == 1) {
;1245:			// show hit model
;1246:			// modelindex2 is the health value of the obelisk
;1247:			c = cent->currentState.modelindex2;
;1248:			model.shaderRGBA[0] = 0xff;
;1249:			model.shaderRGBA[1] = c;
;1250:			model.shaderRGBA[2] = c;
;1251:			model.shaderRGBA[3] = 0xff;
;1252:			//
;1253:			model.hModel = cgs.media.overloadEnergyModel;
;1254:			trap_R_AddRefEntityToScene( &model );
;1255:		}
;1256:		// if respawning
;1257:		if ( cent->currentState.frame == 2) {
;1258:			if ( !cent->miscTime ) {
;1259:				cent->miscTime = cg.time;
;1260:			}
;1261:			t = cg.time - cent->miscTime;
;1262:			h = (cg_obeliskRespawnDelay.integer - 5) * 1000;
;1263:			//
;1264:			if (t > h) {
;1265:				c = (float) (t - h) / h;
;1266:				if (c > 1)
;1267:					c = 1;
;1268:			}
;1269:			else {
;1270:				c = 0;
;1271:			}
;1272:			// show the lights
;1273:			AnglesToAxis( cent->currentState.angles, model.axis );
;1274:			//
;1275:			model.shaderRGBA[0] = c * 0xff;
;1276:			model.shaderRGBA[1] = c * 0xff;
;1277:			model.shaderRGBA[2] = c * 0xff;
;1278:			model.shaderRGBA[3] = c * 0xff;
;1279:
;1280:			model.hModel = cgs.media.overloadLightsModel;
;1281:			trap_R_AddRefEntityToScene( &model );
;1282:			// show the target
;1283:			if (t > h) {
;1284:				if ( !cent->muzzleFlashTime ) {
;1285:					trap_S_StartSound (cent->lerpOrigin, ENTITYNUM_NONE, CHAN_BODY,  cgs.media.obeliskRespawnSound);
;1286:					cent->muzzleFlashTime = 1;
;1287:				}
;1288:				VectorCopy(cent->currentState.angles, angles);
;1289:				angles[YAW] += (float) 16 * acos(1-c) * 180 / M_PI;
;1290:				AnglesToAxis( angles, model.axis );
;1291:
;1292:				VectorScale( model.axis[0], c, model.axis[0]);
;1293:				VectorScale( model.axis[1], c, model.axis[1]);
;1294:				VectorScale( model.axis[2], c, model.axis[2]);
;1295:
;1296:				model.shaderRGBA[0] = 0xff;
;1297:				model.shaderRGBA[1] = 0xff;
;1298:				model.shaderRGBA[2] = 0xff;
;1299:				model.shaderRGBA[3] = 0xff;
;1300:				//
;1301:				model.origin[2] += 56;
;1302:				model.hModel = cgs.media.overloadTargetModel;
;1303:				trap_R_AddRefEntityToScene( &model );
;1304:			}
;1305:			else {
;1306:				//FIXME: show animated smoke
;1307:			}
;1308:		}
;1309:		else {
;1310:			cent->miscTime = 0;
;1311:			cent->muzzleFlashTime = 0;
;1312:			// modelindex2 is the health value of the obelisk
;1313:			c = cent->currentState.modelindex2;
;1314:			model.shaderRGBA[0] = 0xff;
;1315:			model.shaderRGBA[1] = c;
;1316:			model.shaderRGBA[2] = c;
;1317:			model.shaderRGBA[3] = 0xff;
;1318:			// show the lights
;1319:			model.hModel = cgs.media.overloadLightsModel;
;1320:			trap_R_AddRefEntityToScene( &model );
;1321:			// show the target
;1322:			model.origin[2] += 56;
;1323:			model.hModel = cgs.media.overloadTargetModel;
;1324:			trap_R_AddRefEntityToScene( &model );
;1325:		}
;1326:	}
;1327:	else if ( cgs.gametype == GT_HARVESTER ) {
;1328:		// show harvester model
;1329:		memset(&model, 0, sizeof(model));
;1330:		model.reType = RT_MODEL;
;1331:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1332:		VectorCopy( cent->lerpOrigin, model.origin );
;1333:		AnglesToAxis( cent->currentState.angles, model.axis );
;1334:
;1335:		if ( cent->currentState.modelindex == TEAM_RED ) {
;1336:			model.hModel = cgs.media.harvesterModel;
;1337:			model.customSkin = cgs.media.harvesterRedSkin;
;1338:		}
;1339:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;1340:			model.hModel = cgs.media.harvesterModel;
;1341:			model.customSkin = cgs.media.harvesterBlueSkin;
;1342:		}
;1343:		else {
;1344:			model.hModel = cgs.media.harvesterNeutralModel;
;1345:			model.customSkin = 0;
;1346:		}
;1347:		trap_R_AddRefEntityToScene( &model );
;1348:	}
;1349:#endif
;1350:}
LABELV $613
endproc CG_TeamBase 140 12
proc CG_AddCEntity 8 8
line 1358
;1351:
;1352:/*
;1353:===============
;1354:CG_AddCEntity
;1355:
;1356:===============
;1357:*/
;1358:static void CG_AddCEntity( centity_t *cent ) {
line 1360
;1359:	// event-only entities will have been dealt with already
;1360:	if ( cent->currentState.eType >= ET_EVENTS ) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 14
LTI4 $634
line 1361
;1361:		return;
ADDRGP4 $633
JUMPV
LABELV $634
line 1365
;1362:	}
;1363:
;1364:	// calculate the current origin
;1365:	CG_CalcEntityLerpPositions( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CalcEntityLerpPositions
CALLV
pop
line 1368
;1366:
;1367:	// add automatic effects
;1368:	CG_EntityEffects( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_EntityEffects
CALLV
pop
line 1370
;1369:
;1370:	switch ( cent->currentState.eType ) {
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
LTI4 $636
ADDRLP4 0
INDIRI4
CNSTI4 13
GTI4 $636
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $652
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $652
address $641
address $642
address $643
address $644
address $645
address $646
address $647
address $648
address $637
address $637
address $637
address $649
address $650
address $651
code
LABELV $636
line 1372
;1371:	default:
;1372:		CG_Error( "Bad entity type: %i\n", cent->currentState.eType );
ADDRGP4 $639
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
line 1373
;1373:		break;
ADDRGP4 $637
JUMPV
line 1377
;1374:	case ET_INVISIBLE:
;1375:	case ET_PUSH_TRIGGER:
;1376:	case ET_TELEPORT_TRIGGER:
;1377:		break;
LABELV $641
line 1379
;1378:	case ET_GENERAL:
;1379:		CG_General( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_General
CALLV
pop
line 1380
;1380:		break;
ADDRGP4 $637
JUMPV
LABELV $642
line 1382
;1381:	case ET_PLAYER:
;1382:		CG_Player( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Player
CALLV
pop
line 1383
;1383:		break;
ADDRGP4 $637
JUMPV
LABELV $643
line 1385
;1384:	case ET_ITEM:
;1385:		CG_Item( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Item
CALLV
pop
line 1386
;1386:		break;
ADDRGP4 $637
JUMPV
LABELV $644
line 1388
;1387:	case ET_MISSILE:
;1388:		CG_Missile( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Missile
CALLV
pop
line 1389
;1389:		break;
ADDRGP4 $637
JUMPV
LABELV $645
line 1391
;1390:	case ET_MOVER:
;1391:		CG_Mover( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Mover
CALLV
pop
line 1392
;1392:		break;
ADDRGP4 $637
JUMPV
LABELV $646
line 1394
;1393:	case ET_BEAM:
;1394:		CG_Beam( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Beam
CALLV
pop
line 1395
;1395:		break;
ADDRGP4 $637
JUMPV
LABELV $647
line 1397
;1396:	case ET_PORTAL:
;1397:		CG_Portal( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Portal
CALLV
pop
line 1398
;1398:		break;
ADDRGP4 $637
JUMPV
LABELV $648
line 1400
;1399:	case ET_SPEAKER:
;1400:		CG_Speaker( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Speaker
CALLV
pop
line 1401
;1401:		break;
ADDRGP4 $637
JUMPV
LABELV $649
line 1403
;1402:	case ET_GRAPPLE:
;1403:		CG_Grapple( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Grapple
CALLV
pop
line 1404
;1404:		break;
ADDRGP4 $637
JUMPV
LABELV $650
line 1406
;1405:	case ET_TEAM:
;1406:		CG_TeamBase( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_TeamBase
CALLV
pop
line 1407
;1407:		break;
ADDRGP4 $637
JUMPV
LABELV $651
line 1409
;1408:	case ET_MONSTER:
;1409:		CG_Monster(cent);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Monster
CALLV
pop
line 1410
;1410:		break;	
LABELV $637
line 1412
;1411:	}
;1412:}
LABELV $633
endproc CG_AddCEntity 8 8
export CG_AddPacketEntities
proc CG_AddPacketEntities 20 12
line 1420
;1413:
;1414:/*
;1415:===============
;1416:CG_AddPacketEntities
;1417:
;1418:===============
;1419:*/
;1420:void CG_AddPacketEntities( void ) {
line 1426
;1421:	int					num;
;1422:	centity_t			*cent;
;1423:	playerState_t		*ps;
;1424:
;1425:	// set cg.frameInterpolation
;1426:	if ( cg.nextSnap ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $654
line 1429
;1427:		int		delta;
;1428:
;1429:		delta = (cg.nextSnap->serverTime - cg.snap->serverTime);
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
line 1430
;1430:		if ( delta == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $659
line 1431
;1431:			cg.frameInterpolation = 0;
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1432
;1432:		} else {
ADDRGP4 $655
JUMPV
LABELV $659
line 1433
;1433:			cg.frameInterpolation = (float)( cg.time - cg.snap->serverTime ) / delta;
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
line 1434
;1434:		}
line 1435
;1435:	} else {
ADDRGP4 $655
JUMPV
LABELV $654
line 1436
;1436:		cg.frameInterpolation = 0;	// actually, it should never be used, because 
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1438
;1437:									// no entities should be marked as interpolating
;1438:	}
LABELV $655
line 1441
;1439:
;1440:	// the auto-rotating items will all have the same axis
;1441:	cg.autoAngles[0] = 0;
ADDRGP4 cg+108948
CNSTF4 0
ASGNF4
line 1442
;1442:	cg.autoAngles[1] = ( cg.time & 2047 ) * 360 / 2048.0;
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
line 1443
;1443:	cg.autoAngles[2] = 0;
ADDRGP4 cg+108948+8
CNSTF4 0
ASGNF4
line 1445
;1444:
;1445:	cg.autoAnglesFast[0] = 0;
ADDRGP4 cg+108996
CNSTF4 0
ASGNF4
line 1446
;1446:	cg.autoAnglesFast[1] = ( cg.time & 1023 ) * 360 / 1024.0f;
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
line 1447
;1447:	cg.autoAnglesFast[2] = 0;
ADDRGP4 cg+108996+8
CNSTF4 0
ASGNF4
line 1449
;1448:
;1449:	AnglesToAxis( cg.autoAngles, cg.autoAxis );
ADDRGP4 cg+108948
ARGP4
ADDRGP4 cg+108960
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1450
;1450:	AnglesToAxis( cg.autoAnglesFast, cg.autoAxisFast );
ADDRGP4 cg+108996
ARGP4
ADDRGP4 cg+109008
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1453
;1451:
;1452:	// generate and add the entity from the playerstate
;1453:	ps = &cg.predictedPlayerState;
ADDRLP4 8
ADDRGP4 cg+107636
ASGNP4
line 1454
;1454:	BG_PlayerStateToEntityState( ps, &cg.predictedPlayerEntity.currentState, qfalse );
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
line 1455
;1455:	CG_AddCEntity( &cg.predictedPlayerEntity );
ADDRGP4 cg+108104
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1458
;1456:
;1457:	// lerp the non-predicted value for lightning gun origins
;1458:	CG_CalcEntityLerpPositions( &cg_entities[ cg.snap->ps.clientNum ] );
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
line 1461
;1459:
;1460:	// add each entity sent over by the server
;1461:	for ( num = 0 ; num < cg.snap->numEntities ; num++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $689
JUMPV
LABELV $686
line 1462
;1462:		cent = &cg_entities[ cg.snap->entities[ num ].number ];
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
line 1463
;1463:		CG_AddCEntity( cent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1464
;1464:	}
LABELV $687
line 1461
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $689
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
LTI4 $686
line 1465
;1465:}
LABELV $653
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
LABELV $639
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
LABELV $580
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
LABELV $224
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
LABELV $167
byte 1 110
byte 1 111
byte 1 110
byte 1 101
byte 1 0
align 1
LABELV $162
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
LABELV $152
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
LABELV $149
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
LABELV $145
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
byte 1 70
byte 1 97
byte 1 117
byte 1 115
byte 1 116
byte 1 50
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
byte 1 83
byte 1 116
byte 1 114
byte 1 97
byte 1 116
byte 1 111
byte 1 115
byte 1 50
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
byte 1 50
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
LABELV $138
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
byte 1 50
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
LABELV $137
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
byte 1 50
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
LABELV $136
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
byte 1 51
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
LABELV $135
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
byte 1 50
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
LABELV $134
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
LABELV $133
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
LABELV $132
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
LABELV $131
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
LABELV $130
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
LABELV $129
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
LABELV $128
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
LABELV $127
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
LABELV $126
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
byte 1 53
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
LABELV $125
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
byte 1 52
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
LABELV $124
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
byte 1 51
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
LABELV $123
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
byte 1 50
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
