Convars.SetValue("rd_override_allow_rotate_camera", 1);
Convars.SetValue("rd_increase_difficulty_by_number_of_marines", 0);

function OnMissionStart()
{
	local gs_timer = Entities.CreateByClassname("logic_timer");
	gs_timer.__KeyValueFromFloat("RefireTime", 0.01);
	DoEntFire("!self", "Disable", "", 0, null, gs_timer);
	gs_timer.ValidateScriptScope();
	local gs_timerScope = gs_timer.GetScriptScope();
	
	gs_timerScope.TimerFunc <- function()
	{
		if (Convars.GetFloat("asw_skill") == 5)
		{
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
		self.DisconnectOutput("OnTimer", "TimerFunc");
		self.Destroy();
	}
	gs_timer.ConnectOutput("OnTimer", "TimerFunc");
	DoEntFire("!self", "Enable", "", 0, null, gs_timer);
}
