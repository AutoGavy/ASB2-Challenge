Convars.SetValue("asw_batch_interval", 3);
Convars.SetValue("asw_realistic_death_chatter", 1);
Convars.SetValue("asw_marine_ff", 2);
Convars.SetValue("asw_marine_ff_dmg_base", 3);
Convars.SetValue("asw_custom_skill_points", 0);
Convars.SetValue("asw_adjust_difficulty_by_number_of_marines", 0);
Convars.SetValue("asw_marine_death_cam_slowdown", 0);
Convars.SetValue("asw_marine_death_protection", 0);
Convars.SetValue("asw_marine_collision", 1);
Convars.SetValue("asw_horde_override", 1);
Convars.SetValue("asw_wanderer_override", 1);
Convars.SetValue("asw_difficulty_alien_health_step", 0.2);
Convars.SetValue("asw_difficulty_alien_damage_step", 0.2);
Convars.SetValue("asw_marine_time_until_ignite", 0);
Convars.SetValue("rd_marine_ignite_immediately", 1);
Convars.SetValue("asw_marine_burn_time_easy", 60);
Convars.SetValue("asw_marine_burn_time_normal", 60);
Convars.SetValue("asw_marine_burn_time_hard", 60);
Convars.SetValue("asw_marine_burn_time_insane", 60);
Convars.SetValue("rd_override_allow_rotate_camera", 1);
Convars.SetValue("rd_increase_difficulty_by_number_of_marines", 0);
Convars.SetValue("rm_prespawn_num_biomass", 1);

const MessageShowDelay = 1.0;
const thirdUpdateRunDelay = 0.5;
const forthUpdateRunDelay = 30.0;
const UpdateBaseDelay = 2.0;
const ShowAllPointsDelay = 60.0;
PlayersCounter <- 0;
ShowAllPointsCounter <- 0;

firstUpdateRun <- true;
secondaryUpdateRun <- true;
thirdUpdateRun <- true;
forthUpdateRun <- true;
MissionsDisabled <- false;
ShouldCheckMarker <- false;

PlayerArray <- array(16, null);
MarineArray <- array(16, null);
NameArray <- array(16, null);
MineArray <- array(16, null);
PointArray <- array(16, 0);
BSkin <- array(16, true);
BMineHat <- array(16, true);
BTail <- array(16, true);
n_AutoGavy <- null;

if (Convars.GetFloat("asw_skill") == 1) //easy
{
	Convars.SetValue("asw_marine_speed_scale_easy", 1.048);
	Convars.SetValue("asw_alien_speed_scale_easy", 2.25);
	Convars.SetValue("asw_drone_acceleration", 5);
	Convars.SetValue("asw_horde_interval_min", 10);
	Convars.SetValue("asw_horde_interval_max", 30);
	Convars.SetValue("asw_director_peak_min_time", 2);
	Convars.SetValue("asw_director_peak_max_time", 4);
	Convars.SetValue("asw_director_relaxed_min_time", 15);
	Convars.SetValue("asw_director_relaxed_max_time", 30);
	Convars.SetValue("rd_prespawn_scale", 1);
}
else if (Convars.GetFloat("asw_skill") == 2) //normal
{
	Convars.SetValue("asw_marine_speed_scale_normal", 1.048);
	Convars.SetValue("asw_alien_speed_scale_normal", 1.2);
	Convars.SetValue("asw_drone_acceleration", 5);
	Convars.SetValue("asw_horde_interval_min", 15);
	Convars.SetValue("asw_horde_interval_max", 60);
	Convars.SetValue("asw_director_peak_min_time", 2);
	Convars.SetValue("asw_director_peak_max_time", 4);
	Convars.SetValue("asw_director_relaxed_min_time", 15);
	Convars.SetValue("asw_director_relaxed_max_time", 30);
	Convars.SetValue("rd_prespawn_scale", 2);
}
else if (Convars.GetFloat("asw_skill") == 3) //hard
{
	Convars.SetValue("asw_marine_speed_scale_hard", 1.048);
	Convars.SetValue("asw_alien_speed_scale_hard", 1.7);
	Convars.SetValue("asw_drone_acceleration", 8);
	Convars.SetValue("asw_horde_interval_min", 15);
	Convars.SetValue("asw_horde_interval_max", 120);
	Convars.SetValue("asw_director_peak_min_time", 2);
	Convars.SetValue("asw_director_peak_max_time", 4);
	Convars.SetValue("asw_director_relaxed_min_time", 15);
	Convars.SetValue("asw_director_relaxed_max_time", 30);
	Convars.SetValue("rd_prespawn_scale", 1);
}
else if (Convars.GetFloat("asw_skill") == 4) //insane
{
	Convars.SetValue("asw_marine_speed_scale_insane", 1.048);
	Convars.SetValue("asw_alien_speed_scale_insane", 1.8);
	Convars.SetValue("asw_drone_acceleration", 9);
	Convars.SetValue("asw_horde_interval_min", 15);
	Convars.SetValue("asw_horde_interval_max", 80);
	Convars.SetValue("asw_director_peak_min_time", 2);
	Convars.SetValue("asw_director_peak_max_time", 4);
	Convars.SetValue("asw_director_relaxed_min_time", 15);
	Convars.SetValue("asw_director_relaxed_max_time", 30);
	Convars.SetValue("rd_prespawn_scale", 0);
}
else if (Convars.GetFloat("asw_skill") == 5) //brutal
{
	Convars.SetValue("asw_marine_speed_scale_insane", 1.048);
	Convars.SetValue("asw_alien_speed_scale_insane", 1.9);
	Convars.SetValue("asw_drone_acceleration", 10);
	Convars.SetValue("asw_horde_interval_min", 15);
	Convars.SetValue("asw_horde_interval_max", 60);
	Convars.SetValue("asw_director_peak_min_time", 2);
	Convars.SetValue("asw_director_peak_max_time", 4);
	Convars.SetValue("asw_director_relaxed_min_time", 10);
	Convars.SetValue("asw_director_relaxed_max_time", 30);
	Convars.SetValue("rd_prespawn_scale", 0);
}

function Update()
{
	ShowAllPointsCounter += UpdateBaseDelay;
	
	if (firstUpdateRun)
	{
		Greeting();
		firstUpdateRun = false;
		return MessageShowDelay;
	}
	if (secondaryUpdateRun)
	{
		ReadPlayers();
		secondaryUpdateRun = false;
		return thirdUpdateRunDelay;
	}
	if (thirdUpdateRun)
	{
		ShowMessageQuick("Current Map: " + GetMapName());
		ShowMessageQuick("Type &help in main chat for more details.");
		thirdUpdateRun = false;
		return forthUpdateRunDelay;
	}
	if (forthUpdateRun)
	{
		ShouldCheckMarker = true;
		forthUpdateRun = false;
		return UpdateBaseDelay;
	}
	
	if (ShouldCheckMarker)
	{
		MissionsDisabled = false;
		local missionsMarker;
		while((missionsMarker = Entities.FindByClassname(missionsMarker, "asw_marker")) != null)
		{
			if (!NetProps.GetPropInt(missionsMarker, "m_bEnabled"));
				MissionsDisabled = true;
		}
	}
	else
		MissionsDisabled = true;

	if (ShowAllPointsCounter >= ShowAllPointsDelay && MissionsDisabled)
	{
		ShowAllPoints();
		ShowAllPointsCounter = 0;
	}
	if (!MissionsDisabled)
	{
		ShowAllPoints();
		ShouldCheckMarker = false;
	}

	return UpdateBaseDelay;
}

function OnGameEvent_entity_killed(params)
{
	local h_victim = EntIndexToHScript(params["entindex_killed"]);
	local h_attacker = EntIndexToHScript(params["entindex_attacker"]);
	
	if (!h_attacker || !h_victim)
		return;
	
	if (h_victim.GetClassname() == "asw_marine")
	{
		local victim = 128;
		for (local i = 0; i < PlayersCounter; i++)
		{
			local VictimName = NameArray[i];
			if (VictimName == "none")
				continue;
			if (h_victim.GetMarineName() == VictimName)
				victim = i;
		}
		
		if (!BMineHat[victim])
		{
			PlantIncendiaryMine(MineArray[victim].GetOrigin(), MineArray[victim].GetAngles());
			MineArray[victim].Destroy();
		}
		
		if (h_attacker.GetClassname() == "asw_marine")
		{
			if (h_attacker.GetMarineName() == h_victim.GetMarineName() && victim == 128)
			{
				ShowMessage("That dead marine has no pts because it is a robot!");
				return;
			}
			else if (h_attacker.GetMarineName() == h_victim.GetMarineName())
			{
				ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
				return;
			}
			
			local b_isBot = true;
			for (local i = 0; i < PlayersCounter; i++)
			{
				local AttackerName = NameArray[i];
				
				if (h_attacker.GetMarineName() == AttackerName)
				{
					b_isBot = false;
					if (victim == n_AutoGavy)
					{
						ShowMessage(AttackerName + " You killed ASB2 Creator!!!111");
						ShowMessage(AttackerName + " lost 50000 pts.");
						SetPoints(i, 50000, 0);
						ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
						break;
					}
					else
					{
						ShowMessage("Evil " + AttackerName + "!!!111");
						ShowMessage(AttackerName + " lost 100 pts.");
						SetPoints(i, 100, 0);
						
						if (victim == 128)
							ShowMessage("That dead marine has no pts because it is a robot!");
						else
							ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
						
						break;
					}
				}
			}
			if (b_isBot)
				ShowMessage("Evil robot!");
		}
		else if (victim == 128)
		{
			ShowMessage("This Marine has no pts because it is a robot!");
			return;
		}
		else if (h_attacker.IsAlien())
		{
			ShowMessage(NameArray[victim] + SortAlienName(h_attacker.GetClassname()));
			ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		}
		else if (h_attacker.GetClassname() == "asw_trigger_fall")
		{
			ShowMessage(NameArray[victim] + " has fallen to his demise.");
			ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		}
		else if (h_attacker.GetClassname() == "env_fire")
		{
			ShowMessage(NameArray[victim] + " was burned alive.");
			ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		}
		else
			ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		
		return;
	}
	
	if (h_attacker.GetClassname() == "asw_marine" && h_victim.IsAlien())
	{
		local attacker = 128;
		for (local i = 0; i < PlayersCounter; i++)
		{
			local AttackerName = NameArray[i];
			if (h_attacker.GetMarineName() == AttackerName)
				attacker = i;
		}
		if (attacker == 128)
			return;
		
		SetPoints(attacker, ReckonPoints(h_victim.GetClassname()), 1);
	}
}

function OnGameEvent_player_say(params)
{
	if (!("text" in params))
		return;
	else if (params["text"] == null)
		return;
	
	switch ((params["text"]).tolower())
	{
		case "&help":
			ShowMessage("==== List of Chat Commands ====\n&pts  -  Display each player's points.\n&map  -  Display the current map name.");
			ShowMessage("&skin  -  Give a black skin to player who has over 100 points.\nPage 1/2     Type &help2 to see next page.");
			break;
		case "&help2":
			ShowMessage("&mine  -  Give a Flame Mine hat to player who has over 200 points.\n&tail  -  Give a rocket tail to player who has over 400 points.");
			ShowMessage("&ctr  -  See ASB2 Challenge Creator.\n~Have Fun!\nPage 2/2     Type &help to see previous page.");
			break;
		case "&pts":
			ShowAllPointsLate();
			break;
		case "&map":
			ShowMessage("Current Map: " + GetMapName());
			break;
		case "&ctr":
			ShowMessage("ASB2 Challenge is made by AutoGavy. You can report any bugs on the workshop page.");
			break;
		case "&skin":
			SetSkin();
			break;
		case "&mine":
			SetMineHat();
			break;
		case "&tail":
			SetTail();
			break;
	}
}

function OnGameEvent_player_heal(params)
{
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (NameArray[i] == "Faith" || NameArray[i] == "Bastille")
			SetPoints(i, 1, 1);
	}
}

function OnTakeDamage_Alive_Any(h_victim, inflictor, h_attacker, weapon, damage, damageType, ammoName) 
{
	if  (h_attacker != null && h_attacker.IsAlien()) 
	{
		if (h_victim != null && h_victim.GetClassname() == "asw_marine")
		{
			local victim = 128;
			for (local i = 0; i < PlayersCounter; i++)
			{
				local VictimName = NameArray[i];
				if (h_victim.GetMarineName() == VictimName)
					victim = i;
			}
			if (victim == 128)
				return damage;
			
			SetPoints(victim, ReckonPoints(h_attacker.GetClassname()), 0);
		}
	}
	else if (h_attacker != null && h_attacker.GetClassname() == "asw_marine")
	{
		if (h_victim != null && h_victim.GetClassname() == "asw_marine")
		{
			local attacker = 128;
			for (local i = 0; i < PlayersCounter; i++)
			{
				local AttackerName = NameArray[i];
				if (h_attacker.GetMarineName() == AttackerName)
					attacker = i;
			}
			if (attacker == 128)
				return damage;
			SetPoints(attacker, ((damage / 20 + 10) * 5).tointeger(), 0);
		}
		else if (weapon != null && h_victim.IsAlien() && weapon.GetClassname() == "asw_weapon_tesla_gun")
		{
			local attacker = 128;
			for (local i = 0; i < PlayersCounter; i++)
			{
				local AttackerName = NameArray[i];
				if (h_attacker.GetMarineName() == AttackerName)
					attacker = i;
			}
			if (attacker == 128)
				return damage;
			SetPoints(attacker, 1, 1);
		}
	}
	return damage;
}

function Greeting()
{
	local player = null;
	while((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.GetNetworkIDString() == "STEAM_1:0:176990841") //AutoGavy
			ClientPrint(player, 3, "=д= ASB2 Creator!");
		else
			ClientPrint(player, 3, "Welcome to ASB2 game mode, " + player.GetPlayerName() + ".");
	}
}

function ReadPlayers()
{
	local player = null;
	while((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.GetNetworkIDString() == "STEAM_1:0:176990841") //AutoGavy
			n_AutoGavy = PlayersCounter;
		PlayerArray[PlayersCounter] = player;
		local marine = NetProps.GetPropEntity(player, "m_hMarine");
		if (marine != null)
		{
			MarineArray[PlayersCounter] = marine;
			NameArray[PlayersCounter] = marine.GetMarineName();
		}
		PlayersCounter++;
	}
	for (local i = 0; i < PlayersCounter; i++)
	{
		for (local y = 0; y < PlayersCounter; y++)
		{
			if (y == i || NameArray[y] == null)
				continue;
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " have 0 pts.");
		}
		ClientPrint(PlayerArray[i], 3, "You have: 0 pts.");
	}
}

function ShowMessage(message)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.message <- message;
	timerScope.TimerFunc <- function()
	{
		local player = null;
		while((player = Entities.FindByClassname(player, "player")) != null)
			ClientPrint(player, 3, message);
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowMessageQuick(message)
{
	local player = null;
	while((player = Entities.FindByClassname(player, "player")) != null)
		ClientPrint(player, 3, message);
}

function SetPoints(player, points, action) //0 to reduce, 1 to add
{
	if (action)
		PointArray[player] += points;
	else
		PointArray[player] -= points;
}

function SortAlienName(alien_class)
{
	switch(alien_class)
	{
		case "asw_drone":
			return " was killed by a Drone.";
		case "asw_buzzer":
			return " was killed by a Buzzer.";
		case "asw_parasite":
			return " ate a Parasite.";
		case "asw_shieldbug":
			return " was trampled by a Shieldbug.";
		case "asw_drone_jumper":
			return " was killed by a Jumper Drone.";
		case "asw_harvester":
			return " was killed by a Harvester.";
		case "asw_parasite_defanged":
			return " ate a Xenomite.";
		case "asw_queen":
			return " was killed by an Alien Queen.";
		case "asw_boomer":
			return " was kicked to death by a Boomer.";
		case "asw_boomer_blob":
			return " ate a Boomer blob."
		case "asw_ranger":
			return " ate a Ranger glob.";
		case "asw_mortarbug":
			return " was killed by a Mortarbug.";
		case "asw_drone_uber":
			return " was killed by a Uber Drone.";
		case "npc_antlionguard_normal":
			return " tried to race with an Antlionguard.";
		case "npc_antlionguard_cavern":
			return " tried to race with a Cavern Antlionguard.";
		case "asw_egg":
			return " ate an Alien Egg.";
		case "asw_alien_goo":
			return " was killed by an Alien Biomass.";
	}
	return " was killed by an unknown alien.";
}

function ReckonPoints(alien_class)
{
	switch(alien_class)
	{
		case "asw_drone":
			return 10;
		case "asw_buzzer":
			return 5;
		case "asw_parasite":
			return 10;
		case "asw_shieldbug":
			return 30;
		case "asw_drone_jumper":
			return 10;
		case "asw_harvester":
			return 25;
		case "asw_parasite_defanged":
			return 5;
		case "asw_queen":
			return 40;
		case "asw_boomer":
			return 25;
		case "asw_ranger":
			return 15;
		case "asw_mortarbug":
			return 25;
		case "asw_drone_uber":
			return 20;
		case "npc_antlionguard_normal":
			return 35;
		case "npc_antlionguard_cavern":
			return 35;
		case "asw_egg":
			return 15;
	}
	return 2;
}

function ShowAllPoints()
{
	local readMarker = 0;
	for (local i = 0; i < PlayersCounter; i++)
	{
		for (local y = 0; y < PlayersCounter; y++)
		{
			if (y == i || NameArray[y] == null)
				continue;
			else
				readMarker++;
			if (readMarker > 4)
			{
				ShowPointsHelper(i, y);
				break;
			}
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " have " + PointArray[y] + " pts.");
		}
		ClientPrint(PlayerArray[i], 3, "You have: " + PointArray[i] + " pts.");
	}
}

function ShowAllPointsLate()
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.PointArray <- PointArray;
	timerScope.ShowPointsHelper <- ShowPointsHelper;
	timerScope.TimerFunc <- function()
	{
		local readMarker = 0;
		for (local i = 0; i < PlayersCounter; i++)
		{
			for (local y = 0; y < PlayersCounter; y++)
			{
				if (y == i || NameArray[y] == null)
					continue;
				else
					readMarker++;
				if (readMarker > 4)
				{
					ShowPointsHelper(i, y);
					break;
				}
				ClientPrint(PlayerArray[i], 3, NameArray[y] + " have " + PointArray[y] + " pts.");
			}
			ClientPrint(PlayerArray[i], 3, "You have: " + PointArray[i] + " pts.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowPointsHelper(i, y)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 2.5);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.PointArray <- PointArray;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayersCounter; y++)
		{
			if (y == i || NameArray[y] == null)
				continue;
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " have " + PointArray[y] + " pts.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function SetSkin()
{
	local count = 0;
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (BSkin[i] && PointArray[i] >= 200)
		{
			MarineArray[i].__KeyValueFromString("rendercolor", "0,0,0");
			BSkin[i] = false;
			count++;
		}
	}
	ShowMessage("Done for " + count + " players.");
}

function SetMineHat()
{
	local count = 0;
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (BMineHat[i] && PointArray[i] >= 400)
		{
			MineArray[i] = CreateProp("prop_dynamic", MarineArray[i].GetOrigin() + Vector(0, 0, 68), "models/items/mine/mine.mdl", 1);
			
			local marine = MarineArray[i];
			EntFireByHandle(MineArray[i], "SetDefaultAnimation", "BindPose", 0, marine, marine);
			EntFireByHandle(MineArray[i], "SetAnimation", "BindPose", 0, self, self);
			EntFireByHandle(MineArray[i], "DisableShadow", "", 0, marine, marine);
			EntFireByHandle(MineArray[i], "SetParent", "!activator", 0, marine, marine);
			EntFireByHandle(MineArray[i], "FireUser1", "", 0, marine, marine);
			
			BMineHat[i] = false;
			count++;
		}
	}
	ShowMessage("Done for " + count + " players.");
}

function SetTail()
{
	local count = 0;
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (BTail[i] && PointArray[i] >= 600)
		{
			local particle = Entities.CreateByClassname("info_particle_system");
			particle.__KeyValueFromString("effect_name", "rocket_trail_small_glow");
			particle.__KeyValueFromString("start_active", "1");
			particle.SetOrigin(MarineArray[i].GetOrigin() + Vector(0, 0, 30));
			particle.SetAnglesVector(MarineArray[i].GetAngles());
			
			local particle2 = Entities.CreateByClassname("info_particle_system");
			particle2.__KeyValueFromString("effect_name", "rocket_trail_small");
			particle2.__KeyValueFromString("start_active", "1");
			particle2.SetOrigin(MarineArray[i].GetOrigin() + Vector(0, 0, 30));
			particle2.SetAnglesVector(MarineArray[i].GetAngles());
			
			DoEntFire("!self", "SetParent", "!activator", 0, MarineArray[i], particle);
			DoEntFire("!self", "SetParent", "!activator", 0, MarineArray[i], particle2);
			
			particle.Spawn();
			particle.Activate();
			particle2.Spawn();
			particle2.Activate();
			
			BTail[i] = false;
			count++;
		}
	}
	ShowMessage("Done for " + count + " players.");
}
