function OnTakeDamage_Alive_Any(victim, inflictor, attacker, weapon, damage, damageType, ammoName) 
{
	local tempMarine = null;
	if (attacker != null && attacker.GetClassname() == "asw_marine") 
	{
		if (victim != null && victim.GetClassname() == "asw_marine" && victim != attacker)
		{
			local player = null;
			while((player = Entities.FindByClassname(player, "player")) != null)
			{
				if (player.GetNetworkIDString() == "STEAM_1:0:176990841" || player.GetNetworkIDString() == "STEAM_1:1:32733671")
				{
					local marine = NetProps.GetPropEntity(player, "m_hMarine");
					if (marine != null)
						tempMarine = marine;
				}
			}
			if (victim.GetMarineName() == tempMarine.GetMarineName())
			{
				if (inflictor != null && inflictor.GetClassname() != "asw_burning" && inflictor.GetClassname() != "asw_sentry_top_machinegun")
				{
					if (weapon != null && weapon.GetClassname() != "asw_sentry_top_cannon")
					{
						attacker.TakeDamage(5, 0, attacker);
						damage = 0;
					}
				}
			}
		}
	}
	return damage;
}
