params ["_side", "_selector"];

_side = _this select 0;
_selector = _this select 1;

sleep 3; // vehicles shouldnt spawn in each other

_supplyVar = '';
switch (_side) do {
    case west: {_supplyVar = 'suppliesBlufor';};
    case east: {_supplyVar = 'suppliesOpfor';};
    default { diag_log format ["fucking fatal error, side of player is b0rked"]; };
};

_supplies = (missionNamespace getVariable _supplyVar);
_supplyItem = _supplies getVariable _selector;
_amount = _supplyItem select 2;
if (_amount == 0) then {
    _supplyItem set [9, 2]; // block buy button forever
} else {
    _supplyItem set [9, 0]; // unblock buy button
};
_supplies setVariable [_selector, _supplyItem, true];

[_supplyVar] remoteExecCall ["GRAD_buymenu_fnc_apiInvalidateSupply", 0];