void killtime()
{   

    
         
        int  busca = "tmchange";
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
            
            damageentity(vEntity, self, 10000, 0, openborconstant("ATK_NORMAL" ));
           }
        }

}

