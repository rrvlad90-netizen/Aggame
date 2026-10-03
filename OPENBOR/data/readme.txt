Generic Player Properties
ajspecial (bi)

Determines the input for special attacks and whether or not players can block attacks.
0 = players use their special with the special key they have assigned and they cannot block.
1 = players can use the input for ATTACKBOTH as a special attack. They can also use a block animation, which will be used when the special attack button is pressed.
If you set 1 but the player does not have a block animation, they can use their special with both the special key and ATTACKBOTH.

autoland {int}

{int} is either 0, 1, or 2, and changes how entities can land after being thrown.
0 (default) = Players can press up and jump when hittting the ground after being thrown by another player or an enemy to land safely.
1 = they can use up and jump for a safe landing when thrown by an enemy, but automatically land safely if thrown by another player. Pits will still be a danger, of course.
2 = players can't use a safe landing at all.

nocost {bi}

Determines how player's special and freespecial attacks costs life.
0 = they always costs life whether they hit something or not
1 = only lose life if they hit something

nolost {bi}

Controls whether or not players will drop the weapon they are holding when grabbing an enemy.
0 = players will drop their weapon while grabbing (default). Same result if no value is given.
1 = players won't drop their weapon while grabbing.

noaircancel {int}

Sets whether players can cancel their jumpattack with other jumpattacks or not.
In case you don't know, you can cancel a jumpattack by pressing command for other jumpattack. For instance, while performing JUMPATTACK2, pressing attack will cancel the move and player performs JUMPATTACK.
0 = Cancellation is possible (default)
1 = Cancellation is only possible after last jumpattack is finished
2 = Cancellation is not possible at all

combodelay {int}

This command sets interval time between attacks in default combo to perform combo attack by tapping attack button.
Default to 100 which means 50 centiseconds. It means if player press attack button 2 seconds after 1st attack connects, the 2nd attack won't be a combo. However, if it's pressed almost half second later, 2nd attack will be combo
Great to disable cheap infinite combo!
offscreen_noatk_factor {bi}

This command determines the ability of an entity to be able to attack while off screen. Useful to prevent entities that use ranged attacks like shots for example, they can attack without being in the visible area.
0 Means that the entity can attack outside the visible area (default)
1 Means that the entity CAN NOT attack outside the visible area.
Generic Blocking Properties
blockratio {bi}

If this is set, blocking will not completely nullify damage. The entity will take one forth of original damage instead

mpblock {bi}

If this is set, damage from blocking will consume MP instead of health. If player is running out of MP, the damage will take health.
blockratio needs to be set before using this.

nochipdeath {bi}

If this is set, entities can't die by blockdamage (damage from blocking).
blockratio needs to be set before using this.
Entities health can be reduced to 1 health with this the next successful blocks won't take any health.
blockback {bi}

Flag to determine if attacks can be blocked from behind.
0 (default) = Entities can not block attacks from behind.
1 = Block attacks are possible
Select Screen Properties
colourselect {bi} {bi}

{bi} is a binary value.
0 = you can't change your character's palette.
1 = you can change your character's palette on the select screen by pressing up and down to cycle through the remaps.
If a remap is used for a character's 'fmap' or some remaps are hidden with 'hmap', they will not be selectable.
That's "colour" with a u, not "color". Some countries spell it different ways.

spdirection {b1} {b2} {b3} {b4}

Sets the facing direction of players in select menu.
0 = facing left.
1 = facing right.
{b1} is for player 1, {b2} is for player 2 and so on.
Default is 1 0 1 0.
Miscellaneous
nodropen

Setting this command makes enemies not knocked down on respawn. Normally when player respawns, all enemies onscreen are knocked down (no damage though).
This command doesn't take any argument. Declaring it is enough to set it.

forcemode {bi}

Sets whether the mode specified in models.txt is switchable or not.
0 = the mode can be switched in options menu.
1 = the mode can't be switched {default}.

versusdamage {bi}

Sets whether players can hit each other or not. This overrides options menu.
0 = players can't hit each other.
1 = players can hit each other.

nocheats {bi}

Sets cheat's allowance in this mod
0 = Cheats are allowed
1 = Cheats are forbidden
Those who like fair play should use this ;).

nodropspawn {bi}

When it is on, the spawn position will be restricted to spawn entry setting.

nodebug {bi}

in models.txt. set nodebug 1 to disable debug menu in options
Attack types & animation limit
If you are receiving an error "Invalid animation name line xxx" , you need to rise the value of the max animations you use for each type. For example, if you have MAXFOLLOWS 4 and try to use FOLLOW10, you will receive that error and you need to change the MAXFOLLOWS to 10. No need to change the others if you aren't using more animations than the max value.

maxattacks {max}

Sets the maximum number of normal attacks animation i.e ATTACK1, ATTACK2 etc.
{max} is number of available animations.
Default is 4.

maxattacktypes {max}

Sets the maximum number of attack types.
PAIN,FALL, RISE, BLOCKPAIN and DEATH animations limit is also set together with this.
{max} is number of available types.
Default is 10 & maximum value is 99.

maxfollows {max}

Sets the maximum number of followup animations i.e FOLLOW1, FOLLOW2 etc.
{max} is number of available animations.
Default is 4.

maxfreespecials {max}

Sets the maximum number of free specials.
{max} is number of available free specials.
Default is 8.

maxidles {max}

Sets the maximum number of IDLEs.
{max} is number of available IDLEs.
Default is 1.

maxwalks {max}

Sets the maximum number of WALKs.
{max} is number of available WALKs.
Default is 1.

maxbackwalks {max}

Sets the maximum number of BACKWALKs.
{max} is number of available BACKWALKs.
Default is 1.

maxups {max}

Sets the maximum number of UPs.
{max} is number of available UPs.
Default is 1.

maxdowns {max}

Sets the maximum number of DOWNs.
{max} is number of available DOWNs.
Default is 1.
Bonus
lifescore {int}

Determines how many score points players must earn to get one life or 1Up.
Default value is 50000.
Set this to big value to prevent players from getting life from points.
DO NOT set this to 0 otherwise you'll get crash when hitting enemy.
credscore {int}

Determines how many score points players must earn to get one credit or continue.
Default value is unknown. But by default players won't get credit from score.
Set this to big value to prevent players from getting credit from points.
DO NOT set this to 0 otherwise you'll get crash when hitting enemy.

nomaxrushreset {int}

Determines whether maximum hit counter (max rush) is resetted or not.
0 = Max rush is resetted if player loses a life or continue
1 = Max rush isn't resetted if player loses a life but still resetted if player continues
2 = Max rush isn't resetted if player loses life or continues
Load & Know
These 2 commands are used to load entities in OpenBoR. However they don't work the same way, read their description below about it.
Each command loads one entity so that means you have to declare these commands more than once to load many entities.
Any order of these will do but it's recommended to group which ones for flashes, heroes etc. You can give # and comment to describe what each group loads.

load {name} {path}

{name} is a name that the game will use to identify the entity.
{path} is the location relative to OpenBoR of the entity's .txt file.
The entity is always loaded when OpenBoR starts and will always be in memory.
Used for flashes, heros, weapon-holding heros, and hero's projectiles.

know {name} {path}

{name} is a name that the game will use to identify the entity.
{path} is the location relative to OpenBoR of the entity's .txt file.
These entities are only loaded to memory when actually needed or to be exact when levels load them.
Used for everything but flashes and heroes.

You don't need to load music, sound, system, or stage files with these commands. This is used only for entities.




AI!!!!!!!!!!!!!!!!!!


Entity Interaction
aggression {value}

For enemies, this command modifies pausetime for enemy before they attack after player is within attack range.
Positive value reduces pausetime making the enemy reacts faster.
Negative value increase pausetime making the enemy reacts slower.

hitenemy {canhit} {alt}

For enemy's projectile entities.
If {canhit} is 1, this entity can hit other enemies, even if they threw this. Obviously, it still can hit players as well.
If {canhit} is 0 or left out, this entity can only hit heros.
If this entity is thrown as a bomb, it won't be able to hit the enemy who threw it until AFTER it explodes.
{alt} determines when this entity can hit other enemies: 0 means it can hit either while in air or on the ground. 1 means the attack can only hit on the ground.

aimove {type}

This command sets enemy's walk AI. IOW it sets how enemy walks around in evels.
Default AI is enemy will go after player or other entity he/she/it is hostile to
Accepted types for {type} are:
Chase = Enemy will always chase player and this allows enemy to use RUN and RUNATTACK if enemy has it.
Chasex = Enemy will chase player but it only lines up enemy's X axis with player's.
Chasez = Enemy will chase player but it only lines up enemy's Z axis with player's.
Avoid = Enemy will always avoid player.
Avoidx = Enemy will always avoid player but enemy only avoids lining up X axis with player's.
Avoidz = Enemy will always avoid player but enemy only avoids lining up Z axis with player's.
Wander = Enemy walks without certain destination (hence the name).
Boomerang = Enemy assume a boomerang moving.
* Accepted 2nd params for {type} are:

Ignoreholes = Enemy walks without ignoring holes. This makes enemy walks to holes stupidly.
Notargetidle = Enemies ignore players when players are in idle animation.
Example: aimove chase notargetidle
Can be declared more than once but combine proper ones. avoid and chase are bad combination but avoidx and chasez are good one

hostile {type1} {type2} ...

Optional.
Specifies what types an AI controlled entity will attack and what entities a projectile with the chase subtype will seek (this does not determine what the entity can hit, only what it will intentionally attack).
Accepted types are enemy, player, npc, obstacle, shot and you can use as many as you need. If you want entity to be hostile to nothing, just set 'none' here.
Be aware if you use this setting, you must provide all types you wish this entity to be hostile towards. That is to say, an enemy with ‘hostile npc obstacle’ will only attack npc and obstacle types, not players.
Also 'stealth' feature below affect if the entity will target certain other entities or not.

candamage {type1} {type2} ...

Optional.
Specifies what types this entity can hit (very similar to hostile, but determines what entity may hit, not what it will intentionally target).
Available types are enemy, player, npc, obstacle, shot and you can use as many as you need. If you don't want entity to hit anything, just set 'none' here.
Be aware if you use this setting, you must provide all types you wish this entity to be able to hit. That is to say, an enemy with ‘candamage npc obstacle’ will be able to hit npc and obstacle types, not players.

projectilehit {type1} {type2} ...

Optional.
Do not let the name confuse you, this is not for projectiles. This
setting specifies what types this entity will hit when thrown from a grab. * Available types are enemy, player, npc, obstacle, shot and you can use as many as you need. If you don't want entity to hit anything, just set 'none' here.

Be aware if you use this setting, you must provide all types you wish this entity to be able to hit when thrown. That is to say, an enemy with ‘projectilehit player’ will only hit players when thrown, not other enemies.

stealth {stealth} {perception}

This command sets stealth ability to entity
{stealth} defines how 'invisible' the entity to hostile entities. Default value is 0
{perception} defines how well entity can see stealth entities. Default value is 0
For instance, entity with {stealth} 2 is only 'visible' to hostile entities with {perception} 2 or higher
This command doesn't affect visual at all IOW entity is still visible to players

attackthrottle {rate} {time}

rate: chance to cancel attack (must be between 0.0 and 1.0)
time: in seconds, how long should this entity stay tame until next check, the engine will generate a random number between 0 and this value.
note: some action will cancel the timer, for example, getting hit. Seeing the target block or attacking will also affects the timer. A value of 0.5-0.75 should be OK.
the idea is to allow using high aggressive settings to give the AI super quick initial "reflexes" but still enough delay between subsequent attacks to avoid unbeatable cheapness

boomerangvalues {acceleration} {horizontal_distance}

acceleration: the float value for de/acceleration of the boomerang
horizontal_distance: the float value max distance from the spawner and boomerang
speed of boomerang you can set manually (write speed {float}) or by default is 2.0!!
Palette
remap {path1} {path2}

Allows you to create alternate palletes for entities.
Each entity can have up to 14 palletes.
{path1} is a sprite of an entity in their normal pallete. {path2} is a sprite of the entity in an alternate pallete.
You should not change the file's pallete. The only changes should be to the pixels in the image, not the pallete data.
Player 2 normally uses the first alternate pallete, but both players can select their color when choosing a character with up and down if the colourselect option is on.
If your entity has sprites with incorrect colors in alternate palletes, the entity may use colors which are not in {path1}. Check the frames with incorrect colors and compare them. Then just add the colors somewhere in {path1} and the new colors in the same position in {path2}. If that sounds confusing, look at K9999's remaps. That's what I mean.
In truecolormode (see video.txt above), this command works same way.

fmap {int}

{int} determines which remap to use by the entity if it gets frozen by an freeze attack (See 'freeze' for more info about freeze attack).
You have to declare that remap with 'remap' before using this obviously.
If hero has 'fmap' set, the respective remap can't be selected at select screen and continue option.
If enemy has 'fmap' set, the respective remap can be used in levels. You might want to avoid using the remap unless you want to see Icemen on your levels.

palette {path}

This is to set default palette for this entity. ONLY compatible with truecolor mode (see video.txt above)!.
{path} is the location of the image whose palette will be used as default palette. The {path} is relative to OpenBoR.
If truecolor mode is set but this command is not declared, the 1st image/frame of the entity will be used instead.
Usually used in conjunction with 'alternatepal' below. But sometimes it can be used to change default palette entity is using
If path is set to none, alternate palettes are ignored and allows each frame (see 'frame' in animation data below) to use its own palette
Useful to create effect libraries without having to design public palette for all of those effects

alternatepal {path}

This is to set alternate palette for this entity. ONLY compatible with truecolor mode (see video.txt above)!.
{path} is the location of the image whose palette will be used as alternate palette. The {path} is relative to OpenBoR.
Used in conjunction with 'pallette' above.

hmap {a} {b}

Hides entity's remap from being selected (in select screen for players). The remaps can still be used with other features, like forcemap or script.
Hidden remaps are from ath remap to bth remap.
For example 'hmap 3 6', hides 3th, 4th, 5th and 6th remap.

globalmap {int}

This command sets independent palette use for mods with 16/32 bit colormode.
0 = Entity has it's own palette.
1 = Entity uses global palette.

KOMap {map} {flag}

Used to change entity's remap when KO'ed or killed.
{map} is the remap number to be applied.
{flag} determines when exactly remap will be applied:
0 = Remap is applied as soon as entity touches the ground
1 = Remap is applied at the last frame of last FALL or DEATH animation
Shadow & Effects
shadow {int}

{int} is a number from 0 to 6.
Each number corresponds to a specific shadow in the SPRITES folder.
Normally, the lower numbers are smaller.
This determines which shadow graphic will appear centered at this entity's offset point.
0 means there won't be a shadow.

aironly {bi}

If set to 1, this character's shadow will only be visible when it is off the ground (jumping, falling, etc.)

gfxshadow {int} {shadowbase}

Changes entity's shadow effect.
0 = (default) Use generic shadow set.
1 = Use entity's current frame for the shadow. Yes, the shadow will be more realistic with this. The angle and length of shadow is defined by 'light' (see below).
{shadowbase} controls how the shadow works in platforms (4287+)
gfxshadow 1 = default gfxshadow
gfxshadow 1 0 = default gfxshadow
gfxshadow 1 1 = no shadow changes on platform/basemap (old builds)
gfxshadow 1 2 = 2D-like shadow (like platform games)
gfxshadow 1 3 = combination 1+2
handable via script with new "shadowbase" prop in entityproperty


alpha {int}

If set to 1, this entity will be displayed with alpha transparency.
If set to 2, this entity will use negative alpha transparency (the darker colors are stronger, like shadows).
If set to 3, this entity will overlay transparency. It's described in the engine as being a combination of alpha and negative alpha, and the formula is "bg<128 ? multiply(bg*2,fg) : screen((bg-128)*2,fg)".
If set to 4, this entity will use hardlight transparency. Seems to be the opposite of overlay. The formula is "fg<128 ? multiply(fg*2,bg) : screen((fg-128)*2,bg)".
If set to 5, this entity uses dodge transparency. Described in the code as being "Very nice for a colourful boost of light."
If set to 6, this entity will use 50% transparency. The entire entity will be 50% transparent: every pixel will be averaged with the pixel right behind it.
In 8bit colormode, this setting DOES NOT work with remaps. You need 16bit or 32bit color mode to use this together with remaps.

parrow {path} {x} {y}

When a player respawns, the image at {path} will flash over the player at {x},{y} compared to their offset.
The image will be visible for as long as the player is invincible after respawning (determined with makeinv).
I use -48 -130 for mine. You'll probably want yours to be somewhere around there, but I doubt you're using the exact same image and entity, so experiment.

parrow2 {path} {x} {y}

If player 2 is playing, and respawns, this will appear instead of parrow. You could just use parrow over again, or you could use something to mark that this is Player 2, not Player 1.

diesound {path}

{path} points to a .wav file that plays if the entity is defeated.
It is also played if entity is killed instantly with lifespan or script.

setlayer {int}

This entity will be displayed as if it were at z position {int}, regardless of it's actual position.
Projectiles
load {name}

This forces engine to load other entity into memory so the entity can be used.
{name} is name of loaded entity.
Normally it's used for projectiles but it can be used to load any 'known' entity especially if the entity is never spawned anywhere in level. Useful to load entities which are spawned by commands such as 'throwframe' and 'spawnframe'.
Before using this, the entity must be declared with 'know' in models.txt.

playshot {name}

{name} is the name of an entity.
The player shoots this with pshotframe #.
This does exactly the same thing as a specifying {name} as a knife. Note: As of version 2.0691, playshot is no longer supported. Use knife instead.

playshotno {name}

{name} is the name of an entity.
The player shoots this with 'pshotframe #'.
Difference with 'playshot' is that the shot entity won't fly forward or in other word, it will stay on ground and not moving. That means it can fall to holes.
That also means setting a in 'pshotframe' is useless.

knife {name}

Used like "load". {name} will be thrown like a knife.
You'll need to use "load {name} {path}" instead of "know {name} {path}" when declaring the projectile in models.txt.
Knives can't be used by enemies during a jump. Stars are currently thrown instead.

boomerang {name}

Used like "load". {name} will be thrown like a boomerang.
You'll need to use "load {name} {path}" instead of "know {name} {path}" when declaring the projectile in models.txt.

star {name}

Used like "load". {name} will be flung like a ninja star in a jump.
This command actually causes three stars to be thrown at three different angles.
You'll need to use "load {name} {path}" instead of "know {name} {path}" when declaring the projectile in models.txt.
Stars can only be used during a jump.

bomb {name} pbomb {name}

This command is different for players and enemies. Players should use "pbomb" and enemies should use "bomb".
Used like "load". {name} will be tossed out like a grenade.
Bombs start off playing their IDLE animation until one of three things happens:
1: The bomb touches an entity
2: The bomb is hit by an attack
3: The bomb touches the ground
After 1 or 2, the bomb will play it's ATTACK2 animation.
After 3, the bomb will play it's ATTACK1 animation.
After playing it's attack animation, the bomb will disappear.
Bombs are thrown in an arc determined by their speed and their jumpheight.
You'll need to use "load {name} {path}" instead of "know {name} {path}" when declaring the projectile in models.txt.

rider {name}

For 'subtype biker' enemies.
{name} should be the name of an enemy in MODELS.txt.
When the bike is attacked, this entity will fall off.
Defaults to "K'" (Yes, with an apostrophe ')
If the rider is only loaded with 'know' in models.txt, you should add 'load {name}' in this biker text to ensure that the 'rider' will fall off.
Flash
flash {name}

{name} is the name of flash animation this entity will use. Defaults to "Flash".
This is played when this entity is hit, not when it hits another entity.
'noatflash' is required to make this command is activated.

bflash {name}

{name} is the name of flash animation this entity will use. Defaults to "Flash".
This is played when this entity blocks an attack.

dust {fall} {land} {jump}

This command defines what dust entity which will be dropped by this entity on certain conditions below.
Dust is another type of flash which falls instead of floating. To make one, simply make dust animation and declare it in models.txt just like flashes.
{fall} is the dust dropped when entity landed on ground after being knocked down.
{land} is the dust dropped when entity landed after normal jump. Doesn't include animations with 'jumpframe' or script based jumping.
{jump} is the dust dropped when entity jumps with normal jump. Doesn't include animations with 'jumpframe' or script based jumping.
If {fall} is the only one defined, the dust will also be dropped while landing but not while jumping.

toflip {bi}

Used for hitflashes.
If {bi} is 0, this hitflash will always face the same direction when spawned. If set to 1, the hitflash will flip when the attack comes from the other side.

noatflash {bi}

When {bi} is 1, this entity will always play it's personal 'flash' when hit, instead of the attacker's. Useful for obstacles.
Offense & Defense
com {input1} {input2} ... {input15} freespecial{#}

Allows you to customize freespecial input commands.
The {#} should be the number of the freespecial you want to change. You can leave it blank for 1 or use 2 though 8 for 2 through 8. There is no space between freespecial and {#}.
If you want to define this command for freespecial9 or higher, make sure
'maxfreespecial' (see models.txt above) has been set.

{input#} defines which key must be pressed. It can be direction or action keys
Accepted direction inputs are:
U: Up
D: Down
F: Forward
B: Back (The direction opposite your current direction. If used, the character will turn around.)
Accepted action inputs are:
A: Attack button
A2: Attack button2
A3: Attack button3
A4: Attack button4
J: Jump button
S: Special attack button
K: Alternate special attack button
You can define same input multiple times if you want to, example: F F A
You can use either S or K for the special attack button commond. You can only use one or the other, so pick one and stick with it. This was done so that modders who use the special key for blocking can remember the key is used to blocK, not use Specials. (B would have been used, for Block, but B is already used for Back.)
Make sure that you don't have any conflicts with other commands. RUN, DODGE, and the directional ATTACKs all have inputs which can be the same as freespecials.
If you use B for {dir1}, flip the next input. The player changes direction, remember? So B, F, A would be 'turn around, move forward, attack', but since you turned around first, moving forward would mean moving in the direction you just turned to. If you wanted to have an input like Street Fighter's Guile or Charlie's Sonic Boom, you'd need to use B, B, A instead of B, F, A.
{input1} now accepts "+" to add mutiple commands. Examples:
a + a2
u + f a
u + f -> a
"->" symbol useful just for better reading

atchain {number} {number} {number} {number} {number} ...

Determines the attack chain order for player. The attack chain only starts if the first attack hits though. Also if player takes too long before pressing attack to combo, the attack chain will reset to 1st.
The maximum length is 12. How they are used are determined by 'combostyle' below.
{number} can be anything from 1 to 12. 1 refers to ATTACK1, 2 to ATTACK2 and so on. Note: before using number 5 to 12, set 'maxattacks' to 12 1st. See 'maxattacks' above.
You can repeat the same number if you need to.
You don't have to use all of them. Setting something like 'atchain 1 3 2' works.
Default combo is 'atchain 1 1 2 3'.

combostyle {bi}

Controls how 'atchain' works.
0 = (Default) Static combo system
1 = Dynamic combo system
2 = Free combo system
With 'combostyle 1', various attack chain can be set with this command. For instance, 'atchain 1 2 5 0 3 3 6 0 4 0' have 3 kinds of attack chain in it.
The attack chains are selected by 'range' specified in respective attack (excluding ATTACK1). In above example, if ATTACK2 can't reach target, attack chain will switch to ATTACK3. If the latter hits, the attack chain becomes '1 3 3 6'. If the latter misses, attack chain will switch to ATTACK4.
With 'combostyle 2', attack chain will be performed even if none of the attacks connects (Streets of Rage 3 style)

offense {type} {factor}

Modifies damage output of given attack type by {factor}.
For example: "offense shock 0.5" will decrease shock attacks to 50%, whereas "offense burn 1.5" will increase burn attacks to 150%.
{factor} could be negative and make the attack give HP instead. For example: -1 makes the attack to give HP to opponent instead of damaging.
Accepted types are:
all (all attacktypes are affected)
normal# (replace # with appropriate attacktype number)
shock
burn
steal
blast
freeze (only affects damage, freeze effect remains)

defense {type} {factor} {pain} {knockdown} {blockpower} {blockthreshold} {blockratio} {blocktype}

Modifies damage received by given attack type by {factor}.
For example: "defense normal3 0.6" will decrease attack3 damage to 60%, whereas "defense blast 1.4" will increase blast damage to 140%.
{factor} could be negative and make the damage restore HP instead. For example: -1 makes the entity regains HP from the respective attack instead being damaged.
Accepted types are exactly sames with 'offense' (see above).
{pain} is for setting 'nopain' (see above) effect just for this {type}. If received damage (with same type) is less than {pain}, entity won't be in PAIN (like nopain) however if damage is higher, entity will play PAIN
{knockdown} works with 'knockdowncount' (see above) and attackbox{#}'s {power} (see Animation Data below). Incoming attack's (with same type) knockdown effect or {power} will be multiplied with {knockdown} before it effects entity. For instance, with 'knockdown = 0.5', it would half knockdown effect from attacks of this type.
{blockpower} works with attack{#}'s {unblockable} (see Animation Data below). If {blockpower} exceeds the latter's value, this entity can block attacks of this type.
{blockthreshold} works just like 'thold' (see above) but just for this type. If received damage (with same type) is higher than {blockthreshold}, entity can't block the attack.
{blockratio} works just like 'blockratio' (see above) but just for this type except that this sets ratio instead. For instance, 'blockratio = 0.5' makes blocked attack (of this type) deals half damage.
{blocktype} works just like 'mpblock' (see above) but just for this type except that this sets which resource will take the damage instead.
-1 = HP only
0 = Use global 'mponly' setting
1 = MP then continue to HP if MP reaches 0
2 = Both MP and HP

blockodds {int}

{int} is a number from 1 to 2147483647. It determines how often an enemy will block an attack.
1 means they'll block almost all attacks. 2147483647 means they pretty much never, ever, ever block, ever.
Enemies can't block during attacks so don't hesitate using this ;).

thold {int}

{int} is the threshold for an entity's blocking ability.
If the entity tries to block an attack with an attack power higher than {int}, they will not be able to do so and will get hit anyway.
If {int} is 0, an entity will have infinite threshold. In other words, they can block any attacks.
Regardless of threshold, if an attack is set to be unblockable, it can't be blocked.

blockpain {int}

Determines how strong entity blocks incoming attack during blocking.
If the attack's damage are lesser than {int}, entity continue blocking however if the damage is bigger or same as {int}, entity plays BLOCKPAIN animation.
Use this with BLOCK animation of course.

nopassiveblock {bi}

Normally when AI controlled entities block a string of attacks, the odds of blocking each incoming hit are always treated separately. With nopassiveblock set to 1, the AI will behave more like a player and hold the block position if hit while blocking a previous attack.
Previous versions of the manual state this property also causes the AI to block "actively", defending itself from attacks that pass close by. This is not true. The AI will never attempt to block an attack that doesn't actually hit.
Obviously entity who use this must have block ability.

holdblock {int}

Determines whether holding special button will make player play his/her block animation once or continuously.
0 = (default) Once. Once the block animation is complete, entity returns to idle.
1 = Continuously until BLOCKPAIN. Holding special button makes player block continuously (block animation holds at its last frame) until button is released or entity assumes a BLOCKPAIN animation (and while in Blockpain,you are still considered blocking.). Once a BLOCKPAIN completes, entity returns to idle.
2 = Continuously. Holding special button makes player block continuously until button is released. After a BLOCKPAIN animation, entity continues to block.
Use this command with block ability of course. Work in conjunction with Blockpain animations.

guardpoints {int}

Defines amount of guardpoints this entity has.
When this entity successfully blocks an attack, guardpoints will be subtracted by that attack's guardcost.
If guardpoints reaches 0, the next block attempt will fail and entity will be forced to play GUARDBREAK animation. The received attack is still blocked though.
Guardpoints will autorecover over time whose recovery time is defined by 'guardrate' below.
This feature works with BLOCK animation and custom blocks with script.

guardrate {int}

Defines recovery rate of 'guardpoints' above. Default value is 2.
Use with 'guardpoints' of course.

offscreen_noatk_factor {bi}

This command determines the ability of an entity to be able to attack while off screen. Useful to prevent entities that use ranged attacks like shots for example, they can attack without being in the visible area.
0 Means that the entity can attack outside the visible area (default)
1 Means that the entity CAN NOT attack outside the visible area.
If set offscreen_noatk_factor in entity.txt it overwrite offscreen_noatk_factor set in models.txt
Reaction
nopain {bi}

Used to make the character not playing his/her PAIN animation when hit by a non-knockdown attack. He will continue what he is doing when attacked.

nodrop {int}

Determines entity's resistance to knockdown attacks.
0 = Entity can be knocked down (default)
1 = Entity can't be knocked down. Can still be knocked down if hit in midair.
2 = Entity can't be knocked down even if hit in midair.
This entity will play corresponding PAIN animation if knockdown attack hits him/her/it. For instance, attack3 will make this entity play PAIN3 even if it's a knockdown attack.
Throwing with THROW can still knockdown this entity.
If this entity dies, he/she will play FALL animation or DEATH if it's available and set.

knockdowncount {int}

This setting makes entity more resistent to knockdown attacks. To knock down this entity, either 'attack' with same or higher power than {int} or {int} consecutive knockdown attacks must hit this entity.
If the above requirements is not fulfilled, the entity will play PAIN animation instead if hit by an attack. Played PAIN animation correspond to attacktype that hits the entity.
If {int} = -1, the entity will always be knocked down even if hit by non knockdown attack.

remove {bi}

Only works for projectiles. Defaults to 1.
1 = the projectile will be destroyed when it hits an enemy.
0 = the projectile continues flying even after hitting an enemy.

escapehits {int}

For enemies
If you give this to an enemy, the enemy will perform SPECIAL2 when they get hit by int+1 hits. Don't forget to give the enemy anim SPECIAL2 if you're using this.
In case you haven't figured out, this feature is to make enemy counter attacks after they get certain number of consecutive hits.
The counter will reset if enemy plays any animation EXCEPT IDLE, FAINT and PAIN. The counter works even with grabattacks.

nodieblink {int}

Sets how entity's death animation is played.
0 = entity starts blinking as soon as entity die in respective FALL animation.
1 = entity won't blink until after the last frame of entity's FALL or DEATH animation when killed.
2 = entity won't blink at all during death, and entity will disappear after the last frame of their death animation.
3 = entity will play it's death animation without blinking, and will not disappear until scrolled offscreen. The enemy won't count towards 'group's after dying, even though they don't disappear. This setting ONLY works for enemies.

makeinv {int} {bi}

Determines whether or not the character is briefly invincible after being respawned. Otherwise, traps and enemies may be able to attack the player as they reappear- not nice.
(int) is how many seconds the player will be invincible for.
(bi) is flag which sets blinking
0 = Blinking (default)
1 = No blinking
{int} also controls how long the parrow and parrow2 are visible.
You can also use makeinv in item type entities. This will create an item that gives the player {int} seconds of invincibility , much like a star in Mario.

falldie {value} or death {value}

Determines how DEATH animation will be played when the character dies.
0 = fall, blink on ground then disappear without playing DEATH at all (default).
1 = No FALL animation, DEATH animation will be played right after final blow
2 = Fall first then play DEATH animation.
MAKE SURE that the character have DEATH animation when using this!

risetime {rise} {riseattack}

Model header. Modifies default delay for entity getting up or performing RISEATTACK after being knocked down. The default rise delay is 200, while a RISEATTACK has no delay at all.
{rise} is rising speed. Reduces time in centiseconds of the delay before rising. Use negative values to increase the delay.
{riseattack} is rise attack speed. Reduces time in centiseconds of the delay before a RISEATTACK can be performed. Use a negative value to increase rise time. Speeding up the already instant RISEATTACK may seem pointless, but it can work to counteract a staydown effect.
Example: risetime 0 -50 #appears to be default

riseattacktype {int}

Determines how entity performs RISEATTACK while rising.
0 = Only RISEATTACK will be used. Other RISEATTACK animations (see Animation Types below) won't be used.
1 = RISEATTACK will be played based on received attacktype. For instance, if entity was knocked down with attack5, entity will perform RISEATTACK5 if it's executed. If required animations aren't available, RISEATTACK will be played instead.
3 = Like 1 but if required animations aren't available, RISE will be played instead (no riseattack).

riseinv {int} {bi}

Determines whether or not the player is briefly invincible after rising.
(int) is how many seconds the player will be invincible for.
(bi) is flag which sets blinking
0 = Blinking (default)
1 = No blinking

jugglepoints {int}

This command limits jugglability of this entity. IOW it controls how many times entity can be juggled.
Juggling means attacking falling opponents (assuming they are vulnerable while falling).
This command is used in conjunction with 'jugglecost' (see Animation Data below).
The command works like this:
If attackbox hits opponent whose 'jugglepoints' is higher than or equal with 'jugglecost', the attack will connect. At this condition, opponent's 'jugglepoints' will be subtracted by that 'jugglecost'. This drops 'jugglepoints' which limits juggling ability. If attackbox hits opponent whose 'jugglepoints' is lower than 'jugglecost', the attack will not connect. At this condition, opponent's 'jugglepoints' will remain the same.
If {int} is set to -1, the entity will be immune to juggles.

instantitemdeath {int}

This command sets whether the pause when item suicides after being taken is removed or not.
0 = pause is not removed.
1 = pause is removed.
Weapons
weapons {name1} {name2} {name3} {name4} {name5} {original name}

This command sets other model which will be used to replace this entity when a weapon is picked up.
{name#} is the name of the model which this character becomes when they pick up weapon #. # is weapon's number. Don't forget to load the model in models.txt.
{original name} is the name of the character when it doesn't have any weapons equipped.
If {name#} is filled with none, this entity can't pick respective weapon.

project {name}

For subtype "project" items.
{name} is the name of the new projectile the player or enemy who grabs this can use.

shootnum {int}

For items which can be used as weapons.
This is the maximum number of times a weapon can be fired.

counter {int}

For items which can be used as weapons.
This is the maximum number of times a weapon can be dropped before it dissapears forever.
To make weapons hang around basically forever, give them a high value like 100,000 or something. If somebody can drop it that many times, they probably don't deserve to hold onto it!

reload {int}

For items.
If a player picks up an item that has this command, it will restore their ammunition by {int}.
Does nothing if a player doesn't have a weapon.
Should be used with 'shootnum'.
Don't forget that items can only give one bonus.

typeshot {bi}

For weapons.
Determines if the weapon is a gun or a knife.
0 means a knife, and ammunition will not be displayed, since you can only throw knives once.
1 means a gun, so ammunition will be displayed. It will also appear on the ground if you run out of ammunition while using it.

animal {bi}

For players with a weapon.
Determines if the weapon is actually an animal to be ridden.
Animals will run away if they are knocked down enough times.
Players on an animal can't be grabbed.

weaploss {flag} {weapnum}

Determines how weapon could be lost when the character is wielding a weapon.
{flag} 0 (default) = weapon is lost and dropped on any hit.
{flag} 1 = weapon is lost only on knockdown hit.
{flag} 2 = weapon is lost only on death.
{flag} 3 = weapon is lost only when level ends or character is changed during continue. This depends on the level settings and whether players had weapons on start or not.
{weapnum} is optional. If set on, the entity set weapon to {weapnum} (see weapnum {int})
This setting can also be declared in weapon text. If you do so, the setting will override similar setting in character's text and it will only be used for that weapon.

modelflag {int}

Determines how weapon model copies animation and weaponlist from original model.
0 = Animation and weaponlist are copied
1 = Animation aren't copied but weaponlist are still copied
3 = Animation and weaponlost aren't copied
Use this with weapon models of course.

weapnum {int}

Used to give number to weapons. {int} is the number.
Declaring this command is important so other command such as 'setweap' (see Level Designs below) could work properly.