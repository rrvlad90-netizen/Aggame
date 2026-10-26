data
align 4
LABELV monsterConfigFiles
address $59
address $60
address $61
byte 4 0
code
proc G_LoadMonsterConfig 9568 16
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
ADDRLP4 1104
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 9556
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 1100
ADDRLP4 9556
INDIRI4
ASGNI4
line 118
;117:
;118:	if (!file) {
ADDRLP4 1104
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
ADDRLP4 1100
INDIRI4
CNSTI4 0
LEI4 $68
ADDRLP4 1100
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
ADDRLP4 1104
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
ADDRLP4 1108
ARGP4
ADDRLP4 1100
INDIRI4
ARGI4
ADDRLP4 1104
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 136
;136:	text[length] = '\0';
ADDRLP4 1100
INDIRI4
ADDRLP4 1108
ADDP4
CNSTI1 0
ASGNI1
line 137
;137:	trap_FS_FCloseFile(file);
ADDRLP4 1104
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 139
;138:
;139:	if (!BG_ParseMonsterConfig(
ADDRLP4 1108
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 9300
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 9564
ADDRGP4 BG_ParseMonsterConfig
CALLI4
ASGNI4
ADDRLP4 9564
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
ADDRLP4 9300
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
CNSTI4 1100
ADDRLP4 0+580
INDIRI4
MULI4
CNSTI4 5500
ADDRLP4 0+576
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ADDRLP4 0
INDIRB
ASGNB 1100
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
endproc G_LoadMonsterConfig 9568 16
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
CNSTI4 1100
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 5500
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
CNSTI4 33000
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
line 604
;603:
;604:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 2
NEI4 $227
line 605
;605:		MONSTER_HUNT_ONE_LIFE ) {
line 606
;606:		monsterWavesLoaded =
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
line 610
;607:			G_LoadMonsterWaveConfig(
;608:				"monsterwaves.cfg"
;609:			);
;610:	}
LABELV $227
line 611
;611:}
LABELV $222
endproc G_MonsterInitDefinitions 8 12
proc G_MonsterEligibleItem 24 0
line 613
;612:
;613:static qboolean G_MonsterEligibleItem(gentity_t *item) {
line 614
;614:	if (!item || !item->item) {
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
line 615
;615:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $231
JUMPV
LABELV $232
line 618
;616:	}
;617:
;618:	if (item->flags & FL_DROPPED_ITEM) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $235
line 619
;619:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $231
JUMPV
LABELV $235
line 622
;620:	}
;621:
;622:	if (item->team || item->targetname || item->wait == -1) {
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
line 623
;623:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $231
JUMPV
LABELV $237
line 626
;624:	}
;625:
;626:	switch (item->item->giType) {
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
line 632
;627:	case IT_WEAPON:
;628:	case IT_AMMO:
;629:	case IT_ARMOR:
;630:	case IT_HEALTH:
;631:	case IT_POWERUP:
;632:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $231
JUMPV
LABELV $241
line 635
;633:
;634:	default:
;635:		return qfalse;
CNSTI4 0
RETI4
LABELV $231
endproc G_MonsterEligibleItem 24 0
proc G_MonsterSetOrigin 0 8
line 642
;636:	}
;637:}
;638:
;639:static void G_MonsterSetOrigin(
;640:	gentity_t *monster,
;641:	const vec3_t origin
;642:) {
line 643
;643:	G_SetOrigin(monster, (float *)origin);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 649
;644:
;645:	/*
;646:	 * The client interpolates monsters between snapshots.
;647:	 * G_SetOrigin resets trType to TR_STATIONARY.
;648:	 */
;649:	monster->s.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 650
;650:	monster->s.pos.trTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 651
;651:}
LABELV $247
endproc G_MonsterSetOrigin 0 8
proc G_MonsterSpawnAtOrigin 52 12
line 658
;652:
;653:static qboolean G_MonsterSpawnAtOrigin(
;654:	gentity_t *item,
;655:	monsterDef_t *def,
;656:	vec3_t spawnOrigin,
;657:	qboolean waveSpawn
;658:) {
line 662
;659:	gentity_t *monster;
;660:	vec3_t origin;
;661:
;662:	if( waveSpawn ) {
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $250
line 663
;663:		if( monsterActiveCount >=
ADDRGP4 monsterActiveCount
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $251
line 664
;664:			monsterWaveMaxActive ) {
line 665
;665:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $249
JUMPV
line 667
;666:		}
;667:	}
LABELV $250
line 668
;668:	else if( monsterActiveCount >= 8 ) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $254
line 669
;669:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $249
JUMPV
LABELV $254
LABELV $251
line 672
;670:	}
;671:
;672:	if( !def ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $256
line 673
;673:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $249
JUMPV
LABELV $256
line 676
;674:	}
;675:
;676:	monster = G_Spawn();
ADDRLP4 16
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16
INDIRP4
ASGNP4
line 678
;677:
;678:	monster->classname = "monster";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $129
ASGNP4
line 679
;679:	monster->s.eType = ET_MONSTER;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 13
ASGNI4
line 681
;680:
;681:	if( def->models[0][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $258
line 682
;682:		monster->s.modelindex =
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
line 684
;683:			G_ModelIndex(def->models[0]);
;684:	}
LABELV $258
line 686
;685:
;686:	if( def->models[1][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $260
line 687
;687:		monster->s.modelindex2 =
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
line 689
;688:			G_ModelIndex(def->models[1]);
;689:	}
LABELV $260
line 691
;690:
;691:	if( def->models[2][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $262
line 692
;692:		monster->s.otherEntityNum =
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
line 694
;693:			G_ModelIndex(def->models[2]);
;694:	}
LABELV $262
line 696
;695:
;696:	if( def->models[3][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 256
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $264
line 697
;697:		monster->s.otherEntityNum2 =
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
line 699
;698:			G_ModelIndex(def->models[3]);
;699:	}
LABELV $264
line 701
;700:
;701:	monster->s.frame =
ADDRLP4 0
INDIRP4
CNSTI4 172
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
ASGNI4
line 704
;702:		def->moveAnimation.firstFrame;
;703:
;704:	monster->s.groundEntityNum =
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 707
;705:		ENTITYNUM_NONE;
;706:
;707:	monster->s.apos.trType =
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 710
;708:		TR_STATIONARY;
;709:
;710:	monster->monsterType =
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
line 713
;711:		def->monsterType;
;712:
;713:	monster->monsterSlot =
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
line 720
;714:		def->monsterSlot;
;715:		
;716:	/*
;717:	 * Send monster definition identity to cgame.
;718:	 * Low byte: type, high byte: slot.
;719:	 */
;720:	monster->s.generic1 =
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
line 724
;721:		(def->monsterType & 255) |
;722:		((def->monsterSlot & 255) << 8);	
;723:
;724:	monster->monsterItem = item;
ADDRLP4 0
INDIRP4
CNSTI4 868
ADDP4
ADDRFP4 0
INDIRP4
ASGNP4
line 725
;725:	monster->monsterWaveSpawn = waveSpawn;
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
ADDRFP4 12
INDIRI4
ASGNI4
line 726
;726:	monster->monsterDead = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 0
ASGNI4
line 728
;727:
;728:	monster->health = def->health;
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
line 729
;729:	monster->takedamage = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 730
;730:	monster->pain = G_MonsterPain;
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
ADDRGP4 G_MonsterPain
ASGNP4
line 731
;731:	monster->die = G_MonsterDie;
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 G_MonsterDie
ASGNP4
line 733
;732:
;733:	monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 736
;734:		level.time + 500;
;735:
;736:	monster->monsterNextShot = 0;
ADDRLP4 0
INDIRP4
CNSTI4 876
ADDP4
CNSTI4 0
ASGNI4
line 737
;737:	monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 739
;738:
;739:	G_MonsterSetAnimation(
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
line 745
;740:		monster,
;741:		MONSTER_STATE_IDLE,
;742:		0
;743:	);
;744:
;745:	monster->monsterNextTalk =
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
line 749
;746:		level.time +
;747:		G_MonsterTalkDelay(def);
;748:
;749:	VectorCopy(
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
line 754
;750:		def->mins,
;751:		monster->r.mins
;752:	);
;753:
;754:	VectorCopy(
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
line 759
;755:		def->maxs,
;756:		monster->r.maxs
;757:	);
;758:
;759:	monster->r.contents = CONTENTS_BODY;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 33554432
ASGNI4
line 760
;760:	monster->clipmask = MASK_PLAYERSOLID;
ADDRLP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 33619969
ASGNI4
line 762
;761:
;762:	VectorCopy(spawnOrigin, origin);
ADDRLP4 4
ADDRFP4 8
INDIRP4
INDIRB
ASGNB 12
line 763
;763:	origin[2] += def->hoverHeight;
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
line 765
;764:
;765:	G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 770
;766:		monster,
;767:		origin
;768:	);
;769:	
;770:	monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 773
;771:	level.time;
;772:
;773:	VectorCopy(
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
line 778
;774:		monster->r.currentOrigin,
;775:		monster->monsterProgressOrigin
;776:	);
;777:
;778:	monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 781
;779:		level.time;
;780:
;781:	monster->monsterDriftPhase =
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
line 784
;782:		monster->s.number * 0.73f;
;783:
;784:	monster->think = G_MonsterThink;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterThink
ASGNP4
line 785
;785:	monster->nextthink = level.time + 50;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 787
;786:
;787:	trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 793
;788:
;789:	/*
;790:	 * Classic Monster Hunt replaces and hides a map item.
;791:	 * Wave monsters are independent from map items.
;792:	 */
;793:	if( item && !waveSpawn ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $272
ADDRFP4 12
INDIRI4
CNSTI4 0
NEI4 $272
line 794
;794:		item->monsterType =
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
line 797
;795:			def->monsterType;
;796:
;797:		item->monsterSlot =
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
line 800
;798:			def->monsterSlot;
;799:
;800:		item->s.eFlags |= EF_NODRAW;
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
line 801
;801:		item->r.svFlags |= SVF_NOCLIENT;
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
line 802
;802:		item->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 803
;803:		item->touch = 0;
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
CNSTP4 0
ASGNP4
line 804
;804:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 805
;805:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 807
;806:
;807:		trap_UnlinkEntity(item);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 808
;808:	}
LABELV $272
line 810
;809:
;810:	monsterActiveCount++;
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
line 819
;811:
;812:/*	G_Printf(
;813:		"Spawned %smonster %s at %s\n",
;814:		waveSpawn ? "wave " : "",
;815:		def->name,
;816:		vtos(origin)
;817:	);*/
;818:
;819:	return qtrue;
CNSTI4 1
RETI4
LABELV $249
endproc G_MonsterSpawnAtOrigin 52 12
proc G_MonsterSpawnFromItem 12 16
line 825
;820:}
;821:
;822:static qboolean G_MonsterSpawnFromItem(
;823:	gentity_t *item,
;824:	monsterDef_t *def
;825:) {
line 826
;826:	if( !item || !def ) {
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
line 827
;827:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $274
JUMPV
LABELV $275
line 830
;828:	}
;829:
;830:	return G_MonsterSpawnAtOrigin(
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
line 838
;831:		item,
;832:		def,
;833:		item->s.pos.trBase,
;834:		qfalse
;835:	);
;836:}
;837:
;838:static void G_MonsterRespawnThink(gentity_t *item) {
line 841
;839:	monsterDef_t *def;
;840:
;841:	if (item->monsterType <= MONSTER_TYPE_OFF ||
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
line 844
;842:		item->monsterType >= MONSTER_TYPE_RANDOM ||
;843:		item->monsterSlot < 0 ||
;844:		item->monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 845
;845:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 846
;846:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 847
;847:		return;
ADDRGP4 $278
JUMPV
LABELV $279
line 850
;848:	}
;849:
;850:	if (!g_monsterDefLoaded
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
line 852
;851:		[item->monsterType]
;852:		[item->monsterSlot]) {
line 853
;853:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 854
;854:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 855
;855:		return;
ADDRGP4 $278
JUMPV
LABELV $284
line 858
;856:	}
;857:
;858:	if (monsterActiveCount >= 8) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $286
line 859
;859:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 860
;860:		return;
ADDRGP4 $278
JUMPV
LABELV $286
line 863
;861:	}
;862:
;863:	def = &g_monsterDefs
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1100
ADDRLP4 24
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5500
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
line 867
;864:		[item->monsterType]
;865:		[item->monsterSlot];
;866:
;867:	if (!G_MonsterSpawnFromItem(item, def)) {
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
line 868
;868:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 869
;869:	}
LABELV $289
line 870
;870:}
LABELV $278
endproc G_MonsterRespawnThink 32 8
proc G_MonsterWaveHasPlayers 8 0
line 872
;871:
;872:static qboolean G_MonsterWaveHasPlayers( void ) {
line 876
;873:	gclient_t *client;
;874:	int i;
;875:
;876:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $296
JUMPV
LABELV $293
line 877
;877:		client = &level.clients[i];
ADDRLP4 0
CNSTI4 780
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 879
;878:
;879:		if( client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $298
line 880
;880:			CON_CONNECTED ) {
line 881
;881:			continue;
ADDRGP4 $294
JUMPV
LABELV $298
line 884
;882:		}
;883:
;884:		if( client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $300
line 885
;885:			TEAM_SPECTATOR ) {
line 886
;886:			continue;
ADDRGP4 $294
JUMPV
LABELV $300
line 889
;887:		}
;888:
;889:		if( client->oneLifeEliminated ) {
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $302
line 890
;890:			continue;
ADDRGP4 $294
JUMPV
LABELV $302
line 893
;891:		}
;892:
;893:		if( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $304
line 894
;894:			continue;
ADDRGP4 $294
JUMPV
LABELV $304
line 897
;895:		}
;896:
;897:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $292
JUMPV
LABELV $294
line 876
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
line 900
;898:	}
;899:
;900:	return qfalse;
CNSTI4 0
RETI4
LABELV $292
endproc G_MonsterWaveHasPlayers 8 0
proc G_MonsterWaveLivingCount 12 0
line 903
;901:}
;902:
;903:static int G_MonsterWaveLivingCount( void ) {
line 908
;904:	gentity_t *ent;
;905:	int count;
;906:	int i;
;907:
;908:	count = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 910
;909:
;910:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $310
JUMPV
LABELV $307
line 912
;911:		i < level.num_entities;
;912:		i++ ) {
line 913
;913:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 915
;914:
;915:		if( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $312
line 916
;916:			continue;
ADDRGP4 $308
JUMPV
LABELV $312
line 919
;917:		}
;918:
;919:		if( ent->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $314
line 920
;920:			continue;
ADDRGP4 $308
JUMPV
LABELV $314
line 923
;921:		}
;922:
;923:		if( !ent->monsterWaveSpawn ) {
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
NEI4 $316
line 924
;924:			continue;
ADDRGP4 $308
JUMPV
LABELV $316
line 927
;925:		}
;926:
;927:		if( ent->monsterDead ) {
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $318
line 928
;928:			continue;
ADDRGP4 $308
JUMPV
LABELV $318
line 931
;929:		}
;930:
;931:		count++;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 932
;932:	}
LABELV $308
line 912
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $310
line 911
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $307
line 934
;933:
;934:	return count;
ADDRLP4 8
INDIRI4
RETI4
LABELV $306
endproc G_MonsterWaveLivingCount 12 0
proc G_MonsterWaveSpotSafe 96 28
line 941
;935:}
;936:
;937:static qboolean G_MonsterWaveSpotSafe(
;938:	gentity_t *spot,
;939:	monsterDef_t *def,
;940:	qboolean requireDistance
;941:) {
line 947
;942:	gentity_t *player;
;943:	trace_t trace;
;944:	vec3_t origin;
;945:	int i;
;946:
;947:	if( !spot || !def ) {
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
line 948
;948:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $321
line 951
;949:	}
;950:
;951:	if( SpotWouldTelefrag(spot) ) {
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
line 952
;952:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $324
line 955
;953:	}
;954:
;955:	VectorCopy(spot->s.origin, origin);
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 956
;956:	origin[2] += 9 + def->hoverHeight;
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
line 958
;957:
;958:	trap_Trace(
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
line 968
;959:		&trace,
;960:		origin,
;961:		def->mins,
;962:		def->maxs,
;963:		origin,
;964:		ENTITYNUM_NONE,
;965:		MASK_PLAYERSOLID
;966:	);
;967:
;968:	if( trace.startsolid || trace.allsolid ) {
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
line 969
;969:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $327
line 972
;970:	}
;971:
;972:	if( !requireDistance ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $331
line 973
;973:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $320
JUMPV
LABELV $331
line 976
;974:	}
;975:
;976:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $336
JUMPV
LABELV $333
line 977
;977:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 979
;978:
;979:		if( !player->client ) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $338
line 980
;980:			continue;
ADDRGP4 $334
JUMPV
LABELV $338
line 983
;981:		}
;982:
;983:		if( player->client->pers.connected !=
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
line 984
;984:			CON_CONNECTED ) {
line 985
;985:			continue;
ADDRGP4 $334
JUMPV
LABELV $340
line 988
;986:		}
;987:
;988:		if( player->client->sess.sessionTeam ==
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
line 989
;989:			TEAM_SPECTATOR ) {
line 990
;990:			continue;
ADDRGP4 $334
JUMPV
LABELV $342
line 993
;991:		}
;992:
;993:		if( player->health <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $344
line 994
;994:			continue;
ADDRGP4 $334
JUMPV
LABELV $344
line 997
;995:		}
;996:
;997:		if( DistanceSquared(
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
line 1000
;998:			spot->s.origin,
;999:			player->r.currentOrigin
;1000:		) < 256.0f * 256.0f ) {
line 1001
;1001:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $320
JUMPV
LABELV $346
line 1003
;1002:		}
;1003:	}
LABELV $334
line 976
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
line 1005
;1004:
;1005:	return qtrue;
CNSTI4 1
RETI4
LABELV $320
endproc G_MonsterWaveSpotSafe 96 28
proc G_MonsterWaveChooseSpawn 536 12
line 1011
;1006:}
;1007:
;1008:static qboolean G_MonsterWaveChooseSpawn(
;1009:	monsterDef_t *def,
;1010:	vec3_t origin
;1011:) {
line 1017
;1012:	gentity_t *spots[128];
;1013:	gentity_t *spot;
;1014:	int count;
;1015:	int pass;
;1016:
;1017:	for( pass = 0; pass < 2; pass++ ) {
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $349
line 1018
;1018:		count = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1019
;1019:		spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $354
JUMPV
LABELV $353
line 1025
;1020:
;1021:		while( (spot = G_Find(
;1022:			spot,
;1023:			FOFS(classname),
;1024:			"info_player_deathmatch"
;1025:		)) != NULL ) {
line 1026
;1026:			if( !G_MonsterWaveSpotSafe(
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
line 1030
;1027:				spot,
;1028:				def,
;1029:				pass == 0
;1030:			) ) {
line 1031
;1031:				continue;
ADDRGP4 $354
JUMPV
LABELV $357
line 1034
;1032:			}
;1033:
;1034:			spots[count++] = spot;
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
line 1036
;1035:
;1036:			if( count >= 128 ) {
ADDRLP4 4
INDIRI4
CNSTI4 128
LTI4 $362
line 1037
;1037:				break;
ADDRGP4 $355
JUMPV
LABELV $362
line 1039
;1038:			}
;1039:		}
LABELV $354
line 1021
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
line 1041
;1040:
;1041:		if( count > 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LEI4 $364
line 1042
;1042:			spot = spots[rand() % count];
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
line 1044
;1043:
;1044:			VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1049
;1045:				spot->s.origin,
;1046:				origin
;1047:			);
;1048:
;1049:			origin[2] += 9;
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
line 1050
;1050:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $348
JUMPV
LABELV $364
line 1052
;1051:		}
;1052:	}
LABELV $350
line 1017
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
line 1054
;1053:
;1054:	return qfalse;
CNSTI4 0
RETI4
LABELV $348
endproc G_MonsterWaveChooseSpawn 536 12
proc G_MonsterWaveBegin 8 8
line 1057
;1055:}
;1056:
;1057:static void G_MonsterWaveBegin( void ) {
line 1058
;1058:	monsterWaveActive = qtrue;
ADDRGP4 monsterWaveActive
CNSTI4 1
ASGNI4
line 1059
;1059:	monsterWaveCombatStarted = qtrue;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 1
ASGNI4
line 1060
;1060:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 1061
;1061:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1062
;1062:	monsterWaveNextSpawn = level.time;
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1063
;1063:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1065
;1064:
;1065:	trap_SendServerCommand(
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
line 1073
;1066:		-1,
;1067:		va(
;1068:			"cp \"Wave %i\n\"",
;1069:			monsterCurrentWave
;1070:		)
;1071:	);
;1072:
;1073:	trap_SendServerCommand(
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
line 1081
;1074:		-1,
;1075:		va(
;1076:			"print \"Monster Hunt: wave %i started.\n\"",
;1077:			monsterCurrentWave
;1078:		)
;1079:	);
;1080:
;1081:	G_Printf(
ADDRGP4 $371
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 1085
;1082:		"Monster Hunt: wave %i started.\n",
;1083:		monsterCurrentWave
;1084:	);
;1085:}
LABELV $366
endproc G_MonsterWaveBegin 8 8
proc G_MonsterWaveComplete 8 8
line 1087
;1086:
;1087:static void G_MonsterWaveComplete( void ) {
line 1088
;1088:	trap_SendServerCommand(
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
line 1096
;1089:		-1,
;1090:		va(
;1091:			"print \"Monster Hunt: wave %i cleared.\n\"",
;1092:			monsterCurrentWave
;1093:		)
;1094:	);
;1095:
;1096:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 1098
;1097:
;1098:	if( monsterCurrentWave <
ADDRGP4 monsterCurrentWave
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
GEI4 $374
line 1099
;1099:		monsterWaveFinal ) {
line 1100
;1100:		monsterCurrentWave++;
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
line 1102
;1101:
;1102:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1106
;1103:			level.time +
;1104:			monsterWaveDelay;
;1105:
;1106:		return;
ADDRGP4 $372
JUMPV
LABELV $374
line 1113
;1107:	}
;1108:
;1109:	/*
;1110:	 * Clearing the configured final wave is a
;1111:	 * collective Monster Hunt victory.
;1112:	 */
;1113:	monsterWaveFinished = qtrue;
ADDRGP4 monsterWaveFinished
CNSTI4 1
ASGNI4
line 1115
;1114:
;1115:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $377
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1120
;1116:		-1,
;1117:		"cp \"Monster Hunt completed!\n\""
;1118:	);
;1119:
;1120:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $378
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1125
;1121:		-1,
;1122:		"print \"Monster Hunt: all waves cleared.\n\""
;1123:	);
;1124:
;1125:	LogExit(
ADDRGP4 $379
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1128
;1126:		"Monster Hunt completed."
;1127:	);
;1128:}
LABELV $372
endproc G_MonsterWaveComplete 8 8
proc G_MonsterWaveRelocateStuck 48 12
line 1130
;1129:
;1130:static int G_MonsterWaveRelocateStuck( void ) {
line 1137
;1131:	gentity_t *monster;
;1132:	monsterDef_t *def;
;1133:	vec3_t origin;
;1134:	int relocated;
;1135:	int i;
;1136:
;1137:	relocated = 0;
ADDRLP4 24
CNSTI4 0
ASGNI4
line 1139
;1138:
;1139:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $384
JUMPV
LABELV $381
line 1141
;1140:		i < level.num_entities;
;1141:		i++ ) {
line 1142
;1142:		monster = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1144
;1143:
;1144:		if( !monster->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $386
line 1145
;1145:			continue;
ADDRGP4 $382
JUMPV
LABELV $386
line 1148
;1146:		}
;1147:
;1148:		if( monster->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $388
line 1149
;1149:			continue;
ADDRGP4 $382
JUMPV
LABELV $388
line 1152
;1150:		}
;1151:
;1152:		if( !monster->monsterWaveSpawn ||
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
EQI4 $392
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $390
LABELV $392
line 1153
;1153:			monster->monsterDead ) {
line 1154
;1154:			continue;
ADDRGP4 $382
JUMPV
LABELV $390
line 1161
;1155:		}
;1156:
;1157:		/*
;1158:		 * Relocate only monsters that have neither moved,
;1159:		 * fired nor received damage for the timeout period.
;1160:		 */
;1161:		if( level.time -
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
GEI4 $393
line 1163
;1162:			monster->monsterProgressTime <
;1163:			monsterWaveTimeout ) {
line 1164
;1164:			continue;
ADDRGP4 $382
JUMPV
LABELV $393
line 1167
;1165:		}
;1166:
;1167:		def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1100
ADDRLP4 0
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5500
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
line 1171
;1168:			[monster->monsterType]
;1169:			[monster->monsterSlot];
;1170:
;1171:		if( !G_MonsterWaveChooseSpawn(
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
NEI4 $396
line 1174
;1172:			def,
;1173:			origin
;1174:		) ) {
line 1175
;1175:			continue;
ADDRGP4 $382
JUMPV
LABELV $396
line 1182
;1176:		}
;1177:
;1178:		/*
;1179:		 * ChooseSpawn returns the base position.
;1180:		 * Apply the monster's configured hovering height.
;1181:		 */
;1182:		origin[2] += def->hoverHeight;
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
line 1184
;1183:
;1184:		G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1189
;1185:			monster,
;1186:			origin
;1187:		);
;1188:
;1189:		monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1192
;1190:			level.time;
;1191:
;1192:		VectorCopy(
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
line 1197
;1193:			monster->r.currentOrigin,
;1194:			monster->monsterProgressOrigin
;1195:		);
;1196:
;1197:		monster->enemy = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 768
ADDP4
CNSTP4 0
ASGNP4
line 1198
;1198:		monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 1199
;1199:		monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1201
;1200:			level.time + 500;
;1201:		monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1204
;1202:			level.time;
;1203:
;1204:		G_MonsterSetAnimation(
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
line 1210
;1205:			monster,
;1206:			MONSTER_STATE_MOVE,
;1207:			0
;1208:		);
;1209:
;1210:		trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1211
;1211:		relocated++;
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1212
;1212:	}
LABELV $382
line 1141
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $384
line 1140
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $381
line 1214
;1213:
;1214:	return relocated;
ADDRLP4 24
INDIRI4
RETI4
LABELV $380
endproc G_MonsterWaveRelocateStuck 48 12
export G_MonsterRunFrame
proc G_MonsterRunFrame 60 16
line 1217
;1215:}
;1216:
;1217:void G_MonsterRunFrame( void ) {
line 1224
;1218:	monsterWaveDef_t *wave;
;1219:	monsterWaveEntry_t *entry;
;1220:	monsterDef_t *def;
;1221:	vec3_t origin;
;1222:	int living;
;1223:
;1224:	if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 2
EQI4 $403
line 1225
;1225:		MONSTER_HUNT_ONE_LIFE ) {
line 1226
;1226:		return;
ADDRGP4 $402
JUMPV
LABELV $403
line 1229
;1227:	}
;1228:
;1229:	if( !monsterWavesLoaded ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 monsterWavesLoaded
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $408
ADDRGP4 monsterWaveFinished
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $406
LABELV $408
line 1230
;1230:		monsterWaveFinished ) {
line 1231
;1231:		return;
ADDRGP4 $402
JUMPV
LABELV $406
line 1234
;1232:	}
;1233:
;1234:	if( level.intermissiontime ||
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 level+9128
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $415
ADDRGP4 level+9124
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $415
ADDRGP4 level+16
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $409
LABELV $415
line 1236
;1235:		level.intermissionQueued ||
;1236:		level.warmupTime ) {
line 1237
;1237:		return;
ADDRGP4 $402
JUMPV
LABELV $409
line 1240
;1238:	}
;1239:
;1240:	if( !G_MonsterWaveHasPlayers() ) {
ADDRLP4 36
ADDRGP4 G_MonsterWaveHasPlayers
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $416
line 1241
;1241:		return;
ADDRGP4 $402
JUMPV
LABELV $416
line 1244
;1242:	}
;1243:
;1244:	if( !monsterWaveStarted ) {
ADDRGP4 monsterWaveStarted
INDIRI4
CNSTI4 0
NEI4 $418
line 1245
;1245:		monsterWaveStarted = qtrue;
ADDRGP4 monsterWaveStarted
CNSTI4 1
ASGNI4
line 1246
;1246:		monsterCurrentWave = 1;
ADDRGP4 monsterCurrentWave
CNSTI4 1
ASGNI4
line 1247
;1247:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1250
;1248:			level.time + monsterWaveDelay;
;1249:
;1250:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $421
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1255
;1251:			-1,
;1252:			"print \"Monster Hunt begins.\n\""
;1253:		);
;1254:
;1255:		return;
ADDRGP4 $402
JUMPV
LABELV $418
line 1258
;1256:	}
;1257:
;1258:	if( !monsterWaveActive ) {
ADDRGP4 monsterWaveActive
INDIRI4
CNSTI4 0
NEI4 $422
line 1259
;1259:		if( level.time >= monsterWaveNextStart ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextStart
INDIRI4
LTI4 $402
line 1260
;1260:			G_MonsterWaveBegin();
ADDRGP4 G_MonsterWaveBegin
CALLV
pop
line 1261
;1261:		}
line 1263
;1262:
;1263:		return;
ADDRGP4 $402
JUMPV
LABELV $422
line 1266
;1264:	}
;1265:
;1266:	wave =
ADDRLP4 0
CNSTI4 104
ADDRGP4 monsterCurrentWave
INDIRI4
MULI4
ADDRGP4 monsterWaves-104
ADDP4
ASGNP4
ADDRGP4 $429
JUMPV
LABELV $428
line 1270
;1267:		&monsterWaves[monsterCurrentWave - 1];
;1268:
;1269:	while( monsterWaveEntry <
;1270:		wave->numEntries ) {
line 1271
;1271:		entry =
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1274
;1272:			&wave->entries[monsterWaveEntry];
;1273:
;1274:		if( monsterWaveEntrySpawned <
ADDRGP4 monsterWaveEntrySpawned
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
GEI4 $431
line 1275
;1275:			entry->count ) {
line 1276
;1276:			break;
ADDRGP4 $430
JUMPV
LABELV $431
line 1279
;1277:		}
;1278:
;1279:		monsterWaveEntry++;
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
line 1280
;1280:		monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1281
;1281:	}
LABELV $429
line 1269
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $428
LABELV $430
line 1283
;1282:
;1283:	living = G_MonsterWaveLivingCount();
ADDRLP4 40
ADDRGP4 G_MonsterWaveLivingCount
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 40
INDIRI4
ASGNI4
line 1289
;1284:
;1285:	/*
;1286:	 * Every configured monster has been spawned.
;1287:	 * Complete the wave after the last living monster dies.
;1288:	 */
;1289:	if( monsterWaveEntry >=
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $433
line 1290
;1290:		wave->numEntries ) {
line 1291
;1291:		if( living == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $435
line 1292
;1292:			G_MonsterWaveComplete();
ADDRGP4 G_MonsterWaveComplete
CALLV
pop
line 1293
;1293:			return;
ADDRGP4 $402
JUMPV
LABELV $435
line 1296
;1294:		}
;1295:
;1296:		if( level.time - monsterWaveLastProgress >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveLastProgress
INDIRI4
SUBI4
ADDRGP4 monsterWaveTimeout
INDIRI4
LTI4 $402
line 1297
;1297:			monsterWaveTimeout ) {
line 1300
;1298:			int relocated;
;1299:
;1300:			relocated =
ADDRLP4 48
ADDRGP4 G_MonsterWaveRelocateStuck
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 48
INDIRI4
ASGNI4
line 1303
;1301:				G_MonsterWaveRelocateStuck();
;1302:
;1303:			monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1319
;1304:
;1305:			/*trap_SendServerCommand(
;1306:				-1,
;1307:				va(
;1308:					"print \"Monster Hunt: relocated %i lost monsters.\n\"",
;1309:					relocated
;1310:				)
;1311:			);
;1312:
;1313:			G_Printf(
;1314:				"Monster Hunt: wave %i still has %i living monsters; relocated %i.\n",
;1315:				monsterCurrentWave,
;1316:				living,
;1317:				relocated
;1318:			);*/
;1319:		}
line 1321
;1320:
;1321:		return;
ADDRGP4 $402
JUMPV
LABELV $433
line 1324
;1322:	}
;1323:
;1324:	if( living >= monsterWaveMaxActive ) {
ADDRLP4 12
INDIRI4
ADDRGP4 monsterWaveMaxActive
INDIRI4
LTI4 $441
line 1325
;1325:		return;
ADDRGP4 $402
JUMPV
LABELV $441
line 1328
;1326:	}
;1327:
;1328:	if( level.time < monsterWaveNextSpawn ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextSpawn
INDIRI4
GEI4 $443
line 1329
;1329:		return;
ADDRGP4 $402
JUMPV
LABELV $443
line 1332
;1330:	}
;1331:
;1332:	entry = &wave->entries[monsterWaveEntry];
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1334
;1333:
;1334:	def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1100
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
MULI4
CNSTI4 5500
ADDRLP4 4
INDIRP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 1338
;1335:		[entry->monsterType]
;1336:		[entry->monsterSlot];
;1337:
;1338:	if( !G_MonsterWaveChooseSpawn(
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
NEI4 $446
line 1341
;1339:		def,
;1340:		origin
;1341:	) ) {
line 1342
;1342:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 1344
;1343:			level.time + 1000;
;1344:		return;
ADDRGP4 $402
JUMPV
LABELV $446
line 1347
;1345:	}
;1346:
;1347:	if( G_MonsterSpawnAtOrigin(
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
EQI4 $449
line 1352
;1348:		NULL,
;1349:		def,
;1350:		origin,
;1351:		qtrue
;1352:	) ) {
line 1353
;1353:	monsterWaveEntrySpawned++;
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
line 1354
;1354:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1356
;1355:
;1356:	monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
ADDI4
ASGNI4
line 1359
;1357:		level.time +
;1358:			monsterWaveSpawnInterval;
;1359:	}
ADDRGP4 $450
JUMPV
LABELV $449
line 1360
;1360:	else {
line 1361
;1361:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1363
;1362:			level.time + 500;
;1363:	}
LABELV $450
line 1364
;1364:}
LABELV $402
endproc G_MonsterRunFrame 60 16
export G_MonsterTryReplaceItem
proc G_MonsterTryReplaceItem 16 8
line 1366
;1365:
;1366:qboolean G_MonsterTryReplaceItem(gentity_t *item) {
line 1374
;1367:
;1368:	monsterDef_t *def;
;1369:	
;1370:	/*
;1371:	 * Item-bound monsters belong only to Classic mode.
;1372:	 * One Life receives monsters exclusively from waves.
;1373:	 */
;1374:	if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 1
EQI4 $455
line 1375
;1375:		MONSTER_HUNT_CLASSIC ) {
line 1376
;1376:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $454
JUMPV
LABELV $455
line 1379
;1377:	}
;1378:
;1379:	if (!g_monsterDefLoaded[MONSTER_TYPE_MAGIC][0]) {
ADDRGP4 g_monsterDefLoaded+20
INDIRI4
CNSTI4 0
NEI4 $458
line 1380
;1380:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $454
JUMPV
LABELV $458
line 1383
;1381:	}
;1382:
;1383:	if (!G_MonsterEligibleItem(item)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 G_MonsterEligibleItem
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $461
line 1384
;1384:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $454
JUMPV
LABELV $461
line 1387
;1385:	}
;1386:
;1387:	monsterItemCounter++;
ADDRLP4 8
ADDRGP4 monsterItemCounter
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1389
;1388:
;1389:	if (monsterItemCounter % 3 != 0) {
ADDRGP4 monsterItemCounter
INDIRI4
CNSTI4 3
MODI4
CNSTI4 0
EQI4 $463
line 1390
;1390:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $454
JUMPV
LABELV $463
line 1393
;1391:	}
;1392:
;1393:	def = &g_monsterDefs[MONSTER_TYPE_MAGIC][0];
ADDRLP4 0
ADDRGP4 g_monsterDefs+5500
ASGNP4
line 1395
;1394:
;1395:	return G_MonsterSpawnFromItem(item, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 G_MonsterSpawnFromItem
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
RETI4
LABELV $454
endproc G_MonsterTryReplaceItem 16 8
proc G_MonsterFindTarget 28 8
line 1398
;1396:}
;1397:
;1398:static gentity_t *G_MonsterFindTarget(gentity_t *monster) {
line 1404
;1399:	gentity_t *player;
;1400:	gentity_t *best;
;1401:	float bestDistance;
;1402:	int i;
;1403:
;1404:	best = NULL;
ADDRLP4 12
CNSTP4 0
ASGNP4
line 1405
;1405:	bestDistance = 99999999.0f;
ADDRLP4 8
CNSTF4 1287568416
ASGNF4
line 1407
;1406:
;1407:	for (i = 0; i < level.maxclients; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $470
JUMPV
LABELV $467
line 1410
;1408:		float distance;
;1409:
;1410:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1412
;1411:
;1412:		if (!player->client) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $472
line 1413
;1413:			continue;
ADDRGP4 $468
JUMPV
LABELV $472
line 1416
;1414:		}
;1415:
;1416:		if (player->client->pers.connected != CON_CONNECTED) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $474
line 1417
;1417:			continue;
ADDRGP4 $468
JUMPV
LABELV $474
line 1420
;1418:		}
;1419:
;1420:		if (player->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $476
line 1421
;1421:			continue;
ADDRGP4 $468
JUMPV
LABELV $476
line 1424
;1422:		}
;1423:
;1424:		if (player->health <= 0) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $478
line 1425
;1425:			continue;
ADDRGP4 $468
JUMPV
LABELV $478
line 1428
;1426:		}
;1427:
;1428:		distance = DistanceSquared(
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
line 1433
;1429:			monster->r.currentOrigin,
;1430:			player->r.currentOrigin
;1431:		);
;1432:
;1433:		if (distance < bestDistance) {
ADDRLP4 16
INDIRF4
ADDRLP4 8
INDIRF4
GEF4 $480
line 1434
;1434:			bestDistance = distance;
ADDRLP4 8
ADDRLP4 16
INDIRF4
ASGNF4
line 1435
;1435:			best = player;
ADDRLP4 12
ADDRLP4 0
INDIRP4
ASGNP4
line 1436
;1436:		}
LABELV $480
line 1437
;1437:	}
LABELV $468
line 1407
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $470
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $467
line 1439
;1438:
;1439:	return best;
ADDRLP4 12
INDIRP4
RETP4
LABELV $466
endproc G_MonsterFindTarget 28 8
proc G_MonsterAnimation 16 0
line 1445
;1440:}
;1441:
;1442:static animation_t *G_MonsterAnimation(
;1443:	gentity_t *monster,
;1444:	monsterDef_t *def
;1445:) {
line 1448
;1446:	int variant;
;1447:
;1448:	variant = monster->monsterAnimationVariant;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
INDIRI4
ASGNI4
line 1450
;1449:
;1450:	if (variant < 0 || variant >= MAX_MONSTER_VARIANTS) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $485
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $483
LABELV $485
line 1451
;1451:		variant = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1452
;1452:	}
LABELV $483
line 1454
;1453:
;1454:	switch (monster->monsterAnimation) {
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
LTI4 $486
ADDRLP4 8
INDIRI4
CNSTI4 5
GTI4 $486
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $495
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $495
address $489
address $490
address $491
address $492
address $493
address $494
code
LABELV $489
line 1456
;1455:	case MONSTER_STATE_IDLE:
;1456:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 708
ADDP4
RETP4
ADDRGP4 $482
JUMPV
LABELV $490
line 1459
;1457:
;1458:	case MONSTER_STATE_MOVE:
;1459:		return &def->moveAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 736
ADDP4
RETP4
ADDRGP4 $482
JUMPV
LABELV $491
line 1462
;1460:
;1461:	case MONSTER_STATE_MELEE:
;1462:		return &def->meleeAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 764
ADDP4
ADDP4
RETP4
ADDRGP4 $482
JUMPV
LABELV $492
line 1465
;1463:
;1464:	case MONSTER_STATE_RANGED:
;1465:		return &def->rangedAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 848
ADDP4
ADDP4
RETP4
ADDRGP4 $482
JUMPV
LABELV $493
line 1468
;1466:
;1467:	case MONSTER_STATE_PAIN:
;1468:		return &def->painAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 932
ADDP4
ADDP4
RETP4
ADDRGP4 $482
JUMPV
LABELV $494
line 1471
;1469:
;1470:	case MONSTER_STATE_DEATH:
;1471:		return &def->deathAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 1016
ADDP4
ADDP4
RETP4
ADDRGP4 $482
JUMPV
LABELV $486
line 1474
;1472:
;1473:	default:
;1474:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 708
ADDP4
RETP4
LABELV $482
endproc G_MonsterAnimation 16 0
proc G_MonsterSetAnimation 0 0
line 1482
;1475:	}
;1476:}
;1477:
;1478:static void G_MonsterSetAnimation(
;1479:	gentity_t *monster,
;1480:	int animation,
;1481:	int variant
;1482:) {
line 1483
;1483:	monster->monsterAnimation = animation;
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
ADDRFP4 4
INDIRI4
ASGNI4
line 1484
;1484:	monster->monsterAnimationVariant = variant;
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 1485
;1485:	monster->monsterAnimationStart = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 836
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1486
;1486:}
LABELV $496
endproc G_MonsterSetAnimation 0 0
proc G_MonsterUpdateAnimation 36 12
line 1491
;1487:
;1488:static void G_MonsterUpdateAnimation(
;1489:	gentity_t *monster,
;1490:	monsterDef_t *def
;1491:) {
line 1496
;1492:	animation_t *animation;
;1493:	int elapsed;
;1494:	int frame;
;1495:
;1496:	animation = G_MonsterAnimation(monster, def);
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
line 1498
;1497:
;1498:	if (animation->numFrames <= 0 ||
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
LEI4 $501
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
GTI4 $499
LABELV $501
line 1499
;1499:		animation->frameLerp <= 0) {
line 1500
;1500:		return;
ADDRGP4 $498
JUMPV
LABELV $499
line 1503
;1501:	}
;1502:
;1503:	elapsed = level.time - monster->monsterAnimationStart;
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
line 1504
;1504:	frame = elapsed / animation->frameLerp;
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
line 1506
;1505:
;1506:	if (frame >= animation->numFrames) {
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
LTI4 $503
line 1507
;1507:		if (animation->loopFrames > 0) {
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
LEI4 $505
line 1508
;1508:			frame =
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
line 1513
;1509:				animation->numFrames -
;1510:				animation->loopFrames +
;1511:				(frame - animation->numFrames) %
;1512:				animation->loopFrames;
;1513:		}
ADDRGP4 $506
JUMPV
LABELV $505
line 1514
;1514:		else {
line 1515
;1515:			frame = animation->numFrames - 1;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1517
;1516:
;1517:		if( monster->monsterAnimation ==
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
EQI4 $509
ADDRLP4 24
INDIRI4
CNSTI4 3
EQI4 $510
ADDRLP4 24
INDIRI4
CNSTI4 2
NEI4 $507
LABELV $510
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $507
LABELV $509
line 1523
;1518:				MONSTER_STATE_PAIN ||
;1519:			((monster->monsterAnimation ==
;1520:					MONSTER_STATE_RANGED ||
;1521:			  monster->monsterAnimation ==
;1522:					MONSTER_STATE_MELEE) &&
;1523:			 monster->monsterShotsRemaining <= 0) ) {
line 1524
;1524:				G_MonsterSetAnimation(
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
line 1530
;1525:					monster,
;1526:					MONSTER_STATE_IDLE,
;1527:					0
;1528:				);
;1529:
;1530:				animation = &def->idleAnimation;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 708
ADDP4
ASGNP4
line 1531
;1531:				frame = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1532
;1532:			}
LABELV $507
line 1533
;1533:		}
LABELV $506
line 1534
;1534:	}
LABELV $503
line 1536
;1535:
;1536:	monster->s.frame =
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
line 1538
;1537:		animation->firstFrame + frame;
;1538:}
LABELV $498
endproc G_MonsterUpdateAnimation 36 12
proc G_MonsterGroundWalker 88 28
line 1544
;1539:
;1540:static void G_MonsterGroundWalker(
;1541:	gentity_t *monster,
;1542:	monsterDef_t *def,
;1543:	int msec
;1544:) {
line 1549
;1545:	trace_t trace;
;1546:	vec3_t destination;
;1547:	float fallDistance;
;1548:
;1549:	if( def->movementType !=
ADDRFP4 4
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
EQI4 $512
line 1550
;1550:		MONSTER_MOVEMENT_WALKING ) {
line 1551
;1551:		return;
ADDRGP4 $511
JUMPV
LABELV $512
line 1554
;1552:	}
;1553:
;1554:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1559
;1555:		monster->r.currentOrigin,
;1556:		destination
;1557:	);
;1558:
;1559:	destination[2] -= 64;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 1561
;1560:
;1561:	trap_Trace(
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
line 1571
;1562:		&trace,
;1563:		monster->r.currentOrigin,
;1564:		monster->r.mins,
;1565:		monster->r.maxs,
;1566:		destination,
;1567:		monster->s.number,
;1568:		MASK_PLAYERSOLID
;1569:	);
;1570:
;1571:	if( !trace.startsolid &&
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $515
ADDRLP4 0
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $515
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $515
line 1573
;1572:		!trace.allsolid &&
;1573:		trace.fraction < 1.0f ) {
line 1574
;1574:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1579
;1575:			monster,
;1576:			trace.endpos
;1577:		);
;1578:
;1579:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1582
;1580:			trace.entityNum;
;1581:
;1582:		return;
ADDRGP4 $511
JUMPV
LABELV $515
line 1588
;1583:	}
;1584:
;1585:	/*
;1586:	 * No nearby floor: apply simple falling movement.
;1587:	 */
;1588:	fallDistance =
ADDRLP4 68
CNSTF4 1137180672
ADDRFP4 8
INDIRI4
CVIF4 4
MULF4
CNSTF4 1148846080
DIVF4
ASGNF4
line 1591
;1589:		400.0f * msec / 1000.0f;
;1590:
;1591:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1596
;1592:		monster->r.currentOrigin,
;1593:		destination
;1594:	);
;1595:
;1596:	destination[2] -= fallDistance;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
ADDRLP4 68
INDIRF4
SUBF4
ASGNF4
line 1598
;1597:
;1598:	trap_Trace(
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
line 1608
;1599:		&trace,
;1600:		monster->r.currentOrigin,
;1601:		monster->r.mins,
;1602:		monster->r.maxs,
;1603:		destination,
;1604:		monster->s.number,
;1605:		MASK_PLAYERSOLID
;1606:	);
;1607:
;1608:	if( !trace.startsolid &&
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $522
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $522
line 1609
;1609:		!trace.allsolid ) {
line 1610
;1610:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1614
;1611:			monster,
;1612:			trace.endpos
;1613:		);
;1614:	}
LABELV $522
line 1616
;1615:
;1616:	if( trace.fraction < 1.0f ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $526
line 1617
;1617:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1619
;1618:			trace.entityNum;
;1619:	}
ADDRGP4 $527
JUMPV
LABELV $526
line 1620
;1620:	else {
line 1621
;1621:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 1623
;1622:			ENTITYNUM_NONE;
;1623:	}
LABELV $527
line 1624
;1624:}
LABELV $511
endproc G_MonsterGroundWalker 88 28
proc G_MonsterFaceTarget 52 8
line 1629
;1625:
;1626:static void G_MonsterFaceTarget(
;1627:	gentity_t *monster,
;1628:	gentity_t *target
;1629:) {
line 1633
;1630:	vec3_t direction;
;1631:	vec3_t angles;
;1632:
;1633:	if( !monster || !target ) {
ADDRLP4 24
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
EQU4 $533
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
NEU4 $531
LABELV $533
line 1634
;1634:		return;
ADDRGP4 $530
JUMPV
LABELV $531
line 1637
;1635:	}
;1636:
;1637:	VectorSubtract(
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
line 1643
;1638:		target->r.currentOrigin,
;1639:		monster->r.currentOrigin,
;1640:		direction
;1641:	);
;1642:
;1643:	if( VectorNormalize(direction) <= 0.0f ) {
ADDRLP4 12
ARGP4
ADDRLP4 48
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 48
INDIRF4
CNSTF4 0
GTF4 $536
line 1644
;1644:		return;
ADDRGP4 $530
JUMPV
LABELV $536
line 1647
;1645:	}
;1646:
;1647:	vectoangles(direction, angles);
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1648
;1648:	angles[PITCH] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1649
;1649:	angles[ROLL] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1651
;1650:
;1651:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1652
;1652:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1653
;1653:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1654
;1654:}
LABELV $530
endproc G_MonsterFaceTarget 52 8
proc G_MonsterMove 324 28
line 1662
;1655:
;1656:
;1657:static void G_MonsterMove(
;1658:	gentity_t *monster,
;1659:	gentity_t *target,
;1660:	monsterDef_t *def,
;1661:	int msec
;1662:) {
line 1681
;1663:	trace_t trace;
;1664:	trace_t slideTrace;
;1665:	vec3_t targetOrigin;
;1666:	vec3_t direction;
;1667:	vec3_t right;
;1668:	vec3_t wishDirection;
;1669:	vec3_t velocity;
;1670:	vec3_t move;
;1671:	vec3_t destination;
;1672:	vec3_t slideMove;
;1673:	vec3_t slideDestination;
;1674:	vec3_t angles;
;1675:	float phase;
;1676:	float drift;
;1677:	float distance;
;1678:	float dot;
;1679:	qboolean shouldMove;
;1680:
;1681:	VectorCopy(
ADDRLP4 128
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1686
;1682:		target->r.currentOrigin,
;1683:		targetOrigin
;1684:	);
;1685:
;1686:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $540
line 1687
;1687:		MONSTER_MOVEMENT_WALKING ) {
line 1691
;1688:		/*
;1689:		 * Walking monsters chase only horizontally.
;1690:		 */
;1691:		targetOrigin[2] =
ADDRLP4 128+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ASGNF4
line 1693
;1692:			monster->r.currentOrigin[2];
;1693:	}
ADDRGP4 $541
JUMPV
LABELV $540
line 1694
;1694:	else {
line 1695
;1695:		targetOrigin[2] += 16;
ADDRLP4 128+8
ADDRLP4 128+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 1696
;1696:	}
LABELV $541
line 1698
;1697:
;1698:	VectorSubtract(
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
line 1704
;1699:		targetOrigin,
;1700:		monster->r.currentOrigin,
;1701:		direction
;1702:	);
;1703:
;1704:	distance = VectorNormalize(direction);
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
line 1706
;1705:
;1706:	if (distance <= 0.0f) {
ADDRLP4 168
INDIRF4
CNSTF4 0
GTF4 $548
line 1707
;1707:		return;
ADDRGP4 $539
JUMPV
LABELV $548
line 1713
;1708:	}
;1709:	/*
;1710:	 * A nearby target behind a wall is not yet a valid
;1711:	 * firing position, so continue moving toward it.
;1712:	 */
;1713:	shouldMove =
ADDRLP4 168
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 648
ADDP4
INDIRF4
GTF4 $553
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
NEI4 $551
LABELV $553
ADDRLP4 260
CNSTI4 1
ASGNI4
ADDRGP4 $552
JUMPV
LABELV $551
ADDRLP4 260
CNSTI4 0
ASGNI4
LABELV $552
ADDRLP4 172
ADDRLP4 260
INDIRI4
ASGNI4
line 1724
;1714:		distance > def->attackRange ||
;1715:		!G_MonsterCanSeeTarget(
;1716:			monster,
;1717:			target
;1718:		);
;1719:	
;1720:	/*
;1721:	 * Switch between standing and movement animations
;1722:	 * without interrupting attacks, pain or death.
;1723:	 */
;1724:	if( monster->monsterAnimation ==
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
EQI4 $556
ADDRLP4 268
INDIRI4
CNSTI4 1
NEI4 $554
LABELV $556
line 1727
;1725:			MONSTER_STATE_IDLE ||
;1726:		monster->monsterAnimation ==
;1727:			MONSTER_STATE_MOVE ) {
line 1728
;1728:		if( shouldMove ||
ADDRLP4 172
INDIRI4
CNSTI4 0
NEI4 $559
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $557
LABELV $559
line 1730
;1729:			def->movePattern ==
;1730:				MONSTER_PATTERN_DRIFT ) {
line 1731
;1731:			if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
EQI4 $558
line 1732
;1732:				MONSTER_STATE_MOVE ) {
line 1733
;1733:				G_MonsterSetAnimation(
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
line 1738
;1734:					monster,
;1735:					MONSTER_STATE_MOVE,
;1736:					0
;1737:				);
;1738:			}
line 1739
;1739:		}
ADDRGP4 $558
JUMPV
LABELV $557
line 1740
;1740:		else if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 0
EQI4 $562
line 1741
;1741:			MONSTER_STATE_IDLE ) {
line 1742
;1742:			G_MonsterSetAnimation(
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
line 1747
;1743:				monster,
;1744:				MONSTER_STATE_IDLE,
;1745:				0
;1746:			);
;1747:		}
LABELV $562
LABELV $558
line 1748
;1748:	}
LABELV $554
line 1750
;1749:
;1750:	VectorSet(
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
line 1757
;1751:		right,
;1752:		-direction[1],
;1753:		direction[0],
;1754:		0
;1755:	);
;1756:
;1757:	if (VectorNormalize(right) <= 0.0f) {
ADDRLP4 104
ARGP4
ADDRLP4 272
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 272
INDIRF4
CNSTF4 0
GTF4 $567
line 1758
;1758:		VectorSet(right, 1, 0, 0);
ADDRLP4 104
CNSTF4 1065353216
ASGNF4
ADDRLP4 104+4
CNSTF4 0
ASGNF4
ADDRLP4 104+8
CNSTF4 0
ASGNF4
line 1759
;1759:	}
LABELV $567
line 1761
;1760:
;1761:	drift = 0.0f;
ADDRLP4 164
CNSTF4 0
ASGNF4
line 1763
;1762:
;1763:	if (def->movePattern == MONSTER_PATTERN_DRIFT &&
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
NEI4 $571
ADDRLP4 276
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
CNSTI4 0
LEI4 $571
line 1764
;1764:		def->driftPeriod > 0) {
line 1765
;1765:		phase =
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
line 1769
;1766:			(level.time % def->driftPeriod) /
;1767:			(float)def->driftPeriod;
;1768:
;1769:		phase *= 6.2831853f;
ADDRLP4 176
CNSTF4 1086918619
ADDRLP4 176
INDIRF4
MULF4
ASGNF4
line 1770
;1770:		phase += monster->monsterDriftPhase;
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
line 1772
;1771:
;1772:		drift =
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
line 1775
;1773:			sin(phase) *
;1774:			def->driftAmount;
;1775:	}
LABELV $571
line 1777
;1776:
;1777:	VectorClear(velocity);
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
line 1779
;1778:
;1779:	if (shouldMove) {
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $576
line 1780
;1780:		VectorCopy(direction, wishDirection);
ADDRLP4 140
ADDRLP4 80
INDIRB
ASGNB 12
line 1782
;1781:
;1782:		if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $578
line 1783
;1783:			MONSTER_PATTERN_DRIFT) {
line 1784
;1784:			VectorMA(
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
line 1790
;1785:				wishDirection,
;1786:				drift,
;1787:				right,
;1788:				wishDirection
;1789:			);
;1790:		}
LABELV $578
line 1792
;1791:
;1792:		if (VectorNormalize(wishDirection) <= 0.0f) {
ADDRLP4 140
ARGP4
ADDRLP4 284
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 284
INDIRF4
CNSTF4 0
GTF4 $586
line 1793
;1793:			return;
ADDRGP4 $539
JUMPV
LABELV $586
line 1796
;1794:		}
;1795:
;1796:		VectorScale(
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
line 1801
;1797:			wishDirection,
;1798:			def->speed,
;1799:			velocity
;1800:		);
;1801:	}
ADDRGP4 $577
JUMPV
LABELV $576
line 1802
;1802:	else if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $539
line 1803
;1803:		MONSTER_PATTERN_DRIFT) {
line 1809
;1804:		/*
;1805:		 * Inside attack range, smoothly strafe.
;1806:		 * Do not normalize this vector: driftAmount must
;1807:		 * affect the actual lateral speed.
;1808:		 */
;1809:		VectorScale(
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
line 1814
;1810:			right,
;1811:			drift * def->speed,
;1812:			velocity
;1813:		);
;1814:	}
line 1815
;1815:	else {
line 1816
;1816:		return;
LABELV $593
LABELV $577
line 1819
;1817:	}
;1818:
;1819:	VectorScale(
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
line 1825
;1820:		velocity,
;1821:		msec / 1000.0f,
;1822:		move
;1823:	);
;1824:
;1825:	if (VectorLengthSquared(move) <= 0.0001f) {
ADDRLP4 56
ARGP4
ADDRLP4 288
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 288
INDIRF4
CNSTF4 953267991
GTF4 $602
line 1826
;1826:		return;
ADDRGP4 $539
JUMPV
LABELV $602
line 1829
;1827:	}
;1828:
;1829:	VectorAdd(
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
line 1835
;1830:		monster->r.currentOrigin,
;1831:		move,
;1832:		destination
;1833:	);
;1834:
;1835:	trap_Trace(
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
line 1845
;1836:		&trace,
;1837:		monster->r.currentOrigin,
;1838:		monster->r.mins,
;1839:		monster->r.maxs,
;1840:		destination,
;1841:		monster->s.number,
;1842:		MASK_PLAYERSOLID
;1843:	);
;1844:
;1845:	G_MonsterSetOrigin(monster, trace.endpos);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1847
;1846:
;1847:	if (trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $609
ADDRLP4 300
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $609
ADDRLP4 0
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $609
line 1849
;1848:		!trace.startsolid &&
;1849:		!trace.allsolid) {
line 1853
;1850:		/*
;1851:		 * Slide only for the uncompleted part of movement.
;1852:		 */
;1853:		VectorScale(
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
line 1859
;1854:			move,
;1855:			1.0f - trace.fraction,
;1856:			slideMove
;1857:		);
;1858:
;1859:		dot = DotProduct(
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
line 1864
;1860:			slideMove,
;1861:			trace.plane.normal
;1862:		);
;1863:
;1864:		VectorMA(
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
line 1871
;1865:			slideMove,
;1866:			-dot,
;1867:			trace.plane.normal,
;1868:			slideMove
;1869:		);
;1870:
;1871:		if (VectorLengthSquared(slideMove) > 0.0001f) {
ADDRLP4 92
ARGP4
ADDRLP4 312
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 312
INDIRF4
CNSTF4 953267991
LEF4 $636
line 1872
;1872:			VectorAdd(
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
line 1878
;1873:				monster->r.currentOrigin,
;1874:				slideMove,
;1875:				slideDestination
;1876:			);
;1877:
;1878:			trap_Trace(
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
line 1888
;1879:				&slideTrace,
;1880:				monster->r.currentOrigin,
;1881:				monster->r.mins,
;1882:				monster->r.maxs,
;1883:				slideDestination,
;1884:				monster->s.number,
;1885:				MASK_PLAYERSOLID
;1886:			);
;1887:
;1888:			G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1892
;1889:				monster,
;1890:				slideTrace.endpos
;1891:			);
;1892:		}
LABELV $636
line 1893
;1893:	}
LABELV $609
line 1895
;1894:
;1895:	vectoangles(direction, angles);
ADDRLP4 80
ARGP4
ADDRLP4 116
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1896
;1896:	angles[PITCH] = 0;
ADDRLP4 116
CNSTF4 0
ASGNF4
line 1897
;1897:	angles[ROLL] = 0;
ADDRLP4 116+8
CNSTF4 0
ASGNF4
line 1899
;1898:
;1899:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1900
;1900:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1901
;1901:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1903
;1902:
;1903:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1904
;1904:}
LABELV $539
endproc G_MonsterMove 324 28
proc G_MonsterValidTarget 8 0
line 1906
;1905:
;1906:static qboolean G_MonsterValidTarget(gentity_t *target) {
line 1907
;1907:	if (!target || !target->client) {
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
EQU4 $647
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $645
LABELV $647
line 1908
;1908:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $644
JUMPV
LABELV $645
line 1911
;1909:	}
;1910:
;1911:	if (target->client->pers.connected != CON_CONNECTED) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $648
line 1912
;1912:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $644
JUMPV
LABELV $648
line 1915
;1913:	}
;1914:
;1915:	if (target->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $650
line 1916
;1916:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $644
JUMPV
LABELV $650
line 1919
;1917:	}
;1918:
;1919:	if (target->health <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $652
line 1920
;1920:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $644
JUMPV
LABELV $652
line 1923
;1921:	}
;1922:
;1923:	return qtrue;
CNSTI4 1
RETI4
LABELV $644
endproc G_MonsterValidTarget 8 0
proc G_MonsterFireProjectile 72 12
line 1934
;1924:}
;1925:
;1926:static void G_MonsterFireProjectile(
;1927:	gentity_t *monster,
;1928:	gentity_t *target,
;1929:	monsterDef_t *def,
;1930:	const char *projectile,
;1931:	int damage,
;1932:	int splashDamage,
;1933:	int splashRadius
;1934:) {
line 1940
;1935:	gentity_t *bolt;
;1936:	vec3_t start;
;1937:	vec3_t targetOrigin;
;1938:	vec3_t direction;
;1939:
;1940:	VectorCopy(
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1945
;1941:		monster->r.currentOrigin,
;1942:		start
;1943:	);
;1944:
;1945:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $655
line 1946
;1946:		MONSTER_MOVEMENT_WALKING ) {
line 1947
;1947:		start[2] += 36;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1108344832
ADDF4
ASGNF4
line 1948
;1948:	}
ADDRGP4 $656
JUMPV
LABELV $655
line 1949
;1949:	else {
line 1950
;1950:		start[2] += 8;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 1951
;1951:	}
LABELV $656
line 1953
;1952:
;1953:	VectorCopy(
ADDRLP4 28
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1958
;1954:		target->r.currentOrigin,
;1955:		targetOrigin
;1956:	);
;1957:
;1958:	targetOrigin[2] +=
ADDRLP4 28+8
ADDRLP4 28+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 1961
;1959:		DEFAULT_VIEWHEIGHT * 0.5f;
;1960:
;1961:	VectorSubtract(
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
line 1967
;1962:		targetOrigin,
;1963:		start,
;1964:		direction
;1965:	);
;1966:
;1967:	VectorNormalize(direction);
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 1969
;1968:
;1969:	VectorMA(
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
line 1976
;1970:		start,
;1971:		24,
;1972:		direction,
;1973:		start
;1974:	);
;1975:
;1976:	if( projectile &&
ADDRLP4 44
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 44
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $672
ADDRLP4 44
INDIRP4
ARGP4
ADDRGP4 $674
ARGP4
ADDRLP4 48
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
NEI4 $672
line 1977
;1977:		!Q_stricmp(projectile, "rocket") ) {
line 1978
;1978:		bolt = fire_rocket(
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
line 1983
;1979:			monster,
;1980:			start,
;1981:			direction
;1982:		);
;1983:	}
ADDRGP4 $673
JUMPV
LABELV $672
line 1984
;1984:	else if( projectile &&
ADDRLP4 52
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 52
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $675
ADDRLP4 52
INDIRP4
ARGP4
ADDRGP4 $677
ARGP4
ADDRLP4 56
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 0
NEI4 $675
line 1985
;1985:		!Q_stricmp(projectile, "blaster") ) {
line 1986
;1986:		bolt = fire_blaster(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 60
ADDRGP4 fire_blaster
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 60
INDIRP4
ASGNP4
line 1991
;1987:			monster,
;1988:			start,
;1989:			direction
;1990:		);
;1991:	}
ADDRGP4 $676
JUMPV
LABELV $675
line 1992
;1992:	else {
line 1993
;1993:		bolt = fire_plasma(
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
line 1998
;1994:			monster,
;1995:			start,
;1996:			direction
;1997:		);
;1998:	}
LABELV $676
LABELV $673
line 2000
;1999:
;2000:	bolt->damage = damage;
ADDRLP4 0
INDIRP4
CNSTI4 740
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
line 2001
;2001:	bolt->splashDamage = splashDamage;
ADDRLP4 0
INDIRP4
CNSTI4 744
ADDP4
ADDRFP4 20
INDIRI4
ASGNI4
line 2002
;2002:	bolt->splashRadius = splashRadius;
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
ADDRFP4 24
INDIRI4
ASGNI4
line 2004
;2003:
;2004:	VectorScale(
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
line 2010
;2005:		direction,
;2006:		def->projectileSpeed,
;2007:		bolt->s.pos.trDelta
;2008:	);
;2009:
;2010:	SnapVector(bolt->s.pos.trDelta);
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
line 2012
;2011:
;2012:	if( monster->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $680
line 2013
;2013:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2016
;2014:			level.time;
;2015:
;2016:		VectorCopy(
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
line 2020
;2017:			monster->r.currentOrigin,
;2018:			monster->monsterProgressOrigin
;2019:		);
;2020:	}
LABELV $680
line 2021
;2021:}
LABELV $654
endproc G_MonsterFireProjectile 72 12
proc G_MonsterStartRangedAttack 72 16
line 2027
;2022:
;2023:static void G_MonsterStartRangedAttack(
;2024:	gentity_t *monster,
;2025:	gentity_t *target,
;2026:	monsterDef_t *def
;2027:) {
line 2035
;2028:	animation_t *animation;
;2029:	int variant;
;2030:	int fireFrame;
;2031:	int windup;
;2032:	vec3_t direction;
;2033:	vec3_t angles;
;2034:
;2035:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2036
;2036:	animation = &def->rangedAnimations[variant];
ADDRLP4 4
CNSTI4 28
ADDRLP4 20
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 848
ADDP4
ADDP4
ASGNP4
line 2038
;2037:
;2038:	fireFrame = def->attackFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 656
ADDP4
INDIRI4
ASGNI4
line 2040
;2039:
;2040:	if (fireFrame < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $684
line 2041
;2041:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2042
;2042:	}
LABELV $684
line 2044
;2043:
;2044:	if (animation->numFrames > 0 &&
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
LEI4 $686
ADDRLP4 0
INDIRI4
ADDRLP4 44
INDIRI4
LTI4 $686
line 2045
;2045:		fireFrame >= animation->numFrames) {
line 2046
;2046:		fireFrame = animation->numFrames - 1;
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2047
;2047:	}
LABELV $686
line 2049
;2048:
;2049:	windup = fireFrame * animation->frameLerp;
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
line 2054
;2050:
;2051:	/*
;2052:	 * Face the target when the attack animation begins.
;2053:	 */
;2054:	VectorSubtract(
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
line 2060
;2055:		target->r.currentOrigin,
;2056:		monster->r.currentOrigin,
;2057:		direction
;2058:	);
;2059:
;2060:	if( VectorNormalize(direction) > 0.0f ) {
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
LEF4 $690
line 2061
;2061:		vectoangles(direction, angles);
ADDRLP4 8
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2063
;2062:
;2063:		angles[PITCH] = 0;
ADDRLP4 24
CNSTF4 0
ASGNF4
line 2064
;2064:		angles[ROLL] = 0;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 2066
;2065:
;2066:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2071
;2067:			angles,
;2068:			monster->s.angles
;2069:		);
;2070:
;2071:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2076
;2072:			angles,
;2073:			monster->s.apos.trBase
;2074:		);
;2075:
;2076:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2080
;2077:			angles,
;2078:			monster->r.currentAngles
;2079:		);
;2080:	}
LABELV $690
line 2082
;2081:
;2082:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2083
;2083:	monster->monsterShotsRemaining = def->burstCount;
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
line 2084
;2084:	monster->monsterNextShot = level.time + windup;
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
line 2086
;2085:
;2086:	G_MonsterSetAnimation(
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
line 2092
;2087:		monster,
;2088:		MONSTER_STATE_RANGED,
;2089:		variant
;2090:	);
;2091:
;2092:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 $694
ARGP4
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2098
;2093:		monster,
;2094:		def,
;2095:		"ranged",
;2096:		variant
;2097:	);
;2098:}
LABELV $683
endproc G_MonsterStartRangedAttack 72 16
proc G_MonsterStartMeleeAttack 24 16
line 2104
;2099:
;2100:static void G_MonsterStartMeleeAttack(
;2101:	gentity_t *monster,
;2102:	gentity_t *target,
;2103:	monsterDef_t *def
;2104:) {
line 2110
;2105:	animation_t *animation;
;2106:	int variant;
;2107:	int fireFrame;
;2108:	int windup;
;2109:
;2110:	variant =
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
line 2113
;2111:		rand() % MAX_MONSTER_VARIANTS;
;2112:
;2113:	animation =
ADDRLP4 4
CNSTI4 28
ADDRLP4 8
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 764
ADDP4
ADDP4
ASGNP4
line 2116
;2114:		&def->meleeAnimations[variant];
;2115:
;2116:	fireFrame = def->meleeFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
ASGNI4
line 2118
;2117:
;2118:	if( fireFrame < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $696
line 2119
;2119:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2120
;2120:	}
LABELV $696
line 2122
;2121:
;2122:	if( animation->numFrames > 0 &&
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
LEI4 $698
ADDRLP4 0
INDIRI4
ADDRLP4 20
INDIRI4
LTI4 $698
line 2123
;2123:		fireFrame >= animation->numFrames ) {
line 2124
;2124:		fireFrame =
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2126
;2125:			animation->numFrames - 1;
;2126:	}
LABELV $698
line 2128
;2127:
;2128:	windup =
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
line 2132
;2129:		fireFrame *
;2130:		animation->frameLerp;
;2131:
;2132:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2133
;2133:	monster->monsterShotsRemaining = 1;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 1
ASGNI4
line 2134
;2134:	monster->monsterNextShot =
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
line 2137
;2135:		level.time + windup;
;2136:
;2137:	G_MonsterSetAnimation(
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
line 2147
;2138:		monster,
;2139:		MONSTER_STATE_MELEE,
;2140:		variant
;2141:	);
;2142:
;2143:	/*
;2144:	 * Melee temporarily reuses the monster's
;2145:	 * ranged attack sound group.
;2146:	 */
;2147:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 $694
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2153
;2148:		monster,
;2149:		def,
;2150:		"ranged",
;2151:		variant
;2152:	);
;2153:}
LABELV $695
endproc G_MonsterStartMeleeAttack 24 16
proc G_MonsterCanSeeTarget 92 28
line 2158
;2154:
;2155:static qboolean G_MonsterCanSeeTarget(
;2156:	gentity_t *monster,
;2157:	gentity_t *target
;2158:) {
line 2163
;2159:	trace_t trace;
;2160:	vec3_t start;
;2161:	vec3_t end;
;2162:
;2163:	if (!G_MonsterValidTarget(target)) {
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
NEI4 $702
line 2164
;2164:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $701
JUMPV
LABELV $702
line 2167
;2165:	}
;2166:
;2167:	VectorCopy(monster->r.currentOrigin, start);
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2168
;2168:	start[2] += 8;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2170
;2169:
;2170:	VectorCopy(target->r.currentOrigin, end);
ADDRLP4 68
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2171
;2171:	end[2] += DEFAULT_VIEWHEIGHT * 0.5f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 2173
;2172:
;2173:	trap_Trace(
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
line 2183
;2174:		&trace,
;2175:		start,
;2176:		NULL,
;2177:		NULL,
;2178:		end,
;2179:		monster->s.number,
;2180:		MASK_SHOT
;2181:	);
;2182:
;2183:	return trace.fraction == 1.0f ||
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $711
ADDRLP4 0+52
INDIRI4
ADDRFP4 4
INDIRP4
INDIRI4
NEI4 $709
LABELV $711
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRGP4 $710
JUMPV
LABELV $709
ADDRLP4 88
CNSTI4 0
ASGNI4
LABELV $710
ADDRLP4 88
INDIRI4
RETI4
LABELV $701
endproc G_MonsterCanSeeTarget 92 28
proc G_MonsterRunAttack 32 28
line 2190
;2184:		trace.entityNum == target->s.number;
;2185:}
;2186:
;2187:static void G_MonsterRunAttack(
;2188:	gentity_t *monster,
;2189:	monsterDef_t *def
;2190:) {
line 2193
;2191:	qboolean meleeAttack;
;2192:
;2193:	if( monster->monsterShotsRemaining <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $713
line 2194
;2194:		return;
ADDRGP4 $712
JUMPV
LABELV $713
line 2197
;2195:	}
;2196:
;2197:	if( !G_MonsterValidTarget(monster->enemy) ||
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
EQI4 $717
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
NEI4 $715
LABELV $717
line 2201
;2198:		!G_MonsterCanSeeTarget(
;2199:			monster,
;2200:			monster->enemy
;2201:		) ) {
line 2202
;2202:		monster->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2204
;2203:
;2204:		monster->monsterNextAttack =
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
line 2208
;2205:			level.time +
;2206:			def->attackCooldown;
;2207:
;2208:		return;
ADDRGP4 $712
JUMPV
LABELV $715
line 2211
;2209:	}
;2210:
;2211:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
INDIRI4
GEI4 $719
line 2212
;2212:		monster->monsterNextShot ) {
line 2213
;2213:		return;
ADDRGP4 $712
JUMPV
LABELV $719
line 2216
;2214:	}
;2215:
;2216:	meleeAttack =
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 2
NEI4 $723
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $724
JUMPV
LABELV $723
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $724
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
line 2220
;2217:		monster->monsterAnimation ==
;2218:		MONSTER_STATE_MELEE;
;2219:
;2220:	if( meleeAttack ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $725
line 2221
;2221:		G_MonsterFireProjectile(
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 20
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 24
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 24
INDIRP4
CNSTI4 668
ADDP4
INDIRI4
ARGI4
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 G_MonsterFireProjectile
CALLV
pop
line 2230
;2222:			monster,
;2223:			monster->enemy,
;2224:			def,
;2225:			def->meleeProjectile,
;2226:			def->meleeDamage,
;2227:			0,
;2228:			0
;2229:		);
;2230:	}
ADDRGP4 $726
JUMPV
LABELV $725
line 2231
;2231:	else {
line 2232
;2232:		G_MonsterFireProjectile(
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 20
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ARGP4
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 24
INDIRP4
CNSTI4 448
ADDP4
ARGP4
ADDRLP4 24
INDIRP4
CNSTI4 684
ADDP4
INDIRI4
ARGI4
ADDRLP4 24
INDIRP4
CNSTI4 688
ADDP4
INDIRI4
ARGI4
ADDRLP4 24
INDIRP4
CNSTI4 692
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_MonsterFireProjectile
CALLV
pop
line 2241
;2233:			monster,
;2234:			monster->enemy,
;2235:			def,
;2236:			def->projectile,
;2237:			def->projectileDamage,
;2238:			def->splashDamage,
;2239:			def->splashRadius
;2240:		);
;2241:	}
LABELV $726
line 2243
;2242:
;2243:	monster->monsterShotsRemaining--;
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
line 2245
;2244:
;2245:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $727
line 2246
;2246:		monster->monsterNextShot =
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
line 2249
;2247:			level.time +
;2248:			def->burstInterval;
;2249:	}
ADDRGP4 $728
JUMPV
LABELV $727
line 2250
;2250:	else {
line 2251
;2251:		monster->monsterNextAttack =
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
line 2254
;2252:			level.time +
;2253:			def->attackCooldown;
;2254:	}
LABELV $728
line 2255
;2255:}
LABELV $712
endproc G_MonsterRunAttack 32 28
proc G_MonsterAttack 32 12
line 2261
;2256:
;2257:static void G_MonsterAttack(
;2258:	gentity_t *monster,
;2259:	gentity_t *target,
;2260:	monsterDef_t *def
;2261:) {
line 2264
;2262:	float distanceSquared;
;2263:
;2264:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $732
line 2265
;2265:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2269
;2266:			monster,
;2267:			def
;2268:		);
;2269:		return;
ADDRGP4 $731
JUMPV
LABELV $732
line 2272
;2270:	}
;2271:
;2272:	if( monster->monsterAnimation !=
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
EQI4 $734
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $734
line 2275
;2273:			MONSTER_STATE_MOVE &&
;2274:		monster->monsterAnimation !=
;2275:			MONSTER_STATE_IDLE ) {
line 2276
;2276:		return;
ADDRGP4 $731
JUMPV
LABELV $734
line 2279
;2277:	}
;2278:
;2279:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
INDIRI4
GEI4 $736
line 2280
;2280:		monster->monsterNextAttack ) {
line 2281
;2281:		return;
ADDRGP4 $731
JUMPV
LABELV $736
line 2284
;2282:	}
;2283:
;2284:	distanceSquared = DistanceSquared(
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
line 2289
;2285:		monster->r.currentOrigin,
;2286:		target->r.currentOrigin
;2287:	);
;2288:
;2289:	if( !G_MonsterCanSeeTarget(
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
NEI4 $739
line 2292
;2290:		monster,
;2291:		target
;2292:	) ) {
line 2293
;2293:		return;
ADDRGP4 $731
JUMPV
LABELV $739
line 2299
;2294:	}
;2295:
;2296:	/*
;2297:	 * Prefer melee whenever the target is close enough.
;2298:	 */
;2299:	if( def->hasMelee &&
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
EQI4 $741
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
GTF4 $741
line 2302
;2300:		distanceSquared <=
;2301:			def->meleeRange *
;2302:			def->meleeRange ) {
line 2303
;2303:		G_MonsterStartMeleeAttack(
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
line 2309
;2304:			monster,
;2305:			target,
;2306:			def
;2307:		);
;2308:
;2309:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2314
;2310:			monster,
;2311:			def
;2312:		);
;2313:
;2314:		return;
ADDRGP4 $731
JUMPV
LABELV $741
line 2317
;2315:	}
;2316:
;2317:	if( !def->hasRanged ) {
ADDRFP4 8
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 0
NEI4 $743
line 2318
;2318:		return;
ADDRGP4 $731
JUMPV
LABELV $743
line 2321
;2319:	}
;2320:
;2321:	if( distanceSquared >
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
LEF4 $745
line 2323
;2322:		def->attackRange *
;2323:		def->attackRange ) {
line 2324
;2324:		return;
ADDRGP4 $731
JUMPV
LABELV $745
line 2327
;2325:	}
;2326:
;2327:	G_MonsterStartRangedAttack(
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
line 2333
;2328:		monster,
;2329:		target,
;2330:		def
;2331:	);
;2332:
;2333:	G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2337
;2334:		monster,
;2335:		def
;2336:	);
;2337:}
LABELV $731
endproc G_MonsterAttack 32 12
proc G_MonsterThink 36 16
line 2339
;2338:
;2339:static void G_MonsterThink(gentity_t *monster) {
line 2344
;2340:	monsterDef_t *def;
;2341:	gentity_t *target;
;2342:	int msec;
;2343:
;2344:	def = &g_monsterDefs
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 1100
ADDRLP4 12
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5500
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
line 2348
;2345:		[monster->monsterType]
;2346:		[monster->monsterSlot];
;2347:
;2348:	G_MonsterUpdateAnimation(monster, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 G_MonsterUpdateAnimation
CALLV
pop
line 2350
;2349:
;2350:	if (monster->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $748
line 2351
;2351:		if (level.time >= monster->monsterDeathTime) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 852
ADDP4
INDIRI4
LTI4 $750
line 2352
;2352:			if (monsterActiveCount > 0) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 0
LEI4 $753
line 2353
;2353:				monsterActiveCount--;
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
line 2354
;2354:			}
LABELV $753
line 2356
;2355:
;2356:			G_FreeEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 2357
;2357:			return;
ADDRGP4 $747
JUMPV
LABELV $750
line 2360
;2358:		}
;2359:
;2360:		monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2361
;2361:		return;
ADDRGP4 $747
JUMPV
LABELV $748
line 2364
;2362:	}
;2363:
;2364:	msec = level.time - monster->monsterLastThink;
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
line 2366
;2365:
;2366:	if (msec < 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
GEI4 $757
line 2367
;2367:		msec = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 2368
;2368:	}
ADDRGP4 $758
JUMPV
LABELV $757
line 2369
;2369:	else if (msec > 100) {
ADDRLP4 0
INDIRI4
CNSTI4 100
LEI4 $759
line 2370
;2370:		msec = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 2371
;2371:	}
LABELV $759
LABELV $758
line 2373
;2372:
;2373:	monster->monsterLastThink = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2375
;2374:
;2375:	target = G_MonsterFindTarget(monster);
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
line 2377
;2376:
;2377:		if (target) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $762
line 2378
;2378:			G_MonsterFaceTarget(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterFaceTarget
CALLV
pop
line 2383
;2379:				monster,
;2380:				target
;2381:			);
;2382:
;2383:			G_MonsterMove(
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
line 2389
;2384:				monster,
;2385:				target,
;2386:				def,
;2387:				msec
;2388:			);
;2389:		G_MonsterAttack(monster, target, def);
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
line 2391
;2390:
;2391:		if (monster->monsterAnimation == MONSTER_STATE_MOVE &&
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
NEI4 $763
ADDRGP4 level+32
INDIRI4
ADDRLP4 20
INDIRP4
CNSTI4 856
ADDP4
INDIRI4
LTI4 $763
line 2392
;2392:			level.time >= monster->monsterNextTalk) {
line 2395
;2393:			int variant;
;2394:
;2395:			variant =
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 24
ADDRLP4 28
INDIRI4
CNSTI4 3
MODI4
ASGNI4
line 2398
;2396:				rand() % MAX_MONSTER_VARIANTS;
;2397:
;2398:			G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $767
ARGP4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2405
;2399:				monster,
;2400:				def,
;2401:				"talk",
;2402:				variant
;2403:			);
;2404:
;2405:			monster->monsterNextTalk =
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 G_MonsterTalkDelay
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 856
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 32
INDIRI4
ADDI4
ASGNI4
line 2408
;2406:				level.time +
;2407:				G_MonsterTalkDelay(def);
;2408:		}
line 2409
;2409:	}
ADDRGP4 $763
JUMPV
LABELV $762
line 2411
;2410:	
;2411:	else if( monster->monsterAnimation ==
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
NEI4 $769
line 2412
;2412:		MONSTER_STATE_MOVE ) {
line 2413
;2413:		G_MonsterSetAnimation(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 20
INDIRI4
ARGI4
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 2418
;2414:			monster,
;2415:			MONSTER_STATE_IDLE,
;2416:			0
;2417:		);
;2418:	}
LABELV $769
LABELV $763
line 2424
;2419:
;2420:	/*
;2421:	 * Walking monsters remain attached to the floor
;2422:	 * and fall when moving over an edge.
;2423:	 */
;2424:	G_MonsterGroundWalker(
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
line 2434
;2425:		monster,
;2426:		def,
;2427:		msec
;2428:	);
;2429:	
;2430:	/*
;2431:	 * Remember meaningful movement so an active monster
;2432:	 * is not mistaken for a lost one.
;2433:	 */
;2434:	if( monster->monsterWaveSpawn &&
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $771
ADDRLP4 20
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 20
INDIRP4
CNSTI4 824
ADDP4
ARGP4
ADDRLP4 24
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 24
INDIRF4
CNSTF4 1149239296
LTF4 $771
line 2438
;2435:		DistanceSquared(
;2436:			monster->r.currentOrigin,
;2437:			monster->monsterProgressOrigin
;2438:		) >= 32.0f * 32.0f ) {
line 2439
;2439:		VectorCopy(
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 28
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2444
;2440:			monster->r.currentOrigin,
;2441:			monster->monsterProgressOrigin
;2442:		);
;2443:
;2444:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2446
;2445:			level.time;
;2446:	}
LABELV $771
line 2448
;2447:
;2448:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2450
;2449:
;2450:	monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2451
;2451:}
LABELV $747
endproc G_MonsterThink 36 16
proc G_MonsterSound 68 24
line 2458
;2452:
;2453:static void G_MonsterSound(
;2454:	gentity_t *monster,
;2455:	monsterDef_t *def,
;2456:	const char *group,
;2457:	int variant
;2458:) {
line 2461
;2459:	char filename[MAX_QPATH];
;2460:
;2461:	Com_sprintf(
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $776
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
line 2470
;2462:		filename,
;2463:		sizeof(filename),
;2464:		"%s/%s%i.wav",
;2465:		def->soundDir,
;2466:		group,
;2467:		variant + 1
;2468:	);
;2469:
;2470:	G_Sound(
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
line 2475
;2471:		monster,
;2472:		CHAN_VOICE,
;2473:		G_SoundIndex(filename)
;2474:	);
;2475:}
LABELV $775
endproc G_MonsterSound 68 24
proc G_MonsterTalkDelay 12 0
line 2477
;2476:
;2477:static int G_MonsterTalkDelay(monsterDef_t *def) {
line 2480
;2478:	int range;
;2479:
;2480:	range = def->talkMaxDelay - def->talkMinDelay;
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
line 2482
;2481:
;2482:	if (range <= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $778
line 2483
;2483:		return def->talkMinDelay;
ADDRFP4 0
INDIRP4
CNSTI4 696
ADDP4
INDIRI4
RETI4
ADDRGP4 $777
JUMPV
LABELV $778
line 2486
;2484:	}
;2485:
;2486:	return def->talkMinDelay + rand() % (range + 1);
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
LABELV $777
endproc G_MonsterTalkDelay 12 0
proc G_MonsterPain 16 16
line 2493
;2487:}
;2488:
;2489:static void G_MonsterPain(
;2490:	gentity_t *self,
;2491:	gentity_t *attacker,
;2492:	int damage
;2493:) {
line 2497
;2494:	monsterDef_t *def;
;2495:	int variant;
;2496:
;2497:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $781
line 2498
;2498:		return;
ADDRGP4 $780
JUMPV
LABELV $781
line 2501
;2499:	}
;2500:	
;2501:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $783
line 2502
;2502:	self->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2505
;2503:		level.time;
;2504:
;2505:	VectorCopy(
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
line 2509
;2506:		self->r.currentOrigin,
;2507:		self->monsterProgressOrigin
;2508:	);
;2509:}
LABELV $783
line 2511
;2510:
;2511:	if (level.time < self->pain_debounce_time) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
GEI4 $786
line 2512
;2512:		return;
ADDRGP4 $780
JUMPV
LABELV $786
line 2515
;2513:	}
;2514:
;2515:	def = &g_monsterDefs
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1100
ADDRLP4 8
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5500
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
line 2520
;2516:		[self->monsterType]
;2517:		[self->monsterSlot];
;2518:			
;2519:
;2520:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2522
;2521:
;2522:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2523
;2523:	self->monsterNextAttack = level.time + def->attackCooldown;
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
line 2525
;2524:
;2525:	G_MonsterSetAnimation(
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
line 2531
;2526:		self,
;2527:		MONSTER_STATE_PAIN,
;2528:		variant
;2529:	);
;2530:
;2531:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $790
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2538
;2532:		self,
;2533:		def,
;2534:		"pain",
;2535:		variant
;2536:	);
;2537:
;2538:	self->pain_debounce_time = level.time + 700;
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 700
ADDI4
ASGNI4
line 2539
;2539:}
LABELV $780
endproc G_MonsterPain 16 16
proc G_MonsterDropItem 36 12
line 2541
;2540:
;2541:static void G_MonsterDropItem(gentity_t *monster) {
line 2544
;2542:	vec3_t velocity;
;2543:
;2544:	if (!monster->monsterItem ||
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
EQU4 $795
ADDRLP4 12
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 16
INDIRU4
NEU4 $793
LABELV $795
line 2545
;2545:		!monster->monsterItem->item) {
line 2546
;2546:		return;
ADDRGP4 $792
JUMPV
LABELV $793
line 2549
;2547:	}
;2548:
;2549:	if (rand() % 100 >= 50) {
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 100
MODI4
CNSTI4 50
LTI4 $796
line 2550
;2550:		return;
ADDRGP4 $792
JUMPV
LABELV $796
line 2553
;2551:	}
;2552:
;2553:	VectorSet(
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
line 2560
;2554:		velocity,
;2555:		crandom() * 60,
;2556:		crandom() * 60,
;2557:		140
;2558:	);
;2559:
;2560:	LaunchItem(
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
line 2565
;2561:		monster->monsterItem->item,
;2562:		monster->r.currentOrigin,
;2563:		velocity
;2564:	);
;2565:}
LABELV $792
endproc G_MonsterDropItem 36 12
proc G_MonsterDie 56 16
line 2573
;2566:
;2567:static void G_MonsterDie(
;2568:	gentity_t *self,
;2569:	gentity_t *inflictor,
;2570:	gentity_t *attacker,
;2571:	int damage,
;2572:	int mod
;2573:) {
line 2579
;2574:	monsterDef_t *def;
;2575:	animation_t *animation;
;2576:	int variant;
;2577:	int duration;
;2578:
;2579:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $801
line 2580
;2580:		return;
ADDRGP4 $800
JUMPV
LABELV $801
line 2583
;2581:	}
;2582:
;2583:	def = &g_monsterDefs
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1100
ADDRLP4 16
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5500
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
line 2587
;2584:		[self->monsterType]
;2585:		[self->monsterSlot];
;2586:
;2587:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2589
;2588:
;2589:	self->monsterDead = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 1
ASGNI4
line 2590
;2590:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $803
line 2591
;2591:		monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2592
;2592:	}
LABELV $803
line 2594
;2593:	
;2594:	self->s.eFlags |= EF_DEAD;
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
line 2595
;2595:	self->takedamage = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 2596
;2596:	self->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 2597
;2597:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2599
;2598:
;2599:	self->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 2600
;2600:	self->clipmask = 0;
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 0
ASGNI4
line 2601
;2601:	trap_LinkEntity(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2603
;2602:
;2603:	G_MonsterSetAnimation(
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
line 2609
;2604:		self,
;2605:		MONSTER_STATE_DEATH,
;2606:		variant
;2607:	);
;2608:
;2609:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $806
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2616
;2610:		self,
;2611:		def,
;2612:		"death",
;2613:		variant
;2614:	);
;2615:
;2616:	animation = &def->deathAnimations[variant];
ADDRLP4 8
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 1016
ADDP4
ADDP4
ASGNP4
line 2617
;2617:	duration = animation->numFrames *
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
line 2620
;2618:		animation->frameLerp;
;2619:
;2620:	self->monsterDeathTime =
ADDRFP4 0
INDIRP4
CNSTI4 852
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 12
INDIRI4
ADDI4
CNSTI4 1000
ADDI4
ASGNI4
line 2627
;2621:		level.time + duration + 1000;
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
EQI4 $808
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
EQU4 $808
ADDRLP4 36
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 40
INDIRU4
EQU4 $808
ADDRLP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
LEI4 $808
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
LABELV $808
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
NEI4 $811
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
EQU4 $811
ADDRLP4 52
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
EQI4 $811
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
LEI4 $811
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
LABELV $811
line 2653
;2653:}
LABELV $800
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
skip 33000
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
LABELV $806
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $790
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $776
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
LABELV $767
byte 1 116
byte 1 97
byte 1 108
byte 1 107
byte 1 0
align 1
LABELV $694
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $677
byte 1 98
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $674
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $421
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
LABELV $379
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
LABELV $378
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
LABELV $377
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
