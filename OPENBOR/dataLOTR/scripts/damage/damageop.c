void damageop()
{   

    


        void self = getlocalvar("self");
	void opp = getentityproperty(self, "opponent");      
        damageentity(self, opp, 0, 0, openborconstant("ani_attack1"));      
            
          

}


void dmgeopp2()
{   

    


        void self = getlocalvar("self");
	void opp = getentityproperty(self, "opponent");      
        damageentity(opp, self, 0, 1, openborconstant("ani_attack1"));      
            
          

}