// Wall's animation script
void spawner(void vName, float fX, float fY, float fZ)
{
	//spawner
	//Damon Vaughn Caskey
	//07/06/2007
	//
	//Spawns entity next to caller.
	//
	//vName: Model name of entity to be spawned in.
	//fX: X location adjustment.
	//fZ: Y location adjustment.
      //fY: Z location adjustment.

	void self = getlocalvar("self"); //Get calling entity.
	void vSpawn; //Spawn object.
	int  vAlias = getentityproperty(self, "name");
	int  iHealth = getentityproperty(self, "health");
	int  iDirection = getentityproperty(self, "direction");

	clearspawnentry(); //Clear current spawn entry.
      setspawnentry("name", vName); //Acquire spawn entity by name.

	if (iDirection == 0){ //Is entity facing left?                  
          fX = -fX; ////Reverse X direction to match facing.
	}

      fX = fX + getentityproperty(self, "x"); //Get X location and add adjustment.
      fY = fY + getentityproperty(self, "a"); //Get Y location and add adjustment.
      fZ = fZ + getentityproperty(self, "z"); //Get Z location and add adjustment.
	
	vSpawn = spawn(); //Spawn in entity.

	changeentityproperty(vSpawn, "position", fX, fZ, fY); //Set spawn location.
	changeentityproperty(vSpawn, "parent", self); //Set caller as parent.
        
	changeentityproperty(vSpawn, "name", vAlias); //Set name.
	changeentityproperty(vSpawn, "health", iHealth); //Set health.
	changeentityproperty(vSpawn, "direction", iDirection); //Set direction.



        
    
	return vSpawn; //Return spawn.
}



void spawner2(void vName, float fX, float fY, float fZ)
{
	//spawner
	//Damon Vaughn Caskey
	//07/06/2007
	//
	//Spawns entity.
	// sem parentesco e em local absoluto na tela
	//vName: Model name of entity to be spawned in.
	//fX: X location adjustment.
	//fZ: Y location adjustment.
      //fY: Z location adjustment.

        void self = getlocalvar("self"); //Get calling entity.
	void vSpawn; //Spawn object.
	int  vAlias = getentityproperty(self, "name");
	int  iHealth = getentityproperty(self, "health");
	int  iDirection = getentityproperty(self, "direction");


        if (iDirection == 0){ //Is entity facing left?                  
          fX = -fX; ////Reverse X direction to match facing.
	}

      fX = fX + getentityproperty(self, "x"); //Get X location and add adjustment.
      fY = fY + getentityproperty(self, "a"); //Get Y location and add adjustment.
      fZ = fZ + getentityproperty(self, "z"); //Get Z location and add adjustment.



	clearspawnentry(); //Clear current spawn entry.
        setspawnentry("name", vName); //Acquire spawn entity by name.

	

      
	
	vSpawn = spawn(); //Spawn in entity.

        void parent      = getentityproperty(self, "parent");
        void owner       = getentityproperty(self, "owner");

        

        
        
	changeentityproperty(vSpawn, "position", fX, fZ, fY); //Set spawn location.

        
        
        changeentityproperty(vSpawn, "parent", self); //Set caller as parent.
       

        return vSpawn; //Return spawn.
        setglobalvar("spawner",vSpawn);	

        
	
	
     
        

	
        
}




void spawner3(void vName, float fX, float fY, float fZ)
{
	//spawner
	//Damon Vaughn Caskey
	//07/06/2007
	//
	//Spawns entity.
	// sem parentesco e em local absoluto na tela
	//vName: Model name of entity to be spawned in.
	//fX: X location adjustment.
	//fZ: Y location adjustment.
      //fY: Z location adjustment.

        void self = getlocalvar("self"); //Get calling entity.
	void vSpawn; //Spawn object.
	int  vAlias = getentityproperty(self, "name");
	int  iHealth = getentityproperty(self, "health");
	int  iDirection = getentityproperty(self, "direction");

	clearspawnentry(); //Clear current spawn entry.
      setspawnentry("name", vName); //Acquire spawn entity by name.

	if (iDirection == 0)
                        { //Is entity facing left?                  
                          fX = -fX; ////Reverse X direction to match facing.
	                }

      
	
	vSpawn = spawn(); //Spawn in entity.

        void parent      = getentityproperty(self, "parent");
        void owner      = getentityproperty(self, "owner");

        changeentityproperty(self, "owner", vSpawn); //entidade que chamou vira dono.
        changeentityproperty(self, "parent", vSpawn); //Set caller as parent.
	changeentityproperty(vSpawn, "position", fX, fZ, fY); //Set spawn location.
        changeentityproperty(vSpawn, "parent", self); //Set caller as parent.

        
	
	changeentityproperty(vSpawn, "name", vAlias); //Set name.
	changeentityproperty(vSpawn, "health", iHealth); //Set health.
	changeentityproperty(vSpawn, "direction", iDirection); //Set direction.
    
	return vSpawn; //Return spawn.
        
}




void spawner4(void vName, float fX, float fY, float fZ, void Anim)
{
	//spawner
	//Damon Vaughn Caskey
	//07/06/2007
	//define anim inicial da entidade chamada
	//Spawns entity next to caller.
	//
	//vName: Model name of entity to be spawned in.
	//fX: X location adjustment.
	//fZ: Y location adjustment.
      //fY: Z location adjustment.

	void self = getlocalvar("self"); //Get calling entity.
	void vSpawn; //Spawn object.
	int  vAlias = getentityproperty(self, "name");
	int  iHealth = getentityproperty(self, "health");
	int  iDirection = getentityproperty(self, "direction");

	clearspawnentry(); //Clear current spawn entry.
      setspawnentry("name", vName); //Acquire spawn entity by name.

	if (iDirection == 0){ //Is entity facing left?                  
          fX = -fX; ////Reverse X direction to match facing.
	}

      fX = fX + getentityproperty(self, "x"); //Get X location and add adjustment.
      fY = fY + getentityproperty(self, "a"); //Get Y location and add adjustment.
      fZ = fZ + getentityproperty(self, "z"); //Get Z location and add adjustment.
	
	vSpawn = spawn(); //Spawn in entity.

	changeentityproperty(vSpawn, "position", fX, fZ, fY); //Set spawn location.
	
        
	changeentityproperty(vSpawn, "name", vAlias); //Set name.
	changeentityproperty(vSpawn, "health", iHealth); //Set health.
	changeentityproperty(vSpawn, "direction", iDirection); //Set direction.
        changeentityproperty(vSpawn, "animation", openborconstant(Anim));


        
    
	return vSpawn; //Return spawn.
}




