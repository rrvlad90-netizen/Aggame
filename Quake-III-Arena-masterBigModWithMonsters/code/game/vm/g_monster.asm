data
align 4
LABELV monsterConfigFiles
address $59
address $60
address $61
address $62
address $63
address $64
address $65
address $66
address $67
address $68
address $69
address $70
address $71
address $72
address $73
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
byte 4 0
code
proc G_LoadMonsterConfig 9576 16
file "../g_monster.c"
line 131
;1:#include "g_local.h"
;2:
;3:typedef enum {
;4:	MONSTER_STATE_IDLE,
;5:	MONSTER_STATE_MOVE,
;6:	MONSTER_STATE_MELEE,
;7:	MONSTER_STATE_RANGED,
;8:	MONSTER_STATE_PAIN,
;9:	MONSTER_STATE_DEATH
;10:} monsterState_t;
;11:
;12:static void G_MonsterPain(
;13:	gentity_t *self,
;14:	gentity_t *attacker,
;15:	int damage
;16:);
;17:
;18:static qboolean G_MonsterCanSeeTarget(
;19:	gentity_t *monster,
;20:	gentity_t *target
;21:);
;22:
;23:static void G_MonsterDie(
;24:	gentity_t *self,
;25:	gentity_t *inflictor,
;26:	gentity_t *attacker,
;27:	int damage,
;28:	int mod
;29:);
;30:
;31:static int monsterItemCounter;
;32:static int monsterActiveCount;
;33:static void G_MonsterThink(gentity_t *ent);
;34:
;35:
;36:#define MAX_MONSTER_WAVES		32
;37:#define DEFAULT_MONSTER_WAVES		5
;38:#define MAX_MONSTERS_IN_WAVE		8
;39:#define MAX_MONSTER_WAVE_TEXT		8192
;40:
;41:typedef struct {
;42:	int	monsterType;
;43:	int	monsterSlot;
;44:	int	count;
;45:} monsterWaveEntry_t;
;46:
;47:typedef struct {
;48:	monsterWaveEntry_t entries[MAX_MONSTERS_IN_WAVE];
;49:	int	numEntries;
;50:	qboolean repeat;
;51:} monsterWaveDef_t;
;52:
;53:static monsterWaveDef_t monsterWaves[MAX_MONSTER_WAVES];
;54:
;55:static int monsterWaveDelay;
;56:static int monsterWaveSpawnInterval;
;57:static int monsterWaveTimeout;
;58:static int monsterWaveMaxActive;
;59:static int monsterWaveFinal;
;60:static qboolean monsterWavesLoaded;
;61:
;62:static int monsterCurrentWave;
;63:static int monsterWaveEntry;
;64:static int monsterWaveEntrySpawned;
;65:static int monsterWaveNextSpawn;
;66:static int monsterWaveNextStart;
;67:static int monsterWaveLastProgress;
;68:
;69:static qboolean monsterWaveActive;
;70:static qboolean monsterWaveStarted;
;71:static qboolean monsterWaveCombatStarted;
;72:static qboolean monsterWaveFinished;
;73:
;74:static qboolean G_LoadMonsterWaveConfig(
;75:	const char *filename
;76:);
;77:
;78:
;79:static void G_MonsterSetAnimation(
;80:	gentity_t *monster,
;81:	int animation,
;82:	int variant
;83:);
;84:
;85:static int G_MonsterTalkDelay(monsterDef_t *def);
;86:
;87:static void G_MonsterSound(
;88:	gentity_t *monster,
;89:	monsterDef_t *def,
;90:	const char *group,
;91:	int variant
;92:);
;93:
;94:monsterDef_t g_monsterDefs
;95:	[MONSTER_TYPE_RANDOM]
;96:	[MAX_MONSTERS_PER_TYPE];
;97:
;98:qboolean g_monsterDefLoaded
;99:	[MONSTER_TYPE_RANDOM]
;100:	[MAX_MONSTERS_PER_TYPE];
;101:
;102:static const char *monsterConfigFiles[] = {
;103:	"models/monsters/HereticDisciple/monster.cfg",
;104:	"models/monsters/DarkKnight/monster.cfg",
;105:	"models/monsters/LionGuy/monster.cfg",
;106:	"models/monsters/D3Imp/monster.cfg",
;107:	"models/monsters/Gross/monster.cfg",
;108:	"models/monsters/Mancubus/monster.cfg",
;109:	"models/monsters/Mancubus2/monster.cfg",
;110:	"models/monsters/Mancubus3/monster.cfg",
;111:	"models/monsters/Mancubus4/monster.cfg",
;112:	"models/monsters/Mancubus5/monster.cfg",	
;113:	"models/monsters/MongGrunt/monster.cfg",
;114:	"models/monsters/MongGruntShotgun/monster.cfg",
;115:	"models/monsters/MongGruntRifle/monster.cfg",
;116:	"models/monsters/Faust/monster.cfg",
;117:	"models/monsters/Stratos/monster.cfg",	
;118:	"models/monsters/Mincer/monster.cfg",
;119:	"models/monsters/Forgotten/monster.cfg",
;120:	"models/monsters/Ghost/monster.cfg",
;121:	"models/monsters/Ghost2/monster.cfg",
;122:	"models/monsters/Ghost3/monster.cfg",
;123:	"models/monsters/MongGrunt2/monster.cfg",
;124:	"models/monsters/MongGruntShotgun2/monster.cfg",
;125:	"models/monsters/MongGruntRifle2/monster.cfg",
;126:	"models/monsters/Stratos2/monster.cfg",
;127:	"models/monsters/Faust2/monster.cfg",	
;128:	NULL
;129:};
;130:
;131:static qboolean G_LoadMonsterConfig(const char *filename) {
line 138
;132:	fileHandle_t file;
;133:	char text[MAX_MONSTER_CONFIG_TEXT];
;134:	char error[256];
;135:	monsterDef_t def;
;136:	int length;
;137:
;138:	length = trap_FS_FOpenFile(filename, &file, FS_READ);
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
line 140
;139:
;140:	if (!file) {
ADDRLP4 1112
INDIRI4
CNSTI4 0
NEI4 $85
line 141
;141:		G_Printf(
ADDRGP4 $87
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 145
;142:			S_COLOR_RED "Monster config not found: %s\n",
;143:			filename
;144:		);
;145:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $85
line 148
;146:	}
;147:
;148:	if (length <= 0 || length >= sizeof(text)) {
ADDRLP4 1108
INDIRI4
CNSTI4 0
LEI4 $90
ADDRLP4 1108
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $88
LABELV $90
line 149
;149:		G_Printf(
ADDRGP4 $91
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 153
;150:			S_COLOR_RED "Invalid monster config size: %s\n",
;151:			filename
;152:		);
;153:		trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 154
;154:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $88
line 157
;155:	}
;156:
;157:	trap_FS_Read(text, length, file);
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
line 158
;158:	text[length] = '\0';
ADDRLP4 1108
INDIRI4
ADDRLP4 1116
ADDP4
CNSTI1 0
ASGNI1
line 159
;159:	trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 161
;160:
;161:	if (!BG_ParseMonsterConfig(
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
NEI4 $92
line 166
;162:		text,
;163:		&def,
;164:		error,
;165:		sizeof(error)
;166:	)) {
line 167
;167:		G_Printf(
ADDRGP4 $94
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9308
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 172
;168:			S_COLOR_RED "Monster config error in %s: %s\n",
;169:			filename,
;170:			error
;171:		);
;172:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $92
line 175
;173:	}
;174:
;175:	if (def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 0+576
INDIRI4
CNSTI4 0
LEI4 $99
ADDRLP4 0+576
INDIRI4
CNSTI4 6
LTI4 $95
LABELV $99
line 176
;176:		def.monsterType >= MONSTER_TYPE_RANDOM) {
line 177
;177:		G_Printf(
ADDRGP4 $100
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 181
;178:			S_COLOR_RED "Invalid monster type in %s\n",
;179:			filename
;180:		);
;181:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $95
line 184
;182:	}
;183:
;184:	if (def.monsterSlot < 0 ||
ADDRLP4 0+580
INDIRI4
CNSTI4 0
LTI4 $105
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $101
LABELV $105
line 185
;185:		def.monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 186
;186:		G_Printf(
ADDRGP4 $106
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 190
;187:			S_COLOR_RED "Invalid monster slot in %s\n",
;188:			filename
;189:		);
;190:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $101
line 193
;191:	}
;192:
;193:	g_monsterDefs[def.monsterType][def.monsterSlot] = def;
CNSTI4 1108
ADDRLP4 0+580
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 0+576
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ADDRLP4 0
INDIRB
ASGNB 1108
line 194
;194:	g_monsterDefLoaded[def.monsterType][def.monsterSlot] = qtrue;
ADDRLP4 0+580
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 20
ADDRLP4 0+576
INDIRI4
MULI4
ADDRGP4 g_monsterDefLoaded
ADDP4
ADDP4
CNSTI4 1
ASGNI4
line 196
;195:
;196:	G_Printf(
ADDRGP4 $111
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 0+576
INDIRI4
ARGI4
ADDRLP4 0+580
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 204
;197:		S_COLOR_GREEN
;198:		"Loaded monster: %s, type %i, slot %i\n",
;199:		def.name,
;200:		def.monsterType,
;201:		def.monsterSlot
;202:	);
;203:
;204:	return qtrue;
CNSTI4 1
RETI4
LABELV $84
endproc G_LoadMonsterConfig 9576 16
proc G_MonsterWaveReadInt 12 4
line 211
;205:}
;206:
;207:
;208:static qboolean G_MonsterWaveReadInt(
;209:	char **text,
;210:	int *value
;211:) {
line 214
;212:	char *token;
;213:
;214:	token = COM_Parse(text);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 216
;215:
;216:	if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $115
line 217
;217:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $114
JUMPV
LABELV $115
line 220
;218:	}
;219:
;220:	*value = atoi(token);
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 8
INDIRI4
ASGNI4
line 221
;221:	return qtrue;
CNSTI4 1
RETI4
LABELV $114
endproc G_MonsterWaveReadInt 12 4
proc G_MonsterWaveFindDefinition 12 8
line 228
;222:}
;223:
;224:static qboolean G_MonsterWaveFindDefinition(
;225:	const char *name,
;226:	int *monsterType,
;227:	int *monsterSlot
;228:) {
line 232
;229:	int type;
;230:	int slot;
;231:
;232:	for( type = MONSTER_TYPE_OFF + 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
LABELV $118
line 234
;233:		type < MONSTER_TYPE_RANDOM;
;234:		type++ ) {
line 235
;235:		for( slot = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $122
line 237
;236:			slot < MAX_MONSTERS_PER_TYPE;
;237:			slot++ ) {
line 238
;238:			if( !g_monsterDefLoaded[type][slot] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 20
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_monsterDefLoaded
ADDP4
ADDP4
INDIRI4
CNSTI4 0
NEI4 $126
line 239
;239:				continue;
ADDRGP4 $123
JUMPV
LABELV $126
line 242
;240:			}
;241:
;242:			if( !Q_stricmp(
CNSTI4 1108
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $128
line 245
;243:				g_monsterDefs[type][slot].name,
;244:				name
;245:			) ) {
line 246
;246:				*monsterType = type;
ADDRFP4 4
INDIRP4
ADDRLP4 4
INDIRI4
ASGNI4
line 247
;247:				*monsterSlot = slot;
ADDRFP4 8
INDIRP4
ADDRLP4 0
INDIRI4
ASGNI4
line 248
;248:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $117
JUMPV
LABELV $128
line 250
;249:			}
;250:		}
LABELV $123
line 237
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 236
ADDRLP4 0
INDIRI4
CNSTI4 5
LTI4 $122
line 251
;251:	}
LABELV $119
line 234
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 233
ADDRLP4 4
INDIRI4
CNSTI4 6
LTI4 $118
line 253
;252:
;253:	return qfalse;
CNSTI4 0
RETI4
LABELV $117
endproc G_MonsterWaveFindDefinition 12 8
proc G_MonsterWaveParseWave 124 12
line 259
;254:}
;255:
;256:static qboolean G_MonsterWaveParseWave(
;257:	char **text,
;258:	int waveNumber
;259:) {
line 263
;260:	monsterWaveDef_t *wave;
;261:	char *token;
;262:
;263:	if( waveNumber < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $133
ADDRLP4 8
INDIRI4
CNSTI4 32
LEI4 $131
LABELV $133
line 264
;264:		waveNumber > MAX_MONSTER_WAVES ) {
line 265
;265:		G_Printf(
ADDRGP4 $134
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 270
;266:			S_COLOR_RED
;267:			"Monster waves: invalid wave %i\n",
;268:			waveNumber
;269:		);
;270:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $131
line 273
;271:	}
;272:
;273:	wave = &monsterWaves[waveNumber - 1];
ADDRLP4 4
CNSTI4 104
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 monsterWaves-104
ADDP4
ASGNP4
line 275
;274:
;275:	token = COM_Parse(text);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 277
;276:
;277:	if( Q_stricmp(token, "{") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $138
ARGP4
ADDRLP4 16
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $141
line 278
;278:		G_Printf(
ADDRGP4 $139
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 283
;279:			S_COLOR_RED
;280:			"Monster waves: expected { after wave %i\n",
;281:			waveNumber
;282:		);
;283:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $140
line 286
;284:	}
;285:
;286:	while( 1 ) {
line 287
;287:		token = COM_Parse(text);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20
INDIRP4
ASGNP4
line 289
;288:
;289:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $143
line 290
;290:			G_Printf(
ADDRGP4 $145
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 295
;291:				S_COLOR_RED
;292:				"Monster waves: unexpected end of wave %i\n",
;293:				waveNumber
;294:			);
;295:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $143
line 298
;296:		}
;297:
;298:		if( !Q_stricmp(token, "}") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $148
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $146
line 299
;299:			break;
ADDRGP4 $142
JUMPV
LABELV $146
line 302
;300:		}
;301:
;302:		if( !Q_stricmp(token, "monster") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $151
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $149
line 306
;303:			monsterWaveEntry_t *entry;
;304:			char monsterName[MAX_QPATH];
;305:
;306:			if( wave->numEntries >=
ADDRLP4 4
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
CNSTI4 8
LTI4 $152
line 307
;307:				MAX_MONSTERS_IN_WAVE ) {
line 308
;308:				G_Printf(
ADDRGP4 $154
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 313
;309:					S_COLOR_RED
;310:					"Monster waves: too many entries in wave %i\n",
;311:					waveNumber
;312:				);
;313:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $152
line 316
;314:			}
;315:
;316:			token = COM_Parse(text);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 100
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 100
INDIRP4
ASGNP4
line 318
;317:
;318:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $155
line 319
;319:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $155
line 322
;320:			}
;321:
;322:			Q_strncpyz(
ADDRLP4 36
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 328
;323:				monsterName,
;324:				token,
;325:				sizeof(monsterName)
;326:			);
;327:
;328:			entry =
ADDRLP4 32
CNSTI4 12
ADDRLP4 4
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
ASGNP4
line 331
;329:				&wave->entries[wave->numEntries];
;330:
;331:			if( !G_MonsterWaveFindDefinition(
ADDRLP4 36
ARGP4
ADDRLP4 32
INDIRP4
ARGP4
ADDRLP4 32
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRLP4 112
ADDRGP4 G_MonsterWaveFindDefinition
CALLI4
ASGNI4
ADDRLP4 112
INDIRI4
CNSTI4 0
NEI4 $157
line 335
;332:				monsterName,
;333:				&entry->monsterType,
;334:				&entry->monsterSlot
;335:			) ) {
line 336
;336:				G_Printf(
ADDRGP4 $159
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 341
;337:					S_COLOR_RED
;338:					"Monster waves: unknown monster %s\n",
;339:					monsterName
;340:				);
;341:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $157
line 344
;342:			}
;343:
;344:			if( !G_MonsterWaveReadInt(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 32
INDIRP4
CNSTI4 8
ADDP4
ARGP4
ADDRLP4 116
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 116
INDIRI4
CNSTI4 0
NEI4 $160
line 347
;345:				text,
;346:				&entry->count
;347:			) ) {
line 348
;348:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $160
line 351
;349:			}
;350:
;351:			if( entry->count < 1 ) {
ADDRLP4 32
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 1
GEI4 $162
line 352
;352:				G_Printf(
ADDRGP4 $164
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 357
;353:					S_COLOR_RED
;354:					"Monster waves: invalid count for %s\n",
;355:					monsterName
;356:				);
;357:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $162
line 360
;358:			}
;359:
;360:			wave->numEntries++;
ADDRLP4 120
ADDRLP4 4
INDIRP4
CNSTI4 96
ADDP4
ASGNP4
ADDRLP4 120
INDIRP4
ADDRLP4 120
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 361
;361:			continue;
ADDRGP4 $141
JUMPV
LABELV $149
line 364
;362:		}
;363:
;364:		if( !Q_stricmp(token, "repeat") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $167
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $165
line 365
;365:			token = COM_Parse(text);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 36
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 36
INDIRP4
ASGNP4
line 367
;366:
;367:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $168
line 368
;368:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $168
line 371
;369:			}
;370:
;371:			wave->repeat =
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $170
ARGP4
ADDRLP4 44
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $174
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 48
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
EQI4 $172
LABELV $174
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $173
JUMPV
LABELV $172
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $173
ADDRLP4 4
INDIRP4
CNSTI4 100
ADDP4
ADDRLP4 40
INDIRI4
ASGNI4
line 375
;372:				!Q_stricmp(token, "true") ||
;373:				atoi(token) != 0;
;374:
;375:			continue;
ADDRGP4 $141
JUMPV
LABELV $165
line 378
;376:		}
;377:
;378:		G_Printf(
ADDRGP4 $175
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 384
;379:			S_COLOR_RED
;380:			"Monster waves: unknown key %s in wave %i\n",
;381:			token,
;382:			waveNumber
;383:		);
;384:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $141
line 286
ADDRGP4 $140
JUMPV
LABELV $142
line 387
;385:	}
;386:
;387:	return qtrue;
CNSTI4 1
RETI4
LABELV $130
endproc G_MonsterWaveParseWave 124 12
proc G_LoadMonsterWaveConfig 8260 16
line 392
;388:}
;389:
;390:static qboolean G_LoadMonsterWaveConfig(
;391:	const char *filename
;392:) {
line 401
;393:	fileHandle_t file;
;394:	char buffer[MAX_MONSTER_WAVE_TEXT];
;395:	char *text;
;396:	char *token;
;397:	int length;
;398:	int value;
;399:	int i;
;400:
;401:	memset(
ADDRGP4 monsterWaves
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3328
ARGI4
ADDRGP4 memset
CALLP4
pop
line 411
;402:		monsterWaves,
;403:		0,
;404:		sizeof(monsterWaves)
;405:	);
;406:
;407:	/*
;408:	 * Default values used when a key is absent
;409:	 * from monsterwaves.cfg.
;410:	 */
;411:	monsterWaveDelay = 5000;
ADDRGP4 monsterWaveDelay
CNSTI4 5000
ASGNI4
line 412
;412:	monsterWaveSpawnInterval = 750;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 750
ASGNI4
line 413
;413:	monsterWaveTimeout = 30000;
ADDRGP4 monsterWaveTimeout
CNSTI4 30000
ASGNI4
line 414
;414:	monsterWaveMaxActive = 8;
ADDRGP4 monsterWaveMaxActive
CNSTI4 8
ASGNI4
line 415
;415:	monsterWaveFinal = DEFAULT_MONSTER_WAVES;
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 417
;416:
;417:	length = trap_FS_FOpenFile(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 8216
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 8216
INDIRI4
ASGNI4
line 423
;418:		filename,
;419:		&file,
;420:		FS_READ
;421:	);
;422:
;423:	if( !file ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $177
line 424
;424:		G_Printf(
ADDRGP4 $179
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 429
;425:			S_COLOR_RED
;426:			"Monster wave config not found: %s\n",
;427:			filename
;428:		);
;429:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
LABELV $177
line 432
;430:	}
;431:
;432:	if( length <= 0 ||
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $182
ADDRLP4 16
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $180
LABELV $182
line 433
;433:		length >= sizeof(buffer) ) {
line 434
;434:		G_Printf(
ADDRGP4 $183
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 440
;435:			S_COLOR_RED
;436:			"Invalid monster wave config size: %s\n",
;437:			filename
;438:		);
;439:
;440:		trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 441
;441:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
LABELV $180
line 444
;442:	}
;443:
;444:	trap_FS_Read(buffer, length, file);
ADDRLP4 24
ARGP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 445
;445:	buffer[length] = '\0';
ADDRLP4 16
INDIRI4
ADDRLP4 24
ADDP4
CNSTI1 0
ASGNI1
line 446
;446:	trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 448
;447:
;448:	text = buffer;
ADDRLP4 4
ADDRLP4 24
ASGNP4
ADDRGP4 $185
JUMPV
LABELV $184
line 450
;449:
;450:	while( 1 ) {
line 451
;451:		token = COM_Parse(&text);
ADDRLP4 4
ARGP4
ADDRLP4 8224
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8224
INDIRP4
ASGNP4
line 453
;452:
;453:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $187
line 454
;454:			break;
ADDRGP4 $186
JUMPV
LABELV $187
line 457
;455:		}
;456:
;457:		if( !Q_stricmp(token, "waveDelay") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $191
ARGP4
ADDRLP4 8228
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8228
INDIRI4
CNSTI4 0
NEI4 $189
line 458
;458:			if( !G_MonsterWaveReadInt(
ADDRLP4 4
ARGP4
ADDRGP4 monsterWaveDelay
ARGP4
ADDRLP4 8232
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 8232
INDIRI4
CNSTI4 0
NEI4 $185
line 461
;459:				&text,
;460:				&monsterWaveDelay
;461:			) ) {
line 462
;462:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
line 465
;463:			}
;464:
;465:			continue;
LABELV $189
line 468
;466:		}
;467:
;468:		if( !Q_stricmp(token, "spawnInterval") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $196
ARGP4
ADDRLP4 8232
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8232
INDIRI4
CNSTI4 0
NEI4 $194
line 469
;469:			if( !G_MonsterWaveReadInt(
ADDRLP4 4
ARGP4
ADDRGP4 monsterWaveSpawnInterval
ARGP4
ADDRLP4 8236
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 8236
INDIRI4
CNSTI4 0
NEI4 $185
line 472
;470:				&text,
;471:				&monsterWaveSpawnInterval
;472:			) ) {
line 473
;473:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
line 476
;474:			}
;475:
;476:			continue;
LABELV $194
line 479
;477:		}
;478:
;479:		if( !Q_stricmp(token, "waveTimeout") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $201
ARGP4
ADDRLP4 8236
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8236
INDIRI4
CNSTI4 0
NEI4 $199
line 480
;480:			if( !G_MonsterWaveReadInt(
ADDRLP4 4
ARGP4
ADDRGP4 monsterWaveTimeout
ARGP4
ADDRLP4 8240
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 8240
INDIRI4
CNSTI4 0
NEI4 $185
line 483
;481:				&text,
;482:				&monsterWaveTimeout
;483:			) ) {
line 484
;484:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
line 487
;485:			}
;486:
;487:			continue;
LABELV $199
line 490
;488:		}
;489:
;490:		if( !Q_stricmp(token, "maxActive") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $206
ARGP4
ADDRLP4 8240
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8240
INDIRI4
CNSTI4 0
NEI4 $204
line 491
;491:			if( !G_MonsterWaveReadInt(
ADDRLP4 4
ARGP4
ADDRGP4 monsterWaveMaxActive
ARGP4
ADDRLP4 8244
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 8244
INDIRI4
CNSTI4 0
NEI4 $185
line 494
;492:				&text,
;493:				&monsterWaveMaxActive
;494:			) ) {
line 495
;495:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
line 498
;496:			}
;497:
;498:			continue;
LABELV $204
line 501
;499:		}
;500:
;501:		if( !Q_stricmp(token, "finalWave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $211
ARGP4
ADDRLP4 8244
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8244
INDIRI4
CNSTI4 0
NEI4 $209
line 502
;502:			if( !G_MonsterWaveReadInt(
ADDRLP4 4
ARGP4
ADDRGP4 monsterWaveFinal
ARGP4
ADDRLP4 8248
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 8248
INDIRI4
CNSTI4 0
NEI4 $185
line 505
;503:				&text,
;504:				&monsterWaveFinal
;505:			) ) {
line 506
;506:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
line 509
;507:			}
;508:
;509:			continue;
LABELV $209
line 512
;510:		}
;511:
;512:		if( !Q_stricmp(token, "wave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $216
ARGP4
ADDRLP4 8248
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8248
INDIRI4
CNSTI4 0
NEI4 $214
line 513
;513:			if( !G_MonsterWaveReadInt(
ADDRLP4 4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 8252
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 8252
INDIRI4
CNSTI4 0
NEI4 $217
line 516
;514:				&text,
;515:				&value
;516:			) ) {
line 517
;517:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
LABELV $217
line 520
;518:			}
;519:
;520:			if( !G_MonsterWaveParseWave(
ADDRLP4 4
ARGP4
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 8256
ADDRGP4 G_MonsterWaveParseWave
CALLI4
ASGNI4
ADDRLP4 8256
INDIRI4
CNSTI4 0
NEI4 $185
line 523
;521:				&text,
;522:				value
;523:			) ) {
line 524
;524:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
line 527
;525:			}
;526:
;527:			continue;
LABELV $214
line 530
;528:		}
;529:
;530:		G_Printf(
ADDRGP4 $221
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 536
;531:			S_COLOR_RED
;532:			"Monster waves: unknown key %s\n",
;533:			token
;534:		);
;535:
;536:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
LABELV $185
line 450
ADDRGP4 $184
JUMPV
LABELV $186
line 542
;537:	}
;538:
;539:	/*
;540:	 * Sanitize timing and entity limits.
;541:	 */
;542:	if( monsterWaveDelay < 0 ) {
ADDRGP4 monsterWaveDelay
INDIRI4
CNSTI4 0
GEI4 $222
line 543
;543:		monsterWaveDelay = 0;
ADDRGP4 monsterWaveDelay
CNSTI4 0
ASGNI4
line 544
;544:	}
LABELV $222
line 546
;545:
;546:	if( monsterWaveSpawnInterval < 100 ) {
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
CNSTI4 100
GEI4 $224
line 547
;547:		monsterWaveSpawnInterval = 100;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 100
ASGNI4
line 548
;548:	}
LABELV $224
line 550
;549:
;550:	if( monsterWaveTimeout < 5000 ) {
ADDRGP4 monsterWaveTimeout
INDIRI4
CNSTI4 5000
GEI4 $226
line 551
;551:		monsterWaveTimeout = 5000;
ADDRGP4 monsterWaveTimeout
CNSTI4 5000
ASGNI4
line 552
;552:	}
LABELV $226
line 554
;553:
;554:	if( monsterWaveMaxActive < 1 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 1
GEI4 $228
line 555
;555:		monsterWaveMaxActive = 1;
ADDRGP4 monsterWaveMaxActive
CNSTI4 1
ASGNI4
line 556
;556:	}
ADDRGP4 $229
JUMPV
LABELV $228
line 557
;557:	else if( monsterWaveMaxActive > 64 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 64
LEI4 $230
line 558
;558:		monsterWaveMaxActive = 64;
ADDRGP4 monsterWaveMaxActive
CNSTI4 64
ASGNI4
line 559
;559:	}
LABELV $230
LABELV $229
line 561
;560:
;561:	if( monsterWaveFinal < 1 ||
ADDRLP4 8224
ADDRGP4 monsterWaveFinal
INDIRI4
ASGNI4
ADDRLP4 8224
INDIRI4
CNSTI4 1
LTI4 $234
ADDRLP4 8224
INDIRI4
CNSTI4 32
LEI4 $232
LABELV $234
line 563
;562:		monsterWaveFinal >
;563:			MAX_MONSTER_WAVES ) {
line 564
;564:		monsterWaveFinal =
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 566
;565:			DEFAULT_MONSTER_WAVES;
;566:	}
LABELV $232
line 572
;567:
;568:	/*
;569:	 * Every enabled wave must contain at least
;570:	 * one monster definition.
;571:	 */
;572:	for( i = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $238
JUMPV
LABELV $235
line 574
;573:		i < monsterWaveFinal;
;574:		i++ ) {
line 575
;575:		if( monsterWaves[i].numEntries == 0 ) {
CNSTI4 104
ADDRLP4 8
INDIRI4
MULI4
ADDRGP4 monsterWaves+96
ADDP4
INDIRI4
CNSTI4 0
NEI4 $239
line 576
;576:			G_Printf(
ADDRGP4 $242
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 582
;577:				S_COLOR_RED
;578:				"Monster waves: wave %i is empty\n",
;579:				i + 1
;580:			);
;581:
;582:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $176
JUMPV
LABELV $239
line 584
;583:		}
;584:	}
LABELV $236
line 574
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $238
line 573
ADDRLP4 8
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
LTI4 $235
line 586
;585:
;586:	G_Printf(
ADDRGP4 $243
ARGP4
ADDRGP4 monsterWaveFinal
INDIRI4
ARGI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
ARGI4
ADDRGP4 monsterWaveTimeout
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 595
;587:		S_COLOR_GREEN
;588:		"Loaded monsterwaves.cfg: %i waves, "
;589:		"max %i active, timeout %i ms\n",
;590:		monsterWaveFinal,
;591:		monsterWaveMaxActive,
;592:		monsterWaveTimeout
;593:	);
;594:
;595:	return qtrue;
CNSTI4 1
RETI4
LABELV $176
endproc G_LoadMonsterWaveConfig 8260 16
export G_MonsterInitDefinitions
proc G_MonsterInitDefinitions 8 12
line 599
;596:}
;597:
;598:
;599:void G_MonsterInitDefinitions(void) {
line 602
;600:	int i;
;601:	
;602:	monsterItemCounter = 0;
ADDRGP4 monsterItemCounter
CNSTI4 0
ASGNI4
line 603
;603:	monsterActiveCount = 0;
ADDRGP4 monsterActiveCount
CNSTI4 0
ASGNI4
line 605
;604:	
;605:	monsterCurrentWave = 0;
ADDRGP4 monsterCurrentWave
CNSTI4 0
ASGNI4
line 606
;606:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 607
;607:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 608
;608:	monsterWaveNextSpawn = 0;
ADDRGP4 monsterWaveNextSpawn
CNSTI4 0
ASGNI4
line 609
;609:	monsterWaveNextStart = 0;
ADDRGP4 monsterWaveNextStart
CNSTI4 0
ASGNI4
line 610
;610:	monsterWaveLastProgress = 0;
ADDRGP4 monsterWaveLastProgress
CNSTI4 0
ASGNI4
line 612
;611:
;612:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 613
;613:	monsterWaveStarted = qfalse;
ADDRGP4 monsterWaveStarted
CNSTI4 0
ASGNI4
line 614
;614:	monsterWaveCombatStarted = qfalse;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 0
ASGNI4
line 615
;615:	monsterWaveFinished = qfalse;
ADDRGP4 monsterWaveFinished
CNSTI4 0
ASGNI4
line 617
;616:
;617:	memset(g_monsterDefs, 0, sizeof(g_monsterDefs));
ADDRGP4 g_monsterDefs
ARGP4
CNSTI4 0
ARGI4
CNSTI4 33240
ARGI4
ADDRGP4 memset
CALLP4
pop
line 618
;618:	memset(g_monsterDefLoaded, 0, sizeof(g_monsterDefLoaded));
ADDRGP4 g_monsterDefLoaded
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 620
;619:
;620:	for (i = 0; monsterConfigFiles[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $248
JUMPV
LABELV $245
line 621
;621:		G_LoadMonsterConfig(monsterConfigFiles[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 monsterConfigFiles
ADDP4
INDIRP4
ARGP4
ADDRGP4 G_LoadMonsterConfig
CALLI4
pop
line 622
;622:	}
LABELV $246
line 620
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $248
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $245
line 624
;623:	
;624:	monsterWavesLoaded = qfalse;
ADDRGP4 monsterWavesLoaded
CNSTI4 0
ASGNI4
line 629
;625:
;626:	/*
;627:	 * Both Monster Hunt modes use monsterwaves.cfg.
;628:	 */
;629:	if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $249
line 630
;630:		MONSTER_HUNT_OFF ) {
line 631
;631:		monsterWavesLoaded =
ADDRGP4 $252
ARGP4
ADDRLP4 4
ADDRGP4 G_LoadMonsterWaveConfig
CALLI4
ASGNI4
ADDRGP4 monsterWavesLoaded
ADDRLP4 4
INDIRI4
ASGNI4
line 635
;632:			G_LoadMonsterWaveConfig(
;633:				"monsterwaves.cfg"
;634:			);
;635:	}
LABELV $249
line 636
;636:}
LABELV $244
endproc G_MonsterInitDefinitions 8 12
proc G_MonsterEligibleItem 24 0
line 638
;637:
;638:static qboolean G_MonsterEligibleItem(gentity_t *item) {
line 639
;639:	if (!item || !item->item) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTU4 0
ASGNU4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
EQU4 $256
ADDRLP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $254
LABELV $256
line 640
;640:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $253
JUMPV
LABELV $254
line 643
;641:	}
;642:
;643:	if (item->flags & FL_DROPPED_ITEM) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $257
line 644
;644:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $253
JUMPV
LABELV $257
line 647
;645:	}
;646:
;647:	if (item->team || item->targetname || item->wait == -1) {
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
CNSTU4 0
ASGNU4
ADDRLP4 8
INDIRP4
CNSTI4 656
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 12
INDIRU4
NEU4 $262
ADDRLP4 8
INDIRP4
CNSTI4 652
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 12
INDIRU4
NEU4 $262
ADDRLP4 8
INDIRP4
CNSTI4 796
ADDP4
INDIRF4
CNSTF4 3212836864
NEF4 $259
LABELV $262
line 648
;648:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $253
JUMPV
LABELV $259
line 651
;649:	}
;650:
;651:	switch (item->item->giType) {
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 1
LTI4 $263
ADDRLP4 16
INDIRI4
CNSTI4 5
GTI4 $263
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $267-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $267
address $266
address $266
address $266
address $266
address $266
code
LABELV $266
line 657
;652:	case IT_WEAPON:
;653:	case IT_AMMO:
;654:	case IT_ARMOR:
;655:	case IT_HEALTH:
;656:	case IT_POWERUP:
;657:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $253
JUMPV
LABELV $263
line 660
;658:
;659:	default:
;660:		return qfalse;
CNSTI4 0
RETI4
LABELV $253
endproc G_MonsterEligibleItem 24 0
proc G_MonsterSetOrigin 0 8
line 667
;661:	}
;662:}
;663:
;664:static void G_MonsterSetOrigin(
;665:	gentity_t *monster,
;666:	const vec3_t origin
;667:) {
line 668
;668:	G_SetOrigin(monster, (float *)origin);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 674
;669:
;670:	/*
;671:	 * The client interpolates monsters between snapshots.
;672:	 * G_SetOrigin resets trType to TR_STATIONARY.
;673:	 */
;674:	monster->s.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 675
;675:	monster->s.pos.trTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 676
;676:}
LABELV $269
endproc G_MonsterSetOrigin 0 8
proc G_MonsterSpawnAtOrigin 52 12
line 683
;677:
;678:static qboolean G_MonsterSpawnAtOrigin(
;679:	gentity_t *item,
;680:	monsterDef_t *def,
;681:	vec3_t spawnOrigin,
;682:	qboolean waveSpawn
;683:) {
line 687
;684:	gentity_t *monster;
;685:	vec3_t origin;
;686:
;687:	if( waveSpawn ) {
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $272
line 688
;688:		if( monsterActiveCount >=
ADDRGP4 monsterActiveCount
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $273
line 689
;689:			monsterWaveMaxActive ) {
line 690
;690:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $271
JUMPV
line 692
;691:		}
;692:	}
LABELV $272
line 693
;693:	else if( monsterActiveCount >= 8 ) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $276
line 694
;694:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $271
JUMPV
LABELV $276
LABELV $273
line 697
;695:	}
;696:
;697:	if( !def ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $278
line 698
;698:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $271
JUMPV
LABELV $278
line 701
;699:	}
;700:
;701:	monster = G_Spawn();
ADDRLP4 16
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16
INDIRP4
ASGNP4
line 703
;702:
;703:	monster->classname = "monster";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $151
ASGNP4
line 704
;704:	monster->s.eType = ET_MONSTER;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 13
ASGNI4
line 706
;705:
;706:	if( def->models[0][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $280
line 707
;707:		monster->s.modelindex =
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 G_ModelIndex
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 709
;708:			G_ModelIndex(def->models[0]);
;709:	}
LABELV $280
line 711
;710:
;711:	if( def->models[1][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $282
line 712
;712:		monster->s.modelindex2 =
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 G_ModelIndex
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 164
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 714
;713:			G_ModelIndex(def->models[1]);
;714:	}
LABELV $282
line 716
;715:
;716:	if( def->models[2][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $284
line 717
;717:		monster->s.otherEntityNum =
ADDRFP4 4
INDIRP4
CNSTI4 192
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 G_ModelIndex
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 140
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 719
;718:			G_ModelIndex(def->models[2]);
;719:	}
LABELV $284
line 721
;720:
;721:	if( def->models[3][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 256
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $286
line 722
;722:		monster->s.otherEntityNum2 =
ADDRFP4 4
INDIRP4
CNSTI4 256
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 G_ModelIndex
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 144
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 724
;723:			G_ModelIndex(def->models[3]);
;724:	}
LABELV $286
line 726
;725:
;726:	monster->s.frame =
ADDRLP4 0
INDIRP4
CNSTI4 172
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 744
ADDP4
INDIRI4
ASGNI4
line 729
;727:		def->moveAnimation.firstFrame;
;728:
;729:	monster->s.groundEntityNum =
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 732
;730:		ENTITYNUM_NONE;
;731:
;732:	monster->s.apos.trType =
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 735
;733:		TR_STATIONARY;
;734:
;735:	monster->monsterType =
ADDRLP4 0
INDIRP4
CNSTI4 808
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 576
ADDP4
INDIRI4
ASGNI4
line 738
;736:		def->monsterType;
;737:
;738:	monster->monsterSlot =
ADDRLP4 0
INDIRP4
CNSTI4 812
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 580
ADDP4
INDIRI4
ASGNI4
line 745
;739:		def->monsterSlot;
;740:		
;741:	/*
;742:	 * Send monster definition identity to cgame.
;743:	 * Low byte: type, high byte: slot.
;744:	 */
;745:	monster->s.generic1 =
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 24
CNSTI4 255
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 204
ADDP4
ADDRLP4 20
INDIRP4
CNSTI4 576
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
BANDI4
ADDRLP4 20
INDIRP4
CNSTI4 580
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
BANDI4
CNSTI4 8
LSHI4
BORI4
ASGNI4
line 749
;746:		(def->monsterType & 255) |
;747:		((def->monsterSlot & 255) << 8);	
;748:
;749:	monster->monsterItem = item;
ADDRLP4 0
INDIRP4
CNSTI4 868
ADDP4
ADDRFP4 0
INDIRP4
ASGNP4
line 750
;750:	monster->monsterWaveSpawn = waveSpawn;
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
ADDRFP4 12
INDIRI4
ASGNI4
line 751
;751:	monster->monsterDead = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 0
ASGNI4
line 753
;752:
;753:	monster->health = def->health;
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 592
ADDP4
INDIRI4
ASGNI4
line 754
;754:	monster->takedamage = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 755
;755:	monster->pain = G_MonsterPain;
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
ADDRGP4 G_MonsterPain
ASGNP4
line 756
;756:	monster->die = G_MonsterDie;
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 G_MonsterDie
ASGNP4
line 758
;757:
;758:	monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 761
;759:		level.time + 500;
;760:
;761:	monster->monsterNextShot = 0;
ADDRLP4 0
INDIRP4
CNSTI4 876
ADDP4
CNSTI4 0
ASGNI4
line 762
;762:	monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 764
;763:
;764:	G_MonsterSetAnimation(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 770
;765:		monster,
;766:		MONSTER_STATE_IDLE,
;767:		0
;768:	);
;769:
;770:	monster->monsterNextTalk =
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 G_MonsterTalkDelay
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 856
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 32
INDIRI4
ADDI4
ASGNI4
line 774
;771:		level.time +
;772:		G_MonsterTalkDelay(def);
;773:
;774:	VectorCopy(
ADDRLP4 0
INDIRP4
CNSTI4 436
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 608
ADDP4
INDIRB
ASGNB 12
line 779
;775:		def->mins,
;776:		monster->r.mins
;777:	);
;778:
;779:	VectorCopy(
ADDRLP4 0
INDIRP4
CNSTI4 448
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 620
ADDP4
INDIRB
ASGNB 12
line 784
;780:		def->maxs,
;781:		monster->r.maxs
;782:	);
;783:
;784:	monster->r.contents = CONTENTS_BODY;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 33554432
ASGNI4
line 785
;785:	monster->clipmask = MASK_PLAYERSOLID;
ADDRLP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 33619969
ASGNI4
line 787
;786:
;787:	VectorCopy(spawnOrigin, origin);
ADDRLP4 4
ADDRFP4 8
INDIRP4
INDIRB
ASGNB 12
line 788
;788:	origin[2] += def->hoverHeight;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 604
ADDP4
INDIRF4
ADDF4
ASGNF4
line 790
;789:
;790:	G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 795
;791:		monster,
;792:		origin
;793:	);
;794:	
;795:	monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 798
;796:	level.time;
;797:
;798:	VectorCopy(
ADDRLP4 0
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 803
;799:		monster->r.currentOrigin,
;800:		monster->monsterProgressOrigin
;801:	);
;802:
;803:	monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 806
;804:		level.time;
;805:
;806:	monster->monsterDriftPhase =
ADDRLP4 0
INDIRP4
CNSTI4 840
ADDP4
CNSTF4 1060823368
ADDRLP4 0
INDIRP4
INDIRI4
CVIF4 4
MULF4
ASGNF4
line 809
;807:		monster->s.number * 0.73f;
;808:
;809:	monster->think = G_MonsterThink;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterThink
ASGNP4
line 810
;810:	monster->nextthink = level.time + 50;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 812
;811:
;812:	trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 818
;813:
;814:	/*
;815:	 * Classic Monster Hunt replaces and hides a map item.
;816:	 * Wave monsters are independent from map items.
;817:	 */
;818:	if( item && !waveSpawn ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $294
ADDRFP4 12
INDIRI4
CNSTI4 0
NEI4 $294
line 819
;819:		item->monsterType =
ADDRFP4 0
INDIRP4
CNSTI4 808
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 576
ADDP4
INDIRI4
ASGNI4
line 822
;820:			def->monsterType;
;821:
;822:		item->monsterSlot =
ADDRFP4 0
INDIRP4
CNSTI4 812
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 580
ADDP4
INDIRI4
ASGNI4
line 825
;823:			def->monsterSlot;
;824:
;825:		item->s.eFlags |= EF_NODRAW;
ADDRLP4 44
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 826
;826:		item->r.svFlags |= SVF_NOCLIENT;
ADDRLP4 48
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 827
;827:		item->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 828
;828:		item->touch = 0;
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
CNSTP4 0
ASGNP4
line 829
;829:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 830
;830:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 832
;831:
;832:		trap_UnlinkEntity(item);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 833
;833:	}
LABELV $294
line 835
;834:
;835:	monsterActiveCount++;
ADDRLP4 44
ADDRGP4 monsterActiveCount
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 844
;836:
;837:/*	G_Printf(
;838:		"Spawned %smonster %s at %s\n",
;839:		waveSpawn ? "wave " : "",
;840:		def->name,
;841:		vtos(origin)
;842:	);*/
;843:
;844:	return qtrue;
CNSTI4 1
RETI4
LABELV $271
endproc G_MonsterSpawnAtOrigin 52 12
proc G_MonsterSpawnFromItem 12 16
line 850
;845:}
;846:
;847:static qboolean G_MonsterSpawnFromItem(
;848:	gentity_t *item,
;849:	monsterDef_t *def
;850:) {
line 851
;851:	if( !item || !def ) {
ADDRLP4 0
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
EQU4 $299
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
NEU4 $297
LABELV $299
line 852
;852:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $296
JUMPV
LABELV $297
line 855
;853:	}
;854:
;855:	return G_MonsterSpawnAtOrigin(
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 8
ADDRGP4 G_MonsterSpawnAtOrigin
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
RETI4
LABELV $296
endproc G_MonsterSpawnFromItem 12 16
proc G_MonsterRespawnThink 32 8
line 863
;856:		item,
;857:		def,
;858:		item->s.pos.trBase,
;859:		qfalse
;860:	);
;861:}
;862:
;863:static void G_MonsterRespawnThink(gentity_t *item) {
line 866
;864:	monsterDef_t *def;
;865:
;866:	if (item->monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
ADDRLP4 4
INDIRP4
CNSTI4 808
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 8
INDIRI4
ADDRLP4 12
INDIRI4
LEI4 $305
ADDRLP4 8
INDIRI4
CNSTI4 6
GEI4 $305
ADDRLP4 16
ADDRLP4 4
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
LTI4 $305
ADDRLP4 16
INDIRI4
CNSTI4 5
LTI4 $301
LABELV $305
line 869
;867:		item->monsterType >= MONSTER_TYPE_RANDOM ||
;868:		item->monsterSlot < 0 ||
;869:		item->monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 870
;870:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 871
;871:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 872
;872:		return;
ADDRGP4 $300
JUMPV
LABELV $301
line 875
;873:	}
;874:
;875:	if (!g_monsterDefLoaded
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 20
ADDRLP4 20
INDIRP4
CNSTI4 808
ADDP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefLoaded
ADDP4
ADDP4
INDIRI4
CNSTI4 0
NEI4 $306
line 877
;876:		[item->monsterType]
;877:		[item->monsterSlot]) {
line 878
;878:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 879
;879:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 880
;880:		return;
ADDRGP4 $300
JUMPV
LABELV $306
line 883
;881:	}
;882:
;883:	if (monsterActiveCount >= 8) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $308
line 884
;884:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 885
;885:		return;
ADDRGP4 $300
JUMPV
LABELV $308
line 888
;886:	}
;887:
;888:	def = &g_monsterDefs
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1108
ADDRLP4 24
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 24
INDIRP4
CNSTI4 808
ADDP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 892
;889:		[item->monsterType]
;890:		[item->monsterSlot];
;891:
;892:	if (!G_MonsterSpawnFromItem(item, def)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 G_MonsterSpawnFromItem
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $311
line 893
;893:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 894
;894:	}
LABELV $311
line 895
;895:}
LABELV $300
endproc G_MonsterRespawnThink 32 8
proc G_MonsterWaveHasPlayers 8 0
line 897
;896:
;897:static qboolean G_MonsterWaveHasPlayers( void ) {
line 901
;898:	gclient_t *client;
;899:	int i;
;900:
;901:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $318
JUMPV
LABELV $315
line 902
;902:		client = &level.clients[i];
ADDRLP4 0
CNSTI4 780
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 904
;903:
;904:		if( client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $320
line 905
;905:			CON_CONNECTED ) {
line 906
;906:			continue;
ADDRGP4 $316
JUMPV
LABELV $320
line 909
;907:		}
;908:
;909:		if( client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $322
line 910
;910:			TEAM_SPECTATOR ) {
line 911
;911:			continue;
ADDRGP4 $316
JUMPV
LABELV $322
line 914
;912:		}
;913:
;914:		if( client->oneLifeEliminated ) {
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $324
line 915
;915:			continue;
ADDRGP4 $316
JUMPV
LABELV $324
line 918
;916:		}
;917:
;918:		if( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $326
line 919
;919:			continue;
ADDRGP4 $316
JUMPV
LABELV $326
line 922
;920:		}
;921:
;922:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $314
JUMPV
LABELV $316
line 901
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $318
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $315
line 925
;923:	}
;924:
;925:	return qfalse;
CNSTI4 0
RETI4
LABELV $314
endproc G_MonsterWaveHasPlayers 8 0
proc G_MonsterWaveLivingCount 12 0
line 928
;926:}
;927:
;928:static int G_MonsterWaveLivingCount( void ) {
line 933
;929:	gentity_t *ent;
;930:	int count;
;931:	int i;
;932:
;933:	count = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 935
;934:
;935:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $332
JUMPV
LABELV $329
line 937
;936:		i < level.num_entities;
;937:		i++ ) {
line 938
;938:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 940
;939:
;940:		if( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $334
line 941
;941:			continue;
ADDRGP4 $330
JUMPV
LABELV $334
line 944
;942:		}
;943:
;944:		if( ent->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $336
line 945
;945:			continue;
ADDRGP4 $330
JUMPV
LABELV $336
line 948
;946:		}
;947:
;948:		if( !ent->monsterWaveSpawn ) {
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
NEI4 $338
line 949
;949:			continue;
ADDRGP4 $330
JUMPV
LABELV $338
line 952
;950:		}
;951:
;952:		if( ent->monsterDead ) {
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $340
line 953
;953:			continue;
ADDRGP4 $330
JUMPV
LABELV $340
line 956
;954:		}
;955:
;956:		count++;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 957
;957:	}
LABELV $330
line 937
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $332
line 936
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $329
line 959
;958:
;959:	return count;
ADDRLP4 8
INDIRI4
RETI4
LABELV $328
endproc G_MonsterWaveLivingCount 12 0
proc G_MonsterWaveSpotSafe 96 28
line 966
;960:}
;961:
;962:static qboolean G_MonsterWaveSpotSafe(
;963:	gentity_t *spot,
;964:	monsterDef_t *def,
;965:	qboolean requireDistance
;966:) {
line 972
;967:	gentity_t *player;
;968:	trace_t trace;
;969:	vec3_t origin;
;970:	int i;
;971:
;972:	if( !spot || !def ) {
ADDRLP4 76
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
EQU4 $345
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
NEU4 $343
LABELV $345
line 973
;973:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $342
JUMPV
LABELV $343
line 976
;974:	}
;975:
;976:	if( SpotWouldTelefrag(spot) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 80
ADDRGP4 SpotWouldTelefrag
CALLI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 0
EQI4 $346
line 977
;977:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $342
JUMPV
LABELV $346
line 980
;978:	}
;979:
;980:	VectorCopy(spot->s.origin, origin);
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 981
;981:	origin[2] += 9 + def->hoverHeight;
ADDRLP4 8+8
ADDRLP4 8+8
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 604
ADDP4
INDIRF4
CNSTF4 1091567616
ADDF4
ADDF4
ASGNF4
line 983
;982:
;983:	trap_Trace(
ADDRLP4 20
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 84
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 84
INDIRP4
CNSTI4 608
ADDP4
ARGP4
ADDRLP4 84
INDIRP4
CNSTI4 620
ADDP4
ARGP4
ADDRLP4 8
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 993
;984:		&trace,
;985:		origin,
;986:		def->mins,
;987:		def->maxs,
;988:		origin,
;989:		ENTITYNUM_NONE,
;990:		MASK_PLAYERSOLID
;991:	);
;992:
;993:	if( trace.startsolid || trace.allsolid ) {
ADDRLP4 88
CNSTI4 0
ASGNI4
ADDRLP4 20+4
INDIRI4
ADDRLP4 88
INDIRI4
NEI4 $352
ADDRLP4 20
INDIRI4
ADDRLP4 88
INDIRI4
EQI4 $349
LABELV $352
line 994
;994:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $342
JUMPV
LABELV $349
line 997
;995:	}
;996:
;997:	if( !requireDistance ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $353
line 998
;998:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $342
JUMPV
LABELV $353
line 1001
;999:	}
;1000:
;1001:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $358
JUMPV
LABELV $355
line 1002
;1002:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1004
;1003:
;1004:		if( !player->client ) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $360
line 1005
;1005:			continue;
ADDRGP4 $356
JUMPV
LABELV $360
line 1008
;1006:		}
;1007:
;1008:		if( player->client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $362
line 1009
;1009:			CON_CONNECTED ) {
line 1010
;1010:			continue;
ADDRGP4 $356
JUMPV
LABELV $362
line 1013
;1011:		}
;1012:
;1013:		if( player->client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $364
line 1014
;1014:			TEAM_SPECTATOR ) {
line 1015
;1015:			continue;
ADDRGP4 $356
JUMPV
LABELV $364
line 1018
;1016:		}
;1017:
;1018:		if( player->health <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $366
line 1019
;1019:			continue;
ADDRGP4 $356
JUMPV
LABELV $366
line 1022
;1020:		}
;1021:
;1022:		if( DistanceSquared(
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 92
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 92
INDIRF4
CNSTF4 1199570944
GEF4 $368
line 1025
;1023:			spot->s.origin,
;1024:			player->r.currentOrigin
;1025:		) < 256.0f * 256.0f ) {
line 1026
;1026:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $342
JUMPV
LABELV $368
line 1028
;1027:		}
;1028:	}
LABELV $356
line 1001
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $358
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $355
line 1030
;1029:
;1030:	return qtrue;
CNSTI4 1
RETI4
LABELV $342
endproc G_MonsterWaveSpotSafe 96 28
proc G_MonsterWaveChooseSpawn 536 12
line 1036
;1031:}
;1032:
;1033:static qboolean G_MonsterWaveChooseSpawn(
;1034:	monsterDef_t *def,
;1035:	vec3_t origin
;1036:) {
line 1042
;1037:	gentity_t *spots[128];
;1038:	gentity_t *spot;
;1039:	int count;
;1040:	int pass;
;1041:
;1042:	for( pass = 0; pass < 2; pass++ ) {
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $371
line 1043
;1043:		count = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1044
;1044:		spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $376
JUMPV
LABELV $375
line 1050
;1045:
;1046:		while( (spot = G_Find(
;1047:			spot,
;1048:			FOFS(classname),
;1049:			"info_player_deathmatch"
;1050:		)) != NULL ) {
line 1051
;1051:			if( !G_MonsterWaveSpotSafe(
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $382
ADDRLP4 524
CNSTI4 1
ASGNI4
ADDRGP4 $383
JUMPV
LABELV $382
ADDRLP4 524
CNSTI4 0
ASGNI4
LABELV $383
ADDRLP4 524
INDIRI4
ARGI4
ADDRLP4 528
ADDRGP4 G_MonsterWaveSpotSafe
CALLI4
ASGNI4
ADDRLP4 528
INDIRI4
CNSTI4 0
NEI4 $379
line 1055
;1052:				spot,
;1053:				def,
;1054:				pass == 0
;1055:			) ) {
line 1056
;1056:				continue;
ADDRGP4 $376
JUMPV
LABELV $379
line 1059
;1057:			}
;1058:
;1059:			spots[count++] = spot;
ADDRLP4 532
ADDRLP4 4
INDIRI4
ASGNI4
ADDRLP4 4
ADDRLP4 532
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 532
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 12
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 1061
;1060:
;1061:			if( count >= 128 ) {
ADDRLP4 4
INDIRI4
CNSTI4 128
LTI4 $384
line 1062
;1062:				break;
ADDRGP4 $377
JUMPV
LABELV $384
line 1064
;1063:			}
;1064:		}
LABELV $376
line 1046
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $378
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
NEU4 $375
LABELV $377
line 1066
;1065:
;1066:		if( count > 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LEI4 $386
line 1067
;1067:			spot = spots[rand() % count];
ADDRLP4 528
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 528
INDIRI4
ADDRLP4 4
INDIRI4
MODI4
CNSTI4 2
LSHI4
ADDRLP4 12
ADDP4
INDIRP4
ASGNP4
line 1069
;1068:
;1069:			VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1074
;1070:				spot->s.origin,
;1071:				origin
;1072:			);
;1073:
;1074:			origin[2] += 9;
ADDRLP4 532
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 532
INDIRP4
ADDRLP4 532
INDIRP4
INDIRF4
CNSTF4 1091567616
ADDF4
ASGNF4
line 1075
;1075:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $370
JUMPV
LABELV $386
line 1077
;1076:		}
;1077:	}
LABELV $372
line 1042
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 2
LTI4 $371
line 1079
;1078:
;1079:	return qfalse;
CNSTI4 0
RETI4
LABELV $370
endproc G_MonsterWaveChooseSpawn 536 12
proc G_MonsterWaveBegin 8 8
line 1082
;1080:}
;1081:
;1082:static void G_MonsterWaveBegin( void ) {
line 1083
;1083:	monsterWaveActive = qtrue;
ADDRGP4 monsterWaveActive
CNSTI4 1
ASGNI4
line 1084
;1084:	monsterWaveCombatStarted = qtrue;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 1
ASGNI4
line 1085
;1085:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 1086
;1086:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1087
;1087:	monsterWaveNextSpawn = level.time;
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1088
;1088:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1090
;1089:
;1090:	trap_SendServerCommand(
ADDRGP4 $391
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRLP4 0
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1098
;1091:		-1,
;1092:		va(
;1093:			"cp \"Wave %i\n\"",
;1094:			monsterCurrentWave
;1095:		)
;1096:	);
;1097:
;1098:	trap_SendServerCommand(
ADDRGP4 $392
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRLP4 4
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1106
;1099:		-1,
;1100:		va(
;1101:			"print \"Monster Hunt: wave %i started.\n\"",
;1102:			monsterCurrentWave
;1103:		)
;1104:	);
;1105:
;1106:	G_Printf(
ADDRGP4 $393
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 1110
;1107:		"Monster Hunt: wave %i started.\n",
;1108:		monsterCurrentWave
;1109:	);
;1110:}
LABELV $388
endproc G_MonsterWaveBegin 8 8
proc G_MonsterWaveComplete 8 8
line 1112
;1111:
;1112:static void G_MonsterWaveComplete( void ) {
line 1113
;1113:	trap_SendServerCommand(
ADDRGP4 $395
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRLP4 0
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1121
;1114:		-1,
;1115:		va(
;1116:			"print \"Monster Hunt: wave %i cleared.\n\"",
;1117:			monsterCurrentWave
;1118:		)
;1119:	);
;1120:
;1121:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 1123
;1122:
;1123:	if( monsterCurrentWave <
ADDRGP4 monsterCurrentWave
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
GEI4 $396
line 1124
;1124:		monsterWaveFinal ) {
line 1125
;1125:		monsterCurrentWave++;
ADDRLP4 4
ADDRGP4 monsterCurrentWave
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1127
;1126:
;1127:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1131
;1128:			level.time +
;1129:			monsterWaveDelay;
;1130:
;1131:		return;
ADDRGP4 $394
JUMPV
LABELV $396
line 1138
;1132:	}
;1133:
;1134:	/*
;1135:	 * Classic Monster Hunt repeats the final wave until
;1136:	 * fraglimit or timelimit ends the match.
;1137:	 */
;1138:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 1
NEI4 $399
line 1139
;1139:		MONSTER_HUNT_CLASSIC ) {
line 1140
;1140:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1144
;1141:			level.time +
;1142:			monsterWaveDelay;
;1143:
;1144:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $403
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1149
;1145:			-1,
;1146:			"print \"Monster Hunt: final wave restarting.\n\""
;1147:		);
;1148:
;1149:		return;
ADDRGP4 $394
JUMPV
LABELV $399
line 1155
;1150:	}
;1151:
;1152:	/*
;1153:	 * One Life ends after clearing the final wave.
;1154:	 */
;1155:	monsterWaveFinished = qtrue;
ADDRGP4 monsterWaveFinished
CNSTI4 1
ASGNI4
line 1157
;1156:
;1157:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $404
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1162
;1158:		-1,
;1159:		"cp \"Monster Hunt completed!\n\""
;1160:	);
;1161:
;1162:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $405
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1167
;1163:		-1,
;1164:		"print \"Monster Hunt: all waves cleared.\n\""
;1165:	);
;1166:
;1167:	LogExit(
ADDRGP4 $406
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1170
;1168:		"Monster Hunt completed."
;1169:	);
;1170:}
LABELV $394
endproc G_MonsterWaveComplete 8 8
proc G_MonsterWaveRelocateStuck 48 12
line 1172
;1171:
;1172:static int G_MonsterWaveRelocateStuck( void ) {
line 1179
;1173:	gentity_t *monster;
;1174:	monsterDef_t *def;
;1175:	vec3_t origin;
;1176:	int relocated;
;1177:	int i;
;1178:
;1179:	relocated = 0;
ADDRLP4 24
CNSTI4 0
ASGNI4
line 1181
;1180:
;1181:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $411
JUMPV
LABELV $408
line 1183
;1182:		i < level.num_entities;
;1183:		i++ ) {
line 1184
;1184:		monster = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1186
;1185:
;1186:		if( !monster->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $413
line 1187
;1187:			continue;
ADDRGP4 $409
JUMPV
LABELV $413
line 1190
;1188:		}
;1189:
;1190:		if( monster->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $415
line 1191
;1191:			continue;
ADDRGP4 $409
JUMPV
LABELV $415
line 1194
;1192:		}
;1193:
;1194:		if( !monster->monsterWaveSpawn ||
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $419
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $417
LABELV $419
line 1195
;1195:			monster->monsterDead ) {
line 1196
;1196:			continue;
ADDRGP4 $409
JUMPV
LABELV $417
line 1203
;1197:		}
;1198:
;1199:		/*
;1200:		 * Relocate only monsters that have neither moved,
;1201:		 * fired nor received damage for the timeout period.
;1202:		 */
;1203:		if( level.time -
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
INDIRI4
SUBI4
ADDRGP4 monsterWaveTimeout
INDIRI4
GEI4 $420
line 1205
;1204:			monster->monsterProgressTime <
;1205:			monsterWaveTimeout ) {
line 1206
;1206:			continue;
ADDRGP4 $409
JUMPV
LABELV $420
line 1209
;1207:		}
;1208:
;1209:		def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1108
ADDRLP4 0
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 0
INDIRP4
CNSTI4 808
ADDP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 1213
;1210:			[monster->monsterType]
;1211:			[monster->monsterSlot];
;1212:
;1213:		if( !G_MonsterWaveChooseSpawn(
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 40
ADDRGP4 G_MonsterWaveChooseSpawn
CALLI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
NEI4 $423
line 1216
;1214:			def,
;1215:			origin
;1216:		) ) {
line 1217
;1217:			continue;
ADDRGP4 $409
JUMPV
LABELV $423
line 1224
;1218:		}
;1219:
;1220:		/*
;1221:		 * ChooseSpawn returns the base position.
;1222:		 * Apply the monster's configured hovering height.
;1223:		 */
;1224:		origin[2] += def->hoverHeight;
ADDRLP4 12+8
ADDRLP4 12+8
INDIRF4
ADDRLP4 8
INDIRP4
CNSTI4 604
ADDP4
INDIRF4
ADDF4
ASGNF4
line 1226
;1225:
;1226:		G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1231
;1227:			monster,
;1228:			origin
;1229:		);
;1230:
;1231:		monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1234
;1232:			level.time;
;1233:
;1234:		VectorCopy(
ADDRLP4 0
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1239
;1235:			monster->r.currentOrigin,
;1236:			monster->monsterProgressOrigin
;1237:		);
;1238:
;1239:		monster->enemy = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 768
ADDP4
CNSTP4 0
ASGNP4
line 1240
;1240:		monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 1241
;1241:		monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1243
;1242:			level.time + 500;
;1243:		monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1246
;1244:			level.time;
;1245:
;1246:		G_MonsterSetAnimation(
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 1252
;1247:			monster,
;1248:			MONSTER_STATE_MOVE,
;1249:			0
;1250:		);
;1251:
;1252:		trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1253
;1253:		relocated++;
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1254
;1254:	}
LABELV $409
line 1183
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $411
line 1182
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $408
line 1256
;1255:
;1256:	return relocated;
ADDRLP4 24
INDIRI4
RETI4
LABELV $407
endproc G_MonsterWaveRelocateStuck 48 12
export G_MonsterRunFrame
proc G_MonsterRunFrame 60 16
line 1259
;1257:}
;1258:
;1259:void G_MonsterRunFrame( void ) {
line 1266
;1260:	monsterWaveDef_t *wave;
;1261:	monsterWaveEntry_t *entry;
;1262:	monsterDef_t *def;
;1263:	vec3_t origin;
;1264:	int living;
;1265:
;1266:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
NEI4 $430
line 1267
;1267:		MONSTER_HUNT_OFF ) {
line 1268
;1268:		return;
ADDRGP4 $429
JUMPV
LABELV $430
line 1271
;1269:	}
;1270:
;1271:	if( !monsterWavesLoaded ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 monsterWavesLoaded
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $435
ADDRGP4 monsterWaveFinished
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $433
LABELV $435
line 1272
;1272:		monsterWaveFinished ) {
line 1273
;1273:		return;
ADDRGP4 $429
JUMPV
LABELV $433
line 1276
;1274:	}
;1275:
;1276:	if( level.intermissiontime ||
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 level+9128
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $442
ADDRGP4 level+9124
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $442
ADDRGP4 level+16
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $436
LABELV $442
line 1278
;1277:		level.intermissionQueued ||
;1278:		level.warmupTime ) {
line 1279
;1279:		return;
ADDRGP4 $429
JUMPV
LABELV $436
line 1282
;1280:	}
;1281:
;1282:	if( !G_MonsterWaveHasPlayers() ) {
ADDRLP4 36
ADDRGP4 G_MonsterWaveHasPlayers
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $443
line 1283
;1283:		return;
ADDRGP4 $429
JUMPV
LABELV $443
line 1286
;1284:	}
;1285:
;1286:	if( !monsterWaveStarted ) {
ADDRGP4 monsterWaveStarted
INDIRI4
CNSTI4 0
NEI4 $445
line 1287
;1287:		monsterWaveStarted = qtrue;
ADDRGP4 monsterWaveStarted
CNSTI4 1
ASGNI4
line 1288
;1288:		monsterCurrentWave = 1;
ADDRGP4 monsterCurrentWave
CNSTI4 1
ASGNI4
line 1289
;1289:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1292
;1290:			level.time + monsterWaveDelay;
;1291:
;1292:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $448
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1297
;1293:			-1,
;1294:			"print \"Monster Hunt begins.\n\""
;1295:		);
;1296:
;1297:		return;
ADDRGP4 $429
JUMPV
LABELV $445
line 1300
;1298:	}
;1299:
;1300:	if( !monsterWaveActive ) {
ADDRGP4 monsterWaveActive
INDIRI4
CNSTI4 0
NEI4 $449
line 1301
;1301:		if( level.time >= monsterWaveNextStart ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextStart
INDIRI4
LTI4 $429
line 1302
;1302:			G_MonsterWaveBegin();
ADDRGP4 G_MonsterWaveBegin
CALLV
pop
line 1303
;1303:		}
line 1305
;1304:
;1305:		return;
ADDRGP4 $429
JUMPV
LABELV $449
line 1308
;1306:	}
;1307:
;1308:	wave =
ADDRLP4 0
CNSTI4 104
ADDRGP4 monsterCurrentWave
INDIRI4
MULI4
ADDRGP4 monsterWaves-104
ADDP4
ASGNP4
ADDRGP4 $456
JUMPV
LABELV $455
line 1312
;1309:		&monsterWaves[monsterCurrentWave - 1];
;1310:
;1311:	while( monsterWaveEntry <
;1312:		wave->numEntries ) {
line 1313
;1313:		entry =
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1316
;1314:			&wave->entries[monsterWaveEntry];
;1315:
;1316:		if( monsterWaveEntrySpawned <
ADDRGP4 monsterWaveEntrySpawned
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
GEI4 $458
line 1317
;1317:			entry->count ) {
line 1318
;1318:			break;
ADDRGP4 $457
JUMPV
LABELV $458
line 1321
;1319:		}
;1320:
;1321:		monsterWaveEntry++;
ADDRLP4 40
ADDRGP4 monsterWaveEntry
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1322
;1322:		monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1323
;1323:	}
LABELV $456
line 1311
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $455
LABELV $457
line 1325
;1324:
;1325:	living = G_MonsterWaveLivingCount();
ADDRLP4 40
ADDRGP4 G_MonsterWaveLivingCount
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 40
INDIRI4
ASGNI4
line 1331
;1326:
;1327:	/*
;1328:	 * Every configured monster has been spawned.
;1329:	 * Complete the wave after the last living monster dies.
;1330:	 */
;1331:	if( monsterWaveEntry >=
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $460
line 1332
;1332:		wave->numEntries ) {
line 1333
;1333:		if( living == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $462
line 1334
;1334:			G_MonsterWaveComplete();
ADDRGP4 G_MonsterWaveComplete
CALLV
pop
line 1335
;1335:			return;
ADDRGP4 $429
JUMPV
LABELV $462
line 1338
;1336:		}
;1337:
;1338:		if( level.time - monsterWaveLastProgress >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveLastProgress
INDIRI4
SUBI4
ADDRGP4 monsterWaveTimeout
INDIRI4
LTI4 $429
line 1339
;1339:			monsterWaveTimeout ) {
line 1342
;1340:			int relocated;
;1341:
;1342:			relocated =
ADDRLP4 48
ADDRGP4 G_MonsterWaveRelocateStuck
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 48
INDIRI4
ASGNI4
line 1345
;1343:				G_MonsterWaveRelocateStuck();
;1344:
;1345:			monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1361
;1346:
;1347:			/*trap_SendServerCommand(
;1348:				-1,
;1349:				va(
;1350:					"print \"Monster Hunt: relocated %i lost monsters.\n\"",
;1351:					relocated
;1352:				)
;1353:			);
;1354:
;1355:			G_Printf(
;1356:				"Monster Hunt: wave %i still has %i living monsters; relocated %i.\n",
;1357:				monsterCurrentWave,
;1358:				living,
;1359:				relocated
;1360:			);*/
;1361:		}
line 1363
;1362:
;1363:		return;
ADDRGP4 $429
JUMPV
LABELV $460
line 1366
;1364:	}
;1365:
;1366:	if( living >= monsterWaveMaxActive ) {
ADDRLP4 12
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $468
line 1367
;1367:		return;
ADDRGP4 $429
JUMPV
LABELV $468
line 1370
;1368:	}
;1369:
;1370:	if( level.time < monsterWaveNextSpawn ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextSpawn
INDIRI4
GEI4 $470
line 1371
;1371:		return;
ADDRGP4 $429
JUMPV
LABELV $470
line 1374
;1372:	}
;1373:
;1374:	entry = &wave->entries[monsterWaveEntry];
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1376
;1375:
;1376:	def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1108
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 4
INDIRP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 1380
;1377:		[entry->monsterType]
;1378:		[entry->monsterSlot];
;1379:
;1380:	if( !G_MonsterWaveChooseSpawn(
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 48
ADDRGP4 G_MonsterWaveChooseSpawn
CALLI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
NEI4 $473
line 1383
;1381:		def,
;1382:		origin
;1383:	) ) {
line 1384
;1384:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 1386
;1385:			level.time + 1000;
;1386:		return;
ADDRGP4 $429
JUMPV
LABELV $473
line 1389
;1387:	}
;1388:
;1389:	if( G_MonsterSpawnAtOrigin(
CNSTP4 0
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 52
ADDRGP4 G_MonsterSpawnAtOrigin
CALLI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 0
EQI4 $476
line 1394
;1390:		NULL,
;1391:		def,
;1392:		origin,
;1393:		qtrue
;1394:	) ) {
line 1395
;1395:	monsterWaveEntrySpawned++;
ADDRLP4 56
ADDRGP4 monsterWaveEntrySpawned
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1396
;1396:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1398
;1397:
;1398:	monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
ADDI4
ASGNI4
line 1401
;1399:		level.time +
;1400:			monsterWaveSpawnInterval;
;1401:	}
ADDRGP4 $477
JUMPV
LABELV $476
line 1402
;1402:	else {
line 1403
;1403:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1405
;1404:			level.time + 500;
;1405:	}
LABELV $477
line 1406
;1406:}
LABELV $429
endproc G_MonsterRunFrame 60 16
export G_MonsterTryReplaceItem
proc G_MonsterTryReplaceItem 0 0
line 1410
;1407:
;1408:qboolean G_MonsterTryReplaceItem(
;1409:	gentity_t *item
;1410:) {
line 1415
;1411:	/*
;1412:	 * Both Monster Hunt modes now receive monsters
;1413:	 * exclusively from the wave controller.
;1414:	 */
;1415:	return qfalse;
CNSTI4 0
RETI4
LABELV $481
endproc G_MonsterTryReplaceItem 0 0
proc G_MonsterFindTarget 28 8
line 1418
;1416:}
;1417:
;1418:static gentity_t *G_MonsterFindTarget(gentity_t *monster) {
line 1424
;1419:	gentity_t *player;
;1420:	gentity_t *best;
;1421:	float bestDistance;
;1422:	int i;
;1423:
;1424:	best = NULL;
ADDRLP4 12
CNSTP4 0
ASGNP4
line 1425
;1425:	bestDistance = 99999999.0f;
ADDRLP4 8
CNSTF4 1287568416
ASGNF4
line 1427
;1426:
;1427:	for (i = 0; i < level.maxclients; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $486
JUMPV
LABELV $483
line 1430
;1428:		float distance;
;1429:
;1430:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1432
;1431:
;1432:		if (!player->client) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $488
line 1433
;1433:			continue;
ADDRGP4 $484
JUMPV
LABELV $488
line 1436
;1434:		}
;1435:
;1436:		if (player->client->pers.connected != CON_CONNECTED) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $490
line 1437
;1437:			continue;
ADDRGP4 $484
JUMPV
LABELV $490
line 1440
;1438:		}
;1439:
;1440:		if (player->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $492
line 1441
;1441:			continue;
ADDRGP4 $484
JUMPV
LABELV $492
line 1444
;1442:		}
;1443:
;1444:		if (player->health <= 0) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $494
line 1445
;1445:			continue;
ADDRGP4 $484
JUMPV
LABELV $494
line 1448
;1446:		}
;1447:
;1448:		distance = DistanceSquared(
ADDRLP4 20
CNSTI4 488
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
ARGP4
ADDRLP4 24
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 16
ADDRLP4 24
INDIRF4
ASGNF4
line 1453
;1449:			monster->r.currentOrigin,
;1450:			player->r.currentOrigin
;1451:		);
;1452:
;1453:		if (distance < bestDistance) {
ADDRLP4 16
INDIRF4
ADDRLP4 8
INDIRF4
GEF4 $496
line 1454
;1454:			bestDistance = distance;
ADDRLP4 8
ADDRLP4 16
INDIRF4
ASGNF4
line 1455
;1455:			best = player;
ADDRLP4 12
ADDRLP4 0
INDIRP4
ASGNP4
line 1456
;1456:		}
LABELV $496
line 1457
;1457:	}
LABELV $484
line 1427
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $486
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $483
line 1459
;1458:
;1459:	return best;
ADDRLP4 12
INDIRP4
RETP4
LABELV $482
endproc G_MonsterFindTarget 28 8
proc G_MonsterAnimation 16 0
line 1465
;1460:}
;1461:
;1462:static animation_t *G_MonsterAnimation(
;1463:	gentity_t *monster,
;1464:	monsterDef_t *def
;1465:) {
line 1468
;1466:	int variant;
;1467:
;1468:	variant = monster->monsterAnimationVariant;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
INDIRI4
ASGNI4
line 1470
;1469:
;1470:	if (variant < 0 || variant >= MAX_MONSTER_VARIANTS) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $501
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $499
LABELV $501
line 1471
;1471:		variant = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1472
;1472:	}
LABELV $499
line 1474
;1473:
;1474:	switch (monster->monsterAnimation) {
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
LTI4 $502
ADDRLP4 8
INDIRI4
CNSTI4 5
GTI4 $502
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $511
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $511
address $505
address $506
address $507
address $508
address $509
address $510
code
LABELV $505
line 1476
;1475:	case MONSTER_STATE_IDLE:
;1476:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 716
ADDP4
RETP4
ADDRGP4 $498
JUMPV
LABELV $506
line 1479
;1477:
;1478:	case MONSTER_STATE_MOVE:
;1479:		return &def->moveAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 744
ADDP4
RETP4
ADDRGP4 $498
JUMPV
LABELV $507
line 1482
;1480:
;1481:	case MONSTER_STATE_MELEE:
;1482:		return &def->meleeAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 772
ADDP4
ADDP4
RETP4
ADDRGP4 $498
JUMPV
LABELV $508
line 1485
;1483:
;1484:	case MONSTER_STATE_RANGED:
;1485:		return &def->rangedAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 856
ADDP4
ADDP4
RETP4
ADDRGP4 $498
JUMPV
LABELV $509
line 1488
;1486:
;1487:	case MONSTER_STATE_PAIN:
;1488:		return &def->painAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 940
ADDP4
ADDP4
RETP4
ADDRGP4 $498
JUMPV
LABELV $510
line 1491
;1489:
;1490:	case MONSTER_STATE_DEATH:
;1491:		return &def->deathAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 1024
ADDP4
ADDP4
RETP4
ADDRGP4 $498
JUMPV
LABELV $502
line 1494
;1492:
;1493:	default:
;1494:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 716
ADDP4
RETP4
LABELV $498
endproc G_MonsterAnimation 16 0
proc G_MonsterSetAnimation 0 0
line 1502
;1495:	}
;1496:}
;1497:
;1498:static void G_MonsterSetAnimation(
;1499:	gentity_t *monster,
;1500:	int animation,
;1501:	int variant
;1502:) {
line 1503
;1503:	monster->monsterAnimation = animation;
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
ADDRFP4 4
INDIRI4
ASGNI4
line 1504
;1504:	monster->monsterAnimationVariant = variant;
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 1505
;1505:	monster->monsterAnimationStart = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 836
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1506
;1506:}
LABELV $512
endproc G_MonsterSetAnimation 0 0
proc G_MonsterUpdateAnimation 36 12
line 1511
;1507:
;1508:static void G_MonsterUpdateAnimation(
;1509:	gentity_t *monster,
;1510:	monsterDef_t *def
;1511:) {
line 1516
;1512:	animation_t *animation;
;1513:	int elapsed;
;1514:	int frame;
;1515:
;1516:	animation = G_MonsterAnimation(monster, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 G_MonsterAnimation
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 1518
;1517:
;1518:	if (animation->numFrames <= 0 ||
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
LEI4 $517
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
GTI4 $515
LABELV $517
line 1519
;1519:		animation->frameLerp <= 0) {
line 1520
;1520:		return;
ADDRGP4 $514
JUMPV
LABELV $515
line 1523
;1521:	}
;1522:
;1523:	elapsed = level.time - monster->monsterAnimationStart;
ADDRLP4 8
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 836
ADDP4
INDIRI4
SUBI4
ASGNI4
line 1524
;1524:	frame = elapsed / animation->frameLerp;
ADDRLP4 4
ADDRLP4 8
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
DIVI4
ASGNI4
line 1526
;1525:
;1526:	if (frame >= animation->numFrames) {
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
LTI4 $519
line 1527
;1527:		if (animation->loopFrames > 0) {
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
LEI4 $521
line 1528
;1528:			frame =
ADDRLP4 28
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 32
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 4
ADDRLP4 28
INDIRI4
ADDRLP4 32
INDIRI4
SUBI4
ADDRLP4 4
INDIRI4
ADDRLP4 28
INDIRI4
SUBI4
ADDRLP4 32
INDIRI4
MODI4
ADDI4
ASGNI4
line 1533
;1529:				animation->numFrames -
;1530:				animation->loopFrames +
;1531:				(frame - animation->numFrames) %
;1532:				animation->loopFrames;
;1533:		}
ADDRGP4 $522
JUMPV
LABELV $521
line 1534
;1534:		else {
line 1535
;1535:			frame = animation->numFrames - 1;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1537
;1536:
;1537:		if( monster->monsterAnimation ==
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 4
EQI4 $525
ADDRLP4 24
INDIRI4
CNSTI4 3
EQI4 $526
ADDRLP4 24
INDIRI4
CNSTI4 2
NEI4 $523
LABELV $526
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $523
LABELV $525
line 1543
;1538:				MONSTER_STATE_PAIN ||
;1539:			((monster->monsterAnimation ==
;1540:					MONSTER_STATE_RANGED ||
;1541:			  monster->monsterAnimation ==
;1542:					MONSTER_STATE_MELEE) &&
;1543:			 monster->monsterShotsRemaining <= 0) ) {
line 1544
;1544:				G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 1550
;1545:					monster,
;1546:					MONSTER_STATE_IDLE,
;1547:					0
;1548:				);
;1549:
;1550:				animation = &def->idleAnimation;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 716
ADDP4
ASGNP4
line 1551
;1551:				frame = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1552
;1552:			}
LABELV $523
line 1553
;1553:		}
LABELV $522
line 1554
;1554:	}
LABELV $519
line 1556
;1555:
;1556:	monster->s.frame =
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
ADDRLP4 0
INDIRP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDI4
ASGNI4
line 1558
;1557:		animation->firstFrame + frame;
;1558:}
LABELV $514
endproc G_MonsterUpdateAnimation 36 12
proc G_MonsterGroundWalker 88 28
line 1564
;1559:
;1560:static void G_MonsterGroundWalker(
;1561:	gentity_t *monster,
;1562:	monsterDef_t *def,
;1563:	int msec
;1564:) {
line 1569
;1565:	trace_t trace;
;1566:	vec3_t destination;
;1567:	float fallDistance;
;1568:
;1569:	if( def->movementType !=
ADDRFP4 4
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
EQI4 $528
line 1570
;1570:		MONSTER_MOVEMENT_WALKING ) {
line 1571
;1571:		return;
ADDRGP4 $527
JUMPV
LABELV $528
line 1574
;1572:	}
;1573:
;1574:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1579
;1575:		monster->r.currentOrigin,
;1576:		destination
;1577:	);
;1578:
;1579:	destination[2] -= 64;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 1581
;1580:
;1581:	trap_Trace(
ADDRLP4 0
ARGP4
ADDRLP4 72
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 72
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 72
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 72
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 72
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1591
;1582:		&trace,
;1583:		monster->r.currentOrigin,
;1584:		monster->r.mins,
;1585:		monster->r.maxs,
;1586:		destination,
;1587:		monster->s.number,
;1588:		MASK_PLAYERSOLID
;1589:	);
;1590:
;1591:	if( !trace.startsolid &&
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $531
ADDRLP4 0
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $531
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $531
line 1593
;1592:		!trace.allsolid &&
;1593:		trace.fraction < 1.0f ) {
line 1594
;1594:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1599
;1595:			monster,
;1596:			trace.endpos
;1597:		);
;1598:
;1599:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1602
;1600:			trace.entityNum;
;1601:
;1602:		return;
ADDRGP4 $527
JUMPV
LABELV $531
line 1608
;1603:	}
;1604:
;1605:	/*
;1606:	 * No nearby floor: apply simple falling movement.
;1607:	 */
;1608:	fallDistance =
ADDRLP4 68
CNSTF4 1137180672
ADDRFP4 8
INDIRI4
CVIF4 4
MULF4
CNSTF4 1148846080
DIVF4
ASGNF4
line 1611
;1609:		400.0f * msec / 1000.0f;
;1610:
;1611:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1616
;1612:		monster->r.currentOrigin,
;1613:		destination
;1614:	);
;1615:
;1616:	destination[2] -= fallDistance;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
ADDRLP4 68
INDIRF4
SUBF4
ASGNF4
line 1618
;1617:
;1618:	trap_Trace(
ADDRLP4 0
ARGP4
ADDRLP4 80
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 80
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 80
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 80
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 80
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1628
;1619:		&trace,
;1620:		monster->r.currentOrigin,
;1621:		monster->r.mins,
;1622:		monster->r.maxs,
;1623:		destination,
;1624:		monster->s.number,
;1625:		MASK_PLAYERSOLID
;1626:	);
;1627:
;1628:	if( !trace.startsolid &&
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $538
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $538
line 1629
;1629:		!trace.allsolid ) {
line 1630
;1630:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1634
;1631:			monster,
;1632:			trace.endpos
;1633:		);
;1634:	}
LABELV $538
line 1636
;1635:
;1636:	if( trace.fraction < 1.0f ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $542
line 1637
;1637:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1639
;1638:			trace.entityNum;
;1639:	}
ADDRGP4 $543
JUMPV
LABELV $542
line 1640
;1640:	else {
line 1641
;1641:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 1643
;1642:			ENTITYNUM_NONE;
;1643:	}
LABELV $543
line 1644
;1644:}
LABELV $527
endproc G_MonsterGroundWalker 88 28
proc G_MonsterFaceTarget 52 8
line 1649
;1645:
;1646:static void G_MonsterFaceTarget(
;1647:	gentity_t *monster,
;1648:	gentity_t *target
;1649:) {
line 1653
;1650:	vec3_t direction;
;1651:	vec3_t angles;
;1652:
;1653:	if( !monster || !target ) {
ADDRLP4 24
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
EQU4 $549
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
NEU4 $547
LABELV $549
line 1654
;1654:		return;
ADDRGP4 $546
JUMPV
LABELV $547
line 1657
;1655:	}
;1656:
;1657:	VectorSubtract(
ADDRLP4 28
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 32
CNSTI4 488
ASGNI4
ADDRLP4 36
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 28
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
ADDRLP4 36
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 40
CNSTI4 492
ASGNI4
ADDRLP4 12+4
ADDRLP4 28
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRF4
ADDRLP4 36
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 44
CNSTI4 496
ASGNI4
ADDRLP4 12+8
ADDRFP4 4
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1663
;1658:		target->r.currentOrigin,
;1659:		monster->r.currentOrigin,
;1660:		direction
;1661:	);
;1662:
;1663:	if( VectorNormalize(direction) <= 0.0f ) {
ADDRLP4 12
ARGP4
ADDRLP4 48
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 48
INDIRF4
CNSTF4 0
GTF4 $552
line 1664
;1664:		return;
ADDRGP4 $546
JUMPV
LABELV $552
line 1667
;1665:	}
;1666:
;1667:	vectoangles(direction, angles);
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1668
;1668:	angles[PITCH] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1669
;1669:	angles[ROLL] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1671
;1670:
;1671:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1672
;1672:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1673
;1673:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1674
;1674:}
LABELV $546
endproc G_MonsterFaceTarget 52 8
proc G_MonsterMove 480 28
line 1682
;1675:
;1676:
;1677:static void G_MonsterMove(
;1678:	gentity_t *monster,
;1679:	gentity_t *target,
;1680:	monsterDef_t *def,
;1681:	int msec
;1682:) {
line 1701
;1683:	trace_t trace;
;1684:	trace_t slideTrace;
;1685:	vec3_t targetOrigin;
;1686:	vec3_t direction;
;1687:	vec3_t right;
;1688:	vec3_t wishDirection;
;1689:	vec3_t velocity;
;1690:	vec3_t move;
;1691:	vec3_t destination;
;1692:	vec3_t slideMove;
;1693:	vec3_t slideDestination;
;1694:	vec3_t angles;
;1695:	float phase;
;1696:	float drift;
;1697:	float distance;
;1698:	float dot;
;1699:	qboolean shouldMove;
;1700:
;1701:	VectorCopy(
ADDRLP4 128
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1706
;1702:		target->r.currentOrigin,
;1703:		targetOrigin
;1704:	);
;1705:
;1706:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $556
line 1707
;1707:		MONSTER_MOVEMENT_WALKING ) {
line 1711
;1708:		/*
;1709:		 * Walking monsters chase only horizontally.
;1710:		 */
;1711:		targetOrigin[2] =
ADDRLP4 128+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ASGNF4
line 1713
;1712:			monster->r.currentOrigin[2];
;1713:	}
ADDRGP4 $557
JUMPV
LABELV $556
line 1714
;1714:	else {
line 1715
;1715:		targetOrigin[2] += 16;
ADDRLP4 128+8
ADDRLP4 128+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 1716
;1716:	}
LABELV $557
line 1718
;1717:
;1718:	VectorSubtract(
ADDRLP4 252
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 80
ADDRLP4 128
INDIRF4
ADDRLP4 252
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 80+4
ADDRLP4 128+4
INDIRF4
ADDRLP4 252
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 80+8
ADDRLP4 128+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1724
;1719:		targetOrigin,
;1720:		monster->r.currentOrigin,
;1721:		direction
;1722:	);
;1723:
;1724:	distance = VectorNormalize(direction);
ADDRLP4 80
ARGP4
ADDRLP4 256
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 168
ADDRLP4 256
INDIRF4
ASGNF4
line 1726
;1725:
;1726:	if (distance <= 0.0f) {
ADDRLP4 168
INDIRF4
CNSTF4 0
GTF4 $564
line 1727
;1727:		return;
ADDRGP4 $555
JUMPV
LABELV $564
line 1733
;1728:	}
;1729:	/*
;1730:	 * A nearby target behind a wall is not yet a valid
;1731:	 * firing position, so continue moving toward it.
;1732:	 */
;1733:	shouldMove =
ADDRLP4 168
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 648
ADDP4
INDIRF4
GTF4 $569
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 264
ADDRGP4 G_MonsterCanSeeTarget
CALLI4
ASGNI4
ADDRLP4 264
INDIRI4
CNSTI4 0
NEI4 $567
LABELV $569
ADDRLP4 260
CNSTI4 1
ASGNI4
ADDRGP4 $568
JUMPV
LABELV $567
ADDRLP4 260
CNSTI4 0
ASGNI4
LABELV $568
ADDRLP4 172
ADDRLP4 260
INDIRI4
ASGNI4
line 1744
;1734:		distance > def->attackRange ||
;1735:		!G_MonsterCanSeeTarget(
;1736:			monster,
;1737:			target
;1738:		);
;1739:	
;1740:	/*
;1741:	 * Switch between standing and movement animations
;1742:	 * without interrupting attacks, pain or death.
;1743:	 */
;1744:	if( monster->monsterAnimation ==
ADDRLP4 268
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
ASGNI4
ADDRLP4 268
INDIRI4
CNSTI4 0
EQI4 $572
ADDRLP4 268
INDIRI4
CNSTI4 1
NEI4 $570
LABELV $572
line 1747
;1745:			MONSTER_STATE_IDLE ||
;1746:		monster->monsterAnimation ==
;1747:			MONSTER_STATE_MOVE ) {
line 1748
;1748:		if( shouldMove ||
ADDRLP4 172
INDIRI4
CNSTI4 0
NEI4 $575
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $573
LABELV $575
line 1750
;1749:			def->movePattern ==
;1750:				MONSTER_PATTERN_DRIFT ) {
line 1751
;1751:			if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
EQI4 $574
line 1752
;1752:				MONSTER_STATE_MOVE ) {
line 1753
;1753:				G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 1758
;1754:					monster,
;1755:					MONSTER_STATE_MOVE,
;1756:					0
;1757:				);
;1758:			}
line 1759
;1759:		}
ADDRGP4 $574
JUMPV
LABELV $573
line 1760
;1760:		else if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 0
EQI4 $578
line 1761
;1761:			MONSTER_STATE_IDLE ) {
line 1762
;1762:			G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 272
CNSTI4 0
ASGNI4
ADDRLP4 272
INDIRI4
ARGI4
ADDRLP4 272
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 1767
;1763:				monster,
;1764:				MONSTER_STATE_IDLE,
;1765:				0
;1766:			);
;1767:		}
LABELV $578
LABELV $574
line 1768
;1768:	}
LABELV $570
line 1770
;1769:
;1770:	VectorSet(
ADDRLP4 104
ADDRLP4 80+4
INDIRF4
NEGF4
ASGNF4
ADDRLP4 104+4
ADDRLP4 80
INDIRF4
ASGNF4
ADDRLP4 104+8
CNSTF4 0
ASGNF4
line 1777
;1771:		right,
;1772:		-direction[1],
;1773:		direction[0],
;1774:		0
;1775:	);
;1776:
;1777:	if (VectorNormalize(right) <= 0.0f) {
ADDRLP4 104
ARGP4
ADDRLP4 272
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 272
INDIRF4
CNSTF4 0
GTF4 $583
line 1778
;1778:		VectorSet(right, 1, 0, 0);
ADDRLP4 104
CNSTF4 1065353216
ASGNF4
ADDRLP4 104+4
CNSTF4 0
ASGNF4
ADDRLP4 104+8
CNSTF4 0
ASGNF4
line 1779
;1779:	}
LABELV $583
line 1781
;1780:
;1781:	drift = 0.0f;
ADDRLP4 164
CNSTF4 0
ASGNF4
line 1783
;1782:
;1783:	if (def->movePattern == MONSTER_PATTERN_DRIFT &&
ADDRLP4 276
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 276
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $587
ADDRLP4 276
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
CNSTI4 0
LEI4 $587
line 1784
;1784:		def->driftPeriod > 0) {
line 1785
;1785:		phase =
ADDRLP4 280
ADDRFP4 8
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
ASGNI4
ADDRLP4 176
ADDRGP4 level+32
INDIRI4
ADDRLP4 280
INDIRI4
MODI4
CVIF4 4
ADDRLP4 280
INDIRI4
CVIF4 4
DIVF4
ASGNF4
line 1789
;1786:			(level.time % def->driftPeriod) /
;1787:			(float)def->driftPeriod;
;1788:
;1789:		phase *= 6.2831853f;
ADDRLP4 176
CNSTF4 1086918619
ADDRLP4 176
INDIRF4
MULF4
ASGNF4
line 1790
;1790:		phase += monster->monsterDriftPhase;
ADDRLP4 176
ADDRLP4 176
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 840
ADDP4
INDIRF4
ADDF4
ASGNF4
line 1792
;1791:
;1792:		drift =
ADDRLP4 176
INDIRF4
ARGF4
ADDRLP4 284
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 164
ADDRLP4 284
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 632
ADDP4
INDIRF4
MULF4
ASGNF4
line 1795
;1793:			sin(phase) *
;1794:			def->driftAmount;
;1795:	}
LABELV $587
line 1797
;1796:
;1797:	VectorClear(velocity);
ADDRLP4 280
CNSTF4 0
ASGNF4
ADDRLP4 68+8
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 68+4
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 68
ADDRLP4 280
INDIRF4
ASGNF4
line 1799
;1798:
;1799:	if (shouldMove) {
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $592
line 1800
;1800:		VectorCopy(direction, wishDirection);
ADDRLP4 152
ADDRLP4 80
INDIRB
ASGNB 12
line 1802
;1801:
;1802:		if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $594
line 1803
;1803:			MONSTER_PATTERN_DRIFT) {
line 1804
;1804:			VectorMA(
ADDRLP4 152
ADDRLP4 152
INDIRF4
ADDRLP4 104
INDIRF4
ADDRLP4 164
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 152+4
ADDRLP4 152+4
INDIRF4
ADDRLP4 104+4
INDIRF4
ADDRLP4 164
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 152+8
ADDRLP4 152+8
INDIRF4
ADDRLP4 104+8
INDIRF4
ADDRLP4 164
INDIRF4
MULF4
ADDF4
ASGNF4
line 1810
;1805:				wishDirection,
;1806:				drift,
;1807:				right,
;1808:				wishDirection
;1809:			);
;1810:		}
LABELV $594
line 1812
;1811:
;1812:		if (VectorNormalize(wishDirection) <= 0.0f) {
ADDRLP4 152
ARGP4
ADDRLP4 284
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 284
INDIRF4
CNSTF4 0
GTF4 $602
line 1813
;1813:			return;
ADDRGP4 $555
JUMPV
LABELV $602
line 1816
;1814:		}
;1815:
;1816:		VectorScale(
ADDRLP4 288
ADDRFP4 8
INDIRP4
CNSTI4 600
ADDP4
ASGNP4
ADDRLP4 68
ADDRLP4 152
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 68+4
ADDRLP4 152+4
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 68+8
ADDRLP4 152+8
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 600
ADDP4
INDIRF4
MULF4
ASGNF4
line 1821
;1817:			wishDirection,
;1818:			def->speed,
;1819:			velocity
;1820:		);
;1821:	}
ADDRGP4 $593
JUMPV
LABELV $592
line 1822
;1822:	else if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $555
line 1823
;1823:		MONSTER_PATTERN_DRIFT) {
line 1829
;1824:		/*
;1825:		 * Inside attack range, smoothly strafe.
;1826:		 * Do not normalize this vector: driftAmount must
;1827:		 * affect the actual lateral speed.
;1828:		 */
;1829:		VectorScale(
ADDRLP4 288
ADDRFP4 8
INDIRP4
CNSTI4 600
ADDP4
ASGNP4
ADDRLP4 68
ADDRLP4 104
INDIRF4
ADDRLP4 164
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
MULF4
MULF4
ASGNF4
ADDRLP4 68+4
ADDRLP4 104+4
INDIRF4
ADDRLP4 164
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
MULF4
MULF4
ASGNF4
ADDRLP4 68+8
ADDRLP4 104+8
INDIRF4
ADDRLP4 164
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 600
ADDP4
INDIRF4
MULF4
MULF4
ASGNF4
line 1834
;1830:			right,
;1831:			drift * def->speed,
;1832:			velocity
;1833:		);
;1834:	}
line 1835
;1835:	else {
line 1836
;1836:		return;
LABELV $609
LABELV $593
line 1839
;1837:	}
;1838:
;1839:	VectorScale(
ADDRLP4 284
ADDRFP4 12
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
ADDRLP4 56
ADDRLP4 68
INDIRF4
ADDRLP4 284
INDIRF4
MULF4
ASGNF4
ADDRLP4 56+4
ADDRLP4 68+4
INDIRF4
ADDRLP4 284
INDIRF4
MULF4
ASGNF4
ADDRLP4 56+8
ADDRLP4 68+8
INDIRF4
ADDRFP4 12
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
MULF4
ASGNF4
line 1845
;1840:		velocity,
;1841:		msec / 1000.0f,
;1842:		move
;1843:	);
;1844:
;1845:	if (VectorLengthSquared(move) <= 0.0001f) {
ADDRLP4 56
ARGP4
ADDRLP4 288
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 288
INDIRF4
CNSTF4 953267991
GTF4 $618
line 1846
;1846:		return;
ADDRGP4 $555
JUMPV
LABELV $618
line 1849
;1847:	}
;1848:
;1849:VectorAdd(
ADDRLP4 292
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 292
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 56
INDIRF4
ADDF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 292
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
ADDRLP4 56+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 140+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDRLP4 56+8
INDIRF4
ADDF4
ASGNF4
line 1855
;1850:		monster->r.currentOrigin,
;1851:		move,
;1852:		destination
;1853:	);
;1854:
;1855:	trap_Trace(
ADDRLP4 0
ARGP4
ADDRLP4 296
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 296
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 296
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 296
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 140
ARGP4
ADDRLP4 296
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1870
;1856:		&trace,
;1857:		monster->r.currentOrigin,
;1858:		monster->r.mins,
;1859:		monster->r.maxs,
;1860:		destination,
;1861:		monster->s.number,
;1862:		MASK_PLAYERSOLID
;1863:	);
;1864:
;1865:	/*
;1866:	 * Step-up: if horizontal move was blocked,
;1867:	 * try to climb a stair. Q3 player step size
;1868:	 * is 18 units; use the same for monsters.
;1869:	 */
;1870:	if( trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $624
ADDRLP4 300
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $624
ADDRLP4 0
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $624
line 1872
;1871:		!trace.startsolid &&
;1872:		!trace.allsolid ) {
line 1878
;1873:		vec3_t stepUp;
;1874:		vec3_t stepDest;
;1875:		vec3_t downDest;
;1876:		trace_t stepTrace;
;1877:		trace_t downTrace;
;1878:		const float stepHeight = 18.0f;
ADDRLP4 372
CNSTF4 1099956224
ASGNF4
line 1880
;1879:
;1880:		VectorCopy(
ADDRLP4 360
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1885
;1881:			monster->r.currentOrigin,
;1882:			stepUp
;1883:		);
;1884:
;1885:		stepUp[2] += stepHeight;
ADDRLP4 360+8
ADDRLP4 360+8
INDIRF4
ADDRLP4 372
INDIRF4
ADDF4
ASGNF4
line 1887
;1886:
;1887:		trap_Trace(
ADDRLP4 304
ARGP4
ADDRLP4 456
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 456
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 456
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 456
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 360
ARGP4
ADDRLP4 456
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1897
;1888:			&stepTrace,
;1889:			monster->r.currentOrigin,
;1890:			monster->r.mins,
;1891:			monster->r.maxs,
;1892:			stepUp,
;1893:			monster->s.number,
;1894:			MASK_PLAYERSOLID
;1895:		);
;1896:
;1897:		if( !stepTrace.startsolid &&
ADDRLP4 460
CNSTI4 0
ASGNI4
ADDRLP4 304+4
INDIRI4
ADDRLP4 460
INDIRI4
NEI4 $629
ADDRLP4 304
INDIRI4
ADDRLP4 460
INDIRI4
NEI4 $629
ADDRLP4 304+8
INDIRF4
CNSTF4 1063675494
LEF4 $629
line 1899
;1898:			!stepTrace.allsolid &&
;1899:			stepTrace.fraction > 0.9f ) {
line 1901
;1900:
;1901:			VectorCopy(
ADDRLP4 376
ADDRLP4 140
INDIRB
ASGNB 12
line 1906
;1902:				destination,
;1903:				stepDest
;1904:			);
;1905:
;1906:			stepDest[2] = stepUp[2];
ADDRLP4 376+8
ADDRLP4 360+8
INDIRF4
ASGNF4
line 1908
;1907:
;1908:			trap_Trace(
ADDRLP4 304
ARGP4
ADDRLP4 360
ARGP4
ADDRLP4 464
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 464
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 464
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 376
ARGP4
ADDRLP4 464
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1918
;1909:				&stepTrace,
;1910:				stepUp,
;1911:				monster->r.mins,
;1912:				monster->r.maxs,
;1913:				stepDest,
;1914:				monster->s.number,
;1915:				MASK_PLAYERSOLID
;1916:			);
;1917:
;1918:			if( !stepTrace.startsolid &&
ADDRLP4 468
CNSTI4 0
ASGNI4
ADDRLP4 304+4
INDIRI4
ADDRLP4 468
INDIRI4
NEI4 $635
ADDRLP4 304
INDIRI4
ADDRLP4 468
INDIRI4
NEI4 $635
line 1919
;1919:				!stepTrace.allsolid ) {
line 1921
;1920:
;1921:				VectorCopy(
ADDRLP4 444
ADDRLP4 304+12
INDIRB
ASGNB 12
line 1926
;1922:					stepTrace.endpos,
;1923:					downDest
;1924:				);
;1925:
;1926:				downDest[2] -= stepHeight;
ADDRLP4 444+8
ADDRLP4 444+8
INDIRF4
ADDRLP4 372
INDIRF4
SUBF4
ASGNF4
line 1928
;1927:
;1928:				trap_Trace(
ADDRLP4 388
ARGP4
ADDRLP4 304+12
ARGP4
ADDRLP4 472
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 472
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 472
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 444
ARGP4
ADDRLP4 472
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1938
;1929:					&downTrace,
;1930:					stepTrace.endpos,
;1931:					monster->r.mins,
;1932:					monster->r.maxs,
;1933:					downDest,
;1934:					monster->s.number,
;1935:					MASK_PLAYERSOLID
;1936:				);
;1937:
;1938:				if( !downTrace.startsolid &&
ADDRLP4 476
CNSTI4 0
ASGNI4
ADDRLP4 388+4
INDIRI4
ADDRLP4 476
INDIRI4
NEI4 $641
ADDRLP4 388
INDIRI4
ADDRLP4 476
INDIRI4
NEI4 $641
ADDRLP4 388+8
INDIRF4
CNSTF4 1065353216
GEF4 $641
line 1940
;1939:					!downTrace.allsolid &&
;1940:					downTrace.fraction < 1.0f ) {
line 1942
;1941:
;1942:					G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 388+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1947
;1943:						monster,
;1944:						downTrace.endpos
;1945:					);
;1946:
;1947:					monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 388+52
INDIRI4
ASGNI4
line 1950
;1948:						downTrace.entityNum;
;1949:
;1950:					vectoangles(
ADDRLP4 80
ARGP4
ADDRLP4 116
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1955
;1951:						direction,
;1952:						angles
;1953:					);
;1954:
;1955:					angles[PITCH] = 0;
ADDRLP4 116
CNSTF4 0
ASGNF4
line 1956
;1956:					angles[ROLL] = 0;
ADDRLP4 116+8
CNSTF4 0
ASGNF4
line 1958
;1957:
;1958:					VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1963
;1959:						angles,
;1960:						monster->s.angles
;1961:					);
;1962:
;1963:					VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1968
;1964:						angles,
;1965:						monster->s.apos.trBase
;1966:					);
;1967:
;1968:					VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1973
;1969:						angles,
;1970:						monster->r.currentAngles
;1971:					);
;1972:
;1973:					trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1975
;1974:
;1975:					return;
ADDRGP4 $555
JUMPV
LABELV $641
line 1977
;1976:				}
;1977:			}
LABELV $635
line 1978
;1978:		}
LABELV $629
line 1979
;1979:	}
LABELV $624
line 1981
;1980:
;1981:	G_MonsterSetOrigin(monster, trace.endpos);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1983
;1982:
;1983:	if (trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $649
ADDRLP4 304
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 304
INDIRI4
NEI4 $649
ADDRLP4 0
INDIRI4
ADDRLP4 304
INDIRI4
NEI4 $649
line 1985
;1984:		!trace.startsolid &&
;1985:		!trace.allsolid) {
line 1987
;1986:		/* slide logic ... (без изменений) */
;1987:	}
LABELV $649
line 1989
;1988:
;1989:	if (trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $653
ADDRLP4 308
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 308
INDIRI4
NEI4 $653
ADDRLP4 0
INDIRI4
ADDRLP4 308
INDIRI4
NEI4 $653
line 1991
;1990:		!trace.startsolid &&
;1991:		!trace.allsolid) {
line 1995
;1992:		/*
;1993:		 * Slide only for the uncompleted part of movement.
;1994:		 */
;1995:		VectorScale(
ADDRLP4 312
CNSTF4 1065353216
ASGNF4
ADDRLP4 92
ADDRLP4 56
INDIRF4
ADDRLP4 312
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
MULF4
ASGNF4
ADDRLP4 92+4
ADDRLP4 56+4
INDIRF4
ADDRLP4 312
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
MULF4
ASGNF4
ADDRLP4 92+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1065353216
ADDRLP4 0+8
INDIRF4
SUBF4
MULF4
ASGNF4
line 2001
;1996:			move,
;1997:			1.0f - trace.fraction,
;1998:			slideMove
;1999:		);
;2000:
;2001:		dot = DotProduct(
ADDRLP4 180
ADDRLP4 92
INDIRF4
ADDRLP4 0+24
INDIRF4
MULF4
ADDRLP4 92+4
INDIRF4
ADDRLP4 0+24+4
INDIRF4
MULF4
ADDF4
ADDRLP4 92+8
INDIRF4
ADDRLP4 0+24+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2006
;2002:			slideMove,
;2003:			trace.plane.normal
;2004:		);
;2005:
;2006:		VectorMA(
ADDRLP4 316
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 92
ADDRLP4 92
INDIRF4
ADDRLP4 0+24
INDIRF4
ADDRLP4 316
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 92+4
ADDRLP4 92+4
INDIRF4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 316
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 92+8
ADDRLP4 92+8
INDIRF4
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 180
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 2013
;2007:			slideMove,
;2008:			-dot,
;2009:			trace.plane.normal,
;2010:			slideMove
;2011:		);
;2012:
;2013:		if (VectorLengthSquared(slideMove) > 0.0001f) {
ADDRLP4 92
ARGP4
ADDRLP4 320
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 320
INDIRF4
CNSTF4 953267991
LEF4 $680
line 2014
;2014:			VectorAdd(
ADDRLP4 324
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 184
ADDRLP4 324
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 92
INDIRF4
ADDF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 324
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
ADDRLP4 92+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 184+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDRLP4 92+8
INDIRF4
ADDF4
ASGNF4
line 2020
;2015:				monster->r.currentOrigin,
;2016:				slideMove,
;2017:				slideDestination
;2018:			);
;2019:
;2020:			trap_Trace(
ADDRLP4 196
ARGP4
ADDRLP4 328
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 328
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 328
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 328
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 184
ARGP4
ADDRLP4 328
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 2030
;2021:				&slideTrace,
;2022:				monster->r.currentOrigin,
;2023:				monster->r.mins,
;2024:				monster->r.maxs,
;2025:				slideDestination,
;2026:				monster->s.number,
;2027:				MASK_PLAYERSOLID
;2028:			);
;2029:
;2030:			G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 2034
;2031:				monster,
;2032:				slideTrace.endpos
;2033:			);
;2034:		}
LABELV $680
line 2035
;2035:	}
LABELV $653
line 2037
;2036:
;2037:	vectoangles(direction, angles);
ADDRLP4 80
ARGP4
ADDRLP4 116
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2038
;2038:	angles[PITCH] = 0;
ADDRLP4 116
CNSTF4 0
ASGNF4
line 2039
;2039:	angles[ROLL] = 0;
ADDRLP4 116+8
CNSTF4 0
ASGNF4
line 2041
;2040:
;2041:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 2042
;2042:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 2043
;2043:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 2045
;2044:
;2045:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2046
;2046:}
LABELV $555
endproc G_MonsterMove 480 28
proc G_MonsterValidTarget 8 0
line 2048
;2047:
;2048:static qboolean G_MonsterValidTarget(gentity_t *target) {
line 2049
;2049:	if (!target || !target->client) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTU4 0
ASGNU4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
EQU4 $691
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $689
LABELV $691
line 2050
;2050:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $688
JUMPV
LABELV $689
line 2053
;2051:	}
;2052:
;2053:	if (target->client->pers.connected != CON_CONNECTED) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $692
line 2054
;2054:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $688
JUMPV
LABELV $692
line 2057
;2055:	}
;2056:
;2057:	if (target->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $694
line 2058
;2058:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $688
JUMPV
LABELV $694
line 2061
;2059:	}
;2060:
;2061:	if (target->health <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $696
line 2062
;2062:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $688
JUMPV
LABELV $696
line 2065
;2063:	}
;2064:
;2065:	return qtrue;
CNSTI4 1
RETI4
LABELV $688
endproc G_MonsterValidTarget 8 0
proc G_MonsterHitscan 184 32
line 2085
;2066:}
;2067:
;2068:/*
;2069: * Hitscan-based monster attack with tracer.
;2070: * weaponType:
;2071: *   "hitscan"  - machinegun-like, 1 pellet, small spread
;2072: *   "rifle"    - accurate rifle, 1 pellet, no spread
;2073: *   "shotgun"  - shotgun, multiple pellets, wide spread
;2074: *
;2075: * damage is per pellet (for shotgun, total = damage * pellets).
;2076: */
;2077:static void G_MonsterHitscan(
;2078:	gentity_t *monster,
;2079:	gentity_t *target,
;2080:	monsterDef_t *def,
;2081:	const char *weaponType,
;2082:	int damage,
;2083:	int splashDamage,
;2084:	int splashRadius
;2085:) {
line 2095
;2086:	vec3_t start;
;2087:	vec3_t forward;
;2088:	vec3_t right;
;2089:	vec3_t up;
;2090:	int pellets;
;2091:	float spread;
;2092:	int mod;
;2093:	int i;
;2094:
;2095:	VectorCopy( monster->r.currentOrigin, start );
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2097
;2096:
;2097:	if( def->movementType == MONSTER_MOVEMENT_WALKING ) {
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $699
line 2098
;2098:		start[2] += 36;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1108344832
ADDF4
ASGNF4
line 2099
;2099:	}
ADDRGP4 $700
JUMPV
LABELV $699
line 2100
;2100:	else {
line 2101
;2101:		start[2] += 8;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2102
;2102:	}
LABELV $700
line 2104
;2103:
;2104:	VectorSubtract(
ADDRLP4 64
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 32
ADDRLP4 64
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
SUBF4
ASGNF4
ADDRLP4 32+4
ADDRLP4 64
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
ADDRLP4 0+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 32+8
ADDRFP4 4
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
ASGNF4
line 2110
;2105:		target->r.currentOrigin,
;2106:		start,
;2107:		forward
;2108:	);
;2109:
;2110:	VectorNormalize( forward );
ADDRLP4 32
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2112
;2111:
;2112:	PerpendicularVector( right, forward );
ADDRLP4 20
ARGP4
ADDRLP4 32
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 2113
;2113:	CrossProduct( forward, right, up );
ADDRLP4 32
ARGP4
ADDRLP4 20
ARGP4
ADDRLP4 44
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 2115
;2114:
;2115:	if( !Q_stricmp( weaponType, "shotgun" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $709
ARGP4
ADDRLP4 68
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 68
INDIRI4
CNSTI4 0
NEI4 $707
line 2116
;2116:		pellets = 11;
ADDRLP4 56
CNSTI4 11
ASGNI4
line 2117
;2117:		spread = 0.15f;
ADDRLP4 12
CNSTF4 1041865114
ASGNF4
line 2118
;2118:		mod = MOD_SHOTGUN;
ADDRLP4 60
CNSTI4 1
ASGNI4
line 2119
;2119:	}
ADDRGP4 $708
JUMPV
LABELV $707
line 2120
;2120:	else if( !Q_stricmp( weaponType, "rifle" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $712
ARGP4
ADDRLP4 72
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
NEI4 $710
line 2121
;2121:		pellets = 1;
ADDRLP4 56
CNSTI4 1
ASGNI4
line 2122
;2122:		spread = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 2123
;2123:		mod = MOD_MACHINEGUN;
ADDRLP4 60
CNSTI4 3
ASGNI4
line 2124
;2124:	}
ADDRGP4 $711
JUMPV
LABELV $710
line 2125
;2125:	else if( !Q_stricmp( weaponType, "lightning" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $715
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
NEI4 $713
line 2126
;2126:		pellets = 1;
ADDRLP4 56
CNSTI4 1
ASGNI4
line 2127
;2127:		spread = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 2128
;2128:		mod = MOD_LIGHTNING;
ADDRLP4 60
CNSTI4 11
ASGNI4
line 2129
;2129:	}
ADDRGP4 $714
JUMPV
LABELV $713
line 2130
;2130:	else {
line 2132
;2131:		/* "hitscan" / machinegun */
;2132:		pellets = 1;
ADDRLP4 56
CNSTI4 1
ASGNI4
line 2133
;2133:		spread = 0.02f;
ADDRLP4 12
CNSTF4 1017370378
ASGNF4
line 2134
;2134:		mod = MOD_MACHINEGUN;
ADDRLP4 60
CNSTI4 3
ASGNI4
line 2135
;2135:	}
LABELV $714
LABELV $711
LABELV $708
line 2137
;2136:
;2137:	for( i = 0; i < pellets; i++ ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $719
JUMPV
LABELV $716
line 2142
;2138:		vec3_t dir;
;2139:		vec3_t end;
;2140:		trace_t trace;
;2141:
;2142:		VectorCopy( forward, dir );
ADDRLP4 80
ADDRLP4 32
INDIRB
ASGNB 12
line 2144
;2143:
;2144:		if( spread > 0.0f ) {
ADDRLP4 12
INDIRF4
CNSTF4 0
LEF4 $720
line 2145
;2145:			VectorMA( dir, crandom() * spread, right, dir );
ADDRLP4 160
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 80
ADDRLP4 80
INDIRF4
ADDRLP4 20
INDIRF4
CNSTF4 1073741824
ADDRLP4 160
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 164
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 80+4
ADDRLP4 80+4
INDIRF4
ADDRLP4 20+4
INDIRF4
CNSTF4 1073741824
ADDRLP4 164
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 168
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 80+8
ADDRLP4 80+8
INDIRF4
ADDRLP4 20+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 168
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 2146
;2146:			VectorMA( dir, crandom() * spread, up, dir );
ADDRLP4 172
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 80
ADDRLP4 80
INDIRF4
ADDRLP4 44
INDIRF4
CNSTF4 1073741824
ADDRLP4 172
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 176
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 80+4
ADDRLP4 80+4
INDIRF4
ADDRLP4 44+4
INDIRF4
CNSTF4 1073741824
ADDRLP4 176
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 180
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 80+8
ADDRLP4 80+8
INDIRF4
ADDRLP4 44+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 180
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 2147
;2147:			VectorNormalize( dir );
ADDRLP4 80
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2148
;2148:		}
LABELV $720
line 2151
;2149:
;2150:		//VectorMA( start, 8192.0f, dir, end );
;2151:		if( !Q_stricmp( weaponType, "lightning" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $715
ARGP4
ADDRLP4 160
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 160
INDIRI4
CNSTI4 0
NEI4 $734
line 2152
;2152:			VectorMA( start, 768.0f, dir, end );
ADDRLP4 164
CNSTF4 1145044992
ASGNF4
ADDRLP4 148
ADDRLP4 0
INDIRF4
ADDRLP4 164
INDIRF4
ADDRLP4 80
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 148+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 164
INDIRF4
ADDRLP4 80+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 148+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1145044992
ADDRLP4 80+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2153
;2153:		}
ADDRGP4 $735
JUMPV
LABELV $734
line 2154
;2154:		else {
line 2155
;2155:			VectorMA( start, 8192.0f, dir, end );
ADDRLP4 164
CNSTF4 1174405120
ASGNF4
ADDRLP4 148
ADDRLP4 0
INDIRF4
ADDRLP4 164
INDIRF4
ADDRLP4 80
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 148+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 164
INDIRF4
ADDRLP4 80+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 148+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1174405120
ADDRLP4 80+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2156
;2156:		}
LABELV $735
line 2158
;2157:
;2158:		trap_Trace(
ADDRLP4 92
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 164
CNSTP4 0
ASGNP4
ADDRLP4 164
INDIRP4
ARGP4
ADDRLP4 164
INDIRP4
ARGP4
ADDRLP4 148
ARGP4
ADDRFP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 2169
;2159:			&trace,
;2160:			start,
;2161:			NULL,
;2162:			NULL,
;2163:			end,
;2164:			monster->s.number,
;2165:			MASK_SHOT
;2166:		);
;2167:
;2168:		/* Damage only if we actually hit a player. */
;2169:		if( trace.fraction < 1.0f &&
ADDRLP4 92+8
INDIRF4
CNSTF4 1065353216
GEF4 $748
ADDRLP4 92+52
INDIRI4
CNSTI4 64
GEI4 $748
line 2170
;2170:			trace.entityNum < MAX_CLIENTS ) {
line 2171
;2171:			gentity_t *hit = &g_entities[trace.entityNum];
ADDRLP4 168
CNSTI4 884
ADDRLP4 92+52
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 2173
;2172:
;2173:			if( hit->client && hit->health > 0 ) {
ADDRLP4 168
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $753
ADDRLP4 168
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
LEI4 $753
line 2174
;2174:				G_Damage(
ADDRLP4 168
INDIRP4
ARGP4
ADDRLP4 176
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 176
INDIRP4
ARGP4
ADDRLP4 176
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 92+12
ARGP4
ADDRFP4 16
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 60
INDIRI4
ARGI4
ADDRGP4 G_Damage
CALLV
pop
line 2184
;2175:					hit,
;2176:					monster,
;2177:					monster,
;2178:					NULL,
;2179:					trace.endpos,
;2180:					damage,
;2181:					0,
;2182:					mod
;2183:				);
;2184:			}
LABELV $753
line 2185
;2185:		}
LABELV $748
line 2188
;2186:
;2187:		/* Splash (usually 0 for hitscan; keep for flexibility). */
;2188:		if( splashDamage > 0 && splashRadius > 0 ) {
ADDRLP4 168
CNSTI4 0
ASGNI4
ADDRFP4 20
INDIRI4
ADDRLP4 168
INDIRI4
LEI4 $756
ADDRFP4 24
INDIRI4
ADDRLP4 168
INDIRI4
LEI4 $756
line 2189
;2189:			G_RadiusDamage(
ADDRLP4 92+12
ARGP4
ADDRLP4 172
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 172
INDIRP4
ARGP4
ADDRFP4 20
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 24
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 172
INDIRP4
ARGP4
ADDRLP4 60
INDIRI4
ARGI4
ADDRGP4 G_RadiusDamage
CALLI4
pop
line 2197
;2190:				trace.endpos,
;2191:				monster,
;2192:				splashDamage,
;2193:				splashRadius,
;2194:				monster,
;2195:				mod
;2196:			);
;2197:		}
LABELV $756
line 2198
;2198:	}
LABELV $717
line 2137
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $719
ADDRLP4 16
INDIRI4
ADDRLP4 56
INDIRI4
LTI4 $716
line 2201
;2199:
;2200:	/* Mark progress for wave relocation. */
;2201:	if( monster->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $759
line 2202
;2202:		monster->monsterProgressTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2204
;2203:
;2204:		VectorCopy(
ADDRLP4 80
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 80
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 80
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2208
;2205:			monster->r.currentOrigin,
;2206:			monster->monsterProgressOrigin
;2207:		);
;2208:	}
LABELV $759
line 2209
;2209:}
LABELV $698
endproc G_MonsterHitscan 184 32
proc G_MonsterFireProjectile 92 28
line 2219
;2210:
;2211:static void G_MonsterFireProjectile(
;2212:	gentity_t *monster,
;2213:	gentity_t *target,
;2214:	monsterDef_t *def,
;2215:	const char *projectile,
;2216:	int damage,
;2217:	int splashDamage,
;2218:	int splashRadius
;2219:) {
line 2229
;2220:	gentity_t *bolt;
;2221:	vec3_t start;
;2222:	vec3_t targetOrigin;
;2223:	vec3_t direction;
;2224:
;2225:	/*
;2226:	 * Hitscan branch: instant hit with tracer.
;2227:	 * projectile can be "hitscan", "rifle" or "shotgun".
;2228:	 */
;2229:	if( projectile &&
ADDRLP4 40
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $763
ADDRLP4 40
INDIRP4
ARGP4
ADDRGP4 $765
ARGP4
ADDRLP4 44
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $768
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $712
ARGP4
ADDRLP4 48
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
EQI4 $768
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $709
ARGP4
ADDRLP4 52
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 0
EQI4 $768
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $715
ARGP4
ADDRLP4 56
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 0
NEI4 $763
LABELV $768
line 2233
;2230:		( !Q_stricmp(projectile, "hitscan") ||
;2231:		  !Q_stricmp(projectile, "rifle") ||
;2232:		  !Q_stricmp(projectile, "shotgun") ||
;2233:		  !Q_stricmp(projectile, "lightning") ) ) {
line 2234
;2234:		G_MonsterHitscan(
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
ADDRFP4 16
INDIRI4
ARGI4
ADDRFP4 20
INDIRI4
ARGI4
ADDRFP4 24
INDIRI4
ARGI4
ADDRGP4 G_MonsterHitscan
CALLV
pop
line 2244
;2235:			monster,
;2236:			target,
;2237:			def,
;2238:			projectile,
;2239:			damage,
;2240:			splashDamage,
;2241:			splashRadius
;2242:		);
;2243:
;2244:		return;
ADDRGP4 $762
JUMPV
LABELV $763
line 2247
;2245:	}
;2246:
;2247:	VectorCopy(
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2252
;2248:		monster->r.currentOrigin,
;2249:		start
;2250:	);
;2251:
;2252:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $769
line 2253
;2253:		MONSTER_MOVEMENT_WALKING ) {
line 2254
;2254:		start[2] += 36;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1108344832
ADDF4
ASGNF4
line 2255
;2255:	}
ADDRGP4 $770
JUMPV
LABELV $769
line 2256
;2256:	else {
line 2257
;2257:		start[2] += 8;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2258
;2258:	}
LABELV $770
line 2260
;2259:
;2260:	VectorCopy(
ADDRLP4 28
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2265
;2261:		target->r.currentOrigin,
;2262:		targetOrigin
;2263:	);
;2264:
;2265:	targetOrigin[2] +=
ADDRLP4 28+8
ADDRLP4 28+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 2268
;2266:		DEFAULT_VIEWHEIGHT * 0.5f;
;2267:
;2268:	VectorSubtract(
ADDRLP4 16
ADDRLP4 28
INDIRF4
ADDRLP4 4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 28+4
INDIRF4
ADDRLP4 4+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 16+8
ADDRLP4 28+8
INDIRF4
ADDRLP4 4+8
INDIRF4
SUBF4
ASGNF4
line 2274
;2269:		targetOrigin,
;2270:		start,
;2271:		direction
;2272:	);
;2273:
;2274:	VectorNormalize(direction);
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2276
;2275:
;2276:	VectorMA(
ADDRLP4 60
CNSTF4 1103101952
ASGNF4
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 60
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 4+4
INDIRF4
ADDRLP4 60
INDIRF4
ADDRLP4 16+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1103101952
ADDRLP4 16+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2283
;2277:		start,
;2278:		24,
;2279:		direction,
;2280:		start
;2281:	);
;2282:
;2283:	if( projectile &&
ADDRLP4 64
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 64
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $786
ADDRLP4 64
INDIRP4
ARGP4
ADDRGP4 $788
ARGP4
ADDRLP4 68
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 68
INDIRI4
CNSTI4 0
NEI4 $786
line 2284
;2284:		!Q_stricmp(projectile, "rocket") ) {
line 2285
;2285:		bolt = fire_rocket(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 72
ADDRGP4 fire_rocket
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 72
INDIRP4
ASGNP4
line 2290
;2286:			monster,
;2287:			start,
;2288:			direction
;2289:		);
;2290:	}
ADDRGP4 $787
JUMPV
LABELV $786
line 2291
;2291:	else if( projectile &&
ADDRLP4 72
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 72
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $789
ADDRLP4 72
INDIRP4
ARGP4
ADDRGP4 $791
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
NEI4 $789
line 2292
;2292:		!Q_stricmp(projectile, "grenade") ) {
line 2299
;2293:		/*
;2294:		 * Ballistic arc: add elevation so the grenade
;2295:		 * reaches a ground target instead of hitting
;2296:		 * the floor immediately.
;2297:		 * fire_grenade itself sets trType = TR_GRAVITY.
;2298:		 */
;2299:		direction[2] += 0.35f;
ADDRLP4 16+8
ADDRLP4 16+8
INDIRF4
CNSTF4 1051931443
ADDF4
ASGNF4
line 2300
;2300:		VectorNormalize( direction );
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2302
;2301:
;2302:		bolt = fire_grenade(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 80
ADDRGP4 fire_grenade
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 80
INDIRP4
ASGNP4
line 2307
;2303:			monster,
;2304:			start,
;2305:			direction
;2306:		);
;2307:	}
ADDRGP4 $790
JUMPV
LABELV $789
line 2308
;2308:	else {
line 2309
;2309:		bolt = fire_plasma(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 80
ADDRGP4 fire_plasma
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 80
INDIRP4
ASGNP4
line 2314
;2310:			monster,
;2311:			start,
;2312:			direction
;2313:		);
;2314:	}
LABELV $790
LABELV $787
line 2316
;2315:
;2316:	bolt->damage = damage;
ADDRLP4 0
INDIRP4
CNSTI4 740
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
line 2317
;2317:	bolt->splashDamage = splashDamage;
ADDRLP4 0
INDIRP4
CNSTI4 744
ADDP4
ADDRFP4 20
INDIRI4
ASGNI4
line 2318
;2318:	bolt->splashRadius = splashRadius;
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
ADDRFP4 24
INDIRI4
ASGNI4
line 2320
;2319:
;2320:	VectorScale(
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 16
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 680
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16+4
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 680
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 16+8
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 680
ADDP4
INDIRF4
MULF4
ASGNF4
line 2326
;2321:		direction,
;2322:		def->projectileSpeed,
;2323:		bolt->s.pos.trDelta
;2324:	);
;2325:
;2326:	SnapVector(bolt->s.pos.trDelta);
ADDRLP4 80
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ASGNP4
ADDRLP4 80
INDIRP4
ADDRLP4 80
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 84
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 88
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
line 2328
;2327:
;2328:	if( monster->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $795
line 2329
;2329:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2332
;2330:			level.time;
;2331:
;2332:		VectorCopy(
ADDRLP4 80
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 80
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 80
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2336
;2333:			monster->r.currentOrigin,
;2334:			monster->monsterProgressOrigin
;2335:		);
;2336:	}
LABELV $795
line 2337
;2337:}
LABELV $762
endproc G_MonsterFireProjectile 92 28
proc G_MonsterStartRangedAttack 72 12
line 2343
;2338:
;2339:static void G_MonsterStartRangedAttack(
;2340:	gentity_t *monster,
;2341:	gentity_t *target,
;2342:	monsterDef_t *def
;2343:) {
line 2351
;2344:	animation_t *animation;
;2345:	int variant;
;2346:	int fireFrame;
;2347:	int windup;
;2348:	vec3_t direction;
;2349:	vec3_t angles;
;2350:
;2351:	variant = rand() % MAX_MONSTER_VARIANTS;
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 40
INDIRI4
CNSTI4 3
MODI4
ASGNI4
line 2352
;2352:	animation = &def->rangedAnimations[variant];
ADDRLP4 4
CNSTI4 28
ADDRLP4 20
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 856
ADDP4
ADDP4
ASGNP4
line 2354
;2353:
;2354:	fireFrame = def->attackFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 656
ADDP4
INDIRI4
ASGNI4
line 2356
;2355:
;2356:	if (fireFrame < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $799
line 2357
;2357:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2358
;2358:	}
LABELV $799
line 2360
;2359:
;2360:	if (animation->numFrames > 0 &&
ADDRLP4 44
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
LEI4 $801
ADDRLP4 0
INDIRI4
ADDRLP4 44
INDIRI4
LTI4 $801
line 2361
;2361:		fireFrame >= animation->numFrames) {
line 2362
;2362:		fireFrame = animation->numFrames - 1;
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2363
;2363:	}
LABELV $801
line 2365
;2364:
;2365:	windup = fireFrame * animation->frameLerp;
ADDRLP4 36
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
MULI4
ASGNI4
line 2370
;2366:
;2367:	/*
;2368:	 * Face the target when the attack animation begins.
;2369:	 */
;2370:	VectorSubtract(
ADDRLP4 48
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 52
CNSTI4 488
ASGNI4
ADDRLP4 56
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
ADDRLP4 48
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRF4
ADDRLP4 56
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 60
CNSTI4 492
ASGNI4
ADDRLP4 8+4
ADDRLP4 48
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRF4
ADDRLP4 56
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 64
CNSTI4 496
ASGNI4
ADDRLP4 8+8
ADDRFP4 4
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2376
;2371:		target->r.currentOrigin,
;2372:		monster->r.currentOrigin,
;2373:		direction
;2374:	);
;2375:
;2376:	if( VectorNormalize(direction) > 0.0f ) {
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
LEF4 $805
line 2377
;2377:		vectoangles(direction, angles);
ADDRLP4 8
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2379
;2378:
;2379:		angles[PITCH] = 0;
ADDRLP4 24
CNSTF4 0
ASGNF4
line 2380
;2380:		angles[ROLL] = 0;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 2382
;2381:
;2382:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2387
;2383:			angles,
;2384:			monster->s.angles
;2385:		);
;2386:
;2387:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2392
;2388:			angles,
;2389:			monster->s.apos.trBase
;2390:		);
;2391:
;2392:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2396
;2393:			angles,
;2394:			monster->r.currentAngles
;2395:		);
;2396:	}
LABELV $805
line 2398
;2397:
;2398:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2399
;2399:	monster->monsterShotsRemaining = def->burstCount;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
ADDRFP4 8
INDIRP4
CNSTI4 672
ADDP4
INDIRI4
ASGNI4
line 2400
;2400:	monster->monsterNextShot = level.time + windup;
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 36
INDIRI4
ADDI4
ASGNI4
line 2402
;2401:
;2402:	G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 3
ARGI4
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 2407
;2403:		monster,
;2404:		MONSTER_STATE_RANGED,
;2405:		variant
;2406:	);
;2407:}
LABELV $798
endproc G_MonsterStartRangedAttack 72 12
proc G_MonsterStartMeleeAttack 24 12
line 2413
;2408:
;2409:static void G_MonsterStartMeleeAttack(
;2410:	gentity_t *monster,
;2411:	gentity_t *target,
;2412:	monsterDef_t *def
;2413:) {
line 2419
;2414:	animation_t *animation;
;2415:	int variant;
;2416:	int fireFrame;
;2417:	int windup;
;2418:
;2419:	variant =
ADDRLP4 16
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 16
INDIRI4
CNSTI4 3
MODI4
ASGNI4
line 2422
;2420:		rand() % MAX_MONSTER_VARIANTS;
;2421:
;2422:	animation =
ADDRLP4 4
CNSTI4 28
ADDRLP4 8
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 772
ADDP4
ADDP4
ASGNP4
line 2425
;2423:		&def->meleeAnimations[variant];
;2424:
;2425:	fireFrame = def->meleeFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
ASGNI4
line 2427
;2426:
;2427:	if( fireFrame < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $810
line 2428
;2428:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2429
;2429:	}
LABELV $810
line 2431
;2430:
;2431:	if( animation->numFrames > 0 &&
ADDRLP4 20
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
LEI4 $812
ADDRLP4 0
INDIRI4
ADDRLP4 20
INDIRI4
LTI4 $812
line 2432
;2432:		fireFrame >= animation->numFrames ) {
line 2433
;2433:		fireFrame =
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2435
;2434:			animation->numFrames - 1;
;2435:	}
LABELV $812
line 2437
;2436:
;2437:	windup =
ADDRLP4 12
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
MULI4
ASGNI4
line 2441
;2438:		fireFrame *
;2439:		animation->frameLerp;
;2440:
;2441:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2442
;2442:	monster->monsterShotsRemaining = 1;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 1
ASGNI4
line 2443
;2443:	monster->monsterNextShot =
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 12
INDIRI4
ADDI4
ASGNI4
line 2446
;2444:		level.time + windup;
;2445:
;2446:	G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 2
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 2451
;2447:		monster,
;2448:		MONSTER_STATE_MELEE,
;2449:		variant
;2450:	);
;2451:}
LABELV $809
endproc G_MonsterStartMeleeAttack 24 12
proc G_MonsterCanSeeTarget 92 28
line 2456
;2452:
;2453:static qboolean G_MonsterCanSeeTarget(
;2454:	gentity_t *monster,
;2455:	gentity_t *target
;2456:) {
line 2461
;2457:	trace_t trace;
;2458:	vec3_t start;
;2459:	vec3_t end;
;2460:
;2461:	if (!G_MonsterValidTarget(target)) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 80
ADDRGP4 G_MonsterValidTarget
CALLI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $816
line 2462
;2462:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $815
JUMPV
LABELV $816
line 2465
;2463:	}
;2464:
;2465:	VectorCopy(monster->r.currentOrigin, start);
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2466
;2466:	start[2] += 8;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2468
;2467:
;2468:	VectorCopy(target->r.currentOrigin, end);
ADDRLP4 68
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2469
;2469:	end[2] += DEFAULT_VIEWHEIGHT * 0.5f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 2471
;2470:
;2471:	trap_Trace(
ADDRLP4 0
ARGP4
ADDRLP4 56
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
ADDRLP4 68
ARGP4
ADDRFP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 2481
;2472:		&trace,
;2473:		start,
;2474:		NULL,
;2475:		NULL,
;2476:		end,
;2477:		monster->s.number,
;2478:		MASK_SHOT
;2479:	);
;2480:
;2481:	return trace.fraction == 1.0f ||
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $825
ADDRLP4 0+52
INDIRI4
ADDRFP4 4
INDIRP4
INDIRI4
NEI4 $823
LABELV $825
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRGP4 $824
JUMPV
LABELV $823
ADDRLP4 88
CNSTI4 0
ASGNI4
LABELV $824
ADDRLP4 88
INDIRI4
RETI4
LABELV $815
endproc G_MonsterCanSeeTarget 92 28
proc G_MonsterRunAttack 80 32
line 2488
;2482:		trace.entityNum == target->s.number;
;2483:}
;2484:
;2485:static void G_MonsterRunAttack(
;2486:	gentity_t *monster,
;2487:	monsterDef_t *def
;2488:) {
line 2491
;2489:	qboolean meleeAttack;
;2490:
;2491:	if( monster->monsterShotsRemaining <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $827
line 2492
;2492:		return;
ADDRGP4 $826
JUMPV
LABELV $827
line 2495
;2493:	}
;2494:
;2495:	if( !G_MonsterValidTarget(monster->enemy) ||
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 G_MonsterValidTarget
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $831
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 G_MonsterCanSeeTarget
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $829
LABELV $831
line 2499
;2496:		!G_MonsterCanSeeTarget(
;2497:			monster,
;2498:			monster->enemy
;2499:		) ) {
line 2500
;2500:		monster->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2502
;2501:
;2502:		monster->monsterNextAttack =
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
ADDI4
ASGNI4
line 2506
;2503:			level.time +
;2504:			def->attackCooldown;
;2505:
;2506:		return;
ADDRGP4 $826
JUMPV
LABELV $829
line 2509
;2507:	}
;2508:
;2509:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
INDIRI4
GEI4 $833
line 2510
;2510:		monster->monsterNextShot ) {
line 2511
;2511:		return;
ADDRGP4 $826
JUMPV
LABELV $833
line 2514
;2512:	}
;2513:
;2514:	meleeAttack =
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 2
NEI4 $837
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $838
JUMPV
LABELV $837
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $838
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
line 2518
;2515:		monster->monsterAnimation ==
;2516:		MONSTER_STATE_MELEE;
;2517:
;2518:	if( meleeAttack ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $839
line 2519
;2519:		G_MonsterSound(
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $841
ARGP4
ADDRLP4 20
INDIRP4
CNSTI4 848
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2532
;2520:			monster,
;2521:			def,
;2522:			"melee",
;2523:			monster->monsterAnimationVariant
;2524:		);
;2525:
;2526:		/*
;2527:		 * meleeProjectile "none" (parser turns it into an
;2528:		 * empty string) enables instant melee via G_Damage.
;2529:		 * Any other value keeps the old projectile-based
;2530:		 * melee behavior (plasma / rocket).
;2531:		 */
;2532:		if( def->meleeProjectile[0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 512
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $842
line 2533
;2533:			G_MonsterFireProjectile(
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 24
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 28
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 28
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 28
INDIRP4
CNSTI4 668
ADDP4
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
ADDRGP4 G_MonsterFireProjectile
CALLV
pop
line 2542
;2534:				monster,
;2535:				monster->enemy,
;2536:				def,
;2537:				def->meleeProjectile,
;2538:				def->meleeDamage,
;2539:				0,
;2540:				0
;2541:			);
;2542:		}
ADDRGP4 $840
JUMPV
LABELV $842
line 2543
;2543:		else {
line 2547
;2544:			vec3_t delta;
;2545:			float dist;
;2546:
;2547:			VectorSubtract(
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 44
ADDRLP4 40
INDIRP4
CNSTI4 768
ADDP4
ASGNP4
ADDRLP4 48
CNSTI4 488
ASGNI4
ADDRLP4 24
ADDRLP4 44
INDIRP4
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
ADDRLP4 40
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 52
CNSTI4 492
ASGNI4
ADDRLP4 24+4
ADDRLP4 44
INDIRP4
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRF4
ADDRLP4 40
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 60
CNSTI4 496
ASGNI4
ADDRLP4 24+8
ADDRLP4 56
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRF4
ADDRLP4 56
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2553
;2548:				monster->enemy->r.currentOrigin,
;2549:				monster->r.currentOrigin,
;2550:				delta
;2551:			);
;2552:
;2553:			dist = VectorLength( delta );
ADDRLP4 24
ARGP4
ADDRLP4 64
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 36
ADDRLP4 64
INDIRF4
ASGNF4
line 2560
;2554:
;2555:			/*
;2556:			 * 1.25f tolerance: during the attack windup the
;2557:			 * target may have moved slightly; still allow the
;2558:			 * hit if it is roughly within melee range.
;2559:			 */
;2560:			if( dist <= def->meleeRange * 1.25f &&
ADDRLP4 36
INDIRF4
CNSTF4 1067450368
ADDRFP4 4
INDIRP4
CNSTI4 660
ADDP4
INDIRF4
MULF4
GTF4 $840
ADDRLP4 68
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 68
INDIRP4
ARGP4
ADDRLP4 68
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 G_MonsterCanSeeTarget
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $840
line 2564
;2561:				G_MonsterCanSeeTarget(
;2562:					monster,
;2563:					monster->enemy
;2564:				) ) {
line 2565
;2565:				G_Damage(
ADDRLP4 76
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 76
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 76
INDIRP4
ARGP4
ADDRLP4 76
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 76
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 668
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 17
ARGI4
ADDRGP4 G_Damage
CALLV
pop
line 2575
;2566:					monster->enemy,
;2567:					monster,
;2568:					monster,
;2569:					NULL,
;2570:					monster->r.currentOrigin,
;2571:					def->meleeDamage,
;2572:					0,
;2573:					MOD_CRUSH
;2574:				);
;2575:			}
line 2576
;2576:		}
line 2577
;2577:	}
ADDRGP4 $840
JUMPV
LABELV $839
line 2578
;2578:	else {
line 2579
;2579:		G_MonsterSound(
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $848
ARGP4
ADDRLP4 20
INDIRP4
CNSTI4 848
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2586
;2580:			monster,
;2581:			def,
;2582:			"ranged",
;2583:			monster->monsterAnimationVariant
;2584:		);
;2585:
;2586:		G_MonsterFireProjectile(
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 24
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 28
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 28
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 28
INDIRP4
CNSTI4 684
ADDP4
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
CNSTI4 688
ADDP4
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
CNSTI4 692
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_MonsterFireProjectile
CALLV
pop
line 2595
;2587:			monster,
;2588:			monster->enemy,
;2589:			def,
;2590:			def->projectile,
;2591:			def->projectileDamage,
;2592:			def->splashDamage,
;2593:			def->splashRadius
;2594:		);
;2595:	}
LABELV $840
line 2597
;2596:
;2597:	monster->monsterShotsRemaining--;
ADDRLP4 20
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2599
;2598:
;2599:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $849
line 2600
;2600:		monster->monsterNextShot =
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 676
ADDP4
INDIRI4
ADDI4
ASGNI4
line 2603
;2601:			level.time +
;2602:			def->burstInterval;
;2603:	}
ADDRGP4 $850
JUMPV
LABELV $849
line 2604
;2604:	else {
line 2605
;2605:		monster->monsterNextAttack =
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
ADDI4
ASGNI4
line 2608
;2606:			level.time +
;2607:			def->attackCooldown;
;2608:	}
LABELV $850
line 2609
;2609:}
LABELV $826
endproc G_MonsterRunAttack 80 32
proc G_MonsterAttack 32 12
line 2615
;2610:
;2611:static void G_MonsterAttack(
;2612:	gentity_t *monster,
;2613:	gentity_t *target,
;2614:	monsterDef_t *def
;2615:) {
line 2618
;2616:	float distanceSquared;
;2617:
;2618:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $854
line 2619
;2619:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2623
;2620:			monster,
;2621:			def
;2622:		);
;2623:		return;
ADDRGP4 $853
JUMPV
LABELV $854
line 2626
;2624:	}
;2625:
;2626:	if( monster->monsterAnimation !=
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 1
EQI4 $856
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $856
line 2629
;2627:			MONSTER_STATE_MOVE &&
;2628:		monster->monsterAnimation !=
;2629:			MONSTER_STATE_IDLE ) {
line 2630
;2630:		return;
ADDRGP4 $853
JUMPV
LABELV $856
line 2633
;2631:	}
;2632:
;2633:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
INDIRI4
GEI4 $858
line 2634
;2634:		monster->monsterNextAttack ) {
line 2635
;2635:		return;
ADDRGP4 $853
JUMPV
LABELV $858
line 2638
;2636:	}
;2637:
;2638:	distanceSquared = DistanceSquared(
ADDRLP4 8
CNSTI4 488
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
ARGP4
ADDRLP4 12
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 12
INDIRF4
ASGNF4
line 2643
;2639:		monster->r.currentOrigin,
;2640:		target->r.currentOrigin
;2641:	);
;2642:
;2643:	if( !G_MonsterCanSeeTarget(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 G_MonsterCanSeeTarget
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $861
line 2646
;2644:		monster,
;2645:		target
;2646:	) ) {
line 2647
;2647:		return;
ADDRGP4 $853
JUMPV
LABELV $861
line 2653
;2648:	}
;2649:
;2650:	/*
;2651:	 * Prefer melee whenever the target is close enough.
;2652:	 */
;2653:	if( def->hasMelee &&
ADDRLP4 20
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 644
ADDP4
INDIRI4
CNSTI4 0
EQI4 $863
ADDRLP4 24
ADDRLP4 20
INDIRP4
CNSTI4 660
ADDP4
INDIRF4
ASGNF4
ADDRLP4 0
INDIRF4
ADDRLP4 24
INDIRF4
ADDRLP4 24
INDIRF4
MULF4
GTF4 $863
line 2656
;2654:		distanceSquared <=
;2655:			def->meleeRange *
;2656:			def->meleeRange ) {
line 2657
;2657:		G_MonsterStartMeleeAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterStartMeleeAttack
CALLV
pop
line 2663
;2658:			monster,
;2659:			target,
;2660:			def
;2661:		);
;2662:
;2663:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2668
;2664:			monster,
;2665:			def
;2666:		);
;2667:
;2668:		return;
ADDRGP4 $853
JUMPV
LABELV $863
line 2671
;2669:	}
;2670:
;2671:	if( !def->hasRanged ) {
ADDRFP4 8
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 0
NEI4 $865
line 2672
;2672:		return;
ADDRGP4 $853
JUMPV
LABELV $865
line 2675
;2673:	}
;2674:
;2675:	if( distanceSquared >
ADDRLP4 28
ADDRFP4 8
INDIRP4
CNSTI4 648
ADDP4
INDIRF4
ASGNF4
ADDRLP4 0
INDIRF4
ADDRLP4 28
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
LEF4 $867
line 2677
;2676:		def->attackRange *
;2677:		def->attackRange ) {
line 2678
;2678:		return;
ADDRGP4 $853
JUMPV
LABELV $867
line 2681
;2679:	}
;2680:
;2681:	G_MonsterStartRangedAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterStartRangedAttack
CALLV
pop
line 2687
;2682:		monster,
;2683:		target,
;2684:		def
;2685:	);
;2686:
;2687:	G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2691
;2688:		monster,
;2689:		def
;2690:	);
;2691:}
LABELV $853
endproc G_MonsterAttack 32 12
proc G_MonsterThink 44 16
line 2693
;2692:
;2693:static void G_MonsterThink(gentity_t *monster) {
line 2698
;2694:	monsterDef_t *def;
;2695:	gentity_t *target;
;2696:	int msec;
;2697:
;2698:	def = &g_monsterDefs
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 1108
ADDRLP4 12
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 12
INDIRP4
CNSTI4 808
ADDP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 2702
;2699:		[monster->monsterType]
;2700:		[monster->monsterSlot];
;2701:
;2702:	G_MonsterUpdateAnimation(monster, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 G_MonsterUpdateAnimation
CALLV
pop
line 2704
;2703:
;2704:	if (monster->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $870
line 2705
;2705:		if (level.time >= monster->monsterDeathTime) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 852
ADDP4
INDIRI4
LTI4 $872
line 2706
;2706:			if (monsterActiveCount > 0) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 0
LEI4 $875
line 2707
;2707:				monsterActiveCount--;
ADDRLP4 16
ADDRGP4 monsterActiveCount
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2708
;2708:			}
LABELV $875
line 2710
;2709:
;2710:			G_FreeEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 2711
;2711:			return;
ADDRGP4 $869
JUMPV
LABELV $872
line 2714
;2712:		}
;2713:
;2714:		monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2715
;2715:		return;
ADDRGP4 $869
JUMPV
LABELV $870
line 2718
;2716:	}
;2717:
;2718:	msec = level.time - monster->monsterLastThink;
ADDRLP4 0
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
INDIRI4
SUBI4
ASGNI4
line 2720
;2719:
;2720:	if (msec < 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
GEI4 $879
line 2721
;2721:		msec = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 2722
;2722:	}
ADDRGP4 $880
JUMPV
LABELV $879
line 2723
;2723:	else if (msec > 100) {
ADDRLP4 0
INDIRI4
CNSTI4 100
LEI4 $881
line 2724
;2724:		msec = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 2725
;2725:	}
LABELV $881
LABELV $880
line 2727
;2726:
;2727:	monster->monsterLastThink = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2729
;2728:
;2729:	target = G_MonsterFindTarget(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 G_MonsterFindTarget
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 16
INDIRP4
ASGNP4
line 2735
;2730:
;2731:	/*
;2732:	 * During an attack, keep facing the target selected
;2733:	 * at the beginning of the attack.
;2734:	 */
;2735:	if ((monster->monsterAnimation ==
ADDRLP4 20
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 3
EQI4 $886
ADDRLP4 20
INDIRI4
CNSTI4 2
NEI4 $884
LABELV $886
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 G_MonsterValidTarget
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
EQI4 $884
line 2739
;2736:			MONSTER_STATE_RANGED ||
;2737:		 monster->monsterAnimation ==
;2738:			MONSTER_STATE_MELEE) &&
;2739:		G_MonsterValidTarget(monster->enemy)) {
line 2740
;2740:		target = monster->enemy;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ASGNP4
line 2741
;2741:	}
LABELV $884
line 2743
;2742:
;2743:	if (target) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $887
line 2744
;2744:		G_MonsterFaceTarget(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterFaceTarget
CALLV
pop
line 2749
;2745:			monster,
;2746:			target
;2747:		);
;2748:
;2749:			G_MonsterMove(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 G_MonsterMove
CALLV
pop
line 2755
;2750:				monster,
;2751:				target,
;2752:				def,
;2753:				msec
;2754:			);
;2755:		G_MonsterAttack(monster, target, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 G_MonsterAttack
CALLV
pop
line 2757
;2756:
;2757:		if (monster->monsterAnimation == MONSTER_STATE_MOVE &&
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
NEI4 $888
ADDRGP4 level+32
INDIRI4
ADDRLP4 28
INDIRP4
CNSTI4 856
ADDP4
INDIRI4
LTI4 $888
line 2758
;2758:			level.time >= monster->monsterNextTalk) {
line 2761
;2759:			int variant;
;2760:
;2761:			variant =
ADDRLP4 36
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 32
ADDRLP4 36
INDIRI4
CNSTI4 3
MODI4
ASGNI4
line 2764
;2762:				rand() % MAX_MONSTER_VARIANTS;
;2763:
;2764:			G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $892
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2771
;2765:				monster,
;2766:				def,
;2767:				"talk",
;2768:				variant
;2769:			);
;2770:
;2771:			monster->monsterNextTalk =
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 G_MonsterTalkDelay
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 856
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 40
INDIRI4
ADDI4
ASGNI4
line 2774
;2772:				level.time +
;2773:				G_MonsterTalkDelay(def);
;2774:		}
line 2775
;2775:	}
ADDRGP4 $888
JUMPV
LABELV $887
line 2777
;2776:	
;2777:	else if( monster->monsterAnimation ==
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
NEI4 $894
line 2778
;2778:		MONSTER_STATE_MOVE ) {
line 2779
;2779:		G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 2784
;2780:			monster,
;2781:			MONSTER_STATE_IDLE,
;2782:			0
;2783:		);
;2784:	}
LABELV $894
LABELV $888
line 2790
;2785:
;2786:	/*
;2787:	 * Walking monsters remain attached to the floor
;2788:	 * and fall when moving over an edge.
;2789:	 */
;2790:	G_MonsterGroundWalker(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 G_MonsterGroundWalker
CALLV
pop
line 2800
;2791:		monster,
;2792:		def,
;2793:		msec
;2794:	);
;2795:	
;2796:	/*
;2797:	 * Remember meaningful movement so an active monster
;2798:	 * is not mistaken for a lost one.
;2799:	 */
;2800:	if( monster->monsterWaveSpawn &&
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $896
ADDRLP4 28
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 28
INDIRP4
CNSTI4 824
ADDP4
ARGP4
ADDRLP4 32
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 32
INDIRF4
CNSTF4 1149239296
LTF4 $896
line 2804
;2801:		DistanceSquared(
;2802:			monster->r.currentOrigin,
;2803:			monster->monsterProgressOrigin
;2804:		) >= 32.0f * 32.0f ) {
line 2805
;2805:		VectorCopy(
ADDRLP4 36
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 36
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 36
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2810
;2806:			monster->r.currentOrigin,
;2807:			monster->monsterProgressOrigin
;2808:		);
;2809:
;2810:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2812
;2811:			level.time;
;2812:	}
LABELV $896
line 2814
;2813:
;2814:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2816
;2815:
;2816:	monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2817
;2817:}
LABELV $869
endproc G_MonsterThink 44 16
proc G_MonsterSound 68 24
line 2824
;2818:
;2819:static void G_MonsterSound(
;2820:	gentity_t *monster,
;2821:	monsterDef_t *def,
;2822:	const char *group,
;2823:	int variant
;2824:) {
line 2827
;2825:	char filename[MAX_QPATH];
;2826:
;2827:	Com_sprintf(
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $901
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 384
ADDP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 2836
;2828:		filename,
;2829:		sizeof(filename),
;2830:		"%s/%s%i.wav",
;2831:		def->soundDir,
;2832:		group,
;2833:		variant + 1
;2834:	);
;2835:
;2836:	G_Sound(
ADDRLP4 0
ARGP4
ADDRLP4 64
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 3
ARGI4
ADDRLP4 64
INDIRI4
ARGI4
ADDRGP4 G_Sound
CALLV
pop
line 2841
;2837:		monster,
;2838:		CHAN_VOICE,
;2839:		G_SoundIndex(filename)
;2840:	);
;2841:}
LABELV $900
endproc G_MonsterSound 68 24
proc G_MonsterTalkDelay 12 0
line 2843
;2842:
;2843:static int G_MonsterTalkDelay(monsterDef_t *def) {
line 2846
;2844:	int range;
;2845:
;2846:	range = def->talkMaxDelay - def->talkMinDelay;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 700
ADDP4
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 696
ADDP4
INDIRI4
SUBI4
ASGNI4
line 2848
;2847:
;2848:	if (range <= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $903
line 2849
;2849:		return def->talkMinDelay;
ADDRFP4 0
INDIRP4
CNSTI4 696
ADDP4
INDIRI4
RETI4
ADDRGP4 $902
JUMPV
LABELV $903
line 2852
;2850:	}
;2851:
;2852:	return def->talkMinDelay + rand() % (range + 1);
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 696
ADDP4
INDIRI4
ADDRLP4 8
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
MODI4
ADDI4
RETI4
LABELV $902
endproc G_MonsterTalkDelay 12 0
proc G_MonsterPain 20 16
line 2859
;2853:}
;2854:
;2855:static void G_MonsterPain(
;2856:	gentity_t *self,
;2857:	gentity_t *attacker,
;2858:	int damage
;2859:) {
line 2863
;2860:	monsterDef_t *def;
;2861:	int variant;
;2862:
;2863:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $906
line 2864
;2864:		return;
ADDRGP4 $905
JUMPV
LABELV $906
line 2867
;2865:	}
;2866:	
;2867:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $908
line 2868
;2868:	self->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2871
;2869:		level.time;
;2870:
;2871:	VectorCopy(
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2875
;2872:		self->r.currentOrigin,
;2873:		self->monsterProgressOrigin
;2874:	);
;2875:}
LABELV $908
line 2877
;2876:
;2877:	if (level.time < self->pain_debounce_time) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
GEI4 $911
line 2878
;2878:		return;
ADDRGP4 $905
JUMPV
LABELV $911
line 2881
;2879:	}
;2880:
;2881:	def = &g_monsterDefs
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1108
ADDRLP4 8
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 8
INDIRP4
CNSTI4 808
ADDP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 2890
;2882:		[self->monsterType]
;2883:		[self->monsterSlot];
;2884:			
;2885:
;2886:	/*
;2887:	 * painChance: probability (0..100) that a hit actually
;2888:	 * triggers the pain animation. 100 keeps the old behavior.
;2889:	 */
;2890:	if( def->painChance <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRI4
CNSTI4 0
GTI4 $914
line 2891
;2891:		return;
ADDRGP4 $905
JUMPV
LABELV $914
line 2894
;2892:	}
;2893:
;2894:	if( def->painChance < 100 &&
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRI4
CNSTI4 100
GEI4 $916
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 100
MODI4
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRI4
LTI4 $916
line 2895
;2895:		(rand() % 100) >= def->painChance ) {
line 2896
;2896:		return;
ADDRGP4 $905
JUMPV
LABELV $916
line 2899
;2897:	}
;2898:
;2899:	variant = rand() % MAX_MONSTER_VARIANTS;
ADDRLP4 16
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 16
INDIRI4
CNSTI4 3
MODI4
ASGNI4
line 2901
;2900:
;2901:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2902
;2902:	self->monsterNextAttack = level.time + def->attackCooldown;
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
ADDI4
ASGNI4
line 2904
;2903:
;2904:	G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 2910
;2905:		self,
;2906:		MONSTER_STATE_PAIN,
;2907:		variant
;2908:	);
;2909:
;2910:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $919
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2917
;2911:		self,
;2912:		def,
;2913:		"pain",
;2914:		variant
;2915:	);
;2916:
;2917:	self->pain_debounce_time = level.time + 700;
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 700
ADDI4
ASGNI4
line 2918
;2918:}
LABELV $905
endproc G_MonsterPain 20 16
proc G_MonsterDropItem 36 12
line 2920
;2919:
;2920:static void G_MonsterDropItem(gentity_t *monster) {
line 2923
;2921:	vec3_t velocity;
;2922:
;2923:	if (!monster->monsterItem ||
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
ASGNP4
ADDRLP4 16
CNSTU4 0
ASGNU4
ADDRLP4 12
INDIRP4
CVPU4 4
ADDRLP4 16
INDIRU4
EQU4 $924
ADDRLP4 12
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 16
INDIRU4
NEU4 $922
LABELV $924
line 2924
;2924:		!monster->monsterItem->item) {
line 2925
;2925:		return;
ADDRGP4 $921
JUMPV
LABELV $922
line 2928
;2926:	}
;2927:
;2928:	if (rand() % 100 >= 50) {
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 100
MODI4
CNSTI4 50
LTI4 $925
line 2929
;2929:		return;
ADDRGP4 $921
JUMPV
LABELV $925
line 2932
;2930:	}
;2931:
;2932:	VectorSet(
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1114636288
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
MULF4
ASGNF4
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1114636288
CNSTF4 1073741824
ADDRLP4 28
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
ASGNF4
ADDRLP4 0+8
CNSTF4 1124859904
ASGNF4
line 2939
;2933:		velocity,
;2934:		crandom() * 60,
;2935:		crandom() * 60,
;2936:		140
;2937:	);
;2938:
;2939:	LaunchItem(
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 32
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
ARGP4
ADDRLP4 32
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 LaunchItem
CALLP4
pop
line 2944
;2940:		monster->monsterItem->item,
;2941:		monster->r.currentOrigin,
;2942:		velocity
;2943:	);
;2944:}
LABELV $921
endproc G_MonsterDropItem 36 12
proc G_MonsterDie 56 16
line 2952
;2945:
;2946:static void G_MonsterDie(
;2947:	gentity_t *self,
;2948:	gentity_t *inflictor,
;2949:	gentity_t *attacker,
;2950:	int damage,
;2951:	int mod
;2952:) {
line 2958
;2953:	monsterDef_t *def;
;2954:	animation_t *animation;
;2955:	int variant;
;2956:	int duration;
;2957:
;2958:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $930
line 2959
;2959:		return;
ADDRGP4 $929
JUMPV
LABELV $930
line 2962
;2960:	}
;2961:
;2962:	def = &g_monsterDefs
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1108
ADDRLP4 16
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5540
ADDRLP4 16
INDIRP4
CNSTI4 808
ADDP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 2966
;2963:		[self->monsterType]
;2964:		[self->monsterSlot];
;2965:
;2966:	variant = rand() % MAX_MONSTER_VARIANTS;
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 20
INDIRI4
CNSTI4 3
MODI4
ASGNI4
line 2968
;2967:
;2968:	self->monsterDead = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 1
ASGNI4
line 2969
;2969:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $932
line 2970
;2970:		monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2971
;2971:	}
LABELV $932
line 2973
;2972:	
;2973:	self->s.eFlags |= EF_DEAD;
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 8
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
line 2974
;2974:	self->takedamage = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 2975
;2975:	self->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 2976
;2976:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2978
;2977:
;2978:	self->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 2979
;2979:	self->clipmask = 0;
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 0
ASGNI4
line 2980
;2980:	trap_LinkEntity(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2982
;2981:
;2982:	G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 5
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 2988
;2983:		self,
;2984:		MONSTER_STATE_DEATH,
;2985:		variant
;2986:	);
;2987:
;2988:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $935
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2995
;2989:		self,
;2990:		def,
;2991:		"death",
;2992:		variant
;2993:	);
;2994:
;2995:	animation = &def->deathAnimations[variant];
ADDRLP4 8
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 1024
ADDP4
ADDP4
ASGNP4
line 2996
;2996:	duration = animation->numFrames *
ADDRLP4 12
ADDRLP4 8
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
MULI4
ASGNI4
line 2999
;2997:		animation->frameLerp;
;2998:
;2999:	self->monsterDeathTime =
ADDRFP4 0
INDIRP4
CNSTI4 852
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 12
INDIRI4
ADDI4
ADDRLP4 0
INDIRP4
CNSTI4 708
ADDP4
INDIRI4
ADDI4
ASGNI4
line 3008
;3000:		level.time +
;3001:		duration +
;3002:		def->corpseTime;
;3003:
;3004:	/*
;3005:	 * Monster Hunt score is awarded only for a monster
;3006:	 * killed by a real player or bot client.
;3007:	 */
;3008:	if (g_monsterHunt.integer &&
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 g_monsterHunt+12
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $937
ADDRLP4 36
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 40
CNSTU4 0
ASGNU4
ADDRLP4 36
INDIRP4
CVPU4 4
ADDRLP4 40
INDIRU4
EQU4 $937
ADDRLP4 36
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 40
INDIRU4
EQU4 $937
ADDRLP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
LEI4 $937
line 3011
;3009:		attacker &&
;3010:		attacker->client &&
;3011:		def->scoreValue > 0) {
line 3012
;3012:		AddScore(
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
ARGI4
ADDRGP4 AddScore
CALLV
pop
line 3017
;3013:			attacker,
;3014:			self->r.currentOrigin,
;3015:			def->scoreValue
;3016:		);
;3017:	}
LABELV $937
line 3019
;3018:
;3019:	G_MonsterDropItem(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_MonsterDropItem
CALLV
pop
line 3024
;3020:	/*
;3021:	 * Only classic item-bound monsters respawn independently.
;3022:	 * Wave monsters are controlled by the wave director.
;3023:	 */
;3024:	if( !self->monsterWaveSpawn &&
ADDRLP4 44
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 48
CNSTI4 0
ASGNI4
ADDRLP4 44
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
NEI4 $940
ADDRLP4 52
ADDRLP4 44
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
ASGNP4
ADDRLP4 52
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $940
ADDRLP4 52
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
EQI4 $940
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
LEI4 $940
line 3027
;3025:		self->monsterItem &&
;3026:		self->monsterItem->inuse &&
;3027:		def->respawnTime > 0 ) {
line 3028
;3028:		self->monsterItem->think =
ADDRFP4 0
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterRespawnThink
ASGNP4
line 3031
;3029:			G_MonsterRespawnThink;
;3030:
;3031:		self->monsterItem->nextthink =
ADDRFP4 0
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRI4
ADDI4
ASGNI4
line 3033
;3032:			level.time + def->respawnTime;
;3033:	}
LABELV $940
line 3034
;3034:}
LABELV $929
endproc G_MonsterDie 56 16
bss
align 4
LABELV monsterWaveFinished
skip 4
align 4
LABELV monsterWaveCombatStarted
skip 4
align 4
LABELV monsterWaveStarted
skip 4
align 4
LABELV monsterWaveActive
skip 4
align 4
LABELV monsterWaveLastProgress
skip 4
align 4
LABELV monsterWaveNextStart
skip 4
align 4
LABELV monsterWaveNextSpawn
skip 4
align 4
LABELV monsterWaveEntrySpawned
skip 4
align 4
LABELV monsterWaveEntry
skip 4
align 4
LABELV monsterCurrentWave
skip 4
align 4
LABELV monsterWavesLoaded
skip 4
align 4
LABELV monsterWaveFinal
skip 4
align 4
LABELV monsterWaveMaxActive
skip 4
align 4
LABELV monsterWaveTimeout
skip 4
align 4
LABELV monsterWaveSpawnInterval
skip 4
align 4
LABELV monsterWaveDelay
skip 4
align 4
LABELV monsterWaves
skip 3328
align 4
LABELV monsterActiveCount
skip 4
align 4
LABELV monsterItemCounter
skip 4
import G_FindAutomaticBaseSpots
export g_monsterDefLoaded
align 4
LABELV g_monsterDefLoaded
skip 120
export g_monsterDefs
align 4
LABELV g_monsterDefs
skip 33240
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
import g_noLightning
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
LABELV $935
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $919
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $901
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $892
byte 1 116
byte 1 97
byte 1 108
byte 1 107
byte 1 0
align 1
LABELV $848
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $841
byte 1 109
byte 1 101
byte 1 108
byte 1 101
byte 1 101
byte 1 0
align 1
LABELV $791
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $788
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $765
byte 1 104
byte 1 105
byte 1 116
byte 1 115
byte 1 99
byte 1 97
byte 1 110
byte 1 0
align 1
LABELV $715
byte 1 108
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $712
byte 1 114
byte 1 105
byte 1 102
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $709
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $448
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 32
byte 1 98
byte 1 101
byte 1 103
byte 1 105
byte 1 110
byte 1 115
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $406
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 32
byte 1 99
byte 1 111
byte 1 109
byte 1 112
byte 1 108
byte 1 101
byte 1 116
byte 1 101
byte 1 100
byte 1 46
byte 1 0
align 1
LABELV $405
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 97
byte 1 108
byte 1 108
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 32
byte 1 99
byte 1 108
byte 1 101
byte 1 97
byte 1 114
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $404
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 32
byte 1 99
byte 1 111
byte 1 109
byte 1 112
byte 1 108
byte 1 101
byte 1 116
byte 1 101
byte 1 100
byte 1 33
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $403
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 102
byte 1 105
byte 1 110
byte 1 97
byte 1 108
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $395
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 99
byte 1 108
byte 1 101
byte 1 97
byte 1 114
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $393
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $392
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $391
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 87
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $378
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
LABELV $252
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $243
byte 1 94
byte 1 50
byte 1 76
byte 1 111
byte 1 97
byte 1 100
byte 1 101
byte 1 100
byte 1 32
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 44
byte 1 32
byte 1 109
byte 1 97
byte 1 120
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 101
byte 1 44
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 109
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $242
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 101
byte 1 109
byte 1 112
byte 1 116
byte 1 121
byte 1 10
byte 1 0
align 1
LABELV $221
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 107
byte 1 101
byte 1 121
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $216
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $211
byte 1 102
byte 1 105
byte 1 110
byte 1 97
byte 1 108
byte 1 87
byte 1 97
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $206
byte 1 109
byte 1 97
byte 1 120
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $201
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 111
byte 1 117
byte 1 116
byte 1 0
align 1
LABELV $196
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 73
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 118
byte 1 97
byte 1 108
byte 1 0
align 1
LABELV $191
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 68
byte 1 101
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $183
byte 1 94
byte 1 49
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
byte 1 119
byte 1 97
byte 1 118
byte 1 101
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
LABELV $179
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
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
LABELV $175
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 107
byte 1 101
byte 1 121
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $170
byte 1 116
byte 1 114
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $167
byte 1 114
byte 1 101
byte 1 112
byte 1 101
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $164
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 99
byte 1 111
byte 1 117
byte 1 110
byte 1 116
byte 1 32
byte 1 102
byte 1 111
byte 1 114
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $159
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $154
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 116
byte 1 111
byte 1 111
byte 1 32
byte 1 109
byte 1 97
byte 1 110
byte 1 121
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 114
byte 1 105
byte 1 101
byte 1 115
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $151
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $148
byte 1 125
byte 1 0
align 1
LABELV $145
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 117
byte 1 110
byte 1 101
byte 1 120
byte 1 112
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 101
byte 1 110
byte 1 100
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $139
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 101
byte 1 120
byte 1 112
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 123
byte 1 32
byte 1 97
byte 1 102
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $138
byte 1 123
byte 1 0
align 1
LABELV $134
byte 1 94
byte 1 49
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $111
byte 1 94
byte 1 50
byte 1 76
byte 1 111
byte 1 97
byte 1 100
byte 1 101
byte 1 100
byte 1 32
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 44
byte 1 32
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 44
byte 1 32
byte 1 115
byte 1 108
byte 1 111
byte 1 116
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $106
byte 1 94
byte 1 49
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
byte 1 115
byte 1 108
byte 1 111
byte 1 116
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $100
byte 1 94
byte 1 49
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
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $94
byte 1 94
byte 1 49
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
LABELV $91
byte 1 94
byte 1 49
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
LABELV $87
byte 1 94
byte 1 49
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
LABELV $83
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
LABELV $82
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
LABELV $81
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
LABELV $80
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
LABELV $79
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
LABELV $78
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
LABELV $77
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
LABELV $76
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
LABELV $75
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
LABELV $74
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
LABELV $73
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
LABELV $72
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
LABELV $71
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
LABELV $70
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
LABELV $69
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
LABELV $68
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
LABELV $67
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
LABELV $66
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
LABELV $65
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
LABELV $64
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
LABELV $63
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
LABELV $62
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
LABELV $61
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
LABELV $60
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
LABELV $59
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
