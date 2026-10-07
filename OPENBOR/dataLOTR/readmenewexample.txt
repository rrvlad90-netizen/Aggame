ћожно добавл€ть видео!
ѕример:
play
#	silence					# Stop music
#animation	data/scenes/newintro.gif 0 0

video data/scenes/senile.webm 1 0
video data/scenes/openbor.webm 1 0
video data/scenes/tjintro.webm 1 0
video data/scenes/intro.webm 1 0
music data/music/intro.ogg 1





ѕример остановки музыки
anim	death4
	offset	85 97
	delay	20
	drawmethod	226 200 0 0 0 -1 -1
	@cmd	pausemusic 1



ѕример противника который атакует дургих противников
name En1
type enemy
aimove chase   #враг активно преследует игрока
health 5500
speed 15
shadow 1
hostile enemy player #кого враг будет атаковать
candamage enemy player obstacle   #может повредить своими атаками
subject_to_obstacle 0
subject_to_wall 0
cantgrab 1   #Ќельз€ захватить
falldie 1   #”мирает при падении, если падает с высоты
nodieblink 3 #Ќе мигает при смерти. 3 = отключить мигание полностью
jugglepoints  20   # оличество очков дл€ Ђжонглировани€ї в воздухе. ѕри достижении лимита перестаЄт быть у€звимым в воздухе.
offscreenkill  1000   #”ничтожаетс€, если находитс€ за экраном более чем на 1000 
offscreen_noatk_factor 1 #враг не атакует, если не на экране
escapehits 1   # ≈сли получает удар Ч попытаетс€ уклонитьс€/убежать 
aggression 40  # 40 Ч средн€€ агресси€, будет искать игрока, но не посто€нно спамить атаки

#ћожно ничего не писать а просто сразу перейти к стейтам
anim	attack
	offset	41 93
	delay	8
	sound	data/sounds/spike.wav
	frame	data/chars/spike/spike014.png





ѕример Path
name          Walker
type          enemy
health        100
speed         1
aimove        path
path          0 100  50 100  100 100  150 100
# Ёто точки X Y Ч по ним будет идти враг по очереди

animationscript data/scripts/walker_ai.c

palette       data/chars/walker/palette.png

anim idle
	delay 5
	frame data/chars/walker/frame1.png
	frame data/chars/walker/frame2.png

anim walk
	loop 1
	delay 5
	frame data/chars/walker/frame1.png
	frame data/chars/walker/frame2.png





 ак работает path:
path задаЄт список координат (x, y), по которым будет двигатьс€ враг.

¬раг будет идти от одной точки к другой, в том пор€дке, в котором ты их указал.

 огда достигнет последней точки Ч по умолчанию останавливаетс€.

ћожно управл€ть поведением дальше через animationscript, если нужно зациклить или изменить маршрут.

