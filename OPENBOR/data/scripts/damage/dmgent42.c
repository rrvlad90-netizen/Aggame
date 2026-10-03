

void dmgent42(int p )
{   

    

       
        
        void self        = getlocalvar("self");
        void owner       = getentityproperty(self, "owner");
        void parent      = getentityproperty(self, "parent");
        void selfname    = getentityproperty(self, "name");  
        int  force       = 102/p;
        int force2       = force;
        
         void confall2    = getglobalvar("1"+self);
         void tmchange    = getglobalvar("2"+self);
         
                   
           
            damageentity(confall2, self, force2, 0, openborconstant("ATK_NORMAL2" ));
            damageentity(tmchange, self, force2, 0, openborconstant("ATK_NORMAL2" ));
           

            
            
         
         
       

}








    
    