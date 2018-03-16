if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_markerPos","_spawnPos","_objs","_camp","_fire","_group"];

_objs = [];

_markerPos = getMarkerPos _marker;

_camp = selectRandom AS_campList;
_spawnPos = _markerPos findEmptyPosition [1,50,"I_Heli_Transport_02_F"];
_objs = [_spawnPos, floor(random 361), _camp] call BIS_fnc_ObjectsMapper;

sleep 2;

{
	call {
		if (typeof _x == campCrate) exitWith
		{
			[_x] call cajaAAF;
			[_x,"heal_camp"] remoteExec ["AS_fnc_addActionMP"];
			
			_x addAction [localize "str_act_healRepair", "healandrepair.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
			_x addAction [localize "str_act_buyVehicle",
				{
					nul = createDialog "vehicle_option"
				},
				nil,
				0,
				false,
				true,
				"",
				"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
			];
			_x addaction [
				localize"STR_ACT_GARAGE",
				{
					//["jn_fnc_garage"] call bis_fnc_startloadingscreen;
					UINamespace setVariable ["jn_type","garage"];
					[clientOwner] remoteExecCall ["jn_fnc_garage_requestOpen",2];
				},
				[],
				6,
				true,
				false,
				"",
				"alive _target && {_target distance _this < 5}"
			];
			_x addaction [
				localize"STR_ACT_ARSENAL",
				{
					["jn_fnc_arsenal"] call bis_fnc_startloadingscreen;
					//save proper ammo because BIS arsenal rearms it, and I will over write it back again
					missionNamespace setVariable ["jna_magazines_init",  [
						magazinesAmmoCargo (uniformContainer player),
						magazinesAmmoCargo (vestContainer player),
						magazinesAmmoCargo (backpackContainer player)
					]];

					//Save attachments in containers, because BIS arsenal removes them
					_attachmentsContainers = [[],[],[]];
					{
						_container = _x;
						_weaponAtt = weaponsItemsCargo _x;
						_attachments = [];

						if!(isNil "_weaponAtt")then{

							{
								_atts = [_x select 1,_x select 2,_x select 3,_x select 5];
								_atts = _atts - [""];
								_attachments = _attachments + _atts;
							} forEach _weaponAtt;
							_attachmentsContainers set [_foreachindex,_attachments];
						}
					} forEach [uniformContainer player,vestContainer player,backpackContainer player];
					missionNamespace setVariable ["jna_containerCargo_init", _attachmentsContainers];

					//set type
					UINamespace setVariable ["jn_type","arsenal"];

					//request server to open arsenal
					[clientOwner] remoteExecCall ["jn_fnc_arsenal_requestOpen",2];
				},
				[],
				6,
				true,
				false,
				"",
				"alive _target && {_target distance _this < 5}"
			];
		};
		
		if (typeof _x == "Land_MetalBarrel_F") exitWith {[_x,"refuel"] remoteExec ["AS_fnc_addActionMP"]};
		if (typeof _x == "Land_Campfire_F") exitWith {_fire = _x;};
	};
	_x setVectorUp (surfaceNormal (position _x));
} forEach _objs;

_group = [_spawnPos, side_blue, ([guer_grp_sniper, "guer"] call AS_fnc_pickGroup)] call BIS_Fnc_spawnGroup;
_group setBehaviour "STEALTH";
_group setCombatMode "GREEN";

{[_x] spawn AS_fnc_initialiseFIAGarrisonUnit;} forEach units _group;

_shorecheck = [_spawnPos, 0, 50, 0, 0, 0, 1, [], [0]] call BIS_fnc_findSafePos;
if ((typename _shorecheck) == "ARRAY") then {[[_fire,"seaport"],"AS_fnc_addActionMP"] call BIS_fnc_MP;};

sleep 10;
_fire inflame true;

waitUntil {sleep 5; !(spawner getVariable _marker) OR ({alive _x} count units _group == 0) OR !(_marker in campsFIA)};

if ({alive _x} count units _group == 0) then {
	[_marker,{["TaskFailed", ["", format [localize "STR_TSK_TD_CAMP_DESTROYED", markerText _this]]] call BIS_fnc_showNotification}] remoteExec ["call", 0];
	campsFIA = campsFIA - [_marker]; publicVariable "campsFIA";
	campList = campList - [[_marker, markerText _marker]]; publicVariable "campList";
	usedCN = usedCN - [markerText _marker]; publicVariable "usedCN";
	markers = markers - [_marker]; publicVariable "markers";
	deleteMarker _marker;
};

waitUntil {sleep 5; !(spawner getVariable _marker) OR !(_marker in campsFIA)};

{deleteVehicle _x} forEach units _group;
deleteGroup _group;

_fire inflame false;
sleep 2;
{deleteVehicle _x} forEach _objs;