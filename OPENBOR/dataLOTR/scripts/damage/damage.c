void damage(int force, int ko,int anim)
{   

    


        void self = getlocalvar("self");
	void opp = getentityproperty(self, "opponent");      
        damageentity(opp, self, force, ko, openborconstant(anim));      
            
          

}


