void dmgent9(int busca, int force )
{   

    


        int  iEntity; 
        void vEntity;
        void self        = getlocalvar("self");
        int  iMax        = openborvariant("ent_max");   
        
        


        for(iEntity=0; iEntity<iMax; iEntity++)
        {

        
        vEntity = getentity(iEntity);
        void  vName   = getentityproperty(vEntity, "name");
        
        
        

         if(vName==busca)
           {
            
            changeentityproperty(vEntity, "noaicontrol", 1);
            damageentity(vEntity, self, force, 0, openborconstant("ATK_NORMAL" ));
           }
        }

}

