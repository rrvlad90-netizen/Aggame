void rotateunit()
{
    void self = getlocalvar("self"); // Get thing of player
    void target = findtarget(self); // seek near enemy

    if (target != NULL())
    {
        float player_x = getentityproperty(self, "x"); // Get X coordinate of player
        float target_x = getentityproperty(target, "x"); // Get X coordinate of enemy

        if (target_x < player_x)
        {
            changeentityproperty(self, "direction", 0); // Turn player to left

	//Not use it
	    //changeentityproperty(self, "facing", 0); // Turn player to left
        }
        else
        {
            changeentityproperty(self, "direction", 1); //  Turn player to right
	//Not use it
            //changeentityproperty(self, "facing", 1); // Turn player to right
        }
    }
}

void rotateleft()
{
    void self = getlocalvar("self"); // Get thing of player
    
            changeentityproperty(self, "direction", 0); // Turn to left
}

void rotateright()
{
    void self = getlocalvar("self"); // Get thing of player
    
            changeentityproperty(self, "direction", 1); // Turn to right
}


void moveup(int V)
{
void self = getlocalvar("self");
changeentityproperty(self,"velocity",1,0,V);	
}

void changeAnimation(char ani)
{
	void self = getlocalvar("self");
	changeentityproperty(self, "animation", openborconstant(ani));
	//changeentityproperty(self, "animpos", 0);
}

void changeperformattack(char ani)
{
	void self = getlocalvar("self");
	performattack(self, openborconstant(ani));
	//changeentityproperty(self, "animpos", 0);
}

void moveX(int V)
{
	int r=rand()%180;
	int Vx;
	int Vz;
	
	Vx=V*cos(r);
	Vz=V*sin(r);
	
	dasher(Vx,0,Vz);	
}


void dasher(float Vx, float Vy, float Vz)
{
	void self = getlocalvar("self");
	int dir = getentityproperty(self,"direction");
	
	if(dir==0)
	{
		Vx=-Vx;
	}
	
	changeentityproperty(self,"velocity",Vx,Vy,Vz);	//Move
}


void stop()
{
	void self = getlocalvar("self");
	changeentityproperty(self,"velocity",0,0,0);
}

void stop2()
{
	void self = getlocalvar("self");
	changeentityproperty(self,"velocity",0,0,0);
	changeentityproperty(self,"speed",0,0,0);
}

void setFullHealth()
{
 	void ent = getlocalvar("self");
 	int Health = getentityproperty(ent, "health");
 	changeentityproperty(ent, "health", Health+200);
}


void restoreHealth()
{
    void ent = getlocalvar("self");
    int maxHealth = getentityproperty(ent, "maxhealth");
    int currentHealth = getentityproperty(ent, "health");

    changeentityproperty(ent, "health", maxHealth);
}


void restoreHealthforplayer()
{
    void self = getlocalvar("self"); // Get thing of player
    void target = findtarget(self); // seek near enemy
    int maxHealth = getentityproperty(target, "maxhealth");

    changeentityproperty(target, "health", maxHealth);
}


//NE RABOTAET NO ON HOTYABI NE RUGAETSA NA PARAMETRY
void bbbb()
{
    void self = getlocalvar("self");

	int ii = getplayerproperty(0,"newkeys") & openborconstant("FLAG_MOVERIGHT");

    if (ii>0) //playerkeys(0, "back")
    {
        //changeentityproperty(self, "direction", !getentityproperty(self, "direction"));

        performattack(self, openborconstant("ANI_DIE"));
    }
}

void keyint(void Ani, int Frame, void Key, int Hflag)
{// Change current animation if proper key is pressed or released
// Animation is changed to attack mode

    void self = getlocalvar("self");
    int Dir = getentityproperty(self, "direction");
    int iPIndex = getentityproperty(self,"playerindex"); //Get player index
    void iRKey;

      if (Key=="U"){ //Up Required?
        iRKey = playerkeys(iPIndex, 0, "moveup"); // "Up"
      } else if (Key=="D"){ //Down Required?
        iRKey = playerkeys(iPIndex, 0, "movedown"); // "Down"
      } else if (Key=="L"){ //Left Required?
        iRKey = playerkeys(iPIndex, 0, "moveleft"); // "Left"
      } else if (Key=="R"){ //Right Required?
        iRKey = playerkeys(iPIndex, 0, "moveright"); // "Right"
      } else if (Key=="F"){ //Forward Required?
        if (Dir == 0){ // Facing Left?
          iRKey = playerkeys(iPIndex, 0, "moveleft"); // "Left"
        } else { // Facing Right
          iRKey = playerkeys(iPIndex, 0, "moveright"); // "Right"
        }
      } else if (Key=="B"){ //Backward Required?
        if (Dir == 1){ // Facing Right?
          iRKey = playerkeys(iPIndex, 0, "moveleft"); // "Left"
        } else { // Facing Left
          iRKey = playerkeys(iPIndex, 0, "moveright"); // "Right"
        }
      } else if (Key=="J"){ //Jump Required?
        iRKey = playerkeys(iPIndex, 0, "jump"); // "Jump"
      } else if (Key=="A"){ //Attack Required?
        iRKey = playerkeys(iPIndex, 0, "attack"); // "Attack"
      } else if (Key=="S"){ //Special Required?
        iRKey = playerkeys(iPIndex, 0, "special"); // "Special"
      }

      if (Hflag==1){ //Not holding the button case?
        iRKey = !iRKey; //Take the opposite condition
      }

      if (iRKey){
        if (Ani=="ANI_IDLE"){ // Going idle?
          setidle(self, openborconstant("ANI_IDLE")); //Be idle!
        } else {
          performattack(self, openborconstant(Ani)); //Change the animation
        }
        updateframe(self, Frame); //Change frame
      }
}

void goto_if_nearx()
{
    void self = getlocalvar("self"); //Thing->enemy
    //void player = getentityproperty(self, "opponent"); //Thing->player
	void target = findtarget(self);

    float distance_x = getentityproperty(self, "x") - getentityproperty(target, "x"); // Distance x between enemy and player
    float distance_y = getentityproperty(self, "y") - getentityproperty(target, "y");


    if (distance_x >= -35 && distance_x <= 35 ) // if close 
    {
//		if (distance_y >= -35 && distance_y <= 35 )
        changeentityproperty(self, "animation", openborconstant("ANI_FOLLOW1")); // Go to follow1 animation  (before it was be ANI_DIE - death animation)
    }
}


void goto_if_near()
{
    void self = getlocalvar("self"); //Thing->enemy
    //void player = getentityproperty(self, "opponent"); //Thing->player
	void target = findtarget(self);

    float distance_x = getentityproperty(self, "x") - getentityproperty(target, "x"); // Distance x between enemy and player
    float distance_y = getentityproperty(self, "y") - getentityproperty(target, "y");


    if (distance_x >= -10 && distance_x <= 10 ) // if close 
    {
		if (distance_y >= -35 && distance_y <= 35 )
        changeentityproperty(self, "animation", openborconstant("ANI_FOLLOW1")); // Go to follow1 animation  (before it was be ANI_DIE - death animation)
    }
}


void gotodeathanimation()
{
    void self = getlocalvar("self"); //Thing->

       changeentityproperty(self, "animation", openborconstant("ANI_DIE")); // Go to death animation
}


void gotoanimation(void ani)
{
    void self = getlocalvar("self"); //Thing->

       changeentityproperty(self, "animation", openborconstant(ani)); // Go to animation
}



void upppp(float howmuch)
{
  	void vSelf = getlocalvar("self"); //Get calling player
        int iVx = getentityproperty(vSelf, "xdir");

        changeentityproperty(vSelf, "velocity", iVx, 0, howmuch);
}


void leffft(float howmuch)
{
  	int iPlIndex = getlocalvar("self"); //Get calling player
    	void vSelf = getplayerproperty(iPlIndex , "entity"); //Get calling entity
	int iVy = getentityproperty(vSelf, "tossv");

	changeentityproperty(vSelf, "velocity", 1, 0, iVy);
}



void goto_if_nearx_random()
{
    void self = getlocalvar("self"); //Thing->enemy
    //void player = getentityproperty(self, "opponent"); //Thing->player
	void target = findtarget(self);

    float distance_x = getentityproperty(self, "x") - getentityproperty(target, "x"); // Distance x between enemy and player
    float distance_y = getentityproperty(self, "y") - getentityproperty(target, "y");


    int r=rand()%10;
    if (distance_x >= -335 && distance_x <= 335 ) // if close 
    {
//		if (distance_y >= -35 && distance_y <= 35 )	
    if (r>=5)
	{
        changeentityproperty(self, "animation", openborconstant("ANI_FREESPECIAL1"));
	}
	else
	{
 	changeentityproperty(self, "animation", openborconstant("ANI_FREESPECIAL2"));
	}

 // Go to follow1 animation  (before it was be ANI_DIE - death animation)
    }
}




void goto_random()
{
    void self = getlocalvar("self"); //Thing->enemy

  int r=rand()%1;
    if (r>=1)
	{
        changeentityproperty(self, "animation", openborconstant("ANI_FREESPECIAL1"));
	}
	else
	{
 	changeentityproperty(self, "animation", openborconstant("ANI_FREESPECIAL2"));
	}

}
