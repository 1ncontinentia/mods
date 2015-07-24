class Extended_PreInit_EventHandlers {
	ADDON = QUOTE(call COMPILE_FILE(XEH_preInit));
};

class Extended_PostInit_EventHandlers {
	ADDON = QUOTE(call COMPILE_FILE(XEH_postInit));
};

class Extended_InitPost_EventHandlers {
	class SoldierWB {
		class ADDON {
			serverInit = QUOTE(_this call FUNC(addUnitToQueue));
		};
	};
	class SoldierEB {
		class ADDON {
			serverInit = QUOTE(_this call FUNC(addUnitToQueue));
		};
	};
	class SoldierGB {
		class ADDON {
			serverInit = QUOTE(_this call FUNC(addUnitToQueue));
		};
	};
};

class Extended_FiredBIS_EventHandlers {
	class AllVehicles {
		class ADDON {
			serverFiredBIS = QUOTE(if (GVAR(enabled) == 1 && GVAR(gunshothearing) > 0) then {_this call FUNC(firedEH)});
		};
	};
};

class Extended_Killed_EventHandlers {
	class SoldierWB {
		class ADDON {
			serverKilled = QUOTE(if (GVAR(enabled) == 1) then {if (GVAR(joinlast) > 0) then {_this spawn FUNC(killedEH)}});
		};
	};
	class SoldierEB {
		class ADDON {
			serverKilled = QUOTE(if (GVAR(enabled) == 1) then {if (GVAR(joinlast) > 0) then {_this spawn FUNC(killedEH)}});
		};
	};
	class SoldierGB {
		class ADDON {
			serverKilled = QUOTE(if (GVAR(enabled) == 1) then {if (GVAR(joinlast) > 0) then {_this spawn FUNC(killedEH)}});
		};
	};
};

class Extended_Hit_EventHandlers {
	class SoldierWB {
		class ADDON {
			serverHit = QUOTE(if (GVAR(enabled) == 1) then {_this call FUNC(handleHit)});
		};
	};
	class SoldierEB {
		class ADDON {
			serverHit = QUOTE(if (GVAR(enabled) == 1) then {_this call FUNC(handleHit)});
		};
	};
	class SoldierGB {
		class ADDON {
			serverHit = QUOTE(if (GVAR(enabled) == 1) then {_this call FUNC(handleHit)});
		};
	};
};

class Extended_InventoryClosed_EventHandlers {
	class CAManBase {
		ADDON = QUOTE(if (GVAR(enabled) == 1) then {_this call FUNC(inventoryClosed)});
	};
};
