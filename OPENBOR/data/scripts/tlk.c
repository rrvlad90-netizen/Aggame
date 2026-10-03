void tlk(){
void vSelf = getplayerproperty(0, "entity");
void vName = getentityproperty(vSelf,"name");
int Health = getentityproperty(vSelf,"health");
void vSelf2 = getplayerproperty(1, "entity");
void vName2 = getentityproperty(vSelf2,"name");
int Health2 = getentityproperty(vSelf2,"health");
void self = getlocalvar("self");
if (Health < Health2 || vName == NULL()){
vName = vName2;
}if (vName == "Chris"){
changeentityproperty(self, "animation", openborconstant("ANI_FREESPECIAL2")); 
}else if (vName == "Jasmin"){
changeentityproperty(self, "animation", openborconstant("ANI_FREESPECIAL3")); 
}else if (vName == "Jack"){
changeentityproperty(self, "animation", openborconstant("ANI_FREESPECIAL4")); 
}
}
