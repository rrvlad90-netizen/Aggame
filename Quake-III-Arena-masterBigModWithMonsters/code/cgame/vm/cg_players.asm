data
export cg_customSoundNames
align 4
LABELV cg_customSoundNames
address $74
address $75
address $76
address $77
address $78
address $79
address $80
address $81
address $82
address $83
address $84
address $85
address $86
skip 76
export CG_CustomSound
code
proc CG_CustomSound 16 8
file "../cg_players.c"
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
;23:// cg_players.c -- handle the media and animation for player entities
;24:#include "cg_local.h"
;25:
;26:char	*cg_customSoundNames[MAX_CUSTOM_SOUNDS] = {
;27:	"*death1.wav",
;28:	"*death2.wav",
;29:	"*death3.wav",
;30:	"*jump1.wav",
;31:	"*pain25_1.wav",
;32:	"*pain50_1.wav",
;33:	"*pain75_1.wav",
;34:	"*pain100_1.wav",
;35:	"*falling1.wav",
;36:	"*gasp.wav",
;37:	"*drown.wav",
;38:	"*fall1.wav",
;39:	"*taunt.wav"
;40:};
;41:
;42:
;43:/*
;44:================
;45:CG_CustomSound
;46:
;47:================
;48:*/
;49:sfxHandle_t	CG_CustomSound( int clientNum, const char *soundName ) {
line 53
;50:	clientInfo_t *ci;
;51:	int			i;
;52:
;53:	if ( soundName[0] != '*' ) {
ADDRFP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 42
EQI4 $88
line 54
;54:		return trap_S_RegisterSound( soundName, qfalse );
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 8
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
RETI4
ADDRGP4 $87
JUMPV
LABELV $88
line 57
;55:	}
;56:
;57:	if ( clientNum < 0 || clientNum >= MAX_CLIENTS ) {
ADDRLP4 8
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
LTI4 $92
ADDRLP4 8
INDIRI4
CNSTI4 64
LTI4 $90
LABELV $92
line 58
;58:		clientNum = 0;
ADDRFP4 0
CNSTI4 0
ASGNI4
line 59
;59:	}
LABELV $90
line 60
;60:	ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 4
CNSTI4 1708
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 62
;61:
;62:	for ( i = 0 ; i < MAX_CUSTOM_SOUNDS && cg_customSoundNames[i] ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $97
JUMPV
LABELV $94
line 63
;63:		if ( !strcmp( soundName, cg_customSoundNames[i] ) ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_customSoundNames
ADDP4
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $98
line 64
;64:			return ci->sounds[i];
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
INDIRP4
CNSTI4 1580
ADDP4
ADDP4
INDIRI4
RETI4
ADDRGP4 $87
JUMPV
LABELV $98
line 66
;65:		}
;66:	}
LABELV $95
line 62
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $97
ADDRLP4 0
INDIRI4
CNSTI4 32
GEI4 $100
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_customSoundNames
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $94
LABELV $100
line 68
;67:
;68:	CG_Error( "Unknown custom sound: %s", soundName );
ADDRGP4 $101
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 69
;69:	return 0;
CNSTI4 0
RETI4
LABELV $87
endproc CG_CustomSound 16 8
proc CG_ParseAnimationFile 20084 12
line 90
;70:}
;71:
;72:
;73:
;74:/*
;75:=============================================================================
;76:
;77:CLIENT INFO
;78:
;79:=============================================================================
;80:*/
;81:
;82:/*
;83:======================
;84:CG_ParseAnimationFile
;85:
;86:Read a configuration file containing animation coutns and rates
;87:models/players/visor/animation.cfg, etc
;88:======================
;89:*/
;90:static qboolean	CG_ParseAnimationFile( const char *filename, clientInfo_t *ci ) {
line 101
;91:	char		*text_p, *prev;
;92:	int			len;
;93:	int			i;
;94:	char		*token;
;95:	float		fps;
;96:	int			skip;
;97:	char		text[20000];
;98:	fileHandle_t	f;
;99:	animation_t *animations;
;100:
;101:	animations = ci->animations;
ADDRLP4 8
ADDRFP4 4
INDIRP4
CNSTI4 544
ADDP4
ASGNP4
line 104
;102:
;103:	// load the file
;104:	len = trap_FS_FOpenFile( filename, &f, FS_READ );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20032
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 20036
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 28
ADDRLP4 20036
INDIRI4
ASGNI4
line 105
;105:	if ( len <= 0 ) {
ADDRLP4 28
INDIRI4
CNSTI4 0
GTI4 $103
line 106
;106:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $102
JUMPV
LABELV $103
line 108
;107:	}
;108:	if ( len >= sizeof( text ) - 1 ) {
ADDRLP4 28
INDIRI4
CVIU4 4
CNSTU4 19999
LTU4 $105
line 109
;109:		CG_Printf( "File %s too long\n", filename );
ADDRGP4 $107
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 110
;110:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $102
JUMPV
LABELV $105
line 112
;111:	}
;112:	trap_FS_Read( text, len, f );
ADDRLP4 32
ARGP4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 20032
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 113
;113:	text[len] = 0;
ADDRLP4 28
INDIRI4
ADDRLP4 32
ADDP4
CNSTI1 0
ASGNI1
line 114
;114:	trap_FS_FCloseFile( f );
ADDRLP4 20032
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 117
;115:
;116:	// parse the text
;117:	text_p = text;
ADDRLP4 12
ADDRLP4 32
ASGNP4
line 118
;118:	skip = 0;	// quite the compiler warning
ADDRLP4 24
CNSTI4 0
ASGNI4
line 120
;119:
;120:	ci->footsteps = FOOTSTEP_NORMAL;
ADDRFP4 4
INDIRP4
CNSTI4 508
ADDP4
CNSTI4 0
ASGNI4
line 121
;121:	VectorClear( ci->headOffset );
ADDRLP4 20040
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 20044
CNSTF4 0
ASGNF4
ADDRLP4 20040
INDIRP4
CNSTI4 504
ADDP4
ADDRLP4 20044
INDIRF4
ASGNF4
ADDRLP4 20040
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 20044
INDIRF4
ASGNF4
ADDRLP4 20040
INDIRP4
CNSTI4 496
ADDP4
ADDRLP4 20044
INDIRF4
ASGNF4
line 122
;122:	ci->gender = GENDER_MALE;
ADDRFP4 4
INDIRP4
CNSTI4 512
ADDP4
CNSTI4 0
ASGNI4
line 123
;123:	ci->fixedlegs = qfalse;
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
CNSTI4 0
ASGNI4
line 124
;124:	ci->fixedtorso = qfalse;
ADDRFP4 4
INDIRP4
CNSTI4 492
ADDP4
CNSTI4 0
ASGNI4
ADDRGP4 $109
JUMPV
LABELV $108
line 127
;125:
;126:	// read optional parameters
;127:	while ( 1 ) {
line 128
;128:		prev = text_p;	// so we can unget
ADDRLP4 20
ADDRLP4 12
INDIRP4
ASGNP4
line 129
;129:		token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20048
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20048
INDIRP4
ASGNP4
line 130
;130:		if ( !token ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $111
line 131
;131:			break;
ADDRGP4 $110
JUMPV
LABELV $111
line 133
;132:		}
;133:		if ( !Q_stricmp( token, "footsteps" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $115
ARGP4
ADDRLP4 20052
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20052
INDIRI4
CNSTI4 0
NEI4 $113
line 134
;134:			token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20056
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20056
INDIRP4
ASGNP4
line 135
;135:			if ( !token ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $116
line 136
;136:				break;
ADDRGP4 $110
JUMPV
LABELV $116
line 138
;137:			}
;138:			if ( !Q_stricmp( token, "default" ) || !Q_stricmp( token, "normal" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $120
ARGP4
ADDRLP4 20060
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20060
INDIRI4
CNSTI4 0
EQI4 $122
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $121
ARGP4
ADDRLP4 20064
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20064
INDIRI4
CNSTI4 0
NEI4 $118
LABELV $122
line 139
;139:				ci->footsteps = FOOTSTEP_NORMAL;
ADDRFP4 4
INDIRP4
CNSTI4 508
ADDP4
CNSTI4 0
ASGNI4
line 140
;140:			} else if ( !Q_stricmp( token, "boot" ) ) {
ADDRGP4 $109
JUMPV
LABELV $118
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $125
ARGP4
ADDRLP4 20068
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20068
INDIRI4
CNSTI4 0
NEI4 $123
line 141
;141:				ci->footsteps = FOOTSTEP_BOOT;
ADDRFP4 4
INDIRP4
CNSTI4 508
ADDP4
CNSTI4 1
ASGNI4
line 142
;142:			} else if ( !Q_stricmp( token, "flesh" ) ) {
ADDRGP4 $109
JUMPV
LABELV $123
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $128
ARGP4
ADDRLP4 20072
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20072
INDIRI4
CNSTI4 0
NEI4 $126
line 143
;143:				ci->footsteps = FOOTSTEP_FLESH;
ADDRFP4 4
INDIRP4
CNSTI4 508
ADDP4
CNSTI4 2
ASGNI4
line 144
;144:			} else if ( !Q_stricmp( token, "mech" ) ) {
ADDRGP4 $109
JUMPV
LABELV $126
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $131
ARGP4
ADDRLP4 20076
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20076
INDIRI4
CNSTI4 0
NEI4 $129
line 145
;145:				ci->footsteps = FOOTSTEP_MECH;
ADDRFP4 4
INDIRP4
CNSTI4 508
ADDP4
CNSTI4 3
ASGNI4
line 146
;146:			} else if ( !Q_stricmp( token, "energy" ) ) {
ADDRGP4 $109
JUMPV
LABELV $129
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $134
ARGP4
ADDRLP4 20080
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20080
INDIRI4
CNSTI4 0
NEI4 $132
line 147
;147:				ci->footsteps = FOOTSTEP_ENERGY;
ADDRFP4 4
INDIRP4
CNSTI4 508
ADDP4
CNSTI4 4
ASGNI4
line 148
;148:			} else {
ADDRGP4 $109
JUMPV
LABELV $132
line 149
;149:				CG_Printf( "Bad footsteps parm in %s: %s\n", filename, token );
ADDRGP4 $135
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 150
;150:			}
line 151
;151:			continue;
ADDRGP4 $109
JUMPV
LABELV $113
line 152
;152:		} else if ( !Q_stricmp( token, "headoffset" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $138
ARGP4
ADDRLP4 20056
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20056
INDIRI4
CNSTI4 0
NEI4 $136
line 153
;153:			for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $139
line 154
;154:				token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20060
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20060
INDIRP4
ASGNP4
line 155
;155:				if ( !token ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $143
line 156
;156:					break;
ADDRGP4 $109
JUMPV
LABELV $143
line 158
;157:				}
;158:				ci->headOffset[i] = atof( token );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 20064
ADDRGP4 atof
CALLF4
ASGNF4
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 4
INDIRP4
CNSTI4 496
ADDP4
ADDP4
ADDRLP4 20064
INDIRF4
ASGNF4
line 159
;159:			}
LABELV $140
line 153
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 3
LTI4 $139
line 160
;160:			continue;
ADDRGP4 $109
JUMPV
LABELV $136
line 161
;161:		} else if ( !Q_stricmp( token, "sex" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $147
ARGP4
ADDRLP4 20060
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20060
INDIRI4
CNSTI4 0
NEI4 $145
line 162
;162:			token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20064
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20064
INDIRP4
ASGNP4
line 163
;163:			if ( !token ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $148
line 164
;164:				break;
ADDRGP4 $110
JUMPV
LABELV $148
line 166
;165:			}
;166:			if ( token[0] == 'f' || token[0] == 'F' ) {
ADDRLP4 20068
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 20068
INDIRI4
CNSTI4 102
EQI4 $152
ADDRLP4 20068
INDIRI4
CNSTI4 70
NEI4 $150
LABELV $152
line 167
;167:				ci->gender = GENDER_FEMALE;
ADDRFP4 4
INDIRP4
CNSTI4 512
ADDP4
CNSTI4 1
ASGNI4
line 168
;168:			} else if ( token[0] == 'n' || token[0] == 'N' ) {
ADDRGP4 $109
JUMPV
LABELV $150
ADDRLP4 20072
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 20072
INDIRI4
CNSTI4 110
EQI4 $155
ADDRLP4 20072
INDIRI4
CNSTI4 78
NEI4 $153
LABELV $155
line 169
;169:				ci->gender = GENDER_NEUTER;
ADDRFP4 4
INDIRP4
CNSTI4 512
ADDP4
CNSTI4 2
ASGNI4
line 170
;170:			} else {
ADDRGP4 $109
JUMPV
LABELV $153
line 171
;171:				ci->gender = GENDER_MALE;
ADDRFP4 4
INDIRP4
CNSTI4 512
ADDP4
CNSTI4 0
ASGNI4
line 172
;172:			}
line 173
;173:			continue;
ADDRGP4 $109
JUMPV
LABELV $145
line 174
;174:		} else if ( !Q_stricmp( token, "fixedlegs" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $158
ARGP4
ADDRLP4 20064
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20064
INDIRI4
CNSTI4 0
NEI4 $156
line 175
;175:			ci->fixedlegs = qtrue;
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
CNSTI4 1
ASGNI4
line 176
;176:			continue;
ADDRGP4 $109
JUMPV
LABELV $156
line 177
;177:		} else if ( !Q_stricmp( token, "fixedtorso" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $161
ARGP4
ADDRLP4 20068
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20068
INDIRI4
CNSTI4 0
NEI4 $159
line 178
;178:			ci->fixedtorso = qtrue;
ADDRFP4 4
INDIRP4
CNSTI4 492
ADDP4
CNSTI4 1
ASGNI4
line 179
;179:			continue;
ADDRGP4 $109
JUMPV
LABELV $159
line 183
;180:		}
;181:
;182:		// if it is a number, start parsing animations
;183:		if ( token[0] >= '0' && token[0] <= '9' ) {
ADDRLP4 20072
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 20072
INDIRI4
CNSTI4 48
LTI4 $162
ADDRLP4 20072
INDIRI4
CNSTI4 57
GTI4 $162
line 184
;184:			text_p = prev;	// unget the token
ADDRLP4 12
ADDRLP4 20
INDIRP4
ASGNP4
line 185
;185:			break;
ADDRGP4 $110
JUMPV
LABELV $162
line 187
;186:		}
;187:		Com_Printf( "unknown token '%s' is %s\n", token, filename );
ADDRGP4 $164
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 188
;188:	}
LABELV $109
line 127
ADDRGP4 $108
JUMPV
LABELV $110
line 191
;189:
;190:	// read information for each frame
;191:	for ( i = 0 ; i < MAX_ANIMATIONS ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $165
line 193
;192:
;193:		token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20048
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20048
INDIRP4
ASGNP4
line 194
;194:		if ( !*token ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $169
line 195
;195:			if( i >= TORSO_GETFLAG && i <= TORSO_NEGATIVE ) {
ADDRLP4 4
INDIRI4
CNSTI4 25
LTI4 $167
ADDRLP4 4
INDIRI4
CNSTI4 30
GTI4 $167
line 196
;196:				animations[i].firstFrame = animations[TORSO_GESTURE].firstFrame;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ASGNI4
line 197
;197:				animations[i].frameLerp = animations[TORSO_GESTURE].frameLerp;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 12
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
ASGNI4
line 198
;198:				animations[i].initialLerp = animations[TORSO_GESTURE].initialLerp;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 16
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 199
;199:				animations[i].loopFrames = animations[TORSO_GESTURE].loopFrames;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 8
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
ASGNI4
line 200
;200:				animations[i].numFrames = animations[TORSO_GESTURE].numFrames;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 4
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 201
;201:				animations[i].reversed = qfalse;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 20
ADDP4
CNSTI4 0
ASGNI4
line 202
;202:				animations[i].flipflop = qfalse;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 24
ADDP4
CNSTI4 0
ASGNI4
line 203
;203:				continue;
ADDRGP4 $166
JUMPV
line 205
;204:			}
;205:			break;
LABELV $169
line 207
;206:		}
;207:		animations[i].firstFrame = atoi( token );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 20052
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
ADDRLP4 20052
INDIRI4
ASGNI4
line 209
;208:		// leg only frames are adjusted to not count the upper body only frames
;209:		if ( i == LEGS_WALKCR ) {
ADDRLP4 4
INDIRI4
CNSTI4 13
NEI4 $173
line 210
;210:			skip = animations[LEGS_WALKCR].firstFrame - animations[TORSO_GESTURE].firstFrame;
ADDRLP4 24
ADDRLP4 8
INDIRP4
CNSTI4 364
ADDP4
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
SUBI4
ASGNI4
line 211
;211:		}
LABELV $173
line 212
;212:		if ( i >= LEGS_WALKCR && i<TORSO_GETFLAG) {
ADDRLP4 4
INDIRI4
CNSTI4 13
LTI4 $175
ADDRLP4 4
INDIRI4
CNSTI4 25
GEI4 $175
line 213
;213:			animations[i].firstFrame -= skip;
ADDRLP4 20060
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
ASGNP4
ADDRLP4 20060
INDIRP4
ADDRLP4 20060
INDIRP4
INDIRI4
ADDRLP4 24
INDIRI4
SUBI4
ASGNI4
line 214
;214:		}
LABELV $175
line 216
;215:
;216:		token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20060
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20060
INDIRP4
ASGNP4
line 217
;217:		if ( !*token ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $177
line 218
;218:			break;
ADDRGP4 $167
JUMPV
LABELV $177
line 220
;219:		}
;220:		animations[i].numFrames = atoi( token );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 20064
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 4
ADDP4
ADDRLP4 20064
INDIRI4
ASGNI4
line 222
;221:
;222:		animations[i].reversed = qfalse;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 20
ADDP4
CNSTI4 0
ASGNI4
line 223
;223:		animations[i].flipflop = qfalse;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 24
ADDP4
CNSTI4 0
ASGNI4
line 225
;224:		// if numFrames is negative the animation is reversed
;225:		if (animations[i].numFrames < 0) {
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 0
GEI4 $179
line 226
;226:			animations[i].numFrames = -animations[i].numFrames;
ADDRLP4 20068
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 4
ADDP4
ASGNP4
ADDRLP4 20068
INDIRP4
ADDRLP4 20068
INDIRP4
INDIRI4
NEGI4
ASGNI4
line 227
;227:			animations[i].reversed = qtrue;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 20
ADDP4
CNSTI4 1
ASGNI4
line 228
;228:		}
LABELV $179
line 230
;229:
;230:		token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20068
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20068
INDIRP4
ASGNP4
line 231
;231:		if ( !*token ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $181
line 232
;232:			break;
ADDRGP4 $167
JUMPV
LABELV $181
line 234
;233:		}
;234:		animations[i].loopFrames = atoi( token );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 20072
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 8
ADDP4
ADDRLP4 20072
INDIRI4
ASGNI4
line 236
;235:
;236:		token = COM_Parse( &text_p );
ADDRLP4 12
ARGP4
ADDRLP4 20076
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20076
INDIRP4
ASGNP4
line 237
;237:		if ( !*token ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $183
line 238
;238:			break;
ADDRGP4 $167
JUMPV
LABELV $183
line 240
;239:		}
;240:		fps = atof( token );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 20080
ADDRGP4 atof
CALLF4
ASGNF4
ADDRLP4 16
ADDRLP4 20080
INDIRF4
ASGNF4
line 241
;241:		if ( fps == 0 ) {
ADDRLP4 16
INDIRF4
CNSTF4 0
NEF4 $185
line 242
;242:			fps = 1;
ADDRLP4 16
CNSTF4 1065353216
ASGNF4
line 243
;243:		}
LABELV $185
line 244
;244:		animations[i].frameLerp = 1000 / fps;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 12
ADDP4
CNSTF4 1148846080
ADDRLP4 16
INDIRF4
DIVF4
CVFI4 4
ASGNI4
line 245
;245:		animations[i].initialLerp = 1000 / fps;
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
CNSTI4 16
ADDP4
CNSTF4 1148846080
ADDRLP4 16
INDIRF4
DIVF4
CVFI4 4
ASGNI4
line 246
;246:	}
LABELV $166
line 191
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 31
LTI4 $165
LABELV $167
line 248
;247:
;248:	if ( i != MAX_ANIMATIONS ) {
ADDRLP4 4
INDIRI4
CNSTI4 31
EQI4 $187
line 249
;249:		CG_Printf( "Error parsing animation file: %s", filename );
ADDRGP4 $189
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 250
;250:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $102
JUMPV
LABELV $187
line 254
;251:	}
;252:
;253:	// crouch backward animation
;254:	memcpy(&animations[LEGS_BACKCR], &animations[LEGS_WALKCR], sizeof(animation_t));
ADDRLP4 8
INDIRP4
CNSTI4 896
ADDP4
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 364
ADDP4
ARGP4
CNSTI4 28
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 255
;255:	animations[LEGS_BACKCR].reversed = qtrue;
ADDRLP4 8
INDIRP4
CNSTI4 916
ADDP4
CNSTI4 1
ASGNI4
line 257
;256:	// walk backward animation
;257:	memcpy(&animations[LEGS_BACKWALK], &animations[LEGS_WALK], sizeof(animation_t));
ADDRLP4 8
INDIRP4
CNSTI4 924
ADDP4
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 392
ADDP4
ARGP4
CNSTI4 28
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 258
;258:	animations[LEGS_BACKWALK].reversed = qtrue;
ADDRLP4 8
INDIRP4
CNSTI4 944
ADDP4
CNSTI4 1
ASGNI4
line 260
;259:	// flag moving fast
;260:	animations[FLAG_RUN].firstFrame = 0;
ADDRLP4 8
INDIRP4
CNSTI4 952
ADDP4
CNSTI4 0
ASGNI4
line 261
;261:	animations[FLAG_RUN].numFrames = 16;
ADDRLP4 8
INDIRP4
CNSTI4 956
ADDP4
CNSTI4 16
ASGNI4
line 262
;262:	animations[FLAG_RUN].loopFrames = 16;
ADDRLP4 8
INDIRP4
CNSTI4 960
ADDP4
CNSTI4 16
ASGNI4
line 263
;263:	animations[FLAG_RUN].frameLerp = 1000 / 15;
ADDRLP4 8
INDIRP4
CNSTI4 964
ADDP4
CNSTI4 66
ASGNI4
line 264
;264:	animations[FLAG_RUN].initialLerp = 1000 / 15;
ADDRLP4 8
INDIRP4
CNSTI4 968
ADDP4
CNSTI4 66
ASGNI4
line 265
;265:	animations[FLAG_RUN].reversed = qfalse;
ADDRLP4 8
INDIRP4
CNSTI4 972
ADDP4
CNSTI4 0
ASGNI4
line 267
;266:	// flag not moving or moving slowly
;267:	animations[FLAG_STAND].firstFrame = 16;
ADDRLP4 8
INDIRP4
CNSTI4 980
ADDP4
CNSTI4 16
ASGNI4
line 268
;268:	animations[FLAG_STAND].numFrames = 5;
ADDRLP4 8
INDIRP4
CNSTI4 984
ADDP4
CNSTI4 5
ASGNI4
line 269
;269:	animations[FLAG_STAND].loopFrames = 0;
ADDRLP4 8
INDIRP4
CNSTI4 988
ADDP4
CNSTI4 0
ASGNI4
line 270
;270:	animations[FLAG_STAND].frameLerp = 1000 / 20;
ADDRLP4 8
INDIRP4
CNSTI4 992
ADDP4
CNSTI4 50
ASGNI4
line 271
;271:	animations[FLAG_STAND].initialLerp = 1000 / 20;
ADDRLP4 8
INDIRP4
CNSTI4 996
ADDP4
CNSTI4 50
ASGNI4
line 272
;272:	animations[FLAG_STAND].reversed = qfalse;
ADDRLP4 8
INDIRP4
CNSTI4 1000
ADDP4
CNSTI4 0
ASGNI4
line 274
;273:	// flag speeding up
;274:	animations[FLAG_STAND2RUN].firstFrame = 16;
ADDRLP4 8
INDIRP4
CNSTI4 1008
ADDP4
CNSTI4 16
ASGNI4
line 275
;275:	animations[FLAG_STAND2RUN].numFrames = 5;
ADDRLP4 8
INDIRP4
CNSTI4 1012
ADDP4
CNSTI4 5
ASGNI4
line 276
;276:	animations[FLAG_STAND2RUN].loopFrames = 1;
ADDRLP4 8
INDIRP4
CNSTI4 1016
ADDP4
CNSTI4 1
ASGNI4
line 277
;277:	animations[FLAG_STAND2RUN].frameLerp = 1000 / 15;
ADDRLP4 8
INDIRP4
CNSTI4 1020
ADDP4
CNSTI4 66
ASGNI4
line 278
;278:	animations[FLAG_STAND2RUN].initialLerp = 1000 / 15;
ADDRLP4 8
INDIRP4
CNSTI4 1024
ADDP4
CNSTI4 66
ASGNI4
line 279
;279:	animations[FLAG_STAND2RUN].reversed = qtrue;
ADDRLP4 8
INDIRP4
CNSTI4 1028
ADDP4
CNSTI4 1
ASGNI4
line 289
;280:	//
;281:	// new anims changes
;282:	//
;283://	animations[TORSO_GETFLAG].flipflop = qtrue;
;284://	animations[TORSO_GUARDBASE].flipflop = qtrue;
;285://	animations[TORSO_PATROL].flipflop = qtrue;
;286://	animations[TORSO_AFFIRMATIVE].flipflop = qtrue;
;287://	animations[TORSO_NEGATIVE].flipflop = qtrue;
;288:	//
;289:	return qtrue;
CNSTI4 1
RETI4
LABELV $102
endproc CG_ParseAnimationFile 20084 12
proc CG_FileExists 8 12
line 297
;290:}
;291:
;292:/*
;293:==========================
;294:CG_FileExists
;295:==========================
;296:*/
;297:static qboolean	CG_FileExists(const char *filename) {
line 300
;298:	int len;
;299:
;300:	len = trap_FS_FOpenFile( filename, 0, FS_READ );
ADDRFP4 0
INDIRP4
ARGP4
CNSTP4 0
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 4
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 301
;301:	if (len>0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LEI4 $191
line 302
;302:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $190
JUMPV
LABELV $191
line 304
;303:	}
;304:	return qfalse;
CNSTI4 0
RETI4
LABELV $190
endproc CG_FileExists 8 12
proc CG_FindClientModelFile 32 40
line 312
;305:}
;306:
;307:/*
;308:==========================
;309:CG_FindClientModelFile
;310:==========================
;311:*/
;312:static qboolean	CG_FindClientModelFile( char *filename, int length, clientInfo_t *ci, const char *teamName, const char *modelName, const char *skinName, const char *base, const char *ext ) {
line 316
;313:	char *team, *charactersFolder;
;314:	int i;
;315:
;316:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $194
line 317
;317:		switch ( ci->team ) {
ADDRLP4 12
ADDRFP4 8
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $200
ADDRGP4 $197
JUMPV
LABELV $200
line 318
;318:			case TEAM_BLUE: {
line 319
;319:				team = "blue";
ADDRLP4 8
ADDRGP4 $201
ASGNP4
line 320
;320:				break;
ADDRGP4 $195
JUMPV
LABELV $197
line 322
;321:			}
;322:			default: {
line 323
;323:				team = "red";
ADDRLP4 8
ADDRGP4 $202
ASGNP4
line 324
;324:				break;
line 327
;325:			}
;326:		}
;327:	}
ADDRGP4 $195
JUMPV
LABELV $194
line 328
;328:	else {
line 329
;329:		team = "default";
ADDRLP4 8
ADDRGP4 $120
ASGNP4
line 330
;330:	}
LABELV $195
line 331
;331:	charactersFolder = "";
ADDRLP4 4
ADDRGP4 $203
ASGNP4
ADDRGP4 $205
JUMPV
LABELV $204
line 332
;332:	while(1) {
line 333
;333:		for ( i = 0; i < 2; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $207
line 334
;334:			if ( i == 0 && teamName && *teamName ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $211
ADDRLP4 16
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $211
ADDRLP4 16
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 12
INDIRI4
EQI4 $211
line 336
;335:				//								"models/players/characters/james/stroggs/lower_lily_red.skin"
;336:				Com_sprintf( filename, length, "models/players/%s%s/%s%s_%s_%s.%s", charactersFolder, modelName, teamName, base, skinName, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $213
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 337
;337:			}
ADDRGP4 $212
JUMPV
LABELV $211
line 338
;338:			else {
line 340
;339:				//								"models/players/characters/james/lower_lily_red.skin"
;340:				Com_sprintf( filename, length, "models/players/%s%s/%s_%s_%s.%s", charactersFolder, modelName, base, skinName, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $214
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 341
;341:			}
LABELV $212
line 342
;342:			if ( CG_FileExists( filename ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 CG_FileExists
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $215
line 343
;343:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $193
JUMPV
LABELV $215
line 345
;344:			}
;345:			if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $217
line 346
;346:				if ( i == 0 && teamName && *teamName ) {
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $220
ADDRLP4 28
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $220
ADDRLP4 28
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 24
INDIRI4
EQI4 $220
line 348
;347:					//								"models/players/characters/james/stroggs/lower_red.skin"
;348:					Com_sprintf( filename, length, "models/players/%s%s/%s%s_%s.%s", charactersFolder, modelName, teamName, base, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $222
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 349
;349:				}
ADDRGP4 $218
JUMPV
LABELV $220
line 350
;350:				else {
line 352
;351:					//								"models/players/characters/james/lower_red.skin"
;352:					Com_sprintf( filename, length, "models/players/%s%s/%s_%s.%s", charactersFolder, modelName, base, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $223
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 353
;353:				}
line 354
;354:			}
ADDRGP4 $218
JUMPV
LABELV $217
line 355
;355:			else {
line 356
;356:				if ( i == 0 && teamName && *teamName ) {
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $224
ADDRLP4 28
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $224
ADDRLP4 28
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 24
INDIRI4
EQI4 $224
line 358
;357:					//								"models/players/characters/james/stroggs/lower_lily.skin"
;358:					Com_sprintf( filename, length, "models/players/%s%s/%s%s_%s.%s", charactersFolder, modelName, teamName, base, skinName, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $222
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 359
;359:				}
ADDRGP4 $225
JUMPV
LABELV $224
line 360
;360:				else {
line 362
;361:					//								"models/players/characters/james/lower_lily.skin"
;362:					Com_sprintf( filename, length, "models/players/%s%s/%s_%s.%s", charactersFolder, modelName, base, skinName, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $223
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 363
;363:				}
LABELV $225
line 364
;364:			}
LABELV $218
line 365
;365:			if ( CG_FileExists( filename ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 CG_FileExists
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
EQI4 $226
line 366
;366:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $193
JUMPV
LABELV $226
line 368
;367:			}
;368:			if ( !teamName || !*teamName ) {
ADDRLP4 28
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $230
ADDRLP4 28
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $228
LABELV $230
line 369
;369:				break;
ADDRGP4 $209
JUMPV
LABELV $228
line 371
;370:			}
;371:		}
LABELV $208
line 333
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LTI4 $207
LABELV $209
line 373
;372:		// if tried the heads folder first
;373:		if ( charactersFolder[0] ) {
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $231
line 374
;374:			break;
ADDRGP4 $206
JUMPV
LABELV $231
line 376
;375:		}
;376:		charactersFolder = "characters/";
ADDRLP4 4
ADDRGP4 $233
ASGNP4
line 377
;377:	}
LABELV $205
line 332
ADDRGP4 $204
JUMPV
LABELV $206
line 379
;378:
;379:	return qfalse;
CNSTI4 0
RETI4
LABELV $193
endproc CG_FindClientModelFile 32 40
proc CG_FindClientHeadFile 32 40
line 387
;380:}
;381:
;382:/*
;383:==========================
;384:CG_FindClientHeadFile
;385:==========================
;386:*/
;387:static qboolean	CG_FindClientHeadFile( char *filename, int length, clientInfo_t *ci, const char *teamName, const char *headModelName, const char *headSkinName, const char *base, const char *ext ) {
line 391
;388:	char *team, *headsFolder;
;389:	int i;
;390:
;391:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $235
line 392
;392:		switch ( ci->team ) {
ADDRLP4 12
ADDRFP4 8
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $241
ADDRGP4 $238
JUMPV
LABELV $241
line 393
;393:			case TEAM_BLUE: {
line 394
;394:				team = "blue";
ADDRLP4 8
ADDRGP4 $201
ASGNP4
line 395
;395:				break;
ADDRGP4 $236
JUMPV
LABELV $238
line 397
;396:			}
;397:			default: {
line 398
;398:				team = "red";
ADDRLP4 8
ADDRGP4 $202
ASGNP4
line 399
;399:				break;
line 402
;400:			}
;401:		}
;402:	}
ADDRGP4 $236
JUMPV
LABELV $235
line 403
;403:	else {
line 404
;404:		team = "default";
ADDRLP4 8
ADDRGP4 $120
ASGNP4
line 405
;405:	}
LABELV $236
line 407
;406:
;407:	if ( headModelName[0] == '*' ) {
ADDRFP4 16
INDIRP4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $242
line 408
;408:		headsFolder = "heads/";
ADDRLP4 4
ADDRGP4 $244
ASGNP4
line 409
;409:		headModelName++;
ADDRFP4 16
ADDRFP4 16
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 410
;410:	}
ADDRGP4 $246
JUMPV
LABELV $242
line 411
;411:	else {
line 412
;412:		headsFolder = "";
ADDRLP4 4
ADDRGP4 $203
ASGNP4
line 413
;413:	}
ADDRGP4 $246
JUMPV
LABELV $245
line 414
;414:	while(1) {
line 415
;415:		for ( i = 0; i < 2; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $248
line 416
;416:			if ( i == 0 && teamName && *teamName ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $252
ADDRLP4 16
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $252
ADDRLP4 16
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 12
INDIRI4
EQI4 $252
line 417
;417:				Com_sprintf( filename, length, "models/players/%s%s/%s/%s%s_%s.%s", headsFolder, headModelName, headSkinName, teamName, base, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $254
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 418
;418:			}
ADDRGP4 $253
JUMPV
LABELV $252
line 419
;419:			else {
line 420
;420:				Com_sprintf( filename, length, "models/players/%s%s/%s/%s_%s.%s", headsFolder, headModelName, headSkinName, base, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $255
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 421
;421:			}
LABELV $253
line 422
;422:			if ( CG_FileExists( filename ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 CG_FileExists
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $256
line 423
;423:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $234
JUMPV
LABELV $256
line 425
;424:			}
;425:			if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $258
line 426
;426:				if ( i == 0 &&  teamName && *teamName ) {
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $261
ADDRLP4 28
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $261
ADDRLP4 28
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 24
INDIRI4
EQI4 $261
line 427
;427:					Com_sprintf( filename, length, "models/players/%s%s/%s%s_%s.%s", headsFolder, headModelName, teamName, base, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $222
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 428
;428:				}
ADDRGP4 $259
JUMPV
LABELV $261
line 429
;429:				else {
line 430
;430:					Com_sprintf( filename, length, "models/players/%s%s/%s_%s.%s", headsFolder, headModelName, base, team, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $223
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 431
;431:				}
line 432
;432:			}
ADDRGP4 $259
JUMPV
LABELV $258
line 433
;433:			else {
line 434
;434:				if ( i == 0 && teamName && *teamName ) {
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $263
ADDRLP4 28
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $263
ADDRLP4 28
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 24
INDIRI4
EQI4 $263
line 435
;435:					Com_sprintf( filename, length, "models/players/%s%s/%s%s_%s.%s", headsFolder, headModelName, teamName, base, headSkinName, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $222
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 436
;436:				}
ADDRGP4 $264
JUMPV
LABELV $263
line 437
;437:				else {
line 438
;438:					Com_sprintf( filename, length, "models/players/%s%s/%s_%s.%s", headsFolder, headModelName, base, headSkinName, ext );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $223
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 24
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 28
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 439
;439:				}
LABELV $264
line 440
;440:			}
LABELV $259
line 441
;441:			if ( CG_FileExists( filename ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 CG_FileExists
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
EQI4 $265
line 442
;442:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $234
JUMPV
LABELV $265
line 444
;443:			}
;444:			if ( !teamName || !*teamName ) {
ADDRLP4 28
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $269
ADDRLP4 28
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $267
LABELV $269
line 445
;445:				break;
ADDRGP4 $250
JUMPV
LABELV $267
line 447
;446:			}
;447:		}
LABELV $249
line 415
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LTI4 $248
LABELV $250
line 449
;448:		// if tried the heads folder first
;449:		if ( headsFolder[0] ) {
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $270
line 450
;450:			break;
ADDRGP4 $247
JUMPV
LABELV $270
line 452
;451:		}
;452:		headsFolder = "heads/";
ADDRLP4 4
ADDRGP4 $244
ASGNP4
line 453
;453:	}
LABELV $246
line 414
ADDRGP4 $245
JUMPV
LABELV $247
line 455
;454:
;455:	return qfalse;
CNSTI4 0
RETI4
LABELV $234
endproc CG_FindClientHeadFile 32 40
proc CG_RegisterClientSkin 84 32
line 463
;456:}
;457:
;458:/*
;459:==========================
;460:CG_RegisterClientSkin
;461:==========================
;462:*/
;463:static qboolean	CG_RegisterClientSkin( clientInfo_t *ci, const char *teamName, const char *modelName, const char *skinName, const char *headModelName, const char *headSkinName ) {
line 488
;464:	char filename[MAX_QPATH];
;465:
;466:	/*
;467:	Com_sprintf( filename, sizeof( filename ), "models/players/%s/%slower_%s.skin", modelName, teamName, skinName );
;468:	ci->legsSkin = trap_R_RegisterSkin( filename );
;469:	if (!ci->legsSkin) {
;470:		Com_sprintf( filename, sizeof( filename ), "models/players/characters/%s/%slower_%s.skin", modelName, teamName, skinName );
;471:		ci->legsSkin = trap_R_RegisterSkin( filename );
;472:		if (!ci->legsSkin) {
;473:			Com_Printf( "Leg skin load failure: %s\n", filename );
;474:		}
;475:	}
;476:
;477:
;478:	Com_sprintf( filename, sizeof( filename ), "models/players/%s/%supper_%s.skin", modelName, teamName, skinName );
;479:	ci->torsoSkin = trap_R_RegisterSkin( filename );
;480:	if (!ci->torsoSkin) {
;481:		Com_sprintf( filename, sizeof( filename ), "models/players/characters/%s/%supper_%s.skin", modelName, teamName, skinName );
;482:		ci->torsoSkin = trap_R_RegisterSkin( filename );
;483:		if (!ci->torsoSkin) {
;484:			Com_Printf( "Torso skin load failure: %s\n", filename );
;485:		}
;486:	}
;487:	*/
;488:	if ( CG_FindClientModelFile( filename, sizeof(filename), ci, teamName, modelName, skinName, "lower", "skin" ) ) {
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $275
ARGP4
ADDRGP4 $276
ARGP4
ADDRLP4 64
ADDRGP4 CG_FindClientModelFile
CALLI4
ASGNI4
ADDRLP4 64
INDIRI4
CNSTI4 0
EQI4 $273
line 489
;489:		ci->legsSkin = trap_R_RegisterSkin( filename );
ADDRLP4 0
ARGP4
ADDRLP4 68
ADDRGP4 trap_R_RegisterSkin
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 520
ADDP4
ADDRLP4 68
INDIRI4
ASGNI4
line 490
;490:	}
LABELV $273
line 491
;491:	if (!ci->legsSkin) {
ADDRFP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $277
line 492
;492:		Com_Printf( "Leg skin load failure: %s\n", filename );
ADDRGP4 $279
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 493
;493:	}
LABELV $277
line 495
;494:
;495:	if ( CG_FindClientModelFile( filename, sizeof(filename), ci, teamName, modelName, skinName, "upper", "skin" ) ) {
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $282
ARGP4
ADDRGP4 $276
ARGP4
ADDRLP4 68
ADDRGP4 CG_FindClientModelFile
CALLI4
ASGNI4
ADDRLP4 68
INDIRI4
CNSTI4 0
EQI4 $280
line 496
;496:		ci->torsoSkin = trap_R_RegisterSkin( filename );
ADDRLP4 0
ARGP4
ADDRLP4 72
ADDRGP4 trap_R_RegisterSkin
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 528
ADDP4
ADDRLP4 72
INDIRI4
ASGNI4
line 497
;497:	}
LABELV $280
line 498
;498:	if (!ci->torsoSkin) {
ADDRFP4 0
INDIRP4
CNSTI4 528
ADDP4
INDIRI4
CNSTI4 0
NEI4 $283
line 499
;499:		Com_Printf( "Torso skin load failure: %s\n", filename );
ADDRGP4 $285
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 500
;500:	}
LABELV $283
line 502
;501:
;502:	if ( CG_FindClientHeadFile( filename, sizeof(filename), ci, teamName, headModelName, headSkinName, "head", "skin" ) ) {
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRGP4 $288
ARGP4
ADDRGP4 $276
ARGP4
ADDRLP4 72
ADDRGP4 CG_FindClientHeadFile
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $286
line 503
;503:		ci->headSkin = trap_R_RegisterSkin( filename );
ADDRLP4 0
ARGP4
ADDRLP4 76
ADDRGP4 trap_R_RegisterSkin
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ADDRLP4 76
INDIRI4
ASGNI4
line 504
;504:	}
LABELV $286
line 505
;505:	if (!ci->headSkin) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 0
NEI4 $289
line 506
;506:		Com_Printf( "Head skin load failure: %s\n", filename );
ADDRGP4 $291
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 507
;507:	}
LABELV $289
line 510
;508:
;509:	// if any skins failed to load
;510:	if ( !ci->legsSkin || !ci->torsoSkin || !ci->headSkin ) {
ADDRLP4 76
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 80
CNSTI4 0
ASGNI4
ADDRLP4 76
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ADDRLP4 80
INDIRI4
EQI4 $295
ADDRLP4 76
INDIRP4
CNSTI4 528
ADDP4
INDIRI4
ADDRLP4 80
INDIRI4
EQI4 $295
ADDRLP4 76
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
ADDRLP4 80
INDIRI4
NEI4 $292
LABELV $295
line 511
;511:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $272
JUMPV
LABELV $292
line 513
;512:	}
;513:	return qtrue;
CNSTI4 1
RETI4
LABELV $272
endproc CG_RegisterClientSkin 84 32
proc CG_RegisterClientModelname 292 32
line 521
;514:}
;515:
;516:/*
;517:==========================
;518:CG_RegisterClientModelname
;519:==========================
;520:*/
;521:static qboolean CG_RegisterClientModelname( clientInfo_t *ci, const char *modelName, const char *skinName, const char *headModelName, const char *headSkinName, const char *teamName ) {
line 526
;522:	char	filename[MAX_QPATH*2];
;523:	const char		*headName;
;524:	char newTeamName[MAX_QPATH*2];
;525:
;526:	if ( headModelName[0] == '\0' ) {
ADDRFP4 12
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $297
line 527
;527:		headName = modelName;
ADDRLP4 128
ADDRFP4 4
INDIRP4
ASGNP4
line 528
;528:	}
ADDRGP4 $298
JUMPV
LABELV $297
line 529
;529:	else {
line 530
;530:		headName = headModelName;
ADDRLP4 128
ADDRFP4 12
INDIRP4
ASGNP4
line 531
;531:	}
LABELV $298
line 532
;532:	Com_sprintf( filename, sizeof( filename ), "models/players/%s/lower.md3", modelName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $299
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 533
;533:	ci->legsModel = trap_R_RegisterModel( filename );
ADDRLP4 0
ARGP4
ADDRLP4 260
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
ADDRLP4 260
INDIRI4
ASGNI4
line 534
;534:	if ( !ci->legsModel ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRI4
CNSTI4 0
NEI4 $300
line 535
;535:		Com_sprintf( filename, sizeof( filename ), "models/players/characters/%s/lower.md3", modelName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $302
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 536
;536:		ci->legsModel = trap_R_RegisterModel( filename );
ADDRLP4 0
ARGP4
ADDRLP4 264
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
ADDRLP4 264
INDIRI4
ASGNI4
line 537
;537:		if ( !ci->legsModel ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRI4
CNSTI4 0
NEI4 $303
line 538
;538:			Com_Printf( "Failed to load model file %s\n", filename );
ADDRGP4 $305
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 539
;539:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
LABELV $303
line 541
;540:		}
;541:	}
LABELV $300
line 543
;542:
;543:	Com_sprintf( filename, sizeof( filename ), "models/players/%s/upper.md3", modelName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $306
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 544
;544:	ci->torsoModel = trap_R_RegisterModel( filename );
ADDRLP4 0
ARGP4
ADDRLP4 264
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRLP4 264
INDIRI4
ASGNI4
line 545
;545:	if ( !ci->torsoModel ) {
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRI4
CNSTI4 0
NEI4 $307
line 546
;546:		Com_sprintf( filename, sizeof( filename ), "models/players/characters/%s/upper.md3", modelName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $309
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 547
;547:		ci->torsoModel = trap_R_RegisterModel( filename );
ADDRLP4 0
ARGP4
ADDRLP4 268
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRLP4 268
INDIRI4
ASGNI4
line 548
;548:		if ( !ci->torsoModel ) {
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRI4
CNSTI4 0
NEI4 $310
line 549
;549:			Com_Printf( "Failed to load model file %s\n", filename );
ADDRGP4 $305
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 550
;550:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
LABELV $310
line 552
;551:		}
;552:	}
LABELV $307
line 554
;553:
;554:	if( headName[0] == '*' ) {
ADDRLP4 128
INDIRP4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $312
line 555
;555:		Com_sprintf( filename, sizeof( filename ), "models/players/heads/%s/%s.md3", &headModelName[1], &headModelName[1] );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $314
ARGP4
ADDRLP4 268
ADDRFP4 12
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 268
INDIRP4
ARGP4
ADDRLP4 268
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 556
;556:	}
ADDRGP4 $313
JUMPV
LABELV $312
line 557
;557:	else {
line 558
;558:		Com_sprintf( filename, sizeof( filename ), "models/players/%s/head.md3", headName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $315
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 559
;559:	}
LABELV $313
line 560
;560:	ci->headModel = trap_R_RegisterModel( filename );
ADDRLP4 0
ARGP4
ADDRLP4 268
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 532
ADDP4
ADDRLP4 268
INDIRI4
ASGNI4
line 562
;561:	// if the head model could not be found and we didn't load from the heads folder try to load from there
;562:	if ( !ci->headModel && headName[0] != '*' ) {
ADDRFP4 0
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
CNSTI4 0
NEI4 $316
ADDRLP4 128
INDIRP4
INDIRI1
CVII4 1
CNSTI4 42
EQI4 $316
line 563
;563:		Com_sprintf( filename, sizeof( filename ), "models/players/heads/%s/%s.md3", headModelName, headModelName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $314
ARGP4
ADDRLP4 272
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 272
INDIRP4
ARGP4
ADDRLP4 272
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 564
;564:		ci->headModel = trap_R_RegisterModel( filename );
ADDRLP4 0
ARGP4
ADDRLP4 276
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 532
ADDP4
ADDRLP4 276
INDIRI4
ASGNI4
line 565
;565:	}
LABELV $316
line 566
;566:	if ( !ci->headModel ) {
ADDRFP4 0
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
CNSTI4 0
NEI4 $318
line 567
;567:		Com_Printf( "Failed to load model file %s\n", filename );
ADDRGP4 $305
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 568
;568:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
LABELV $318
line 572
;569:	}
;570:
;571:	// if any skins failed to load, return failure
;572:	if ( !CG_RegisterClientSkin( ci, teamName, modelName, skinName, headName, headSkinName ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRLP4 272
ADDRGP4 CG_RegisterClientSkin
CALLI4
ASGNI4
ADDRLP4 272
INDIRI4
CNSTI4 0
NEI4 $320
line 573
;573:		if ( teamName && *teamName) {
ADDRLP4 276
ADDRFP4 20
INDIRP4
ASGNP4
ADDRLP4 276
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $322
ADDRLP4 276
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $322
line 574
;574:			Com_Printf( "Failed to load skin file: %s : %s : %s, %s : %s\n", teamName, modelName, skinName, headName, headSkinName );
ADDRGP4 $324
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 575
;575:			if( ci->team == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 2
NEI4 $325
line 576
;576:				Com_sprintf(newTeamName, sizeof(newTeamName), "%s/", DEFAULT_BLUETEAM_NAME);
ADDRLP4 132
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $327
ARGP4
ADDRGP4 $328
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 577
;577:			}
ADDRGP4 $326
JUMPV
LABELV $325
line 578
;578:			else {
line 579
;579:				Com_sprintf(newTeamName, sizeof(newTeamName), "%s/", DEFAULT_REDTEAM_NAME);
ADDRLP4 132
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $327
ARGP4
ADDRGP4 $329
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 580
;580:			}
LABELV $326
line 581
;581:			if ( !CG_RegisterClientSkin( ci, newTeamName, modelName, skinName, headName, headSkinName ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 132
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRLP4 280
ADDRGP4 CG_RegisterClientSkin
CALLI4
ASGNI4
ADDRLP4 280
INDIRI4
CNSTI4 0
NEI4 $323
line 582
;582:				Com_Printf( "Failed to load skin file: %s : %s : %s, %s : %s\n", newTeamName, modelName, skinName, headName, headSkinName );
ADDRGP4 $324
ARGP4
ADDRLP4 132
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 583
;583:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
line 585
;584:			}
;585:		} else {
LABELV $322
line 586
;586:			Com_Printf( "Failed to load skin file: %s : %s, %s : %s\n", modelName, skinName, headName, headSkinName );
ADDRGP4 $332
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 587
;587:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
LABELV $323
line 589
;588:		}
;589:	}
LABELV $320
line 592
;590:
;591:	// load the animations
;592:	Com_sprintf( filename, sizeof( filename ), "models/players/%s/animation.cfg", modelName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $333
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 593
;593:	if ( !CG_ParseAnimationFile( filename, ci ) ) {
ADDRLP4 0
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 276
ADDRGP4 CG_ParseAnimationFile
CALLI4
ASGNI4
ADDRLP4 276
INDIRI4
CNSTI4 0
NEI4 $334
line 594
;594:		Com_sprintf( filename, sizeof( filename ), "models/players/characters/%s/animation.cfg", modelName );
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $336
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 595
;595:		if ( !CG_ParseAnimationFile( filename, ci ) ) {
ADDRLP4 0
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
ADDRGP4 CG_ParseAnimationFile
CALLI4
ASGNI4
ADDRLP4 280
INDIRI4
CNSTI4 0
NEI4 $337
line 596
;596:			Com_Printf( "Failed to load animation file %s\n", filename );
ADDRGP4 $339
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 Com_Printf
CALLV
pop
line 597
;597:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
LABELV $337
line 599
;598:		}
;599:	}
LABELV $334
line 601
;600:
;601:	if ( CG_FindClientHeadFile( filename, sizeof(filename), ci, teamName, headName, headSkinName, "icon", "skin" ) ) {
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRGP4 $342
ARGP4
ADDRGP4 $276
ARGP4
ADDRLP4 280
ADDRGP4 CG_FindClientHeadFile
CALLI4
ASGNI4
ADDRLP4 280
INDIRI4
CNSTI4 0
EQI4 $340
line 602
;602:		ci->modelIcon = trap_R_RegisterShaderNoMip( filename );
ADDRLP4 0
ARGP4
ADDRLP4 284
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 540
ADDP4
ADDRLP4 284
INDIRI4
ASGNI4
line 603
;603:	}
ADDRGP4 $341
JUMPV
LABELV $340
line 604
;604:	else if ( CG_FindClientHeadFile( filename, sizeof(filename), ci, teamName, headName, headSkinName, "icon", "tga" ) ) {
ADDRLP4 0
ARGP4
CNSTI4 128
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRGP4 $342
ARGP4
ADDRGP4 $345
ARGP4
ADDRLP4 284
ADDRGP4 CG_FindClientHeadFile
CALLI4
ASGNI4
ADDRLP4 284
INDIRI4
CNSTI4 0
EQI4 $343
line 605
;605:		ci->modelIcon = trap_R_RegisterShaderNoMip( filename );
ADDRLP4 0
ARGP4
ADDRLP4 288
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 540
ADDP4
ADDRLP4 288
INDIRI4
ASGNI4
line 606
;606:	}
LABELV $343
LABELV $341
line 608
;607:
;608:	if ( !ci->modelIcon ) {
ADDRFP4 0
INDIRP4
CNSTI4 540
ADDP4
INDIRI4
CNSTI4 0
NEI4 $346
line 609
;609:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
LABELV $346
line 612
;610:	}
;611:
;612:	return qtrue;
CNSTI4 1
RETI4
LABELV $296
endproc CG_RegisterClientModelname 292 32
proc CG_ColorFromString 20 4
line 620
;613:}
;614:
;615:/*
;616:====================
;617:CG_ColorFromString
;618:====================
;619:*/
;620:static void CG_ColorFromString( const char *v, vec3_t color ) {
line 623
;621:	int val;
;622:
;623:	VectorClear( color );
ADDRLP4 4
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 8
CNSTF4 0
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
ADDRLP4 4
INDIRP4
ADDRLP4 8
INDIRF4
ASGNF4
line 625
;624:
;625:	val = atoi( v );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 627
;626:
;627:	if ( val < 1 || val > 7 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
LTI4 $351
ADDRLP4 0
INDIRI4
CNSTI4 7
LEI4 $349
LABELV $351
line 628
;628:		VectorSet( color, 1, 1, 1 );
ADDRFP4 4
INDIRP4
CNSTF4 1065353216
ASGNF4
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
CNSTF4 1065353216
ASGNF4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
CNSTF4 1065353216
ASGNF4
line 629
;629:		return;
ADDRGP4 $348
JUMPV
LABELV $349
line 632
;630:	}
;631:
;632:	if ( val & 1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $352
line 633
;633:		color[2] = 1.0f;
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
CNSTF4 1065353216
ASGNF4
line 634
;634:	}
LABELV $352
line 635
;635:	if ( val & 2 ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $354
line 636
;636:		color[1] = 1.0f;
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
CNSTF4 1065353216
ASGNF4
line 637
;637:	}
LABELV $354
line 638
;638:	if ( val & 4 ) {
ADDRLP4 0
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $356
line 639
;639:		color[0] = 1.0f;
ADDRFP4 4
INDIRP4
CNSTF4 1065353216
ASGNF4
line 640
;640:	}
LABELV $356
line 641
;641:}
LABELV $348
endproc CG_ColorFromString 20 4
proc CG_LoadClientInfo 152 24
line 651
;642:
;643:/*
;644:===================
;645:CG_LoadClientInfo
;646:
;647:Load it now, taking the disk hits.
;648:This will usually be deferred to a safe time
;649:===================
;650:*/
;651:static void CG_LoadClientInfo( clientInfo_t *ci ) {
line 658
;652:	const char	*dir, *fallback;
;653:	int			i, modelloaded;
;654:	const char	*s;
;655:	int			clientNum;
;656:	char		teamname[MAX_QPATH];
;657:
;658:	teamname[0] = 0;
ADDRLP4 24
CNSTI1 0
ASGNI1
line 671
;659:#ifdef MISSIONPACK
;660:	if( cgs.gametype >= GT_TEAM) {
;661:		if( ci->team == TEAM_BLUE ) {
;662:			Q_strncpyz(teamname, cg_blueTeamName.string, sizeof(teamname) );
;663:		} else {
;664:			Q_strncpyz(teamname, cg_redTeamName.string, sizeof(teamname) );
;665:		}
;666:	}
;667:	if( teamname[0] ) {
;668:		strcat( teamname, "/" );
;669:	}
;670:#endif
;671:	modelloaded = qtrue;
ADDRLP4 8
CNSTI4 1
ASGNI4
line 672
;672:	if ( !CG_RegisterClientModelname( ci, ci->modelName, ci->skinName, ci->headModelName, ci->headSkinName, teamname ) ) {
ADDRLP4 88
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 88
INDIRP4
ARGP4
ADDRLP4 88
INDIRP4
CNSTI4 160
ADDP4
ARGP4
ADDRLP4 88
INDIRP4
CNSTI4 224
ADDP4
ARGP4
ADDRLP4 88
INDIRP4
CNSTI4 288
ADDP4
ARGP4
ADDRLP4 88
INDIRP4
CNSTI4 352
ADDP4
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 92
ADDRGP4 CG_RegisterClientModelname
CALLI4
ASGNI4
ADDRLP4 92
INDIRI4
CNSTI4 0
NEI4 $359
line 673
;673:		if ( cg_buildScript.integer ) {
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $361
line 674
;674:			CG_Error( "CG_RegisterClientModelname( %s, %s, %s, %s %s ) failed", ci->modelName, ci->skinName, ci->headModelName, ci->headSkinName, teamname );
ADDRGP4 $364
ARGP4
ADDRLP4 96
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 96
INDIRP4
CNSTI4 160
ADDP4
ARGP4
ADDRLP4 96
INDIRP4
CNSTI4 224
ADDP4
ARGP4
ADDRLP4 96
INDIRP4
CNSTI4 288
ADDP4
ARGP4
ADDRLP4 96
INDIRP4
CNSTI4 352
ADDP4
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 675
;675:		}
LABELV $361
line 678
;676:
;677:		// fall back to default team name
;678:		if( cgs.gametype >= GT_TEAM) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $365
line 680
;679:			// keep skin name
;680:			if( ci->team == TEAM_BLUE ) {
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 2
NEI4 $368
line 681
;681:				Q_strncpyz(teamname, DEFAULT_BLUETEAM_NAME, sizeof(teamname) );
ADDRLP4 24
ARGP4
ADDRGP4 $328
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 682
;682:			} else {
ADDRGP4 $369
JUMPV
LABELV $368
line 683
;683:				Q_strncpyz(teamname, DEFAULT_REDTEAM_NAME, sizeof(teamname) );
ADDRLP4 24
ARGP4
ADDRGP4 $329
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 684
;684:			}
LABELV $369
line 685
;685:			if ( !CG_RegisterClientModelname( ci, DEFAULT_TEAM_MODEL, ci->skinName, DEFAULT_TEAM_HEAD, ci->skinName, teamname ) ) {
ADDRLP4 96
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 96
INDIRP4
ARGP4
ADDRLP4 100
ADDRGP4 $372
ASGNP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 104
ADDRLP4 96
INDIRP4
CNSTI4 224
ADDP4
ASGNP4
ADDRLP4 104
INDIRP4
ARGP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 104
INDIRP4
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 108
ADDRGP4 CG_RegisterClientModelname
CALLI4
ASGNI4
ADDRLP4 108
INDIRI4
CNSTI4 0
NEI4 $366
line 686
;686:				CG_Error( "DEFAULT_TEAM_MODEL / skin (%s/%s) failed to register", DEFAULT_TEAM_MODEL, ci->skinName );
ADDRGP4 $373
ARGP4
ADDRGP4 $372
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 224
ADDP4
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 687
;687:			}
line 688
;688:		} else {
ADDRGP4 $366
JUMPV
LABELV $365
line 689
;689:			if ( !CG_RegisterClientModelname( ci, DEFAULT_MODEL, "default", DEFAULT_MODEL, "default", teamname ) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 96
ADDRGP4 $372
ASGNP4
ADDRLP4 96
INDIRP4
ARGP4
ADDRLP4 100
ADDRGP4 $120
ASGNP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 96
INDIRP4
ARGP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 104
ADDRGP4 CG_RegisterClientModelname
CALLI4
ASGNI4
ADDRLP4 104
INDIRI4
CNSTI4 0
NEI4 $374
line 690
;690:				CG_Error( "DEFAULT_MODEL (%s) failed to register", DEFAULT_MODEL );
ADDRGP4 $376
ARGP4
ADDRGP4 $372
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 691
;691:			}
LABELV $374
line 692
;692:		}
LABELV $366
line 693
;693:		modelloaded = qfalse;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 694
;694:	}
LABELV $359
line 696
;695:
;696:	ci->newAnims = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 484
ADDP4
CNSTI4 0
ASGNI4
line 697
;697:	if ( ci->torsoModel ) {
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRI4
CNSTI4 0
EQI4 $377
line 700
;698:		orientation_t tag;
;699:		// if the torso model has the "tag_flag"
;700:		if ( trap_R_LerpTag( &tag, ci->torsoModel, 0, 0, 1, "tag_flag" ) ) {
ADDRLP4 96
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRI4
ARGI4
ADDRLP4 144
CNSTI4 0
ASGNI4
ADDRLP4 144
INDIRI4
ARGI4
ADDRLP4 144
INDIRI4
ARGI4
CNSTF4 1065353216
ARGF4
ADDRGP4 $381
ARGP4
ADDRLP4 148
ADDRGP4 trap_R_LerpTag
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
EQI4 $379
line 701
;701:			ci->newAnims = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 484
ADDP4
CNSTI4 1
ASGNI4
line 702
;702:		}
LABELV $379
line 703
;703:	}
LABELV $377
line 706
;704:
;705:	// sounds
;706:	dir = ci->modelName;
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
ASGNP4
line 707
;707:	fallback = (cgs.gametype >= GT_TEAM) ? DEFAULT_TEAM_MODEL : DEFAULT_MODEL;
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $384
ADDRLP4 96
ADDRGP4 $372
ASGNP4
ADDRGP4 $385
JUMPV
LABELV $384
ADDRLP4 96
ADDRGP4 $372
ASGNP4
LABELV $385
ADDRLP4 20
ADDRLP4 96
INDIRP4
ASGNP4
line 709
;708:
;709:	for ( i = 0 ; i < MAX_CUSTOM_SOUNDS ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $386
line 710
;710:		s = cg_customSoundNames[i];
ADDRLP4 4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_customSoundNames
ADDP4
INDIRP4
ASGNP4
line 711
;711:		if ( !s ) {
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $390
line 712
;712:			break;
ADDRGP4 $388
JUMPV
LABELV $390
line 714
;713:		}
;714:		ci->sounds[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 1580
ADDP4
ADDP4
CNSTI4 0
ASGNI4
line 716
;715:		// if the model didn't load use the sounds of the default model
;716:		if (modelloaded) {
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $392
line 717
;717:			ci->sounds[i] = trap_S_RegisterSound( va("sound/player/%s/%s", dir, s + 1), qfalse );
ADDRGP4 $394
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 1
ADDP4
ARGP4
ADDRLP4 100
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 100
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 104
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 1580
ADDP4
ADDP4
ADDRLP4 104
INDIRI4
ASGNI4
line 718
;718:		}
LABELV $392
line 719
;719:		if ( !ci->sounds[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 1580
ADDP4
ADDP4
INDIRI4
CNSTI4 0
NEI4 $395
line 720
;720:			ci->sounds[i] = trap_S_RegisterSound( va("sound/player/%s/%s", fallback, s + 1), qfalse );
ADDRGP4 $394
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 1
ADDP4
ARGP4
ADDRLP4 100
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 100
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 104
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 1580
ADDP4
ADDP4
ADDRLP4 104
INDIRI4
ASGNI4
line 721
;721:		}
LABELV $395
line 722
;722:	}
LABELV $387
line 709
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 32
LTI4 $386
LABELV $388
line 724
;723:
;724:	ci->deferred = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 480
ADDP4
CNSTI4 0
ASGNI4
line 728
;725:
;726:	// reset any existing players and bodies, because they might be in bad
;727:	// frames for this new model
;728:	clientNum = ci - cgs.clientinfo;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 cgs+40972
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 1708
DIVI4
ASGNI4
line 729
;729:	for ( i = 0 ; i < MAX_GENTITIES ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $398
line 730
;730:		if ( cg_entities[i].currentState.clientNum == clientNum
ADDRLP4 100
CNSTI4 728
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 100
INDIRI4
ADDRGP4 cg_entities+168
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $402
ADDRLP4 100
INDIRI4
ADDRGP4 cg_entities+4
ADDP4
INDIRI4
CNSTI4 1
NEI4 $402
line 731
;731:			&& cg_entities[i].currentState.eType == ET_PLAYER ) {
line 732
;732:			CG_ResetPlayerEntity( &cg_entities[i] );
CNSTI4 728
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ARGP4
ADDRGP4 CG_ResetPlayerEntity
CALLV
pop
line 733
;733:		}
LABELV $402
line 734
;734:	}
LABELV $399
line 729
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1024
LTI4 $398
line 735
;735:}
LABELV $358
endproc CG_LoadClientInfo 152 24
proc CG_CopyClientInfoModel 52 12
line 742
;736:
;737:/*
;738:======================
;739:CG_CopyClientInfoModel
;740:======================
;741:*/
;742:static void CG_CopyClientInfoModel( clientInfo_t *from, clientInfo_t *to ) {
line 743
;743:	VectorCopy( from->headOffset, to->headOffset );
ADDRLP4 0
CNSTI4 496
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 0
INDIRI4
ADDP4
INDIRB
ASGNB 12
line 744
;744:	to->footsteps = from->footsteps;
ADDRLP4 4
CNSTI4 508
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 4
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 4
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 745
;745:	to->gender = from->gender;
ADDRLP4 8
CNSTI4 512
ASGNI4
ADDRFP4 4
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
line 747
;746:
;747:	to->legsModel = from->legsModel;
ADDRLP4 12
CNSTI4 516
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 748
;748:	to->legsSkin = from->legsSkin;
ADDRLP4 16
CNSTI4 520
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 749
;749:	to->torsoModel = from->torsoModel;
ADDRLP4 20
CNSTI4 524
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 750
;750:	to->torsoSkin = from->torsoSkin;
ADDRLP4 24
CNSTI4 528
ASGNI4
ADDRFP4 4
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
line 751
;751:	to->headModel = from->headModel;
ADDRLP4 28
CNSTI4 532
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 752
;752:	to->headSkin = from->headSkin;
ADDRLP4 32
CNSTI4 536
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 753
;753:	to->modelIcon = from->modelIcon;
ADDRLP4 36
CNSTI4 540
ASGNI4
ADDRFP4 4
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
line 755
;754:
;755:	to->newAnims = from->newAnims;
ADDRLP4 40
CNSTI4 484
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 757
;756:
;757:	memcpy( to->animations, from->animations, sizeof( to->animations ) );
ADDRLP4 44
CNSTI4 544
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ARGP4
ADDRFP4 0
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ARGP4
CNSTI4 1036
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 758
;758:	memcpy( to->sounds, from->sounds, sizeof( to->sounds ) );
ADDRLP4 48
CNSTI4 1580
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
ARGP4
ADDRFP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 759
;759:}
LABELV $406
endproc CG_CopyClientInfoModel 52 12
proc CG_ScanForExistingClientInfo 60 8
line 766
;760:
;761:/*
;762:======================
;763:CG_ScanForExistingClientInfo
;764:======================
;765:*/
;766:static qboolean CG_ScanForExistingClientInfo( clientInfo_t *ci ) {
line 770
;767:	int		i;
;768:	clientInfo_t	*match;
;769:
;770:	for ( i = 0 ; i < cgs.maxclients ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $411
JUMPV
LABELV $408
line 771
;771:		match = &cgs.clientinfo[ i ];
ADDRLP4 0
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 772
;772:		if ( !match->infoValid ) {
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $414
line 773
;773:			continue;
ADDRGP4 $409
JUMPV
LABELV $414
line 775
;774:		}
;775:		if ( match->deferred ) {
ADDRLP4 0
INDIRP4
CNSTI4 480
ADDP4
INDIRI4
CNSTI4 0
EQI4 $416
line 776
;776:			continue;
ADDRGP4 $409
JUMPV
LABELV $416
line 778
;777:		}
;778:		if ( !Q_stricmp( ci->modelName, match->modelName )
ADDRLP4 8
CNSTI4 160
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
ARGP4
ADDRLP4 12
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $418
ADDRLP4 16
CNSTI4 224
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $418
ADDRLP4 24
CNSTI4 288
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $418
ADDRLP4 32
CNSTI4 352
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
ARGP4
ADDRLP4 36
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $418
ADDRLP4 40
CNSTI4 448
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
ARGP4
ADDRLP4 44
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
NEI4 $418
ADDRLP4 48
CNSTI4 416
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
ARGP4
ADDRLP4 52
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 0
NEI4 $418
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $421
ADDRLP4 56
CNSTI4 68
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
INDIRI4
NEI4 $418
LABELV $421
line 784
;779:			&& !Q_stricmp( ci->skinName, match->skinName )
;780:			&& !Q_stricmp( ci->headModelName, match->headModelName )
;781:			&& !Q_stricmp( ci->headSkinName, match->headSkinName ) 
;782:			&& !Q_stricmp( ci->blueTeam, match->blueTeam ) 
;783:			&& !Q_stricmp( ci->redTeam, match->redTeam )
;784:			&& (cgs.gametype < GT_TEAM || ci->team == match->team) ) {
line 787
;785:			// this clientinfo is identical, so use it's handles
;786:
;787:			ci->deferred = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 480
ADDP4
CNSTI4 0
ASGNI4
line 789
;788:
;789:			CG_CopyClientInfoModel( match, ci );
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CopyClientInfoModel
CALLV
pop
line 791
;790:
;791:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $407
JUMPV
LABELV $418
line 793
;792:		}
;793:	}
LABELV $409
line 770
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $411
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $408
line 796
;794:
;795:	// nothing matches, so defer the load
;796:	return qfalse;
CNSTI4 0
RETI4
LABELV $407
endproc CG_ScanForExistingClientInfo 60 8
proc CG_SetDeferredClientInfo 36 8
line 807
;797:}
;798:
;799:/*
;800:======================
;801:CG_SetDeferredClientInfo
;802:
;803:We aren't going to load it now, so grab some other
;804:client's info to use until we have some spare time.
;805:======================
;806:*/
;807:static void CG_SetDeferredClientInfo( clientInfo_t *ci ) {
line 813
;808:	int		i;
;809:	clientInfo_t	*match;
;810:
;811:	// if someone else is already the same models and skins we
;812:	// can just load the client info
;813:	for ( i = 0 ; i < cgs.maxclients ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $426
JUMPV
LABELV $423
line 814
;814:		match = &cgs.clientinfo[ i ];
ADDRLP4 0
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 815
;815:		if ( !match->infoValid || match->deferred ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $431
ADDRLP4 0
INDIRP4
CNSTI4 480
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $429
LABELV $431
line 816
;816:			continue;
ADDRGP4 $424
JUMPV
LABELV $429
line 818
;817:		}
;818:		if ( Q_stricmp( ci->skinName, match->skinName ) ||
ADDRLP4 16
CNSTI4 224
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $436
ADDRLP4 24
CNSTI4 160
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $436
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $432
ADDRLP4 32
CNSTI4 68
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
EQI4 $432
LABELV $436
line 822
;819:			 Q_stricmp( ci->modelName, match->modelName ) ||
;820://			 Q_stricmp( ci->headModelName, match->headModelName ) ||
;821://			 Q_stricmp( ci->headSkinName, match->headSkinName ) ||
;822:			 (cgs.gametype >= GT_TEAM && ci->team != match->team) ) {
line 823
;823:			continue;
ADDRGP4 $424
JUMPV
LABELV $432
line 826
;824:		}
;825:		// just load the real info cause it uses the same models and skins
;826:		CG_LoadClientInfo( ci );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_LoadClientInfo
CALLV
pop
line 827
;827:		return;
ADDRGP4 $422
JUMPV
LABELV $424
line 813
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $426
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $423
line 831
;828:	}
;829:
;830:	// if we are in teamplay, only grab a model if the skin is correct
;831:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $437
line 832
;832:		for ( i = 0 ; i < cgs.maxclients ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $443
JUMPV
LABELV $440
line 833
;833:			match = &cgs.clientinfo[ i ];
ADDRLP4 0
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 834
;834:			if ( !match->infoValid || match->deferred ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $448
ADDRLP4 0
INDIRP4
CNSTI4 480
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $446
LABELV $448
line 835
;835:				continue;
ADDRGP4 $441
JUMPV
LABELV $446
line 837
;836:			}
;837:			if ( Q_stricmp( ci->skinName, match->skinName ) ||
ADDRLP4 16
CNSTI4 224
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $452
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $449
ADDRLP4 24
CNSTI4 68
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
EQI4 $449
LABELV $452
line 838
;838:				(cgs.gametype >= GT_TEAM && ci->team != match->team) ) {
line 839
;839:				continue;
ADDRGP4 $441
JUMPV
LABELV $449
line 841
;840:			}
;841:			ci->deferred = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 480
ADDP4
CNSTI4 1
ASGNI4
line 842
;842:			CG_CopyClientInfoModel( match, ci );
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CopyClientInfoModel
CALLV
pop
line 843
;843:			return;
ADDRGP4 $422
JUMPV
LABELV $441
line 832
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $443
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $440
line 849
;844:		}
;845:		// load the full model, because we don't ever want to show
;846:		// an improper team skin.  This will cause a hitch for the first
;847:		// player, when the second enters.  Combat shouldn't be going on
;848:		// yet, so it shouldn't matter
;849:		CG_LoadClientInfo( ci );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_LoadClientInfo
CALLV
pop
line 850
;850:		return;
ADDRGP4 $422
JUMPV
LABELV $437
line 854
;851:	}
;852:
;853:	// find the first valid clientinfo and grab its stuff
;854:	for ( i = 0 ; i < cgs.maxclients ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $456
JUMPV
LABELV $453
line 855
;855:		match = &cgs.clientinfo[ i ];
ADDRLP4 0
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 856
;856:		if ( !match->infoValid ) {
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $459
line 857
;857:			continue;
ADDRGP4 $454
JUMPV
LABELV $459
line 860
;858:		}
;859:
;860:		ci->deferred = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 480
ADDP4
CNSTI4 1
ASGNI4
line 861
;861:		CG_CopyClientInfoModel( match, ci );
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CopyClientInfoModel
CALLV
pop
line 862
;862:		return;
ADDRGP4 $422
JUMPV
LABELV $454
line 854
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $456
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $453
line 866
;863:	}
;864:
;865:	// we should never get here...
;866:	CG_Printf( "CG_SetDeferredClientInfo: no valid clients!\n" );
ADDRGP4 $461
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 868
;867:
;868:	CG_LoadClientInfo( ci );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_LoadClientInfo
CALLV
pop
line 869
;869:}
LABELV $422
endproc CG_SetDeferredClientInfo 36 8
export CG_NewClientInfo
proc CG_NewClientInfo 1888 12
line 877
;870:
;871:
;872:/*
;873:======================
;874:CG_NewClientInfo
;875:======================
;876:*/
;877:void CG_NewClientInfo( int clientNum ) {
line 884
;878:	clientInfo_t *ci;
;879:	clientInfo_t newInfo;
;880:	const char	*configstring;
;881:	const char	*v;
;882:	char		*slash;
;883:
;884:	ci = &cgs.clientinfo[clientNum];
ADDRLP4 1720
CNSTI4 1708
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 886
;885:
;886:	configstring = CG_ConfigString( clientNum + CS_PLAYERS );
ADDRFP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 1724
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 1712
ADDRLP4 1724
INDIRP4
ASGNP4
line 887
;887:	if ( !configstring[0] ) {
ADDRLP4 1712
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $464
line 888
;888:		memset( ci, 0, sizeof( *ci ) );
ADDRLP4 1720
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 1708
ARGI4
ADDRGP4 memset
CALLP4
pop
line 889
;889:		return;		// player just left
ADDRGP4 $462
JUMPV
LABELV $464
line 894
;890:	}
;891:
;892:	// build into a temp buffer so the defer checks can use
;893:	// the old value
;894:	memset( &newInfo, 0, sizeof( newInfo ) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 1708
ARGI4
ADDRGP4 memset
CALLP4
pop
line 897
;895:
;896:	// isolate the player's name
;897:	v = Info_ValueForKey(configstring, "n");
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $466
ARGP4
ADDRLP4 1728
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1728
INDIRP4
ASGNP4
line 898
;898:	Q_strncpyz( newInfo.name, v, sizeof( newInfo.name ) );
ADDRLP4 0+4
ARGP4
ADDRLP4 1708
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 901
;899:
;900:	// colors
;901:	v = Info_ValueForKey( configstring, "c1" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $469
ARGP4
ADDRLP4 1732
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1732
INDIRP4
ASGNP4
line 902
;902:	CG_ColorFromString( v, newInfo.color1 );
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 0+76
ARGP4
ADDRGP4 CG_ColorFromString
CALLV
pop
line 904
;903:
;904:	v = Info_ValueForKey( configstring, "c2" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $471
ARGP4
ADDRLP4 1736
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1736
INDIRP4
ASGNP4
line 905
;905:	CG_ColorFromString( v, newInfo.color2 );
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 0+88
ARGP4
ADDRGP4 CG_ColorFromString
CALLV
pop
line 908
;906:
;907:	// bot skill
;908:	v = Info_ValueForKey( configstring, "skill" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $473
ARGP4
ADDRLP4 1740
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1740
INDIRP4
ASGNP4
line 909
;909:	newInfo.botSkill = atoi( v );
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 1744
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0+72
ADDRLP4 1744
INDIRI4
ASGNI4
line 912
;910:
;911:	// handicap
;912:	v = Info_ValueForKey( configstring, "hc" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $475
ARGP4
ADDRLP4 1748
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1748
INDIRP4
ASGNP4
line 913
;913:	newInfo.handicap = atoi( v );
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 1752
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0+120
ADDRLP4 1752
INDIRI4
ASGNI4
line 916
;914:
;915:	// wins
;916:	v = Info_ValueForKey( configstring, "w" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $477
ARGP4
ADDRLP4 1756
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1756
INDIRP4
ASGNP4
line 917
;917:	newInfo.wins = atoi( v );
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 1760
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0+124
ADDRLP4 1760
INDIRI4
ASGNI4
line 920
;918:
;919:	// losses
;920:	v = Info_ValueForKey( configstring, "l" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $479
ARGP4
ADDRLP4 1764
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1764
INDIRP4
ASGNP4
line 921
;921:	newInfo.losses = atoi( v );
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 1768
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0+128
ADDRLP4 1768
INDIRI4
ASGNI4
line 924
;922:
;923:	// team
;924:	v = Info_ValueForKey( configstring, "t" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $481
ARGP4
ADDRLP4 1772
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1772
INDIRP4
ASGNP4
line 925
;925:	newInfo.team = atoi( v );
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 1776
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0+68
ADDRLP4 1776
INDIRI4
ASGNI4
line 928
;926:
;927:	// team task
;928:	v = Info_ValueForKey( configstring, "tt" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $483
ARGP4
ADDRLP4 1780
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1780
INDIRP4
ASGNP4
line 929
;929:	newInfo.teamTask = atoi(v);
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 1784
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0+132
ADDRLP4 1784
INDIRI4
ASGNI4
line 932
;930:
;931:	// team leader
;932:	v = Info_ValueForKey( configstring, "tl" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $485
ARGP4
ADDRLP4 1788
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1788
INDIRP4
ASGNP4
line 933
;933:	newInfo.teamLeader = atoi(v);
ADDRLP4 1708
INDIRP4
ARGP4
ADDRLP4 1792
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0+136
ADDRLP4 1792
INDIRI4
ASGNI4
line 935
;934:
;935:	v = Info_ValueForKey( configstring, "g_redteam" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $487
ARGP4
ADDRLP4 1796
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1796
INDIRP4
ASGNP4
line 936
;936:	Q_strncpyz(newInfo.redTeam, v, MAX_TEAMNAME);
ADDRLP4 0+416
ARGP4
ADDRLP4 1708
INDIRP4
ARGP4
CNSTI4 32
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 938
;937:
;938:	v = Info_ValueForKey( configstring, "g_blueteam" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $489
ARGP4
ADDRLP4 1800
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1800
INDIRP4
ASGNP4
line 939
;939:	Q_strncpyz(newInfo.blueTeam, v, MAX_TEAMNAME);
ADDRLP4 0+448
ARGP4
ADDRLP4 1708
INDIRP4
ARGP4
CNSTI4 32
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 942
;940:
;941:	// model
;942:	v = Info_ValueForKey( configstring, "model" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $491
ARGP4
ADDRLP4 1804
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1804
INDIRP4
ASGNP4
line 943
;943:	if ( cg_forceModel.integer ) {
ADDRGP4 cg_forceModel+12
INDIRI4
CNSTI4 0
EQI4 $492
line 949
;944:		// forcemodel makes everyone use a single model
;945:		// to prevent load hitches
;946:		char modelStr[MAX_QPATH];
;947:		char *skin;
;948:
;949:		if( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $495
line 950
;950:			Q_strncpyz( newInfo.modelName, DEFAULT_TEAM_MODEL, sizeof( newInfo.modelName ) );
ADDRLP4 0+160
ARGP4
ADDRGP4 $372
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 951
;951:			Q_strncpyz( newInfo.skinName, "default", sizeof( newInfo.skinName ) );
ADDRLP4 0+224
ARGP4
ADDRGP4 $120
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 952
;952:		} else {
ADDRGP4 $496
JUMPV
LABELV $495
line 953
;953:			trap_Cvar_VariableStringBuffer( "model", modelStr, sizeof( modelStr ) );
ADDRGP4 $491
ARGP4
ADDRLP4 1808
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 954
;954:			if ( ( skin = strchr( modelStr, '/' ) ) == NULL) {
ADDRLP4 1808
ARGP4
CNSTI4 47
ARGI4
ADDRLP4 1876
ADDRGP4 strchr
CALLP4
ASGNP4
ADDRLP4 1872
ADDRLP4 1876
INDIRP4
ASGNP4
ADDRLP4 1876
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $502
line 955
;955:				skin = "default";
ADDRLP4 1872
ADDRGP4 $120
ASGNP4
line 956
;956:			} else {
ADDRGP4 $503
JUMPV
LABELV $502
line 957
;957:				*skin++ = 0;
ADDRLP4 1880
ADDRLP4 1872
INDIRP4
ASGNP4
ADDRLP4 1872
ADDRLP4 1880
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 1880
INDIRP4
CNSTI1 0
ASGNI1
line 958
;958:			}
LABELV $503
line 960
;959:
;960:			Q_strncpyz( newInfo.skinName, skin, sizeof( newInfo.skinName ) );
ADDRLP4 0+224
ARGP4
ADDRLP4 1872
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 961
;961:			Q_strncpyz( newInfo.modelName, modelStr, sizeof( newInfo.modelName ) );
ADDRLP4 0+160
ARGP4
ADDRLP4 1808
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 962
;962:		}
LABELV $496
line 964
;963:
;964:		if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $493
line 966
;965:			// keep skin name
;966:			slash = strchr( v, '/' );
ADDRLP4 1708
INDIRP4
ARGP4
CNSTI4 47
ARGI4
ADDRLP4 1876
ADDRGP4 strchr
CALLP4
ASGNP4
ADDRLP4 1716
ADDRLP4 1876
INDIRP4
ASGNP4
line 967
;967:			if ( slash ) {
ADDRLP4 1716
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $493
line 968
;968:				Q_strncpyz( newInfo.skinName, slash + 1, sizeof( newInfo.skinName ) );
ADDRLP4 0+224
ARGP4
ADDRLP4 1716
INDIRP4
CNSTI4 1
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 969
;969:			}
line 970
;970:		}
line 971
;971:	} else {
ADDRGP4 $493
JUMPV
LABELV $492
line 972
;972:		Q_strncpyz( newInfo.modelName, v, sizeof( newInfo.modelName ) );
ADDRLP4 0+160
ARGP4
ADDRLP4 1708
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 974
;973:
;974:		slash = strchr( newInfo.modelName, '/' );
ADDRLP4 0+160
ARGP4
CNSTI4 47
ARGI4
ADDRLP4 1808
ADDRGP4 strchr
CALLP4
ASGNP4
ADDRLP4 1716
ADDRLP4 1808
INDIRP4
ASGNP4
line 975
;975:		if ( !slash ) {
ADDRLP4 1716
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $518
line 977
;976:			// modelName didn not include a skin name
;977:			Q_strncpyz( newInfo.skinName, "default", sizeof( newInfo.skinName ) );
ADDRLP4 0+224
ARGP4
ADDRGP4 $120
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 978
;978:		} else {
ADDRGP4 $519
JUMPV
LABELV $518
line 979
;979:			Q_strncpyz( newInfo.skinName, slash + 1, sizeof( newInfo.skinName ) );
ADDRLP4 0+224
ARGP4
ADDRLP4 1716
INDIRP4
CNSTI4 1
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 981
;980:			// truncate modelName
;981:			*slash = 0;
ADDRLP4 1716
INDIRP4
CNSTI1 0
ASGNI1
line 982
;982:		}
LABELV $519
line 983
;983:	}
LABELV $493
line 986
;984:
;985:	// head model
;986:	v = Info_ValueForKey( configstring, "hmodel" );
ADDRLP4 1712
INDIRP4
ARGP4
ADDRGP4 $524
ARGP4
ADDRLP4 1808
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1708
ADDRLP4 1808
INDIRP4
ASGNP4
line 987
;987:	if ( cg_forceModel.integer ) {
ADDRGP4 cg_forceModel+12
INDIRI4
CNSTI4 0
EQI4 $525
line 993
;988:		// forcemodel makes everyone use a single model
;989:		// to prevent load hitches
;990:		char modelStr[MAX_QPATH];
;991:		char *skin;
;992:
;993:		if( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $528
line 994
;994:			Q_strncpyz( newInfo.headModelName, DEFAULT_TEAM_MODEL, sizeof( newInfo.headModelName ) );
ADDRLP4 0+288
ARGP4
ADDRGP4 $372
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 995
;995:			Q_strncpyz( newInfo.headSkinName, "default", sizeof( newInfo.headSkinName ) );
ADDRLP4 0+352
ARGP4
ADDRGP4 $120
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 996
;996:		} else {
ADDRGP4 $529
JUMPV
LABELV $528
line 997
;997:			trap_Cvar_VariableStringBuffer( "headmodel", modelStr, sizeof( modelStr ) );
ADDRGP4 $535
ARGP4
ADDRLP4 1812
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 998
;998:			if ( ( skin = strchr( modelStr, '/' ) ) == NULL) {
ADDRLP4 1812
ARGP4
CNSTI4 47
ARGI4
ADDRLP4 1880
ADDRGP4 strchr
CALLP4
ASGNP4
ADDRLP4 1876
ADDRLP4 1880
INDIRP4
ASGNP4
ADDRLP4 1880
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $536
line 999
;999:				skin = "default";
ADDRLP4 1876
ADDRGP4 $120
ASGNP4
line 1000
;1000:			} else {
ADDRGP4 $537
JUMPV
LABELV $536
line 1001
;1001:				*skin++ = 0;
ADDRLP4 1884
ADDRLP4 1876
INDIRP4
ASGNP4
ADDRLP4 1876
ADDRLP4 1884
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 1884
INDIRP4
CNSTI1 0
ASGNI1
line 1002
;1002:			}
LABELV $537
line 1004
;1003:
;1004:			Q_strncpyz( newInfo.headSkinName, skin, sizeof( newInfo.headSkinName ) );
ADDRLP4 0+352
ARGP4
ADDRLP4 1876
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1005
;1005:			Q_strncpyz( newInfo.headModelName, modelStr, sizeof( newInfo.headModelName ) );
ADDRLP4 0+288
ARGP4
ADDRLP4 1812
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1006
;1006:		}
LABELV $529
line 1008
;1007:
;1008:		if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $526
line 1010
;1009:			// keep skin name
;1010:			slash = strchr( v, '/' );
ADDRLP4 1708
INDIRP4
ARGP4
CNSTI4 47
ARGI4
ADDRLP4 1880
ADDRGP4 strchr
CALLP4
ASGNP4
ADDRLP4 1716
ADDRLP4 1880
INDIRP4
ASGNP4
line 1011
;1011:			if ( slash ) {
ADDRLP4 1716
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $526
line 1012
;1012:				Q_strncpyz( newInfo.headSkinName, slash + 1, sizeof( newInfo.headSkinName ) );
ADDRLP4 0+352
ARGP4
ADDRLP4 1716
INDIRP4
CNSTI4 1
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1013
;1013:			}
line 1014
;1014:		}
line 1015
;1015:	} else {
ADDRGP4 $526
JUMPV
LABELV $525
line 1016
;1016:		Q_strncpyz( newInfo.headModelName, v, sizeof( newInfo.headModelName ) );
ADDRLP4 0+288
ARGP4
ADDRLP4 1708
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1018
;1017:
;1018:		slash = strchr( newInfo.headModelName, '/' );
ADDRLP4 0+288
ARGP4
CNSTI4 47
ARGI4
ADDRLP4 1812
ADDRGP4 strchr
CALLP4
ASGNP4
ADDRLP4 1716
ADDRLP4 1812
INDIRP4
ASGNP4
line 1019
;1019:		if ( !slash ) {
ADDRLP4 1716
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $552
line 1021
;1020:			// modelName didn not include a skin name
;1021:			Q_strncpyz( newInfo.headSkinName, "default", sizeof( newInfo.headSkinName ) );
ADDRLP4 0+352
ARGP4
ADDRGP4 $120
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1022
;1022:		} else {
ADDRGP4 $553
JUMPV
LABELV $552
line 1023
;1023:			Q_strncpyz( newInfo.headSkinName, slash + 1, sizeof( newInfo.headSkinName ) );
ADDRLP4 0+352
ARGP4
ADDRLP4 1716
INDIRP4
CNSTI4 1
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1025
;1024:			// truncate modelName
;1025:			*slash = 0;
ADDRLP4 1716
INDIRP4
CNSTI1 0
ASGNI1
line 1026
;1026:		}
LABELV $553
line 1027
;1027:	}
LABELV $526
line 1031
;1028:
;1029:	// scan for an existing clientinfo that matches this modelname
;1030:	// so we can avoid loading checks if possible
;1031:	if ( !CG_ScanForExistingClientInfo( &newInfo ) ) {
ADDRLP4 0
ARGP4
ADDRLP4 1812
ADDRGP4 CG_ScanForExistingClientInfo
CALLI4
ASGNI4
ADDRLP4 1812
INDIRI4
CNSTI4 0
NEI4 $558
line 1034
;1032:		qboolean	forceDefer;
;1033:
;1034:		forceDefer = trap_MemoryRemaining() < 4000000;
ADDRLP4 1824
ADDRGP4 trap_MemoryRemaining
CALLI4
ASGNI4
ADDRLP4 1824
INDIRI4
CNSTI4 4000000
GEI4 $561
ADDRLP4 1820
CNSTI4 1
ASGNI4
ADDRGP4 $562
JUMPV
LABELV $561
ADDRLP4 1820
CNSTI4 0
ASGNI4
LABELV $562
ADDRLP4 1816
ADDRLP4 1820
INDIRI4
ASGNI4
line 1037
;1035:
;1036:		// if we are defering loads, just have it pick the first valid
;1037:		if ( forceDefer || (cg_deferPlayers.integer && !cg_buildScript.integer && !cg.loading ) ) {
ADDRLP4 1828
CNSTI4 0
ASGNI4
ADDRLP4 1816
INDIRI4
ADDRLP4 1828
INDIRI4
NEI4 $568
ADDRGP4 cg_deferPlayers+12
INDIRI4
ADDRLP4 1828
INDIRI4
EQI4 $563
ADDRGP4 cg_buildScript+12
INDIRI4
ADDRLP4 1828
INDIRI4
NEI4 $563
ADDRGP4 cg+20
INDIRI4
ADDRLP4 1828
INDIRI4
NEI4 $563
LABELV $568
line 1039
;1038:			// keep whatever they had if it won't violate team skins
;1039:			CG_SetDeferredClientInfo( &newInfo );
ADDRLP4 0
ARGP4
ADDRGP4 CG_SetDeferredClientInfo
CALLV
pop
line 1041
;1040:			// if we are low on memory, leave them with this model
;1041:			if ( forceDefer ) {
ADDRLP4 1816
INDIRI4
CNSTI4 0
EQI4 $564
line 1042
;1042:				CG_Printf( "Memory is low.  Using deferred model.\n" );
ADDRGP4 $571
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 1043
;1043:				newInfo.deferred = qfalse;
ADDRLP4 0+480
CNSTI4 0
ASGNI4
line 1044
;1044:			}
line 1045
;1045:		} else {
ADDRGP4 $564
JUMPV
LABELV $563
line 1046
;1046:			CG_LoadClientInfo( &newInfo );
ADDRLP4 0
ARGP4
ADDRGP4 CG_LoadClientInfo
CALLV
pop
line 1047
;1047:		}
LABELV $564
line 1048
;1048:	}
LABELV $558
line 1051
;1049:
;1050:	// replace whatever was there with the new one
;1051:	newInfo.infoValid = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 1052
;1052:	*ci = newInfo;
ADDRLP4 1720
INDIRP4
ADDRLP4 0
INDIRB
ASGNB 1708
line 1053
;1053:}
LABELV $462
endproc CG_NewClientInfo 1888 12
export CG_LoadDeferredPlayers
proc CG_LoadDeferredPlayers 20 4
line 1066
;1054:
;1055:
;1056:
;1057:/*
;1058:======================
;1059:CG_LoadDeferredPlayers
;1060:
;1061:Called each frame when a player is dead
;1062:and the scoreboard is up
;1063:so deferred players can be loaded
;1064:======================
;1065:*/
;1066:void CG_LoadDeferredPlayers( void ) {
line 1071
;1067:	int		i;
;1068:	clientInfo_t	*ci;
;1069:
;1070:	// scan for a deferred player to load
;1071:	for ( i = 0, ci = cgs.clientinfo ; i < cgs.maxclients ; i++, ci++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
ADDRGP4 cgs+40972
ASGNP4
ADDRGP4 $577
JUMPV
LABELV $574
line 1072
;1072:		if ( ci->infoValid && ci->deferred ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $580
ADDRLP4 0
INDIRP4
CNSTI4 480
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $580
line 1074
;1073:			// if we are low on memory, leave it deferred
;1074:			if ( trap_MemoryRemaining() < 4000000 ) {
ADDRLP4 16
ADDRGP4 trap_MemoryRemaining
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 4000000
GEI4 $582
line 1075
;1075:				CG_Printf( "Memory is low.  Using deferred model.\n" );
ADDRGP4 $571
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 1076
;1076:				ci->deferred = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 480
ADDP4
CNSTI4 0
ASGNI4
line 1077
;1077:				continue;
ADDRGP4 $575
JUMPV
LABELV $582
line 1079
;1078:			}
;1079:			CG_LoadClientInfo( ci );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_LoadClientInfo
CALLV
pop
line 1081
;1080://			break;
;1081:		}
LABELV $580
line 1082
;1082:	}
LABELV $575
line 1071
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1708
ADDP4
ASGNP4
LABELV $577
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $574
line 1083
;1083:}
LABELV $573
endproc CG_LoadDeferredPlayers 20 4
proc CG_SetLerpFrameAnimation 12 8
line 1101
;1084:
;1085:/*
;1086:=============================================================================
;1087:
;1088:PLAYER ANIMATION
;1089:
;1090:=============================================================================
;1091:*/
;1092:
;1093:
;1094:/*
;1095:===============
;1096:CG_SetLerpFrameAnimation
;1097:
;1098:may include ANIM_TOGGLEBIT
;1099:===============
;1100:*/
;1101:static void CG_SetLerpFrameAnimation( clientInfo_t *ci, lerpFrame_t *lf, int newAnimation ) {
line 1104
;1102:	animation_t	*anim;
;1103:
;1104:	lf->animationNumber = newAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 1105
;1105:	newAnimation &= ~ANIM_TOGGLEBIT;
ADDRFP4 8
ADDRFP4 8
INDIRI4
CNSTI4 -129
BANDI4
ASGNI4
line 1107
;1106:
;1107:	if ( newAnimation < 0 || newAnimation >= MAX_TOTALANIMATIONS ) {
ADDRLP4 4
ADDRFP4 8
INDIRI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $587
ADDRLP4 4
INDIRI4
CNSTI4 37
LTI4 $585
LABELV $587
line 1108
;1108:		CG_Error( "Bad animation number: %i", newAnimation );
ADDRGP4 $588
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 1109
;1109:	}
LABELV $585
line 1111
;1110:
;1111:	anim = &ci->animations[ newAnimation ];
ADDRLP4 0
CNSTI4 28
ADDRFP4 8
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 544
ADDP4
ADDP4
ASGNP4
line 1113
;1112:
;1113:	lf->animation = anim;
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 1114
;1114:	lf->animationTime = lf->frameTime + anim->initialLerp;
ADDRLP4 8
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ADDI4
ASGNI4
line 1116
;1115:
;1116:	if ( cg_debugAnim.integer ) {
ADDRGP4 cg_debugAnim+12
INDIRI4
CNSTI4 0
EQI4 $589
line 1117
;1117:		CG_Printf( "Anim: %i\n", newAnimation );
ADDRGP4 $592
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 1118
;1118:	}
LABELV $589
line 1119
;1119:}
LABELV $584
endproc CG_SetLerpFrameAnimation 12 8
proc CG_RunLerpFrame 44 12
line 1129
;1120:
;1121:/*
;1122:===============
;1123:CG_RunLerpFrame
;1124:
;1125:Sets cg.snap, cg.oldFrame, and cg.backlerp
;1126:cg.time should be between oldFrameTime and frameTime after exit
;1127:===============
;1128:*/
;1129:static void CG_RunLerpFrame( clientInfo_t *ci, lerpFrame_t *lf, int newAnimation, float speedScale ) {
line 1134
;1130:	int			f, numFrames;
;1131:	animation_t	*anim;
;1132:
;1133:	// debugging tool to get no animations
;1134:	if ( cg_animSpeed.integer == 0 ) {
ADDRGP4 cg_animSpeed+12
INDIRI4
CNSTI4 0
NEI4 $594
line 1135
;1135:		lf->oldFrame = lf->frame = lf->backlerp = 0;
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 16
CNSTF4 0
ASGNF4
ADDRLP4 12
INDIRP4
CNSTI4 16
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 20
ADDRLP4 16
INDIRF4
CVFI4 4
ASGNI4
ADDRLP4 12
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
ADDRLP4 12
INDIRP4
ADDRLP4 20
INDIRI4
ASGNI4
line 1136
;1136:		return;
ADDRGP4 $593
JUMPV
LABELV $594
line 1140
;1137:	}
;1138:
;1139:	// see if the animation sequence is switching
;1140:	if ( newAnimation != lf->animationNumber || !lf->animation ) {
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
ADDRFP4 8
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
NEI4 $599
ADDRLP4 12
INDIRP4
CNSTI4 40
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $597
LABELV $599
line 1141
;1141:		CG_SetLerpFrameAnimation( ci, lf, newAnimation );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 CG_SetLerpFrameAnimation
CALLV
pop
line 1142
;1142:	}
LABELV $597
line 1146
;1143:
;1144:	// if we have passed the current frame, move it to
;1145:	// oldFrame and calculate a new frame
;1146:	if ( cg.time >= lf->frameTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
LTI4 $600
line 1147
;1147:		lf->oldFrame = lf->frame;
ADDRLP4 16
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1148
;1148:		lf->oldFrameTime = lf->frameTime;
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 20
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1151
;1149:
;1150:		// get the next frame based on the animation
;1151:		anim = lf->animation;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
INDIRP4
ASGNP4
line 1152
;1152:		if ( !anim->frameLerp ) {
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 0
NEI4 $603
line 1153
;1153:			return;		// shouldn't happen
ADDRGP4 $593
JUMPV
LABELV $603
line 1155
;1154:		}
;1155:		if ( cg.time < lf->animationTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
GEI4 $605
line 1156
;1156:			lf->frameTime = lf->animationTime;		// initial lerp
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 24
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
ASGNI4
line 1157
;1157:		} else {
ADDRGP4 $606
JUMPV
LABELV $605
line 1158
;1158:			lf->frameTime = lf->oldFrameTime + anim->frameLerp;
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 28
CNSTI4 12
ASGNI4
ADDRLP4 24
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
ADDRLP4 24
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ADDI4
ASGNI4
line 1159
;1159:		}
LABELV $606
line 1160
;1160:		f = ( lf->frameTime - lf->animationTime ) / anim->frameLerp;
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 28
CNSTI4 12
ASGNI4
ADDRLP4 4
ADDRLP4 24
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ADDRLP4 24
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
SUBI4
ADDRLP4 0
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
DIVI4
ASGNI4
line 1161
;1161:		f *= speedScale;		// adjust for haste, etc
ADDRLP4 4
ADDRLP4 4
INDIRI4
CVIF4 4
ADDRFP4 12
INDIRF4
MULF4
CVFI4 4
ASGNI4
line 1163
;1162:
;1163:		numFrames = anim->numFrames;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
line 1164
;1164:		if (anim->flipflop) {
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
CNSTI4 0
EQI4 $608
line 1165
;1165:			numFrames *= 2;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
LSHI4
ASGNI4
line 1166
;1166:		}
LABELV $608
line 1167
;1167:		if ( f >= numFrames ) {
ADDRLP4 4
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $610
line 1168
;1168:			f -= numFrames;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 8
INDIRI4
SUBI4
ASGNI4
line 1169
;1169:			if ( anim->loopFrames ) {
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
EQI4 $612
line 1170
;1170:				f %= anim->loopFrames;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
MODI4
ASGNI4
line 1171
;1171:				f += anim->numFrames - anim->loopFrames;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
SUBI4
ADDI4
ASGNI4
line 1172
;1172:			} else {
ADDRGP4 $613
JUMPV
LABELV $612
line 1173
;1173:				f = numFrames - 1;
ADDRLP4 4
ADDRLP4 8
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1176
;1174:				// the animation is stuck at the end, so it
;1175:				// can immediately transition to another sequence
;1176:				lf->frameTime = cg.time;
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1177
;1177:			}
LABELV $613
line 1178
;1178:		}
LABELV $610
line 1179
;1179:		if ( anim->reversed ) {
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 0
EQI4 $615
line 1180
;1180:			lf->frame = anim->firstFrame + anim->numFrames - 1 - f;
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDI4
CNSTI4 1
SUBI4
ADDRLP4 4
INDIRI4
SUBI4
ASGNI4
line 1181
;1181:		}
ADDRGP4 $616
JUMPV
LABELV $615
line 1182
;1182:		else if (anim->flipflop && f>=anim->numFrames) {
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
CNSTI4 0
EQI4 $617
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
LTI4 $617
line 1183
;1183:			lf->frame = anim->firstFrame + anim->numFrames - 1 - (f%anim->numFrames);
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRLP4 40
INDIRI4
ADDI4
CNSTI4 1
SUBI4
ADDRLP4 4
INDIRI4
ADDRLP4 40
INDIRI4
MODI4
SUBI4
ASGNI4
line 1184
;1184:		}
ADDRGP4 $618
JUMPV
LABELV $617
line 1185
;1185:		else {
line 1186
;1186:			lf->frame = anim->firstFrame + f;
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDI4
ASGNI4
line 1187
;1187:		}
LABELV $618
LABELV $616
line 1188
;1188:		if ( cg.time > lf->frameTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
LEI4 $619
line 1189
;1189:			lf->frameTime = cg.time;
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1190
;1190:			if ( cg_debugAnim.integer ) {
ADDRGP4 cg_debugAnim+12
INDIRI4
CNSTI4 0
EQI4 $623
line 1191
;1191:				CG_Printf( "Clamp lf->frameTime\n");
ADDRGP4 $626
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 1192
;1192:			}
LABELV $623
line 1193
;1193:		}
LABELV $619
line 1194
;1194:	}
LABELV $600
line 1196
;1195:
;1196:	if ( lf->frameTime > cg.time + 200 ) {
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 200
ADDI4
LEI4 $627
line 1197
;1197:		lf->frameTime = cg.time;
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1198
;1198:	}
LABELV $627
line 1200
;1199:
;1200:	if ( lf->oldFrameTime > cg.time ) {
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
LEI4 $631
line 1201
;1201:		lf->oldFrameTime = cg.time;
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1202
;1202:	}
LABELV $631
line 1204
;1203:	// calculate current lerp value
;1204:	if ( lf->frameTime == lf->oldFrameTime ) {
ADDRLP4 16
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 16
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
NEI4 $635
line 1205
;1205:		lf->backlerp = 0;
ADDRFP4 4
INDIRP4
CNSTI4 16
ADDP4
CNSTF4 0
ASGNF4
line 1206
;1206:	} else {
ADDRGP4 $636
JUMPV
LABELV $635
line 1207
;1207:		lf->backlerp = 1.0 - (float)( cg.time - lf->oldFrameTime ) / ( lf->frameTime - lf->oldFrameTime );
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 24
ADDRLP4 20
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 20
INDIRP4
CNSTI4 16
ADDP4
CNSTF4 1065353216
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 24
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 20
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
SUBI4
CVIF4 4
DIVF4
SUBF4
ASGNF4
line 1208
;1208:	}
LABELV $636
line 1209
;1209:}
LABELV $593
endproc CG_RunLerpFrame 44 12
proc CG_ClearLerpFrame 16 12
line 1217
;1210:
;1211:
;1212:/*
;1213:===============
;1214:CG_ClearLerpFrame
;1215:===============
;1216:*/
;1217:static void CG_ClearLerpFrame( clientInfo_t *ci, lerpFrame_t *lf, int animationNumber ) {
line 1218
;1218:	lf->frameTime = lf->oldFrameTime = cg.time;
ADDRLP4 0
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1219
;1219:	CG_SetLerpFrameAnimation( ci, lf, animationNumber );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 CG_SetLerpFrameAnimation
CALLV
pop
line 1220
;1220:	lf->oldFrame = lf->frame = lf->animation->firstFrame;
ADDRLP4 8
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 8
INDIRP4
CNSTI4 40
ADDP4
INDIRP4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 12
INDIRI4
ASGNI4
ADDRLP4 8
INDIRP4
ADDRLP4 12
INDIRI4
ASGNI4
line 1221
;1221:}
LABELV $638
endproc CG_ClearLerpFrame 16 12
proc CG_PlayerAnimation 20 16
line 1230
;1222:
;1223:
;1224:/*
;1225:===============
;1226:CG_PlayerAnimation
;1227:===============
;1228:*/
;1229:static void CG_PlayerAnimation( centity_t *cent, int *legsOld, int *legs, float *legsBackLerp,
;1230:						int *torsoOld, int *torso, float *torsoBackLerp ) {
line 1235
;1231:	clientInfo_t	*ci;
;1232:	int				clientNum;
;1233:	float			speedScale;
;1234:
;1235:	clientNum = cent->currentState.clientNum;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ASGNI4
line 1237
;1236:
;1237:	if ( cg_noPlayerAnims.integer ) {
ADDRGP4 cg_noPlayerAnims+12
INDIRI4
CNSTI4 0
EQI4 $641
line 1238
;1238:		*legsOld = *legs = *torsoOld = *torso = 0;
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRFP4 20
INDIRP4
ADDRLP4 12
INDIRI4
ASGNI4
ADDRFP4 16
INDIRP4
ADDRLP4 12
INDIRI4
ASGNI4
ADDRFP4 8
INDIRP4
ADDRLP4 12
INDIRI4
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRI4
ASGNI4
line 1239
;1239:		return;
ADDRGP4 $640
JUMPV
LABELV $641
line 1242
;1240:	}
;1241:
;1242:	if ( cent->currentState.powerups & ( 1 << PW_HASTE ) ) {
ADDRFP4 0
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $644
line 1243
;1243:		speedScale = 1.5;
ADDRLP4 4
CNSTF4 1069547520
ASGNF4
line 1244
;1244:	} else {
ADDRGP4 $645
JUMPV
LABELV $644
line 1245
;1245:		speedScale = 1;
ADDRLP4 4
CNSTF4 1065353216
ASGNF4
line 1246
;1246:	}
LABELV $645
line 1248
;1247:
;1248:	ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 0
CNSTI4 1708
ADDRLP4 8
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 1251
;1249:
;1250:	// do the shuffle turn frames locally
;1251:	if ( cent->pe.legs.yawing && ( cent->currentState.legsAnim & ~ANIM_TOGGLEBIT ) == LEGS_IDLE ) {
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 476
ADDP4
INDIRI4
CNSTI4 0
EQI4 $647
ADDRLP4 12
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
CNSTI4 -129
BANDI4
CNSTI4 22
NEI4 $647
line 1252
;1252:		CG_RunLerpFrame( ci, &cent->pe.legs, LEGS_TURN, speedScale );
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 452
ADDP4
ARGP4
CNSTI4 24
ARGI4
ADDRLP4 4
INDIRF4
ARGF4
ADDRGP4 CG_RunLerpFrame
CALLV
pop
line 1253
;1253:	} else {
ADDRGP4 $648
JUMPV
LABELV $647
line 1254
;1254:		CG_RunLerpFrame( ci, &cent->pe.legs, cent->currentState.legsAnim, speedScale );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 452
ADDP4
ARGP4
ADDRLP4 16
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRF4
ARGF4
ADDRGP4 CG_RunLerpFrame
CALLV
pop
line 1255
;1255:	}
LABELV $648
line 1257
;1256:
;1257:	*legsOld = cent->pe.legs.oldFrame;
ADDRFP4 4
INDIRP4
ADDRFP4 0
INDIRP4
CNSTI4 452
ADDP4
INDIRI4
ASGNI4
line 1258
;1258:	*legs = cent->pe.legs.frame;
ADDRFP4 8
INDIRP4
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
INDIRI4
ASGNI4
line 1259
;1259:	*legsBackLerp = cent->pe.legs.backlerp;
ADDRFP4 12
INDIRP4
ADDRFP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRF4
ASGNF4
line 1261
;1260:
;1261:	CG_RunLerpFrame( ci, &cent->pe.torso, cent->currentState.torsoAnim, speedScale );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 500
ADDP4
ARGP4
ADDRLP4 16
INDIRP4
CNSTI4 200
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRF4
ARGF4
ADDRGP4 CG_RunLerpFrame
CALLV
pop
line 1263
;1262:
;1263:	*torsoOld = cent->pe.torso.oldFrame;
ADDRFP4 16
INDIRP4
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
INDIRI4
ASGNI4
line 1264
;1264:	*torso = cent->pe.torso.frame;
ADDRFP4 20
INDIRP4
ADDRFP4 0
INDIRP4
CNSTI4 508
ADDP4
INDIRI4
ASGNI4
line 1265
;1265:	*torsoBackLerp = cent->pe.torso.backlerp;
ADDRFP4 24
INDIRP4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRF4
ASGNF4
line 1266
;1266:}
LABELV $640
endproc CG_PlayerAnimation 20 16
proc CG_SwingAngles 28 8
line 1282
;1267:
;1268:/*
;1269:=============================================================================
;1270:
;1271:PLAYER ANGLES
;1272:
;1273:=============================================================================
;1274:*/
;1275:
;1276:/*
;1277:==================
;1278:CG_SwingAngles
;1279:==================
;1280:*/
;1281:static void CG_SwingAngles( float destination, float swingTolerance, float clampTolerance,
;1282:					float speed, float *angle, qboolean *swinging ) {
line 1287
;1283:	float	swing;
;1284:	float	move;
;1285:	float	scale;
;1286:
;1287:	if ( !*swinging ) {
ADDRFP4 20
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $650
line 1289
;1288:		// see if a swing should be started
;1289:		swing = AngleSubtract( *angle, destination );
ADDRFP4 16
INDIRP4
INDIRF4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 12
ADDRGP4 AngleSubtract
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 12
INDIRF4
ASGNF4
line 1290
;1290:		if ( swing > swingTolerance || swing < -swingTolerance ) {
ADDRLP4 20
ADDRFP4 4
INDIRF4
ASGNF4
ADDRLP4 0
INDIRF4
ADDRLP4 20
INDIRF4
GTF4 $654
ADDRLP4 0
INDIRF4
ADDRLP4 20
INDIRF4
NEGF4
GEF4 $652
LABELV $654
line 1291
;1291:			*swinging = qtrue;
ADDRFP4 20
INDIRP4
CNSTI4 1
ASGNI4
line 1292
;1292:		}
LABELV $652
line 1293
;1293:	}
LABELV $650
line 1295
;1294:
;1295:	if ( !*swinging ) {
ADDRFP4 20
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $655
line 1296
;1296:		return;
ADDRGP4 $649
JUMPV
LABELV $655
line 1301
;1297:	}
;1298:	
;1299:	// modify the speed depending on the delta
;1300:	// so it doesn't seem so linear
;1301:	swing = AngleSubtract( destination, *angle );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 16
INDIRP4
INDIRF4
ARGF4
ADDRLP4 12
ADDRGP4 AngleSubtract
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 12
INDIRF4
ASGNF4
line 1302
;1302:	scale = fabs( swing );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 16
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 4
ADDRLP4 16
INDIRF4
ASGNF4
line 1303
;1303:	if ( scale < swingTolerance * 0.5 ) {
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
ADDRFP4 4
INDIRF4
MULF4
GEF4 $657
line 1304
;1304:		scale = 0.5;
ADDRLP4 4
CNSTF4 1056964608
ASGNF4
line 1305
;1305:	} else if ( scale < swingTolerance ) {
ADDRGP4 $658
JUMPV
LABELV $657
ADDRLP4 4
INDIRF4
ADDRFP4 4
INDIRF4
GEF4 $659
line 1306
;1306:		scale = 1.0;
ADDRLP4 4
CNSTF4 1065353216
ASGNF4
line 1307
;1307:	} else {
ADDRGP4 $660
JUMPV
LABELV $659
line 1308
;1308:		scale = 2.0;
ADDRLP4 4
CNSTF4 1073741824
ASGNF4
line 1309
;1309:	}
LABELV $660
LABELV $658
line 1312
;1310:
;1311:	// swing towards the destination angle
;1312:	if ( swing >= 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
LTF4 $661
line 1313
;1313:		move = cg.frametime * scale * speed;
ADDRLP4 8
ADDRGP4 cg+107600
INDIRI4
CVIF4 4
ADDRLP4 4
INDIRF4
MULF4
ADDRFP4 12
INDIRF4
MULF4
ASGNF4
line 1314
;1314:		if ( move >= swing ) {
ADDRLP4 8
INDIRF4
ADDRLP4 0
INDIRF4
LTF4 $664
line 1315
;1315:			move = swing;
ADDRLP4 8
ADDRLP4 0
INDIRF4
ASGNF4
line 1316
;1316:			*swinging = qfalse;
ADDRFP4 20
INDIRP4
CNSTI4 0
ASGNI4
line 1317
;1317:		}
LABELV $664
line 1318
;1318:		*angle = AngleMod( *angle + move );
ADDRLP4 20
ADDRFP4 16
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
INDIRF4
ADDRLP4 8
INDIRF4
ADDF4
ARGF4
ADDRLP4 24
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 20
INDIRP4
ADDRLP4 24
INDIRF4
ASGNF4
line 1319
;1319:	} else if ( swing < 0 ) {
ADDRGP4 $662
JUMPV
LABELV $661
ADDRLP4 0
INDIRF4
CNSTF4 0
GEF4 $666
line 1320
;1320:		move = cg.frametime * scale * -speed;
ADDRLP4 8
ADDRGP4 cg+107600
INDIRI4
CVIF4 4
ADDRLP4 4
INDIRF4
MULF4
ADDRFP4 12
INDIRF4
NEGF4
MULF4
ASGNF4
line 1321
;1321:		if ( move <= swing ) {
ADDRLP4 8
INDIRF4
ADDRLP4 0
INDIRF4
GTF4 $669
line 1322
;1322:			move = swing;
ADDRLP4 8
ADDRLP4 0
INDIRF4
ASGNF4
line 1323
;1323:			*swinging = qfalse;
ADDRFP4 20
INDIRP4
CNSTI4 0
ASGNI4
line 1324
;1324:		}
LABELV $669
line 1325
;1325:		*angle = AngleMod( *angle + move );
ADDRLP4 20
ADDRFP4 16
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
INDIRF4
ADDRLP4 8
INDIRF4
ADDF4
ARGF4
ADDRLP4 24
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 20
INDIRP4
ADDRLP4 24
INDIRF4
ASGNF4
line 1326
;1326:	}
LABELV $666
LABELV $662
line 1329
;1327:
;1328:	// clamp to no more than tolerance
;1329:	swing = AngleSubtract( destination, *angle );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 16
INDIRP4
INDIRF4
ARGF4
ADDRLP4 20
ADDRGP4 AngleSubtract
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 20
INDIRF4
ASGNF4
line 1330
;1330:	if ( swing > clampTolerance ) {
ADDRLP4 0
INDIRF4
ADDRFP4 8
INDIRF4
LEF4 $671
line 1331
;1331:		*angle = AngleMod( destination - (clampTolerance - 1) );
ADDRFP4 0
INDIRF4
ADDRFP4 8
INDIRF4
CNSTF4 1065353216
SUBF4
SUBF4
ARGF4
ADDRLP4 24
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRFP4 16
INDIRP4
ADDRLP4 24
INDIRF4
ASGNF4
line 1332
;1332:	} else if ( swing < -clampTolerance ) {
ADDRGP4 $672
JUMPV
LABELV $671
ADDRLP4 0
INDIRF4
ADDRFP4 8
INDIRF4
NEGF4
GEF4 $673
line 1333
;1333:		*angle = AngleMod( destination + (clampTolerance - 1) );
ADDRFP4 0
INDIRF4
ADDRFP4 8
INDIRF4
CNSTF4 1065353216
SUBF4
ADDF4
ARGF4
ADDRLP4 24
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRFP4 16
INDIRP4
ADDRLP4 24
INDIRF4
ASGNF4
line 1334
;1334:	}
LABELV $673
LABELV $672
line 1335
;1335:}
LABELV $649
endproc CG_SwingAngles 28 8
proc CG_AddPainTwitch 12 0
line 1342
;1336:
;1337:/*
;1338:=================
;1339:CG_AddPainTwitch
;1340:=================
;1341:*/
;1342:static void CG_AddPainTwitch( centity_t *cent, vec3_t torsoAngles ) {
line 1346
;1343:	int		t;
;1344:	float	f;
;1345:
;1346:	t = cg.time - cent->pe.painTime;
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
SUBI4
ASGNI4
line 1347
;1347:	if ( t >= PAIN_TWITCH_TIME ) {
ADDRLP4 0
INDIRI4
CNSTI4 200
LTI4 $677
line 1348
;1348:		return;
ADDRGP4 $675
JUMPV
LABELV $677
line 1351
;1349:	}
;1350:
;1351:	f = 1.0 - (float)t / PAIN_TWITCH_TIME;
ADDRLP4 4
CNSTF4 1065353216
ADDRLP4 0
INDIRI4
CVIF4 4
CNSTF4 1128792064
DIVF4
SUBF4
ASGNF4
line 1353
;1352:
;1353:	if ( cent->pe.painDirection ) {
ADDRFP4 0
INDIRP4
CNSTI4 600
ADDP4
INDIRI4
CNSTI4 0
EQI4 $679
line 1354
;1354:		torsoAngles[ROLL] += 20 * f;
ADDRLP4 8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRF4
CNSTF4 1101004800
ADDRLP4 4
INDIRF4
MULF4
ADDF4
ASGNF4
line 1355
;1355:	} else {
ADDRGP4 $680
JUMPV
LABELV $679
line 1356
;1356:		torsoAngles[ROLL] -= 20 * f;
ADDRLP4 8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRF4
CNSTF4 1101004800
ADDRLP4 4
INDIRF4
MULF4
SUBF4
ASGNF4
line 1357
;1357:	}
LABELV $680
line 1358
;1358:}
LABELV $675
endproc CG_AddPainTwitch 12 0
data
align 4
LABELV $682
byte 4 0
byte 4 22
byte 4 45
byte 4 -22
byte 4 0
byte 4 22
byte 4 -45
byte 4 -22
code
proc CG_PlayerAngles 148 24
line 1375
;1359:
;1360:
;1361:/*
;1362:===============
;1363:CG_PlayerAngles
;1364:
;1365:Handles seperate torso motion
;1366:
;1367:  legs pivot based on direction of movement
;1368:
;1369:  head always looks exactly at cent->lerpAngles
;1370:
;1371:  if motion < 20 degrees, show in head only
;1372:  if < 45 degrees, also show in torso
;1373:===============
;1374:*/
;1375:static void CG_PlayerAngles( centity_t *cent, vec3_t legs[3], vec3_t torso[3], vec3_t head[3] ) {
line 1384
;1376:	vec3_t		legsAngles, torsoAngles, headAngles;
;1377:	float		dest;
;1378:	static	int	movementOffsets[8] = { 0, 22, 45, -22, 0, 22, -45, -22 };
;1379:	vec3_t		velocity;
;1380:	float		speed;
;1381:	int			dir, clientNum;
;1382:	clientInfo_t	*ci;
;1383:
;1384:	VectorCopy( cent->lerpAngles, headAngles );
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
INDIRB
ASGNB 12
line 1385
;1385:	headAngles[YAW] = AngleMod( headAngles[YAW] );
ADDRLP4 24+4
INDIRF4
ARGF4
ADDRLP4 68
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 24+4
ADDRLP4 68
INDIRF4
ASGNF4
line 1386
;1386:	VectorClear( legsAngles );
ADDRLP4 72
CNSTF4 0
ASGNF4
ADDRLP4 12+8
ADDRLP4 72
INDIRF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 72
INDIRF4
ASGNF4
ADDRLP4 12
ADDRLP4 72
INDIRF4
ASGNF4
line 1387
;1387:	VectorClear( torsoAngles );
ADDRLP4 76
CNSTF4 0
ASGNF4
ADDRLP4 0+8
ADDRLP4 76
INDIRF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 76
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 76
INDIRF4
ASGNF4
line 1392
;1388:
;1389:	// --------- yaw -------------
;1390:
;1391:	// allow yaw to drift a bit
;1392:	if ( ( cent->currentState.legsAnim & ~ANIM_TOGGLEBIT ) != LEGS_IDLE 
ADDRLP4 80
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 84
CNSTI4 -129
ASGNI4
ADDRLP4 80
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
BANDI4
CNSTI4 22
NEI4 $691
ADDRLP4 80
INDIRP4
CNSTI4 200
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
BANDI4
CNSTI4 11
EQI4 $689
LABELV $691
line 1393
;1393:		|| ( cent->currentState.torsoAnim & ~ANIM_TOGGLEBIT ) != TORSO_STAND  ) {
line 1395
;1394:		// if not standing still, always point all in the same direction
;1395:		cent->pe.torso.yawing = qtrue;	// always center
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
CNSTI4 1
ASGNI4
line 1396
;1396:		cent->pe.torso.pitching = qtrue;	// always center
ADDRFP4 0
INDIRP4
CNSTI4 532
ADDP4
CNSTI4 1
ASGNI4
line 1397
;1397:		cent->pe.legs.yawing = qtrue;	// always center
ADDRFP4 0
INDIRP4
CNSTI4 476
ADDP4
CNSTI4 1
ASGNI4
line 1398
;1398:	}
LABELV $689
line 1401
;1399:
;1400:	// adjust legs for movement dir
;1401:	if ( cent->currentState.eFlags & EF_DEAD ) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $692
line 1403
;1402:		// don't let dead bodies twitch
;1403:		dir = 0;
ADDRLP4 52
CNSTI4 0
ASGNI4
line 1404
;1404:	} else {
ADDRGP4 $693
JUMPV
LABELV $692
line 1405
;1405:		dir = cent->currentState.angles2[YAW];
ADDRLP4 52
ADDRFP4 0
INDIRP4
CNSTI4 132
ADDP4
INDIRF4
CVFI4 4
ASGNI4
line 1406
;1406:		if ( dir < 0 || dir > 7 ) {
ADDRLP4 52
INDIRI4
CNSTI4 0
LTI4 $696
ADDRLP4 52
INDIRI4
CNSTI4 7
LEI4 $694
LABELV $696
line 1407
;1407:			CG_Error( "Bad player movement angle" );
ADDRGP4 $697
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 1408
;1408:		}
LABELV $694
line 1409
;1409:	}
LABELV $693
line 1410
;1410:	legsAngles[YAW] = headAngles[YAW] + movementOffsets[ dir ];
ADDRLP4 12+4
ADDRLP4 24+4
INDIRF4
ADDRLP4 52
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $682
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 1411
;1411:	torsoAngles[YAW] = headAngles[YAW] + 0.25 * movementOffsets[ dir ];
ADDRLP4 0+4
ADDRLP4 24+4
INDIRF4
CNSTF4 1048576000
ADDRLP4 52
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $682
ADDP4
INDIRI4
CVIF4 4
MULF4
ADDF4
ASGNF4
line 1414
;1412:
;1413:	// torso
;1414:	CG_SwingAngles( torsoAngles[YAW], 25, 90, cg_swingSpeed.value, &cent->pe.torso.yawAngle, &cent->pe.torso.yawing );
ADDRLP4 0+4
INDIRF4
ARGF4
CNSTF4 1103626240
ARGF4
CNSTF4 1119092736
ARGF4
ADDRGP4 cg_swingSpeed+8
INDIRF4
ARGF4
ADDRLP4 88
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 88
INDIRP4
CNSTI4 520
ADDP4
ARGP4
ADDRLP4 88
INDIRP4
CNSTI4 524
ADDP4
ARGP4
ADDRGP4 CG_SwingAngles
CALLV
pop
line 1415
;1415:	CG_SwingAngles( legsAngles[YAW], 40, 90, cg_swingSpeed.value, &cent->pe.legs.yawAngle, &cent->pe.legs.yawing );
ADDRLP4 12+4
INDIRF4
ARGF4
CNSTF4 1109393408
ARGF4
CNSTF4 1119092736
ARGF4
ADDRGP4 cg_swingSpeed+8
INDIRF4
ARGF4
ADDRLP4 92
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 92
INDIRP4
CNSTI4 472
ADDP4
ARGP4
ADDRLP4 92
INDIRP4
CNSTI4 476
ADDP4
ARGP4
ADDRGP4 CG_SwingAngles
CALLV
pop
line 1417
;1416:
;1417:	torsoAngles[YAW] = cent->pe.torso.yawAngle;
ADDRLP4 0+4
ADDRFP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRF4
ASGNF4
line 1418
;1418:	legsAngles[YAW] = cent->pe.legs.yawAngle;
ADDRLP4 12+4
ADDRFP4 0
INDIRP4
CNSTI4 472
ADDP4
INDIRF4
ASGNF4
line 1424
;1419:
;1420:
;1421:	// --------- pitch -------------
;1422:
;1423:	// only show a fraction of the pitch angle in the torso
;1424:	if ( headAngles[PITCH] > 180 ) {
ADDRLP4 24
INDIRF4
CNSTF4 1127481344
LEF4 $708
line 1425
;1425:		dest = (-360 + headAngles[PITCH]) * 0.75f;
ADDRLP4 60
CNSTF4 1061158912
ADDRLP4 24
INDIRF4
CNSTF4 3283353600
ADDF4
MULF4
ASGNF4
line 1426
;1426:	} else {
ADDRGP4 $709
JUMPV
LABELV $708
line 1427
;1427:		dest = headAngles[PITCH] * 0.75f;
ADDRLP4 60
CNSTF4 1061158912
ADDRLP4 24
INDIRF4
MULF4
ASGNF4
line 1428
;1428:	}
LABELV $709
line 1429
;1429:	CG_SwingAngles( dest, 15, 30, 0.1f, &cent->pe.torso.pitchAngle, &cent->pe.torso.pitching );
ADDRLP4 60
INDIRF4
ARGF4
CNSTF4 1097859072
ARGF4
CNSTF4 1106247680
ARGF4
CNSTF4 1036831949
ARGF4
ADDRLP4 96
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 96
INDIRP4
CNSTI4 528
ADDP4
ARGP4
ADDRLP4 96
INDIRP4
CNSTI4 532
ADDP4
ARGP4
ADDRGP4 CG_SwingAngles
CALLV
pop
line 1430
;1430:	torsoAngles[PITCH] = cent->pe.torso.pitchAngle;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 528
ADDP4
INDIRF4
ASGNF4
line 1433
;1431:
;1432:	//
;1433:	clientNum = cent->currentState.clientNum;
ADDRLP4 36
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ASGNI4
line 1434
;1434:	if ( clientNum >= 0 && clientNum < MAX_CLIENTS ) {
ADDRLP4 36
INDIRI4
CNSTI4 0
LTI4 $710
ADDRLP4 36
INDIRI4
CNSTI4 64
GEI4 $710
line 1435
;1435:		ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 64
CNSTI4 1708
ADDRLP4 36
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 1436
;1436:		if ( ci->fixedtorso ) {
ADDRLP4 64
INDIRP4
CNSTI4 492
ADDP4
INDIRI4
CNSTI4 0
EQI4 $713
line 1437
;1437:			torsoAngles[PITCH] = 0.0f;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1438
;1438:		}
LABELV $713
line 1439
;1439:	}
LABELV $710
line 1445
;1440:
;1441:	// --------- roll -------------
;1442:
;1443:
;1444:	// lean towards the direction of travel
;1445:	VectorCopy( cent->currentState.pos.trDelta, velocity );
ADDRLP4 40
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRB
ASGNB 12
line 1446
;1446:	speed = VectorNormalize( velocity );
ADDRLP4 40
ARGP4
ADDRLP4 104
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 56
ADDRLP4 104
INDIRF4
ASGNF4
line 1447
;1447:	if ( speed ) {
ADDRLP4 56
INDIRF4
CNSTF4 0
EQF4 $715
line 1451
;1448:		vec3_t	axis[3];
;1449:		float	side;
;1450:
;1451:		speed *= 0.05f;
ADDRLP4 56
CNSTF4 1028443341
ADDRLP4 56
INDIRF4
MULF4
ASGNF4
line 1453
;1452:
;1453:		AnglesToAxis( legsAngles, axis );
ADDRLP4 12
ARGP4
ADDRLP4 108
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1454
;1454:		side = speed * DotProduct( velocity, axis[1] );
ADDRLP4 144
ADDRLP4 56
INDIRF4
ADDRLP4 40
INDIRF4
ADDRLP4 108+12
INDIRF4
MULF4
ADDRLP4 40+4
INDIRF4
ADDRLP4 108+12+4
INDIRF4
MULF4
ADDF4
ADDRLP4 40+8
INDIRF4
ADDRLP4 108+12+8
INDIRF4
MULF4
ADDF4
MULF4
ASGNF4
line 1455
;1455:		legsAngles[ROLL] -= side;
ADDRLP4 12+8
ADDRLP4 12+8
INDIRF4
ADDRLP4 144
INDIRF4
SUBF4
ASGNF4
line 1457
;1456:
;1457:		side = speed * DotProduct( velocity, axis[0] );
ADDRLP4 144
ADDRLP4 56
INDIRF4
ADDRLP4 40
INDIRF4
ADDRLP4 108
INDIRF4
MULF4
ADDRLP4 40+4
INDIRF4
ADDRLP4 108+4
INDIRF4
MULF4
ADDF4
ADDRLP4 40+8
INDIRF4
ADDRLP4 108+8
INDIRF4
MULF4
ADDF4
MULF4
ASGNF4
line 1458
;1458:		legsAngles[PITCH] += side;
ADDRLP4 12
ADDRLP4 12
INDIRF4
ADDRLP4 144
INDIRF4
ADDF4
ASGNF4
line 1459
;1459:	}
LABELV $715
line 1462
;1460:
;1461:	//
;1462:	clientNum = cent->currentState.clientNum;
ADDRLP4 36
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ASGNI4
line 1463
;1463:	if ( clientNum >= 0 && clientNum < MAX_CLIENTS ) {
ADDRLP4 36
INDIRI4
CNSTI4 0
LTI4 $729
ADDRLP4 36
INDIRI4
CNSTI4 64
GEI4 $729
line 1464
;1464:		ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 64
CNSTI4 1708
ADDRLP4 36
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 1465
;1465:		if ( ci->fixedlegs ) {
ADDRLP4 64
INDIRP4
CNSTI4 488
ADDP4
INDIRI4
CNSTI4 0
EQI4 $732
line 1466
;1466:			legsAngles[YAW] = torsoAngles[YAW];
ADDRLP4 12+4
ADDRLP4 0+4
INDIRF4
ASGNF4
line 1467
;1467:			legsAngles[PITCH] = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 1468
;1468:			legsAngles[ROLL] = 0.0f;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 1469
;1469:		}
LABELV $732
line 1470
;1470:	}
LABELV $729
line 1473
;1471:
;1472:	// pain twitch
;1473:	CG_AddPainTwitch( cent, torsoAngles );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CG_AddPainTwitch
CALLV
pop
line 1476
;1474:
;1475:	// pull the angles back out of the hierarchial chain
;1476:	AnglesSubtract( headAngles, torsoAngles, headAngles );
ADDRLP4 24
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 AnglesSubtract
CALLV
pop
line 1477
;1477:	AnglesSubtract( torsoAngles, legsAngles, torsoAngles );
ADDRLP4 0
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 AnglesSubtract
CALLV
pop
line 1478
;1478:	AnglesToAxis( legsAngles, legs );
ADDRLP4 12
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1479
;1479:	AnglesToAxis( torsoAngles, torso );
ADDRLP4 0
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1480
;1480:	AnglesToAxis( headAngles, head );
ADDRLP4 24
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1481
;1481:}
LABELV $681
endproc CG_PlayerAngles 148 24
proc CG_HasteTrail 40 48
line 1491
;1482:
;1483:
;1484://==========================================================================
;1485:
;1486:/*
;1487:===============
;1488:CG_HasteTrail
;1489:===============
;1490:*/
;1491:static void CG_HasteTrail( centity_t *cent ) {
line 1496
;1492:	localEntity_t	*smoke;
;1493:	vec3_t			origin;
;1494:	int				anim;
;1495:
;1496:	if ( cent->trailTime > cg.time ) {
ADDRFP4 0
INDIRP4
CNSTI4 436
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
LEI4 $738
line 1497
;1497:		return;
ADDRGP4 $737
JUMPV
LABELV $738
line 1499
;1498:	}
;1499:	anim = cent->pe.legs.animationNumber & ~ANIM_TOGGLEBIT;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRI4
CNSTI4 -129
BANDI4
ASGNI4
line 1500
;1500:	if ( anim != LEGS_RUN && anim != LEGS_BACK ) {
ADDRLP4 12
INDIRI4
CNSTI4 15
EQI4 $741
ADDRLP4 12
INDIRI4
CNSTI4 16
EQI4 $741
line 1501
;1501:		return;
ADDRGP4 $737
JUMPV
LABELV $741
line 1504
;1502:	}
;1503:
;1504:	cent->trailTime += 100;
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 436
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 100
ADDI4
ASGNI4
line 1505
;1505:	if ( cent->trailTime < cg.time ) {
ADDRFP4 0
INDIRP4
CNSTI4 436
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
GEI4 $743
line 1506
;1506:		cent->trailTime = cg.time;
ADDRFP4 0
INDIRP4
CNSTI4 436
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1507
;1507:	}
LABELV $743
line 1509
;1508:
;1509:	VectorCopy( cent->lerpOrigin, origin );
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1510
;1510:	origin[2] -= 16;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1098907648
SUBF4
ASGNF4
line 1512
;1511:
;1512:	smoke = CG_SmokePuff( origin, vec3_origin, 
ADDRLP4 0
ARGP4
ADDRGP4 vec3_origin
ARGP4
CNSTF4 1090519040
ARGF4
ADDRLP4 28
CNSTF4 1065353216
ASGNF4
ADDRLP4 28
INDIRF4
ARGF4
ADDRLP4 28
INDIRF4
ARGF4
ADDRLP4 28
INDIRF4
ARGF4
ADDRLP4 28
INDIRF4
ARGF4
CNSTF4 1140457472
ARGF4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRLP4 32
INDIRI4
ARGI4
ADDRLP4 32
INDIRI4
ARGI4
ADDRGP4 cgs+152340+420
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 CG_SmokePuff
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 36
INDIRP4
ASGNP4
line 1522
;1513:				  8, 
;1514:				  1, 1, 1, 1,
;1515:				  500, 
;1516:				  cg.time,
;1517:				  0,
;1518:				  0,
;1519:				  cgs.media.hastePuffShader );
;1520:
;1521:	// use the optimized local entity add
;1522:	smoke->leType = LE_SCALE_FADE;
ADDRLP4 16
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 7
ASGNI4
line 1523
;1523:}
LABELV $737
endproc CG_HasteTrail 40 48
proc CG_TrailItem 188 12
line 1618
;1524:
;1525:#ifdef MISSIONPACK
;1526:/*
;1527:===============
;1528:CG_BreathPuffs
;1529:===============
;1530:*/
;1531:static void CG_BreathPuffs( centity_t *cent, refEntity_t *head) {
;1532:	clientInfo_t *ci;
;1533:	vec3_t up, origin;
;1534:	int contents;
;1535:
;1536:	ci = &cgs.clientinfo[ cent->currentState.number ];
;1537:
;1538:	if (!cg_enableBreath.integer) {
;1539:		return;
;1540:	}
;1541:	if ( cent->currentState.number == cg.snap->ps.clientNum && !cg.renderingThirdPerson) {
;1542:		return;
;1543:	}
;1544:	if ( cent->currentState.eFlags & EF_DEAD ) {
;1545:		return;
;1546:	}
;1547:	contents = trap_CM_PointContents( head->origin, 0 );
;1548:	if ( contents & ( CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA ) ) {
;1549:		return;
;1550:	}
;1551:	if ( ci->breathPuffTime > cg.time ) {
;1552:		return;
;1553:	}
;1554:
;1555:	VectorSet( up, 0, 0, 8 );
;1556:	VectorMA(head->origin, 8, head->axis[0], origin);
;1557:	VectorMA(origin, -4, head->axis[2], origin);
;1558:	CG_SmokePuff( origin, up, 16, 1, 1, 1, 0.66f, 1500, cg.time, cg.time + 400, LEF_PUFF_DONT_SCALE, cgs.media.shotgunSmokePuffShader );
;1559:	ci->breathPuffTime = cg.time + 2000;
;1560:}
;1561:
;1562:/*
;1563:===============
;1564:CG_DustTrail
;1565:===============
;1566:*/
;1567:static void CG_DustTrail( centity_t *cent ) {
;1568:	int				anim;
;1569:	localEntity_t	*dust;
;1570:	vec3_t end, vel;
;1571:	trace_t tr;
;1572:
;1573:	if (!cg_enableDust.integer)
;1574:		return;
;1575:
;1576:	if ( cent->dustTrailTime > cg.time ) {
;1577:		return;
;1578:	}
;1579:
;1580:	anim = cent->pe.legs.animationNumber & ~ANIM_TOGGLEBIT;
;1581:	if ( anim != LEGS_LANDB && anim != LEGS_LAND ) {
;1582:		return;
;1583:	}
;1584:
;1585:	cent->dustTrailTime += 40;
;1586:	if ( cent->dustTrailTime < cg.time ) {
;1587:		cent->dustTrailTime = cg.time;
;1588:	}
;1589:
;1590:	VectorCopy(cent->currentState.pos.trBase, end);
;1591:	end[2] -= 64;
;1592:	CG_Trace( &tr, cent->currentState.pos.trBase, NULL, NULL, end, cent->currentState.number, MASK_PLAYERSOLID );
;1593:
;1594:	if ( !(tr.surfaceFlags & SURF_DUST) )
;1595:		return;
;1596:
;1597:	VectorCopy( cent->currentState.pos.trBase, end );
;1598:	end[2] -= 16;
;1599:
;1600:	VectorSet(vel, 0, 0, -30);
;1601:	dust = CG_SmokePuff( end, vel,
;1602:				  24,
;1603:				  .8f, .8f, 0.7f, 0.33f,
;1604:				  500,
;1605:				  cg.time,
;1606:				  0,
;1607:				  0,
;1608:				  cgs.media.dustPuffShader );
;1609:}
;1610:
;1611:#endif
;1612:
;1613:/*
;1614:===============
;1615:CG_TrailItem
;1616:===============
;1617:*/
;1618:static void CG_TrailItem( centity_t *cent, qhandle_t hModel ) {
line 1623
;1619:	refEntity_t		ent;
;1620:	vec3_t			angles;
;1621:	vec3_t			axis[3];
;1622:
;1623:	VectorCopy( cent->lerpAngles, angles );
ADDRLP4 140
ADDRFP4 0
INDIRP4
CNSTI4 716
ADDP4
INDIRB
ASGNB 12
line 1624
;1624:	angles[PITCH] = 0;
ADDRLP4 140
CNSTF4 0
ASGNF4
line 1625
;1625:	angles[ROLL] = 0;
ADDRLP4 140+8
CNSTF4 0
ASGNF4
line 1626
;1626:	AnglesToAxis( angles, axis );
ADDRLP4 140
ARGP4
ADDRLP4 152
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1628
;1627:
;1628:	memset( &ent, 0, sizeof( ent ) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1629
;1629:	VectorMA( cent->lerpOrigin, -16, axis[0], ent.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRF4
CNSTF4 3246391296
ADDRLP4 152
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+4
ADDRFP4 0
INDIRP4
CNSTI4 708
ADDP4
INDIRF4
CNSTF4 3246391296
ADDRLP4 152+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+8
ADDRFP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRF4
CNSTF4 3246391296
ADDRLP4 152+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 1630
;1630:	ent.origin[2] += 16;
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 1631
;1631:	angles[YAW] += 90;
ADDRLP4 140+4
ADDRLP4 140+4
INDIRF4
CNSTF4 1119092736
ADDF4
ASGNF4
line 1632
;1632:	AnglesToAxis( angles, ent.axis );
ADDRLP4 140
ARGP4
ADDRLP4 0+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1634
;1633:
;1634:	ent.hModel = hModel;
ADDRLP4 0+8
ADDRFP4 4
INDIRI4
ASGNI4
line 1635
;1635:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1636
;1636:}
LABELV $751
endproc CG_TrailItem 188 12
proc CG_PlayerFlag 356 24
line 1644
;1637:
;1638:
;1639:/*
;1640:===============
;1641:CG_PlayerFlag
;1642:===============
;1643:*/
;1644:static void CG_PlayerFlag( centity_t *cent, qhandle_t hSkin, refEntity_t *torso ) {
line 1653
;1645:	clientInfo_t	*ci;
;1646:	refEntity_t	pole;
;1647:	refEntity_t	flag;
;1648:	vec3_t		angles, dir;
;1649:	int			legsAnim, flagAnim, updateangles;
;1650:	float		angle, d;
;1651:
;1652:	// show the flag pole model
;1653:	memset( &pole, 0, sizeof(pole) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1654
;1654:	pole.hModel = cgs.media.flagPoleModel;
ADDRLP4 0+8
ADDRGP4 cgs+152340+88
INDIRI4
ASGNI4
line 1655
;1655:	VectorCopy( torso->lightingOrigin, pole.lightingOrigin );
ADDRLP4 0+12
ADDRFP4 8
INDIRP4
CNSTI4 12
ADDP4
INDIRB
ASGNB 12
line 1656
;1656:	pole.shadowPlane = torso->shadowPlane;
ADDRLP4 0+24
ADDRFP4 8
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ASGNF4
line 1657
;1657:	pole.renderfx = torso->renderfx;
ADDRLP4 0+4
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
line 1658
;1658:	CG_PositionEntityOnTag( &pole, torso, torso->hModel, "tag_flag" );
ADDRLP4 0
ARGP4
ADDRLP4 328
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 328
INDIRP4
ARGP4
ADDRLP4 328
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 $381
ARGP4
ADDRGP4 CG_PositionEntityOnTag
CALLV
pop
line 1659
;1659:	trap_R_AddRefEntityToScene( &pole );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1662
;1660:
;1661:	// show the flag model
;1662:	memset( &flag, 0, sizeof(flag) );
ADDRLP4 140
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1663
;1663:	flag.hModel = cgs.media.flagFlapModel;
ADDRLP4 140+8
ADDRGP4 cgs+152340+92
INDIRI4
ASGNI4
line 1664
;1664:	flag.customSkin = hSkin;
ADDRLP4 140+108
ADDRFP4 4
INDIRI4
ASGNI4
line 1665
;1665:	VectorCopy( torso->lightingOrigin, flag.lightingOrigin );
ADDRLP4 140+12
ADDRFP4 8
INDIRP4
CNSTI4 12
ADDP4
INDIRB
ASGNB 12
line 1666
;1666:	flag.shadowPlane = torso->shadowPlane;
ADDRLP4 140+24
ADDRFP4 8
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ASGNF4
line 1667
;1667:	flag.renderfx = torso->renderfx;
ADDRLP4 140+4
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
line 1669
;1668:
;1669:	VectorClear(angles);
ADDRLP4 332
CNSTF4 0
ASGNF4
ADDRLP4 280+8
ADDRLP4 332
INDIRF4
ASGNF4
ADDRLP4 280+4
ADDRLP4 332
INDIRF4
ASGNF4
ADDRLP4 280
ADDRLP4 332
INDIRF4
ASGNF4
line 1671
;1670:
;1671:	updateangles = qfalse;
ADDRLP4 312
CNSTI4 0
ASGNI4
line 1672
;1672:	legsAnim = cent->currentState.legsAnim & ~ANIM_TOGGLEBIT;
ADDRLP4 304
ADDRFP4 0
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
CNSTI4 -129
BANDI4
ASGNI4
line 1673
;1673:	if( legsAnim == LEGS_IDLE || legsAnim == LEGS_IDLECR ) {
ADDRLP4 304
INDIRI4
CNSTI4 22
EQI4 $783
ADDRLP4 304
INDIRI4
CNSTI4 23
NEI4 $781
LABELV $783
line 1674
;1674:		flagAnim = FLAG_STAND;
ADDRLP4 320
CNSTI4 35
ASGNI4
line 1675
;1675:	} else if ( legsAnim == LEGS_WALK || legsAnim == LEGS_WALKCR ) {
ADDRGP4 $782
JUMPV
LABELV $781
ADDRLP4 304
INDIRI4
CNSTI4 14
EQI4 $786
ADDRLP4 304
INDIRI4
CNSTI4 13
NEI4 $784
LABELV $786
line 1676
;1676:		flagAnim = FLAG_STAND;
ADDRLP4 320
CNSTI4 35
ASGNI4
line 1677
;1677:		updateangles = qtrue;
ADDRLP4 312
CNSTI4 1
ASGNI4
line 1678
;1678:	} else {
ADDRGP4 $785
JUMPV
LABELV $784
line 1679
;1679:		flagAnim = FLAG_RUN;
ADDRLP4 320
CNSTI4 34
ASGNI4
line 1680
;1680:		updateangles = qtrue;
ADDRLP4 312
CNSTI4 1
ASGNI4
line 1681
;1681:	}
LABELV $785
LABELV $782
line 1683
;1682:
;1683:	if ( updateangles ) {
ADDRLP4 312
INDIRI4
CNSTI4 0
EQI4 $787
line 1685
;1684:
;1685:		VectorCopy( cent->currentState.pos.trDelta, dir );
ADDRLP4 292
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRB
ASGNB 12
line 1687
;1686:		// add gravity
;1687:		dir[2] += 100;
ADDRLP4 292+8
ADDRLP4 292+8
INDIRF4
CNSTF4 1120403456
ADDF4
ASGNF4
line 1688
;1688:		VectorNormalize( dir );
ADDRLP4 292
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 1689
;1689:		d = DotProduct(pole.axis[2], dir);
ADDRLP4 308
ADDRLP4 0+28+24
INDIRF4
ADDRLP4 292
INDIRF4
MULF4
ADDRLP4 0+28+24+4
INDIRF4
ADDRLP4 292+4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+28+24+8
INDIRF4
ADDRLP4 292+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 1691
;1690:		// if there is anough movement orthogonal to the flag pole
;1691:		if (fabs(d) < 0.9) {
ADDRLP4 308
INDIRF4
ARGF4
ADDRLP4 344
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 344
INDIRF4
CNSTF4 1063675494
GEF4 $800
line 1693
;1692:			//
;1693:			d = DotProduct(pole.axis[0], dir);
ADDRLP4 308
ADDRLP4 0+28
INDIRF4
ADDRLP4 292
INDIRF4
MULF4
ADDRLP4 0+28+4
INDIRF4
ADDRLP4 292+4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+28+8
INDIRF4
ADDRLP4 292+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 1694
;1694:			if (d > 1.0f) {
ADDRLP4 308
INDIRF4
CNSTF4 1065353216
LEF4 $809
line 1695
;1695:				d = 1.0f;
ADDRLP4 308
CNSTF4 1065353216
ASGNF4
line 1696
;1696:			}
ADDRGP4 $810
JUMPV
LABELV $809
line 1697
;1697:			else if (d < -1.0f) {
ADDRLP4 308
INDIRF4
CNSTF4 3212836864
GEF4 $811
line 1698
;1698:				d = -1.0f;
ADDRLP4 308
CNSTF4 3212836864
ASGNF4
line 1699
;1699:			}
LABELV $811
LABELV $810
line 1700
;1700:			angle = acos(d);
ADDRLP4 308
INDIRF4
ARGF4
ADDRLP4 348
ADDRGP4 acos
CALLF4
ASGNF4
ADDRLP4 324
ADDRLP4 348
INDIRF4
ASGNF4
line 1702
;1701:
;1702:			d = DotProduct(pole.axis[1], dir);
ADDRLP4 308
ADDRLP4 0+28+12
INDIRF4
ADDRLP4 292
INDIRF4
MULF4
ADDRLP4 0+28+12+4
INDIRF4
ADDRLP4 292+4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+28+12+8
INDIRF4
ADDRLP4 292+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 1703
;1703:			if (d < 0) {
ADDRLP4 308
INDIRF4
CNSTF4 0
GEF4 $823
line 1704
;1704:				angles[YAW] = 360 - angle * 180 / M_PI;
ADDRLP4 280+4
CNSTF4 1135869952
CNSTF4 1127481344
ADDRLP4 324
INDIRF4
MULF4
CNSTF4 1078530011
DIVF4
SUBF4
ASGNF4
line 1705
;1705:			}
ADDRGP4 $824
JUMPV
LABELV $823
line 1706
;1706:			else {
line 1707
;1707:				angles[YAW] = angle * 180 / M_PI;
ADDRLP4 280+4
CNSTF4 1127481344
ADDRLP4 324
INDIRF4
MULF4
CNSTF4 1078530011
DIVF4
ASGNF4
line 1708
;1708:			}
LABELV $824
line 1709
;1709:			if (angles[YAW] < 0)
ADDRLP4 280+4
INDIRF4
CNSTF4 0
GEF4 $827
line 1710
;1710:				angles[YAW] += 360;
ADDRLP4 280+4
ADDRLP4 280+4
INDIRF4
CNSTF4 1135869952
ADDF4
ASGNF4
LABELV $827
line 1711
;1711:			if (angles[YAW] > 360)
ADDRLP4 280+4
INDIRF4
CNSTF4 1135869952
LEF4 $831
line 1712
;1712:				angles[YAW] -= 360;
ADDRLP4 280+4
ADDRLP4 280+4
INDIRF4
CNSTF4 1135869952
SUBF4
ASGNF4
LABELV $831
line 1717
;1713:
;1714:			//vectoangles( cent->currentState.pos.trDelta, tmpangles );
;1715:			//angles[YAW] = tmpangles[YAW] + 45 - cent->pe.torso.yawAngle;
;1716:			// change the yaw angle
;1717:			CG_SwingAngles( angles[YAW], 25, 90, 0.15f, &cent->pe.flag.yawAngle, &cent->pe.flag.yawing );
ADDRLP4 280+4
INDIRF4
ARGF4
CNSTF4 1103626240
ARGF4
CNSTF4 1119092736
ARGF4
CNSTF4 1041865114
ARGF4
ADDRLP4 352
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 352
INDIRP4
CNSTI4 568
ADDP4
ARGP4
ADDRLP4 352
INDIRP4
CNSTI4 572
ADDP4
ARGP4
ADDRGP4 CG_SwingAngles
CALLV
pop
line 1718
;1718:		}
LABELV $800
line 1738
;1719:
;1720:		/*
;1721:		d = DotProduct(pole.axis[2], dir);
;1722:		angle = Q_acos(d);
;1723:
;1724:		d = DotProduct(pole.axis[1], dir);
;1725:		if (d < 0) {
;1726:			angle = 360 - angle * 180 / M_PI;
;1727:		}
;1728:		else {
;1729:			angle = angle * 180 / M_PI;
;1730:		}
;1731:		if (angle > 340 && angle < 20) {
;1732:			flagAnim = FLAG_RUNUP;
;1733:		}
;1734:		if (angle > 160 && angle < 200) {
;1735:			flagAnim = FLAG_RUNDOWN;
;1736:		}
;1737:		*/
;1738:	}
LABELV $787
line 1741
;1739:
;1740:	// set the yaw angle
;1741:	angles[YAW] = cent->pe.flag.yawAngle;
ADDRLP4 280+4
ADDRFP4 0
INDIRP4
CNSTI4 568
ADDP4
INDIRF4
ASGNF4
line 1743
;1742:	// lerp the flag animation frames
;1743:	ci = &cgs.clientinfo[ cent->currentState.clientNum ];
ADDRLP4 316
CNSTI4 1708
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 1744
;1744:	CG_RunLerpFrame( ci, &cent->pe.flag, flagAnim, 1 );
ADDRLP4 316
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 548
ADDP4
ARGP4
ADDRLP4 320
INDIRI4
ARGI4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_RunLerpFrame
CALLV
pop
line 1745
;1745:	flag.oldframe = cent->pe.flag.oldFrame;
ADDRLP4 140+96
ADDRFP4 0
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ASGNI4
line 1746
;1746:	flag.frame = cent->pe.flag.frame;
ADDRLP4 140+80
ADDRFP4 0
INDIRP4
CNSTI4 556
ADDP4
INDIRI4
ASGNI4
line 1747
;1747:	flag.backlerp = cent->pe.flag.backlerp;
ADDRLP4 140+100
ADDRFP4 0
INDIRP4
CNSTI4 564
ADDP4
INDIRF4
ASGNF4
line 1749
;1748:
;1749:	AnglesToAxis( angles, flag.axis );
ADDRLP4 280
ARGP4
ADDRLP4 140+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 1750
;1750:	CG_PositionRotatedEntityOnTag( &flag, &pole, pole.hModel, "tag_flag" );
ADDRLP4 140
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 0+8
INDIRI4
ARGI4
ADDRGP4 $381
ARGP4
ADDRGP4 CG_PositionRotatedEntityOnTag
CALLV
pop
line 1752
;1751:
;1752:	trap_R_AddRefEntityToScene( &flag );
ADDRLP4 140
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1753
;1753:}
LABELV $765
endproc CG_PlayerFlag 356 24
proc CG_PlayerPowerups 16 20
line 1829
;1754:
;1755:
;1756:#ifdef MISSIONPACK // bk001204
;1757:/*
;1758:===============
;1759:CG_PlayerTokens
;1760:===============
;1761:*/
;1762:static void CG_PlayerTokens( centity_t *cent, int renderfx ) {
;1763:	int			tokens, i, j;
;1764:	float		angle;
;1765:	refEntity_t	ent;
;1766:	vec3_t		dir, origin;
;1767:	skulltrail_t *trail;
;1768:	trail = &cg.skulltrails[cent->currentState.number];
;1769:	tokens = cent->currentState.generic1;
;1770:	if ( !tokens ) {
;1771:		trail->numpositions = 0;
;1772:		return;
;1773:	}
;1774:
;1775:	if ( tokens > MAX_SKULLTRAIL ) {
;1776:		tokens = MAX_SKULLTRAIL;
;1777:	}
;1778:
;1779:	// add skulls if there are more than last time
;1780:	for (i = 0; i < tokens - trail->numpositions; i++) {
;1781:		for (j = trail->numpositions; j > 0; j--) {
;1782:			VectorCopy(trail->positions[j-1], trail->positions[j]);
;1783:		}
;1784:		VectorCopy(cent->lerpOrigin, trail->positions[0]);
;1785:	}
;1786:	trail->numpositions = tokens;
;1787:
;1788:	// move all the skulls along the trail
;1789:	VectorCopy(cent->lerpOrigin, origin);
;1790:	for (i = 0; i < trail->numpositions; i++) {
;1791:		VectorSubtract(trail->positions[i], origin, dir);
;1792:		if (VectorNormalize(dir) > 30) {
;1793:			VectorMA(origin, 30, dir, trail->positions[i]);
;1794:		}
;1795:		VectorCopy(trail->positions[i], origin);
;1796:	}
;1797:
;1798:	memset( &ent, 0, sizeof( ent ) );
;1799:	if( cgs.clientinfo[ cent->currentState.clientNum ].team == TEAM_BLUE ) {
;1800:		ent.hModel = cgs.media.redCubeModel;
;1801:	} else {
;1802:		ent.hModel = cgs.media.blueCubeModel;
;1803:	}
;1804:	ent.renderfx = renderfx;
;1805:
;1806:	VectorCopy(cent->lerpOrigin, origin);
;1807:	for (i = 0; i < trail->numpositions; i++) {
;1808:		VectorSubtract(origin, trail->positions[i], ent.axis[0]);
;1809:		ent.axis[0][2] = 0;
;1810:		VectorNormalize(ent.axis[0]);
;1811:		VectorSet(ent.axis[2], 0, 0, 1);
;1812:		CrossProduct(ent.axis[0], ent.axis[2], ent.axis[1]);
;1813:
;1814:		VectorCopy(trail->positions[i], ent.origin);
;1815:		angle = (((cg.time + 500 * MAX_SKULLTRAIL - 500 * i) / 16) & 255) * (M_PI * 2) / 255;
;1816:		ent.origin[2] += sin(angle) * 10;
;1817:		trap_R_AddRefEntityToScene( &ent );
;1818:		VectorCopy(trail->positions[i], origin);
;1819:	}
;1820:}
;1821:#endif
;1822:
;1823:
;1824:/*
;1825:===============
;1826:CG_PlayerPowerups
;1827:===============
;1828:*/
;1829:static void CG_PlayerPowerups( centity_t *cent, refEntity_t *torso ) {
line 1833
;1830:	int		powerups;
;1831:	clientInfo_t	*ci;
;1832:
;1833:	powerups = cent->currentState.powerups;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
ASGNI4
line 1834
;1834:	if ( !powerups ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $844
line 1835
;1835:		return;
ADDRGP4 $843
JUMPV
LABELV $844
line 1839
;1836:	}
;1837:
;1838:	// quad gives a dlight
;1839:	if ( powerups & ( 1 << PW_QUAD ) ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $846
line 1840
;1840:		trap_R_AddLightToScene( cent->lerpOrigin, 200 + (rand()&31), 0.2f, 0.2f, 1 );
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 31
BANDI4
CNSTI4 200
ADDI4
CVIF4 4
ARGF4
ADDRLP4 12
CNSTF4 1045220557
ASGNF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 1841
;1841:	}
LABELV $846
line 1844
;1842:
;1843:	// flight plays a looped sound
;1844:	if ( powerups & ( 1 << PW_FLIGHT ) ) {
ADDRLP4 0
INDIRI4
CNSTI4 64
BANDI4
CNSTI4 0
EQI4 $848
line 1845
;1845:		trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin, cgs.media.flightSound );
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
INDIRI4
ARGI4
ADDRLP4 8
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 vec3_origin
ARGP4
ADDRGP4 cgs+152340+860
INDIRI4
ARGI4
ADDRGP4 trap_S_AddLoopingSound
CALLV
pop
line 1846
;1846:	}
LABELV $848
line 1848
;1847:
;1848:	ci = &cgs.clientinfo[ cent->currentState.clientNum ];
ADDRLP4 4
CNSTI4 1708
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 1850
;1849:	// redflag
;1850:	if ( powerups & ( 1 << PW_REDFLAG ) ) {
ADDRLP4 0
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 0
EQI4 $853
line 1851
;1851:		if (ci->newAnims) {
ADDRLP4 4
INDIRP4
CNSTI4 484
ADDP4
INDIRI4
CNSTI4 0
EQI4 $855
line 1852
;1852:			CG_PlayerFlag( cent, cgs.media.redFlagFlapSkin, torso );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+96
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_PlayerFlag
CALLV
pop
line 1853
;1853:		}
ADDRGP4 $856
JUMPV
LABELV $855
line 1854
;1854:		else {
line 1855
;1855:			CG_TrailItem( cent, cgs.media.redFlagModel );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+36
INDIRI4
ARGI4
ADDRGP4 CG_TrailItem
CALLV
pop
line 1856
;1856:		}
LABELV $856
line 1857
;1857:		trap_R_AddLightToScene( cent->lerpOrigin, 200 + (rand()&31), 1.0, 0.2f, 0.2f );
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 31
BANDI4
CNSTI4 200
ADDI4
CVIF4 4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 12
CNSTF4 1045220557
ASGNF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 1858
;1858:	}
LABELV $853
line 1861
;1859:
;1860:	// blueflag
;1861:	if ( powerups & ( 1 << PW_BLUEFLAG ) ) {
ADDRLP4 0
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $861
line 1862
;1862:		if (ci->newAnims){
ADDRLP4 4
INDIRP4
CNSTI4 484
ADDP4
INDIRI4
CNSTI4 0
EQI4 $863
line 1863
;1863:			CG_PlayerFlag( cent, cgs.media.blueFlagFlapSkin, torso );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+100
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_PlayerFlag
CALLV
pop
line 1864
;1864:		}
ADDRGP4 $864
JUMPV
LABELV $863
line 1865
;1865:		else {
line 1866
;1866:			CG_TrailItem( cent, cgs.media.blueFlagModel );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+40
INDIRI4
ARGI4
ADDRGP4 CG_TrailItem
CALLV
pop
line 1867
;1867:		}
LABELV $864
line 1868
;1868:		trap_R_AddLightToScene( cent->lerpOrigin, 200 + (rand()&31), 0.2f, 0.2f, 1.0 );
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 31
BANDI4
CNSTI4 200
ADDI4
CVIF4 4
ARGF4
ADDRLP4 12
CNSTF4 1045220557
ASGNF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 1869
;1869:	}
LABELV $861
line 1872
;1870:
;1871:	// neutralflag
;1872:	if ( powerups & ( 1 << PW_NEUTRALFLAG ) ) {
ADDRLP4 0
INDIRI4
CNSTI4 512
BANDI4
CNSTI4 0
EQI4 $869
line 1873
;1873:		if (ci->newAnims) {
ADDRLP4 4
INDIRP4
CNSTI4 484
ADDP4
INDIRI4
CNSTI4 0
EQI4 $871
line 1874
;1874:			CG_PlayerFlag( cent, cgs.media.neutralFlagFlapSkin, torso );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+104
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_PlayerFlag
CALLV
pop
line 1875
;1875:		}
ADDRGP4 $872
JUMPV
LABELV $871
line 1876
;1876:		else {
line 1877
;1877:			CG_TrailItem( cent, cgs.media.neutralFlagModel );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+44
INDIRI4
ARGI4
ADDRGP4 CG_TrailItem
CALLV
pop
line 1878
;1878:		}
LABELV $872
line 1879
;1879:		trap_R_AddLightToScene( cent->lerpOrigin, 200 + (rand()&31), 1.0, 1.0, 1.0 );
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 31
BANDI4
CNSTI4 200
ADDI4
CVIF4 4
ARGF4
ADDRLP4 12
CNSTF4 1065353216
ASGNF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 1880
;1880:	}
LABELV $869
line 1883
;1881:
;1882:	// haste leaves smoke trails
;1883:	if ( powerups & ( 1 << PW_HASTE ) ) {
ADDRLP4 0
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $877
line 1884
;1884:		CG_HasteTrail( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_HasteTrail
CALLV
pop
line 1885
;1885:	}
LABELV $877
line 1886
;1886:}
LABELV $843
endproc CG_PlayerPowerups 16 20
proc CG_PlayerFloatSprite 144 12
line 1896
;1887:
;1888:
;1889:/*
;1890:===============
;1891:CG_PlayerFloatSprite
;1892:
;1893:Float a sprite over the player's head
;1894:===============
;1895:*/
;1896:static void CG_PlayerFloatSprite( centity_t *cent, qhandle_t shader ) {
line 1900
;1897:	int				rf;
;1898:	refEntity_t		ent;
;1899:
;1900:	if ( cent->currentState.number == cg.snap->ps.clientNum && !cg.renderingThirdPerson ) {
ADDRFP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $880
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
NEI4 $880
line 1901
;1901:		rf = RF_THIRD_PERSON;		// only show in mirrors
ADDRLP4 140
CNSTI4 2
ASGNI4
line 1902
;1902:	} else {
ADDRGP4 $881
JUMPV
LABELV $880
line 1903
;1903:		rf = 0;
ADDRLP4 140
CNSTI4 0
ASGNI4
line 1904
;1904:	}
LABELV $881
line 1906
;1905:
;1906:	memset( &ent, 0, sizeof( ent ) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1907
;1907:	VectorCopy( cent->lerpOrigin, ent.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 1908
;1908:	ent.origin[2] += 48;
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
CNSTF4 1111490560
ADDF4
ASGNF4
line 1909
;1909:	ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 1910
;1910:	ent.customShader = shader;
ADDRLP4 0+112
ADDRFP4 4
INDIRI4
ASGNI4
line 1911
;1911:	ent.radius = 10;
ADDRLP4 0+132
CNSTF4 1092616192
ASGNF4
line 1912
;1912:	ent.renderfx = rf;
ADDRLP4 0+4
ADDRLP4 140
INDIRI4
ASGNI4
line 1913
;1913:	ent.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 1914
;1914:	ent.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 1915
;1915:	ent.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 1916
;1916:	ent.shaderRGBA[3] = 255;
ADDRLP4 0+116+3
CNSTU1 255
ASGNU1
line 1917
;1917:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 1918
;1918:}
LABELV $879
endproc CG_PlayerFloatSprite 144 12
proc CG_PlayerSprites 40 8
line 1929
;1919:
;1920:
;1921:
;1922:/*
;1923:===============
;1924:CG_PlayerSprites
;1925:
;1926:Float sprites over the player's head
;1927:===============
;1928:*/
;1929:static void CG_PlayerSprites( centity_t *cent ) {
line 1932
;1930:	int		team;
;1931:
;1932:	if ( cent->currentState.eFlags & EF_CONNECTION ) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 8192
BANDI4
CNSTI4 0
EQI4 $898
line 1933
;1933:		CG_PlayerFloatSprite( cent, cgs.media.connectionShader );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+208
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1934
;1934:		return;
ADDRGP4 $897
JUMPV
LABELV $898
line 1937
;1935:	}
;1936:
;1937:	if( !cg_cleanView.integer &&
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $902
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
ADDRLP4 4
INDIRI4
EQI4 $902
line 1938
;1938:		(cent->currentState.eFlags & EF_TALK) ) {
line 1939
;1939:		CG_PlayerFloatSprite( cent, cgs.media.balloonShader );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+204
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1940
;1940:		return;
ADDRGP4 $897
JUMPV
LABELV $902
line 1943
;1941:	}
;1942:
;1943:	if ( !cg_cleanView.integer && ( cent->currentState.eFlags & EF_AWARD_IMPRESSIVE ) ) {
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $907
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 32768
BANDI4
ADDRLP4 8
INDIRI4
EQI4 $907
line 1944
;1944:		CG_PlayerFloatSprite( cent, cgs.media.medalImpressive );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+504
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1945
;1945:		return;
ADDRGP4 $897
JUMPV
LABELV $907
line 1948
;1946:	}
;1947:
;1948:	if ( !cg_cleanView.integer && (cent->currentState.eFlags & EF_AWARD_EXCELLENT ) ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $912
ADDRLP4 16
CNSTI4 8
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ADDRLP4 16
INDIRI4
BANDI4
ADDRLP4 12
INDIRI4
EQI4 $912
line 1949
;1949:		CG_PlayerFloatSprite( cent, cgs.media.medalExcellent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+508
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1950
;1950:		return;
ADDRGP4 $897
JUMPV
LABELV $912
line 1953
;1951:	}
;1952:
;1953:	if ( !cg_cleanView.integer && ( cent->currentState.eFlags & EF_AWARD_GAUNTLET ) ) {
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 20
INDIRI4
NEI4 $917
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 64
BANDI4
ADDRLP4 20
INDIRI4
EQI4 $917
line 1954
;1954:		CG_PlayerFloatSprite( cent, cgs.media.medalGauntlet );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+512
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1955
;1955:		return;
ADDRGP4 $897
JUMPV
LABELV $917
line 1958
;1956:	}
;1957:
;1958:	if ( !cg_cleanView.integer && ( cent->currentState.eFlags & EF_AWARD_DEFEND ) ) {
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 24
INDIRI4
NEI4 $922
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 65536
BANDI4
ADDRLP4 24
INDIRI4
EQI4 $922
line 1959
;1959:		CG_PlayerFloatSprite( cent, cgs.media.medalDefend );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+516
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1960
;1960:		return;
ADDRGP4 $897
JUMPV
LABELV $922
line 1963
;1961:	}
;1962:
;1963:	if ( !cg_cleanView.integer && ( cent->currentState.eFlags & EF_AWARD_ASSIST ) ) {
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $927
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 131072
BANDI4
ADDRLP4 28
INDIRI4
EQI4 $927
line 1964
;1964:		CG_PlayerFloatSprite( cent, cgs.media.medalAssist );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+520
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1965
;1965:		return;
ADDRGP4 $897
JUMPV
LABELV $927
line 1968
;1966:	}
;1967:
;1968:	if ( !cg_cleanView.integer && ( cent->currentState.eFlags & EF_AWARD_CAP ) ) {
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $932
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 2048
BANDI4
ADDRLP4 32
INDIRI4
EQI4 $932
line 1969
;1969:		CG_PlayerFloatSprite( cent, cgs.media.medalCapture );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+524
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1970
;1970:		return;
ADDRGP4 $897
JUMPV
LABELV $932
line 1973
;1971:	}
;1972:
;1973:	team = cgs.clientinfo[ cent->currentState.clientNum ].team;
ADDRLP4 0
CNSTI4 1708
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
ASGNI4
line 1974
;1974:	if ( !(cent->currentState.eFlags & EF_DEAD) && 
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $939
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $939
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $939
line 1976
;1975:		cg.snap->ps.persistant[PERS_TEAM] == team &&
;1976:		cgs.gametype >= GT_TEAM) {
line 1977
;1977:		if( !cg_cleanView.integer && cg_drawFriend.integer ) {
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRGP4 cg_cleanView+12
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $897
ADDRGP4 cg_drawFriend+12
INDIRI4
ADDRLP4 36
INDIRI4
EQI4 $897
line 1978
;1978:			CG_PlayerFloatSprite( cent, cgs.media.friendShader );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cgs+152340+200
INDIRI4
ARGI4
ADDRGP4 CG_PlayerFloatSprite
CALLV
pop
line 1979
;1979:		}
line 1980
;1980:		return;
LABELV $939
line 1982
;1981:	}
;1982:}
LABELV $897
endproc CG_PlayerSprites 40 8
lit
align 4
LABELV $950
byte 4 3245342720
byte 4 3245342720
byte 4 0
align 4
LABELV $951
byte 4 1097859072
byte 4 1097859072
byte 4 1073741824
code
proc CG_PlayerShadow 104 44
line 1994
;1983:
;1984:/*
;1985:===============
;1986:CG_PlayerShadow
;1987:
;1988:Returns the Z component of the surface being shadowed
;1989:
;1990:  should it return a full plane instead of a Z?
;1991:===============
;1992:*/
;1993:#define	SHADOW_DISTANCE		128
;1994:static qboolean CG_PlayerShadow( centity_t *cent, float *shadowPlane ) {
line 1995
;1995:	vec3_t		end, mins = {-15, -15, 0}, maxs = {15, 15, 2};
ADDRLP4 72
ADDRGP4 $950
INDIRB
ASGNB 12
ADDRLP4 84
ADDRGP4 $951
INDIRB
ASGNB 12
line 1999
;1996:	trace_t		trace;
;1997:	float		alpha;
;1998:
;1999:	*shadowPlane = 0;
ADDRFP4 4
INDIRP4
CNSTF4 0
ASGNF4
line 2001
;2000:
;2001:	if ( cg_shadows.integer == 0 ) {
ADDRGP4 cg_shadows+12
INDIRI4
CNSTI4 0
NEI4 $952
line 2002
;2002:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $949
JUMPV
LABELV $952
line 2006
;2003:	}
;2004:
;2005:	// no shadows when invisible
;2006:	if ( cent->currentState.powerups & ( 1 << PW_INVIS ) ) {
ADDRFP4 0
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $955
line 2007
;2007:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $949
JUMPV
LABELV $955
line 2011
;2008:	}
;2009:
;2010:	// send a trace down from the player to the ground
;2011:	VectorCopy( cent->lerpOrigin, end );
ADDRLP4 60
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2012
;2012:	end[2] -= SHADOW_DISTANCE;
ADDRLP4 60+8
ADDRLP4 60+8
INDIRF4
CNSTF4 1124073472
SUBF4
ASGNF4
line 2014
;2013:
;2014:	trap_CM_BoxTrace( &trace, cent->lerpOrigin, end, mins, maxs, 0, MASK_PLAYERSOLID );
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
line 2017
;2015:
;2016:	// no shadow if too high
;2017:	if ( trace.fraction == 1.0 || trace.startsolid || trace.allsolid ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $963
ADDRLP4 96
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 96
INDIRI4
NEI4 $963
ADDRLP4 0
INDIRI4
ADDRLP4 96
INDIRI4
EQI4 $958
LABELV $963
line 2018
;2018:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $949
JUMPV
LABELV $958
line 2021
;2019:	}
;2020:
;2021:	*shadowPlane = trace.endpos[2] + 1;
ADDRFP4 4
INDIRP4
ADDRLP4 0+12+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2023
;2022:
;2023:	if ( cg_shadows.integer != 1 ) {	// no mark for stencil or projection shadows
ADDRGP4 cg_shadows+12
INDIRI4
CNSTI4 1
EQI4 $966
line 2024
;2024:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $949
JUMPV
LABELV $966
line 2028
;2025:	}
;2026:
;2027:	// fade the shadow out with height
;2028:	alpha = 1.0 - trace.fraction;
ADDRLP4 56
CNSTF4 1065353216
ADDRLP4 0+8
INDIRF4
SUBF4
ASGNF4
line 2035
;2029:
;2030:	// bk0101022 - hack / FPE - bogus planes?
;2031:	//assert( DotProduct( trace.plane.normal, trace.plane.normal ) != 0.0f ) 
;2032:
;2033:	// add the mark as a temporary, so it goes directly to the renderer
;2034:	// without taking a spot in the cg_marks array
;2035:	CG_ImpactMark( cgs.media.shadowMarkShader, trace.endpos, trace.plane.normal, 
ADDRGP4 cgs+152340+344
INDIRI4
ARGI4
ADDRLP4 0+12
ARGP4
ADDRLP4 0+24
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 472
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
CNSTF4 1103101952
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 CG_ImpactMark
CALLV
pop
line 2038
;2036:		cent->pe.legs.yawAngle, alpha,alpha,alpha,1, qfalse, 24, qtrue );
;2037:
;2038:	return qtrue;
CNSTI4 1
RETI4
LABELV $949
endproc CG_PlayerShadow 104 44
proc CG_PlayerSplash 192 28
line 2049
;2039:}
;2040:
;2041:
;2042:/*
;2043:===============
;2044:CG_PlayerSplash
;2045:
;2046:Draw a mark at the water surface
;2047:===============
;2048:*/
;2049:static void CG_PlayerSplash( centity_t *cent ) {
line 2055
;2050:	vec3_t		start, end;
;2051:	trace_t		trace;
;2052:	int			contents;
;2053:	polyVert_t	verts[4];
;2054:
;2055:	if ( !cg_shadows.integer ) {
ADDRGP4 cg_shadows+12
INDIRI4
CNSTI4 0
NEI4 $975
line 2056
;2056:		return;
ADDRGP4 $974
JUMPV
LABELV $975
line 2059
;2057:	}
;2058:
;2059:	VectorCopy( cent->lerpOrigin, end );
ADDRLP4 164
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2060
;2060:	end[2] -= 24;
ADDRLP4 164+8
ADDRLP4 164+8
INDIRF4
CNSTF4 1103101952
SUBF4
ASGNF4
line 2064
;2061:
;2062:	// if the feet aren't in liquid, don't make a mark
;2063:	// this won't handle moving water brushes, but they wouldn't draw right anyway...
;2064:	contents = trap_CM_PointContents( end, 0 );
ADDRLP4 164
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 180
ADDRGP4 trap_CM_PointContents
CALLI4
ASGNI4
ADDRLP4 176
ADDRLP4 180
INDIRI4
ASGNI4
line 2065
;2065:	if ( !( contents & ( CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA ) ) ) {
ADDRLP4 176
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
NEI4 $979
line 2066
;2066:		return;
ADDRGP4 $974
JUMPV
LABELV $979
line 2069
;2067:	}
;2068:
;2069:	VectorCopy( cent->lerpOrigin, start );
ADDRLP4 152
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2070
;2070:	start[2] += 32;
ADDRLP4 152+8
ADDRLP4 152+8
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 2073
;2071:
;2072:	// if the head isn't out of liquid, don't make a mark
;2073:	contents = trap_CM_PointContents( start, 0 );
ADDRLP4 152
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 184
ADDRGP4 trap_CM_PointContents
CALLI4
ASGNI4
ADDRLP4 176
ADDRLP4 184
INDIRI4
ASGNI4
line 2074
;2074:	if ( contents & ( CONTENTS_SOLID | CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA ) ) {
ADDRLP4 176
INDIRI4
CNSTI4 57
BANDI4
CNSTI4 0
EQI4 $982
line 2075
;2075:		return;
ADDRGP4 $974
JUMPV
LABELV $982
line 2079
;2076:	}
;2077:
;2078:	// trace down to find the surface
;2079:	trap_CM_BoxTrace( &trace, start, end, NULL, NULL, 0, ( CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA ) );
ADDRLP4 96
ARGP4
ADDRLP4 152
ARGP4
ADDRLP4 164
ARGP4
ADDRLP4 188
CNSTP4 0
ASGNP4
ADDRLP4 188
INDIRP4
ARGP4
ADDRLP4 188
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 56
ARGI4
ADDRGP4 trap_CM_BoxTrace
CALLV
pop
line 2081
;2080:
;2081:	if ( trace.fraction == 1.0 ) {
ADDRLP4 96+8
INDIRF4
CNSTF4 1065353216
NEF4 $984
line 2082
;2082:		return;
ADDRGP4 $974
JUMPV
LABELV $984
line 2086
;2083:	}
;2084:
;2085:	// create a mark polygon
;2086:	VectorCopy( trace.endpos, verts[0].xyz );
ADDRLP4 0
ADDRLP4 96+12
INDIRB
ASGNB 12
line 2087
;2087:	verts[0].xyz[0] -= 32;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 2088
;2088:	verts[0].xyz[1] -= 32;
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 2089
;2089:	verts[0].st[0] = 0;
ADDRLP4 0+12
CNSTF4 0
ASGNF4
line 2090
;2090:	verts[0].st[1] = 0;
ADDRLP4 0+12+4
CNSTF4 0
ASGNF4
line 2091
;2091:	verts[0].modulate[0] = 255;
ADDRLP4 0+20
CNSTU1 255
ASGNU1
line 2092
;2092:	verts[0].modulate[1] = 255;
ADDRLP4 0+20+1
CNSTU1 255
ASGNU1
line 2093
;2093:	verts[0].modulate[2] = 255;
ADDRLP4 0+20+2
CNSTU1 255
ASGNU1
line 2094
;2094:	verts[0].modulate[3] = 255;
ADDRLP4 0+20+3
CNSTU1 255
ASGNU1
line 2096
;2095:
;2096:	VectorCopy( trace.endpos, verts[1].xyz );
ADDRLP4 0+24
ADDRLP4 96+12
INDIRB
ASGNB 12
line 2097
;2097:	verts[1].xyz[0] -= 32;
ADDRLP4 0+24
ADDRLP4 0+24
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 2098
;2098:	verts[1].xyz[1] += 32;
ADDRLP4 0+24+4
ADDRLP4 0+24+4
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 2099
;2099:	verts[1].st[0] = 0;
ADDRLP4 0+24+12
CNSTF4 0
ASGNF4
line 2100
;2100:	verts[1].st[1] = 1;
ADDRLP4 0+24+12+4
CNSTF4 1065353216
ASGNF4
line 2101
;2101:	verts[1].modulate[0] = 255;
ADDRLP4 0+24+20
CNSTU1 255
ASGNU1
line 2102
;2102:	verts[1].modulate[1] = 255;
ADDRLP4 0+24+20+1
CNSTU1 255
ASGNU1
line 2103
;2103:	verts[1].modulate[2] = 255;
ADDRLP4 0+24+20+2
CNSTU1 255
ASGNU1
line 2104
;2104:	verts[1].modulate[3] = 255;
ADDRLP4 0+24+20+3
CNSTU1 255
ASGNU1
line 2106
;2105:
;2106:	VectorCopy( trace.endpos, verts[2].xyz );
ADDRLP4 0+48
ADDRLP4 96+12
INDIRB
ASGNB 12
line 2107
;2107:	verts[2].xyz[0] += 32;
ADDRLP4 0+48
ADDRLP4 0+48
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 2108
;2108:	verts[2].xyz[1] += 32;
ADDRLP4 0+48+4
ADDRLP4 0+48+4
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 2109
;2109:	verts[2].st[0] = 1;
ADDRLP4 0+48+12
CNSTF4 1065353216
ASGNF4
line 2110
;2110:	verts[2].st[1] = 1;
ADDRLP4 0+48+12+4
CNSTF4 1065353216
ASGNF4
line 2111
;2111:	verts[2].modulate[0] = 255;
ADDRLP4 0+48+20
CNSTU1 255
ASGNU1
line 2112
;2112:	verts[2].modulate[1] = 255;
ADDRLP4 0+48+20+1
CNSTU1 255
ASGNU1
line 2113
;2113:	verts[2].modulate[2] = 255;
ADDRLP4 0+48+20+2
CNSTU1 255
ASGNU1
line 2114
;2114:	verts[2].modulate[3] = 255;
ADDRLP4 0+48+20+3
CNSTU1 255
ASGNU1
line 2116
;2115:
;2116:	VectorCopy( trace.endpos, verts[3].xyz );
ADDRLP4 0+72
ADDRLP4 96+12
INDIRB
ASGNB 12
line 2117
;2117:	verts[3].xyz[0] += 32;
ADDRLP4 0+72
ADDRLP4 0+72
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 2118
;2118:	verts[3].xyz[1] -= 32;
ADDRLP4 0+72+4
ADDRLP4 0+72+4
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 2119
;2119:	verts[3].st[0] = 1;
ADDRLP4 0+72+12
CNSTF4 1065353216
ASGNF4
line 2120
;2120:	verts[3].st[1] = 0;
ADDRLP4 0+72+12+4
CNSTF4 0
ASGNF4
line 2121
;2121:	verts[3].modulate[0] = 255;
ADDRLP4 0+72+20
CNSTU1 255
ASGNU1
line 2122
;2122:	verts[3].modulate[1] = 255;
ADDRLP4 0+72+20+1
CNSTU1 255
ASGNU1
line 2123
;2123:	verts[3].modulate[2] = 255;
ADDRLP4 0+72+20+2
CNSTU1 255
ASGNU1
line 2124
;2124:	verts[3].modulate[3] = 255;
ADDRLP4 0+72+20+3
CNSTU1 255
ASGNU1
line 2126
;2125:
;2126:	trap_R_AddPolyToScene( cgs.media.wakeMarkShader, 4, verts );
ADDRGP4 cgs+152340+368
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddPolyToScene
CALLV
pop
line 2127
;2127:}
LABELV $974
endproc CG_PlayerSplash 192 28
export CG_AddRefEntityWithPowerups
proc CG_AddRefEntityWithPowerups 0 4
line 2139
;2128:
;2129:
;2130:
;2131:/*
;2132:===============
;2133:CG_AddRefEntityWithPowerups
;2134:
;2135:Adds a piece with modifications or duplications for powerups
;2136:Also called by CG_Missile for quad rockets, but nobody can tell...
;2137:===============
;2138:*/
;2139:void CG_AddRefEntityWithPowerups( refEntity_t *ent, entityState_t *state, int team ) {
line 2141
;2140:
;2141:	if ( state->powerups & ( 1 << PW_INVIS ) ) {
ADDRFP4 4
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $1065
line 2142
;2142:		ent->customShader = cgs.media.invisShader;
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+404
INDIRI4
ASGNI4
line 2143
;2143:		trap_R_AddRefEntityToScene( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 2144
;2144:	} else {
ADDRGP4 $1066
JUMPV
LABELV $1065
line 2154
;2145:		/*
;2146:		if ( state->eFlags & EF_KAMIKAZE ) {
;2147:			if (team == TEAM_BLUE)
;2148:				ent->customShader = cgs.media.blueKamikazeShader;
;2149:			else
;2150:				ent->customShader = cgs.media.redKamikazeShader;
;2151:			trap_R_AddRefEntityToScene( ent );
;2152:		}
;2153:		else {*/
;2154:			trap_R_AddRefEntityToScene( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 2157
;2155:		//}
;2156:
;2157:		if ( state->powerups & ( 1 << PW_QUAD ) )
ADDRFP4 4
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1069
line 2158
;2158:		{
line 2159
;2159:			if (team == TEAM_RED)
ADDRFP4 8
INDIRI4
CNSTI4 1
NEI4 $1071
line 2160
;2160:				ent->customShader = cgs.media.redQuadShader;
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+396
INDIRI4
ASGNI4
ADDRGP4 $1072
JUMPV
LABELV $1071
line 2162
;2161:			else
;2162:				ent->customShader = cgs.media.quadShader;
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+392
INDIRI4
ASGNI4
LABELV $1072
line 2163
;2163:			trap_R_AddRefEntityToScene( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 2164
;2164:		}
LABELV $1069
line 2165
;2165:		if ( state->powerups & ( 1 << PW_REGEN ) ) {
ADDRFP4 4
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
EQI4 $1077
line 2166
;2166:			if ( ( ( cg.time / 100 ) % 10 ) == 1 ) {
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
DIVI4
CNSTI4 10
MODI4
CNSTI4 1
NEI4 $1079
line 2167
;2167:				ent->customShader = cgs.media.regenShader;
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+408
INDIRI4
ASGNI4
line 2168
;2168:				trap_R_AddRefEntityToScene( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 2169
;2169:			}
LABELV $1079
line 2170
;2170:		}
LABELV $1077
line 2171
;2171:		if ( state->powerups & ( 1 << PW_BATTLESUIT ) ) {
ADDRFP4 4
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $1084
line 2172
;2172:			ent->customShader = cgs.media.battleSuitShader;
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+412
INDIRI4
ASGNI4
line 2173
;2173:			trap_R_AddRefEntityToScene( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 2174
;2174:		}
LABELV $1084
line 2175
;2175:	}
LABELV $1066
line 2176
;2176:}
LABELV $1064
endproc CG_AddRefEntityWithPowerups 0 4
export CG_LightVerts
proc CG_LightVerts 88 16
line 2184
;2177:
;2178:/*
;2179:=================
;2180:CG_LightVerts
;2181:=================
;2182:*/
;2183:int CG_LightVerts( vec3_t normal, int numVerts, polyVert_t *verts )
;2184:{
line 2191
;2185:	int				i, j;
;2186:	float			incoming;
;2187:	vec3_t			ambientLight;
;2188:	vec3_t			lightDir;
;2189:	vec3_t			directedLight;
;2190:
;2191:	trap_R_LightForPoint( verts[0].xyz, ambientLight, directedLight, lightDir );
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 trap_R_LightForPoint
CALLI4
pop
line 2193
;2192:
;2193:	for (i = 0; i < numVerts; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1092
JUMPV
LABELV $1089
line 2194
;2194:		incoming = DotProduct (normal, lightDir);
ADDRLP4 48
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
ADDRLP4 48
INDIRP4
INDIRF4
ADDRLP4 24
INDIRF4
MULF4
ADDRLP4 48
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 24+4
INDIRF4
MULF4
ADDF4
ADDRLP4 48
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 24+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2195
;2195:		if ( incoming <= 0 ) {
ADDRLP4 8
INDIRF4
CNSTF4 0
GTF4 $1095
line 2196
;2196:			verts[i].modulate[0] = ambientLight[0];
ADDRLP4 56
ADDRLP4 12
INDIRF4
ASGNF4
ADDRLP4 60
CNSTF4 1325400064
ASGNF4
ADDRLP4 56
INDIRF4
ADDRLP4 60
INDIRF4
LTF4 $1098
ADDRLP4 52
ADDRLP4 56
INDIRF4
ADDRLP4 60
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1099
JUMPV
LABELV $1098
ADDRLP4 52
ADDRLP4 56
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1099
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 20
ADDP4
ADDRLP4 52
INDIRU4
CVUU1 4
ASGNU1
line 2197
;2197:			verts[i].modulate[1] = ambientLight[1];
ADDRLP4 68
ADDRLP4 12+4
INDIRF4
ASGNF4
ADDRLP4 72
CNSTF4 1325400064
ASGNF4
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
LTF4 $1102
ADDRLP4 64
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1103
JUMPV
LABELV $1102
ADDRLP4 64
ADDRLP4 68
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1103
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 21
ADDP4
ADDRLP4 64
INDIRU4
CVUU1 4
ASGNU1
line 2198
;2198:			verts[i].modulate[2] = ambientLight[2];
ADDRLP4 80
ADDRLP4 12+8
INDIRF4
ASGNF4
ADDRLP4 84
CNSTF4 1325400064
ASGNF4
ADDRLP4 80
INDIRF4
ADDRLP4 84
INDIRF4
LTF4 $1106
ADDRLP4 76
ADDRLP4 80
INDIRF4
ADDRLP4 84
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1107
JUMPV
LABELV $1106
ADDRLP4 76
ADDRLP4 80
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1107
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 22
ADDP4
ADDRLP4 76
INDIRU4
CVUU1 4
ASGNU1
line 2199
;2199:			verts[i].modulate[3] = 255;
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 23
ADDP4
CNSTU1 255
ASGNU1
line 2200
;2200:			continue;
ADDRGP4 $1090
JUMPV
LABELV $1095
line 2202
;2201:		} 
;2202:		j = ( ambientLight[0] + incoming * directedLight[0] );
ADDRLP4 0
ADDRLP4 12
INDIRF4
ADDRLP4 8
INDIRF4
ADDRLP4 36
INDIRF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 2203
;2203:		if ( j > 255 ) {
ADDRLP4 0
INDIRI4
CNSTI4 255
LEI4 $1108
line 2204
;2204:			j = 255;
ADDRLP4 0
CNSTI4 255
ASGNI4
line 2205
;2205:		}
LABELV $1108
line 2206
;2206:		verts[i].modulate[0] = j;
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 20
ADDP4
ADDRLP4 0
INDIRI4
CVIU4 4
CVUU1 4
ASGNU1
line 2208
;2207:
;2208:		j = ( ambientLight[1] + incoming * directedLight[1] );
ADDRLP4 0
ADDRLP4 12+4
INDIRF4
ADDRLP4 8
INDIRF4
ADDRLP4 36+4
INDIRF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 2209
;2209:		if ( j > 255 ) {
ADDRLP4 0
INDIRI4
CNSTI4 255
LEI4 $1112
line 2210
;2210:			j = 255;
ADDRLP4 0
CNSTI4 255
ASGNI4
line 2211
;2211:		}
LABELV $1112
line 2212
;2212:		verts[i].modulate[1] = j;
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 21
ADDP4
ADDRLP4 0
INDIRI4
CVIU4 4
CVUU1 4
ASGNU1
line 2214
;2213:
;2214:		j = ( ambientLight[2] + incoming * directedLight[2] );
ADDRLP4 0
ADDRLP4 12+8
INDIRF4
ADDRLP4 8
INDIRF4
ADDRLP4 36+8
INDIRF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 2215
;2215:		if ( j > 255 ) {
ADDRLP4 0
INDIRI4
CNSTI4 255
LEI4 $1116
line 2216
;2216:			j = 255;
ADDRLP4 0
CNSTI4 255
ASGNI4
line 2217
;2217:		}
LABELV $1116
line 2218
;2218:		verts[i].modulate[2] = j;
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 22
ADDP4
ADDRLP4 0
INDIRI4
CVIU4 4
CVUU1 4
ASGNU1
line 2220
;2219:
;2220:		verts[i].modulate[3] = 255;
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
ADDP4
CNSTI4 23
ADDP4
CNSTU1 255
ASGNU1
line 2221
;2221:	}
LABELV $1090
line 2193
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1092
ADDRLP4 4
INDIRI4
ADDRFP4 4
INDIRI4
LTI4 $1089
line 2222
;2222:	return qtrue;
CNSTI4 1
RETI4
LABELV $1088
endproc CG_LightVerts 88 16
export CG_Player
proc CG_Player 448 28
line 2230
;2223:}
;2224:
;2225:/*
;2226:===============
;2227:CG_Player
;2228:===============
;2229:*/
;2230:void CG_Player( centity_t *cent ) {
line 2251
;2231:	clientInfo_t	*ci;
;2232:	refEntity_t		legs;
;2233:	refEntity_t		torso;
;2234:	refEntity_t		head;
;2235:	int				clientNum;
;2236:	int				renderfx;
;2237:	qboolean		shadow;
;2238:	float			shadowPlane;
;2239:#ifdef MISSIONPACK
;2240:	refEntity_t		skull;
;2241:	refEntity_t		powerup;
;2242:	int				t;
;2243:	float			c;
;2244:	float			angle;
;2245:	vec3_t			dir, angles;
;2246:#endif
;2247:
;2248:	// the client number is stored in clientNum.  It can't be derived
;2249:	// from the entity number, because a single client may have
;2250:	// multiple corpses on the level using the same clientinfo
;2251:	clientNum = cent->currentState.clientNum;
ADDRLP4 428
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ASGNI4
line 2252
;2252:	if ( clientNum < 0 || clientNum >= MAX_CLIENTS ) {
ADDRLP4 428
INDIRI4
CNSTI4 0
LTI4 $1121
ADDRLP4 428
INDIRI4
CNSTI4 64
LTI4 $1119
LABELV $1121
line 2253
;2253:		CG_Error( "Bad clientNum on player entity");
ADDRGP4 $1122
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 2254
;2254:	}
LABELV $1119
line 2255
;2255:	ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 280
CNSTI4 1708
ADDRLP4 428
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 2259
;2256:
;2257:	// it is possible to see corpses from disconnected players that may
;2258:	// not have valid clientinfo
;2259:	if ( !ci->infoValid ) {
ADDRLP4 280
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $1124
line 2260
;2260:		return;
ADDRGP4 $1118
JUMPV
LABELV $1124
line 2264
;2261:	}
;2262:
;2263:	// get the player model information
;2264:	renderfx = 0;
ADDRLP4 424
CNSTI4 0
ASGNI4
line 2265
;2265:	if ( cent->currentState.number == cg.snap->ps.clientNum) {
ADDRFP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $1126
line 2266
;2266:		if (!cg.renderingThirdPerson) {
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
NEI4 $1129
line 2267
;2267:			renderfx = RF_THIRD_PERSON;			// only draw in mirrors
ADDRLP4 424
CNSTI4 2
ASGNI4
line 2268
;2268:		} else {
ADDRGP4 $1130
JUMPV
LABELV $1129
line 2269
;2269:			if (cg_cameraMode.integer) {
ADDRGP4 cg_cameraMode+12
INDIRI4
CNSTI4 0
EQI4 $1132
line 2270
;2270:				return;
ADDRGP4 $1118
JUMPV
LABELV $1132
line 2272
;2271:			}
;2272:		}
LABELV $1130
line 2273
;2273:	}
LABELV $1126
line 2276
;2274:
;2275:
;2276:	memset( &legs, 0, sizeof(legs) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2277
;2277:	memset( &torso, 0, sizeof(torso) );
ADDRLP4 140
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2278
;2278:	memset( &head, 0, sizeof(head) );
ADDRLP4 284
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2281
;2279:
;2280:	// get the rotation information
;2281:	CG_PlayerAngles( cent, legs.axis, torso.axis, head.axis );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+28
ARGP4
ADDRLP4 140+28
ARGP4
ADDRLP4 284+28
ARGP4
ADDRGP4 CG_PlayerAngles
CALLV
pop
line 2284
;2282:	
;2283:	// get the animation state (after rotation, to allow feet shuffle)
;2284:	CG_PlayerAnimation( cent, &legs.oldframe, &legs.frame, &legs.backlerp,
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+96
ARGP4
ADDRLP4 0+80
ARGP4
ADDRLP4 0+100
ARGP4
ADDRLP4 140+96
ARGP4
ADDRLP4 140+80
ARGP4
ADDRLP4 140+100
ARGP4
ADDRGP4 CG_PlayerAnimation
CALLV
pop
line 2288
;2285:		 &torso.oldframe, &torso.frame, &torso.backlerp );
;2286:
;2287:	// add the talk baloon or disconnect icon
;2288:	CG_PlayerSprites( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_PlayerSprites
CALLV
pop
line 2291
;2289:
;2290:	// add the shadow
;2291:	shadow = CG_PlayerShadow( cent, &shadowPlane );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 432
ARGP4
ADDRLP4 444
ADDRGP4 CG_PlayerShadow
CALLI4
ASGNI4
ADDRLP4 436
ADDRLP4 444
INDIRI4
ASGNI4
line 2294
;2292:
;2293:	// add a water splash if partially in and out of water
;2294:	CG_PlayerSplash( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_PlayerSplash
CALLV
pop
line 2296
;2295:
;2296:	if ( cg_shadows.integer == 3 && shadow ) {
ADDRGP4 cg_shadows+12
INDIRI4
CNSTI4 3
NEI4 $1144
ADDRLP4 436
INDIRI4
CNSTI4 0
EQI4 $1144
line 2297
;2297:		renderfx |= RF_SHADOW_PLANE;
ADDRLP4 424
ADDRLP4 424
INDIRI4
CNSTI4 256
BORI4
ASGNI4
line 2298
;2298:	}
LABELV $1144
line 2299
;2299:	renderfx |= RF_LIGHTING_ORIGIN;			// use the same origin for all
ADDRLP4 424
ADDRLP4 424
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 2308
;2300:#ifdef MISSIONPACK
;2301:	if( cgs.gametype == GT_HARVESTER ) {
;2302:		CG_PlayerTokens( cent, renderfx );
;2303:	}
;2304:#endif
;2305:	//
;2306:	// add the legs
;2307:	//
;2308:	legs.hModel = ci->legsModel;
ADDRLP4 0+8
ADDRLP4 280
INDIRP4
CNSTI4 516
ADDP4
INDIRI4
ASGNI4
line 2309
;2309:	legs.customSkin = ci->legsSkin;
ADDRLP4 0+108
ADDRLP4 280
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ASGNI4
line 2311
;2310:
;2311:	VectorCopy( cent->lerpOrigin, legs.origin );
ADDRLP4 0+68
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2313
;2312:
;2313:	VectorCopy( cent->lerpOrigin, legs.lightingOrigin );
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2314
;2314:	legs.shadowPlane = shadowPlane;
ADDRLP4 0+24
ADDRLP4 432
INDIRF4
ASGNF4
line 2315
;2315:	legs.renderfx = renderfx;
ADDRLP4 0+4
ADDRLP4 424
INDIRI4
ASGNI4
line 2316
;2316:	VectorCopy (legs.origin, legs.oldorigin);	// don't positionally lerp at all
ADDRLP4 0+84
ADDRLP4 0+68
INDIRB
ASGNB 12
line 2318
;2317:
;2318:	CG_AddRefEntityWithPowerups( &legs, &cent->currentState, ci->team );
ADDRLP4 0
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_AddRefEntityWithPowerups
CALLV
pop
line 2321
;2319:
;2320:	// if the model failed, allow the default nullmodel to be displayed
;2321:	if (!legs.hModel) {
ADDRLP4 0+8
INDIRI4
CNSTI4 0
NEI4 $1155
line 2322
;2322:		return;
ADDRGP4 $1118
JUMPV
LABELV $1155
line 2328
;2323:	}
;2324:
;2325:	//
;2326:	// add the torso
;2327:	//
;2328:	torso.hModel = ci->torsoModel;
ADDRLP4 140+8
ADDRLP4 280
INDIRP4
CNSTI4 524
ADDP4
INDIRI4
ASGNI4
line 2329
;2329:	if (!torso.hModel) {
ADDRLP4 140+8
INDIRI4
CNSTI4 0
NEI4 $1159
line 2330
;2330:		return;
ADDRGP4 $1118
JUMPV
LABELV $1159
line 2333
;2331:	}
;2332:
;2333:	torso.customSkin = ci->torsoSkin;
ADDRLP4 140+108
ADDRLP4 280
INDIRP4
CNSTI4 528
ADDP4
INDIRI4
ASGNI4
line 2335
;2334:
;2335:	VectorCopy( cent->lerpOrigin, torso.lightingOrigin );
ADDRLP4 140+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2337
;2336:
;2337:	CG_PositionRotatedEntityOnTag( &torso, &legs, ci->legsModel, "tag_torso");
ADDRLP4 140
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 280
INDIRP4
CNSTI4 516
ADDP4
INDIRI4
ARGI4
ADDRGP4 $1164
ARGP4
ADDRGP4 CG_PositionRotatedEntityOnTag
CALLV
pop
line 2339
;2338:
;2339:	torso.shadowPlane = shadowPlane;
ADDRLP4 140+24
ADDRLP4 432
INDIRF4
ASGNF4
line 2340
;2340:	torso.renderfx = renderfx;
ADDRLP4 140+4
ADDRLP4 424
INDIRI4
ASGNI4
line 2342
;2341:
;2342:	CG_AddRefEntityWithPowerups( &torso, &cent->currentState, ci->team );
ADDRLP4 140
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_AddRefEntityWithPowerups
CALLV
pop
line 2551
;2343:
;2344:#ifdef MISSIONPACK
;2345:	if ( cent->currentState.eFlags & EF_KAMIKAZE ) {
;2346:
;2347:		memset( &skull, 0, sizeof(skull) );
;2348:
;2349:		VectorCopy( cent->lerpOrigin, skull.lightingOrigin );
;2350:		skull.shadowPlane = shadowPlane;
;2351:		skull.renderfx = renderfx;
;2352:
;2353:		if ( cent->currentState.eFlags & EF_DEAD ) {
;2354:			// one skull bobbing above the dead body
;2355:			angle = ((cg.time / 7) & 255) * (M_PI * 2) / 255;
;2356:			if (angle > M_PI * 2)
;2357:				angle -= (float)M_PI * 2;
;2358:			dir[0] = sin(angle) * 20;
;2359:			dir[1] = cos(angle) * 20;
;2360:			angle = ((cg.time / 4) & 255) * (M_PI * 2) / 255;
;2361:			dir[2] = 15 + sin(angle) * 8;
;2362:			VectorAdd(torso.origin, dir, skull.origin);
;2363:			
;2364:			dir[2] = 0;
;2365:			VectorCopy(dir, skull.axis[1]);
;2366:			VectorNormalize(skull.axis[1]);
;2367:			VectorSet(skull.axis[2], 0, 0, 1);
;2368:			CrossProduct(skull.axis[1], skull.axis[2], skull.axis[0]);
;2369:
;2370:			skull.hModel = cgs.media.kamikazeHeadModel;
;2371:			trap_R_AddRefEntityToScene( &skull );
;2372:			skull.hModel = cgs.media.kamikazeHeadTrail;
;2373:			trap_R_AddRefEntityToScene( &skull );
;2374:		}
;2375:		else {
;2376:			// three skulls spinning around the player
;2377:			angle = ((cg.time / 4) & 255) * (M_PI * 2) / 255;
;2378:			dir[0] = cos(angle) * 20;
;2379:			dir[1] = sin(angle) * 20;
;2380:			dir[2] = cos(angle) * 20;
;2381:			VectorAdd(torso.origin, dir, skull.origin);
;2382:
;2383:			angles[0] = sin(angle) * 30;
;2384:			angles[1] = (angle * 180 / M_PI) + 90;
;2385:			if (angles[1] > 360)
;2386:				angles[1] -= 360;
;2387:			angles[2] = 0;
;2388:			AnglesToAxis( angles, skull.axis );
;2389:
;2390:			/*
;2391:			dir[2] = 0;
;2392:			VectorInverse(dir);
;2393:			VectorCopy(dir, skull.axis[1]);
;2394:			VectorNormalize(skull.axis[1]);
;2395:			VectorSet(skull.axis[2], 0, 0, 1);
;2396:			CrossProduct(skull.axis[1], skull.axis[2], skull.axis[0]);
;2397:			*/
;2398:
;2399:			skull.hModel = cgs.media.kamikazeHeadModel;
;2400:			trap_R_AddRefEntityToScene( &skull );
;2401:			// flip the trail because this skull is spinning in the other direction
;2402:			VectorInverse(skull.axis[1]);
;2403:			skull.hModel = cgs.media.kamikazeHeadTrail;
;2404:			trap_R_AddRefEntityToScene( &skull );
;2405:
;2406:			angle = ((cg.time / 4) & 255) * (M_PI * 2) / 255 + M_PI;
;2407:			if (angle > M_PI * 2)
;2408:				angle -= (float)M_PI * 2;
;2409:			dir[0] = sin(angle) * 20;
;2410:			dir[1] = cos(angle) * 20;
;2411:			dir[2] = cos(angle) * 20;
;2412:			VectorAdd(torso.origin, dir, skull.origin);
;2413:
;2414:			angles[0] = cos(angle - 0.5 * M_PI) * 30;
;2415:			angles[1] = 360 - (angle * 180 / M_PI);
;2416:			if (angles[1] > 360)
;2417:				angles[1] -= 360;
;2418:			angles[2] = 0;
;2419:			AnglesToAxis( angles, skull.axis );
;2420:
;2421:			/*
;2422:			dir[2] = 0;
;2423:			VectorCopy(dir, skull.axis[1]);
;2424:			VectorNormalize(skull.axis[1]);
;2425:			VectorSet(skull.axis[2], 0, 0, 1);
;2426:			CrossProduct(skull.axis[1], skull.axis[2], skull.axis[0]);
;2427:			*/
;2428:
;2429:			skull.hModel = cgs.media.kamikazeHeadModel;
;2430:			trap_R_AddRefEntityToScene( &skull );
;2431:			skull.hModel = cgs.media.kamikazeHeadTrail;
;2432:			trap_R_AddRefEntityToScene( &skull );
;2433:
;2434:			angle = ((cg.time / 3) & 255) * (M_PI * 2) / 255 + 0.5 * M_PI;
;2435:			if (angle > M_PI * 2)
;2436:				angle -= (float)M_PI * 2;
;2437:			dir[0] = sin(angle) * 20;
;2438:			dir[1] = cos(angle) * 20;
;2439:			dir[2] = 0;
;2440:			VectorAdd(torso.origin, dir, skull.origin);
;2441:			
;2442:			VectorCopy(dir, skull.axis[1]);
;2443:			VectorNormalize(skull.axis[1]);
;2444:			VectorSet(skull.axis[2], 0, 0, 1);
;2445:			CrossProduct(skull.axis[1], skull.axis[2], skull.axis[0]);
;2446:
;2447:			skull.hModel = cgs.media.kamikazeHeadModel;
;2448:			trap_R_AddRefEntityToScene( &skull );
;2449:			skull.hModel = cgs.media.kamikazeHeadTrail;
;2450:			trap_R_AddRefEntityToScene( &skull );
;2451:		}
;2452:	}
;2453:
;2454:	if ( cent->currentState.powerups & ( 1 << PW_GUARD ) ) {
;2455:		memcpy(&powerup, &torso, sizeof(torso));
;2456:		powerup.hModel = cgs.media.guardPowerupModel;
;2457:		powerup.frame = 0;
;2458:		powerup.oldframe = 0;
;2459:		powerup.customSkin = 0;
;2460:		trap_R_AddRefEntityToScene( &powerup );
;2461:	}
;2462:	if ( cent->currentState.powerups & ( 1 << PW_SCOUT ) ) {
;2463:		memcpy(&powerup, &torso, sizeof(torso));
;2464:		powerup.hModel = cgs.media.scoutPowerupModel;
;2465:		powerup.frame = 0;
;2466:		powerup.oldframe = 0;
;2467:		powerup.customSkin = 0;
;2468:		trap_R_AddRefEntityToScene( &powerup );
;2469:	}
;2470:	if ( cent->currentState.powerups & ( 1 << PW_DOUBLER ) ) {
;2471:		memcpy(&powerup, &torso, sizeof(torso));
;2472:		powerup.hModel = cgs.media.doublerPowerupModel;
;2473:		powerup.frame = 0;
;2474:		powerup.oldframe = 0;
;2475:		powerup.customSkin = 0;
;2476:		trap_R_AddRefEntityToScene( &powerup );
;2477:	}
;2478:	if ( cent->currentState.powerups & ( 1 << PW_AMMOREGEN ) ) {
;2479:		memcpy(&powerup, &torso, sizeof(torso));
;2480:		powerup.hModel = cgs.media.ammoRegenPowerupModel;
;2481:		powerup.frame = 0;
;2482:		powerup.oldframe = 0;
;2483:		powerup.customSkin = 0;
;2484:		trap_R_AddRefEntityToScene( &powerup );
;2485:	}
;2486:	if ( cent->currentState.powerups & ( 1 << PW_INVULNERABILITY ) ) {
;2487:		if ( !ci->invulnerabilityStartTime ) {
;2488:			ci->invulnerabilityStartTime = cg.time;
;2489:		}
;2490:		ci->invulnerabilityStopTime = cg.time;
;2491:	}
;2492:	else {
;2493:		ci->invulnerabilityStartTime = 0;
;2494:	}
;2495:	if ( (cent->currentState.powerups & ( 1 << PW_INVULNERABILITY ) ) ||
;2496:		cg.time - ci->invulnerabilityStopTime < 250 ) {
;2497:
;2498:		memcpy(&powerup, &torso, sizeof(torso));
;2499:		powerup.hModel = cgs.media.invulnerabilityPowerupModel;
;2500:		powerup.customSkin = 0;
;2501:		// always draw
;2502:		powerup.renderfx &= ~RF_THIRD_PERSON;
;2503:		VectorCopy(cent->lerpOrigin, powerup.origin);
;2504:
;2505:		if ( cg.time - ci->invulnerabilityStartTime < 250 ) {
;2506:			c = (float) (cg.time - ci->invulnerabilityStartTime) / 250;
;2507:		}
;2508:		else if (cg.time - ci->invulnerabilityStopTime < 250 ) {
;2509:			c = (float) (250 - (cg.time - ci->invulnerabilityStopTime)) / 250;
;2510:		}
;2511:		else {
;2512:			c = 1;
;2513:		}
;2514:		VectorSet( powerup.axis[0], c, 0, 0 );
;2515:		VectorSet( powerup.axis[1], 0, c, 0 );
;2516:		VectorSet( powerup.axis[2], 0, 0, c );
;2517:		trap_R_AddRefEntityToScene( &powerup );
;2518:	}
;2519:
;2520:	t = cg.time - ci->medkitUsageTime;
;2521:	if ( ci->medkitUsageTime && t < 500 ) {
;2522:		memcpy(&powerup, &torso, sizeof(torso));
;2523:		powerup.hModel = cgs.media.medkitUsageModel;
;2524:		powerup.customSkin = 0;
;2525:		// always draw
;2526:		powerup.renderfx &= ~RF_THIRD_PERSON;
;2527:		VectorClear(angles);
;2528:		AnglesToAxis(angles, powerup.axis);
;2529:		VectorCopy(cent->lerpOrigin, powerup.origin);
;2530:		powerup.origin[2] += -24 + (float) t * 80 / 500;
;2531:		if ( t > 400 ) {
;2532:			c = (float) (t - 1000) * 0xff / 100;
;2533:			powerup.shaderRGBA[0] = 0xff - c;
;2534:			powerup.shaderRGBA[1] = 0xff - c;
;2535:			powerup.shaderRGBA[2] = 0xff - c;
;2536:			powerup.shaderRGBA[3] = 0xff - c;
;2537:		}
;2538:		else {
;2539:			powerup.shaderRGBA[0] = 0xff;
;2540:			powerup.shaderRGBA[1] = 0xff;
;2541:			powerup.shaderRGBA[2] = 0xff;
;2542:			powerup.shaderRGBA[3] = 0xff;
;2543:		}
;2544:		trap_R_AddRefEntityToScene( &powerup );
;2545:	}
;2546:#endif // MISSIONPACK
;2547:
;2548:	//
;2549:	// add the head
;2550:	//
;2551:	head.hModel = ci->headModel;
ADDRLP4 284+8
ADDRLP4 280
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
ASGNI4
line 2552
;2552:	if (!head.hModel) {
ADDRLP4 284+8
INDIRI4
CNSTI4 0
NEI4 $1168
line 2553
;2553:		return;
ADDRGP4 $1118
JUMPV
LABELV $1168
line 2555
;2554:	}
;2555:	head.customSkin = ci->headSkin;
ADDRLP4 284+108
ADDRLP4 280
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
ASGNI4
line 2557
;2556:
;2557:	VectorCopy( cent->lerpOrigin, head.lightingOrigin );
ADDRLP4 284+12
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2559
;2558:
;2559:	CG_PositionRotatedEntityOnTag( &head, &torso, ci->torsoModel, "tag_head");
ADDRLP4 284
ARGP4
ADDRLP4 140
ARGP4
ADDRLP4 280
INDIRP4
CNSTI4 524
ADDP4
INDIRI4
ARGI4
ADDRGP4 $1173
ARGP4
ADDRGP4 CG_PositionRotatedEntityOnTag
CALLV
pop
line 2561
;2560:
;2561:	head.shadowPlane = shadowPlane;
ADDRLP4 284+24
ADDRLP4 432
INDIRF4
ASGNF4
line 2562
;2562:	head.renderfx = renderfx;
ADDRLP4 284+4
ADDRLP4 424
INDIRI4
ASGNI4
line 2564
;2563:
;2564:	CG_AddRefEntityWithPowerups( &head, &cent->currentState, ci->team );
ADDRLP4 284
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_AddRefEntityWithPowerups
CALLV
pop
line 2575
;2565:
;2566:#ifdef MISSIONPACK
;2567:	CG_BreathPuffs(cent, &head);
;2568:
;2569:	CG_DustTrail(cent);
;2570:#endif
;2571:
;2572:	//
;2573:	// add the gun / barrel / flash
;2574:	//
;2575:	CG_AddPlayerWeapon( &torso, NULL, cent, ci->team );
ADDRLP4 140
ARGP4
CNSTP4 0
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_AddPlayerWeapon
CALLV
pop
line 2578
;2576:
;2577:	// add powerups floating behind the player
;2578:	CG_PlayerPowerups( cent, &torso );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ARGP4
ADDRGP4 CG_PlayerPowerups
CALLV
pop
line 2579
;2579:}
LABELV $1118
endproc CG_Player 448 28
export CG_ResetPlayerEntity
proc CG_ResetPlayerEntity 40 12
line 2591
;2580:
;2581:
;2582://=====================================================================
;2583:
;2584:/*
;2585:===============
;2586:CG_ResetPlayerEntity
;2587:
;2588:A player just came into view or teleported, so reset all animation info
;2589:===============
;2590:*/
;2591:void CG_ResetPlayerEntity( centity_t *cent ) {
line 2592
;2592:	cent->errorTime = -99999;		// guarantee no error decay added
ADDRFP4 0
INDIRP4
CNSTI4 636
ADDP4
CNSTI4 -99999
ASGNI4
line 2593
;2593:	cent->extrapolated = qfalse;	
ADDRFP4 0
INDIRP4
CNSTI4 664
ADDP4
CNSTI4 0
ASGNI4
line 2595
;2594:
;2595:	CG_ClearLerpFrame( &cgs.clientinfo[ cent->currentState.clientNum ], &cent->pe.legs, cent->currentState.legsAnim );
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
CNSTI4 1708
ADDRLP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 452
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_ClearLerpFrame
CALLV
pop
line 2596
;2596:	CG_ClearLerpFrame( &cgs.clientinfo[ cent->currentState.clientNum ], &cent->pe.torso, cent->currentState.torsoAnim );
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
CNSTI4 1708
ADDRLP4 4
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 500
ADDP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 200
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_ClearLerpFrame
CALLV
pop
line 2598
;2597:
;2598:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.time, cent->lerpOrigin );
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
line 2599
;2599:	BG_EvaluateTrajectory( &cent->currentState.apos, cg.time, cent->lerpAngles );
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
line 2601
;2600:
;2601:	VectorCopy( cent->lerpOrigin, cent->rawOrigin );
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 668
ADDP4
ADDRLP4 16
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 2602
;2602:	VectorCopy( cent->lerpAngles, cent->rawAngles );
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 680
ADDP4
ADDRLP4 20
INDIRP4
CNSTI4 716
ADDP4
INDIRB
ASGNB 12
line 2604
;2603:
;2604:	memset( &cent->pe.legs, 0, sizeof( cent->pe.legs ) );
ADDRFP4 0
INDIRP4
CNSTI4 452
ADDP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 48
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2605
;2605:	cent->pe.legs.yawAngle = cent->rawAngles[YAW];
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
CNSTI4 472
ADDP4
ADDRLP4 24
INDIRP4
CNSTI4 684
ADDP4
INDIRF4
ASGNF4
line 2606
;2606:	cent->pe.legs.yawing = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 476
ADDP4
CNSTI4 0
ASGNI4
line 2607
;2607:	cent->pe.legs.pitchAngle = 0;
ADDRFP4 0
INDIRP4
CNSTI4 480
ADDP4
CNSTF4 0
ASGNF4
line 2608
;2608:	cent->pe.legs.pitching = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 484
ADDP4
CNSTI4 0
ASGNI4
line 2610
;2609:
;2610:	memset( &cent->pe.torso, 0, sizeof( cent->pe.legs ) );
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 48
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2611
;2611:	cent->pe.torso.yawAngle = cent->rawAngles[YAW];
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 520
ADDP4
ADDRLP4 28
INDIRP4
CNSTI4 684
ADDP4
INDIRF4
ASGNF4
line 2612
;2612:	cent->pe.torso.yawing = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 524
ADDP4
CNSTI4 0
ASGNI4
line 2613
;2613:	cent->pe.torso.pitchAngle = cent->rawAngles[PITCH];
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 32
INDIRP4
CNSTI4 528
ADDP4
ADDRLP4 32
INDIRP4
CNSTI4 680
ADDP4
INDIRF4
ASGNF4
line 2614
;2614:	cent->pe.torso.pitching = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 532
ADDP4
CNSTI4 0
ASGNI4
line 2616
;2615:
;2616:	if ( cg_debugPosition.integer ) {
ADDRGP4 cg_debugPosition+12
INDIRI4
CNSTI4 0
EQI4 $1181
line 2617
;2617:		CG_Printf("%i ResetPlayerEntity yaw=%i\n", cent->currentState.number, cent->pe.torso.yawAngle );
ADDRGP4 $1184
ARGP4
ADDRLP4 36
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 36
INDIRP4
INDIRI4
ARGI4
ADDRLP4 36
INDIRP4
CNSTI4 520
ADDP4
INDIRF4
ARGF4
ADDRGP4 CG_Printf
CALLV
pop
line 2618
;2618:	}
LABELV $1181
line 2619
;2619:}
LABELV $1176
endproc CG_ResetPlayerEntity 40 12
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
import CG_PositionRotatedEntityOnTag
import CG_PositionEntityOnTag
import CG_AdjustPositionForMover
import CG_Beam
import CG_InitMonsterShaders
import CG_AddPacketEntities
import CG_SetEntitySoundPosition
import CG_PainEvent
import CG_EntityEvent
import CG_PlaceString
import CG_CheckEvents
import CG_PredictPlayerState
import CG_Trace
import CG_PointContents
import CG_BuildSolidList
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
LABELV $1184
byte 1 37
byte 1 105
byte 1 32
byte 1 82
byte 1 101
byte 1 115
byte 1 101
byte 1 116
byte 1 80
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 69
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 121
byte 1 97
byte 1 119
byte 1 61
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $1173
byte 1 116
byte 1 97
byte 1 103
byte 1 95
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $1164
byte 1 116
byte 1 97
byte 1 103
byte 1 95
byte 1 116
byte 1 111
byte 1 114
byte 1 115
byte 1 111
byte 1 0
align 1
LABELV $1122
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 78
byte 1 117
byte 1 109
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $697
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 32
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 109
byte 1 101
byte 1 110
byte 1 116
byte 1 32
byte 1 97
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $626
byte 1 67
byte 1 108
byte 1 97
byte 1 109
byte 1 112
byte 1 32
byte 1 108
byte 1 102
byte 1 45
byte 1 62
byte 1 102
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $592
byte 1 65
byte 1 110
byte 1 105
byte 1 109
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $588
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $571
byte 1 77
byte 1 101
byte 1 109
byte 1 111
byte 1 114
byte 1 121
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 108
byte 1 111
byte 1 119
byte 1 46
byte 1 32
byte 1 32
byte 1 85
byte 1 115
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 114
byte 1 114
byte 1 101
byte 1 100
byte 1 32
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $535
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
LABELV $524
byte 1 104
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $491
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $489
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
LABELV $487
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
LABELV $485
byte 1 116
byte 1 108
byte 1 0
align 1
LABELV $483
byte 1 116
byte 1 116
byte 1 0
align 1
LABELV $481
byte 1 116
byte 1 0
align 1
LABELV $479
byte 1 108
byte 1 0
align 1
LABELV $477
byte 1 119
byte 1 0
align 1
LABELV $475
byte 1 104
byte 1 99
byte 1 0
align 1
LABELV $473
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $471
byte 1 99
byte 1 50
byte 1 0
align 1
LABELV $469
byte 1 99
byte 1 49
byte 1 0
align 1
LABELV $466
byte 1 110
byte 1 0
align 1
LABELV $461
byte 1 67
byte 1 71
byte 1 95
byte 1 83
byte 1 101
byte 1 116
byte 1 68
byte 1 101
byte 1 102
byte 1 101
byte 1 114
byte 1 114
byte 1 101
byte 1 100
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 73
byte 1 110
byte 1 102
byte 1 111
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $394
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
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $381
byte 1 116
byte 1 97
byte 1 103
byte 1 95
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $376
byte 1 68
byte 1 69
byte 1 70
byte 1 65
byte 1 85
byte 1 76
byte 1 84
byte 1 95
byte 1 77
byte 1 79
byte 1 68
byte 1 69
byte 1 76
byte 1 32
byte 1 40
byte 1 37
byte 1 115
byte 1 41
byte 1 32
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 114
byte 1 101
byte 1 103
byte 1 105
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $373
byte 1 68
byte 1 69
byte 1 70
byte 1 65
byte 1 85
byte 1 76
byte 1 84
byte 1 95
byte 1 84
byte 1 69
byte 1 65
byte 1 77
byte 1 95
byte 1 77
byte 1 79
byte 1 68
byte 1 69
byte 1 76
byte 1 32
byte 1 47
byte 1 32
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 32
byte 1 40
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 41
byte 1 32
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 114
byte 1 101
byte 1 103
byte 1 105
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $372
byte 1 115
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $364
byte 1 67
byte 1 71
byte 1 95
byte 1 82
byte 1 101
byte 1 103
byte 1 105
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 77
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 40
byte 1 32
byte 1 37
byte 1 115
byte 1 44
byte 1 32
byte 1 37
byte 1 115
byte 1 44
byte 1 32
byte 1 37
byte 1 115
byte 1 44
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 41
byte 1 32
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $345
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $342
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $339
byte 1 70
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 32
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $336
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 99
byte 1 104
byte 1 97
byte 1 114
byte 1 97
byte 1 99
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $333
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $332
byte 1 70
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 32
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 44
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $329
byte 1 83
byte 1 116
byte 1 114
byte 1 111
byte 1 103
byte 1 103
byte 1 115
byte 1 0
align 1
LABELV $328
byte 1 80
byte 1 97
byte 1 103
byte 1 97
byte 1 110
byte 1 115
byte 1 0
align 1
LABELV $327
byte 1 37
byte 1 115
byte 1 47
byte 1 0
align 1
LABELV $324
byte 1 70
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 32
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 44
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $315
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $314
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $309
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 99
byte 1 104
byte 1 97
byte 1 114
byte 1 97
byte 1 99
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 117
byte 1 112
byte 1 112
byte 1 101
byte 1 114
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $306
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 117
byte 1 112
byte 1 112
byte 1 101
byte 1 114
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $305
byte 1 70
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 32
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $302
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 99
byte 1 104
byte 1 97
byte 1 114
byte 1 97
byte 1 99
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 108
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $299
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 108
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $291
byte 1 72
byte 1 101
byte 1 97
byte 1 100
byte 1 32
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 32
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 32
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 117
byte 1 114
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $288
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $285
byte 1 84
byte 1 111
byte 1 114
byte 1 115
byte 1 111
byte 1 32
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 32
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 32
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 117
byte 1 114
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $282
byte 1 117
byte 1 112
byte 1 112
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $279
byte 1 76
byte 1 101
byte 1 103
byte 1 32
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 32
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 32
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 117
byte 1 114
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $276
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $275
byte 1 108
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $255
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 46
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $254
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 46
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $244
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 115
byte 1 47
byte 1 0
align 1
LABELV $233
byte 1 99
byte 1 104
byte 1 97
byte 1 114
byte 1 97
byte 1 99
byte 1 116
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 0
align 1
LABELV $223
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 46
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $222
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 46
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $214
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 46
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $213
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 95
byte 1 37
byte 1 115
byte 1 46
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $203
byte 1 0
align 1
LABELV $202
byte 1 114
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $201
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $189
byte 1 69
byte 1 114
byte 1 114
byte 1 111
byte 1 114
byte 1 32
byte 1 112
byte 1 97
byte 1 114
byte 1 115
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $164
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 116
byte 1 111
byte 1 107
byte 1 101
byte 1 110
byte 1 32
byte 1 39
byte 1 37
byte 1 115
byte 1 39
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $161
byte 1 102
byte 1 105
byte 1 120
byte 1 101
byte 1 100
byte 1 116
byte 1 111
byte 1 114
byte 1 115
byte 1 111
byte 1 0
align 1
LABELV $158
byte 1 102
byte 1 105
byte 1 120
byte 1 101
byte 1 100
byte 1 108
byte 1 101
byte 1 103
byte 1 115
byte 1 0
align 1
LABELV $147
byte 1 115
byte 1 101
byte 1 120
byte 1 0
align 1
LABELV $138
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 111
byte 1 102
byte 1 102
byte 1 115
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $135
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 32
byte 1 112
byte 1 97
byte 1 114
byte 1 109
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
LABELV $134
byte 1 101
byte 1 110
byte 1 101
byte 1 114
byte 1 103
byte 1 121
byte 1 0
align 1
LABELV $131
byte 1 109
byte 1 101
byte 1 99
byte 1 104
byte 1 0
align 1
LABELV $128
byte 1 102
byte 1 108
byte 1 101
byte 1 115
byte 1 104
byte 1 0
align 1
LABELV $125
byte 1 98
byte 1 111
byte 1 111
byte 1 116
byte 1 0
align 1
LABELV $121
byte 1 110
byte 1 111
byte 1 114
byte 1 109
byte 1 97
byte 1 108
byte 1 0
align 1
LABELV $120
byte 1 100
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $115
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $107
byte 1 70
byte 1 105
byte 1 108
byte 1 101
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 116
byte 1 111
byte 1 111
byte 1 32
byte 1 108
byte 1 111
byte 1 110
byte 1 103
byte 1 10
byte 1 0
align 1
LABELV $101
byte 1 85
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 99
byte 1 117
byte 1 115
byte 1 116
byte 1 111
byte 1 109
byte 1 32
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $86
byte 1 42
byte 1 116
byte 1 97
byte 1 117
byte 1 110
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $85
byte 1 42
byte 1 102
byte 1 97
byte 1 108
byte 1 108
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $84
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
align 1
LABELV $83
byte 1 42
byte 1 103
byte 1 97
byte 1 115
byte 1 112
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $82
byte 1 42
byte 1 102
byte 1 97
byte 1 108
byte 1 108
byte 1 105
byte 1 110
byte 1 103
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $81
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 49
byte 1 48
byte 1 48
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $80
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 55
byte 1 53
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $79
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 53
byte 1 48
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $78
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 50
byte 1 53
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $77
byte 1 42
byte 1 106
byte 1 117
byte 1 109
byte 1 112
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $76
byte 1 42
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 51
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $75
byte 1 42
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 50
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $74
byte 1 42
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
