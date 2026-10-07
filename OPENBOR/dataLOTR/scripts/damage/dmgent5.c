
void dmgent5(int busca,int p )
{   

    


        
        void self        = getlocalvar("self");
        void owner      = getentityproperty(self, "owner");
        void parent      = getentityproperty(self, "parent");
        void selfname = getentityproperty(self, "name");  
        void ownername = getentityproperty(owner, "name"); 
        void parentname = getentityproperty(parent, "name");   
        int  force       = 102/p;
        int force2       = force;
        

         if(ownername==busca)
           {   
                   
            damageentity(owner, self, force2, 0, openborconstant("ATK_NORMAL" ));
           }
         
       

}








    
    