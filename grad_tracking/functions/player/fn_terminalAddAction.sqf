params ["_terminal"];

_terminal addAction [
	"Open Terminal", {_this call GRAD_tracking_fnc_terminalOpen;}, 
	nil,1,false,true,"","_target getVariable ['RadioInterference',-1] == 0"
];

_terminal addAction [
	"Close Terminal", {_this call GRAD_tracking_fnc_terminalClose;},
	nil,1,false,true,"","_target getVariable ['RadioInterference',-1] == 2"
];

// condition: _terminal getVariable ("RadioInterference",false)