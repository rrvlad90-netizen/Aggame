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
LABELV $71
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
LABELV $72
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
LTI4 $71
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
LABELV $70
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
LABELV $77
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
LABELV $78
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
LTI4 $77
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
LABELV $76
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
NEI4 $83
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
ADDRGP4 $84
JUMPV
LABELV $83
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
LABELV $84
line 115
;115:}
LABELV $82
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
EQI4 $89
line 131
;131:		if (cent->currentState.eType != ET_SPEAKER) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 7
EQI4 $91
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
ADDRGP4 $92
JUMPV
LABELV $91
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
LABELV $92
line 138
;138:	}
LABELV $89
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
EQI4 $95
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
LABELV $95
line 154
;153:
;154:}
LABELV $88
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
NEI4 $98
line 170
;170:		return;
ADDRGP4 $97
JUMPV
LABELV $98
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
NEI4 $108
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
LABELV $108
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
LABELV $97
endproc CG_General 144 12
proc CG_Speaker 16 16
line 205
;197:
;198:/*
;199:==================
;200:CG_Speaker
;201:
;202:Speaker entities can automatically play sounds
;203:==================
;204:*/
;205:static void CG_Speaker( centity_t *cent ) {
line 206
;206:	if ( ! cent->currentState.clientNum ) {	// FIXME: use something other than clientNum...
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
CNSTI4 0
NEI4 $114
line 207
;207:		return;		// not auto triggering
ADDRGP4 $113
JUMPV
LABELV $114
line 210
;208:	}
;209:
;210:	if ( cg.time < cent->miscTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRI4
GEI4 $116
line 211
;211:		return;
ADDRGP4 $113
JUMPV
LABELV $116
line 214
;212:	}
;213:
;214:	trap_S_StartSound (NULL, cent->currentState.number, CHAN_ITEM, cgs.gameSounds[cent->currentState.eventParm] );
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
line 218
;215:
;216:	//	ent->s.frame = ent->wait * 10;
;217:	//	ent->s.clientNum = ent->random * 10;
;218:	cent->miscTime = cg.time + cent->currentState.frame * 100 + cent->currentState.clientNum * 100 * crandom();
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
line 219
;219:}
LABELV $113
endproc CG_Speaker 16 16
proc CG_Item 204 12
line 226
;220:
;221:/*
;222:==================
;223:CG_Item
;224:==================
;225:*/
;226:static void CG_Item( centity_t *cent ) {
line 235
;227:	refEntity_t	ent;
;228:	entityState_t	*es;
;229:	gitem_t		*item;
;230:	int		msec;
;231:	float		frac;
;232:	float		scale;
;233:	weaponInfo_t	*wi;
;234:
;235:	es = &cent->currentState;
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
line 237
;236:
;237:	if( es->modelindex >= bg_numItems ) {
ADDRLP4 144
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $122
line 238
;238:		CG_Error(
ADDRGP4 $124
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
line 242
;239:			"Bad item index %i on entity",
;240:			es->modelindex
;241:		);
;242:	}
LABELV $122
line 245
;243:
;244:	// if set to invisible, skip
;245:	if( !es->modelindex ||
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
EQI4 $127
ADDRLP4 144
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 128
BANDI4
ADDRLP4 168
INDIRI4
EQI4 $125
LABELV $127
line 246
;246:		(es->eFlags & EF_NODRAW) ) {
line 247
;247:		return;
ADDRGP4 $121
JUMPV
LABELV $125
line 250
;248:	}
;249:
;250:	item = &bg_itemlist[es->modelindex];
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
line 252
;251:
;252:	if( cg_simpleItems.integer &&
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
EQI4 $128
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 8
EQI4 $128
line 253
;253:		item->giType != IT_TEAM ) {
line 254
;254:		memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 256
;255:
;256:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 257
;257:		VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 261
;258:			cent->lerpOrigin,
;259:			ent.origin
;260:		);
;261:		ent.radius = 14;
ADDRLP4 0+132
CNSTF4 1096810496
ASGNF4
line 262
;262:		ent.customShader =
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
line 264
;263:			cg_items[es->modelindex].icon;
;264:		ent.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 265
;265:		ent.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 266
;266:		ent.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 267
;267:		ent.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 269
;268:
;269:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 270
;270:		return;
ADDRGP4 $121
JUMPV
LABELV $128
line 277
;271:	}
;272:
;273:	/*
;274:	 * Normal items continuously bob up and down.
;275:	 * Static items retain their original map position.
;276:	 */
;277:	if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $142
line 278
;278:		scale =
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
line 282
;279:			0.005 +
;280:			cent->currentState.number * 0.00001;
;281:
;282:		cent->lerpOrigin[2] +=
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
line 285
;283:			4 +
;284:			cos((cg.time + 1000) * scale) * 4;
;285:	}
LABELV $142
line 287
;286:
;287:	memset( &ent, 0, sizeof(ent) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 293
;288:
;289:	/*
;290:	 * Static items use a fixed identity axis.
;291:	 * Normal items use the original automatic rotation.
;292:	 */
;293:	if( cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
EQI4 $146
line 294
;294:		VectorClear( cent->lerpAngles );
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
line 295
;295:		AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 296
;296:	}
ADDRGP4 $147
JUMPV
LABELV $146
line 297
;297:	else if( item->giType == IT_HEALTH ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 4
NEI4 $150
line 298
;298:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108996
INDIRB
ASGNB 12
line 302
;299:			cg.autoAnglesFast,
;300:			cent->lerpAngles
;301:		);
;302:		AxisCopy(
ADDRGP4 cg+109008
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 306
;303:			cg.autoAxisFast,
;304:			ent.axis
;305:		);
;306:	}
ADDRGP4 $151
JUMPV
LABELV $150
line 307
;307:	else {
line 308
;308:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 cg+108948
INDIRB
ASGNB 12
line 312
;309:			cg.autoAngles,
;310:			cent->lerpAngles
;311:		);
;312:		AxisCopy(
ADDRGP4 cg+108960
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 316
;313:			cg.autoAxis,
;314:			ent.axis
;315:		);
;316:	}
LABELV $151
LABELV $147
line 318
;317:
;318:	wi = NULL;
ADDRLP4 152
CNSTP4 0
ASGNP4
line 324
;319:
;320:	/*
;321:	 * Weapon models have their origin at the attachment point,
;322:	 * so compensate using the weapon midpoint.
;323:	 */
;324:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $158
line 325
;325:		wi = &cg_weapons[item->giTag];
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
line 327
;326:
;327:		cent->lerpOrigin[0] -=
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
line 332
;328:			wi->weaponMidpoint[0] * ent.axis[0][0] +
;329:			wi->weaponMidpoint[1] * ent.axis[1][0] +
;330:			wi->weaponMidpoint[2] * ent.axis[2][0];
;331:
;332:		cent->lerpOrigin[1] -=
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
line 337
;333:			wi->weaponMidpoint[0] * ent.axis[0][1] +
;334:			wi->weaponMidpoint[1] * ent.axis[1][1] +
;335:			wi->weaponMidpoint[2] * ent.axis[2][1];
;336:
;337:		cent->lerpOrigin[2] -=
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
line 342
;338:			wi->weaponMidpoint[0] * ent.axis[0][2] +
;339:			wi->weaponMidpoint[1] * ent.axis[1][2] +
;340:			wi->weaponMidpoint[2] * ent.axis[2][2];
;341:
;342:		cent->lerpOrigin[2] += 8;
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
line 343
;343:	}
LABELV $158
line 345
;344:
;345:	ent.hModel =
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
line 348
;346:		cg_items[es->modelindex].models[0];
;347:
;348:	VectorCopy(
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 352
;349:		cent->lerpOrigin,
;350:		ent.origin
;351:	);
;352:	VectorCopy(
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 357
;353:		cent->lerpOrigin,
;354:		ent.oldorigin
;355:	);
;356:
;357:	ent.nonNormalizedAxes = qfalse;
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 363
;358:
;359:	/*
;360:	 * Static items appear immediately at full size.
;361:	 * Normal items retain the respawn scale animation.
;362:	 */
;363:	msec = cg.time - cent->miscTime;
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
line 365
;364:
;365:	if( !cg_staticItems.integer &&
ADDRLP4 172
CNSTI4 0
ASGNI4
ADDRGP4 cg_staticItems+12
INDIRI4
ADDRLP4 172
INDIRI4
NEI4 $187
ADDRLP4 156
INDIRI4
ADDRLP4 172
INDIRI4
LTI4 $187
ADDRLP4 156
INDIRI4
CNSTI4 1000
GEI4 $187
line 367
;366:		msec >= 0 &&
;367:		msec < ITEM_SCALEUP_TIME ) {
line 368
;368:		frac = (float)msec /
ADDRLP4 148
ADDRLP4 156
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 371
;369:			ITEM_SCALEUP_TIME;
;370:
;371:		VectorScale(
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
line 376
;372:			ent.axis[0],
;373:			frac,
;374:			ent.axis[0]
;375:		);
;376:		VectorScale(
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
line 381
;377:			ent.axis[1],
;378:			frac,
;379:			ent.axis[1]
;380:		);
;381:		VectorScale(
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
line 387
;382:			ent.axis[2],
;383:			frac,
;384:			ent.axis[2]
;385:		);
;386:
;387:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 388
;388:	}
ADDRGP4 $188
JUMPV
LABELV $187
line 389
;389:	else {
line 390
;390:		frac = 1.0f;
ADDRLP4 148
CNSTF4 1065353216
ASGNF4
line 391
;391:	}
LABELV $188
line 396
;392:
;393:	/*
;394:	 * Items without glow textures need a minimum light value.
;395:	 */
;396:	if( item->giType == IT_WEAPON ||
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
EQI4 $235
ADDRLP4 180
INDIRI4
CNSTI4 3
NEI4 $233
LABELV $235
line 397
;397:		item->giType == IT_ARMOR ) {
line 398
;398:		ent.renderfx |= RF_MINLIGHT;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 399
;399:	}
LABELV $233
line 402
;400:
;401:	// increase the size of weapon pickup models
;402:	if( item->giType == IT_WEAPON ) {
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $237
line 403
;403:		VectorScale(
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
line 408
;404:			ent.axis[0],
;405:			1.5f,
;406:			ent.axis[0]
;407:		);
;408:		VectorScale(
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
line 413
;409:			ent.axis[1],
;410:			1.5f,
;411:			ent.axis[1]
;412:		);
;413:		VectorScale(
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
line 419
;414:			ent.axis[2],
;415:			1.5f,
;416:			ent.axis[2]
;417:		);
;418:
;419:		ent.nonNormalizedAxes = qtrue;
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 431
;420:
;421:#ifdef MISSIONPACK
;422:		if( !cg_staticItems.integer ) {
;423:			trap_S_AddLoopingSound(
;424:				cent->currentState.number,
;425:				cent->lerpOrigin,
;426:				vec3_origin,
;427:				cgs.media.weaponHoverSound
;428:			);
;429:		}
;430:#endif
;431:	}
LABELV $237
line 457
;432:
;433:#ifdef MISSIONPACK
;434:	if( item->giType == IT_HOLDABLE &&
;435:		item->giTag == HI_KAMIKAZE ) {
;436:		VectorScale(
;437:			ent.axis[0],
;438:			2,
;439:			ent.axis[0]
;440:		);
;441:		VectorScale(
;442:			ent.axis[1],
;443:			2,
;444:			ent.axis[1]
;445:		);
;446:		VectorScale(
;447:			ent.axis[2],
;448:			2,
;449:			ent.axis[2]
;450:		);
;451:
;452:		ent.nonNormalizedAxes = qtrue;
;453:	}
;454:#endif
;455:
;456:	// add main model
;457:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 504
;458:
;459:#ifdef MISSIONPACK
;460:	if( item->giType == IT_WEAPON &&
;461:		wi->barrelModel ) {
;462:		refEntity_t barrel;
;463:
;464:		memset(
;465:			&barrel,
;466:			0,
;467:			sizeof(barrel)
;468:		);
;469:
;470:		barrel.hModel = wi->barrelModel;
;471:
;472:		VectorCopy(
;473:			ent.lightingOrigin,
;474:			barrel.lightingOrigin
;475:		);
;476:
;477:		barrel.shadowPlane =
;478:			ent.shadowPlane;
;479:		barrel.renderfx =
;480:			ent.renderfx;
;481:
;482:		CG_PositionRotatedEntityOnTag(
;483:			&barrel,
;484:			&ent,
;485:			wi->weaponModel,
;486:			"tag_barrel"
;487:		);
;488:
;489:		AxisCopy(
;490:			ent.axis,
;491:			barrel.axis
;492:		);
;493:
;494:		barrel.nonNormalizedAxes =
;495:			ent.nonNormalizedAxes;
;496:
;497:		trap_R_AddRefEntityToScene(
;498:			&barrel
;499:		);
;500:	}
;501:#endif
;502:
;503:	// accompanying rings and spheres for powerups
;504:	if( !cg_simpleItems.integer ) {
ADDRGP4 cg_simpleItems+12
INDIRI4
CNSTI4 0
NEI4 $282
line 507
;505:		vec3_t spinAngles;
;506:
;507:		VectorClear( spinAngles );
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
line 509
;508:
;509:		if( item->giType == IT_HEALTH ||
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
EQI4 $289
ADDRLP4 200
INDIRI4
CNSTI4 5
NEI4 $287
LABELV $289
line 510
;510:			item->giType == IT_POWERUP ) {
line 511
;511:			ent.hModel =
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
line 516
;512:				cg_items[
;513:					es->modelindex
;514:				].models[1];
;515:
;516:			if( ent.hModel ) {
ADDRLP4 0+8
INDIRI4
CNSTI4 0
EQI4 $293
line 517
;517:				if( item->giType ==
ADDRLP4 140
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 5
NEI4 $296
line 518
;518:					IT_POWERUP ) {
line 519
;519:					ent.origin[2] += 12;
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
CNSTF4 1094713344
ADDF4
ASGNF4
line 521
;520:
;521:					if( !cg_staticItems.integer ) {
ADDRGP4 cg_staticItems+12
INDIRI4
CNSTI4 0
NEI4 $300
line 522
;522:						spinAngles[1] =
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
line 526
;523:							(cg.time & 1023) *
;524:							360 /
;525:							-1024.0f;
;526:					}
LABELV $300
line 527
;527:				}
LABELV $296
line 529
;528:
;529:				AnglesToAxis(
ADDRLP4 184
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 534
;530:					spinAngles,
;531:					ent.axis
;532:				);
;533:
;534:				if( frac != 1.0f ) {
ADDRLP4 148
INDIRF4
CNSTF4 1065353216
EQF4 $306
line 535
;535:					VectorScale(
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
line 540
;536:						ent.axis[0],
;537:						frac,
;538:						ent.axis[0]
;539:					);
;540:					VectorScale(
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
line 545
;541:						ent.axis[1],
;542:						frac,
;543:						ent.axis[1]
;544:					);
;545:					VectorScale(
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
line 551
;546:						ent.axis[2],
;547:						frac,
;548:						ent.axis[2]
;549:					);
;550:
;551:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 1
ASGNI4
line 553
;552:						qtrue;
;553:				}
ADDRGP4 $307
JUMPV
LABELV $306
line 554
;554:				else {
line 555
;555:					ent.nonNormalizedAxes =
ADDRLP4 0+64
CNSTI4 0
ASGNI4
line 557
;556:						qfalse;
;557:				}
LABELV $307
line 559
;558:
;559:				trap_R_AddRefEntityToScene(
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 562
;560:					&ent
;561:				);
;562:			}
LABELV $293
line 563
;563:		}
LABELV $287
line 564
;564:	}
LABELV $282
line 565
;565:}
LABELV $121
endproc CG_Item 204 12
proc CG_Missile 164 20
line 574
;566:
;567://============================================================================
;568:
;569:/*
;570:===============
;571:CG_Missile
;572:===============
;573:*/
;574:static void CG_Missile( centity_t *cent ) {
line 580
;575:	refEntity_t			ent;
;576:	entityState_t		*s1;
;577:	const weaponInfo_t		*weapon;
;578://	int	col;
;579:
;580:	s1 = &cent->currentState;
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
line 581
;581:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 144
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $353
line 582
;582:		s1->weapon = 0;
ADDRLP4 144
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 583
;583:	}
LABELV $353
line 584
;584:	weapon = &cg_weapons[s1->weapon];
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
line 587
;585:
;586:	// calculate the axis
;587:	VectorCopy( s1->angles, cent->lerpAngles);
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
line 590
;588:
;589:	// add trails
;590:	if ( weapon->missileTrailFunc ) 
ADDRLP4 140
INDIRP4
CNSTI4 88
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $355
line 591
;591:	{
line 592
;592:		weapon->missileTrailFunc( cent, weapon );
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
line 593
;593:	}
LABELV $355
line 612
;594:/*
;595:	if ( cent->currentState.modelindex == TEAM_RED ) {
;596:		col = 1;
;597:	}
;598:	else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;599:		col = 2;
;600:	}
;601:	else {
;602:		col = 0;
;603:	}
;604:
;605:	// add dynamic light
;606:	if ( weapon->missileDlight ) {
;607:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
;608:			weapon->missileDlightColor[col][0], weapon->missileDlightColor[col][1], weapon->missileDlightColor[col][2] );
;609:	}
;610:*/
;611:	// add dynamic light
;612:	if ( weapon->missileDlight ) {
ADDRLP4 140
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
CNSTF4 0
EQF4 $357
line 613
;613:		trap_R_AddLightToScene(cent->lerpOrigin, weapon->missileDlight, 
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
line 615
;614:			weapon->missileDlightColor[0], weapon->missileDlightColor[1], weapon->missileDlightColor[2] );
;615:	}
LABELV $357
line 618
;616:
;617:	// add missile sound
;618:	if ( weapon->missileSound ) {
ADDRLP4 140
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 0
EQI4 $359
line 621
;619:		vec3_t	velocity;
;620:
;621:		BG_EvaluateTrajectoryDelta( &cent->currentState.pos, cg.time, velocity );
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
line 623
;622:
;623:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, velocity, weapon->missileSound );
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
line 624
;624:	}
LABELV $359
line 627
;625:
;626:	// create the render entity
;627:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 628
;628:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 629
;629:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 631
;630:
;631:	if ( cent->currentState.weapon == WP_PLASMAGUN ) {
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 8
NEI4 $364
line 632
;632:		ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 633
;633:		ent.radius = 16;
ADDRLP4 0+132
CNSTF4 1098907648
ASGNF4
line 634
;634:		ent.rotation = 0;
ADDRLP4 0+136
CNSTF4 0
ASGNF4
line 635
;635:		ent.customShader = cgs.media.plasmaBallShader;
ADDRLP4 0+112
ADDRGP4 cgs+152340+288
INDIRI4
ASGNI4
line 636
;636:		trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 637
;637:		return;
ADDRGP4 $352
JUMPV
LABELV $364
line 641
;638:	}
;639:
;640:	// flicker between two skins
;641:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 642
;642:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 140
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 643
;643:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 140
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 654
;644:
;645:#ifdef MISSIONPACK
;646:	if ( cent->currentState.weapon == WP_PROX_LAUNCHER ) {
;647:		if (s1->generic1 == TEAM_BLUE) {
;648:			ent.hModel = cgs.media.blueProxMine;
;649:		}
;650:	}
;651:#endif
;652:
;653:	// convert direction of travel into axis
;654:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
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
NEF4 $374
line 655
;655:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 656
;656:	}
LABELV $374
line 659
;657:
;658:	// spin as it moves
;659:	if ( s1->pos.trType != TR_STATIONARY ) {
ADDRLP4 144
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 0
EQI4 $379
line 660
;660:		RotateAroundDirection( ent.axis, cg.time / 4 );
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
line 661
;661:	} else {
ADDRGP4 $380
JUMPV
LABELV $379
line 668
;662:#ifdef MISSIONPACK
;663:		if ( s1->weapon == WP_PROX_LAUNCHER ) {
;664:			AnglesToAxis( cent->lerpAngles, ent.axis );
;665:		}
;666:		else
;667:#endif
;668:		{
line 669
;669:			RotateAroundDirection( ent.axis, s1->time );
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
line 670
;670:		}
line 671
;671:	}
LABELV $380
line 674
;672:
;673:	// add to refresh list, possibly with quad glow
;674:	CG_AddRefEntityWithPowerups( &ent, s1, TEAM_FREE );
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
line 675
;675:}
LABELV $352
endproc CG_Missile 164 20
proc CG_Grapple 152 12
line 684
;676:
;677:/*
;678:===============
;679:CG_Grapple
;680:
;681:This is called when the grapple is sitting up against the wall
;682:===============
;683:*/
;684:static void CG_Grapple( centity_t *cent ) {
line 689
;685:	refEntity_t			ent;
;686:	entityState_t		*s1;
;687:	const weaponInfo_t		*weapon;
;688:
;689:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 690
;690:	if ( s1->weapon > WP_NUM_WEAPONS ) {
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 12
LEI4 $385
line 691
;691:		s1->weapon = 0;
ADDRLP4 140
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 0
ASGNI4
line 692
;692:	}
LABELV $385
line 693
;693:	weapon = &cg_weapons[s1->weapon];
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
line 696
;694:
;695:	// calculate the axis
;696:	VectorCopy( s1->angles, cent->lerpAngles);
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
line 706
;697:
;698:#if 0 // FIXME add grapple pull sound here..?
;699:	// add missile sound
;700:	if ( weapon->missileSound ) {
;701:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, weapon->missileSound );
;702:	}
;703:#endif
;704:
;705:	// Will draw cable if needed
;706:	CG_GrappleTrail ( cent, weapon );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRGP4 CG_GrappleTrail
CALLV
pop
line 709
;707:
;708:	// create the render entity
;709:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 710
;710:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 711
;711:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 714
;712:
;713:	// flicker between two skins
;714:	ent.skinNum = cg.clientFrame & 1;
ADDRLP4 0+104
ADDRGP4 cg
INDIRI4
CNSTI4 1
BANDI4
ASGNI4
line 715
;715:	ent.hModel = weapon->missileModel;
ADDRLP4 0+8
ADDRLP4 144
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 716
;716:	ent.renderfx = weapon->missileRenderfx | RF_NOSHADOW;
ADDRLP4 0+4
ADDRLP4 144
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 719
;717:
;718:	// convert direction of travel into axis
;719:	if ( VectorNormalize2( s1->pos.trDelta, ent.axis[0] ) == 0 ) {
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
NEF4 $392
line 720
;720:		ent.axis[0][2] = 1;
ADDRLP4 0+28+8
CNSTF4 1065353216
ASGNF4
line 721
;721:	}
LABELV $392
line 723
;722:
;723:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 724
;724:}
LABELV $384
endproc CG_Grapple 152 12
proc CG_Mover 144 12
line 731
;725:
;726:/*
;727:===============
;728:CG_Mover
;729:===============
;730:*/
;731:static void CG_Mover( centity_t *cent ) {
line 735
;732:	refEntity_t			ent;
;733:	entityState_t		*s1;
;734:
;735:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 738
;736:
;737:	// create the render entity
;738:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 739
;739:	VectorCopy( cent->lerpOrigin, ent.origin);
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 740
;740:	VectorCopy( cent->lerpOrigin, ent.oldorigin);
ADDRLP4 0+84
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 741
;741:	AnglesToAxis( cent->lerpAngles, ent.axis );
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
line 743
;742:
;743:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 746
;744:
;745:	// flicker between two skins (FIXME?)
;746:	ent.skinNum = ( cg.time >> 6 ) & 1;
ADDRLP4 0+104
ADDRGP4 cg+107604
INDIRI4
CNSTI4 6
RSHI4
CNSTI4 1
BANDI4
ASGNI4
line 749
;747:
;748:	// get the model, either as a bmodel or a modelindex
;749:	if ( s1->solid == SOLID_BMODEL ) {
ADDRLP4 140
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
NEI4 $404
line 750
;750:		ent.hModel = cgs.inlineDrawModel[s1->modelindex];
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
line 751
;751:	} else {
ADDRGP4 $405
JUMPV
LABELV $404
line 752
;752:		ent.hModel = cgs.gameModels[s1->modelindex];
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
line 753
;753:	}
LABELV $405
line 756
;754:
;755:	// add to refresh list
;756:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 759
;757:
;758:	// add the secondary model
;759:	if ( s1->modelindex2 ) {
ADDRLP4 140
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $410
line 760
;760:		ent.skinNum = 0;
ADDRLP4 0+104
CNSTI4 0
ASGNI4
line 761
;761:		ent.hModel = cgs.gameModels[s1->modelindex2];
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
line 762
;762:		trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 763
;763:	}
LABELV $410
line 765
;764:
;765:}
LABELV $397
endproc CG_Mover 144 12
export CG_Beam
proc CG_Beam 144 12
line 774
;766:
;767:/*
;768:===============
;769:CG_Beam
;770:
;771:Also called as an event
;772:===============
;773:*/
;774:void CG_Beam( centity_t *cent ) {
line 778
;775:	refEntity_t			ent;
;776:	entityState_t		*s1;
;777:
;778:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 781
;779:
;780:	// create the render entity
;781:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 782
;782:	VectorCopy( s1->pos.trBase, ent.origin );
ADDRLP4 0+68
ADDRLP4 140
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
line 783
;783:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 784
;784:	AxisClear( ent.axis );
ADDRLP4 0+28
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 785
;785:	ent.reType = RT_BEAM;
ADDRLP4 0
CNSTI4 3
ASGNI4
line 787
;786:
;787:	ent.renderfx = RF_NOSHADOW;
ADDRLP4 0+4
CNSTI4 64
ASGNI4
line 790
;788:
;789:	// add to refresh list
;790:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 791
;791:}
LABELV $415
endproc CG_Beam 144 12
proc CG_Portal 144 12
line 799
;792:
;793:
;794:/*
;795:===============
;796:CG_Portal
;797:===============
;798:*/
;799:static void CG_Portal( centity_t *cent ) {
line 803
;800:	refEntity_t			ent;
;801:	entityState_t		*s1;
;802:
;803:	s1 = &cent->currentState;
ADDRLP4 140
ADDRFP4 0
INDIRP4
ASGNP4
line 806
;804:
;805:	// create the render entity
;806:	memset (&ent, 0, sizeof(ent));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 807
;807:	VectorCopy( cent->lerpOrigin, ent.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 808
;808:	VectorCopy( s1->origin2, ent.oldorigin );
ADDRLP4 0+84
ADDRLP4 140
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
line 809
;809:	ByteToDir( s1->eventParm, ent.axis[0] );
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
line 810
;810:	PerpendicularVector( ent.axis[1], ent.axis[0] );
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 814
;811:
;812:	// negating this tends to get the directions like they want
;813:	// we really should have a camera roll value
;814:	VectorSubtract( vec3_origin, ent.axis[1], ent.axis[1] );
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
line 816
;815:
;816:	CrossProduct( ent.axis[0], ent.axis[1], ent.axis[2] );
ADDRLP4 0+28
ARGP4
ADDRLP4 0+28+12
ARGP4
ADDRLP4 0+28+24
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 817
;817:	ent.reType = RT_PORTALSURFACE;
ADDRLP4 0
CNSTI4 7
ASGNI4
line 818
;818:	ent.oldframe = s1->powerups;
ADDRLP4 0+96
ADDRLP4 140
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
ASGNI4
line 819
;819:	ent.frame = s1->frame;		// rotation speed
ADDRLP4 0+80
ADDRLP4 140
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 820
;820:	ent.skinNum = s1->clientNum/256.0 * 360;	// roll offset
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
line 823
;821:
;822:	// add to refresh list
;823:	trap_R_AddRefEntityToScene(&ent);
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 824
;824:}
LABELV $420
endproc CG_Portal 144 12
export CG_AdjustPositionForMover
proc CG_AdjustPositionForMover 92 12
line 834
;825:
;826:
;827:/*
;828:=========================
;829:CG_AdjustPositionForMover
;830:
;831:Also called by client movement prediction code
;832:=========================
;833:*/
;834:void CG_AdjustPositionForMover( const vec3_t in, int moverNum, int fromTime, int toTime, vec3_t out ) {
line 839
;835:	centity_t	*cent;
;836:	vec3_t	oldOrigin, origin, deltaOrigin;
;837:	vec3_t	oldAngles, angles, deltaAngles;
;838:
;839:	if ( moverNum <= 0 || moverNum >= ENTITYNUM_MAX_NORMAL ) {
ADDRLP4 76
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
LEI4 $456
ADDRLP4 76
INDIRI4
CNSTI4 1022
LTI4 $454
LABELV $456
line 840
;840:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 841
;841:		return;
ADDRGP4 $453
JUMPV
LABELV $454
line 844
;842:	}
;843:
;844:	cent = &cg_entities[ moverNum ];
ADDRLP4 0
CNSTI4 728
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 845
;845:	if ( cent->currentState.eType != ET_MOVER ) {
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
EQI4 $457
line 846
;846:		VectorCopy( in, out );
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 847
;847:		return;
ADDRGP4 $453
JUMPV
LABELV $457
line 850
;848:	}
;849:
;850:	BG_EvaluateTrajectory( &cent->currentState.pos, fromTime, oldOrigin );
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
line 851
;851:	BG_EvaluateTrajectory( &cent->currentState.apos, fromTime, oldAngles );
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
line 853
;852:
;853:	BG_EvaluateTrajectory( &cent->currentState.pos, toTime, origin );
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
line 854
;854:	BG_EvaluateTrajectory( &cent->currentState.apos, toTime, angles );
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
line 856
;855:
;856:	VectorSubtract( origin, oldOrigin, deltaOrigin );
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
line 857
;857:	VectorSubtract( angles, oldAngles, deltaAngles );
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
line 859
;858:
;859:	VectorAdd( in, deltaOrigin, out );
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
line 862
;860:
;861:	// FIXME: origin change when on a rotating object
;862:}
LABELV $453
endproc CG_AdjustPositionForMover 92 12
proc CG_InterpolateEntityPosition 44 12
line 870
;863:
;864:
;865:/*
;866:=============================
;867:CG_InterpolateEntityPosition
;868:=============================
;869:*/
;870:static void CG_InterpolateEntityPosition( centity_t *cent ) {
line 876
;871:	vec3_t		current, next;
;872:	float		f;
;873:
;874:	// it would be an internal error to find an entity that interpolates without
;875:	// a snapshot ahead of the current one
;876:	if ( cg.nextSnap == NULL ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $474
line 877
;877:		CG_Error( "CG_InterpoateEntityPosition: cg.nextSnap == NULL" );
ADDRGP4 $477
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 878
;878:	}
LABELV $474
line 880
;879:
;880:	f = cg.frameInterpolation;
ADDRLP4 24
ADDRGP4 cg+107588
INDIRF4
ASGNF4
line 884
;881:
;882:	// this will linearize a sine or parabolic curve, but it is important
;883:	// to not extrapolate player positions if more recent data is available
;884:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.snap->serverTime, current );
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
line 885
;885:	BG_EvaluateTrajectory( &cent->nextState.pos, cg.nextSnap->serverTime, next );
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
line 887
;886:
;887:	cent->lerpOrigin[0] = current[0] + f * ( next[0] - current[0] );
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
line 888
;888:	cent->lerpOrigin[1] = current[1] + f * ( next[1] - current[1] );
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
line 889
;889:	cent->lerpOrigin[2] = current[2] + f * ( next[2] - current[2] );
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
line 891
;890:
;891:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.snap->serverTime, current );
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
line 892
;892:	BG_EvaluateTrajectory( &cent->nextState.apos, cg.nextSnap->serverTime, next );
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
line 894
;893:
;894:	cent->lerpAngles[0] = LerpAngle( current[0], next[0], f );
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
line 895
;895:	cent->lerpAngles[1] = LerpAngle( current[1], next[1], f );
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
line 896
;896:	cent->lerpAngles[2] = LerpAngle( current[2], next[2], f );
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
line 898
;897:
;898:}
LABELV $473
endproc CG_InterpolateEntityPosition 44 12
proc CG_CalcEntityLerpPositions 24 20
line 906
;899:
;900:/*
;901:===============
;902:CG_CalcEntityLerpPositions
;903:
;904:===============
;905:*/
;906:static void CG_CalcEntityLerpPositions( centity_t *cent ) {
line 909
;907:
;908:	// if this player does not want to see extrapolated players
;909:	if ( !cg_smoothClients.integer ) {
ADDRGP4 cg_smoothClients+12
INDIRI4
CNSTI4 0
NEI4 $494
line 911
;910:		// make sure the clients use TR_INTERPOLATE
;911:		if ( cent->currentState.number < MAX_CLIENTS ) {
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $497
line 912
;912:			cent->currentState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 913
;913:			cent->nextState.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
CNSTI4 1
ASGNI4
line 914
;914:		}
LABELV $497
line 915
;915:	}
LABELV $494
line 917
;916:
;917:	if ( cent->interpolate && cent->currentState.pos.trType == TR_INTERPOLATE ) {
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
EQI4 $499
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 1
NEI4 $499
line 918
;918:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 919
;919:		return;
ADDRGP4 $493
JUMPV
LABELV $499
line 924
;920:	}
;921:
;922:	// first see if we can interpolate between two snaps for
;923:	// linear extrapolated clients
;924:	if ( cent->interpolate && cent->currentState.pos.trType == TR_LINEAR_STOP &&
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
EQI4 $501
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 3
NEI4 $501
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 64
GEI4 $501
line 925
;925:											cent->currentState.number < MAX_CLIENTS) {
line 926
;926:		CG_InterpolateEntityPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_InterpolateEntityPosition
CALLV
pop
line 927
;927:		return;
ADDRGP4 $493
JUMPV
LABELV $501
line 931
;928:	}
;929:
;930:	// just use the current frame and evaluate as best we can
;931:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.time, cent->lerpOrigin );
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
line 932
;932:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.time, cent->lerpAngles );
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
line 936
;933:
;934:	// adjust for riding a mover if it wasn't rolled into the predicted
;935:	// player state
;936:	if ( cent != &cg.predictedPlayerEntity ) {
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 cg+108104
CVPU4 4
EQU4 $505
line 937
;937:		CG_AdjustPositionForMover( cent->lerpOrigin, cent->currentState.groundEntityNum, 
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
line 939
;938:		cg.snap->serverTime, cg.time, cent->lerpOrigin );
;939:	}
LABELV $505
line 940
;940:}
LABELV $493
endproc CG_CalcEntityLerpPositions 24 20
proc CG_TeamBase 140 12
line 947
;941:
;942:/*
;943:===============
;944:CG_TeamBase
;945:===============
;946:*/
;947:static void CG_TeamBase( centity_t *cent ) {
line 956
;948:	refEntity_t model;
;949:#ifdef MISSIONPACK
;950:	vec3_t angles;
;951:	int t, h;
;952:	float c;
;953:
;954:	if ( cgs.gametype == GT_CTF || cgs.gametype == GT_1FCTF ) {
;955:#else
;956:	if ( cgs.gametype == GT_CTF) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $511
line 959
;957:#endif
;958:		// show the flag base
;959:		memset(&model, 0, sizeof(model));
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
;960:		model.reType = RT_MODEL;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 961
;961:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 962
;962:		VectorCopy( cent->lerpOrigin, model.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 963
;963:		AnglesToAxis( cent->currentState.angles, model.axis );
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
line 964
;964:		if ( cent->currentState.modelindex == TEAM_RED ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $517
line 965
;965:			model.hModel = cgs.media.redFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+108
INDIRI4
ASGNI4
line 966
;966:		}
ADDRGP4 $518
JUMPV
LABELV $517
line 967
;967:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 2
NEI4 $522
line 968
;968:			model.hModel = cgs.media.blueFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+112
INDIRI4
ASGNI4
line 969
;969:		}
ADDRGP4 $523
JUMPV
LABELV $522
line 970
;970:		else {
line 971
;971:			model.hModel = cgs.media.neutralFlagBaseModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+116
INDIRI4
ASGNI4
line 972
;972:		}
LABELV $523
LABELV $518
line 973
;973:		trap_R_AddRefEntityToScene( &model );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 974
;974:	}
LABELV $511
line 1093
;975:#ifdef MISSIONPACK
;976:	else if ( cgs.gametype == GT_OBELISK ) {
;977:		// show the obelisk
;978:		memset(&model, 0, sizeof(model));
;979:		model.reType = RT_MODEL;
;980:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;981:		VectorCopy( cent->lerpOrigin, model.origin );
;982:		AnglesToAxis( cent->currentState.angles, model.axis );
;983:
;984:		model.hModel = cgs.media.overloadBaseModel;
;985:		trap_R_AddRefEntityToScene( &model );
;986:		// if hit
;987:		if ( cent->currentState.frame == 1) {
;988:			// show hit model
;989:			// modelindex2 is the health value of the obelisk
;990:			c = cent->currentState.modelindex2;
;991:			model.shaderRGBA[0] = 0xff;
;992:			model.shaderRGBA[1] = c;
;993:			model.shaderRGBA[2] = c;
;994:			model.shaderRGBA[3] = 0xff;
;995:			//
;996:			model.hModel = cgs.media.overloadEnergyModel;
;997:			trap_R_AddRefEntityToScene( &model );
;998:		}
;999:		// if respawning
;1000:		if ( cent->currentState.frame == 2) {
;1001:			if ( !cent->miscTime ) {
;1002:				cent->miscTime = cg.time;
;1003:			}
;1004:			t = cg.time - cent->miscTime;
;1005:			h = (cg_obeliskRespawnDelay.integer - 5) * 1000;
;1006:			//
;1007:			if (t > h) {
;1008:				c = (float) (t - h) / h;
;1009:				if (c > 1)
;1010:					c = 1;
;1011:			}
;1012:			else {
;1013:				c = 0;
;1014:			}
;1015:			// show the lights
;1016:			AnglesToAxis( cent->currentState.angles, model.axis );
;1017:			//
;1018:			model.shaderRGBA[0] = c * 0xff;
;1019:			model.shaderRGBA[1] = c * 0xff;
;1020:			model.shaderRGBA[2] = c * 0xff;
;1021:			model.shaderRGBA[3] = c * 0xff;
;1022:
;1023:			model.hModel = cgs.media.overloadLightsModel;
;1024:			trap_R_AddRefEntityToScene( &model );
;1025:			// show the target
;1026:			if (t > h) {
;1027:				if ( !cent->muzzleFlashTime ) {
;1028:					trap_S_StartSound (cent->lerpOrigin, ENTITYNUM_NONE, CHAN_BODY,  cgs.media.obeliskRespawnSound);
;1029:					cent->muzzleFlashTime = 1;
;1030:				}
;1031:				VectorCopy(cent->currentState.angles, angles);
;1032:				angles[YAW] += (float) 16 * acos(1-c) * 180 / M_PI;
;1033:				AnglesToAxis( angles, model.axis );
;1034:
;1035:				VectorScale( model.axis[0], c, model.axis[0]);
;1036:				VectorScale( model.axis[1], c, model.axis[1]);
;1037:				VectorScale( model.axis[2], c, model.axis[2]);
;1038:
;1039:				model.shaderRGBA[0] = 0xff;
;1040:				model.shaderRGBA[1] = 0xff;
;1041:				model.shaderRGBA[2] = 0xff;
;1042:				model.shaderRGBA[3] = 0xff;
;1043:				//
;1044:				model.origin[2] += 56;
;1045:				model.hModel = cgs.media.overloadTargetModel;
;1046:				trap_R_AddRefEntityToScene( &model );
;1047:			}
;1048:			else {
;1049:				//FIXME: show animated smoke
;1050:			}
;1051:		}
;1052:		else {
;1053:			cent->miscTime = 0;
;1054:			cent->muzzleFlashTime = 0;
;1055:			// modelindex2 is the health value of the obelisk
;1056:			c = cent->currentState.modelindex2;
;1057:			model.shaderRGBA[0] = 0xff;
;1058:			model.shaderRGBA[1] = c;
;1059:			model.shaderRGBA[2] = c;
;1060:			model.shaderRGBA[3] = 0xff;
;1061:			// show the lights
;1062:			model.hModel = cgs.media.overloadLightsModel;
;1063:			trap_R_AddRefEntityToScene( &model );
;1064:			// show the target
;1065:			model.origin[2] += 56;
;1066:			model.hModel = cgs.media.overloadTargetModel;
;1067:			trap_R_AddRefEntityToScene( &model );
;1068:		}
;1069:	}
;1070:	else if ( cgs.gametype == GT_HARVESTER ) {
;1071:		// show harvester model
;1072:		memset(&model, 0, sizeof(model));
;1073:		model.reType = RT_MODEL;
;1074:		VectorCopy( cent->lerpOrigin, model.lightingOrigin );
;1075:		VectorCopy( cent->lerpOrigin, model.origin );
;1076:		AnglesToAxis( cent->currentState.angles, model.axis );
;1077:
;1078:		if ( cent->currentState.modelindex == TEAM_RED ) {
;1079:			model.hModel = cgs.media.harvesterModel;
;1080:			model.customSkin = cgs.media.harvesterRedSkin;
;1081:		}
;1082:		else if ( cent->currentState.modelindex == TEAM_BLUE ) {
;1083:			model.hModel = cgs.media.harvesterModel;
;1084:			model.customSkin = cgs.media.harvesterBlueSkin;
;1085:		}
;1086:		else {
;1087:			model.hModel = cgs.media.harvesterNeutralModel;
;1088:			model.customSkin = 0;
;1089:		}
;1090:		trap_R_AddRefEntityToScene( &model );
;1091:	}
;1092:#endif
;1093:}
LABELV $510
endproc CG_TeamBase 140 12
proc CG_AddCEntity 8 8
line 1101
;1094:
;1095:/*
;1096:===============
;1097:CG_AddCEntity
;1098:
;1099:===============
;1100:*/
;1101:static void CG_AddCEntity( centity_t *cent ) {
line 1103
;1102:	// event-only entities will have been dealt with already
;1103:	if ( cent->currentState.eType >= ET_EVENTS ) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
LTI4 $531
line 1104
;1104:		return;
ADDRGP4 $530
JUMPV
LABELV $531
line 1108
;1105:	}
;1106:
;1107:	// calculate the current origin
;1108:	CG_CalcEntityLerpPositions( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CalcEntityLerpPositions
CALLV
pop
line 1111
;1109:
;1110:	// add automatic effects
;1111:	CG_EntityEffects( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_EntityEffects
CALLV
pop
line 1113
;1112:
;1113:	switch ( cent->currentState.eType ) {
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
LTI4 $533
ADDRLP4 0
INDIRI4
CNSTI4 12
GTI4 $533
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $548
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $548
address $538
address $539
address $540
address $541
address $542
address $543
address $544
address $545
address $534
address $534
address $534
address $546
address $547
code
LABELV $533
line 1115
;1114:	default:
;1115:		CG_Error( "Bad entity type: %i\n", cent->currentState.eType );
ADDRGP4 $536
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
line 1116
;1116:		break;
ADDRGP4 $534
JUMPV
line 1120
;1117:	case ET_INVISIBLE:
;1118:	case ET_PUSH_TRIGGER:
;1119:	case ET_TELEPORT_TRIGGER:
;1120:		break;
LABELV $538
line 1122
;1121:	case ET_GENERAL:
;1122:		CG_General( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_General
CALLV
pop
line 1123
;1123:		break;
ADDRGP4 $534
JUMPV
LABELV $539
line 1125
;1124:	case ET_PLAYER:
;1125:		CG_Player( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Player
CALLV
pop
line 1126
;1126:		break;
ADDRGP4 $534
JUMPV
LABELV $540
line 1128
;1127:	case ET_ITEM:
;1128:		CG_Item( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Item
CALLV
pop
line 1129
;1129:		break;
ADDRGP4 $534
JUMPV
LABELV $541
line 1131
;1130:	case ET_MISSILE:
;1131:		CG_Missile( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Missile
CALLV
pop
line 1132
;1132:		break;
ADDRGP4 $534
JUMPV
LABELV $542
line 1134
;1133:	case ET_MOVER:
;1134:		CG_Mover( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Mover
CALLV
pop
line 1135
;1135:		break;
ADDRGP4 $534
JUMPV
LABELV $543
line 1137
;1136:	case ET_BEAM:
;1137:		CG_Beam( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Beam
CALLV
pop
line 1138
;1138:		break;
ADDRGP4 $534
JUMPV
LABELV $544
line 1140
;1139:	case ET_PORTAL:
;1140:		CG_Portal( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Portal
CALLV
pop
line 1141
;1141:		break;
ADDRGP4 $534
JUMPV
LABELV $545
line 1143
;1142:	case ET_SPEAKER:
;1143:		CG_Speaker( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Speaker
CALLV
pop
line 1144
;1144:		break;
ADDRGP4 $534
JUMPV
LABELV $546
line 1146
;1145:	case ET_GRAPPLE:
;1146:		CG_Grapple( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Grapple
CALLV
pop
line 1147
;1147:		break;
ADDRGP4 $534
JUMPV
LABELV $547
line 1149
;1148:	case ET_TEAM:
;1149:		CG_TeamBase( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_TeamBase
CALLV
pop
line 1150
;1150:		break;
LABELV $534
line 1152
;1151:	}
;1152:}
LABELV $530
endproc CG_AddCEntity 8 8
export CG_AddPacketEntities
proc CG_AddPacketEntities 20 12
line 1160
;1153:
;1154:/*
;1155:===============
;1156:CG_AddPacketEntities
;1157:
;1158:===============
;1159:*/
;1160:void CG_AddPacketEntities( void ) {
line 1166
;1161:	int					num;
;1162:	centity_t			*cent;
;1163:	playerState_t		*ps;
;1164:
;1165:	// set cg.frameInterpolation
;1166:	if ( cg.nextSnap ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $550
line 1169
;1167:		int		delta;
;1168:
;1169:		delta = (cg.nextSnap->serverTime - cg.snap->serverTime);
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
line 1170
;1170:		if ( delta == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $555
line 1171
;1171:			cg.frameInterpolation = 0;
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1172
;1172:		} else {
ADDRGP4 $551
JUMPV
LABELV $555
line 1173
;1173:			cg.frameInterpolation = (float)( cg.time - cg.snap->serverTime ) / delta;
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
line 1174
;1174:		}
line 1175
;1175:	} else {
ADDRGP4 $551
JUMPV
LABELV $550
line 1176
;1176:		cg.frameInterpolation = 0;	// actually, it should never be used, because 
ADDRGP4 cg+107588
CNSTF4 0
ASGNF4
line 1178
;1177:									// no entities should be marked as interpolating
;1178:	}
LABELV $551
line 1181
;1179:
;1180:	// the auto-rotating items will all have the same axis
;1181:	cg.autoAngles[0] = 0;
ADDRGP4 cg+108948
CNSTF4 0
ASGNF4
line 1182
;1182:	cg.autoAngles[1] = ( cg.time & 2047 ) * 360 / 2048.0;
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
line 1183
;1183:	cg.autoAngles[2] = 0;
ADDRGP4 cg+108948+8
CNSTF4 0
ASGNF4
line 1185
;1184:
;1185:	cg.autoAnglesFast[0] = 0;
ADDRGP4 cg+108996
CNSTF4 0
ASGNF4
line 1186
;1186:	cg.autoAnglesFast[1] = ( cg.time & 1023 ) * 360 / 1024.0f;
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
line 1187
;1187:	cg.autoAnglesFast[2] = 0;
ADDRGP4 cg+108996+8
CNSTF4 0
ASGNF4
line 1189
;1188:
;1189:	AnglesToAxis( cg.autoAngles, cg.autoAxis );
ADDRGP4 cg+108948
ARGP4
ADDRGP4 cg+108960
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1190
;1190:	AnglesToAxis( cg.autoAnglesFast, cg.autoAxisFast );
ADDRGP4 cg+108996
ARGP4
ADDRGP4 cg+109008
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1193
;1191:
;1192:	// generate and add the entity from the playerstate
;1193:	ps = &cg.predictedPlayerState;
ADDRLP4 8
ADDRGP4 cg+107636
ASGNP4
line 1194
;1194:	BG_PlayerStateToEntityState( ps, &cg.predictedPlayerEntity.currentState, qfalse );
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
line 1195
;1195:	CG_AddCEntity( &cg.predictedPlayerEntity );
ADDRGP4 cg+108104
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1198
;1196:
;1197:	// lerp the non-predicted value for lightning gun origins
;1198:	CG_CalcEntityLerpPositions( &cg_entities[ cg.snap->ps.clientNum ] );
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
line 1201
;1199:
;1200:	// add each entity sent over by the server
;1201:	for ( num = 0 ; num < cg.snap->numEntities ; num++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $585
JUMPV
LABELV $582
line 1202
;1202:		cent = &cg_entities[ cg.snap->entities[ num ].number ];
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
line 1203
;1203:		CG_AddCEntity( cent );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_AddCEntity
CALLV
pop
line 1204
;1204:	}
LABELV $583
line 1201
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $585
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
LTI4 $582
line 1205
;1205:}
LABELV $549
endproc CG_AddPacketEntities 20 12
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
LABELV $536
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
LABELV $477
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
LABELV $124
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
