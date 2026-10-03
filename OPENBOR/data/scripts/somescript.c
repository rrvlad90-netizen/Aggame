void  main(){
                void self = getlocalvar("self");
                int iPIndex = getentityproperty(self,"playerindex"); //Get player index
                void p1 = playerkeys(iPIndex, 0, "moveright");
                void p2 = playerkeys(iPIndex, 0, "moveleft");

                void p3 = playerkeys(iPIndex, 0, "attack");
                                 if ((p2)&&(p3)&&(frame == 3)){
                     changeentityproperty(self, "direction", 0 );
                changeentityproperty(self, "animation", openborconstant("ANI_ATTACK2"));
		}
		                             if ((p1)&&(p3)&&(frame == 3)){
                     changeentityproperty(self, "direction", -1 );
                changeentityproperty(self, "animation", openborconstant("ANI_ATTACK2"));
		}
                 if ((p3)&&(frame == 3)){

                changeentityproperty(self, "animation", openborconstant("ANI_ATTACK2"));
		}
}