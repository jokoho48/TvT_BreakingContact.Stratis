#include "\z\ace\addons\main\script_component.hpp"

forceRespawn player;

CSSA3_forceClose = true;
if (!isNull (findDisplay 7810)) then {closeDialog 0};


[{["Starting Replay."] call EFUNC(common,displayTextStructured);},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;

[{openMap [true,true];},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;