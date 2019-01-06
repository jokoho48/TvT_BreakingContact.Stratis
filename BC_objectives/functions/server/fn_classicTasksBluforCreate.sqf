params ["_count", "_min"];

_taskName = "bluforTask1";
_taskDescription = format [localize "str_GRAD_classicTaskDescriptionBlufor",_count, _min];
_taskTitle = format [localize "str_GRAD_classicTaskTitleBlufor",_count, _min];
_areaMarkerName = " target area ";
_type = "destroy";

if (CONQUER_MODE) then {
     _taskDescription = format [localize "str_GRAD_classicTaskDescriptionBlufor_conquermode", _count, _min];
     _taskTitle = format [localize "str_GRAD_classicTaskTitleBlufor_conquermode", _count, _min];
};

_bluforTask1 = [
     WEST,
     _taskName,
     [
          _taskDescription,
          _taskTitle,
          _areaMarkerName
     ],
     objNull,
     "AUTOASSIGNED",
     2,
     true,
     "destroy"
] call BIS_fnc_taskCreate;

sleep 3;

_taskName = "bluforTask2";
_taskDescription = localize "str_GRAD_classicTaskDescriptionBlufor2";
_taskTitle = localize "str_GRAD_classicTaskTitleEliminate";
_areaMarkerName = " target area ";

_bluforTask2 = [
     WEST,
     _taskName,
     [
          _taskDescription,
          _taskTitle,
          _areaMarkerName
     ],
     objNull,
     "AUTOASSIGNED",
     1,
     true,
     "destroy"
] call BIS_fnc_taskCreate;


[_bluforTask1,_bluforTask2]
