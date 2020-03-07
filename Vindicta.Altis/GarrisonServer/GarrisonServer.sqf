#include "common.hpp"

/*
Class: GarrisonServer
Singleton server-only class.
Collects garrisons which have changed their state and sends periodic updates about garrisons to clients which need the data.

When garrison data updates (composition, etc) many times in a short period of time we don't want to send new data on each update,
but we want to send new data at a specific rate.

Author: Sparker 23 August 2019
*/

#define pr private

#define __JIP_ID_SUFFIX "_srv_update"

CLASS("GarrisonServer", "MessageReceiverEx")

	// Array with all objects
	VARIABLE("objects");

	// Array with garrisons which have just been created
	VARIABLE("createdObjects");

	// Array with garrisons for which update events will be broadcasted at next update cycle
	VARIABLE("outdatedObjects");
	
	// Array with garrisons for which destroyed events will be broadcasted at next update cycle
	VARIABLE("destroyedObjects");

	VARIABLE("timer");
	VARIABLE("timer1");

	STATIC_VARIABLE("instance");

	METHOD("new") {
		params [P_THISOBJECT];

		T_SETV("outdatedObjects", []);
		T_SETV("destroyedObjects", []);
		T_SETV("createdObjects", []);
		T_SETV("objects", []);

		// Timer to send garrison update messages
		private _msg = MESSAGE_NEW();
		_msg set [MESSAGE_ID_DESTINATION, _thisObject];
		_msg set [MESSAGE_ID_SOURCE, ""];
		_msg set [MESSAGE_ID_DATA, []];
		_msg set [MESSAGE_ID_TYPE, "process"];
		pr _processInterval = 1;
		private _args = [_thisObject, _processInterval, _msg, gTimerServiceMain]; // message receiver, interval, message, timer service
		private _timer = NEW("Timer", _args);
		SETV(_thisObject, "timer", _timer);

		if (!isNil {GETSV("GarrisonServer", "instance")}) then {
			OOP_ERROR_1("Multiple instances of GarrisonServer are not allowed! %1", _thisObject);
		};
		SETSV("GarrisonServer", "instance", _thisObject);

	} ENDMETHOD;

	// Sends update messages about a garrison(_gar) to _target(same as remoteExecCall target)
	METHOD("_sendUpdate") {
		params [P_THISOBJECT, P_OOP_OBJECT("_gar"), "_target"];

		// Create a GarrisonRecord to serialize it (to deserialize it at the client machine)
		pr _tempRecord = NEW("GarrisonRecord", [_gar]);
		CALLM1(_tempRecord, "initFromGarrison", _gar);
		pr _serArray = SERIALIZE(_tempRecord);
		DELETE(_tempRecord);

		OOP_INFO_2("SEND UPDATE Garrison: %1, target: %2", _gar, _target);
		OOP_INFO_1("  data: %1", _serArray);

		// Now we can send the serialized array
		pr _jipid = _gar + __JIP_ID_SUFFIX;
		REMOTE_EXEC_CALL_STATIC_METHOD("GarrisonDatabaseClient", "update", [_serArray], _target, _jipid); // classNameStr, methodNameStr, extraParams, targets, JIP
	} ENDMETHOD;

	// We only receive messages from timer now, so we don't care about the message type
	// - - - - Processing of garrisons - - - - -
	METHOD("process") {
		params [P_THISOBJECT];

		// Broadcast update messages
		// This also corresponds to just created garrisons as they are outdated
		pr _outdatedGarrisons = T_GETV("outdatedObjects") + T_GETV("createdObjects");
		if (count _outdatedGarrisons > 0) then { OOP_INFO_1("OUTDATED: %1", _outdatedGarrisons); };
		{
			pr _gar = _x;
			if (IS_OOP_OBJECT(_gar)) then {
				if (CALLM0(_gar, "isAlive")) then { // We only serve update events here
					pr _side = GETV(_gar, "side");
					T_CALLM2("_sendUpdate", _gar, [_side ARG civilian]); // Send data to all clients of same side as this garrison
				};
			};
		} forEach _outdatedGarrisons;

		// Broadcast destroyed events
		pr _destroyedGarrisons = T_GETV("destroyedObjects");
		if (count _destroyedGarrisons > 0) then { OOP_INFO_1("DESTROYED: %1", _destroyedGarrisons); };
		// Just send data to everyone, those who don't care about these objects will just ignore them
		{
			pr _sides = [EAST, WEST, INDEPENDENT, CIVILIAN];
			REMOTE_EXEC_CALL_STATIC_METHOD("GarrisonDatabaseClient", "destroy", [_x], _sides, false); // Execute on all machines with interface, don't add to JIP!
			// Remove the message from the JIP queue
			pr _jipid = _x + __JIP_ID_SUFFIX;
			remoteExecCall ["", _jipid];

			// Remove from our array of objects
			pr _objects = T_GETV("objects");
			pr _index = _objects find _x;

			#ifdef _SQF_VM
			if (_index != -1) then {
			#endif

			_objects deleteAt _index;

			#ifdef _SQF_VM
			};
			#endif

			// Unref if we have ever referenced it
			if (_index != -1) then {
				UNREF(_x);
			};
		} forEach _destroyedGarrisons;

		// Reset the arrays of garrisons to broadcast
		T_SETV("outdatedObjects", []);
		T_SETV("destroyedObjects", []);
		T_SETV("createdObjects", []);

	} ENDMETHOD;


	// Called when a client has connected
	METHOD("onClientConnected") {
		params [P_THISOBJECT, P_NUMBER("_clientOwner"), P_SIDE("_side")];

		OOP_INFO_2("CLIENT CONNECTED: %1, side: %2", _clientOwner, _side);

		// Transmit data about all garrisons with the same side
		pr _garrisons = CALLSM2("Garrison", "getAllActive", [_side], []);
		{
			T_CALLM2("_sendUpdate", _x, [_side ARG civilian]); // Send data to all clients of same side as this garrison
		} forEach _garrisons;

	} ENDMETHOD;


	// - - - - Methods to be called by garrison on various events - - - - 

	// Marks the garrison as just created
	METHOD("onGarrisonCreated") {
		params [P_THISOBJECT, P_OOP_OBJECT("_gar")];

		T_GETV("createdObjects") pushBackUnique _gar;
		T_GETV("objects") pushBackUnique _gar;
		SETV(_gar, "regAtServer", true); // We will check this variable

		// Ref
		REF(_gar);
	} ENDMETHOD;

	// Marks the garrison requiring an update broadcast
	METHOD("onGarrisonOutdated") {
		params [P_THISOBJECT, P_OOP_OBJECT("_gar")];

		// Check if it's registered here
		if (GETV(_gar, "regAtServer")) then {
			T_GETV("outdatedObjects") pushBackUnique _gar;
		};
	} ENDMETHOD;

	// Marks the garrison requiring a destroyed event broadcast
	METHOD("onGarrisonDestroyed") {
		params [P_THISOBJECT, P_OOP_OBJECT("_gar")];

		T_GETV("destroyedObjects") pushBackUnique _gar;

		// Make sure we don't send an update event about it any more
		pr _outdatedObjects = T_GETV("outdatedObjects");
		pr _index = (_outdatedObjects find _gar);
		#ifdef _SQF_VM
		if (_index != -1) then { _outdatedObjects deleteAt _index; };
		#else
		_outdatedObjects deleteAt _index;
		#endif
	} ENDMETHOD;

	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 




	// GarrisonServer is attached to the main message loop
	METHOD("getMessageLoop") {
		gMessageLoopMain
	} ENDMETHOD;

	// Player's requests

	// This runs in the thread
	METHOD("buildFromGarrison") {
		OOP_INFO_1("BUILD FROM GARRISON: %1", _this);
		params [P_THISOBJECT, P_NUMBER("_clientOwner"), P_OOP_OBJECT("_gar"),
				P_STRING("_catCfgClassNameStr"), P_STRING("_objCfgClassNameStr"),
				P_POSITION("_pos"), P_POSITION("_dir"), P_BOOL("_checkGarrisonBuildRes")];
		
		// Sanity checks
		if (_catCfgClassNameStr == "") exitWith { OOP_ERROR_1("BuildFromGarrison: Category config class name is empty. _this: %1", _this); };
		if (_objCfgClassNameStr == "") exitWith { OOP_ERROR_1("BuildFromGarrison: Object class name is empty. _this: %1", _this);};

		// Bail if the garrison isn't registered any more
		if (!(_gar in T_GETV("objects"))) exitWith {
			"We can't build here any more" remoteExecCall ["systemChat", _clientOwner];
		};

		pr _buildRes = CALLM1(_gar, "getBuildResources", true); // Force update

		// Get data from config
		pr _objClass = missionConfigFile >> "BuildObjects" >> "Categories" >> _catCfgClassNameStr >> _objCfgClassNameStr;
		pr _className = getText (_objClass >> "className");
		if (_className == "") exitWith { // Bail if data is incorrect
			OOP_ERROR_1("BuildFromGarrison: class name is empty. _this: %1", _this);
		};
		pr _cost = getNumber (_objClass >> "buildResource");
		pr _catID = getNumber (_objClass >> "templateCatID");
		pr _subcatID = getNumber (_objClass >> "templateSubcatID");
		pr _isRadio = [false, true] select (getNumber (_objClass >> "isRadio"));

		// Bail if there is not enough resources
		if (_buildRes < _cost && _checkGarrisonBuildRes) exitWith {
			pr _objName = getText (configfile >> "CfgVehicles" >> _className >> "displayName");
			pr _text = format ["Not enough resources to build %1", _objName];
			_text remoteExecCall ["systemChat", _clientOwner];
		};

		// Looks like we are able to build it
		CALLM1(_gar, "removeBuildResources", _cost);

		// Create a unit or just a plain object
		pr _hO = createVehicle [_className, _pos, [], 0, "CAN_COLLIDE"];
		pr _surfaceVectorUp = surfaceNormal _pos;

		// Remove exec it so that it updates instantly on all computers
		//[_hO, _pos] remoteExec ["setPos"];
		//[_hO, _dir] remoteExec ["setDir"];
		//[_hO, _surfaceVectorUp] remoteExec ["setVectorUp"];
		
		_hO setPos _pos;
		_hO setVectorDirAndUp [_dir, _surfaceVectorUp];

		if (_catID != -1) then {
			pr _args = [[], _catID, _subcatID, -1, "", _hO];
			pr _unit = NEW("Unit", _args);
			pr _isValid = CALLM0(_unit, "isValid");
			if (_isValid) then {
				CALLM1(_gar, "addUnit", _unit);

				// If it's a cargo box, initialize the limited arsenal on it
				if (_catID == T_CARGO) then {
					CALLM1(_unit, "limitedArsenalEnable", true);
				};
			};
		};

		CALL_STATIC_METHOD_2("BuildUI", "setObjectMovable", _hO, true);

		// Add the built object to the location
		pr _loc = CALLM0(_gar, "getLocation");
		if (!IS_NULL_OBJECT(_loc)) then {
			// Add this object to location, if it's not a Unit object but a basic object
			if (_catID == -1) then {
				CALLM1(_loc, "addObject", _hO);
			};

			// Player might have added an object which affects location's player respawn capabilities,
			// so we must update it
			pr _gmdata = CALLM0(_loc, "getGameModeData");
			if (!IS_NULL_OBJECT(_gmdata)) then {
				CALLM0(_gmdata, "updatePlayerRespawn");
			};
		};

		// Send message to player
		pr _objName = getText (configfile >> "CfgVehicles" >> _className >> "displayName");
		pr _text = format ["Object %1 was build successfully!", _objName];
		_text remoteExecCall ["systemChat", _clientOwner];
	} ENDMETHOD;

	// Recruits a unit at this location from one of nearby cities
	METHOD("recruitUnitAtLocation") {
		params [P_THISOBJECT, P_NUMBER("_clientOwner"), P_OOP_OBJECT("_loc"), P_SIDE("_side"), P_NUMBER("_subcatID"), P_ARRAY("_weapons"), P_OOP_OBJECT("_arsenalUnit")];

		OOP_INFO_1("RECRUIT UNIT AT LOCATION: %1", _this);

		// Ensure that we can recruit at this place
		pr _pos = CALLM0(_loc, "getPos");
		pr _cities = CALLM1(gGameMode, "getRecruitCities", _pos);
		pr _nRecruits = CALLM1(gGameMode, "getRecruitCount", _cities);

		// Bail if we can't recruit here any more
		if (_nRecruits < 1) exitWith {
			pr _text = "Not enough recruits here!";
			REMOTE_EXEC_CALL_STATIC_METHOD("RecruitTab", "showServerResponse", [_text], _clientOwner, false);
		};

		// Remove recruits from any city
		if (count _cities > 0) then {
			pr _gmdata = GETV(_cities#0, "gameModeData");
			CALLM1(_gmdata, "removeRecruits", 1);
		};

		// Find an existing garrison here or create one
		pr _gars = CALLM1(_loc, "getGarrisons", _side);
		pr _gar = if ((count _gars) > 0) then {
			_gars#0
		} else {
			pr _locPos = CALLM0(_loc, "getPos");
			// Create a new garrison and register it
			_gar = NEW("Garrison", [_side ARG _locPos]);
			CALLM0(_gar, "activate");
			CALLM1(_gar, "setLocation", _loc);
			_activate = true;
			_gar
		};


		// Bail if the infantry capacity of the location has been reached
		pr _capinf = CALLM0(_loc, "getCapacityInf");
		pr _nInf = CALLM0(_gar, "countInfantryUnits");
		if (_nInf >= _capInf) exitWith {
			pr _text = "Infantry capacity has been reached!";
			REMOTE_EXEC_CALL_STATIC_METHOD("RecruitTab", "showServerResponse", [_text], _clientOwner, false);
		};


		// Create a group or pick an existing one
		pr _groupToJoin = "";
		pr _groups = CALLM0(_gar, "getGroups") select {(CALLM0(_x, "getType") == GROUP_TYPE_IDLE) && ((count CALLM0(_x, "getUnits")) < 5)};
		if (count _groups != 0) then {
			_groupToJoin = _groups#0;
		};

		pr _group = NEW("Group", [_side ARG GROUP_TYPE_IDLE]);

		// Create a unit
		pr _template = ["tGuerrilla"] call t_fnc_getTemplate;
		// ["_template", [], [[]]], ["_catID", 0, [0]], ["_subcatID", 0, [0]], ["_classID", 0, [0]], ["_group", "", [""]], ["_hO", objNull]];
		pr _args = [_template, T_INF, _subcatID, -1, _group, objNull, _weapons];
		pr _unit = NEW("Unit", _args);

		// Add its new group to the garrison
		CALLM1(_gar, "addGroup", _group);

		// Join an existing group if it exists
		if (_groupToJoin != "") then {
			CALLM1(_groupToJoin, "addGroup", _group);
		};

		// Remove weapons from the arsenal
		if (!IS_NULL_OBJECT(_arsenalUnit)) then {
			if (IS_OOP_OBJECT(_arsenalUnit)) then {
				pr _primary = _weapons select UNIT_WEAPONS_ID_PRIMARY;
				pr _secondary = _weapons select UNIT_WEAPONS_ID_SECONDARY;
				if (_primary != "") then {
					CALLM2(_arsenalUnit, "limitedArsenalRemoveItem", _primary, 1);
				};
				if (_secondary != "") then {
					CALLM2(_arsenalUnit, "limitedArsenalRemoveItem", _secondary, 1);
				};
			};
		};

		// Send msg back
		pr _name = T_NAMES#T_INF#_subcatID;
		pr _text = format ["We have recruited one %1", _name];
		REMOTE_EXEC_CALL_STATIC_METHOD("RecruitTab", "showServerResponse", [_text], _clientOwner, false);

		// Send weapon data again, to re-enable client's buttons
		T_CALLM3("clientRequestRecruitWeaponsAtLocation", _clientOwner, _loc, _side);
	} ENDMETHOD;

	METHOD("clientRequestRecruitWeaponsAtLocation") {
		params [P_THISOBJECT, P_NUMBER("_clientOwner"), P_OOP_OBJECT("_loc"), P_SIDE("_side")];

		OOP_INFO_1("REQUEST RECRUIT WEAPONS AT LOCATION: %1", _this);

		// Find an existing garrison here or create one
		pr _gars = CALLM1(_loc, "getGarrisons", _side);
		if ((count _gars) == 0) exitWith {
			pr _args = [[], [], 0];
			REMOTE_EXEC_CALL_STATIC_METHOD("RecruitTab", "receiveData", _args, _clientOwner, false);
		};
		
		// Find units which have arsenal
		pr _gar = _gars#0;
		pr _arsenalUnits = CALLM0(_gar, "getUnits") select { CALLM0(_x, "limitedArsenalEnabled") };
		pr _unitsAndWeapons = [];
		{
			pr _unit = _x;
			pr _dataList = CALLM0(_unit, "limitedArsenalGetDataList");
			pr _primary = _dataList call jn_fnc_arsenal_getPrimaryWeapons;
			pr _secondary = _dataList call jn_fnc_arsenal_getSecondaryWeapons;
			_unitsAndWeapons pushBack [_unit, +_primary, +_secondary];
		} forEach _arsenalUnits;

		// Find the amount of recruits available
		pr _pos = CALLM0(_loc, "getPos");
		pr _cities = CALLM1(gGameMode, "getRecruitCities", _pos);
		pr _nRecruits = CALLM1(gGameMode, "getRecruitCount", _cities);

		pr _args = [_unitsAndWeapons, call t_fnc_getAllValidTemplateNames, _nRecruits];
		OOP_INFO_1("  sending daga: %1", _args);
		REMOTE_EXEC_CALL_STATIC_METHOD("RecruitTab", "receiveData", _args, _clientOwner, false);
	} ENDMETHOD;

	// Called from AttachToGarrisonDialog
	METHOD("getUnitData") {
		params [P_THISOBJECT, P_NUMBER("_clientOwner"), P_OOP_OBJECT("_unit")];

		// Ensure this unit exists
		if (!IS_OOP_OBJECT(_unit)) exitWith {
			pr _args = [_unit, 0]; // Report wrong unit
			REMOTE_EXEC_CALL_STATIC_METHOD("AttachToGarrisonDialog", "staticShowServerResponse_0", _args, _clientOwner, false);
			OOP_ERROR_1("getUnitData: unit %1 does not exist!", _unit);
		};

		// Ensure that the unit's garrison is correct
		pr _gar = CALLM0(_unit, "getGarrison");
		if (!IS_OOP_OBJECT(_gar) || {IS_NULL_OBJECT(_gar)}) exitWith {
			pr _args = [_unit, 1]; // Report wrong garrison
			REMOTE_EXEC_CALL_STATIC_METHOD("AttachToGarrisonDialog", "staticShowServerResponse_0", _args, _clientOwner, false);
			OOP_ERROR_2("getUnitData: garrison %1 of unit %2 is not valid!", _gar, _unit);
		};

		// Report garrison's properties and other data to client
		pr _catID = CALLM0(_unit, "getCategory");
		pr _garSide = CALLM0(_gar, "getSide");

		pr _args = [_unit, 2,	// 2 is an OK code
					_catID, _gar, _garSide];
		REMOTE_EXEC_CALL_STATIC_METHOD("AttachToGarrisonDialog", "staticShowServerResponse_0", _args, _clientOwner, false);

	} ENDMETHOD;

	// Called from AttachToGarrisonDialog
	METHOD("attachUnit") {
		params [P_THISOBJECT, P_NUMBER("_clientOwner"), P_OOP_OBJECT("_unit"), P_OOP_OBJECT("_gar")];

		OOP_INFO_1("ATTACH UNIT: %1", _this);

		// Ensure this unit exists
		if (!IS_OOP_OBJECT(_unit)) exitWith {
			pr _args = [_unit, 0]; // Report wrong unit
			REMOTE_EXEC_CALL_STATIC_METHOD("AttachToGarrisonDialog", "staticShowServerResponse_0", _args, _clientOwner, false);
			OOP_ERROR_1("attachUnit: unit %1 does not exist!", _unit);
		};

		// Ensure garrison is correct
		if (!IS_OOP_OBJECT(_gar) || {IS_NULL_OBJECT(_gar)}) exitWith {
			pr _args = [_unit, 3]; // Report wrong garrison
			REMOTE_EXEC_CALL_STATIC_METHOD("AttachToGarrisonDialog", "staticShowServerResponse_0", _args, _clientOwner, false);
			OOP_ERROR_1("attachUnit: garrison %1 is not valid!", _gar);
		};

		// Ensure garrison is spawned (why??)
		if (!CALLM0(_gar, "isSpawned")) then {
			OOP_ERROR_0("Client added unit to a despawned garrison");
			CALLM0(_gar, "spawn");
		};

		// We are good to go
		CALLM1(_gar, "captureUnit", _unit);

		// Report success to user
		pr _args = [_unit, 2,	// 2 is an OK code
					CALLM0(_unit, "getCategory"), _gar, CALLM0(_gar, "getSide")];
		REMOTE_EXEC_CALL_STATIC_METHOD("AttachToGarrisonDialog", "staticShowServerResponse_0", _args, _clientOwner, false);

	} ENDMETHOD;

ENDCLASS;