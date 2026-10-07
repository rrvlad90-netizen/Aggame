void clearL(){
clearlocalvar();
}void shoot(void Shot, float dx, float dy, float dz){ 
void self = getlocalvar("self");
int Direction = getentityproperty(self, "direction");
int x = getentityproperty(self, "x");
int y = getentityproperty(self, "a");
int z = getentityproperty(self, "z");
if (Direction == 0){
dx = -dx; 
}projectile(Shot, x+dx, z+dz, y+dy, Direction, 0, 0, 0);
}
