const StopFunc = 5000;

function Update()
{
	DisplayMsg("This challenge is currently working in progress.", 1)
	
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
	
	return StopFunc;
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
