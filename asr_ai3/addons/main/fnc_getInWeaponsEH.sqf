//#define DEBUG_MODE_FULL
#include "script_component.hpp"
params ["_veh", "_pos", "_unit", "_turret"];
if ([group _unit] call FUNC(hasPlayer) || {_unit == missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", objNull]}) exitWith {};
private _time2leave = time + 300 + (random 300);
while {count (_veh magazinesTurret _turret) > 0 && {time < _time2leave}} do {sleep 10};
if (alive _unit && {alive _veh} && {vehicle _unit == _veh}) then {doGetOut _unit};
