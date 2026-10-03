
void dmgent(int busca, int p )
{   

    


        int  iEntity; 
        void vEntity;
        void self        = getlocalvar("self");
        int  iMax        = openborvariant("ent_max");   
        int  force       = 102/p;
        int force2       = force;


        for(iEntity=0; iEntity<iMax; iEntity++)
        {

        
        vEntity = getentity(iEntity);
        void  vName   = getentityproperty(vEntity, "name");
        
        
        

         if(vName==busca)
           {
            
            damageentity(vEntity, vEntity, force2, 0, openborconstant("ATK_NORMAL" ));
           }
        }

}









