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

const intVersion = 1;
const strDelimiter = ":";
const MessageShowDelay = 1.0;
const thirdUpdateRunDelay = 0.5;
const UpdateBaseDelay = 2.0;
const StopFunc = 5000;
PlayerCounter <- 0;

firstUpdateRun <- true;
secondaryUpdateRun <- true;
thirdUpdateRun <- true;
forthUpdateRun <- true;
FlamerDetected <- false;
b3Checks <- true;
bInPRO <- false;

n_AutoGavy <- null;

timer_LowerBound <- 2.2;
timer_UpperBound <- 4.0;
victimSpeedBoosted <- 1.6;

PlayerManager <- [];
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

class cPlayer
{
	constructor(vplayer, vpoints = 0, vkills = 0, vshots = 0, vdeaths = 0)
	{
		player = vplayer;
		points = vpoints;
		deaths = vdeaths;
		tkills = vkills;
		tshots = vshots;

		if (vplayer != null)
		{
			name = vplayer.GetPlayerName();
			id = vplayer.GetNetworkIDString();
			
			local hmarine = NetProps.GetPropEntity(player, "m_hMarine");
			if (hmarine != null)
				marine = hmarine;
		}
	}
	
	tkills = 0;
	tshots = 0;
	points = 0;
	deaths = 0;
	kills = 0;
	shots = 0;
	bskin = true;
	bmine = true;
	btail = true;
	bammo = true;
	bsurvived = true;
	bflare = true;
	bscale = true;
	bHasSkin = 0;
	bHasTail = 0;
	bHasMine = 0;
	bHasAmmo = 0;
	bHasScale = 0;
	player = null;
	name = null;
	marine = null;
	id = null;
	index = null;
	hammo = null;
	hmine = null;
	status = "Survived."
	
	function HasSkin(val)
	{
		if (val)
			bHasSkin = 1;
		else
			bHasSkin = 0;
		Save();
	}
	function HasTail(val)
	{
		if (val)
			bHasTail = 1;
		else
			bHasTail = 0;
		Save();
	}
	function HasMine(val)
	{
		if (val)
			bHasMine = 1;
		else
			bHasMine = 0;
		Save();
	}
	function HasAmmo(val)
	{
		if (val)
			bHasAmmo = 1;
		else
			bHasAmmo = 0;
		Save();
	}
	function HasScale(val)
	{
		bHasScale = val;
		Save();
	}
	function Save()
	{
		local BaseFileName = split(id, ":");
		local FileName = "asb2data_" + BaseFileName[1] + BaseFileName[2];
		
		StringToFile(FileName, points.tostring() + strDelimiter + tkills.tostring() + strDelimiter + tshots.tostring() + strDelimiter + deaths.tostring() + strDelimiter + intVersion + strDelimiter + bHasSkin.tostring() + strDelimiter + bHasTail.tostring() + strDelimiter + bHasMine.tostring() + strDelimiter + bHasAmmo.tostring() + strDelimiter + bHasScale.tostring());
	}
}

ifFirstRun <- true;
if (ifFirstRun)
{
	Entities.First().ValidateScriptScope();
	g_worldspawnScope <- Entities.First().GetScriptScope();
	local MainTimersTable = {};
	g_worldspawnScope.MainTimersTable <- MainTimersTable;
	ifFirstRun = false;	
}

if (Convars.GetFloat("asw_skill") == 1) //easy
{
	Convars.SetValue("asw_marine_speed_scale_easy", 0.96);
	Convars.SetValue("asw_alien_speed_scale_easy", 0.7);
	Convars.SetValue("asw_drone_acceleration", 5);
	Convars.SetValue("asw_horde_interval_min", 10);
	Convars.SetValue("asw_horde_interval_max", 30);
	Convars.SetValue("asw_director_peak_min_time", 2);
	Convars.SetValue("asw_director_peak_max_time", 4);
	Convars.SetValue("asw_director_relaxed_min_time", 15);
	Convars.SetValue("asw_director_relaxed_max_time", 30);
	Convars.SetValue("asw_difficulty_alien_health_step", 0.3);
}
else if (Convars.GetFloat("asw_skill") == 2) //normal
{
	Convars.SetValue("asw_marine_speed_scale_normal", 1.0);
	Convars.SetValue("asw_alien_speed_scale_normal", 1.0);
	Convars.SetValue("asw_drone_acceleration", 5);
	Convars.SetValue("asw_horde_interval_min", 15);
	Convars.SetValue("asw_horde_interval_max", 60);
	Convars.SetValue("asw_director_peak_min_time", 2);
	Convars.SetValue("asw_director_peak_max_time", 4);
	Convars.SetValue("asw_director_relaxed_min_time", 15);
	Convars.SetValue("asw_director_relaxed_max_time", 30);
	Convars.SetValue("asw_difficulty_alien_health_step", 0.3);
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
	Convars.SetValue("asw_difficulty_alien_health_step", 0.2);
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
	Convars.SetValue("asw_difficulty_alien_health_step", 0.2);
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
	Convars.SetValue("asw_difficulty_alien_health_step", 0);
	Convars.SetValue("asw_drone_health", 88);
	Convars.SetValue("asw_ranger_health", 222);
	Convars.SetValue("asw_drone_uber_health", 1300);
	Convars.SetValue("asw_shaman_health", 129);
	Convars.SetValue("rd_harvester_health", 440);
	Convars.SetValue("rd_mortarbug_health", 770);
	Convars.SetValue("rd_parasite_health", 55);
	Convars.SetValue("rd_parasite_defanged_health", 22);
	Convars.SetValue("rd_shieldbug_health", 2200);
	Convars.SetValue("sk_asw_buzzer_health", 66);
	Convars.SetValue("sk_antlionguard_health", 1000);
}

function Update()
{
	if (b3Checks)
	{
		CheckDifficulty();
		if (Convars.GetFloat("asw_skill") == 1 || Convars.GetFloat("asw_skill") == 2)
			return StopFunc;
		
		if (firstUpdateRun)
		{
			Greeting();
			firstUpdateRun = false;
			return MessageShowDelay;
		}
		if (secondaryUpdateRun)
		{
			ASB2SetUp();
			ReadPlayers();
			ReadDataFile();
			SetGifts();
			GreetShowAllPoints();
			secondaryUpdateRun = false;
			return thirdUpdateRunDelay;
		}
		if (thirdUpdateRun)
		{
			DisplayMsg("Current Map: " + GetMapName(), 0);
			DisplayMsg("Type &help in main chat for more details.", 0);
			thirdUpdateRun = false;
			b3Checks = false;
			CheckMissionComplete();
			return UpdateBaseDelay;
		}
	}

	return StopFunc;
}

function OnGameEvent_entity_killed(params)
{
	local h_victim = null;
	local h_attacker = null;
	local h_inflictor = null;
	
	if ("entindex_killed" in params)
		h_victim = EntIndexToHScript(params["entindex_killed"]);
	if ("entindex_attacker" in params)
		h_attacker = EntIndexToHScript(params["entindex_attacker"]);
	if ("entindex_inflictor" in params)
		h_inflictor = EntIndexToHScript(params["entindex_inflictor"]);
	
	if (!h_victim)
		return;

	local victimIndex = null;
	local attackerIndex = null;
	if (h_victim.GetClassname() == "asw_marine")
	{
		if (h_victim.IsInhabited())
			victimIndex = GetPlayerIndex(h_victim.GetCommander());
		
		if (victimIndex != null)
		{
			PlayerManager[victimIndex].deaths++;
			PlayerManager[victimIndex].status = "Not survived.";
			PlayerManager[victimIndex].bsurvived = false;
		}
		
		if (victimIndex != null && !PlayerManager[victimIndex].bmine)
		{
			PlantIncendiaryMine(h_victim.GetOrigin(), h_victim.GetAngles());
			PlayerManager[victimIndex].hmine.Destroy();
		}
		
		if (victimIndex != null && !PlayerManager[victimIndex].bammo)
		{
			local ammo = Entities.CreateByClassname("asw_ammo_drop");
			ammo.__KeyValueFromInt("percent_remaining", 20);
			ammo.SetOrigin(PlayerManager[victimIndex].hammo.GetOrigin() + Vector(0, 0, -32));
			ammo.Spawn();
			PlayerManager[victimIndex].hammo.Destroy();
		}
		
		if (victimIndex != null && h_inflictor != null  && PlayerManager[victimIndex].player != null)
		{
			if (h_inflictor.GetClassname() == "asw_burning")
			{
				if (PlayerManager[victimIndex].player != null)
					DisplayMsg(PlayerManager[victimIndex].name + " was burned alive.");
				else
					DisplayMsg(PlayerManager[victimIndex].marine.GetMarineName() + " was burned alive.");
				
				return;
			}
		}
		
		if (!h_attacker)
			return;

		if (h_attacker.GetClassname() == "asw_marine")
		{
			if (h_attacker.IsInhabited())
				attackerIndex = GetPlayerIndex(h_attacker.GetCommander());
			
			if (attackerIndex == null)
				DisplayMsg("Evil Robot!");
			else if (victimIndex == attackerIndex)
			{
				DisplayMsg("Console: o", 0.06);
				if (h_inflictor != null && h_inflictor.GetClassname() == "asw_grenade_cluster")
					SetPoints(attackerIndex, 30, 0);
			}
			else if (victimIndex == n_AutoGavy)
			{
				DisplayMsg(PlayerManager[attackerIndex].name + " Extremly Evil !!!111");
				SetPoints(attackerIndex, 100, 0);
			}
			else
			{
				if (PlayerManager[attackerIndex].player != null && PlayerManager[attackerIndex].player != null)
					DisplayMsg("Evil " + PlayerManager[attackerIndex].name + "!!!111");
				else
					DisplayMsg("Evil " + PlayerManager[attackerIndex].marine.GetMarineName() + "!!!111");
			}
		}
		else if (victimIndex == null || PlayerManager[victimIndex].player == null)
			return;
		else if (h_attacker.IsAlien())
		{
			if (PlayerManager[victimIndex].player != null)
				DisplayMsg(PlayerManager[victimIndex].name + GetAlienName(h_attacker.GetClassname()));
			else
				DisplayMsg(PlayerManager[victimIndex].marine.GetMarineName() + GetAlienName(h_attacker.GetClassname()));
		}
		else if (h_attacker.GetClassname() == "asw_trigger_fall")
		{
			if (h_victim.IsInhabited())
			{
				if (PlayerManager[victimIndex].player != null)
				{
					if (PlayerManager[victimIndex].marine.GetMarineName() == "Wildcat" || PlayerManager[victimIndex].marine.GetMarineName() == "Faith")
						DisplayMsg(PlayerManager[victimIndex].name + " has fallen to her demise.");
					else
						DisplayMsg(PlayerManager[victimIndex].name + " has fallen to his demise.");	
				}
			}
			else if (PlayerManager[victimIndex].marine.GetMarineName() == "Wildcat" || PlayerManager[victimIndex].marine.GetMarineName() == "Faith")
				DisplayMsg(PlayerManager[victimIndex].marine.GetMarineName() + " has fallen to her demise.");
			else
				DisplayMsg(PlayerManager[victimIndex].marine.GetMarineName() + " has fallen to his demise.");
		}
		else if (h_attacker.GetClassname() == "env_fire")
		{
			if (PlayerManager[victimIndex].player != null)
				DisplayMsg(PlayerManager[victimIndex].name + " was burned alive.");
			else
				DisplayMsg(PlayerManager[victimIndex].marine.GetMarineName() + " was burned alive.");
		}
		
		SaveData();
		return;
	}
	
	if (h_attacker != null && h_attacker.GetClassname() == "asw_marine" && h_victim.IsAlien())
	{
		if (h_attacker.IsInhabited())
		{
			attackerIndex = GetPlayerIndex(h_attacker.GetCommander());
			SetPoints(attackerIndex, ReckonPoints(h_victim.GetClassname()), 1);
			PlayerManager[attackerIndex].tkills++;
			PlayerManager[attackerIndex].kills++;
		}
	}
}

function OnGameEvent_player_say(params)
{
	if (!("text" in params))
		return;
	else if (params["text"] == null)
		return;
	
	const strAND = "&";
	local strText = params["text"].tolower();
	local speakerID = null;
	if (("userid" in params))
		speakerID = params["userid"];
	
	switch (strText)
	{
		case "&help":
			DisplayMsg("==== List of Chat Commands ====\n&map  -  Display the current map name.\n&pts  -  Display each player's points.");
			DisplayMsg("&kill  -  Display each player's kills.\nPage 1/4     Type &help2 to see next page.");
			return;
		case "&help2":
			DisplayMsg("&cancel  -  Cancel all gift effects.");
			DisplayMsg("&shot  -  Display each player's shots.\n&death  -  Display each player's deaths.");
			DisplayMsg("&mine  -  Get a Flame Mine Backpack. 200 deaths required.\nPage 2/4     Type &help3 to see next page.");
			return;
		case "&help3":
			DisplayMsg("&skin  -  Get a black skin. 100 deaths required.\n&tail  -  Get a rocket tail. 10000 kills required.");
			DisplayMsg("&ammo  -  Get an Ammo Backpack. 10000 shots required");
			DisplayMsg("&flare - Get a flare which can illuminate or burn biomass. 20000 shots required.\nPage 3/4     Type &help4 to see next page.");
			return;
		case "&help4":
			DisplayMsg("&small / &big - Scale your marine size. 20000 kills required.\n&status  -  Report current players' status.");
			DisplayMsg("~Have Fun!\nPage 4/4     Type &help3 to see previous page.");
			return;
		case "&map":
			DisplayMsg("Current Map: " + GetMapName());
			return;
		case "&status":
			ReportStatus();
			return;
		case "&cancel":
			CancelGifts(speakerID);
			return;
		case "&pts":
			ShowAllPointsLate();
			return;
		case "&kill":
			ShowKills();
			return;
		case "&shot":
			ShowShots();
			return;
		case "&death":
			ShowDeaths();
			return;
	}
	if (strText.find(strAND, 0) != null)
	{
		foreach (strCmd in split(strText, strAND))
		{
			switch (strCmd)
			{
				case "skin":
					SetSkin(speakerID);
					break;
				case "mine":
					SetMinePack(speakerID);
					break;
				case "tail":
					SetTail(speakerID);
					break;
				case "ammo":
					SetAmmo(speakerID);
					break;
				case "flare":
					SetFlare(speakerID);
					break;
				case "small":
					SetScale(speakerID, 1);
					break;
				case "big":
					SetScale(speakerID, 2);
					break;
			}
		}
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
	self.DisconnectOutput("OnDeath", "VictimDeathFunc"); //error?
	timer.DisconnectOutput("OnTimer", "TimerFunc");
	timer.Destroy();
	delete g_worldspawnScope.MainTimersTable[self];
}

function OnTakeDamage_Alive_Any(h_victim, inflictor, h_attacker, weapon, damage, damageType, ammoName) 
{
	if (h_attacker != null && h_attacker.IsAlien())
	{
		if (h_victim != null && h_victim.GetClassname() == "asw_marine")
		{
			local victimIndex = null;
			if (h_victim.IsInhabited())
				victimIndex = GetPlayerIndex(h_victim.GetCommander());
			
			if (victimIndex == null)
				return damage;
			
			SetPoints(victimIndex, ReckonPoints(h_attacker.GetClassname()), 0);
		}
	}
	
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
		local attackerIndex = null;
		if (h_attacker.IsInhabited())
			attackerIndex = GetPlayerIndex(h_attacker.GetCommander());
		
		if (bInPRO && !FlamerDetected && inflictor != null && inflictor.GetClassname() == "asw_flamer_projectile")
		{
			if (weapon != null && weapon.GetClassname() == "asw_weapon_flamer")
			{
				local FlamerUserName = "A Robot";
				
				if (attackerIndex != null)
					FlamerUserName =PlayerManager[attackerIndex].name;
					
				DisplayMsg("Flamethrower Detected! The First User: " + FlamerUserName + ".", 0);
				DisplayMsg("OnFire Settings Enabled.");
				FlamerDetected = true;
			}
		}
		
		if (h_victim != null && h_victim.GetClassname() == "asw_marine")
		{
			if (attackerIndex != null)
				return damage;
			
			if (h_victim.GetMarineName() != h_attacker.GetMarineName())
				SetPoints(attackerIndex, damage.tointeger(), 0);
		}
	}
	return damage;
}

function OnGameEvent_player_heal(params)
{
	if (("userid" in params))
		if (params["userid"] != null)
			SetPoints(GetPlayerIndex(GetPlayerFromUserID(params["userid"])), 1, 1);
}

function OnGameEvent_weapon_fire(params)
{
	local marine = null;
	local weapon = null;
	
	if ("marine" in params)
		marine = EntIndexToHScript(params["marine"]);
	if ("weapon" in params)
		weapon = EntIndexToHScript(params["weapon"]);

	if (!marine.IsInhabited() || !marine || !weapon)
		return;
	else if (weapon.GetClassname() == "asw_weapon_heal_gun" || weapon.GetClassname() == "asw_weapon_heal_grenade" || weapon.GetClassname() == "asw_weapon_medical_satchel" || weapon.GetClassname() == "asw_weapon_ammo_bag" || weapon.GetClassname() == "asw_weapon_ammo_satchel" || weapon.GetClassname() == "asw_weapon_chainsaw" || weapon.GetClassname() == "asw_weapon_mining_laser" || weapon.GetClassname() == "asw_weapon_sentry" || weapon.GetClassname() == "asw_weapon_sentry_flamer" || weapon.GetClassname() == "asw_weapon_sentry_freeze" || weapon.GetClassname() == "asw_weapon_sentry_cannon")
		return;
	else if (weapon.GetClassname() == "asw_weapon_tesla_gun")
		SetPoints(GetPlayerIndex(marine.GetCommander()), 1, 1);
	
	PlayerManager[GetPlayerIndex(marine.GetCommander())].tshots++;
	PlayerManager[GetPlayerIndex(marine.GetCommander())].shots++;
	return;
}

function CheckDifficulty()
{
	local CurrentDiff = Convars.GetFloat("asw_skill");
	local strDiff;
	
	if (CurrentDiff == 1)
		strDiff = "Easy";
	else if (CurrentDiff == 2)
		strDiff = "Normal";
	else
		return;
	
	DisplayMsg(strDiff + " difficulty is not allowed in ASB2.", 0);
	
	local gs_timer = Entities.CreateByClassname("logic_timer");
	gs_timer.__KeyValueFromFloat("RefireTime", 3.5);
	DoEntFire("!self", "Disable", "", 0, null, gs_timer);
	gs_timer.ValidateScriptScope();
	local gs_timerScope = gs_timer.GetScriptScope();
	
	gs_timerScope.TimerFunc <- function()
	{
		Director.RestartMission();
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	gs_timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, gs_timer);
}

function ASB2SetUp()
{
	if (!bInPRO)
		return;
	
	local hButton = null;
	local hComputer = null;
	local hDoor = null;
	while ((hButton = Entities.FindByClassname(hButton, "trigger_asw_button_area")) != null)
	{
		if (hButton.GetKeyValue("locked").tointeger() == 0)
		{
			hButton.__KeyValueFromInt("locked", 1);
			hButton.__KeyValueFromInt("needstech", 0);
			hButton.__KeyValueFromInt("useafterhack", 1);
			
			hButton.ValidateScriptScope();
			local buttonScope = hButton.GetScriptScope();

			buttonScope.hButton <- hButton;
			buttonScope.SpawnUberFunc <- function()
			{
				Director.SpawnAlienAuto("asw_mortarbug");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				self.DisconnectOutput("OnButtonHackStarted", "SpawnUberFunc");
			}
			buttonScope.SpawnFunc <- function()
			{
				Director.SpawnAlienAuto("asw_drone_uber");
				Director.SpawnAlienAuto("asw_harvester");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				self.DisconnectOutput("OnButtonHackAt50Percent", "SpawnFunc");
			}
			
			hButton.ConnectOutput("OnButtonHackStarted", "SpawnUberFunc");
			hButton.ConnectOutput("OnButtonHackAt50Percent", "SpawnFunc");
		}
	}
	while ((hComputer = Entities.FindByClassname(hComputer, "trigger_asw_computer_area")) != null)
	{
		if (hComputer.GetKeyValue("locked").tointeger() == 0)
		{
			hComputer.__KeyValueFromInt("locked", 1);
			
			hComputer.ValidateScriptScope();
			local computerScope = hComputer.GetScriptScope();
 
			computerScope.hComputer <- hComputer;
			computerScope.SpawnUberFunc <- function()
			{
				Director.SpawnAlienAuto("asw_mortarbug");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				self.DisconnectOutput("OnComputerHackStarted", "SpawnUberFunc");
			}
			computerScope.SpawnFunc <- function()
			{
				Director.SpawnAlienAuto("asw_drone_uber");
				Director.SpawnAlienAuto("asw_harvester");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				Director.SpawnAlienAuto("asw_drone");
				self.DisconnectOutput("OnComputerHackHalfway", "SpawnFunc");
			}
			
			hComputer.ConnectOutput("OnComputerHackStarted", "SpawnUberFunc");
			hComputer.ConnectOutput("OnComputerHackHalfway", "SpawnFunc");
		}
	}
	while ((hDoor = Entities.FindByClassname(hDoor, "asw_door")) != null)
	{
		if (hDoor.GetKeyValue("autoopen").tointeger() == 1)
		{
			hDoor.__KeyValueFromInt("autoopen", 0);
			
			hDoor.ValidateScriptScope();
			local doorScope = hDoor.GetScriptScope();
			
			doorScope.hDoor <- hDoor;
			doorScope.AdjustAutoOpenFunc <- function()
			{
				hDoor.__KeyValueFromInt("autoopen", 1);
				self.DisconnectOutput("OnFullyOpen", "AdjustAutoOpenFunc");
			}
			
			hDoor.ConnectOutput("OnFullyOpen", "AdjustAutoOpenFunc");
		}
	}
}

function ReadPlayers()
{
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.GetNetworkIDString() == "STEAM_1:0:176990841") //AutoGavy
			n_AutoGavy = PlayerCounter;
		PlayerManager.push(cPlayer(player));
		PlayerCounter++;
	}
}

//Data File: Points, Kills, Shots, Deaths, Version, HasSkin, HasTail, HasMine, HasAmmo, HasScale
function ReadDataFile()
{
	foreach (val in PlayerManager)
	{
		if (val.player != null)
		{
			local BaseFileName = split(val.id, ":");
			local FileName = "asb2data_" + BaseFileName[1] + BaseFileName[2];
			local FileReader = FileToString(FileName);

			if (split(FileReader, strDelimiter).len() == 5)
			{
				local strArrayContent = split(FileReader, strDelimiter);
				val.points = strArrayContent[0].tointeger();
				val.tkills = strArrayContent[1].tointeger();
				val.tshots = strArrayContent[2].tointeger();
				val.deaths = strArrayContent[3].tointeger();
				StringToFile(FileName, val.points.tostring() + strDelimiter + val.tkills.tostring() + strDelimiter + val.tshots.tostring() + strDelimiter + val.deaths.tostring() + strDelimiter + intVersion + strDelimiter + val.bHasSkin.tostring() + strDelimiter + val.bHasTail.tostring() + strDelimiter + val.bHasMine.tostring() + strDelimiter + val.bHasAmmo.tostring() + strDelimiter + val.bHasScale.tostring());
			}
			else if (split(FileReader, strDelimiter).len() == 10)
			{
				local strArrayContent = split(FileReader, strDelimiter);
				val.points = strArrayContent[0].tointeger();
				val.tkills = strArrayContent[1].tointeger();
				val.tshots = strArrayContent[2].tointeger();
				val.deaths = strArrayContent[3].tointeger();
				val.bHasSkin = strArrayContent[5].tointeger();
				val.bHasTail = strArrayContent[6].tointeger();
				val.bHasMine = strArrayContent[7].tointeger();
				val.bHasAmmo = strArrayContent[8].tointeger();
				val.bHasScale = strArrayContent[9].tointeger();
			}
			else
				StringToFile(FileName,  "0:0:0:0:1:0:0:0:0:0");
		}
	}
}

function SetGifts()
{
	foreach (val in PlayerManager)
	{
		if (val.player == null)
			continue;
		if (val.bHasSkin)
			SetSkin(val.player.GetPlayerUserID());
		if (val.bHasTail)
			SetTail(val.player.GetPlayerUserID());
		if (val.bHasMine)
			SetMinePack(val.player.GetPlayerUserID());
		if (val.bHasAmmo)
			SetAmmo(val.player.GetPlayerUserID());
		if (val.bHasScale != 0)
			SetScale(val.player.GetPlayerUserID(), val.bHasScale);
	}
}

function CancelGifts(userid)
{
	if (userid == null)
		return;
	
	local cTarget = PlayerManager[GetPlayerIndex(GetPlayerFromUserID(userid))];
	if (cTarget.player == null)
		return;
	cTarget.HasSkin(false);
	cTarget.HasTail(false);
	cTarget.HasMine(false);
	cTarget.HasAmmo(false);
	cTarget.HasScale(0);
	ClientPrint(cTarget.player, 3, "Done. Will take effect in the next round.");
}

function ReloadPlayers()
{
	local player = null;
	local strID = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		local bNewPlayer = true;
		strID = player.GetNetworkIDString();
		foreach (index, val in PlayerManager)
		{
			if (strID == val.id)
				bNewPlayer = false;
			else
			{
				PlayerManager.remove(index);
				bNewPlayer = false;
			}
			if (bNewPlayer)
				PushPlayerClass(player);
		}
	}
}

function CheckPlayerIndex(player, index)
{
	local hmarine = NetProps.GetPropEntity(player, "m_hMarine");
	if (PlayerManager[index].marine != hmarine)
		PlayerManager[index].marine = hmarine;
}

function PushPlayerClass(player)
{
	if (player != null)
	{
		local BaseFileName = split(player.GetNetworkIDString(), ":");
		local FileName = "asb2data_" + BaseFileName[1] + BaseFileName[2];
		local FileReader = FileToString(FileName);

		if (split(FileReader, strDelimiter).len() == 5)
		{
			local strArrayContent = split(FileReader, strDelimiter);
			val.points = strArrayContent[0].tointeger();
			val.tkills = strArrayContent[1].tointeger();
			val.tshots = strArrayContent[2].tointeger();
			val.deaths = strArrayContent[3].tointeger();
			StringToFile(FileName, val.points.tostring() + strDelimiter + val.tkills.tostring() + strDelimiter + val.tshots.tostring() + strDelimiter + val.deaths.tostring() + strDelimiter + intVersion + strDelimiter + val.bHasSkin.tostring() + strDelimiter + val.bHasTail.tostring() + strDelimiter + val.bHasMine.tostring() + strDelimiter + val.bHasAmmo.tostring() + strDelimiter + val.bHasScale.tostring());
		}
		else if (split(FileReader, strDelimiter).len() == 10)
		{
			local strArrayContent = split(FileReader, strDelimiter);
			val.points = strArrayContent[0].tointeger();
			val.tkills = strArrayContent[1].tointeger();
			val.tshots = strArrayContent[2].tointeger();
			val.deaths = strArrayContent[3].tointeger();
			val.bHasSkin = strArrayContent[5].tointeger();
			val.bHasTail = strArrayContent[6].tointeger();
			val.bHasMine = strArrayContent[7].tointeger();
			val.bHasAmmo = strArrayContent[8].tointeger();
			val.bHasScale = strArrayContent[9].tointeger();
		}
		else
			StringToFile(FileName,  "0:0:0:0:1:0:0:0:0:0");
	}
}

function SaveData()
{
	foreach (val in PlayerManager)
	{
		if (val.player != null)
		{
			local BaseFileName = split(val.id, ":");
			local FileName = "asb2data_" + BaseFileName[1] + BaseFileName[2];
			
			StringToFile(FileName, val.points.tostring() + strDelimiter + val.tkills.tostring() + strDelimiter + val.tshots.tostring() + strDelimiter + val.deaths.tostring() + strDelimiter + intVersion + strDelimiter + val.bHasSkin.tostring() + strDelimiter + val.bHasTail.tostring() + strDelimiter + val.bHasMine.tostring() + strDelimiter + val.bHasAmmo.tostring() + strDelimiter + val.bHasScale.tostring());
		}
	}
}

function GetPlayerIndex(player)
{
	local strID = player.GetNetworkIDString();
	foreach (index, val in PlayerManager)
	{
		if (strID == val.id)
		{
			CheckPlayerIndex(player, index);
			return index;
		}
	}
	ReloadPlayers();
	return fGetPlayerIndex(player);
}

function fGetPlayerIndex(player)
{
	local strID = player.GetNetworkIDString();
	foreach (index, val in PlayerManager)
	{
		if (strID == val.id)
		{
			CheckPlayerIndex(player, index);
			return index;
		}
	}
	return _GetPlayerIndex(player);
}

function Greeting()
{
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.GetNetworkIDString() == "STEAM_1:0:176990841") //AutoGavy
			ClientPrint(player, 3, "=д= Challenge Creator!");
		else
			ClientPrint(player, 3, "Welcome to ASB2 game mode, " + player.GetPlayerName() + ".");
	}
}

function DisplayMsg(message, delay = 0.01)
{
	if (!delay)
	{
		local player = null;
		while ((player = Entities.FindByClassname(player, "player")) != null)
			ClientPrint(player, 3, message);
		return;
	}
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", delay);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.message <- message;
	timerScope.TimerFunc <- function()
	{
		local player = null;
		while ((player = Entities.FindByClassname(player, "player")) != null)
			ClientPrint(player, 3, message);
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function SetPoints(index, points, action) //0 to take, 1 to add
{
	if (index == null)
		return;
	if (action)
		PlayerManager[index].points += points;
	else
		PlayerManager[index].points -= points;
}

function GetAlienName(alien_class)
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
			return " was killed by an Uber Drone.";
		case "npc_antlionguard_normal":
			return " tried to race with an Antlionguard.";
		case "npc_antlionguard_cavern":
			return " tried to race with a Cavern Antlionguard.";
		case "asw_egg":
			return " ate an Alien Egg.";
		case "asw_alien_goo":
			return " was killed by an Alien Biomass.";
		default:
			return " was killed by an unknown alien.";
	}
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
			return 8;
		case "asw_drone_jumper":
			return 2;
		case "asw_harvester":
			return 5;
		case "asw_parasite_defanged":
			return 1;
		case "asw_queen":
			return 20;
		case "asw_boomer":
			return 5;
		case "asw_ranger":
			return 3;
		case "asw_mortarbug":
			return 5;
		case "asw_drone_uber":
			return 2;
		case "npc_antlionguard_normal":
			return 12;
		case "npc_antlionguard_cavern":
			return 12;
		case "asw_egg":
			return 2;
	}
	return 5;
}

function CheckMissionComplete()
{
    local EscObj = Entities.FindByClassname(null, "asw_objective_escape");
    if (EscObj != null)
    {
        EscObj.ValidateScriptScope();
        local ScopeEscObj = EscObj.GetScriptScope();
        ScopeEscObj.ScopeChallengeFile <- self.GetScriptScope();
       
        ScopeEscObj.ObjFunc <- function()
		{
			ScopeChallengeFile.MissonCompleteFunc();
		}
       
	   EscObj.ConnectOutput("OnObjectiveComplete", "ObjFunc");
    }
}

function MissonCompleteFunc()
{
	DisplayMsg("Mission Completed.", 0.06);
	ReportStatus(1);
	foreach (index, val in PlayerManager)
	{
		if (val.marine != null && val.bsurvived)
			SetPoints(index, 50, 1);
	}
	SaveData();
}

function ReportStatus(delay = 0.01)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", delay);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.ReportStatusHelper <- ReportStatusHelper;
	timerScope.TimerFunc <- function()
	{
		foreach (i, val in PlayerManager)
		{
			local readMarker = 0;
			foreach (y, _val in PlayerManager)
			{
				if (y == i || _val.player == null)
					continue;
				
				if (readMarker >= 4)
				{
					ReportStatusHelper(i, y);
					break;
				}
				if (val.player != null && _val.player != null)
				{
					ClientPrint(val.player, 3, _val.name + " got " + _val.kills + " kills, " + _val.shots + " shots. " + _val.status);
					readMarker++;
				}
			}
			if (val.player != null)
				ClientPrint(val.player, 3, "You got: " + val.kills + " kills, " + val.shots + " shots. " + val.status);
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ReportStatusHelper(i, y)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 2.5);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayerManager.len(); y++)
		{
			if (y == i || PlayerManager[y].player == null)
				continue;
			if (PlayerManager[i].player != null || PlayerManager[y].player != null)
				ClientPrint(PlayerManager[i].player, 3, PlayerManager[y].name + " got " + PlayerManager[y].kills + " kills, " + PlayerManager[y].shots + " shots.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function GreetShowAllPoints()
{
	foreach (i, val in PlayerManager)
	{
		local readMarker = 0;
		foreach (y, _val in PlayerManager)
		{
			if (y == i || _val.player == null)
				continue;
			
			if (readMarker >= 3)
			{
				ShowPointsHelper(i, y);
				break;
			}
			if (val.player != null && _val.player != null)
			{
				ClientPrint(val.player, 3, _val.name + " has " + _val.points + " pts.");
				readMarker++;
			}
		}
		if (val.player != null)
			ClientPrint(val.player, 3, "You have: " + val.points + " pts.");
	}
}

function ShowAllPoints()
{
	foreach (i, val in PlayerManager)
	{
		local readMarker = 0;
		foreach (y, _val in PlayerManager)
		{
			if (y == i || _val.player == null)
				continue;
			
			if (readMarker >= 4)
			{
				ShowPointsHelper(i, y);
				break;
			}
			if (val.player != null && _val.player != null)
			{
				ClientPrint(val.player, 3, _val.name + " has " + _val.points + " pts.");
				readMarker++;
			}
		}
		if (val.player != null)
			ClientPrint(val.player, 3, "You have: " + val.points + " pts.");
	}
}

function ShowPointsHelper(i, y)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 2.5);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayerManager.len(); y++)
		{
			if (y == i || PlayerManager[y].player == null)
				continue;
			if (PlayerManager[i].player != null || PlayerManager[y].player != null)
				ClientPrint(PlayerManager[i].player, 3, PlayerManager[y].name + " has " + PlayerManager[y].points + " pts.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowAllPointsLate()
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.ShowPointsHelper <- ShowPointsHelper;
	timerScope.TimerFunc <- function()
	{
		foreach (i, val in PlayerManager)
		{
			local readMarker = 0;
			foreach (y, _val in PlayerManager)
			{
				if (y == i || _val.player == null)
					continue;
				
				if (readMarker >= 4)
				{
					ShowPointsHelper(i, y);
					break;
				}
				if (val.player != null && _val.player != null)
				{
					ClientPrint(val.player, 3, _val.name + " has " + _val.points + " pts.");
					readMarker++;
				}
			}
			if (val.player != null)
				ClientPrint(val.player, 3, "You have: " + val.points + " pts.");
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
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.ShowKillsHelper <- ShowKillsHelper;
	timerScope.TimerFunc <- function()
	{
		foreach (i, val in PlayerManager)
		{
			local readMarker = 0;
			foreach (y, _val in PlayerManager)
			{
				if (y == i || _val.player == null)
					continue;
				
				if (readMarker >= 4)
				{
					ShowKillsHelper(i, y);
					break;
				}
				if (val.player != null && _val.player != null)
				{
					ClientPrint(val.player, 3, _val.name + " has " + _val.tkills + " kills.");
					readMarker++;
				}
			}
			if (val.player != null)
				ClientPrint(val.player, 3, "You have: " + val.tkills + " kills.");
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
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayerManager.len(); y++)
		{
			if (y == i || PlayerManager[y].player == null)
				continue;
			if (PlayerManager[i].player != null || PlayerManager[y].player != null)
				ClientPrint(PlayerManager[i].player, 3, PlayerManager[y].name + " has " + PlayerManager[y].tkills + " kills.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowShots()
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.ShowShotsHelper <- ShowShotsHelper;
	timerScope.TimerFunc <- function()
	{
		foreach (i, val in PlayerManager)
		{
			local readMarker = 0;
			foreach (y, _val in PlayerManager)
			{
				if (y == i || _val.player == null)
					continue;
				
				if (readMarker >= 4)
				{
					ShowShotsHelper(i, y);
					break;
				}
				if (val.player != null && _val.player != null)
				{
					ClientPrint(val.player, 3, _val.name + " has " + _val.tshots + " shots.");
					readMarker++;
				}
			}
			if (val.player != null)
				ClientPrint(val.player, 3, "You have: " + val.tshots + " shots.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function ShowShotsHelper(i, y)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 2.5);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayerManager.len(); y++)
		{
			if (y == i || PlayerManager[y].player == null)
				continue;
			if (PlayerManager[i].player != null || PlayerManager[y].player != null)
				ClientPrint(PlayerManager[i].player, 3, PlayerManager[y].name + " has " + PlayerManager[y].tshots + " shots.");
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
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.ShowDeathsHelper <- ShowDeathsHelper;
	timerScope.TimerFunc <- function()
	{
		foreach (i, val in PlayerManager)
		{
			local readMarker = 0;
			foreach (y, _val in PlayerManager)
			{
				if (y == i || _val.player == null)
					continue;
				
				if (readMarker >= 4)
				{
					ShowDeathsHelper(i, y);
					break;
				}
				if (val.player != null && _val.player != null)
				{
					ClientPrint(val.player, 3, _val.name + " has " + _val.deaths + " deaths.");
					readMarker++;
				}
			}
			if (val.player != null)
				ClientPrint(val.player, 3, "You have: " + val.deaths + " deaths.");
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
	
	timerScope.PlayerManager <- PlayerManager;
	timerScope.i <- i;
	timerScope.y <- y;
	timerScope.TimerFunc <- function()
	{
		for (; y < PlayerManager.len(); y++)
		{
			if (y == i || PlayerManager[y].player == null)
				continue;
			if (PlayerManager[i].player != null || PlayerManager[y].player != null)
				ClientPrint(PlayerManager[i].player, 3, PlayerManager[y].name + " has " + PlayerManager[y].deaths + " deaths.");
		}
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function SetSkin(userid)
{
	if (userid == null)
		return;
	
	local cTarget = PlayerManager[GetPlayerIndex(GetPlayerFromUserID(userid))];
	if (cTarget.player == null)
		return;
	
	if (cTarget.deaths < 100)
	{
		if(!cTarget.bHasSkin)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough deaths.");
		return;
	}
	if (!cTarget.bskin)
	{
		if(!cTarget.bHasSkin)
			ClientPrint(cTarget.player, 3, "Failed. You've already had a effect with the same type of this gift.");
		return;
	}
	if (cTarget.points < 100)
	{
		if(!cTarget.bHasSkin)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough points.");
		return;
	}
	if (cTarget.marine != null)
	{
		cTarget.marine.__KeyValueFromString("rendercolor", "0,0,0");
		cTarget.points -= 100;
		cTarget.bskin = false;
		cTarget.HasSkin(true);
		
		if(!cTarget.bHasSkin)
			ClientPrint(cTarget.player, 3, "Done. Your current pts: " + cTarget.points);
	}
}

function SetTail(userid)
{
	if (userid == null)
		return;
	
	local cTarget = PlayerManager[GetPlayerIndex(GetPlayerFromUserID(userid))];
	if (cTarget.player == null)
		return;

	if (cTarget.tkills < 10000)
	{
		if(!cTarget.bHasTail)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough kills.");
		return;
	}
	if (!cTarget.btail)
	{
		if(!cTarget.bHasTail)
			ClientPrint(cTarget.player, 3, "Failed. You've already had a effect with the same type of this gift.");
		return;
	}
	if (cTarget.points < 100)
	{
		if(!cTarget.bHasTail)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough points.");
		return;
	}
	if (cTarget.marine != null)
	{
		local particle = Entities.CreateByClassname("info_particle_system");
		particle.__KeyValueFromString("effect_name", "rocket_trail_small_glow");
		particle.__KeyValueFromString("start_active", "1");
		particle.SetOrigin(cTarget.marine.GetOrigin() + Vector(0, 0, 30));
		particle.SetAnglesVector(cTarget.marine.GetAngles());
		
		local particle2 = Entities.CreateByClassname("info_particle_system");
		particle2.__KeyValueFromString("effect_name", "rocket_trail_small");
		particle2.__KeyValueFromString("start_active", "1");
		particle2.SetOrigin(cTarget.marine.GetOrigin() + Vector(0, 0, 30));
		particle2.SetAnglesVector(cTarget.marine.GetAngles());
		
		DoEntFire("!self", "SetParent", "!activator", 0, cTarget.marine, particle);
		DoEntFire("!self", "SetParent", "!activator", 0, cTarget.marine, particle2);
		
		particle.Spawn();
		particle.Activate();
		particle2.Spawn();
		particle2.Activate();
		
		cTarget.points -= 100;
		cTarget.btail = false;
		cTarget.HasTail(true);
		
		if(!cTarget.bHasTail)
			ClientPrint(cTarget.player, 3, "Done. Your current pts: " + cTarget.points);
	}
}

function SetMinePack(userid)
{
	if (userid == null)
		return;
	
	local cTarget = PlayerManager[GetPlayerIndex(GetPlayerFromUserID(userid))];
	if (cTarget.player == null)
		return;

	if (cTarget.deaths < 200)
	{
		if(!cTarget.bHasMine)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough deaths.");
		return;
	}
	if (!cTarget.bammo || !cTarget.bmine)
	{
		if(!cTarget.bHasMine)
			ClientPrint(cTarget.player, 3, "Failed. You've already had a effect with the same type of this gift.");
		return;
	}
	if (cTarget.points < 100)
	{
		if(!cTarget.bHasMine)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough points.");
		return;
	}
	if (cTarget.marine != null)
	{
		cTarget.hmine = CreateProp("prop_dynamic", cTarget.marine.GetOrigin(), "models/items/mine/mine.mdl", 1);
		
		EntFireByHandle(cTarget.hmine, "SetDefaultAnimation", "BindPose", 0, cTarget.marine, cTarget.marine);
		EntFireByHandle(cTarget.hmine, "SetAnimation", "BindPose", 0, self, self);
		EntFireByHandle(cTarget.hmine, "DisableShadow", "", 0, cTarget.marine, cTarget.marine);
		EntFireByHandle(cTarget.hmine, "SetParent", "!activator", 0, cTarget.marine, cTarget.marine);
		EntFireByHandle(cTarget.hmine, "SetParentAttachment", "jump_jet_r", 0, null, cTarget.marine)
		PropLocalRotate(cTarget.hmine);
		
		cTarget.points -= 100;
		cTarget.bmine = false;
		cTarget.HasMine(true);
		
		if(!cTarget.bHasMine)
			ClientPrint(cTarget.player, 3, "Done. Your current pts: " + cTarget.points);
	}
}

function SetAmmo(userid)
{
	if (userid == null)
		return;
	
	local cTarget = PlayerManager[GetPlayerIndex(GetPlayerFromUserID(userid))];
	if (cTarget.player == null)
		return;

	if (cTarget.tshots < 10000)
	{
		if(!cTarget.bHasAmmo)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough shots.");
		return;
	}
	if (!cTarget.bmine || !cTarget.bammo)
	{
		if(!cTarget.bHasAmmo)
			ClientPrint(cTarget.player, 3, "Failed. You've already had a effect with the same type of this gift.");
		return;
	}
	if (cTarget.points < 100)
	{
		if(!cTarget.bHasAmmo)
			ClientPrint(cTarget.player, 3, "Failed. You don't have enough points.");
		return;
	}
	if (cTarget.marine != null)
	{
		cTarget.hammo = CreateProp("prop_dynamic", cTarget.marine.GetOrigin(), "models/items/ammobag/ammobag.mdl", 1);
		
		EntFireByHandle(cTarget.hammo, "SetDefaultAnimation", "BindPose", 0, cTarget.marine, cTarget.marine);
		EntFireByHandle(cTarget.hammo, "SetAnimation", "BindPose", 0, self, self);
		EntFireByHandle(cTarget.hammo, "DisableShadow", "", 0, cTarget.marine, cTarget.marine);
		EntFireByHandle(cTarget.hammo, "SetParent", "!activator", 0, cTarget.marine, cTarget.marine);
		EntFireByHandle(cTarget.hammo, "SetParentAttachment", "jump_jet_r", 0, null, cTarget.marine);
		PropLocalRotate(cTarget.hammo);
		
		cTarget.points -= 100;
		cTarget.bammo = false;
		cTarget.HasAmmo(true);
			
		if(!cTarget.bHasAmmo)
			ClientPrint(cTarget.player, 3, "Done. Your current pts: " + cTarget.points);
	}
}

function SetFlare(userid)
{
	if (userid == null)
		return;
	
	local cTarget = PlayerManager[GetPlayerIndex(GetPlayerFromUserID(userid))];
	if (cTarget.marine == null || cTarget.player == null)
		return;
	
	if(cTarget.tshots < 20000)
	{
		ClientPrint(cTarget.player, 3, "Failed. You don't have enough shots.");
		return;
	}
	if(!cTarget.bflare)
	{
		ClientPrint(cTarget.player, 3, "Failed. You've used this gift.");
		return;
	}
	if(cTarget.points < 100)
	{
		ClientPrint(cTarget.player, 3, "Failed. You don't have enough shots.");
		return;
	}
	cTarget.marine.DropWeapon(2);
	cTarget.marine.GiveWeapon("asw_weapon_flares", 2);
	cTarget.points -= 100;
	cTarget.bflare = false;
	ClientPrint(cTarget.player, 3, "Done. Your current pts: " + cTarget.points);
}

function SetScale(userid, ScaleMode) //1 to small, 2 to big
{
	if (userid == null)
		return;
	
	local cTarget = PlayerManager[GetPlayerIndex(GetPlayerFromUserID(userid))];
	if (cTarget.marine == null || cTarget.player == null)
		return;
	
	if(cTarget.tkills < 20000)
	{
		ClientPrint(cTarget.player, 3, "Failed. You don't have enough shots.");
		return;
	}
	if(!cTarget.bscale)
	{
		ClientPrint(cTarget.player, 3, "Failed. You've used this gift.");
		return;
	}
	if(cTarget.points < 100)
	{
		ClientPrint(cTarget.player, 3, "Failed. You don't have enough shots.");
		return;
	}
	if (ScaleMode == 1)
	{
		cTarget.HasScale(1);
		DoEntFire("!self", "AddOutput", "modelscale 0.5", 0, null, cTarget.marine);
	}
		
	else if (ScaleMode == 2)
	{
		cTarget.HasScale(2);
		DoEntFire("!self", "AddOutput", "modelscale 1.5", 0, null, cTarget.marine);
	}
		
	cTarget.points -= 100;
	cTarget.bscale = false;
		
	if(cTarget.bHasScale != 0)
		ClientPrint(cTarget.player, 3, "Done. Your current pts: " + cTarget.points);
}

function PropLocalRotate(prop)
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	
	timer.GetScriptScope().prop <- prop;
	timer.GetScriptScope().TimerFunc <- function()
	{
		if (prop != null && prop.IsValid())
			prop.SetLocalAngles(0, 0, 90);
		
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function PrecacheParticlesFunc()
{
	local strArrayParticleName = ["rocket_trail_small_glow", "rocket_trail_small"];
	local vecPosition = Vector(16384, 16384, 16384);
	
	foreach(val in strArrayParticleName)
		CreateParticleFunc(0.5, vecPosition, Vector(0, 0, 0), val, null);
}

function CreateParticleFunc(arg_flAliveTime, arg_vecOrigin, arg_vecAngles, arg_strParticleClass, arg_hParent)
{
	local hParticle = Entities.CreateByClassname("info_particle_system");
	hParticle.__KeyValueFromString("effect_name", arg_strParticleClass);
	hParticle.__KeyValueFromString("start_active", "1");
	hParticle.SetOrigin(arg_vecOrigin);
	hParticle.SetAnglesVector(arg_vecAngles);
	hParticle.Spawn();
	hParticle.Activate();
	DoEntFire("!self", "Kill", "", arg_flAliveTime, null, hParticle);
	
	if (arg_hParent != null)
		DoEntFire("!self", "SetParent", "!activator", 0, arg_hParent, hParticle);
	
	return hParticle;
}

PrecacheParticlesFunc();
g_ModeScript.OnTakeDamage_Alive_Any <- OnTakeDamage_Alive_Any;
