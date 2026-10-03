void trollcounter()
{
    void self = getlocalvar("self");
    int now = openborvariant("elapsed_time");
    int nextCounter = getentityvar(self, 0);
    int roll = rand();

    if(roll < 0)
    {
        roll = -roll;
    }

    // Контратака доступна и сработал шанс 33%
    if((nextCounter == NULL() || now >= nextCounter) && roll % 3 == 0)
    {
        setentityvar(self, 0, now + 600);
        performattack(self, openborconstant("ANI_ATTACK2"));
    }
    else
    {
        makenopainfalse();
        setidle(self, openborconstant("ANI_IDLE"));
    }
}

void walkvariation()
{
    void self = getlocalvar("self");
    int chance = rand();

    if(chance < 0)
    {
        chance = -chance;
    }

    chance %= 100;

    // Манёвр примерно в 30% циклов ходьбы
    if(chance >= 30)
    {
        return;
    }

    float z = getentityproperty(self, "z");
    float minZ = openborvariant("player_min_z");
    float maxZ = openborvariant("player_max_z");

    // Не позволяем уходить за края участка
    if(z < minZ + 80)
    {
        performattack(self, openborconstant("ANI_FOLLOW2"));
    }
    else if(z > maxZ - 80)
    {
        performattack(self, openborconstant("ANI_FOLLOW1"));
    }
    else if(chance % 2 == 0)
    {
        performattack(self, openborconstant("ANI_FOLLOW1"));
    }
    else
    {
        performattack(self, openborconstant("ANI_FOLLOW2"));
    }
}

void randomlongpain()
{
    void self = getlocalvar("self");
    int chance = rand();

    if(chance < 0)
    {
        chance = -chance;
    }

    if(chance % 5 == 0)
    {
        performattack(self, openborconstant("ANI_PAIN7"));
    }
}

void setchase()
{
    void self = getlocalvar("self");
    changeentityproperty(self, "aimove", 1);
}

void reposition()
{
    void self = getlocalvar("self");
    int chance = rand();
    int movement = rand();

    if(chance < 0) chance = -chance;
    if(movement < 0) movement = -movement;

    chance %= 100;
    movement %= 100;

    // В 35% случаев остаёмся на месте
    if(chance >= 65)
    {
        setidle(self, openborconstant("ANI_IDLE"));
        return;
    }

    if(movement < 35)
    {
        performattack(self, openborconstant("ANI_FOLLOW1"));
    }
    else if(movement < 70)
    {
        performattack(self, openborconstant("ANI_FOLLOW2"));
    }
    else if(movement < 85)
    {
        performattack(self, openborconstant("ANI_FOLLOW3"));
    }
    else
    {
        performattack(self, openborconstant("ANI_FOLLOW4"));
    }
}

void enableunitpushing()
{
    void self = getlocalvar("self");

    changeentityproperty(self, "entitypushing", 1);
    changeentityproperty(self, "pushingfactor", 0.6);
}

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

void randomscript()
{
        void self = getlocalvar("self");
        int r = rand() % 3;
            if (r == 0) 
	    {
                performattack(self, openborconstant("ANI_FOLLOW1"));
            } else if (r == 1) {
                performattack(self, openborconstant("ANI_FOLLOW2"));
            } else {
                performattack(self, openborconstant("ANI_FOLLOW3"));
            }
}



void gotoidleifhealthlower(int hh)
{
    void self = getlocalvar("self");
    int myHealth = getentityproperty(self, "health");

	if(myHealth<hh)
	{
            performattack(self, openborconstant("ANI_ATTACK2"));
	}
}


void gotodeath()
{
    void self = getlocalvar("self");
    int myHealth = getentityproperty(self, "health");

	if(myHealth<1)
	{
            performattack(self, openborconstant("ANI_DIE"));
	}
}



void decreasehealthh(int amount)
{
void self = getlocalvar("self"); // Get thing of object
int curHealth = getentityproperty(self, "health");

int newHealth = curHealth - amount;

   changeentityproperty(self, "health", newHealth);
}



void makenomovetrue()
{
    void self = getlocalvar("self"); // Get thing of object

   changeentityproperty(self, "speed", 0);
}

void makespeedunit(int V)
{
    void self = getlocalvar("self"); // Get thing of object

   changeentityproperty(self, "speed", V);
}


void makenopaintrue()
{
    void self = getlocalvar("self"); // Get thing of object

   changeentityproperty(self, "nopain", 1);
}

void makenopainfalse()
{
    void self = getlocalvar("self"); // Get thing of object

   changeentityproperty(self, "nopain", 0);
}




void rotateleft()
{
    void self = getlocalvar("self"); // Get thing of object

   changeentityproperty(self, "direction", 0);
}


void rotateright()
{
    void self = getlocalvar("self"); // Get thing of object

   changeentityproperty(self, "direction", 1);
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
    float distance_z = getentityproperty(self, "z") - getentityproperty(target, "z");


    if (distance_x >= 0 && distance_x <= 180 ) // if close  //&& distance_x <= 1580 
    {
		if (distance_z >= 1 && distance_z <= 10 ) //&& distance_z <= 1 
        changeentityproperty(self, "animation", openborconstant("ANI_ATTACK1")); // Go to follow1 animation  (before it was be ANI_DIE - death animation)
    }
}


void goto_if_nearx_archer()
{
    void self = getlocalvar("self"); //Thing->enemy
    //void player = getentityproperty(self, "opponent"); //Thing->player
	void target = findtarget(self);

    float distance_x = getentityproperty(self, "x") - getentityproperty(target, "x"); // Distance x between enemy and player
    float distance_z = getentityproperty(self, "z") - getentityproperty(target, "z");


    if (distance_x >= 0 && distance_x <= 1180 ) // if close  //&& distance_x <= 1580 
    {
		//if (distance_z >= 1 && distance_z <= 10 ) //&& distance_z <= 1 
        changeentityproperty(self, "animation", openborconstant("ANI_ATTACK1")); // Go to follow1 animation  (before it was be ANI_DIE - death animation)
    }
   else 
    {
	changeentityproperty(self, "animation", openborconstant("ANI_FOLLOW1"));
    }
}


void goto_if_nearx_archer2()
{
    void self = getlocalvar("self"); //Thing->enemy
    //void player = getentityproperty(self, "opponent"); //Thing->player
	void target = findtarget(self);

    float distance_x = getentityproperty(self, "x") - getentityproperty(target, "x"); // Distance x between enemy and player
    float distance_z = getentityproperty(self, "z") - getentityproperty(target, "z");


    if (distance_x >= -1180 && distance_x <= 0 ) // if close  //&& distance_x <= 1580 
    {
        changeentityproperty(self, "animation", openborconstant("ANI_ATTACK1")); // Go to follow1 animation  (before it was be ANI_DIE - death animation)
    }
   else 
    {
	changeentityproperty(self, "animation", openborconstant("ANI_FOLLOW1"));
    }
}


void goto_if_nearx_archer22()
{
    void self = getlocalvar("self"); //Thing->enemy
    //void player = getentityproperty(self, "opponent"); //Thing->player
	void target = findtarget(self);

    float distance_x = getentityproperty(self, "x") - getentityproperty(target, "x"); // Distance x between enemy and player
    float distance_z = getentityproperty(self, "z") - getentityproperty(target, "z");


    if (distance_x >= -1180 && distance_x <= 0 ) // if close  //&& distance_x <= 1580 
    {
        changeentityproperty(self, "animation", openborconstant("ANI_ATTACK1")); // Go to follow1 animation  (before it was be ANI_DIE - death animation)
    }
   else 
    {
	changeentityproperty(self, "animation", openborconstant("ANI_PAIN2"));
    }
}

void spawn03(void vName, float fX, float fY, float fZ, int idirection)
{

	void vSpawn; //Spawn object.

	clearspawnentry(); //Clear current spawn entry.
      setspawnentry("name", vName); //Acquire spawn entity by name.

	
	vSpawn = spawn(); //Spawn in entity.

	changeentityproperty(vSpawn, "position", fX, fZ, fY); //Set spawn location.
	changeentityproperty(vSpawn, "direction", idirection); //Set direction.
    
	return vSpawn; //Return spawn.
}