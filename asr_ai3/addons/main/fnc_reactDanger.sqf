//#define DEBUG_MODE_FULL
#include "script_component.hpp"
params ["_unit", "_dangerCausedBy"];

// skip in singleplayer when player is too far and not the source of danger (save computing resources)
if (!isMultiPlayer && {_dangerCausedBy != player} && {_unit distance player > 2000}) exitWith {};

private _grp = group _unit;
private _time = time;

if (_unit call FUNC(isValidUnitC) && {unitReady _unit} && {!(_grp call FUNC(hasPlayer))} && {_time > (_unit getVariable [QGVAR(reacting),0]) + 20}) then {
        
    _unit setVariable [QGVAR(reacting),_time,false]; //save last time we ran this for this unit, so we don't run more than thrice per minute / unit
    private _leader = leader _grp;

    // report to near groups
    if (GVAR(radiorange > 0) && {_unit == _leader} && {_unit knowsAbout _dangerCausedBy > 1.5}) then {
        [_grp,_dangerCausedBy] spawn FUNC(broadcastInfo);
    };

	// mount weapons
	if (random 1 < GVAR(getinweapons)) then {
        private ["_weap","_mc","_ehid"];
        private _weapons = [getposATL _leader, vehicles, 100, {!(_x isKindOf "Plane" || _x isKindOf "Tank") && {_x call FUNC(canMountAIGunner)}}] call FUNC(getNearest);
        TRACE_2("empty weapons",_grp,_weapons);
        private _wc = count _weapons;
        if (_wc > 0) then {
            { //get some units to man the weapons
                if (_wc > 0 && {_x != _leader} && {getSuppression _x < 0.4} && {random 1 < 0.8}) then {
                    DEC(_wc);
                    _weap = _weapons select _wc;
                    _ehid = _weap getVariable [QGVAR(getInWeaponsEH), -1];
                    if (_ehid == -1) then {
                        _ehid = _weap addEventHandler ["GetIn", {_this spawn FUNC(getInWeaponsEH)}];
                        _weap setVariable [QGVAR(getInWeaponsEH), _ehid];
                    };
                    _mc = _weap getVariable [QGVAR(mountcount), 0];
                    if (_mc < ceil (2 + random 5)) then { // mount up to a few times
                        doStop _x;
                        _x assignAsGunner _weap;
                        [_x] orderGetIn true;
                        INC(_mc);
                        _weap setVariable [QGVAR(mountcount), _mc];
                    };
                };
            } forEach units _grp;
        };
    };

	// search buildings
	if (!isNull _dangerCausedBy && {random 1 < GVAR(usebuildings)}) then {
		private _dude = _unit;
		//pick another dude if possible
		{if (_x != _unit) exitWith {_dude = _x}} forEach units _grp;
        if (_dude getVariable [QGVAR(housing),false]) exitWith {};
		private _bpos = [];
		{
			{
				if (random 1 > 0.2) then {_bpos pushBack [_x select 2, _x]}; //pick some; get height and pos
			} forEach ([_x] call BIS_fnc_buildingPositions);
		} forEach (_dangerCausedBy nearObjects ["HouseBase", 100]);
		if (count _bpos > 0) then {
			_bpos sort false; //prefer higher positions
			[_dude,(_time + 300),_bpos] spawn {
				params ["_dude", "_dangerUntil", "_bpos"];
				private "_timeout";
                _dude setVariable [QGVAR(housing),true,false];
                TRACE_1("House search duty",_dude);
				while {count _bpos > 0 && {time < _dangerUntil} && {_dude call FUNC(isValidUnitC)}} do {
					waitUntil {isNil {_dude getVariable QGVAR(shooting)} && {getSuppression _dude < 0.4}}; //stopped shooting and not suppressed
					doStop _dude;
					_dude doMove (([_bpos] call BIS_fnc_arrayShift) select 1);
					waitUntil {unitReady _dude}; //reached pos
					if (_dude call FUNC(isUnderRoof)) then {_dude setUnitPosWeak "Up"} else {_dude setUnitPosWeak "Auto"};
					doStop _dude;
					sleep (5 + random 20);
				};
				if (alive _dude) then { // regroup
					_dude setUnitPos "Auto";
					[_dude] joinSilent (group _dude);
                    _dude setVariable [QGVAR(housing),false,false];
				};
			};
		};
	};

	// check for cover near and divert
	private _coverRange = if (currentWaypoint _grp == count waypoints _grp) then {150} else {30};
	[_unit,_dangerCausedBy,_coverRange] call FUNC(moveToCover);

};
