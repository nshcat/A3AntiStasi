if (!isServer and hasInterface) exitWith {};

private ["_tipo","_cantidad","_tipoMuni","_grupo","_unit","_tam","_roads","_road","_pos","_camion","_texto","_mrk","_ATminesAdd","_APminesAdd","_posicionTel","_tsk","_magazines","_typeMagazines","_cantMagazines","_newCantMagazines","_mina","_tipo","_camion"];

_tipo = _this select 0;
_posicionTel = _this select 1;
_cantidad = _this select 2;
_coste = (2*(server getVariable guer_sol_EXP)) + ([guer_veh_truck] call vehiclePrice);
[-2,-1*_coste] remoteExec [resourcesFIA,2];

if (_tipo == "ATMine") then
	{
	_tipoMuni = atMine;
	};
if (_tipo == "APERSMine") then
	{
	_tipoMuni = apMine;
	};

_magazines = getMagazineCargo caja;
_typeMagazines = _magazines select 0;
_cantMagazines = _magazines select 1;
_newCantMagazines = [];

for "_i" from 0 to (count _typeMagazines) - 1 do
	{
	if ((_typeMagazines select _i) != _tipoMuni) then
		{
		_newCantMagazines pushBack (_cantMagazines select _i);
		}
	else
		{
		_cuantasHay = (_cantMagazines select _i);
		_cuantasHay = _cuantasHay - _cantidad;
		if (_cuantasHay < 0) then {_cuentasHay = 0};
		_newCantMagazines pushBack _cuantasHay;
		};
	};

clearMagazineCargoGlobal caja;

for "_i" from 0 to (count _typeMagazines) - 1 do
	{
	caja addMagazineCargoGlobal [_typeMagazines select _i,_newCantMagazines select _i];
	};

_mrk = createMarker [format ["Minefield%1", random 1000], _posicionTel];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [100,100];
_mrk setMarkerType "hd_warning";
_mrk setMarkerColor "ColorRed";
_mrk setMarkerBrush "DiagGrid";
_mrk setMarkerText _texto;

_tsk = ["Mines",[side_blue,civilian],[["STR_TSK_MINEFIELD_DESC",_cantidad],"STR_MINEFIELD_TITLE",_mrk],_posicionTel,"CREATED",5,true,true,"map"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_grupo = createGroup side_blue;

_unit = _grupo createUnit [guer_sol_EXP, (getMarkerPos guer_respawn), [], 0, "NONE"];
sleep 1;
_unit = _grupo createUnit [guer_sol_EXP, (getMarkerPos guer_respawn), [], 0, "NONE"];
_grupo setGroupId ["MineF"];

_tam = 10;
while {true} do
	{
	_roads = getMarkerPos guer_respawn nearRoads _tam;
	if (count _roads < 1) then {_tam = _tam + 10};
	if (count _roads > 0) exitWith {};
	};
_road = _roads select 0;
_pos = position _road findEmptyPosition [1,30,guer_veh_truck];

_camion = guer_veh_truck createVehicle _pos;

_grupo addVehicle _camion;
{[_x] spawn AS_fnc_initialiseFIAUnit; [_x] orderGetIn true} forEach units _grupo;
[_camion] spawn VEHinit;
leader _grupo setBehaviour "SAFE";
Slowhand hcSetGroup [_grupo];
_grupo setVariable ["isHCgroup", true, true];
_camion allowCrewInImmobile true;

//waitUntil {sleep 1; (count crew _camion > 0) or (!alive _camion) or ({alive _x} count units _grupo == 0)};

waitUntil {sleep 1; (!alive _camion) or ((_camion distance _posicionTel < 50) and ({alive _x} count units _grupo > 0))};

if ((_camion distance _posicionTel < 50) and ({alive _x} count units _grupo > 0)) then
	{
	if (isPlayer leader _grupo) then
		{
		_owner = player getVariable ["owner",player];
		//removeAllActions player;  ----- might cause issues
		selectPlayer _owner;
		(leader _grupo) setVariable ["owner",player,true];
		{[_x] joinsilent group player} forEach units group player;
		group player selectLeader player;
		hint "";
		};
	Slowhand hcRemoveGroup _grupo;
	[[petros,"locHint","STR_TSK_MINEFIELD_HINT"],"commsMP"] call BIS_fnc_MP;
	[_grupo, _mrk, "SAFE","SPAWNED", "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
	sleep 30*_cantidad;
	if ((alive _camion) and ({alive _x} count units _grupo > 0)) then
		{
		{deleteVehicle _x} forEach units _grupo;
		deleteGroup _grupo;
		deleteVehicle _camion;
		for "_i" from 1 to _cantidad do
			{
			_mina = createMine [_tipo,_posicionTel,[],100];
			side_blue revealMine _mina;
			};
		_tsk = ["Mines",[side_blue,civilian],[["STR_TSK_MINEFIELD_DESC",_cantidad],"STR_MINEFIELD_TITLE",_mrk],_posicionTel,"SUCCEEDED",5,true,true,"Map"] call BIS_fnc_setTask;
		sleep 15;
		//[_tsk,true] call BIS_fnc_deleteTask;
		[0,_tsk] spawn borrarTask;
		[2,_coste] remoteExec ["resourcesFIA",2];
		}
	else
		{
		_tsk = ["Mines",[side_blue,civilian],[["STR_TSK_MINEFIELD_DESC",_cantidad],"STR_MINEFIELD_TITLE",_mrk],_posicionTel,"FAILED",5,true,true,"Map"] call BIS_fnc_setTask;
		sleep 15;
		Slowhand hcRemoveGroup _grupo;
		//[_tsk,true] call BIS_fnc_deleteTask;
		[0,_tsk] spawn borrarTask;
		{deleteVehicle _x} forEach units _grupo;
		deleteGroup _grupo;
		deleteVehicle _camion;
		deleteMarker _mrk;
		};
	}
else
	{
	_tsk = ["Mines",[side_blue,civilian],[["STR_TSK_MINEFIELD_DESC",_cantidad],"STR_MINEFIELD_TITLE",_mrk],_posicionTel,"FAILED",5,true,true,"Map"] call BIS_fnc_setTask;
	sleep 15;
	Slowhand hcRemoveGroup _grupo;
	//[_tsk,true] call BIS_fnc_deleteTask;
	[0,_tsk] spawn borrarTask;
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	deleteVehicle _camion;
	deleteMarker _mrk;
	};

