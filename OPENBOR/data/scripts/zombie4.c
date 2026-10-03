void shoot(void Shot, float dx, float dy, float dz){
	void self = getlocalvar("self");
	int Direction = getentityproperty(self, "direction");
	int x = getentityproperty(self, "x");
	int y = getentityproperty(self, "a");
	int z = getentityproperty(self, "z");
	int vMap = getentityproperty(self, "map");
	if (Direction == 0){
		dx = -dx;
	}projectile(Shot, x+dx, z+dz, y+dy, Direction, 0, 0, vMap);
}void toss(void Bomb, float dx, float dy, float dz){ 
	void self = getlocalvar("self");
	int Direction = getentityproperty(self, "direction");
	int x = getentityproperty(self, "x");
	int y = getentityproperty(self, "a");
	int z = getentityproperty(self, "z");
	int vMap = getentityproperty(self, "map");
	if (Direction == 0){
		dx = -dx;
	}projectile(Bomb, x+dx, z+dz, y+dy, Direction, 0, 1, vMap);
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
	}H = checkwall(x+Dist,z);
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
}void teletarget(int dx, int dy, int dz){
	void self = getlocalvar("self");
	int dir = getentityproperty(self, "direction");
	if(dir==0){
		dx = -dx ;
	}
	setlocalvar("T"+self, findtarget(self));
	if( getlocalvar("T"+self) != NULL()){
		void target = getlocalvar("T"+self);
		int Tx = getentityproperty(target, "x");
		int Tz = getentityproperty(target, "z");
		changeentityproperty(self, "position", Tx+dx, Tz+dz, dy); 
	} 
}void target(float Velx, float Velz){
	void self = getlocalvar("self");
	int dir = getentityproperty(self, "direction");
	float x = getentityproperty(self, "x");
	float z = getentityproperty(self, "z");
	setlocalvar("T"+self, findtarget(self));
	if( getlocalvar("T"+self) != NULL()){
		void target = getlocalvar("T"+self);
		float Tx = getentityproperty(target, "x");
		float Tz = getentityproperty(target, "z");
		float Disx = Tx - x;
		float Disz = Tz - z;
		if(Disx < 0){
			Disx = -Disx;
			changeentityproperty(self, "direction", 0);
		} else {
			changeentityproperty(self, "direction", 1);
		}
		if(Disz < 0){
			Disz = -Disz;
		}
		if(Disz < Disx)
		{
			if(Tx < x){
				setlocalvar("x"+self, -Velx);
			} else { setlocalvar("x"+self, Velx); }
			setlocalvar("z"+self, Velx*(Tz-z)/Disx);
		} else {
			if(Tz < z){
				setlocalvar("z"+self, -Velz);
			} else { setlocalvar("z"+self, Velz); }
			setlocalvar("x"+self, Velz*(Tx-x)/Disz);
		}
	} else {
		setlocalvar("z"+self, 0);
		if(dir==0){
			setlocalvar("x"+self, -Velx);
		} else { setlocalvar("x"+self, Velx); }
	}
}
