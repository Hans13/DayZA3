private["_carrier","_player","_anim","_anim2","_anim3","_anim4","_sitPosture","_display"];
 
_player = player;
_carrier = nil;
_sitPosture = "sitUnarm_L_idleLoop_inUH1Y";
_position = _this select 3;
_isOk = true;
_modelArray = [0,0,0];
_dir = 0;

    if (typeOf cursorTarget in ["Old_bike_TK_CIV_EP1","Old_bike_TK_INS_EP1"]) then
    {
        _carrier = cursorTarget;
        _modelArray = [0,-0.6,-0.94];
        _dir = 270;
    };

    if (typeOf cursorTarget in ["ATV_US_EP1","ATV_CZ_EP1"]) then
    {
        _carrier = cursorTarget;
        _modelArray = [0,-0.8,-1.3];
        _dir = 270;
    };

    if (typeOf cursorTarget in ["Tractor"]) then
    {
        _carrier = cursorTarget;
        _modelArray = [0,-1.35,0.1];
        _dir = 270;
    };
 
    if (typeOf cursorTarget in ["VolhaLimo_TK_CIV_EP1","Volha_2_TK_CIV_EP1","Volha_1_TK_CIV_EP1","car_sedan","car_hatchback"]) then
    {
        _carrier = cursorTarget;
        _modelArray = [0,-2,-1.3];
        _dir = -90;
    };
   
    if (typeOf cursorTarget in ["Lada2_TK_CIV_EP1","Lada1_TK_CIV_EP1","Skoda","Lada1","Lada2","LadaLM","SkodaRed","SkodaGreen","SkodaBlue"]) then
    {
        _carrier = cursorTarget;
        if (_position == 0) then {
            _modelArray = [-0.55,-1.5,-1.4];
            _dir = 0;
        };
        if (_position == 1) then {
            _modelArray = [0.55,-1.5,-1.4];
            _dir = 180;
        };
    };
   
    if (typeOf cursorTarget in ["datsun1_civil_3_open","datsun1_civil_1_open","hilux1_civil_3_open_EP1","hilux1_civil_1_open"]) then
    {
        _carrier = cursorTarget;
        if (_position == 0) then {
            _modelArray = [-0.7,-1.2,-1.25];
            _dir = 0;
        };
        if (_position == 1) then {
            _modelArray = [0.7,-1.2,-1.25];
            _dir = 180;
        };
        if (_position == 2) then {
            _modelArray = [0.1,-1.5,-0.7];
            _dir = 180;
            _sitPosture = "AmovPercMstpSlowWrflDnon_AmovPsitMstpSlowWrflDnon"; 
            if ((primaryWeapon player == "") and (secondaryWeapon player == "") and (handgunWeapon player == "")) then {
                _sitPosture = "AmovPercMstpSnonWnonDnon_AmovPsitMstpSnonWnonDnon_ground"; 
            };
        };
    };
    
if (isNil "_carrier") exitWith { };
 
if (_position == 0) then {
    _isOk = _carrier getVariable["leftOpen", true];
};
if (_position == 1) then {
    _isOk = _carrier getVariable["rightOpen", true];
};
if (_position == 2) then {
    _isOk = _carrier getVariable["centerOpen", true];
};
if (!_isOk) exitWith {
	2 cutText ["Someone is already sitting there!", "PLAIN DOWN"];
};
[[[_player,"AmovPercMstpSnonWnonDnon_AcrgPknlMstpSnonWnonDnon_getInLow"], { (_this select 0) switchMove (_this select 1); }], "BIS_fnc_spawn", true, false] call BIS_fnc_MP;

sleep 0.55;

[[[_player,_sitPosture,name player], { if(name player != (_this select 2) then { (_this select 0) switchMove (_this select 1); }; }], "BIS_fnc_spawn", true, false] call BIS_fnc_MP;
player switchMove _sitPosture;

_player attachTo [_carrier,_modelArray];
_player setDir _dir;
r_player_onVehicleC = true;
r_player_currentCar = _carrier;
r_player_carPosition = _position;
_carrier switchCamera "EXTERNAL"; 
 
if (_position == 0) then {
    _carrier setVariable ["leftOpen", false, true];
};
if (_position == 1) then {
    _carrier setVariable ["rightOpen", false, true];
};
if (_position == 2) then {
    _carrier setVariable ["centerOpen", false, true];
};
hintSilent parseText "<t size='1.20' font='Bitstream' color='#F20C0C'>[SYSTEM]</t><br/><t size='1' font='Bitstream'>Hit 'Backspace' to eject!</t><br/>";
player removeAction s_player_getin1;
s_player_getin1 = -1;
player removeAction s_player_getin2;
s_player_getin2 = -1;
player removeAction s_player_getin3;
s_player_getin3 = -1;
[] spawn {
    while { (r_player_onVehicleC and alive player)} do
    {
        _max = 100;
        if (speed r_player_currentCar >= 30) then {
            _measure = (1 - ((speed r_player_currentCar) * 0.005));
            if (_measure >= -1) then {
                _measure = 0.99;
            };
            _max  = 100 * _measure;
        };
        _random = floor(random _max) + 1;
        if ((_random <= 1) and (name (driver r_player_currentCar) != "Error: No Vehicle") and (typeOf r_player_currentCar in ["Lada2_TK_CIV_EP1","Lada1_TK_CIV_EP1","Skoda","Lada1","Lada2","LadaLM","SkodaRed","SkodaGreen","SkodaBlue","VolhaLimo_TK_CIV_EP1","Volha_2_TK_CIV_EP1","Volha_1_TK_CIV_EP1","car_sedan","car_hatchback"])) exitWith {
            _randomText = ["swerved and threw you off the car.",
            "hit a bump, causing you to fall off.",
            "jumped the gun, causing you to fall foward."] call BIS_fnc_selectRandom;
            hintSilent parseText format["<t size='1.20' font='Bitstream' color='#F20C0C'>[SYSTEM]</t><br/><t size='1' font='Bitstream'>%1 %2</t><br/>", name (driver r_player_currentCar),_randomText];
            [] execVM "\z\addons\dayz_code\actions\player_getout.sqf";
        };
        sleep 1;
    };
};
while { r_player_onVehicleC } do
{
    _player setPosATL (_carrier modelToWorld _modelArray);
    
    if ((r_player_OnVehicleC) and (cameraOn == _carrier) and (cameraView == "INTERNAL")) then {
        player switchCamera "INTERNAL";
    };
    if ((r_player_OnVehicleC) and (cameraOn == player) and (cameraView == "EXTERNAL")) then {
        _carrier switchCamera "EXTERNAL";
    };
    if ((r_player_OnVehicleC) and (cameraOn != player) and (cameraOn != _carrier)) then {
        _carrier switchCamera "EXTERNAL";
    };
    
    if !(alive player) exitWith {
        [] execVM "\z\addons\dayz_code\actions\player_getout.sqf";
    };
};