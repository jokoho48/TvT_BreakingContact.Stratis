fnc_refreshEntryBuyButton = {
	disableSerialization;

	_idc = _this select 0;
	_display = _this select 1;
	_xPos = _this select 2;
	_width = _this select 3;
	_selector = _this select 4;
	_supplies = _this select 5;
	_spawnMethod = _this select 6;
	_status = _this select 7;
	_cost = _this select 8;


	_btn =  findDisplay 1337 displayCtrl _idc;

	_moneyVar = player getVariable "GRAD_buymenu_money_name";
	_money = missionNamespace getVariable _moneyVar;

	_newMoney = _money - _cost;
	if (_newMoney < 0) exitWith {
		ctrlSetText [_idc, localize 'str_GRAD_buy_tooexpensive'];
		_btn ctrlSetTextColor  [0.8,0.2,0.2,1];
        ctrlEnable [_idc, false];

        GRAD_buymenu_currentMenuBuyButtonIDCs setVariable [_selector, _idc];
        _btn ctrlCommit 0;
	};


	buttonSetAction [_idc, format["['%1', %2] call fnc_addOrder;", _selector, _spawnMethod]];

	switch (_status) do {
		case 0: {ctrlEnable [_idc, true];  _btn ctrlSetText (localize "str_GRAD_buy_order_hint");};
		case 1: {ctrlEnable [_idc, false]; _btn ctrlSetText (localize "str_GRAD_buy_calling");};
		case 2: {ctrlEnable [_idc, false]; _btn ctrlSetText (localize "str_GRAD_buy_noleft");};
		default {};
	};

    GRAD_buymenu_currentMenuBuyButtonIDCs setVariable [_selector, _idc];
    

	_btn ctrlCommit 0;
};