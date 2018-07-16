ifFirstRun <- true;
if (ifFirstRun)
{
	Entities.First().ValidateScriptScope();
	g_worldspawnScope <- Entities.First().GetScriptScope();
	local MainTimersTable = {};
	g_worldspawnScope.MainTimersTable <- MainTimersTable;
	ifFirstRun = false;	
}

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

const strDelimiter = ":";
const MessageShowDelay = 1.0;
const thirdUpdateRunDelay = 0.5;
const forthUpdateRunDelay = 30.0;
const UpdateBaseDelay = 2.0;
PointBonus <- 1;
PlayersCounter <- 0;
SaveDataCounter <- 0;

firstUpdateRun <- true;
secondaryUpdateRun <- true;
thirdUpdateRun <- true;
forthUpdateRun <- true;
FlamerDetected <- false;

PlayerArray <- array(16, null);
MarineArray <- array(16, null);
NameArray <- array(16, null);
MineArray <- array(16, null);
PointArray <- array(16, 0);
KillArray <- array(16, 0);
ShootArray <- array(16, 0);
DeathArray <- array(16, 0);
BSkin <- array(16, true);
BMineHat <- array(16, true);
BTail <- array(16, true);
n_AutoGavy <- null;

timer_LowerBound <- 2.2;
timer_UpperBound <- 4.0;
victimSpeedBoosted <- 1.6;

alienNamesArray <- [
"asw_drone",
"asw_buzzer",
"asw_parasite",
"asw_shieldbug",
"asw_grub",
"asw_drone_jumper",
"asw_harvester",
"asw_parasite_defanged",
"asw_queen",
"asw_boomer",
"asw_ranger",
"asw_mortarbug",
"asw_shaman",
"asw_drone_uber",
"npc_antlionguard_normal",
"npc_antlionguard_cavern"
];

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
	PointBonus = 0.1;
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
	PointBonus = 0.2;
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
	PointBonus = 0.4;
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
	PointBonus = 0.8;
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
	SaveDataCounter += UpdateBaseDelay;
	
	if (SaveDataCounter >= 3)
		SaveData();
	
	if (firstUpdateRun)
	{
		Greeting();
		firstUpdateRun = false;
		return MessageShowDelay;
	}
	if (secondaryUpdateRun)
	{
		ReadPlayers();
		ReadDataFile();
		ShowAllPoints();
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
		forthUpdateRun = false;
		return UpdateBaseDelay;
	}
	
	return UpdateBaseDelay;
}

function OnGameEvent_entity_killed(params)
{
	local h_victim = EntIndexToHScript(params["entindex_killed"]);
	local h_attacker = EntIndexToHScript(params["entindex_attacker"]);
	local h_inflictor = EntIndexToHScript(params["entindex_inflictor"]);

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
		
		if (victim != 128)
		{
			DeathArray[victim]++;
			SaveData();
		}
		
		if (!BMineHat[victim])
		{
			PlantIncendiaryMine(MineArray[victim].GetOrigin(), MineArray[victim].GetAngles());
			MineArray[victim].Destroy();
		}
		
		if (h_inflictor != null)
		{
			if (h_inflictor.GetClassname() == "asw_burning")
			{
				ShowMessage(NameArray[victim] + " was burned alive.");
				//ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
				return;
			}
		}
		
		if (h_attacker.GetClassname() == "asw_marine")
		{
			/*
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
			*/
			
			local b_isBot = true;
			for (local i = 0; i < PlayersCounter; i++)
			{
				local AttackerName = NameArray[i];
				
				if (h_attacker.GetMarineName() == AttackerName)
				{
					b_isBot = false;
					if (victim == i)
					{
						SetPoints(i, 40, 0);
						break;
					}
					if (victim == n_AutoGavy)
					{
						ShowMessage(AttackerName + " You killed ASB2 Creator!!!111");
						//ShowMessage(AttackerName + " lost 100 pts.");
						SetPoints(i, 80, 0);
						//ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
						break;
					}
					else
					{
						ShowMessage("Evil " + AttackerName + "!!!111");
						//ShowMessage(AttackerName + " lost 100 pts.");
						SetPoints(i, 80, 0);
						
						//if (victim == 128)
						//	ShowMessage("That dead marine has no pts because it is a robot!");
						//else
						//	ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
						
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
			//ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		}
		else if (h_attacker.GetClassname() == "asw_trigger_fall")
		{
			ShowMessage(NameArray[victim] + " has fallen to his demise.");
			//ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		}
		else if (h_attacker.GetClassname() == "env_fire")
		{
			ShowMessage(NameArray[victim] + " was burned alive.");
			//ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		}
		//else
		//	ShowMessage(NameArray[victim] + " has a total of " + PointArray[victim] + " pts.");
		
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
		KillArray[attacker]++;
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
			ShowMessage("==== List of Chat Commands ====\n&map  -  Display the current map name.\n&pts  -  Display each player's points.");
			ShowMessage("&kill  -  Display each player's kills.\nPage 1/3     Type &help2 to see next page.");
			break;
		case "&help2":
			ShowMessage("&shoot  -  Display each player's shoots.\n&death  -  Display each player's deaths.");
			ShowMessage("&skin  -  Give a black skin to player who has over 2000 points.");
			ShowMessage("&mine  -  Give a Flame Mine hat to player who has over 4000 points.\nPage 2/3     Type &help3 to see next page.");
			break;
		case "&help3":
			ShowMessage("&tail  -  Give a rocket tail to player who has over 8000 points.");
			ShowMessage("&ctr  -  See ASB2 Challenge Creator.\n~Have Fun!\nPage 3/3     Type &help to see previous page.");
			break;
		case "&pts":
			ShowAllPointsLate();
			break;
		case "&kill":
			ShowKills();
			break;
		case "&shoot":
			ShowShoots();
			break;
		case "&death":
			ShowDeaths();
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

function IfAlienFunc(testingEntity)
{
	for (local i = 0; i < alienNamesArray.len(); i++)
	{
		if (testingEntity.GetClassname() == alienNamesArray[i])
			return true;
	}
	return false;
}

function TimerFunc()
{
	DoEntFire("!self", "Disable", "", 0, null, self);
	DoEntFire("!self", "AddOutput", "speedscale 1.0", 0, null, h_victim);
}

function VictimDeathFunc()
{
	//self.DisconnectOutput("OnDeath", "VictimDeathFunc");
	timer.DisconnectOutput("OnTimer", "TimerFunc");
	timer.Destroy();
	delete g_worldspawnScope.MainTimersTable[self];
}

function OnTakeDamage_Alive_Any(h_victim, inflictor, h_attacker, weapon, damage, damageType, ammoName) 
{
	/*if (h_attacker != null && h_attacker.IsAlien())
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
			
			SetPoints(victim, (ReckonPoints(h_attacker.GetClassname()) / 3).tointeger(), 0);
		}
	}
	else */
	
	if (FlamerDetected)
	{
		if (inflictor != null && inflictor.GetClassname() == "asw_flamer_projectile" && h_victim != null && IfAlienFunc(h_victim))
		{
			if (h_victim in g_worldspawnScope.MainTimersTable)
			{
				DoEntFire("!self", "ResetTimer", "", 0, null, g_worldspawnScope.MainTimersTable[h_victim]);
			}
			else
			{
				DoEntFire("!self", "AddOutput", "speedscale " + victimSpeedBoosted.tostring(), 0, null, h_victim);
				
				local timer = Entities.CreateByClassname("logic_timer");

				timer.__KeyValueFromInt("UseRandomTime", 1);
				timer.__KeyValueFromFloat("LowerRandomBound", timer_LowerBound);
				timer.__KeyValueFromFloat("UpperRandomBound", timer_UpperBound);
				DoEntFire("!self", "Disable", "", 0, null, timer);
				
				timer.ValidateScriptScope();
				local timerScope = timer.GetScriptScope();
				timerScope.h_victim <- h_victim;
				timerScope.TimerFunc <- TimerFunc;
				timer.ConnectOutput("OnTimer", "TimerFunc");
				DoEntFire("!self", "Enable", "", 0, null, timer);
				
				g_worldspawnScope.MainTimersTable[h_victim] <- timer;
				
				h_victim.ValidateScriptScope();
				local victimScope = h_victim.GetScriptScope();
				victimScope.VictimDeathFunc <- VictimDeathFunc;
				victimScope.timer <- timer;
				victimScope.g_worldspawnScope <- g_worldspawnScope;
				h_victim.ConnectOutput("OnDeath", "VictimDeathFunc");
			}
		}
	}
	
	if (h_attacker != null && h_attacker.GetClassname() == "asw_marine")
	{
		if (!FlamerDetected && inflictor != null && inflictor.GetClassname() == "asw_flamer_projectile")
		{
			local attacker = 128;
			for (local i = 0; i < PlayersCounter; i++)
			{
				local AttackerName = NameArray[i];
				if (h_attacker.GetMarineName() == AttackerName)
					attacker = i;
			}
			
			if (weapon != null && weapon.GetClassname() == "asw_weapon_flamer")
			{
				local FlamerUserName = "A Robot";
				
				if (attacker != 128)
					FlamerUserName = PlayerArray[attacker].GetPlayerName();
					
				ShowMessageQuick("Flamethrower Detected! The First User: " + FlamerUserName + ".");
				ShowMessage("OnFire Settings Enabled.");
				FlamerDetected = true;
			}
		}
		
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
			
			if (h_victim.GetMarineName() != h_attacker.GetMarineName())
				SetPoints(attacker, (damage / 20).tointeger(), 0);
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

function OnGameEvent_player_heal(params)
{
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (NameArray[i] == "Faith" || NameArray[i] == "Bastille")
			SetPoints(i, 1, 1);
	}
}

function OnGameEvent_weapon_fire(params)
{
	local marine = EntIndexToHScript(params["marine"]);
	local weapon = EntIndexToHScript(params["weapon"]);
	
	if (!marine || !weapon)
		return;
	
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (marine.GetMarineName() == NameArray[i])
		{
			if (weapon.GetClassname() == "asw_weapon_heal_gun" || weapon.GetClassname() == "asw_weapon_heal_grenade" || weapon.GetClassname() == "asw_weapon_medical_satchel" || weapon.GetClassname() == "asw_weapon_ammo_bag" || weapon.GetClassname() == "asw_weapon_ammo_satchel")
				return;
			
			ShootArray[i]++;
			return;
		}
	}
}

//Data File: Points, Kills, Shoots, Deaths
function ReadDataFile()
{
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (PlayerArray[i] != null)
		{
			local BaseFileName = split(PlayerArray[i].GetNetworkIDString(), ":");
			local FileName = "asb2data_" + BaseFileName[1] + BaseFileName[2];
			local FileReader = FileToString(FileName);

			if (FileReader == "")
				StringToFile(FileName,  "0:0:0:0");
			else
			{
				local strArrayContent = split(FileReader, strDelimiter);
				PointArray[i] = strArrayContent[0].tointeger();
				KillArray[i] = strArrayContent[1].tointeger();
				ShootArray[i] = strArrayContent[2].tointeger();
				DeathArray[i] = strArrayContent[3].tointeger();
			}
		}
	}
}

function SaveData()
{
	for (local i = 0; i < PlayersCounter; i++)
	{
		if (PlayerArray[i] != null)
		{
			local BaseFileName = split(PlayerArray[i].GetNetworkIDString(), ":");
			local FileName = "asb2data_" + BaseFileName[1] + BaseFileName[2];
			
			StringToFile(FileName, PointArray[i].tostring() + strDelimiter + KillArray[i].tostring() + strDelimiter + ShootArray[i].tostring() + strDelimiter + DeathArray[i].tostring());
		}
	}
	SaveDataCounter = 0;
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

function SetPoints(player_index, points, action) //0 to reduce, 1 to add
{
	if (action)
		PointArray[player_index] += (points * PointBonus).tointeger();
	else
		PointArray[player_index] -= (points * PointBonus).tointeger();
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
	return 5;
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
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + PointArray[y] + " pts.");
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
				ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + PointArray[y] + " pts.");
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
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + PointArray[y] + " pts.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowKills()
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.KillArray <- KillArray;
	timerScope.ShowKillsHelper <- ShowKillsHelper;
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
					ShowKillsHelper(i, y);
					break;
				}
				ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + KillArray[y] + " kills.");
			}
			ClientPrint(PlayerArray[i], 3, "You have: " + KillArray[i] + " kills.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowKillsHelper(i, y)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 2.5);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.KillArray <- KillArray;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayersCounter; y++)
		{
			if (y == i || NameArray[y] == null)
				continue;
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + KillArray[y] + " kills.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowShoots()
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.ShootArray <- ShootArray;
	timerScope.ShowShootsHelper <- ShowShootsHelper;
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
					ShowShootsHelper(i, y);
					break;
				}
				ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + ShootArray[y] + " shoots.");
			}
			ClientPrint(PlayerArray[i], 3, "You have: " + ShootArray[i] + " shoots.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowShootsHelper(i, y)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 2.5);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.ShootArray <- ShootArray;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayersCounter; y++)
		{
			if (y == i || NameArray[y] == null)
				continue;
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + ShootArray[y] + " shoots.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowDeaths()
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.DeathArray <- DeathArray;
	timerScope.ShowDeathsHelper <- ShowDeathsHelper;
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
					ShowDeathsHelper(i, y);
					break;
				}
				ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + DeathArray[y] + " deaths.");
			}
			ClientPrint(PlayerArray[i], 3, "You have: " + DeathArray[i] + " deaths.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowDeathsHelper(i, y)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 2.5);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayersCounter <- PlayersCounter;
	timerScope.PlayerArray <- PlayerArray;
	timerScope.NameArray <- NameArray;
	timerScope.DeathArray <- DeathArray;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayersCounter; y++)
		{
			if (y == i || NameArray[y] == null)
				continue;
			ClientPrint(PlayerArray[i], 3, NameArray[y] + " has " + DeathArray[y] + " deaths.");
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
		if (BSkin[i] && PointArray[i] >= 2000)
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
		if (BMineHat[i] && PointArray[i] >= 4000)
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
		if (BTail[i] && PointArray[i] >= 8000)
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

g_ModeScript.OnTakeDamage_Alive_Any <- OnTakeDamage_Alive_Any;
