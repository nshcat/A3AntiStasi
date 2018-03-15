// Called with vehicle class index

if (player != player getVariable ["owner",player]) exitWith {hint "You cannot buy vehicles while you are controlling AI"};

_chequeo = false;
{
	if (((side _x == side_red) or (side _x == side_green)) and (_x distance player < safeDistance_recruit) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot buy vehicles with enemies nearby"};

private ["_tipoVeh","_coste","_resourcesFIA","_classIndex","_xplevel","_typeList","_costList","_marcador","_pos","_veh"];

// Its not passed as an array
_classIndex = _this;

// Load current army xp TODO is this the correct variable?
_xplevel = server getVariable "skillFIA";

if(_xplevel > vehMaxLevel) then {
	_xplevel = vehMaxLevel;
};

// Obtain cost
_costList = vehPrices select _classIndex;
_coste = _costList select _xplevel;

// Check if vehicle class in unavailable
if(_coste <= 0) exitWith {hint "This class of vehicle is not yet unlocked. Inrease your army level to gain acces to it."};


// Obtain vehicle type
_typeList = vehIDs select _classIndex;
_tipoVeh = _typeList select _xplevel;


if (!isMultiPlayer) then {_resourcesFIA = server getVariable "resourcesFIA"}
else
{
	_resourcesFIA = server getVariable "resourcesFIA";
};

if (_resourcesFIA < _coste) exitWith {hint format ["You do not have enough money for this vehicle: %1 € required",_coste]};
_pos = position player findEmptyPosition [10,50,_tipoVeh];
if (count _pos == 0) exitWith {hint "Not enough space to place this type of vehicle"};

_veh = _tipoVeh createVehicle _pos;


if (!isMultiplayer) then
{
	[0,(-1* _coste)] remoteExec ["resourcesFIA", 2];
}
else
{
	if (player != Slowhand) then
	{
		[-1* _coste] call resourcesPlayer;
		_veh setVariable ["vehOwner",getPlayerUID player,true];
	}
	else
	{
		[0,(-1* _coste)] remoteExecCall ["resourcesFIA",2]
	};
};
[_veh] spawn VEHinit;

hint "Vehicle Purchased";
player reveal _veh;
petros directSay "SentGenBaseUnlockVehicle";
