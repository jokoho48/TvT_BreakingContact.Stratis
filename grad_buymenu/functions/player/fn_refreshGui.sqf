if (!dialog) exitWith {};
// closeDialog 0;
diag_log format ["refreshing gui"];
_gui = [true] call GRAD_buymenu_fnc_createEntries;
if (isNull _gui) exitWith {};
_toolbar = [_gui, true] spawn GRAD_buymenu_fnc_createToolbar;