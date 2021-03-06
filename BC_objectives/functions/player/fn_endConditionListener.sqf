#include "\z\ace\addons\main\script_component.hpp"
#include "..\..\..\missionMacros.h"

private _TRANSMISSION_COMPLETE_listener = {
     if (_this select 1) then {
          _string = localize "str_GRAD_winmsg_points";
          [_string] call EFUNC(common,displayTextStructured);
          _transmissionPercentage = call GRAD_tracking_fnc_getTransmissionPercentage;
          missionNamespace setVariable ["BC_transmissionPercentage", str _transmissionPercentage, true];
          ["east", "transmission"] spawn BC_objectives_fnc_endMission;
     };
};

private _BLUFOR_CAPTURED_listener = {
     if (_this select 1) then {
          _transmissionPercentage = call GRAD_tracking_fnc_getTransmissionPercentage;
          missionNamespace setVariable ["BC_transmissionPercentage", str _transmissionPercentage, true];
          ["west", "captured"] spawn BC_objectives_fnc_endMission;
     };
};

private _BLUFOR_ELIMINATED_listener = {
     if (_this select 1) then {
          _transmissionPercentage = call GRAD_tracking_fnc_getTransmissionPercentage;
          missionNamespace setVariable ["BC_transmissionPercentage", str _transmissionPercentage, true];
          ["east", "elimination"] spawn BC_objectives_fnc_endMission;
     };
};

private _OPFOR_ELIMINATED_listener = {
     if (_this select 1) then {
          _transmissionPercentage = call GRAD_tracking_fnc_getTransmissionPercentage;
          missionNamespace setVariable ["BC_transmissionPercentage", str _transmissionPercentage, true];
          ["west", "elimination"] spawn BC_objectives_fnc_endMission;
     };
};

private _TRUCK_DESTROYED_NOT_CONQUERED_listener = {
     if (_this select 1) then {
          _transmissionPercentage = call GRAD_tracking_fnc_getTransmissionPercentage;
          missionNamespace setVariable ["BC_transmissionPercentage", str _transmissionPercentage, true];
          ["draw", "destroyed"] spawn BC_objectives_fnc_endMission;

     };
};

"TRANSMISSION_COMPLETE" addPublicVariableEventHandler _TRANSMISSION_COMPLETE_listener;
"BLUFOR_CAPTURED" addPublicVariableEventHandler _BLUFOR_CAPTURED_listener;
"BLUFOR_ELIMINATED" addPublicVariableEventHandler _BLUFOR_ELIMINATED_listener;
"OPFOR_ELIMINATED" addPublicVariableEventHandler _OPFOR_ELIMINATED_listener;

if (CONQUER_MODE) then {
     "TRUCK_DESTROYED_NOT_CONQUERED" addPublicVariableEventHandler _TRUCK_DESTROYED_NOT_CONQUERED_listener;
};

// runs in SP to emulate addPublicVariableEventHandler (which doesnt work in SP)
if (!isMultiplayer) then {
     _TRANSMISSION_COMPLETE_listener spawn {
          waitUntil {TRANSMISSION_COMPLETE};
          [0, TRANSMISSION_COMPLETE] call _this;
     };
     _BLUFOR_CAPTURED_listener spawn {
          waitUntil {BLUFOR_CAPTURED};
          [0, BLUFOR_CAPTURED] call _this;
     };
     _BLUFOR_ELIMINATED_listener spawn {
          waitUntil {BLUFOR_ELIMINATED};
          [0, BLUFOR_ELIMINATED] call _this;
     };
     _OPFOR_ELIMINATED_listener spawn {
          waitUntil {OPFOR_ELIMINATED};
          [0, OPFOR_ELIMINATED] call _this;
     };


     if (CONQUER_MODE) then {
          _TRUCK_DESTROYED_NOT_CONQUERED_listener spawn {
               waitUntil {TRUCK_DESTROYED_NOT_CONQUERED};
               [0, TRUCK_DESTROYED_NOT_CONQUERED] call _this;
          };
     };
};
