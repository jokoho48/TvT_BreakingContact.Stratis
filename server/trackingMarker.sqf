waitUntil {!isNil "radio_object"};


bluforCaptured = {
	BLUFOR_CAPTURED = TRUE; publicVariable "BLUFOR_CAPTURED";
};

bluforSurrendered = {
	BLUFOR_SURRENDERED = true; publicVariable "BLUFOR_SURRENDERED";
	publicVariable "OPFOR_POINTS";
};


radioTruckIsSending = {
	(((radio_object getVariable ["tf_range",0]) == 50000) && alive radio_object)
};

radioBoxIsSending = {
	(RADIO_BOX_ACTIVE)
};

// get multiplier for distance penalty radio box to truck
distanceToRadioNerf = {
	_distance = _this select 0;
	_mod = 1;
	if ((_distance > 50) && (_distance < 500)) then {
		_substractor = (_distance)/1000;
		// round value
		_substractor = _substractor * 100;
		_substractor = floor (_substractor);
		_substractor = _substractor / 100;

		_mod = _mod - _substractor;
	};
	if (_distance >= 500) then {
		_mod = 0.5;
	};
	[_mod,_distance]
};


booleanEqual = {
	_a = _this select 0;
	_b = _this select 1;

	(_a && _b) || (!_a && !_b)
};


// radio truck functions
setRadioTruckMarkerStatus = {
	_previous = RADIO_TRUCK_MARKER_HIDDEN;
	RADIO_TRUCK_MARKER_HIDDEN = _this;
	if (MISSION_COMPLETED) then {RADIO_TRUCK_MARKER_HIDDEN = true;};
	if (!alive radio_object) then {RADIO_TRUCK_MARKER_HIDDEN = true;};
	if (!([RADIO_TRUCK_MARKER_HIDDEN, _previous] call booleanEqual)) then {
		 publicVariable "RADIO_TRUCK_MARKER_HIDDEN";
	};
};

setRadioTruckMarkerPosition = {
	_prev = RADIO_TRUCK_MARKER_POS;
	RADIO_TRUCK_MARKER_POS = _this;
	if ((_prev select 0 != RADIO_TRUCK_MARKER_POS select 0) ||
		 (_prev select 1 != RADIO_TRUCK_MARKER_POS select 1)) then {
		 publicVariable "RADIO_TRUCK_MARKER_POS";
	};
};


// radio box functions
setRadioBoxMarkerStatus = {
	_previous = RADIO_BOX_MARKER_HIDDEN;
	RADIO_BOX_MARKER_HIDDEN = _this;
	if (MISSION_COMPLETED) then {RADIO_BOX_MARKER_HIDDEN = true;};
	if (!isNil "portableRadioBox" && {!alive portableRadioBox}) then {RADIO_BOX_MARKER_HIDDEN = true;};
	if (!([RADIO_BOX_MARKER_HIDDEN, _previous] call booleanEqual)) then {
		publicVariable "RADIO_BOX_MARKER_HIDDEN";
	};
};

setRadioBoxMarkerPosition = {
	_prev = RADIO_BOX_MARKER_POS;
	RADIO_BOX_MARKER_POS = _this;
	if ((_prev select 0 != RADIO_BOX_MARKER_POS select 0) ||
		 (_prev select 1 != RADIO_BOX_MARKER_POS select 1)) then {
		 publicVariable "RADIO_BOX_MARKER_POS";
	};
};



[] spawn {
	while {OPFOR_POINTS <= POINTS_NEEDED_FOR_VICTORY} do  {
		publicVariable "OPFOR_POINTS";
		sleep 5;
	};
};

sleep 2; // give it time, boy - possible fix for "Undefined variable in expression: radioTruckIsSending"

[] spawn {
	_result = [1,0];
	_counter = 0;
	while {true} do { // could be optimized and synced to real time - b/c as it is, there WILL be delays
		_radioTruckIsSending = call radioTruckIsSending;
		_radioBoxIsSending = call radioBoxIsSending;
		_bothAreSending = (_radioBoxIsSending && _radioTruckIsSending);

		if (_radioTruckIsSending && !_bothAreSending && !RADIO_BOX) then {
			OPFOR_POINTS = OPFOR_POINTS + 1;
			// diag_log format ["debug: radio truck is sending alone"];
		};

		if (!_radioTruckIsSending && _radioBoxIsSending) then {
			OPFOR_POINTS = OPFOR_POINTS + 0.5;
			// diag_log format ["debug: radio box is sending alone"];
		};

		if (_bothAreSending) then {
			_tempModifier = _result select 0;
			_tempDistance = _result select 1;

			_result = [radio_object distance portableRadioBox] call distanceToRadioNerf;
			_modifier = _result select 0;
			_distanceToRadioTruck = _result select 1;

			// check if distance changed, if yes, broadcast for client hint
			if ((_distanceToRadioTruck != _tempDistance) || (_modifier != _tempModifier)) then {
				RADIO_BOX_DISTANCE = _modifier * 100;
				publicVariable "RADIO_BOX_DISTANCE";
			};
			OPFOR_POINTS = OPFOR_POINTS + (1 * _modifier);
			// diag_log format ["debug:both are sending"];
		};



		!_radioTruckIsSending call setRadioTruckMarkerStatus;
		!_radioBoxIsSending call setRadioBoxMarkerStatus;

		if (typeOf radio_object == "rhs_gaz66_r142_vv") then {
			if (radio_object getHit "karoserie" == 1 && radio_object getHit "motor" == 1 && !(radio_object getVariable ["isCookingOff", false])) then {
				radio_object setVariable ["isCookingOff", true, true];
				[[radio_object, {[radio_object] call ace_cookoff_fnc_cookOff}], "helpers\execIfLocal.sqf"] remoteExec ["execVM",0,false];
			};
		};

		if (OPFOR_POINTS >= POINTS_NEEDED_FOR_VICTORY) exitWith {
			[] call bluforSurrendered;
		};

		if (!alive radio_object && {(radio_object getVariable ["detachableRadio", 0] != 2)}) exitWith {
			[] call bluforCaptured;
		};


		if (!RADIO_BOX_ACTIVE) then {
			if (!FACTIONS_DEFAULT) then {
				[getPos radio_object select 0, getPos radio_object select 1] call setRadioTruckMarkerPosition;
			} else {
				if (_counter < 10) then {
					_counter = _counter + 1;
				} else {
					_counter = 0;
					[getPos radio_object select 0, getPos radio_object select 1] call setRadioTruckMarkerPosition;
				};
			};
			// diag_log format ["line 159 trackinmarker moved to %1,%2", getPos radio_object select 0, getPos radio_object select 1];
			// diag_log format ["logging radio_object: %1", radio_object];
		} else {
			[getPos radio_object select 0, getPos radio_object select 1] call setRadioTruckMarkerPosition;
			[getPos portableRadioBox select 0, getPos portableRadioBox select 1] call setRadioBoxMarkerPosition;
			// diag_log format ["logging portableRadioBox: %1", portableRadioBox];
		};
		
		sleep 1;
	};
};