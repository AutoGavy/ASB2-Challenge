t75Prop <- CreateProp("prop_dynamic", self.GetOrigin(), "models/items/itembox/itemboxsmall.mdl", 1);

function CarrierDroneDied() {
	realT75 <- Entities.CreateByClassname("asw_weapon_t75");
	realT75.SetAnglesVector(t75Prop.GetAngles());
	realT75.SetOrigin(t75Prop.GetOrigin());
	realT75.Spawn();
	
	local tempT75 = null;
	while ((tempT75 = Entities.FindByClassname(tempT75, "asw_weapon_t75")) != null)
		tempT75.SetClip1(1);
	
	t75Prop.Destroy();
	self.DisconnectOutput("OnDeath", "CarrierDroneDied");
}

EntFireByHandle(self, "Color", "255 0 0", 0, self, self);
t75Prop.SetOwner(self);

function RotateToFaceForward() {
	self.SetLocalAngles(0, 90, 0);
	self.DisconnectOutput("OnUser1", "RotateToFaceForward");
}
t75Prop.ValidateScriptScope();
t75Prop.GetScriptScope().RotateToFaceForward <- RotateToFaceForward;

EntFireByHandle(t75Prop, "SetDefaultAnimation", "BindPose", 0, self, self);
EntFireByHandle(t75Prop, "SetAnimation", "BindPose", 0, self, self);
EntFireByHandle(t75Prop, "DisableShadow", "", 0, self, self);
EntFireByHandle(t75Prop, "SetParent", "!activator", 0, self, self);
EntFireByHandle(t75Prop, "SetParentAttachment", "blood_spray", 0, self, self);
t75Prop.ConnectOutput("OnUser1", "RotateToFaceForward");
EntFireByHandle(t75Prop, "FireUser1", "", 0, self, self);

self.ValidateScriptScope();
self.GetScriptScope().CarrierDroneDied <- CarrierDroneDied;
self.ConnectOutput("OnDeath", "CarrierDroneDied");
