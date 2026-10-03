void main(){
void self = getlocalvar("self");
int player = getentityproperty(self, "playerindex");
int animation = getentityproperty(self, "animationid");
float xdir = getentityproperty(self, "xdir");
float zdir = getentityproperty(self, "zdir");
float tossv = getentityproperty(self, "tossv");
if(animation == openborconstant("ANI_SPECIAL") || animation == openborconstant("ANI_FREESPECIAL34")){
float speed = 0.5;
if(playerkeys(player, 1, "moveright") && !playerkeys(player, 0, "moveleft"))
xdir = speed;
else if(playerkeys(player, 1, "moveleft"))
xdir = -speed;
else if(playerkeys(player, 2, "moveright")){
if(playerkeys(player, 0, "moveleft"))
xdir = -speed;
else
xdir = 0;
}else if(playerkeys(player, 2, "moveleft")){
if(playerkeys(player, 0, "moveright"))
xdir = speed;
else
xdir = 0;
}if(playerkeys(player, 1, "movedown") && !playerkeys(player, 0, "moveup"))
zdir = speed/2.0;
else if(playerkeys(player, 1, "moveup"))
zdir = -speed/2.0;
else if(playerkeys(player, 2, "movedown")){
if(playerkeys(player, 0, "moveup"))
zdir = -speed/2.0;
else
zdir = 0;
}else if(playerkeys(player, 2, "moveup")){
if(playerkeys(player, 0, "movedown"))
zdir = speed/2.0;
else
zdir = 0;
}changeentityproperty(self, "velocity", xdir, zdir, tossv);
}
}
