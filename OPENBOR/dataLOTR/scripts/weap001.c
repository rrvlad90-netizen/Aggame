void weap001(int iWep){
 
    //weap001
	//Damon Vaughn Caskey
	//06/30/2007
    //Sets callers weapon model.
    //
    //iWep: Desired weapon model index.
     
     void vSelf = getlocalvar("self"); //Get calling entity.
     int iMap = getentityproperty(vSelf, "map"); //Get current remap.
     
     if ((iWep) && (iMap)){ //If requested model is not default and a remap is being used, record remap.
     
        setglobalvar("iMap" + vSelf, iMap); 
          
     } 
     
	 changeentityproperty(vSelf, "weapon", iWep, 0); //Switch to desired model.
     changeentityproperty(vSelf, "map", getglobalvar("iMap" + vSelf)); //Defeat weapon remap bug by forcing a switch back to remap.
     
}


