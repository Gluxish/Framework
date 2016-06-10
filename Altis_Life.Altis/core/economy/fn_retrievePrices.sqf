#include "..\..\script_macros.hpp"
/*
File: fn_retrievePrices.sqf
Author: Derek

Description:
Send a query to retrieve the price of stuff on the server
*/
private["_type","_side","_data","_ret","_tickTime","_queryResult","_market","_shoptype","_priceArray","_varname"];
_type = [_this,0,0,[0]] call BIS_fnc_param;
_data= [_this,1,"",[""]] call BIS_fnc_param;


//Error checks

diag_log format ["%1   %2",_type,_data];
if( _data == "") exitWith
{

diag_log "data null";

};


_market = missionNamespace getVariable "MarketPrices";

_itemArray = [];
_factor = [];
_shoptype = [];
_shoptype pushBack _data;
_shopItems = [];

switch (_data) do { 
    case "economy" :{ 
        _factor = [2,3,4];
    };
    default {
        _shopItems = M_CONFIG(getArray,"VirtualShops",_data, "items");
    };
};

{
    _name = SEL(_x,0);
    _fact = SEL(_x,1);
    if ((_fact in _factor) or (_name in _shopItems)) then {
        _varname = format["%1MarketGoodPrice",_name];
        _priceArray = missionNamespace getVariable (_varname);
        _itemArray pushBack _priceArray;
    };
} forEach _market;



if (_data == "economy") exitwith {[_type,_itemArray] spawn life_fnc_updateEconomy};

[_type,_itemArray] spawn life_fnc_updatePrice;