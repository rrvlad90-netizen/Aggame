main()
{
	maps\_load::main();
	level.player takeallweapons();
	level.player giveWeapon("colt");
	level.player giveWeapon("m1garand");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("thompson");
	level.player switchToWeapon("thompson");
}