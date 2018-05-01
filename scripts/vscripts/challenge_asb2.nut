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
Convars.SetValue("asw_wire_full_random", 1);
Convars.SetValue("asw_stim_time_scale", 1.5);
Convars.SetValue("rd_override_allow_rotate_camera", 1);
Convars.SetValue("rd_horde_two_sided", 1);
Convars.SetValue("sk_asw_buzzer_melee_interval", 0.2);

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

PlayerArray <- array(8, null);
MarineArray <- array(8, null);
NameArray <- array(8, null);
PointArray <- array(8, 0);
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
	Convars.SetValue("rd_prespawn_scale", 3);
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
			ShowMessage("==== List of Chat Commands ====\n&pts  -  Display each player's points.\n&map  - Display the current map name.");
			ShowMessage("&ctr  -  See ASB2 Challenge Creator.\n~Have Fun!");
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
			
			SetPoints(attacker, (damage / 20 + 1).tointeger(), 0);
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
	return "an unknown alien.";
}

function ReckonPoints(alien_class)
{
	switch(alien_class)
	{
		case "asw_drone":
			return 2;
		case "asw_buzzer":
			return 1;
		case "asw_parasite":
			return 2;
		case "asw_shieldbug":
			return 6;
		case "asw_drone_jumper":
			return 2;
		case "asw_harvester":
			return 5;
		case "asw_parasite_defanged":
			return 1;
		case "asw_queen":
			return 8;
		case "asw_boomer":
			return 5;
		case "asw_ranger":
			return 3;
		case "asw_mortarbug":
			return 5;
		case "asw_drone_uber":
			return 4;
		case "npc_antlionguard_normal":
			return 7;
		case "npc_antlionguard_cavern":
			return 7;
		case "asw_egg":
			return 3;
	}
	return 2;
}

function ShowAllPoints()
{
	for (local i = 0; i < PlayersCounter; i++)
	{
		for (local y = 0; y < PlayersCounter; y++)
		{
			if (y == i || NameArray[y] == null)
				continue;
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
	timerScope.TimerFunc <- function()
	{
		for (local i = 0; i < PlayersCounter; i++)
		{
			for (local y = 0; y < PlayersCounter; y++)
			{
				if (y == i || NameArray[y] == null)
					continue;
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
