local gs_trollmarine = null;
while((gs_trollmarine = Entities.FindByClassname(gs_trollmarine, "asw_marine")) != null)
	NetProps.SetPropInt(gs_trollmarine, "bEmoteAnimeSmile", 1);
