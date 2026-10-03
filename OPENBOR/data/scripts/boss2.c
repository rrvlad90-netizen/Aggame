void velo001(float fX, float fZ, float fY){
	void vSelf = getlocalvar("self"); 
	if (getentityproperty(vSelf, "direction")==0){                  
		fX = -fX; 
	}changeentityproperty(vSelf, "velocity", fX, fZ, fY); 
}void shoot(void Shot, float dx, float dy, float dz){ 
	void self = getlocalvar("self");
	int Direction = getentityproperty(self, "direction");
	int x = getentityproperty(self, "x");
	int y = getentityproperty(self, "a");
	int z = getentityproperty(self, "z");
	if (Direction == 0){               
		dx = -dx; 
	}projectile(Shot, x+dx, z+dz, y+dy, Direction, 0, 0, 0);
}void toss(void Bomb, float dx, float dy, float dz){ 
	void self = getlocalvar("self");
	int Direction = getentityproperty(self, "direction");
	int x = getentityproperty(self, "x");
	int y = getentityproperty(self, "a");
	int z = getentityproperty(self, "z");
	if (Direction == 0){                
		dx = -dx; 
	}projectile(Bomb, x+dx, z+dz, y+dy, Direction, 0, 1, 0);
}void antiwall(int Dist, int Move, int Distz){
	void self = getlocalvar("self");
	int Direction = getentityproperty(self, "direction");
	int x = getentityproperty(self, "x");
	int z = getentityproperty(self, "z");
	float H;
	float Hz;
	if (Direction == 0){             
		Dist = -Dist; 
		Move = -Move; 
	}
	H = checkwall(x+Dist,z);
	Hz = checkwall(x+Dist,z+Distz);
	if(Hz > 0){
		changeentityproperty(self, "position", x, z-Distz);
	}if(H > 0){
		changeentityproperty(self, "position", x+Move, z);
	}
}void death(){
	void vSelf = getlocalvar("self"); 
	float fY = getentityproperty(vSelf, "a"); 
	if (fY > 1){
		changeentityproperty(vSelf, "animation", openborconstant("ANI_DIE3"));
	}
}void hurt3(int Damage, int set){
	void self = getlocalvar("self");
	if(set==0){
		void target = getlocalvar("Target" + self);
		if(target==NULL()){
			target = getentityproperty(self, "grabbing");
			setlocalvar("Target" + self, target);
		}if(target!=NULL()){
			void THealth = getentityproperty(target,"health"); 
			changeentityproperty(target, "health", THealth - Damage); 
		}
	}else if(set==1){
		void SHealth = getentityproperty(self,"health"); 
		changeentityproperty(self, "health", SHealth + Damage);
	}
}void spawn01(void vName, float fX, float fY, float fZ){
	void self = getlocalvar("self"); 
	void vSpawn; 
	int  iDirection = getentityproperty(self, "direction");
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
}void grabcheck(){
	void self = getlocalvar("self");
	void target = getentityproperty(self, "grabbing");
	if(target==NULL()){
		performattack(self, openborconstant("ANI_ATTACK2")); 
	}
}void clearL(){
	clearlocalvar();
}void targetL(float Vy, float dx, float dz){
	void self = getlocalvar("self");
	int dir = getentityproperty(self, "direction");
	float x = getentityproperty(self, "x");
	float z = getentityproperty(self, "z");
	if (dir == 0){
		dx = -dx;
	}
	setlocalvar("T"+self, findtarget(self));
	if( getlocalvar("T"+self) != NULL()){
		void target = getlocalvar("T"+self);
		float Tx = getentityproperty(target, "x");
		float Tz = getentityproperty(target, "z");
		if(Tx < x){
			changeentityproperty(self, "direction", 0);
		} else {
			changeentityproperty(self, "direction", 1);
		}
		x = x+dx;
		z = z+dz;
		setlocalvar("x"+self, (Tx-x)/(22*Vy));
		setlocalvar("z"+self, (Tz-z)/(22*Vy));
	} else {
		setlocalvar("z"+self, 0);
		setlocalvar("x"+self, 0);
	}
}void leap(float Vely){
	void self = getlocalvar("self");
	float Vx = getlocalvar("x"+self);
	float Vz = getlocalvar("z"+self);
	if( Vx!=NULL() && Vz!=NULL() ){
		tossentity(self, Vely, Vx, Vz);
	}
}
