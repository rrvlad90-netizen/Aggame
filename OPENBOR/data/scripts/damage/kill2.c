void kill2(int busca)
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


                      killentity(vEntity);

                      }

       }

}