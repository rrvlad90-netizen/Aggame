data
align 4
LABELV monsterConfigFiles
address $59
address $60
address $61
address $62
address $63
address $64
byte 4 0
code
proc G_LoadMonsterConfig 9576 16
file "../g_monster.c"
line 112
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
;109:	NULL
;110:};
;111:
;112:static qboolean G_LoadMonsterConfig(const char *filename) {
line 119
;113:	fileHandle_t file;
;114:	char text[MAX_MONSTER_CONFIG_TEXT];
;115:	char error[256];
;116:	monsterDef_t def;
;117:	int length;
;118:
;119:	length = trap_FS_FOpenFile(filename, &file, FS_READ);
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
line 121
;120:
;121:	if (!file) {
ADDRLP4 1112
INDIRI4
CNSTI4 0
NEI4 $66
line 122
;122:		G_Printf(
ADDRGP4 $68
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 126
;123:			S_COLOR_RED "Monster config not found: %s\n",
;124:			filename
;125:		);
;126:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $65
JUMPV
LABELV $66
line 129
;127:	}
;128:
;129:	if (length <= 0 || length >= sizeof(text)) {
ADDRLP4 1108
INDIRI4
CNSTI4 0
LEI4 $71
ADDRLP4 1108
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $69
LABELV $71
line 130
;130:		G_Printf(
ADDRGP4 $72
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 134
;131:			S_COLOR_RED "Invalid monster config size: %s\n",
;132:			filename
;133:		);
;134:		trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 135
;135:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $65
JUMPV
LABELV $69
line 138
;136:	}
;137:
;138:	trap_FS_Read(text, length, file);
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
line 139
;139:	text[length] = '\0';
ADDRLP4 1108
INDIRI4
ADDRLP4 1116
ADDP4
CNSTI1 0
ASGNI1
line 140
;140:	trap_FS_FCloseFile(file);
ADDRLP4 1112
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 142
;141:
;142:	if (!BG_ParseMonsterConfig(
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
NEI4 $73
line 147
;143:		text,
;144:		&def,
;145:		error,
;146:		sizeof(error)
;147:	)) {
line 148
;148:		G_Printf(
ADDRGP4 $75
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9308
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 153
;149:			S_COLOR_RED "Monster config error in %s: %s\n",
;150:			filename,
;151:			error
;152:		);
;153:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $65
JUMPV
LABELV $73
line 156
;154:	}
;155:
;156:	if (def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 0+576
INDIRI4
CNSTI4 0
LEI4 $80
ADDRLP4 0+576
INDIRI4
CNSTI4 6
LTI4 $76
LABELV $80
line 157
;157:		def.monsterType >= MONSTER_TYPE_RANDOM) {
line 158
;158:		G_Printf(
ADDRGP4 $81
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 162
;159:			S_COLOR_RED "Invalid monster type in %s\n",
;160:			filename
;161:		);
;162:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $65
JUMPV
LABELV $76
line 165
;163:	}
;164:
;165:	if (def.monsterSlot < 0 ||
ADDRLP4 0+580
INDIRI4
CNSTI4 0
LTI4 $86
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $82
LABELV $86
line 166
;166:		def.monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 167
;167:		G_Printf(
ADDRGP4 $87
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 171
;168:			S_COLOR_RED "Invalid monster slot in %s\n",
;169:			filename
;170:		);
;171:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $65
JUMPV
LABELV $82
line 174
;172:	}
;173:
;174:	g_monsterDefs[def.monsterType][def.monsterSlot] = def;
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
line 175
;175:	g_monsterDefLoaded[def.monsterType][def.monsterSlot] = qtrue;
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
line 177
;176:
;177:	G_Printf(
ADDRGP4 $92
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
line 185
;178:		S_COLOR_GREEN
;179:		"Loaded monster: %s, type %i, slot %i\n",
;180:		def.name,
;181:		def.monsterType,
;182:		def.monsterSlot
;183:	);
;184:
;185:	return qtrue;
CNSTI4 1
RETI4
LABELV $65
endproc G_LoadMonsterConfig 9576 16
proc G_MonsterWaveReadInt 12 4
line 192
;186:}
;187:
;188:
;189:static qboolean G_MonsterWaveReadInt(
;190:	char **text,
;191:	int *value
;192:) {
line 195
;193:	char *token;
;194:
;195:	token = COM_Parse(text);
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
line 197
;196:
;197:	if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $96
line 198
;198:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $95
JUMPV
LABELV $96
line 201
;199:	}
;200:
;201:	*value = atoi(token);
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
line 202
;202:	return qtrue;
CNSTI4 1
RETI4
LABELV $95
endproc G_MonsterWaveReadInt 12 4
proc G_MonsterWaveFindDefinition 12 8
line 209
;203:}
;204:
;205:static qboolean G_MonsterWaveFindDefinition(
;206:	const char *name,
;207:	int *monsterType,
;208:	int *monsterSlot
;209:) {
line 213
;210:	int type;
;211:	int slot;
;212:
;213:	for( type = MONSTER_TYPE_OFF + 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
LABELV $99
line 215
;214:		type < MONSTER_TYPE_RANDOM;
;215:		type++ ) {
line 216
;216:		for( slot = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $103
line 218
;217:			slot < MAX_MONSTERS_PER_TYPE;
;218:			slot++ ) {
line 219
;219:			if( !g_monsterDefLoaded[type][slot] ) {
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
NEI4 $107
line 220
;220:				continue;
ADDRGP4 $104
JUMPV
LABELV $107
line 223
;221:			}
;222:
;223:			if( !Q_stricmp(
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
NEI4 $109
line 226
;224:				g_monsterDefs[type][slot].name,
;225:				name
;226:			) ) {
line 227
;227:				*monsterType = type;
ADDRFP4 4
INDIRP4
ADDRLP4 4
INDIRI4
ASGNI4
line 228
;228:				*monsterSlot = slot;
ADDRFP4 8
INDIRP4
ADDRLP4 0
INDIRI4
ASGNI4
line 229
;229:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $98
JUMPV
LABELV $109
line 231
;230:			}
;231:		}
LABELV $104
line 218
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 217
ADDRLP4 0
INDIRI4
CNSTI4 5
LTI4 $103
line 232
;232:	}
LABELV $100
line 215
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 214
ADDRLP4 4
INDIRI4
CNSTI4 6
LTI4 $99
line 234
;233:
;234:	return qfalse;
CNSTI4 0
RETI4
LABELV $98
endproc G_MonsterWaveFindDefinition 12 8
proc G_MonsterWaveParseWave 124 12
line 240
;235:}
;236:
;237:static qboolean G_MonsterWaveParseWave(
;238:	char **text,
;239:	int waveNumber
;240:) {
line 244
;241:	monsterWaveDef_t *wave;
;242:	char *token;
;243:
;244:	if( waveNumber < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $114
ADDRLP4 8
INDIRI4
CNSTI4 32
LEI4 $112
LABELV $114
line 245
;245:		waveNumber > MAX_MONSTER_WAVES ) {
line 246
;246:		G_Printf(
ADDRGP4 $115
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 251
;247:			S_COLOR_RED
;248:			"Monster waves: invalid wave %i\n",
;249:			waveNumber
;250:		);
;251:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $112
line 254
;252:	}
;253:
;254:	wave = &monsterWaves[waveNumber - 1];
ADDRLP4 4
CNSTI4 104
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 monsterWaves-104
ADDP4
ASGNP4
line 256
;255:
;256:	token = COM_Parse(text);
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
line 258
;257:
;258:	if( Q_stricmp(token, "{") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $119
ARGP4
ADDRLP4 16
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $122
line 259
;259:		G_Printf(
ADDRGP4 $120
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 264
;260:			S_COLOR_RED
;261:			"Monster waves: expected { after wave %i\n",
;262:			waveNumber
;263:		);
;264:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $121
line 267
;265:	}
;266:
;267:	while( 1 ) {
line 268
;268:		token = COM_Parse(text);
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
line 270
;269:
;270:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $124
line 271
;271:			G_Printf(
ADDRGP4 $126
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 276
;272:				S_COLOR_RED
;273:				"Monster waves: unexpected end of wave %i\n",
;274:				waveNumber
;275:			);
;276:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $124
line 279
;277:		}
;278:
;279:		if( !Q_stricmp(token, "}") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $129
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $127
line 280
;280:			break;
ADDRGP4 $123
JUMPV
LABELV $127
line 283
;281:		}
;282:
;283:		if( !Q_stricmp(token, "monster") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $132
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $130
line 287
;284:			monsterWaveEntry_t *entry;
;285:			char monsterName[MAX_QPATH];
;286:
;287:			if( wave->numEntries >=
ADDRLP4 4
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
CNSTI4 8
LTI4 $133
line 288
;288:				MAX_MONSTERS_IN_WAVE ) {
line 289
;289:				G_Printf(
ADDRGP4 $135
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 294
;290:					S_COLOR_RED
;291:					"Monster waves: too many entries in wave %i\n",
;292:					waveNumber
;293:				);
;294:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $133
line 297
;295:			}
;296:
;297:			token = COM_Parse(text);
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
line 299
;298:
;299:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $136
line 300
;300:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $136
line 303
;301:			}
;302:
;303:			Q_strncpyz(
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
line 309
;304:				monsterName,
;305:				token,
;306:				sizeof(monsterName)
;307:			);
;308:
;309:			entry =
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
line 312
;310:				&wave->entries[wave->numEntries];
;311:
;312:			if( !G_MonsterWaveFindDefinition(
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
NEI4 $138
line 316
;313:				monsterName,
;314:				&entry->monsterType,
;315:				&entry->monsterSlot
;316:			) ) {
line 317
;317:				G_Printf(
ADDRGP4 $140
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 322
;318:					S_COLOR_RED
;319:					"Monster waves: unknown monster %s\n",
;320:					monsterName
;321:				);
;322:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $138
line 325
;323:			}
;324:
;325:			if( !G_MonsterWaveReadInt(
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
NEI4 $141
line 328
;326:				text,
;327:				&entry->count
;328:			) ) {
line 329
;329:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $141
line 332
;330:			}
;331:
;332:			if( entry->count < 1 ) {
ADDRLP4 32
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 1
GEI4 $143
line 333
;333:				G_Printf(
ADDRGP4 $145
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 338
;334:					S_COLOR_RED
;335:					"Monster waves: invalid count for %s\n",
;336:					monsterName
;337:				);
;338:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $143
line 341
;339:			}
;340:
;341:			wave->numEntries++;
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
line 342
;342:			continue;
ADDRGP4 $122
JUMPV
LABELV $130
line 345
;343:		}
;344:
;345:		if( !Q_stricmp(token, "repeat") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $148
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $146
line 346
;346:			token = COM_Parse(text);
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
line 348
;347:
;348:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $149
line 349
;349:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $149
line 352
;350:			}
;351:
;352:			wave->repeat =
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $151
ARGP4
ADDRLP4 44
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $155
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
EQI4 $153
LABELV $155
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $154
JUMPV
LABELV $153
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $154
ADDRLP4 4
INDIRP4
CNSTI4 100
ADDP4
ADDRLP4 40
INDIRI4
ASGNI4
line 356
;353:				!Q_stricmp(token, "true") ||
;354:				atoi(token) != 0;
;355:
;356:			continue;
ADDRGP4 $122
JUMPV
LABELV $146
line 359
;357:		}
;358:
;359:		G_Printf(
ADDRGP4 $156
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
line 365
;360:			S_COLOR_RED
;361:			"Monster waves: unknown key %s in wave %i\n",
;362:			token,
;363:			waveNumber
;364:		);
;365:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $111
JUMPV
LABELV $122
line 267
ADDRGP4 $121
JUMPV
LABELV $123
line 368
;366:	}
;367:
;368:	return qtrue;
CNSTI4 1
RETI4
LABELV $111
endproc G_MonsterWaveParseWave 124 12
proc G_LoadMonsterWaveConfig 8260 16
line 373
;369:}
;370:
;371:static qboolean G_LoadMonsterWaveConfig(
;372:	const char *filename
;373:) {
line 382
;374:	fileHandle_t file;
;375:	char buffer[MAX_MONSTER_WAVE_TEXT];
;376:	char *text;
;377:	char *token;
;378:	int length;
;379:	int value;
;380:	int i;
;381:
;382:	memset(
ADDRGP4 monsterWaves
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3328
ARGI4
ADDRGP4 memset
CALLP4
pop
line 392
;383:		monsterWaves,
;384:		0,
;385:		sizeof(monsterWaves)
;386:	);
;387:
;388:	/*
;389:	 * Default values used when a key is absent
;390:	 * from monsterwaves.cfg.
;391:	 */
;392:	monsterWaveDelay = 5000;
ADDRGP4 monsterWaveDelay
CNSTI4 5000
ASGNI4
line 393
;393:	monsterWaveSpawnInterval = 750;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 750
ASGNI4
line 394
;394:	monsterWaveTimeout = 30000;
ADDRGP4 monsterWaveTimeout
CNSTI4 30000
ASGNI4
line 395
;395:	monsterWaveMaxActive = 8;
ADDRGP4 monsterWaveMaxActive
CNSTI4 8
ASGNI4
line 396
;396:	monsterWaveFinal = DEFAULT_MONSTER_WAVES;
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 398
;397:
;398:	length = trap_FS_FOpenFile(
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
line 404
;399:		filename,
;400:		&file,
;401:		FS_READ
;402:	);
;403:
;404:	if( !file ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $158
line 405
;405:		G_Printf(
ADDRGP4 $160
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 410
;406:			S_COLOR_RED
;407:			"Monster wave config not found: %s\n",
;408:			filename
;409:		);
;410:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
LABELV $158
line 413
;411:	}
;412:
;413:	if( length <= 0 ||
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $163
ADDRLP4 16
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $161
LABELV $163
line 414
;414:		length >= sizeof(buffer) ) {
line 415
;415:		G_Printf(
ADDRGP4 $164
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 421
;416:			S_COLOR_RED
;417:			"Invalid monster wave config size: %s\n",
;418:			filename
;419:		);
;420:
;421:		trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 422
;422:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
LABELV $161
line 425
;423:	}
;424:
;425:	trap_FS_Read(buffer, length, file);
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
line 426
;426:	buffer[length] = '\0';
ADDRLP4 16
INDIRI4
ADDRLP4 24
ADDP4
CNSTI1 0
ASGNI1
line 427
;427:	trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 429
;428:
;429:	text = buffer;
ADDRLP4 4
ADDRLP4 24
ASGNP4
ADDRGP4 $166
JUMPV
LABELV $165
line 431
;430:
;431:	while( 1 ) {
line 432
;432:		token = COM_Parse(&text);
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
line 434
;433:
;434:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $168
line 435
;435:			break;
ADDRGP4 $167
JUMPV
LABELV $168
line 438
;436:		}
;437:
;438:		if( !Q_stricmp(token, "waveDelay") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $172
ARGP4
ADDRLP4 8228
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8228
INDIRI4
CNSTI4 0
NEI4 $170
line 439
;439:			if( !G_MonsterWaveReadInt(
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
NEI4 $166
line 442
;440:				&text,
;441:				&monsterWaveDelay
;442:			) ) {
line 443
;443:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
line 446
;444:			}
;445:
;446:			continue;
LABELV $170
line 449
;447:		}
;448:
;449:		if( !Q_stricmp(token, "spawnInterval") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $177
ARGP4
ADDRLP4 8232
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8232
INDIRI4
CNSTI4 0
NEI4 $175
line 450
;450:			if( !G_MonsterWaveReadInt(
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
NEI4 $166
line 453
;451:				&text,
;452:				&monsterWaveSpawnInterval
;453:			) ) {
line 454
;454:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
line 457
;455:			}
;456:
;457:			continue;
LABELV $175
line 460
;458:		}
;459:
;460:		if( !Q_stricmp(token, "waveTimeout") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $182
ARGP4
ADDRLP4 8236
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8236
INDIRI4
CNSTI4 0
NEI4 $180
line 461
;461:			if( !G_MonsterWaveReadInt(
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
NEI4 $166
line 464
;462:				&text,
;463:				&monsterWaveTimeout
;464:			) ) {
line 465
;465:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
line 468
;466:			}
;467:
;468:			continue;
LABELV $180
line 471
;469:		}
;470:
;471:		if( !Q_stricmp(token, "maxActive") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $187
ARGP4
ADDRLP4 8240
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8240
INDIRI4
CNSTI4 0
NEI4 $185
line 472
;472:			if( !G_MonsterWaveReadInt(
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
NEI4 $166
line 475
;473:				&text,
;474:				&monsterWaveMaxActive
;475:			) ) {
line 476
;476:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
line 479
;477:			}
;478:
;479:			continue;
LABELV $185
line 482
;480:		}
;481:
;482:		if( !Q_stricmp(token, "finalWave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $192
ARGP4
ADDRLP4 8244
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8244
INDIRI4
CNSTI4 0
NEI4 $190
line 483
;483:			if( !G_MonsterWaveReadInt(
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
NEI4 $166
line 486
;484:				&text,
;485:				&monsterWaveFinal
;486:			) ) {
line 487
;487:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
line 490
;488:			}
;489:
;490:			continue;
LABELV $190
line 493
;491:		}
;492:
;493:		if( !Q_stricmp(token, "wave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $197
ARGP4
ADDRLP4 8248
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8248
INDIRI4
CNSTI4 0
NEI4 $195
line 494
;494:			if( !G_MonsterWaveReadInt(
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
NEI4 $198
line 497
;495:				&text,
;496:				&value
;497:			) ) {
line 498
;498:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
LABELV $198
line 501
;499:			}
;500:
;501:			if( !G_MonsterWaveParseWave(
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
NEI4 $166
line 504
;502:				&text,
;503:				value
;504:			) ) {
line 505
;505:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
line 508
;506:			}
;507:
;508:			continue;
LABELV $195
line 511
;509:		}
;510:
;511:		G_Printf(
ADDRGP4 $202
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 517
;512:			S_COLOR_RED
;513:			"Monster waves: unknown key %s\n",
;514:			token
;515:		);
;516:
;517:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
LABELV $166
line 431
ADDRGP4 $165
JUMPV
LABELV $167
line 523
;518:	}
;519:
;520:	/*
;521:	 * Sanitize timing and entity limits.
;522:	 */
;523:	if( monsterWaveDelay < 0 ) {
ADDRGP4 monsterWaveDelay
INDIRI4
CNSTI4 0
GEI4 $203
line 524
;524:		monsterWaveDelay = 0;
ADDRGP4 monsterWaveDelay
CNSTI4 0
ASGNI4
line 525
;525:	}
LABELV $203
line 527
;526:
;527:	if( monsterWaveSpawnInterval < 100 ) {
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
CNSTI4 100
GEI4 $205
line 528
;528:		monsterWaveSpawnInterval = 100;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 100
ASGNI4
line 529
;529:	}
LABELV $205
line 531
;530:
;531:	if( monsterWaveTimeout < 5000 ) {
ADDRGP4 monsterWaveTimeout
INDIRI4
CNSTI4 5000
GEI4 $207
line 532
;532:		monsterWaveTimeout = 5000;
ADDRGP4 monsterWaveTimeout
CNSTI4 5000
ASGNI4
line 533
;533:	}
LABELV $207
line 535
;534:
;535:	if( monsterWaveMaxActive < 1 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 1
GEI4 $209
line 536
;536:		monsterWaveMaxActive = 1;
ADDRGP4 monsterWaveMaxActive
CNSTI4 1
ASGNI4
line 537
;537:	}
ADDRGP4 $210
JUMPV
LABELV $209
line 538
;538:	else if( monsterWaveMaxActive > 64 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 64
LEI4 $211
line 539
;539:		monsterWaveMaxActive = 64;
ADDRGP4 monsterWaveMaxActive
CNSTI4 64
ASGNI4
line 540
;540:	}
LABELV $211
LABELV $210
line 542
;541:
;542:	if( monsterWaveFinal < 1 ||
ADDRLP4 8224
ADDRGP4 monsterWaveFinal
INDIRI4
ASGNI4
ADDRLP4 8224
INDIRI4
CNSTI4 1
LTI4 $215
ADDRLP4 8224
INDIRI4
CNSTI4 32
LEI4 $213
LABELV $215
line 544
;543:		monsterWaveFinal >
;544:			MAX_MONSTER_WAVES ) {
line 545
;545:		monsterWaveFinal =
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 547
;546:			DEFAULT_MONSTER_WAVES;
;547:	}
LABELV $213
line 553
;548:
;549:	/*
;550:	 * Every enabled wave must contain at least
;551:	 * one monster definition.
;552:	 */
;553:	for( i = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $219
JUMPV
LABELV $216
line 555
;554:		i < monsterWaveFinal;
;555:		i++ ) {
line 556
;556:		if( monsterWaves[i].numEntries == 0 ) {
CNSTI4 104
ADDRLP4 8
INDIRI4
MULI4
ADDRGP4 monsterWaves+96
ADDP4
INDIRI4
CNSTI4 0
NEI4 $220
line 557
;557:			G_Printf(
ADDRGP4 $223
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 563
;558:				S_COLOR_RED
;559:				"Monster waves: wave %i is empty\n",
;560:				i + 1
;561:			);
;562:
;563:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $157
JUMPV
LABELV $220
line 565
;564:		}
;565:	}
LABELV $217
line 555
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $219
line 554
ADDRLP4 8
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
LTI4 $216
line 567
;566:
;567:	G_Printf(
ADDRGP4 $224
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
line 576
;568:		S_COLOR_GREEN
;569:		"Loaded monsterwaves.cfg: %i waves, "
;570:		"max %i active, timeout %i ms\n",
;571:		monsterWaveFinal,
;572:		monsterWaveMaxActive,
;573:		monsterWaveTimeout
;574:	);
;575:
;576:	return qtrue;
CNSTI4 1
RETI4
LABELV $157
endproc G_LoadMonsterWaveConfig 8260 16
export G_MonsterInitDefinitions
proc G_MonsterInitDefinitions 8 12
line 580
;577:}
;578:
;579:
;580:void G_MonsterInitDefinitions(void) {
line 583
;581:	int i;
;582:	
;583:	monsterItemCounter = 0;
ADDRGP4 monsterItemCounter
CNSTI4 0
ASGNI4
line 584
;584:	monsterActiveCount = 0;
ADDRGP4 monsterActiveCount
CNSTI4 0
ASGNI4
line 586
;585:	
;586:	monsterCurrentWave = 0;
ADDRGP4 monsterCurrentWave
CNSTI4 0
ASGNI4
line 587
;587:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 588
;588:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 589
;589:	monsterWaveNextSpawn = 0;
ADDRGP4 monsterWaveNextSpawn
CNSTI4 0
ASGNI4
line 590
;590:	monsterWaveNextStart = 0;
ADDRGP4 monsterWaveNextStart
CNSTI4 0
ASGNI4
line 591
;591:	monsterWaveLastProgress = 0;
ADDRGP4 monsterWaveLastProgress
CNSTI4 0
ASGNI4
line 593
;592:
;593:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 594
;594:	monsterWaveStarted = qfalse;
ADDRGP4 monsterWaveStarted
CNSTI4 0
ASGNI4
line 595
;595:	monsterWaveCombatStarted = qfalse;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 0
ASGNI4
line 596
;596:	monsterWaveFinished = qfalse;
ADDRGP4 monsterWaveFinished
CNSTI4 0
ASGNI4
line 598
;597:
;598:	memset(g_monsterDefs, 0, sizeof(g_monsterDefs));
ADDRGP4 g_monsterDefs
ARGP4
CNSTI4 0
ARGI4
CNSTI4 33240
ARGI4
ADDRGP4 memset
CALLP4
pop
line 599
;599:	memset(g_monsterDefLoaded, 0, sizeof(g_monsterDefLoaded));
ADDRGP4 g_monsterDefLoaded
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 601
;600:
;601:	for (i = 0; monsterConfigFiles[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $229
JUMPV
LABELV $226
line 602
;602:		G_LoadMonsterConfig(monsterConfigFiles[i]);
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
line 603
;603:	}
LABELV $227
line 601
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $229
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $226
line 605
;604:	
;605:	monsterWavesLoaded = qfalse;
ADDRGP4 monsterWavesLoaded
CNSTI4 0
ASGNI4
line 610
;606:
;607:	/*
;608:	 * Both Monster Hunt modes use monsterwaves.cfg.
;609:	 */
;610:	if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $230
line 611
;611:		MONSTER_HUNT_OFF ) {
line 612
;612:		monsterWavesLoaded =
ADDRGP4 $233
ARGP4
ADDRLP4 4
ADDRGP4 G_LoadMonsterWaveConfig
CALLI4
ASGNI4
ADDRGP4 monsterWavesLoaded
ADDRLP4 4
INDIRI4
ASGNI4
line 616
;613:			G_LoadMonsterWaveConfig(
;614:				"monsterwaves.cfg"
;615:			);
;616:	}
LABELV $230
line 617
;617:}
LABELV $225
endproc G_MonsterInitDefinitions 8 12
proc G_MonsterEligibleItem 24 0
line 619
;618:
;619:static qboolean G_MonsterEligibleItem(gentity_t *item) {
line 620
;620:	if (!item || !item->item) {
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
EQU4 $237
ADDRLP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $235
LABELV $237
line 621
;621:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $234
JUMPV
LABELV $235
line 624
;622:	}
;623:
;624:	if (item->flags & FL_DROPPED_ITEM) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $238
line 625
;625:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $234
JUMPV
LABELV $238
line 628
;626:	}
;627:
;628:	if (item->team || item->targetname || item->wait == -1) {
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
NEU4 $243
ADDRLP4 8
INDIRP4
CNSTI4 652
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 12
INDIRU4
NEU4 $243
ADDRLP4 8
INDIRP4
CNSTI4 796
ADDP4
INDIRF4
CNSTF4 3212836864
NEF4 $240
LABELV $243
line 629
;629:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $234
JUMPV
LABELV $240
line 632
;630:	}
;631:
;632:	switch (item->item->giType) {
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
LTI4 $244
ADDRLP4 16
INDIRI4
CNSTI4 5
GTI4 $244
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $248-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $248
address $247
address $247
address $247
address $247
address $247
code
LABELV $247
line 638
;633:	case IT_WEAPON:
;634:	case IT_AMMO:
;635:	case IT_ARMOR:
;636:	case IT_HEALTH:
;637:	case IT_POWERUP:
;638:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $234
JUMPV
LABELV $244
line 641
;639:
;640:	default:
;641:		return qfalse;
CNSTI4 0
RETI4
LABELV $234
endproc G_MonsterEligibleItem 24 0
proc G_MonsterSetOrigin 0 8
line 648
;642:	}
;643:}
;644:
;645:static void G_MonsterSetOrigin(
;646:	gentity_t *monster,
;647:	const vec3_t origin
;648:) {
line 649
;649:	G_SetOrigin(monster, (float *)origin);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 655
;650:
;651:	/*
;652:	 * The client interpolates monsters between snapshots.
;653:	 * G_SetOrigin resets trType to TR_STATIONARY.
;654:	 */
;655:	monster->s.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 656
;656:	monster->s.pos.trTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 657
;657:}
LABELV $250
endproc G_MonsterSetOrigin 0 8
proc G_MonsterSpawnAtOrigin 52 12
line 664
;658:
;659:static qboolean G_MonsterSpawnAtOrigin(
;660:	gentity_t *item,
;661:	monsterDef_t *def,
;662:	vec3_t spawnOrigin,
;663:	qboolean waveSpawn
;664:) {
line 668
;665:	gentity_t *monster;
;666:	vec3_t origin;
;667:
;668:	if( waveSpawn ) {
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $253
line 669
;669:		if( monsterActiveCount >=
ADDRGP4 monsterActiveCount
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $254
line 670
;670:			monsterWaveMaxActive ) {
line 671
;671:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $252
JUMPV
line 673
;672:		}
;673:	}
LABELV $253
line 674
;674:	else if( monsterActiveCount >= 8 ) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $257
line 675
;675:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $252
JUMPV
LABELV $257
LABELV $254
line 678
;676:	}
;677:
;678:	if( !def ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $259
line 679
;679:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $252
JUMPV
LABELV $259
line 682
;680:	}
;681:
;682:	monster = G_Spawn();
ADDRLP4 16
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16
INDIRP4
ASGNP4
line 684
;683:
;684:	monster->classname = "monster";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $132
ASGNP4
line 685
;685:	monster->s.eType = ET_MONSTER;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 13
ASGNI4
line 687
;686:
;687:	if( def->models[0][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $261
line 688
;688:		monster->s.modelindex =
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
line 690
;689:			G_ModelIndex(def->models[0]);
;690:	}
LABELV $261
line 692
;691:
;692:	if( def->models[1][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $263
line 693
;693:		monster->s.modelindex2 =
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
line 695
;694:			G_ModelIndex(def->models[1]);
;695:	}
LABELV $263
line 697
;696:
;697:	if( def->models[2][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $265
line 698
;698:		monster->s.otherEntityNum =
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
line 700
;699:			G_ModelIndex(def->models[2]);
;700:	}
LABELV $265
line 702
;701:
;702:	if( def->models[3][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 256
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $267
line 703
;703:		monster->s.otherEntityNum2 =
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
line 705
;704:			G_ModelIndex(def->models[3]);
;705:	}
LABELV $267
line 707
;706:
;707:	monster->s.frame =
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
line 710
;708:		def->moveAnimation.firstFrame;
;709:
;710:	monster->s.groundEntityNum =
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 713
;711:		ENTITYNUM_NONE;
;712:
;713:	monster->s.apos.trType =
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 716
;714:		TR_STATIONARY;
;715:
;716:	monster->monsterType =
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
line 719
;717:		def->monsterType;
;718:
;719:	monster->monsterSlot =
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
line 726
;720:		def->monsterSlot;
;721:		
;722:	/*
;723:	 * Send monster definition identity to cgame.
;724:	 * Low byte: type, high byte: slot.
;725:	 */
;726:	monster->s.generic1 =
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
line 730
;727:		(def->monsterType & 255) |
;728:		((def->monsterSlot & 255) << 8);	
;729:
;730:	monster->monsterItem = item;
ADDRLP4 0
INDIRP4
CNSTI4 868
ADDP4
ADDRFP4 0
INDIRP4
ASGNP4
line 731
;731:	monster->monsterWaveSpawn = waveSpawn;
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
ADDRFP4 12
INDIRI4
ASGNI4
line 732
;732:	monster->monsterDead = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 0
ASGNI4
line 734
;733:
;734:	monster->health = def->health;
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
line 735
;735:	monster->takedamage = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 736
;736:	monster->pain = G_MonsterPain;
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
ADDRGP4 G_MonsterPain
ASGNP4
line 737
;737:	monster->die = G_MonsterDie;
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 G_MonsterDie
ASGNP4
line 739
;738:
;739:	monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 742
;740:		level.time + 500;
;741:
;742:	monster->monsterNextShot = 0;
ADDRLP4 0
INDIRP4
CNSTI4 876
ADDP4
CNSTI4 0
ASGNI4
line 743
;743:	monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 745
;744:
;745:	G_MonsterSetAnimation(
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
line 751
;746:		monster,
;747:		MONSTER_STATE_IDLE,
;748:		0
;749:	);
;750:
;751:	monster->monsterNextTalk =
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
line 755
;752:		level.time +
;753:		G_MonsterTalkDelay(def);
;754:
;755:	VectorCopy(
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
line 760
;756:		def->mins,
;757:		monster->r.mins
;758:	);
;759:
;760:	VectorCopy(
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
line 765
;761:		def->maxs,
;762:		monster->r.maxs
;763:	);
;764:
;765:	monster->r.contents = CONTENTS_BODY;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 33554432
ASGNI4
line 766
;766:	monster->clipmask = MASK_PLAYERSOLID;
ADDRLP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 33619969
ASGNI4
line 768
;767:
;768:	VectorCopy(spawnOrigin, origin);
ADDRLP4 4
ADDRFP4 8
INDIRP4
INDIRB
ASGNB 12
line 769
;769:	origin[2] += def->hoverHeight;
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
line 771
;770:
;771:	G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 776
;772:		monster,
;773:		origin
;774:	);
;775:	
;776:	monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 779
;777:	level.time;
;778:
;779:	VectorCopy(
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
line 784
;780:		monster->r.currentOrigin,
;781:		monster->monsterProgressOrigin
;782:	);
;783:
;784:	monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 787
;785:		level.time;
;786:
;787:	monster->monsterDriftPhase =
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
line 790
;788:		monster->s.number * 0.73f;
;789:
;790:	monster->think = G_MonsterThink;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterThink
ASGNP4
line 791
;791:	monster->nextthink = level.time + 50;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 793
;792:
;793:	trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 799
;794:
;795:	/*
;796:	 * Classic Monster Hunt replaces and hides a map item.
;797:	 * Wave monsters are independent from map items.
;798:	 */
;799:	if( item && !waveSpawn ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $275
ADDRFP4 12
INDIRI4
CNSTI4 0
NEI4 $275
line 800
;800:		item->monsterType =
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
line 803
;801:			def->monsterType;
;802:
;803:		item->monsterSlot =
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
line 806
;804:			def->monsterSlot;
;805:
;806:		item->s.eFlags |= EF_NODRAW;
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
line 807
;807:		item->r.svFlags |= SVF_NOCLIENT;
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
line 808
;808:		item->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 809
;809:		item->touch = 0;
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
CNSTP4 0
ASGNP4
line 810
;810:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 811
;811:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 813
;812:
;813:		trap_UnlinkEntity(item);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 814
;814:	}
LABELV $275
line 816
;815:
;816:	monsterActiveCount++;
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
line 825
;817:
;818:/*	G_Printf(
;819:		"Spawned %smonster %s at %s\n",
;820:		waveSpawn ? "wave " : "",
;821:		def->name,
;822:		vtos(origin)
;823:	);*/
;824:
;825:	return qtrue;
CNSTI4 1
RETI4
LABELV $252
endproc G_MonsterSpawnAtOrigin 52 12
proc G_MonsterSpawnFromItem 12 16
line 831
;826:}
;827:
;828:static qboolean G_MonsterSpawnFromItem(
;829:	gentity_t *item,
;830:	monsterDef_t *def
;831:) {
line 832
;832:	if( !item || !def ) {
ADDRLP4 0
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
EQU4 $280
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
NEU4 $278
LABELV $280
line 833
;833:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $277
JUMPV
LABELV $278
line 836
;834:	}
;835:
;836:	return G_MonsterSpawnAtOrigin(
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
LABELV $277
endproc G_MonsterSpawnFromItem 12 16
proc G_MonsterRespawnThink 32 8
line 844
;837:		item,
;838:		def,
;839:		item->s.pos.trBase,
;840:		qfalse
;841:	);
;842:}
;843:
;844:static void G_MonsterRespawnThink(gentity_t *item) {
line 847
;845:	monsterDef_t *def;
;846:
;847:	if (item->monsterType <= MONSTER_TYPE_OFF ||
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
LEI4 $286
ADDRLP4 8
INDIRI4
CNSTI4 6
GEI4 $286
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
LTI4 $286
ADDRLP4 16
INDIRI4
CNSTI4 5
LTI4 $282
LABELV $286
line 850
;848:		item->monsterType >= MONSTER_TYPE_RANDOM ||
;849:		item->monsterSlot < 0 ||
;850:		item->monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 851
;851:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 852
;852:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 853
;853:		return;
ADDRGP4 $281
JUMPV
LABELV $282
line 856
;854:	}
;855:
;856:	if (!g_monsterDefLoaded
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
NEI4 $287
line 858
;857:		[item->monsterType]
;858:		[item->monsterSlot]) {
line 859
;859:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 860
;860:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 861
;861:		return;
ADDRGP4 $281
JUMPV
LABELV $287
line 864
;862:	}
;863:
;864:	if (monsterActiveCount >= 8) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $289
line 865
;865:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 866
;866:		return;
ADDRGP4 $281
JUMPV
LABELV $289
line 869
;867:	}
;868:
;869:	def = &g_monsterDefs
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
line 873
;870:		[item->monsterType]
;871:		[item->monsterSlot];
;872:
;873:	if (!G_MonsterSpawnFromItem(item, def)) {
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
NEI4 $292
line 874
;874:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 875
;875:	}
LABELV $292
line 876
;876:}
LABELV $281
endproc G_MonsterRespawnThink 32 8
proc G_MonsterWaveHasPlayers 8 0
line 878
;877:
;878:static qboolean G_MonsterWaveHasPlayers( void ) {
line 882
;879:	gclient_t *client;
;880:	int i;
;881:
;882:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $299
JUMPV
LABELV $296
line 883
;883:		client = &level.clients[i];
ADDRLP4 0
CNSTI4 780
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 885
;884:
;885:		if( client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $301
line 886
;886:			CON_CONNECTED ) {
line 887
;887:			continue;
ADDRGP4 $297
JUMPV
LABELV $301
line 890
;888:		}
;889:
;890:		if( client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $303
line 891
;891:			TEAM_SPECTATOR ) {
line 892
;892:			continue;
ADDRGP4 $297
JUMPV
LABELV $303
line 895
;893:		}
;894:
;895:		if( client->oneLifeEliminated ) {
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $305
line 896
;896:			continue;
ADDRGP4 $297
JUMPV
LABELV $305
line 899
;897:		}
;898:
;899:		if( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $307
line 900
;900:			continue;
ADDRGP4 $297
JUMPV
LABELV $307
line 903
;901:		}
;902:
;903:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $295
JUMPV
LABELV $297
line 882
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $299
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $296
line 906
;904:	}
;905:
;906:	return qfalse;
CNSTI4 0
RETI4
LABELV $295
endproc G_MonsterWaveHasPlayers 8 0
proc G_MonsterWaveLivingCount 12 0
line 909
;907:}
;908:
;909:static int G_MonsterWaveLivingCount( void ) {
line 914
;910:	gentity_t *ent;
;911:	int count;
;912:	int i;
;913:
;914:	count = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 916
;915:
;916:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $313
JUMPV
LABELV $310
line 918
;917:		i < level.num_entities;
;918:		i++ ) {
line 919
;919:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 921
;920:
;921:		if( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $315
line 922
;922:			continue;
ADDRGP4 $311
JUMPV
LABELV $315
line 925
;923:		}
;924:
;925:		if( ent->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $317
line 926
;926:			continue;
ADDRGP4 $311
JUMPV
LABELV $317
line 929
;927:		}
;928:
;929:		if( !ent->monsterWaveSpawn ) {
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
NEI4 $319
line 930
;930:			continue;
ADDRGP4 $311
JUMPV
LABELV $319
line 933
;931:		}
;932:
;933:		if( ent->monsterDead ) {
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $321
line 934
;934:			continue;
ADDRGP4 $311
JUMPV
LABELV $321
line 937
;935:		}
;936:
;937:		count++;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 938
;938:	}
LABELV $311
line 918
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $313
line 917
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $310
line 940
;939:
;940:	return count;
ADDRLP4 8
INDIRI4
RETI4
LABELV $309
endproc G_MonsterWaveLivingCount 12 0
proc G_MonsterWaveSpotSafe 96 28
line 947
;941:}
;942:
;943:static qboolean G_MonsterWaveSpotSafe(
;944:	gentity_t *spot,
;945:	monsterDef_t *def,
;946:	qboolean requireDistance
;947:) {
line 953
;948:	gentity_t *player;
;949:	trace_t trace;
;950:	vec3_t origin;
;951:	int i;
;952:
;953:	if( !spot || !def ) {
ADDRLP4 76
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
EQU4 $326
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
NEU4 $324
LABELV $326
line 954
;954:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $323
JUMPV
LABELV $324
line 957
;955:	}
;956:
;957:	if( SpotWouldTelefrag(spot) ) {
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
EQI4 $327
line 958
;958:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $323
JUMPV
LABELV $327
line 961
;959:	}
;960:
;961:	VectorCopy(spot->s.origin, origin);
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 962
;962:	origin[2] += 9 + def->hoverHeight;
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
line 964
;963:
;964:	trap_Trace(
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
line 974
;965:		&trace,
;966:		origin,
;967:		def->mins,
;968:		def->maxs,
;969:		origin,
;970:		ENTITYNUM_NONE,
;971:		MASK_PLAYERSOLID
;972:	);
;973:
;974:	if( trace.startsolid || trace.allsolid ) {
ADDRLP4 88
CNSTI4 0
ASGNI4
ADDRLP4 20+4
INDIRI4
ADDRLP4 88
INDIRI4
NEI4 $333
ADDRLP4 20
INDIRI4
ADDRLP4 88
INDIRI4
EQI4 $330
LABELV $333
line 975
;975:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $323
JUMPV
LABELV $330
line 978
;976:	}
;977:
;978:	if( !requireDistance ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $334
line 979
;979:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $323
JUMPV
LABELV $334
line 982
;980:	}
;981:
;982:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $339
JUMPV
LABELV $336
line 983
;983:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 985
;984:
;985:		if( !player->client ) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $341
line 986
;986:			continue;
ADDRGP4 $337
JUMPV
LABELV $341
line 989
;987:		}
;988:
;989:		if( player->client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $343
line 990
;990:			CON_CONNECTED ) {
line 991
;991:			continue;
ADDRGP4 $337
JUMPV
LABELV $343
line 994
;992:		}
;993:
;994:		if( player->client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $345
line 995
;995:			TEAM_SPECTATOR ) {
line 996
;996:			continue;
ADDRGP4 $337
JUMPV
LABELV $345
line 999
;997:		}
;998:
;999:		if( player->health <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $347
line 1000
;1000:			continue;
ADDRGP4 $337
JUMPV
LABELV $347
line 1003
;1001:		}
;1002:
;1003:		if( DistanceSquared(
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
GEF4 $349
line 1006
;1004:			spot->s.origin,
;1005:			player->r.currentOrigin
;1006:		) < 256.0f * 256.0f ) {
line 1007
;1007:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $323
JUMPV
LABELV $349
line 1009
;1008:		}
;1009:	}
LABELV $337
line 982
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $339
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $336
line 1011
;1010:
;1011:	return qtrue;
CNSTI4 1
RETI4
LABELV $323
endproc G_MonsterWaveSpotSafe 96 28
proc G_MonsterWaveChooseSpawn 536 12
line 1017
;1012:}
;1013:
;1014:static qboolean G_MonsterWaveChooseSpawn(
;1015:	monsterDef_t *def,
;1016:	vec3_t origin
;1017:) {
line 1023
;1018:	gentity_t *spots[128];
;1019:	gentity_t *spot;
;1020:	int count;
;1021:	int pass;
;1022:
;1023:	for( pass = 0; pass < 2; pass++ ) {
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $352
line 1024
;1024:		count = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1025
;1025:		spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $357
JUMPV
LABELV $356
line 1031
;1026:
;1027:		while( (spot = G_Find(
;1028:			spot,
;1029:			FOFS(classname),
;1030:			"info_player_deathmatch"
;1031:		)) != NULL ) {
line 1032
;1032:			if( !G_MonsterWaveSpotSafe(
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $363
ADDRLP4 524
CNSTI4 1
ASGNI4
ADDRGP4 $364
JUMPV
LABELV $363
ADDRLP4 524
CNSTI4 0
ASGNI4
LABELV $364
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
NEI4 $360
line 1036
;1033:				spot,
;1034:				def,
;1035:				pass == 0
;1036:			) ) {
line 1037
;1037:				continue;
ADDRGP4 $357
JUMPV
LABELV $360
line 1040
;1038:			}
;1039:
;1040:			spots[count++] = spot;
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
line 1042
;1041:
;1042:			if( count >= 128 ) {
ADDRLP4 4
INDIRI4
CNSTI4 128
LTI4 $365
line 1043
;1043:				break;
ADDRGP4 $358
JUMPV
LABELV $365
line 1045
;1044:			}
;1045:		}
LABELV $357
line 1027
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $359
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
NEU4 $356
LABELV $358
line 1047
;1046:
;1047:		if( count > 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LEI4 $367
line 1048
;1048:			spot = spots[rand() % count];
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
line 1050
;1049:
;1050:			VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1055
;1051:				spot->s.origin,
;1052:				origin
;1053:			);
;1054:
;1055:			origin[2] += 9;
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
line 1056
;1056:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $351
JUMPV
LABELV $367
line 1058
;1057:		}
;1058:	}
LABELV $353
line 1023
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 2
LTI4 $352
line 1060
;1059:
;1060:	return qfalse;
CNSTI4 0
RETI4
LABELV $351
endproc G_MonsterWaveChooseSpawn 536 12
proc G_MonsterWaveBegin 8 8
line 1063
;1061:}
;1062:
;1063:static void G_MonsterWaveBegin( void ) {
line 1064
;1064:	monsterWaveActive = qtrue;
ADDRGP4 monsterWaveActive
CNSTI4 1
ASGNI4
line 1065
;1065:	monsterWaveCombatStarted = qtrue;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 1
ASGNI4
line 1066
;1066:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 1067
;1067:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1068
;1068:	monsterWaveNextSpawn = level.time;
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1069
;1069:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1071
;1070:
;1071:	trap_SendServerCommand(
ADDRGP4 $372
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
line 1079
;1072:		-1,
;1073:		va(
;1074:			"cp \"Wave %i\n\"",
;1075:			monsterCurrentWave
;1076:		)
;1077:	);
;1078:
;1079:	trap_SendServerCommand(
ADDRGP4 $373
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
line 1087
;1080:		-1,
;1081:		va(
;1082:			"print \"Monster Hunt: wave %i started.\n\"",
;1083:			monsterCurrentWave
;1084:		)
;1085:	);
;1086:
;1087:	G_Printf(
ADDRGP4 $374
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 1091
;1088:		"Monster Hunt: wave %i started.\n",
;1089:		monsterCurrentWave
;1090:	);
;1091:}
LABELV $369
endproc G_MonsterWaveBegin 8 8
proc G_MonsterWaveComplete 8 8
line 1093
;1092:
;1093:static void G_MonsterWaveComplete( void ) {
line 1094
;1094:	trap_SendServerCommand(
ADDRGP4 $376
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
line 1102
;1095:		-1,
;1096:		va(
;1097:			"print \"Monster Hunt: wave %i cleared.\n\"",
;1098:			monsterCurrentWave
;1099:		)
;1100:	);
;1101:
;1102:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 1104
;1103:
;1104:	if( monsterCurrentWave <
ADDRGP4 monsterCurrentWave
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
GEI4 $377
line 1105
;1105:		monsterWaveFinal ) {
line 1106
;1106:		monsterCurrentWave++;
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
line 1108
;1107:
;1108:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1112
;1109:			level.time +
;1110:			monsterWaveDelay;
;1111:
;1112:		return;
ADDRGP4 $375
JUMPV
LABELV $377
line 1119
;1113:	}
;1114:
;1115:	/*
;1116:	 * Classic Monster Hunt repeats the final wave until
;1117:	 * fraglimit or timelimit ends the match.
;1118:	 */
;1119:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 1
NEI4 $380
line 1120
;1120:		MONSTER_HUNT_CLASSIC ) {
line 1121
;1121:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1125
;1122:			level.time +
;1123:			monsterWaveDelay;
;1124:
;1125:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $384
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1130
;1126:			-1,
;1127:			"print \"Monster Hunt: final wave restarting.\n\""
;1128:		);
;1129:
;1130:		return;
ADDRGP4 $375
JUMPV
LABELV $380
line 1136
;1131:	}
;1132:
;1133:	/*
;1134:	 * One Life ends after clearing the final wave.
;1135:	 */
;1136:	monsterWaveFinished = qtrue;
ADDRGP4 monsterWaveFinished
CNSTI4 1
ASGNI4
line 1138
;1137:
;1138:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $385
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1143
;1139:		-1,
;1140:		"cp \"Monster Hunt completed!\n\""
;1141:	);
;1142:
;1143:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $386
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1148
;1144:		-1,
;1145:		"print \"Monster Hunt: all waves cleared.\n\""
;1146:	);
;1147:
;1148:	LogExit(
ADDRGP4 $387
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1151
;1149:		"Monster Hunt completed."
;1150:	);
;1151:}
LABELV $375
endproc G_MonsterWaveComplete 8 8
proc G_MonsterWaveRelocateStuck 48 12
line 1153
;1152:
;1153:static int G_MonsterWaveRelocateStuck( void ) {
line 1160
;1154:	gentity_t *monster;
;1155:	monsterDef_t *def;
;1156:	vec3_t origin;
;1157:	int relocated;
;1158:	int i;
;1159:
;1160:	relocated = 0;
ADDRLP4 24
CNSTI4 0
ASGNI4
line 1162
;1161:
;1162:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $392
JUMPV
LABELV $389
line 1164
;1163:		i < level.num_entities;
;1164:		i++ ) {
line 1165
;1165:		monster = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1167
;1166:
;1167:		if( !monster->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $394
line 1168
;1168:			continue;
ADDRGP4 $390
JUMPV
LABELV $394
line 1171
;1169:		}
;1170:
;1171:		if( monster->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $396
line 1172
;1172:			continue;
ADDRGP4 $390
JUMPV
LABELV $396
line 1175
;1173:		}
;1174:
;1175:		if( !monster->monsterWaveSpawn ||
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
EQI4 $400
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $398
LABELV $400
line 1176
;1176:			monster->monsterDead ) {
line 1177
;1177:			continue;
ADDRGP4 $390
JUMPV
LABELV $398
line 1184
;1178:		}
;1179:
;1180:		/*
;1181:		 * Relocate only monsters that have neither moved,
;1182:		 * fired nor received damage for the timeout period.
;1183:		 */
;1184:		if( level.time -
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
GEI4 $401
line 1186
;1185:			monster->monsterProgressTime <
;1186:			monsterWaveTimeout ) {
line 1187
;1187:			continue;
ADDRGP4 $390
JUMPV
LABELV $401
line 1190
;1188:		}
;1189:
;1190:		def = &g_monsterDefs
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
line 1194
;1191:			[monster->monsterType]
;1192:			[monster->monsterSlot];
;1193:
;1194:		if( !G_MonsterWaveChooseSpawn(
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
NEI4 $404
line 1197
;1195:			def,
;1196:			origin
;1197:		) ) {
line 1198
;1198:			continue;
ADDRGP4 $390
JUMPV
LABELV $404
line 1205
;1199:		}
;1200:
;1201:		/*
;1202:		 * ChooseSpawn returns the base position.
;1203:		 * Apply the monster's configured hovering height.
;1204:		 */
;1205:		origin[2] += def->hoverHeight;
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
line 1207
;1206:
;1207:		G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1212
;1208:			monster,
;1209:			origin
;1210:		);
;1211:
;1212:		monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1215
;1213:			level.time;
;1214:
;1215:		VectorCopy(
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
line 1220
;1216:			monster->r.currentOrigin,
;1217:			monster->monsterProgressOrigin
;1218:		);
;1219:
;1220:		monster->enemy = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 768
ADDP4
CNSTP4 0
ASGNP4
line 1221
;1221:		monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 1222
;1222:		monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1224
;1223:			level.time + 500;
;1224:		monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1227
;1225:			level.time;
;1226:
;1227:		G_MonsterSetAnimation(
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
line 1233
;1228:			monster,
;1229:			MONSTER_STATE_MOVE,
;1230:			0
;1231:		);
;1232:
;1233:		trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1234
;1234:		relocated++;
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1235
;1235:	}
LABELV $390
line 1164
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $392
line 1163
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $389
line 1237
;1236:
;1237:	return relocated;
ADDRLP4 24
INDIRI4
RETI4
LABELV $388
endproc G_MonsterWaveRelocateStuck 48 12
export G_MonsterRunFrame
proc G_MonsterRunFrame 60 16
line 1240
;1238:}
;1239:
;1240:void G_MonsterRunFrame( void ) {
line 1247
;1241:	monsterWaveDef_t *wave;
;1242:	monsterWaveEntry_t *entry;
;1243:	monsterDef_t *def;
;1244:	vec3_t origin;
;1245:	int living;
;1246:
;1247:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
NEI4 $411
line 1248
;1248:		MONSTER_HUNT_OFF ) {
line 1249
;1249:		return;
ADDRGP4 $410
JUMPV
LABELV $411
line 1252
;1250:	}
;1251:
;1252:	if( !monsterWavesLoaded ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 monsterWavesLoaded
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $416
ADDRGP4 monsterWaveFinished
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $414
LABELV $416
line 1253
;1253:		monsterWaveFinished ) {
line 1254
;1254:		return;
ADDRGP4 $410
JUMPV
LABELV $414
line 1257
;1255:	}
;1256:
;1257:	if( level.intermissiontime ||
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 level+9128
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $423
ADDRGP4 level+9124
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $423
ADDRGP4 level+16
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $417
LABELV $423
line 1259
;1258:		level.intermissionQueued ||
;1259:		level.warmupTime ) {
line 1260
;1260:		return;
ADDRGP4 $410
JUMPV
LABELV $417
line 1263
;1261:	}
;1262:
;1263:	if( !G_MonsterWaveHasPlayers() ) {
ADDRLP4 36
ADDRGP4 G_MonsterWaveHasPlayers
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $424
line 1264
;1264:		return;
ADDRGP4 $410
JUMPV
LABELV $424
line 1267
;1265:	}
;1266:
;1267:	if( !monsterWaveStarted ) {
ADDRGP4 monsterWaveStarted
INDIRI4
CNSTI4 0
NEI4 $426
line 1268
;1268:		monsterWaveStarted = qtrue;
ADDRGP4 monsterWaveStarted
CNSTI4 1
ASGNI4
line 1269
;1269:		monsterCurrentWave = 1;
ADDRGP4 monsterCurrentWave
CNSTI4 1
ASGNI4
line 1270
;1270:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1273
;1271:			level.time + monsterWaveDelay;
;1272:
;1273:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $429
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1278
;1274:			-1,
;1275:			"print \"Monster Hunt begins.\n\""
;1276:		);
;1277:
;1278:		return;
ADDRGP4 $410
JUMPV
LABELV $426
line 1281
;1279:	}
;1280:
;1281:	if( !monsterWaveActive ) {
ADDRGP4 monsterWaveActive
INDIRI4
CNSTI4 0
NEI4 $430
line 1282
;1282:		if( level.time >= monsterWaveNextStart ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextStart
INDIRI4
LTI4 $410
line 1283
;1283:			G_MonsterWaveBegin();
ADDRGP4 G_MonsterWaveBegin
CALLV
pop
line 1284
;1284:		}
line 1286
;1285:
;1286:		return;
ADDRGP4 $410
JUMPV
LABELV $430
line 1289
;1287:	}
;1288:
;1289:	wave =
ADDRLP4 0
CNSTI4 104
ADDRGP4 monsterCurrentWave
INDIRI4
MULI4
ADDRGP4 monsterWaves-104
ADDP4
ASGNP4
ADDRGP4 $437
JUMPV
LABELV $436
line 1293
;1290:		&monsterWaves[monsterCurrentWave - 1];
;1291:
;1292:	while( monsterWaveEntry <
;1293:		wave->numEntries ) {
line 1294
;1294:		entry =
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1297
;1295:			&wave->entries[monsterWaveEntry];
;1296:
;1297:		if( monsterWaveEntrySpawned <
ADDRGP4 monsterWaveEntrySpawned
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
GEI4 $439
line 1298
;1298:			entry->count ) {
line 1299
;1299:			break;
ADDRGP4 $438
JUMPV
LABELV $439
line 1302
;1300:		}
;1301:
;1302:		monsterWaveEntry++;
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
line 1303
;1303:		monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1304
;1304:	}
LABELV $437
line 1292
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $436
LABELV $438
line 1306
;1305:
;1306:	living = G_MonsterWaveLivingCount();
ADDRLP4 40
ADDRGP4 G_MonsterWaveLivingCount
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 40
INDIRI4
ASGNI4
line 1312
;1307:
;1308:	/*
;1309:	 * Every configured monster has been spawned.
;1310:	 * Complete the wave after the last living monster dies.
;1311:	 */
;1312:	if( monsterWaveEntry >=
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $441
line 1313
;1313:		wave->numEntries ) {
line 1314
;1314:		if( living == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $443
line 1315
;1315:			G_MonsterWaveComplete();
ADDRGP4 G_MonsterWaveComplete
CALLV
pop
line 1316
;1316:			return;
ADDRGP4 $410
JUMPV
LABELV $443
line 1319
;1317:		}
;1318:
;1319:		if( level.time - monsterWaveLastProgress >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveLastProgress
INDIRI4
SUBI4
ADDRGP4 monsterWaveTimeout
INDIRI4
LTI4 $410
line 1320
;1320:			monsterWaveTimeout ) {
line 1323
;1321:			int relocated;
;1322:
;1323:			relocated =
ADDRLP4 48
ADDRGP4 G_MonsterWaveRelocateStuck
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 48
INDIRI4
ASGNI4
line 1326
;1324:				G_MonsterWaveRelocateStuck();
;1325:
;1326:			monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1342
;1327:
;1328:			/*trap_SendServerCommand(
;1329:				-1,
;1330:				va(
;1331:					"print \"Monster Hunt: relocated %i lost monsters.\n\"",
;1332:					relocated
;1333:				)
;1334:			);
;1335:
;1336:			G_Printf(
;1337:				"Monster Hunt: wave %i still has %i living monsters; relocated %i.\n",
;1338:				monsterCurrentWave,
;1339:				living,
;1340:				relocated
;1341:			);*/
;1342:		}
line 1344
;1343:
;1344:		return;
ADDRGP4 $410
JUMPV
LABELV $441
line 1347
;1345:	}
;1346:
;1347:	if( living >= monsterWaveMaxActive ) {
ADDRLP4 12
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $449
line 1348
;1348:		return;
ADDRGP4 $410
JUMPV
LABELV $449
line 1351
;1349:	}
;1350:
;1351:	if( level.time < monsterWaveNextSpawn ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextSpawn
INDIRI4
GEI4 $451
line 1352
;1352:		return;
ADDRGP4 $410
JUMPV
LABELV $451
line 1355
;1353:	}
;1354:
;1355:	entry = &wave->entries[monsterWaveEntry];
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1357
;1356:
;1357:	def = &g_monsterDefs
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
line 1361
;1358:		[entry->monsterType]
;1359:		[entry->monsterSlot];
;1360:
;1361:	if( !G_MonsterWaveChooseSpawn(
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
NEI4 $454
line 1364
;1362:		def,
;1363:		origin
;1364:	) ) {
line 1365
;1365:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 1367
;1366:			level.time + 1000;
;1367:		return;
ADDRGP4 $410
JUMPV
LABELV $454
line 1370
;1368:	}
;1369:
;1370:	if( G_MonsterSpawnAtOrigin(
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
EQI4 $457
line 1375
;1371:		NULL,
;1372:		def,
;1373:		origin,
;1374:		qtrue
;1375:	) ) {
line 1376
;1376:	monsterWaveEntrySpawned++;
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
line 1377
;1377:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1379
;1378:
;1379:	monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
ADDI4
ASGNI4
line 1382
;1380:		level.time +
;1381:			monsterWaveSpawnInterval;
;1382:	}
ADDRGP4 $458
JUMPV
LABELV $457
line 1383
;1383:	else {
line 1384
;1384:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1386
;1385:			level.time + 500;
;1386:	}
LABELV $458
line 1387
;1387:}
LABELV $410
endproc G_MonsterRunFrame 60 16
export G_MonsterTryReplaceItem
proc G_MonsterTryReplaceItem 0 0
line 1391
;1388:
;1389:qboolean G_MonsterTryReplaceItem(
;1390:	gentity_t *item
;1391:) {
line 1396
;1392:	/*
;1393:	 * Both Monster Hunt modes now receive monsters
;1394:	 * exclusively from the wave controller.
;1395:	 */
;1396:	return qfalse;
CNSTI4 0
RETI4
LABELV $462
endproc G_MonsterTryReplaceItem 0 0
proc G_MonsterFindTarget 28 8
line 1399
;1397:}
;1398:
;1399:static gentity_t *G_MonsterFindTarget(gentity_t *monster) {
line 1405
;1400:	gentity_t *player;
;1401:	gentity_t *best;
;1402:	float bestDistance;
;1403:	int i;
;1404:
;1405:	best = NULL;
ADDRLP4 12
CNSTP4 0
ASGNP4
line 1406
;1406:	bestDistance = 99999999.0f;
ADDRLP4 8
CNSTF4 1287568416
ASGNF4
line 1408
;1407:
;1408:	for (i = 0; i < level.maxclients; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $467
JUMPV
LABELV $464
line 1411
;1409:		float distance;
;1410:
;1411:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1413
;1412:
;1413:		if (!player->client) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $469
line 1414
;1414:			continue;
ADDRGP4 $465
JUMPV
LABELV $469
line 1417
;1415:		}
;1416:
;1417:		if (player->client->pers.connected != CON_CONNECTED) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $471
line 1418
;1418:			continue;
ADDRGP4 $465
JUMPV
LABELV $471
line 1421
;1419:		}
;1420:
;1421:		if (player->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $473
line 1422
;1422:			continue;
ADDRGP4 $465
JUMPV
LABELV $473
line 1425
;1423:		}
;1424:
;1425:		if (player->health <= 0) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $475
line 1426
;1426:			continue;
ADDRGP4 $465
JUMPV
LABELV $475
line 1429
;1427:		}
;1428:
;1429:		distance = DistanceSquared(
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
line 1434
;1430:			monster->r.currentOrigin,
;1431:			player->r.currentOrigin
;1432:		);
;1433:
;1434:		if (distance < bestDistance) {
ADDRLP4 16
INDIRF4
ADDRLP4 8
INDIRF4
GEF4 $477
line 1435
;1435:			bestDistance = distance;
ADDRLP4 8
ADDRLP4 16
INDIRF4
ASGNF4
line 1436
;1436:			best = player;
ADDRLP4 12
ADDRLP4 0
INDIRP4
ASGNP4
line 1437
;1437:		}
LABELV $477
line 1438
;1438:	}
LABELV $465
line 1408
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $467
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $464
line 1440
;1439:
;1440:	return best;
ADDRLP4 12
INDIRP4
RETP4
LABELV $463
endproc G_MonsterFindTarget 28 8
proc G_MonsterAnimation 16 0
line 1446
;1441:}
;1442:
;1443:static animation_t *G_MonsterAnimation(
;1444:	gentity_t *monster,
;1445:	monsterDef_t *def
;1446:) {
line 1449
;1447:	int variant;
;1448:
;1449:	variant = monster->monsterAnimationVariant;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
INDIRI4
ASGNI4
line 1451
;1450:
;1451:	if (variant < 0 || variant >= MAX_MONSTER_VARIANTS) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $482
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $480
LABELV $482
line 1452
;1452:		variant = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1453
;1453:	}
LABELV $480
line 1455
;1454:
;1455:	switch (monster->monsterAnimation) {
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
LTI4 $483
ADDRLP4 8
INDIRI4
CNSTI4 5
GTI4 $483
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $492
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $492
address $486
address $487
address $488
address $489
address $490
address $491
code
LABELV $486
line 1457
;1456:	case MONSTER_STATE_IDLE:
;1457:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 716
ADDP4
RETP4
ADDRGP4 $479
JUMPV
LABELV $487
line 1460
;1458:
;1459:	case MONSTER_STATE_MOVE:
;1460:		return &def->moveAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 744
ADDP4
RETP4
ADDRGP4 $479
JUMPV
LABELV $488
line 1463
;1461:
;1462:	case MONSTER_STATE_MELEE:
;1463:		return &def->meleeAnimations[variant];
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
ADDRGP4 $479
JUMPV
LABELV $489
line 1466
;1464:
;1465:	case MONSTER_STATE_RANGED:
;1466:		return &def->rangedAnimations[variant];
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
ADDRGP4 $479
JUMPV
LABELV $490
line 1469
;1467:
;1468:	case MONSTER_STATE_PAIN:
;1469:		return &def->painAnimations[variant];
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
ADDRGP4 $479
JUMPV
LABELV $491
line 1472
;1470:
;1471:	case MONSTER_STATE_DEATH:
;1472:		return &def->deathAnimations[variant];
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
ADDRGP4 $479
JUMPV
LABELV $483
line 1475
;1473:
;1474:	default:
;1475:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 716
ADDP4
RETP4
LABELV $479
endproc G_MonsterAnimation 16 0
proc G_MonsterSetAnimation 0 0
line 1483
;1476:	}
;1477:}
;1478:
;1479:static void G_MonsterSetAnimation(
;1480:	gentity_t *monster,
;1481:	int animation,
;1482:	int variant
;1483:) {
line 1484
;1484:	monster->monsterAnimation = animation;
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
ADDRFP4 4
INDIRI4
ASGNI4
line 1485
;1485:	monster->monsterAnimationVariant = variant;
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 1486
;1486:	monster->monsterAnimationStart = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 836
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1487
;1487:}
LABELV $493
endproc G_MonsterSetAnimation 0 0
proc G_MonsterUpdateAnimation 36 12
line 1492
;1488:
;1489:static void G_MonsterUpdateAnimation(
;1490:	gentity_t *monster,
;1491:	monsterDef_t *def
;1492:) {
line 1497
;1493:	animation_t *animation;
;1494:	int elapsed;
;1495:	int frame;
;1496:
;1497:	animation = G_MonsterAnimation(monster, def);
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
line 1499
;1498:
;1499:	if (animation->numFrames <= 0 ||
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
LEI4 $498
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
GTI4 $496
LABELV $498
line 1500
;1500:		animation->frameLerp <= 0) {
line 1501
;1501:		return;
ADDRGP4 $495
JUMPV
LABELV $496
line 1504
;1502:	}
;1503:
;1504:	elapsed = level.time - monster->monsterAnimationStart;
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
line 1505
;1505:	frame = elapsed / animation->frameLerp;
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
line 1507
;1506:
;1507:	if (frame >= animation->numFrames) {
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
LTI4 $500
line 1508
;1508:		if (animation->loopFrames > 0) {
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
LEI4 $502
line 1509
;1509:			frame =
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
line 1514
;1510:				animation->numFrames -
;1511:				animation->loopFrames +
;1512:				(frame - animation->numFrames) %
;1513:				animation->loopFrames;
;1514:		}
ADDRGP4 $503
JUMPV
LABELV $502
line 1515
;1515:		else {
line 1516
;1516:			frame = animation->numFrames - 1;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1518
;1517:
;1518:		if( monster->monsterAnimation ==
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
EQI4 $506
ADDRLP4 24
INDIRI4
CNSTI4 3
EQI4 $507
ADDRLP4 24
INDIRI4
CNSTI4 2
NEI4 $504
LABELV $507
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $504
LABELV $506
line 1524
;1519:				MONSTER_STATE_PAIN ||
;1520:			((monster->monsterAnimation ==
;1521:					MONSTER_STATE_RANGED ||
;1522:			  monster->monsterAnimation ==
;1523:					MONSTER_STATE_MELEE) &&
;1524:			 monster->monsterShotsRemaining <= 0) ) {
line 1525
;1525:				G_MonsterSetAnimation(
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
line 1531
;1526:					monster,
;1527:					MONSTER_STATE_IDLE,
;1528:					0
;1529:				);
;1530:
;1531:				animation = &def->idleAnimation;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 716
ADDP4
ASGNP4
line 1532
;1532:				frame = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1533
;1533:			}
LABELV $504
line 1534
;1534:		}
LABELV $503
line 1535
;1535:	}
LABELV $500
line 1537
;1536:
;1537:	monster->s.frame =
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
line 1539
;1538:		animation->firstFrame + frame;
;1539:}
LABELV $495
endproc G_MonsterUpdateAnimation 36 12
proc G_MonsterGroundWalker 88 28
line 1545
;1540:
;1541:static void G_MonsterGroundWalker(
;1542:	gentity_t *monster,
;1543:	monsterDef_t *def,
;1544:	int msec
;1545:) {
line 1550
;1546:	trace_t trace;
;1547:	vec3_t destination;
;1548:	float fallDistance;
;1549:
;1550:	if( def->movementType !=
ADDRFP4 4
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
EQI4 $509
line 1551
;1551:		MONSTER_MOVEMENT_WALKING ) {
line 1552
;1552:		return;
ADDRGP4 $508
JUMPV
LABELV $509
line 1555
;1553:	}
;1554:
;1555:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1560
;1556:		monster->r.currentOrigin,
;1557:		destination
;1558:	);
;1559:
;1560:	destination[2] -= 64;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 1562
;1561:
;1562:	trap_Trace(
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
line 1572
;1563:		&trace,
;1564:		monster->r.currentOrigin,
;1565:		monster->r.mins,
;1566:		monster->r.maxs,
;1567:		destination,
;1568:		monster->s.number,
;1569:		MASK_PLAYERSOLID
;1570:	);
;1571:
;1572:	if( !trace.startsolid &&
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $512
ADDRLP4 0
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $512
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $512
line 1574
;1573:		!trace.allsolid &&
;1574:		trace.fraction < 1.0f ) {
line 1575
;1575:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1580
;1576:			monster,
;1577:			trace.endpos
;1578:		);
;1579:
;1580:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1583
;1581:			trace.entityNum;
;1582:
;1583:		return;
ADDRGP4 $508
JUMPV
LABELV $512
line 1589
;1584:	}
;1585:
;1586:	/*
;1587:	 * No nearby floor: apply simple falling movement.
;1588:	 */
;1589:	fallDistance =
ADDRLP4 68
CNSTF4 1137180672
ADDRFP4 8
INDIRI4
CVIF4 4
MULF4
CNSTF4 1148846080
DIVF4
ASGNF4
line 1592
;1590:		400.0f * msec / 1000.0f;
;1591:
;1592:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1597
;1593:		monster->r.currentOrigin,
;1594:		destination
;1595:	);
;1596:
;1597:	destination[2] -= fallDistance;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
ADDRLP4 68
INDIRF4
SUBF4
ASGNF4
line 1599
;1598:
;1599:	trap_Trace(
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
line 1609
;1600:		&trace,
;1601:		monster->r.currentOrigin,
;1602:		monster->r.mins,
;1603:		monster->r.maxs,
;1604:		destination,
;1605:		monster->s.number,
;1606:		MASK_PLAYERSOLID
;1607:	);
;1608:
;1609:	if( !trace.startsolid &&
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $519
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $519
line 1610
;1610:		!trace.allsolid ) {
line 1611
;1611:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1615
;1612:			monster,
;1613:			trace.endpos
;1614:		);
;1615:	}
LABELV $519
line 1617
;1616:
;1617:	if( trace.fraction < 1.0f ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $523
line 1618
;1618:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1620
;1619:			trace.entityNum;
;1620:	}
ADDRGP4 $524
JUMPV
LABELV $523
line 1621
;1621:	else {
line 1622
;1622:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 1624
;1623:			ENTITYNUM_NONE;
;1624:	}
LABELV $524
line 1625
;1625:}
LABELV $508
endproc G_MonsterGroundWalker 88 28
proc G_MonsterFaceTarget 52 8
line 1630
;1626:
;1627:static void G_MonsterFaceTarget(
;1628:	gentity_t *monster,
;1629:	gentity_t *target
;1630:) {
line 1634
;1631:	vec3_t direction;
;1632:	vec3_t angles;
;1633:
;1634:	if( !monster || !target ) {
ADDRLP4 24
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
EQU4 $530
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
NEU4 $528
LABELV $530
line 1635
;1635:		return;
ADDRGP4 $527
JUMPV
LABELV $528
line 1638
;1636:	}
;1637:
;1638:	VectorSubtract(
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
line 1644
;1639:		target->r.currentOrigin,
;1640:		monster->r.currentOrigin,
;1641:		direction
;1642:	);
;1643:
;1644:	if( VectorNormalize(direction) <= 0.0f ) {
ADDRLP4 12
ARGP4
ADDRLP4 48
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 48
INDIRF4
CNSTF4 0
GTF4 $533
line 1645
;1645:		return;
ADDRGP4 $527
JUMPV
LABELV $533
line 1648
;1646:	}
;1647:
;1648:	vectoangles(direction, angles);
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1649
;1649:	angles[PITCH] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1650
;1650:	angles[ROLL] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1652
;1651:
;1652:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1653
;1653:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1654
;1654:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1655
;1655:}
LABELV $527
endproc G_MonsterFaceTarget 52 8
proc G_MonsterMove 324 28
line 1663
;1656:
;1657:
;1658:static void G_MonsterMove(
;1659:	gentity_t *monster,
;1660:	gentity_t *target,
;1661:	monsterDef_t *def,
;1662:	int msec
;1663:) {
line 1682
;1664:	trace_t trace;
;1665:	trace_t slideTrace;
;1666:	vec3_t targetOrigin;
;1667:	vec3_t direction;
;1668:	vec3_t right;
;1669:	vec3_t wishDirection;
;1670:	vec3_t velocity;
;1671:	vec3_t move;
;1672:	vec3_t destination;
;1673:	vec3_t slideMove;
;1674:	vec3_t slideDestination;
;1675:	vec3_t angles;
;1676:	float phase;
;1677:	float drift;
;1678:	float distance;
;1679:	float dot;
;1680:	qboolean shouldMove;
;1681:
;1682:	VectorCopy(
ADDRLP4 128
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1687
;1683:		target->r.currentOrigin,
;1684:		targetOrigin
;1685:	);
;1686:
;1687:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $537
line 1688
;1688:		MONSTER_MOVEMENT_WALKING ) {
line 1692
;1689:		/*
;1690:		 * Walking monsters chase only horizontally.
;1691:		 */
;1692:		targetOrigin[2] =
ADDRLP4 128+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ASGNF4
line 1694
;1693:			monster->r.currentOrigin[2];
;1694:	}
ADDRGP4 $538
JUMPV
LABELV $537
line 1695
;1695:	else {
line 1696
;1696:		targetOrigin[2] += 16;
ADDRLP4 128+8
ADDRLP4 128+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 1697
;1697:	}
LABELV $538
line 1699
;1698:
;1699:	VectorSubtract(
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
line 1705
;1700:		targetOrigin,
;1701:		monster->r.currentOrigin,
;1702:		direction
;1703:	);
;1704:
;1705:	distance = VectorNormalize(direction);
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
line 1707
;1706:
;1707:	if (distance <= 0.0f) {
ADDRLP4 168
INDIRF4
CNSTF4 0
GTF4 $545
line 1708
;1708:		return;
ADDRGP4 $536
JUMPV
LABELV $545
line 1714
;1709:	}
;1710:	/*
;1711:	 * A nearby target behind a wall is not yet a valid
;1712:	 * firing position, so continue moving toward it.
;1713:	 */
;1714:	shouldMove =
ADDRLP4 168
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 648
ADDP4
INDIRF4
GTF4 $550
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
NEI4 $548
LABELV $550
ADDRLP4 260
CNSTI4 1
ASGNI4
ADDRGP4 $549
JUMPV
LABELV $548
ADDRLP4 260
CNSTI4 0
ASGNI4
LABELV $549
ADDRLP4 172
ADDRLP4 260
INDIRI4
ASGNI4
line 1725
;1715:		distance > def->attackRange ||
;1716:		!G_MonsterCanSeeTarget(
;1717:			monster,
;1718:			target
;1719:		);
;1720:	
;1721:	/*
;1722:	 * Switch between standing and movement animations
;1723:	 * without interrupting attacks, pain or death.
;1724:	 */
;1725:	if( monster->monsterAnimation ==
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
EQI4 $553
ADDRLP4 268
INDIRI4
CNSTI4 1
NEI4 $551
LABELV $553
line 1728
;1726:			MONSTER_STATE_IDLE ||
;1727:		monster->monsterAnimation ==
;1728:			MONSTER_STATE_MOVE ) {
line 1729
;1729:		if( shouldMove ||
ADDRLP4 172
INDIRI4
CNSTI4 0
NEI4 $556
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $554
LABELV $556
line 1731
;1730:			def->movePattern ==
;1731:				MONSTER_PATTERN_DRIFT ) {
line 1732
;1732:			if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
EQI4 $555
line 1733
;1733:				MONSTER_STATE_MOVE ) {
line 1734
;1734:				G_MonsterSetAnimation(
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
line 1739
;1735:					monster,
;1736:					MONSTER_STATE_MOVE,
;1737:					0
;1738:				);
;1739:			}
line 1740
;1740:		}
ADDRGP4 $555
JUMPV
LABELV $554
line 1741
;1741:		else if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 0
EQI4 $559
line 1742
;1742:			MONSTER_STATE_IDLE ) {
line 1743
;1743:			G_MonsterSetAnimation(
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
line 1748
;1744:				monster,
;1745:				MONSTER_STATE_IDLE,
;1746:				0
;1747:			);
;1748:		}
LABELV $559
LABELV $555
line 1749
;1749:	}
LABELV $551
line 1751
;1750:
;1751:	VectorSet(
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
line 1758
;1752:		right,
;1753:		-direction[1],
;1754:		direction[0],
;1755:		0
;1756:	);
;1757:
;1758:	if (VectorNormalize(right) <= 0.0f) {
ADDRLP4 104
ARGP4
ADDRLP4 272
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 272
INDIRF4
CNSTF4 0
GTF4 $564
line 1759
;1759:		VectorSet(right, 1, 0, 0);
ADDRLP4 104
CNSTF4 1065353216
ASGNF4
ADDRLP4 104+4
CNSTF4 0
ASGNF4
ADDRLP4 104+8
CNSTF4 0
ASGNF4
line 1760
;1760:	}
LABELV $564
line 1762
;1761:
;1762:	drift = 0.0f;
ADDRLP4 164
CNSTF4 0
ASGNF4
line 1764
;1763:
;1764:	if (def->movePattern == MONSTER_PATTERN_DRIFT &&
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
NEI4 $568
ADDRLP4 276
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
CNSTI4 0
LEI4 $568
line 1765
;1765:		def->driftPeriod > 0) {
line 1766
;1766:		phase =
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
line 1770
;1767:			(level.time % def->driftPeriod) /
;1768:			(float)def->driftPeriod;
;1769:
;1770:		phase *= 6.2831853f;
ADDRLP4 176
CNSTF4 1086918619
ADDRLP4 176
INDIRF4
MULF4
ASGNF4
line 1771
;1771:		phase += monster->monsterDriftPhase;
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
line 1773
;1772:
;1773:		drift =
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
line 1776
;1774:			sin(phase) *
;1775:			def->driftAmount;
;1776:	}
LABELV $568
line 1778
;1777:
;1778:	VectorClear(velocity);
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
line 1780
;1779:
;1780:	if (shouldMove) {
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $573
line 1781
;1781:		VectorCopy(direction, wishDirection);
ADDRLP4 140
ADDRLP4 80
INDIRB
ASGNB 12
line 1783
;1782:
;1783:		if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $575
line 1784
;1784:			MONSTER_PATTERN_DRIFT) {
line 1785
;1785:			VectorMA(
ADDRLP4 140
ADDRLP4 140
INDIRF4
ADDRLP4 104
INDIRF4
ADDRLP4 164
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 140+4
INDIRF4
ADDRLP4 104+4
INDIRF4
ADDRLP4 164
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 140+8
INDIRF4
ADDRLP4 104+8
INDIRF4
ADDRLP4 164
INDIRF4
MULF4
ADDF4
ASGNF4
line 1791
;1786:				wishDirection,
;1787:				drift,
;1788:				right,
;1789:				wishDirection
;1790:			);
;1791:		}
LABELV $575
line 1793
;1792:
;1793:		if (VectorNormalize(wishDirection) <= 0.0f) {
ADDRLP4 140
ARGP4
ADDRLP4 284
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 284
INDIRF4
CNSTF4 0
GTF4 $583
line 1794
;1794:			return;
ADDRGP4 $536
JUMPV
LABELV $583
line 1797
;1795:		}
;1796:
;1797:		VectorScale(
ADDRLP4 288
ADDRFP4 8
INDIRP4
CNSTI4 600
ADDP4
ASGNP4
ADDRLP4 68
ADDRLP4 140
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 68+4
ADDRLP4 140+4
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 68+8
ADDRLP4 140+8
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 600
ADDP4
INDIRF4
MULF4
ASGNF4
line 1802
;1798:			wishDirection,
;1799:			def->speed,
;1800:			velocity
;1801:		);
;1802:	}
ADDRGP4 $574
JUMPV
LABELV $573
line 1803
;1803:	else if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $536
line 1804
;1804:		MONSTER_PATTERN_DRIFT) {
line 1810
;1805:		/*
;1806:		 * Inside attack range, smoothly strafe.
;1807:		 * Do not normalize this vector: driftAmount must
;1808:		 * affect the actual lateral speed.
;1809:		 */
;1810:		VectorScale(
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
line 1815
;1811:			right,
;1812:			drift * def->speed,
;1813:			velocity
;1814:		);
;1815:	}
line 1816
;1816:	else {
line 1817
;1817:		return;
LABELV $590
LABELV $574
line 1820
;1818:	}
;1819:
;1820:	VectorScale(
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
line 1826
;1821:		velocity,
;1822:		msec / 1000.0f,
;1823:		move
;1824:	);
;1825:
;1826:	if (VectorLengthSquared(move) <= 0.0001f) {
ADDRLP4 56
ARGP4
ADDRLP4 288
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 288
INDIRF4
CNSTF4 953267991
GTF4 $599
line 1827
;1827:		return;
ADDRGP4 $536
JUMPV
LABELV $599
line 1830
;1828:	}
;1829:
;1830:	VectorAdd(
ADDRLP4 292
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 152
ADDRLP4 292
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 56
INDIRF4
ADDF4
ASGNF4
ADDRLP4 152+4
ADDRLP4 292
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
ADDRLP4 56+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 152+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDRLP4 56+8
INDIRF4
ADDF4
ASGNF4
line 1836
;1831:		monster->r.currentOrigin,
;1832:		move,
;1833:		destination
;1834:	);
;1835:
;1836:	trap_Trace(
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
ADDRLP4 152
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
line 1846
;1837:		&trace,
;1838:		monster->r.currentOrigin,
;1839:		monster->r.mins,
;1840:		monster->r.maxs,
;1841:		destination,
;1842:		monster->s.number,
;1843:		MASK_PLAYERSOLID
;1844:	);
;1845:
;1846:	G_MonsterSetOrigin(monster, trace.endpos);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1848
;1847:
;1848:	if (trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $606
ADDRLP4 300
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $606
ADDRLP4 0
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $606
line 1850
;1849:		!trace.startsolid &&
;1850:		!trace.allsolid) {
line 1854
;1851:		/*
;1852:		 * Slide only for the uncompleted part of movement.
;1853:		 */
;1854:		VectorScale(
ADDRLP4 304
CNSTF4 1065353216
ASGNF4
ADDRLP4 92
ADDRLP4 56
INDIRF4
ADDRLP4 304
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
MULF4
ASGNF4
ADDRLP4 92+4
ADDRLP4 56+4
INDIRF4
ADDRLP4 304
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
line 1860
;1855:			move,
;1856:			1.0f - trace.fraction,
;1857:			slideMove
;1858:		);
;1859:
;1860:		dot = DotProduct(
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
line 1865
;1861:			slideMove,
;1862:			trace.plane.normal
;1863:		);
;1864:
;1865:		VectorMA(
ADDRLP4 308
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 92
ADDRLP4 92
INDIRF4
ADDRLP4 0+24
INDIRF4
ADDRLP4 308
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 92+4
ADDRLP4 92+4
INDIRF4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 308
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
line 1872
;1866:			slideMove,
;1867:			-dot,
;1868:			trace.plane.normal,
;1869:			slideMove
;1870:		);
;1871:
;1872:		if (VectorLengthSquared(slideMove) > 0.0001f) {
ADDRLP4 92
ARGP4
ADDRLP4 312
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 312
INDIRF4
CNSTF4 953267991
LEF4 $633
line 1873
;1873:			VectorAdd(
ADDRLP4 316
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 184
ADDRLP4 316
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 92
INDIRF4
ADDF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 316
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
line 1879
;1874:				monster->r.currentOrigin,
;1875:				slideMove,
;1876:				slideDestination
;1877:			);
;1878:
;1879:			trap_Trace(
ADDRLP4 196
ARGP4
ADDRLP4 320
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 320
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 320
INDIRP4
CNSTI4 436
ADDP4
ARGP4
ADDRLP4 320
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 184
ARGP4
ADDRLP4 320
INDIRP4
INDIRI4
ARGI4
CNSTI4 33619969
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 1889
;1880:				&slideTrace,
;1881:				monster->r.currentOrigin,
;1882:				monster->r.mins,
;1883:				monster->r.maxs,
;1884:				slideDestination,
;1885:				monster->s.number,
;1886:				MASK_PLAYERSOLID
;1887:			);
;1888:
;1889:			G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1893
;1890:				monster,
;1891:				slideTrace.endpos
;1892:			);
;1893:		}
LABELV $633
line 1894
;1894:	}
LABELV $606
line 1896
;1895:
;1896:	vectoangles(direction, angles);
ADDRLP4 80
ARGP4
ADDRLP4 116
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1897
;1897:	angles[PITCH] = 0;
ADDRLP4 116
CNSTF4 0
ASGNF4
line 1898
;1898:	angles[ROLL] = 0;
ADDRLP4 116+8
CNSTF4 0
ASGNF4
line 1900
;1899:
;1900:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1901
;1901:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1902
;1902:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1904
;1903:
;1904:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1905
;1905:}
LABELV $536
endproc G_MonsterMove 324 28
proc G_MonsterValidTarget 8 0
line 1907
;1906:
;1907:static qboolean G_MonsterValidTarget(gentity_t *target) {
line 1908
;1908:	if (!target || !target->client) {
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
EQU4 $644
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $642
LABELV $644
line 1909
;1909:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $641
JUMPV
LABELV $642
line 1912
;1910:	}
;1911:
;1912:	if (target->client->pers.connected != CON_CONNECTED) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $645
line 1913
;1913:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $641
JUMPV
LABELV $645
line 1916
;1914:	}
;1915:
;1916:	if (target->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $647
line 1917
;1917:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $641
JUMPV
LABELV $647
line 1920
;1918:	}
;1919:
;1920:	if (target->health <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $649
line 1921
;1921:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $641
JUMPV
LABELV $649
line 1924
;1922:	}
;1923:
;1924:	return qtrue;
CNSTI4 1
RETI4
LABELV $641
endproc G_MonsterValidTarget 8 0
proc G_MonsterFireProjectile 72 12
line 1935
;1925:}
;1926:
;1927:static void G_MonsterFireProjectile(
;1928:	gentity_t *monster,
;1929:	gentity_t *target,
;1930:	monsterDef_t *def,
;1931:	const char *projectile,
;1932:	int damage,
;1933:	int splashDamage,
;1934:	int splashRadius
;1935:) {
line 1941
;1936:	gentity_t *bolt;
;1937:	vec3_t start;
;1938:	vec3_t targetOrigin;
;1939:	vec3_t direction;
;1940:
;1941:	VectorCopy(
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1946
;1942:		monster->r.currentOrigin,
;1943:		start
;1944:	);
;1945:
;1946:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $652
line 1947
;1947:		MONSTER_MOVEMENT_WALKING ) {
line 1948
;1948:		start[2] += 36;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1108344832
ADDF4
ASGNF4
line 1949
;1949:	}
ADDRGP4 $653
JUMPV
LABELV $652
line 1950
;1950:	else {
line 1951
;1951:		start[2] += 8;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 1952
;1952:	}
LABELV $653
line 1954
;1953:
;1954:	VectorCopy(
ADDRLP4 28
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1959
;1955:		target->r.currentOrigin,
;1956:		targetOrigin
;1957:	);
;1958:
;1959:	targetOrigin[2] +=
ADDRLP4 28+8
ADDRLP4 28+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 1962
;1960:		DEFAULT_VIEWHEIGHT * 0.5f;
;1961:
;1962:	VectorSubtract(
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
line 1968
;1963:		targetOrigin,
;1964:		start,
;1965:		direction
;1966:	);
;1967:
;1968:	VectorNormalize(direction);
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 1970
;1969:
;1970:	VectorMA(
ADDRLP4 40
CNSTF4 1103101952
ASGNF4
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 40
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 4+4
INDIRF4
ADDRLP4 40
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
line 1977
;1971:		start,
;1972:		24,
;1973:		direction,
;1974:		start
;1975:	);
;1976:
;1977:	if( projectile &&
ADDRLP4 44
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 44
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $669
ADDRLP4 44
INDIRP4
ARGP4
ADDRGP4 $671
ARGP4
ADDRLP4 48
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
NEI4 $669
line 1978
;1978:		!Q_stricmp(projectile, "rocket") ) {
line 1979
;1979:		bolt = fire_rocket(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 52
ADDRGP4 fire_rocket
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 52
INDIRP4
ASGNP4
line 1984
;1980:			monster,
;1981:			start,
;1982:			direction
;1983:		);
;1984:	}
ADDRGP4 $670
JUMPV
LABELV $669
line 1985
;1985:	else if( projectile &&
ADDRLP4 52
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 52
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $672
ADDRLP4 52
INDIRP4
ARGP4
ADDRGP4 $674
ARGP4
ADDRLP4 56
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 0
NEI4 $672
line 1986
;1986:		!Q_stricmp(projectile, "grenade") ) {
line 1993
;1987:		/*
;1988:		 * Ballistic arc: add elevation so the grenade
;1989:		 * reaches a ground target instead of hitting
;1990:		 * the floor immediately.
;1991:		 * fire_grenade itself sets trType = TR_GRAVITY.
;1992:		 */
;1993:		direction[2] += 0.35f;
ADDRLP4 16+8
ADDRLP4 16+8
INDIRF4
CNSTF4 1051931443
ADDF4
ASGNF4
line 1994
;1994:		VectorNormalize( direction );
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 1996
;1995:
;1996:		bolt = fire_grenade(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 60
ADDRGP4 fire_grenade
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 60
INDIRP4
ASGNP4
line 2001
;1997:			monster,
;1998:			start,
;1999:			direction
;2000:		);
;2001:	}
ADDRGP4 $673
JUMPV
LABELV $672
line 2002
;2002:	else {
line 2003
;2003:		bolt = fire_plasma(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 60
ADDRGP4 fire_plasma
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 60
INDIRP4
ASGNP4
line 2008
;2004:			monster,
;2005:			start,
;2006:			direction
;2007:		);
;2008:	}
LABELV $673
LABELV $670
line 2010
;2009:
;2010:	bolt->damage = damage;
ADDRLP4 0
INDIRP4
CNSTI4 740
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
line 2011
;2011:	bolt->splashDamage = splashDamage;
ADDRLP4 0
INDIRP4
CNSTI4 744
ADDP4
ADDRFP4 20
INDIRI4
ASGNI4
line 2012
;2012:	bolt->splashRadius = splashRadius;
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
ADDRFP4 24
INDIRI4
ASGNI4
line 2014
;2013:
;2014:	VectorScale(
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
line 2020
;2015:		direction,
;2016:		def->projectileSpeed,
;2017:		bolt->s.pos.trDelta
;2018:	);
;2019:
;2020:	SnapVector(bolt->s.pos.trDelta);
ADDRLP4 60
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 64
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ASGNP4
ADDRLP4 64
INDIRP4
ADDRLP4 64
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 68
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
line 2022
;2021:
;2022:	if( monster->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $678
line 2023
;2023:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2026
;2024:			level.time;
;2025:
;2026:		VectorCopy(
ADDRLP4 60
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 60
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 60
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2030
;2027:			monster->r.currentOrigin,
;2028:			monster->monsterProgressOrigin
;2029:		);
;2030:	}
LABELV $678
line 2031
;2031:}
LABELV $651
endproc G_MonsterFireProjectile 72 12
proc G_MonsterStartRangedAttack 72 12
line 2037
;2032:
;2033:static void G_MonsterStartRangedAttack(
;2034:	gentity_t *monster,
;2035:	gentity_t *target,
;2036:	monsterDef_t *def
;2037:) {
line 2045
;2038:	animation_t *animation;
;2039:	int variant;
;2040:	int fireFrame;
;2041:	int windup;
;2042:	vec3_t direction;
;2043:	vec3_t angles;
;2044:
;2045:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2046
;2046:	animation = &def->rangedAnimations[variant];
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
line 2048
;2047:
;2048:	fireFrame = def->attackFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 656
ADDP4
INDIRI4
ASGNI4
line 2050
;2049:
;2050:	if (fireFrame < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $682
line 2051
;2051:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2052
;2052:	}
LABELV $682
line 2054
;2053:
;2054:	if (animation->numFrames > 0 &&
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
LEI4 $684
ADDRLP4 0
INDIRI4
ADDRLP4 44
INDIRI4
LTI4 $684
line 2055
;2055:		fireFrame >= animation->numFrames) {
line 2056
;2056:		fireFrame = animation->numFrames - 1;
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2057
;2057:	}
LABELV $684
line 2059
;2058:
;2059:	windup = fireFrame * animation->frameLerp;
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
line 2064
;2060:
;2061:	/*
;2062:	 * Face the target when the attack animation begins.
;2063:	 */
;2064:	VectorSubtract(
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
line 2070
;2065:		target->r.currentOrigin,
;2066:		monster->r.currentOrigin,
;2067:		direction
;2068:	);
;2069:
;2070:	if( VectorNormalize(direction) > 0.0f ) {
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
LEF4 $688
line 2071
;2071:		vectoangles(direction, angles);
ADDRLP4 8
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2073
;2072:
;2073:		angles[PITCH] = 0;
ADDRLP4 24
CNSTF4 0
ASGNF4
line 2074
;2074:		angles[ROLL] = 0;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 2076
;2075:
;2076:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2081
;2077:			angles,
;2078:			monster->s.angles
;2079:		);
;2080:
;2081:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2086
;2082:			angles,
;2083:			monster->s.apos.trBase
;2084:		);
;2085:
;2086:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2090
;2087:			angles,
;2088:			monster->r.currentAngles
;2089:		);
;2090:	}
LABELV $688
line 2092
;2091:
;2092:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2093
;2093:	monster->monsterShotsRemaining = def->burstCount;
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
line 2094
;2094:	monster->monsterNextShot = level.time + windup;
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
line 2096
;2095:
;2096:	G_MonsterSetAnimation(
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
line 2101
;2097:		monster,
;2098:		MONSTER_STATE_RANGED,
;2099:		variant
;2100:	);
;2101:}
LABELV $681
endproc G_MonsterStartRangedAttack 72 12
proc G_MonsterStartMeleeAttack 24 12
line 2107
;2102:
;2103:static void G_MonsterStartMeleeAttack(
;2104:	gentity_t *monster,
;2105:	gentity_t *target,
;2106:	monsterDef_t *def
;2107:) {
line 2113
;2108:	animation_t *animation;
;2109:	int variant;
;2110:	int fireFrame;
;2111:	int windup;
;2112:
;2113:	variant =
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
line 2116
;2114:		rand() % MAX_MONSTER_VARIANTS;
;2115:
;2116:	animation =
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
line 2119
;2117:		&def->meleeAnimations[variant];
;2118:
;2119:	fireFrame = def->meleeFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
ASGNI4
line 2121
;2120:
;2121:	if( fireFrame < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $693
line 2122
;2122:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2123
;2123:	}
LABELV $693
line 2125
;2124:
;2125:	if( animation->numFrames > 0 &&
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
LEI4 $695
ADDRLP4 0
INDIRI4
ADDRLP4 20
INDIRI4
LTI4 $695
line 2126
;2126:		fireFrame >= animation->numFrames ) {
line 2127
;2127:		fireFrame =
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2129
;2128:			animation->numFrames - 1;
;2129:	}
LABELV $695
line 2131
;2130:
;2131:	windup =
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
line 2135
;2132:		fireFrame *
;2133:		animation->frameLerp;
;2134:
;2135:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2136
;2136:	monster->monsterShotsRemaining = 1;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 1
ASGNI4
line 2137
;2137:	monster->monsterNextShot =
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
line 2140
;2138:		level.time + windup;
;2139:
;2140:	G_MonsterSetAnimation(
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
line 2145
;2141:		monster,
;2142:		MONSTER_STATE_MELEE,
;2143:		variant
;2144:	);
;2145:}
LABELV $692
endproc G_MonsterStartMeleeAttack 24 12
proc G_MonsterCanSeeTarget 92 28
line 2150
;2146:
;2147:static qboolean G_MonsterCanSeeTarget(
;2148:	gentity_t *monster,
;2149:	gentity_t *target
;2150:) {
line 2155
;2151:	trace_t trace;
;2152:	vec3_t start;
;2153:	vec3_t end;
;2154:
;2155:	if (!G_MonsterValidTarget(target)) {
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
NEI4 $699
line 2156
;2156:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $698
JUMPV
LABELV $699
line 2159
;2157:	}
;2158:
;2159:	VectorCopy(monster->r.currentOrigin, start);
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2160
;2160:	start[2] += 8;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2162
;2161:
;2162:	VectorCopy(target->r.currentOrigin, end);
ADDRLP4 68
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2163
;2163:	end[2] += DEFAULT_VIEWHEIGHT * 0.5f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 2165
;2164:
;2165:	trap_Trace(
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
line 2175
;2166:		&trace,
;2167:		start,
;2168:		NULL,
;2169:		NULL,
;2170:		end,
;2171:		monster->s.number,
;2172:		MASK_SHOT
;2173:	);
;2174:
;2175:	return trace.fraction == 1.0f ||
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $708
ADDRLP4 0+52
INDIRI4
ADDRFP4 4
INDIRP4
INDIRI4
NEI4 $706
LABELV $708
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRGP4 $707
JUMPV
LABELV $706
ADDRLP4 88
CNSTI4 0
ASGNI4
LABELV $707
ADDRLP4 88
INDIRI4
RETI4
LABELV $698
endproc G_MonsterCanSeeTarget 92 28
proc G_MonsterRunAttack 80 32
line 2182
;2176:		trace.entityNum == target->s.number;
;2177:}
;2178:
;2179:static void G_MonsterRunAttack(
;2180:	gentity_t *monster,
;2181:	monsterDef_t *def
;2182:) {
line 2185
;2183:	qboolean meleeAttack;
;2184:
;2185:	if( monster->monsterShotsRemaining <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $710
line 2186
;2186:		return;
ADDRGP4 $709
JUMPV
LABELV $710
line 2189
;2187:	}
;2188:
;2189:	if( !G_MonsterValidTarget(monster->enemy) ||
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
EQI4 $714
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
NEI4 $712
LABELV $714
line 2193
;2190:		!G_MonsterCanSeeTarget(
;2191:			monster,
;2192:			monster->enemy
;2193:		) ) {
line 2194
;2194:		monster->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2196
;2195:
;2196:		monster->monsterNextAttack =
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
line 2200
;2197:			level.time +
;2198:			def->attackCooldown;
;2199:
;2200:		return;
ADDRGP4 $709
JUMPV
LABELV $712
line 2203
;2201:	}
;2202:
;2203:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
INDIRI4
GEI4 $716
line 2204
;2204:		monster->monsterNextShot ) {
line 2205
;2205:		return;
ADDRGP4 $709
JUMPV
LABELV $716
line 2208
;2206:	}
;2207:
;2208:	meleeAttack =
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 2
NEI4 $720
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $721
JUMPV
LABELV $720
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $721
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
line 2212
;2209:		monster->monsterAnimation ==
;2210:		MONSTER_STATE_MELEE;
;2211:
;2212:	if( meleeAttack ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $722
line 2213
;2213:		G_MonsterSound(
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
ADDRGP4 $724
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
line 2226
;2214:			monster,
;2215:			def,
;2216:			"melee",
;2217:			monster->monsterAnimationVariant
;2218:		);
;2219:
;2220:		/*
;2221:		 * meleeProjectile "none" (parser turns it into an
;2222:		 * empty string) enables instant melee via G_Damage.
;2223:		 * Any other value keeps the old projectile-based
;2224:		 * melee behavior (plasma / rocket).
;2225:		 */
;2226:		if( def->meleeProjectile[0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 512
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $725
line 2227
;2227:			G_MonsterFireProjectile(
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
line 2236
;2228:				monster,
;2229:				monster->enemy,
;2230:				def,
;2231:				def->meleeProjectile,
;2232:				def->meleeDamage,
;2233:				0,
;2234:				0
;2235:			);
;2236:		}
ADDRGP4 $723
JUMPV
LABELV $725
line 2237
;2237:		else {
line 2241
;2238:			vec3_t delta;
;2239:			float dist;
;2240:
;2241:			VectorSubtract(
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
line 2247
;2242:				monster->enemy->r.currentOrigin,
;2243:				monster->r.currentOrigin,
;2244:				delta
;2245:			);
;2246:
;2247:			dist = VectorLength( delta );
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
line 2254
;2248:
;2249:			/*
;2250:			 * 1.25f tolerance: during the attack windup the
;2251:			 * target may have moved slightly; still allow the
;2252:			 * hit if it is roughly within melee range.
;2253:			 */
;2254:			if( dist <= def->meleeRange * 1.25f &&
ADDRLP4 36
INDIRF4
CNSTF4 1067450368
ADDRFP4 4
INDIRP4
CNSTI4 660
ADDP4
INDIRF4
MULF4
GTF4 $723
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
EQI4 $723
line 2258
;2255:				G_MonsterCanSeeTarget(
;2256:					monster,
;2257:					monster->enemy
;2258:				) ) {
line 2259
;2259:				G_Damage(
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
line 2269
;2260:					monster->enemy,
;2261:					monster,
;2262:					monster,
;2263:					NULL,
;2264:					monster->r.currentOrigin,
;2265:					def->meleeDamage,
;2266:					0,
;2267:					MOD_CRUSH
;2268:				);
;2269:			}
line 2270
;2270:		}
line 2271
;2271:	}
ADDRGP4 $723
JUMPV
LABELV $722
line 2272
;2272:	else {
line 2273
;2273:		G_MonsterSound(
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
ADDRGP4 $731
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
line 2280
;2274:			monster,
;2275:			def,
;2276:			"ranged",
;2277:			monster->monsterAnimationVariant
;2278:		);
;2279:
;2280:		G_MonsterFireProjectile(
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
line 2289
;2281:			monster,
;2282:			monster->enemy,
;2283:			def,
;2284:			def->projectile,
;2285:			def->projectileDamage,
;2286:			def->splashDamage,
;2287:			def->splashRadius
;2288:		);
;2289:	}
LABELV $723
line 2291
;2290:
;2291:	monster->monsterShotsRemaining--;
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
line 2293
;2292:
;2293:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $732
line 2294
;2294:		monster->monsterNextShot =
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
line 2297
;2295:			level.time +
;2296:			def->burstInterval;
;2297:	}
ADDRGP4 $733
JUMPV
LABELV $732
line 2298
;2298:	else {
line 2299
;2299:		monster->monsterNextAttack =
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
line 2302
;2300:			level.time +
;2301:			def->attackCooldown;
;2302:	}
LABELV $733
line 2303
;2303:}
LABELV $709
endproc G_MonsterRunAttack 80 32
proc G_MonsterAttack 32 12
line 2309
;2304:
;2305:static void G_MonsterAttack(
;2306:	gentity_t *monster,
;2307:	gentity_t *target,
;2308:	monsterDef_t *def
;2309:) {
line 2312
;2310:	float distanceSquared;
;2311:
;2312:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $737
line 2313
;2313:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2317
;2314:			monster,
;2315:			def
;2316:		);
;2317:		return;
ADDRGP4 $736
JUMPV
LABELV $737
line 2320
;2318:	}
;2319:
;2320:	if( monster->monsterAnimation !=
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
EQI4 $739
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $739
line 2323
;2321:			MONSTER_STATE_MOVE &&
;2322:		monster->monsterAnimation !=
;2323:			MONSTER_STATE_IDLE ) {
line 2324
;2324:		return;
ADDRGP4 $736
JUMPV
LABELV $739
line 2327
;2325:	}
;2326:
;2327:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
INDIRI4
GEI4 $741
line 2328
;2328:		monster->monsterNextAttack ) {
line 2329
;2329:		return;
ADDRGP4 $736
JUMPV
LABELV $741
line 2332
;2330:	}
;2331:
;2332:	distanceSquared = DistanceSquared(
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
line 2337
;2333:		monster->r.currentOrigin,
;2334:		target->r.currentOrigin
;2335:	);
;2336:
;2337:	if( !G_MonsterCanSeeTarget(
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
NEI4 $744
line 2340
;2338:		monster,
;2339:		target
;2340:	) ) {
line 2341
;2341:		return;
ADDRGP4 $736
JUMPV
LABELV $744
line 2347
;2342:	}
;2343:
;2344:	/*
;2345:	 * Prefer melee whenever the target is close enough.
;2346:	 */
;2347:	if( def->hasMelee &&
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
EQI4 $746
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
GTF4 $746
line 2350
;2348:		distanceSquared <=
;2349:			def->meleeRange *
;2350:			def->meleeRange ) {
line 2351
;2351:		G_MonsterStartMeleeAttack(
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
line 2357
;2352:			monster,
;2353:			target,
;2354:			def
;2355:		);
;2356:
;2357:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2362
;2358:			monster,
;2359:			def
;2360:		);
;2361:
;2362:		return;
ADDRGP4 $736
JUMPV
LABELV $746
line 2365
;2363:	}
;2364:
;2365:	if( !def->hasRanged ) {
ADDRFP4 8
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 0
NEI4 $748
line 2366
;2366:		return;
ADDRGP4 $736
JUMPV
LABELV $748
line 2369
;2367:	}
;2368:
;2369:	if( distanceSquared >
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
LEF4 $750
line 2371
;2370:		def->attackRange *
;2371:		def->attackRange ) {
line 2372
;2372:		return;
ADDRGP4 $736
JUMPV
LABELV $750
line 2375
;2373:	}
;2374:
;2375:	G_MonsterStartRangedAttack(
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
line 2381
;2376:		monster,
;2377:		target,
;2378:		def
;2379:	);
;2380:
;2381:	G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2385
;2382:		monster,
;2383:		def
;2384:	);
;2385:}
LABELV $736
endproc G_MonsterAttack 32 12
proc G_MonsterThink 44 16
line 2387
;2386:
;2387:static void G_MonsterThink(gentity_t *monster) {
line 2392
;2388:	monsterDef_t *def;
;2389:	gentity_t *target;
;2390:	int msec;
;2391:
;2392:	def = &g_monsterDefs
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
line 2396
;2393:		[monster->monsterType]
;2394:		[monster->monsterSlot];
;2395:
;2396:	G_MonsterUpdateAnimation(monster, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 G_MonsterUpdateAnimation
CALLV
pop
line 2398
;2397:
;2398:	if (monster->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $753
line 2399
;2399:		if (level.time >= monster->monsterDeathTime) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 852
ADDP4
INDIRI4
LTI4 $755
line 2400
;2400:			if (monsterActiveCount > 0) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 0
LEI4 $758
line 2401
;2401:				monsterActiveCount--;
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
line 2402
;2402:			}
LABELV $758
line 2404
;2403:
;2404:			G_FreeEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 2405
;2405:			return;
ADDRGP4 $752
JUMPV
LABELV $755
line 2408
;2406:		}
;2407:
;2408:		monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2409
;2409:		return;
ADDRGP4 $752
JUMPV
LABELV $753
line 2412
;2410:	}
;2411:
;2412:	msec = level.time - monster->monsterLastThink;
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
line 2414
;2413:
;2414:	if (msec < 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
GEI4 $762
line 2415
;2415:		msec = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 2416
;2416:	}
ADDRGP4 $763
JUMPV
LABELV $762
line 2417
;2417:	else if (msec > 100) {
ADDRLP4 0
INDIRI4
CNSTI4 100
LEI4 $764
line 2418
;2418:		msec = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 2419
;2419:	}
LABELV $764
LABELV $763
line 2421
;2420:
;2421:	monster->monsterLastThink = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2423
;2422:
;2423:	target = G_MonsterFindTarget(monster);
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
line 2429
;2424:
;2425:	/*
;2426:	 * During an attack, keep facing the target selected
;2427:	 * at the beginning of the attack.
;2428:	 */
;2429:	if ((monster->monsterAnimation ==
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
EQI4 $769
ADDRLP4 20
INDIRI4
CNSTI4 2
NEI4 $767
LABELV $769
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
EQI4 $767
line 2433
;2430:			MONSTER_STATE_RANGED ||
;2431:		 monster->monsterAnimation ==
;2432:			MONSTER_STATE_MELEE) &&
;2433:		G_MonsterValidTarget(monster->enemy)) {
line 2434
;2434:		target = monster->enemy;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ASGNP4
line 2435
;2435:	}
LABELV $767
line 2437
;2436:
;2437:	if (target) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $770
line 2438
;2438:		G_MonsterFaceTarget(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterFaceTarget
CALLV
pop
line 2443
;2439:			monster,
;2440:			target
;2441:		);
;2442:
;2443:			G_MonsterMove(
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
line 2449
;2444:				monster,
;2445:				target,
;2446:				def,
;2447:				msec
;2448:			);
;2449:		G_MonsterAttack(monster, target, def);
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
line 2451
;2450:
;2451:		if (monster->monsterAnimation == MONSTER_STATE_MOVE &&
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
NEI4 $771
ADDRGP4 level+32
INDIRI4
ADDRLP4 28
INDIRP4
CNSTI4 856
ADDP4
INDIRI4
LTI4 $771
line 2452
;2452:			level.time >= monster->monsterNextTalk) {
line 2455
;2453:			int variant;
;2454:
;2455:			variant =
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
line 2458
;2456:				rand() % MAX_MONSTER_VARIANTS;
;2457:
;2458:			G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $775
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2465
;2459:				monster,
;2460:				def,
;2461:				"talk",
;2462:				variant
;2463:			);
;2464:
;2465:			monster->monsterNextTalk =
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
line 2468
;2466:				level.time +
;2467:				G_MonsterTalkDelay(def);
;2468:		}
line 2469
;2469:	}
ADDRGP4 $771
JUMPV
LABELV $770
line 2471
;2470:	
;2471:	else if( monster->monsterAnimation ==
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
NEI4 $777
line 2472
;2472:		MONSTER_STATE_MOVE ) {
line 2473
;2473:		G_MonsterSetAnimation(
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
line 2478
;2474:			monster,
;2475:			MONSTER_STATE_IDLE,
;2476:			0
;2477:		);
;2478:	}
LABELV $777
LABELV $771
line 2484
;2479:
;2480:	/*
;2481:	 * Walking monsters remain attached to the floor
;2482:	 * and fall when moving over an edge.
;2483:	 */
;2484:	G_MonsterGroundWalker(
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
line 2494
;2485:		monster,
;2486:		def,
;2487:		msec
;2488:	);
;2489:	
;2490:	/*
;2491:	 * Remember meaningful movement so an active monster
;2492:	 * is not mistaken for a lost one.
;2493:	 */
;2494:	if( monster->monsterWaveSpawn &&
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
EQI4 $779
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
LTF4 $779
line 2498
;2495:		DistanceSquared(
;2496:			monster->r.currentOrigin,
;2497:			monster->monsterProgressOrigin
;2498:		) >= 32.0f * 32.0f ) {
line 2499
;2499:		VectorCopy(
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
line 2504
;2500:			monster->r.currentOrigin,
;2501:			monster->monsterProgressOrigin
;2502:		);
;2503:
;2504:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2506
;2505:			level.time;
;2506:	}
LABELV $779
line 2508
;2507:
;2508:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2510
;2509:
;2510:	monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2511
;2511:}
LABELV $752
endproc G_MonsterThink 44 16
proc G_MonsterSound 68 24
line 2518
;2512:
;2513:static void G_MonsterSound(
;2514:	gentity_t *monster,
;2515:	monsterDef_t *def,
;2516:	const char *group,
;2517:	int variant
;2518:) {
line 2521
;2519:	char filename[MAX_QPATH];
;2520:
;2521:	Com_sprintf(
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $784
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
line 2530
;2522:		filename,
;2523:		sizeof(filename),
;2524:		"%s/%s%i.wav",
;2525:		def->soundDir,
;2526:		group,
;2527:		variant + 1
;2528:	);
;2529:
;2530:	G_Sound(
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
line 2535
;2531:		monster,
;2532:		CHAN_VOICE,
;2533:		G_SoundIndex(filename)
;2534:	);
;2535:}
LABELV $783
endproc G_MonsterSound 68 24
proc G_MonsterTalkDelay 12 0
line 2537
;2536:
;2537:static int G_MonsterTalkDelay(monsterDef_t *def) {
line 2540
;2538:	int range;
;2539:
;2540:	range = def->talkMaxDelay - def->talkMinDelay;
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
line 2542
;2541:
;2542:	if (range <= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $786
line 2543
;2543:		return def->talkMinDelay;
ADDRFP4 0
INDIRP4
CNSTI4 696
ADDP4
INDIRI4
RETI4
ADDRGP4 $785
JUMPV
LABELV $786
line 2546
;2544:	}
;2545:
;2546:	return def->talkMinDelay + rand() % (range + 1);
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
LABELV $785
endproc G_MonsterTalkDelay 12 0
proc G_MonsterPain 20 16
line 2553
;2547:}
;2548:
;2549:static void G_MonsterPain(
;2550:	gentity_t *self,
;2551:	gentity_t *attacker,
;2552:	int damage
;2553:) {
line 2557
;2554:	monsterDef_t *def;
;2555:	int variant;
;2556:
;2557:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $789
line 2558
;2558:		return;
ADDRGP4 $788
JUMPV
LABELV $789
line 2561
;2559:	}
;2560:	
;2561:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $791
line 2562
;2562:	self->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2565
;2563:		level.time;
;2564:
;2565:	VectorCopy(
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
line 2569
;2566:		self->r.currentOrigin,
;2567:		self->monsterProgressOrigin
;2568:	);
;2569:}
LABELV $791
line 2571
;2570:
;2571:	if (level.time < self->pain_debounce_time) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
GEI4 $794
line 2572
;2572:		return;
ADDRGP4 $788
JUMPV
LABELV $794
line 2575
;2573:	}
;2574:
;2575:	def = &g_monsterDefs
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
line 2584
;2576:		[self->monsterType]
;2577:		[self->monsterSlot];
;2578:			
;2579:
;2580:	/*
;2581:	 * painChance: probability (0..100) that a hit actually
;2582:	 * triggers the pain animation. 100 keeps the old behavior.
;2583:	 */
;2584:	if( def->painChance <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRI4
CNSTI4 0
GTI4 $797
line 2585
;2585:		return;
ADDRGP4 $788
JUMPV
LABELV $797
line 2588
;2586:	}
;2587:
;2588:	if( def->painChance < 100 &&
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRI4
CNSTI4 100
GEI4 $799
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
LTI4 $799
line 2589
;2589:		(rand() % 100) >= def->painChance ) {
line 2590
;2590:		return;
ADDRGP4 $788
JUMPV
LABELV $799
line 2593
;2591:	}
;2592:
;2593:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2595
;2594:
;2595:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2596
;2596:	self->monsterNextAttack = level.time + def->attackCooldown;
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
line 2598
;2597:
;2598:	G_MonsterSetAnimation(
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
line 2604
;2599:		self,
;2600:		MONSTER_STATE_PAIN,
;2601:		variant
;2602:	);
;2603:
;2604:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $802
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2611
;2605:		self,
;2606:		def,
;2607:		"pain",
;2608:		variant
;2609:	);
;2610:
;2611:	self->pain_debounce_time = level.time + 700;
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 700
ADDI4
ASGNI4
line 2612
;2612:}
LABELV $788
endproc G_MonsterPain 20 16
proc G_MonsterDropItem 36 12
line 2614
;2613:
;2614:static void G_MonsterDropItem(gentity_t *monster) {
line 2617
;2615:	vec3_t velocity;
;2616:
;2617:	if (!monster->monsterItem ||
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
EQU4 $807
ADDRLP4 12
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 16
INDIRU4
NEU4 $805
LABELV $807
line 2618
;2618:		!monster->monsterItem->item) {
line 2619
;2619:		return;
ADDRGP4 $804
JUMPV
LABELV $805
line 2622
;2620:	}
;2621:
;2622:	if (rand() % 100 >= 50) {
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 100
MODI4
CNSTI4 50
LTI4 $808
line 2623
;2623:		return;
ADDRGP4 $804
JUMPV
LABELV $808
line 2626
;2624:	}
;2625:
;2626:	VectorSet(
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
line 2633
;2627:		velocity,
;2628:		crandom() * 60,
;2629:		crandom() * 60,
;2630:		140
;2631:	);
;2632:
;2633:	LaunchItem(
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
line 2638
;2634:		monster->monsterItem->item,
;2635:		monster->r.currentOrigin,
;2636:		velocity
;2637:	);
;2638:}
LABELV $804
endproc G_MonsterDropItem 36 12
proc G_MonsterDie 56 16
line 2646
;2639:
;2640:static void G_MonsterDie(
;2641:	gentity_t *self,
;2642:	gentity_t *inflictor,
;2643:	gentity_t *attacker,
;2644:	int damage,
;2645:	int mod
;2646:) {
line 2652
;2647:	monsterDef_t *def;
;2648:	animation_t *animation;
;2649:	int variant;
;2650:	int duration;
;2651:
;2652:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $813
line 2653
;2653:		return;
ADDRGP4 $812
JUMPV
LABELV $813
line 2656
;2654:	}
;2655:
;2656:	def = &g_monsterDefs
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
line 2660
;2657:		[self->monsterType]
;2658:		[self->monsterSlot];
;2659:
;2660:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2662
;2661:
;2662:	self->monsterDead = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 1
ASGNI4
line 2663
;2663:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $815
line 2664
;2664:		monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2665
;2665:	}
LABELV $815
line 2667
;2666:	
;2667:	self->s.eFlags |= EF_DEAD;
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
line 2668
;2668:	self->takedamage = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 2669
;2669:	self->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 2670
;2670:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2672
;2671:
;2672:	self->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 2673
;2673:	self->clipmask = 0;
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 0
ASGNI4
line 2674
;2674:	trap_LinkEntity(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2676
;2675:
;2676:	G_MonsterSetAnimation(
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
line 2682
;2677:		self,
;2678:		MONSTER_STATE_DEATH,
;2679:		variant
;2680:	);
;2681:
;2682:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $818
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2689
;2683:		self,
;2684:		def,
;2685:		"death",
;2686:		variant
;2687:	);
;2688:
;2689:	animation = &def->deathAnimations[variant];
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
line 2690
;2690:	duration = animation->numFrames *
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
line 2693
;2691:		animation->frameLerp;
;2692:
;2693:	self->monsterDeathTime =
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
line 2702
;2694:		level.time +
;2695:		duration +
;2696:		def->corpseTime;
;2697:
;2698:	/*
;2699:	 * Monster Hunt score is awarded only for a monster
;2700:	 * killed by a real player or bot client.
;2701:	 */
;2702:	if (g_monsterHunt.integer &&
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 g_monsterHunt+12
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $820
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
EQU4 $820
ADDRLP4 36
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 40
INDIRU4
EQU4 $820
ADDRLP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
LEI4 $820
line 2705
;2703:		attacker &&
;2704:		attacker->client &&
;2705:		def->scoreValue > 0) {
line 2706
;2706:		AddScore(
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
line 2711
;2707:			attacker,
;2708:			self->r.currentOrigin,
;2709:			def->scoreValue
;2710:		);
;2711:	}
LABELV $820
line 2713
;2712:
;2713:	G_MonsterDropItem(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_MonsterDropItem
CALLV
pop
line 2718
;2714:	/*
;2715:	 * Only classic item-bound monsters respawn independently.
;2716:	 * Wave monsters are controlled by the wave director.
;2717:	 */
;2718:	if( !self->monsterWaveSpawn &&
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
NEI4 $823
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
EQU4 $823
ADDRLP4 52
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
EQI4 $823
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
LEI4 $823
line 2721
;2719:		self->monsterItem &&
;2720:		self->monsterItem->inuse &&
;2721:		def->respawnTime > 0 ) {
line 2722
;2722:		self->monsterItem->think =
ADDRFP4 0
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterRespawnThink
ASGNP4
line 2725
;2723:			G_MonsterRespawnThink;
;2724:
;2725:		self->monsterItem->nextthink =
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
line 2727
;2726:			level.time + def->respawnTime;
;2727:	}
LABELV $823
line 2728
;2728:}
LABELV $812
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
LABELV $818
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $802
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $784
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
LABELV $775
byte 1 116
byte 1 97
byte 1 108
byte 1 107
byte 1 0
align 1
LABELV $731
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $724
byte 1 109
byte 1 101
byte 1 108
byte 1 101
byte 1 101
byte 1 0
align 1
LABELV $674
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $671
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $429
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
LABELV $387
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
LABELV $386
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
LABELV $385
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
LABELV $384
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
LABELV $376
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
LABELV $374
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
LABELV $373
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
LABELV $372
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
LABELV $359
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
LABELV $233
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
LABELV $224
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
LABELV $223
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
LABELV $202
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
LABELV $197
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $192
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
LABELV $187
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
LABELV $182
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
LABELV $177
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
LABELV $172
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
LABELV $164
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
LABELV $160
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
LABELV $156
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
LABELV $151
byte 1 116
byte 1 114
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $148
byte 1 114
byte 1 101
byte 1 112
byte 1 101
byte 1 97
byte 1 116
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
LABELV $140
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
LABELV $135
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
LABELV $132
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $129
byte 1 125
byte 1 0
align 1
LABELV $126
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
LABELV $120
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
LABELV $119
byte 1 123
byte 1 0
align 1
LABELV $115
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
LABELV $92
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
LABELV $87
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
LABELV $81
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
LABELV $75
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
LABELV $72
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
LABELV $68
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
