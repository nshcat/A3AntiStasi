private ["_display","_childControl", "_xplevel", "_costList", "_typeList" ];
createDialog "buy_vehicle";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
{
	// Load current army xp TODO is this the correct variable?
	_xplevel = server getVariable "skillFIA"

	if(_xplevel > vehMaxLevel)
	{
		_xplevel = vehMaxLevel;
	};

	// Truck
	_costList = [vehPrices select 0]
	_typeList = [vehIDs select 0]	
	_ChildControl = _display displayCtrl 104;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// Transport
	_costList = [vehPrices select 1]
	_typeList = [vehIDs select 1]	
	_ChildControl = _display displayCtrl 105;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// Fueltruck
	_costList = [vehPrices select 2]
	_typeList = [vehIDs select 2]	
	_ChildControl = _display displayCtrl 106;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// Ammotruck
	_costList = [vehPrices select 3]
	_typeList = [vehIDs select 3]	
	_ChildControl = _display displayCtrl 110;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// APC
	_costList = [vehPrices select 4]
	_typeList = [vehIDs select 4]	
	_ChildControl = _display displayCtrl 107;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// Artillery
	_costList = [vehPrices select 5]
	_typeList = [vehIDs select 5]	
	_ChildControl = _display displayCtrl 109;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// Tank
	_costList = [vehPrices select 6]
	_typeList = [vehIDs select 6]	
	_ChildControl = _display displayCtrl 108;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// AA
	_costList = [vehPrices select 7]
	_typeList = [vehIDs select 7]	
	_ChildControl = _display displayCtrl 111;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// Scout
	_costList = [vehPrices select 8]
	_typeList = [vehIDs select 8]	
	_ChildControl = _display displayCtrl 112;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
	
	
	// Gunship
	_costList = [vehPrices select 9]
	_typeList = [vehIDs select 9]	
	_ChildControl = _display displayCtrl 113;
	_ChildControl ctrlSetTooltip format ["Type: %1, Cost: %2 €", _typeList select _xplevel, _costList select _xplevel]
};
