//#define OOP_PROFILE
//#define OOP_PROFILE_MIN_T 0.01
#include "common.hpp"

/*
Class: AI.AIGarrison
*/

#define pr private

#ifndef RELEASE_BUILD
#define DEBUG_GOAL_MARKERS
#endif

#ifdef _SQF_VM
#undef DEBUG_GOAL_MARKERS
#endif

#define MRK_GOAL	"_goal"
#define MRK_ARROW	"_arrow"

CLASS("AIGarrison", "AI_GOAP")

	// Array of targets known by this garrison
	/* save */	VARIABLE_ATTR("targets", [ATTR_SAVE]);
	// Array of buildings occupied by enemies known by this garrison
				VARIABLE("buildingsWithTargets");
	// Position of the assigned targets (the center of the cluster typically)
	/* save */	VARIABLE_ATTR("assignedTargetsPos", [ATTR_SAVE]);
	// Radius where to search for assigned targets
	/* save */	VARIABLE_ATTR("assignedTargetsRadius", [ATTR_SAVE]);
	// Bool, set to true if garrison is aware of any targets in the 'assigned targets' area
	/* save */	VARIABLE_ATTR("awareOfAssignedTargets", [ATTR_SAVE]);

	VARIABLE("sensorHealth");
	VARIABLE("sensorState");
	VARIABLE("sensorObserved");
	VARIABLE("sensorTargets");
	
	// Last time the garrison has any goal except for "GoalGarrisonRelax"
	VARIABLE("lastBusyTime");

	// A serialized CmdrActionRecord, to be read by GarrisonServer when it needs to
	/* save */	VARIABLE_ATTR("cmdrActionRecordSerial", [ATTR_SAVE]);

	// Variables below serve for player to get intel from this garrison about various things
	// Through picking up tablet items or interrogations or whatever
	/* save */	VARIABLE_ATTR("intelGeneral", [ATTR_SAVE]); // Array with intel item refs known by this garrison
	/* save */	VARIABLE_ATTR("intelPersonal", [ATTR_SAVE]); // Ref to intel about cmdr action inwhich this garrison ai is involved
	/* save */	VARIABLE_ATTR("knownFriendlyLocations", [ATTR_SAVE]); // Array with locations about which this garrison knows

	// Radio key, string, used for player to intercept intel
	/* save */	VARIABLE_ATTR("radioKey", [ATTR_SAVE]);

	METHOD("new") {
		params [["_thisObject", "", [""]], ["_agent", "", [""]]];
		
		ASSERT_GLOBAL_OBJECT(gStimulusManagerGarrison);

		// Initialize sensors
		T_CALLM0("_initSensors");

		// Initialize the world state
		pr _ws = [WSP_GAR_COUNT] call ws_new; // todo WorldState size must depend on the agent
		[_ws, WSP_GAR_AWARE_OF_ENEMY, false] call ws_setPropertyValue;
		[_ws, WSP_GAR_ALL_CREW_MOUNTED, false] call ws_setPropertyValue;
		[_ws, WSP_GAR_ALL_INFANTRY_MOUNTED, false] call ws_setPropertyValue;
		[_ws, WSP_GAR_VEHICLE_GROUPS_MERGED, false] call ws_setPropertyValue;
		[_ws, WSP_GAR_VEHICLE_GROUPS_BALANCED, false] call ws_setPropertyValue;
		[_ws, WSP_GAR_CLEARING_AREA, [0, 0, 0]] call ws_setPropertyValue;
		[_ws, WSP_GAR_HAS_VEHICLES, false] call ws_setPropertyValue;
		// Location
		pr _loc = CALLM0(_agent, "getLocation");
		[_ws, WSP_GAR_LOCATION, _loc] call ws_setPropertyValue;
		// Position
		pr _pos = if (_loc != "") then {
			CALLM0(_loc, "getPos");
		} else {
			[0, 0, 0];
		};
		[_ws, WSP_GAR_POSITION, _pos] call ws_setPropertyValue;
		
		T_SETV("worldState", _ws);
		T_SETV("targets", []);
		T_SETV("buildingsWithTargets", []);
		T_SETV("assignedTargetsPos", [0 ARG 0 ARG 0]);
		T_SETV("assignedTargetsRadius", 0);
		T_SETV("awareOfAssignedTargets", false);
		T_SETV("lastBusyTime", time-AI_GARRISON_IDLE_TIME_THRESHOLD-1); // Garrison should be able to switch to relax instantly after its creation
		
		// Update composition
		CALLM0(_thisObject, "updateComposition");
		
		// Set process interval
		// Makes no sense any more since it's processed in thread's process categories
		//CALLM1(_thisObject, "setProcessInterval", AI_GARRISON_PROCESS_INTERVAL_DESPAWNED);
		
		// Commander action record serial
		T_SETV("cmdrActionRecordSerial", []);

		T_SETV("intelGeneral", []); // Array with intel item refs known by this garrison
		T_SETV("intelPersonal", NULL_OBJECT); // Ref to intel about cmdr action inwhich this garrison ai is involved
		T_SETV("knownFriendlyLocations", []); // Array with locations about which this garrison knows

		// Test to make all garrisons 'know' about some locations
		/*
		pr _allLocs = CALLSM0("Location", "getAll");
		for "_i" from 0 to 4 do {
			T_GETV("knownFriendlyLocations") pushBackUnique (selectRandom _allLocs);
		};
		*/

		// Get radio key from AICommander
		T_CALLM0("updateRadioKey");

		#ifdef DEBUG_GOAL_MARKERS
		T_CALLM0("_initDebugMarkers");
		#endif

		// Register at stimulus manager
		CALLM1(gStimulusManagerGarrison, "addSensingAI", _thisObject);
		
	} ENDMETHOD;
	
	METHOD("delete") {
		params ["_thisObject"];
		
		#ifdef DEBUG_GOAL_MARKERS
		deleteMarker (_thisObject + MRK_GOAL);
		deleteMarker (_thisObject + MRK_ARROW);
		#endif

		// Unregister from stimulus manager
		CALLM1(gStimulusManagerGarrison, "removeSensingAI", _thisObject);
	} ENDMETHOD;
	
	METHOD("_initDebugMarkers") {
		params [P_THISOBJECT];

		pr _agent = T_GETV("agent");

		// Location
		pr _loc = CALLM0(_agent, "getLocation");
		// Position
		pr _pos = if (_loc != "") then {
			CALLM0(_loc, "getPos");
		} else {
			[0, 0, 0];
		};

		// Main marker
		pr _color = [CALLM0(_agent, "getSide"), true] call BIS_fnc_sideColor;
		pr _name = _thisObject + MRK_GOAL;
		pr _mrk = createmarker [_name, _pos];
		_mrk setMarkerType "n_unknown";
		_mrk setMarkerColor _color;
		_mrk setMarkerAlpha 1;
		_mrk setMarkerText "new...";
		// Arrow marker (todo)
		
		// Arrow marker
		pr _name = _thisObject + MRK_ARROW;
		pr _mrk = createMarker [_name, [0, 0, 0]];
		_mrk setMarkerShape "RECTANGLE";
		_mrk setMarkerBrush "SolidFull";
		_mrk setMarkerSize [10, 10];
		_mrk setMarkerColor _color;
		_mrk setMarkerAlpha 0.5;
	} ENDMETHOD;

	METHOD("_initSensors") {
		params [P_THISOBJECT];

		pr _sensorHealth = NEW("SensorGarrisonHealth", [_thisObject]);
		CALLM(_thisObject, "addSensor", [_sensorHealth]);
		T_SETV("sensorHealth", _sensorHealth); // Keep reference to this sensor in case we want to update it
		
		pr _sensorTargets = NEW("SensorGarrisonTargets", [_thisObject]);
		CALLM(_thisObject, "addSensor", [_sensorTargets]);
		T_SETV("sensorTargets", _sensorTargets);
		
		pr _sensorCasualties = NEW("SensorGarrisonCasualties", [_thisObject]);
		CALLM(_thisObject, "addSensor", [_sensorCasualties]);
		
		pr _sensorState = NEW("SensorGarrisonState", [_thisObject]);
		CALLM1(_thisObject, "addSensor", _sensorState);
		T_SETV("sensorState", _sensorState);
		
		pr _sensorObserved = NEW("SensorGarrisonIsObserved", [_thisObject]);
		CALLM1(_thisObject, "addSensor", _sensorObserved);
		T_SETV("sensorObserved", _sensorObserved);

		pr _sensorSound = NEW("SensorGarrisonSound", [_thisObject]);
		CALLM1(_thisObject, "addSensor", _sensorSound);
	} ENDMETHOD;
	
	METHOD("process") {
		params ["_thisObject", ["_accelerate", false]];
		
		pr _gar = T_GETV("agent");

		// Call base class process (classNameStr, objNameStr, methodNameStr, extraParams)
		//OOP_INFO_2("PROCESS: SPAWNED: %1, ACCELERATE: %2", CALLM0(_thisObject, "isSpawned"), _accelerate);
		if (CALLM0(_gar, "countInfantryUnits") > 0) then {
			CALL_CLASS_METHOD("AI_GOAP", _thisObject, "process", [_accelerate]);

			// Update the "busy" timer
			pr _currentGoal = T_GETV("currentGoal");
			if (_currentGoal != "" && _currentGoal != "GoalGarrisonRelax") then { // Do we have anything to do?
				T_SETV("lastBusyTime", time);
			};

			#ifdef DEBUG_GOAL_MARKERS
			CALLM0(_thisObject, "_updateDebugMarkers");
			#endif
		} else {
			// Update only the garrisonIsObserved sensor, because vehicles and cargo boxes can still be observed
			pr _sensor = T_GETV("sensorObserved");
			
			// Update the sensor if it's time to update it
			pr _timeNextUpdate = GETV(_sensor, "timeNextUpdate");
			// If timeNextUpdate is 0, we never update this sensor
			if ((_timeNextUpdate != 0 && TIME_NOW > _timeNextUpdate)) then {
				CALLM(_sensor, "update", []);
				pr _interval = CALLM(_sensor, "getUpdateInterval", []);
				SETV(_sensor, "timeNextUpdate", TIME_NOW + _interval);
			};
		};

		// Check if we can capture other garrisons attached to this place
		pr _loc = CALLM0(_gar, "getLocation");
		if (!IS_NULL_OBJECT(_loc)) then {										// Copture something only if we are at location
			pr _side = CALLM0(_gar, "getSide");									
			if ((CALLM0(_gar, "countInfantryUnits") > 0) ||						// We must have some infantry ...
				{ _side in CALLM0(_loc, "getPlayerSides") } ) then {			// ... or some friendly players at this location
				pr _otherGars = CALLM0(_loc, "getGarrisons"); 					// Get all garrisons of any sides
				{																// Iterate those garrisons
					if (_x != _gar) then {										// We can't capture ourselves...
						if (CALLM0(_x, "getSide") != CIVILIAN) then {			// We aren't commies to capture civilian property...
							if (CALLM0(_x, "countInfantryUnits") == 0) then {	// We can't capture a garrison which has infantry...
								CALLM1(_gar, "captureGarrison", _x);			// Now all your units are belong to us!
							};
						};
					};
				} forEach _otherGars;
			};
		};

		// Add a "spawned" field to profiling output 
		PROFILE_ADD_EXTRA_FIELD("spawned", GETV(_gar, "spawned"));
		
	} ENDMETHOD;
	
	#ifdef DEBUG_GOAL_MARKERS
	METHOD("_updateDebugMarkers") {
		params ["_thisObject"];

		pr _gar = T_GETV("agent");

		// Update the markers
		pr _mrk = _thisObject + MRK_GOAL;
		
		// Set text
		pr _action = T_GETV("currentAction");
		if (_action != "") then {
			_action = CALLM0(_action, "getFrontSubaction");
		};
		pr _text = format ["%1 (%2), %3, %4, %5", _gar, CALLM(_gar, "getEfficiencyMobile", []), T_GETV("currentGoal"), T_GETV("currentGoalParameters"), _action];
		_mrk setMarkerText _text;
		
		// Set pos
		pr _pos = CALLM0(_gar, "getPos");
		_mrk setMarkerPos (_pos vectorAdd [20, 20, 0]);
		
		// Update arrow marker
		pr _mrk = _thisObject + MRK_ARROW;
		pr _goalParameters = T_GETV("currentGoalParameters");
		// See if location or position is passed
		pr _pPos = CALLSM3("Action", "getParameterValue", _goalParameters, TAG_G_POS, false);
		pr _pLoc = CALLSM3("Action", "getParameterValue", _goalParameters, TAG_LOCATION, false);
		if (isNil "_pPos" && isNil "_pLoc") then {
			_mrk setMarkerAlpha 0; // Hide the marker
		} else {
			_mrk setMarkerAlpha 0.5; // Show the marker
			pr _posDest = [0, 0, 0];
			if (!isNil "_pPos") then {	_posDest = _pPos;	};
			if (!isNil "_pLoc") then {
				if (_pLoc isEqualType "") then {
					_posDest = CALLM0(_pLoc, "getPos");
				} else {
					_posDest = _pLoc;
				};
			};
			pr _mrkPos = (_posDest vectorAdd _pos) vectorMultiply 0.5;
			_mrk setMarkerPos _mrkPos;
			_mrk setMarkerSize [0.5*(_pos distance2D _posDest), 10];
			_mrk setMarkerDir ((_pos getDir _posDest) + 90);
		};

	} ENDMETHOD;
	#endif

	// ----------------------------------------------------------------------
	// |                    G E T   M E S S A G E   L O O P
	// | The garrison AI resides in the same thread as the garrison
	// ----------------------------------------------------------------------
	
	METHOD("getMessageLoop") {
		gMessageLoopMain
	} ENDMETHOD;

	/*
	Method: handleGroupsAdded
	Handles what happens when groups get added while there is an active action.
	
	Parameters: _groups
	
	_groups - Array of <Group>
	
	Returns: nil
	*/
	METHOD("handleGroupsAdded") {
		params [["_thisObject", "", [""]], ["_groups", [], [[]]]];
		
		pr _action = T_GETV("currentAction");
		if (_action != "") then {
			// Call it directly since it is in the same thread
			CALLM1(_action, "handleGroupsAdded", _groups);
		};
		
		nil
	} ENDMETHOD;


	/*
	Method: handleGroupsRemoved
	Handles a group being removed from its garrison while the AI object is still operational.
	Currently it deletes goals from groups that have been assigned by this AI object and calls handleGroupsRemoved of current action of this AI object, if it exists.
	
	Parameters: _groups
	
	_groups - Array of <Group>
	
	Returns: nil
	*/
	METHOD("handleGroupsRemoved") {
		params [["_thisObject", "", [""]], ["_groups", [], [[]]]];
		
		// Delete goals that have been given by this object
		{
			pr _groupAI = CALLM0(_x, "getAI");
			if (!isNil "_groupAI") then {
				if (_groupAI != "") then {
					pr _args = ["", _thisObject]; // Any goal from this object
					CALLM2(_groupAI, "postMethodAsync", "deleteExternalGoal", _args);
				};
			};
		} forEach _groups;
		
		// Notify the current action
		pr _action = T_GETV("currentAction");
		if (_action != "") then {
			// Call it directly since it is in the same thread
			CALLM1(_action, "handleGroupsRemoved", _groups);
		};
		
		nil
	} ENDMETHOD;
	
	
	
	/*
	Method: handleUnitsRemoved
	Handles what happens when units get removed from their garrison, for instance when they gets destroyed.
	
	Access: internal
	
	Parameters: _units
	
	_units - Array of <Unit> objects
	
	Returns: nil
	*/
	METHOD("handleUnitsRemoved") {
		params [["_thisObject", "", [""]], ["_units", [], [[]]]];
		
		// Delete goals given by this object
		{
			pr _unitAI = CALLM0(_x, "getAI");
			if (_unitAI != "") then {
				pr _args = ["", _thisObject]; // Any goal from this object
				CALLM2(_unitAI, "postMethodAsync", "deleteExternalGoal", _args);
			};
		} forEach _units;
		
		// Notify the current action
		pr _action = T_GETV("currentAction");
		if (_action != "") then {
			// Call it directly since it is in the same thread
			CALLM1(_action, "handleUnitsRemoved", _units);
		};
	} ENDMETHOD;
	
	/*
	Method: handleUnitsAdded
	Handles what happens when units get added to a garrison.
	
	Access: internal
	
	Parameters: _unit
	
	_units - Array of <Unit> objects
	
	Returns: nil
	*/
	METHOD("handleUnitsAdded") {
		params [["_thisObject", "", [""]], ["_units", [], [[]]]];
		
		// Notify the current action
		pr _action = T_GETV("currentAction");
		if (_action != "") then {
			// Call it directly since it is in the same thread
			CALLM1(_action, "handleUnitsAdded", _units);
		};
	} ENDMETHOD;
	
	
	METHOD("handleLocationChanged") {
		params ["_thisObject", ["_loc", "", [""]]];

		// Set location world state property
		pr _ws = T_GETV("worldState");
		[_ws, WSP_GAR_LOCATION, _loc] call ws_setPropertyValue;

		// If we now are attached to a location
		if (_loc != "") then {
			// Set position world state property
			pr _pos = CALLM0(_loc, "getPos");
			[_ws, WSP_GAR_POSITION, _pos] call ws_setPropertyValue;
			
			// Now we know about this location
			T_CALLM1("addKnownFriendlyLocation", _loc);
		};

		// Update our radio key
		T_CALLM0("updateRadioKey");

		// Update the debug markers
		#ifdef DEBUG_GOAL_MARKERS
		CALLM0(_thisObject, "_updateDebugMarkers");
		#endif

	} ENDMETHOD;

	// Updates world state properties related to composition of the garrison
	// Here we have checks that must be run only when new units/groups are added or removed
	METHOD("updateComposition") {
		params ["_thisObject"];
		
		pr _gar = T_GETV("agent");
		pr _worldState = T_GETV("worldState");		
		
		// Find medics
		pr _medics = [_gar, [[T_INF, T_INF_medic], [T_INF, T_INF_recon_medic]]] call GETM(_gar, "findUnits");
		pr _medicAvailable = (count _medics) > 0;
		[_worldState, WSP_GAR_MEDIC_AVAILABLE, _medicAvailable] call ws_setPropertyValue;
		
		// Find engineers
		pr _engineers = [_gar, [[T_INF, T_INF_engineer]]] call GETM(_gar, "findUnits");
		pr _engineerAvailable = (count _engineers) > 0;
		[_worldState, WSP_GAR_ENGINEER_AVAILABLE, _engineerAvailable] call ws_setPropertyValue;
		
		// Do we have vehicles ?
		pr _haveVehicles = count CALLM0(_gar, "getVehicleUnits") > 0;
		[_worldState, WSP_GAR_HAS_VEHICLES, _haveVehicles] call ws_setPropertyValue;
		
	} ENDMETHOD;

	// Returns spawned state of attached garrison
	METHOD("isSpawned") {
		params ["_thisObject"];
		//CALLM0(T_GETV("agent"), "isSpawned")
		GETV(T_GETV("agent"), "spawned")
	} ENDMETHOD;

	// Sets the position, because it is stored in the world state
	METHOD("setPos") {
		params ["_thisObject", "_pos"];
		
		OOP_INFO_1("SET POS AI: %1", _pos);
		pr _ws = T_GETV("worldState");
		[_ws, WSP_GAR_POSITION, _pos] call ws_setPropertyValue;

		// Update our radio key, if someone has forced a position change on us
		T_CALLM0("updateRadioKey");

		// Notify GarrisonServer
		CALLM1(gGarrisonServer, "onGarrisonOutdated", T_GETV("agent"));
	} ENDMETHOD;

	// Sets the position, because it is stored in the world state
	METHOD("getPos") {
		params ["_thisObject", "_pos"];
		pr _ws = T_GETV("worldState");
		[_ws, WSP_GAR_POSITION] call ws_getPropertyValue;
	} ENDMETHOD;
	// Gets called after the garrison is spawned
	// Not used right now
	/*
	METHOD("onGarrisonSpawned") {
		params ["_thisObject"];

	} ENDMETHOD;

	// Gets called after the garrison is spawned
	METHOD("onGarrisonDespawned") {

	} ENDMETHOD;
	*/

	// This is postMethodAsync'd from GarrisonModel.setAction, to synchronize the current action this garrison is doing
	// _actionSerial can also be [], meaning there is no current action
	METHOD("setCmdrActionSerial") {
		params [P_THISOBJECT, P_ARRAY("_actionSerial")];
		T_SETV("cmdrActionRecordSerial", _actionSerial);

		// Notify the garrison server that this garrison should be updated on clients
		CALLM1(gGarrisonServer, "onGarrisonOutdated", T_GETV("agent"));
	} ENDMETHOD;

	// Intel stuff
	METHOD("addGeneralIntel") {
		params [P_THISOBJECT, P_OOP_OBJECT("_item")];
		T_GETV("intelGeneral") pushBackUnique _item;

		// Update intel of units inventory items if garrison is spawned
		CALLM0(T_GETV("agent"), "updateUnitsIntel");
	} ENDMETHOD;

	METHOD("getAllGeneralIntel") {
		params [P_THISOBJECT];
		+T_GETV("intelGeneral")
	} ENDMETHOD;
	

	METHOD("setPersonalIntel") {
		params [P_THISOBJECT, P_OOP_OBJECT("_item")];

		OOP_INFO_1(" SET PERSONAL INTEL: %1", _item);

		T_SETV("intelPersonal", _item);

		// Update intel of units inventory items if garrison is spawned
		CALLM0(T_GETV("agent"), "updateUnitsIntel");
	} ENDMETHOD;

	METHOD("addKnownFriendlyLocation") {
		params [P_THISOBJECT, P_OOP_OBJECT("_loc")];
		T_GETV("knownFriendlyLocations") pushBackUnique _loc;

		// Update intel of units inventory items if garrison is spawned
		CALLM0(T_GETV("agent"), "updateUnitsIntel");
	} ENDMETHOD;

	// Copies intel from another AIGarrison by adding intel items and locations to this object
	// Should call it when garrisons are being split if we want them to inherit intel
	METHOD("copyIntelFrom") {
		params [P_THISOBJECT, P_OOP_OBJECT("_otherAI")];

		pr _intelGeneral = T_GETV("intelGeneral");
		pr _locs = T_GETV("knownFriendlyLocations");

		// Merge known general intel
		{
			// We don't want to accumulate intel about finished cmdr actions
			if (!CALLM0(_x, "isEnded")) then {
				_intelGeneral pushBackUnique _x;
			};
		} forEach GETV(_otherAI, "intelGeneral");

		// Merge known friendly locations
		{
			_locs pushBackUnique _x;
		} forEach GETV(_otherAI, "knownFriendlyLocations");

		// Copy the radio key
		T_SETV("radioKey", GETV(_otherAI, "radioKey"));

		// Update intel of units inventory items if garrison is spawned
		CALLM0(T_GETV("agent"), "updateUnitsIntel");
	} ENDMETHOD;

	// Gets the radio key corresponding to the current position
	METHOD("updateRadioKey") {
		params [P_THISOBJECT];
		pr _side = CALLM0(T_GETV("agent"), "getSide"); // Garrison's side
		pr _AICommander = CALLSM1("AICommander", "getAICommander", _side);
		if (!IS_NULL_OBJECT(_AICommander)) then {
			pr _pos = T_CALLM0("getPos");
			pr _key = CALLM1(_AICommander, "getRadioKey", _pos);
			T_SETV("radioKey", _key);
		} else {
			T_SETV("radioKey", "666-ERROR-666");
		};
	} ENDMETHOD;

	// Returns a serialized UnitIntelData object
	// Typically we are going to assign the returned value to personal inventory
	METHOD("getUnitIntelDataSerial") {
		params [P_THISOBJECT];

		pr _temp = NEW("UnitIntelData", []);
		pr _gar = T_GETV("agent");

		SETV(_temp, "intelGeneral", +T_GETV("intelGeneral"));
		SETV(_temp, "intelPersonal", T_GETV("intelPersonal"));
		SETV(_temp, "knownFriendlyLocations", +T_GETV("knownFriendlyLocations"));
		SETV(_temp, "side", CALLM0(_gar, "getSide"));

		// Only military tablets have the radio key
		if (CALLM0(_gar, "getFaction") == "military") then {
			SETV(_temp, "radioKey", T_GETV("radioKey"));
		} else {
			SETV(_temp, "radioKey", "");
		};

		pr _serial = SERIALIZE(_temp);
		DELETE(_temp);
		_serial
	} ENDMETHOD;

	// - - - - - - STORAGE - - - - - -

	/* override */ METHOD("postDeserialize") {
		params [P_THISOBJECT, P_OOP_OBJECT("_storage")];

		//diag_log "AIGarrison postDeserialize";

		// Call method of all base classes
		CALL_CLASS_METHOD("AI_GOAP", _thisObject, "postDeserialize", [_storage]);

		// Restore sensors
		T_CALLM0("_initSensors");

		// Restore other variables
		T_SETV("lastBusyTime", time-AI_GARRISON_IDLE_TIME_THRESHOLD-1);

		// Restore debug markers
		#ifdef DEBUG_GOAL_MARKERS
		T_CALLM0("_initDebugMarkers");
		#endif

		// Register at stimulus manager
		CALLM1(gStimulusManagerGarrison, "addSensingAI", _thisObject);

		// Refresh composition
		T_CALLM0("updateComposition");

		true
	} ENDMETHOD;

ENDCLASS;