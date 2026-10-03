void velo001(float fX, float fZ, float fY){
void vSelf = getlocalvar("self"); 
if (getentityproperty(vSelf, "direction")==0){                  
fX = -fX; 
}changeentityproperty(vSelf, "velocity", fX, fZ, fY);
}void flipdir(){
void self = getlocalvar("self");
changeentityproperty(self, "direction", !getentityproperty(self, "direction"));
}
