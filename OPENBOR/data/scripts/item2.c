void Rspawn2(float fX, float fY, float fZ){
void self = getlocalvar("self"); 
void vSpawn; 
void vName; 
void vRName = getentityproperty(self,"defaultname"); 
void vAlias = getentityproperty(self,"name"); 
void vWeap = getentityproperty(self,"name");
int  iMHealth = getentityproperty(self,"maxhealth"); 
int  iHealth = getentityproperty(self,"health"); 
int  iDirection = getentityproperty(self, "direction");
int  iMap = getentityproperty(self, "map");
int  iR = rand()%10;
if (iR >= 0 && iR < 2){ 
vName = "shtgun";
}else if (iR >= 2 && iR < 4){
vName = "chainsaw";
}else if (iR >= 4 && iR < 6){ 
vName = "shtgun";
}else if (iR >= 6 && iR < 8){ 
vName = "axe";
}else if (iR >= 8 && iR < 10){ 
vName = "mshgun";
}else{ 
vName = "grit";
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
