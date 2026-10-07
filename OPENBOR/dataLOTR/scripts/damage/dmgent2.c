void dmgent2(int force )
{   

    
      







                 void self        = getlocalvar("self");

                int i;
		for(i=0; i<3; i++)
		{
			void p = getplayerproperty(i, "ent");
			if(p!=NULL())
			{
				if(getentityproperty(p, "a")<=0 && getentityproperty(p, "animationid")!=openborconstant("ANI_SPAwn"))
				{
					damageentity(p, self, force, 1, openborconstant("ATK_NORMAL" ));
					
				}
			}
                         else
                        {
                        NULL();
                        }
		}


}
