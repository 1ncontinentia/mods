#include "script_component.hpp"

#include "CfgPatches.hpp"

PRELOAD_ADDONS;

#include "CfgAmmo.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"

#include "CfgEventhandlers.hpp"

class CfgAISkill {
	aimingAccuracy[] = {0, 0, 1, 1};	//default
	aimingShake[] = {0, 0, 1, 1};		//default
	aimingSpeed[] = {0, 0.1, 1, 1};		//0.5->0.1
	endurance[] = {0, 0, 1, 1};		//default
	spotDistance[] = {0, 0.1, 1, 0.4};	//0.2->0.1
	spotTime[] = {0, 0, 1, 1};		//0.7->1
	courage[] = {0, 0, 1, 1};		//default
	reloadSpeed[] = {0, 0, 1, 1};		//default
	commanding[] = {0, 0, 1, 1};		//default
	general[] = {0, 0, 1, 1};		//default
};
/*
aimingAccuracy
Affects how well the AI can lead a target
Affects how accurately the AI estimate range and calculates bullet drop
Affects how well the AI compensates for weapon dispersion
Affects how much the AI will know to compensate for recoil (Higher value = more controlled fire)
Affects how certain the AI must be about its aim on target before opening fire
aimingShake
Affects how steadily the AI can hold a weapon (Higher value = less weapon sway)
aimingSpeed
Affects how quickly the AI can rotate and stabilize its aim (Higher value = faster, less error)
commanding
Affects how quickly recognized targets are shared with the group (Higher value = faster reporting)
courage
Affects unit's subordinates' morale (Higher value = more courage)
endurance
Disabled in Arma3

general
Raw "Skill", value is distributed to sub-skills unless defined otherwise. Affects the AI's decision making.
reloadSpeed
Affects the delay between switching or reloading a weapon (Higher value = less delay)
spotDistance
Affects the AI ability to spot targets within it's visual or audible range (Higher value = more likely to spot)
Affects the accuracy of the information (Higher value = more accurate information)
spotTime
Affects how quick the AI react to death, damage or observing an enemy (Higher value = quicker reaction)
*/
