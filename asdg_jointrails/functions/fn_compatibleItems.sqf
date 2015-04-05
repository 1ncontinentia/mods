/*
	Author: Karel Moricky
	Fixed by Robalo

	Description:
	Return all compatible weapon attachments
	
	Parameter(s):
		0: STRING - weapon class
		1: STRING - accessory type: number (see defines below; optional)
	
	Returns:
	ARRAY of STRINGs
*/

#define ACCMUZZLE 101
#define ACCSIGHTS 201
#define ACCPOINTER 301
#define ACCBIPOD 302

private ["_weapon","_cfgWeapon","_infoType"];
_weapon = [_this,0,"",[""]] call bis_fnc_param;
_typefilter = [_this,1,0] call bis_fnc_param;
_cfgWeapon = configfile >> "cfgweapons" >> _weapon;

if (isClass _cfgWeapon) then {
	private ["_compatibleItems"];
	_compatibleItems = [];
	{
		private ["_cfgCompatibleItems"];
		_cfgCompatibleItems = _x >> "compatibleItems";
		if (isarray _cfgCompatibleItems) then {
			{
				if !(_x in _compatibleItems) then {_compatibleItems pushBack _x;};
			} forEach getArray _cfgCompatibleItems;
		} else {
			if (isclass _cfgCompatibleItems) then {
				{
					if (getnumber _x > 0 && {!((configname _x) in _compatibleItems)}) then {_compatibleItems pushback configname _x};
				} foreach configproperties [_cfgCompatibleItems, "isNumber _x"];
			};
		};
	} foreach configproperties [_cfgWeapon >> "WeaponSlotsInfo","isclass _x"];
	if (_typefilter == 0) then {_compatibleItems} else {[_compatibleItems, {_typefilter == getnumber(configfile>>"cfgweapons">>_x>>"itemInfo">>"type")}] call BIS_fnc_conditionalSelect};

} else {
	if (_weapon != "") then {["'%1' not found in CfgWeapons",_weapon] call bis_fnc_error;};
	[]
};
