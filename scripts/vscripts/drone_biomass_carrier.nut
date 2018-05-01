biomassProp <- CreateProp("prop_dynamic", self.GetOrigin() + Vector(-30, 0, 30), "models/aliens/biomass/biomasshelix.mdl", 32);

function CarrierDroneDied() {
	realBiomass <- Entities.CreateByClassname("asw_alien_goo");
	switch (RandomInt(0, 3))
	{
		case 0:
			realBiomass.__KeyValueFromString("model", "models/aliens/biomass/biomasshelix.mdl");
			break;
		
		case 1:
			realBiomass.__KeyValueFromString("model", "models/aliens/biomass/biomassl.mdl");
			break;
		
		case 2:
			realBiomass.__KeyValueFromString("model", "models/aliens/biomass/biomasss.mdl");
			break;
		
		case 3:
			realBiomass.__KeyValueFromString("model", "models/aliens/biomass/biomassu.mdl");
			break;
	}
	realBiomass.SetOrigin(self.GetOrigin());
	realBiomass.SetAnglesVector(biomassProp.GetAngles());
	realBiomass.Spawn();
	biomassProp.Destroy();

	self.DisconnectOutput("OnDeath", "CarrierDroneDied");
}

biomassProp.SetOwner(self);

function RotateToFaceForward() {
	self.SetLocalAngles(0, 0, 0);
	self.DisconnectOutput("OnUser1", "RotateToFaceForward");
}
biomassProp.ValidateScriptScope();
biomassProp.GetScriptScope().RotateToFaceForward <- RotateToFaceForward;

EntFireByHandle(biomassProp, "SetDefaultAnimation", "Idle", 0, self, self);
EntFireByHandle(biomassProp, "SetAnimation", "Idle", 0, self, self);
EntFireByHandle(biomassProp, "DisableShadow", "", 0, self, self);
EntFireByHandle(biomassProp, "SetParent", "!activator", 0, self, self);
biomassProp.ConnectOutput("OnUser1", "RotateToFaceForward");
EntFireByHandle(biomassProp, "FireUser1", "", 0, self, self);

self.ValidateScriptScope();
self.GetScriptScope().CarrierDroneDied <- CarrierDroneDied;
self.ConnectOutput("OnDeath", "CarrierDroneDied");
