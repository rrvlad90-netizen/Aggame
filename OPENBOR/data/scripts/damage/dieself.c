void dieself()
{   

    


        
        void self        = getlocalvar("self");
        void parent = getentityproperty(self, "parent");
        damageentity(self, parent , 10000, 0, openborconstant("ATK_NORMAL" ));
        
        


        

}
