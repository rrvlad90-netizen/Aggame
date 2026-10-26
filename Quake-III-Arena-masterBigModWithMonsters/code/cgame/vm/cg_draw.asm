data
export drawTeamOverlayModificationCount
align 4
LABELV drawTeamOverlayModificationCount
byte 4 -1
code
proc CG_DrawField 64 20
file "../cg_draw.c"
line 212
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
;23:// cg_draw.c -- draw all of the graphical elements during
;24:// active (after loading) gameplay
;25:
;26:#include "cg_local.h"
;27:
;28:#ifdef MISSIONPACK
;29:#include "../ui/ui_shared.h"
;30:
;31:// used for scoreboard
;32:extern displayContextDef_t cgDC;
;33:menuDef_t *menuScoreboard = NULL;
;34:#else
;35:int drawTeamOverlayModificationCount = -1;
;36:#endif
;37:
;38:int sortedTeamPlayers[TEAM_MAXOVERLAY];
;39:int	numSortedTeamPlayers;
;40:
;41:char systemChat[256];
;42:char teamChat1[256];
;43:char teamChat2[256];
;44:
;45:#ifdef MISSIONPACK
;46:
;47:int CG_Text_Width(const char *text, float scale, int limit) {
;48:  int count,len;
;49:	float out;
;50:	glyphInfo_t *glyph;
;51:	float useScale;
;52:// FIXME: see ui_main.c, same problem
;53://	const unsigned char *s = text;
;54:	const char *s = text;
;55:	fontInfo_t *font = &cgDC.Assets.textFont;
;56:	if (scale <= cg_smallFont.value) {
;57:		font = &cgDC.Assets.smallFont;
;58:	} else if (scale > cg_bigFont.value) {
;59:		font = &cgDC.Assets.bigFont;
;60:	}
;61:	useScale = scale * font->glyphScale;
;62:  out = 0;
;63:  if (text) {
;64:    len = strlen(text);
;65:		if (limit > 0 && len > limit) {
;66:			len = limit;
;67:		}
;68:		count = 0;
;69:		while (s && *s && count < len) {
;70:			if ( Q_IsColorString(s) ) {
;71:				s += 2;
;72:				continue;
;73:			} else {
;74:				glyph = &font->glyphs[(int)*s]; // TTimo: FIXME: getting nasty warnings without the cast, hopefully this doesn't break the VM build
;75:				out += glyph->xSkip;
;76:				s++;
;77:				count++;
;78:			}
;79:    }
;80:  }
;81:  return out * useScale;
;82:}
;83:
;84:int CG_Text_Height(const char *text, float scale, int limit) {
;85:  int len, count;
;86:	float max;
;87:	glyphInfo_t *glyph;
;88:	float useScale;
;89:// TTimo: FIXME
;90://	const unsigned char *s = text;
;91:	const char *s = text;
;92:	fontInfo_t *font = &cgDC.Assets.textFont;
;93:	if (scale <= cg_smallFont.value) {
;94:		font = &cgDC.Assets.smallFont;
;95:	} else if (scale > cg_bigFont.value) {
;96:		font = &cgDC.Assets.bigFont;
;97:	}
;98:	useScale = scale * font->glyphScale;
;99:  max = 0;
;100:  if (text) {
;101:    len = strlen(text);
;102:		if (limit > 0 && len > limit) {
;103:			len = limit;
;104:		}
;105:		count = 0;
;106:		while (s && *s && count < len) {
;107:			if ( Q_IsColorString(s) ) {
;108:				s += 2;
;109:				continue;
;110:			} else {
;111:				glyph = &font->glyphs[(int)*s]; // TTimo: FIXME: getting nasty warnings without the cast, hopefully this doesn't break the VM build
;112:	      if (max < glyph->height) {
;113:		      max = glyph->height;
;114:			  }
;115:				s++;
;116:				count++;
;117:			}
;118:    }
;119:  }
;120:  return max * useScale;
;121:}
;122:
;123:void CG_Text_PaintChar(float x, float y, float width, float height, float scale, float s, float t, float s2, float t2, qhandle_t hShader) {
;124:  float w, h;
;125:  w = width * scale;
;126:  h = height * scale;
;127:  CG_AdjustFrom640( &x, &y, &w, &h );
;128:  trap_R_DrawStretchPic( x, y, w, h, s, t, s2, t2, hShader );
;129:}
;130:
;131:void CG_Text_Paint(float x, float y, float scale, vec4_t color, const char *text, float adjust, int limit, int style) {
;132:  int len, count;
;133:	vec4_t newColor;
;134:	glyphInfo_t *glyph;
;135:	float useScale;
;136:	fontInfo_t *font = &cgDC.Assets.textFont;
;137:	if (scale <= cg_smallFont.value) {
;138:		font = &cgDC.Assets.smallFont;
;139:	} else if (scale > cg_bigFont.value) {
;140:		font = &cgDC.Assets.bigFont;
;141:	}
;142:	useScale = scale * font->glyphScale;
;143:  if (text) {
;144:// TTimo: FIXME
;145://		const unsigned char *s = text;
;146:		const char *s = text;
;147:		trap_R_SetColor( color );
;148:		memcpy(&newColor[0], &color[0], sizeof(vec4_t));
;149:    len = strlen(text);
;150:		if (limit > 0 && len > limit) {
;151:			len = limit;
;152:		}
;153:		count = 0;
;154:		while (s && *s && count < len) {
;155:			glyph = &font->glyphs[(int)*s]; // TTimo: FIXME: getting nasty warnings without the cast, hopefully this doesn't break the VM build
;156:      //int yadj = Assets.textFont.glyphs[text[i]].bottom + Assets.textFont.glyphs[text[i]].top;
;157:      //float yadj = scale * (Assets.textFont.glyphs[text[i]].imageHeight - Assets.textFont.glyphs[text[i]].height);
;158:			if ( Q_IsColorString( s ) ) {
;159:				memcpy( newColor, g_color_table[ColorIndex(*(s+1))], sizeof( newColor ) );
;160:				newColor[3] = color[3];
;161:				trap_R_SetColor( newColor );
;162:				s += 2;
;163:				continue;
;164:			} else {
;165:				float yadj = useScale * glyph->top;
;166:				if (style == ITEM_TEXTSTYLE_SHADOWED || style == ITEM_TEXTSTYLE_SHADOWEDMORE) {
;167:					int ofs = style == ITEM_TEXTSTYLE_SHADOWED ? 1 : 2;
;168:					colorBlack[3] = newColor[3];
;169:					trap_R_SetColor( colorBlack );
;170:					CG_Text_PaintChar(x + ofs, y - yadj + ofs, 
;171:														glyph->imageWidth,
;172:														glyph->imageHeight,
;173:														useScale, 
;174:														glyph->s,
;175:														glyph->t,
;176:														glyph->s2,
;177:														glyph->t2,
;178:														glyph->glyph);
;179:					colorBlack[3] = 1.0;
;180:					trap_R_SetColor( newColor );
;181:				}
;182:				CG_Text_PaintChar(x, y - yadj, 
;183:													glyph->imageWidth,
;184:													glyph->imageHeight,
;185:													useScale, 
;186:													glyph->s,
;187:													glyph->t,
;188:													glyph->s2,
;189:													glyph->t2,
;190:													glyph->glyph);
;191:				// CG_DrawPic(x, y - yadj, scale * cgDC.Assets.textFont.glyphs[text[i]].imageWidth, scale * cgDC.Assets.textFont.glyphs[text[i]].imageHeight, cgDC.Assets.textFont.glyphs[text[i]].glyph);
;192:				x += (glyph->xSkip * useScale) + adjust;
;193:				s++;
;194:				count++;
;195:			}
;196:    }
;197:	  trap_R_SetColor( NULL );
;198:  }
;199:}
;200:
;201:
;202:#endif
;203:
;204:/*
;205:==============
;206:CG_DrawField
;207:
;208:Draws large numbers for status bar and powerups
;209:==============
;210:*/
;211:#ifndef MISSIONPACK
;212:static void CG_DrawField (int x, int y, int width, int value) {
line 217
;213:	char	num[16], *ptr;
;214:	int		l;
;215:	int		frame;
;216:
;217:	if ( width < 1 ) {
ADDRFP4 8
INDIRI4
CNSTI4 1
GEI4 $75
line 218
;218:		return;
ADDRGP4 $74
JUMPV
LABELV $75
line 222
;219:	}
;220:
;221:	// draw number string
;222:	if ( width > 5 ) {
ADDRFP4 8
INDIRI4
CNSTI4 5
LEI4 $77
line 223
;223:		width = 5;
ADDRFP4 8
CNSTI4 5
ASGNI4
line 224
;224:	}
LABELV $77
line 226
;225:
;226:	switch ( width ) {
ADDRLP4 28
ADDRFP4 8
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1
LTI4 $79
ADDRLP4 28
INDIRI4
CNSTI4 4
GTI4 $79
ADDRLP4 28
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $109-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $109
address $81
address $88
address $95
address $102
code
LABELV $81
line 228
;227:	case 1:
;228:		value = value > 9 ? 9 : value;
ADDRFP4 12
INDIRI4
CNSTI4 9
LEI4 $83
ADDRLP4 32
CNSTI4 9
ASGNI4
ADDRGP4 $84
JUMPV
LABELV $83
ADDRLP4 32
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $84
ADDRFP4 12
ADDRLP4 32
INDIRI4
ASGNI4
line 229
;229:		value = value < 0 ? 0 : value;
ADDRFP4 12
INDIRI4
CNSTI4 0
GEI4 $86
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRGP4 $87
JUMPV
LABELV $86
ADDRLP4 36
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $87
ADDRFP4 12
ADDRLP4 36
INDIRI4
ASGNI4
line 230
;230:		break;
ADDRGP4 $80
JUMPV
LABELV $88
line 232
;231:	case 2:
;232:		value = value > 99 ? 99 : value;
ADDRFP4 12
INDIRI4
CNSTI4 99
LEI4 $90
ADDRLP4 40
CNSTI4 99
ASGNI4
ADDRGP4 $91
JUMPV
LABELV $90
ADDRLP4 40
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $91
ADDRFP4 12
ADDRLP4 40
INDIRI4
ASGNI4
line 233
;233:		value = value < -9 ? -9 : value;
ADDRFP4 12
INDIRI4
CNSTI4 -9
GEI4 $93
ADDRLP4 44
CNSTI4 -9
ASGNI4
ADDRGP4 $94
JUMPV
LABELV $93
ADDRLP4 44
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $94
ADDRFP4 12
ADDRLP4 44
INDIRI4
ASGNI4
line 234
;234:		break;
ADDRGP4 $80
JUMPV
LABELV $95
line 236
;235:	case 3:
;236:		value = value > 999 ? 999 : value;
ADDRFP4 12
INDIRI4
CNSTI4 999
LEI4 $97
ADDRLP4 48
CNSTI4 999
ASGNI4
ADDRGP4 $98
JUMPV
LABELV $97
ADDRLP4 48
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $98
ADDRFP4 12
ADDRLP4 48
INDIRI4
ASGNI4
line 237
;237:		value = value < -99 ? -99 : value;
ADDRFP4 12
INDIRI4
CNSTI4 -99
GEI4 $100
ADDRLP4 52
CNSTI4 -99
ASGNI4
ADDRGP4 $101
JUMPV
LABELV $100
ADDRLP4 52
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $101
ADDRFP4 12
ADDRLP4 52
INDIRI4
ASGNI4
line 238
;238:		break;
ADDRGP4 $80
JUMPV
LABELV $102
line 240
;239:	case 4:
;240:		value = value > 9999 ? 9999 : value;
ADDRFP4 12
INDIRI4
CNSTI4 9999
LEI4 $104
ADDRLP4 56
CNSTI4 9999
ASGNI4
ADDRGP4 $105
JUMPV
LABELV $104
ADDRLP4 56
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $105
ADDRFP4 12
ADDRLP4 56
INDIRI4
ASGNI4
line 241
;241:		value = value < -999 ? -999 : value;
ADDRFP4 12
INDIRI4
CNSTI4 -999
GEI4 $107
ADDRLP4 60
CNSTI4 -999
ASGNI4
ADDRGP4 $108
JUMPV
LABELV $107
ADDRLP4 60
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $108
ADDRFP4 12
ADDRLP4 60
INDIRI4
ASGNI4
line 242
;242:		break;
LABELV $79
LABELV $80
line 245
;243:	}
;244:
;245:	Com_sprintf (num, sizeof(num), "%i", value);
ADDRLP4 12
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 $111
ARGP4
ADDRFP4 12
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 246
;246:	l = strlen(num);
ADDRLP4 12
ARGP4
ADDRLP4 32
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 32
INDIRI4
ASGNI4
line 247
;247:	if (l > width)
ADDRLP4 4
INDIRI4
ADDRFP4 8
INDIRI4
LEI4 $112
line 248
;248:		l = width;
ADDRLP4 4
ADDRFP4 8
INDIRI4
ASGNI4
LABELV $112
line 249
;249:	x += 2 + CHAR_WIDTH*(width - l);
ADDRFP4 0
ADDRFP4 0
INDIRI4
ADDRFP4 8
INDIRI4
ADDRLP4 4
INDIRI4
SUBI4
CNSTI4 5
LSHI4
CNSTI4 2
ADDI4
ADDI4
ASGNI4
line 251
;250:
;251:	ptr = num;
ADDRLP4 0
ADDRLP4 12
ASGNP4
ADDRGP4 $115
JUMPV
LABELV $114
line 253
;252:	while (*ptr && l)
;253:	{
line 254
;254:		if (*ptr == '-')
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 45
NEI4 $117
line 255
;255:			frame = STAT_MINUS;
ADDRLP4 8
CNSTI4 10
ASGNI4
ADDRGP4 $118
JUMPV
LABELV $117
line 257
;256:		else
;257:			frame = *ptr -'0';
ADDRLP4 8
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
ASGNI4
LABELV $118
line 259
;258:
;259:		CG_DrawPic( x,y, CHAR_WIDTH, CHAR_HEIGHT, cgs.media.numberShaders[frame] );
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1107296256
ARGF4
CNSTF4 1111490560
ARGF4
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+300
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 260
;260:		x += CHAR_WIDTH;
ADDRFP4 0
ADDRFP4 0
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 261
;261:		ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 262
;262:		l--;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 263
;263:	}
LABELV $115
line 252
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 36
INDIRI4
EQI4 $121
ADDRLP4 4
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $114
LABELV $121
line 264
;264:}
LABELV $74
endproc CG_DrawField 64 20
export CG_Draw3DModel
proc CG_Draw3DModel 512 16
line 273
;265:#endif // MISSIONPACK
;266:
;267:/*
;268:================
;269:CG_Draw3DModel
;270:
;271:================
;272:*/
;273:void CG_Draw3DModel( float x, float y, float w, float h, qhandle_t model, qhandle_t skin, vec3_t origin, vec3_t angles ) {
line 277
;274:	refdef_t		refdef;
;275:	refEntity_t		ent;
;276:
;277:	if ( !cg_draw3dIcons.integer || !cg_drawIcons.integer ) {
ADDRLP4 508
CNSTI4 0
ASGNI4
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 508
INDIRI4
EQI4 $127
ADDRGP4 cg_drawIcons+12
INDIRI4
ADDRLP4 508
INDIRI4
NEI4 $123
LABELV $127
line 278
;278:		return;
ADDRGP4 $122
JUMPV
LABELV $123
line 281
;279:	}
;280:
;281:	CG_AdjustFrom640( &x, &y, &w, &h );
ADDRFP4 0
ARGP4
ADDRFP4 4
ARGP4
ADDRFP4 8
ARGP4
ADDRFP4 12
ARGP4
ADDRGP4 CG_AdjustFrom640
CALLV
pop
line 283
;282:
;283:	memset( &refdef, 0, sizeof( refdef ) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 368
ARGI4
ADDRGP4 memset
CALLP4
pop
line 285
;284:
;285:	memset( &ent, 0, sizeof( ent ) );
ADDRLP4 368
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 286
;286:	AnglesToAxis( angles, ent.axis );
ADDRFP4 28
INDIRP4
ARGP4
ADDRLP4 368+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 287
;287:	VectorCopy( origin, ent.origin );
ADDRLP4 368+68
ADDRFP4 24
INDIRP4
INDIRB
ASGNB 12
line 288
;288:	ent.hModel = model;
ADDRLP4 368+8
ADDRFP4 16
INDIRI4
ASGNI4
line 289
;289:	ent.customSkin = skin;
ADDRLP4 368+108
ADDRFP4 20
INDIRI4
ASGNI4
line 290
;290:	ent.renderfx = RF_NOSHADOW;		// no stencil shadows
ADDRLP4 368+4
CNSTI4 64
ASGNI4
line 292
;291:
;292:	refdef.rdflags = RDF_NOWORLDMODEL;
ADDRLP4 0+76
CNSTI4 1
ASGNI4
line 294
;293:
;294:	AxisClear( refdef.viewaxis );
ADDRLP4 0+36
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 296
;295:
;296:	refdef.fov_x = 30;
ADDRLP4 0+16
CNSTF4 1106247680
ASGNF4
line 297
;297:	refdef.fov_y = 30;
ADDRLP4 0+20
CNSTF4 1106247680
ASGNF4
line 299
;298:
;299:	refdef.x = x;
ADDRLP4 0
ADDRFP4 0
INDIRF4
CVFI4 4
ASGNI4
line 300
;300:	refdef.y = y;
ADDRLP4 0+4
ADDRFP4 4
INDIRF4
CVFI4 4
ASGNI4
line 301
;301:	refdef.width = w;
ADDRLP4 0+8
ADDRFP4 8
INDIRF4
CVFI4 4
ASGNI4
line 302
;302:	refdef.height = h;
ADDRLP4 0+12
ADDRFP4 12
INDIRF4
CVFI4 4
ASGNI4
line 304
;303:
;304:	refdef.time = cg.time;
ADDRLP4 0+72
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 306
;305:
;306:	trap_R_ClearScene();
ADDRGP4 trap_R_ClearScene
CALLV
pop
line 307
;307:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 368
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 308
;308:	trap_R_RenderScene( &refdef );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_RenderScene
CALLV
pop
line 309
;309:}
LABELV $122
endproc CG_Draw3DModel 512 16
export CG_DrawHead
proc CG_DrawHead 56 32
line 318
;310:
;311:/*
;312:================
;313:CG_DrawHead
;314:
;315:Used for both the status bar and the scoreboard
;316:================
;317:*/
;318:void CG_DrawHead( float x, float y, float w, float h, int clientNum, vec3_t headAngles ) {
line 325
;319:	clipHandle_t	cm;
;320:	clientInfo_t	*ci;
;321:	float			len;
;322:	vec3_t			origin;
;323:	vec3_t			mins, maxs;
;324:
;325:	ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 0
CNSTI4 1708
ADDRFP4 16
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 327
;326:
;327:	if ( cg_draw3dIcons.integer ) {
ADDRGP4 cg_draw3dIcons+12
INDIRI4
CNSTI4 0
EQI4 $144
line 328
;328:		cm = ci->headModel;
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
ASGNI4
line 329
;329:		if ( !cm ) {
ADDRLP4 40
INDIRI4
CNSTI4 0
NEI4 $147
line 330
;330:			return;
ADDRGP4 $142
JUMPV
LABELV $147
line 334
;331:		}
;332:
;333:		// offset the origin y and z to center the head
;334:		trap_R_ModelBounds( cm, mins, maxs );
ADDRLP4 40
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRLP4 28
ARGP4
ADDRGP4 trap_R_ModelBounds
CALLV
pop
line 336
;335:
;336:		origin[2] = -0.5 * ( mins[2] + maxs[2] );
ADDRLP4 4+8
CNSTF4 3204448256
ADDRLP4 16+8
INDIRF4
ADDRLP4 28+8
INDIRF4
ADDF4
MULF4
ASGNF4
line 337
;337:		origin[1] = 0.5 * ( mins[1] + maxs[1] );
ADDRLP4 4+4
CNSTF4 1056964608
ADDRLP4 16+4
INDIRF4
ADDRLP4 28+4
INDIRF4
ADDF4
MULF4
ASGNF4
line 341
;338:
;339:		// calculate distance so the head nearly fills the box
;340:		// assume heads are taller than wide
;341:		len = 0.7 * ( maxs[2] - mins[2] );		
ADDRLP4 44
CNSTF4 1060320051
ADDRLP4 28+8
INDIRF4
ADDRLP4 16+8
INDIRF4
SUBF4
MULF4
ASGNF4
line 342
;342:		origin[0] = len / 0.268;	// len / tan( fov/2 )
ADDRLP4 4
ADDRLP4 44
INDIRF4
CNSTF4 1049179980
DIVF4
ASGNF4
line 345
;343:
;344:		// allow per-model tweaking
;345:		VectorAdd( origin, ci->headOffset, origin );
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 4+4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 500
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 504
ADDP4
INDIRF4
ADDF4
ASGNF4
line 347
;346:
;347:		CG_Draw3DModel( x, y, w, h, ci->headModel, ci->headSkin, origin, headAngles );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 348
;348:	} else if ( cg_drawIcons.integer ) {
ADDRGP4 $145
JUMPV
LABELV $144
ADDRGP4 cg_drawIcons+12
INDIRI4
CNSTI4 0
EQI4 $161
line 349
;349:		CG_DrawPic( x, y, w, h, ci->modelIcon );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 540
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 350
;350:	}
LABELV $161
LABELV $145
line 353
;351:
;352:	// if they are deferred, draw a cross out
;353:	if ( ci->deferred ) {
ADDRLP4 0
INDIRP4
CNSTI4 480
ADDP4
INDIRI4
CNSTI4 0
EQI4 $164
line 354
;354:		CG_DrawPic( x, y, w, h, cgs.media.deferShader );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRGP4 cgs+152340+132
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 355
;355:	}
LABELV $164
line 356
;356:}
LABELV $142
endproc CG_DrawHead 56 32
export CG_DrawFlagModel
proc CG_DrawFlagModel 72 32
line 365
;357:
;358:/*
;359:================
;360:CG_DrawFlagModel
;361:
;362:Used for both the status bar and the scoreboard
;363:================
;364:*/
;365:void CG_DrawFlagModel( float x, float y, float w, float h, int team, qboolean force2D ) {
line 372
;366:	qhandle_t		cm;
;367:	float			len;
;368:	vec3_t			origin, angles;
;369:	vec3_t			mins, maxs;
;370:	qhandle_t		handle;
;371:
;372:	if ( !force2D && cg_draw3dIcons.integer ) {
ADDRLP4 60
CNSTI4 0
ASGNI4
ADDRFP4 20
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $169
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 60
INDIRI4
EQI4 $169
line 374
;373:
;374:		VectorClear( angles );
ADDRLP4 64
CNSTF4 0
ASGNF4
ADDRLP4 0+8
ADDRLP4 64
INDIRF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 64
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 64
INDIRF4
ASGNF4
line 376
;375:
;376:		cm = cgs.media.redFlagModel;
ADDRLP4 48
ADDRGP4 cgs+152340+36
INDIRI4
ASGNI4
line 379
;377:
;378:		// offset the origin y and z to center the flag
;379:		trap_R_ModelBounds( cm, mins, maxs );
ADDRLP4 48
INDIRI4
ARGI4
ADDRLP4 24
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 trap_R_ModelBounds
CALLV
pop
line 381
;380:
;381:		origin[2] = -0.5 * ( mins[2] + maxs[2] );
ADDRLP4 12+8
CNSTF4 3204448256
ADDRLP4 24+8
INDIRF4
ADDRLP4 36+8
INDIRF4
ADDF4
MULF4
ASGNF4
line 382
;382:		origin[1] = 0.5 * ( mins[1] + maxs[1] );
ADDRLP4 12+4
CNSTF4 1056964608
ADDRLP4 24+4
INDIRF4
ADDRLP4 36+4
INDIRF4
ADDF4
MULF4
ASGNF4
line 386
;383:
;384:		// calculate distance so the flag nearly fills the box
;385:		// assume heads are taller than wide
;386:		len = 0.5 * ( maxs[2] - mins[2] );		
ADDRLP4 52
CNSTF4 1056964608
ADDRLP4 36+8
INDIRF4
ADDRLP4 24+8
INDIRF4
SUBF4
MULF4
ASGNF4
line 387
;387:		origin[0] = len / 0.268;	// len / tan( fov/2 )
ADDRLP4 12
ADDRLP4 52
INDIRF4
CNSTF4 1049179980
DIVF4
ASGNF4
line 389
;388:
;389:		angles[YAW] = 60 * sin( cg.time / 2000.0 );;
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
CNSTF4 1157234688
DIVF4
ARGF4
ADDRLP4 68
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 0+4
CNSTF4 1114636288
ADDRLP4 68
INDIRF4
MULF4
ASGNF4
line 391
;390:
;391:		if( team == TEAM_RED ) {
ADDRFP4 16
INDIRI4
CNSTI4 1
NEI4 $186
line 392
;392:			handle = cgs.media.redFlagModel;
ADDRLP4 56
ADDRGP4 cgs+152340+36
INDIRI4
ASGNI4
line 393
;393:		} else if( team == TEAM_BLUE ) {
ADDRGP4 $187
JUMPV
LABELV $186
ADDRFP4 16
INDIRI4
CNSTI4 2
NEI4 $190
line 394
;394:			handle = cgs.media.blueFlagModel;
ADDRLP4 56
ADDRGP4 cgs+152340+40
INDIRI4
ASGNI4
line 395
;395:		} else if( team == TEAM_FREE ) {
ADDRGP4 $191
JUMPV
LABELV $190
ADDRFP4 16
INDIRI4
CNSTI4 0
NEI4 $168
line 396
;396:			handle = cgs.media.neutralFlagModel;
ADDRLP4 56
ADDRGP4 cgs+152340+44
INDIRI4
ASGNI4
line 397
;397:		} else {
line 398
;398:			return;
LABELV $195
LABELV $191
LABELV $187
line 400
;399:		}
;400:		CG_Draw3DModel( x, y, w, h, handle, 0, origin, angles );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 56
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 401
;401:	} else if ( cg_drawIcons.integer ) {
ADDRGP4 $170
JUMPV
LABELV $169
ADDRGP4 cg_drawIcons+12
INDIRI4
CNSTI4 0
EQI4 $198
line 404
;402:		gitem_t *item;
;403:
;404:		if( team == TEAM_RED ) {
ADDRFP4 16
INDIRI4
CNSTI4 1
NEI4 $201
line 405
;405:			item = BG_FindItemForPowerup( PW_REDFLAG );
CNSTI4 7
ARGI4
ADDRLP4 68
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 64
ADDRLP4 68
INDIRP4
ASGNP4
line 406
;406:		} else if( team == TEAM_BLUE ) {
ADDRGP4 $202
JUMPV
LABELV $201
ADDRFP4 16
INDIRI4
CNSTI4 2
NEI4 $203
line 407
;407:			item = BG_FindItemForPowerup( PW_BLUEFLAG );
CNSTI4 8
ARGI4
ADDRLP4 68
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 64
ADDRLP4 68
INDIRP4
ASGNP4
line 408
;408:		} else if( team == TEAM_FREE ) {
ADDRGP4 $204
JUMPV
LABELV $203
ADDRFP4 16
INDIRI4
CNSTI4 0
NEI4 $168
line 409
;409:			item = BG_FindItemForPowerup( PW_NEUTRALFLAG );
CNSTI4 9
ARGI4
ADDRLP4 68
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 64
ADDRLP4 68
INDIRP4
ASGNP4
line 410
;410:		} else {
line 411
;411:			return;
LABELV $206
LABELV $204
LABELV $202
line 413
;412:		}
;413:		if (item) {
ADDRLP4 64
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $207
line 414
;414:		  CG_DrawPic( x, y, w, h, cg_items[ ITEM_INDEX(item) ].icon );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
CNSTI4 24
ADDRLP4 64
INDIRP4
CVPU4 4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
MULI4
ADDRGP4 cg_items+20
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 415
;415:		}
LABELV $207
line 416
;416:	}
LABELV $198
LABELV $170
line 417
;417:}
LABELV $168
endproc CG_DrawFlagModel 72 32
proc CG_DrawStatusBarHead 56 24
line 427
;418:
;419:/*
;420:================
;421:CG_DrawStatusBarHead
;422:
;423:================
;424:*/
;425:#ifndef MISSIONPACK
;426:
;427:static void CG_DrawStatusBarHead( float x ) {
line 432
;428:	vec3_t		angles;
;429:	float		size, stretch;
;430:	float		frac;
;431:
;432:	VectorClear( angles );
ADDRLP4 24
CNSTF4 0
ASGNF4
ADDRLP4 4+8
ADDRLP4 24
INDIRF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 24
INDIRF4
ASGNF4
ADDRLP4 4
ADDRLP4 24
INDIRF4
ASGNF4
line 434
;433:
;434:	if ( cg.damageTime && cg.time - cg.damageTime < DAMAGE_TIME ) {
ADDRGP4 cg+124688
INDIRF4
CNSTF4 0
EQF4 $213
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124688
INDIRF4
SUBF4
CNSTF4 1140457472
GEF4 $213
line 435
;435:		frac = (float)(cg.time - cg.damageTime ) / DAMAGE_TIME;
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124688
INDIRF4
SUBF4
CNSTF4 1140457472
DIVF4
ASGNF4
line 436
;436:		size = ICON_SIZE * 1.25 * ( 1.5 - frac * 0.5 );
ADDRLP4 16
CNSTF4 1114636288
CNSTF4 1069547520
CNSTF4 1056964608
ADDRLP4 0
INDIRF4
MULF4
SUBF4
MULF4
ASGNF4
line 438
;437:
;438:		stretch = size - ICON_SIZE * 1.25;
ADDRLP4 20
ADDRLP4 16
INDIRF4
CNSTF4 1114636288
SUBF4
ASGNF4
line 440
;439:		// kick in the direction of damage
;440:		x -= stretch * 0.5 + cg.damageX * stretch * 0.5;
ADDRLP4 28
CNSTF4 1056964608
ASGNF4
ADDRLP4 32
ADDRLP4 20
INDIRF4
ASGNF4
ADDRFP4 0
ADDRFP4 0
INDIRF4
ADDRLP4 28
INDIRF4
ADDRLP4 32
INDIRF4
MULF4
ADDRLP4 28
INDIRF4
ADDRGP4 cg+124692
INDIRF4
ADDRLP4 32
INDIRF4
MULF4
MULF4
ADDF4
SUBF4
ASGNF4
line 442
;441:
;442:		cg.headStartYaw = 180 + cg.damageX * 45;
ADDRGP4 cg+124724
CNSTF4 1110704128
ADDRGP4 cg+124692
INDIRF4
MULF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 444
;443:
;444:		cg.headEndYaw = 180 + 20 * cos( crandom()*M_PI );
ADDRLP4 36
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
CNSTF4 1073741824
ADDRLP4 36
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
ARGF4
ADDRLP4 40
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124712
CNSTF4 1101004800
ADDRLP4 40
INDIRF4
MULF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 445
;445:		cg.headEndPitch = 5 * cos( crandom()*M_PI );
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
CNSTF4 1073741824
ADDRLP4 44
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
ARGF4
ADDRLP4 48
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124708
CNSTF4 1084227584
ADDRLP4 48
INDIRF4
MULF4
ASGNF4
line 447
;446:
;447:		cg.headStartTime = cg.time;
ADDRGP4 cg+124728
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 448
;448:		cg.headEndTime = cg.time + 100 + random() * 2000;
ADDRLP4 52
ADDRGP4 rand
CALLI4
ASGNI4
ADDRGP4 cg+124716
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
ADDI4
CVIF4 4
CNSTF4 1157234688
ADDRLP4 52
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 449
;449:	} else {
ADDRGP4 $214
JUMPV
LABELV $213
line 450
;450:		if ( cg.time >= cg.headEndTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124716
INDIRI4
LTI4 $229
line 452
;451:			// select a new head angle
;452:			cg.headStartYaw = cg.headEndYaw;
ADDRGP4 cg+124724
ADDRGP4 cg+124712
INDIRF4
ASGNF4
line 453
;453:			cg.headStartPitch = cg.headEndPitch;
ADDRGP4 cg+124720
ADDRGP4 cg+124708
INDIRF4
ASGNF4
line 454
;454:			cg.headStartTime = cg.headEndTime;
ADDRGP4 cg+124728
ADDRGP4 cg+124716
INDIRI4
ASGNI4
line 455
;455:			cg.headEndTime = cg.time + 100 + random() * 2000;
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRGP4 cg+124716
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
ADDI4
CVIF4 4
CNSTF4 1157234688
ADDRLP4 28
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 457
;456:
;457:			cg.headEndYaw = 180 + 20 * cos( crandom()*M_PI );
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
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
ARGF4
ADDRLP4 36
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124712
CNSTF4 1101004800
ADDRLP4 36
INDIRF4
MULF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 458
;458:			cg.headEndPitch = 5 * cos( crandom()*M_PI );
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
CNSTF4 1073741824
ADDRLP4 40
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
ARGF4
ADDRLP4 44
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124708
CNSTF4 1084227584
ADDRLP4 44
INDIRF4
MULF4
ASGNF4
line 459
;459:		}
LABELV $229
line 461
;460:
;461:		size = ICON_SIZE * 1.25;
ADDRLP4 16
CNSTF4 1114636288
ASGNF4
line 462
;462:	}
LABELV $214
line 465
;463:
;464:	// if the server was frozen for a while we may have a bad head start time
;465:	if ( cg.headStartTime > cg.time ) {
ADDRGP4 cg+124728
INDIRI4
ADDRGP4 cg+107604
INDIRI4
LEI4 $243
line 466
;466:		cg.headStartTime = cg.time;
ADDRGP4 cg+124728
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 467
;467:	}
LABELV $243
line 469
;468:
;469:	frac = ( cg.time - cg.headStartTime ) / (float)( cg.headEndTime - cg.headStartTime );
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124728
INDIRI4
SUBI4
CVIF4 4
ADDRGP4 cg+124716
INDIRI4
ADDRGP4 cg+124728
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 470
;470:	frac = frac * frac * ( 3 - 2 * frac );
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
CNSTF4 1077936128
CNSTF4 1073741824
ADDRLP4 0
INDIRF4
MULF4
SUBF4
MULF4
ASGNF4
line 471
;471:	angles[YAW] = cg.headStartYaw + ( cg.headEndYaw - cg.headStartYaw ) * frac;
ADDRLP4 4+4
ADDRGP4 cg+124724
INDIRF4
ADDRGP4 cg+124712
INDIRF4
ADDRGP4 cg+124724
INDIRF4
SUBF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
line 472
;472:	angles[PITCH] = cg.headStartPitch + ( cg.headEndPitch - cg.headStartPitch ) * frac;
ADDRLP4 4
ADDRGP4 cg+124720
INDIRF4
ADDRGP4 cg+124708
INDIRF4
ADDRGP4 cg+124720
INDIRF4
SUBF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
line 474
;473:
;474:	CG_DrawHead( x, 480 - size, size, size, 
ADDRFP4 0
INDIRF4
ARGF4
CNSTF4 1139802112
ADDRLP4 16
INDIRF4
SUBF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 CG_DrawHead
CALLV
pop
line 476
;475:				cg.snap->ps.clientNum, angles );
;476:}
LABELV $210
endproc CG_DrawStatusBarHead 56 24
proc CG_DrawStatusBarFlag 4 24
line 486
;477:#endif // MISSIONPACK
;478:
;479:/*
;480:================
;481:CG_DrawStatusBarFlag
;482:
;483:================
;484:*/
;485:#ifndef MISSIONPACK
;486:static void CG_DrawStatusBarFlag( float x, int team ) {
line 487
;487:	CG_DrawFlagModel( x, 480 - ICON_SIZE, ICON_SIZE, ICON_SIZE, team, qfalse );
ADDRFP4 0
INDIRF4
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 0
CNSTF4 1111490560
ASGNF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 488
;488:}
LABELV $261
endproc CG_DrawStatusBarFlag 4 24
export CG_DrawTeamBackground
proc CG_DrawTeamBackground 16 20
line 498
;489:#endif // MISSIONPACK
;490:
;491:/*
;492:================
;493:CG_DrawTeamBackground
;494:
;495:================
;496:*/
;497:void CG_DrawTeamBackground( int x, int y, int w, int h, float alpha, int team )
;498:{
line 501
;499:	vec4_t		hcolor;
;500:
;501:	hcolor[3] = alpha;
ADDRLP4 0+12
ADDRFP4 16
INDIRF4
ASGNF4
line 502
;502:	if ( team == TEAM_RED ) {
ADDRFP4 20
INDIRI4
CNSTI4 1
NEI4 $264
line 503
;503:		hcolor[0] = 1;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 504
;504:		hcolor[1] = 0;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 505
;505:		hcolor[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 506
;506:	} else if ( team == TEAM_BLUE ) {
ADDRGP4 $265
JUMPV
LABELV $264
ADDRFP4 20
INDIRI4
CNSTI4 2
NEI4 $262
line 507
;507:		hcolor[0] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 508
;508:		hcolor[1] = 0;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 509
;509:		hcolor[2] = 1;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 510
;510:	} else {
line 511
;511:		return;
LABELV $269
LABELV $265
line 513
;512:	}
;513:	trap_R_SetColor( hcolor );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 514
;514:	CG_DrawPic( x, y, w, h, cgs.media.teamStatusBar );
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 4
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 cgs+152340+128
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 515
;515:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 516
;516:}
LABELV $262
endproc CG_DrawTeamBackground 16 20
data
align 4
LABELV $275
byte 4 1065353216
byte 4 1060152279
byte 4 0
byte 4 1065353216
byte 4 1065353216
byte 4 1045220557
byte 4 1045220557
byte 4 1065353216
byte 4 1056964608
byte 4 1056964608
byte 4 1056964608
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
code
proc CG_DrawStatusBar 80 32
line 525
;517:
;518:/*
;519:================
;520:CG_DrawStatusBar
;521:
;522:================
;523:*/
;524:#ifndef MISSIONPACK
;525:static void CG_DrawStatusBar( void ) {
line 543
;526:	int			color;
;527:	centity_t	*cent;
;528:	playerState_t	*ps;
;529:	int			value;
;530:	vec4_t		hcolor;
;531:	vec3_t		angles;
;532:	vec3_t		origin;
;533:#ifdef MISSIONPACK
;534:	qhandle_t	handle;
;535:#endif
;536:	static float colors[4][4] = { 
;537://		{ 0.2, 1.0, 0.2, 1.0 } , { 1.0, 0.2, 0.2, 1.0 }, {0.5, 0.5, 0.5, 1} };
;538:		{ 1.0f, 0.69f, 0.0f, 1.0f },    // normal
;539:		{ 1.0f, 0.2f, 0.2f, 1.0f },     // low health
;540:		{ 0.5f, 0.5f, 0.5f, 1.0f },     // weapon firing
;541:		{ 1.0f, 1.0f, 1.0f, 1.0f } };   // health > 100
;542:
;543:	if ( cg_drawStatus.integer == 0 ) {
ADDRGP4 cg_drawStatus+12
INDIRI4
CNSTI4 0
NEI4 $276
line 544
;544:		return;
ADDRGP4 $274
JUMPV
LABELV $276
line 548
;545:	}
;546:
;547:	// draw the team background
;548:	CG_DrawTeamBackground( 0, 420, 640, 60, 0.33f, cg.snap->ps.persistant[PERS_TEAM] );
CNSTI4 0
ARGI4
CNSTI4 420
ARGI4
CNSTI4 640
ARGI4
CNSTI4 60
ARGI4
CNSTF4 1051260355
ARGF4
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawTeamBackground
CALLV
pop
line 550
;549:
;550:	cent = &cg_entities[cg.snap->ps.clientNum];
ADDRLP4 4
CNSTI4 728
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 551
;551:	ps = &cg.snap->ps;
ADDRLP4 20
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
line 553
;552:
;553:	VectorClear( angles );
ADDRLP4 56
CNSTF4 0
ASGNF4
ADDRLP4 8+8
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 8+4
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 8
ADDRLP4 56
INDIRF4
ASGNF4
line 556
;554:
;555:	// draw any 3D icons first, so the changes back to 2D are minimized
;556:	if ( cent->currentState.weapon && cg_weapons[ cent->currentState.weapon ].ammoModel ) {
ADDRLP4 60
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ASGNI4
ADDRLP4 64
CNSTI4 0
ASGNI4
ADDRLP4 60
INDIRI4
ADDRLP4 64
INDIRI4
EQI4 $284
CNSTI4 136
ADDRLP4 60
INDIRI4
MULI4
ADDRGP4 cg_weapons+76
ADDP4
INDIRI4
ADDRLP4 64
INDIRI4
EQI4 $284
line 557
;557:		origin[0] = 70;
ADDRLP4 24
CNSTF4 1116471296
ASGNF4
line 558
;558:		origin[1] = 0;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 559
;559:		origin[2] = 0;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 560
;560:		angles[YAW] = 90 + 20 * sin( cg.time / 1000.0 );
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ARGF4
ADDRLP4 68
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 8+4
CNSTF4 1101004800
ADDRLP4 68
INDIRF4
MULF4
CNSTF4 1119092736
ADDF4
ASGNF4
line 561
;561:		CG_Draw3DModel( CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE,
CNSTF4 1120403456
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 72
CNSTF4 1111490560
ASGNF4
ADDRLP4 72
INDIRF4
ARGF4
ADDRLP4 72
INDIRF4
ARGF4
CNSTI4 136
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons+76
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 24
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 563
;562:					   cg_weapons[ cent->currentState.weapon ].ammoModel, 0, origin, angles );
;563:	}
LABELV $284
line 565
;564:
;565:	CG_DrawStatusBarHead( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE );
CNSTF4 1133412352
ARGF4
ADDRGP4 CG_DrawStatusBarHead
CALLV
pop
line 567
;566:
;567:	if( cg.predictedPlayerState.powerups[PW_REDFLAG] ) {
ADDRGP4 cg+107636+312+28
INDIRI4
CNSTI4 0
EQI4 $292
line 568
;568:		CG_DrawStatusBarFlag( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE + ICON_SIZE, TEAM_RED );
CNSTF4 1134985216
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 CG_DrawStatusBarFlag
CALLV
pop
line 569
;569:	} else if( cg.predictedPlayerState.powerups[PW_BLUEFLAG] ) {
ADDRGP4 $293
JUMPV
LABELV $292
ADDRGP4 cg+107636+312+32
INDIRI4
CNSTI4 0
EQI4 $297
line 570
;570:		CG_DrawStatusBarFlag( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE + ICON_SIZE, TEAM_BLUE );
CNSTF4 1134985216
ARGF4
CNSTI4 2
ARGI4
ADDRGP4 CG_DrawStatusBarFlag
CALLV
pop
line 571
;571:	} else if( cg.predictedPlayerState.powerups[PW_NEUTRALFLAG] ) {
ADDRGP4 $298
JUMPV
LABELV $297
ADDRGP4 cg+107636+312+36
INDIRI4
CNSTI4 0
EQI4 $302
line 572
;572:		CG_DrawStatusBarFlag( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE + ICON_SIZE, TEAM_FREE );
CNSTF4 1134985216
ARGF4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStatusBarFlag
CALLV
pop
line 573
;573:	}
LABELV $302
LABELV $298
LABELV $293
line 575
;574:
;575:	if ( ps->stats[ STAT_ARMOR ] ) {
ADDRLP4 20
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
CNSTI4 0
EQI4 $307
line 576
;576:		origin[0] = 90;
ADDRLP4 24
CNSTF4 1119092736
ASGNF4
line 577
;577:		origin[1] = 0;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 578
;578:		origin[2] = -10;
ADDRLP4 24+8
CNSTF4 3240099840
ASGNF4
line 579
;579:		angles[YAW] = ( cg.time & 2047 ) * 360 / 2048.0;
ADDRLP4 8+4
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
line 580
;580:		CG_Draw3DModel( 370 + CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE,
CNSTF4 1139474432
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 68
CNSTF4 1111490560
ASGNF4
ADDRLP4 68
INDIRF4
ARGF4
ADDRLP4 68
INDIRF4
ARGF4
ADDRGP4 cgs+152340+120
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 24
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 582
;581:					   cgs.media.armorModel, 0, origin, angles );
;582:	}
LABELV $307
line 600
;583:#ifdef MISSIONPACK
;584:	if( cgs.gametype == GT_HARVESTER ) {
;585:		origin[0] = 90;
;586:		origin[1] = 0;
;587:		origin[2] = -10;
;588:		angles[YAW] = ( cg.time & 2047 ) * 360 / 2048.0;
;589:		if( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
;590:			handle = cgs.media.redCubeModel;
;591:		} else {
;592:			handle = cgs.media.blueCubeModel;
;593:		}
;594:		CG_Draw3DModel( 640 - (TEXT_ICON_SPACE + ICON_SIZE), 416, ICON_SIZE, ICON_SIZE, handle, 0, origin, angles );
;595:	}
;596:#endif
;597:	//
;598:	// ammo
;599:	//
;600:	if ( cent->currentState.weapon ) {
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 0
EQI4 $315
line 601
;601:		value = ps->ammo[cent->currentState.weapon];
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 20
INDIRP4
CNSTI4 376
ADDP4
ADDP4
INDIRI4
ASGNI4
line 602
;602:		if ( value > -1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 -1
LEI4 $317
line 603
;603:			if ( cg.predictedPlayerState.weaponstate == WEAPON_FIRING
ADDRGP4 cg+107636+148
INDIRI4
CNSTI4 3
NEI4 $319
ADDRGP4 cg+107636+44
INDIRI4
CNSTI4 100
LEI4 $319
line 604
;604:				&& cg.predictedPlayerState.weaponTime > 100 ) {
line 606
;605:				// draw as dark grey when reloading
;606:				color = 2;	// dark grey
ADDRLP4 52
CNSTI4 2
ASGNI4
line 607
;607:			} else {
ADDRGP4 $320
JUMPV
LABELV $319
line 608
;608:				if ( value >= 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $325
line 609
;609:					color = 0;	// green
ADDRLP4 52
CNSTI4 0
ASGNI4
line 610
;610:				} else {
ADDRGP4 $326
JUMPV
LABELV $325
line 611
;611:					color = 1;	// red
ADDRLP4 52
CNSTI4 1
ASGNI4
line 612
;612:				}
LABELV $326
line 613
;613:			}
LABELV $320
line 614
;614:			trap_R_SetColor( colors[color] );
ADDRLP4 52
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 $275
ADDP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 616
;615:			
;616:			CG_DrawField (0, 432, 3, value);
CNSTI4 0
ARGI4
CNSTI4 432
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 617
;617:			trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 620
;618:
;619:			// if we didn't draw a 3D icon, draw a 2D icon for ammo
;620:			if ( !cg_draw3dIcons.integer && cg_drawIcons.integer ) {
ADDRLP4 68
CNSTI4 0
ASGNI4
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
NEI4 $327
ADDRGP4 cg_drawIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
EQI4 $327
line 623
;621:				qhandle_t	icon;
;622:
;623:				icon = cg_weapons[ cg.predictedPlayerState.weapon ].ammoIcon;
ADDRLP4 72
CNSTI4 136
ADDRGP4 cg+107636+144
INDIRI4
MULI4
ADDRGP4 cg_weapons+72
ADDP4
INDIRI4
ASGNI4
line 624
;624:				if ( icon ) {
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $334
line 625
;625:					CG_DrawPic( CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE, icon );
CNSTF4 1120403456
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 76
CNSTF4 1111490560
ASGNF4
ADDRLP4 76
INDIRF4
ARGF4
ADDRLP4 76
INDIRF4
ARGF4
ADDRLP4 72
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 626
;626:				}
LABELV $334
line 627
;627:			}
LABELV $327
line 628
;628:		}
LABELV $317
line 629
;629:	}
LABELV $315
line 634
;630:
;631:	//
;632:	// health
;633:	//
;634:	value = ps->stats[STAT_HEALTH];
ADDRLP4 0
ADDRLP4 20
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 635
;635:	if ( value > 100 ) {
ADDRLP4 0
INDIRI4
CNSTI4 100
LEI4 $336
line 636
;636:		trap_R_SetColor( colors[3] );		// white
ADDRGP4 $275+48
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 637
;637:	} else if (value > 25) {
ADDRGP4 $337
JUMPV
LABELV $336
ADDRLP4 0
INDIRI4
CNSTI4 25
LEI4 $339
line 638
;638:		trap_R_SetColor( colors[0] );	// green
ADDRGP4 $275
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 639
;639:	} else if (value > 0) {
ADDRGP4 $340
JUMPV
LABELV $339
ADDRLP4 0
INDIRI4
CNSTI4 0
LEI4 $341
line 640
;640:		color = (cg.time >> 8) & 1;	// flash
ADDRLP4 52
ADDRGP4 cg+107604
INDIRI4
CNSTI4 8
RSHI4
CNSTI4 1
BANDI4
ASGNI4
line 641
;641:		trap_R_SetColor( colors[color] );
ADDRLP4 52
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 $275
ADDP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 642
;642:	} else {
ADDRGP4 $342
JUMPV
LABELV $341
line 643
;643:		trap_R_SetColor( colors[1] );	// red
ADDRGP4 $275+16
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 644
;644:	}
LABELV $342
LABELV $340
LABELV $337
line 647
;645:
;646:	// stretch the health up when taking damage
;647:	CG_DrawField ( 185, 432, 3, value);
CNSTI4 185
ARGI4
CNSTI4 432
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 648
;648:	CG_ColorForHealth( hcolor );
ADDRLP4 36
ARGP4
ADDRGP4 CG_ColorForHealth
CALLV
pop
line 649
;649:	trap_R_SetColor( hcolor );
ADDRLP4 36
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 655
;650:
;651:
;652:	//
;653:	// armor
;654:	//
;655:	value = ps->stats[STAT_ARMOR];
ADDRLP4 0
ADDRLP4 20
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ASGNI4
line 656
;656:	if (value > 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LEI4 $345
line 657
;657:		trap_R_SetColor( colors[0] );
ADDRGP4 $275
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 658
;658:		CG_DrawField (370, 432, 3, value);
CNSTI4 370
ARGI4
CNSTI4 432
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 659
;659:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 661
;660:		// if we didn't draw a 3D icon, draw a 2D icon for armor
;661:		if ( !cg_draw3dIcons.integer && cg_drawIcons.integer ) {
ADDRLP4 68
CNSTI4 0
ASGNI4
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
NEI4 $347
ADDRGP4 cg_drawIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
EQI4 $347
line 662
;662:			CG_DrawPic( 370 + CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE, cgs.media.armorIcon );
CNSTF4 1139474432
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 72
CNSTF4 1111490560
ASGNF4
ADDRLP4 72
INDIRF4
ARGF4
ADDRLP4 72
INDIRF4
ARGF4
ADDRGP4 cgs+152340+124
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 663
;663:		}
LABELV $347
line 665
;664:
;665:	}
LABELV $345
line 689
;666:#ifdef MISSIONPACK
;667:	//
;668:	// cubes
;669:	//
;670:	if( cgs.gametype == GT_HARVESTER ) {
;671:		value = ps->generic1;
;672:		if( value > 99 ) {
;673:			value = 99;
;674:		}
;675:		trap_R_SetColor( colors[0] );
;676:		CG_DrawField (640 - (CHAR_WIDTH*2 + TEXT_ICON_SPACE + ICON_SIZE), 432, 2, value);
;677:		trap_R_SetColor( NULL );
;678:		// if we didn't draw a 3D icon, draw a 2D icon for armor
;679:		if ( !cg_draw3dIcons.integer && cg_drawIcons.integer ) {
;680:			if( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
;681:				handle = cgs.media.redCubeIcon;
;682:			} else {
;683:				handle = cgs.media.blueCubeIcon;
;684:			}
;685:			CG_DrawPic( 640 - (TEXT_ICON_SPACE + ICON_SIZE), 432, ICON_SIZE, ICON_SIZE, handle );
;686:		}
;687:	}
;688:#endif
;689:}
LABELV $274
endproc CG_DrawStatusBar 80 32
proc CG_DrawAttacker 52 24
line 706
;690:#endif
;691:
;692:/*
;693:===========================================================================================
;694:
;695:  UPPER RIGHT CORNER
;696:
;697:===========================================================================================
;698:*/
;699:
;700:/*
;701:================
;702:CG_DrawAttacker
;703:
;704:================
;705:*/
;706:static float CG_DrawAttacker( float y ) {
line 714
;707:	int			t;
;708:	float		size;
;709:	vec3_t		angles;
;710:	const char	*info;
;711:	const char	*name;
;712:	int			clientNum;
;713:
;714:	if ( cg.predictedPlayerState.stats[STAT_HEALTH] <= 0 ) {
ADDRGP4 cg+107636+184
INDIRI4
CNSTI4 0
GTI4 $354
line 715
;715:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $353
JUMPV
LABELV $354
line 718
;716:	}
;717:
;718:	if ( !cg.attackerTime ) {
ADDRGP4 cg+124416
INDIRI4
CNSTI4 0
NEI4 $358
line 719
;719:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $353
JUMPV
LABELV $358
line 722
;720:	}
;721:
;722:	clientNum = cg.predictedPlayerState.persistant[PERS_ATTACKER];
ADDRLP4 0
ADDRGP4 cg+107636+248+24
INDIRI4
ASGNI4
line 723
;723:	if ( clientNum < 0 || clientNum >= MAX_CLIENTS || clientNum == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $368
ADDRLP4 0
INDIRI4
CNSTI4 64
GEI4 $368
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $364
LABELV $368
line 724
;724:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $353
JUMPV
LABELV $364
line 727
;725:	}
;726:
;727:	t = cg.time - cg.attackerTime;
ADDRLP4 24
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124416
INDIRI4
SUBI4
ASGNI4
line 728
;728:	if ( t > ATTACKER_HEAD_TIME ) {
ADDRLP4 24
INDIRI4
CNSTI4 10000
LEI4 $371
line 729
;729:		cg.attackerTime = 0;
ADDRGP4 cg+124416
CNSTI4 0
ASGNI4
line 730
;730:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $353
JUMPV
LABELV $371
line 733
;731:	}
;732:
;733:	size = ICON_SIZE * 1.25;
ADDRLP4 4
CNSTF4 1114636288
ASGNF4
line 735
;734:
;735:	angles[PITCH] = 0;
ADDRLP4 8
CNSTF4 0
ASGNF4
line 736
;736:	angles[YAW] = 180;
ADDRLP4 8+4
CNSTF4 1127481344
ASGNF4
line 737
;737:	angles[ROLL] = 0;
ADDRLP4 8+8
CNSTF4 0
ASGNF4
line 738
;738:	CG_DrawHead( 640 - size, y, size, size, clientNum, angles );
CNSTF4 1142947840
ADDRLP4 4
INDIRF4
SUBF4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ARGP4
ADDRGP4 CG_DrawHead
CALLV
pop
line 740
;739:
;740:	info = CG_ConfigString( CS_PLAYERS + clientNum );
ADDRLP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 40
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 40
INDIRP4
ASGNP4
line 741
;741:	name = Info_ValueForKey(  info, "n" );
ADDRLP4 28
INDIRP4
ARGP4
ADDRGP4 $376
ARGP4
ADDRLP4 44
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 44
INDIRP4
ASGNP4
line 742
;742:	y += size;
ADDRFP4 0
ADDRFP4 0
INDIRF4
ADDRLP4 4
INDIRF4
ADDF4
ASGNF4
line 743
;743:	CG_DrawBigString( 640 - ( Q_PrintStrlen( name ) * BIGCHAR_WIDTH), y, name, 0.5 );
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 48
ADDRGP4 Q_PrintStrlen
CALLI4
ASGNI4
CNSTI4 640
ADDRLP4 48
INDIRI4
CNSTI4 4
LSHI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 20
INDIRP4
ARGP4
CNSTF4 1056964608
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 745
;744:
;745:	return y + BIGCHAR_HEIGHT + 2;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1073741824
ADDF4
RETF4
LABELV $353
endproc CG_DrawAttacker 52 24
proc CG_DrawSnapshot 16 16
line 753
;746:}
;747:
;748:/*
;749:==================
;750:CG_DrawSnapshot
;751:==================
;752:*/
;753:static float CG_DrawSnapshot( float y ) {
line 757
;754:	char		*s;
;755:	int			w;
;756:
;757:	s = va( "time:%i snap:%i cmd:%i", cg.snap->serverTime, 
ADDRGP4 $378
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 cg+28
INDIRI4
ARGI4
ADDRGP4 cgs+31444
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 759
;758:		cg.latestSnapshotNum, cgs.serverCommandSequence );
;759:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 761
;760:
;761:	CG_DrawBigString( 635 - w, y + 2, s, 1.0F);
CNSTI4 635
ADDRLP4 4
INDIRI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CNSTF4 1073741824
ADDF4
CVFI4 4
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 763
;762:
;763:	return y + BIGCHAR_HEIGHT + 4;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1082130432
ADDF4
RETF4
LABELV $377
endproc CG_DrawSnapshot 16 16
bss
align 4
LABELV $383
skip 16
align 4
LABELV $384
skip 4
align 4
LABELV $385
skip 4
code
proc CG_DrawFPS 44 16
line 772
;764:}
;765:
;766:/*
;767:==================
;768:CG_DrawFPS
;769:==================
;770:*/
;771:#define	FPS_FRAMES	4
;772:static float CG_DrawFPS( float y ) {
line 784
;773:	char		*s;
;774:	int			w;
;775:	static int	previousTimes[FPS_FRAMES];
;776:	static int	index;
;777:	int		i, total;
;778:	int		fps;
;779:	static	int	previous;
;780:	int		t, frameTime;
;781:
;782:	// don't use serverTime, because that will be drifting to
;783:	// correct for internet lag changes, timescales, timedemos, etc
;784:	t = trap_Milliseconds();
ADDRLP4 28
ADDRGP4 trap_Milliseconds
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 28
INDIRI4
ASGNI4
line 785
;785:	frameTime = t - previous;
ADDRLP4 12
ADDRLP4 8
INDIRI4
ADDRGP4 $385
INDIRI4
SUBI4
ASGNI4
line 786
;786:	previous = t;
ADDRGP4 $385
ADDRLP4 8
INDIRI4
ASGNI4
line 788
;787:
;788:	previousTimes[index % FPS_FRAMES] = frameTime;
ADDRGP4 $384
INDIRI4
CNSTI4 4
MODI4
CNSTI4 2
LSHI4
ADDRGP4 $383
ADDP4
ADDRLP4 12
INDIRI4
ASGNI4
line 789
;789:	index++;
ADDRLP4 32
ADDRGP4 $384
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 790
;790:	if ( index > FPS_FRAMES ) {
ADDRGP4 $384
INDIRI4
CNSTI4 4
LEI4 $386
line 792
;791:		// average multiple frames together to smooth changes out a bit
;792:		total = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 793
;793:		for ( i = 0 ; i < FPS_FRAMES ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $388
line 794
;794:			total += previousTimes[i];
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $383
ADDP4
INDIRI4
ADDI4
ASGNI4
line 795
;795:		}
LABELV $389
line 793
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $388
line 796
;796:		if ( !total ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $392
line 797
;797:			total = 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 798
;798:		}
LABELV $392
line 799
;799:		fps = 1000 * FPS_FRAMES / total;
ADDRLP4 24
CNSTI4 4000
ADDRLP4 4
INDIRI4
DIVI4
ASGNI4
line 801
;800:
;801:		s = va( "%ifps", fps );
ADDRGP4 $394
ARGP4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 36
INDIRP4
ASGNP4
line 802
;802:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 40
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 804
;803:
;804:		CG_DrawBigString( 635 - w, y + 2, s, 1.0F);
CNSTI4 635
ADDRLP4 20
INDIRI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CNSTF4 1073741824
ADDF4
CVFI4 4
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 805
;805:	}
LABELV $386
line 807
;806:
;807:	return y + BIGCHAR_HEIGHT + 4;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1082130432
ADDF4
RETF4
LABELV $382
endproc CG_DrawFPS 44 16
proc CG_DrawTimer 32 16
line 815
;808:}
;809:
;810:/*
;811:=================
;812:CG_DrawTimer
;813:=================
;814:*/
;815:static float CG_DrawTimer( float y ) {
line 821
;816:	char		*s;
;817:	int			w;
;818:	int			mins, seconds, tens;
;819:	int			msec;
;820:
;821:	msec = cg.time - cgs.levelStartTime;
ADDRLP4 20
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cgs+34796
INDIRI4
SUBI4
ASGNI4
line 823
;822:
;823:	seconds = msec / 1000;
ADDRLP4 0
ADDRLP4 20
INDIRI4
CNSTI4 1000
DIVI4
ASGNI4
line 824
;824:	mins = seconds / 60;
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 60
DIVI4
ASGNI4
line 825
;825:	seconds -= mins * 60;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 60
ADDRLP4 8
INDIRI4
MULI4
SUBI4
ASGNI4
line 826
;826:	tens = seconds / 10;
ADDRLP4 12
ADDRLP4 0
INDIRI4
CNSTI4 10
DIVI4
ASGNI4
line 827
;827:	seconds -= tens * 10;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 10
ADDRLP4 12
INDIRI4
MULI4
SUBI4
ASGNI4
line 829
;828:
;829:	s = va( "%i:%i%i", mins, tens, seconds );
ADDRGP4 $398
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 24
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 24
INDIRP4
ASGNP4
line 830
;830:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 28
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 832
;831:
;832:	CG_DrawBigString( 635 - w, y + 2, s, 1.0F);
CNSTI4 635
ADDRLP4 16
INDIRI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CNSTF4 1073741824
ADDF4
CVFI4 4
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 834
;833:
;834:	return y + BIGCHAR_HEIGHT + 4;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1082130432
ADDF4
RETF4
LABELV $395
endproc CG_DrawTimer 32 16
proc CG_DrawTeamOverlay 148 36
line 844
;835:}
;836:
;837:
;838:/*
;839:=================
;840:CG_DrawTeamOverlay
;841:=================
;842:*/
;843:
;844:static float CG_DrawTeamOverlay( float y, qboolean right, qboolean upper ) {
line 856
;845:	int x, w, h, xx;
;846:	int i, j, len;
;847:	const char *p;
;848:	vec4_t		hcolor;
;849:	int pwidth, lwidth;
;850:	int plyrs;
;851:	char st[16];
;852:	clientInfo_t *ci;
;853:	gitem_t	*item;
;854:	int ret_y, count;
;855:
;856:	if ( !cg_drawTeamOverlay.integer ) {
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
CNSTI4 0
NEI4 $400
line 857
;857:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $399
JUMPV
LABELV $400
line 860
;858:	}
;859:
;860:	if ( cg.snap->ps.persistant[PERS_TEAM] != TEAM_RED && cg.snap->ps.persistant[PERS_TEAM] != TEAM_BLUE ) {
ADDRLP4 92
CNSTI4 304
ASGNI4
ADDRGP4 cg+36
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRI4
CNSTI4 1
EQI4 $403
ADDRGP4 cg+36
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRI4
CNSTI4 2
EQI4 $403
line 861
;861:		return y; // Not on any team
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $399
JUMPV
LABELV $403
line 864
;862:	}
;863:
;864:	plyrs = 0;
ADDRLP4 76
CNSTI4 0
ASGNI4
line 867
;865:
;866:	// max player name width
;867:	pwidth = 0;
ADDRLP4 56
CNSTI4 0
ASGNI4
line 868
;868:	count = (numSortedTeamPlayers > 8) ? 8 : numSortedTeamPlayers;
ADDRGP4 numSortedTeamPlayers
INDIRI4
CNSTI4 8
LEI4 $408
ADDRLP4 96
CNSTI4 8
ASGNI4
ADDRGP4 $409
JUMPV
LABELV $408
ADDRLP4 96
ADDRGP4 numSortedTeamPlayers
INDIRI4
ASGNI4
LABELV $409
ADDRLP4 48
ADDRLP4 96
INDIRI4
ASGNI4
line 869
;869:	for (i = 0; i < count; i++) {
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $413
JUMPV
LABELV $410
line 870
;870:		ci = cgs.clientinfo + sortedTeamPlayers[i];
ADDRLP4 4
CNSTI4 1708
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 sortedTeamPlayers
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 871
;871:		if ( ci->infoValid && ci->team == cg.snap->ps.persistant[PERS_TEAM]) {
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $415
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
NEI4 $415
line 872
;872:			plyrs++;
ADDRLP4 76
ADDRLP4 76
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 873
;873:			len = CG_DrawStrlen(ci->name);
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRLP4 104
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 104
INDIRI4
ASGNI4
line 874
;874:			if (len > pwidth)
ADDRLP4 40
INDIRI4
ADDRLP4 56
INDIRI4
LEI4 $418
line 875
;875:				pwidth = len;
ADDRLP4 56
ADDRLP4 40
INDIRI4
ASGNI4
LABELV $418
line 876
;876:		}
LABELV $415
line 877
;877:	}
LABELV $411
line 869
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $413
ADDRLP4 8
INDIRI4
ADDRLP4 48
INDIRI4
LTI4 $410
line 879
;878:
;879:	if (!plyrs)
ADDRLP4 76
INDIRI4
CNSTI4 0
NEI4 $420
line 880
;880:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $399
JUMPV
LABELV $420
line 882
;881:
;882:	if (pwidth > TEAM_OVERLAY_MAXNAME_WIDTH)
ADDRLP4 56
INDIRI4
CNSTI4 12
LEI4 $422
line 883
;883:		pwidth = TEAM_OVERLAY_MAXNAME_WIDTH;
ADDRLP4 56
CNSTI4 12
ASGNI4
LABELV $422
line 886
;884:
;885:	// max location name width
;886:	lwidth = 0;
ADDRLP4 44
CNSTI4 0
ASGNI4
line 887
;887:	for (i = 1; i < MAX_LOCATIONS; i++) {
ADDRLP4 8
CNSTI4 1
ASGNI4
LABELV $424
line 888
;888:		p = CG_ConfigString(CS_LOCATIONS + i);
ADDRLP4 8
INDIRI4
CNSTI4 608
ADDI4
ARGI4
ADDRLP4 100
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 100
INDIRP4
ASGNP4
line 889
;889:		if (p && *p) {
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $428
ADDRLP4 20
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $428
line 890
;890:			len = CG_DrawStrlen(p);
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 108
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 108
INDIRI4
ASGNI4
line 891
;891:			if (len > lwidth)
ADDRLP4 40
INDIRI4
ADDRLP4 44
INDIRI4
LEI4 $430
line 892
;892:				lwidth = len;
ADDRLP4 44
ADDRLP4 40
INDIRI4
ASGNI4
LABELV $430
line 893
;893:		}
LABELV $428
line 894
;894:	}
LABELV $425
line 887
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 64
LTI4 $424
line 896
;895:
;896:	if (lwidth > TEAM_OVERLAY_MAXLOCATION_WIDTH)
ADDRLP4 44
INDIRI4
CNSTI4 16
LEI4 $432
line 897
;897:		lwidth = TEAM_OVERLAY_MAXLOCATION_WIDTH;
ADDRLP4 44
CNSTI4 16
ASGNI4
LABELV $432
line 899
;898:
;899:	w = (pwidth + lwidth + 4 + 7) * TINYCHAR_WIDTH;
ADDRLP4 80
ADDRLP4 56
INDIRI4
ADDRLP4 44
INDIRI4
ADDI4
CNSTI4 3
LSHI4
CNSTI4 32
ADDI4
CNSTI4 56
ADDI4
ASGNI4
line 901
;900:
;901:	if ( right )
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $434
line 902
;902:		x = 640 - w;
ADDRLP4 52
CNSTI4 640
ADDRLP4 80
INDIRI4
SUBI4
ASGNI4
ADDRGP4 $435
JUMPV
LABELV $434
line 904
;903:	else
;904:		x = 0;
ADDRLP4 52
CNSTI4 0
ASGNI4
LABELV $435
line 906
;905:
;906:	h = plyrs * TINYCHAR_HEIGHT;
ADDRLP4 84
ADDRLP4 76
INDIRI4
CNSTI4 3
LSHI4
ASGNI4
line 908
;907:
;908:	if ( upper ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
EQI4 $436
line 909
;909:		ret_y = y + h;
ADDRLP4 88
ADDRFP4 0
INDIRF4
ADDRLP4 84
INDIRI4
CVIF4 4
ADDF4
CVFI4 4
ASGNI4
line 910
;910:	} else {
ADDRGP4 $437
JUMPV
LABELV $436
line 911
;911:		y -= h;
ADDRFP4 0
ADDRFP4 0
INDIRF4
ADDRLP4 84
INDIRI4
CVIF4 4
SUBF4
ASGNF4
line 912
;912:		ret_y = y;
ADDRLP4 88
ADDRFP4 0
INDIRF4
CVFI4 4
ASGNI4
line 913
;913:	}
LABELV $437
line 915
;914:
;915:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_RED ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 1
NEI4 $438
line 916
;916:		hcolor[0] = 1.0f;
ADDRLP4 24
CNSTF4 1065353216
ASGNF4
line 917
;917:		hcolor[1] = 0.0f;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 918
;918:		hcolor[2] = 0.0f;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 919
;919:		hcolor[3] = 0.33f;
ADDRLP4 24+12
CNSTF4 1051260355
ASGNF4
line 920
;920:	} else { // if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE )
ADDRGP4 $439
JUMPV
LABELV $438
line 921
;921:		hcolor[0] = 0.0f;
ADDRLP4 24
CNSTF4 0
ASGNF4
line 922
;922:		hcolor[1] = 0.0f;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 923
;923:		hcolor[2] = 1.0f;
ADDRLP4 24+8
CNSTF4 1065353216
ASGNF4
line 924
;924:		hcolor[3] = 0.33f;
ADDRLP4 24+12
CNSTF4 1051260355
ASGNF4
line 925
;925:	}
LABELV $439
line 926
;926:	trap_R_SetColor( hcolor );
ADDRLP4 24
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 927
;927:	CG_DrawPic( x, y, w, h, cgs.media.teamStatusBar );
ADDRLP4 52
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 80
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 cgs+152340+128
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 928
;928:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 930
;929:
;930:	for (i = 0; i < count; i++) {
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $452
JUMPV
LABELV $449
line 931
;931:		ci = cgs.clientinfo + sortedTeamPlayers[i];
ADDRLP4 4
CNSTI4 1708
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 sortedTeamPlayers
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 932
;932:		if ( ci->infoValid && ci->team == cg.snap->ps.persistant[PERS_TEAM]) {
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $454
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
NEI4 $454
line 934
;933:
;934:			hcolor[0] = hcolor[1] = hcolor[2] = hcolor[3] = 1.0;
ADDRLP4 104
CNSTF4 1065353216
ASGNF4
ADDRLP4 24+12
ADDRLP4 104
INDIRF4
ASGNF4
ADDRLP4 24+8
ADDRLP4 104
INDIRF4
ASGNF4
ADDRLP4 24+4
ADDRLP4 104
INDIRF4
ASGNF4
ADDRLP4 24
ADDRLP4 104
INDIRF4
ASGNF4
line 936
;935:
;936:			xx = x + TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 52
INDIRI4
CNSTI4 8
ADDI4
ASGNI4
line 938
;937:
;938:			CG_DrawStringExt( xx, y,
ADDRLP4 12
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 108
CNSTI4 0
ASGNI4
ADDRLP4 108
INDIRI4
ARGI4
ADDRLP4 108
INDIRI4
ARGI4
ADDRLP4 112
CNSTI4 8
ASGNI4
ADDRLP4 112
INDIRI4
ARGI4
ADDRLP4 112
INDIRI4
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 942
;939:				ci->name, hcolor, qfalse, qfalse,
;940:				TINYCHAR_WIDTH, TINYCHAR_HEIGHT, TEAM_OVERLAY_MAXNAME_WIDTH);
;941:
;942:			if (lwidth) {
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $460
line 943
;943:				p = CG_ConfigString(CS_LOCATIONS + ci->location);
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
CNSTI4 608
ADDI4
ARGI4
ADDRLP4 116
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 116
INDIRP4
ASGNP4
line 944
;944:				if (!p || !*p)
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $464
ADDRLP4 20
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $462
LABELV $464
line 945
;945:					p = "unknown";
ADDRLP4 20
ADDRGP4 $465
ASGNP4
LABELV $462
line 946
;946:				len = CG_DrawStrlen(p);
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 124
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 124
INDIRI4
ASGNI4
line 947
;947:				if (len > lwidth)
ADDRLP4 40
INDIRI4
ADDRLP4 44
INDIRI4
LEI4 $466
line 948
;948:					len = lwidth;
ADDRLP4 40
ADDRLP4 44
INDIRI4
ASGNI4
LABELV $466
line 952
;949:
;950://				xx = x + TINYCHAR_WIDTH * 2 + TINYCHAR_WIDTH * pwidth + 
;951://					((lwidth/2 - len/2) * TINYCHAR_WIDTH);
;952:				xx = x + TINYCHAR_WIDTH * 2 + TINYCHAR_WIDTH * pwidth;
ADDRLP4 12
ADDRLP4 52
INDIRI4
CNSTI4 16
ADDI4
ADDRLP4 56
INDIRI4
CNSTI4 3
LSHI4
ADDI4
ASGNI4
line 953
;953:				CG_DrawStringExt( xx, y,
ADDRLP4 12
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 128
CNSTI4 0
ASGNI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 132
CNSTI4 8
ASGNI4
ADDRLP4 132
INDIRI4
ARGI4
ADDRLP4 132
INDIRI4
ARGI4
CNSTI4 16
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 956
;954:					p, hcolor, qfalse, qfalse, TINYCHAR_WIDTH, TINYCHAR_HEIGHT,
;955:					TEAM_OVERLAY_MAXLOCATION_WIDTH);
;956:			}
LABELV $460
line 958
;957:
;958:			CG_GetColorForHealth( ci->health, ci->armor, hcolor );
ADDRLP4 4
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
INDIRI4
ARGI4
ADDRLP4 24
ARGP4
ADDRGP4 CG_GetColorForHealth
CALLV
pop
line 960
;959:
;960:			Com_sprintf (st, sizeof(st), "%3i %3i", ci->health,	ci->armor);
ADDRLP4 60
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 $468
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 962
;961:
;962:			xx = x + TINYCHAR_WIDTH * 3 + 
ADDRLP4 124
CNSTI4 3
ASGNI4
ADDRLP4 12
ADDRLP4 52
INDIRI4
CNSTI4 24
ADDI4
ADDRLP4 56
INDIRI4
ADDRLP4 124
INDIRI4
LSHI4
ADDI4
ADDRLP4 44
INDIRI4
ADDRLP4 124
INDIRI4
LSHI4
ADDI4
ASGNI4
line 965
;963:				TINYCHAR_WIDTH * pwidth + TINYCHAR_WIDTH * lwidth;
;964:
;965:			CG_DrawStringExt( xx, y,
ADDRLP4 12
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 60
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 128
CNSTI4 0
ASGNI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 132
CNSTI4 8
ASGNI4
ADDRLP4 132
INDIRI4
ARGI4
ADDRLP4 132
INDIRI4
ARGI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 970
;966:				st, hcolor, qfalse, qfalse,
;967:				TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 0 );
;968:
;969:			// draw weapon icon
;970:			xx += TINYCHAR_WIDTH * 3;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 24
ADDI4
ASGNI4
line 972
;971:
;972:			if ( cg_weapons[ci->curWeapon].weaponIcon ) {
CNSTI4 136
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons+68
ADDP4
INDIRI4
CNSTI4 0
EQI4 $469
line 973
;973:				CG_DrawPic( xx, y, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 136
CNSTF4 1090519040
ASGNF4
ADDRLP4 136
INDIRF4
ARGF4
ADDRLP4 136
INDIRF4
ARGF4
CNSTI4 136
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons+68
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 975
;974:					cg_weapons[ci->curWeapon].weaponIcon );
;975:			} else {
ADDRGP4 $470
JUMPV
LABELV $469
line 976
;976:				CG_DrawPic( xx, y, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 136
CNSTF4 1090519040
ASGNF4
ADDRLP4 136
INDIRF4
ARGF4
ADDRLP4 136
INDIRF4
ARGF4
ADDRGP4 cgs+152340+132
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 978
;977:					cgs.media.deferShader );
;978:			}
LABELV $470
line 981
;979:
;980:			// Draw powerup icons
;981:			if (right) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $475
line 982
;982:				xx = x;
ADDRLP4 12
ADDRLP4 52
INDIRI4
ASGNI4
line 983
;983:			} else {
ADDRGP4 $476
JUMPV
LABELV $475
line 984
;984:				xx = x + w - TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 52
INDIRI4
ADDRLP4 80
INDIRI4
ADDI4
CNSTI4 8
SUBI4
ASGNI4
line 985
;985:			}
LABELV $476
line 986
;986:			for (j = 0; j <= PW_NUM_POWERUPS; j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $477
line 987
;987:				if (ci->powerups & (1 << j)) {
ADDRLP4 4
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
CNSTI4 1
ADDRLP4 0
INDIRI4
LSHI4
BANDI4
CNSTI4 0
EQI4 $481
line 989
;988:
;989:					item = BG_FindItemForPowerup( j );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 136
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 136
INDIRP4
ASGNP4
line 991
;990:
;991:					if (item) {
ADDRLP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $483
line 992
;992:						CG_DrawPic( xx, y, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 
ADDRLP4 16
INDIRP4
CNSTI4 24
ADDP4
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 144
CNSTF4 1090519040
ASGNF4
ADDRLP4 144
INDIRF4
ARGF4
ADDRLP4 144
INDIRF4
ARGF4
ADDRLP4 140
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 994
;993:						trap_R_RegisterShader( item->icon ) );
;994:						if (right) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $485
line 995
;995:							xx -= TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 8
SUBI4
ASGNI4
line 996
;996:						} else {
ADDRGP4 $486
JUMPV
LABELV $485
line 997
;997:							xx += TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 8
ADDI4
ASGNI4
line 998
;998:						}
LABELV $486
line 999
;999:					}
LABELV $483
line 1000
;1000:				}
LABELV $481
line 1001
;1001:			}
LABELV $478
line 986
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 15
LEI4 $477
line 1003
;1002:
;1003:			y += TINYCHAR_HEIGHT;
ADDRFP4 0
ADDRFP4 0
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 1004
;1004:		}
LABELV $454
line 1005
;1005:	}
LABELV $450
line 930
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $452
ADDRLP4 8
INDIRI4
ADDRLP4 48
INDIRI4
LTI4 $449
line 1007
;1006:
;1007:	return ret_y;
ADDRLP4 88
INDIRI4
CVIF4 4
RETF4
LABELV $399
endproc CG_DrawTeamOverlay 148 36
proc CG_DrawUpperRight 12 12
line 1018
;1008://#endif
;1009:}
;1010:
;1011:
;1012:/*
;1013:=====================
;1014:CG_DrawUpperRight
;1015:
;1016:=====================
;1017:*/
;1018:static void CG_DrawUpperRight( void ) {
line 1021
;1019:	float	y;
;1020:
;1021:	y = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1023
;1022:
;1023:	if ( cgs.gametype >= GT_TEAM && cg_drawTeamOverlay.integer == 1 ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $488
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
CNSTI4 1
NEI4 $488
line 1024
;1024:		y = CG_DrawTeamOverlay( y, qtrue, qtrue );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 CG_DrawTeamOverlay
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 8
INDIRF4
ASGNF4
line 1025
;1025:	} 
LABELV $488
line 1026
;1026:	if ( cg_drawSnapshot.integer ) {
ADDRGP4 cg_drawSnapshot+12
INDIRI4
CNSTI4 0
EQI4 $492
line 1027
;1027:		y = CG_DrawSnapshot( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawSnapshot
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1028
;1028:	}
LABELV $492
line 1029
;1029:	if ( cg_drawFPS.integer ) {
ADDRGP4 cg_drawFPS+12
INDIRI4
CNSTI4 0
EQI4 $495
line 1030
;1030:		y = CG_DrawFPS( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawFPS
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1031
;1031:	}
LABELV $495
line 1032
;1032:	if ( cg_drawTimer.integer ) {
ADDRGP4 cg_drawTimer+12
INDIRI4
CNSTI4 0
EQI4 $498
line 1033
;1033:		y = CG_DrawTimer( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawTimer
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1034
;1034:	}
LABELV $498
line 1035
;1035:	if ( cg_drawAttacker.integer ) {
ADDRGP4 cg_drawAttacker+12
INDIRI4
CNSTI4 0
EQI4 $501
line 1036
;1036:		y = CG_DrawAttacker( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawAttacker
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1037
;1037:	}
LABELV $501
line 1039
;1038:
;1039:}
LABELV $487
endproc CG_DrawUpperRight 12 12
proc CG_DrawScores 92 20
line 1057
;1040:
;1041:/*
;1042:===========================================================================================
;1043:
;1044:  LOWER RIGHT CORNER
;1045:
;1046:===========================================================================================
;1047:*/
;1048:
;1049:/*
;1050:=================
;1051:CG_DrawScores
;1052:
;1053:Draw the small two score display
;1054:=================
;1055:*/
;1056:#ifndef MISSIONPACK
;1057:static float CG_DrawScores( float y ) {
line 1071
;1058:	const char	*s;
;1059:	const char	*serverInfo;
;1060:	int		s1, s2, score;
;1061:	int		x, w;
;1062:	int		v;
;1063:	vec4_t		color;
;1064:	float		y1;
;1065:	gitem_t		*item;
;1066:
;1067:	/*
;1068:	 * Hide the small team frag counter in both One Life modes.
;1069:	 * g_oneLifeTDM is transmitted through CS_SERVERINFO.
;1070:	 */
;1071:	serverInfo = CG_ConfigString( CS_SERVERINFO );
CNSTI4 0
ARGI4
ADDRLP4 56
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 40
ADDRLP4 56
INDIRP4
ASGNP4
line 1073
;1072:
;1073:	if( atoi(
ADDRLP4 40
INDIRP4
ARGP4
ADDRGP4 $507
ARGP4
ADDRLP4 60
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 60
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 64
INDIRI4
CNSTI4 0
EQI4 $505
line 1078
;1074:		Info_ValueForKey(
;1075:			serverInfo,
;1076:			"g_oneLifeTDM"
;1077:		)
;1078:	) ) {
line 1079
;1079:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $504
JUMPV
LABELV $505
line 1082
;1080:	}
;1081:
;1082:	s1 = cgs.scores1;
ADDRLP4 28
ADDRGP4 cgs+34800
INDIRI4
ASGNI4
line 1083
;1083:	s2 = cgs.scores2;
ADDRLP4 32
ADDRGP4 cgs+34804
INDIRI4
ASGNI4
line 1085
;1084:
;1085:	y -=  BIGCHAR_HEIGHT + 8;
ADDRFP4 0
ADDRFP4 0
INDIRF4
CNSTF4 1103101952
SUBF4
ASGNF4
line 1087
;1086:
;1087:	y1 = y;
ADDRLP4 36
ADDRFP4 0
INDIRF4
ASGNF4
line 1090
;1088:
;1089:	// draw from the right side to left
;1090:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $510
line 1091
;1091:		x = 640;
ADDRLP4 16
CNSTI4 640
ASGNI4
line 1092
;1092:		color[0] = 0.0f;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1093
;1093:		color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1094
;1094:		color[2] = 1.0f;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 1095
;1095:		color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1096
;1096:		s = va( "%2i", s2 );
ADDRGP4 $516
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRLP4 68
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 68
INDIRP4
ASGNP4
line 1097
;1097:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 72
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1098
;1098:		x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1099
;1099:		CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1100
;1100:		if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 2
NEI4 $517
line 1101
;1101:			CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1102
;1102:		}
LABELV $517
line 1103
;1103:		CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1105
;1104:
;1105:		if ( cgs.gametype == GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $522
line 1107
;1106:			// Display flag status
;1107:			item = BG_FindItemForPowerup( PW_BLUEFLAG );
CNSTI4 8
ARGI4
ADDRLP4 76
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 52
ADDRLP4 76
INDIRP4
ASGNP4
line 1109
;1108:
;1109:			if (item) {
ADDRLP4 52
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $525
line 1110
;1110:				y1 = y - BIGCHAR_HEIGHT - 8;
ADDRLP4 36
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
SUBF4
CNSTF4 1090519040
SUBF4
ASGNF4
line 1111
;1111:				if( cgs.blueflag >= 0 && cgs.blueflag <= 2 ) {
ADDRGP4 cgs+34812
INDIRI4
CNSTI4 0
LTI4 $527
ADDRGP4 cgs+34812
INDIRI4
CNSTI4 2
GTI4 $527
line 1112
;1112:					CG_DrawPic( x, y1-4, w, BIGCHAR_HEIGHT+8, cgs.media.blueFlagShader[cgs.blueflag] );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 36
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+34812
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+60
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1113
;1113:				}
LABELV $527
line 1114
;1114:			}
LABELV $525
line 1115
;1115:		}
LABELV $522
line 1116
;1116:		color[0] = 1.0f;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 1117
;1117:		color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1118
;1118:		color[2] = 0.0f;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1119
;1119:		color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1120
;1120:		s = va( "%2i", s1 );
ADDRGP4 $516
ARGP4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 76
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 76
INDIRP4
ASGNP4
line 1121
;1121:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 80
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 80
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1122
;1122:		x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1123
;1123:		CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1124
;1124:		if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_RED ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 1
NEI4 $537
line 1125
;1125:			CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1126
;1126:		}
LABELV $537
line 1127
;1127:		CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1129
;1128:
;1129:		if ( cgs.gametype == GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $542
line 1131
;1130:			// Display flag status
;1131:			item = BG_FindItemForPowerup( PW_REDFLAG );
CNSTI4 7
ARGI4
ADDRLP4 84
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 52
ADDRLP4 84
INDIRP4
ASGNP4
line 1133
;1132:
;1133:			if (item) {
ADDRLP4 52
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $545
line 1134
;1134:				y1 = y - BIGCHAR_HEIGHT - 8;
ADDRLP4 36
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
SUBF4
CNSTF4 1090519040
SUBF4
ASGNF4
line 1135
;1135:				if( cgs.redflag >= 0 && cgs.redflag <= 2 ) {
ADDRGP4 cgs+34808
INDIRI4
CNSTI4 0
LTI4 $547
ADDRGP4 cgs+34808
INDIRI4
CNSTI4 2
GTI4 $547
line 1136
;1136:					CG_DrawPic( x, y1-4, w, BIGCHAR_HEIGHT+8, cgs.media.redFlagShader[cgs.redflag] );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 36
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+34808
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+48
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1137
;1137:				}
LABELV $547
line 1138
;1138:			}
LABELV $545
line 1139
;1139:		}
LABELV $542
line 1154
;1140:
;1141:#ifdef MISSIONPACK
;1142:		if ( cgs.gametype == GT_1FCTF ) {
;1143:			// Display flag status
;1144:			item = BG_FindItemForPowerup( PW_NEUTRALFLAG );
;1145:
;1146:			if (item) {
;1147:				y1 = y - BIGCHAR_HEIGHT - 8;
;1148:				if( cgs.flagStatus >= 0 && cgs.flagStatus <= 3 ) {
;1149:					CG_DrawPic( x, y1-4, w, BIGCHAR_HEIGHT+8, cgs.media.flagShader[cgs.flagStatus] );
;1150:				}
;1151:			}
;1152:		}
;1153:#endif
;1154:		if ( cgs.gametype >= GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
LTI4 $554
line 1155
;1155:			v = cgs.capturelimit;
ADDRLP4 48
ADDRGP4 cgs+31472
INDIRI4
ASGNI4
line 1156
;1156:		} else {
ADDRGP4 $555
JUMPV
LABELV $554
line 1157
;1157:			v = cgs.fraglimit;
ADDRLP4 48
ADDRGP4 cgs+31468
INDIRI4
ASGNI4
line 1158
;1158:		}
LABELV $555
line 1159
;1159:		if ( v ) {
ADDRLP4 48
INDIRI4
CNSTI4 0
EQI4 $511
line 1160
;1160:			s = va( "%2i", v );
ADDRGP4 $516
ARGP4
ADDRLP4 48
INDIRI4
ARGI4
ADDRLP4 84
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 84
INDIRP4
ASGNP4
line 1161
;1161:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 88
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 88
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1162
;1162:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1163
;1163:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1164
;1164:		}
line 1166
;1165:
;1166:	} else {
ADDRGP4 $511
JUMPV
LABELV $510
line 1169
;1167:		qboolean	spectator;
;1168:
;1169:		x = 640;
ADDRLP4 16
CNSTI4 640
ASGNI4
line 1170
;1170:		score = cg.snap->ps.persistant[PERS_SCORE];
ADDRLP4 44
ADDRGP4 cg+36
INDIRP4
CNSTI4 292
ADDP4
INDIRI4
ASGNI4
line 1171
;1171:		spectator = ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR );
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $564
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRGP4 $565
JUMPV
LABELV $564
ADDRLP4 72
CNSTI4 0
ASGNI4
LABELV $565
ADDRLP4 68
ADDRLP4 72
INDIRI4
ASGNI4
line 1174
;1172:
;1173:		// always show your score in the second box if not in first place
;1174:		if ( s1 != score ) {
ADDRLP4 28
INDIRI4
ADDRLP4 44
INDIRI4
EQI4 $566
line 1175
;1175:			s2 = score;
ADDRLP4 32
ADDRLP4 44
INDIRI4
ASGNI4
line 1176
;1176:		}
LABELV $566
line 1177
;1177:		if ( s2 != SCORE_NOT_PRESENT ) {
ADDRLP4 32
INDIRI4
CNSTI4 -9999
EQI4 $568
line 1178
;1178:			s = va( "%2i", s2 );
ADDRGP4 $516
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRLP4 76
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 76
INDIRP4
ASGNP4
line 1179
;1179:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 80
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 80
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1180
;1180:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1181
;1181:			if ( !spectator && score == s2 && score != s1 ) {
ADDRLP4 68
INDIRI4
CNSTI4 0
NEI4 $570
ADDRLP4 84
ADDRLP4 44
INDIRI4
ASGNI4
ADDRLP4 84
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $570
ADDRLP4 84
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $570
line 1182
;1182:				color[0] = 1.0f;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 1183
;1183:				color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1184
;1184:				color[2] = 0.0f;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1185
;1185:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1186
;1186:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1187
;1187:				CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1188
;1188:			} else {
ADDRGP4 $571
JUMPV
LABELV $570
line 1189
;1189:				color[0] = 0.5f;
ADDRLP4 0
CNSTF4 1056964608
ASGNF4
line 1190
;1190:				color[1] = 0.5f;
ADDRLP4 0+4
CNSTF4 1056964608
ASGNF4
line 1191
;1191:				color[2] = 0.5f;
ADDRLP4 0+8
CNSTF4 1056964608
ASGNF4
line 1192
;1192:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1193
;1193:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1194
;1194:			}	
LABELV $571
line 1195
;1195:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1196
;1196:		}
LABELV $568
line 1199
;1197:
;1198:		// first place
;1199:		if ( s1 != SCORE_NOT_PRESENT ) {
ADDRLP4 28
INDIRI4
CNSTI4 -9999
EQI4 $580
line 1200
;1200:			s = va( "%2i", s1 );
ADDRGP4 $516
ARGP4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 76
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 76
INDIRP4
ASGNP4
line 1201
;1201:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 80
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 80
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1202
;1202:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1203
;1203:			if ( !spectator && score == s1 ) {
ADDRLP4 68
INDIRI4
CNSTI4 0
NEI4 $582
ADDRLP4 44
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $582
line 1204
;1204:				color[0] = 0.0f;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1205
;1205:				color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1206
;1206:				color[2] = 1.0f;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 1207
;1207:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1208
;1208:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1209
;1209:				CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1210
;1210:			} else {
ADDRGP4 $583
JUMPV
LABELV $582
line 1211
;1211:				color[0] = 0.5f;
ADDRLP4 0
CNSTF4 1056964608
ASGNF4
line 1212
;1212:				color[1] = 0.5f;
ADDRLP4 0+4
CNSTF4 1056964608
ASGNF4
line 1213
;1213:				color[2] = 0.5f;
ADDRLP4 0+8
CNSTF4 1056964608
ASGNF4
line 1214
;1214:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1215
;1215:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1216
;1216:			}	
LABELV $583
line 1217
;1217:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1218
;1218:		}
LABELV $580
line 1220
;1219:
;1220:		if ( cgs.fraglimit ) {
ADDRGP4 cgs+31468
INDIRI4
CNSTI4 0
EQI4 $592
line 1221
;1221:			s = va( "%2i", cgs.fraglimit );
ADDRGP4 $516
ARGP4
ADDRGP4 cgs+31468
INDIRI4
ARGI4
ADDRLP4 76
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 76
INDIRP4
ASGNP4
line 1222
;1222:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 80
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 80
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1223
;1223:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1224
;1224:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1225
;1225:		}
LABELV $592
line 1227
;1226:
;1227:	}
LABELV $511
line 1229
;1228:
;1229:	return y1 - 8;
ADDRLP4 36
INDIRF4
CNSTF4 1090519040
SUBF4
RETF4
LABELV $504
endproc CG_DrawScores 92 20
data
align 4
LABELV $597
byte 4 1045220557
byte 4 1065353216
byte 4 1045220557
byte 4 1065353216
byte 4 1065353216
byte 4 1045220557
byte 4 1045220557
byte 4 1065353216
code
proc CG_DrawPowerups 208 20
line 1239
;1230:}
;1231:#endif // MISSIONPACK
;1232:
;1233:/*
;1234:================
;1235:CG_DrawPowerups
;1236:================
;1237:*/
;1238:#ifndef MISSIONPACK
;1239:static float CG_DrawPowerups( float y ) {
line 1256
;1240:	int		sorted[MAX_POWERUPS];
;1241:	int		sortedTime[MAX_POWERUPS];
;1242:	int		i, j, k;
;1243:	int		active;
;1244:	playerState_t	*ps;
;1245:	int		t;
;1246:	gitem_t	*item;
;1247:	int		x;
;1248:	int		color;
;1249:	float	size;
;1250:	float	f;
;1251:	static float colors[2][4] = { 
;1252:    { 0.2f, 1.0f, 0.2f, 1.0f } , 
;1253:    { 1.0f, 0.2f, 0.2f, 1.0f } 
;1254:  };
;1255:
;1256:	ps = &cg.snap->ps;
ADDRLP4 148
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
line 1258
;1257:
;1258:	if ( ps->stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 148
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $599
line 1259
;1259:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $596
JUMPV
LABELV $599
line 1263
;1260:	}
;1261:
;1262:	// sort the list by time remaining
;1263:	active = 0;
ADDRLP4 136
CNSTI4 0
ASGNI4
line 1264
;1264:	for ( i = 0 ; i < MAX_POWERUPS ; i++ ) {
ADDRLP4 144
CNSTI4 0
ASGNI4
LABELV $601
line 1265
;1265:		if ( !ps->powerups[ i ] ) {
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 148
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
CNSTI4 0
NEI4 $605
line 1266
;1266:			continue;
ADDRGP4 $602
JUMPV
LABELV $605
line 1268
;1267:		}
;1268:		t = ps->powerups[ i ] - cg.time;
ADDRLP4 140
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 148
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
ASGNI4
line 1271
;1269:		// ZOID--don't draw if the power up has unlimited time (999 seconds)
;1270:		// This is true of the CTF flags
;1271:		if ( t < 0 || t > 999000) {
ADDRLP4 140
INDIRI4
CNSTI4 0
LTI4 $610
ADDRLP4 140
INDIRI4
CNSTI4 999000
LEI4 $608
LABELV $610
line 1272
;1272:			continue;
ADDRGP4 $602
JUMPV
LABELV $608
line 1276
;1273:		}
;1274:
;1275:		// insert into the list
;1276:		for ( j = 0 ; j < active ; j++ ) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $614
JUMPV
LABELV $611
line 1277
;1277:			if ( sortedTime[j] >= t ) {
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
ADDRLP4 140
INDIRI4
LTI4 $615
line 1278
;1278:				for ( k = active - 1 ; k >= j ; k-- ) {
ADDRLP4 0
ADDRLP4 136
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRGP4 $620
JUMPV
LABELV $617
line 1279
;1279:					sorted[k+1] = sorted[k];
ADDRLP4 176
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 176
INDIRI4
ADDRLP4 68+4
ADDP4
ADDRLP4 176
INDIRI4
ADDRLP4 68
ADDP4
INDIRI4
ASGNI4
line 1280
;1280:					sortedTime[k+1] = sortedTime[k];
ADDRLP4 180
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 180
INDIRI4
ADDRLP4 4+4
ADDP4
ADDRLP4 180
INDIRI4
ADDRLP4 4
ADDP4
INDIRI4
ASGNI4
line 1281
;1281:				}
LABELV $618
line 1278
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $620
ADDRLP4 0
INDIRI4
ADDRLP4 132
INDIRI4
GEI4 $617
line 1282
;1282:				break;
ADDRGP4 $613
JUMPV
LABELV $615
line 1284
;1283:			}
;1284:		}
LABELV $612
line 1276
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $614
ADDRLP4 132
INDIRI4
ADDRLP4 136
INDIRI4
LTI4 $611
LABELV $613
line 1285
;1285:		sorted[j] = i;
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 68
ADDP4
ADDRLP4 144
INDIRI4
ASGNI4
line 1286
;1286:		sortedTime[j] = t;
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
ADDRLP4 140
INDIRI4
ASGNI4
line 1287
;1287:		active++;
ADDRLP4 136
ADDRLP4 136
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1288
;1288:	}
LABELV $602
line 1264
ADDRLP4 144
ADDRLP4 144
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 16
LTI4 $601
line 1291
;1289:
;1290:	// draw the icons and timers
;1291:	x = 640 - ICON_SIZE - CHAR_WIDTH * 2;
ADDRLP4 168
CNSTI4 528
ASGNI4
line 1292
;1292:	for ( i = 0 ; i < active ; i++ ) {
ADDRLP4 144
CNSTI4 0
ASGNI4
ADDRGP4 $626
JUMPV
LABELV $623
line 1293
;1293:		item = BG_FindItemForPowerup( sorted[i] );
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 68
ADDP4
INDIRI4
ARGI4
ADDRLP4 172
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 152
ADDRLP4 172
INDIRP4
ASGNP4
line 1295
;1294:
;1295:    if (item) {
ADDRLP4 152
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $627
line 1297
;1296:
;1297:		  color = 1;
ADDRLP4 164
CNSTI4 1
ASGNI4
line 1299
;1298:
;1299:		  y -= ICON_SIZE;
ADDRFP4 0
ADDRFP4 0
INDIRF4
CNSTF4 1111490560
SUBF4
ASGNF4
line 1301
;1300:
;1301:		  trap_R_SetColor( colors[color] );
ADDRLP4 164
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 $597
ADDP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1302
;1302:		  CG_DrawField( x, y, 2, sortedTime[ i ] / 1000 );
ADDRLP4 168
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 176
CNSTI4 2
ASGNI4
ADDRLP4 176
INDIRI4
ARGI4
ADDRLP4 144
INDIRI4
ADDRLP4 176
INDIRI4
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
CNSTI4 1000
DIVI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 1304
;1303:
;1304:		  t = ps->powerups[ sorted[i] ];
ADDRLP4 180
CNSTI4 2
ASGNI4
ADDRLP4 140
ADDRLP4 144
INDIRI4
ADDRLP4 180
INDIRI4
LSHI4
ADDRLP4 68
ADDP4
INDIRI4
ADDRLP4 180
INDIRI4
LSHI4
ADDRLP4 148
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
ASGNI4
line 1305
;1305:		  if ( t - cg.time >= POWERUP_BLINKS * POWERUP_BLINK_TIME ) {
ADDRLP4 140
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CNSTI4 5000
LTI4 $629
line 1306
;1306:			  trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1307
;1307:		  } else {
ADDRGP4 $630
JUMPV
LABELV $629
line 1310
;1308:			  vec4_t	modulate;
;1309:
;1310:			  f = (float)( t - cg.time ) / POWERUP_BLINK_TIME;
ADDRLP4 160
ADDRLP4 140
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 1311
;1311:			  f -= (int)f;
ADDRLP4 160
ADDRLP4 160
INDIRF4
ADDRLP4 160
INDIRF4
CVFI4 4
CVIF4 4
SUBF4
ASGNF4
line 1312
;1312:			  modulate[0] = modulate[1] = modulate[2] = modulate[3] = f;
ADDRLP4 184+12
ADDRLP4 160
INDIRF4
ASGNF4
ADDRLP4 184+8
ADDRLP4 160
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 160
INDIRF4
ASGNF4
ADDRLP4 184
ADDRLP4 160
INDIRF4
ASGNF4
line 1313
;1313:			  trap_R_SetColor( modulate );
ADDRLP4 184
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1314
;1314:		  }
LABELV $630
line 1316
;1315:
;1316:		  if ( cg.powerupActive == sorted[i] && 
ADDRGP4 cg+124408
INDIRI4
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 68
ADDP4
INDIRI4
NEI4 $636
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124412
INDIRI4
SUBI4
CNSTI4 200
GEI4 $636
line 1317
;1317:			  cg.time - cg.powerupTime < PULSE_TIME ) {
line 1318
;1318:			  f = 1.0 - ( ( (float)cg.time - cg.powerupTime ) / PULSE_TIME );
ADDRLP4 160
CNSTF4 1065353216
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124412
INDIRI4
CVIF4 4
SUBF4
CNSTF4 1128792064
DIVF4
SUBF4
ASGNF4
line 1319
;1319:			  size = ICON_SIZE * ( 1.0 + ( PULSE_SCALE - 1.0 ) * f );
ADDRLP4 156
CNSTF4 1111490560
CNSTF4 1056964608
ADDRLP4 160
INDIRF4
MULF4
CNSTF4 1065353216
ADDF4
MULF4
ASGNF4
line 1320
;1320:		  } else {
ADDRGP4 $637
JUMPV
LABELV $636
line 1321
;1321:			  size = ICON_SIZE;
ADDRLP4 156
CNSTF4 1111490560
ASGNF4
line 1322
;1322:		  }
LABELV $637
line 1324
;1323:
;1324:		  CG_DrawPic( 640 - size, y + ICON_SIZE / 2 - size / 2, 
ADDRLP4 152
INDIRP4
CNSTI4 24
ADDP4
INDIRP4
ARGP4
ADDRLP4 184
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
CNSTF4 1142947840
ADDRLP4 156
INDIRF4
SUBF4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1103101952
ADDF4
ADDRLP4 156
INDIRF4
CNSTF4 1073741824
DIVF4
SUBF4
ARGF4
ADDRLP4 156
INDIRF4
ARGF4
ADDRLP4 156
INDIRF4
ARGF4
ADDRLP4 184
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1326
;1325:			  size, size, trap_R_RegisterShader( item->icon ) );
;1326:    }
LABELV $627
line 1327
;1327:	}
LABELV $624
line 1292
ADDRLP4 144
ADDRLP4 144
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $626
ADDRLP4 144
INDIRI4
ADDRLP4 136
INDIRI4
LTI4 $623
line 1328
;1328:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1330
;1329:
;1330:	return y;
ADDRFP4 0
INDIRF4
RETF4
LABELV $596
endproc CG_DrawPowerups 208 20
proc CG_DrawLowerRight 12 12
line 1341
;1331:}
;1332:#endif // MISSIONPACK
;1333:
;1334:/*
;1335:=====================
;1336:CG_DrawLowerRight
;1337:
;1338:=====================
;1339:*/
;1340:#ifndef MISSIONPACK
;1341:static void CG_DrawLowerRight( void ) {
line 1344
;1342:	float	y;
;1343:
;1344:	y = 480 - ICON_SIZE;
ADDRLP4 0
CNSTF4 1138229248
ASGNF4
line 1346
;1345:
;1346:	if ( cgs.gametype >= GT_TEAM && cg_drawTeamOverlay.integer == 2 ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $644
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
CNSTI4 2
NEI4 $644
line 1347
;1347:		y = CG_DrawTeamOverlay( y, qtrue, qfalse );
ADDRLP4 0
INDIRF4
ARGF4
CNSTI4 1
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 4
ADDRGP4 CG_DrawTeamOverlay
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1348
;1348:	} 
LABELV $644
line 1350
;1349:
;1350:	y = CG_DrawScores( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawScores
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1351
;1351:	y = CG_DrawPowerups( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 8
ADDRGP4 CG_DrawPowerups
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 8
INDIRF4
ASGNF4
line 1352
;1352:}
LABELV $643
endproc CG_DrawLowerRight 12 12
proc CG_DrawPickupItem 16 20
line 1361
;1353:#endif // MISSIONPACK
;1354:
;1355:/*
;1356:===================
;1357:CG_DrawPickupItem
;1358:===================
;1359:*/
;1360:#ifndef MISSIONPACK
;1361:static int CG_DrawPickupItem( int y ) {
line 1365
;1362:	int		value;
;1363:	float	*fadeColor;
;1364:
;1365:	if ( cg.snap->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 228
ADDP4
INDIRI4
CNSTI4 0
GTI4 $649
line 1366
;1366:		return y;
ADDRFP4 0
INDIRI4
RETI4
ADDRGP4 $648
JUMPV
LABELV $649
line 1369
;1367:	}
;1368:
;1369:	y -= ICON_SIZE;
ADDRFP4 0
ADDRFP4 0
INDIRI4
CNSTI4 48
SUBI4
ASGNI4
line 1371
;1370:
;1371:	value = cg.itemPickup;
ADDRLP4 0
ADDRGP4 cg+124664
INDIRI4
ASGNI4
line 1372
;1372:	if ( value ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $653
line 1373
;1373:		fadeColor = CG_FadeColor( cg.itemPickupTime, 3000 );
ADDRGP4 cg+124668
INDIRI4
ARGI4
CNSTI4 3000
ARGI4
ADDRLP4 8
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
ASGNP4
line 1374
;1374:		if ( fadeColor ) {
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $656
line 1375
;1375:			CG_RegisterItemVisuals( value );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_RegisterItemVisuals
CALLV
pop
line 1376
;1376:			trap_R_SetColor( fadeColor );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1377
;1377:			CG_DrawPic( 8, y, ICON_SIZE, ICON_SIZE, cg_items[ value ].icon );
CNSTF4 1090519040
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 12
CNSTF4 1111490560
ASGNF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
CNSTI4 24
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_items+20
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1378
;1378:			CG_DrawBigString( ICON_SIZE + 16, y + (ICON_SIZE/2 - BIGCHAR_HEIGHT/2), bg_itemlist[ value ].pickup_name, fadeColor[0] );
CNSTI4 64
ARGI4
ADDRFP4 0
INDIRI4
CNSTI4 16
ADDI4
ARGI4
CNSTI4 52
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 bg_itemlist+28
ADDP4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
INDIRF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1379
;1379:			trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1380
;1380:		}
LABELV $656
line 1381
;1381:	}
LABELV $653
line 1383
;1382:	
;1383:	return y;
ADDRFP4 0
INDIRI4
RETI4
LABELV $648
endproc CG_DrawPickupItem 16 20
proc CG_DrawLowerLeft 16 12
line 1394
;1384:}
;1385:#endif // MISSIONPACK
;1386:
;1387:/*
;1388:=====================
;1389:CG_DrawLowerLeft
;1390:
;1391:=====================
;1392:*/
;1393:#ifndef MISSIONPACK
;1394:static void CG_DrawLowerLeft( void ) {
line 1397
;1395:	float	y;
;1396:
;1397:	y = 480 - ICON_SIZE;
ADDRLP4 0
CNSTF4 1138229248
ASGNF4
line 1399
;1398:
;1399:	if ( cgs.gametype >= GT_TEAM && cg_drawTeamOverlay.integer == 3 ) {
ADDRLP4 4
CNSTI4 3
ASGNI4
ADDRGP4 cgs+31456
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $661
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $661
line 1400
;1400:		y = CG_DrawTeamOverlay( y, qfalse, qfalse );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 CG_DrawTeamOverlay
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 12
INDIRF4
ASGNF4
line 1401
;1401:	} 
LABELV $661
line 1404
;1402:
;1403:
;1404:	y = CG_DrawPickupItem( y );
ADDRLP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 8
ADDRGP4 CG_DrawPickupItem
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 8
INDIRI4
CVIF4 4
ASGNF4
line 1405
;1405:}
LABELV $660
endproc CG_DrawLowerLeft 16 12
proc CG_DrawTeamInfo 56 36
line 1417
;1406:#endif // MISSIONPACK
;1407:
;1408:
;1409://===========================================================================================
;1410:
;1411:/*
;1412:=================
;1413:CG_DrawTeamInfo
;1414:=================
;1415:*/
;1416:#ifndef MISSIONPACK
;1417:static void CG_DrawTeamInfo( void ) {
line 1426
;1418:	int w, h;
;1419:	int i, len;
;1420:	vec4_t		hcolor;
;1421:	int		chatHeight;
;1422:
;1423:#define CHATLOC_Y 420 // bottom end
;1424:#define CHATLOC_X 0
;1425:
;1426:	if (cg_teamChatHeight.integer < TEAMCHAT_HEIGHT)
ADDRGP4 cg_teamChatHeight+12
INDIRI4
CNSTI4 8
GEI4 $666
line 1427
;1427:		chatHeight = cg_teamChatHeight.integer;
ADDRLP4 8
ADDRGP4 cg_teamChatHeight+12
INDIRI4
ASGNI4
ADDRGP4 $667
JUMPV
LABELV $666
line 1429
;1428:	else
;1429:		chatHeight = TEAMCHAT_HEIGHT;
ADDRLP4 8
CNSTI4 8
ASGNI4
LABELV $667
line 1430
;1430:	if (chatHeight <= 0)
ADDRLP4 8
INDIRI4
CNSTI4 0
GTI4 $670
line 1431
;1431:		return; // disabled
ADDRGP4 $665
JUMPV
LABELV $670
line 1433
;1432:
;1433:	if (cgs.teamLastChatPos != cgs.teamChatPos) {
ADDRGP4 cgs+152248
INDIRI4
ADDRGP4 cgs+152244
INDIRI4
EQI4 $672
line 1434
;1434:		if (cg.time - cgs.teamChatMsgTimes[cgs.teamLastChatPos % chatHeight] > cg_teamChatTime.integer) {
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cgs+152248
INDIRI4
ADDRLP4 8
INDIRI4
MODI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152212
ADDP4
INDIRI4
SUBI4
ADDRGP4 cg_teamChatTime+12
INDIRI4
LEI4 $676
line 1435
;1435:			cgs.teamLastChatPos++;
ADDRLP4 36
ADDRGP4 cgs+152248
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 36
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1436
;1436:		}
LABELV $676
line 1438
;1437:
;1438:		h = (cgs.teamChatPos - cgs.teamLastChatPos) * TINYCHAR_HEIGHT;
ADDRLP4 32
ADDRGP4 cgs+152244
INDIRI4
ADDRGP4 cgs+152248
INDIRI4
SUBI4
CNSTI4 3
LSHI4
ASGNI4
line 1440
;1439:
;1440:		w = 0;
ADDRLP4 28
CNSTI4 0
ASGNI4
line 1442
;1441:
;1442:		for (i = cgs.teamLastChatPos; i < cgs.teamChatPos; i++) {
ADDRLP4 0
ADDRGP4 cgs+152248
INDIRI4
ASGNI4
ADDRGP4 $688
JUMPV
LABELV $685
line 1443
;1443:			len = CG_DrawStrlen(cgs.teamChatMsgs[i % chatHeight]);
CNSTI4 241
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
MODI4
MULI4
ADDRGP4 cgs+150284
ADDP4
ARGP4
ADDRLP4 36
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 36
INDIRI4
ASGNI4
line 1444
;1444:			if (len > w)
ADDRLP4 4
INDIRI4
ADDRLP4 28
INDIRI4
LEI4 $692
line 1445
;1445:				w = len;
ADDRLP4 28
ADDRLP4 4
INDIRI4
ASGNI4
LABELV $692
line 1446
;1446:		}
LABELV $686
line 1442
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $688
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+152244
INDIRI4
LTI4 $685
line 1447
;1447:		w *= TINYCHAR_WIDTH;
ADDRLP4 28
ADDRLP4 28
INDIRI4
CNSTI4 3
LSHI4
ASGNI4
line 1448
;1448:		w += TINYCHAR_WIDTH * 2;
ADDRLP4 28
ADDRLP4 28
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1450
;1449:
;1450:		if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_RED ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 1
NEI4 $694
line 1451
;1451:			hcolor[0] = 1.0f;
ADDRLP4 12
CNSTF4 1065353216
ASGNF4
line 1452
;1452:			hcolor[1] = 0.0f;
ADDRLP4 12+4
CNSTF4 0
ASGNF4
line 1453
;1453:			hcolor[2] = 0.0f;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 1454
;1454:			hcolor[3] = 0.33f;
ADDRLP4 12+12
CNSTF4 1051260355
ASGNF4
line 1455
;1455:		} else if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
ADDRGP4 $695
JUMPV
LABELV $694
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 2
NEI4 $700
line 1456
;1456:			hcolor[0] = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 1457
;1457:			hcolor[1] = 0.0f;
ADDRLP4 12+4
CNSTF4 0
ASGNF4
line 1458
;1458:			hcolor[2] = 1.0f;
ADDRLP4 12+8
CNSTF4 1065353216
ASGNF4
line 1459
;1459:			hcolor[3] = 0.33f;
ADDRLP4 12+12
CNSTF4 1051260355
ASGNF4
line 1460
;1460:		} else {
ADDRGP4 $701
JUMPV
LABELV $700
line 1461
;1461:			hcolor[0] = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 1462
;1462:			hcolor[1] = 1.0f;
ADDRLP4 12+4
CNSTF4 1065353216
ASGNF4
line 1463
;1463:			hcolor[2] = 0.0f;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 1464
;1464:			hcolor[3] = 0.33f;
ADDRLP4 12+12
CNSTF4 1051260355
ASGNF4
line 1465
;1465:		}
LABELV $701
LABELV $695
line 1467
;1466:
;1467:		trap_R_SetColor( hcolor );
ADDRLP4 12
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1468
;1468:		CG_DrawPic( CHATLOC_X, CHATLOC_Y - h, 640, h, cgs.media.teamStatusBar );
CNSTF4 0
ARGF4
ADDRLP4 36
ADDRLP4 32
INDIRI4
ASGNI4
CNSTI4 420
ADDRLP4 36
INDIRI4
SUBI4
CVIF4 4
ARGF4
CNSTF4 1142947840
ARGF4
ADDRLP4 36
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 cgs+152340+128
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1469
;1469:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1471
;1470:
;1471:		hcolor[0] = hcolor[1] = hcolor[2] = 1.0f;
ADDRLP4 40
CNSTF4 1065353216
ASGNF4
ADDRLP4 12+8
ADDRLP4 40
INDIRF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 40
INDIRF4
ASGNF4
ADDRLP4 12
ADDRLP4 40
INDIRF4
ASGNF4
line 1472
;1472:		hcolor[3] = 1.0f;
ADDRLP4 12+12
CNSTF4 1065353216
ASGNF4
line 1474
;1473:
;1474:		for (i = cgs.teamChatPos - 1; i >= cgs.teamLastChatPos; i--) {
ADDRLP4 0
ADDRGP4 cgs+152244
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRGP4 $717
JUMPV
LABELV $714
line 1475
;1475:			CG_DrawStringExt( CHATLOC_X + TINYCHAR_WIDTH, 
ADDRLP4 44
CNSTI4 8
ASGNI4
ADDRLP4 44
INDIRI4
ARGI4
CNSTI4 420
ADDRGP4 cgs+152244
INDIRI4
ADDRLP4 0
INDIRI4
SUBI4
CNSTI4 3
LSHI4
SUBI4
ARGI4
CNSTI4 241
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
MODI4
MULI4
ADDRGP4 cgs+150284
ADDP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 1479
;1476:				CHATLOC_Y - (cgs.teamChatPos - i)*TINYCHAR_HEIGHT, 
;1477:				cgs.teamChatMsgs[i % chatHeight], hcolor, qfalse, qfalse,
;1478:				TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 0 );
;1479:		}
LABELV $715
line 1474
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $717
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+152248
INDIRI4
GEI4 $714
line 1480
;1480:	}
LABELV $672
line 1481
;1481:}
LABELV $665
endproc CG_DrawTeamInfo 56 36
proc CG_DrawHoldableItem 8 20
line 1490
;1482:#endif // MISSIONPACK
;1483:
;1484:/*
;1485:===================
;1486:CG_DrawHoldableItem
;1487:===================
;1488:*/
;1489:#ifndef MISSIONPACK
;1490:static void CG_DrawHoldableItem( void ) { 
line 1493
;1491:	int		value;
;1492:
;1493:	value = cg.snap->ps.stats[STAT_HOLDABLE_ITEM];
ADDRLP4 0
ADDRGP4 cg+36
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
ASGNI4
line 1494
;1494:	if ( value ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $724
line 1495
;1495:		CG_RegisterItemVisuals( value );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_RegisterItemVisuals
CALLV
pop
line 1496
;1496:		CG_DrawPic( 640-ICON_SIZE, (SCREEN_HEIGHT-ICON_SIZE)/2, ICON_SIZE, ICON_SIZE, cg_items[ value ].icon );
CNSTF4 1142161408
ARGF4
CNSTF4 1129840640
ARGF4
ADDRLP4 4
CNSTF4 1111490560
ASGNF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
CNSTI4 24
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_items+20
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1497
;1497:	}
LABELV $724
line 1499
;1498:
;1499:}
LABELV $722
endproc CG_DrawHoldableItem 8 20
proc CG_DrawReward 68 36
line 1527
;1500:#endif // MISSIONPACK
;1501:
;1502:#ifdef MISSIONPACK
;1503:/*
;1504:===================
;1505:CG_DrawPersistantPowerup
;1506:===================
;1507:*/
;1508:#if 0 // sos001208 - DEAD
;1509:static void CG_DrawPersistantPowerup( void ) { 
;1510:	int		value;
;1511:
;1512:	value = cg.snap->ps.stats[STAT_PERSISTANT_POWERUP];
;1513:	if ( value ) {
;1514:		CG_RegisterItemVisuals( value );
;1515:		CG_DrawPic( 640-ICON_SIZE, (SCREEN_HEIGHT-ICON_SIZE)/2 - ICON_SIZE, ICON_SIZE, ICON_SIZE, cg_items[ value ].icon );
;1516:	}
;1517:}
;1518:#endif
;1519:#endif // MISSIONPACK
;1520:
;1521:
;1522:/*
;1523:===================
;1524:CG_DrawReward
;1525:===================
;1526:*/
;1527:static void CG_DrawReward( void ) { 
line 1533
;1528:	float	*color;
;1529:	int		i, count;
;1530:	float	x, y;
;1531:	char	buf[32];
;1532:
;1533:	if ( !cg_drawRewards.integer ) {
ADDRGP4 cg_drawRewards+12
INDIRI4
CNSTI4 0
NEI4 $728
line 1534
;1534:		return;
ADDRGP4 $727
JUMPV
LABELV $728
line 1537
;1535:	}
;1536:
;1537:	color = CG_FadeColor( cg.rewardTime, REWARD_TIME );
ADDRGP4 cg+124428
INDIRI4
ARGI4
CNSTI4 3000
ARGI4
ADDRLP4 52
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 52
INDIRP4
ASGNP4
line 1538
;1538:	if ( !color ) {
ADDRLP4 16
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $732
line 1539
;1539:		if (cg.rewardStack > 0) {
ADDRGP4 cg+124424
INDIRI4
CNSTI4 0
LEI4 $727
line 1540
;1540:			for(i = 0; i < cg.rewardStack; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $740
JUMPV
LABELV $737
line 1541
;1541:				cg.rewardSound[i] = cg.rewardSound[i+1];
ADDRLP4 56
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 56
INDIRI4
ADDRGP4 cg+124512
ADDP4
ADDRLP4 56
INDIRI4
ADDRGP4 cg+124512+4
ADDP4
INDIRI4
ASGNI4
line 1542
;1542:				cg.rewardShader[i] = cg.rewardShader[i+1];
ADDRLP4 60
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 60
INDIRI4
ADDRGP4 cg+124472
ADDP4
ADDRLP4 60
INDIRI4
ADDRGP4 cg+124472+4
ADDP4
INDIRI4
ASGNI4
line 1543
;1543:				cg.rewardCount[i] = cg.rewardCount[i+1];
ADDRLP4 64
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 64
INDIRI4
ADDRGP4 cg+124432
ADDP4
ADDRLP4 64
INDIRI4
ADDRGP4 cg+124432+4
ADDP4
INDIRI4
ASGNI4
line 1544
;1544:			}
LABELV $738
line 1540
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $740
ADDRLP4 0
INDIRI4
ADDRGP4 cg+124424
INDIRI4
LTI4 $737
line 1545
;1545:			cg.rewardTime = cg.time;
ADDRGP4 cg+124428
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1546
;1546:			cg.rewardStack--;
ADDRLP4 56
ADDRGP4 cg+124424
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1547
;1547:			color = CG_FadeColor( cg.rewardTime, REWARD_TIME );
ADDRGP4 cg+124428
INDIRI4
ARGI4
CNSTI4 3000
ARGI4
ADDRLP4 60
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 60
INDIRP4
ASGNP4
line 1548
;1548:			trap_S_StartLocalSound(cg.rewardSound[0], CHAN_ANNOUNCER);
ADDRGP4 cg+124512
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 1549
;1549:		} else {
line 1550
;1550:			return;
LABELV $735
line 1552
;1551:		}
;1552:	}
LABELV $732
line 1554
;1553:
;1554:	trap_R_SetColor( color );
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1571
;1555:
;1556:	/*
;1557:	count = cg.rewardCount[0]/10;				// number of big rewards to draw
;1558:
;1559:	if (count) {
;1560:		y = 4;
;1561:		x = 320 - count * ICON_SIZE;
;1562:		for ( i = 0 ; i < count ; i++ ) {
;1563:			CG_DrawPic( x, y, (ICON_SIZE*2)-4, (ICON_SIZE*2)-4, cg.rewardShader[0] );
;1564:			x += (ICON_SIZE*2);
;1565:		}
;1566:	}
;1567:
;1568:	count = cg.rewardCount[0] - count*10;		// number of small rewards to draw
;1569:	*/
;1570:
;1571:	if ( cg.rewardCount[0] >= 10 ) {
ADDRGP4 cg+124432
INDIRI4
CNSTI4 10
LTI4 $756
line 1572
;1572:		y = 56;
ADDRLP4 8
CNSTF4 1113587712
ASGNF4
line 1573
;1573:		x = 320 - ICON_SIZE/2;
ADDRLP4 4
CNSTF4 1133772800
ASGNF4
line 1574
;1574:		CG_DrawPic( x, y, ICON_SIZE-4, ICON_SIZE-4, cg.rewardShader[0] );
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 56
CNSTF4 1110441984
ASGNF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRGP4 cg+124472
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1575
;1575:		Com_sprintf(buf, sizeof(buf), "%d", cg.rewardCount[0]);
ADDRLP4 20
ARGP4
CNSTI4 32
ARGI4
ADDRGP4 $760
ARGP4
ADDRGP4 cg+124432
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1576
;1576:		x = ( SCREEN_WIDTH - SMALLCHAR_WIDTH * CG_DrawStrlen( buf ) ) / 2;
ADDRLP4 20
ARGP4
ADDRLP4 60
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
CNSTI4 640
ADDRLP4 60
INDIRI4
CNSTI4 3
LSHI4
SUBI4
CNSTI4 2
DIVI4
CVIF4 4
ASGNF4
line 1577
;1577:		CG_DrawStringExt( x, y+ICON_SIZE, buf, color, qfalse, qtrue,
ADDRLP4 4
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 8
INDIRF4
CNSTF4 1111490560
ADDF4
CVFI4 4
ARGI4
ADDRLP4 20
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 64
CNSTI4 0
ASGNI4
ADDRLP4 64
INDIRI4
ARGI4
CNSTI4 1
ARGI4
CNSTI4 8
ARGI4
CNSTI4 16
ARGI4
ADDRLP4 64
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 1579
;1578:								SMALLCHAR_WIDTH, SMALLCHAR_HEIGHT, 0 );
;1579:	}
ADDRGP4 $757
JUMPV
LABELV $756
line 1580
;1580:	else {
line 1582
;1581:
;1582:		count = cg.rewardCount[0];
ADDRLP4 12
ADDRGP4 cg+124432
INDIRI4
ASGNI4
line 1584
;1583:
;1584:		y = 56;
ADDRLP4 8
CNSTF4 1113587712
ASGNF4
line 1585
;1585:		x = 320 - count * ICON_SIZE/2;
ADDRLP4 4
CNSTI4 320
CNSTI4 48
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
CVIF4 4
ASGNF4
line 1586
;1586:		for ( i = 0 ; i < count ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $766
JUMPV
LABELV $763
line 1587
;1587:			CG_DrawPic( x, y, ICON_SIZE-4, ICON_SIZE-4, cg.rewardShader[0] );
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 56
CNSTF4 1110441984
ASGNF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRGP4 cg+124472
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1588
;1588:			x += ICON_SIZE;
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1111490560
ADDF4
ASGNF4
line 1589
;1589:		}
LABELV $764
line 1586
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $766
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRI4
LTI4 $763
line 1590
;1590:	}
LABELV $757
line 1591
;1591:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1592
;1592:}
LABELV $727
endproc CG_DrawReward 68 36
export CG_AddLagometerFrameInfo
proc CG_AddLagometerFrameInfo 8 0
line 1623
;1593:
;1594:
;1595:/*
;1596:===============================================================================
;1597:
;1598:LAGOMETER
;1599:
;1600:===============================================================================
;1601:*/
;1602:
;1603:#define	LAG_SAMPLES		128
;1604:
;1605:
;1606:typedef struct {
;1607:	int		frameSamples[LAG_SAMPLES];
;1608:	int		frameCount;
;1609:	int		snapshotFlags[LAG_SAMPLES];
;1610:	int		snapshotSamples[LAG_SAMPLES];
;1611:	int		snapshotCount;
;1612:} lagometer_t;
;1613:
;1614:lagometer_t		lagometer;
;1615:
;1616:/*
;1617:==============
;1618:CG_AddLagometerFrameInfo
;1619:
;1620:Adds the current interpolate / extrapolate bar for this frame
;1621:==============
;1622:*/
;1623:void CG_AddLagometerFrameInfo( void ) {
line 1626
;1624:	int			offset;
;1625:
;1626:	offset = cg.time - cg.latestSnapshotTime;
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+32
INDIRI4
SUBI4
ASGNI4
line 1627
;1627:	lagometer.frameSamples[ lagometer.frameCount & ( LAG_SAMPLES - 1) ] = offset;
ADDRGP4 lagometer+512
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1628
;1628:	lagometer.frameCount++;
ADDRLP4 4
ADDRGP4 lagometer+512
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1629
;1629:}
LABELV $769
endproc CG_AddLagometerFrameInfo 8 0
export CG_AddLagometerSnapshotInfo
proc CG_AddLagometerSnapshotInfo 4 0
line 1641
;1630:
;1631:/*
;1632:==============
;1633:CG_AddLagometerSnapshotInfo
;1634:
;1635:Each time a snapshot is received, log its ping time and
;1636:the number of snapshots that were dropped before it.
;1637:
;1638:Pass NULL for a dropped packet.
;1639:==============
;1640:*/
;1641:void CG_AddLagometerSnapshotInfo( snapshot_t *snap ) {
line 1643
;1642:	// dropped packet
;1643:	if ( !snap ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $775
line 1644
;1644:		lagometer.snapshotSamples[ lagometer.snapshotCount & ( LAG_SAMPLES - 1) ] = -1;
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+1028
ADDP4
CNSTI4 -1
ASGNI4
line 1645
;1645:		lagometer.snapshotCount++;
ADDRLP4 0
ADDRGP4 lagometer+1540
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1646
;1646:		return;
ADDRGP4 $774
JUMPV
LABELV $775
line 1650
;1647:	}
;1648:
;1649:	// add this snapshot's info
;1650:	lagometer.snapshotSamples[ lagometer.snapshotCount & ( LAG_SAMPLES - 1) ] = snap->ping;
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+1028
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
line 1651
;1651:	lagometer.snapshotFlags[ lagometer.snapshotCount & ( LAG_SAMPLES - 1) ] = snap->snapFlags;
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+516
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 1652
;1652:	lagometer.snapshotCount++;
ADDRLP4 0
ADDRGP4 lagometer+1540
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1653
;1653:}
LABELV $774
endproc CG_AddLagometerSnapshotInfo 4 0
proc CG_DrawDisconnect 64 20
line 1662
;1654:
;1655:/*
;1656:==============
;1657:CG_DrawDisconnect
;1658:
;1659:Should we draw something differnet for long lag vs no packets?
;1660:==============
;1661:*/
;1662:static void CG_DrawDisconnect( void ) {
line 1670
;1663:	float		x, y;
;1664:	int			cmdNum;
;1665:	usercmd_t	cmd;
;1666:	const char		*s;
;1667:	int			w;  // bk010215 - FIXME char message[1024];
;1668:
;1669:	// draw the phone jack if we are completely past our buffers
;1670:	cmdNum = trap_GetCurrentCmdNumber() - CMD_BACKUP + 1;
ADDRLP4 44
ADDRGP4 trap_GetCurrentCmdNumber
CALLI4
ASGNI4
ADDRLP4 36
ADDRLP4 44
INDIRI4
CNSTI4 64
SUBI4
CNSTI4 1
ADDI4
ASGNI4
line 1671
;1671:	trap_GetUserCmd( cmdNum, &cmd );
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_GetUserCmd
CALLI4
pop
line 1672
;1672:	if ( cmd.serverTime <= cg.snap->ps.commandTime
ADDRLP4 48
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 48
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
LEI4 $790
ADDRLP4 48
INDIRI4
ADDRGP4 cg+107604
INDIRI4
LEI4 $786
LABELV $790
line 1673
;1673:		|| cmd.serverTime > cg.time ) {	// special check for map_restart // bk 0102165 - FIXME
line 1674
;1674:		return;
ADDRGP4 $785
JUMPV
LABELV $786
line 1678
;1675:	}
;1676:
;1677:	// also add text in center of screen
;1678:	s = "Connection Interrupted"; // bk 010215 - FIXME
ADDRLP4 24
ADDRGP4 $791
ASGNP4
line 1679
;1679:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 52
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 52
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 1680
;1680:	CG_DrawBigString( 320 - w/2, 100, s, 1.0F);
CNSTI4 320
ADDRLP4 40
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 100
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1683
;1681:
;1682:	// blink the icon
;1683:	if ( ( cg.time >> 9 ) & 1 ) {
ADDRGP4 cg+107604
INDIRI4
CNSTI4 9
RSHI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $792
line 1684
;1684:		return;
ADDRGP4 $785
JUMPV
LABELV $792
line 1687
;1685:	}
;1686:
;1687:	x = 640 - 48;
ADDRLP4 28
CNSTF4 1142161408
ASGNF4
line 1688
;1688:	y = 480 - 48;
ADDRLP4 32
CNSTF4 1138229248
ASGNF4
line 1690
;1689:
;1690:	CG_DrawPic( x, y, 48, 48, trap_R_RegisterShader("gfx/2d/net.tga" ) );
ADDRGP4 $795
ARGP4
ADDRLP4 56
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 28
INDIRF4
ARGF4
ADDRLP4 32
INDIRF4
ARGF4
ADDRLP4 60
CNSTF4 1111490560
ASGNF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 56
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1691
;1691:}
LABELV $785
endproc CG_DrawDisconnect 64 20
proc CG_DrawLagometer 68 36
line 1702
;1692:
;1693:
;1694:#define	MAX_LAGOMETER_PING	900
;1695:#define	MAX_LAGOMETER_RANGE	300
;1696:
;1697:/*
;1698:==============
;1699:CG_DrawLagometer
;1700:==============
;1701:*/
;1702:static void CG_DrawLagometer( void ) {
line 1709
;1703:	int		a, x, y, i;
;1704:	float	v;
;1705:	float	ax, ay, aw, ah, mid, range;
;1706:	int		color;
;1707:	float	vscale;
;1708:
;1709:	if ( !cg_lagometer.integer || cgs.localServer ) {
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRGP4 cg_lagometer+12
INDIRI4
ADDRLP4 52
INDIRI4
EQI4 $801
ADDRGP4 cgs+31452
INDIRI4
ADDRLP4 52
INDIRI4
EQI4 $797
LABELV $801
line 1710
;1710:		CG_DrawDisconnect();
ADDRGP4 CG_DrawDisconnect
CALLV
pop
line 1711
;1711:		return;
ADDRGP4 $796
JUMPV
LABELV $797
line 1721
;1712:	}
;1713:
;1714:	//
;1715:	// draw the graph
;1716:	//
;1717:#ifdef MISSIONPACK
;1718:	x = 640 - 48;
;1719:	y = 480 - 144;
;1720:#else
;1721:	x = 640 - 48;
ADDRLP4 44
CNSTI4 592
ASGNI4
line 1722
;1722:	y = 480 - 48;
ADDRLP4 48
CNSTI4 432
ASGNI4
line 1725
;1723:#endif
;1724:
;1725:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1726
;1726:	CG_DrawPic( x, y, 48, 48, cgs.media.lagometerShader );
ADDRLP4 44
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 48
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 56
CNSTF4 1111490560
ASGNF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRGP4 cgs+152340+264
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1728
;1727:
;1728:	ax = x;
ADDRLP4 24
ADDRLP4 44
INDIRI4
CVIF4 4
ASGNF4
line 1729
;1729:	ay = y;
ADDRLP4 36
ADDRLP4 48
INDIRI4
CVIF4 4
ASGNF4
line 1730
;1730:	aw = 48;
ADDRLP4 12
CNSTF4 1111490560
ASGNF4
line 1731
;1731:	ah = 48;
ADDRLP4 32
CNSTF4 1111490560
ASGNF4
line 1732
;1732:	CG_AdjustFrom640( &ax, &ay, &aw, &ah );
ADDRLP4 24
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 32
ARGP4
ADDRGP4 CG_AdjustFrom640
CALLV
pop
line 1734
;1733:
;1734:	color = -1;
ADDRLP4 20
CNSTI4 -1
ASGNI4
line 1735
;1735:	range = ah / 3;
ADDRLP4 16
ADDRLP4 32
INDIRF4
CNSTF4 1077936128
DIVF4
ASGNF4
line 1736
;1736:	mid = ay + range;
ADDRLP4 40
ADDRLP4 36
INDIRF4
ADDRLP4 16
INDIRF4
ADDF4
ASGNF4
line 1738
;1737:
;1738:	vscale = range / MAX_LAGOMETER_RANGE;
ADDRLP4 28
ADDRLP4 16
INDIRF4
CNSTF4 1133903872
DIVF4
ASGNF4
line 1741
;1739:
;1740:	// draw the frame interpoalte / extrapolate graph
;1741:	for ( a = 0 ; a < aw ; a++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $807
JUMPV
LABELV $804
line 1742
;1742:		i = ( lagometer.frameCount - 1 - a ) & (LAG_SAMPLES - 1);
ADDRLP4 8
ADDRGP4 lagometer+512
INDIRI4
CNSTI4 1
SUBI4
ADDRLP4 4
INDIRI4
SUBI4
CNSTI4 127
BANDI4
ASGNI4
line 1743
;1743:		v = lagometer.frameSamples[i];
ADDRLP4 0
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer
ADDP4
INDIRI4
CVIF4 4
ASGNF4
line 1744
;1744:		v *= vscale;
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 1745
;1745:		if ( v > 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
LEF4 $809
line 1746
;1746:			if ( color != 1 ) {
ADDRLP4 20
INDIRI4
CNSTI4 1
EQI4 $811
line 1747
;1747:				color = 1;
ADDRLP4 20
CNSTI4 1
ASGNI4
line 1748
;1748:				trap_R_SetColor( g_color_table[ColorIndex(COLOR_YELLOW)] );
ADDRGP4 g_color_table+48
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1749
;1749:			}
LABELV $811
line 1750
;1750:			if ( v > range ) {
ADDRLP4 0
INDIRF4
ADDRLP4 16
INDIRF4
LEF4 $814
line 1751
;1751:				v = range;
ADDRLP4 0
ADDRLP4 16
INDIRF4
ASGNF4
line 1752
;1752:			}
LABELV $814
line 1753
;1753:			trap_R_DrawStretchPic ( ax + aw - a, mid - v, 1, v, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 40
INDIRF4
ADDRLP4 0
INDIRF4
SUBF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 64
CNSTF4 0
ASGNF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1754
;1754:		} else if ( v < 0 ) {
ADDRGP4 $810
JUMPV
LABELV $809
ADDRLP4 0
INDIRF4
CNSTF4 0
GEF4 $818
line 1755
;1755:			if ( color != 2 ) {
ADDRLP4 20
INDIRI4
CNSTI4 2
EQI4 $820
line 1756
;1756:				color = 2;
ADDRLP4 20
CNSTI4 2
ASGNI4
line 1757
;1757:				trap_R_SetColor( g_color_table[ColorIndex(COLOR_BLUE)] );
ADDRGP4 g_color_table+64
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1758
;1758:			}
LABELV $820
line 1759
;1759:			v = -v;
ADDRLP4 0
ADDRLP4 0
INDIRF4
NEGF4
ASGNF4
line 1760
;1760:			if ( v > range ) {
ADDRLP4 0
INDIRF4
ADDRLP4 16
INDIRF4
LEF4 $823
line 1761
;1761:				v = range;
ADDRLP4 0
ADDRLP4 16
INDIRF4
ASGNF4
line 1762
;1762:			}
LABELV $823
line 1763
;1763:			trap_R_DrawStretchPic( ax + aw - a, mid, 1, v, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 40
INDIRF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 60
CNSTF4 0
ASGNF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1764
;1764:		}
LABELV $818
LABELV $810
line 1765
;1765:	}
LABELV $805
line 1741
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $807
ADDRLP4 4
INDIRI4
CVIF4 4
ADDRLP4 12
INDIRF4
LTF4 $804
line 1768
;1766:
;1767:	// draw the snapshot latency / drop graph
;1768:	range = ah / 2;
ADDRLP4 16
ADDRLP4 32
INDIRF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 1769
;1769:	vscale = range / MAX_LAGOMETER_PING;
ADDRLP4 28
ADDRLP4 16
INDIRF4
CNSTF4 1147207680
DIVF4
ASGNF4
line 1771
;1770:
;1771:	for ( a = 0 ; a < aw ; a++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $830
JUMPV
LABELV $827
line 1772
;1772:		i = ( lagometer.snapshotCount - 1 - a ) & (LAG_SAMPLES - 1);
ADDRLP4 8
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 1
SUBI4
ADDRLP4 4
INDIRI4
SUBI4
CNSTI4 127
BANDI4
ASGNI4
line 1773
;1773:		v = lagometer.snapshotSamples[i];
ADDRLP4 0
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+1028
ADDP4
INDIRI4
CVIF4 4
ASGNF4
line 1774
;1774:		if ( v > 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
LEF4 $833
line 1775
;1775:			if ( lagometer.snapshotFlags[i] & SNAPFLAG_RATE_DELAYED ) {
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+516
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $835
line 1776
;1776:				if ( color != 5 ) {
ADDRLP4 20
INDIRI4
CNSTI4 5
EQI4 $836
line 1777
;1777:					color = 5;	// YELLOW for rate delay
ADDRLP4 20
CNSTI4 5
ASGNI4
line 1778
;1778:					trap_R_SetColor( g_color_table[ColorIndex(COLOR_YELLOW)] );
ADDRGP4 g_color_table+48
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1779
;1779:				}
line 1780
;1780:			} else {
ADDRGP4 $836
JUMPV
LABELV $835
line 1781
;1781:				if ( color != 3 ) {
ADDRLP4 20
INDIRI4
CNSTI4 3
EQI4 $841
line 1782
;1782:					color = 3;
ADDRLP4 20
CNSTI4 3
ASGNI4
line 1783
;1783:					trap_R_SetColor( g_color_table[ColorIndex(COLOR_GREEN)] );
ADDRGP4 g_color_table+32
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1784
;1784:				}
LABELV $841
line 1785
;1785:			}
LABELV $836
line 1786
;1786:			v = v * vscale;
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 1787
;1787:			if ( v > range ) {
ADDRLP4 0
INDIRF4
ADDRLP4 16
INDIRF4
LEF4 $844
line 1788
;1788:				v = range;
ADDRLP4 0
ADDRLP4 16
INDIRF4
ASGNF4
line 1789
;1789:			}
LABELV $844
line 1790
;1790:			trap_R_DrawStretchPic( ax + aw - a, ay + ah - v, 1, v, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 36
INDIRF4
ADDRLP4 32
INDIRF4
ADDF4
ADDRLP4 0
INDIRF4
SUBF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 64
CNSTF4 0
ASGNF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1791
;1791:		} else if ( v < 0 ) {
ADDRGP4 $834
JUMPV
LABELV $833
ADDRLP4 0
INDIRF4
CNSTF4 0
GEF4 $848
line 1792
;1792:			if ( color != 4 ) {
ADDRLP4 20
INDIRI4
CNSTI4 4
EQI4 $850
line 1793
;1793:				color = 4;		// RED for dropped snapshots
ADDRLP4 20
CNSTI4 4
ASGNI4
line 1794
;1794:				trap_R_SetColor( g_color_table[ColorIndex(COLOR_RED)] );
ADDRGP4 g_color_table+16
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1795
;1795:			}
LABELV $850
line 1796
;1796:			trap_R_DrawStretchPic( ax + aw - a, ay + ah - range, 1, range, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 36
INDIRF4
ADDRLP4 32
INDIRF4
ADDF4
ADDRLP4 16
INDIRF4
SUBF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 64
CNSTF4 0
ASGNF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1797
;1797:		}
LABELV $848
LABELV $834
line 1798
;1798:	}
LABELV $828
line 1771
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $830
ADDRLP4 4
INDIRI4
CVIF4 4
ADDRLP4 12
INDIRF4
LTF4 $827
line 1800
;1799:
;1800:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1802
;1801:
;1802:	if ( cg_nopredict.integer || cg_synchronousClients.integer ) {
ADDRLP4 60
CNSTI4 0
ASGNI4
ADDRGP4 cg_nopredict+12
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $859
ADDRGP4 cg_synchronousClients+12
INDIRI4
ADDRLP4 60
INDIRI4
EQI4 $855
LABELV $859
line 1803
;1803:		CG_DrawBigString( ax, ay, "snc", 1.0 );
ADDRLP4 24
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 36
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 $860
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1804
;1804:	}
LABELV $855
line 1806
;1805:
;1806:	CG_DrawDisconnect();
ADDRGP4 CG_DrawDisconnect
CALLV
pop
line 1807
;1807:}
LABELV $796
endproc CG_DrawLagometer 68 36
export CG_CenterPrint
proc CG_CenterPrint 8 12
line 1828
;1808:
;1809:
;1810:
;1811:/*
;1812:===============================================================================
;1813:
;1814:CENTER PRINTING
;1815:
;1816:===============================================================================
;1817:*/
;1818:
;1819:
;1820:/*
;1821:==============
;1822:CG_CenterPrint
;1823:
;1824:Called for important messages that should stay in the center of the screen
;1825:for a few moments
;1826:==============
;1827:*/
;1828:void CG_CenterPrint( const char *str, int y, int charWidth ) {
line 1831
;1829:	char	*s;
;1830:
;1831:	Q_strncpyz( cg.centerPrint, str, sizeof(cg.centerPrint) );
ADDRGP4 cg+123364
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1833
;1832:
;1833:	cg.centerPrintTime = cg.time;
ADDRGP4 cg+123352
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1834
;1834:	cg.centerPrintY = y;
ADDRGP4 cg+123360
ADDRFP4 4
INDIRI4
ASGNI4
line 1835
;1835:	cg.centerPrintCharWidth = charWidth;
ADDRGP4 cg+123356
ADDRFP4 8
INDIRI4
ASGNI4
line 1838
;1836:
;1837:	// count the number of lines for centering
;1838:	cg.centerPrintLines = 1;
ADDRGP4 cg+124388
CNSTI4 1
ASGNI4
line 1839
;1839:	s = cg.centerPrint;
ADDRLP4 0
ADDRGP4 cg+123364
ASGNP4
ADDRGP4 $871
JUMPV
LABELV $870
line 1840
;1840:	while( *s ) {
line 1841
;1841:		if (*s == '\n')
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 10
NEI4 $873
line 1842
;1842:			cg.centerPrintLines++;
ADDRLP4 4
ADDRGP4 cg+124388
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $873
line 1843
;1843:		s++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1844
;1844:	}
LABELV $871
line 1840
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $870
line 1845
;1845:}
LABELV $861
endproc CG_CenterPrint 8 12
proc CG_DrawCenterString 1064 36
line 1853
;1846:
;1847:
;1848:/*
;1849:===================
;1850:CG_DrawCenterString
;1851:===================
;1852:*/
;1853:static void CG_DrawCenterString( void ) {
line 1862
;1854:	char	*start;
;1855:	int		l;
;1856:	int		x, y, w;
;1857:#ifdef MISSIONPACK // bk010221 - unused else
;1858:  int h;
;1859:#endif
;1860:	float	*color;
;1861:
;1862:	if ( !cg.centerPrintTime ) {
ADDRGP4 cg+123352
INDIRI4
CNSTI4 0
NEI4 $877
line 1863
;1863:		return;
ADDRGP4 $876
JUMPV
LABELV $877
line 1866
;1864:	}
;1865:
;1866:	color = CG_FadeColor( cg.centerPrintTime, 1000 * cg_centertime.value );
ADDRGP4 cg+123352
INDIRI4
ARGI4
CNSTF4 1148846080
ADDRGP4 cg_centertime+8
INDIRF4
MULF4
CVFI4 4
ARGI4
ADDRLP4 24
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 24
INDIRP4
ASGNP4
line 1867
;1867:	if ( !color ) {
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $882
line 1868
;1868:		return;
ADDRGP4 $876
JUMPV
LABELV $882
line 1871
;1869:	}
;1870:
;1871:	trap_R_SetColor( color );
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1873
;1872:
;1873:	start = cg.centerPrint;
ADDRLP4 0
ADDRGP4 cg+123364
ASGNP4
line 1875
;1874:
;1875:	y = cg.centerPrintY - cg.centerPrintLines * BIGCHAR_HEIGHT / 2;
ADDRLP4 8
ADDRGP4 cg+123360
INDIRI4
ADDRGP4 cg+124388
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 2
DIVI4
SUBI4
ASGNI4
ADDRGP4 $888
JUMPV
LABELV $887
line 1877
;1876:
;1877:	while ( 1 ) {
line 1880
;1878:		char linebuffer[1024];
;1879:
;1880:		for ( l = 0; l < 50; l++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $890
line 1881
;1881:			if ( !start[l] || start[l] == '\n' ) {
ADDRLP4 1052
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1052
INDIRI4
CNSTI4 0
EQI4 $896
ADDRLP4 1052
INDIRI4
CNSTI4 10
NEI4 $894
LABELV $896
line 1882
;1882:				break;
ADDRGP4 $892
JUMPV
LABELV $894
line 1884
;1883:			}
;1884:			linebuffer[l] = start[l];
ADDRLP4 4
INDIRI4
ADDRLP4 28
ADDP4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
ADDP4
INDIRI1
ASGNI1
line 1885
;1885:		}
LABELV $891
line 1880
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 50
LTI4 $890
LABELV $892
line 1886
;1886:		linebuffer[l] = 0;
ADDRLP4 4
INDIRI4
ADDRLP4 28
ADDP4
CNSTI1 0
ASGNI1
line 1895
;1887:
;1888:#ifdef MISSIONPACK
;1889:		w = CG_Text_Width(linebuffer, 0.5, 0);
;1890:		h = CG_Text_Height(linebuffer, 0.5, 0);
;1891:		x = (SCREEN_WIDTH - w) / 2;
;1892:		CG_Text_Paint(x, y + h, 0.5, color, linebuffer, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;1893:		y += h + 6;
;1894:#else
;1895:		w = cg.centerPrintCharWidth * CG_DrawStrlen( linebuffer );
ADDRLP4 28
ARGP4
ADDRLP4 1052
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRGP4 cg+123356
INDIRI4
ADDRLP4 1052
INDIRI4
MULI4
ASGNI4
line 1897
;1896:
;1897:		x = ( SCREEN_WIDTH - w ) / 2;
ADDRLP4 12
CNSTI4 640
ADDRLP4 16
INDIRI4
SUBI4
CNSTI4 2
DIVI4
ASGNI4
line 1899
;1898:
;1899:		CG_DrawStringExt( x, y, linebuffer, color, qfalse, qtrue,
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 28
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 1056
CNSTI4 0
ASGNI4
ADDRLP4 1056
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 cg+123356
INDIRI4
ARGI4
CNSTF4 1069547520
ADDRGP4 cg+123356
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 1056
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 1902
;1900:			cg.centerPrintCharWidth, (int)(cg.centerPrintCharWidth * 1.5), 0 );
;1901:
;1902:		y += cg.centerPrintCharWidth * 1.5;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CVIF4 4
CNSTF4 1069547520
ADDRGP4 cg+123356
INDIRI4
CVIF4 4
MULF4
ADDF4
CVFI4 4
ASGNI4
ADDRGP4 $902
JUMPV
LABELV $901
line 1904
;1903:#endif
;1904:		while ( *start && ( *start != '\n' ) ) {
line 1905
;1905:			start++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1906
;1906:		}
LABELV $902
line 1904
ADDRLP4 1060
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
EQI4 $904
ADDRLP4 1060
INDIRI4
CNSTI4 10
NEI4 $901
LABELV $904
line 1907
;1907:		if ( !*start ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $905
line 1908
;1908:			break;
ADDRGP4 $889
JUMPV
LABELV $905
line 1910
;1909:		}
;1910:		start++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1911
;1911:	}
LABELV $888
line 1877
ADDRGP4 $887
JUMPV
LABELV $889
line 1913
;1912:
;1913:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1914
;1914:}
LABELV $876
endproc CG_DrawCenterString 1064 36
proc CG_DrawCrosshair 56 36
line 1932
;1915:
;1916:
;1917:
;1918:/*
;1919:================================================================================
;1920:
;1921:CROSSHAIR
;1922:
;1923:================================================================================
;1924:*/
;1925:
;1926:
;1927:/*
;1928:=================
;1929:CG_DrawCrosshair
;1930:=================
;1931:*/
;1932:static void CG_DrawCrosshair(void) {
line 1939
;1933:	float		w, h;
;1934:	qhandle_t	hShader;
;1935:	float		f;
;1936:	float		x, y;
;1937:	int			ca;
;1938:
;1939:	if ( !cg_drawCrosshair.integer ) {
ADDRGP4 cg_drawCrosshair+12
INDIRI4
CNSTI4 0
NEI4 $908
line 1940
;1940:		return;
ADDRGP4 $907
JUMPV
LABELV $908
line 1943
;1941:	}
;1942:
;1943:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $911
line 1944
;1944:		return;
ADDRGP4 $907
JUMPV
LABELV $911
line 1947
;1945:	}
;1946:
;1947:	if ( cg.renderingThirdPerson ) {
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
EQI4 $914
line 1948
;1948:		return;
ADDRGP4 $907
JUMPV
LABELV $914
line 1952
;1949:	}
;1950:
;1951:	// set color based on health
;1952:	if ( cg_crosshairHealth.integer ) {
ADDRGP4 cg_crosshairHealth+12
INDIRI4
CNSTI4 0
EQI4 $917
line 1955
;1953:		vec4_t		hcolor;
;1954:
;1955:		CG_ColorForHealth( hcolor );
ADDRLP4 28
ARGP4
ADDRGP4 CG_ColorForHealth
CALLV
pop
line 1956
;1956:		trap_R_SetColor( hcolor );
ADDRLP4 28
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1957
;1957:	} else {
ADDRGP4 $918
JUMPV
LABELV $917
line 1958
;1958:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1959
;1959:	}
LABELV $918
line 1961
;1960:
;1961:	w = h = cg_crosshairSize.value;
ADDRLP4 28
ADDRGP4 cg_crosshairSize+8
INDIRF4
ASGNF4
ADDRLP4 4
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 28
INDIRF4
ASGNF4
line 1964
;1962:
;1963:	// pulse the size of the crosshair when picking up items
;1964:	f = cg.time - cg.itemPickupBlendTime;
ADDRLP4 8
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124672
INDIRI4
SUBI4
CVIF4 4
ASGNF4
line 1965
;1965:	if ( f > 0 && f < ITEM_BLOB_TIME ) {
ADDRLP4 8
INDIRF4
CNSTF4 0
LEF4 $923
ADDRLP4 8
INDIRF4
CNSTF4 1128792064
GEF4 $923
line 1966
;1966:		f /= ITEM_BLOB_TIME;
ADDRLP4 8
ADDRLP4 8
INDIRF4
CNSTF4 1128792064
DIVF4
ASGNF4
line 1967
;1967:		w *= ( 1 + f );
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 8
INDIRF4
CNSTF4 1065353216
ADDF4
MULF4
ASGNF4
line 1968
;1968:		h *= ( 1 + f );
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 8
INDIRF4
CNSTF4 1065353216
ADDF4
MULF4
ASGNF4
line 1969
;1969:	}
LABELV $923
line 1971
;1970:
;1971:	x = cg_crosshairX.integer;
ADDRLP4 16
ADDRGP4 cg_crosshairX+12
INDIRI4
CVIF4 4
ASGNF4
line 1972
;1972:	y = cg_crosshairY.integer;
ADDRLP4 20
ADDRGP4 cg_crosshairY+12
INDIRI4
CVIF4 4
ASGNF4
line 1973
;1973:	CG_AdjustFrom640( &x, &y, &w, &h );
ADDRLP4 16
ARGP4
ADDRLP4 20
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 CG_AdjustFrom640
CALLV
pop
line 1975
;1974:
;1975:	ca = cg_drawCrosshair.integer;
ADDRLP4 12
ADDRGP4 cg_drawCrosshair+12
INDIRI4
ASGNI4
line 1976
;1976:	if (ca < 0) {
ADDRLP4 12
INDIRI4
CNSTI4 0
GEI4 $928
line 1977
;1977:		ca = 0;
ADDRLP4 12
CNSTI4 0
ASGNI4
line 1978
;1978:	}
LABELV $928
line 1979
;1979:	hShader = cgs.media.crosshairShader[ ca % NUM_CROSSHAIRS ];
ADDRLP4 24
ADDRLP4 12
INDIRI4
CNSTI4 10
MODI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+224
ADDP4
INDIRI4
ASGNI4
line 1981
;1980:
;1981:	trap_R_DrawStretchPic( x + cg.refdef.x + 0.5 * (cg.refdef.width - w), 
ADDRLP4 36
CNSTF4 1056964608
ASGNF4
ADDRLP4 40
ADDRLP4 0
INDIRF4
ASGNF4
ADDRLP4 16
INDIRF4
ADDRGP4 cg+109044
INDIRI4
CVIF4 4
ADDF4
ADDRLP4 36
INDIRF4
ADDRGP4 cg+109044+8
INDIRI4
CVIF4 4
ADDRLP4 40
INDIRF4
SUBF4
MULF4
ADDF4
ARGF4
ADDRLP4 44
ADDRLP4 4
INDIRF4
ASGNF4
ADDRLP4 20
INDIRF4
ADDRGP4 cg+109044+4
INDIRI4
CVIF4 4
ADDF4
ADDRLP4 36
INDIRF4
ADDRGP4 cg+109044+12
INDIRI4
CVIF4 4
ADDRLP4 44
INDIRF4
SUBF4
MULF4
ADDF4
ARGF4
ADDRLP4 40
INDIRF4
ARGF4
ADDRLP4 44
INDIRF4
ARGF4
ADDRLP4 48
CNSTF4 0
ASGNF4
ADDRLP4 48
INDIRF4
ARGF4
ADDRLP4 48
INDIRF4
ARGF4
ADDRLP4 52
CNSTF4 1065353216
ASGNF4
ADDRLP4 52
INDIRF4
ARGF4
ADDRLP4 52
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1984
;1982:		y + cg.refdef.y + 0.5 * (cg.refdef.height - h), 
;1983:		w, h, 0, 0, 1, 1, hShader );
;1984:}
LABELV $907
endproc CG_DrawCrosshair 56 36
proc CG_ScanForCrosshairEntity 96 28
line 1993
;1985:
;1986:
;1987:
;1988:/*
;1989:=================
;1990:CG_ScanForCrosshairEntity
;1991:=================
;1992:*/
;1993:static void CG_ScanForCrosshairEntity( void ) {
line 1998
;1994:	trace_t		trace;
;1995:	vec3_t		start, end;
;1996:	int			content;
;1997:
;1998:	VectorCopy( cg.refdef.vieworg, start );
ADDRLP4 56
ADDRGP4 cg+109044+24
INDIRB
ASGNB 12
line 1999
;1999:	VectorMA( start, 131072, cg.refdef.viewaxis[0], end );
ADDRLP4 84
CNSTF4 1207959552
ASGNF4
ADDRLP4 68
ADDRLP4 56
INDIRF4
ADDRLP4 84
INDIRF4
ADDRGP4 cg+109044+36
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 68+4
ADDRLP4 56+4
INDIRF4
ADDRLP4 84
INDIRF4
ADDRGP4 cg+109044+36+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 68+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1207959552
ADDRGP4 cg+109044+36+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2001
;2000:
;2001:	CG_Trace( &trace, start, vec3_origin, vec3_origin, end, 
ADDRLP4 0
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 88
ADDRGP4 vec3_origin
ASGNP4
ADDRLP4 88
INDIRP4
ARGP4
ADDRLP4 88
INDIRP4
ARGP4
ADDRLP4 68
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
CNSTI4 33554433
ARGI4
ADDRGP4 CG_Trace
CALLV
pop
line 2003
;2002:		cg.snap->ps.clientNum, CONTENTS_SOLID|CONTENTS_BODY );
;2003:	if ( trace.entityNum >= MAX_CLIENTS ) {
ADDRLP4 0+52
INDIRI4
CNSTI4 64
LTI4 $955
line 2004
;2004:		return;
ADDRGP4 $939
JUMPV
LABELV $955
line 2008
;2005:	}
;2006:
;2007:	// if the player is in fog, don't show it
;2008:	content = trap_CM_PointContents( trace.endpos, 0 );
ADDRLP4 0+12
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 92
ADDRGP4 trap_CM_PointContents
CALLI4
ASGNI4
ADDRLP4 80
ADDRLP4 92
INDIRI4
ASGNI4
line 2009
;2009:	if ( content & CONTENTS_FOG ) {
ADDRLP4 80
INDIRI4
CNSTI4 64
BANDI4
CNSTI4 0
EQI4 $959
line 2010
;2010:		return;
ADDRGP4 $939
JUMPV
LABELV $959
line 2014
;2011:	}
;2012:
;2013:	// if the player is invisible, don't show it
;2014:	if ( cg_entities[ trace.entityNum ].currentState.powerups & ( 1 << PW_INVIS ) ) {
CNSTI4 728
ADDRLP4 0+52
INDIRI4
MULI4
ADDRGP4 cg_entities+188
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $961
line 2015
;2015:		return;
ADDRGP4 $939
JUMPV
LABELV $961
line 2019
;2016:	}
;2017:
;2018:	// update the fade timer
;2019:	cg.crosshairClientNum = trace.entityNum;
ADDRGP4 cg+124400
ADDRLP4 0+52
INDIRI4
ASGNI4
line 2020
;2020:	cg.crosshairClientTime = cg.time;
ADDRGP4 cg+124404
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 2021
;2021:}
LABELV $939
endproc CG_ScanForCrosshairEntity 96 28
proc CG_DrawCrosshairNames 20 16
line 2029
;2022:
;2023:
;2024:/*
;2025:=====================
;2026:CG_DrawCrosshairNames
;2027:=====================
;2028:*/
;2029:static void CG_DrawCrosshairNames( void ) {
line 2034
;2030:	float		*color;
;2031:	char		*name;
;2032:	float		w;
;2033:
;2034:	if ( !cg_drawCrosshair.integer ) {
ADDRGP4 cg_drawCrosshair+12
INDIRI4
CNSTI4 0
NEI4 $970
line 2035
;2035:		return;
ADDRGP4 $969
JUMPV
LABELV $970
line 2037
;2036:	}
;2037:	if ( !cg_drawCrosshairNames.integer ) {
ADDRGP4 cg_drawCrosshairNames+12
INDIRI4
CNSTI4 0
NEI4 $973
line 2038
;2038:		return;
ADDRGP4 $969
JUMPV
LABELV $973
line 2040
;2039:	}
;2040:	if ( cg.renderingThirdPerson ) {
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
EQI4 $976
line 2041
;2041:		return;
ADDRGP4 $969
JUMPV
LABELV $976
line 2045
;2042:	}
;2043:
;2044:	// scan the known entities to see if the crosshair is sighted on one
;2045:	CG_ScanForCrosshairEntity();
ADDRGP4 CG_ScanForCrosshairEntity
CALLV
pop
line 2048
;2046:
;2047:	// draw the name of the player being looked at
;2048:	color = CG_FadeColor( cg.crosshairClientTime, 1000 );
ADDRGP4 cg+124404
INDIRI4
ARGI4
CNSTI4 1000
ARGI4
ADDRLP4 12
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 2049
;2049:	if ( !color ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $980
line 2050
;2050:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 2051
;2051:		return;
ADDRGP4 $969
JUMPV
LABELV $980
line 2054
;2052:	}
;2053:
;2054:	name = cgs.clientinfo[ cg.crosshairClientNum ].name;
ADDRLP4 4
CNSTI4 1708
ADDRGP4 cg+124400
INDIRI4
MULI4
ADDRGP4 cgs+40972+4
ADDP4
ASGNP4
line 2060
;2055:#ifdef MISSIONPACK
;2056:	color[3] *= 0.5f;
;2057:	w = CG_Text_Width(name, 0.3f, 0);
;2058:	CG_Text_Paint( 320 - w / 2, 190, 0.3f, color, name, 0, 0, ITEM_TEXTSTYLE_SHADOWED);
;2059:#else
;2060:	w = CG_DrawStrlen( name ) * BIGCHAR_WIDTH;
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 16
INDIRI4
CNSTI4 4
LSHI4
CVIF4 4
ASGNF4
line 2061
;2061:	CG_DrawBigString( 320 - w / 2, 170, name, color[3] * 0.5f );
CNSTF4 1134559232
ADDRLP4 8
INDIRF4
CNSTF4 1073741824
DIVF4
SUBF4
CVFI4 4
ARGI4
CNSTI4 170
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
CNSTF4 1056964608
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRF4
MULF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2063
;2062:#endif
;2063:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 2064
;2064:}
LABELV $969
endproc CG_DrawCrosshairNames 20 16
proc CG_DrawSpectator 0 16
line 2074
;2065:
;2066:
;2067://==============================================================================
;2068:
;2069:/*
;2070:=================
;2071:CG_DrawSpectator
;2072:=================
;2073:*/
;2074:static void CG_DrawSpectator(void) {
line 2075
;2075:	CG_DrawBigString(320 - 9 * 8, 440, "SPECTATOR", 1.0F);
CNSTI4 248
ARGI4
CNSTI4 440
ARGI4
ADDRGP4 $986
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2076
;2076:	if ( cgs.gametype == GT_TOURNAMENT ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 1
NEI4 $987
line 2077
;2077:		CG_DrawBigString(320 - 15 * 8, 460, "waiting to play", 1.0F);
CNSTI4 200
ARGI4
CNSTI4 460
ARGI4
ADDRGP4 $990
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2078
;2078:	}
ADDRGP4 $988
JUMPV
LABELV $987
line 2079
;2079:	else if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $991
line 2080
;2080:		CG_DrawBigString(320 - 39 * 8, 460, "press ESC and use the JOIN menu to play", 1.0F);
CNSTI4 8
ARGI4
CNSTI4 460
ARGI4
ADDRGP4 $994
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2081
;2081:	}
LABELV $991
LABELV $988
line 2082
;2082:}
LABELV $985
endproc CG_DrawSpectator 0 16
proc CG_DrawVote 12 20
line 2089
;2083:
;2084:/*
;2085:=================
;2086:CG_DrawVote
;2087:=================
;2088:*/
;2089:static void CG_DrawVote(void) {
line 2093
;2090:	char	*s;
;2091:	int		sec;
;2092:
;2093:	if ( !cgs.voteTime ) {
ADDRGP4 cgs+31676
INDIRI4
CNSTI4 0
NEI4 $996
line 2094
;2094:		return;
ADDRGP4 $995
JUMPV
LABELV $996
line 2098
;2095:	}
;2096:
;2097:	// play a talk beep whenever it is modified
;2098:	if ( cgs.voteModified ) {
ADDRGP4 cgs+31688
INDIRI4
CNSTI4 0
EQI4 $999
line 2099
;2099:		cgs.voteModified = qfalse;
ADDRGP4 cgs+31688
CNSTI4 0
ASGNI4
line 2100
;2100:		trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+732
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2101
;2101:	}
LABELV $999
line 2103
;2102:
;2103:	sec = ( VOTE_TIME - ( cg.time - cgs.voteTime ) ) / 1000;
ADDRLP4 0
CNSTI4 30000
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cgs+31676
INDIRI4
SUBI4
SUBI4
CNSTI4 1000
DIVI4
ASGNI4
line 2104
;2104:	if ( sec < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1007
line 2105
;2105:		sec = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2106
;2106:	}
LABELV $1007
line 2113
;2107:#ifdef MISSIONPACK
;2108:	s = va("VOTE(%i):%s yes:%i no:%i", sec, cgs.voteString, cgs.voteYes, cgs.voteNo);
;2109:	CG_DrawSmallString( 0, 58, s, 1.0F );
;2110:	s = "or press ESC then click Vote";
;2111:	CG_DrawSmallString( 0, 58 + SMALLCHAR_HEIGHT + 2, s, 1.0F );
;2112:#else
;2113:	s = va("VOTE(%i):%s yes:%i no:%i", sec, cgs.voteString, cgs.voteYes, cgs.voteNo );
ADDRGP4 $1009
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 cgs+31692
ARGP4
ADDRGP4 cgs+31680
INDIRI4
ARGI4
ADDRGP4 cgs+31684
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
ASGNP4
line 2114
;2114:	CG_DrawSmallString( 0, 58, s, 1.0F );
CNSTI4 0
ARGI4
CNSTI4 58
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawSmallString
CALLV
pop
line 2116
;2115:#endif
;2116:}
LABELV $995
endproc CG_DrawVote 12 20
proc CG_DrawTeamVote 24 20
line 2123
;2117:
;2118:/*
;2119:=================
;2120:CG_DrawTeamVote
;2121:=================
;2122:*/
;2123:static void CG_DrawTeamVote(void) {
line 2127
;2124:	char	*s;
;2125:	int		sec, cs_offset;
;2126:
;2127:	if ( cgs.clientinfo->team == TEAM_RED )
ADDRGP4 cgs+40972+68
INDIRI4
CNSTI4 1
NEI4 $1014
line 2128
;2128:		cs_offset = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1015
JUMPV
LABELV $1014
line 2129
;2129:	else if ( cgs.clientinfo->team == TEAM_BLUE )
ADDRGP4 cgs+40972+68
INDIRI4
CNSTI4 2
NEI4 $1013
line 2130
;2130:		cs_offset = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 2132
;2131:	else
;2132:		return;
LABELV $1019
LABELV $1015
line 2134
;2133:
;2134:	if ( !cgs.teamVoteTime[cs_offset] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32716
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1022
line 2135
;2135:		return;
ADDRGP4 $1013
JUMPV
LABELV $1022
line 2139
;2136:	}
;2137:
;2138:	// play a talk beep whenever it is modified
;2139:	if ( cgs.teamVoteModified[cs_offset] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32740
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1025
line 2140
;2140:		cgs.teamVoteModified[cs_offset] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32740
ADDP4
CNSTI4 0
ASGNI4
line 2141
;2141:		trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+732
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2142
;2142:	}
LABELV $1025
line 2144
;2143:
;2144:	sec = ( VOTE_TIME - ( cg.time - cgs.teamVoteTime[cs_offset] ) ) / 1000;
ADDRLP4 4
CNSTI4 30000
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32716
ADDP4
INDIRI4
SUBI4
SUBI4
CNSTI4 1000
DIVI4
ASGNI4
line 2145
;2145:	if ( sec < 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $1033
line 2146
;2146:		sec = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 2147
;2147:	}
LABELV $1033
line 2148
;2148:	s = va("TEAMVOTE(%i):%s yes:%i no:%i", sec, cgs.teamVoteString[cs_offset],
ADDRGP4 $1035
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 0
INDIRI4
CNSTI4 10
LSHI4
ADDRGP4 cgs+32748
ADDP4
ARGP4
ADDRLP4 16
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 16
INDIRI4
ADDRGP4 cgs+32724
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
INDIRI4
ADDRGP4 cgs+32732
ADDP4
INDIRI4
ARGI4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 20
INDIRP4
ASGNP4
line 2150
;2149:							cgs.teamVoteYes[cs_offset], cgs.teamVoteNo[cs_offset] );
;2150:	CG_DrawSmallString( 0, 90, s, 1.0F );
CNSTI4 0
ARGI4
CNSTI4 90
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawSmallString
CALLV
pop
line 2151
;2151:}
LABELV $1013
endproc CG_DrawTeamVote 24 20
proc CG_DrawScoreboard 4 0
line 2154
;2152:
;2153:
;2154:static qboolean CG_DrawScoreboard() {
line 2219
;2155:#ifdef MISSIONPACK
;2156:	static qboolean firstTime = qtrue;
;2157:	float fade, *fadeColor;
;2158:
;2159:	if (menuScoreboard) {
;2160:		menuScoreboard->window.flags &= ~WINDOW_FORCED;
;2161:	}
;2162:	if (cg_paused.integer) {
;2163:		cg.deferredPlayerLoading = 0;
;2164:		firstTime = qtrue;
;2165:		return qfalse;
;2166:	}
;2167:
;2168:	// should never happen in Team Arena
;2169:	if (cgs.gametype == GT_SINGLE_PLAYER && cg.predictedPlayerState.pm_type == PM_INTERMISSION ) {
;2170:		cg.deferredPlayerLoading = 0;
;2171:		firstTime = qtrue;
;2172:		return qfalse;
;2173:	}
;2174:
;2175:	// don't draw scoreboard during death while warmup up
;2176:	if ( cg.warmup && !cg.showScores ) {
;2177:		return qfalse;
;2178:	}
;2179:
;2180:	if ( cg.showScores || cg.predictedPlayerState.pm_type == PM_DEAD || cg.predictedPlayerState.pm_type == PM_INTERMISSION ) {
;2181:		fade = 1.0;
;2182:		fadeColor = colorWhite;
;2183:	} else {
;2184:		fadeColor = CG_FadeColor( cg.scoreFadeTime, FADE_TIME );
;2185:		if ( !fadeColor ) {
;2186:			// next time scoreboard comes up, don't print killer
;2187:			cg.deferredPlayerLoading = 0;
;2188:			cg.killerName[0] = 0;
;2189:			firstTime = qtrue;
;2190:			return qfalse;
;2191:		}
;2192:		fade = *fadeColor;
;2193:	}																					  
;2194:
;2195:
;2196:	if (menuScoreboard == NULL) {
;2197:		if ( cgs.gametype >= GT_TEAM ) {
;2198:			menuScoreboard = Menus_FindByName("teamscore_menu");
;2199:		} else {
;2200:			menuScoreboard = Menus_FindByName("score_menu");
;2201:		}
;2202:	}
;2203:
;2204:	if (menuScoreboard) {
;2205:		if (firstTime) {
;2206:			CG_SetScoreSelection(menuScoreboard);
;2207:			firstTime = qfalse;
;2208:		}
;2209:		Menu_Paint(menuScoreboard, qtrue);
;2210:	}
;2211:
;2212:	// load any models that have been deferred
;2213:	if ( ++cg.deferredPlayerLoading > 10 ) {
;2214:		CG_LoadDeferredPlayers();
;2215:	}
;2216:
;2217:	return qtrue;
;2218:#else
;2219:	return CG_DrawOldScoreboard();
ADDRLP4 0
ADDRGP4 CG_DrawOldScoreboard
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
RETI4
LABELV $1039
endproc CG_DrawScoreboard 4 0
proc CG_DrawIntermission 4 0
line 2228
;2220:#endif
;2221:}
;2222:
;2223:/*
;2224:=================
;2225:CG_DrawIntermission
;2226:=================
;2227:*/
;2228:static void CG_DrawIntermission( void ) {
line 2236
;2229://	int key;
;2230:#ifdef MISSIONPACK
;2231:	//if (cg_singlePlayer.integer) {
;2232:	//	CG_DrawCenterString();
;2233:	//	return;
;2234:	//}
;2235:#else
;2236:	if ( cgs.gametype == GT_SINGLE_PLAYER ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 2
NEI4 $1041
line 2237
;2237:		CG_DrawCenterString();
ADDRGP4 CG_DrawCenterString
CALLV
pop
line 2238
;2238:		return;
ADDRGP4 $1040
JUMPV
LABELV $1041
line 2241
;2239:	}
;2240:#endif
;2241:	cg.scoreFadeTime = cg.time;
ADDRGP4 cg+114328
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 2242
;2242:	cg.scoreBoardShowing = CG_DrawScoreboard();
ADDRLP4 0
ADDRGP4 CG_DrawScoreboard
CALLI4
ASGNI4
ADDRGP4 cg+114324
ADDRLP4 0
INDIRI4
ASGNI4
line 2243
;2243:}
LABELV $1040
endproc CG_DrawIntermission 4 0
proc CG_DrawFollow 32 36
line 2250
;2244:
;2245:/*
;2246:=================
;2247:CG_DrawFollow
;2248:=================
;2249:*/
;2250:static qboolean CG_DrawFollow( void ) {
line 2255
;2251:	float		x;
;2252:	vec4_t		color;
;2253:	const char	*name;
;2254:
;2255:	if ( !(cg.snap->ps.pm_flags & PMF_FOLLOW) ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 56
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
NEI4 $1048
line 2256
;2256:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1047
JUMPV
LABELV $1048
line 2258
;2257:	}
;2258:	color[0] = 1;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 2259
;2259:	color[1] = 1;
ADDRLP4 0+4
CNSTF4 1065353216
ASGNF4
line 2260
;2260:	color[2] = 1;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 2261
;2261:	color[3] = 1;
ADDRLP4 0+12
CNSTF4 1065353216
ASGNF4
line 2264
;2262:
;2263:
;2264:	CG_DrawBigString( 320 - 9 * 8, 24, "following", 1.0F );
CNSTI4 248
ARGI4
CNSTI4 24
ARGI4
ADDRGP4 $1054
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2266
;2265:
;2266:	name = cgs.clientinfo[ cg.snap->ps.clientNum ].name;
ADDRLP4 16
CNSTI4 1708
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972+4
ADDP4
ASGNP4
line 2268
;2267:
;2268:	x = 0.5 * ( 640 - GIANT_WIDTH * CG_DrawStrlen( name ) );
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
CNSTF4 1056964608
CNSTI4 640
ADDRLP4 24
INDIRI4
CNSTI4 5
LSHI4
SUBI4
CVIF4 4
MULF4
ASGNF4
line 2270
;2269:
;2270:	CG_DrawStringExt( x, 40, name, color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
ADDRLP4 20
INDIRF4
CVFI4 4
ARGI4
CNSTI4 40
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 28
CNSTI4 1
ASGNI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 2272
;2271:
;2272:	return qtrue;
CNSTI4 1
RETI4
LABELV $1047
endproc CG_DrawFollow 32 36
proc CG_DrawAmmoWarning 12 16
line 2282
;2273:}
;2274:
;2275:
;2276:
;2277:/*
;2278:=================
;2279:CG_DrawAmmoWarning
;2280:=================
;2281:*/
;2282:static void CG_DrawAmmoWarning( void ) {
line 2286
;2283:	const char	*s;
;2284:	int			w;
;2285:
;2286:	if ( cg_drawAmmoWarning.integer == 0 ) {
ADDRGP4 cg_drawAmmoWarning+12
INDIRI4
CNSTI4 0
NEI4 $1059
line 2287
;2287:		return;
ADDRGP4 $1058
JUMPV
LABELV $1059
line 2290
;2288:	}
;2289:
;2290:	if ( !cg.lowAmmoWarning ) {
ADDRGP4 cg+124392
INDIRI4
CNSTI4 0
NEI4 $1062
line 2291
;2291:		return;
ADDRGP4 $1058
JUMPV
LABELV $1062
line 2294
;2292:	}
;2293:
;2294:	if ( cg.lowAmmoWarning == 2 ) {
ADDRGP4 cg+124392
INDIRI4
CNSTI4 2
NEI4 $1065
line 2295
;2295:		s = "OUT OF AMMO";
ADDRLP4 0
ADDRGP4 $1068
ASGNP4
line 2296
;2296:	} else {
ADDRGP4 $1066
JUMPV
LABELV $1065
line 2297
;2297:		s = "LOW AMMO WARNING";
ADDRLP4 0
ADDRGP4 $1069
ASGNP4
line 2298
;2298:	}
LABELV $1066
line 2299
;2299:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2300
;2300:	CG_DrawBigString(320 - w / 2, 64, s, 1.0F);
CNSTI4 320
ADDRLP4 4
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 64
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2301
;2301:}
LABELV $1058
endproc CG_DrawAmmoWarning 12 16
proc CG_DrawWarmup 56 36
line 2350
;2302:
;2303:
;2304:#ifdef MISSIONPACK
;2305:/*
;2306:=================
;2307:CG_DrawProxWarning
;2308:=================
;2309:*/
;2310:static void CG_DrawProxWarning( void ) {
;2311:	char s [32];
;2312:	int			w;
;2313:  static int proxTime;
;2314:  static int proxCounter;
;2315:  static int proxTick;
;2316:
;2317:	if( !(cg.snap->ps.eFlags & EF_TICKING ) ) {
;2318:    proxTime = 0;
;2319:		return;
;2320:	}
;2321:
;2322:  if (proxTime == 0) {
;2323:    proxTime = cg.time + 5000;
;2324:    proxCounter = 5;
;2325:    proxTick = 0;
;2326:  }
;2327:
;2328:  if (cg.time > proxTime) {
;2329:    proxTick = proxCounter--;
;2330:    proxTime = cg.time + 1000;
;2331:  }
;2332:
;2333:  if (proxTick != 0) {
;2334:    Com_sprintf(s, sizeof(s), "INTERNAL COMBUSTION IN: %i", proxTick);
;2335:  } else {
;2336:    Com_sprintf(s, sizeof(s), "YOU HAVE BEEN MINED");
;2337:  }
;2338:
;2339:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
;2340:	CG_DrawBigStringColor( 320 - w / 2, 64 + BIGCHAR_HEIGHT, s, g_color_table[ColorIndex(COLOR_RED)] );
;2341:}
;2342:#endif
;2343:
;2344:
;2345:/*
;2346:=================
;2347:CG_DrawWarmup
;2348:=================
;2349:*/
;2350:static void CG_DrawWarmup( void ) {
line 2359
;2351:	int			w;
;2352:	int			sec;
;2353:	int			i;
;2354:	float scale;
;2355:	clientInfo_t	*ci1, *ci2;
;2356:	int			cw;
;2357:	const char	*s;
;2358:
;2359:	sec = cg.warmup;
ADDRLP4 4
ADDRGP4 cg+124656
INDIRI4
ASGNI4
line 2360
;2360:	if ( !sec ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1072
line 2361
;2361:		return;
ADDRGP4 $1070
JUMPV
LABELV $1072
line 2364
;2362:	}
;2363:
;2364:	if ( sec < 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $1074
line 2365
;2365:		s = "Waiting for players";		
ADDRLP4 8
ADDRGP4 $1076
ASGNP4
line 2366
;2366:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 32
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2367
;2367:		CG_DrawBigString(320 - w / 2, 24, s, 1.0F);
CNSTI4 320
ADDRLP4 16
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 24
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2368
;2368:		cg.warmupCount = 0;
ADDRGP4 cg+124660
CNSTI4 0
ASGNI4
line 2369
;2369:		return;
ADDRGP4 $1070
JUMPV
LABELV $1074
line 2372
;2370:	}
;2371:
;2372:	if (cgs.gametype == GT_TOURNAMENT) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 1
NEI4 $1078
line 2374
;2373:		// find the two active players
;2374:		ci1 = NULL;
ADDRLP4 20
CNSTP4 0
ASGNP4
line 2375
;2375:		ci2 = NULL;
ADDRLP4 24
CNSTP4 0
ASGNP4
line 2376
;2376:		for ( i = 0 ; i < cgs.maxclients ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1084
JUMPV
LABELV $1081
line 2377
;2377:			if ( cgs.clientinfo[i].infoValid && cgs.clientinfo[i].team == TEAM_FREE ) {
ADDRLP4 32
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 32
INDIRI4
ADDRGP4 cgs+40972
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
EQI4 $1086
ADDRLP4 32
INDIRI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $1086
line 2378
;2378:				if ( !ci1 ) {
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1091
line 2379
;2379:					ci1 = &cgs.clientinfo[i];
ADDRLP4 20
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 2380
;2380:				} else {
ADDRGP4 $1092
JUMPV
LABELV $1091
line 2381
;2381:					ci2 = &cgs.clientinfo[i];
ADDRLP4 24
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 2382
;2382:				}
LABELV $1092
line 2383
;2383:			}
LABELV $1086
line 2384
;2384:		}
LABELV $1082
line 2376
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1084
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $1081
line 2386
;2385:
;2386:		if ( ci1 && ci2 ) {
ADDRLP4 32
CNSTU4 0
ASGNU4
ADDRLP4 20
INDIRP4
CVPU4 4
ADDRLP4 32
INDIRU4
EQU4 $1079
ADDRLP4 24
INDIRP4
CVPU4 4
ADDRLP4 32
INDIRU4
EQU4 $1079
line 2387
;2387:			s = va( "%s vs %s", ci1->name, ci2->name );
ADDRGP4 $1097
ARGP4
ADDRLP4 36
CNSTI4 4
ASGNI4
ADDRLP4 20
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
ARGP4
ADDRLP4 24
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
ARGP4
ADDRLP4 40
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 40
INDIRP4
ASGNP4
line 2392
;2388:#ifdef MISSIONPACK
;2389:			w = CG_Text_Width(s, 0.6f, 0);
;2390:			CG_Text_Paint(320 - w / 2, 60, 0.6f, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;2391:#else
;2392:			w = CG_DrawStrlen( s );
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 44
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 44
INDIRI4
ASGNI4
line 2393
;2393:			if ( w > 640 / GIANT_WIDTH ) {
ADDRLP4 16
INDIRI4
CNSTI4 20
LEI4 $1098
line 2394
;2394:				cw = 640 / w;
ADDRLP4 12
CNSTI4 640
ADDRLP4 16
INDIRI4
DIVI4
ASGNI4
line 2395
;2395:			} else {
ADDRGP4 $1099
JUMPV
LABELV $1098
line 2396
;2396:				cw = GIANT_WIDTH;
ADDRLP4 12
CNSTI4 32
ASGNI4
line 2397
;2397:			}
LABELV $1099
line 2398
;2398:			CG_DrawStringExt( 320 - w * cw/2, 20,s, colorWhite, 
CNSTI4 320
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 20
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 colorWhite
ARGP4
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRLP4 52
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTF4 1069547520
ADDRLP4 12
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 2401
;2399:					qfalse, qtrue, cw, (int)(cw * 1.5f), 0 );
;2400:#endif
;2401:		}
line 2402
;2402:	} else {
ADDRGP4 $1079
JUMPV
LABELV $1078
line 2403
;2403:		if ( cgs.gametype == GT_FFA ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 0
NEI4 $1100
line 2404
;2404:			s = "Free For All";
ADDRLP4 8
ADDRGP4 $1103
ASGNP4
line 2405
;2405:		} else if ( cgs.gametype == GT_TEAM ) {
ADDRGP4 $1101
JUMPV
LABELV $1100
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
NEI4 $1104
line 2406
;2406:			s = "Team Deathmatch";
ADDRLP4 8
ADDRGP4 $1107
ASGNP4
line 2407
;2407:		} else if ( cgs.gametype == GT_CTF ) {
ADDRGP4 $1105
JUMPV
LABELV $1104
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $1108
line 2408
;2408:			s = "Capture the Flag";
ADDRLP4 8
ADDRGP4 $1111
ASGNP4
line 2417
;2409:#ifdef MISSIONPACK
;2410:		} else if ( cgs.gametype == GT_1FCTF ) {
;2411:			s = "One Flag CTF";
;2412:		} else if ( cgs.gametype == GT_OBELISK ) {
;2413:			s = "Overload";
;2414:		} else if ( cgs.gametype == GT_HARVESTER ) {
;2415:			s = "Harvester";
;2416:#endif
;2417:		} else {
ADDRGP4 $1109
JUMPV
LABELV $1108
line 2418
;2418:			s = "";
ADDRLP4 8
ADDRGP4 $1112
ASGNP4
line 2419
;2419:		}
LABELV $1109
LABELV $1105
LABELV $1101
line 2424
;2420:#ifdef MISSIONPACK
;2421:		w = CG_Text_Width(s, 0.6f, 0);
;2422:		CG_Text_Paint(320 - w / 2, 90, 0.6f, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;2423:#else
;2424:		w = CG_DrawStrlen( s );
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 32
INDIRI4
ASGNI4
line 2425
;2425:		if ( w > 640 / GIANT_WIDTH ) {
ADDRLP4 16
INDIRI4
CNSTI4 20
LEI4 $1113
line 2426
;2426:			cw = 640 / w;
ADDRLP4 12
CNSTI4 640
ADDRLP4 16
INDIRI4
DIVI4
ASGNI4
line 2427
;2427:		} else {
ADDRGP4 $1114
JUMPV
LABELV $1113
line 2428
;2428:			cw = GIANT_WIDTH;
ADDRLP4 12
CNSTI4 32
ASGNI4
line 2429
;2429:		}
LABELV $1114
line 2430
;2430:		CG_DrawStringExt( 320 - w * cw/2, 25,s, colorWhite, 
CNSTI4 320
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 25
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 colorWhite
ARGP4
ADDRLP4 40
CNSTI4 0
ASGNI4
ADDRLP4 40
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTF4 1066192077
ADDRLP4 12
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 40
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 2433
;2431:				qfalse, qtrue, cw, (int)(cw * 1.1f), 0 );
;2432:#endif
;2433:	}
LABELV $1079
line 2435
;2434:
;2435:	sec = ( sec - cg.time ) / 1000;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CNSTI4 1000
DIVI4
ASGNI4
line 2436
;2436:	if ( sec < 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $1116
line 2437
;2437:		cg.warmup = 0;
ADDRGP4 cg+124656
CNSTI4 0
ASGNI4
line 2438
;2438:		sec = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 2439
;2439:	}
LABELV $1116
line 2440
;2440:	s = va( "Starts in: %i", sec + 1 );
ADDRGP4 $1119
ARGP4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRLP4 32
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 32
INDIRP4
ASGNP4
line 2441
;2441:	if ( sec != cg.warmupCount ) {
ADDRLP4 4
INDIRI4
ADDRGP4 cg+124660
INDIRI4
EQI4 $1120
line 2442
;2442:		cg.warmupCount = sec;
ADDRGP4 cg+124660
ADDRLP4 4
INDIRI4
ASGNI4
line 2443
;2443:		switch ( sec ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $1126
ADDRLP4 4
INDIRI4
CNSTI4 1
EQI4 $1129
ADDRLP4 4
INDIRI4
CNSTI4 2
EQI4 $1132
ADDRGP4 $1125
JUMPV
LABELV $1126
line 2445
;2444:		case 0:
;2445:			trap_S_StartLocalSound( cgs.media.count1Sound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+968
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2446
;2446:			break;
ADDRGP4 $1125
JUMPV
LABELV $1129
line 2448
;2447:		case 1:
;2448:			trap_S_StartLocalSound( cgs.media.count2Sound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+964
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2449
;2449:			break;
ADDRGP4 $1125
JUMPV
LABELV $1132
line 2451
;2450:		case 2:
;2451:			trap_S_StartLocalSound( cgs.media.count3Sound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+960
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2452
;2452:			break;
line 2454
;2453:		default:
;2454:			break;
LABELV $1125
line 2456
;2455:		}
;2456:	}
LABELV $1120
line 2457
;2457:	scale = 0.45f;
ADDRLP4 28
CNSTF4 1055286886
ASGNF4
line 2458
;2458:	switch ( cg.warmupCount ) {
ADDRLP4 36
ADDRGP4 cg+124660
INDIRI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
EQI4 $1138
ADDRLP4 36
INDIRI4
CNSTI4 1
EQI4 $1139
ADDRLP4 36
INDIRI4
CNSTI4 2
EQI4 $1140
ADDRGP4 $1135
JUMPV
LABELV $1138
line 2460
;2459:	case 0:
;2460:		cw = 28;
ADDRLP4 12
CNSTI4 28
ASGNI4
line 2461
;2461:		scale = 0.54f;
ADDRLP4 28
CNSTF4 1057635697
ASGNF4
line 2462
;2462:		break;
ADDRGP4 $1136
JUMPV
LABELV $1139
line 2464
;2463:	case 1:
;2464:		cw = 24;
ADDRLP4 12
CNSTI4 24
ASGNI4
line 2465
;2465:		scale = 0.51f;
ADDRLP4 28
CNSTF4 1057132380
ASGNF4
line 2466
;2466:		break;
ADDRGP4 $1136
JUMPV
LABELV $1140
line 2468
;2467:	case 2:
;2468:		cw = 20;
ADDRLP4 12
CNSTI4 20
ASGNI4
line 2469
;2469:		scale = 0.48f;
ADDRLP4 28
CNSTF4 1056293519
ASGNF4
line 2470
;2470:		break;
ADDRGP4 $1136
JUMPV
LABELV $1135
line 2472
;2471:	default:
;2472:		cw = 16;
ADDRLP4 12
CNSTI4 16
ASGNI4
line 2473
;2473:		scale = 0.45f;
ADDRLP4 28
CNSTF4 1055286886
ASGNF4
line 2474
;2474:		break;
LABELV $1136
line 2481
;2475:	}
;2476:
;2477:#ifdef MISSIONPACK
;2478:		w = CG_Text_Width(s, scale, 0);
;2479:		CG_Text_Paint(320 - w / 2, 125, scale, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;2480:#else
;2481:	w = CG_DrawStrlen( s );
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 40
INDIRI4
ASGNI4
line 2482
;2482:	CG_DrawStringExt( 320 - w * cw/2, 70, s, colorWhite, 
CNSTI4 320
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 70
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 colorWhite
ARGP4
ADDRLP4 48
CNSTI4 0
ASGNI4
ADDRLP4 48
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTF4 1069547520
ADDRLP4 12
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 48
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 2485
;2483:			qfalse, qtrue, cw, (int)(cw * 1.5), 0 );
;2484:#endif
;2485:}
LABELV $1070
endproc CG_DrawWarmup 56 36
proc CG_Draw2D 8 0
line 2510
;2486:
;2487://==================================================================================
;2488:#ifdef MISSIONPACK
;2489:/* 
;2490:=================
;2491:CG_DrawTimedMenus
;2492:=================
;2493:*/
;2494:void CG_DrawTimedMenus() {
;2495:	if (cg.voiceTime) {
;2496:		int t = cg.time - cg.voiceTime;
;2497:		if ( t > 2500 ) {
;2498:			Menus_CloseByName("voiceMenu");
;2499:			trap_Cvar_Set("cl_conXOffset", "0");
;2500:			cg.voiceTime = 0;
;2501:		}
;2502:	}
;2503:}
;2504:#endif
;2505:/*
;2506:=================
;2507:CG_Draw2D
;2508:=================
;2509:*/
;2510:static void CG_Draw2D( void ) {
line 2517
;2511:#ifdef MISSIONPACK
;2512:	if (cgs.orderPending && cg.time > cgs.orderTime) {
;2513:		CG_CheckOrderPending();
;2514:	}
;2515:#endif
;2516:	// if we are taking a levelshot for the menu, don't draw anything
;2517:	if ( cg.levelShot ) {
ADDRGP4 cg+12
INDIRI4
CNSTI4 0
EQI4 $1142
line 2518
;2518:		return;
ADDRGP4 $1141
JUMPV
LABELV $1142
line 2521
;2519:	}
;2520:
;2521:	if ( cg_draw2D.integer == 0 ) {
ADDRGP4 cg_draw2D+12
INDIRI4
CNSTI4 0
NEI4 $1145
line 2522
;2522:		return;
ADDRGP4 $1141
JUMPV
LABELV $1145
line 2525
;2523:	}
;2524:
;2525:	if ( cg.snap->ps.pm_type == PM_INTERMISSION ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 5
NEI4 $1148
line 2526
;2526:		CG_DrawIntermission();
ADDRGP4 CG_DrawIntermission
CALLV
pop
line 2527
;2527:		return;
ADDRGP4 $1141
JUMPV
LABELV $1148
line 2535
;2528:	}
;2529:
;2530:/*
;2531:	if (cg.cameraMode) {
;2532:		return;
;2533:	}
;2534:*/
;2535:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $1151
line 2536
;2536:		CG_DrawSpectator();
ADDRGP4 CG_DrawSpectator
CALLV
pop
line 2537
;2537:		CG_DrawCrosshair();
ADDRGP4 CG_DrawCrosshair
CALLV
pop
line 2538
;2538:		CG_DrawCrosshairNames();
ADDRGP4 CG_DrawCrosshairNames
CALLV
pop
line 2539
;2539:	} else {
ADDRGP4 $1152
JUMPV
LABELV $1151
line 2541
;2540:		// don't draw any status if dead or the scoreboard is being explicitly shown
;2541:		if ( !cg.showScores && cg.snap->ps.stats[STAT_HEALTH] > 0 ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 cg+114320
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $1154
ADDRGP4 cg+36
INDIRP4
CNSTI4 228
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
LEI4 $1154
line 2549
;2542:
;2543:#ifdef MISSIONPACK
;2544:			if ( cg_drawStatus.integer ) {
;2545:				Menu_PaintAll();
;2546:				CG_DrawTimedMenus();
;2547:			}
;2548:#else
;2549:			CG_DrawStatusBar();
ADDRGP4 CG_DrawStatusBar
CALLV
pop
line 2552
;2550:#endif
;2551:      
;2552:			CG_DrawAmmoWarning();
ADDRGP4 CG_DrawAmmoWarning
CALLV
pop
line 2557
;2553:
;2554:#ifdef MISSIONPACK
;2555:			CG_DrawProxWarning();
;2556:#endif      
;2557:			CG_DrawCrosshair();
ADDRGP4 CG_DrawCrosshair
CALLV
pop
line 2558
;2558:			CG_DrawCrosshairNames();
ADDRGP4 CG_DrawCrosshairNames
CALLV
pop
line 2559
;2559:			CG_DrawWeaponSelect();
ADDRGP4 CG_DrawWeaponSelect
CALLV
pop
line 2562
;2560:
;2561:#ifndef MISSIONPACK
;2562:			CG_DrawHoldableItem();
ADDRGP4 CG_DrawHoldableItem
CALLV
pop
line 2566
;2563:#else
;2564:			//CG_DrawPersistantPowerup();
;2565:#endif
;2566:			CG_DrawReward();
ADDRGP4 CG_DrawReward
CALLV
pop
line 2567
;2567:		}
LABELV $1154
line 2569
;2568:    
;2569:		if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $1158
line 2571
;2570:#ifndef MISSIONPACK
;2571:			CG_DrawTeamInfo();
ADDRGP4 CG_DrawTeamInfo
CALLV
pop
line 2573
;2572:#endif
;2573:		}
LABELV $1158
line 2574
;2574:	}
LABELV $1152
line 2576
;2575:
;2576:	CG_DrawVote();
ADDRGP4 CG_DrawVote
CALLV
pop
line 2577
;2577:	CG_DrawTeamVote();
ADDRGP4 CG_DrawTeamVote
CALLV
pop
line 2579
;2578:
;2579:	CG_DrawLagometer();
ADDRGP4 CG_DrawLagometer
CALLV
pop
line 2586
;2580:
;2581:#ifdef MISSIONPACK
;2582:	if (!cg_paused.integer) {
;2583:		CG_DrawUpperRight();
;2584:	}
;2585:#else
;2586:	CG_DrawUpperRight();
ADDRGP4 CG_DrawUpperRight
CALLV
pop
line 2590
;2587:#endif
;2588:
;2589:#ifndef MISSIONPACK
;2590:	CG_DrawLowerRight();
ADDRGP4 CG_DrawLowerRight
CALLV
pop
line 2591
;2591:	CG_DrawLowerLeft();
ADDRGP4 CG_DrawLowerLeft
CALLV
pop
line 2594
;2592:#endif
;2593:
;2594:	if ( !CG_DrawFollow() ) {
ADDRLP4 0
ADDRGP4 CG_DrawFollow
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1161
line 2595
;2595:		CG_DrawWarmup();
ADDRGP4 CG_DrawWarmup
CALLV
pop
line 2596
;2596:	}
LABELV $1161
line 2599
;2597:
;2598:	// don't draw center string if scoreboard is up
;2599:	cg.scoreBoardShowing = CG_DrawScoreboard();
ADDRLP4 4
ADDRGP4 CG_DrawScoreboard
CALLI4
ASGNI4
ADDRGP4 cg+114324
ADDRLP4 4
INDIRI4
ASGNI4
line 2600
;2600:	if ( !cg.scoreBoardShowing) {
ADDRGP4 cg+114324
INDIRI4
CNSTI4 0
NEI4 $1164
line 2601
;2601:		CG_DrawCenterString();
ADDRGP4 CG_DrawCenterString
CALLV
pop
line 2602
;2602:	}
LABELV $1164
line 2603
;2603:}
LABELV $1141
endproc CG_Draw2D 8 0
proc CG_DrawTourneyScoreboard 0 0
line 2606
;2604:
;2605:
;2606:static void CG_DrawTourneyScoreboard() {
line 2609
;2607:#ifdef MISSIONPACK
;2608:#else
;2609:	CG_DrawOldTourneyScoreboard();
ADDRGP4 CG_DrawOldTourneyScoreboard
CALLV
pop
line 2611
;2610:#endif
;2611:}
LABELV $1167
endproc CG_DrawTourneyScoreboard 0 0
export CG_DrawActive
proc CG_DrawActive 24 4
line 2620
;2612:
;2613:/*
;2614:=====================
;2615:CG_DrawActive
;2616:
;2617:Perform all drawing needed to completely fill the screen
;2618:=====================
;2619:*/
;2620:void CG_DrawActive( stereoFrame_t stereoView ) {
line 2625
;2621:	float		separation;
;2622:	vec3_t		baseOrg;
;2623:
;2624:	// optionally draw the info screen instead
;2625:	if ( !cg.snap ) {
ADDRGP4 cg+36
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1169
line 2626
;2626:		CG_DrawInformation();
ADDRGP4 CG_DrawInformation
CALLV
pop
line 2627
;2627:		return;
ADDRGP4 $1168
JUMPV
LABELV $1169
line 2631
;2628:	}
;2629:
;2630:	// optionally draw the tournement scoreboard instead
;2631:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR &&
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $1172
ADDRGP4 cg+36
INDIRP4
CNSTI4 56
ADDP4
INDIRI4
CNSTI4 8192
BANDI4
CNSTI4 0
EQI4 $1172
line 2632
;2632:		( cg.snap->ps.pm_flags & PMF_SCOREBOARD ) ) {
line 2633
;2633:		CG_DrawTourneyScoreboard();
ADDRGP4 CG_DrawTourneyScoreboard
CALLV
pop
line 2634
;2634:		return;
ADDRGP4 $1168
JUMPV
LABELV $1172
line 2637
;2635:	}
;2636:
;2637:	switch ( stereoView ) {
ADDRLP4 16
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $1179
ADDRLP4 16
INDIRI4
CNSTI4 1
EQI4 $1180
ADDRLP4 16
INDIRI4
CNSTI4 2
EQI4 $1182
ADDRGP4 $1176
JUMPV
LABELV $1179
line 2639
;2638:	case STEREO_CENTER:
;2639:		separation = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 2640
;2640:		break;
ADDRGP4 $1177
JUMPV
LABELV $1180
line 2642
;2641:	case STEREO_LEFT:
;2642:		separation = -cg_stereoSeparation.value / 2;
ADDRLP4 0
ADDRGP4 cg_stereoSeparation+8
INDIRF4
NEGF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 2643
;2643:		break;
ADDRGP4 $1177
JUMPV
LABELV $1182
line 2645
;2644:	case STEREO_RIGHT:
;2645:		separation = cg_stereoSeparation.value / 2;
ADDRLP4 0
ADDRGP4 cg_stereoSeparation+8
INDIRF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 2646
;2646:		break;
ADDRGP4 $1177
JUMPV
LABELV $1176
line 2648
;2647:	default:
;2648:		separation = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 2649
;2649:		CG_Error( "CG_DrawActive: Undefined stereoView" );
ADDRGP4 $1184
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 2650
;2650:	}
LABELV $1177
line 2654
;2651:
;2652:
;2653:	// clear around the rendered view if sized down
;2654:	CG_TileClear();
ADDRGP4 CG_TileClear
CALLV
pop
line 2657
;2655:
;2656:	// offset vieworg appropriately if we're doing stereo separation
;2657:	VectorCopy( cg.refdef.vieworg, baseOrg );
ADDRLP4 4
ADDRGP4 cg+109044+24
INDIRB
ASGNB 12
line 2658
;2658:	if ( separation != 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
EQF4 $1187
line 2659
;2659:		VectorMA( cg.refdef.vieworg, -separation, cg.refdef.viewaxis[1], cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRGP4 cg+109044+24
INDIRF4
ADDRGP4 cg+109044+36+12
INDIRF4
ADDRLP4 0
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+109044+24+4
ADDRGP4 cg+109044+24+4
INDIRF4
ADDRGP4 cg+109044+36+12+4
INDIRF4
ADDRLP4 0
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+109044+24+8
ADDRGP4 cg+109044+24+8
INDIRF4
ADDRGP4 cg+109044+36+12+8
INDIRF4
ADDRLP4 0
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 2660
;2660:	}
LABELV $1187
line 2663
;2661:
;2662:	// draw 3D view
;2663:	trap_R_RenderScene( &cg.refdef );
ADDRGP4 cg+109044
ARGP4
ADDRGP4 trap_R_RenderScene
CALLV
pop
line 2666
;2664:
;2665:	// restore original viewpoint if running stereo
;2666:	if ( separation != 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
EQF4 $1217
line 2667
;2667:		VectorCopy( baseOrg, cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRLP4 4
INDIRB
ASGNB 12
line 2668
;2668:	}
LABELV $1217
line 2671
;2669:
;2670:	// draw status bar and other floating elements
;2671: 	CG_Draw2D();
ADDRGP4 CG_Draw2D
CALLV
pop
line 2672
;2672:}
LABELV $1168
endproc CG_DrawActive 24 4
bss
export lagometer
align 4
LABELV lagometer
skip 1544
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
export teamChat2
align 1
LABELV teamChat2
skip 256
export teamChat1
align 1
LABELV teamChat1
skip 256
export systemChat
align 1
LABELV systemChat
skip 256
export numSortedTeamPlayers
align 4
LABELV numSortedTeamPlayers
skip 4
export sortedTeamPlayers
align 4
LABELV sortedTeamPlayers
skip 128
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
byte 1 67
byte 1 71
byte 1 95
byte 1 68
byte 1 114
byte 1 97
byte 1 119
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 101
byte 1 58
byte 1 32
byte 1 85
byte 1 110
byte 1 100
byte 1 101
byte 1 102
byte 1 105
byte 1 110
byte 1 101
byte 1 100
byte 1 32
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 101
byte 1 111
byte 1 86
byte 1 105
byte 1 101
byte 1 119
byte 1 0
align 1
LABELV $1119
byte 1 83
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 115
byte 1 32
byte 1 105
byte 1 110
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1112
byte 1 0
align 1
LABELV $1111
byte 1 67
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $1107
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 68
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
LABELV $1103
byte 1 70
byte 1 114
byte 1 101
byte 1 101
byte 1 32
byte 1 70
byte 1 111
byte 1 114
byte 1 32
byte 1 65
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $1097
byte 1 37
byte 1 115
byte 1 32
byte 1 118
byte 1 115
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $1076
byte 1 87
byte 1 97
byte 1 105
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 102
byte 1 111
byte 1 114
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 0
align 1
LABELV $1069
byte 1 76
byte 1 79
byte 1 87
byte 1 32
byte 1 65
byte 1 77
byte 1 77
byte 1 79
byte 1 32
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 0
align 1
LABELV $1068
byte 1 79
byte 1 85
byte 1 84
byte 1 32
byte 1 79
byte 1 70
byte 1 32
byte 1 65
byte 1 77
byte 1 77
byte 1 79
byte 1 0
align 1
LABELV $1054
byte 1 102
byte 1 111
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $1035
byte 1 84
byte 1 69
byte 1 65
byte 1 77
byte 1 86
byte 1 79
byte 1 84
byte 1 69
byte 1 40
byte 1 37
byte 1 105
byte 1 41
byte 1 58
byte 1 37
byte 1 115
byte 1 32
byte 1 121
byte 1 101
byte 1 115
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 110
byte 1 111
byte 1 58
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1009
byte 1 86
byte 1 79
byte 1 84
byte 1 69
byte 1 40
byte 1 37
byte 1 105
byte 1 41
byte 1 58
byte 1 37
byte 1 115
byte 1 32
byte 1 121
byte 1 101
byte 1 115
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 110
byte 1 111
byte 1 58
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $994
byte 1 112
byte 1 114
byte 1 101
byte 1 115
byte 1 115
byte 1 32
byte 1 69
byte 1 83
byte 1 67
byte 1 32
byte 1 97
byte 1 110
byte 1 100
byte 1 32
byte 1 117
byte 1 115
byte 1 101
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 74
byte 1 79
byte 1 73
byte 1 78
byte 1 32
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $990
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $986
byte 1 83
byte 1 80
byte 1 69
byte 1 67
byte 1 84
byte 1 65
byte 1 84
byte 1 79
byte 1 82
byte 1 0
align 1
LABELV $860
byte 1 115
byte 1 110
byte 1 99
byte 1 0
align 1
LABELV $795
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 101
byte 1 116
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $791
byte 1 67
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 73
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 114
byte 1 117
byte 1 112
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $760
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $516
byte 1 37
byte 1 50
byte 1 105
byte 1 0
align 1
LABELV $507
byte 1 103
byte 1 95
byte 1 111
byte 1 110
byte 1 101
byte 1 76
byte 1 105
byte 1 102
byte 1 101
byte 1 84
byte 1 68
byte 1 77
byte 1 0
align 1
LABELV $468
byte 1 37
byte 1 51
byte 1 105
byte 1 32
byte 1 37
byte 1 51
byte 1 105
byte 1 0
align 1
LABELV $465
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 0
align 1
LABELV $398
byte 1 37
byte 1 105
byte 1 58
byte 1 37
byte 1 105
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $394
byte 1 37
byte 1 105
byte 1 102
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $378
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 115
byte 1 110
byte 1 97
byte 1 112
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 99
byte 1 109
byte 1 100
byte 1 58
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $376
byte 1 110
byte 1 0
align 1
LABELV $111
byte 1 37
byte 1 105
byte 1 0
