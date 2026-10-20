main()
{
	maps\_load::main();
	maps\_wood::main();
	level.player takeallweapons();
	level.player giveWeapon("colt");
	level.player giveWeapon("m1garand");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("thompson");
	level.player switchToWeapon("thompson");

	thread tele1(getent ("tele1t1","targetname"));
	thread tele1(getent ("tele1t2","targetname"));
	thread push1(getent ("push1","targetname"));
	thread door1(getent ("door1","target"));
}

tele1(trigger)
{
	tele1 = getent (trigger.target,"targetname");
	while(1)
	{
		trigger waittill ("trigger");
		level.player setorigin(tele1.origin);
	}
}

push1(trigger)
{
	while(1)
	{
		trigger waittill ("trigger");
		level.player setVelocity((0,0,500));
	}
}

door1(trigger)
{
	door1 = getent (trigger.target,"targetname");
	trigger waittill ("trigger");
	//door1 delete();
	trigger delete();
}