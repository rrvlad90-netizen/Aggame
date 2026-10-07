
void dmparent(int force )
{   

    


        
        void self        = getlocalvar("self");
        void parent      = getentityproperty(self, "parent");
        damageentity(parent, self, force, 0, openborconstant("ATK_NORMAL" ));
          
         
       

}




