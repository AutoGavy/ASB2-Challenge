newProp <- CreateProp("prop_dynamic", self.GetOrigin() + Vector(-25, 0, 45), "models/sentry_gun/sentry_base.mdl", 1);

function CarrierDroneDied() {
	local realSentry = Entities.CreateByClassname("asw_sentry_base");
	local CarrierOrigin = self.GetOrigin();
	local CarrierOriginz = CarrierOrigin.z;
	local PropOrigin = newProp.GetOrigin();
	realSentry.SetOrigin(Vector(PropOrigin.x, PropOrigin.y, CarrierOriginz));
	realSentry.SetAnglesVector(newProp.GetAngles());
	realSentry.Spawn();
	realSentry.Activate();

	newProp.Destroy();

	self.DisconnectOutput("OnDeath", "CarrierDroneDied");
}

newProp.SetOwner(self);

function RotateToFaceForward() {
	self.SetLocalAngles(0, 0, -45);
	self.DisconnectOutput("OnUser1", "RotateToFaceForward");
}
newProp.ValidateScriptScope();
newProp.GetScriptScope().RotateToFaceForward <- RotateToFaceForward;

EntFireByHandle(newProp, "SetDefaultAnimation", "BindPose", 0, self, self);
EntFireByHandle(newProp, "SetAnimation", "BindPose", 0, self, self);
EntFireByHandle(newProp, "DisableShadow", "", 0, self, self);
EntFireByHandle(newProp, "SetParent", "!activator", 0, self, self);
//EntFireByHandle(newProp, "SetParentAttachment", "blood_spray", 0, self, self);
newProp.ConnectOutput("OnUser1", "RotateToFaceForward");
EntFireByHandle(newProp, "FireUser1", "", 0, self, self);

self.ValidateScriptScope();
self.GetScriptScope().CarrierDroneDied <- CarrierDroneDied;
self.ConnectOutput("OnDeath", "CarrierDroneDied");
