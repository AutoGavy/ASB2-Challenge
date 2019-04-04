rangerProp <- CreateProp("prop_dynamic", self.GetOrigin(), "models/aliens/mortar3/mortar3.mdl", 17);

function CarrierDroneDied() {
	realranger <- Director.SpawnAlienAt("asw_ranger", rangerProp.GetOrigin(), rangerProp.GetAngles());
	rangerProp.Destroy();

	self.DisconnectOutput("OnDeath", "CarrierDroneDied");
}

EntFireByHandle(self, "Color", "0 255 0", 0, self, self);
rangerProp.SetOwner(self);

function RotateToFaceForward() {
	self.SetLocalAngles(0, 90, 0);
	self.DisconnectOutput("OnUser1", "RotateToFaceForward");
}
rangerProp.ValidateScriptScope();
rangerProp.GetScriptScope().RotateToFaceForward <- RotateToFaceForward;

EntFireByHandle(rangerProp, "SetDefaultAnimation", "ragdoll", 0, self, self);
EntFireByHandle(rangerProp, "SetAnimation", "ragdoll", 0, self, self);
EntFireByHandle(rangerProp, "DisableShadow", "", 0, self, self);
EntFireByHandle(rangerProp, "SetParent", "!activator", 0, self, self);
EntFireByHandle(rangerProp, "SetParentAttachment", "blood_spray", 0, self, self);
rangerProp.ConnectOutput("OnUser1", "RotateToFaceForward");
EntFireByHandle(rangerProp, "FireUser1", "", 0, self, self);

self.ValidateScriptScope();
self.GetScriptScope().CarrierDroneDied <- CarrierDroneDied;
self.ConnectOutput("OnDeath", "CarrierDroneDied");
