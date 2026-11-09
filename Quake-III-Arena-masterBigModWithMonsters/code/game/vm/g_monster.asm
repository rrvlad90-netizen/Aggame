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
proc G_LoadMonsterConfig 9648 16
file "../g_monster.c"
line 132
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
;51:	int maxActive;   /* 0 = use global monsterWaveMaxActive */
;52:} monsterWaveDef_t;
;53:
;54:static monsterWaveDef_t monsterWaves[MAX_MONSTER_WAVES];
;55:
;56:static int monsterWaveDelay;
;57:static int monsterWaveSpawnInterval;
;58:static int monsterWaveTimeout;
;59:static int monsterWaveMaxActive;
;60:static int monsterWaveFinal;
;61:static qboolean monsterWavesLoaded;
;62:
;63:static int monsterCurrentWave;
;64:static int monsterWaveEntry;
;65:static int monsterWaveEntrySpawned;
;66:static int monsterWaveNextSpawn;
;67:static int monsterWaveNextStart;
;68:static int monsterWaveLastProgress;
;69:
;70:static qboolean monsterWaveActive;
;71:static qboolean monsterWaveStarted;
;72:static qboolean monsterWaveCombatStarted;
;73:static qboolean monsterWaveFinished;
;74:
;75:static qboolean G_LoadMonsterWaveConfig(
;76:	const char *filename
;77:);
;78:
;79:
;80:static void G_MonsterSetAnimation(
;81:	gentity_t *monster,
;82:	int animation,
;83:	int variant
;84:);
;85:
;86:static int G_MonsterTalkDelay(monsterDef_t *def);
;87:
;88:static void G_MonsterSound(
;89:	gentity_t *monster,
;90:	monsterDef_t *def,
;91:	const char *group,
;92:	int variant
;93:);
;94:
;95:monsterDef_t g_monsterDefs
;96:	[MONSTER_TYPE_RANDOM]
;97:	[MAX_MONSTERS_PER_TYPE];
;98:
;99:qboolean g_monsterDefLoaded
;100:	[MONSTER_TYPE_RANDOM]
;101:	[MAX_MONSTERS_PER_TYPE];
;102:
;103:static const char *monsterConfigFiles[] = {
;104:	"models/monsters/HereticDisciple/monster.cfg",
;105:	"models/monsters/DarkKnight/monster.cfg",
;106:	"models/monsters/LionGuy/monster.cfg",
;107:	"models/monsters/D3Imp/monster.cfg",
;108:	"models/monsters/Gross/monster.cfg",
;109:	"models/monsters/Flyer/monster.cfg",
;110:	"models/monsters/Hover/monster.cfg",
;111:	"models/monsters/FlyingGuard/monster.cfg",
;112:	"models/monsters/StrongF/monster.cfg",
;113:	"models/monsters/Gunner/monster.cfg",	
;114:	"models/monsters/MongGrunt/monster.cfg",
;115:	"models/monsters/MongGruntShotgun/monster.cfg",
;116:	"models/monsters/MongGruntRifle/monster.cfg",
;117:	"models/monsters/Faust/monster.cfg",
;118:	"models/monsters/Stratos/monster.cfg",
;119:	"models/monsters/Mincer/monster.cfg",
;120:	"models/monsters/Forgotten/monster.cfg",
;121:	"models/monsters/Ghost/monster.cfg",
;122:	"models/monsters/Mancubus/monster.cfg",
;123:	"models/monsters/Frostatronach/monster.cfg",
;124:	"models/monsters/Trooper/monster.cfg",
;125:	"models/monsters/TrooperShotgun/monster.cfg",
;126:	"models/monsters/TrooperBlaster/monster.cfg",
;127:	"models/monsters/TrooperFlyer/monster.cfg",
;128:	"models/monsters/TrooperRocket/monster.cfg",	
;129:	NULL
;130:};
;131:
;132:static qboolean G_LoadMonsterConfig(const char *filename) {
line 139
;133:	fileHandle_t file;
;134:	char text[MAX_MONSTER_CONFIG_TEXT];
;135:	char error[256];
;136:	monsterDef_t def;
;137:	int length;
;138:
;139:	length = trap_FS_FOpenFile(filename, &file, FS_READ);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1184
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 9636
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 1180
ADDRLP4 9636
INDIRI4
ASGNI4
line 141
;140:
;141:	if (!file) {
ADDRLP4 1184
INDIRI4
CNSTI4 0
NEI4 $85
line 142
;142:		G_Printf(
ADDRGP4 $87
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 146
;143:			S_COLOR_RED "Monster config not found: %s\n",
;144:			filename
;145:		);
;146:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $85
line 149
;147:	}
;148:
;149:	if (length <= 0 || length >= sizeof(text)) {
ADDRLP4 1180
INDIRI4
CNSTI4 0
LEI4 $90
ADDRLP4 1180
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $88
LABELV $90
line 150
;150:		G_Printf(
ADDRGP4 $91
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 154
;151:			S_COLOR_RED "Invalid monster config size: %s\n",
;152:			filename
;153:		);
;154:		trap_FS_FCloseFile(file);
ADDRLP4 1184
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 155
;155:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $88
line 158
;156:	}
;157:
;158:	trap_FS_Read(text, length, file);
ADDRLP4 1188
ARGP4
ADDRLP4 1180
INDIRI4
ARGI4
ADDRLP4 1184
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 159
;159:	text[length] = '\0';
ADDRLP4 1180
INDIRI4
ADDRLP4 1188
ADDP4
CNSTI1 0
ASGNI1
line 160
;160:	trap_FS_FCloseFile(file);
ADDRLP4 1184
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 162
;161:
;162:	if (!BG_ParseMonsterConfig(
ADDRLP4 1188
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 9380
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 9644
ADDRGP4 BG_ParseMonsterConfig
CALLI4
ASGNI4
ADDRLP4 9644
INDIRI4
CNSTI4 0
NEI4 $92
line 167
;163:		text,
;164:		&def,
;165:		error,
;166:		sizeof(error)
;167:	)) {
line 168
;168:		G_Printf(
ADDRGP4 $94
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 9380
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 173
;169:			S_COLOR_RED "Monster config error in %s: %s\n",
;170:			filename,
;171:			error
;172:		);
;173:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $92
line 176
;174:	}
;175:
;176:	if (def.monsterType <= MONSTER_TYPE_OFF ||
ADDRLP4 0+576
INDIRI4
CNSTI4 0
LEI4 $99
ADDRLP4 0+576
INDIRI4
CNSTI4 6
LTI4 $95
LABELV $99
line 177
;177:		def.monsterType >= MONSTER_TYPE_RANDOM) {
line 178
;178:		G_Printf(
ADDRGP4 $100
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 182
;179:			S_COLOR_RED "Invalid monster type in %s\n",
;180:			filename
;181:		);
;182:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $95
line 185
;183:	}
;184:
;185:	if (def.monsterSlot < 0 ||
ADDRLP4 0+580
INDIRI4
CNSTI4 0
LTI4 $105
ADDRLP4 0+580
INDIRI4
CNSTI4 5
LTI4 $101
LABELV $105
line 186
;186:		def.monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 187
;187:		G_Printf(
ADDRGP4 $106
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 191
;188:			S_COLOR_RED "Invalid monster slot in %s\n",
;189:			filename
;190:		);
;191:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $84
JUMPV
LABELV $101
line 194
;192:	}
;193:
;194:	g_monsterDefs[def.monsterType][def.monsterSlot] = def;
CNSTI4 1180
ADDRLP4 0+580
INDIRI4
MULI4
CNSTI4 5900
ADDRLP4 0+576
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ADDRLP4 0
INDIRB
ASGNB 1180
line 195
;195:	g_monsterDefLoaded[def.monsterType][def.monsterSlot] = qtrue;
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
line 197
;196:
;197:	G_Printf(
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
line 205
;198:		S_COLOR_GREEN
;199:		"Loaded monster: %s, type %i, slot %i\n",
;200:		def.name,
;201:		def.monsterType,
;202:		def.monsterSlot
;203:	);
;204:
;205:	return qtrue;
CNSTI4 1
RETI4
LABELV $84
endproc G_LoadMonsterConfig 9648 16
proc G_MonsterWaveReadInt 12 4
line 212
;206:}
;207:
;208:
;209:static qboolean G_MonsterWaveReadInt(
;210:	char **text,
;211:	int *value
;212:) {
line 215
;213:	char *token;
;214:
;215:	token = COM_Parse(text);
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
line 217
;216:
;217:	if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $115
line 218
;218:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $114
JUMPV
LABELV $115
line 221
;219:	}
;220:
;221:	*value = atoi(token);
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
line 222
;222:	return qtrue;
CNSTI4 1
RETI4
LABELV $114
endproc G_MonsterWaveReadInt 12 4
proc G_MonsterWaveFindDefinition 12 8
line 229
;223:}
;224:
;225:static qboolean G_MonsterWaveFindDefinition(
;226:	const char *name,
;227:	int *monsterType,
;228:	int *monsterSlot
;229:) {
line 233
;230:	int type;
;231:	int slot;
;232:
;233:	for( type = MONSTER_TYPE_OFF + 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
LABELV $118
line 235
;234:		type < MONSTER_TYPE_RANDOM;
;235:		type++ ) {
line 236
;236:		for( slot = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $122
line 238
;237:			slot < MAX_MONSTERS_PER_TYPE;
;238:			slot++ ) {
line 239
;239:			if( !g_monsterDefLoaded[type][slot] ) {
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
line 240
;240:				continue;
ADDRGP4 $123
JUMPV
LABELV $126
line 243
;241:			}
;242:
;243:			if( !Q_stricmp(
CNSTI4 1180
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 5900
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
line 246
;244:				g_monsterDefs[type][slot].name,
;245:				name
;246:			) ) {
line 247
;247:				*monsterType = type;
ADDRFP4 4
INDIRP4
ADDRLP4 4
INDIRI4
ASGNI4
line 248
;248:				*monsterSlot = slot;
ADDRFP4 8
INDIRP4
ADDRLP4 0
INDIRI4
ASGNI4
line 249
;249:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $117
JUMPV
LABELV $128
line 251
;250:			}
;251:		}
LABELV $123
line 238
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 237
ADDRLP4 0
INDIRI4
CNSTI4 5
LTI4 $122
line 252
;252:	}
LABELV $119
line 235
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 234
ADDRLP4 4
INDIRI4
CNSTI4 6
LTI4 $118
line 254
;253:
;254:	return qfalse;
CNSTI4 0
RETI4
LABELV $117
endproc G_MonsterWaveFindDefinition 12 8
proc G_MonsterWaveParseWave 124 12
line 260
;255:}
;256:
;257:static qboolean G_MonsterWaveParseWave(
;258:	char **text,
;259:	int waveNumber
;260:) {
line 264
;261:	monsterWaveDef_t *wave;
;262:	char *token;
;263:
;264:	if( waveNumber < 1 ||
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
line 265
;265:		waveNumber > MAX_MONSTER_WAVES ) {
line 266
;266:		G_Printf(
ADDRGP4 $134
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 271
;267:			S_COLOR_RED
;268:			"Monster waves: invalid wave %i\n",
;269:			waveNumber
;270:		);
;271:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $131
line 274
;272:	}
;273:
;274:	wave = &monsterWaves[waveNumber - 1];
ADDRLP4 4
CNSTI4 108
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 monsterWaves-108
ADDP4
ASGNP4
line 276
;275:
;276:	token = COM_Parse(text);
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
line 278
;277:
;278:	if( Q_stricmp(token, "{") ) {
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
line 279
;279:		G_Printf(
ADDRGP4 $139
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 284
;280:			S_COLOR_RED
;281:			"Monster waves: expected { after wave %i\n",
;282:			waveNumber
;283:		);
;284:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $140
line 287
;285:	}
;286:
;287:	while( 1 ) {
line 288
;288:		token = COM_Parse(text);
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
line 290
;289:
;290:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $143
line 291
;291:			G_Printf(
ADDRGP4 $145
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 296
;292:				S_COLOR_RED
;293:				"Monster waves: unexpected end of wave %i\n",
;294:				waveNumber
;295:			);
;296:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $143
line 299
;297:		}
;298:
;299:		if( !Q_stricmp(token, "}") ) {
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
line 300
;300:			break;
ADDRGP4 $142
JUMPV
LABELV $146
line 303
;301:		}
;302:
;303:		if( !Q_stricmp(token, "monster") ) {
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
line 307
;304:			monsterWaveEntry_t *entry;
;305:			char monsterName[MAX_QPATH];
;306:
;307:			if( wave->numEntries >=
ADDRLP4 4
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
CNSTI4 8
LTI4 $152
line 308
;308:				MAX_MONSTERS_IN_WAVE ) {
line 309
;309:				G_Printf(
ADDRGP4 $154
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 314
;310:					S_COLOR_RED
;311:					"Monster waves: too many entries in wave %i\n",
;312:					waveNumber
;313:				);
;314:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $152
line 317
;315:			}
;316:
;317:			token = COM_Parse(text);
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
line 319
;318:
;319:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $155
line 320
;320:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $155
line 323
;321:			}
;322:
;323:			Q_strncpyz(
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
line 329
;324:				monsterName,
;325:				token,
;326:				sizeof(monsterName)
;327:			);
;328:
;329:			entry =
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
line 332
;330:				&wave->entries[wave->numEntries];
;331:
;332:			if( !G_MonsterWaveFindDefinition(
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
line 336
;333:				monsterName,
;334:				&entry->monsterType,
;335:				&entry->monsterSlot
;336:			) ) {
line 337
;337:				G_Printf(
ADDRGP4 $159
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 342
;338:					S_COLOR_RED
;339:					"Monster waves: unknown monster %s\n",
;340:					monsterName
;341:				);
;342:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $157
line 345
;343:			}
;344:
;345:			if( !G_MonsterWaveReadInt(
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
line 348
;346:				text,
;347:				&entry->count
;348:			) ) {
line 349
;349:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $160
line 352
;350:			}
;351:
;352:			if( entry->count < 1 ) {
ADDRLP4 32
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 1
GEI4 $162
line 353
;353:				G_Printf(
ADDRGP4 $164
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 358
;354:					S_COLOR_RED
;355:					"Monster waves: invalid count for %s\n",
;356:					monsterName
;357:				);
;358:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $162
line 361
;359:			}
;360:
;361:			wave->numEntries++;
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
line 362
;362:			continue;
ADDRGP4 $141
JUMPV
LABELV $149
line 365
;363:		}
;364:
;365:		if( !Q_stricmp(token, "repeat") ) {
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
line 366
;366:			token = COM_Parse(text);
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
line 368
;367:
;368:			if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $168
line 369
;369:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $168
line 372
;370:			}
;371:
;372:			wave->repeat =
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
line 376
;373:				!Q_stricmp(token, "true") ||
;374:				atoi(token) != 0;
;375:
;376:			continue;
ADDRGP4 $141
JUMPV
LABELV $165
line 379
;377:		}
;378:
;379:	if( !Q_stricmp(token, "maxActive") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $177
ARGP4
ADDRLP4 36
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $175
line 380
;380:				if( !G_MonsterWaveReadInt(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
ARGP4
ADDRLP4 40
ADDRGP4 G_MonsterWaveReadInt
CALLI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
NEI4 $178
line 383
;381:					text,
;382:					&wave->maxActive
;383:				) ) {
line 384
;384:					return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $178
line 387
;385:				}
;386:
;387:				if( wave->maxActive < 0 ) {
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
CNSTI4 0
GEI4 $180
line 388
;388:					wave->maxActive = 0;
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
CNSTI4 0
ASGNI4
line 389
;389:				}
ADDRGP4 $141
JUMPV
LABELV $180
line 390
;390:				else if( wave->maxActive > 64 ) {
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
CNSTI4 64
LEI4 $141
line 391
;391:					wave->maxActive = 64;
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
CNSTI4 64
ASGNI4
line 392
;392:				}
line 394
;393:
;394:				continue;
ADDRGP4 $141
JUMPV
LABELV $175
line 397
;395:			}
;396:
;397:		G_Printf(
ADDRGP4 $184
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
line 403
;398:			S_COLOR_RED
;399:			"Monster waves: unknown key %s in wave %i\n",
;400:			token,
;401:			waveNumber
;402:		);
;403:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $141
line 287
ADDRGP4 $140
JUMPV
LABELV $142
line 406
;404:	}
;405:
;406:	return qtrue;
CNSTI4 1
RETI4
LABELV $130
endproc G_MonsterWaveParseWave 124 12
proc G_LoadMonsterWaveConfig 8260 16
line 411
;407:}
;408:
;409:static qboolean G_LoadMonsterWaveConfig(
;410:	const char *filename
;411:) {
line 420
;412:	fileHandle_t file;
;413:	char buffer[MAX_MONSTER_WAVE_TEXT];
;414:	char *text;
;415:	char *token;
;416:	int length;
;417:	int value;
;418:	int i;
;419:
;420:	memset(
ADDRGP4 monsterWaves
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3456
ARGI4
ADDRGP4 memset
CALLP4
pop
line 430
;421:		monsterWaves,
;422:		0,
;423:		sizeof(monsterWaves)
;424:	);
;425:
;426:	/*
;427:	 * Default values used when a key is absent
;428:	 * from monsterwaves.cfg.
;429:	 */
;430:	monsterWaveDelay = 5000;
ADDRGP4 monsterWaveDelay
CNSTI4 5000
ASGNI4
line 431
;431:	monsterWaveSpawnInterval = 750;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 750
ASGNI4
line 432
;432:	monsterWaveTimeout = 30000;
ADDRGP4 monsterWaveTimeout
CNSTI4 30000
ASGNI4
line 433
;433:	monsterWaveMaxActive = 8;
ADDRGP4 monsterWaveMaxActive
CNSTI4 8
ASGNI4
line 434
;434:	monsterWaveFinal = DEFAULT_MONSTER_WAVES;
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 436
;435:
;436:	length = trap_FS_FOpenFile(
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
line 442
;437:		filename,
;438:		&file,
;439:		FS_READ
;440:	);
;441:
;442:	if( !file ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $186
line 443
;443:		G_Printf(
ADDRGP4 $188
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 448
;444:			S_COLOR_RED
;445:			"Monster wave config not found: %s\n",
;446:			filename
;447:		);
;448:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
LABELV $186
line 451
;449:	}
;450:
;451:	if( length <= 0 ||
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $191
ADDRLP4 16
INDIRI4
CVIU4 4
CNSTU4 8192
LTU4 $189
LABELV $191
line 452
;452:		length >= sizeof(buffer) ) {
line 453
;453:		G_Printf(
ADDRGP4 $192
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 459
;454:			S_COLOR_RED
;455:			"Invalid monster wave config size: %s\n",
;456:			filename
;457:		);
;458:
;459:		trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 460
;460:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
LABELV $189
line 463
;461:	}
;462:
;463:	trap_FS_Read(buffer, length, file);
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
line 464
;464:	buffer[length] = '\0';
ADDRLP4 16
INDIRI4
ADDRLP4 24
ADDP4
CNSTI1 0
ASGNI1
line 465
;465:	trap_FS_FCloseFile(file);
ADDRLP4 20
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 467
;466:
;467:	text = buffer;
ADDRLP4 4
ADDRLP4 24
ASGNP4
ADDRGP4 $194
JUMPV
LABELV $193
line 469
;468:
;469:	while( 1 ) {
line 470
;470:		token = COM_Parse(&text);
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
line 472
;471:
;472:		if( !token[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $196
line 473
;473:			break;
ADDRGP4 $195
JUMPV
LABELV $196
line 476
;474:		}
;475:
;476:		if( !Q_stricmp(token, "waveDelay") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $200
ARGP4
ADDRLP4 8228
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8228
INDIRI4
CNSTI4 0
NEI4 $198
line 477
;477:			if( !G_MonsterWaveReadInt(
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
NEI4 $194
line 480
;478:				&text,
;479:				&monsterWaveDelay
;480:			) ) {
line 481
;481:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
line 484
;482:			}
;483:
;484:			continue;
LABELV $198
line 487
;485:		}
;486:
;487:		if( !Q_stricmp(token, "spawnInterval") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $205
ARGP4
ADDRLP4 8232
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8232
INDIRI4
CNSTI4 0
NEI4 $203
line 488
;488:			if( !G_MonsterWaveReadInt(
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
NEI4 $194
line 491
;489:				&text,
;490:				&monsterWaveSpawnInterval
;491:			) ) {
line 492
;492:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
line 495
;493:			}
;494:
;495:			continue;
LABELV $203
line 498
;496:		}
;497:
;498:		if( !Q_stricmp(token, "waveTimeout") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $210
ARGP4
ADDRLP4 8236
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8236
INDIRI4
CNSTI4 0
NEI4 $208
line 499
;499:			if( !G_MonsterWaveReadInt(
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
NEI4 $194
line 502
;500:				&text,
;501:				&monsterWaveTimeout
;502:			) ) {
line 503
;503:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
line 506
;504:			}
;505:
;506:			continue;
LABELV $208
line 509
;507:		}
;508:
;509:		if( !Q_stricmp(token, "maxActive") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $177
ARGP4
ADDRLP4 8240
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8240
INDIRI4
CNSTI4 0
NEI4 $213
line 510
;510:			if( !G_MonsterWaveReadInt(
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
NEI4 $194
line 513
;511:				&text,
;512:				&monsterWaveMaxActive
;513:			) ) {
line 514
;514:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
line 517
;515:			}
;516:
;517:			continue;
LABELV $213
line 520
;518:		}
;519:
;520:		if( !Q_stricmp(token, "finalWave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $219
ARGP4
ADDRLP4 8244
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8244
INDIRI4
CNSTI4 0
NEI4 $217
line 521
;521:			if( !G_MonsterWaveReadInt(
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
NEI4 $194
line 524
;522:				&text,
;523:				&monsterWaveFinal
;524:			) ) {
line 525
;525:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
line 528
;526:			}
;527:
;528:			continue;
LABELV $217
line 531
;529:		}
;530:
;531:		if( !Q_stricmp(token, "wave") ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $224
ARGP4
ADDRLP4 8248
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8248
INDIRI4
CNSTI4 0
NEI4 $222
line 532
;532:			if( !G_MonsterWaveReadInt(
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
NEI4 $225
line 535
;533:				&text,
;534:				&value
;535:			) ) {
line 536
;536:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
LABELV $225
line 539
;537:			}
;538:
;539:			if( !G_MonsterWaveParseWave(
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
NEI4 $194
line 542
;540:				&text,
;541:				value
;542:			) ) {
line 543
;543:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
line 546
;544:			}
;545:
;546:			continue;
LABELV $222
line 549
;547:		}
;548:
;549:		G_Printf(
ADDRGP4 $229
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 555
;550:			S_COLOR_RED
;551:			"Monster waves: unknown key %s\n",
;552:			token
;553:		);
;554:
;555:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
LABELV $194
line 469
ADDRGP4 $193
JUMPV
LABELV $195
line 561
;556:	}
;557:
;558:	/*
;559:	 * Sanitize timing and entity limits.
;560:	 */
;561:	if( monsterWaveDelay < 0 ) {
ADDRGP4 monsterWaveDelay
INDIRI4
CNSTI4 0
GEI4 $230
line 562
;562:		monsterWaveDelay = 0;
ADDRGP4 monsterWaveDelay
CNSTI4 0
ASGNI4
line 563
;563:	}
LABELV $230
line 565
;564:
;565:	if( monsterWaveSpawnInterval < 100 ) {
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
CNSTI4 100
GEI4 $232
line 566
;566:		monsterWaveSpawnInterval = 100;
ADDRGP4 monsterWaveSpawnInterval
CNSTI4 100
ASGNI4
line 567
;567:	}
LABELV $232
line 569
;568:
;569:	if( monsterWaveTimeout < 5000 ) {
ADDRGP4 monsterWaveTimeout
INDIRI4
CNSTI4 5000
GEI4 $234
line 570
;570:		monsterWaveTimeout = 5000;
ADDRGP4 monsterWaveTimeout
CNSTI4 5000
ASGNI4
line 571
;571:	}
LABELV $234
line 573
;572:
;573:	if( monsterWaveMaxActive < 1 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 1
GEI4 $236
line 574
;574:		monsterWaveMaxActive = 1;
ADDRGP4 monsterWaveMaxActive
CNSTI4 1
ASGNI4
line 575
;575:	}
ADDRGP4 $237
JUMPV
LABELV $236
line 576
;576:	else if( monsterWaveMaxActive > 64 ) {
ADDRGP4 monsterWaveMaxActive
INDIRI4
CNSTI4 64
LEI4 $238
line 577
;577:		monsterWaveMaxActive = 64;
ADDRGP4 monsterWaveMaxActive
CNSTI4 64
ASGNI4
line 578
;578:	}
LABELV $238
LABELV $237
line 580
;579:
;580:	if( monsterWaveFinal < 1 ||
ADDRLP4 8224
ADDRGP4 monsterWaveFinal
INDIRI4
ASGNI4
ADDRLP4 8224
INDIRI4
CNSTI4 1
LTI4 $242
ADDRLP4 8224
INDIRI4
CNSTI4 32
LEI4 $240
LABELV $242
line 582
;581:		monsterWaveFinal >
;582:			MAX_MONSTER_WAVES ) {
line 583
;583:		monsterWaveFinal =
ADDRGP4 monsterWaveFinal
CNSTI4 5
ASGNI4
line 585
;584:			DEFAULT_MONSTER_WAVES;
;585:	}
LABELV $240
line 591
;586:
;587:	/*
;588:	 * Every enabled wave must contain at least
;589:	 * one monster definition.
;590:	 */
;591:	for( i = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $246
JUMPV
LABELV $243
line 593
;592:		i < monsterWaveFinal;
;593:		i++ ) {
line 594
;594:		if( monsterWaves[i].numEntries == 0 ) {
CNSTI4 108
ADDRLP4 8
INDIRI4
MULI4
ADDRGP4 monsterWaves+96
ADDP4
INDIRI4
CNSTI4 0
NEI4 $247
line 595
;595:			G_Printf(
ADDRGP4 $250
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 601
;596:				S_COLOR_RED
;597:				"Monster waves: wave %i is empty\n",
;598:				i + 1
;599:			);
;600:
;601:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $185
JUMPV
LABELV $247
line 603
;602:		}
;603:	}
LABELV $244
line 593
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $246
line 592
ADDRLP4 8
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
LTI4 $243
line 605
;604:
;605:	G_Printf(
ADDRGP4 $251
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
line 614
;606:		S_COLOR_GREEN
;607:		"Loaded monsterwaves.cfg: %i waves, "
;608:		"max %i active, timeout %i ms\n",
;609:		monsterWaveFinal,
;610:		monsterWaveMaxActive,
;611:		monsterWaveTimeout
;612:	);
;613:
;614:	return qtrue;
CNSTI4 1
RETI4
LABELV $185
endproc G_LoadMonsterWaveConfig 8260 16
export G_MonsterInitDefinitions
proc G_MonsterInitDefinitions 8 12
line 618
;615:}
;616:
;617:
;618:void G_MonsterInitDefinitions(void) {
line 621
;619:	int i;
;620:	
;621:	monsterItemCounter = 0;
ADDRGP4 monsterItemCounter
CNSTI4 0
ASGNI4
line 622
;622:	monsterActiveCount = 0;
ADDRGP4 monsterActiveCount
CNSTI4 0
ASGNI4
line 624
;623:	
;624:	monsterCurrentWave = 0;
ADDRGP4 monsterCurrentWave
CNSTI4 0
ASGNI4
line 625
;625:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 626
;626:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 627
;627:	monsterWaveNextSpawn = 0;
ADDRGP4 monsterWaveNextSpawn
CNSTI4 0
ASGNI4
line 628
;628:	monsterWaveNextStart = 0;
ADDRGP4 monsterWaveNextStart
CNSTI4 0
ASGNI4
line 629
;629:	monsterWaveLastProgress = 0;
ADDRGP4 monsterWaveLastProgress
CNSTI4 0
ASGNI4
line 631
;630:
;631:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 632
;632:	monsterWaveStarted = qfalse;
ADDRGP4 monsterWaveStarted
CNSTI4 0
ASGNI4
line 633
;633:	monsterWaveCombatStarted = qfalse;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 0
ASGNI4
line 634
;634:	monsterWaveFinished = qfalse;
ADDRGP4 monsterWaveFinished
CNSTI4 0
ASGNI4
line 636
;635:
;636:	memset(g_monsterDefs, 0, sizeof(g_monsterDefs));
ADDRGP4 g_monsterDefs
ARGP4
CNSTI4 0
ARGI4
CNSTI4 35400
ARGI4
ADDRGP4 memset
CALLP4
pop
line 637
;637:	memset(g_monsterDefLoaded, 0, sizeof(g_monsterDefLoaded));
ADDRGP4 g_monsterDefLoaded
ARGP4
CNSTI4 0
ARGI4
CNSTI4 120
ARGI4
ADDRGP4 memset
CALLP4
pop
line 639
;638:
;639:	for (i = 0; monsterConfigFiles[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $256
JUMPV
LABELV $253
line 640
;640:		G_LoadMonsterConfig(monsterConfigFiles[i]);
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
line 641
;641:	}
LABELV $254
line 639
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $256
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 monsterConfigFiles
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $253
line 643
;642:	
;643:	monsterWavesLoaded = qfalse;
ADDRGP4 monsterWavesLoaded
CNSTI4 0
ASGNI4
line 648
;644:
;645:	/*
;646:	 * Both Monster Hunt modes use monsterwaves.cfg.
;647:	 */
;648:	if( g_monsterHunt.integer !=
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $257
line 649
;649:		MONSTER_HUNT_OFF ) {
line 650
;650:		monsterWavesLoaded =
ADDRGP4 $260
ARGP4
ADDRLP4 4
ADDRGP4 G_LoadMonsterWaveConfig
CALLI4
ASGNI4
ADDRGP4 monsterWavesLoaded
ADDRLP4 4
INDIRI4
ASGNI4
line 654
;651:			G_LoadMonsterWaveConfig(
;652:				"monsterwaves.cfg"
;653:			);
;654:	}
LABELV $257
line 655
;655:}
LABELV $252
endproc G_MonsterInitDefinitions 8 12
proc G_MonsterEligibleItem 24 0
line 657
;656:
;657:static qboolean G_MonsterEligibleItem(gentity_t *item) {
line 658
;658:	if (!item || !item->item) {
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
EQU4 $264
ADDRLP4 0
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $262
LABELV $264
line 659
;659:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $261
JUMPV
LABELV $262
line 662
;660:	}
;661:
;662:	if (item->flags & FL_DROPPED_ITEM) {
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $265
line 663
;663:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $261
JUMPV
LABELV $265
line 666
;664:	}
;665:
;666:	if (item->team || item->targetname || item->wait == -1) {
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
NEU4 $270
ADDRLP4 8
INDIRP4
CNSTI4 652
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 12
INDIRU4
NEU4 $270
ADDRLP4 8
INDIRP4
CNSTI4 796
ADDP4
INDIRF4
CNSTF4 3212836864
NEF4 $267
LABELV $270
line 667
;667:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $261
JUMPV
LABELV $267
line 670
;668:	}
;669:
;670:	switch (item->item->giType) {
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
LTI4 $271
ADDRLP4 16
INDIRI4
CNSTI4 5
GTI4 $271
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $275-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $275
address $274
address $274
address $274
address $274
address $274
code
LABELV $274
line 676
;671:	case IT_WEAPON:
;672:	case IT_AMMO:
;673:	case IT_ARMOR:
;674:	case IT_HEALTH:
;675:	case IT_POWERUP:
;676:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $261
JUMPV
LABELV $271
line 679
;677:
;678:	default:
;679:		return qfalse;
CNSTI4 0
RETI4
LABELV $261
endproc G_MonsterEligibleItem 24 0
proc G_MonsterSetOrigin 0 8
line 686
;680:	}
;681:}
;682:
;683:static void G_MonsterSetOrigin(
;684:	gentity_t *monster,
;685:	const vec3_t origin
;686:) {
line 687
;687:	G_SetOrigin(monster, (float *)origin);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 693
;688:
;689:	/*
;690:	 * The client interpolates monsters between snapshots.
;691:	 * G_SetOrigin resets trType to TR_STATIONARY.
;692:	 */
;693:	monster->s.pos.trType = TR_INTERPOLATE;
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 694
;694:	monster->s.pos.trTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 695
;695:}
LABELV $277
endproc G_MonsterSetOrigin 0 8
proc G_MonsterSpawnAtOrigin 48 12
line 702
;696:
;697:static qboolean G_MonsterSpawnAtOrigin(
;698:	gentity_t *item,
;699:	monsterDef_t *def,
;700:	vec3_t spawnOrigin,
;701:	qboolean waveSpawn
;702:) {
line 711
;703:	gentity_t *monster;
;704:	vec3_t origin;
;705:
;706:	/*
;707:	 * Wave limit is enforced by G_MonsterRunFrame
;708:	 * via wave->maxActive (per-wave) or the global
;709:	 * monsterWaveMaxActive fallback.
;710:	 */
;711:	if( !waveSpawn && monsterActiveCount >= 8 ) {
ADDRFP4 12
INDIRI4
CNSTI4 0
NEI4 $280
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $280
line 712
;712:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $279
JUMPV
LABELV $280
line 715
;713:	}
;714:
;715:	if( !def ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $282
line 716
;716:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $279
JUMPV
LABELV $282
line 719
;717:	}
;718:
;719:	monster = G_Spawn();
ADDRLP4 16
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16
INDIRP4
ASGNP4
line 721
;720:
;721:	monster->classname = "monster";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $151
ASGNP4
line 722
;722:	monster->s.eType = ET_MONSTER;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 13
ASGNI4
line 724
;723:
;724:	if( def->models[0][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $284
line 725
;725:		monster->s.modelindex =
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
line 727
;726:			G_ModelIndex(def->models[0]);
;727:	}
LABELV $284
line 729
;728:
;729:	if( def->models[1][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $286
line 730
;730:		monster->s.modelindex2 =
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
line 732
;731:			G_ModelIndex(def->models[1]);
;732:	}
LABELV $286
line 734
;733:
;734:	if( def->models[2][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $288
line 735
;735:		monster->s.otherEntityNum =
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
line 737
;736:			G_ModelIndex(def->models[2]);
;737:	}
LABELV $288
line 739
;738:
;739:	if( def->models[3][0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 256
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $290
line 740
;740:		monster->s.otherEntityNum2 =
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
line 742
;741:			G_ModelIndex(def->models[3]);
;742:	}
LABELV $290
line 744
;743:
;744:	monster->s.frame =
ADDRLP4 0
INDIRP4
CNSTI4 172
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 816
ADDP4
INDIRI4
ASGNI4
line 747
;745:		def->moveAnimation.firstFrame;
;746:
;747:	monster->s.groundEntityNum =
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 750
;748:		ENTITYNUM_NONE;
;749:
;750:	monster->s.apos.trType =
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 753
;751:		TR_STATIONARY;
;752:
;753:	monster->monsterType =
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
line 756
;754:		def->monsterType;
;755:
;756:	monster->monsterSlot =
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
line 764
;757:		def->monsterSlot;
;758:		
;759:	/*
;760:	 * Send monster definition identity to cgame.
;761:	 * Packed into a single byte: type * MAX_MONSTERS_PER_TYPE + slot.
;762:	 * (entityState generic1 is only 8 bits on the network.)
;763:	 */
;764:	monster->s.generic1 =
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 204
ADDP4
CNSTI4 5
ADDRLP4 20
INDIRP4
CNSTI4 576
ADDP4
INDIRI4
MULI4
ADDRLP4 20
INDIRP4
CNSTI4 580
ADDP4
INDIRI4
ADDI4
ASGNI4
line 768
;765:		def->monsterType * MAX_MONSTERS_PER_TYPE +
;766:		def->monsterSlot;	
;767:
;768:	monster->monsterItem = item;
ADDRLP4 0
INDIRP4
CNSTI4 868
ADDP4
ADDRFP4 0
INDIRP4
ASGNP4
line 769
;769:	monster->monsterWaveSpawn = waveSpawn;
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
ADDRFP4 12
INDIRI4
ASGNI4
line 770
;770:	monster->monsterDead = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 0
ASGNI4
line 772
;771:
;772:	monster->health = def->health;
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
line 773
;773:	monster->takedamage = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 1
ASGNI4
line 774
;774:	monster->pain = G_MonsterPain;
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
ADDRGP4 G_MonsterPain
ASGNP4
line 775
;775:	monster->die = G_MonsterDie;
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ADDRGP4 G_MonsterDie
ASGNP4
line 777
;776:
;777:	monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 780
;778:		level.time + 500;
;779:
;780:	monster->monsterNextShot = 0;
ADDRLP4 0
INDIRP4
CNSTI4 876
ADDP4
CNSTI4 0
ASGNI4
line 781
;781:	monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 783
;782:
;783:	G_MonsterSetAnimation(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 G_MonsterSetAnimation
CALLV
pop
line 789
;784:		monster,
;785:		MONSTER_STATE_IDLE,
;786:		0
;787:	);
;788:
;789:	monster->monsterNextTalk =
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 G_MonsterTalkDelay
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 856
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRLP4 28
INDIRI4
ADDI4
ASGNI4
line 793
;790:		level.time +
;791:		G_MonsterTalkDelay(def);
;792:
;793:	VectorCopy(
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
line 798
;794:		def->mins,
;795:		monster->r.mins
;796:	);
;797:
;798:	VectorCopy(
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
line 803
;799:		def->maxs,
;800:		monster->r.maxs
;801:	);
;802:
;803:	monster->r.contents = CONTENTS_BODY;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 33554432
ASGNI4
line 804
;804:	monster->clipmask = MASK_PLAYERSOLID;
ADDRLP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 33619969
ASGNI4
line 806
;805:
;806:	VectorCopy(spawnOrigin, origin);
ADDRLP4 4
ADDRFP4 8
INDIRP4
INDIRB
ASGNB 12
line 807
;807:	origin[2] += def->hoverHeight;
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
line 809
;808:
;809:	G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 814
;810:		monster,
;811:		origin
;812:	);
;813:	
;814:	monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 817
;815:	level.time;
;816:
;817:	VectorCopy(
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
line 822
;818:		monster->r.currentOrigin,
;819:		monster->monsterProgressOrigin
;820:	);
;821:
;822:	monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 825
;823:		level.time;
;824:
;825:	monster->monsterDriftPhase =
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
line 828
;826:		monster->s.number * 0.73f;
;827:
;828:	monster->think = G_MonsterThink;
ADDRLP4 0
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterThink
ASGNP4
line 829
;829:	monster->nextthink = level.time + 50;
ADDRLP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 831
;830:
;831:	trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 837
;832:
;833:	/*
;834:	 * Classic Monster Hunt replaces and hides a map item.
;835:	 * Wave monsters are independent from map items.
;836:	 */
;837:	if( item && !waveSpawn ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $298
ADDRFP4 12
INDIRI4
CNSTI4 0
NEI4 $298
line 838
;838:		item->monsterType =
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
line 841
;839:			def->monsterType;
;840:
;841:		item->monsterSlot =
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
line 844
;842:			def->monsterSlot;
;843:
;844:		item->s.eFlags |= EF_NODRAW;
ADDRLP4 40
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 845
;845:		item->r.svFlags |= SVF_NOCLIENT;
ADDRLP4 44
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 846
;846:		item->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 847
;847:		item->touch = 0;
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
CNSTP4 0
ASGNP4
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
line 851
;850:
;851:		trap_UnlinkEntity(item);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
line 852
;852:	}
LABELV $298
line 854
;853:
;854:	monsterActiveCount++;
ADDRLP4 40
ADDRGP4 monsterActiveCount
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 863
;855:
;856:/*	G_Printf(
;857:		"Spawned %smonster %s at %s\n",
;858:		waveSpawn ? "wave " : "",
;859:		def->name,
;860:		vtos(origin)
;861:	);*/
;862:
;863:	return qtrue;
CNSTI4 1
RETI4
LABELV $279
endproc G_MonsterSpawnAtOrigin 48 12
proc G_MonsterSpawnFromItem 12 16
line 869
;864:}
;865:
;866:static qboolean G_MonsterSpawnFromItem(
;867:	gentity_t *item,
;868:	monsterDef_t *def
;869:) {
line 870
;870:	if( !item || !def ) {
ADDRLP4 0
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
EQU4 $303
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRU4
NEU4 $301
LABELV $303
line 871
;871:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $300
JUMPV
LABELV $301
line 874
;872:	}
;873:
;874:	return G_MonsterSpawnAtOrigin(
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
LABELV $300
endproc G_MonsterSpawnFromItem 12 16
proc G_MonsterRespawnThink 32 8
line 882
;875:		item,
;876:		def,
;877:		item->s.pos.trBase,
;878:		qfalse
;879:	);
;880:}
;881:
;882:static void G_MonsterRespawnThink(gentity_t *item) {
line 885
;883:	monsterDef_t *def;
;884:
;885:	if (item->monsterType <= MONSTER_TYPE_OFF ||
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
LEI4 $309
ADDRLP4 8
INDIRI4
CNSTI4 6
GEI4 $309
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
LTI4 $309
ADDRLP4 16
INDIRI4
CNSTI4 5
LTI4 $305
LABELV $309
line 888
;886:		item->monsterType >= MONSTER_TYPE_RANDOM ||
;887:		item->monsterSlot < 0 ||
;888:		item->monsterSlot >= MAX_MONSTERS_PER_TYPE) {
line 889
;889:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 890
;890:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 891
;891:		return;
ADDRGP4 $304
JUMPV
LABELV $305
line 894
;892:	}
;893:
;894:	if (!g_monsterDefLoaded
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
NEI4 $310
line 896
;895:		[item->monsterType]
;896:		[item->monsterSlot]) {
line 897
;897:		item->think = 0;
ADDRFP4 0
INDIRP4
CNSTI4 692
ADDP4
CNSTP4 0
ASGNP4
line 898
;898:		item->nextthink = 0;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
CNSTI4 0
ASGNI4
line 899
;899:		return;
ADDRGP4 $304
JUMPV
LABELV $310
line 902
;900:	}
;901:
;902:	if (monsterActiveCount >= 8) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 8
LTI4 $312
line 903
;903:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 904
;904:		return;
ADDRGP4 $304
JUMPV
LABELV $312
line 907
;905:	}
;906:
;907:	def = &g_monsterDefs
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1180
ADDRLP4 24
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5900
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
line 911
;908:		[item->monsterType]
;909:		[item->monsterSlot];
;910:
;911:	if (!G_MonsterSpawnFromItem(item, def)) {
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
NEI4 $315
line 912
;912:		item->nextthink = level.time + 1000;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 913
;913:	}
LABELV $315
line 914
;914:}
LABELV $304
endproc G_MonsterRespawnThink 32 8
proc G_MonsterWaveHasPlayers 8 0
line 916
;915:
;916:static qboolean G_MonsterWaveHasPlayers( void ) {
line 920
;917:	gclient_t *client;
;918:	int i;
;919:
;920:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $322
JUMPV
LABELV $319
line 921
;921:		client = &level.clients[i];
ADDRLP4 0
CNSTI4 780
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
ASGNP4
line 923
;922:
;923:		if( client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $324
line 924
;924:			CON_CONNECTED ) {
line 925
;925:			continue;
ADDRGP4 $320
JUMPV
LABELV $324
line 928
;926:		}
;927:
;928:		if( client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $326
line 929
;929:			TEAM_SPECTATOR ) {
line 930
;930:			continue;
ADDRGP4 $320
JUMPV
LABELV $326
line 933
;931:		}
;932:
;933:		if( client->oneLifeEliminated ) {
ADDRLP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRI4
CNSTI4 0
EQI4 $328
line 934
;934:			continue;
ADDRGP4 $320
JUMPV
LABELV $328
line 937
;935:		}
;936:
;937:		if( client->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $330
line 938
;938:			continue;
ADDRGP4 $320
JUMPV
LABELV $330
line 941
;939:		}
;940:
;941:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $318
JUMPV
LABELV $320
line 920
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $322
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $319
line 944
;942:	}
;943:
;944:	return qfalse;
CNSTI4 0
RETI4
LABELV $318
endproc G_MonsterWaveHasPlayers 8 0
proc G_MonsterWaveLivingCount 12 0
line 947
;945:}
;946:
;947:static int G_MonsterWaveLivingCount( void ) {
line 952
;948:	gentity_t *ent;
;949:	int count;
;950:	int i;
;951:
;952:	count = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 954
;953:
;954:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $336
JUMPV
LABELV $333
line 956
;955:		i < level.num_entities;
;956:		i++ ) {
line 957
;957:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 959
;958:
;959:		if( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $338
line 960
;960:			continue;
ADDRGP4 $334
JUMPV
LABELV $338
line 963
;961:		}
;962:
;963:		if( ent->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $340
line 964
;964:			continue;
ADDRGP4 $334
JUMPV
LABELV $340
line 967
;965:		}
;966:
;967:		if( !ent->monsterWaveSpawn ) {
ADDRLP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
NEI4 $342
line 968
;968:			continue;
ADDRGP4 $334
JUMPV
LABELV $342
line 971
;969:		}
;970:
;971:		if( ent->monsterDead ) {
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $344
line 972
;972:			continue;
ADDRGP4 $334
JUMPV
LABELV $344
line 975
;973:		}
;974:
;975:		count++;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 976
;976:	}
LABELV $334
line 956
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $336
line 955
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $333
line 978
;977:
;978:	return count;
ADDRLP4 8
INDIRI4
RETI4
LABELV $332
endproc G_MonsterWaveLivingCount 12 0
proc G_MonsterWaveSpotSafe 96 28
line 985
;979:}
;980:
;981:static qboolean G_MonsterWaveSpotSafe(
;982:	gentity_t *spot,
;983:	monsterDef_t *def,
;984:	qboolean requireDistance
;985:) {
line 991
;986:	gentity_t *player;
;987:	trace_t trace;
;988:	vec3_t origin;
;989:	int i;
;990:
;991:	if( !spot || !def ) {
ADDRLP4 76
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
EQU4 $349
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 76
INDIRU4
NEU4 $347
LABELV $349
line 992
;992:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $346
JUMPV
LABELV $347
line 995
;993:	}
;994:
;995:	if( SpotWouldTelefrag(spot) ) {
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
EQI4 $350
line 996
;996:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $346
JUMPV
LABELV $350
line 999
;997:	}
;998:
;999:	VectorCopy(spot->s.origin, origin);
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1000
;1000:	origin[2] += 9 + def->hoverHeight;
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
line 1002
;1001:
;1002:	trap_Trace(
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
line 1012
;1003:		&trace,
;1004:		origin,
;1005:		def->mins,
;1006:		def->maxs,
;1007:		origin,
;1008:		ENTITYNUM_NONE,
;1009:		MASK_PLAYERSOLID
;1010:	);
;1011:
;1012:	if( trace.startsolid || trace.allsolid ) {
ADDRLP4 88
CNSTI4 0
ASGNI4
ADDRLP4 20+4
INDIRI4
ADDRLP4 88
INDIRI4
NEI4 $356
ADDRLP4 20
INDIRI4
ADDRLP4 88
INDIRI4
EQI4 $353
LABELV $356
line 1013
;1013:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $346
JUMPV
LABELV $353
line 1016
;1014:	}
;1015:
;1016:	if( !requireDistance ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $357
line 1017
;1017:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $346
JUMPV
LABELV $357
line 1020
;1018:	}
;1019:
;1020:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $362
JUMPV
LABELV $359
line 1021
;1021:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1023
;1022:
;1023:		if( !player->client ) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $364
line 1024
;1024:			continue;
ADDRGP4 $360
JUMPV
LABELV $364
line 1027
;1025:		}
;1026:
;1027:		if( player->client->pers.connected !=
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $366
line 1028
;1028:			CON_CONNECTED ) {
line 1029
;1029:			continue;
ADDRGP4 $360
JUMPV
LABELV $366
line 1032
;1030:		}
;1031:
;1032:		if( player->client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $368
line 1033
;1033:			TEAM_SPECTATOR ) {
line 1034
;1034:			continue;
ADDRGP4 $360
JUMPV
LABELV $368
line 1037
;1035:		}
;1036:
;1037:		if( player->health <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $370
line 1038
;1038:			continue;
ADDRGP4 $360
JUMPV
LABELV $370
line 1041
;1039:		}
;1040:
;1041:		if( DistanceSquared(
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
GEF4 $372
line 1044
;1042:			spot->s.origin,
;1043:			player->r.currentOrigin
;1044:		) < 256.0f * 256.0f ) {
line 1045
;1045:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $346
JUMPV
LABELV $372
line 1047
;1046:		}
;1047:	}
LABELV $360
line 1020
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $362
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $359
line 1049
;1048:
;1049:	return qtrue;
CNSTI4 1
RETI4
LABELV $346
endproc G_MonsterWaveSpotSafe 96 28
proc G_MonsterWaveChooseSpawn 536 12
line 1055
;1050:}
;1051:
;1052:static qboolean G_MonsterWaveChooseSpawn(
;1053:	monsterDef_t *def,
;1054:	vec3_t origin
;1055:) {
line 1061
;1056:	gentity_t *spots[128];
;1057:	gentity_t *spot;
;1058:	int count;
;1059:	int pass;
;1060:
;1061:	for( pass = 0; pass < 2; pass++ ) {
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $375
line 1062
;1062:		count = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1063
;1063:		spot = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $380
JUMPV
LABELV $379
line 1069
;1064:
;1065:		while( (spot = G_Find(
;1066:			spot,
;1067:			FOFS(classname),
;1068:			"info_player_deathmatch"
;1069:		)) != NULL ) {
line 1070
;1070:			if( !G_MonsterWaveSpotSafe(
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $386
ADDRLP4 524
CNSTI4 1
ASGNI4
ADDRGP4 $387
JUMPV
LABELV $386
ADDRLP4 524
CNSTI4 0
ASGNI4
LABELV $387
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
NEI4 $383
line 1074
;1071:				spot,
;1072:				def,
;1073:				pass == 0
;1074:			) ) {
line 1075
;1075:				continue;
ADDRGP4 $380
JUMPV
LABELV $383
line 1078
;1076:			}
;1077:
;1078:			spots[count++] = spot;
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
line 1080
;1079:
;1080:			if( count >= 128 ) {
ADDRLP4 4
INDIRI4
CNSTI4 128
LTI4 $388
line 1081
;1081:				break;
ADDRGP4 $381
JUMPV
LABELV $388
line 1083
;1082:			}
;1083:		}
LABELV $380
line 1065
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRGP4 $382
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
NEU4 $379
LABELV $381
line 1085
;1084:
;1085:		if( count > 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LEI4 $390
line 1086
;1086:			spot = spots[rand() % count];
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
line 1088
;1087:
;1088:			VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1093
;1089:				spot->s.origin,
;1090:				origin
;1091:			);
;1092:
;1093:			origin[2] += 9;
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
line 1094
;1094:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $374
JUMPV
LABELV $390
line 1096
;1095:		}
;1096:	}
LABELV $376
line 1061
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 2
LTI4 $375
line 1098
;1097:
;1098:	return qfalse;
CNSTI4 0
RETI4
LABELV $374
endproc G_MonsterWaveChooseSpawn 536 12
proc G_MonsterWaveBegin 8 8
line 1101
;1099:}
;1100:
;1101:static void G_MonsterWaveBegin( void ) {
line 1102
;1102:	monsterWaveActive = qtrue;
ADDRGP4 monsterWaveActive
CNSTI4 1
ASGNI4
line 1103
;1103:	monsterWaveCombatStarted = qtrue;
ADDRGP4 monsterWaveCombatStarted
CNSTI4 1
ASGNI4
line 1104
;1104:	monsterWaveEntry = 0;
ADDRGP4 monsterWaveEntry
CNSTI4 0
ASGNI4
line 1105
;1105:	monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1106
;1106:	monsterWaveNextSpawn = level.time;
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1107
;1107:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1109
;1108:
;1109:	trap_SendServerCommand(
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
line 1117
;1110:		-1,
;1111:		va(
;1112:			"cp \"Wave %i\n\"",
;1113:			monsterCurrentWave
;1114:		)
;1115:	);
;1116:
;1117:	trap_SendServerCommand(
ADDRGP4 $396
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
line 1125
;1118:		-1,
;1119:		va(
;1120:			"print \"Monster Hunt: wave %i started.\n\"",
;1121:			monsterCurrentWave
;1122:		)
;1123:	);
;1124:
;1125:	G_Printf(
ADDRGP4 $397
ARGP4
ADDRGP4 monsterCurrentWave
INDIRI4
ARGI4
ADDRGP4 G_Printf
CALLV
pop
line 1129
;1126:		"Monster Hunt: wave %i started.\n",
;1127:		monsterCurrentWave
;1128:	);
;1129:}
LABELV $392
endproc G_MonsterWaveBegin 8 8
proc G_MonsterWaveComplete 8 8
line 1131
;1130:
;1131:static void G_MonsterWaveComplete( void ) {
line 1132
;1132:	trap_SendServerCommand(
ADDRGP4 $399
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
line 1140
;1133:		-1,
;1134:		va(
;1135:			"print \"Monster Hunt: wave %i cleared.\n\"",
;1136:			monsterCurrentWave
;1137:		)
;1138:	);
;1139:
;1140:	monsterWaveActive = qfalse;
ADDRGP4 monsterWaveActive
CNSTI4 0
ASGNI4
line 1142
;1141:
;1142:	if( monsterCurrentWave <
ADDRGP4 monsterCurrentWave
INDIRI4
ADDRGP4 monsterWaveFinal
INDIRI4
GEI4 $400
line 1143
;1143:		monsterWaveFinal ) {
line 1144
;1144:		monsterCurrentWave++;
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
line 1146
;1145:
;1146:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1150
;1147:			level.time +
;1148:			monsterWaveDelay;
;1149:
;1150:		return;
ADDRGP4 $398
JUMPV
LABELV $400
line 1157
;1151:	}
;1152:
;1153:	/*
;1154:	 * Classic Monster Hunt repeats the final wave until
;1155:	 * fraglimit or timelimit ends the match.
;1156:	 */
;1157:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 1
NEI4 $403
line 1158
;1158:		MONSTER_HUNT_CLASSIC ) {
line 1159
;1159:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1163
;1160:			level.time +
;1161:			monsterWaveDelay;
;1162:
;1163:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $407
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1168
;1164:			-1,
;1165:			"print \"Monster Hunt: final wave restarting.\n\""
;1166:		);
;1167:
;1168:		return;
ADDRGP4 $398
JUMPV
LABELV $403
line 1174
;1169:	}
;1170:
;1171:	/*
;1172:	 * One Life ends after clearing the final wave.
;1173:	 */
;1174:	monsterWaveFinished = qtrue;
ADDRGP4 monsterWaveFinished
CNSTI4 1
ASGNI4
line 1176
;1175:
;1176:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $408
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1181
;1177:		-1,
;1178:		"cp \"Monster Hunt completed!\n\""
;1179:	);
;1180:
;1181:	trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $409
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1186
;1182:		-1,
;1183:		"print \"Monster Hunt: all waves cleared.\n\""
;1184:	);
;1185:
;1186:	LogExit(
ADDRGP4 $410
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1189
;1187:		"Monster Hunt completed."
;1188:	);
;1189:}
LABELV $398
endproc G_MonsterWaveComplete 8 8
proc G_MonsterWaveRelocateStuck 48 12
line 1191
;1190:
;1191:static int G_MonsterWaveRelocateStuck( void ) {
line 1198
;1192:	gentity_t *monster;
;1193:	monsterDef_t *def;
;1194:	vec3_t origin;
;1195:	int relocated;
;1196:	int i;
;1197:
;1198:	relocated = 0;
ADDRLP4 24
CNSTI4 0
ASGNI4
line 1200
;1199:
;1200:	for( i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $415
JUMPV
LABELV $412
line 1202
;1201:		i < level.num_entities;
;1202:		i++ ) {
line 1203
;1203:		monster = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1205
;1204:
;1205:		if( !monster->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $417
line 1206
;1206:			continue;
ADDRGP4 $413
JUMPV
LABELV $417
line 1209
;1207:		}
;1208:
;1209:		if( monster->s.eType != ET_MONSTER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $419
line 1210
;1210:			continue;
ADDRGP4 $413
JUMPV
LABELV $419
line 1213
;1211:		}
;1212:
;1213:		if( !monster->monsterWaveSpawn ||
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
EQI4 $423
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $421
LABELV $423
line 1214
;1214:			monster->monsterDead ) {
line 1215
;1215:			continue;
ADDRGP4 $413
JUMPV
LABELV $421
line 1222
;1216:		}
;1217:
;1218:		/*
;1219:		 * Relocate only monsters that have neither moved,
;1220:		 * fired nor received damage for the timeout period.
;1221:		 */
;1222:		if( level.time -
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
GEI4 $424
line 1224
;1223:			monster->monsterProgressTime <
;1224:			monsterWaveTimeout ) {
line 1225
;1225:			continue;
ADDRGP4 $413
JUMPV
LABELV $424
line 1228
;1226:		}
;1227:
;1228:		def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1180
ADDRLP4 0
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5900
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
line 1232
;1229:			[monster->monsterType]
;1230:			[monster->monsterSlot];
;1231:
;1232:		if( !G_MonsterWaveChooseSpawn(
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
NEI4 $427
line 1235
;1233:			def,
;1234:			origin
;1235:		) ) {
line 1236
;1236:			continue;
ADDRGP4 $413
JUMPV
LABELV $427
line 1243
;1237:		}
;1238:
;1239:		/*
;1240:		 * ChooseSpawn returns the base position.
;1241:		 * Apply the monster's configured hovering height.
;1242:		 */
;1243:		origin[2] += def->hoverHeight;
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
line 1245
;1244:
;1245:		G_MonsterSetOrigin(
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1250
;1246:			monster,
;1247:			origin
;1248:		);
;1249:
;1250:		monster->monsterProgressTime =
ADDRLP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1253
;1251:			level.time;
;1252:
;1253:		VectorCopy(
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
line 1258
;1254:			monster->r.currentOrigin,
;1255:			monster->monsterProgressOrigin
;1256:		);
;1257:
;1258:		monster->enemy = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 768
ADDP4
CNSTP4 0
ASGNP4
line 1259
;1259:		monster->monsterShotsRemaining = 0;
ADDRLP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 1260
;1260:		monster->monsterNextAttack =
ADDRLP4 0
INDIRP4
CNSTI4 872
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1262
;1261:			level.time + 500;
;1262:		monster->monsterLastThink =
ADDRLP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1265
;1263:			level.time;
;1264:
;1265:		G_MonsterSetAnimation(
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
line 1271
;1266:			monster,
;1267:			MONSTER_STATE_MOVE,
;1268:			0
;1269:		);
;1270:
;1271:		trap_LinkEntity(monster);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 1272
;1272:		relocated++;
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1273
;1273:	}
LABELV $413
line 1202
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $415
line 1201
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $412
line 1275
;1274:
;1275:	return relocated;
ADDRLP4 24
INDIRI4
RETI4
LABELV $411
endproc G_MonsterWaveRelocateStuck 48 12
export G_MonsterRunFrame
proc G_MonsterRunFrame 60 16
line 1278
;1276:}
;1277:
;1278:void G_MonsterRunFrame( void ) {
line 1285
;1279:	monsterWaveDef_t *wave;
;1280:	monsterWaveEntry_t *entry;
;1281:	monsterDef_t *def;
;1282:	vec3_t origin;
;1283:	int living;
;1284:
;1285:	if( g_monsterHunt.integer ==
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
NEI4 $434
line 1286
;1286:		MONSTER_HUNT_OFF ) {
line 1287
;1287:		return;
ADDRGP4 $433
JUMPV
LABELV $434
line 1290
;1288:	}
;1289:
;1290:	if( !monsterWavesLoaded ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 monsterWavesLoaded
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $439
ADDRGP4 monsterWaveFinished
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $437
LABELV $439
line 1291
;1291:		monsterWaveFinished ) {
line 1292
;1292:		return;
ADDRGP4 $433
JUMPV
LABELV $437
line 1295
;1293:	}
;1294:
;1295:	if( level.intermissiontime ||
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 level+9128
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $446
ADDRGP4 level+9124
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $446
ADDRGP4 level+16
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $440
LABELV $446
line 1297
;1296:		level.intermissionQueued ||
;1297:		level.warmupTime ) {
line 1298
;1298:		return;
ADDRGP4 $433
JUMPV
LABELV $440
line 1301
;1299:	}
;1300:
;1301:	if( !G_MonsterWaveHasPlayers() ) {
ADDRLP4 36
ADDRGP4 G_MonsterWaveHasPlayers
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $447
line 1302
;1302:		return;
ADDRGP4 $433
JUMPV
LABELV $447
line 1305
;1303:	}
;1304:
;1305:	if( !monsterWaveStarted ) {
ADDRGP4 monsterWaveStarted
INDIRI4
CNSTI4 0
NEI4 $449
line 1306
;1306:		monsterWaveStarted = qtrue;
ADDRGP4 monsterWaveStarted
CNSTI4 1
ASGNI4
line 1307
;1307:		monsterCurrentWave = 1;
ADDRGP4 monsterCurrentWave
CNSTI4 1
ASGNI4
line 1308
;1308:		monsterWaveNextStart =
ADDRGP4 monsterWaveNextStart
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveDelay
INDIRI4
ADDI4
ASGNI4
line 1311
;1309:			level.time + monsterWaveDelay;
;1310:
;1311:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $452
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1316
;1312:			-1,
;1313:			"print \"Monster Hunt begins.\n\""
;1314:		);
;1315:
;1316:		return;
ADDRGP4 $433
JUMPV
LABELV $449
line 1319
;1317:	}
;1318:
;1319:	if( !monsterWaveActive ) {
ADDRGP4 monsterWaveActive
INDIRI4
CNSTI4 0
NEI4 $453
line 1320
;1320:		if( level.time >= monsterWaveNextStart ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextStart
INDIRI4
LTI4 $433
line 1321
;1321:			G_MonsterWaveBegin();
ADDRGP4 G_MonsterWaveBegin
CALLV
pop
line 1322
;1322:		}
line 1324
;1323:
;1324:		return;
ADDRGP4 $433
JUMPV
LABELV $453
line 1327
;1325:	}
;1326:
;1327:	wave =
ADDRLP4 0
CNSTI4 108
ADDRGP4 monsterCurrentWave
INDIRI4
MULI4
ADDRGP4 monsterWaves-108
ADDP4
ASGNP4
ADDRGP4 $460
JUMPV
LABELV $459
line 1331
;1328:		&monsterWaves[monsterCurrentWave - 1];
;1329:
;1330:	while( monsterWaveEntry <
;1331:		wave->numEntries ) {
line 1332
;1332:		entry =
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1335
;1333:			&wave->entries[monsterWaveEntry];
;1334:
;1335:		if( monsterWaveEntrySpawned <
ADDRGP4 monsterWaveEntrySpawned
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
GEI4 $462
line 1336
;1336:			entry->count ) {
line 1337
;1337:			break;
ADDRGP4 $461
JUMPV
LABELV $462
line 1340
;1338:		}
;1339:
;1340:		monsterWaveEntry++;
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
line 1341
;1341:		monsterWaveEntrySpawned = 0;
ADDRGP4 monsterWaveEntrySpawned
CNSTI4 0
ASGNI4
line 1342
;1342:	}
LABELV $460
line 1330
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $459
LABELV $461
line 1344
;1343:
;1344:	living = G_MonsterWaveLivingCount();
ADDRLP4 40
ADDRGP4 G_MonsterWaveLivingCount
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 40
INDIRI4
ASGNI4
line 1350
;1345:
;1346:	/*
;1347:	 * Every configured monster has been spawned.
;1348:	 * Complete the wave after the last living monster dies.
;1349:	 */
;1350:	if( monsterWaveEntry >=
ADDRGP4 monsterWaveEntry
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
LTI4 $464
line 1351
;1351:		wave->numEntries ) {
line 1352
;1352:		if( living == 0 ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $466
line 1353
;1353:			G_MonsterWaveComplete();
ADDRGP4 G_MonsterWaveComplete
CALLV
pop
line 1354
;1354:			return;
ADDRGP4 $433
JUMPV
LABELV $466
line 1357
;1355:		}
;1356:
;1357:		if( level.time - monsterWaveLastProgress >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveLastProgress
INDIRI4
SUBI4
ADDRGP4 monsterWaveTimeout
INDIRI4
LTI4 $433
line 1358
;1358:			monsterWaveTimeout ) {
line 1361
;1359:			int relocated;
;1360:
;1361:			relocated =
ADDRLP4 48
ADDRGP4 G_MonsterWaveRelocateStuck
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 48
INDIRI4
ASGNI4
line 1364
;1362:				G_MonsterWaveRelocateStuck();
;1363:
;1364:			monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1380
;1365:
;1366:			/*trap_SendServerCommand(
;1367:				-1,
;1368:				va(
;1369:					"print \"Monster Hunt: relocated %i lost monsters.\n\"",
;1370:					relocated
;1371:				)
;1372:			);
;1373:
;1374:			G_Printf(
;1375:				"Monster Hunt: wave %i still has %i living monsters; relocated %i.\n",
;1376:				monsterCurrentWave,
;1377:				living,
;1378:				relocated
;1379:			);*/
;1380:		}
line 1382
;1381:
;1382:		return;
ADDRGP4 $433
JUMPV
LABELV $464
line 1385
;1383:	}
;1384:
;1385:	{
line 1386
;1386:		int waveLimit = wave->maxActive > 0
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
CNSTI4 0
LEI4 $473
ADDRLP4 48
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $474
JUMPV
LABELV $473
ADDRLP4 48
ADDRGP4 monsterWaveMaxActive
INDIRI4
ASGNI4
LABELV $474
ADDRLP4 44
ADDRLP4 48
INDIRI4
ASGNI4
line 1390
;1387:			? wave->maxActive
;1388:			: monsterWaveMaxActive;
;1389:
;1390:		if( living >= waveLimit ) {
ADDRLP4 12
INDIRI4
ADDRLP4 44
INDIRI4
LTI4 $475
line 1391
;1391:			return;
ADDRGP4 $433
JUMPV
LABELV $475
line 1393
;1392:		}
;1393:	}
line 1395
;1394:
;1395:	if( level.time < monsterWaveNextSpawn ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveNextSpawn
INDIRI4
GEI4 $477
line 1396
;1396:		return;
ADDRGP4 $433
JUMPV
LABELV $477
line 1399
;1397:	}
;1398:
;1399:	entry = &wave->entries[monsterWaveEntry];
ADDRLP4 4
CNSTI4 12
ADDRGP4 monsterWaveEntry
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
ADDP4
ASGNP4
line 1401
;1400:
;1401:	def = &g_monsterDefs
ADDRLP4 8
CNSTI4 1180
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
MULI4
CNSTI4 5900
ADDRLP4 4
INDIRP4
INDIRI4
MULI4
ADDRGP4 g_monsterDefs
ADDP4
ADDP4
ASGNP4
line 1405
;1402:		[entry->monsterType]
;1403:		[entry->monsterSlot];
;1404:
;1405:	if( !G_MonsterWaveChooseSpawn(
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
NEI4 $480
line 1408
;1406:		def,
;1407:		origin
;1408:	) ) {
line 1409
;1409:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 1000
ADDI4
ASGNI4
line 1411
;1410:			level.time + 1000;
;1411:		return;
ADDRGP4 $433
JUMPV
LABELV $480
line 1414
;1412:	}
;1413:
;1414:	if( G_MonsterSpawnAtOrigin(
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
EQI4 $483
line 1419
;1415:		NULL,
;1416:		def,
;1417:		origin,
;1418:		qtrue
;1419:	) ) {
line 1420
;1420:	monsterWaveEntrySpawned++;
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
line 1421
;1421:	monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1423
;1422:
;1423:	monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
ADDRGP4 monsterWaveSpawnInterval
INDIRI4
ADDI4
ASGNI4
line 1426
;1424:		level.time +
;1425:			monsterWaveSpawnInterval;
;1426:	}
ADDRGP4 $484
JUMPV
LABELV $483
line 1427
;1427:	else {
line 1428
;1428:		monsterWaveNextSpawn =
ADDRGP4 monsterWaveNextSpawn
ADDRGP4 level+32
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 1430
;1429:			level.time + 500;
;1430:	}
LABELV $484
line 1431
;1431:}
LABELV $433
endproc G_MonsterRunFrame 60 16
export G_MonsterTryReplaceItem
proc G_MonsterTryReplaceItem 0 0
line 1435
;1432:
;1433:qboolean G_MonsterTryReplaceItem(
;1434:	gentity_t *item
;1435:) {
line 1440
;1436:	/*
;1437:	 * Both Monster Hunt modes now receive monsters
;1438:	 * exclusively from the wave controller.
;1439:	 */
;1440:	return qfalse;
CNSTI4 0
RETI4
LABELV $488
endproc G_MonsterTryReplaceItem 0 0
proc G_MonsterFindTarget 28 8
line 1443
;1441:}
;1442:
;1443:static gentity_t *G_MonsterFindTarget(gentity_t *monster) {
line 1449
;1444:	gentity_t *player;
;1445:	gentity_t *best;
;1446:	float bestDistance;
;1447:	int i;
;1448:
;1449:	best = NULL;
ADDRLP4 12
CNSTP4 0
ASGNP4
line 1450
;1450:	bestDistance = 99999999.0f;
ADDRLP4 8
CNSTF4 1287568416
ASGNF4
line 1452
;1451:
;1452:	for (i = 0; i < level.maxclients; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $493
JUMPV
LABELV $490
line 1455
;1453:		float distance;
;1454:
;1455:		player = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1457
;1456:
;1457:		if (!player->client) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $495
line 1458
;1458:			continue;
ADDRGP4 $491
JUMPV
LABELV $495
line 1461
;1459:		}
;1460:
;1461:		if (player->client->pers.connected != CON_CONNECTED) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $497
line 1462
;1462:			continue;
ADDRGP4 $491
JUMPV
LABELV $497
line 1465
;1463:		}
;1464:
;1465:		if (player->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $499
line 1466
;1466:			continue;
ADDRGP4 $491
JUMPV
LABELV $499
line 1469
;1467:		}
;1468:
;1469:		if (player->health <= 0) {
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $501
line 1470
;1470:			continue;
ADDRGP4 $491
JUMPV
LABELV $501
line 1473
;1471:		}
;1472:
;1473:		distance = DistanceSquared(
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
line 1478
;1474:			monster->r.currentOrigin,
;1475:			player->r.currentOrigin
;1476:		);
;1477:
;1478:		if (distance < bestDistance) {
ADDRLP4 16
INDIRF4
ADDRLP4 8
INDIRF4
GEF4 $503
line 1479
;1479:			bestDistance = distance;
ADDRLP4 8
ADDRLP4 16
INDIRF4
ASGNF4
line 1480
;1480:			best = player;
ADDRLP4 12
ADDRLP4 0
INDIRP4
ASGNP4
line 1481
;1481:		}
LABELV $503
line 1482
;1482:	}
LABELV $491
line 1452
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $493
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $490
line 1484
;1483:
;1484:	return best;
ADDRLP4 12
INDIRP4
RETP4
LABELV $489
endproc G_MonsterFindTarget 28 8
proc G_MonsterAnimation 16 0
line 1490
;1485:}
;1486:
;1487:static animation_t *G_MonsterAnimation(
;1488:	gentity_t *monster,
;1489:	monsterDef_t *def
;1490:) {
line 1493
;1491:	int variant;
;1492:
;1493:	variant = monster->monsterAnimationVariant;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
INDIRI4
ASGNI4
line 1495
;1494:
;1495:	if (variant < 0 || variant >= MAX_MONSTER_VARIANTS) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $508
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $506
LABELV $508
line 1496
;1496:		variant = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1497
;1497:	}
LABELV $506
line 1499
;1498:
;1499:	switch (monster->monsterAnimation) {
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
LTI4 $509
ADDRLP4 8
INDIRI4
CNSTI4 5
GTI4 $509
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $518
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $518
address $512
address $513
address $514
address $515
address $516
address $517
code
LABELV $512
line 1501
;1500:	case MONSTER_STATE_IDLE:
;1501:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 788
ADDP4
RETP4
ADDRGP4 $505
JUMPV
LABELV $513
line 1504
;1502:
;1503:	case MONSTER_STATE_MOVE:
;1504:		return &def->moveAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 816
ADDP4
RETP4
ADDRGP4 $505
JUMPV
LABELV $514
line 1507
;1505:
;1506:	case MONSTER_STATE_MELEE:
;1507:		return &def->meleeAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 844
ADDP4
ADDP4
RETP4
ADDRGP4 $505
JUMPV
LABELV $515
line 1510
;1508:
;1509:	case MONSTER_STATE_RANGED:
;1510:		return &def->rangedAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 928
ADDP4
ADDP4
RETP4
ADDRGP4 $505
JUMPV
LABELV $516
line 1513
;1511:
;1512:	case MONSTER_STATE_PAIN:
;1513:		return &def->painAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 1012
ADDP4
ADDP4
RETP4
ADDRGP4 $505
JUMPV
LABELV $517
line 1516
;1514:
;1515:	case MONSTER_STATE_DEATH:
;1516:		return &def->deathAnimations[variant];
CNSTI4 28
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 4
INDIRP4
CNSTI4 1096
ADDP4
ADDP4
RETP4
ADDRGP4 $505
JUMPV
LABELV $509
line 1519
;1517:
;1518:	default:
;1519:		return &def->idleAnimation;
ADDRFP4 4
INDIRP4
CNSTI4 788
ADDP4
RETP4
LABELV $505
endproc G_MonsterAnimation 16 0
proc G_MonsterSetAnimation 0 0
line 1527
;1520:	}
;1521:}
;1522:
;1523:static void G_MonsterSetAnimation(
;1524:	gentity_t *monster,
;1525:	int animation,
;1526:	int variant
;1527:) {
line 1528
;1528:	monster->monsterAnimation = animation;
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
ADDRFP4 4
INDIRI4
ASGNI4
line 1529
;1529:	monster->monsterAnimationVariant = variant;
ADDRFP4 0
INDIRP4
CNSTI4 848
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 1530
;1530:	monster->monsterAnimationStart = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 836
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1531
;1531:}
LABELV $519
endproc G_MonsterSetAnimation 0 0
proc G_MonsterUpdateAnimation 36 12
line 1536
;1532:
;1533:static void G_MonsterUpdateAnimation(
;1534:	gentity_t *monster,
;1535:	monsterDef_t *def
;1536:) {
line 1541
;1537:	animation_t *animation;
;1538:	int elapsed;
;1539:	int frame;
;1540:
;1541:	animation = G_MonsterAnimation(monster, def);
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
line 1543
;1542:
;1543:	if (animation->numFrames <= 0 ||
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
LEI4 $524
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
GTI4 $522
LABELV $524
line 1544
;1544:		animation->frameLerp <= 0) {
line 1545
;1545:		return;
ADDRGP4 $521
JUMPV
LABELV $522
line 1548
;1546:	}
;1547:
;1548:	elapsed = level.time - monster->monsterAnimationStart;
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
line 1549
;1549:	frame = elapsed / animation->frameLerp;
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
line 1551
;1550:
;1551:	if (frame >= animation->numFrames) {
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
LTI4 $526
line 1552
;1552:		if (animation->loopFrames > 0) {
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
LEI4 $528
line 1553
;1553:			frame =
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
line 1558
;1554:				animation->numFrames -
;1555:				animation->loopFrames +
;1556:				(frame - animation->numFrames) %
;1557:				animation->loopFrames;
;1558:		}
ADDRGP4 $529
JUMPV
LABELV $528
line 1559
;1559:		else {
line 1560
;1560:			frame = animation->numFrames - 1;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1562
;1561:
;1562:		if( monster->monsterAnimation ==
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
EQI4 $532
ADDRLP4 24
INDIRI4
CNSTI4 3
EQI4 $533
ADDRLP4 24
INDIRI4
CNSTI4 2
NEI4 $530
LABELV $533
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $530
LABELV $532
line 1568
;1563:				MONSTER_STATE_PAIN ||
;1564:			((monster->monsterAnimation ==
;1565:					MONSTER_STATE_RANGED ||
;1566:			  monster->monsterAnimation ==
;1567:					MONSTER_STATE_MELEE) &&
;1568:			 monster->monsterShotsRemaining <= 0) ) {
line 1569
;1569:				G_MonsterSetAnimation(
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
line 1575
;1570:					monster,
;1571:					MONSTER_STATE_IDLE,
;1572:					0
;1573:				);
;1574:
;1575:				animation = &def->idleAnimation;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 788
ADDP4
ASGNP4
line 1576
;1576:				frame = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1577
;1577:			}
LABELV $530
line 1578
;1578:		}
LABELV $529
line 1579
;1579:	}
LABELV $526
line 1581
;1580:
;1581:	monster->s.frame =
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
line 1583
;1582:		animation->firstFrame + frame;
;1583:}
LABELV $521
endproc G_MonsterUpdateAnimation 36 12
proc G_MonsterGroundWalker 88 28
line 1589
;1584:
;1585:static void G_MonsterGroundWalker(
;1586:	gentity_t *monster,
;1587:	monsterDef_t *def,
;1588:	int msec
;1589:) {
line 1594
;1590:	trace_t trace;
;1591:	vec3_t destination;
;1592:	float fallDistance;
;1593:
;1594:	if( def->movementType !=
ADDRFP4 4
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
EQI4 $535
line 1595
;1595:		MONSTER_MOVEMENT_WALKING ) {
line 1596
;1596:		return;
ADDRGP4 $534
JUMPV
LABELV $535
line 1599
;1597:	}
;1598:
;1599:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1604
;1600:		monster->r.currentOrigin,
;1601:		destination
;1602:	);
;1603:
;1604:	destination[2] -= 64;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 1606
;1605:
;1606:	trap_Trace(
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
line 1616
;1607:		&trace,
;1608:		monster->r.currentOrigin,
;1609:		monster->r.mins,
;1610:		monster->r.maxs,
;1611:		destination,
;1612:		monster->s.number,
;1613:		MASK_PLAYERSOLID
;1614:	);
;1615:
;1616:	if( !trace.startsolid &&
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $538
ADDRLP4 0
INDIRI4
ADDRLP4 76
INDIRI4
NEI4 $538
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $538
line 1618
;1617:		!trace.allsolid &&
;1618:		trace.fraction < 1.0f ) {
line 1619
;1619:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1624
;1620:			monster,
;1621:			trace.endpos
;1622:		);
;1623:
;1624:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1627
;1625:			trace.entityNum;
;1626:
;1627:		return;
ADDRGP4 $534
JUMPV
LABELV $538
line 1633
;1628:	}
;1629:
;1630:	/*
;1631:	 * No nearby floor: apply simple falling movement.
;1632:	 */
;1633:	fallDistance =
ADDRLP4 68
CNSTF4 1137180672
ADDRFP4 8
INDIRI4
CVIF4 4
MULF4
CNSTF4 1148846080
DIVF4
ASGNF4
line 1636
;1634:		400.0f * msec / 1000.0f;
;1635:
;1636:	VectorCopy(
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1641
;1637:		monster->r.currentOrigin,
;1638:		destination
;1639:	);
;1640:
;1641:	destination[2] -= fallDistance;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
ADDRLP4 68
INDIRF4
SUBF4
ASGNF4
line 1643
;1642:
;1643:	trap_Trace(
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
line 1653
;1644:		&trace,
;1645:		monster->r.currentOrigin,
;1646:		monster->r.mins,
;1647:		monster->r.maxs,
;1648:		destination,
;1649:		monster->s.number,
;1650:		MASK_PLAYERSOLID
;1651:	);
;1652:
;1653:	if( !trace.startsolid &&
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $545
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $545
line 1654
;1654:		!trace.allsolid ) {
line 1655
;1655:		G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1659
;1656:			monster,
;1657:			trace.endpos
;1658:		);
;1659:	}
LABELV $545
line 1661
;1660:
;1661:	if( trace.fraction < 1.0f ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $549
line 1662
;1662:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 0+52
INDIRI4
ASGNI4
line 1664
;1663:			trace.entityNum;
;1664:	}
ADDRGP4 $550
JUMPV
LABELV $549
line 1665
;1665:	else {
line 1666
;1666:		monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1023
ASGNI4
line 1668
;1667:			ENTITYNUM_NONE;
;1668:	}
LABELV $550
line 1669
;1669:}
LABELV $534
endproc G_MonsterGroundWalker 88 28
proc G_MonsterFaceTarget 52 8
line 1674
;1670:
;1671:static void G_MonsterFaceTarget(
;1672:	gentity_t *monster,
;1673:	gentity_t *target
;1674:) {
line 1678
;1675:	vec3_t direction;
;1676:	vec3_t angles;
;1677:
;1678:	if( !monster || !target ) {
ADDRLP4 24
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
EQU4 $556
ADDRFP4 4
INDIRP4
CVPU4 4
ADDRLP4 24
INDIRU4
NEU4 $554
LABELV $556
line 1679
;1679:		return;
ADDRGP4 $553
JUMPV
LABELV $554
line 1682
;1680:	}
;1681:
;1682:	VectorSubtract(
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
line 1688
;1683:		target->r.currentOrigin,
;1684:		monster->r.currentOrigin,
;1685:		direction
;1686:	);
;1687:
;1688:	if( VectorNormalize(direction) <= 0.0f ) {
ADDRLP4 12
ARGP4
ADDRLP4 48
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 48
INDIRF4
CNSTF4 0
GTF4 $559
line 1689
;1689:		return;
ADDRGP4 $553
JUMPV
LABELV $559
line 1692
;1690:	}
;1691:
;1692:	vectoangles(direction, angles);
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1693
;1693:	angles[PITCH] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1694
;1694:	angles[ROLL] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1696
;1695:
;1696:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1697
;1697:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1698
;1698:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 1699
;1699:}
LABELV $553
endproc G_MonsterFaceTarget 52 8
proc G_MonsterMove 480 28
line 1707
;1700:
;1701:
;1702:static void G_MonsterMove(
;1703:	gentity_t *monster,
;1704:	gentity_t *target,
;1705:	monsterDef_t *def,
;1706:	int msec
;1707:) {
line 1726
;1708:	trace_t trace;
;1709:	trace_t slideTrace;
;1710:	vec3_t targetOrigin;
;1711:	vec3_t direction;
;1712:	vec3_t right;
;1713:	vec3_t wishDirection;
;1714:	vec3_t velocity;
;1715:	vec3_t move;
;1716:	vec3_t destination;
;1717:	vec3_t slideMove;
;1718:	vec3_t slideDestination;
;1719:	vec3_t angles;
;1720:	float phase;
;1721:	float drift;
;1722:	float distance;
;1723:	float dot;
;1724:	qboolean shouldMove;
;1725:
;1726:	VectorCopy(
ADDRLP4 128
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1731
;1727:		target->r.currentOrigin,
;1728:		targetOrigin
;1729:	);
;1730:
;1731:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $563
line 1732
;1732:		MONSTER_MOVEMENT_WALKING ) {
line 1736
;1733:		/*
;1734:		 * Walking monsters chase only horizontally.
;1735:		 */
;1736:		targetOrigin[2] =
ADDRLP4 128+8
ADDRFP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ASGNF4
line 1738
;1737:			monster->r.currentOrigin[2];
;1738:	}
ADDRGP4 $564
JUMPV
LABELV $563
line 1739
;1739:	else {
line 1740
;1740:		targetOrigin[2] += 16;
ADDRLP4 128+8
ADDRLP4 128+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 1741
;1741:	}
LABELV $564
line 1743
;1742:
;1743:	VectorSubtract(
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
line 1749
;1744:		targetOrigin,
;1745:		monster->r.currentOrigin,
;1746:		direction
;1747:	);
;1748:
;1749:	distance = VectorNormalize(direction);
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
line 1751
;1750:
;1751:	if (distance <= 0.0f) {
ADDRLP4 168
INDIRF4
CNSTF4 0
GTF4 $571
line 1752
;1752:		return;
ADDRGP4 $562
JUMPV
LABELV $571
line 1758
;1753:	}
;1754:	/*
;1755:	 * A nearby target behind a wall is not yet a valid
;1756:	 * firing position, so continue moving toward it.
;1757:	 */
;1758:	shouldMove =
ADDRLP4 168
INDIRF4
ADDRFP4 8
INDIRP4
CNSTI4 648
ADDP4
INDIRF4
GTF4 $576
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
NEI4 $574
LABELV $576
ADDRLP4 260
CNSTI4 1
ASGNI4
ADDRGP4 $575
JUMPV
LABELV $574
ADDRLP4 260
CNSTI4 0
ASGNI4
LABELV $575
ADDRLP4 172
ADDRLP4 260
INDIRI4
ASGNI4
line 1769
;1759:		distance > def->attackRange ||
;1760:		!G_MonsterCanSeeTarget(
;1761:			monster,
;1762:			target
;1763:		);
;1764:	
;1765:	/*
;1766:	 * Switch between standing and movement animations
;1767:	 * without interrupting attacks, pain or death.
;1768:	 */
;1769:	if( monster->monsterAnimation ==
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
EQI4 $579
ADDRLP4 268
INDIRI4
CNSTI4 1
NEI4 $577
LABELV $579
line 1772
;1770:			MONSTER_STATE_IDLE ||
;1771:		monster->monsterAnimation ==
;1772:			MONSTER_STATE_MOVE ) {
line 1773
;1773:		if( shouldMove ||
ADDRLP4 172
INDIRI4
CNSTI4 0
NEI4 $582
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $580
LABELV $582
line 1775
;1774:			def->movePattern ==
;1775:				MONSTER_PATTERN_DRIFT ) {
line 1776
;1776:			if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
EQI4 $581
line 1777
;1777:				MONSTER_STATE_MOVE ) {
line 1778
;1778:				G_MonsterSetAnimation(
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
line 1783
;1779:					monster,
;1780:					MONSTER_STATE_MOVE,
;1781:					0
;1782:				);
;1783:			}
line 1784
;1784:		}
ADDRGP4 $581
JUMPV
LABELV $580
line 1785
;1785:		else if( monster->monsterAnimation !=
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 0
EQI4 $585
line 1786
;1786:			MONSTER_STATE_IDLE ) {
line 1787
;1787:			G_MonsterSetAnimation(
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
line 1792
;1788:				monster,
;1789:				MONSTER_STATE_IDLE,
;1790:				0
;1791:			);
;1792:		}
LABELV $585
LABELV $581
line 1793
;1793:	}
LABELV $577
line 1795
;1794:
;1795:	VectorSet(
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
line 1802
;1796:		right,
;1797:		-direction[1],
;1798:		direction[0],
;1799:		0
;1800:	);
;1801:
;1802:	if (VectorNormalize(right) <= 0.0f) {
ADDRLP4 104
ARGP4
ADDRLP4 272
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 272
INDIRF4
CNSTF4 0
GTF4 $590
line 1803
;1803:		VectorSet(right, 1, 0, 0);
ADDRLP4 104
CNSTF4 1065353216
ASGNF4
ADDRLP4 104+4
CNSTF4 0
ASGNF4
ADDRLP4 104+8
CNSTF4 0
ASGNF4
line 1804
;1804:	}
LABELV $590
line 1806
;1805:
;1806:	drift = 0.0f;
ADDRLP4 164
CNSTF4 0
ASGNF4
line 1808
;1807:
;1808:	if (def->movePattern == MONSTER_PATTERN_DRIFT &&
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
NEI4 $594
ADDRLP4 276
INDIRP4
CNSTI4 636
ADDP4
INDIRI4
CNSTI4 0
LEI4 $594
line 1809
;1809:		def->driftPeriod > 0) {
line 1810
;1810:		phase =
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
line 1814
;1811:			(level.time % def->driftPeriod) /
;1812:			(float)def->driftPeriod;
;1813:
;1814:		phase *= 6.2831853f;
ADDRLP4 176
CNSTF4 1086918619
ADDRLP4 176
INDIRF4
MULF4
ASGNF4
line 1815
;1815:		phase += monster->monsterDriftPhase;
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
line 1817
;1816:
;1817:		drift =
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
line 1820
;1818:			sin(phase) *
;1819:			def->driftAmount;
;1820:	}
LABELV $594
line 1822
;1821:
;1822:	VectorClear(velocity);
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
line 1824
;1823:
;1824:	if (shouldMove) {
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $599
line 1825
;1825:		VectorCopy(direction, wishDirection);
ADDRLP4 152
ADDRLP4 80
INDIRB
ASGNB 12
line 1827
;1826:
;1827:		if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $601
line 1828
;1828:			MONSTER_PATTERN_DRIFT) {
line 1829
;1829:			VectorMA(
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
line 1835
;1830:				wishDirection,
;1831:				drift,
;1832:				right,
;1833:				wishDirection
;1834:			);
;1835:		}
LABELV $601
line 1837
;1836:
;1837:		if (VectorNormalize(wishDirection) <= 0.0f) {
ADDRLP4 152
ARGP4
ADDRLP4 284
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 284
INDIRF4
CNSTF4 0
GTF4 $609
line 1838
;1838:			return;
ADDRGP4 $562
JUMPV
LABELV $609
line 1841
;1839:		}
;1840:
;1841:		VectorScale(
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
line 1846
;1842:			wishDirection,
;1843:			def->speed,
;1844:			velocity
;1845:		);
;1846:	}
ADDRGP4 $600
JUMPV
LABELV $599
line 1847
;1847:	else if (def->movePattern ==
ADDRFP4 8
INDIRP4
CNSTI4 588
ADDP4
INDIRI4
CNSTI4 1
NEI4 $562
line 1848
;1848:		MONSTER_PATTERN_DRIFT) {
line 1854
;1849:		/*
;1850:		 * Inside attack range, smoothly strafe.
;1851:		 * Do not normalize this vector: driftAmount must
;1852:		 * affect the actual lateral speed.
;1853:		 */
;1854:		VectorScale(
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
line 1859
;1855:			right,
;1856:			drift * def->speed,
;1857:			velocity
;1858:		);
;1859:	}
line 1860
;1860:	else {
line 1861
;1861:		return;
LABELV $616
LABELV $600
line 1864
;1862:	}
;1863:
;1864:	VectorScale(
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
line 1870
;1865:		velocity,
;1866:		msec / 1000.0f,
;1867:		move
;1868:	);
;1869:
;1870:	if (VectorLengthSquared(move) <= 0.0001f) {
ADDRLP4 56
ARGP4
ADDRLP4 288
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 288
INDIRF4
CNSTF4 953267991
GTF4 $625
line 1871
;1871:		return;
ADDRGP4 $562
JUMPV
LABELV $625
line 1874
;1872:	}
;1873:
;1874:VectorAdd(
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
line 1880
;1875:		monster->r.currentOrigin,
;1876:		move,
;1877:		destination
;1878:	);
;1879:
;1880:	trap_Trace(
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
line 1895
;1881:		&trace,
;1882:		monster->r.currentOrigin,
;1883:		monster->r.mins,
;1884:		monster->r.maxs,
;1885:		destination,
;1886:		monster->s.number,
;1887:		MASK_PLAYERSOLID
;1888:	);
;1889:
;1890:	/*
;1891:	 * Step-up: if horizontal move was blocked,
;1892:	 * try to climb a stair. Q3 player step size
;1893:	 * is 18 units; use the same for monsters.
;1894:	 */
;1895:	if( trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $631
ADDRLP4 300
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $631
ADDRLP4 0
INDIRI4
ADDRLP4 300
INDIRI4
NEI4 $631
line 1897
;1896:		!trace.startsolid &&
;1897:		!trace.allsolid ) {
line 1903
;1898:		vec3_t stepUp;
;1899:		vec3_t stepDest;
;1900:		vec3_t downDest;
;1901:		trace_t stepTrace;
;1902:		trace_t downTrace;
;1903:		const float stepHeight = 18.0f;
ADDRLP4 372
CNSTF4 1099956224
ASGNF4
line 1905
;1904:
;1905:		VectorCopy(
ADDRLP4 360
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 1910
;1906:			monster->r.currentOrigin,
;1907:			stepUp
;1908:		);
;1909:
;1910:		stepUp[2] += stepHeight;
ADDRLP4 360+8
ADDRLP4 360+8
INDIRF4
ADDRLP4 372
INDIRF4
ADDF4
ASGNF4
line 1912
;1911:
;1912:		trap_Trace(
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
line 1922
;1913:			&stepTrace,
;1914:			monster->r.currentOrigin,
;1915:			monster->r.mins,
;1916:			monster->r.maxs,
;1917:			stepUp,
;1918:			monster->s.number,
;1919:			MASK_PLAYERSOLID
;1920:		);
;1921:
;1922:		if( !stepTrace.startsolid &&
ADDRLP4 460
CNSTI4 0
ASGNI4
ADDRLP4 304+4
INDIRI4
ADDRLP4 460
INDIRI4
NEI4 $636
ADDRLP4 304
INDIRI4
ADDRLP4 460
INDIRI4
NEI4 $636
ADDRLP4 304+8
INDIRF4
CNSTF4 1063675494
LEF4 $636
line 1924
;1923:			!stepTrace.allsolid &&
;1924:			stepTrace.fraction > 0.9f ) {
line 1926
;1925:
;1926:			VectorCopy(
ADDRLP4 376
ADDRLP4 140
INDIRB
ASGNB 12
line 1931
;1927:				destination,
;1928:				stepDest
;1929:			);
;1930:
;1931:			stepDest[2] = stepUp[2];
ADDRLP4 376+8
ADDRLP4 360+8
INDIRF4
ASGNF4
line 1933
;1932:
;1933:			trap_Trace(
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
line 1943
;1934:				&stepTrace,
;1935:				stepUp,
;1936:				monster->r.mins,
;1937:				monster->r.maxs,
;1938:				stepDest,
;1939:				monster->s.number,
;1940:				MASK_PLAYERSOLID
;1941:			);
;1942:
;1943:			if( !stepTrace.startsolid &&
ADDRLP4 468
CNSTI4 0
ASGNI4
ADDRLP4 304+4
INDIRI4
ADDRLP4 468
INDIRI4
NEI4 $642
ADDRLP4 304
INDIRI4
ADDRLP4 468
INDIRI4
NEI4 $642
line 1944
;1944:				!stepTrace.allsolid ) {
line 1946
;1945:
;1946:				VectorCopy(
ADDRLP4 444
ADDRLP4 304+12
INDIRB
ASGNB 12
line 1951
;1947:					stepTrace.endpos,
;1948:					downDest
;1949:				);
;1950:
;1951:				downDest[2] -= stepHeight;
ADDRLP4 444+8
ADDRLP4 444+8
INDIRF4
ADDRLP4 372
INDIRF4
SUBF4
ASGNF4
line 1953
;1952:
;1953:				trap_Trace(
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
line 1963
;1954:					&downTrace,
;1955:					stepTrace.endpos,
;1956:					monster->r.mins,
;1957:					monster->r.maxs,
;1958:					downDest,
;1959:					monster->s.number,
;1960:					MASK_PLAYERSOLID
;1961:				);
;1962:
;1963:				if( !downTrace.startsolid &&
ADDRLP4 476
CNSTI4 0
ASGNI4
ADDRLP4 388+4
INDIRI4
ADDRLP4 476
INDIRI4
NEI4 $648
ADDRLP4 388
INDIRI4
ADDRLP4 476
INDIRI4
NEI4 $648
ADDRLP4 388+8
INDIRF4
CNSTF4 1065353216
GEF4 $648
line 1965
;1964:					!downTrace.allsolid &&
;1965:					downTrace.fraction < 1.0f ) {
line 1967
;1966:
;1967:					G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 388+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 1972
;1968:						monster,
;1969:						downTrace.endpos
;1970:					);
;1971:
;1972:					monster->s.groundEntityNum =
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
ADDRLP4 388+52
INDIRI4
ASGNI4
line 1975
;1973:						downTrace.entityNum;
;1974:
;1975:					vectoangles(
ADDRLP4 80
ARGP4
ADDRLP4 116
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1980
;1976:						direction,
;1977:						angles
;1978:					);
;1979:
;1980:					angles[PITCH] = 0;
ADDRLP4 116
CNSTF4 0
ASGNF4
line 1981
;1981:					angles[ROLL] = 0;
ADDRLP4 116+8
CNSTF4 0
ASGNF4
line 1983
;1982:
;1983:					VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1988
;1984:						angles,
;1985:						monster->s.angles
;1986:					);
;1987:
;1988:					VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1993
;1989:						angles,
;1990:						monster->s.apos.trBase
;1991:					);
;1992:
;1993:					VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 1998
;1994:						angles,
;1995:						monster->r.currentAngles
;1996:					);
;1997:
;1998:					trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2000
;1999:
;2000:					return;
ADDRGP4 $562
JUMPV
LABELV $648
line 2002
;2001:				}
;2002:			}
LABELV $642
line 2003
;2003:		}
LABELV $636
line 2004
;2004:	}
LABELV $631
line 2006
;2005:
;2006:	G_MonsterSetOrigin(monster, trace.endpos);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 2008
;2007:
;2008:	if (trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $656
ADDRLP4 304
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 304
INDIRI4
NEI4 $656
ADDRLP4 0
INDIRI4
ADDRLP4 304
INDIRI4
NEI4 $656
line 2010
;2009:		!trace.startsolid &&
;2010:		!trace.allsolid) {
line 2012
;2011:		/* slide logic ... (без изменений) */
;2012:	}
LABELV $656
line 2014
;2013:
;2014:	if (trace.fraction < 1.0f &&
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $660
ADDRLP4 308
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 308
INDIRI4
NEI4 $660
ADDRLP4 0
INDIRI4
ADDRLP4 308
INDIRI4
NEI4 $660
line 2016
;2015:		!trace.startsolid &&
;2016:		!trace.allsolid) {
line 2020
;2017:		/*
;2018:		 * Slide only for the uncompleted part of movement.
;2019:		 */
;2020:		VectorScale(
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
line 2026
;2021:			move,
;2022:			1.0f - trace.fraction,
;2023:			slideMove
;2024:		);
;2025:
;2026:		dot = DotProduct(
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
line 2031
;2027:			slideMove,
;2028:			trace.plane.normal
;2029:		);
;2030:
;2031:		VectorMA(
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
line 2038
;2032:			slideMove,
;2033:			-dot,
;2034:			trace.plane.normal,
;2035:			slideMove
;2036:		);
;2037:
;2038:		if (VectorLengthSquared(slideMove) > 0.0001f) {
ADDRLP4 92
ARGP4
ADDRLP4 320
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 320
INDIRF4
CNSTF4 953267991
LEF4 $687
line 2039
;2039:			VectorAdd(
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
line 2045
;2040:				monster->r.currentOrigin,
;2041:				slideMove,
;2042:				slideDestination
;2043:			);
;2044:
;2045:			trap_Trace(
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
line 2055
;2046:				&slideTrace,
;2047:				monster->r.currentOrigin,
;2048:				monster->r.mins,
;2049:				monster->r.maxs,
;2050:				slideDestination,
;2051:				monster->s.number,
;2052:				MASK_PLAYERSOLID
;2053:			);
;2054:
;2055:			G_MonsterSetOrigin(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196+12
ARGP4
ADDRGP4 G_MonsterSetOrigin
CALLV
pop
line 2059
;2056:				monster,
;2057:				slideTrace.endpos
;2058:			);
;2059:		}
LABELV $687
line 2060
;2060:	}
LABELV $660
line 2062
;2061:
;2062:	vectoangles(direction, angles);
ADDRLP4 80
ARGP4
ADDRLP4 116
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2063
;2063:	angles[PITCH] = 0;
ADDRLP4 116
CNSTF4 0
ASGNF4
line 2064
;2064:	angles[ROLL] = 0;
ADDRLP4 116+8
CNSTF4 0
ASGNF4
line 2066
;2065:
;2066:	VectorCopy(angles, monster->s.angles);
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 2067
;2067:	VectorCopy(angles, monster->s.apos.trBase);
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 2068
;2068:	VectorCopy(angles, monster->r.currentAngles);
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 116
INDIRB
ASGNB 12
line 2070
;2069:
;2070:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2071
;2071:}
LABELV $562
endproc G_MonsterMove 480 28
proc G_MonsterValidTarget 8 0
line 2073
;2072:
;2073:static qboolean G_MonsterValidTarget(gentity_t *target) {
line 2074
;2074:	if (!target || !target->client) {
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
EQU4 $698
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $696
LABELV $698
line 2075
;2075:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $695
JUMPV
LABELV $696
line 2078
;2076:	}
;2077:
;2078:	if (target->client->pers.connected != CON_CONNECTED) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $699
line 2079
;2079:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $695
JUMPV
LABELV $699
line 2082
;2080:	}
;2081:
;2082:	if (target->client->sess.sessionTeam == TEAM_SPECTATOR) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
NEI4 $701
line 2083
;2083:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $695
JUMPV
LABELV $701
line 2086
;2084:	}
;2085:
;2086:	if (target->health <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
GTI4 $703
line 2087
;2087:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $695
JUMPV
LABELV $703
line 2090
;2088:	}
;2089:
;2090:	return qtrue;
CNSTI4 1
RETI4
LABELV $695
endproc G_MonsterValidTarget 8 0
proc G_MonsterHitscan 200 32
line 2110
;2091:}
;2092:
;2093:/*
;2094: * Hitscan-based monster attack with tracer.
;2095: * weaponType:
;2096: *   "hitscan"  - machinegun-like, 1 pellet, small spread
;2097: *   "rifle"    - accurate rifle, 1 pellet, no spread
;2098: *   "shotgun"  - shotgun, multiple pellets, wide spread
;2099: *
;2100: * damage is per pellet (for shotgun, total = damage * pellets).
;2101: */
;2102:static void G_MonsterHitscan(
;2103:	gentity_t *monster,
;2104:	gentity_t *target,
;2105:	monsterDef_t *def,
;2106:	const char *weaponType,
;2107:	int damage,
;2108:	int splashDamage,
;2109:	int splashRadius
;2110:) {
line 2120
;2111:	vec3_t start;
;2112:	vec3_t forward;
;2113:	vec3_t right;
;2114:	vec3_t up;
;2115:	int pellets;
;2116:	float spread;
;2117:	int mod;
;2118:	int i;
;2119:
;2120:	VectorCopy( monster->r.currentOrigin, start );
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2122
;2121:
;2122:	if( def->movementType == MONSTER_MOVEMENT_WALKING ) {
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $706
line 2123
;2123:		start[2] += 36;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1108344832
ADDF4
ASGNF4
line 2124
;2124:	}
ADDRGP4 $707
JUMPV
LABELV $706
line 2125
;2125:	else {
line 2126
;2126:		start[2] += 8;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2127
;2127:	}
LABELV $707
line 2129
;2128:
;2129:	VectorSubtract(
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
line 2135
;2130:		target->r.currentOrigin,
;2131:		start,
;2132:		forward
;2133:	);
;2134:
;2135:	VectorNormalize( forward );
ADDRLP4 32
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2137
;2136:
;2137:	PerpendicularVector( right, forward );
ADDRLP4 20
ARGP4
ADDRLP4 32
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 2138
;2138:	CrossProduct( forward, right, up );
ADDRLP4 32
ARGP4
ADDRLP4 20
ARGP4
ADDRLP4 44
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 2140
;2139:
;2140:	if( !Q_stricmp( weaponType, "shotgun" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $716
ARGP4
ADDRLP4 68
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 68
INDIRI4
CNSTI4 0
NEI4 $714
line 2141
;2141:		pellets = 11;
ADDRLP4 56
CNSTI4 11
ASGNI4
line 2142
;2142:		spread = 0.15f;
ADDRLP4 12
CNSTF4 1041865114
ASGNF4
line 2143
;2143:		mod = MOD_SHOTGUN;
ADDRLP4 60
CNSTI4 1
ASGNI4
line 2144
;2144:	}
ADDRGP4 $715
JUMPV
LABELV $714
line 2145
;2145:	else if( !Q_stricmp( weaponType, "rifle" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $719
ARGP4
ADDRLP4 72
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
NEI4 $717
line 2146
;2146:		pellets = 1;
ADDRLP4 56
CNSTI4 1
ASGNI4
line 2147
;2147:		spread = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 2148
;2148:		mod = MOD_MACHINEGUN;
ADDRLP4 60
CNSTI4 3
ASGNI4
line 2149
;2149:	}
ADDRGP4 $718
JUMPV
LABELV $717
line 2150
;2150:	else if( !Q_stricmp( weaponType, "lightning" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $722
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
NEI4 $720
line 2151
;2151:		pellets = 1;
ADDRLP4 56
CNSTI4 1
ASGNI4
line 2152
;2152:		spread = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 2153
;2153:		mod = MOD_LIGHTNING;
ADDRLP4 60
CNSTI4 11
ASGNI4
line 2154
;2154:	}
ADDRGP4 $721
JUMPV
LABELV $720
line 2155
;2155:	else if( !Q_stricmp( weaponType, "blaster" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $725
ARGP4
ADDRLP4 80
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $723
line 2161
;2156:		/*
;2157:		 * Enemy blaster: hitscan like machinegun, but
;2158:		 * a red Star Wars tracer is drawn on the client.
;2159:		 * MOD_BLASTER doesn't exist, use MOD_MACHINEGUN.
;2160:		 */
;2161:		pellets = 1;
ADDRLP4 56
CNSTI4 1
ASGNI4
line 2162
;2162:		spread = 0.02f;
ADDRLP4 12
CNSTF4 1017370378
ASGNF4
line 2163
;2163:		mod = MOD_MACHINEGUN;
ADDRLP4 60
CNSTI4 3
ASGNI4
line 2164
;2164:	}
ADDRGP4 $724
JUMPV
LABELV $723
line 2165
;2165:	else {
line 2167
;2166:		/* "hitscan" / machinegun */
;2167:		pellets = 1;
ADDRLP4 56
CNSTI4 1
ASGNI4
line 2168
;2168:		spread = 0.02f;
ADDRLP4 12
CNSTF4 1017370378
ASGNF4
line 2169
;2169:		mod = MOD_MACHINEGUN;
ADDRLP4 60
CNSTI4 3
ASGNI4
line 2170
;2170:	}
LABELV $724
LABELV $721
LABELV $718
LABELV $715
line 2172
;2171:
;2172:	for( i = 0; i < pellets; i++ ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $729
JUMPV
LABELV $726
line 2177
;2173:		vec3_t dir;
;2174:		vec3_t end;
;2175:		trace_t trace;
;2176:
;2177:		VectorCopy( forward, dir );
ADDRLP4 84
ADDRLP4 32
INDIRB
ASGNB 12
line 2179
;2178:
;2179:		if( spread > 0.0f ) {
ADDRLP4 12
INDIRF4
CNSTF4 0
LEF4 $730
line 2180
;2180:			VectorMA( dir, crandom() * spread, right, dir );
ADDRLP4 164
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 84
ADDRLP4 84
INDIRF4
ADDRLP4 20
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
ADDRLP4 84+4
ADDRLP4 84+4
INDIRF4
ADDRLP4 20+4
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
ADDRLP4 172
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 84+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 20+8
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
line 2181
;2181:			VectorMA( dir, crandom() * spread, up, dir );
ADDRLP4 176
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 84
ADDRLP4 84
INDIRF4
ADDRLP4 44
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
ADDRLP4 84+4
ADDRLP4 84+4
INDIRF4
ADDRLP4 44+4
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
ADDRLP4 184
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 84+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 44+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 184
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
line 2182
;2182:			VectorNormalize( dir );
ADDRLP4 84
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2183
;2183:		}
LABELV $730
line 2186
;2184:
;2185:		//VectorMA( start, 8192.0f, dir, end );
;2186:		if( !Q_stricmp( weaponType, "lightning" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $722
ARGP4
ADDRLP4 164
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 164
INDIRI4
CNSTI4 0
NEI4 $744
line 2187
;2187:			VectorMA( start, 768.0f, dir, end );
ADDRLP4 168
CNSTF4 1145044992
ASGNF4
ADDRLP4 152
ADDRLP4 0
INDIRF4
ADDRLP4 168
INDIRF4
ADDRLP4 84
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 152+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 168
INDIRF4
ADDRLP4 84+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 152+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1145044992
ADDRLP4 84+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2188
;2188:		}
ADDRGP4 $745
JUMPV
LABELV $744
line 2189
;2189:		else {
line 2190
;2190:			VectorMA( start, 8192.0f, dir, end );
ADDRLP4 168
CNSTF4 1174405120
ASGNF4
ADDRLP4 152
ADDRLP4 0
INDIRF4
ADDRLP4 168
INDIRF4
ADDRLP4 84
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 152+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 168
INDIRF4
ADDRLP4 84+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 152+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1174405120
ADDRLP4 84+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 2191
;2191:		}
LABELV $745
line 2193
;2192:
;2193:		trap_Trace(
ADDRLP4 96
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 168
CNSTP4 0
ASGNP4
ADDRLP4 168
INDIRP4
ARGP4
ADDRLP4 168
INDIRP4
ARGP4
ADDRLP4 152
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
line 2208
;2194:			&trace,
;2195:			start,
;2196:			NULL,
;2197:			NULL,
;2198:			end,
;2199:			monster->s.number,
;2200:			MASK_SHOT
;2201:		);
;2202:		
;2203:		/*
;2204:		 * Enemy blaster tracer: spawn a temp entity
;2205:		 * that the client draws as a red Star Wars bolt.
;2206:		 * origin2 = muzzle (start), pos.trBase = impact (trace.endpos).
;2207:		 */
;2208:		if( !Q_stricmp( weaponType, "blaster" ) ) {
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $725
ARGP4
ADDRLP4 172
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 172
INDIRI4
CNSTI4 0
NEI4 $758
line 2212
;2209:			gentity_t *tent;
;2210:			vec3_t snappedEnd;
;2211:
;2212:			VectorCopy( trace.endpos, snappedEnd );
ADDRLP4 176
ADDRLP4 96+12
INDIRB
ASGNB 12
line 2213
;2213:			SnapVector( snappedEnd );
ADDRLP4 176
ADDRLP4 176
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 176+4
ADDRLP4 176+4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 176+8
ADDRLP4 176+8
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
line 2215
;2214:
;2215:			tent = G_TempEntity( snappedEnd, EV_ENEMY_BLASTER_TRACER );
ADDRLP4 176
ARGP4
CNSTI4 83
ARGI4
ADDRLP4 192
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 188
ADDRLP4 192
INDIRP4
ASGNP4
line 2216
;2216:			VectorCopy( start, tent->s.origin2 );
ADDRLP4 188
INDIRP4
CNSTI4 104
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 2217
;2217:			tent->s.eventParm = DirToByte( trace.plane.normal );
ADDRLP4 96+24
ARGP4
ADDRLP4 196
ADDRGP4 DirToByte
CALLI4
ASGNI4
ADDRLP4 188
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 196
INDIRI4
ASGNI4
line 2218
;2218:		}
LABELV $758
line 2221
;2219:
;2220:		/* Damage only if we actually hit a player. */
;2221:		if( trace.fraction < 1.0f &&
ADDRLP4 96+8
INDIRF4
CNSTF4 1065353216
GEF4 $766
ADDRLP4 96+52
INDIRI4
CNSTI4 64
GEI4 $766
line 2222
;2222:			trace.entityNum < MAX_CLIENTS ) {
line 2223
;2223:			gentity_t *hit = &g_entities[trace.entityNum];
ADDRLP4 176
CNSTI4 884
ADDRLP4 96+52
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 2225
;2224:
;2225:			if( hit->client && hit->health > 0 ) {
ADDRLP4 176
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $771
ADDRLP4 176
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
CNSTI4 0
LEI4 $771
line 2226
;2226:				G_Damage(
ADDRLP4 176
INDIRP4
ARGP4
ADDRLP4 184
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 184
INDIRP4
ARGP4
ADDRLP4 184
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 96+12
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
line 2236
;2227:					hit,
;2228:					monster,
;2229:					monster,
;2230:					NULL,
;2231:					trace.endpos,
;2232:					damage,
;2233:					0,
;2234:					mod
;2235:				);
;2236:			}
LABELV $771
line 2237
;2237:		}
LABELV $766
line 2240
;2238:
;2239:		/* Splash (usually 0 for hitscan; keep for flexibility). */
;2240:		if( splashDamage > 0 && splashRadius > 0 ) {
ADDRLP4 176
CNSTI4 0
ASGNI4
ADDRFP4 20
INDIRI4
ADDRLP4 176
INDIRI4
LEI4 $774
ADDRFP4 24
INDIRI4
ADDRLP4 176
INDIRI4
LEI4 $774
line 2241
;2241:			G_RadiusDamage(
ADDRLP4 96+12
ARGP4
ADDRLP4 180
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 180
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
ADDRLP4 180
INDIRP4
ARGP4
ADDRLP4 60
INDIRI4
ARGI4
ADDRGP4 G_RadiusDamage
CALLI4
pop
line 2249
;2242:				trace.endpos,
;2243:				monster,
;2244:				splashDamage,
;2245:				splashRadius,
;2246:				monster,
;2247:				mod
;2248:			);
;2249:		}
LABELV $774
line 2250
;2250:	}
LABELV $727
line 2172
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $729
ADDRLP4 16
INDIRI4
ADDRLP4 56
INDIRI4
LTI4 $726
line 2253
;2251:
;2252:	/* Mark progress for wave relocation. */
;2253:	if( monster->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $777
line 2254
;2254:		monster->monsterProgressTime = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2256
;2255:
;2256:		VectorCopy(
ADDRLP4 84
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 84
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 84
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2260
;2257:			monster->r.currentOrigin,
;2258:			monster->monsterProgressOrigin
;2259:		);
;2260:	}
LABELV $777
line 2261
;2261:}
LABELV $705
endproc G_MonsterHitscan 200 32
proc G_MonsterFireProjectile 96 28
line 2271
;2262:
;2263:static void G_MonsterFireProjectile(
;2264:	gentity_t *monster,
;2265:	gentity_t *target,
;2266:	monsterDef_t *def,
;2267:	const char *projectile,
;2268:	int damage,
;2269:	int splashDamage,
;2270:	int splashRadius
;2271:) {
line 2281
;2272:	gentity_t *bolt;
;2273:	vec3_t start;
;2274:	vec3_t targetOrigin;
;2275:	vec3_t direction;
;2276:
;2277:	/*
;2278:	 * Hitscan branch: instant hit with tracer.
;2279:	 * projectile can be "hitscan", "rifle" or "shotgun".
;2280:	 */
;2281:	if( projectile &&
ADDRLP4 40
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $781
ADDRLP4 40
INDIRP4
ARGP4
ADDRGP4 $783
ARGP4
ADDRLP4 44
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $787
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $719
ARGP4
ADDRLP4 48
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
EQI4 $787
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $716
ARGP4
ADDRLP4 52
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 0
EQI4 $787
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $722
ARGP4
ADDRLP4 56
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 0
EQI4 $787
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 $725
ARGP4
ADDRLP4 60
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 60
INDIRI4
CNSTI4 0
NEI4 $781
LABELV $787
line 2286
;2282:		( !Q_stricmp(projectile, "hitscan") ||
;2283:		  !Q_stricmp(projectile, "rifle") ||
;2284:		  !Q_stricmp(projectile, "shotgun") ||
;2285:		  !Q_stricmp(projectile, "lightning") ||
;2286:		  !Q_stricmp(projectile, "blaster") ) ) {
line 2287
;2287:		G_MonsterHitscan(
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
line 2297
;2288:			monster,
;2289:			target,
;2290:			def,
;2291:			projectile,
;2292:			damage,
;2293:			splashDamage,
;2294:			splashRadius
;2295:		);
;2296:
;2297:		return;
ADDRGP4 $780
JUMPV
LABELV $781
line 2300
;2298:	}
;2299:
;2300:	VectorCopy(
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2305
;2301:		monster->r.currentOrigin,
;2302:		start
;2303:	);
;2304:
;2305:	if( def->movementType ==
ADDRFP4 8
INDIRP4
CNSTI4 584
ADDP4
INDIRI4
CNSTI4 1
NEI4 $788
line 2306
;2306:		MONSTER_MOVEMENT_WALKING ) {
line 2307
;2307:		start[2] += 36;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1108344832
ADDF4
ASGNF4
line 2308
;2308:	}
ADDRGP4 $789
JUMPV
LABELV $788
line 2309
;2309:	else {
line 2310
;2310:		start[2] += 8;
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2311
;2311:	}
LABELV $789
line 2313
;2312:
;2313:	VectorCopy(
ADDRLP4 28
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2318
;2314:		target->r.currentOrigin,
;2315:		targetOrigin
;2316:	);
;2317:
;2318:	targetOrigin[2] +=
ADDRLP4 28+8
ADDRLP4 28+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 2321
;2319:		DEFAULT_VIEWHEIGHT * 0.5f;
;2320:
;2321:	VectorSubtract(
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
line 2327
;2322:		targetOrigin,
;2323:		start,
;2324:		direction
;2325:	);
;2326:
;2327:	VectorNormalize(direction);
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2329
;2328:
;2329:	VectorMA(
ADDRLP4 64
CNSTF4 1103101952
ASGNF4
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 64
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 4+4
INDIRF4
ADDRLP4 64
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
line 2336
;2330:		start,
;2331:		24,
;2332:		direction,
;2333:		start
;2334:	);
;2335:
;2336:	if( projectile &&
ADDRLP4 68
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 68
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $805
ADDRLP4 68
INDIRP4
ARGP4
ADDRGP4 $807
ARGP4
ADDRLP4 72
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
NEI4 $805
line 2337
;2337:		!Q_stricmp(projectile, "rocket") ) {
line 2338
;2338:		bolt = fire_rocket(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 76
ADDRGP4 fire_rocket
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 76
INDIRP4
ASGNP4
line 2343
;2339:			monster,
;2340:			start,
;2341:			direction
;2342:		);
;2343:	}
ADDRGP4 $806
JUMPV
LABELV $805
line 2344
;2344:	else if( projectile &&
ADDRLP4 76
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 76
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $808
ADDRLP4 76
INDIRP4
ARGP4
ADDRGP4 $810
ARGP4
ADDRLP4 80
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $808
line 2345
;2345:		!Q_stricmp(projectile, "grenade") ) {
line 2352
;2346:		/*
;2347:		 * Ballistic arc: add elevation so the grenade
;2348:		 * reaches a ground target instead of hitting
;2349:		 * the floor immediately.
;2350:		 * fire_grenade itself sets trType = TR_GRAVITY.
;2351:		 */
;2352:		direction[2] += 0.35f;
ADDRLP4 16+8
ADDRLP4 16+8
INDIRF4
CNSTF4 1051931443
ADDF4
ASGNF4
line 2353
;2353:		VectorNormalize( direction );
ADDRLP4 16
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2355
;2354:
;2355:		bolt = fire_grenade(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 84
ADDRGP4 fire_grenade
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 84
INDIRP4
ASGNP4
line 2360
;2356:			monster,
;2357:			start,
;2358:			direction
;2359:		);
;2360:	}
ADDRGP4 $809
JUMPV
LABELV $808
line 2361
;2361:	else {
line 2362
;2362:		bolt = fire_plasma(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 84
ADDRGP4 fire_plasma
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 84
INDIRP4
ASGNP4
line 2367
;2363:			monster,
;2364:			start,
;2365:			direction
;2366:		);
;2367:	}
LABELV $809
LABELV $806
line 2369
;2368:
;2369:	bolt->damage = damage;
ADDRLP4 0
INDIRP4
CNSTI4 740
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
line 2370
;2370:	bolt->splashDamage = splashDamage;
ADDRLP4 0
INDIRP4
CNSTI4 744
ADDP4
ADDRFP4 20
INDIRI4
ASGNI4
line 2371
;2371:	bolt->splashRadius = splashRadius;
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
ADDRFP4 24
INDIRI4
ASGNI4
line 2373
;2372:
;2373:	VectorScale(
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
line 2379
;2374:		direction,
;2375:		def->projectileSpeed,
;2376:		bolt->s.pos.trDelta
;2377:	);
;2378:
;2379:	SnapVector(bolt->s.pos.trDelta);
ADDRLP4 84
ADDRLP4 0
INDIRP4
CNSTI4 36
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
CNSTI4 40
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
ADDRLP4 92
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
ADDRLP4 92
INDIRP4
ADDRLP4 92
INDIRP4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
line 2381
;2380:
;2381:	if( monster->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $814
line 2382
;2382:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2385
;2383:			level.time;
;2384:
;2385:		VectorCopy(
ADDRLP4 84
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 84
INDIRP4
CNSTI4 824
ADDP4
ADDRLP4 84
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2389
;2386:			monster->r.currentOrigin,
;2387:			monster->monsterProgressOrigin
;2388:		);
;2389:	}
LABELV $814
line 2390
;2390:}
LABELV $780
endproc G_MonsterFireProjectile 96 28
proc G_MonsterStartRangedAttack 72 12
line 2396
;2391:
;2392:static void G_MonsterStartRangedAttack(
;2393:	gentity_t *monster,
;2394:	gentity_t *target,
;2395:	monsterDef_t *def
;2396:) {
line 2404
;2397:	animation_t *animation;
;2398:	int variant;
;2399:	int fireFrame;
;2400:	int windup;
;2401:	vec3_t direction;
;2402:	vec3_t angles;
;2403:
;2404:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2405
;2405:	animation = &def->rangedAnimations[variant];
ADDRLP4 4
CNSTI4 28
ADDRLP4 20
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 928
ADDP4
ADDP4
ASGNP4
line 2407
;2406:
;2407:	fireFrame = def->attackFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 656
ADDP4
INDIRI4
ASGNI4
line 2409
;2408:
;2409:	if (fireFrame < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $818
line 2410
;2410:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2411
;2411:	}
LABELV $818
line 2413
;2412:
;2413:	if (animation->numFrames > 0 &&
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
LEI4 $820
ADDRLP4 0
INDIRI4
ADDRLP4 44
INDIRI4
LTI4 $820
line 2414
;2414:		fireFrame >= animation->numFrames) {
line 2415
;2415:		fireFrame = animation->numFrames - 1;
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2416
;2416:	}
LABELV $820
line 2418
;2417:
;2418:	windup = fireFrame * animation->frameLerp;
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
line 2423
;2419:
;2420:	/*
;2421:	 * Face the target when the attack animation begins.
;2422:	 */
;2423:	VectorSubtract(
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
line 2429
;2424:		target->r.currentOrigin,
;2425:		monster->r.currentOrigin,
;2426:		direction
;2427:	);
;2428:
;2429:	if( VectorNormalize(direction) > 0.0f ) {
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
LEF4 $824
line 2430
;2430:		vectoangles(direction, angles);
ADDRLP4 8
ARGP4
ADDRLP4 24
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2432
;2431:
;2432:		angles[PITCH] = 0;
ADDRLP4 24
CNSTF4 0
ASGNF4
line 2433
;2433:		angles[ROLL] = 0;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 2435
;2434:
;2435:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2440
;2436:			angles,
;2437:			monster->s.angles
;2438:		);
;2439:
;2440:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2445
;2441:			angles,
;2442:			monster->s.apos.trBase
;2443:		);
;2444:
;2445:		VectorCopy(
ADDRFP4 0
INDIRP4
CNSTI4 500
ADDP4
ADDRLP4 24
INDIRB
ASGNB 12
line 2449
;2446:			angles,
;2447:			monster->r.currentAngles
;2448:		);
;2449:	}
LABELV $824
line 2451
;2450:
;2451:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2452
;2452:	monster->monsterShotsRemaining = def->burstCount;
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
line 2453
;2453:	monster->monsterNextShot = level.time + windup;
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
line 2455
;2454:
;2455:	G_MonsterSetAnimation(
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
line 2460
;2456:		monster,
;2457:		MONSTER_STATE_RANGED,
;2458:		variant
;2459:	);
;2460:}
LABELV $817
endproc G_MonsterStartRangedAttack 72 12
proc G_MonsterStartMeleeAttack 24 12
line 2466
;2461:
;2462:static void G_MonsterStartMeleeAttack(
;2463:	gentity_t *monster,
;2464:	gentity_t *target,
;2465:	monsterDef_t *def
;2466:) {
line 2472
;2467:	animation_t *animation;
;2468:	int variant;
;2469:	int fireFrame;
;2470:	int windup;
;2471:
;2472:	variant =
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
line 2475
;2473:		rand() % MAX_MONSTER_VARIANTS;
;2474:
;2475:	animation =
ADDRLP4 4
CNSTI4 28
ADDRLP4 8
INDIRI4
MULI4
ADDRFP4 8
INDIRP4
CNSTI4 844
ADDP4
ADDP4
ASGNP4
line 2478
;2476:		&def->meleeAnimations[variant];
;2477:
;2478:	fireFrame = def->meleeFireFrame;
ADDRLP4 0
ADDRFP4 8
INDIRP4
CNSTI4 664
ADDP4
INDIRI4
ASGNI4
line 2480
;2479:
;2480:	if( fireFrame < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $829
line 2481
;2481:		fireFrame = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2482
;2482:	}
LABELV $829
line 2484
;2483:
;2484:	if( animation->numFrames > 0 &&
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
LEI4 $831
ADDRLP4 0
INDIRI4
ADDRLP4 20
INDIRI4
LTI4 $831
line 2485
;2485:		fireFrame >= animation->numFrames ) {
line 2486
;2486:		fireFrame =
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2488
;2487:			animation->numFrames - 1;
;2488:	}
LABELV $831
line 2490
;2489:
;2490:	windup =
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
line 2494
;2491:		fireFrame *
;2492:		animation->frameLerp;
;2493:
;2494:	monster->enemy = target;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
line 2495
;2495:	monster->monsterShotsRemaining = 1;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 1
ASGNI4
line 2496
;2496:	monster->monsterNextShot =
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
line 2499
;2497:		level.time + windup;
;2498:
;2499:	G_MonsterSetAnimation(
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
line 2504
;2500:		monster,
;2501:		MONSTER_STATE_MELEE,
;2502:		variant
;2503:	);
;2504:}
LABELV $828
endproc G_MonsterStartMeleeAttack 24 12
proc G_MonsterCanSeeTarget 92 28
line 2509
;2505:
;2506:static qboolean G_MonsterCanSeeTarget(
;2507:	gentity_t *monster,
;2508:	gentity_t *target
;2509:) {
line 2514
;2510:	trace_t trace;
;2511:	vec3_t start;
;2512:	vec3_t end;
;2513:
;2514:	if (!G_MonsterValidTarget(target)) {
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
NEI4 $835
line 2515
;2515:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $834
JUMPV
LABELV $835
line 2518
;2516:	}
;2517:
;2518:	VectorCopy(monster->r.currentOrigin, start);
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2519
;2519:	start[2] += 8;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 2521
;2520:
;2521:	VectorCopy(target->r.currentOrigin, end);
ADDRLP4 68
ADDRFP4 4
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 2522
;2522:	end[2] += DEFAULT_VIEWHEIGHT * 0.5f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1095761920
ADDF4
ASGNF4
line 2524
;2523:
;2524:	trap_Trace(
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
line 2534
;2525:		&trace,
;2526:		start,
;2527:		NULL,
;2528:		NULL,
;2529:		end,
;2530:		monster->s.number,
;2531:		MASK_SHOT
;2532:	);
;2533:
;2534:	return trace.fraction == 1.0f ||
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $844
ADDRLP4 0+52
INDIRI4
ADDRFP4 4
INDIRP4
INDIRI4
NEI4 $842
LABELV $844
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRGP4 $843
JUMPV
LABELV $842
ADDRLP4 88
CNSTI4 0
ASGNI4
LABELV $843
ADDRLP4 88
INDIRI4
RETI4
LABELV $834
endproc G_MonsterCanSeeTarget 92 28
proc G_MonsterRunAttack 80 32
line 2541
;2535:		trace.entityNum == target->s.number;
;2536:}
;2537:
;2538:static void G_MonsterRunAttack(
;2539:	gentity_t *monster,
;2540:	monsterDef_t *def
;2541:) {
line 2544
;2542:	qboolean meleeAttack;
;2543:
;2544:	if( monster->monsterShotsRemaining <= 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
GTI4 $846
line 2545
;2545:		return;
ADDRGP4 $845
JUMPV
LABELV $846
line 2548
;2546:	}
;2547:
;2548:	if( !G_MonsterValidTarget(monster->enemy) ||
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
EQI4 $850
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
NEI4 $848
LABELV $850
line 2552
;2549:		!G_MonsterCanSeeTarget(
;2550:			monster,
;2551:			monster->enemy
;2552:		) ) {
line 2553
;2553:		monster->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2555
;2554:
;2555:		monster->monsterNextAttack =
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
line 2559
;2556:			level.time +
;2557:			def->attackCooldown;
;2558:
;2559:		return;
ADDRGP4 $845
JUMPV
LABELV $848
line 2562
;2560:	}
;2561:
;2562:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 876
ADDP4
INDIRI4
GEI4 $852
line 2563
;2563:		monster->monsterNextShot ) {
line 2564
;2564:		return;
ADDRGP4 $845
JUMPV
LABELV $852
line 2567
;2565:	}
;2566:
;2567:	meleeAttack =
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 2
NEI4 $856
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $857
JUMPV
LABELV $856
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $857
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
line 2571
;2568:		monster->monsterAnimation ==
;2569:		MONSTER_STATE_MELEE;
;2570:
;2571:	if( meleeAttack ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $858
line 2572
;2572:		G_MonsterSound(
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
ADDRGP4 $860
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
line 2585
;2573:			monster,
;2574:			def,
;2575:			"melee",
;2576:			monster->monsterAnimationVariant
;2577:		);
;2578:
;2579:		/*
;2580:		 * meleeProjectile "none" (parser turns it into an
;2581:		 * empty string) enables instant melee via G_Damage.
;2582:		 * Any other value keeps the old projectile-based
;2583:		 * melee behavior (plasma / rocket).
;2584:		 */
;2585:		if( def->meleeProjectile[0] ) {
ADDRFP4 4
INDIRP4
CNSTI4 512
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $861
line 2586
;2586:			G_MonsterFireProjectile(
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
line 2595
;2587:				monster,
;2588:				monster->enemy,
;2589:				def,
;2590:				def->meleeProjectile,
;2591:				def->meleeDamage,
;2592:				0,
;2593:				0
;2594:			);
;2595:		}
ADDRGP4 $859
JUMPV
LABELV $861
line 2596
;2596:		else {
line 2600
;2597:			vec3_t delta;
;2598:			float dist;
;2599:
;2600:			VectorSubtract(
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
line 2606
;2601:				monster->enemy->r.currentOrigin,
;2602:				monster->r.currentOrigin,
;2603:				delta
;2604:			);
;2605:
;2606:			dist = VectorLength( delta );
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
line 2613
;2607:
;2608:			/*
;2609:			 * 1.25f tolerance: during the attack windup the
;2610:			 * target may have moved slightly; still allow the
;2611:			 * hit if it is roughly within melee range.
;2612:			 */
;2613:			if( dist <= def->meleeRange * 1.25f &&
ADDRLP4 36
INDIRF4
CNSTF4 1067450368
ADDRFP4 4
INDIRP4
CNSTI4 660
ADDP4
INDIRF4
MULF4
GTF4 $859
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
EQI4 $859
line 2617
;2614:				G_MonsterCanSeeTarget(
;2615:					monster,
;2616:					monster->enemy
;2617:				) ) {
line 2618
;2618:				G_Damage(
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
line 2628
;2619:					monster->enemy,
;2620:					monster,
;2621:					monster,
;2622:					NULL,
;2623:					monster->r.currentOrigin,
;2624:					def->meleeDamage,
;2625:					0,
;2626:					MOD_CRUSH
;2627:				);
;2628:			}
line 2629
;2629:		}
line 2630
;2630:	}
ADDRGP4 $859
JUMPV
LABELV $858
line 2631
;2631:	else {
line 2632
;2632:		G_MonsterSound(
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
ADDRGP4 $867
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
line 2639
;2633:			monster,
;2634:			def,
;2635:			"ranged",
;2636:			monster->monsterAnimationVariant
;2637:		);
;2638:
;2639:		G_MonsterFireProjectile(
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
line 2648
;2640:			monster,
;2641:			monster->enemy,
;2642:			def,
;2643:			def->projectile,
;2644:			def->projectileDamage,
;2645:			def->splashDamage,
;2646:			def->splashRadius
;2647:		);
;2648:	}
LABELV $859
line 2650
;2649:
;2650:	monster->monsterShotsRemaining--;
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
line 2652
;2651:
;2652:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $868
line 2653
;2653:		monster->monsterNextShot =
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
line 2656
;2654:			level.time +
;2655:			def->burstInterval;
;2656:	}
ADDRGP4 $869
JUMPV
LABELV $868
line 2657
;2657:	else {
line 2658
;2658:		monster->monsterNextAttack =
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
line 2661
;2659:			level.time +
;2660:			def->attackCooldown;
;2661:	}
LABELV $869
line 2662
;2662:}
LABELV $845
endproc G_MonsterRunAttack 80 32
proc G_MonsterAttack 32 12
line 2668
;2663:
;2664:static void G_MonsterAttack(
;2665:	gentity_t *monster,
;2666:	gentity_t *target,
;2667:	monsterDef_t *def
;2668:) {
line 2671
;2669:	float distanceSquared;
;2670:
;2671:	if( monster->monsterShotsRemaining > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
INDIRI4
CNSTI4 0
LEI4 $873
line 2672
;2672:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2676
;2673:			monster,
;2674:			def
;2675:		);
;2676:		return;
ADDRGP4 $872
JUMPV
LABELV $873
line 2679
;2677:	}
;2678:
;2679:	if( monster->monsterAnimation !=
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
EQI4 $875
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $875
line 2682
;2680:			MONSTER_STATE_MOVE &&
;2681:		monster->monsterAnimation !=
;2682:			MONSTER_STATE_IDLE ) {
line 2683
;2683:		return;
ADDRGP4 $872
JUMPV
LABELV $875
line 2686
;2684:	}
;2685:
;2686:	if( level.time <
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 872
ADDP4
INDIRI4
GEI4 $877
line 2687
;2687:		monster->monsterNextAttack ) {
line 2688
;2688:		return;
ADDRGP4 $872
JUMPV
LABELV $877
line 2691
;2689:	}
;2690:
;2691:	distanceSquared = DistanceSquared(
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
line 2696
;2692:		monster->r.currentOrigin,
;2693:		target->r.currentOrigin
;2694:	);
;2695:
;2696:	if( !G_MonsterCanSeeTarget(
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
NEI4 $880
line 2699
;2697:		monster,
;2698:		target
;2699:	) ) {
line 2700
;2700:		return;
ADDRGP4 $872
JUMPV
LABELV $880
line 2706
;2701:	}
;2702:
;2703:	/*
;2704:	 * Prefer melee whenever the target is close enough.
;2705:	 */
;2706:	if( def->hasMelee &&
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
EQI4 $882
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
GTF4 $882
line 2709
;2707:		distanceSquared <=
;2708:			def->meleeRange *
;2709:			def->meleeRange ) {
line 2710
;2710:		G_MonsterStartMeleeAttack(
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
line 2716
;2711:			monster,
;2712:			target,
;2713:			def
;2714:		);
;2715:
;2716:		G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2721
;2717:			monster,
;2718:			def
;2719:		);
;2720:
;2721:		return;
ADDRGP4 $872
JUMPV
LABELV $882
line 2724
;2722:	}
;2723:
;2724:	if( !def->hasRanged ) {
ADDRFP4 8
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 0
NEI4 $884
line 2725
;2725:		return;
ADDRGP4 $872
JUMPV
LABELV $884
line 2728
;2726:	}
;2727:
;2728:	if( distanceSquared >
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
LEF4 $886
line 2730
;2729:		def->attackRange *
;2730:		def->attackRange ) {
line 2731
;2731:		return;
ADDRGP4 $872
JUMPV
LABELV $886
line 2734
;2732:	}
;2733:
;2734:	G_MonsterStartRangedAttack(
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
line 2740
;2735:		monster,
;2736:		target,
;2737:		def
;2738:	);
;2739:
;2740:	G_MonsterRunAttack(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterRunAttack
CALLV
pop
line 2744
;2741:		monster,
;2742:		def
;2743:	);
;2744:}
LABELV $872
endproc G_MonsterAttack 32 12
proc G_MonsterThink 44 16
line 2746
;2745:
;2746:static void G_MonsterThink(gentity_t *monster) {
line 2751
;2747:	monsterDef_t *def;
;2748:	gentity_t *target;
;2749:	int msec;
;2750:
;2751:	def = &g_monsterDefs
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 1180
ADDRLP4 12
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5900
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
line 2755
;2752:		[monster->monsterType]
;2753:		[monster->monsterSlot];
;2754:
;2755:	G_MonsterUpdateAnimation(monster, def);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 G_MonsterUpdateAnimation
CALLV
pop
line 2757
;2756:
;2757:	if (monster->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $889
line 2758
;2758:		if (level.time >= monster->monsterDeathTime) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 852
ADDP4
INDIRI4
LTI4 $891
line 2759
;2759:			if (monsterActiveCount > 0) {
ADDRGP4 monsterActiveCount
INDIRI4
CNSTI4 0
LEI4 $894
line 2760
;2760:				monsterActiveCount--;
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
line 2761
;2761:			}
LABELV $894
line 2763
;2762:
;2763:			G_FreeEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 2764
;2764:			return;
ADDRGP4 $888
JUMPV
LABELV $891
line 2767
;2765:		}
;2766:
;2767:		monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2768
;2768:		return;
ADDRGP4 $888
JUMPV
LABELV $889
line 2771
;2769:	}
;2770:
;2771:	msec = level.time - monster->monsterLastThink;
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
line 2773
;2772:
;2773:	if (msec < 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
GEI4 $898
line 2774
;2774:		msec = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 2775
;2775:	}
ADDRGP4 $899
JUMPV
LABELV $898
line 2776
;2776:	else if (msec > 100) {
ADDRLP4 0
INDIRI4
CNSTI4 100
LEI4 $900
line 2777
;2777:		msec = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 2778
;2778:	}
LABELV $900
LABELV $899
line 2780
;2779:
;2780:	monster->monsterLastThink = level.time;
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2782
;2781:
;2782:	target = G_MonsterFindTarget(monster);
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
line 2788
;2783:
;2784:	/*
;2785:	 * During an attack, keep facing the target selected
;2786:	 * at the beginning of the attack.
;2787:	 */
;2788:	if ((monster->monsterAnimation ==
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
EQI4 $905
ADDRLP4 20
INDIRI4
CNSTI4 2
NEI4 $903
LABELV $905
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
EQI4 $903
line 2792
;2789:			MONSTER_STATE_RANGED ||
;2790:		 monster->monsterAnimation ==
;2791:			MONSTER_STATE_MELEE) &&
;2792:		G_MonsterValidTarget(monster->enemy)) {
line 2793
;2793:		target = monster->enemy;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
INDIRP4
ASGNP4
line 2794
;2794:	}
LABELV $903
line 2796
;2795:
;2796:	if (target) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $906
line 2797
;2797:		G_MonsterFaceTarget(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 G_MonsterFaceTarget
CALLV
pop
line 2802
;2798:			monster,
;2799:			target
;2800:		);
;2801:
;2802:			G_MonsterMove(
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
line 2808
;2803:				monster,
;2804:				target,
;2805:				def,
;2806:				msec
;2807:			);
;2808:		G_MonsterAttack(monster, target, def);
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
line 2810
;2809:
;2810:		if (monster->monsterAnimation == MONSTER_STATE_MOVE &&
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
NEI4 $907
ADDRGP4 level+32
INDIRI4
ADDRLP4 28
INDIRP4
CNSTI4 856
ADDP4
INDIRI4
LTI4 $907
line 2811
;2811:			level.time >= monster->monsterNextTalk) {
line 2814
;2812:			int variant;
;2813:
;2814:			variant =
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
line 2817
;2815:				rand() % MAX_MONSTER_VARIANTS;
;2816:
;2817:			G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $911
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 2824
;2818:				monster,
;2819:				def,
;2820:				"talk",
;2821:				variant
;2822:			);
;2823:
;2824:			monster->monsterNextTalk =
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
line 2827
;2825:				level.time +
;2826:				G_MonsterTalkDelay(def);
;2827:		}
line 2828
;2828:	}
ADDRGP4 $907
JUMPV
LABELV $906
line 2830
;2829:	
;2830:	else if( monster->monsterAnimation ==
ADDRFP4 0
INDIRP4
CNSTI4 844
ADDP4
INDIRI4
CNSTI4 1
NEI4 $913
line 2831
;2831:		MONSTER_STATE_MOVE ) {
line 2832
;2832:		G_MonsterSetAnimation(
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
line 2837
;2833:			monster,
;2834:			MONSTER_STATE_IDLE,
;2835:			0
;2836:		);
;2837:	}
LABELV $913
LABELV $907
line 2843
;2838:
;2839:	/*
;2840:	 * Walking monsters remain attached to the floor
;2841:	 * and fall when moving over an edge.
;2842:	 */
;2843:	G_MonsterGroundWalker(
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
line 2853
;2844:		monster,
;2845:		def,
;2846:		msec
;2847:	);
;2848:	
;2849:	/*
;2850:	 * Remember meaningful movement so an active monster
;2851:	 * is not mistaken for a lost one.
;2852:	 */
;2853:	if( monster->monsterWaveSpawn &&
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
EQI4 $915
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
LTF4 $915
line 2857
;2854:		DistanceSquared(
;2855:			monster->r.currentOrigin,
;2856:			monster->monsterProgressOrigin
;2857:		) >= 32.0f * 32.0f ) {
line 2858
;2858:		VectorCopy(
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
line 2863
;2859:			monster->r.currentOrigin,
;2860:			monster->monsterProgressOrigin
;2861:		);
;2862:
;2863:		monster->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2865
;2864:			level.time;
;2865:	}
LABELV $915
line 2867
;2866:
;2867:	trap_LinkEntity(monster);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 2869
;2868:
;2869:	monster->nextthink = level.time + 50;
ADDRFP4 0
INDIRP4
CNSTI4 688
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 50
ADDI4
ASGNI4
line 2870
;2870:}
LABELV $888
endproc G_MonsterThink 44 16
proc G_MonsterSound 68 24
line 2877
;2871:
;2872:static void G_MonsterSound(
;2873:	gentity_t *monster,
;2874:	monsterDef_t *def,
;2875:	const char *group,
;2876:	int variant
;2877:) {
line 2880
;2878:	char filename[MAX_QPATH];
;2879:
;2880:	Com_sprintf(
ADDRLP4 0
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $920
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
line 2889
;2881:		filename,
;2882:		sizeof(filename),
;2883:		"%s/%s%i.wav",
;2884:		def->soundDir,
;2885:		group,
;2886:		variant + 1
;2887:	);
;2888:
;2889:	G_Sound(
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
line 2894
;2890:		monster,
;2891:		CHAN_VOICE,
;2892:		G_SoundIndex(filename)
;2893:	);
;2894:}
LABELV $919
endproc G_MonsterSound 68 24
proc G_MonsterTalkDelay 12 0
line 2896
;2895:
;2896:static int G_MonsterTalkDelay(monsterDef_t *def) {
line 2899
;2897:	int range;
;2898:
;2899:	range = def->talkMaxDelay - def->talkMinDelay;
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
line 2901
;2900:
;2901:	if (range <= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GTI4 $922
line 2902
;2902:		return def->talkMinDelay;
ADDRFP4 0
INDIRP4
CNSTI4 696
ADDP4
INDIRI4
RETI4
ADDRGP4 $921
JUMPV
LABELV $922
line 2905
;2903:	}
;2904:
;2905:	return def->talkMinDelay + rand() % (range + 1);
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
LABELV $921
endproc G_MonsterTalkDelay 12 0
proc G_MonsterBleed 44 8
line 2912
;2906:}
;2907:
;2908:/*
;2909: * Standard flesh-hit blood spray, if the monster definition
;2910: * has blood enabled (noblood/blood 1 in monster.cfg).
;2911: */
;2912:static void G_MonsterBleed(gentity_t *monster) {
line 2918
;2913:	monsterDef_t *def;
;2914:	gentity_t *tent;
;2915:	vec3_t origin;
;2916:	int i;
;2917:
;2918:	def = &g_monsterDefs
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
CNSTI4 1180
ADDRLP4 24
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5900
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
line 2922
;2919:		[monster->monsterType]
;2920:		[monster->monsterSlot];
;2921:
;2922:	if (!def->blood) {
ADDRLP4 20
INDIRP4
CNSTI4 780
ADDP4
INDIRI4
CNSTI4 0
NEI4 $925
line 2923
;2923:		return;
ADDRGP4 $924
JUMPV
LABELV $925
line 2926
;2924:	}
;2925:
;2926:	for (i = 0; i < 3; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $927
line 2927
;2927:		origin[i] =
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 32
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 36
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 32
INDIRI4
ADDRLP4 4
ADDP4
ADDRLP4 32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
ADDP4
INDIRF4
CNSTF4 1048576000
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
ADDRLP4 36
INDIRI4
ADDRLP4 40
INDIRP4
CNSTI4 448
ADDP4
ADDP4
INDIRF4
ADDRLP4 36
INDIRI4
ADDRLP4 40
INDIRP4
CNSTI4 436
ADDP4
ADDP4
INDIRF4
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
line 2932
;2928:			monster->r.currentOrigin[i] +
;2929:			crandom() *
;2930:			(monster->r.maxs[i] - monster->r.mins[i]) *
;2931:			0.25f;
;2932:	}
LABELV $928
line 2926
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $927
line 2935
;2933:
;2934:	/* Lift blood to chest level. */
;2935:	origin[2] +=
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
CNSTF4 1056964608
ADDRLP4 28
INDIRP4
CNSTI4 456
ADDP4
INDIRF4
ADDRLP4 28
INDIRP4
CNSTI4 444
ADDP4
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 2938
;2936:		(monster->r.maxs[2] - monster->r.mins[2]) * 0.5f;
;2937:
;2938:	tent = G_TempEntity(origin, EV_BULLET_HIT_FLESH);
ADDRLP4 4
ARGP4
CNSTI4 48
ARGI4
ADDRLP4 32
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
ASGNP4
line 2939
;2939:	tent->s.eventParm = monster->s.number;
ADDRLP4 16
INDIRP4
CNSTI4 184
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 2940
;2940:	tent->s.otherEntityNum = ENTITYNUM_NONE;
ADDRLP4 16
INDIRP4
CNSTI4 140
ADDP4
CNSTI4 1023
ASGNI4
line 2941
;2941:}
LABELV $924
endproc G_MonsterBleed 44 8
proc G_MonsterPain 20 16
line 2947
;2942:
;2943:static void G_MonsterPain(
;2944:	gentity_t *self,
;2945:	gentity_t *attacker,
;2946:	int damage
;2947:) {
line 2951
;2948:	monsterDef_t *def;
;2949:	int variant;
;2950:
;2951:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $933
line 2952
;2952:		return;
ADDRGP4 $932
JUMPV
LABELV $933
line 2954
;2953:	}
;2954:	G_MonsterBleed(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_MonsterBleed
CALLV
pop
line 2956
;2955:	
;2956:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $935
line 2957
;2957:	self->monsterProgressTime =
ADDRFP4 0
INDIRP4
CNSTI4 820
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 2960
;2958:		level.time;
;2959:
;2960:	VectorCopy(
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
line 2964
;2961:		self->r.currentOrigin,
;2962:		self->monsterProgressOrigin
;2963:	);
;2964:}
LABELV $935
line 2966
;2965:
;2966:	if (level.time < self->pain_debounce_time) {
ADDRGP4 level+32
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
INDIRI4
GEI4 $938
line 2967
;2967:		return;
ADDRGP4 $932
JUMPV
LABELV $938
line 2970
;2968:	}
;2969:
;2970:	def = &g_monsterDefs
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1180
ADDRLP4 8
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5900
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
line 2979
;2971:		[self->monsterType]
;2972:		[self->monsterSlot];
;2973:			
;2974:
;2975:	/*
;2976:	 * painChance: probability (0..100) that a hit actually
;2977:	 * triggers the pain animation. 100 keeps the old behavior.
;2978:	 */
;2979:	if( def->painChance <= 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRI4
CNSTI4 0
GTI4 $941
line 2980
;2980:		return;
ADDRGP4 $932
JUMPV
LABELV $941
line 2983
;2981:	}
;2982:
;2983:	if( def->painChance < 100 &&
ADDRLP4 0
INDIRP4
CNSTI4 712
ADDP4
INDIRI4
CNSTI4 100
GEI4 $943
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
LTI4 $943
line 2984
;2984:		(rand() % 100) >= def->painChance ) {
line 2985
;2985:		return;
ADDRGP4 $932
JUMPV
LABELV $943
line 2988
;2986:	}
;2987:
;2988:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 2990
;2989:
;2990:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 2991
;2991:	self->monsterNextAttack = level.time + def->attackCooldown;
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
line 2993
;2992:
;2993:	G_MonsterSetAnimation(
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
line 2999
;2994:		self,
;2995:		MONSTER_STATE_PAIN,
;2996:		variant
;2997:	);
;2998:
;2999:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $946
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 3006
;3000:		self,
;3001:		def,
;3002:		"pain",
;3003:		variant
;3004:	);
;3005:
;3006:	self->pain_debounce_time = level.time + 700;
ADDRFP4 0
INDIRP4
CNSTI4 720
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 700
ADDI4
ASGNI4
line 3007
;3007:}
LABELV $932
endproc G_MonsterPain 20 16
proc G_MonsterDropItem 36 12
line 3009
;3008:
;3009:static void G_MonsterDropItem(gentity_t *monster) {
line 3012
;3010:	vec3_t velocity;
;3011:
;3012:	if (!monster->monsterItem ||
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
EQU4 $951
ADDRLP4 12
INDIRP4
CNSTI4 804
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 16
INDIRU4
NEU4 $949
LABELV $951
line 3013
;3013:		!monster->monsterItem->item) {
line 3014
;3014:		return;
ADDRGP4 $948
JUMPV
LABELV $949
line 3017
;3015:	}
;3016:
;3017:	if (rand() % 100 >= 50) {
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 100
MODI4
CNSTI4 50
LTI4 $952
line 3018
;3018:		return;
ADDRGP4 $948
JUMPV
LABELV $952
line 3021
;3019:	}
;3020:
;3021:	VectorSet(
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
line 3028
;3022:		velocity,
;3023:		crandom() * 60,
;3024:		crandom() * 60,
;3025:		140
;3026:	);
;3027:
;3028:	LaunchItem(
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
line 3033
;3029:		monster->monsterItem->item,
;3030:		monster->r.currentOrigin,
;3031:		velocity
;3032:	);
;3033:}
LABELV $948
endproc G_MonsterDropItem 36 12
proc G_MonsterDie 80 16
line 3041
;3034:
;3035:static void G_MonsterDie(
;3036:	gentity_t *self,
;3037:	gentity_t *inflictor,
;3038:	gentity_t *attacker,
;3039:	int damage,
;3040:	int mod
;3041:) {
line 3047
;3042:	monsterDef_t *def;
;3043:	animation_t *animation;
;3044:	int variant;
;3045:	int duration;
;3046:
;3047:	if (self->monsterDead) {
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
CNSTI4 0
EQI4 $957
line 3048
;3048:		return;
ADDRGP4 $956
JUMPV
LABELV $957
line 3051
;3049:	}
;3050:
;3051:	def = &g_monsterDefs
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1180
ADDRLP4 16
INDIRP4
CNSTI4 812
ADDP4
INDIRI4
MULI4
CNSTI4 5900
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
line 3055
;3052:		[self->monsterType]
;3053:		[self->monsterSlot];
;3054:
;3055:	variant = rand() % MAX_MONSTER_VARIANTS;
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
line 3057
;3056:
;3057:	G_MonsterBleed(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_MonsterBleed
CALLV
pop
line 3058
;3058:	self->monsterDead = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 860
ADDP4
CNSTI4 1
ASGNI4
line 3059
;3059:	if( self->monsterWaveSpawn ) {
ADDRFP4 0
INDIRP4
CNSTI4 864
ADDP4
INDIRI4
CNSTI4 0
EQI4 $959
line 3060
;3060:		monsterWaveLastProgress = level.time;
ADDRGP4 monsterWaveLastProgress
ADDRGP4 level+32
INDIRI4
ASGNI4
line 3061
;3061:	}
LABELV $959
line 3063
;3062:	
;3063:	self->s.eFlags |= EF_DEAD;
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
line 3064
;3064:	self->takedamage = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 736
ADDP4
CNSTI4 0
ASGNI4
line 3065
;3065:	self->enemy = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 768
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
line 3066
;3066:	self->monsterShotsRemaining = 0;
ADDRFP4 0
INDIRP4
CNSTI4 880
ADDP4
CNSTI4 0
ASGNI4
line 3068
;3067:
;3068:	self->r.contents = 0;
ADDRFP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 3069
;3069:	self->clipmask = 0;
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 0
ASGNI4
line 3070
;3070:	trap_LinkEntity(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 3072
;3071:
;3072:	G_MonsterSetAnimation(
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
line 3083
;3073:		self,
;3074:		MONSTER_STATE_DEATH,
;3075:		variant
;3076:	);
;3077:
;3078:	/*
;3079:	 * Optional death explosion, configured per-monster
;3080:	 * via 'deathExplosion' in monster.cfg.
;3081:	 * Supported values: rocket, grenade, plasma, bfg, none.
;3082:	 */
;3083:	if( def->deathExplosion[0] ) {
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $962
line 3084
;3084:		int explosionWeapon = WP_NONE;
ADDRLP4 28
CNSTI4 0
ASGNI4
line 3086
;3085:
;3086:		if( !Q_stricmp( def->deathExplosion, "rocket" ) ) {
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRGP4 $807
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $964
line 3087
;3087:			explosionWeapon = WP_ROCKET_LAUNCHER;
ADDRLP4 28
CNSTI4 5
ASGNI4
line 3088
;3088:		}
ADDRGP4 $965
JUMPV
LABELV $964
line 3089
;3089:		else if( !Q_stricmp( def->deathExplosion, "grenade" ) ) {
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRGP4 $810
ARGP4
ADDRLP4 36
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $966
line 3090
;3090:			explosionWeapon = WP_GRENADE_LAUNCHER;
ADDRLP4 28
CNSTI4 4
ASGNI4
line 3091
;3091:		}
ADDRGP4 $967
JUMPV
LABELV $966
line 3092
;3092:		else if( !Q_stricmp( def->deathExplosion, "plasma" ) ) {
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRGP4 $970
ARGP4
ADDRLP4 40
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
NEI4 $968
line 3093
;3093:			explosionWeapon = WP_PLASMAGUN;
ADDRLP4 28
CNSTI4 8
ASGNI4
line 3094
;3094:		}
ADDRGP4 $969
JUMPV
LABELV $968
line 3095
;3095:		else if( !Q_stricmp( def->deathExplosion, "bfg" ) ) {
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
ARGP4
ADDRGP4 $973
ARGP4
ADDRLP4 44
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
NEI4 $971
line 3096
;3096:			explosionWeapon = WP_BFG;
ADDRLP4 28
CNSTI4 9
ASGNI4
line 3097
;3097:		}
LABELV $971
LABELV $969
LABELV $967
LABELV $965
line 3099
;3098:
;3099:		if( explosionWeapon != WP_NONE ) {
ADDRLP4 28
INDIRI4
CNSTI4 0
EQI4 $974
line 3103
;3100:			gentity_t *tent;
;3101:			vec3_t snappedOrigin;
;3102:
;3103:			VectorCopy( self->r.currentOrigin, snappedOrigin );
ADDRLP4 48
ADDRFP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 3104
;3104:			SnapVector( snappedOrigin );
ADDRLP4 48
ADDRLP4 48
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 48+4
ADDRLP4 48+4
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
ADDRLP4 48+8
ADDRLP4 48+8
INDIRF4
CVFI4 4
CVIF4 4
ASGNF4
line 3106
;3105:
;3106:			tent = G_TempEntity( snappedOrigin, EV_MISSILE_HIT );
ADDRLP4 48
ARGP4
CNSTI4 50
ARGI4
ADDRLP4 64
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 60
ADDRLP4 64
INDIRP4
ASGNP4
line 3107
;3107:			tent->s.weapon = explosionWeapon;
ADDRLP4 60
INDIRP4
CNSTI4 192
ADDP4
ADDRLP4 28
INDIRI4
ASGNI4
line 3108
;3108:			tent->s.eventParm = DirToByte( tv( 0, 0, 1 ) );
ADDRLP4 68
CNSTF4 0
ASGNF4
ADDRLP4 68
INDIRF4
ARGF4
ADDRLP4 68
INDIRF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 72
ADDRGP4 tv
CALLP4
ASGNP4
ADDRLP4 72
INDIRP4
ARGP4
ADDRLP4 76
ADDRGP4 DirToByte
CALLI4
ASGNI4
ADDRLP4 60
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 76
INDIRI4
ASGNI4
line 3109
;3109:			tent->s.otherEntityNum = self->s.number;
ADDRLP4 60
INDIRP4
CNSTI4 140
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 3110
;3110:		}
LABELV $974
line 3111
;3111:	}
LABELV $962
line 3113
;3112:
;3113:	G_MonsterSound(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $980
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 G_MonsterSound
CALLV
pop
line 3120
;3114:		self,
;3115:		def,
;3116:		"death",
;3117:		variant
;3118:	);
;3119:
;3120:	animation = &def->deathAnimations[variant];
ADDRLP4 8
CNSTI4 28
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 1096
ADDP4
ADDP4
ASGNP4
line 3121
;3121:	duration = animation->numFrames *
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
line 3124
;3122:		animation->frameLerp;
;3123:
;3124:	self->monsterDeathTime =
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
line 3133
;3125:		level.time +
;3126:		duration +
;3127:		def->corpseTime;
;3128:
;3129:	/*
;3130:	 * Monster Hunt score is awarded only for a monster
;3131:	 * killed by a real player or bot client.
;3132:	 */
;3133:	if (g_monsterHunt.integer &&
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 g_monsterHunt+12
INDIRI4
ADDRLP4 32
INDIRI4
EQI4 $982
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
EQU4 $982
ADDRLP4 36
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 40
INDIRU4
EQU4 $982
ADDRLP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
LEI4 $982
line 3136
;3134:		attacker &&
;3135:		attacker->client &&
;3136:		def->scoreValue > 0) {
line 3137
;3137:		AddScore(
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
line 3142
;3138:			attacker,
;3139:			self->r.currentOrigin,
;3140:			def->scoreValue
;3141:		);
;3142:	}
LABELV $982
line 3144
;3143:
;3144:	G_MonsterDropItem(self);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_MonsterDropItem
CALLV
pop
line 3149
;3145:	/*
;3146:	 * Only classic item-bound monsters respawn independently.
;3147:	 * Wave monsters are controlled by the wave director.
;3148:	 */
;3149:	if( !self->monsterWaveSpawn &&
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
NEI4 $985
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
EQU4 $985
ADDRLP4 52
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
EQI4 $985
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
LEI4 $985
line 3152
;3150:		self->monsterItem &&
;3151:		self->monsterItem->inuse &&
;3152:		def->respawnTime > 0 ) {
line 3153
;3153:		self->monsterItem->think =
ADDRFP4 0
INDIRP4
CNSTI4 868
ADDP4
INDIRP4
CNSTI4 692
ADDP4
ADDRGP4 G_MonsterRespawnThink
ASGNP4
line 3156
;3154:			G_MonsterRespawnThink;
;3155:
;3156:		self->monsterItem->nextthink =
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
line 3158
;3157:			level.time + def->respawnTime;
;3158:	}
LABELV $985
line 3159
;3159:}
LABELV $956
endproc G_MonsterDie 80 16
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
skip 3456
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
skip 35400
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
LABELV $980
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $973
byte 1 98
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $970
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 0
align 1
LABELV $946
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $920
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
LABELV $911
byte 1 116
byte 1 97
byte 1 108
byte 1 107
byte 1 0
align 1
LABELV $867
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $860
byte 1 109
byte 1 101
byte 1 108
byte 1 101
byte 1 101
byte 1 0
align 1
LABELV $810
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $807
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $783
byte 1 104
byte 1 105
byte 1 116
byte 1 115
byte 1 99
byte 1 97
byte 1 110
byte 1 0
align 1
LABELV $725
byte 1 98
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $722
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
LABELV $719
byte 1 114
byte 1 105
byte 1 102
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $716
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $452
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
LABELV $410
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
LABELV $409
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
LABELV $408
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
LABELV $407
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
LABELV $399
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
LABELV $397
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
LABELV $396
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
LABELV $395
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
LABELV $382
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
LABELV $260
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
LABELV $251
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
LABELV $250
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
LABELV $229
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
LABELV $224
byte 1 119
byte 1 97
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $219
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
LABELV $210
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
LABELV $205
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
LABELV $200
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
LABELV $192
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
LABELV $188
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
LABELV $184
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
LABELV $177
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
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 82
byte 1 111
byte 1 99
byte 1 107
byte 1 101
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
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 70
byte 1 108
byte 1 121
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
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
byte 1 66
byte 1 108
byte 1 97
byte 1 115
byte 1 116
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
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
byte 1 101
byte 1 114
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
byte 1 84
byte 1 114
byte 1 111
byte 1 111
byte 1 112
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
byte 1 70
byte 1 114
byte 1 111
byte 1 115
byte 1 116
byte 1 97
byte 1 116
byte 1 114
byte 1 111
byte 1 110
byte 1 97
byte 1 99
byte 1 104
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
byte 1 71
byte 1 117
byte 1 110
byte 1 110
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
byte 1 83
byte 1 116
byte 1 114
byte 1 111
byte 1 110
byte 1 103
byte 1 70
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
byte 1 70
byte 1 108
byte 1 121
byte 1 105
byte 1 110
byte 1 103
byte 1 71
byte 1 117
byte 1 97
byte 1 114
byte 1 100
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
byte 1 72
byte 1 111
byte 1 118
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
byte 1 70
byte 1 108
byte 1 121
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
