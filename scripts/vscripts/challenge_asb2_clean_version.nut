Convars.SetValue( "asw_batch_interval", 3 );
Convars.SetValue( "asw_realistic_death_chatter", 1 );
Convars.SetValue( "asw_marine_ff", 2 );
Convars.SetValue( "asw_marine_ff_dmg_base", 3 );
Convars.SetValue( "asw_custom_skill_points", 0 );
Convars.SetValue( "asw_adjust_difficulty_by_number_of_marines", 0 );
Convars.SetValue( "asw_marine_death_cam_slowdown", 0 );
Convars.SetValue( "asw_marine_death_protection", 0 );
Convars.SetValue( "asw_marine_collision", 1 );
Convars.SetValue( "asw_horde_override", 1 );
Convars.SetValue( "asw_wanderer_override", 1 );
Convars.SetValue( "asw_difficulty_alien_health_step", 0.2 );
Convars.SetValue( "asw_difficulty_alien_damage_step", 0.2 );
Convars.SetValue( "asw_marine_time_until_ignite", 0 );
Convars.SetValue( "rd_marine_ignite_immediately", 1 );
Convars.SetValue( "asw_marine_burn_time_easy", 60 );
Convars.SetValue( "asw_marine_burn_time_normal", 60 );
Convars.SetValue( "asw_marine_burn_time_hard", 60 );
Convars.SetValue( "asw_marine_burn_time_insane", 60 );
Convars.SetValue("rd_marine_ignite_immediately", 1);
Convars.SetValue("rd_override_allow_rotate_camera", 1);
Convars.SetValue("rd_increase_difficulty_by_number_of_marines", 0);

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
	Convars.SetValue("asw_difficulty_alien_health_step", 1);
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
	Convars.SetValue("asw_difficulty_alien_health_step", 1);
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
	Convars.SetValue("asw_difficulty_alien_health_step", 1);
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
	Convars.SetValue("asw_difficulty_alien_health_step", 1);
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
	Convars.SetValue("rd_prespawn_scale", 0);
}
