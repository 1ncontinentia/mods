//#define DEBUG_MODE_FULL
#include "script_component.hpp"
PARAMS_2(_unit,_dangerCausedBy);
private ["_coverRange","_grp","_bpos","_dude"];

_grp = group _unit;
_time = diag_ticktime;

if (unitReady _unit && {{isPlayer _x} count units _grp == 0} && {_time > (_unit getVariable [QGVAR(reacting),0]) + 30}) then {
        
    _unit setVariable [QGVAR(reacting),_time,false]; //save last time we ran this for this unit, so we don't run more than twice per minute / unit

	// mount weapons
	if (random 1 < GVAR(getinweapons)) then {
        private ["_leader","_weapons","_wc","_weap","_mc","_ehid"];
        _leader = leader _grp;
        _weapons = [getposATL _leader, vehicles, 100, {!(_x isKindOf "Plane" || _x isKindOf "Tank") && {_x call FUNC(canMountAIGunner)}}] call FUNC(getNearest);
        TRACE_2("empty weapons",_grp,_weapons);
        _wc = count _weapons;
        if (_wc > 0) then {
            { //get some units to man the weapons
                if (_wc > 0 && {_x != _leader} && {random 1 < 0.8}) then {
                    DEC(_wc);
                    _weap = _weapons select _wc;
                    _ehid = _weap getVariable [QGVAR(getInWeaponsEH), -1];
                    if (_ehid == -1) then {
                        _ehid = _weap addEventHandler ["GetIn", {_this spawn FUNC(getInWeaponsEH)}];
                        _weap setVariable [QGVAR(getInWeaponsEH), _ehid];
                    };
                    _mc = _weap getVariable [QGVAR(mountcount), 0];
                    if (_mc < ceil (2 + random 4)) then { // mount up to a few times
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
		_dude = _unit;
		//pick another dude if possible
		{if (_x != _unit) exitWith {_dude = _x}} forEach units _grp;
                if (_dude getVariable [QGVAR(housing),false]) exitWith {};
		_bpos = [];
		{
			{
				if (random 1 > 0.2) then {_bpos pushBack [_x select 2, _x]}; //pick some; get height and pos
			} forEach ([_x] call BIS_fnc_buildingPositions);
		} forEach (_dangerCausedBy nearObjects ["HouseBase", 75]);
		if (count _bpos > 0) then {
			_bpos sort false; //prefer higher positions
			[_dude,(_time + 300),_bpos] spawn {
				PARAMS_3(_dude,_dangerUntil,_bpos);
				private "_timeout";
                _dude setVariable [QGVAR(housing),true,false];
                TRACE_1("House search duty",_dude);
				while {count _bpos > 0 && {diag_ticktime < _dangerUntil} && {_dude call FUNC(isValidUnitC)}} do {
					waitUntil {isNil {_dude getVariable QGVAR(shooting)}}; // stopped shooting
					doStop _dude;
					_dude doMove (([_bpos] call BIS_fnc_arrayShift) select 1);
					_timeout = diag_ticktime + 60;
					waitUntil {unitReady _dude || {_timeout < diag_ticktime}};
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
	_coverRange = if (currentWaypoint _grp == count waypoints _grp) then {100} else {20};
	[_unit,_dangerCausedBy,_coverRange] call FUNC(moveToCover);

};
