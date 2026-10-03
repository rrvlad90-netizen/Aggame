void Rspawn(float fX, float fY, float fZ){
void self = getlocalvar("self");
void vSpawn; 
void vName; 
void vRName = getentityproperty(self,"defaultname"); 
void vAlias = getentityproperty(self,"name"); 
int  iMHealth = getentityproperty(self,"maxhealth"); 
int  iHealth = getentityproperty(self,"health"); 
int  iDirection = getentityproperty(self, "direction");
int  iMap = getentityproperty(self, "map"); 
int  iR = rand()%10;
if (iR >= 0 && iR < 2){ 
vName = "money1";
}else if (iR >= 2 && iR < 4){ 
vName = "money2";
}else if (iR >= 4 && iR < 6){ 
vName = "can";
}else if (iR >= 6 && iR < 8){ 
vName = "hotdog";
}else if (iR >= 8 && iR < 10){ 
vName = "zupa";
}else{ 
vName = "money1";
}
clearspawnentry(); 
setspawnentry("name", vName); 
if (iDirection == 0){             
fX = -fX; 
}
fX = fX + getentityproperty(self, "x");
fY = fY + getentityproperty(self, "a");
fZ = fZ + getentityproperty(self, "z");
vSpawn = spawn(); 
changeentityproperty(vSpawn, "position", fX, fZ, fY); 
changeentityproperty(vSpawn, "direction", iDirection); 
return vSpawn; 
}
