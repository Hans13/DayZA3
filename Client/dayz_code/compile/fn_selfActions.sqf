scriptName "Functions\misc\fn_selfActions.sqf";
/***********************************************************
	ADD ACTIONS FOR SELF
	- Function
	- [] call fnc_usec_selfActions;
************************************************************/
private["_vehicle","_inVehicle","_isWater","_magazinesPlayer","_weaponsPlayer","_unit","_injured","_inPain","_legsBroke","_armsBroke","_onLadder","_canFill","_canDo","_isPond","_isWell","_pondPos","_objectsWell","_objectsPond","_hasAntiB",
			"_hasFuelE","_hasbottleitem","_hasbottleitemE","_hasWood","_hasSPack","_hasBandage","_hasEpi","_hasMorphine","_hasHeatpack","_hasPainkillers","_hasAntibiotic","_hasClothes1","_hasClothes2","_hasClothes3","_hasClothes4",
			"_hasClothes5","_hasClothes6","_hasClothes7","_hasHatchet","_hasMRE","_hasKnife","_hasToolbox","_hasEtool","_hasTent","_hasATent","_hasSand","_hasWire","_hasTTrap","_hasBTrap","_hastinitem","_nearLightG","_nearLightB",
			"_nearLightY","_nearLightR","_nearLightF","_canPickLightG","_canPickLightY","_canPickLightB","_canPickLightR","_canpicklightF","_refuelVehicle","_vehicle_refuel_id","_refuelDistance","_refuelAmount","_currentVehicle","_countFuel","_isNearFeed","_cursorTarget","_isHarvested","_isTakeable","_isVehicle","_isVehicletype","_isMan","_ownerID","_isAnimal",
			"_isDog","_isZombie","_isPlayer","_hasClothes","_isDestructable","_isTent","_isFuel","_isAlive","_canmove","_text","_rawmeat","_hasRawMeat","_dogHandle","_lieDown","_warn","_dog","_speed","_foodItems","_hasFood",
			"_drinkItems","_hasDrink","_isCustom","_seat","_text2","_seatSide","_type"];

//A3 Med Definitions and other vars by Papzzz, Pwnoz0r and MistaD
//General Defines
_vehicle =			vehicle player;
_inVehicle = 		(_vehicle != player);
_isWater = 			(surfaceIsWater (position player)) or dayz_isSwimming;
_magazinesPlayer = 	magazines player;
_weaponsPlayer =	weapons player;
_unit = 			player;
_injured = 			player getVariable ["USEC_injured", false];
_inPain = 			player getVariable ["USEC_inPain", false];
_legsBroke = 		player getVariable ["hit_legs", 0] >= 1;
_armsBroke = 		player getVariable ["hit_hands", 0] >= 1;
_onLadder =			(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canFill = 			count (nearestObjects [position player, ["Land_pumpa","Land_water_tank"], 4]) > 0;
_canDo =			(!r_drag_sqf and !r_player_unconscious and !_onLadder and !_isWater);
_isPond = 			false;
_isWell = 			false;
_pondPos = 			[];
_objectsWell = 		[];
_objectsPond = 		[];

//Inventory Checks
_hasAntiB = 		"ItemAntibiotic" in _magazinesPlayer;
_hasFuelE = 		"ItemJerrycanEmpty" in _magazinesPlayer;
_hasbottleitem = 	"ItemWaterbottle" in _magazinesPlayer;
_hasbottleitemE = 	"ItemWaterbottleUnfilled" in _magazinesPlayer;
_hasWood = 			"PartWoodPile" in _magazinesPlayer;
_hasSPack =      	"SurvivalPack" in _magazinesPlayer;
_hasBandage = 		"ItemBandage" in _magazinesPlayer;
_hasEpi = 			"ItemEpinephrine" in _magazinesPlayer;
_hasMorphine = 		"ItemMorphine" in _magazinesPlayer;
_hasHeatpack = 		"ItemHeatpack" in _magazinesPlayer;
_hasPainkillers = 	"ItemPainkiller" in _magazinesPlayer;
_hasAntibiotic =	"ItemAntibiotic" in _magazinesPlayer;
_hasClothes1 = 		"Skin_Sniper1_DZ" in _magazinesPlayer; //Ghillie
_hasClothes2 = 		"Skin_Camo1_DZ" in _magazinesPlayer; //Camo
_hasClothes3 = 		"Skin_Survivor2_DZ" in _magazinesPlayer; //Survivor
_hasClothes4 = 		"Skin_SurvivorR_DZ" in _magazinesPlayer; //Survivor
_hasClothes5 = 		"Skin_SurvivorB_DZ" in _magazinesPlayer; //Survivor
_hasClothes6 = 		"Skin_Ranger_DZ" in _magazinesPlayer; //Ranger
_hasClothes7 = 		"Skin_Sniper2_DZ" in _magazinesPlayer; //Ghillie
_hasHatchet =       "MeleeHatchet" in _weaponsPlayer;
_hasMRE =			"FoodMRE" in _magazinesPlayer;
_hasKnife = 		"ItemKnife" in _magazinesPlayer;
_hasToolbox =	 	"ItemToolbox" in _magazinesPlayer;
_hasEtool = 		"ItemEtool" in _magazinesPlayer;
_hasTent = 			"ItemTent" in _magazinesPlayer;
_hasATent = 		"ItemATent" in _magazinesPlayer;
_hasSand = 	   	    "ItemSandbag" in _magazinesPlayer;
_hasWire =  		"ItemWire" in _magazinesPlayer;
_hasTTrap = 		"ItemTankTrap" in _magazinesPlayer;
_hasBTrap = 		"TrapBear" in _magazinesPlayer;
_hastinitem =		false;
{
    if (_x in _magazinesPlayer) then {
        _hastinitem = true;
    };

} forEach boil_tin_cans;

//Light pick-up
_nearLightG = 		nearestObject [player,"Chemlight_green"];
_nearLightB = 		nearestObject [player,"Chemlight_blue"];
_nearLightY =   	nearestObject [player,"Chemlight_yellow"];
_nearLightR =   	nearestObject [player,"Chemlight_red"];
_nearLightF =   	nearestObject [player,"RoadFlare"];
_canPickLightG = 	false;
_canPickLightY = 	false;
_canPickLightB = 	false;
_canPickLightR = 	false;
_canpicklightF = 	false;

if (!isNull _nearLightG) then {
  if (_nearLightG distance player < 3) then {
    _canPickLightG = isNull (_nearLightG getVariable ["owner",objNull]);
  };
};
if (!isNull _nearLightY) then {
  if (_nearLightY distance player < 3) then {
    _canPickLightY = isNull (_nearLightY getVariable ["owner",objNull]);
  };
};
if (!isNull _nearLightB) then {
  if (_nearLightB distance player < 3) then {
    _canPickLightB = isNull (_nearLightB getVariable ["owner",objNull]);
  };
};
if (!isNull _nearLightR) then {
  if (_nearLightR distance player < 3) then {
    _canPickLightR = isNull (_nearLightR getVariable ["owner",objNull]);
  };
};
if (!isNull _nearLightF) then {
  if (_nearLightF distance player < 3) then {
    _canPickLightF = isNull (_nearLightF getVariable ["owner",objNull]);
  };
};

//FOOD
//_hasFood = 		["FoodCanBakedBeans", "FoodCanSardines", "FoodCanFrankBeans", "FoodCanPasta", "FoodSteakCooked"];
//_hasFood2 = 		"FoodCanSardines" in _magazinesPlayer;
//_hasFood3 = 		"FoodCanFrankBeans" in _magazinesPlayer;
//_hasFood4 = 		"FoodCanPasta" in _magazinesPlayer;
//_hasFood5 = 		"FoodSteakCooked" in _magazinesPlayer;
//DRINK
//_hasDrink =		["ItemSodaCoke", "ItemSodaPepsi", "ItemSodaMdew"];
//_hasDrink2 =		"ItemSodaPepsi" in _magazinesPlayer;
//_hasDrink3 =		"ItemSodaMdew" in _magazinesPlayer;


if (!_canFill) then {
	_objectsWell = 	nearestObjects [getPosATL player, [], 4];
	{
		//Check for Well
		_isWell = ["_well",str(_x),false] call fnc_inString;
		if (_isWell) then {_canFill = true};
	} forEach _objectsWell;
};

if (!_canFill) then {
	_objectsPond = 		nearestObjects [getPosATL player, [], 50];
	{
		//Check for pond
		_isPond = ["pond",str(_x),false] call fnc_inString;
		if (_isPond) then {
			_pondPos = (_x worldToModel getPosATL player) select 2;
			if (_pondPos < 0) then {
				_canFill = true;
			};
		};
	} forEach _objectsPond;
};
/*
//Auto-refuel
_refuelVehicle = objNull;
_refuelDistance = 15;
_refuelAmount= 0.01;
_currentVehicle = vehicle player;
_countFuel = (count ((position _currentVehicle) nearObjects ["Land_Ind_TankSmall", _refuelDistance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_fuel_tank_big", _refuelDistance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_fuel_tank_stairs", _refuelDistance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_wagon_tanker", _refuelDistance]));
_isNearFeed = _countFuel > 0;
*/
//Off topic functions
/*
	if (player == player) then {
			s_getAlive = player addAction["Force Gear Save", "\z\addons\dayz_code\system\forceGearSave.sqf"];
	};
*/
//End off topic functions

//*******************************//
//START ACTIONS WITH CURSORTARGET//
//*******************************//
if (!isNull cursorTarget and !_inVehicle and (player distance cursorTarget < 4)) then {	
	_cursorTarget =		cursorTarget;
	_isHarvested = 		true;
	_isTakeable = 		false;
    _isHarvested =		_cursorTarget getVariable["meatHarvested",false];
	_isTakeable = 		_cursorTarget getVariable["clothesTaken",false];
	_isVehicle = 		_cursorTarget isKindOf "AllVehicles";
	_isVehicletype = 	typeOf _cursorTarget in ["ATV_US_EP1","ATV_CZ_EP1","Old_bike_TK_CIV_EP1","Old_bike_TK_INS_EP1","M1030","TT650_Cib","TT650_Ins","TT650_Gue","TT650_TK_CIV_EP1","TT650_TK_EP1","M1030_US_DES_EP1","Old_moto_TK_Civ_EP1"];
	_isMan = 			_cursorTarget isKindOf "Man";
	_ownerID = 			_cursorTarget getVariable ["characterID","0"];
	_isAnimal = 		_cursorTarget isKindOf "Animal";
	_isDog =  			(_cursorTarget isKindOf "DZ_Pastor" || _cursorTarget isKindOf "DZ_Fin");
	_isZombie = 		_cursorTarget isKindOf "zZombie_base";
	_isPlayer = 		typeOf _cursorTarget in AllPlayers_A3;
	_hasClothes = 		typeOf _cursorTarget in ["Camo1_DZ","Sniper1_DZ","Sniper2_DZ","Bandit1_DZ","Survivor2_DZ","Survivor3_DZ","Survivor4_DZ","Bandit2_DZ","Bandit3_DZ","Survivor5_DZ","Survivor_R","Survivor_B","Ranger_DZ"];
	_isDestructable = 	_cursorTarget isKindOf "BuiltItems";
	_isTent = 			_cursorTarget isKindOf "TentStorage";
	_isFuel = 			false;
	_isAlive = 			alive _cursorTarget;
	_canmove = 			canmove _cursorTarget;
	_text = 			getText (configFile >> "CfgVehicles" >> typeOf _cursorTarget >> "displayName");	
	if (isNil "_isHarvested") then { _isHarvested = true; };
	if (isNil "_isTakeable") then { _isTakeable = false; };	
	_rawmeat = 			meatraw;
	_hasRawMeat = 		false;
		{
			if (_x in _magazinesPlayer) then {
				_hasRawMeat = true;
			};
		} forEach _rawmeat; 
	
	//Create locations for jerry-fill
	if (_hasFuelE) then {
		_isFuel = (_cursorTarget isKindOf "Land_Ind_TankSmall") or (_cursorTarget isKindOf "Land_fuel_tank_big") or (_cursorTarget isKindOf "Land_fuel_tank_stairs") or (_cursorTarget isKindOf "Land_wagon_tanker");
	};
	
	//diag_log ("OWNERID = " + _ownerID + " CHARID = " + dayz_characterID + " " + str(_ownerID == dayz_characterID));
	
	//Allow player to delete objects
	if(_isDestructable and _hasToolbox and _canDo) then {
		if (s_player_deleteBuild < 0) then {
			s_player_deleteBuild = player addAction [format[localize "str_actions_delete",_text], "\z\addons\dayz_code\actions\remove.sqf",_cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteBuild;
		s_player_deleteBuild = -1;
	};
	
	/*
	//Allow player to force save
	if((_isVehicle or _isTent) and _canDo and !_isMan) then {
		if (s_player_forceSave < 0) then {
			s_player_forceSave = player addAction [format[localize "str_actions_save",_text], "\z\addons\dayz_code\actions\forcesave.sqf",_cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_forceSave;
		s_player_forceSave = -1;
	};
	*/
	//Allow player to flip vehicle
	if ((_isVehicletype) and !_canmove and _isAlive and (player distance _cursorTarget >= 2) and (count (crew _cursorTarget))== 0 and ((vectorUp _cursorTarget) select 2) < 0.5) then {
		if (s_player_flipveh  < 0) then {
			s_player_flipveh = player addAction [format[localize "str_actions_flipveh",_text], "\z\addons\dayz_code\actions\player_flipvehicle.sqf",_cursorTarget, 1, true, true, "", ""];		
		};	
	} else {
		player removeAction s_player_flipveh;
		s_player_flipveh = -1;
	};
    
	
	//Allow player to fill jerrycan
	if(_hasFuelE and _isFuel and _canDo) then {
		if (s_player_fillfuel < 0) then {
			s_player_fillfuel = player addAction [localize "str_actions_self_10", "\z\addons\dayz_code\actions\jerry_fill.sqf",[], 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_fillfuel;
		s_player_fillfuel = -1;
	};
	
	//Allow player to gut animals
	if (!isNull _cursorTarget and !alive _cursorTarget and (_isAnimal or _isZombie or _isPlayer) and _hasKnife and !_isHarvested and _canDo) then {
		if (s_player_butcher < 0) then {
			s_player_butcher = player addAction ["Gut Flesh", "\z\addons\dayz_code\actions\gather_meat.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_butcher;
		s_player_butcher = -1;
	};
	
    //Allow player to take clothes
	if (!isNull _cursorTarget and !alive _cursorTarget and _isPlayer and _hasClothes and !_isTakeable and _canDo) then {
		if (s_player_stealclothes < 0) then {
			s_player_stealclothes = player addAction ["Take Clothes", "\z\addons\dayz_code\actions\gather_clothes.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_stealclothes;
		s_player_stealclothes = -1;
	};
	
	//Fireplace Actions check
	//Cook meat
	if (inflamed _cursorTarget and _hasRawMeat and _canDo) then {
		if (s_player_cook < 0) then {
			s_player_cook = player addAction [localize "str_actions_self_05", "\z\addons\dayz_code\actions\cook.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_cook;
		s_player_cook = -1;
	};
	//Boil water
	if (inflamed _cursorTarget and (_hasbottleitem and _hastinitem) and _canDo) then {
		if (s_player_boil < 0) then {
			s_player_boil = player addAction [localize "str_actions_boilwater", "\z\addons\dayz_code\actions\boil.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_boil;
		s_player_boil = -1;
	};
	
	//Allow player to pack fireplace
	if(_cursorTarget == dayz_hasFire and _canDo) then {
		if ((s_player_fireout < 0) and !(inflamed _cursorTarget) and (player distance _cursorTarget < 3)) then {
			s_player_fireout = player addAction [localize "str_actions_self_06", "\z\addons\dayz_code\actions\fire_pack.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_fireout;
		s_player_fireout = -1;
	};
	
	//Allow player to pack tent
	if(!isNull _cursorTarget and _cursorTarget isKindOf "TentStorage" and _canDo and _ownerID == dayz_characterID) then {
		if ((s_player_packtent < 0) and (player distance _cursorTarget < 3)) then {
			s_player_packtent = player addAction [localize "str_actions_self_07", "\z\addons\dayz_code\actions\tent_pack.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_packtent;
		s_player_packtent = -1;
		};
	
	//Allow player to pack ACampStorage
	if(_cursorTarget isKindOf "ACampStorage" and _canDo and _ownerID == dayz_characterID) then {
		if ((s_player_packatent < 0) and (player distance _cursorTarget < 3)) then {
			s_player_packatent = player addAction [localize "str_actions_self_07", "\z\addons\dayz_code\actions\atent_pack.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_packatent;
		s_player_packatent = -1;
		};
	
	//Allow player to sleep in tent
	if(_cursorTarget isKindOf "TentStorage" and _canDo and _ownerID == dayz_characterID) then {
		if ((s_player_sleep < 0) and (player distance _cursorTarget < 3)) then {
			s_player_sleep = player addAction [localize "str_actions_self_sleep", "\z\addons\dayz_code\actions\player_sleep.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_sleep;
		s_player_sleep = -1;
	};
	
	//Repairing Vehicles
	if ((dayz_myCursorTarget != _cursorTarget) and _isVehicle and !_isMan and _hasToolbox and (damage _cursorTarget < 1)) then {
		if (s_player_repair_crtl < 0) then {
			dayz_myCursorTarget = _cursorTarget;
			_menu = dayz_myCursorTarget addAction ["Repair Vehicle", "\z\addons\dayz_code\actions\repair_vehicle.sqf",_cursorTarget, 0, true, false, "",""];
			_menu1 = dayz_myCursorTarget addAction ["Salvage Vehicle", "\z\addons\dayz_code\actions\salvage_vehicle.sqf",_cursorTarget, 0, true, false, "",""];
			s_player_repairActions set [count s_player_repairActions,_menu];
			s_player_repairActions set [count s_player_repairActions,_menu1];
			s_player_repair_crtl = 1;
		} else {
			{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
			s_player_repair_crtl = -1;
		};
	};
	
	/* OLD REPAIR FUNCTION ////////////////////////////////////////////////////////////////////////////////////////////////////
	//Repairing Vehicles
	if ((dayz_myCursorTarget != _cursorTarget) and _isVehicle and !_isMan and _hasToolbox and (damage _cursorTarget < 1)) then {
		_vehicle = _cursorTarget;
		{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
		dayz_myCursorTarget = _vehicle;

		_allFixed = true;
		_hitpoints = _vehicle call vehicle_getHitpoints;
		
		{
			_damage = [_vehicle,_x] call object_getHit;
			_part = "PartGeneric";
			
			//change "HitPart" to " - Part" rather than complicated string replace
			_cmpt = toArray (_x);
			_cmpt set [0,20];
			_cmpt set [1,toArray ("-") select 0];
			_cmpt set [2,20];
			_cmpt = toString _cmpt;
				
			if(["Engine",_x,false] call fnc_inString) then {
				_part = "PartEngine";
			};
					
			if(["HRotor",_x,false] call fnc_inString) then {
				_part = "PartVRotor"; //yes you need PartVRotor to fix HRotor LOL
			};

			if(["Fuel",_x,false] call fnc_inString) then {
				_part = "PartFueltank";
			};
			
			if(["Wheel",_x,false] call fnc_inString) then {
				_part = "PartWheel";

			};
					
			if(["Glass",_x,false] call fnc_inString) then {
				_part = "PartGlass";
			};

			// get every damaged part no matter how tiny damage is!
			if (_damage > 0) then {
				
				_allFixed = false;
				_color = "color='#ffff00'"; //yellow
				if (_damage >= 0.5) then {_color = "color='#ff8800'";}; //orange
				if (_damage >= 0.9) then {_color = "color='#ff0000'";}; //red

				_string = format["<t %2>Repair%1</t>",_cmpt,_color]; //Repair - Part
				_handle = dayz_myCursorTarget addAction [_string, "\z\addons\dayz_code\actions\repair.sqf",[_vehicle,_part,_x], 0, false, true, "",""];
				s_player_repairActions set [count s_player_repairActions,_handle];

			};
					
		} forEach _hitpoints;
		if (_allFixed) then {
			_vehicle setDamage 0;
		};
	};
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
	
	//Allow player to study body
	if (_isMan and !_isAlive and !_isZombie) then {
		if (s_player_studybody < 0) then {
			s_player_studybody = player addAction [localize "str_action_studybody", "\z\addons\dayz_code\actions\study_body.sqf",_cursorTarget, 0, false, true, "",""];
		};	

	} else {
		player removeAction s_player_studybody;
		s_player_studybody = -1;
	};

	/*
	if (_isDog and _isAlive and (_hasRawMeat) and _canDo and _ownerID == "0" and player getVariable ["dogID", 0] == 0) then {
		if (s_player_tamedog < 0) then {
			s_player_tamedog = player addAction [localize "str_actions_tamedog", "\z\addons\dayz_code\actions\tame_dog.sqf", _cursorTarget, 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_tamedog;
		s_player_tamedog = -1;
	};
	*/
	
	//Dog Actions
	if (_isDog and _ownerID == dayz_characterID and _isAlive and _canDo) then {
		_dogHandle = player getVariable ["dogID", 0];
		if (s_player_feeddog < 0 and _hasRawMeat) then {
			s_player_feeddog = player addAction [localize "str_actions_feeddog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,0], 0, false, true,"",""];
		};
		if (s_player_waterdog < 0 and "ItemWaterbottle" in _magazinesPlayer) then {
			s_player_waterdog = player addAction [localize "str_actions_waterdog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,1], 0, false, true,"",""];
		};
		if (s_player_staydog < 0) then {
			_lieDown = _dogHandle getFSMVariable "_actionLieDown";
			if (_lieDown) then { _text = "str_actions_liedog"; } else { _text = "str_actions_sitdog"; };
			s_player_staydog = player addAction [localize _text,"\z\addons\dayz_code\actions\dog\stay.sqf", _dogHandle, 5, false, true,"",""];
		};
		if (s_player_trackdog < 0) then {
			s_player_trackdog = player addAction [localize "str_actions_trackdog","\z\addons\dayz_code\actions\dog\track.sqf", _dogHandle, 4, false, true,"",""];
		};
		if (s_player_barkdog < 0) then {
			s_player_barkdog = player addAction [localize "str_actions_barkdog","\z\addons\dayz_code\actions\dog\speak.sqf", _cursorTarget, 3, false, true,"",""];
		};
		if (s_player_warndog < 0) then {
			_warn = _dogHandle getFSMVariable "_watchDog";
			if (_warn) then { _text = "Quiet"; _warn = false; } else { _text = "Alert"; _warn = true; };
			s_player_warndog = player addAction [format[localize "str_actions_warndog",_text],"\z\addons\dayz_code\actions\dog\warn.sqf",[_dogHandle, _warn], 2, false, true,"",""];		
		};
		if (s_player_followdog < 0) then {
			s_player_followdog = player addAction [localize "str_actions_followdog","\z\addons\dayz_code\actions\dog\follow.sqf",[_dogHandle,true], 6, false, true,"",""];
		};
	} else {
		player removeAction s_player_feeddog;
		s_player_feeddog = -1;
		player removeAction s_player_waterdog;
		s_player_waterdog = -1;
		player removeAction s_player_staydog;
		s_player_staydog = -1;
		player removeAction s_player_trackdog;
		s_player_trackdog = -1;
		player removeAction s_player_barkdog;
		s_player_barkdog = -1;
		player removeAction s_player_warndog;
		s_player_warndog = -1;
		player removeAction s_player_followdog;
		s_player_followdog = -1;
	};
} else {
	//Engineering
	{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
	dayz_myCursorTarget = objNull;
	//Others
	player removeAction s_player_forceSave;
	s_player_forceSave = -1;
	player removeAction s_player_flipveh;
	s_player_flipveh = -1;
	player removeAction s_player_sleep;
	s_player_sleep = -1;
	player removeAction s_player_deleteBuild;
	s_player_deleteBuild = -1;
	player removeAction s_player_butcher;
	s_player_butcher = -1;
	player removeAction s_player_stealclothes;
	s_player_stealclothes = -1;
	player removeAction s_player_cook;
	s_player_cook = -1;
	player removeAction s_player_boil;
	s_player_boil = -1;
	player removeAction s_player_fireout;
	s_player_fireout = -1;
	player removeAction s_player_packtent;
	s_player_packtent = -1;
	player removeAction s_player_fillfuel;
	s_player_fillfuel = -1;
	player removeAction s_player_studybody;
	s_player_studybody = -1;
	/*
	player removeAction s_player_tamedog;
	s_player_tamedog = -1;
    */
	player removeAction s_player_feeddog;
	s_player_feeddog = -1;
	player removeAction s_player_waterdog;
	s_player_waterdog = -1;
	player removeAction s_player_staydog;
	s_player_staydog = -1;
	player removeAction s_player_trackdog;
	s_player_trackdog = -1;
	player removeAction s_player_barkdog;
	s_player_barkdog = -1;
	player removeAction s_player_warndog;
	s_player_warndog = -1;
	player removeAction s_player_followdog;
	s_player_followdog = -1;
};
//*****************************//
//END ACTIONS WITH CURSORTARGET//
//*****************************//
//***********************************//
//START ACTIONS WITH NO CURSOR TARGET//
//***********************************//

//Dog actions on player self
_dogHandle = player getVariable ["dogID", 0];
if (_dogHandle > 0) then {
	_dog = _dogHandle getFSMVariable "_dog";
	_ownerID = "0";
	if (!isNull _cursorTarget) then { _ownerID = _cursorTarget getVariable ["characterID","0"]; };
	if (_canDo and !_inVehicle and alive _dog and _ownerID != dayz_characterID) then {
		if (s_player_movedog < 0) then {
			s_player_movedog = player addAction [localize "str_actions_movedog", "\z\addons\dayz_code\actions\dog\move.sqf", player getVariable ["dogID", 0], 1, false, true, "", ""];
		};
		if (s_player_speeddog < 0) then {
			_text = "Walk";
			_speed = 0;
			if (_dog getVariable ["currentSpeed",1] == 0) then { _speed = 1; _text = "Run"; };
			s_player_speeddog = player addAction [format[localize "str_actions_speeddog", _text], "\z\addons\dayz_code\actions\dog\speed.sqf",[player getVariable ["dogID", 0],_speed], 0, false, true, "", ""];
		};
		if (s_player_calldog < 0) then {
			s_player_calldog = player addAction [localize "str_actions_calldog", "\z\addons\dayz_code\actions\dog\follow.sqf", [player getVariable ["dogID", 0], true], 2, false, true, "", ""];
		};
	};
} else {
	player removeAction s_player_movedog;		
	s_player_movedog =		-1;
	player removeAction s_player_speeddog;
	s_player_speeddog =		-1;
	player removeAction s_player_calldog;
	s_player_calldog = 		-1;
};

//Grab GChem
if (_canPickLightG and !dayz_hasLight) then {
  if (s_player_grabflare < 0) then {
    _text = "Green Chemlight";
    s_player_grabflare = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightG, 1, false, true, "", ""];
    s_player_removeflare = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightG, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare;
  player removeAction s_player_removeflare;
  s_player_grabflare = -1;
  s_player_removeflare = -1;
};

//Grab BChem
if (_canPickLightB and !dayz_hasLight) then {
  if (s_player_grabflare2 < 0) then {
    _text = "Blue Chemlight";
    s_player_grabflare2 = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightB, 1, false, true, "", ""];
    s_player_removeflare2 = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightB, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare2;
  player removeAction s_player_removeflare2;
  s_player_grabflare2 = -1;
  s_player_removeflare2 = -1;
};

//Grab YChem
if (_canPickLightY and !dayz_hasLight) then {
  if (s_player_grabflare3 < 0) then {
    _text = "Yellow Chemlight";
    s_player_grabflare3 = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightY, 1, false, true, "", ""];
    s_player_removeflare3 = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightY, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare3;
  player removeAction s_player_removeflare3;
  s_player_grabflare3 = -1;
  s_player_removeflare3 = -1;
};

//Grab RChem
if (_canPickLightR and !dayz_hasLight) then {
  if (s_player_grabflare4 < 0) then {
    _text = "Red Chemlight";
    s_player_grabflare4 = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightR, 1, false, true, "", ""];
    s_player_removeflare4 = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightR, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare4;
  player removeAction s_player_removeflare4;
  s_player_grabflare4 = -1;
  s_player_removeflare4 = -1;
};

//Grab RoadFlare
if (_canPickLightF and !dayz_hasLight) then {
  if (s_player_grabflare5 < 0) then {
    _text = "Road Flare";
    s_player_grabflare5 = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightF, 1, false, true, "", ""];
    s_player_removeflare5 = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightF, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare5;
  player removeAction s_player_removeflare5;
  s_player_grabflare5 = -1;
  s_player_removeflare5 = -1;
};

//Allow player to use the Survival Pack
if (_vehicle == player and _hasSPack and ((_legsBroke or _armsBroke) or (r_player_infected) or (_inPain) or (_injured) or (r_player_blood < 12000))) then {
    if (s_player_survivalpackA3 < 0) then {
    s_player_survivalpackA3 = player addAction [format["<t color='#FF0000'>Use Survival Pack%1</t>"], "\z\addons\dayz_code\medical\spack.sqf",[_unit], 1, true, true, "", "'SurvivalPack' in _magazinesPlayer"];
    };
} else {
    player removeAction s_player_survivalpackA3;
    s_player_survivalpackA3 = -1;
};

//Allow player to use heatpacks
if (_vehicle == player and (dayz_temperatur < 35.5) and _hasHeatpack) then {
	if (s_player_heatpackA3 < 0) then {
	s_player_heatpackA3 = player addAction [format["<t color='#FF0000'>Use Heatpack%1</t>"], "\z\addons\dayz_code\medical\heatpack.sqf",[_unit], 1, true, true, "", "'ItemHeatpack' in _magazinesPlayer"];
	};
} else {
	player removeAction s_player_heatpackA3;
	s_player_heatpackA3 = -1;
};
    
//Allow player to use Morphine
if (_vehicle == player and (_legsBroke or _armsBroke) and _hasMorphine) then {
	if (s_player_morphineA3 < 0) then {
	s_player_morphineA3 = player addAction [format["<t color='#FF0000'>Use Morphine%1</t>"], "\z\addons\dayz_code\medical\morphine.sqf",[_unit], 1, true, true, "", "'ItemMorphine' in _magazinesPlayer"];
	};
} else {
	player removeAction s_player_morphineA3;
	s_player_morphineA3 = -1;
};

//Allow player to use Antibiotics
if (_vehicle == player and _hasAntibiotic and r_player_infected) then {
	if (s_player_antibioticA3 < 0) then {
	s_player_antibioticA3 = player addAction [format["<t color='#FF0000'>Use Antibiotics%1</t>"], "\z\addons\dayz_code\medical\antibiotics.sqf",[_unit], 1, true, true, "", "'ItemAntibiotic' in _magazinesPlayer"];
	};
} else {
	player removeAction s_player_antibioticA3;
	s_player_antiboioticA3 = -1;
};

//Allow player to use Painkillers
if (_vehicle == player and _inPain and _hasPainkillers) then {
	if (s_player_painkillerA3 < 0) then {
	s_player_painkillerA3 = player addAction [format["<t color='#FF0000'>Use Painkillers%1</t>"], "\z\addons\dayz_code\medical\painkiller.sqf",[_unit], 1, true, true, "", "'ItemPainkiller' in _magazinesPlayer"];
	};
} else {
	player removeAction s_player_painkillerA3;
	s_player_painkillerA3 = -1;
};

//Allow player to bandage
if (_vehicle == player and _injured and _hasBandage) then {
	if (s_player_bandageA3 < 0) then {
	s_player_bandageA3 = player addAction [format["<t color='#FF0000'>Use Bandage%1</t>"], "\z\addons\dayz_code\medical\bandageSelf.sqf",[_unit], 1, true, true, "", "'ItemBandage' in _magazinesPlayer"];
	};
} else {
	player removeAction s_player_bandageA3;
	s_player_bandageA3 = -1;
};

//Allow player to use epinephrine
if(_vehicle == player and _hasEpi and (!r_player_adren)) then {
	if(s_player_adren < 0) then {
		s_player_adren = player addAction [format["<t color='#FF0000'>Inject Epinephrine</t>"], "z\addons\dayz_code\medical\adren.sqf",[_unit], 1, true, true, "", "'ItemEpinephrine' in _magazinesPlayer"];
	};
} else	{
	player removeAction s_player_adren;
	s_player_adren = -1;
};

//Allow player to chop trees
if (_vehicle == player and (["forest",dayz_surfaceType] call fnc_inString) and _hasHatchet) then {
	if (s_player_chopA3 < 0) then {
	s_player_chopA3 = player addAction [format["<t color='#FF0000'>Chop Wood%1</t>"], "\z\addons\dayz_code\actions\player_chopWood.sqf",[_unit], 1, true, true, "", ""];
	};
} else {
	player removeAction s_player_chopA3;
	s_player_chopA3 = -1;
};

//Allow player to setup a camp fire
if (_vehicle == player and _hasWood) then {
	if (s_player_makefireA3 < 0) then {
	s_player_makefireA3 = player addAction [format["<t color='#FF0000'>Place Campfire%1</t>"], "\z\addons\dayz_code\actions\player_makefire.sqf",[_unit], 1, true, true, "", ""];
	};
} else {
	player removeAction s_player_makefireA3;
	s_player_makefireA3 = -1;
};

//Check for food in inventory
_foodItems = no_output_food + food_with_output + meatcooked;
_hasFood = false;
{
	if (_x in _magazinesPlayer) then {
	_hasFood = true;
	};
} forEach _foodItems; 
	
//Allow player to eat
if(_vehicle == player and _hasFood) then {
	if ((r_player_blood < 10000) and (dayz_hunger3 < 0)) then {	
		player removeAction dayz_hunger2;
		dayz_hunger2 = -1;
		dayz_hunger3 = player addAction [format["<t color='#FF0000'>Eat%1</t>"], "\z\addons\dayz_code\actions\player_eat.sqf",[], 1, false, true, "", "player == player"];		
	};
	
	if ((r_player_blood >= 10000) and (dayz_hunger2 < 0)) then {
		player removeAction dayz_hunger3;
		dayz_hunger3 = -1;
		if(dayz_hunger >= 270) then {
			dayz_hunger2 = player addAction [format["<t color='#FF0000'>Eat%1</t>"], "\z\addons\dayz_code\actions\player_eat.sqf",[], 1, false, true, "", "player == player"];
		};
	};
} else	{
		player removeAction dayz_hunger2;
		dayz_hunger2 = -1;
		player removeAction dayz_hunger3;
		dayz_hunger3 = -1;
	};

//Check for drink in inventory
_drinkItems = no_output_drink + drink_with_output;
_hasDrink = false;
{
	if (_x in _magazinesPlayer) then {
	_hasDrink = true;
	};
} forEach _drinkItems; 

//Allow player to drink
if(_vehicle == player and _hasDrink) then {
    	if((dayz_thirst >= 180) and (dayz_thirst2 < 0)) then {
        	dayz_thirst2 = player addAction [format["<t color='#FF0000'>Drink%1</t>"], "\z\addons\dayz_code\actions\player_drink2.sqf",[], 1, false, true, "", "player == player"];
    	};
} else {
    	player removeAction dayz_thirst2;
    	dayz_thirst2 = -1;
};

//Allow player to fill water bottles
if(_vehicle == player and _canFill and _hasbottleitemE) then {
    	if((s_player_fillwater2 < 0)) then {
        	s_player_fillwater2 = player addAction [format["<t color='#FF0000'>Fill Bottle%1</t>"], "\z\addons\dayz_code\actions\water_fill.sqf",[], 1, false, true, "", "player == player"];
    	};
} else {
    	player removeAction s_player_fillwater2;
    	s_player_fillwater2 = -1;
};

//Allow consuming of an MRE
if(_vehicle == player and _hasMRE) then {
	if ((r_player_blood < 10000) and (dayz_mre2 < 0)) then {
		
		player removeAction dayz_mre;
		dayz_mre = -1;
		dayz_mre2 = player addAction [format["<t color='#FF0000'>Use MRE%1</t>"], "\z\addons\dayz_code\actions\player_mre.sqf",[], 1, false, true, "", "player == player"];
		
	};
    if ((r_player_blood >= 10000) and (dayz_mre < 0)) then {
		player removeAction dayz_mre2;
		dayz_mre2 = -1;
		if((dayz_hunger >= 270) or (dayz_thirst >= 180)) then {
			dayz_mre = player addAction [format["<t color='#FF0000'>Use MRE%1</t>"], "\z\addons\dayz_code\actions\player_mre.sqf",[], 1, false, true, "", "player == player"];
		};
	};
} else {
    	player removeAction dayz_mre;
    	dayz_mre = -1;
    	player removeAction dayz_mre2;
    	dayz_mre2 = -1;
};
	
//Allow placing of tents
if(_vehicle == player and _hasTent and _canDo and !r_isBuilding) then {
	if(s_doTent < 0) then {
		s_doTent = player addAction [format["<t color='#FF0000'>Pitch Tent%1</t>"], "z\addons\dayz_code\actions\tent_pitch.sqf"];
	};
} else	{
	player removeAction s_doTent;
	s_doTent = -1;
};
	
//Allow placing of tents
if(_vehicle == player and _hasATent and _canDo and !r_isBuilding) then {
	if(s_doATent < 0) then {
	s_doATent = player addAction [format["<t color='#FF0000'>Pitch Tent (Large)%1</t>"], "z\addons\dayz_code\actions\atent_pitch.sqf"];
	};
} else	{
	player removeAction s_doATent;
	s_doATent = -1;
};
	
//Allow placing of Sandbags
if(_vehicle == player and _hasSand and _canDo and !r_isBuilding and _hasEtool) then {
	if(s_doSand < 0) then {
		s_doSand = player addAction [format["<t color='#FF0000'>Stack Sandbags%1</t>"], "z\addons\dayz_code\actions\build.sqf", "ItemSandbag"];
	};
} else	{
	player removeAction s_doSand;
	s_doSand = -1;
};

//Allow placing of Wire    
if(_vehicle == player and _hasWire and _canDo and !r_isBuilding and _hasToolbox and _hasEtool) then {
	if(s_doWire < 0) then {
		s_doWire = player addAction [format["<t color='#FF0000'>Build Wire Fence%1</t>"], "z\addons\dayz_code\actions\build.sqf", "ItemWire"];
	};
} else	{
	player removeAction s_doWire;
	s_doWire = -1;
};
    
//Allow placing of TTraps
if(_vehicle == player and _hasTTrap and _canDo and !r_isBuilding and _hasToolbox) then {
	if(s_doTTrap < 0) then {
		s_doTTrap = player addAction [format["<t color='#FF0000'>Set Tank Trap%1</t>"], "z\addons\dayz_code\actions\build.sqf", "ItemTankTrap"];
	};
} else	{
	player removeAction s_doTTrap;
	s_doTTrap = -1;
};
 
//Allow placing of bear traps 
if(_vehicle == player and _hasBTrap and _canDo and !r_isBuilding) then {
	if(s_doBTrap < 0) then {
		s_doBTrap = player addAction [format["<t color='#FF0000'>Set Bear Trap%1</t>"], "z\addons\dayz_code\actions\build.sqf", "TrapBear"];
	};
} else	{
	player removeAction s_doBTrap;
	s_doBTrap = -1;
};
		
//Allow changing of clothes
if(_vehicle == player and (_hasClothes1 or _hasClothes2 or _hasClothes3 or _hasClothes4 or _hasClothes5 or _hasClothes6 or _hasClothes7) and _canDo) then {
	if((s_doClothes1 < 0) and (_hasClothes1)) then {
		s_doClothes1 = player addAction [format["<t color='#FF0000'>Wear Ghillie Suit</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Sniper1_DZ"]];
	};
	if((s_doClothes2 < 0) and (_hasClothes2)) then {
		s_doClothes2 = player addAction [format["<t color='#FF0000'>Wear Camo Clothing</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Camo1_DZ"]];
	};
	if((s_doClothes3 < 0) and (_hasClothes3)) then {
		s_doClothes3 = player addAction [format["<t color='#FF0000'>Wear Civilian Clothing</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Survivor2_DZ"]];
	};
	if((s_doClothes4 < 0) and (_hasClothes4)) then {
		s_doClothes4 = player addAction [format["<t color='#FF0000'>Wear Veteran Clothing (Red)</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_SurvivorR_DZ"]];
	};
	if((s_doClothes5 < 0) and (_hasClothes5)) then {
		s_doClothes5 = player addAction [format["<t color='#FF0000'>Wear Veteran Clothing (Blue)</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_SurvivorB_DZ"]];
	};
	if((s_doClothes6 < 0) and (_hasClothes6)) then {
		s_doClothes6 = player addAction [format["<t color='#FF0000'>Wear Ranger Outfit</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Ranger_DZ"]];
	};
	if((s_doClothes7 < 0) and (_hasClothes7)) then {
		s_doClothes7 = player addAction [format["<t color='#FF0000'>Wear Desert Ghillie Suit</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Sniper2_DZ"]];
	};
} else	{
	player removeAction s_doClothes1;
	s_doClothes1 = -1;
	player removeAction s_doClothes2;
	s_doClothes2 = -1;
	player removeAction s_doClothes3;
	s_doClothes3 = -1;
	player removeAction s_doClothes4;
	s_doClothes4 = -1;
	player removeAction s_doClothes5;
	s_doClothes5 = -1;
	player removeAction s_doClothes6;
	s_doClothes6 = -1;
	player removeAction s_doClothes7;
	s_doClothes7 = -1;
};
    
//Custom Get in Back script
if (!isNull _cursorTarget and (player distance _cursorTarget < 4) and !_inVehicle) then {
    _isAlive = alive _cursorTarget;
    _isCustom = typeOf _cursorTarget in ["Old_bike_TK_CIV_EP1","Old_bike_TK_INS_EP1","ATV_US_EP1","ATV_CZ_EP1","Tractor","VolhaLimo_TK_CIV_EP1","Volha_2_TK_CIV_EP1","Volha_1_TK_CIV_EP1","car_sedan","car_hatchback","Lada2_TK_CIV_EP1","Lada1_TK_CIV_EP1","Skoda","Lada1","Lada2","LadaLM","SkodaRed","SkodaGreen","SkodaBlue","datsun1_civil_3_open","datsun1_civil_1_open","hilux1_civil_3_open_EP1","hilux1_civil_3_open","hilux1_civil_1_open"];
    if (_isCustom and _isAlive and !r_player_onVehicleC and alive player) then {
        _seat = 0;
        _text = "";
        _text2 = "";
        _seatSide = "";
        _type = typeOf _cursorTarget;
        if (_type in ["Tractor"]) then {
            _text = "Get on ";
            _text2 = " on top";
        };
        if (_type in ["ATV_US_EP1","ATV_CZ_EP1","Old_bike_TK_CIV_EP1","Old_bike_TK_INS_EP1"]) then {
            _text = "Get on ";
            _text2 = " on back";
        };
        if (_type in ["VolhaLimo_TK_CIV_EP1","Volha_2_TK_CIV_EP1","Volha_1_TK_CIV_EP1","car_sedan","car_hatchback"]) then {
            _text = "Get on ";
            _text2 = " on trunk";
        };
        if (_type in ["Lada2_TK_CIV_EP1","Lada1_TK_CIV_EP1","Skoda","Lada1","Lada2","LadaLM","SkodaRed","SkodaGreen","SkodaBlue"]) then {
            _text = "Get on ";
            _text2 = " on trunk";
        };
        if (_type in ["datsun1_civil_3_open","datsun1_civil_1_open","hilux1_civil_3_open_EP1","hilux1_civil_1_open","hilux1_civil_3_open"]) then {
            _text = "Get in ";
            _text2 = " in trunk";
        };
        _type = getText (configFile >> "CfgVehicles" >> _type >> "displayname");
        if (s_player_getin1 < 0) then {
            if (typeOf _cursorTarget in ["ATV_US_EP1","ATV_CZ_EP1","Old_bike_TK_CIV_EP1","Old_bike_TK_INS_EP1"]) then {
                s_player_getin1 = player addAction [format["%1%2%3%4",_text,_type,_text2,_seatSide], "\z\addons\dayz_code\actions\player_getin.sqf",0, 0, true, true, "", ""];	
            };
            if (typeOf _cursorTarget in ["Lada2_TK_CIV_EP1","Lada1_TK_CIV_EP1","Skoda","Lada1","Lada2","LadaLM","SkodaRed","SkodaGreen","SkodaBlue","VolhaLimo_TK_CIV_EP1","Volha_2_TK_CIV_EP1","Volha_1_TK_CIV_EP1","car_sedan","car_hatchback"]) then {
                _seatSide = " (Left)";
                s_player_getin1 = player addAction [format["%1%2%3%4",_text,_type,_text2,_seatSide], "\z\addons\dayz_code\actions\player_getin.sqf",0, 0, true, true, "", ""];	
            };
            if (typeOf _cursorTarget in ["datsun1_civil_3_open","datsun1_civil_1_open","hilux1_civil_3_open_EP1","hilux1_civil_1_open","hilux1_civil_3_open"]) then {
                _seatSide = " (Left)";
                s_player_getin1 = player addAction [format["%1%2%3%4",_text,_type,_text2,_seatSide], "\z\addons\dayz_code\actions\player_getin.sqf",0, 0, true, true, "", ""];	
            };	
            if (typeOf _cursorTarget in ["Tractor"]) then {
                s_player_getin1 = player addAction [format["%1%2%3%4",_text,_type,_text2,_seatSide], "\z\addons\dayz_code\actions\player_getin.sqf",0, 0, true, true, "", ""];	
            };	
        };	
        if (s_player_getin2 < 0) then {
            _seatSide = "";
            if (typeOf _cursorTarget in ["Lada2_TK_CIV_EP1","Lada1_TK_CIV_EP1","Skoda","Lada1","Lada2","LadaLM","SkodaRed","SkodaGreen","SkodaBlue","VolhaLimo_TK_CIV_EP1","Volha_2_TK_CIV_EP1","Volha_1_TK_CIV_EP1","car_sedan","car_hatchback"]) then {
                _seatSide = " (Right)";
                s_player_getin2 = player addAction [format["%1%2%3%4",_text,_type,_text2,_seatSide], "\z\addons\dayz_code\actions\player_getin.sqf",1, 0, true, true, "", ""];		
            };
            if (typeOf _cursorTarget in ["datsun1_civil_3_open","datsun1_civil_1_open","hilux1_civil_3_open_EP1","hilux1_civil_1_open","hilux1_civil_3_open"]) then {
                _seatSide = " (Center)";
                s_player_getin2 = player addAction [format["%1%2%3%4",_text,_type,_text2,_seatSide], "\z\addons\dayz_code\actions\player_getin.sqf",2, 0, true, true, "", ""];		
            };
        };	
        if (s_player_getin3 < 0) then {
            _seatSide = "";
            if (typeOf _cursorTarget in ["datsun1_civil_3_open","datsun1_civil_1_open","hilux1_civil_3_open_EP1","hilux1_civil_1_open","hilux1_civil_3_open"]) then {
                _seatSide = " (Right)";
                s_player_getin3 = player addAction [format["%1%2%3%4",_text,_type,_text2,_seatSide], "\z\addons\dayz_code\actions\player_getin.sqf",1, 0, true, true, "", ""];		
            };
        };	
    } else {
        player removeAction s_player_getin1;
        s_player_getin1 = -1;
        player removeAction s_player_getin2;
        s_player_getin2 = -1;
        player removeAction s_player_getin3;
        s_player_getin3 = -1;
    };
} else {
    player removeAction s_player_getin1;
    s_player_getin1 = -1;
    player removeAction s_player_getin2;
    s_player_getin2 = -1;
    player removeAction s_player_getin3;
    s_player_getin3 = -1;
};
/*
//Auto-refuel Script
if (_refuelVehicle != _currentVehicle) then {
    if (!isNull _refuelVehicle) then {
        _refuelVehicle removeAction _vehicle_refuel_id;
        _refuelVehicle = objNull;
    };
 
    if (_currentVehicle != player && _isNearFeed && !(_currentVehicle isKindof "Bicycle")) then {
        _refuelVehicle = _currentVehicle;
        _vehicle_refuel_id = _refuelVehicle addAction ["Refuel", "\z\addons\dayz_code\actions\vehicle_refuel.sqf", [_refuelAmount], -1, false, true, "", "vehicle _this == _target && local _target"];
    };
};
if (!_isNearFeed) then {
    _refuelVehicle removeAction _vehicle_refuel_id;
    _refuelVehicle = objNull;
};
*/