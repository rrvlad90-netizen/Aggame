void Main(float fX, float fZ, float fY){
	void vSelf = getlocalvar("self");
	//void target = findtarget(self);  
	if (getentityproperty(vSelf, "direction")==0)
	{                  
		fX = -fX; 
	}
changeentityproperty(vSelf, "velocity", fX, fZ, fY); 
}