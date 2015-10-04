checkInsideMap = {
	_maximumX = _this select 0;
	_maximumY = _this select 0;
	_positionX = (_this select 1) select 0;
	_positionY = (_this select 1) select 1;
	_resultInsideMap = true;

	diag_log format ["MapsizeX: %1, MapsizeY: %2, PositionX: %3, PositionY: %4",_maximumX,_maximumY,_positionX,_positionY];

	if (_positionX < 0 || _positionX > _maximumX) then {_resultInsideMap = false;};
	if (_positionY < 0 || _positionY > _maximumY) then {_resultInsideMap = false;};

	_resultInsideMap
};

// ripped from fry
get_slope = {
	private ["_position", "_radius", "_slopeObject", "_centerHeight", "_height", "_direction", "_count"];
	_position = _this select 0;_radius = _this select 1;
	_slopeObject = "Logic" createVehicleLocal _position;
	_slopeObject setPos _position;
	_centerHeight = getPosASL _slopeObject select 2;
	_height = 0;_direction = 0;
	for "_count" from 0 to 7 do {
		_slopeObject setPos [(_position select 0)+((sin _direction)*_radius),(_position select 1)+((cos _direction)*_radius),0];
		_direction = _direction + 45;
		_height = _height + abs (_centerHeight - (getPosASL _slopeObject select 2));
	};
	deleteVehicle _slopeObject;
	_height / 8
};

testSpawnPositions = {
	_center = _this select 0;
	_items = _this select 1;
	_distance = _this select 2;
	_result = [2,nil,nil];

	_mapSize = getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize");



	// put something very big in there, just to be sure there is enough room
	_testPos1 = [_center,[_distance,_distance], random 360,0,[1,500]] call SHK_pos;
	if (count _testPos1 < 1) exitWith {_result = [1,nil,nil];};	
	if (!([_mapSize, _testPos1] call checkInsideMap)) exitWith {_result = [1,nil,nil]; diag_log format ["Calculating Spawnposis: Outside Map."]; _result };
	if ([_testPos1, 10] call get_slope > 0.6) exitWith {_result = [1,nil,nil]; diag_log format ["Calculating Spawnposis: Not flat enough."]; _result };


	_testVehicle1 = (_items select 0) createVehicle _testPos1;


	_testPos2 = [_testPos1,[30,50], random 360,0,[1,500]] call SHK_pos;
	if (count _testPos2 < 1) exitWith {_result = [1,nil,nil]; diag_log format ["Calculating Spawnposis: No matching second pos."]; _result};	
	if (_testPos1 distance _testPos2 < 10) exitWith {deleteVehicle _testVehicle1; _result = [1,nil,nil]; diag_log format ["Calculating Spawnposis: HQ too close on marker."]; _result};
	if ([_testPos2, 10] call get_slope > 0.6) exitWith {deleteVehicle _testVehicle1;_result = [1,nil,nil]; diag_log format ["Calculating Spawnposis: Not flat enough."]; _result};

	_testVehicle2 = (_items select 1) createVehicle _testPos2;

	_result = [2, _testVehicle1, _testVehicle2];

	_road1 = [getPos _testVehicle1] call BIS_fnc_nearestRoad;
	_road2 = [getPos _testVehicle2] call BIS_fnc_nearestRoad;
	if (!isNull _road1) then {
		_roadConnectedTo1 = roadsConnectedTo _road1;  
	 	_connectedRoad1 = _roadConnectedTo1 select 0;  
	 	_direction1 = [_road1, _connectedRoad1] call BIS_fnc_DirTo; 
	 	_testVehicle1 setDir _direction1;
	};
	if (!isNull _road2) then {
		_roadConnectedTo2 = roadsConnectedTo _road2;  
	 	_connectedRoad2 = _roadConnectedTo2 select 0;  
	 	_direction2 = [_road2, _connectedRoad2] call BIS_fnc_DirTo; 
	 	_testVehicle2 setDir _direction2;
	};

	_result
};


spawnBluforHQ = {
	_bluforCenterPosition = _this select 0;
	_bluforDistance = _this select 1;
	_waitingForBluforSpawn = true;
	


	while {_waitingForBluforSpawn} do {
		_bluforSpawnSuccess = [0,nil,nil];
		_bluforSpawnSuccess = [_bluforCenterPosition, ["US_WarfareBUAVterminal_Base_EP1","Land_HelipadCivil_F"], _bluforDistance] call testSpawnPositions;
		waitUntil {(_bluforSpawnSuccess select 0) > 0};

		if ((_bluforSpawnSuccess select 0) > 1) exitWith {
			_waitingForBluforSpawn = false;

			US_VEHICLE_SPAWN = getPos (_bluforSpawnSuccess select 2);
			publicVariable "US_VEHICLE_SPAWN";

			BLUFOR_TELEPORT_TARGET = getPos (_bluforSpawnSuccess select 2);
			publicVariableServer "BLUFOR_TELEPORT_TARGET";

			debugLog("blufor published target");
			diag_log format ["creating blufor stuff on position: %1",US_VEHICLE_SPAWN];
		};


		sleep 0.01;
	};
};

spawnOpforHQ = {
	_opforCenterPosition = _this select 0;
	_opforDistance = _this select 1;
	_waitingForOpforSpawn = true;
	

	while {_waitingForOpforSpawn} do {
		_opforSpawnSuccess = [0,nil,nil];
		_opforSpawnSuccess = [_opforCenterPosition, ["TK_WarfareBUAVterminal_Base_EP1","Land_HelipadCivil_F"], _opforDistance] call testSpawnPositions;
		waitUntil {(_opforSpawnSuccess select 0) > 0};

		if ((_opforSpawnSuccess select 0) > 1) exitWith {
			_waitingForOpforSpawn = false;

			RUS_VEHICLE_SPAWN = getPos (_opforSpawnSuccess select 2);
			publicVariable "RUS_VEHICLE_SPAWN";

			/* OPFOR_TELEPORT_TARGET = getPos (_opforSpawnSuccess select 2);
			publicVariableServer "OPFOR_TELEPORT_TARGET"; */

			diag_log format ["creating opfor stuff on position: %1",RUS_VEHICLE_SPAWN];
		};

		sleep 0.01;
	};
};