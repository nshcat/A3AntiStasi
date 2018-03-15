private ["_display","_childControl", "_xplevel", "_costList", "_typeList", "_tooltip" ];
createDialog "buy_vehicle";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
{
	_tooltip = {
		_dis = _this select 0;
		_classId = _this select	1;
		_bttId = _this select 2;
		
		
		// Retrieve control id
		_ChildControl = _dis displayCtrl _bttId;
		
		
		// Retrieve XP level
		_xplevel = server getVariable "skillFIA";

		if(_xplevel > vehMaxLevel) then
		{
			_xplevel = vehMaxLevel;
		};
		
		
		// Retrieve vehicle data
		_costList = vehPrices select _classId;
		_cost = _costList select _xplevel;
		_typeList = vehIDs select _classId;
		_type = _typeList select _xplevel;
		
		
		// If the price is 0, the class does not offer a vehicle type
		// at the current army XP level.
		if(_cost <= 0) then 
		{
			_childControl ctrlSetTooltip "Not available";
		}
		else
		{
			_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _type, _cost];
		};
	};
	
	// Truck
	[_display, 0, 104] call _tooltip;
	
	// Transport
	[_display, 1, 105] call _tooltip;
	
	// Fueltruck
	[_display, 2, 106] call _tooltip;
	
	// Ammotruck
	[_display, 3, 110] call _tooltip;
	
	// APC
	[_display, 4, 107] call _tooltip;
	
	// Artillery
	[_display, 5, 109] call _tooltip;
	
	// Tank
	[_display, 6, 108] call _tooltip;
	
	// AA
	[_display, 7, 111] call _tooltip;
	
	// Scout
	[_display, 8, 112] call _tooltip;
	
	// Gunship
	[_display, 9, 113] call _tooltip;
};
