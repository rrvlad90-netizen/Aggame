void spawn01(void vName, float fX, float fY, float fZ){
	void self = getlocalvar("self");
	void vSpawn;
	int  iDirection = getentityproperty(self, "direction");
	clearspawnentry(); 
	setspawnentry("name", vName); 
	if (iDirection == 0){
		fX = -fX;
	}fX = fX + getentityproperty(self, "x");
	fY = fY + getentityproperty(self, "a");
	fZ = fZ + getentityproperty(self, "z");
	vSpawn = spawn();
	changeentityproperty(vSpawn, "position", fX, fZ, fY); 
	changeentityproperty(vSpawn, "direction", iDirection); 
	return vSpawn; 
}void spawn02(void vName, float fX, float fY, float fZ){  
	void self = getlocalvar("self"); 
	void map = getentityproperty(self, "map");
	void vSpawn; 
	vSpawn = spawn01(vName, fX, fY, fZ); 
	changeentityproperty(vSpawn, "map", map); 
	return vSpawn; 
}void velo001(float fX, float fZ, float fY){
	void vSelf = getlocalvar("self"); 
	if (getentityproperty(vSelf, "direction")==0){
		fX = -fX; 
	}changeentityproperty(vSelf, "velocity", fX, fZ, fY);
}
