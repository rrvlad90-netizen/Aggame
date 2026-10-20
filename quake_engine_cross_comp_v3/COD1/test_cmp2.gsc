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
	thread door2(getent ("door2","target"));
	thread door3(getent ("door3t1","targetname"));
	thread door3(getent ("door3t2","targetname"));
	thread door4(getent ("door4","target"));
	thread door5(getent ("door5","target"));
	thread door6(getent ("door6","target"));
	thread rot_door(getent ("rot_door","target"));
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
	close1 = door1 getOrigin();
	open1 = close1 + (0,0,248);
	trigger waittill ("trigger");
	door1 moveto (open1, 1.0);
	trigger delete();
}

door2(trigger)
{
	door2 = getent (trigger.target,"targetname");
	close2 = door2 getOrigin();
	open2 = close2 + (0,0,248);
	trigger waittill ("trigger");
	door2 moveto (open2, 1.0);
	trigger delete();
}

door3(trigger)
{
	door3 = getent (trigger.target,"targetname");
	close3 = door3 getOrigin();
	open3 = close3 + (0,0,248);
	while(1)
	{
		trigger waittill ("trigger");
		door3 moveto (open3, 1.0);
		wait 3;
		door3 moveto (close3, 1.0);
	}
}

door4(trigger)
{
	door4 = getent (trigger.target,"targetname");
	close4 = door4 getOrigin();
	open4 = close4 + (0,0,-312);
	while(1)
	{
		trigger waittill ("trigger");
		door4 moveto (open4, 1.0);
		wait 3;
		door4 moveto (close4, 1.0);
	}
}

door5(trigger)
{
	door5 = getent (trigger.target,"targetname");
	close5 = door5 getOrigin();
	open5 = close5 + (0,-256,0);
	while(1)
	{
		trigger waittill ("trigger");
		door5 moveto (open5, 1.0);
		wait 3;
		door5 moveto (close5, 1.0);
	}
}

door6(trigger)
{
	door6 = getent (trigger.target,"targetname");
	close6 = door6 getOrigin();
	open6 = close6 + (0,-58,0);
	while(1)
	{
		trigger waittill ("trigger");
		door6 moveto (open6, 1.0);
		wait 3;
		door6 moveto (close6, 1.0);
	}
}

rot_door(trigger)
{
	rdoor1 = getent (trigger.target,"targetname");
	rdoor1_open = 0;
	while(1)
	{
		trigger waittill ("trigger");
		if(rdoor1_open == 0)
		{
			rdoor1 rotateyaw(-90, 0.4,0,0);
			wait 1;
			rdoor1_open = 1;
			continue;
		}
		rdoor1 rotateyaw(90, 0.4,0,0);
		wait 1;
		rdoor1_open = 0;
	}
}