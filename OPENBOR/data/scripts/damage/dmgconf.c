

void dmgconf()
{   

    

       
        
        void self        = getlocalvar("self");
        void confall2    = getglobalvar("1"+self);
        void tmchange    = getglobalvar("2"+self);
         
                   
           
            damageentity(confall2, self, 1000, 0, openborconstant("ATK_NORMAL" ));
            damageentity(tmchange, self, 1000, 0, openborconstant("ATK_NORMAL" ));
           

            
            
         
         
       

}








    
    