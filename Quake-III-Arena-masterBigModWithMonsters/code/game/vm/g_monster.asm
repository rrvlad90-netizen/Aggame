data
align 4
LABELV monsterConfigFiles
address $59
address $60
address $61
byte 4 0
code
proc G_LoadMonsterConfig 9572 16
file "../g_monster.c"
line 109
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
;106:	NULL
;107:};
;108:
;109:static qboolean G_LoadMonsterConfig(const char *filename) {
line 116
;110:	fileHandle_t file;
;111:	char text[MAX_MONSTER_CONFIG_TEXT];
;112:	char error[256];
;113:	monsterDef_t def;
;114:	int length;
;115:
;116:	length = trap_FS_FOpenFile(filename, &file, FS_READ);
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
line 118
;117:
;118:	if (!file) {
ADDRLP4 1108
INDIRI4
CNSTI4 0
NEI4 $63
line 119
;119:		G_Printf(
ADDRGP4 $65
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 123
;120:			S_COLOR_RED "Monster config not found: %s\n",
;121:			filename
;122:		);
;123:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $62
JUMPV
LABELV $63
line 126
;124:	}
;125:
;126:	if (length <= 0 || length >= sizeof(text)) {
ADDRLP4 1104
INDIRI4
CNSTI4 0
LEI4 $68
ADDRLP4 1104
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $66
LABELV $68
line 127
;127:		G_Printf(
ADDRGP4 $69
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 131
;128:			S_COLOR_RED "Invalid monster config size: %s\n",
;129:			filename
;130:		);
;131:		trap_FS_FCloseFile(file);
ADDRLP4 1108
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 132
;132:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $62
JUMPV
LABELV $66
line 135
;133:	}
;134:
;135:	trap_FS_Read(text, length, file);
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
line 136
;136:	text[length] = '\0';
ADDRLP4 1104
INDIRI4
ADDRLP4 1112
ADDP4
CNSTI1 0
ASGNI1
line 137
;137:	trap_FS_FCloseFile(file);
ADDRLP4 1108
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 139
;138:
;139:	if (!BG_ParseMonsterConfig(
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
NEI4 $70
line 144
;140:		text,
;141:		&def,
;142:		error,
;143:		sizeof(error)
;144:	)) {
line 145
;145:		G_Printf(
ADDRGP4 $72
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9304
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 150
;146:			S_COLOR_RED "Monster config error in %s: %s\n",
;147:			filename,
;148:			error
;149:		);
;150:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $62
JUMPV
LABELV $70
line 153
;151:	}
;152:
;153:	if (def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 0+576
INDIRI4
CNSTI4 0
LEI4 $77
ADDRLP4 0+576
INDIRI4
CNSTI4 6
LTI4 $73
LABELV $77
line 154
;154:		def.monsterType >= MONSTER_TYPE_RANDOM) {
line 155
;155:		G_Printf(
ADDRGP4 $78
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 159
;156:			S_COLOR_RED "Invalid monster type in %s\n",
;157:			filename
;158:		);
;159:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $62
JUMPV
LABELV $73
line 162
;160:	}
;161:
;162:	if (def.monsterSlot < 0 ||
ADDRLP4 0+580
INDIRI4
CNSTI4 0
LTI4 $83
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $79
LABELV $83
line 163
;163:		def.monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 164
;164:		G_Printf(
ADDRGP4 $84
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 168
;165:			S_COLOR_RED "Invalid monster slot in %s\n",
;166:			filename
;167:		);
;168:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $62
JUMPV
LABELV $79
line 171
;169:	}
;170:
;171:	g_monsterDefs[def.monsterType][def.monsterSlot] = def;
CNSTI4 1104
ADDRLP4 0+580
INDIRI4
MULI4
CNSTI4 5520
ADDRLP4 0+576
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ADDRLP4 0
INDIRB
ASGNB 1104
line 172
;172:	g_monsterDefLoaded[def.monsterType][def.monsterSlot] = qtrue;
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
line 174
;173:
;174:	G_Printf(
ADDRGP4 $89
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
line 182
;175:		S_COLOR_GREEN
;176:		"Loaded monster: %s, type %i, slot %i\n",
;177:		def.name,
;178:		def.monsterType,
;179:		def.monsterSlot
;180:	);
;181:
;182:	return qtrue;
CNSTI4 1
RETI4
LABELV $62
endproc G_LoadMonsterConfig 9572 16
proc G_MonsterWaveReadInt 12 4
line 189
;183:}
;184:
;185:
;186:static qboolean G_MonsterWaveReadInt(
;187:	char **text,
;188:	int *value
;189:) {
line 192
;190:	char *token;
;191:
;192:	token = COM_Parse(text);
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
line 194
;193:
;194:	if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $93
line 195
;195:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $92
JUMPV
LABELV $93
line 198
;196:	}
;197:
;198:	*value = atoi(token);
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
line 199
;199:	return qtrue;
CNSTI4 1
RETI4
LABELV $92
endproc G_MonsterWaveReadInt 12 4
proc G_MonsterWaveFindDefinition 12 8
line 206
;200:}
;201:
;202:static qboolean G_MonsterWaveFindDefinition(
;203:	const char *name,
;204:	int *monsterType,
;205:	int *monsterSlot
;206:) {
line 210
;207:	int type;
;208:	int slot;
;209:
;210:	for( type = MONSTER_TYPE_OFF + 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
LABELV $96
line 212
;211:		type < MONSTER_TYPE_RANDOM;
;212:		type++ ) {
line 213
;213:		for( slot = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $100
line 215
;214:			slot < MAX_MONSTERS_PER_TYPE;
;215:			slot++ ) {
line 216
;216:			if( !g_monsterDefLoaded[type][slot] ) {
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
NEI4 $104
line 217
;217:				continue;
ADDRGP4 $101
JUMPV
LABELV $104
line 220
;218:			}
;219:
;220:			if( !Q_stricmp(
CNSTI4 1104
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 5520
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
NEI4 $106
line 223
;221:				g_monsterDefs[type][slot].name,
;222:				name
;223:			) ) {
line 224
;224:				*monsterType = type;
ADDRFP4 4
INDIRP4
ADDRLP4 4
INDIRI4
ASGNI4
line 225
;225:				*monsterSlot = slot;
ADDRFP4 8
INDIRP4
ADDRLP4 0
INDIRI4
ASGNI4
line 226
;226:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $95
JUMPV
LABELV $106
line 228
;227:			}
;228:		}
LABELV $101
line 215
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 214
ADDRLP4 0
INDIRI4
CNSTI4 5
LTI4 $100
line 229
;229:	}
LABELV $97
line 212
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 211
ADDRLP4 4
INDIRI4
CNSTI4 6
LTI4 $96
line 231
;230:
;231:	return qfalse;
CNSTI4 0
RETI4
LABELV $95
endproc G_MonsterWaveFindDefinition 12 8
proc G_MonsterWaveParseWave 124 12
line 237
;232:}
;233:
;234:static qboolean G_MonsterWaveParseWave(
;235:	char **text,
;236:	int waveNumber
;237:) {
line 241
;238:	monsterWaveDef_t *wave;
;239:	char *token;
;240:
;241:	if( waveNumber < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $111
ADDRLP4 8
INDIRI4
CNSTI4 32
LEI4 $109
LABELV $111
line 242
;242:		waveNumber > MAX_MONSTER_WAVES ) {
line 243
;243:		G_Printf(
ADDRGP4 $112
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 248
;244:			S_COLOR_RED
;245:			"Monster waves: invalid wave %i\n",
;246:			waveNumber
;247:		);
;248:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $109
line 251
;249:	}
;250:
;251:	wave = &monsterWaves[waveNumber - 1];
ADDRLP4 4
CNSTI4 104
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 monsterWaves-104
ADDP4
ASGNP4
line 253
;252:
;253:	token = COM_Parse(text);
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
line 255
;254:
;255:	if( Q_stricmp(token, "{") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $116
ARGP4
ADDRLP4 16
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $119
line 256
;256:		G_Printf(
ADDRGP4 $117
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 261
;257:			S_COLOR_RED
;258:			"Monster waves: expected { after wave %i\n",
;259:			waveNumber
;260:		);
;261:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $118
line 264
;262:	}
;263:
;264:	while( 1 ) {
line 265
;265:		token = COM_Parse(text);
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
line 267
;266:
;267:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $121
line 268
;268:			G_Printf(
ADDRGP4 $123
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 273
;269:				S_COLOR_RED
;270:				"Monster waves: unexpected end of wave %i\n",
;271:				waveNumber
;272:			);
;273:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $121
line 276
;274:		}
;275:
;276:		if( !Q_stricmp(token, "}") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $126
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $124
line 277
;277:			break;
ADDRGP4 $120
JUMPV
LABELV $124
line 280
;278:		}
;279:
;280:		if( !Q_stricmp(token, "monster") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $129
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $127
line 284
;281:			monsterWaveEntry_t *entry;
;282:			char monsterName[MAX_QPATH];
;283:
;284:			if( wave->numEntries >=
ADDRLP4 4
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
CNSTI4 8
LTI4 $130
line 285
;285:				MAX_MONSTERS_IN_WAVE ) {
line 286
;286:				G_Printf(
ADDRGP4 $132
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 291
;287:					S_COLOR_RED
;288:					"Monster waves: too many entries in wave %i\n",
;289:					waveNumber
;290:				);
;291:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $130
line 294
;292:			}
;293:
;294:			token = COM_Parse(text);
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
line 296
;295:
;296:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $133
line 297
;297:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $133
line 300
;298:			}
;299:
;300:			Q_strncpyz(
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
line 306
;301:				monsterName,
;302:				token,
;303:				sizeof(monsterName)
;304:			);
;305:
;306:			entry =
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
line 309
;307:				&wave->entries[wave->numEntries];
;308:
;309:			if( !G_MonsterWaveFindDefinition(
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
NEI4 $135
line 313
;310:				monsterName,
;311:				&entry->monsterType,
;312:				&entry->monsterSlot
;313:			) ) {
line 314
;314:				G_Printf(
ADDRGP4 $137
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 319
;315:					S_COLOR_RED
;316:					"Monster waves: unknown monster %s\n",
;317:					monsterName
;318:				);
;319:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $135
line 322
;320:			}
;321:
;322:			if( !G_MonsterWaveReadInt(
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
NEI4 $138
line 325
;323:				text,
;324:				&entry->count
;325:			) ) {
line 326
;326:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $138
line 329
;327:			}
;328:
;329:			if( entry->count < 1 ) {
ADDRLP4 32
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 1
GEI4 $140
line 330
;330:				G_Printf(
ADDRGP4 $142
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 335
;331:					S_COLOR_RED
;332:					"Monster waves: invalid count for %s\n",
;333:					monsterName
;334:				);
;335:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $140
line 338
;336:			}
;337:
;338:			wave->numEntries++;
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
line 339
;339:			continue;
ADDRGP4 $119
JUMPV
LABELV $127
line 342
;340:		}
;341:
;342:		if( !Q_stricmp(token, "repeat") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $145
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $143
line 343
;343:			token = COM_Parse(text);
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
line 345
;344:
;345:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $146
line 346
;346:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $146
line 349
;347:			}
;348:
;349:			wave->repeat =
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $148
ARGP4
ADDRLP4 44
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $152
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
EQI4 $150
LABELV $152
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $151
JUMPV
LABELV $150
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $151
ADDRLP4 4
INDIRP4
CNSTI4 100
ADDP4
ADDRLP4 40
INDIRI4
ASGNI4
line 353
;350:				!Q_stricmp(token, "true") ||
;351:				atoi(token) != 0;
;352:
;353:			continue;
ADDRGP4 $119
JUMPV
LABELV $143
line 356
;354:		}
;355:
;356:		G_Printf(
ADDRGP4 $153
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
line 362
;357:			S_COLOR_RED
;358:			"Monster waves: unknown key %s in wave %i\n",
;359:			token,
;360:			waveNumber
;361:		);
;362:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $108
JUMPV
LABELV $119
line 264
ADDRGP4 $118
JUMPV
LABELV $120
line 365
;363:	}
;364:
;365:	return qtrue;
CNSTI4 1
RETI4
LABELV $108
endproc G_MonsterWaveParseWave 124 12
proc G_LoadMonsterWaveConfig 8260 16
line 370
;366:}
;367:
;368:static qboolean G_LoadMonsterWaveConfig(
;369:	const char *filename
;370:) {
line 379
;371:	fileHandle_t file;
;372:	char buffer[MAX_MONSTER_WAVE_TEXT];
;373:	char *text;
;374:	char *token;
;375:	int length;
;376:	int value;
;377:	int i;
;378:
;379:	memset(
ADDRGP4 monsterWaves
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3328
ARGI4
ADDRGP4 memset
CALLP4
pop
line 389
;380:		monsterWaves,
;381:		0,
;382:		sizeof(monsterWaves)
;383:	);
;384:
;385:	/*
;386:	 * Default values used when a key is absent
;387:	 * from monsterwaves.cfg.
;388:	 */
;389:	monsterWaveDelay = 5000;
ADDRGP4 monsterWaveDelay
CNSTI4 5000
ASGNI4
line 390
;390:	monsterWaveSpawnInterval = 750;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 750
ASGNI4
line 391
;391:	monsterWaveTimeout = 30000;
ADDRGP4 monsterWaveTimeout
CNSTI4 30000
ASGNI4
line 392
;392:	monsterWaveMaxActive = 8;
ADDRGP4 monsterWaveMaxActive
CNSTI4 8
ASGNI4
line 393
;393:	monsterWaveFinal = DEFAULT_MONSTER_WAVES;
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 395
;394:
;395:	length = trap_FS_FOpenFile(
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
line 401
;396:		filename,
;397:		&file,
;398:		FS_READ
;399:	);
;400:
;401:	if( !file ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $155
line 402
;402:		G_Printf(
ADDRGP4 $157
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 407
;403:			S_COLOR_RED
;404:			"Monster wave config not found: %s\n",
;405:			filename
;406:		);
;407:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
LABELV $155
line 410
;408:	}
;409:
;410:	if( length <= 0 ||
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $160
ADDRLP4 16
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $158
LABELV $160
line 411
;411:		length >= sizeof(buffer) ) {
line 412
;412:		G_Printf(
ADDRGP4 $161
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 418
;413:			S_COLOR_RED
;414:			"Invalid monster wave config size: %s\n",
;415:			filename
;416:		);
;417:
;418:		trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 419
;419:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
LABELV $158
line 422
;420:	}
;421:
;422:	trap_FS_Read(buffer, length, file);
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
line 423
;423:	buffer[length] = '\0';
ADDRLP4 16
INDIRI4
ADDRLP4 24
ADDP4
CNSTI1 0
ASGNI1
line 424
;424:	trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 426
;425:
;426:	text = buffer;
ADDRLP4 4
ADDRLP4 24
ASGNP4
ADDRGP4 $163
JUMPV
LABELV $162
line 428
;427:
;428:	while( 1 ) {
line 429
;429:		token = COM_Parse(&text);
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
line 431
;430:
;431:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $165
line 432
;432:			break;
ADDRGP4 $164
JUMPV
LABELV $165
line 435
;433:		}
;434:
;435:		if( !Q_stricmp(token, "waveDelay") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $169
ARGP4
ADDRLP4 8228
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8228
INDIRI4
CNSTI4 0
NEI4 $167
line 436
;436:			if( !G_MonsterWaveReadInt(
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
NEI4 $163
line 439
;437:				&text,
;438:				&monsterWaveDelay
;439:			) ) {
line 440
;440:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
line 443
;441:			}
;442:
;443:			continue;
LABELV $167
line 446
;444:		}
;445:
;446:		if( !Q_stricmp(token, "spawnInterval") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $174
ARGP4
ADDRLP4 8232
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8232
INDIRI4
CNSTI4 0
NEI4 $172
line 447
;447:			if( !G_MonsterWaveReadInt(
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
NEI4 $163
line 450
;448:				&text,
;449:				&monsterWaveSpawnInterval
;450:			) ) {
line 451
;451:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
line 454
;452:			}
;453:
;454:			continue;
LABELV $172
line 457
;455:		}
;456:
;457:		if( !Q_stricmp(token, "waveTimeout") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $179
ARGP4
ADDRLP4 8236
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8236
INDIRI4
CNSTI4 0
NEI4 $177
line 458
;458:			if( !G_MonsterWaveReadInt(
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
NEI4 $163
line 461
;459:				&text,
;460:				&monsterWaveTimeout
;461:			) ) {
line 462
;462:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
line 465
;463:			}
;464:
;465:			continue;
LABELV $177
line 468
;466:		}
;467:
;468:		if( !Q_stricmp(token, "maxActive") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $184
ARGP4
ADDRLP4 8240
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8240
INDIRI4
CNSTI4 0
NEI4 $182
line 469
;469:			if( !G_MonsterWaveReadInt(
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
NEI4 $163
line 472
;470:				&text,
;471:				&monsterWaveMaxActive
;472:			) ) {
line 473
;473:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
line 476
;474:			}
;475:
;476:			continue;
LABELV $182
line 479
;477:		}
;478:
;479:		if( !Q_stricmp(token, "finalWave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $189
ARGP4
ADDRLP4 8244
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8244
INDIRI4
CNSTI4 0
NEI4 $187
line 480
;480:			if( !G_MonsterWaveReadInt(
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
NEI4 $163
line 483
;481:				&text,
;482:				&monsterWaveFinal
;483:			) ) {
line 484
;484:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
line 487
;485:			}
;486:
;487:			continue;
LABELV $187
line 490
;488:		}
;489:
;490:		if( !Q_stricmp(token, "wave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $194
ARGP4
ADDRLP4 8248
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8248
INDIRI4
CNSTI4 0
NEI4 $192
line 491
;491:			if( !G_MonsterWaveReadInt(
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
NEI4 $195
line 494
;492:				&text,
;493:				&value
;494:			) ) {
line 495
;495:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
LABELV $195
line 498
;496:			}
;497:
;498:			if( !G_MonsterWaveParseWave(
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
NEI4 $163
line 501
;499:				&text,
;500:				value
;501:			) ) {
line 502
;502:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
line 505
;503:			}
;504:
;505:			continue;
LABELV $192
line 508
;506:		}
;507:
;508:		G_Printf(
ADDRGP4 $199
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 514
;509:			S_COLOR_RED
;510:			"Monster waves: unknown key %s\n",
;511:			token
;512:		);
;513:
;514:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
LABELV $163
line 428
ADDRGP4 $162
JUMPV
LABELV $164
line 520
;515:	}
;516:
;517:	/*
;518:	 * Sanitize timing and entity limits.
;519:	 */
;520:	if( monsterWaveDelay < 0 ) {
ADDRGP4 monsterWaveDelay
INDIRI4
CNSTI4 0
GEI4 $200
line 521
;521:		monsterWaveDelay = 0;
ADDRGP4 monsterWaveDelay
CNSTI4 0
ASGNI4
line 522
;522:	}
LABELV $200
line 524
;523:
;524:	if( monsterWaveSpawnInterval < 100 ) {
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
CNSTI4 100
GEI4 $202
line 525
;525:		monsterWaveSpawnInterval = 100;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 100
ASGNI4
line 526
;526:	}
LABELV $202
line 528
;527:
;528:	if( monsterWaveTimeout < 5000 ) {
ADDRGP4 monsterWaveTimeout
INDIRI4
CNSTI4 5000
GEI4 $204
line 529
;529:		monsterWaveTimeout = 5000;
ADDRGP4 monsterWaveTimeout
CNSTI4 5000
ASGNI4
line 530
;530:	}
LABELV $204
line 532
;531:
;532:	if( monsterWaveMaxActive < 1 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 1
GEI4 $206
line 533
;533:		monsterWaveMaxActive = 1;
ADDRGP4 monsterWaveMaxActive
CNSTI4 1
ASGNI4
line 534
;534:	}
ADDRGP4 $207
JUMPV
LABELV $206
line 535
;535:	else if( monsterWaveMaxActive > 64 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 64
LEI4 $208
line 536
;536:		monsterWaveMaxActive = 64;
ADDRGP4 monsterWaveMaxActive
CNSTI4 64
ASGNI4
line 537
;537:	}
LABELV $208
LABELV $207
line 539
;538:
;539:	if( monsterWaveFinal < 1 ||
ADDRLP4 8224
ADDRGP4 monsterWaveFinal
INDIRI4
ASGNI4
ADDRLP4 8224
INDIRI4
CNSTI4 1
LTI4 $212
ADDRLP4 8224
INDIRI4
CNSTI4 32
LEI4 $210
LABELV $212
line 541
;540:		monsterWaveFinal >
;541:			MAX_MONSTER_WAVES ) {
line 542
;542:		monsterWaveFinal =
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 544
;543:			DEFAULT_MONSTER_WAVES;
;544:	}
LABELV $210
line 550
;545:
;546:	/*
;547:	 * Every enabled wave must contain at least
;548:	 * one monster definition.
;549:	 */
;550:	for( i = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $216
JUMPV
LABELV $213
line 552
;551:		i < monsterWaveFinal;
;552:		i++ ) {
line 553
;553:		if( monsterWaves[i].numEntries == 0 ) {
CNSTI4 104
ADDRLP4 8
INDIRI4
MULI4
ADDRGP4 monsterWaves+96
ADDP4
INDIRI4
CNSTI4 0
NEI4 $217
line 554
;554:			G_Printf(
ADDRGP4 $220
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 560
;555:				S_COLOR_RED
;556:				"Monster waves: wave %i is empty\n",
;557:				i + 1
;558:			);
;559:
;560:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $154
JUMPV
LABELV $217
line 562
;561:		}
;562:	}
LABELV $214
line 552
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $216
line 551
ADDRLP4 8
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
LTI4 $213
line 564
;563:
;564:	G_Printf(
ADDRGP4 $221
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
line 573
;565:		S_COLOR_GREEN
;566:		"Loaded monsterwaves.cfg: %i waves, "
;567:		"max %i active, timeout %i ms\n",
;568:		monsterWaveFinal,
;569:		monsterWaveMaxActive,
;570:		monsterWaveTimeout
;571:	);
;572:
;573:	return qtrue;
CNSTI4 1
RETI4
LABELV $154
endproc G_LoadMonsterWaveConfig 8260 16
export G_MonsterInitDefinitions
proc G_MonsterInitDefinitions 8 12
line 577
;574:}
;575:
;576:
;577:void G_MonsterInitDefinitions(void) {
line 580
;578:	int i;
;579:	
;580:	monsterItemCounter = 0;
ADDRGP4 monsterItemCounter
CNSTI4 0
ASGNI4
line 581
;581:	monsterActiveCount = 0;
ADDRGP4 monsterActiveCount
CNSTI4 0
ASGNI4
line 583
;582:	
;583:	monsterCurrentWave = 0;
ADDRGP4 monsterCurrentWave
CNSTI4 0
ASGNI4
line 584
;584:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 585
;585:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 586
;586:	monsterWaveNextSpawn = 0;
ADDRGP4 monsterWaveNextSpawn
CNSTI4 0
ASGNI4
line 587
;587:	monsterWaveNextStart = 0;
ADDRGP4 monsterWaveNextStart
CNSTI4 0
ASGNI4
line 588
;588:	monsterWaveLastProgress = 0;
ADDRGP4 monsterWaveLastProgress
CNSTI4 0
ASGNI4
line 590
;589:
;590:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 591
;591:	monsterWaveStarted = qfalse;
ADDRGP4 monsterWaveStarted
CNSTI4 0
ASGNI4
line 592
;592:	monsterWaveCombatStarted = qfalse;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 0
ASGNI4
line 593
;593:	monsterWaveFinished = qfalse;
ADDRGP4 monsterWaveFinished
CNSTI4 0
ASGNI4
line 595
;594:
;595:	memset(g_monsterDefs, 0, sizeof(g_monsterDefs));
ADDRGP4 g_monsterDefs
ARGP4
CNSTI4 0
ARGI4
CNSTI4 33120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 596
;596:	memset(g_monsterDefLoaded, 0, sizeof(g_monsterDefLoaded));
ADDRGP4 g_monsterDefLoaded
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 598
;597:
;598:	for (i = 0; monsterConfigFiles[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $226
JUMPV
LABELV $223
line 599
;599:		G_LoadMonsterConfig(monsterConfigFiles[i]);
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
line 600
;600:	}
LABELV $224
line 598
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $226
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $223
line 602
;601:	
;602:	monsterWavesLoaded = qfalse;
ADDRGP4 monsterWavesLoaded
CNSTI4 0
ASGNI4
line 607
;603:
;604:	/*
;605:	 * Both Monster Hunt modes use monsterwaves.cfg.
;606:	 */
;607:	if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $227
line 608
;608:		MONSTER_HUNT_OFF ) {
line 609
;609:		monsterWavesLoaded =
ADDRGP4 $230
ARGP4
ADDRLP4 4
ADDRGP4 G_LoadMonsterWaveConfig
CALLI4
ASGNI4
ADDRGP4 monsterWavesLoaded
ADDRLP4 4
INDIRI4
ASGNI4
line 613
;610:			G_LoadMonsterWaveConfig(
;611:				"monsterwaves.cfg"
;612:			);
;613:	}
LABELV $227
line 614
;614:}
LABELV $222
endproc G_MonsterInitDefinitions 8 12
proc G_MonsterEligibleItem 24 0
line 616
;615:
;616:static qboolean G_MonsterEligibleItem(gentity_t *item) {
line 617
;617:	if (!item || !item->item) {
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
EQU4 $234
ADDRLP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $232
LABELV $234
line 618
;618:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $231
JUMPV
LABELV $232
line 621
;619:	}
;620:
;621:	if (item->flags & FL_DROPPED_ITEM) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $235
line 622
;622:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $231
JUMPV
LABELV $235
line 625
;623:	}
;624:
;625:	if (item->team || item->targetname || item->wait == -1) {
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
NEU4 $240
ADDRLP4 8
INDIRP4
CNSTI4 652
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 12
INDIRU4
NEU4 $240
ADDRLP4 8
INDIRP4
CNSTI4 796
ADDP4
INDIRF4
CNSTF4 3212836864
NEF4 $237
LABELV $240
line 626
;626:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $231
JUMPV
LABELV $237
line 629
;627:	}
;628:
;629:	switch (item->item->giType) {
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
LTI4 $241
ADDRLP4 16
INDIRI4
CNSTI4 5
GTI4 $241
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $245-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $245
address $244
address $244
address $244
address $244
address $244
code
LABELV $244
line 635
;630:	case IT_WEAPON:
;631:	case IT_AMMO:
;632:	case IT_ARMOR:
;633:	case IT_HEALTH:
;634:	case IT_POWERUP:
;635:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $231
JUMPV
LABELV $241
line 638
;636:
;637:	default:
;638:		return qfalse;
CNSTI4 0
RETI4
LABELV $231
endproc G_MonsterEligibleItem 24 0
proc G_MonsterSetOrigin 0 8
line 645
;639:	}
;640:}
;641:
;642:static void G_MonsterSetOrigin(
;643:	gentity_t *monster,
;644:	const vec3_t origin
;645:) {
line 646
;646:	G_SetOrigin(monster, (float *)origin);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 652
;647:
;648:	/*
;649:	 * The client interpolates monsters between snapshots.
;650:	 * G_SetOrigin resets trType to TR_STATIONARY.
;651:	 */
;652:	monster->s.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 653
;653:	monster->s.pos.trTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 654
;654:}
LABELV $247
endproc G_MonsterSetOrigin 0 8
proc G_MonsterSpawnAtOrigin 52 12
line 661
;655:
;656:static qboolean G_MonsterSpawnAtOrigin(
;657:	gentity_t *item,
;658:	monsterDef_t *def,
;659:	vec3_t spawnOrigin,
;660:	qboolean waveSpawn
;661:) {
line 665
;662:	gentity_t *monster;
;663:	vec3_t origin;
;664:
;665:	if( waveSpawn ) {
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $250
line 666
;666:		if( monsterActiveCount >=
ADDRGP4 monsterActiveCount
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $251
line 667
;667:			monsterWaveMaxActive ) {
line 668
;668:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $249
JUMPV
line 670
;669:		}
;670:	}
LABELV $250
line 671
;671:	else if( monsterActiveCount >= 8 ) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $254
line 672
;672:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $249
JUMPV
LABELV $254
LABELV $251
line 675
;673:	}
;674:
;675:	if( !def ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $256
line 676
;676:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $249
JUMPV
LABELV $256
line 679
;677:	}
;678:
;679:	monster = G_Spawn();
ADDRLP4 16
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16
INDIRP4
ASGNP4
line 681
;680:
;681:	monster->classname = "monster";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $129
ASGNP4
line 682
;682:	monster->s.eType = ET_MONSTER;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 13
ASGNI4
line 684
;683:
;684:	if( def->models[0][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $258
line 685
;685:		monster->s.modelindex =
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
line 687
;686:			G_ModelIndex(def->models[0]);
;687:	}
LABELV $258
line 689
;688:
;689:	if( def->models[1][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $260
line 690
;690:		monster->s.modelindex2 =
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
line 692
;691:			G_ModelIndex(def->models[1]);
;692:	}
LABELV $260
line 694
;693:
;694:	if( def->models[2][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $262
line 695
;695:		monster->s.otherEntityNum =
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
line 697
;696:			G_ModelIndex(def->models[2]);
;697:	}
LABELV $262
line 699
;698:
;699:	if( def->models[3][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 256
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $264
line 700
;700:		monster->s.otherEntityNum2 =
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
line 702
;701:			G_ModelIndex(def->models[3]);
;702:	}
LABELV $264
line 704
;703:
;704:	monster->s.frame =
ADDRLP4 0
INDIRP4
CNSTI4 172
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 740
ADDP4
INDIRI4
ASGNI4
line 707
;705:		def->moveAnimation.firstFrame;
;706:
;707:	monster->s.groundEntityNum =
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 710
;708:		ENTITYNUM_NONE;
;709:
;710:	monster->s.apos.trType =
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 713
;711:		TR_STATIONARY;
;712:
;713:	monster->monsterType =
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
line 716
;714:		def->monsterType;
;715:
;716:	monster->monsterSlot =
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
line 723
;717:		def->monsterSlot;
;718:		
;719:	/*
;720:	 * Send monster definition identity to cgame.
;721:	 * Low byte: type, high byte: slot.
;722:	 */
;723:	monster->s.generic1 =
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
line 727
;724:		(def->monsterType & 255) |
;725:		((def->monsterSlot & 255) << 8);	
;726:
;727:	monster->monsterItem = item;
ADDRLP4 0
INDIRP4
CNSTI4 868
ADDP4
ADDRFP4 0
INDIRP4
ASGNP4
line 728
;728:	monster->monsterWaveSpawn = waveSpawn;
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
ADDRFP4 12
INDIRI4
ASGNI4
line 729
;729:	monster->monsterDead = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 0
ASGNI4
line 731
;730:
;731:	monster->health = def->health;
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
line 732
;732:	monster->takedamage = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 733
;733:	monster->pain = G_MonsterPain;
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
ADDRGP4 G_MonsterPain
ASGNP4
line 734
;734:	monster->die = G_MonsterDie;
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 G_MonsterDie
ASGNP4
line 736
;735:
;736:	monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 739
;737:		level.time + 500;
;738:
;739:	monster->monsterNextShot = 0;
ADDRLP4 0
INDIRP4
CNSTI4 876
ADDP4
CNSTI4 0
ASGNI4
line 740
;740:	monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 742
;741:
;742:	G_MonsterSetAnimation(
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
line 748
;743:		monster,
;744:		MONSTER_STATE_IDLE,
;745:		0
;746:	);
;747:
;748:	monster->monsterNextTalk =
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
line 752
;749:		level.time +
;750:		G_MonsterTalkDelay(def);
;751:
;752:	VectorCopy(
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
line 757
;753:		def->mins,
;754:		monster->r.mins
;755:	);
;756:
;757:	VectorCopy(
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
line 762
;758:		def->maxs,
;759:		monster->r.maxs
;760:	);
;761:
;762:	monster->r.contents = CONTENTS_BODY;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 33554432
ASGNI4
line 763
;763:	monster->clipmask = MASK_PLAYERSOLID;
ADDRLP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 33619969
ASGNI4
line 765
;764:
;765:	VectorCopy(spawnOrigin, origin);
ADDRLP4 4
ADDRFP4 8
INDIRP4
INDIRB
ASGNB 12
line 766
;766:	origin[2] += def->hoverHeight;
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
line 768
;767:
;768:	G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 773
;769:		monster,
;770:		origin
;771:	);
;772:	
;773:	monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 776
;774:	level.time;
;775:
;776:	VectorCopy(
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
line 781
;777:		monster->r.currentOrigin,
;778:		monster->monsterProgressOrigin
;779:	);
;780:
;781:	monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 784
;782:		level.time;
;783:
;784:	monster->monsterDriftPhase =
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
line 787
;785:		monster->s.number * 0.73f;
;786:
;787:	monster->think = G_MonsterThink;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterThink
ASGNP4
line 788
;788:	monster->nextthink = level.time + 50;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 790
;789:
;790:	trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 796
;791:
;792:	/*
;793:	 * Classic Monster Hunt replaces and hides a map item.
;794:	 * Wave monsters are independent from map items.
;795:	 */
;796:	if( item && !waveSpawn ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $272
ADDRFP4 12
INDIRI4
CNSTI4 0
NEI4 $272
line 797
;797:		item->monsterType =
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
line 800
;798:			def->monsterType;
;799:
;800:		item->monsterSlot =
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
line 803
;801:			def->monsterSlot;
;802:
;803:		item->s.eFlags |= EF_NODRAW;
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
line 804
;804:		item->r.svFlags |= SVF_NOCLIENT;
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
line 805
;805:		item->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 806
;806:		item->touch = 0;
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
CNSTP4 0
ASGNP4
line 807
;807:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 808
;808:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 810
;809:
;810:		trap_UnlinkEntity(item);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 811
;811:	}
LABELV $272
line 813
;812:
;813:	monsterActiveCount++;
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
line 822
;814:
;815:/*	G_Printf(
;816:		"Spawned %smonster %s at %s\n",
;817:		waveSpawn ? "wave " : "",
;818:		def->name,
;819:		vtos(origin)
;820:	);*/
;821:
;822:	return qtrue;
CNSTI4 1
RETI4
LABELV $249
endproc G_MonsterSpawnAtOrigin 52 12
proc G_MonsterSpawnFromItem 12 16
line 828
;823:}
;824:
;825:static qboolean G_MonsterSpawnFromItem(
;826:	gentity_t *item,
;827:	monsterDef_t *def
;828:) {
line 829
;829:	if( !item || !def ) {
ADDRLP4 0
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
EQU4 $277
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
NEU4 $275
LABELV $277
line 830
;830:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $274
JUMPV
LABELV $275
line 833
;831:	}
;832:
;833:	return G_MonsterSpawnAtOrigin(
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
LABELV $274
endproc G_MonsterSpawnFromItem 12 16
proc G_MonsterRespawnThink 32 8
line 841
;834:		item,
;835:		def,
;836:		item->s.pos.trBase,
;837:		qfalse
;838:	);
;839:}
;840:
;841:static void G_MonsterRespawnThink(gentity_t *item) {
line 844
;842:	monsterDef_t *def;
;843:
;844:	if (item->monsterType <= MONSTER_TYPE_OFF ||
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
LEI4 $283
ADDRLP4 8
INDIRI4
CNSTI4 6
GEI4 $283
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
LTI4 $283
ADDRLP4 16
INDIRI4
CNSTI4 5
LTI4 $279
LABELV $283
line 847
;845:		item->monsterType >= MONSTER_TYPE_RANDOM ||
;846:		item->monsterSlot < 0 ||
;847:		item->monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 848
;848:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 849
;849:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 850
;850:		return;
ADDRGP4 $278
JUMPV
LABELV $279
line 853
;851:	}
;852:
;853:	if (!g_monsterDefLoaded
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
NEI4 $284
line 855
;854:		[item->monsterType]
;855:		[item->monsterSlot]) {
line 856
;856:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 857
;857:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 858
;858:		return;
ADDRGP4 $278
JUMPV
LABELV $284
line 861
;859:	}
;860:
;861:	if (monsterActiveCount >= 8) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $286
line 862
;862:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 863
;863:		return;
ADDRGP4 $278
JUMPV
LABELV $286
line 866
;864:	}
;865:
;866:	def = &g_monsterDefs
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1104
ADDRLP4 24
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5520
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
line 870
;867:		[item->monsterType]
;868:		[item->monsterSlot];
;869:
;870:	if (!G_MonsterSpawnFromItem(item, def)) {
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
NEI4 $289
line 871
;871:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 872
;872:	}
LABELV $289
line 873
;873:}
LABELV $278
endproc G_MonsterRespawnThink 32 8
proc G_MonsterWaveHasPlayers 8 0
line 875
;874:
;875:static qboolean G_MonsterWaveHasPlayers( void ) {
line 879
;876:	gclient_t *client;
;877:	int i;
;878:
;879:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $296
JUMPV
LABELV $293
line 880
;880:		client = &level.clients[i];
ADDRLP4 0
CNSTI4 780
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 882
;881:
;882:		if( client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $298
line 883
;883:			CON_CONNECTED ) {
line 884
;884:			continue;
ADDRGP4 $294
JUMPV
LABELV $298
line 887
;885:		}
;886:
;887:		if( client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $300
line 888
;888:			TEAM_SPECTATOR ) {
line 889
;889:			continue;
ADDRGP4 $294
JUMPV
LABELV $300
line 892
;890:		}
;891:
;892:		if( client->oneLifeEliminated ) {
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $302
line 893
;893:			continue;
ADDRGP4 $294
JUMPV
LABELV $302
line 896
;894:		}
;895:
;896:		if( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $304
line 897
;897:			continue;
ADDRGP4 $294
JUMPV
LABELV $304
line 900
;898:		}
;899:
;900:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $292
JUMPV
LABELV $294
line 879
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $296
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $293
line 903
;901:	}
;902:
;903:	return qfalse;
CNSTI4 0
RETI4
LABELV $292
endproc G_MonsterWaveHasPlayers 8 0
proc G_MonsterWaveLivingCount 12 0
line 906
;904:}
;905:
;906:static int G_MonsterWaveLivingCount( void ) {
line 911
;907:	gentity_t *ent;
;908:	int count;
;909:	int i;
;910:
;911:	count = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 913
;912:
;913:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $310
JUMPV
LABELV $307
line 915
;914:		i < level.num_entities;
;915:		i++ ) {
line 916
;916:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 918
;917:
;918:		if( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $312
line 919
;919:			continue;
ADDRGP4 $308
JUMPV
LABELV $312
line 922
;920:		}
;921:
;922:		if( ent->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $314
line 923
;923:			continue;
ADDRGP4 $308
JUMPV
LABELV $314
line 926
;924:		}
;925:
;926:		if( !ent->monsterWaveSpawn ) {
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
NEI4 $316
line 927
;927:			continue;
ADDRGP4 $308
JUMPV
LABELV $316
line 930
;928:		}
;929:
;930:		if( ent->monsterDead ) {
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $318
line 931
;931:			continue;
ADDRGP4 $308
JUMPV
LABELV $318
line 934
;932:		}
;933:
;934:		count++;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 935
;935:	}
LABELV $308
line 915
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $310
line 914
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $307
line 937
;936:
;937:	return count;
ADDRLP4 8
INDIRI4
RETI4
LABELV $306
endproc G_MonsterWaveLivingCount 12 0
proc G_MonsterWaveSpotSafe 96 28
line 944
;938:}
;939:
;940:static qboolean G_MonsterWaveSpotSafe(
;941:	gentity_t *spot,
;942:	monsterDef_t *def,
;943:	qboolean requireDistance
;944:) {
line 950
;945:	gentity_t *player;
;946:	trace_t trace;
;947:	vec3_t origin;
;948:	int i;
;949:
;950:	if( !spot || !def ) {
ADDRLP4 76
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
EQU4 $323
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
NEU4 $321
LABELV $323
line 951
;951:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $321
line 954
;952:	}
;953:
;954:	if( SpotWouldTelefrag(spot) ) {
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
EQI4 $324
line 955
;955:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $324
line 958
;956:	}
;957:
;958:	VectorCopy(spot->s.origin, origin);
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 959
;959:	origin[2] += 9 + def->hoverHeight;
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
line 961
;960:
;961:	trap_Trace(
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
line 971
;962:		&trace,
;963:		origin,
;964:		def->mins,
;965:		def->maxs,
;966:		origin,
;967:		ENTITYNUM_NONE,
;968:		MASK_PLAYERSOLID
;969:	);
;970:
;971:	if( trace.startsolid || trace.allsolid ) {
ADDRLP4 88
CNSTI4 0
ASGNI4
ADDRLP4 20+4
INDIRI4
ADDRLP4 88
INDIRI4
NEI4 $330
ADDRLP4 20
INDIRI4
ADDRLP4 88
INDIRI4
EQI4 $327
LABELV $330
line 972
;972:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $327
line 975
;973:	}
;974:
;975:	if( !requireDistance ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $331
line 976
;976:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $320
JUMPV
LABELV $331
line 979
;977:	}
;978:
;979:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $336
JUMPV
LABELV $333
line 980
;980:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 982
;981:
;982:		if( !player->client ) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $338
line 983
;983:			continue;
ADDRGP4 $334
JUMPV
LABELV $338
line 986
;984:		}
;985:
;986:		if( player->client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $340
line 987
;987:			CON_CONNECTED ) {
line 988
;988:			continue;
ADDRGP4 $334
JUMPV
LABELV $340
line 991
;989:		}
;990:
;991:		if( player->client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $342
line 992
;992:			TEAM_SPECTATOR ) {
line 993
;993:			continue;
ADDRGP4 $334
JUMPV
LABELV $342
line 996
;994:		}
;995:
;996:		if( player->health <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $344
line 997
;997:			continue;
ADDRGP4 $334
JUMPV
LABELV $344
line 1000
;998:		}
;999:
;1000:		if( DistanceSquared(
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
GEF4 $346
line 1003
;1001:			spot->s.origin,
;1002:			player->r.currentOrigin
;1003:		) < 256.0f * 256.0f ) {
line 1004
;1004:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $346
line 1006
;1005:		}
;1006:	}
LABELV $334
line 979
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $336
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $333
line 1008
;1007:
;1008:	return qtrue;
CNSTI4 1
RETI4
LABELV $320
endproc G_MonsterWaveSpotSafe 96 28
proc G_MonsterWaveChooseSpawn 536 12
line 1014
;1009:}
;1010:
;1011:static qboolean G_MonsterWaveChooseSpawn(
;1012:	monsterDef_t *def,
;1013:	vec3_t origin
;1014:) {
line 1020
;1015:	gentity_t *spots[128];
;1016:	gentity_t *spot;
;1017:	int count;
;1018:	int pass;
;1019:
;1020:	for( pass = 0; pass < 2; pass++ ) {
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $349
line 1021
;1021:		count = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1022
;1022:		spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $354
JUMPV
LABELV $353
line 1028
;1023:
;1024:		while( (spot = G_Find(
;1025:			spot,
;1026:			FOFS(classname),
;1027:			"info_player_deathmatch"
;1028:		)) != NULL ) {
line 1029
;1029:			if( !G_MonsterWaveSpotSafe(
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $360
ADDRLP4 524
CNSTI4 1
ASGNI4
ADDRGP4 $361
JUMPV
LABELV $360
ADDRLP4 524
CNSTI4 0
ASGNI4
LABELV $361
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
NEI4 $357
line 1033
;1030:				spot,
;1031:				def,
;1032:				pass == 0
;1033:			) ) {
line 1034
;1034:				continue;
ADDRGP4 $354
JUMPV
LABELV $357
line 1037
;1035:			}
;1036:
;1037:			spots[count++] = spot;
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
line 1039
;1038:
;1039:			if( count >= 128 ) {
ADDRLP4 4
INDIRI4
CNSTI4 128
LTI4 $362
line 1040
;1040:				break;
ADDRGP4 $355
JUMPV
LABELV $362
line 1042
;1041:			}
;1042:		}
LABELV $354
line 1024
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $356
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
NEU4 $353
LABELV $355
line 1044
;1043:
;1044:		if( count > 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LEI4 $364
line 1045
;1045:			spot = spots[rand() % count];
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
line 1047
;1046:
;1047:			VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1052
;1048:				spot->s.origin,
;1049:				origin
;1050:			);
;1051:
;1052:			origin[2] += 9;
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
line 1053
;1053:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $348
JUMPV
LABELV $364
line 1055
;1054:		}
;1055:	}
LABELV $350
line 1020
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 2
LTI4 $349
line 1057
;1056:
;1057:	return qfalse;
CNSTI4 0
RETI4
LABELV $348
endproc G_MonsterWaveChooseSpawn 536 12
proc G_MonsterWaveBegin 8 8
line 1060
;1058:}
;1059:
;1060:static void G_MonsterWaveBegin( void ) {
line 1061
;1061:	monsterWaveActive = qtrue;
ADDRGP4 monsterWaveActive
CNSTI4 1
ASGNI4
line 1062
;1062:	monsterWaveCombatStarted = qtrue;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 1
ASGNI4
line 1063
;1063:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 1064
;1064:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1065
;1065:	monsterWaveNextSpawn = level.time;
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1066
;1066:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1068
;1067:
;1068:	trap_SendServerCommand(
ADDRGP4 $369
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
line 1076
;1069:		-1,
;1070:		va(
;1071:			"cp \"Wave %i\n\"",
;1072:			monsterCurrentWave
;1073:		)
;1074:	);
;1075:
;1076:	trap_SendServerCommand(
ADDRGP4 $370
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
line 1084
;1077:		-1,
;1078:		va(
;1079:			"print \"Monster Hunt: wave %i started.\n\"",
;1080:			monsterCurrentWave
;1081:		)
;1082:	);
;1083:
;1084:	G_Printf(
ADDRGP4 $371
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 1088
;1085:		"Monster Hunt: wave %i started.\n",
;1086:		monsterCurrentWave
;1087:	);
;1088:}
LABELV $366
endproc G_MonsterWaveBegin 8 8
proc G_MonsterWaveComplete 8 8
line 1090
;1089:
;1090:static void G_MonsterWaveComplete( void ) {
line 1091
;1091:	trap_SendServerCommand(
ADDRGP4 $373
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
line 1099
;1092:		-1,
;1093:		va(
;1094:			"print \"Monster Hunt: wave %i cleared.\n\"",
;1095:			monsterCurrentWave
;1096:		)
;1097:	);
;1098:
;1099:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 1101
;1100:
;1101:	if( monsterCurrentWave <
ADDRGP4 monsterCurrentWave
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
GEI4 $374
line 1102
;1102:		monsterWaveFinal ) {
line 1103
;1103:		monsterCurrentWave++;
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
line 1105
;1104:
;1105:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1109
;1106:			level.time +
;1107:			monsterWaveDelay;
;1108:
;1109:		return;
ADDRGP4 $372
JUMPV
LABELV $374
line 1116
;1110:	}
;1111:
;1112:	/*
;1113:	 * Classic Monster Hunt repeats the final wave until
;1114:	 * fraglimit or timelimit ends the match.
;1115:	 */
;1116:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 1
NEI4 $377
line 1117
;1117:		MONSTER_HUNT_CLASSIC ) {
line 1118
;1118:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1122
;1119:			level.time +
;1120:			monsterWaveDelay;
;1121:
;1122:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $381
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1127
;1123:			-1,
;1124:			"print \"Monster Hunt: final wave restarting.\n\""
;1125:		);
;1126:
;1127:		return;
ADDRGP4 $372
JUMPV
LABELV $377
line 1133
;1128:	}
;1129:
;1130:	/*
;1131:	 * One Life ends after clearing the final wave.
;1132:	 */
;1133:	monsterWaveFinished = qtrue;
ADDRGP4 monsterWaveFinished
CNSTI4 1
ASGNI4
line 1135
;1134:
;1135:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $382
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1140
;1136:		-1,
;1137:		"cp \"Monster Hunt completed!\n\""
;1138:	);
;1139:
;1140:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $383
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1145
;1141:		-1,
;1142:		"print \"Monster Hunt: all waves cleared.\n\""
;1143:	);
;1144:
;1145:	LogExit(
ADDRGP4 $384
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1148
;1146:		"Monster Hunt completed."
;1147:	);
;1148:}
LABELV $372
endproc G_MonsterWaveComplete 8 8
proc G_MonsterWaveRelocateStuck 48 12
line 1150
;1149:
;1150:static int G_MonsterWaveRelocateStuck( void ) {
line 1157
;1151:	gentity_t *monster;
;1152:	monsterDef_t *def;
;1153:	vec3_t origin;
;1154:	int relocated;
;1155:	int i;
;1156:
;1157:	relocated = 0;
ADDRLP4 24
CNSTI4 0
ASGNI4
line 1159
;1158:
;1159:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $389
JUMPV
LABELV $386
line 1161
;1160:		i < level.num_entities;
;1161:		i++ ) {
line 1162
;1162:		monster = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1164
;1163:
;1164:		if( !monster->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $391
line 1165
;1165:			continue;
ADDRGP4 $387
JUMPV
LABELV $391
line 1168
;1166:		}
;1167:
;1168:		if( monster->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $393
line 1169
;1169:			continue;
ADDRGP4 $387
JUMPV
LABELV $393
line 1172
;1170:		}
;1171:
;1172:		if( !monster->monsterWaveSpawn ||
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
EQI4 $397
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $395
LABELV $397
line 1173
;1173:			monster->monsterDead ) {
line 1174
;1174:			continue;
ADDRGP4 $387
JUMPV
LABELV $395
line 1181
;1175:		}
;1176:
;1177:		/*
;1178:		 * Relocate only monsters that have neither moved,
;1179:		 * fired nor received damage for the timeout period.
;1180:		 */
;1181:		if( level.time -
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
GEI4 $398
line 1183
;1182:			monster->monsterProgressTime <
;1183:			monsterWaveTimeout ) {
line 1184
;1184:			continue;
ADDRGP4 $387
JUMPV
LABELV $398
line 1187
;1185:		}
;1186:
;1187:		def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1104
ADDRLP4 0
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5520
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
line 1191
;1188:			[monster->monsterType]
;1189:			[monster->monsterSlot];
;1190:
;1191:		if( !G_MonsterWaveChooseSpawn(
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
NEI4 $401
line 1194
;1192:			def,
;1193:			origin
;1194:		) ) {
line 1195
;1195:			continue;
ADDRGP4 $387
JUMPV
LABELV $401
line 1202
;1196:		}
;1197:
;1198:		/*
;1199:		 * ChooseSpawn returns the base position.
;1200:		 * Apply the monster's configured hovering height.
;1201:		 */
;1202:		origin[2] += def->hoverHeight;
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
line 1204
;1203:
;1204:		G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1209
;1205:			monster,
;1206:			origin
;1207:		);
;1208:
;1209:		monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1212
;1210:			level.time;
;1211:
;1212:		VectorCopy(
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
line 1217
;1213:			monster->r.currentOrigin,
;1214:			monster->monsterProgressOrigin
;1215:		);
;1216:
;1217:		monster->enemy = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 768
ADDP4
CNSTP4 0
ASGNP4
line 1218
;1218:		monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 1219
;1219:		monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1221
;1220:			level.time + 500;
;1221:		monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1224
;1222:			level.time;
;1223:
;1224:		G_MonsterSetAnimation(
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
line 1230
;1225:			monster,
;1226:			MONSTER_STATE_MOVE,
;1227:			0
;1228:		);
;1229:
;1230:		trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1231
;1231:		relocated++;
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1232
;1232:	}
LABELV $387
line 1161
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $389
line 1160
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $386
line 1234
;1233:
;1234:	return relocated;
ADDRLP4 24
INDIRI4
RETI4
LABELV $385
endproc G_MonsterWaveRelocateStuck 48 12
export G_MonsterRunFrame
proc G_MonsterRunFrame 60 16
line 1237
;1235:}
;1236:
;1237:void G_MonsterRunFrame( void ) {
line 1244
;1238:	monsterWaveDef_t *wave;
;1239:	monsterWaveEntry_t *entry;
;1240:	monsterDef_t *def;
;1241:	vec3_t origin;
;1242:	int living;
;1243:
;1244:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
NEI4 $408
line 1245
;1245:		MONSTER_HUNT_OFF ) {
line 1246
;1246:		return;
ADDRGP4 $407
JUMPV
LABELV $408
line 1249
;1247:	}
;1248:
;1249:	if( !monsterWavesLoaded ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 monsterWavesLoaded
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $413
ADDRGP4 monsterWaveFinished
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $411
LABELV $413
line 1250
;1250:		monsterWaveFinished ) {
line 1251
;1251:		return;
ADDRGP4 $407
JUMPV
LABELV $411
line 1254
;1252:	}
;1253:
;1254:	if( level.intermissiontime ||
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 level+9128
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $420
ADDRGP4 level+9124
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $420
ADDRGP4 level+16
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $414
LABELV $420
line 1256
;1255:		level.intermissionQueued ||
;1256:		level.warmupTime ) {
line 1257
;1257:		return;
ADDRGP4 $407
JUMPV
LABELV $414
line 1260
;1258:	}
;1259:
;1260:	if( !G_MonsterWaveHasPlayers() ) {
ADDRLP4 36
ADDRGP4 G_MonsterWaveHasPlayers
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $421
line 1261
;1261:		return;
ADDRGP4 $407
JUMPV
LABELV $421
line 1264
;1262:	}
;1263:
;1264:	if( !monsterWaveStarted ) {
ADDRGP4 monsterWaveStarted
INDIRI4
CNSTI4 0
NEI4 $423
line 1265
;1265:		monsterWaveStarted = qtrue;
ADDRGP4 monsterWaveStarted
CNSTI4 1
ASGNI4
line 1266
;1266:		monsterCurrentWave = 1;
ADDRGP4 monsterCurrentWave
CNSTI4 1
ASGNI4
line 1267
;1267:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1270
;1268:			level.time + monsterWaveDelay;
;1269:
;1270:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $426
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1275
;1271:			-1,
;1272:			"print \"Monster Hunt begins.\n\""
;1273:		);
;1274:
;1275:		return;
ADDRGP4 $407
JUMPV
LABELV $423
line 1278
;1276:	}
;1277:
;1278:	if( !monsterWaveActive ) {
ADDRGP4 monsterWaveActive
INDIRI4
CNSTI4 0
NEI4 $427
line 1279
;1279:		if( level.time >= monsterWaveNextStart ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextStart
INDIRI4
LTI4 $407
line 1280
;1280:			G_MonsterWaveBegin();
ADDRGP4 G_MonsterWaveBegin
CALLV
pop
line 1281
;1281:		}
line 1283
;1282:
;1283:		return;
ADDRGP4 $407
JUMPV
LABELV $427
line 1286
;1284:	}
;1285:
;1286:	wave =
ADDRLP4 0
CNSTI4 104
ADDRGP4 monsterCurrentWave
INDIRI4
MULI4
ADDRGP4 monsterWaves-104
ADDP4
ASGNP4
ADDRGP4 $434
JUMPV
LABELV $433
line 1290
;1287:		&monsterWaves[monsterCurrentWave - 1];
;1288:
;1289:	while( monsterWaveEntry <
;1290:		wave->numEntries ) {
line 1291
;1291:		entry =
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1294
;1292:			&wave->entries[monsterWaveEntry];
;1293:
;1294:		if( monsterWaveEntrySpawned <
ADDRGP4 monsterWaveEntrySpawned
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
GEI4 $436
line 1295
;1295:			entry->count ) {
line 1296
;1296:			break;
ADDRGP4 $435
JUMPV
LABELV $436
line 1299
;1297:		}
;1298:
;1299:		monsterWaveEntry++;
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
line 1300
;1300:		monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1301
;1301:	}
LABELV $434
line 1289
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $433
LABELV $435
line 1303
;1302:
;1303:	living = G_MonsterWaveLivingCount();
ADDRLP4 40
ADDRGP4 G_MonsterWaveLivingCount
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 40
INDIRI4
ASGNI4
line 1309
;1304:
;1305:	/*
;1306:	 * Every configured monster has been spawned.
;1307:	 * Complete the wave after the last living monster dies.
;1308:	 */
;1309:	if( monsterWaveEntry >=
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $438
line 1310
;1310:		wave->numEntries ) {
line 1311
;1311:		if( living == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $440
line 1312
;1312:			G_MonsterWaveComplete();
ADDRGP4 G_MonsterWaveComplete
CALLV
pop
line 1313
;1313:			return;
ADDRGP4 $407
JUMPV
LABELV $440
line 1316
;1314:		}
;1315:
;1316:		if( level.time - monsterWaveLastProgress >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveLastProgress
INDIRI4
SUBI4
ADDRGP4 monsterWaveTimeout
INDIRI4
LTI4 $407
line 1317
;1317:			monsterWaveTimeout ) {
line 1320
;1318:			int relocated;
;1319:
;1320:			relocated =
ADDRLP4 48
ADDRGP4 G_MonsterWaveRelocateStuck
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 48
INDIRI4
ASGNI4
line 1323
;1321:				G_MonsterWaveRelocateStuck();
;1322:
;1323:			monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1339
;1324:
;1325:			/*trap_SendServerCommand(
;1326:				-1,
;1327:				va(
;1328:					"print \"Monster Hunt: relocated %i lost monsters.\n\"",
;1329:					relocated
;1330:				)
;1331:			);
;1332:
;1333:			G_Printf(
;1334:				"Monster Hunt: wave %i still has %i living monsters; relocated %i.\n",
;1335:				monsterCurrentWave,
;1336:				living,
;1337:				relocated
;1338:			);*/
;1339:		}
line 1341
;1340:
;1341:		return;
ADDRGP4 $407
JUMPV
LABELV $438
line 1344
;1342:	}
;1343:
;1344:	if( living >= monsterWaveMaxActive ) {
ADDRLP4 12
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $446
line 1345
;1345:		return;
ADDRGP4 $407
JUMPV
LABELV $446
line 1348
;1346:	}
;1347:
;1348:	if( level.time < monsterWaveNextSpawn ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextSpawn
INDIRI4
GEI4 $448
line 1349
;1349:		return;
ADDRGP4 $407
JUMPV
LABELV $448
line 1352
;1350:	}
;1351:
;1352:	entry = &wave->entries[monsterWaveEntry];
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1354
;1353:
;1354:	def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1104
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
MULI4
CNSTI4 5520
ADDRLP4 4
INDIRP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 1358
;1355:		[entry->monsterType]
;1356:		[entry->monsterSlot];
;1357:
;1358:	if( !G_MonsterWaveChooseSpawn(
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
NEI4 $451
line 1361
;1359:		def,
;1360:		origin
;1361:	) ) {
line 1362
;1362:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 1364
;1363:			level.time + 1000;
;1364:		return;
ADDRGP4 $407
JUMPV
LABELV $451
line 1367
;1365:	}
;1366:
;1367:	if( G_MonsterSpawnAtOrigin(
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
EQI4 $454
line 1372
;1368:		NULL,
;1369:		def,
;1370:		origin,
;1371:		qtrue
;1372:	) ) {
line 1373
;1373:	monsterWaveEntrySpawned++;
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
line 1374
;1374:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1376
;1375:
;1376:	monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
ADDI4
ASGNI4
line 1379
;1377:		level.time +
;1378:			monsterWaveSpawnInterval;
;1379:	}
ADDRGP4 $455
JUMPV
LABELV $454
line 1380
;1380:	else {
line 1381
;1381:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1383
;1382:			level.time + 500;
;1383:	}
LABELV $455
line 1384
;1384:}
LABELV $407
endproc G_MonsterRunFrame 60 16
export G_MonsterTryReplaceItem
proc G_MonsterTryReplaceItem 0 0
line 1388
;1385:
;1386:qboolean G_MonsterTryReplaceItem(
;1387:	gentity_t *item
;1388:) {
line 1393
;1389:	/*
;1390:	 * Both Monster Hunt modes now receive monsters
;1391:	 * exclusively from the wave controller.
;1392:	 */
;1393:	return qfalse;
CNSTI4 0
RETI4
LABELV $459
endproc G_MonsterTryReplaceItem 0 0
proc G_MonsterFindTarget 28 8
line 1396
;1394:}
;1395:
;1396:static gentity_t *G_MonsterFindTarget(gentity_t *monster) {
line 1402
;1397:	gentity_t *player;
;1398:	gentity_t *best;
;1399:	float bestDistance;
;1400:	int i;
;1401:
;1402:	best = NULL;
ADDRLP4 12
CNSTP4 0
ASGNP4
line 1403
;1403:	bestDistance = 99999999.0f;
ADDRLP4 8
CNSTF4 1287568416
ASGNF4
line 1405
;1404:
;1405:	for (i = 0; i < level.maxclients; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $464
JUMPV
LABELV $461
line 1408
;1406:		float distance;
;1407:
;1408:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1410
;1409:
;1410:		if (!player->client) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $466
line 1411
;1411:			continue;
ADDRGP4 $462
JUMPV
LABELV $466
line 1414
;1412:		}
;1413:
;1414:		if (player->client->pers.connected != CON_CONNECTED) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $468
line 1415
;1415:			continue;
ADDRGP4 $462
JUMPV
LABELV $468
line 1418
;1416:		}
;1417:
;1418:		if (player->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $470
line 1419
;1419:			continue;
ADDRGP4 $462
JUMPV
LABELV $470
line 1422
;1420:		}
;1421:
;1422:		if (player->health <= 0) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $472
line 1423
;1423:			continue;
ADDRGP4 $462
JUMPV
LABELV $472
line 1426
;1424:		}
;1425:
;1426:		distance = DistanceSquared(
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
line 1431
;1427:			monster->r.currentOrigin,
;1428:			player->r.currentOrigin
;1429:		);
;1430:
;1431:		if (distance < bestDistance) {
ADDRLP4 16
INDIRF4
ADDRLP4 8
INDIRF4
GEF4 $474
line 1432
;1432:			bestDistance = distance;
ADDRLP4 8
ADDRLP4 16
INDIRF4
ASGNF4
line 1433
;1433:			best = player;
ADDRLP4 12
ADDRLP4 0
INDIRP4
ASGNP4
line 1434
;1434:		}
LABELV $474
line 1435
;1435:	}
LABELV $462
line 1405
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $464
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $461
line 1437
;1436:
;1437:	return best;
ADDRLP4 12
INDIRP4
RETP4
LABELV $460
endproc G_MonsterFindTarget 28 8
proc G_MonsterAnimation 16 0
line 1443
;1438:}
;1439:
;1440:static animation_t *G_MonsterAnimation(
;1441:	gentity_t *monster,
;1442:	monsterDef_t *def
;1443:) {
line 1446
;1444:	int variant;
;1445:
;1446:	variant = monster->monsterAnimationVariant;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
INDIRI4
ASGNI4
line 1448
;1447:
;1448:	if (variant < 0 || variant >= MAX_MONSTER_VARIANTS) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $479
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $477
LABELV $479
line 1449
;1449:		variant = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1450
;1450:	}
LABELV $477
line 1452
;1451:
;1452:	switch (monster->monsterAnimation) {
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
LTI4 $480
ADDRLP4 8
INDIRI4
CNSTI4 5
GTI4 $480
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $489
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $489
address $483
address $484
address $485
address $486
address $487
address $488
code
LABELV $483
line 1454
;1453:	case MONSTER_STATE_IDLE:
;1454:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 712
ADDP4
RETP4
ADDRGP4 $476
JUMPV
LABELV $484
line 1457
;1455:
;1456:	case MONSTER_STATE_MOVE:
;1457:		return &def->moveAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 740
ADDP4
RETP4
ADDRGP4 $476
JUMPV
LABELV $485
line 1460
;1458:
;1459:	case MONSTER_STATE_MELEE:
;1460:		return &def->meleeAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 768
ADDP4
ADDP4
RETP4
ADDRGP4 $476
JUMPV
LABELV $486
line 1463
;1461:
;1462:	case MONSTER_STATE_RANGED:
;1463:		return &def->rangedAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 852
ADDP4
ADDP4
RETP4
ADDRGP4 $476
JUMPV
LABELV $487
line 1466
;1464:
;1465:	case MONSTER_STATE_PAIN:
;1466:		return &def->painAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 936
ADDP4
ADDP4
RETP4
ADDRGP4 $476
JUMPV
LABELV $488
line 1469
;1467:
;1468:	case MONSTER_STATE_DEATH:
;1469:		return &def->deathAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 1020
ADDP4
ADDP4
RETP4
ADDRGP4 $476
JUMPV
LABELV $480
line 1472
;1470:
;1471:	default:
;1472:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 712
ADDP4
RETP4
LABELV $476
endproc G_MonsterAnimation 16 0
proc G_MonsterSetAnimation 0 0
line 1480
;1473:	}
;1474:}
;1475:
;1476:static void G_MonsterSetAnimation(
;1477:	gentity_t *monster,
;1478:	int animation,
;1479:	int variant
;1480:) {
line 1481
;1481:	monster->monsterAnimation = animation;
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
ADDRFP4 4
INDIRI4
ASGNI4
line 1482
;1482:	monster->monsterAnimationVariant = variant;
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 1483
;1483:	monster->monsterAnimationStart = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 836
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1484
;1484:}
LABELV $490
endproc G_MonsterSetAnimation 0 0
proc G_MonsterUpdateAnimation 36 12
line 1489
;1485:
;1486:static void G_MonsterUpdateAnimation(
;1487:	gentity_t *monster,
;1488:	monsterDef_t *def
;1489:) {
line 1494
;1490:	animation_t *animation;
;1491:	int elapsed;
;1492:	int frame;
;1493:
;1494:	animation = G_MonsterAnimation(monster, def);
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
line 1496
;1495:
;1496:	if (animation->numFrames <= 0 ||
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
LEI4 $495
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
GTI4 $493
LABELV $495
line 1497
;1497:		animation->frameLerp <= 0) {
line 1498
;1498:		return;
ADDRGP4 $492
JUMPV
LABELV $493
line 1501
;1499:	}
;1500:
;1501:	elapsed = level.time - monster->monsterAnimationStart;
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
line 1502
;1502:	frame = elapsed / animation->frameLerp;
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
line 1504
;1503:
;1504:	if (frame >= animation->numFrames) {
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
LTI4 $497
line 1505
;1505:		if (animation->loopFrames > 0) {
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
LEI4 $499
line 1506
;1506:			frame =
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
line 1511
;1507:				animation->numFrames -
;1508:				animation->loopFrames +
;1509:				(frame - animation->numFrames) %
;1510:				animation->loopFrames;
;1511:		}
ADDRGP4 $500
JUMPV
LABELV $499
line 1512
;1512:		else {
line 1513
;1513:			frame = animation->numFrames - 1;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1515
;1514:
;1515:		if( monster->monsterAnimation ==
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
EQI4 $503
ADDRLP4 24
INDIRI4
CNSTI4 3
EQI4 $504
ADDRLP4 24
INDIRI4
CNSTI4 2
NEI4 $501
LABELV $504
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $501
LABELV $503
line 1521
;1516:				MONSTER_STATE_PAIN ||
;1517:			((monster->monsterAnimation ==
;1518:					MONSTER_STATE_RANGED ||
;1519:			  monster->monsterAnimation ==
;1520:					MONSTER_STATE_MELEE) &&
;1521:			 monster->monsterShotsRemaining <= 0) ) {
line 1522
;1522:				G_MonsterSetAnimation(
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
line 1528
;1523:					monster,
;1524:					MONSTER_STATE_IDLE,
;1525:					0
;1526:				);
;1527:
;1528:				animation = &def->idleAnimation;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 712
ADDP4
ASGNP4
line 1529
;1529:				frame = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1530
;1530:			}
LABELV $501
line 1531
;1531:		}
LABELV $500
line 1532
;1532:	}
LABELV $497
line 1534
;1533:
;1534:	monster->s.frame =
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
line 1536
;1535:		animation->firstFrame + frame;
;1536:}
LABELV $492
endproc G_MonsterUpdateAnimation 36 12
proc G_MonsterGroundWalker 88 28
line 1542
;1537:
;1538:static void G_MonsterGroundWalker(
;1539:	gentity_t *monster,
;1540:	monsterDef_t *def,
;1541:	int msec
;1542:) {
line 1547
;1543:	trace_t trace;
;1544:	vec3_t destination;
;1545:	float fallDistance;
;1546:
;1547:	if( def->movementType !=
ADDRFP4 4
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
EQI4 $506
line 1548
;1548:		MONSTER_MOVEMENT_WALKING ) {
line 1549
;1549:		return;
ADDRGP4 $505
JUMPV
LABELV $506
line 1552
;1550:	}
;1551:
;1552:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1557
;1553:		monster->r.currentOrigin,
;1554:		destination
;1555:	);
;1556:
;1557:	destination[2] -= 64;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 1559
;1558:
;1559:	trap_Trace(
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
line 1569
;1560:		&trace,
;1561:		monster->r.currentOrigin,
;1562:		monster->r.mins,
;1563:		monster->r.maxs,
;1564:		destination,
;1565:		monster->s.number,
;1566:		MASK_PLAYERSOLID
;1567:	);
;1568:
;1569:	if( !trace.startsolid &&
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $509
ADDRLP4 0
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $509
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $509
line 1571
;1570:		!trace.allsolid &&
;1571:		trace.fraction < 1.0f ) {
line 1572
;1572:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1577
;1573:			monster,
;1574:			trace.endpos
;1575:		);
;1576:
;1577:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1580
;1578:			trace.entityNum;
;1579:
;1580:		return;
ADDRGP4 $505
JUMPV
LABELV $509
line 1586
;1581:	}
;1582:
;1583:	/*
;1584:	 * No nearby floor: apply simple falling movement.
;1585:	 */
;1586:	fallDistance =
ADDRLP4 68
CNSTF4 1137180672
ADDRFP4 8
INDIRI4
CVIF4 4
MULF4
CNSTF4 1148846080
DIVF4
ASGNF4
line 1589
;1587:		400.0f * msec / 1000.0f;
;1588:
;1589:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1594
;1590:		monster->r.currentOrigin,
;1591:		destination
;1592:	);
;1593:
;1594:	destination[2] -= fallDistance;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
ADDRLP4 68
INDIRF4
SUBF4
ASGNF4
line 1596
;1595:
;1596:	trap_Trace(
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
line 1606
;1597:		&trace,
;1598:		monster->r.currentOrigin,
;1599:		monster->r.mins,
;1600:		monster->r.maxs,
;1601:		destination,
;1602:		monster->s.number,
;1603:		MASK_PLAYERSOLID
;1604:	);
;1605:
;1606:	if( !trace.startsolid &&
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $516
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $516
line 1607
;1607:		!trace.allsolid ) {
line 1608
;1608:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1612
;1609:			monster,
;1610:			trace.endpos
;1611:		);
;1612:	}
LABELV $516
line 1614
;1613:
;1614:	if( trace.fraction < 1.0f ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $520
line 1615
;1615:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1617
;1616:			trace.entityNum;
;1617:	}
ADDRGP4 $521
JUMPV
LABELV $520
line 1618
;1618:	else {
line 1619
;1619:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 1621
;1620:			ENTITYNUM_NONE;
;1621:	}
LABELV $521
line 1622
;1622:}
LABELV $505
endproc G_MonsterGroundWalker 88 28
proc G_MonsterFaceTarget 52 8
line 1627
;1623:
;1624:static void G_MonsterFaceTarget(
;1625:	gentity_t *monster,
;1626:	gentity_t *target
;1627:) {
line 1631
;1628:	vec3_t direction;
;1629:	vec3_t angles;
;1630:
;1631:	if( !monster || !target ) {
ADDRLP4 24
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
EQU4 $527
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
NEU4 $525
LABELV $527
line 1632
;1632:		return;
ADDRGP4 $524
JUMPV
LABELV $525
line 1635
;1633:	}
;1634:
;1635:	VectorSubtract(
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
line 1641
;1636:		target->r.currentOrigin,
;1637:		monster->r.currentOrigin,
;1638:		direction
;1639:	);
;1640:
;1641:	if( VectorNormalize(direction) <= 0.0f ) {
ADDRLP4 12
ARGP4
ADDRLP4 48
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 48
INDIRF4
CNSTF4 0
GTF4 $530
line 1642
;1642:		return;
ADDRGP4 $524
JUMPV
LABELV $530
line 1645
;1643:	}
;1644:
;1645:	vectoangles(direction, angles);
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1646
;1646:	angles[PITCH] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1647
;1647:	angles[ROLL] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1649
;1648:
;1649:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1650
;1650:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1651
;1651:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1652
;1652:}
LABELV $524
endproc G_MonsterFaceTarget 52 8
proc G_MonsterMove 324 28
line 1660
;1653:
;1654:
;1655:static void G_MonsterMove(
;1656:	gentity_t *monster,
;1657:	gentity_t *target,
;1658:	monsterDef_t *def,
;1659:	int msec
;1660:) {
line 1679
;1661:	trace_t trace;
;1662:	trace_t slideTrace;
;1663:	vec3_t targetOrigin;
;1664:	vec3_t direction;
;1665:	vec3_t right;
;1666:	vec3_t wishDirection;
;1667:	vec3_t velocity;
;1668:	vec3_t move;
;1669:	vec3_t destination;
;1670:	vec3_t slideMove;
;1671:	vec3_t slideDestination;
;1672:	vec3_t angles;
;1673:	float phase;
;1674:	float drift;
;1675:	float distance;
;1676:	float dot;
;1677:	qboolean shouldMove;
;1678:
;1679:	VectorCopy(
ADDRLP4 128
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1684
;1680:		target->r.currentOrigin,
;1681:		targetOrigin
;1682:	);
;1683:
;1684:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $534
line 1685
;1685:		MONSTER_MOVEMENT_WALKING ) {
line 1689
;1686:		/*
;1687:		 * Walking monsters chase only horizontally.
;1688:		 */
;1689:		targetOrigin[2] =
ADDRLP4 128+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ASGNF4
line 1691
;1690:			monster->r.currentOrigin[2];
;1691:	}
ADDRGP4 $535
JUMPV
LABELV $534
line 1692
;1692:	else {
line 1693
;1693:		targetOrigin[2] += 16;
ADDRLP4 128+8
ADDRLP4 128+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 1694
;1694:	}
LABELV $535
line 1696
;1695:
;1696:	VectorSubtract(
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
line 1702
;1697:		targetOrigin,
;1698:		monster->r.currentOrigin,
;1699:		direction
;1700:	);
;1701:
;1702:	distance = VectorNormalize(direction);
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
line 1704
;1703:
;1704:	if (distance <= 0.0f) {
ADDRLP4 168
INDIRF4
CNSTF4 0
GTF4 $542
line 1705
;1705:		return;
ADDRGP4 $533
JUMPV
LABELV $542
line 1711
;1706:	}
;1707:	/*
;1708:	 * A nearby target behind a wall is not yet a valid
;1709:	 * firing position, so continue moving toward it.
;1710:	 */
;1711:	shouldMove =
ADDRLP4 168
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 648
ADDP4
INDIRF4
GTF4 $547
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
NEI4 $545
LABELV $547
ADDRLP4 260
CNSTI4 1
ASGNI4
ADDRGP4 $546
JUMPV
LABELV $545
ADDRLP4 260
CNSTI4 0
ASGNI4
LABELV $546
ADDRLP4 172
ADDRLP4 260
INDIRI4
ASGNI4
line 1722
;1712:		distance > def->attackRange ||
;1713:		!G_MonsterCanSeeTarget(
;1714:			monster,
;1715:			target
;1716:		);
;1717:	
;1718:	/*
;1719:	 * Switch between standing and movement animations
;1720:	 * without interrupting attacks, pain or death.
;1721:	 */
;1722:	if( monster->monsterAnimation ==
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
EQI4 $550
ADDRLP4 268
INDIRI4
CNSTI4 1
NEI4 $548
LABELV $550
line 1725
;1723:			MONSTER_STATE_IDLE ||
;1724:		monster->monsterAnimation ==
;1725:			MONSTER_STATE_MOVE ) {
line 1726
;1726:		if( shouldMove ||
ADDRLP4 172
INDIRI4
CNSTI4 0
NEI4 $553
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $551
LABELV $553
line 1728
;1727:			def->movePattern ==
;1728:				MONSTER_PATTERN_DRIFT ) {
line 1729
;1729:			if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
EQI4 $552
line 1730
;1730:				MONSTER_STATE_MOVE ) {
line 1731
;1731:				G_MonsterSetAnimation(
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
line 1736
;1732:					monster,
;1733:					MONSTER_STATE_MOVE,
;1734:					0
;1735:				);
;1736:			}
line 1737
;1737:		}
ADDRGP4 $552
JUMPV
LABELV $551
line 1738
;1738:		else if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 0
EQI4 $556
line 1739
;1739:			MONSTER_STATE_IDLE ) {
line 1740
;1740:			G_MonsterSetAnimation(
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
line 1745
;1741:				monster,
;1742:				MONSTER_STATE_IDLE,
;1743:				0
;1744:			);
;1745:		}
LABELV $556
LABELV $552
line 1746
;1746:	}
LABELV $548
line 1748
;1747:
;1748:	VectorSet(
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
line 1755
;1749:		right,
;1750:		-direction[1],
;1751:		direction[0],
;1752:		0
;1753:	);
;1754:
;1755:	if (VectorNormalize(right) <= 0.0f) {
ADDRLP4 104
ARGP4
ADDRLP4 272
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 272
INDIRF4
CNSTF4 0
GTF4 $561
line 1756
;1756:		VectorSet(right, 1, 0, 0);
ADDRLP4 104
CNSTF4 1065353216
ASGNF4
ADDRLP4 104+4
CNSTF4 0
ASGNF4
ADDRLP4 104+8
CNSTF4 0
ASGNF4
line 1757
;1757:	}
LABELV $561
line 1759
;1758:
;1759:	drift = 0.0f;
ADDRLP4 164
CNSTF4 0
ASGNF4
line 1761
;1760:
;1761:	if (def->movePattern == MONSTER_PATTERN_DRIFT &&
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
NEI4 $565
ADDRLP4 276
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
CNSTI4 0
LEI4 $565
line 1762
;1762:		def->driftPeriod > 0) {
line 1763
;1763:		phase =
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
line 1767
;1764:			(level.time % def->driftPeriod) /
;1765:			(float)def->driftPeriod;
;1766:
;1767:		phase *= 6.2831853f;
ADDRLP4 176
CNSTF4 1086918619
ADDRLP4 176
INDIRF4
MULF4
ASGNF4
line 1768
;1768:		phase += monster->monsterDriftPhase;
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
line 1770
;1769:
;1770:		drift =
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
line 1773
;1771:			sin(phase) *
;1772:			def->driftAmount;
;1773:	}
LABELV $565
line 1775
;1774:
;1775:	VectorClear(velocity);
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
line 1777
;1776:
;1777:	if (shouldMove) {
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $570
line 1778
;1778:		VectorCopy(direction, wishDirection);
ADDRLP4 140
ADDRLP4 80
INDIRB
ASGNB 12
line 1780
;1779:
;1780:		if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $572
line 1781
;1781:			MONSTER_PATTERN_DRIFT) {
line 1782
;1782:			VectorMA(
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
line 1788
;1783:				wishDirection,
;1784:				drift,
;1785:				right,
;1786:				wishDirection
;1787:			);
;1788:		}
LABELV $572
line 1790
;1789:
;1790:		if (VectorNormalize(wishDirection) <= 0.0f) {
ADDRLP4 140
ARGP4
ADDRLP4 284
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 284
INDIRF4
CNSTF4 0
GTF4 $580
line 1791
;1791:			return;
ADDRGP4 $533
JUMPV
LABELV $580
line 1794
;1792:		}
;1793:
;1794:		VectorScale(
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
line 1799
;1795:			wishDirection,
;1796:			def->speed,
;1797:			velocity
;1798:		);
;1799:	}
ADDRGP4 $571
JUMPV
LABELV $570
line 1800
;1800:	else if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $533
line 1801
;1801:		MONSTER_PATTERN_DRIFT) {
line 1807
;1802:		/*
;1803:		 * Inside attack range, smoothly strafe.
;1804:		 * Do not normalize this vector: driftAmount must
;1805:		 * affect the actual lateral speed.
;1806:		 */
;1807:		VectorScale(
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
line 1812
;1808:			right,
;1809:			drift * def->speed,
;1810:			velocity
;1811:		);
;1812:	}
line 1813
;1813:	else {
line 1814
;1814:		return;
LABELV $587
LABELV $571
line 1817
;1815:	}
;1816:
;1817:	VectorScale(
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
line 1823
;1818:		velocity,
;1819:		msec / 1000.0f,
;1820:		move
;1821:	);
;1822:
;1823:	if (VectorLengthSquared(move) <= 0.0001f) {
ADDRLP4 56
ARGP4
ADDRLP4 288
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 288
INDIRF4
CNSTF4 953267991
GTF4 $596
line 1824
;1824:		return;
ADDRGP4 $533
JUMPV
LABELV $596
line 1827
;1825:	}
;1826:
;1827:	VectorAdd(
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
line 1833
;1828:		monster->r.currentOrigin,
;1829:		move,
;1830:		destination
;1831:	);
;1832:
;1833:	trap_Trace(
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
line 1843
;1834:		&trace,
;1835:		monster->r.currentOrigin,
;1836:		monster->r.mins,
;1837:		monster->r.maxs,
;1838:		destination,
;1839:		monster->s.number,
;1840:		MASK_PLAYERSOLID
;1841:	);
;1842:
;1843:	G_MonsterSetOrigin(monster, trace.endpos);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1845
;1844:
;1845:	if (trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $603
ADDRLP4 300
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $603
ADDRLP4 0
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $603
line 1847
;1846:		!trace.startsolid &&
;1847:		!trace.allsolid) {
line 1851
;1848:		/*
;1849:		 * Slide only for the uncompleted part of movement.
;1850:		 */
;1851:		VectorScale(
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
line 1857
;1852:			move,
;1853:			1.0f - trace.fraction,
;1854:			slideMove
;1855:		);
;1856:
;1857:		dot = DotProduct(
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
line 1862
;1858:			slideMove,
;1859:			trace.plane.normal
;1860:		);
;1861:
;1862:		VectorMA(
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
line 1869
;1863:			slideMove,
;1864:			-dot,
;1865:			trace.plane.normal,
;1866:			slideMove
;1867:		);
;1868:
;1869:		if (VectorLengthSquared(slideMove) > 0.0001f) {
ADDRLP4 92
ARGP4
ADDRLP4 312
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 312
INDIRF4
CNSTF4 953267991
LEF4 $630
line 1870
;1870:			VectorAdd(
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
line 1876
;1871:				monster->r.currentOrigin,
;1872:				slideMove,
;1873:				slideDestination
;1874:			);
;1875:
;1876:			trap_Trace(
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
line 1886
;1877:				&slideTrace,
;1878:				monster->r.currentOrigin,
;1879:				monster->r.mins,
;1880:				monster->r.maxs,
;1881:				slideDestination,
;1882:				monster->s.number,
;1883:				MASK_PLAYERSOLID
;1884:			);
;1885:
;1886:			G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1890
;1887:				monster,
;1888:				slideTrace.endpos
;1889:			);
;1890:		}
LABELV $630
line 1891
;1891:	}
LABELV $603
line 1893
;1892:
;1893:	vectoangles(direction, angles);
ADDRLP4 80
ARGP4
ADDRLP4 116
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1894
;1894:	angles[PITCH] = 0;
ADDRLP4 116
CNSTF4 0
ASGNF4
line 1895
;1895:	angles[ROLL] = 0;
ADDRLP4 116+8
CNSTF4 0
ASGNF4
line 1897
;1896:
;1897:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1898
;1898:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1899
;1899:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1901
;1900:
;1901:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1902
;1902:}
LABELV $533
endproc G_MonsterMove 324 28
proc G_MonsterValidTarget 8 0
line 1904
;1903:
;1904:static qboolean G_MonsterValidTarget(gentity_t *target) {
line 1905
;1905:	if (!target || !target->client) {
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
EQU4 $641
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $639
LABELV $641
line 1906
;1906:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $638
JUMPV
LABELV $639
line 1909
;1907:	}
;1908:
;1909:	if (target->client->pers.connected != CON_CONNECTED) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $642
line 1910
;1910:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $638
JUMPV
LABELV $642
line 1913
;1911:	}
;1912:
;1913:	if (target->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $644
line 1914
;1914:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $638
JUMPV
LABELV $644
line 1917
;1915:	}
;1916:
;1917:	if (target->health <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $646
line 1918
;1918:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $638
JUMPV
LABELV $646
line 1921
;1919:	}
;1920:
;1921:	return qtrue;
CNSTI4 1
RETI4
LABELV $638
endproc G_MonsterValidTarget 8 0
proc G_MonsterFireProjectile 64 12
line 1932
;1922:}
;1923:
;1924:static void G_MonsterFireProjectile(
;1925:	gentity_t *monster,
;1926:	gentity_t *target,
;1927:	monsterDef_t *def,
;1928:	const char *projectile,
;1929:	int damage,
;1930:	int splashDamage,
;1931:	int splashRadius
;1932:) {
line 1938
;1933:	gentity_t *bolt;
;1934:	vec3_t start;
;1935:	vec3_t targetOrigin;
;1936:	vec3_t direction;
;1937:
;1938:	VectorCopy(
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1943
;1939:		monster->r.currentOrigin,
;1940:		start
;1941:	);
;1942:
;1943:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $649
line 1944
;1944:		MONSTER_MOVEMENT_WALKING ) {
line 1945
;1945:		start[2] += 36;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1108344832
ADDF4
ASGNF4
line 1946
;1946:	}
ADDRGP4 $650
JUMPV
LABELV $649
line 1947
;1947:	else {
line 1948
;1948:		start[2] += 8;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 1949
;1949:	}
LABELV $650
line 1951
;1950:
;1951:	VectorCopy(
ADDRLP4 28
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1956
;1952:		target->r.currentOrigin,
;1953:		targetOrigin
;1954:	);
;1955:
;1956:	targetOrigin[2] +=
ADDRLP4 28+8
ADDRLP4 28+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 1959
;1957:		DEFAULT_VIEWHEIGHT * 0.5f;
;1958:
;1959:	VectorSubtract(
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
line 1965
;1960:		targetOrigin,
;1961:		start,
;1962:		direction
;1963:	);
;1964:
;1965:	VectorNormalize(direction);
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 1967
;1966:
;1967:	VectorMA(
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
line 1974
;1968:		start,
;1969:		24,
;1970:		direction,
;1971:		start
;1972:	);
;1973:
;1974:	if( projectile &&
ADDRLP4 44
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 44
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $666
ADDRLP4 44
INDIRP4
ARGP4
ADDRGP4 $668
ARGP4
ADDRLP4 48
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
NEI4 $666
line 1975
;1975:		!Q_stricmp(projectile, "rocket") ) {
line 1976
;1976:		bolt = fire_rocket(
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
line 1981
;1977:			monster,
;1978:			start,
;1979:			direction
;1980:		);
;1981:	}
ADDRGP4 $667
JUMPV
LABELV $666
line 1982
;1982:	else {
line 1983
;1983:		bolt = fire_plasma(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 52
ADDRGP4 fire_plasma
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 52
INDIRP4
ASGNP4
line 1988
;1984:			monster,
;1985:			start,
;1986:			direction
;1987:		);
;1988:	}
LABELV $667
line 1990
;1989:
;1990:	bolt->damage = damage;
ADDRLP4 0
INDIRP4
CNSTI4 740
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
line 1991
;1991:	bolt->splashDamage = splashDamage;
ADDRLP4 0
INDIRP4
CNSTI4 744
ADDP4
ADDRFP4 20
INDIRI4
ASGNI4
line 1992
;1992:	bolt->splashRadius = splashRadius;
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
ADDRFP4 24
INDIRI4
ASGNI4
line 1994
;1993:
;1994:	VectorScale(
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
line 2000
;1995:		direction,
;1996:		def->projectileSpeed,
;1997:		bolt->s.pos.trDelta
;1998:	);
;1999:
;2000:	SnapVector(bolt->s.pos.trDelta);
ADDRLP4 52
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ASGNP4
ADDRLP4 52
INDIRP4
ADDRLP4 52
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 56
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 60
ADDRLP4 0
INDIRP4
CNSTI4 44
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
line 2002
;2001:
;2002:	if( monster->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $671
line 2003
;2003:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2006
;2004:			level.time;
;2005:
;2006:		VectorCopy(
ADDRLP4 52
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 52
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 52
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2010
;2007:			monster->r.currentOrigin,
;2008:			monster->monsterProgressOrigin
;2009:		);
;2010:	}
LABELV $671
line 2011
;2011:}
LABELV $648
endproc G_MonsterFireProjectile 64 12
proc G_MonsterStartRangedAttack 72 12
line 2017
;2012:
;2013:static void G_MonsterStartRangedAttack(
;2014:	gentity_t *monster,
;2015:	gentity_t *target,
;2016:	monsterDef_t *def
;2017:) {
line 2025
;2018:	animation_t *animation;
;2019:	int variant;
;2020:	int fireFrame;
;2021:	int windup;
;2022:	vec3_t direction;
;2023:	vec3_t angles;
;2024:
;2025:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2026
;2026:	animation = &def->rangedAnimations[variant];
ADDRLP4 4
CNSTI4 28
ADDRLP4 20
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 852
ADDP4
ADDP4
ASGNP4
line 2028
;2027:
;2028:	fireFrame = def->attackFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 656
ADDP4
INDIRI4
ASGNI4
line 2030
;2029:
;2030:	if (fireFrame < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $675
line 2031
;2031:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2032
;2032:	}
LABELV $675
line 2034
;2033:
;2034:	if (animation->numFrames > 0 &&
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
LEI4 $677
ADDRLP4 0
INDIRI4
ADDRLP4 44
INDIRI4
LTI4 $677
line 2035
;2035:		fireFrame >= animation->numFrames) {
line 2036
;2036:		fireFrame = animation->numFrames - 1;
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2037
;2037:	}
LABELV $677
line 2039
;2038:
;2039:	windup = fireFrame * animation->frameLerp;
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
line 2044
;2040:
;2041:	/*
;2042:	 * Face the target when the attack animation begins.
;2043:	 */
;2044:	VectorSubtract(
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
line 2050
;2045:		target->r.currentOrigin,
;2046:		monster->r.currentOrigin,
;2047:		direction
;2048:	);
;2049:
;2050:	if( VectorNormalize(direction) > 0.0f ) {
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
LEF4 $681
line 2051
;2051:		vectoangles(direction, angles);
ADDRLP4 8
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2053
;2052:
;2053:		angles[PITCH] = 0;
ADDRLP4 24
CNSTF4 0
ASGNF4
line 2054
;2054:		angles[ROLL] = 0;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 2056
;2055:
;2056:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2061
;2057:			angles,
;2058:			monster->s.angles
;2059:		);
;2060:
;2061:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2066
;2062:			angles,
;2063:			monster->s.apos.trBase
;2064:		);
;2065:
;2066:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2070
;2067:			angles,
;2068:			monster->r.currentAngles
;2069:		);
;2070:	}
LABELV $681
line 2072
;2071:
;2072:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2073
;2073:	monster->monsterShotsRemaining = def->burstCount;
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
line 2074
;2074:	monster->monsterNextShot = level.time + windup;
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
line 2076
;2075:
;2076:	G_MonsterSetAnimation(
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
line 2081
;2077:		monster,
;2078:		MONSTER_STATE_RANGED,
;2079:		variant
;2080:	);
;2081:}
LABELV $674
endproc G_MonsterStartRangedAttack 72 12
proc G_MonsterStartMeleeAttack 24 12
line 2087
;2082:
;2083:static void G_MonsterStartMeleeAttack(
;2084:	gentity_t *monster,
;2085:	gentity_t *target,
;2086:	monsterDef_t *def
;2087:) {
line 2093
;2088:	animation_t *animation;
;2089:	int variant;
;2090:	int fireFrame;
;2091:	int windup;
;2092:
;2093:	variant =
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
line 2096
;2094:		rand() % MAX_MONSTER_VARIANTS;
;2095:
;2096:	animation =
ADDRLP4 4
CNSTI4 28
ADDRLP4 8
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 768
ADDP4
ADDP4
ASGNP4
line 2099
;2097:		&def->meleeAnimations[variant];
;2098:
;2099:	fireFrame = def->meleeFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
ASGNI4
line 2101
;2100:
;2101:	if( fireFrame < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $686
line 2102
;2102:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2103
;2103:	}
LABELV $686
line 2105
;2104:
;2105:	if( animation->numFrames > 0 &&
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
LEI4 $688
ADDRLP4 0
INDIRI4
ADDRLP4 20
INDIRI4
LTI4 $688
line 2106
;2106:		fireFrame >= animation->numFrames ) {
line 2107
;2107:		fireFrame =
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2109
;2108:			animation->numFrames - 1;
;2109:	}
LABELV $688
line 2111
;2110:
;2111:	windup =
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
line 2115
;2112:		fireFrame *
;2113:		animation->frameLerp;
;2114:
;2115:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2116
;2116:	monster->monsterShotsRemaining = 1;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 1
ASGNI4
line 2117
;2117:	monster->monsterNextShot =
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
line 2120
;2118:		level.time + windup;
;2119:
;2120:	G_MonsterSetAnimation(
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
line 2125
;2121:		monster,
;2122:		MONSTER_STATE_MELEE,
;2123:		variant
;2124:	);
;2125:}
LABELV $685
endproc G_MonsterStartMeleeAttack 24 12
proc G_MonsterCanSeeTarget 92 28
line 2130
;2126:
;2127:static qboolean G_MonsterCanSeeTarget(
;2128:	gentity_t *monster,
;2129:	gentity_t *target
;2130:) {
line 2135
;2131:	trace_t trace;
;2132:	vec3_t start;
;2133:	vec3_t end;
;2134:
;2135:	if (!G_MonsterValidTarget(target)) {
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
NEI4 $692
line 2136
;2136:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $691
JUMPV
LABELV $692
line 2139
;2137:	}
;2138:
;2139:	VectorCopy(monster->r.currentOrigin, start);
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2140
;2140:	start[2] += 8;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2142
;2141:
;2142:	VectorCopy(target->r.currentOrigin, end);
ADDRLP4 68
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2143
;2143:	end[2] += DEFAULT_VIEWHEIGHT * 0.5f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 2145
;2144:
;2145:	trap_Trace(
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
line 2155
;2146:		&trace,
;2147:		start,
;2148:		NULL,
;2149:		NULL,
;2150:		end,
;2151:		monster->s.number,
;2152:		MASK_SHOT
;2153:	);
;2154:
;2155:	return trace.fraction == 1.0f ||
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $701
ADDRLP4 0+52
INDIRI4
ADDRFP4 4
INDIRP4
INDIRI4
NEI4 $699
LABELV $701
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRGP4 $700
JUMPV
LABELV $699
ADDRLP4 88
CNSTI4 0
ASGNI4
LABELV $700
ADDRLP4 88
INDIRI4
RETI4
LABELV $691
endproc G_MonsterCanSeeTarget 92 28
proc G_MonsterRunAttack 36 28
line 2162
;2156:		trace.entityNum == target->s.number;
;2157:}
;2158:
;2159:static void G_MonsterRunAttack(
;2160:	gentity_t *monster,
;2161:	monsterDef_t *def
;2162:) {
line 2165
;2163:	qboolean meleeAttack;
;2164:
;2165:	if( monster->monsterShotsRemaining <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $703
line 2166
;2166:		return;
ADDRGP4 $702
JUMPV
LABELV $703
line 2169
;2167:	}
;2168:
;2169:	if( !G_MonsterValidTarget(monster->enemy) ||
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
EQI4 $707
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
NEI4 $705
LABELV $707
line 2173
;2170:		!G_MonsterCanSeeTarget(
;2171:			monster,
;2172:			monster->enemy
;2173:		) ) {
line 2174
;2174:		monster->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2176
;2175:
;2176:		monster->monsterNextAttack =
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
line 2180
;2177:			level.time +
;2178:			def->attackCooldown;
;2179:
;2180:		return;
ADDRGP4 $702
JUMPV
LABELV $705
line 2183
;2181:	}
;2182:
;2183:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
INDIRI4
GEI4 $709
line 2184
;2184:		monster->monsterNextShot ) {
line 2185
;2185:		return;
ADDRGP4 $702
JUMPV
LABELV $709
line 2188
;2186:	}
;2187:
;2188:	meleeAttack =
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 2
NEI4 $713
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $714
JUMPV
LABELV $713
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $714
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
line 2192
;2189:		monster->monsterAnimation ==
;2190:		MONSTER_STATE_MELEE;
;2191:
;2192:	if( meleeAttack ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $715
line 2193
;2193:		G_MonsterSound(
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
ADDRGP4 $717
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
line 2200
;2194:			monster,
;2195:			def,
;2196:			"melee",
;2197:			monster->monsterAnimationVariant
;2198:		);
;2199:
;2200:		G_MonsterFireProjectile(
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
line 2209
;2201:			monster,
;2202:			monster->enemy,
;2203:			def,
;2204:			def->meleeProjectile,
;2205:			def->meleeDamage,
;2206:			0,
;2207:			0
;2208:		);
;2209:	}
ADDRGP4 $716
JUMPV
LABELV $715
line 2210
;2210:	else {
line 2211
;2211:		G_MonsterSound(
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
ADDRGP4 $718
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
line 2218
;2212:			monster,
;2213:			def,
;2214:			"ranged",
;2215:			monster->monsterAnimationVariant
;2216:		);
;2217:
;2218:		G_MonsterFireProjectile(
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
line 2227
;2219:			monster,
;2220:			monster->enemy,
;2221:			def,
;2222:			def->projectile,
;2223:			def->projectileDamage,
;2224:			def->splashDamage,
;2225:			def->splashRadius
;2226:		);
;2227:	}
LABELV $716
line 2229
;2228:
;2229:	monster->monsterShotsRemaining--;
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
line 2231
;2230:
;2231:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $719
line 2232
;2232:		monster->monsterNextShot =
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
line 2235
;2233:			level.time +
;2234:			def->burstInterval;
;2235:	}
ADDRGP4 $720
JUMPV
LABELV $719
line 2236
;2236:	else {
line 2237
;2237:		monster->monsterNextAttack =
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
line 2240
;2238:			level.time +
;2239:			def->attackCooldown;
;2240:	}
LABELV $720
line 2241
;2241:}
LABELV $702
endproc G_MonsterRunAttack 36 28
proc G_MonsterAttack 32 12
line 2247
;2242:
;2243:static void G_MonsterAttack(
;2244:	gentity_t *monster,
;2245:	gentity_t *target,
;2246:	monsterDef_t *def
;2247:) {
line 2250
;2248:	float distanceSquared;
;2249:
;2250:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $724
line 2251
;2251:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2255
;2252:			monster,
;2253:			def
;2254:		);
;2255:		return;
ADDRGP4 $723
JUMPV
LABELV $724
line 2258
;2256:	}
;2257:
;2258:	if( monster->monsterAnimation !=
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
EQI4 $726
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $726
line 2261
;2259:			MONSTER_STATE_MOVE &&
;2260:		monster->monsterAnimation !=
;2261:			MONSTER_STATE_IDLE ) {
line 2262
;2262:		return;
ADDRGP4 $723
JUMPV
LABELV $726
line 2265
;2263:	}
;2264:
;2265:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
INDIRI4
GEI4 $728
line 2266
;2266:		monster->monsterNextAttack ) {
line 2267
;2267:		return;
ADDRGP4 $723
JUMPV
LABELV $728
line 2270
;2268:	}
;2269:
;2270:	distanceSquared = DistanceSquared(
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
line 2275
;2271:		monster->r.currentOrigin,
;2272:		target->r.currentOrigin
;2273:	);
;2274:
;2275:	if( !G_MonsterCanSeeTarget(
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
NEI4 $731
line 2278
;2276:		monster,
;2277:		target
;2278:	) ) {
line 2279
;2279:		return;
ADDRGP4 $723
JUMPV
LABELV $731
line 2285
;2280:	}
;2281:
;2282:	/*
;2283:	 * Prefer melee whenever the target is close enough.
;2284:	 */
;2285:	if( def->hasMelee &&
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
EQI4 $733
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
GTF4 $733
line 2288
;2286:		distanceSquared <=
;2287:			def->meleeRange *
;2288:			def->meleeRange ) {
line 2289
;2289:		G_MonsterStartMeleeAttack(
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
line 2295
;2290:			monster,
;2291:			target,
;2292:			def
;2293:		);
;2294:
;2295:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2300
;2296:			monster,
;2297:			def
;2298:		);
;2299:
;2300:		return;
ADDRGP4 $723
JUMPV
LABELV $733
line 2303
;2301:	}
;2302:
;2303:	if( !def->hasRanged ) {
ADDRFP4 8
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 0
NEI4 $735
line 2304
;2304:		return;
ADDRGP4 $723
JUMPV
LABELV $735
line 2307
;2305:	}
;2306:
;2307:	if( distanceSquared >
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
LEF4 $737
line 2309
;2308:		def->attackRange *
;2309:		def->attackRange ) {
line 2310
;2310:		return;
ADDRGP4 $723
JUMPV
LABELV $737
line 2313
;2311:	}
;2312:
;2313:	G_MonsterStartRangedAttack(
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
line 2319
;2314:		monster,
;2315:		target,
;2316:		def
;2317:	);
;2318:
;2319:	G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2323
;2320:		monster,
;2321:		def
;2322:	);
;2323:}
LABELV $723
endproc G_MonsterAttack 32 12
proc G_MonsterThink 44 16
line 2325
;2324:
;2325:static void G_MonsterThink(gentity_t *monster) {
line 2330
;2326:	monsterDef_t *def;
;2327:	gentity_t *target;
;2328:	int msec;
;2329:
;2330:	def = &g_monsterDefs
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 1104
ADDRLP4 12
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5520
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
line 2334
;2331:		[monster->monsterType]
;2332:		[monster->monsterSlot];
;2333:
;2334:	G_MonsterUpdateAnimation(monster, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 G_MonsterUpdateAnimation
CALLV
pop
line 2336
;2335:
;2336:	if (monster->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $740
line 2337
;2337:		if (level.time >= monster->monsterDeathTime) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 852
ADDP4
INDIRI4
LTI4 $742
line 2338
;2338:			if (monsterActiveCount > 0) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 0
LEI4 $745
line 2339
;2339:				monsterActiveCount--;
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
line 2340
;2340:			}
LABELV $745
line 2342
;2341:
;2342:			G_FreeEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 2343
;2343:			return;
ADDRGP4 $739
JUMPV
LABELV $742
line 2346
;2344:		}
;2345:
;2346:		monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2347
;2347:		return;
ADDRGP4 $739
JUMPV
LABELV $740
line 2350
;2348:	}
;2349:
;2350:	msec = level.time - monster->monsterLastThink;
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
line 2352
;2351:
;2352:	if (msec < 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
GEI4 $749
line 2353
;2353:		msec = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 2354
;2354:	}
ADDRGP4 $750
JUMPV
LABELV $749
line 2355
;2355:	else if (msec > 100) {
ADDRLP4 0
INDIRI4
CNSTI4 100
LEI4 $751
line 2356
;2356:		msec = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 2357
;2357:	}
LABELV $751
LABELV $750
line 2359
;2358:
;2359:	monster->monsterLastThink = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2361
;2360:
;2361:	target = G_MonsterFindTarget(monster);
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
line 2367
;2362:
;2363:	/*
;2364:	 * During an attack, keep facing the target selected
;2365:	 * at the beginning of the attack.
;2366:	 */
;2367:	if ((monster->monsterAnimation ==
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
EQI4 $756
ADDRLP4 20
INDIRI4
CNSTI4 2
NEI4 $754
LABELV $756
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
EQI4 $754
line 2371
;2368:			MONSTER_STATE_RANGED ||
;2369:		 monster->monsterAnimation ==
;2370:			MONSTER_STATE_MELEE) &&
;2371:		G_MonsterValidTarget(monster->enemy)) {
line 2372
;2372:		target = monster->enemy;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ASGNP4
line 2373
;2373:	}
LABELV $754
line 2375
;2374:
;2375:	if (target) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $757
line 2376
;2376:		G_MonsterFaceTarget(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterFaceTarget
CALLV
pop
line 2381
;2377:			monster,
;2378:			target
;2379:		);
;2380:
;2381:			G_MonsterMove(
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
line 2387
;2382:				monster,
;2383:				target,
;2384:				def,
;2385:				msec
;2386:			);
;2387:		G_MonsterAttack(monster, target, def);
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
line 2389
;2388:
;2389:		if (monster->monsterAnimation == MONSTER_STATE_MOVE &&
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
NEI4 $758
ADDRGP4 level+32
INDIRI4
ADDRLP4 28
INDIRP4
CNSTI4 856
ADDP4
INDIRI4
LTI4 $758
line 2390
;2390:			level.time >= monster->monsterNextTalk) {
line 2393
;2391:			int variant;
;2392:
;2393:			variant =
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
line 2396
;2394:				rand() % MAX_MONSTER_VARIANTS;
;2395:
;2396:			G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $762
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2403
;2397:				monster,
;2398:				def,
;2399:				"talk",
;2400:				variant
;2401:			);
;2402:
;2403:			monster->monsterNextTalk =
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
line 2406
;2404:				level.time +
;2405:				G_MonsterTalkDelay(def);
;2406:		}
line 2407
;2407:	}
ADDRGP4 $758
JUMPV
LABELV $757
line 2409
;2408:	
;2409:	else if( monster->monsterAnimation ==
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
NEI4 $764
line 2410
;2410:		MONSTER_STATE_MOVE ) {
line 2411
;2411:		G_MonsterSetAnimation(
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
line 2416
;2412:			monster,
;2413:			MONSTER_STATE_IDLE,
;2414:			0
;2415:		);
;2416:	}
LABELV $764
LABELV $758
line 2422
;2417:
;2418:	/*
;2419:	 * Walking monsters remain attached to the floor
;2420:	 * and fall when moving over an edge.
;2421:	 */
;2422:	G_MonsterGroundWalker(
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
line 2432
;2423:		monster,
;2424:		def,
;2425:		msec
;2426:	);
;2427:	
;2428:	/*
;2429:	 * Remember meaningful movement so an active monster
;2430:	 * is not mistaken for a lost one.
;2431:	 */
;2432:	if( monster->monsterWaveSpawn &&
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
EQI4 $766
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
LTF4 $766
line 2436
;2433:		DistanceSquared(
;2434:			monster->r.currentOrigin,
;2435:			monster->monsterProgressOrigin
;2436:		) >= 32.0f * 32.0f ) {
line 2437
;2437:		VectorCopy(
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
line 2442
;2438:			monster->r.currentOrigin,
;2439:			monster->monsterProgressOrigin
;2440:		);
;2441:
;2442:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2444
;2443:			level.time;
;2444:	}
LABELV $766
line 2446
;2445:
;2446:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2448
;2447:
;2448:	monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2449
;2449:}
LABELV $739
endproc G_MonsterThink 44 16
proc G_MonsterSound 68 24
line 2456
;2450:
;2451:static void G_MonsterSound(
;2452:	gentity_t *monster,
;2453:	monsterDef_t *def,
;2454:	const char *group,
;2455:	int variant
;2456:) {
line 2459
;2457:	char filename[MAX_QPATH];
;2458:
;2459:	Com_sprintf(
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $771
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
line 2468
;2460:		filename,
;2461:		sizeof(filename),
;2462:		"%s/%s%i.wav",
;2463:		def->soundDir,
;2464:		group,
;2465:		variant + 1
;2466:	);
;2467:
;2468:	G_Sound(
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
line 2473
;2469:		monster,
;2470:		CHAN_VOICE,
;2471:		G_SoundIndex(filename)
;2472:	);
;2473:}
LABELV $770
endproc G_MonsterSound 68 24
proc G_MonsterTalkDelay 12 0
line 2475
;2474:
;2475:static int G_MonsterTalkDelay(monsterDef_t *def) {
line 2478
;2476:	int range;
;2477:
;2478:	range = def->talkMaxDelay - def->talkMinDelay;
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
line 2480
;2479:
;2480:	if (range <= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $773
line 2481
;2481:		return def->talkMinDelay;
ADDRFP4 0
INDIRP4
CNSTI4 696
ADDP4
INDIRI4
RETI4
ADDRGP4 $772
JUMPV
LABELV $773
line 2484
;2482:	}
;2483:
;2484:	return def->talkMinDelay + rand() % (range + 1);
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
LABELV $772
endproc G_MonsterTalkDelay 12 0
proc G_MonsterPain 16 16
line 2491
;2485:}
;2486:
;2487:static void G_MonsterPain(
;2488:	gentity_t *self,
;2489:	gentity_t *attacker,
;2490:	int damage
;2491:) {
line 2495
;2492:	monsterDef_t *def;
;2493:	int variant;
;2494:
;2495:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $776
line 2496
;2496:		return;
ADDRGP4 $775
JUMPV
LABELV $776
line 2499
;2497:	}
;2498:	
;2499:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $778
line 2500
;2500:	self->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2503
;2501:		level.time;
;2502:
;2503:	VectorCopy(
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
line 2507
;2504:		self->r.currentOrigin,
;2505:		self->monsterProgressOrigin
;2506:	);
;2507:}
LABELV $778
line 2509
;2508:
;2509:	if (level.time < self->pain_debounce_time) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
GEI4 $781
line 2510
;2510:		return;
ADDRGP4 $775
JUMPV
LABELV $781
line 2513
;2511:	}
;2512:
;2513:	def = &g_monsterDefs
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1104
ADDRLP4 8
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5520
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
line 2518
;2514:		[self->monsterType]
;2515:		[self->monsterSlot];
;2516:			
;2517:
;2518:	variant = rand() % MAX_MONSTER_VARIANTS;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
CNSTI4 3
MODI4
ASGNI4
line 2520
;2519:
;2520:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2521
;2521:	self->monsterNextAttack = level.time + def->attackCooldown;
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
line 2523
;2522:
;2523:	G_MonsterSetAnimation(
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
line 2529
;2524:		self,
;2525:		MONSTER_STATE_PAIN,
;2526:		variant
;2527:	);
;2528:
;2529:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $785
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2536
;2530:		self,
;2531:		def,
;2532:		"pain",
;2533:		variant
;2534:	);
;2535:
;2536:	self->pain_debounce_time = level.time + 700;
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 700
ADDI4
ASGNI4
line 2537
;2537:}
LABELV $775
endproc G_MonsterPain 16 16
proc G_MonsterDropItem 36 12
line 2539
;2538:
;2539:static void G_MonsterDropItem(gentity_t *monster) {
line 2542
;2540:	vec3_t velocity;
;2541:
;2542:	if (!monster->monsterItem ||
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
EQU4 $790
ADDRLP4 12
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 16
INDIRU4
NEU4 $788
LABELV $790
line 2543
;2543:		!monster->monsterItem->item) {
line 2544
;2544:		return;
ADDRGP4 $787
JUMPV
LABELV $788
line 2547
;2545:	}
;2546:
;2547:	if (rand() % 100 >= 50) {
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 100
MODI4
CNSTI4 50
LTI4 $791
line 2548
;2548:		return;
ADDRGP4 $787
JUMPV
LABELV $791
line 2551
;2549:	}
;2550:
;2551:	VectorSet(
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
line 2558
;2552:		velocity,
;2553:		crandom() * 60,
;2554:		crandom() * 60,
;2555:		140
;2556:	);
;2557:
;2558:	LaunchItem(
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
line 2563
;2559:		monster->monsterItem->item,
;2560:		monster->r.currentOrigin,
;2561:		velocity
;2562:	);
;2563:}
LABELV $787
endproc G_MonsterDropItem 36 12
proc G_MonsterDie 56 16
line 2571
;2564:
;2565:static void G_MonsterDie(
;2566:	gentity_t *self,
;2567:	gentity_t *inflictor,
;2568:	gentity_t *attacker,
;2569:	int damage,
;2570:	int mod
;2571:) {
line 2577
;2572:	monsterDef_t *def;
;2573:	animation_t *animation;
;2574:	int variant;
;2575:	int duration;
;2576:
;2577:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $796
line 2578
;2578:		return;
ADDRGP4 $795
JUMPV
LABELV $796
line 2581
;2579:	}
;2580:
;2581:	def = &g_monsterDefs
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1104
ADDRLP4 16
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5520
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
line 2585
;2582:		[self->monsterType]
;2583:		[self->monsterSlot];
;2584:
;2585:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2587
;2586:
;2587:	self->monsterDead = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 1
ASGNI4
line 2588
;2588:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $798
line 2589
;2589:		monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2590
;2590:	}
LABELV $798
line 2592
;2591:	
;2592:	self->s.eFlags |= EF_DEAD;
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
line 2593
;2593:	self->takedamage = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 2594
;2594:	self->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 2595
;2595:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2597
;2596:
;2597:	self->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 2598
;2598:	self->clipmask = 0;
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 0
ASGNI4
line 2599
;2599:	trap_LinkEntity(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2601
;2600:
;2601:	G_MonsterSetAnimation(
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
line 2607
;2602:		self,
;2603:		MONSTER_STATE_DEATH,
;2604:		variant
;2605:	);
;2606:
;2607:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $801
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2614
;2608:		self,
;2609:		def,
;2610:		"death",
;2611:		variant
;2612:	);
;2613:
;2614:	animation = &def->deathAnimations[variant];
ADDRLP4 8
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 1020
ADDP4
ADDP4
ASGNP4
line 2615
;2615:	duration = animation->numFrames *
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
line 2618
;2616:		animation->frameLerp;
;2617:
;2618:	self->monsterDeathTime =
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
line 2627
;2619:		level.time +
;2620:		duration +
;2621:		def->corpseTime;
;2622:
;2623:	/*
;2624:	 * Monster Hunt score is awarded only for a monster
;2625:	 * killed by a real player or bot client.
;2626:	 */
;2627:	if (g_monsterHunt.integer &&
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 g_monsterHunt+12
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $803
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
EQU4 $803
ADDRLP4 36
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 40
INDIRU4
EQU4 $803
ADDRLP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
LEI4 $803
line 2630
;2628:		attacker &&
;2629:		attacker->client &&
;2630:		def->scoreValue > 0) {
line 2631
;2631:		AddScore(
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
line 2636
;2632:			attacker,
;2633:			self->r.currentOrigin,
;2634:			def->scoreValue
;2635:		);
;2636:	}
LABELV $803
line 2638
;2637:
;2638:	G_MonsterDropItem(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_MonsterDropItem
CALLV
pop
line 2643
;2639:	/*
;2640:	 * Only classic item-bound monsters respawn independently.
;2641:	 * Wave monsters are controlled by the wave director.
;2642:	 */
;2643:	if( !self->monsterWaveSpawn &&
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
NEI4 $806
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
EQU4 $806
ADDRLP4 52
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
EQI4 $806
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
LEI4 $806
line 2646
;2644:		self->monsterItem &&
;2645:		self->monsterItem->inuse &&
;2646:		def->respawnTime > 0 ) {
line 2647
;2647:		self->monsterItem->think =
ADDRFP4 0
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterRespawnThink
ASGNP4
line 2650
;2648:			G_MonsterRespawnThink;
;2649:
;2650:		self->monsterItem->nextthink =
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
line 2652
;2651:			level.time + def->respawnTime;
;2652:	}
LABELV $806
line 2653
;2653:}
LABELV $795
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
skip 33120
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
LABELV $801
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $785
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $771
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
LABELV $762
byte 1 116
byte 1 97
byte 1 108
byte 1 107
byte 1 0
align 1
LABELV $718
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $717
byte 1 109
byte 1 101
byte 1 108
byte 1 101
byte 1 101
byte 1 0
align 1
LABELV $668
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $426
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
LABELV $384
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
LABELV $383
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
LABELV $382
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
LABELV $381
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
LABELV $371
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
LABELV $370
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
LABELV $369
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
LABELV $356
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
LABELV $230
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
LABELV $221
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
LABELV $220
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
LABELV $199
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
LABELV $194
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $189
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
LABELV $184
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
LABELV $179
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
LABELV $174
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
LABELV $169
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
LABELV $161
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
LABELV $157
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
LABELV $153
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
LABELV $148
byte 1 116
byte 1 114
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $145
byte 1 114
byte 1 101
byte 1 112
byte 1 101
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $142
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
LABELV $137
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
LABELV $132
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
LABELV $129
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $126
byte 1 125
byte 1 0
align 1
LABELV $123
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
LABELV $117
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
LABELV $116
byte 1 123
byte 1 0
align 1
LABELV $112
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
LABELV $89
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
LABELV $84
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
LABELV $78
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
LABELV $72
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
LABELV $69
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
LABELV $65
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
