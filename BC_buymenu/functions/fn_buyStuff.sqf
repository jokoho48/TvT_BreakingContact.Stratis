private _display = uiNamespace getVariable ["BC_buymenu_display", _display];
private _spawnCone = uiNamespace getVariable ["BC_buymenu_spawnCone", objNull];
_display closeDisplay 1;

[player] remoteExec ["BC_buymenu_fnc_dropMoney", [0,-2] select isDedicated];


private _buyQueue = missionNamespace getVariable ["BC_buymenu_vehicleSpawnQueue", []];

// copyToClipboard str _buyQueue;

private _spawnPos = (getPos _spawnCone);
private _roadArray = _spawnPos nearRoads 1000;
private _closestRoads = [_roadArray, [_spawnCone], { _input0 distance _x }, "ASCEND"] call BIS_fnc_sortBy;
// copyToClipBoard str _closestRoads;

private _debugMarkerGood = {
    _position = _this select 0;
    _position params ["_posX", "_posY"];
    _index = _this select 1;
    _markerstr = createMarker [format ["markernameGood%1",[_posX,_posY]], [_posX, _posY]];
    _markerstr setMarkerShape "ICON";
    _markerstr setMarkerType "hd_dot";
    _markerstr setMArkerColor "ColorGreen";
    _markerstr setMarkerText (str _index);
};

private _debugMarkerBad = {
    _position = _this select 0;
    _position params ["_posX", "_posY"];
    _index = _this select 1;
    _markerstr = createMarker [format ["markernameBad%1",[_posX,_posY]], [_posX, _posY]];
    _markerstr setMarkerShape "ICON";
    _markerstr setMarkerType "hd_dot";
    _markerstr setMArkerColor "ColorRed";
    _markerstr setMarkerText (str _index);
};

private _emptyIndex = 0;
    

    
for "_i" from _emptyIndex to ((count _closestRoads) - 1) do {
    private _road = (_closestRoads select _i);
    private _roadDir = getDir player;
    private _roadPos = getPos _road;
    private _roadsConnectedTo = roadsConnectedTo _road;
    if (count _roadsConnectedTo > 0) then {
        private _connectedRoad = _roadsConnectedTo select 0;
        _roadDir = [_road, _connectedRoad] call BIS_fnc_DirTo;
    };
    
    // _isEmpty = [_roadPos, 0, 5, 9, 0, 20, 0] call BIS_fnc_findSafePos;
    // [center, a, b, angle, isRectangle, c]
    private _foundStuff = (allMissionObjects "") inAreaArray [_roadPos, 8, 8, _roadDir, true, -1];
    // systemChat str _foundStuff;
    if ((count _foundStuff) < 1) then {
        _emptyIndex = _emptyIndex + 1;
        
        [_roadPos, _i] call _debugMarkerGood;

        if (_emptyIndex < ((count _buyQueue)-1)) then {
            diag_log format ["%1", _emptyIndex];
            private _data = _buyQueue select _emptyIndex;
            _data params ["_classname", "_displayName", "_maxCount", "_description", "_code", "_picturePath", "_crew", "_cargo", "_speed", "_baseConfigName", "_categoryConfigName", "_itemConfigName", "_spawnCone"];
            [player, player, 0, _code, _baseConfigName, _categoryConfigName, _itemConfigName, _roadPos, _roadDir] call BC_buymenu_fnc_buyVehicle;
        };
    } else {
        [_roadPos, _i] call _debugMarkerBad;
    };
};

    /*
    private _data = _x;
    private _road = _closestRoads select _emptyIndex;
    private _spawnPos = getPos _road;
    private _spawnDir = getDir _road;
    _data params ["_classname", "_displayName", "_maxCount", "_description", "_code", "_picturePath", "_crew", "_cargo", "_speed", "_baseConfigName", "_categoryConfigName", "_itemConfigName", "_spawnCone"];
    */

    // diag_log format ["_data %1", _data];
    // diag_log format ["_baseConfigName %1, _categoryConfigName %2, _itemConfigName %3", _baseConfigName, _categoryConfigName, _itemConfigName];

    // [player, player, 0, _code, _baseConfigName, _categoryConfigName, _itemConfigName, _spawnPos, _spawnDir] call BC_buymenu_fnc_buyVehicle;


missionNamespace setVariable ["BC_buymenu_vehicleSpawnQueue", []];