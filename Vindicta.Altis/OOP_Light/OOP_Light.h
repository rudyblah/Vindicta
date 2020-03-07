#include "..\config\global_config.hpp"

//  * OOP-Light
//  * A preprocessor-based limited OOP implementation for SQF
//  * Author: Sparker
//  * 02.06.2018

//  * Technical info:
//  *
//  * Name formatting:
//  * Special static class members:	o_MyClass_sm_mySpecialMember
//  * Static class members: 			o_MyClass_st_myStaticMember
//  * General members:					o_MyClass_N_123_myMember
//  *
//  * Special class members:
//  * special members are static members of the class meant to be accessed only by the internals of the OOP-Light
//  * nextID			- NUMBER counter to provide a new ID each time an object of this class is created
//  * memList			- ARRAY with all members of this class
//  * staticMemList	- ARRAY with all static members of this class
//  * methodList		- ARRAY with all methods and static methods of this class

// ----------------------------------------------------
// |          C O N T R O L  F L A G S                |
// ----------------------------------------------------

// Defines the ofstream file name for OOP_INFO_, OOP_ERROR_, OOP_WARNING_ macros
// Must be defined before including OOP_Light.h into your class definition .sqf file
//#define OFSTREAM_FILE "OOP.rpt"

// Enables output to external file with ofstream in all OOP classes
// It's a global flag, must be defined here

// #define OFSTREAM_ENABLE

// #define OOP_PROFILE

// Enables checks for member accesses at runtime
// As well as other assertions
// It's a global flag, must be defined here

//#define OOP_ASSERT
// #define OOP_ASSERT_ACCESS

// Enables support for Arma Script Profiler globally
// Set it in this file
//#define ASP_ENABLE

// Enables macros for Arma Script Profiler counters, enables global counter variables per every class
// Define it at the top of the file per every class where you need to count objects
//#define PROFILER_COUNTERS_ENABLE

// Enables logging of each REF/UNREF on OOP objects
//#define OOP_LOG_REF_UNREF


// Enforce some constraints
#ifndef OFSTREAM_FILE
#define OFSTREAM_FILE "OOP.rpt"
#endif
#ifndef OFSTREAM_ENABLE
#undef OFSTREAM_FILE
#endif

#ifdef _SQF_VM
// ___ SQF-VM ___
#define TEXT_
#undef ASP_ENABLE
#undef PROFILER_COUNTERS_ENABLE
#undef ADE
#undef OFSTREAM_ENABLE
#undef OFSTREAM_FILE
#define VM_LOG(t) diag_log t
#define VM_LOG_FMT(t, args) diag_log format ([t] + args)
#define OOP_ASSERT
#define OOP_ASSERT_ACCESS
//#undef OOP_DEBUG
#undef OOP_INFO
#define OOP_WARNING
#define OOP_ERROR
#undef OOP_PROFILE

#define TIME_NOW 0
#define DATE_NOW [0,0,0,0,0]
#define CLIENT_OWNER 0
#define IS_SERVER true
#define HAS_INTERFACE true
#define IS_HEADLESSCLIENT false
#define PUBLIC_VARIABLE isNil
#define IS_MULTIPLAYER false

#define PROFILE_NAME "Satan"
#define SCRIPT_NULL objNull
#define saveProfileNamespace
// ^^^ SQF-VM ^^^
#else
// ___ ARMA ___

#define TEXT_ text

#define VM_LOG(t)
#define VM_LOG_FMT(t, args)

#define TIME_NOW time
#define DATE_NOW date
#define CLIENT_OWNER clientOwner
#define IS_SERVER isServer
#define HAS_INTERFACE hasInterface
#define IS_HEADLESSCLIENT (!hasInterface && !isDedicated)
#define IS_MULTIPLAYER isMultiplayer
#define PUBLIC_VARIABLE publicVariable

#define PROFILE_NAME profileName

#define SCRIPT_NULL scriptNull
#endif
// ^^^ ARMA ^^^

// Some BS to force Arma preprocessor line numbers to be correct.
// You basically have to put this after every pre-processor block if you want the correct line numbers
#define FIX_LINE_NUMBERS2(sharp) sharp##line __LINE__ __FILE__
// Use this with () but WITHOUT terminating ; like:
// FIX_LINE_NUMBERS()
#define FIX_LINE_NUMBERS() FIX_LINE_NUMBERS2(#)

// ----------------------------------------------------------------------
// |                P R O F I L E R   C O U N T E R S                   |
// ----------------------------------------------------------------------
#ifndef ASP_ENABLE
#undef PROFILER_COUNTERS_ENABLE
#endif

#define COUNTER_NAME_STR(nameStr) ("g_profCnt_" + nameStr)

#ifdef PROFILER_COUNTERS_ENABLE
#define PROFILER_COUNTER_INIT(nameStr) missionNamespace setVariable[COUNTER_NAME_STR(nameStr), 0];
#else
#define PROFILER_COUNTER_INIT(nameStr)
#endif

#ifdef ASP_ENABLE
#define PROFILER_COUNTER_INC(nameStr) isNil { \
	private _oop_cnt = missionNamespace getVariable COUNTER_NAME_STR(nameStr); \
	if(!isNil "_oop_cnt") then { \
		missionNamespace setVariable [COUNTER_NAME_STR(nameStr), _oop_cnt+1]; \
		nameStr profilerSetCounter _oop_cnt; \
	}; \
};

#define PROFILER_COUNTER_DEC(nameStr) isNil { \
	private _oop_cnt = missionNamespace getVariable COUNTER_NAME_STR(nameStr); \
	if(!isNil "_oop_cnt") then { \
		missionNamespace setVariable [COUNTER_NAME_STR(nameStr), _oop_cnt-1]; \
		nameStr profilerSetCounter _oop_cnt; \
	}; \
};
#else
#define PROFILER_COUNTER_INC(nameStr)
#define PROFILER_COUNTER_DEC(nameStr)
#endif

// Minimum amount of time for a function to take before its profile entry will be written out
#ifndef OOP_PROFILE_MIN_T
	#define OOP_PROFILE_MIN_T 0.1
#endif

/*
#ifdef OOP_ASSERT
	diag_log "[OOP] Warning: member assertion is enabled. Disable it for better performance.";
#endif
*/

// Defines into which namespace this class is going to store variables
// Not all OOP functionality is supported with namespaces yet!
// ! ! ! ! ! Namespaces don't work at all, don't even try to use them, just use mission namespace ! ! ! ! ! !
#ifndef NAMESPACE
	#define NAMESPACE missionNameSpace
#endif


// -----------------------------------------------------
// |       M E T H O D   P A R A M E T E R S           |
// -----------------------------------------------------

#define P_THISOBJECT ["_thisObject", "", [""]]
#define P_DEFAULT_PARAMS params [["_thisObject", "", [""]]]
#define P_THISCLASS ["_thisClass", "", [""]]
#define P_DEFAULT_STATIC_PARAMS params [["_thisObject", "", [""]]]
#define P_STRING(paramNameStr) [paramNameStr, "", [""]]
#define P_TEXT(paramNameStr) paramNameStr
#define P_OBJECT(paramNameStr) [paramNameStr, objNull, [objNull]]
#define P_NUMBER(paramNameStr) [paramNameStr, 0, [0]]
#define P_NUMBER_DEFAULT(paramNameStr, defaultVal) [paramNameStr, defaultVal, [0]]
#define P_SIDE(paramNameStr) [paramNameStr, WEST, [WEST]]
#define P_BOOL(paramNameStr) [paramNameStr, false, [false]]
#define P_BOOL_DEFAULT_TRUE(paramNameStr) [paramNameStr, true, [true]]
#define P_ARRAY(paramNameStr) [paramNameStr, [], [[]]]
#define P_COLOR(paramNameStr) [paramNameStr, [1,1,1,1]]
#define P_POSITION(paramNameStr) [paramNameStr, [], [[]]]
#define P_CODE(paramNameStr) [paramNameStr, {}, [{}]]
#define P_DYNAMIC(paramNameStr) [paramNameStr, nil]

#define P_OOP_OBJECT(paramNameStr) P_STRING(paramNameStr)

// ----------------------------------------------------------------------
// |                 I N T E R N A L   S T R I N G S                    |
// ----------------------------------------------------------------------

#define OOP_PREFIX "o_"
#define OBJECT_SEPARATOR "_N_"
#define SPECIAL_SEPARATOR "_spm_"
#define STATIC_SEPARATOR "_stm_"
#define METHOD_SEPARATOR "_fnc_"
#define INNER_PREFIX "inner_"
#define GLOBAL_SEPARATOR "global_"

// ----------------------------------------------------------------------
// |          I N T E R N A L   N A M E   F O R M A T T I N G           |
// ----------------------------------------------------------------------

//Name of a specific instance of object
#define OBJECT_NAME_STR(classNameStr, objIDInt)  (format ["o_%1_c%2_s%3_n%4", classNameStr, CLIENT_OWNER, OOP_GVAR(sessionID), objIDInt])

//String name of a static member
#define CLASS_STATIC_MEM_NAME_STR(classNameStr, memNameStr) ((OOP_PREFIX) + (classNameStr) + STATIC_SEPARATOR + (memNameStr))

//String name of a method
#define CLASS_METHOD_NAME_STR(classNameStr, methodNameStr) ((classNameStr) + METHOD_SEPARATOR + (methodNameStr))

//String name of a special member
#define CLASS_SPECIAL_MEM_NAME_STR(classNameStr, memNameStr) (OOP_PREFIX + (classNameStr) + SPECIAL_SEPARATOR + (memNameStr))

//String name of a non-static member
#define OBJECT_MEM_NAME_STR(objNameStr, memNameStr) ((objNameStr) + "_" + memNameStr)

//Gets parent class of an object
#define OBJECT_PARENT_CLASS_STR(objNameStr) (FORCE_GET_MEM(objNameStr, OOP_PARENT_STR))

//String name of an inner method
#define INNER_METHOD_NAME_STR(methodNameStr) (INNER_PREFIX + methodNameStr)

//Macro for global OOP variables
#define OOP_GVAR(var) o_##var
#define OOP_GVAR_STR(var) format["o_%1", #var]

// ==== Private special members
#define NEXT_ID_STR "nextID"
#define MEM_LIST_STR "memList"
#define STATIC_MEM_LIST_STR "staticMemList"
#define SERIAL_MEM_LIST_STR "serialMemList"
#define METHOD_LIST_STR "methodList"
#define PARENTS_STR "parents"
#define OOP_PARENT_STR "oop_parent"
#define OOP_PUBLIC_STR "oop_public"
#define NAMESPACE_STR "namespace"

// Other important strings
#define OOP_ERROR_DEBRIEFING_SECTION_VAR_NAME_STR "oop_missionEndText"
// CfgDebriefing class entry in description.ext which is shown when a critical OOP error happens
#define OOP_ERROR_DEBRIEFING_CLASS_NAME	end_OOP_class_error
#define OOP_ERROR_DEBRIEFING_CLASS_NAME_STR "end_OOP_class_error"

// ----------------------------------------------------------------------
// |          I N T E R N A L   A C C E S S   M E M B E R S             |
// ----------------------------------------------------------------------

#define FORCE_SET_MEM(objNameStr, memNameStr, value) NAMESPACE setVariable [OBJECT_MEM_NAME_STR(objNameStr, memNameStr), value]
#define FORCE_SET_MEM_NS(ns, objNameStr, memNameStr, value) ns setVariable [OBJECT_MEM_NAME_STR(objNameStr, memNameStr), value]
#define FORCE_SET_MEM_REF(objNameStr, memNameStr, value) \
	isNil { \
		private _oldVal = NAMESPACE getVariable [OBJECT_MEM_NAME_STR(objNameStr, memNameStr), NULL_OBJECT]; \
		if (!IS_NULL_OBJECT(_oldVal)) then { UNREF(_oldVal); }; \
		if (!IS_NULL_OBJECT(value)) then { REF((value)); }; \
		NAMESPACE setVariable [OBJECT_MEM_NAME_STR(objNameStr, memNameStr), value] \
	}

#define FORCE_SET_STATIC_MEM(classNameStr, memNameStr, value) NAMESPACE setVariable [CLASS_STATIC_MEM_NAME_STR(classNameStr, memNameStr), value]
#define FORCE_SET_METHOD(classNameStr, methodNameStr, code) missionNamespace setVariable [CLASS_METHOD_NAME_STR(classNameStr, methodNameStr), code]
#define FORCE_GET_MEM(objNameStr, memNameStr) ( NAMESPACE getVariable OBJECT_MEM_NAME_STR(objNameStr, memNameStr) )
#define FORCE_GET_STATIC_MEM(classNameStr, memNameStr) ( NAMESPACE getVariable CLASS_STATIC_MEM_NAME_STR(classNameStr, memNameStr) )
#define FORCE_GET_METHOD(classNameStr, methodNameStr) ( missionNamespace getVariable CLASS_METHOD_NAME_STR(classNameStr, methodNameStr) )

#ifndef _SQF_VM
#define FORCE_PUBLIC_MEM(objNameStr, memNameStr) publicVariable OBJECT_MEM_NAME_STR(objNameStr, memNameStr)
#define FORCE_PUBLIC_STATIC_MEM(classNameStr, memNameStr) publicVariable CLASS_STATIC_MEM_NAME_STR(classNameStr, memNameStr)
#else
#define FORCE_PUBLIC_MEM(objNameStr, memNameStr)
#define FORCE_PUBLIC_STATIC_MEM(classNameStr, memNameStr)
#endif

//Special members don't use run time checks
#define SET_SPECIAL_MEM(classNameStr, memNameStr, value) missionNamespace setVariable [CLASS_SPECIAL_MEM_NAME_STR(classNameStr, memNameStr), value]
#define GET_SPECIAL_MEM(classNameStr, memNameStr) ( missionNamespace getVariable CLASS_SPECIAL_MEM_NAME_STR(classNameStr, memNameStr) )

// -----------------------------------------------------
// |           A C C E S S   M E M B E R S             |
// -----------------------------------------------------

#ifdef OOP_ASSERT_ACCESS
#define ASSERT_SET_MEMBER_ACCESS(objNameStr, memNameStr) 			[objNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_set_member_access
#define ASSERT_SET_STATIC_MEMBER_ACCESS(classNameStr, memNameStr) 	[classNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_set_static_member_access
#define ASSERT_GET_MEMBER_ACCESS(objNameStr, memNameStr) 			[objNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_get_member_access
#define ASSERT_GET_STATIC_MEMBER_ACCESS(classNameStr, memNameStr)	[classNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_get_static_member_access
#else
#define ASSERT_SET_MEMBER_ACCESS(objNameStr, memNameStr) 			
#define ASSERT_SET_STATIC_MEMBER_ACCESS(classNameStr, memNameStr) 	
#define ASSERT_GET_MEMBER_ACCESS(objNameStr, memNameStr) 			
#define ASSERT_GET_STATIC_MEMBER_ACCESS(classNameStr, memNameStr)	
#endif

#ifdef OOP_ASSERT
	#define SET_MEM(objNameStr, memNameStr, value) \
		if([objNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_member_is_not_ref) then { \
			ASSERT_SET_MEMBER_ACCESS(objNameStr, memNameStr); \
			FORCE_SET_MEM(objNameStr, memNameStr, value) \
		}
	#define SET_MEM_REF(objNameStr, memNameStr, value) \
		if([objNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_member_is_ref) then { \
			ASSERT_SET_MEMBER_ACCESS(objNameStr, memNameStr); \
			FORCE_SET_MEM_REF(objNameStr, memNameStr, value) \
		}
	#define SET_STATIC_MEM(classNameStr, memNameStr, value) \
		if([classNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_staticMember) then { \
			ASSERT_SET_STATIC_MEMBER_ACCESS(classNameStr, memNameStr); \
			FORCE_SET_STATIC_MEM(classNameStr, memNameStr, value) \
		}
	#define GET_MEM(objNameStr, memNameStr) \
		( if([objNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_member) then { \
			ASSERT_GET_MEMBER_ACCESS(objNameStr, memNameStr); \
			FORCE_GET_MEM(objNameStr, memNameStr) \
		}else{nil} )
	#define GET_STATIC_MEM(classNameStr, memNameStr) \
		( if([classNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_staticMember) then { \
			ASSERT_GET_STATIC_MEMBER_ACCESS(classNameStr, memNameStr); \
			FORCE_GET_STATIC_MEM(classNameStr, memNameStr) \
		}else{nil} )
	#define GET_METHOD(classNameStr, methodNameStr) \
		( if([classNameStr, methodNameStr, __FILE__, __LINE__] call OOP_assert_method) then { \
			FORCE_GET_METHOD(classNameStr, methodNameStr) \
		}else{nil} )
	#define PUBLIC_MEM(objNameStr, memNameStr) \
		if([objNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_member) then { \
			FORCE_PUBLIC_MEM(objNameStr, memNameStr) \
		}
	#define PUBLIC_STATIC_MEM(classNameStr, memNameStr) \
		if([classNameStr, memNameStr, __FILE__, __LINE__] call OOP_assert_staticMember) then { \
			FORCE_PUBLIC_STATIC_MEM(classNameStr, memNameStr) \
		}
#else
	#define SET_MEM(objNameStr, memNameStr, value) FORCE_SET_MEM(objNameStr, memNameStr, value)
	#define SET_MEM_REF(objNameStr, memNameStr, value) FORCE_SET_MEM_REF(objNameStr, memNameStr, value)
	#define SET_STATIC_MEM(classNameStr, memNameStr, value) FORCE_SET_STATIC_MEM(classNameStr, memNameStr, value)
	#define GET_MEM(objNameStr, memNameStr) FORCE_GET_MEM(objNameStr, memNameStr)
	#define GET_STATIC_MEM(classNameStr, memNameStr) FORCE_GET_STATIC_MEM(classNameStr, memNameStr)
	#define GET_METHOD(classNameStr, methodNameStr) FORCE_GET_METHOD(classNameStr, methodNameStr)
	#define PUBLIC_MEM(objNameStr, memNameStr) FORCE_PUBLIC_MEM(objNameStr, memNameStr)
	#define PUBLIC_STATIC_MEM(classNameStr, memNameStr) FORCE_PUBLIC_STATIC_MEM(classNameStr, memNameStr)
#endif

#define SET_VAR(a, b, c) SET_MEM(a, b, c)
#define SET_VAR_REF(a, b, c) SET_MEM_REF(a, b, c)
#define SET_STATIC_VAR(a, b, c) SET_STATIC_MEM(a, b, c)
#define GET_VAR(a, b) GET_MEM(a, b)
#define GET_STATIC_VAR(a, b) GET_STATIC_MEM(a, b)
#define PUBLIC_VAR(a, b) PUBLIC_MEM(a, b)
#define PUBLIC_STATIC_VAR(a, b) PUBLIC_STATIC_MEM(a, b)
#define SET_VAR_PUBLIC(a, b, c) SET_VAR(a, b, c); PUBLIC_VAR(a, b)

// Shortened variants of macros
#define SETV(a, b, c) SET_VAR(a, b, c)
#define SETV_REF(a, b, c) SET_VAR_REF(a, b, c)
#define SETSV(a, b, c) SET_STATIC_VAR(a, b, c)
#define GETV(a, b) GET_VAR(a, b)
#define GETSV(a, b) GET_STATIC_VAR(a, b)
#define PVAR(a, b) PUBLIC_VAR(a, b)

// Getting/setting variables of _thisObject
#define T_SETV(varNameStr, varValue) SET_VAR(_thisObject, varNameStr, varValue)
#define T_SETV_REF(varNameStr, varValue) SET_VAR_REF(_thisObject, varNameStr, varValue)
#define T_PUBLIC_VAR(varNameStr) PUBLIC_VAR(_thisObject, varNameStr)
#define T_SETV_PUBLIC(varNameStr, varValue) SET_VAR_PUBLIC(_thisObject, varNameStr, varValue)
#define T_GETV(varNameStr) GET_VAR(_thisObject, varNameStr)

// Unpacking a _thisObject variable into a private _variable
// So if we have private _var = GET_VAR(_thisObject, "var"), this macros can help
#define __STRINGIFY(s) #s
#define T_PRVAR(varName) private _##varName = GET_VAR(_thisObject, __STRINGIFY(varName))

// Returns object class name
#define GET_OBJECT_CLASS(objNameStr) OBJECT_PARENT_CLASS_STR(objNameStr)

// Returns true if reference passed is pointing at a valid object 
#define IS_OOP_OBJECT(objNameStr) (! (isNil {GET_OBJECT_CLASS(objNameStr)}))

// Returns variable names of this class
#define GET_CLASS_MEMBERS(classNameStr) GET_SPECIAL_MEM(classNameStr, MEM_LIST_STR)

// -----------------------------------------------------
// |             M E T H O D   C A L L S               |
// -----------------------------------------------------

#define GETM(objNameStr, methodNameStr) GET_METHOD(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr)

//Same performance for small functions
//#define CALL_METHOD(objNameStr, methodNameStr, extraParams) ([objNameStr] + extraParams) call (call compile (CLASS_STATIC_MEM_NAME_STR(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr)))
#define CALL_METHOD(objNameStr, methodNameStr, extraParams) (([objNameStr] + extraParams) call GET_METHOD(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr))
#define CALL_METHOD_0(objNameStr, methodNameStr) (([objNameStr]) call GET_METHOD(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr))
#define CALL_METHOD_1(objNameStr, methodNameStr, a) (([objNameStr, a]) call GET_METHOD(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr))
#define CALL_METHOD_2(objNameStr, methodNameStr, a, b) (([objNameStr, a, b]) call GET_METHOD(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr))
#define CALL_METHOD_3(objNameStr, methodNameStr, a, b, c) (([objNameStr, a, b, c]) call GET_METHOD(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr))
#define CALL_METHOD_4(objNameStr, methodNameStr, a, b, c, d) (([objNameStr, a, b, c, d]) call GET_METHOD(OBJECT_PARENT_CLASS_STR(objNameStr), methodNameStr))

#define CALL_CLASS_METHOD(classNameStr, objNameStr, methodNameStr, extraParams) (([objNameStr] + extraParams) call GET_METHOD(classNameStr, methodNameStr))

#define CALL_STATIC_METHOD(classNameStr, methodNameStr, extraParams) (([classNameStr] + extraParams) call GET_METHOD(classNameStr, methodNameStr))
#define CALL_STATIC_METHOD_0(classNameStr, methodNameStr) ([classNameStr] call GET_METHOD(classNameStr, methodNameStr))
#define CALL_STATIC_METHOD_1(classNameStr, methodNameStr, a) (([classNameStr, a]) call GET_METHOD(classNameStr, methodNameStr))
#define CALL_STATIC_METHOD_2(classNameStr, methodNameStr, a, b) (([classNameStr, a, b]) call GET_METHOD(classNameStr, methodNameStr))
#define CALL_STATIC_METHOD_3(classNameStr, methodNameStr, a, b, c) (([classNameStr, a, b, c]) call GET_METHOD(classNameStr, methodNameStr))
#define CALL_STATIC_METHOD_4(classNameStr, methodNameStr, a, b, c, d) (([classNameStr, a, b, c, d]) call GET_METHOD(classNameStr, methodNameStr))

// Shortened variants of macros
#define CALLM(a, b, c) CALL_METHOD(a, b, c)
#define CALLCM(a, b, c, d) CALL_CLASS_METHOD(a, b, c, d)
#define CALLSM(a, b, c) CALL_STATIC_METHOD(a, b, c)

// Macros for multiple variables
#define CALLM0(a, b) CALL_METHOD_0(a, b)
#define CALLM1(a, b, c) CALL_METHOD_1(a, b, c)
#define CALLM2(a, b, c, d) CALL_METHOD_2(a, b, c, d)
#define CALLM3(a, b, c, d, e) CALL_METHOD_3(a, b, c, d, e)
#define CALLM4(a, b, c, d, e, f) CALL_METHOD_4(a, b, c, d, e, f)

// Macros for calls to this
#define T_CALLM(a, b) CALL_METHOD(_thisObject, a, b)
#define T_CALLM0(a) CALL_METHOD_0(_thisObject, a)
#define T_CALLM1(a, b) CALL_METHOD_1(_thisObject, a, b)
#define T_CALLM2(a, b, c) CALL_METHOD_2(_thisObject, a, b, c)
#define T_CALLM3(a, b, c, d) CALL_METHOD_3(_thisObject, a, b, c, d)
#define T_CALLM4(a, b, c, d, e) CALL_METHOD_4(_thisObject, a, b, c, d, e)

// Call an overidden method from the overriding method.
#define T_CALLCM(classNameStr, methodNameStr, extraParams) ([_thisObject]+extraParams call GET_METHOD(classNameStr, methodNameStr))

#define CALLSM0(a, b) CALL_STATIC_METHOD_0(a, b)
#define CALLSM1(a, b, c) CALL_STATIC_METHOD_1(a, b, c)
#define CALLSM2(a, b, c, d) CALL_STATIC_METHOD_2(a, b, c, d)
#define CALLSM3(a, b, c, d, e) CALL_STATIC_METHOD_3(a, b, c, d, e)
#define CALLSM4(a, b, c, d, e, f) CALL_STATIC_METHOD_4(a, b, c, d, e, f)

// Remote executions
#define REMOTE_EXEC_METHOD(objNameStr, methodNameStr, extraParams, targets) [objNameStr, methodNameStr, extraParams] remoteExec ["OOP_callFromRemote", targets, false]
#define REMOTE_EXEC_CALL_METHOD(objNameStr, methodNameStr, extraParams, targets) [objNameStr, methodNameStr, extraParams] remoteExecCall ["OOP_callFromRemote", targets, false]

#ifdef OOP_ASSERT
#define REMOTE_EXEC_STATIC_METHOD(classNameStr, methodNameStr, extraParams, targets, JIP) [classNameStr, methodNameStr, extraParams] remoteExec ["OOP_callStaticMethodFromRemote", targets, JIP];
#define REMOTE_EXEC_CALL_STATIC_METHOD(classNameStr, methodNameStr, extraParams, targets, JIP) [classNameStr, methodNameStr, extraParams] remoteExecCall ["OOP_callStaticMethodFromRemote", targets, JIP];
#else
#define REMOTE_EXEC_STATIC_METHOD(classNameStr, methodNameStr, extraParams, targets, JIP) ([classNameStr] + extraParams) remoteExec [CLASS_METHOD_NAME_STR(classNameStr, methodNameStr), targets, JIP];
#define REMOTE_EXEC_CALL_STATIC_METHOD(classNameStr, methodNameStr, extraParams, targets, JIP) ([classNameStr] + extraParams) remoteExecCall [CLASS_METHOD_NAME_STR(classNameStr, methodNameStr), targets, JIP];
#endif

// ----------------------------------------
// |         A T T R I B U T E S          |
// ----------------------------------------

#define ATTR_REFCOUNTED		1
#define ATTR_SERIALIZABLE	2
#define ATTR_PRIVATE		3

// Needs more work to implement this (walking classes to find the first place a member was defined etc.)
// #define ATTR_PROTECTED 4
#define ATTR_GET_ONLY 5
#define ATTR_THREAD_AFFINITY_ID 6
#define ATTR_THREAD_AFFINITY(getThreadFn) [ATTR_THREAD_AFFINITY_ID, getThreadFn]

// For serialization when saving
#define ATTR_SAVE			7
#define ATTR_SAVE_VER(ver)	[7,ver]
// #define ATTR_DEFAULT_KEY	8
// #define ATTR_DEFAULT(val)	[8,val]

#define ATTR_USERBASE 1000

// -----------------------------------------------------
// |       M E M B E R   D E C L A R A T I O N S       |
// -----------------------------------------------------

#define VARIABLE(varNameStr) VARIABLE_ATTR(varNameStr, [])
#define STATIC_VARIABLE(varNameStr) STATIC_VARIABLE_ATTR(varNameStr, [])

#ifdef OOP_ASSERT
#define VARIABLE_ATTR(varNameStr, attributes) \
	if(!((varNameStr) in [OOP_PARENT_STR, OOP_PUBLIC_STR]) && (_oop_memList findIf { (_x select 0) isEqualTo (varNameStr) } != NOT_FOUND)) then { \
		OOP_ERROR_2("Class %1 is hiding variable %2 in parent", _oop_classNameStr, varNameStr); \
	}; \
	_oop_memList pushBackUnique [varNameStr, attributes]
#define STATIC_VARIABLE_ATTR(varNameStr, attributes) \
	if(_oop_staticMemList findIf { (_x select 0) isEqualTo (varNameStr) } != NOT_FOUND) then { \
		OOP_ERROR_2("Class %1 is hiding static variable %2 in parent", _oop_classNameStr, varNameStr); \
	}; \
	_oop_staticMemList pushBackUnique [varNameStr, attributes]
#else
#define VARIABLE_ATTR(varNameStr, attributes) _oop_memList pushBackUnique [varNameStr, attributes]
#define STATIC_VARIABLE_ATTR(varNameStr, attributes) _oop_staticMemList pushBackUnique [varNameStr, attributes]
#endif

// -----------------------------------------------------
// |                 P R O F I L I N G                 |
// -----------------------------------------------------

#ifdef OOP_ASSERT
	#define OOP_ASSERT_BOOL true
#else
	#define OOP_ASSERT_BOOL false
#endif

#ifdef OOP_PROFILE
	#define _OOP_FUNCTION_WRAPPERS

	#define PROFILE_SCOPE_START(scopeName) \
		private _profileTStart##scopeName = diag_tickTime; \
		private _extraProfileFields = [];

	#define PROFILE_SCOPE_END(scopeName, minT) \
		private _totalProfileT##scopeName = diag_tickTime - _profileTStart##scopeName; \
		if(_totalProfileT##scopeName > minT) then { \
			private _str = format ["{ ""profile"": { ""scope"": ""%1"", ""time"": %2 }}", #scopeName, _totalProfileT##scopeName]; \
			OOP_PROFILE_0(_str); \
		};

	#define OOP_FUNC_HEADER_PROFILE \
		private _profileTStart = diag_tickTime; \
		private _class = if(isNil "_thisClass") then { if(isNil "_thisObject") then { "(unknown)" } else { OBJECT_PARENT_CLASS_STR(_thisObject) } } else { _thisClass }; \
		private _profileTag = if(_class != "(unknown)") then { FORCE_GET_STATIC_MEM(_class, "profile__tag") } else { "" }; \
		private _scopeKey = if(isNil "_profileTag" or isNil "_thisObject") then { \
			_class \
		} else { \
			if(_profileTag == "" or isNil "_thisObject") then { _objOrClass } else { GETV(_thisObject, _profileTag) } \
		}; \
		private _class1 = OBJECT_PARENT_CLASS_STR(_thisObject); \
		private _scopeKey = _class1; \
		private _extraProfileFields = [];



	#define OOP_FUNC_HEADER_PROFILE_STATIC \
		private _profileTStart = diag_tickTime; \
		private _class1 = _thisClass; \
		private _scopeKey = _class1; \
		private _extraProfileFields = [];

	#define OOP_FUNC_FOOTER_PROFILE \
		private _totalProfileT = diag_tickTime - _profileTStart; \
		if(_totalProfileT > OOP_PROFILE_MIN_T) then { \
			private _extraFieldsObj = ""; \
			if(count _extraProfileFields > 0) then { \
				{ \
					_x params ["_fieldName", "_fieldVal"]; \
					if(_extraFieldsObj != "") then { _extraFieldsObj = _extraFieldsObj + "," }; \
					if(_fieldVal isEqualType "") then {	 \
						_extraFieldsObj = _extraFieldsObj + (format [ """%1"": ""%2""", _fieldName, _fieldVal ]); \
					} else { \
						_extraFieldsObj = _extraFieldsObj + (format [ """%1"": %2", _fieldName, _fieldVal ]); \
					}; \
				} forEach _extraProfileFields; \
				_extraFieldsObj = ", ""extra"": { " + _extraFieldsObj + " }"; \
			}; \
			private _str = format ["{ ""profile"": { ""class"": ""%1"", ""method"": ""%2"", ""scope"": ""%5.%2"", ""time"": %3, ""object_or_class"": ""%4"", ""oop_assert"": %7%6 }}", _class1, _methodNameStr, _totalProfileT, _objOrClass, _scopeKey, _extraFieldsObj, OOP_ASSERT_BOOL]; \
			OOP_PROFILE_0(_str); \
		}
	
	#define PROFILE_ADD_EXTRA_FIELD(fieldName, fieldVal) _extraProfileFields pushBack [fieldName, fieldVal]
#else
	#define PROFILE_SCOPE_START(scopeName)
	#define PROFILE_SCOPE_END(scopeName, minT)
	#define PROFILE_ADD_EXTRA_FIELD(fieldName, fieldVal)
	#define OOP_FUNC_HEADER_PROFILE
	#define OOP_FUNC_HEADER_PROFILE_STATIC
	#define OOP_FUNC_FOOTER_PROFILE
#endif

// Enable function wrappers if logging macros are used
// /*
// #ifdef OOP_DEBUG
// #define _OOP_FUNCTION_WRAPPERS
// #endif
// #ifdef OOP_INFO
// #define _OOP_FUNCTION_WRAPPERS
// #endif
// #ifdef OOP_WARNING
// #define _OOP_FUNCTION_WRAPPERS
// #endif
// #ifdef OOP_ERROR
// #define _OOP_FUNCTION_WRAPPERS
// #endif
// #ifdef OOP_DEBUG
// #define _OOP_FUNCTION_WRAPPERS
// #endif
// */

// Enable function wrappers if access assertions are enabled
#ifdef OOP_ASSERT_ACCESS
#define _OOP_FUNCTION_WRAPPERS
#endif

// Enable function wrappers if access assertions are enabled
#ifdef OOP_TRACE_FUNCTIONS
#define OOP_DEBUG
#define _OOP_FUNCTION_WRAPPERS
#define OOP_TRACE_ENTER_FUNCTION OOP_DEBUG_MSG("> enter function %1", [_this])
#define OOP_TRACE_EXIT_FUNCTION OOP_DEBUG_MSG("< exit function", [])
#else
#define OOP_TRACE_ENTER_FUNCTION 
#define OOP_TRACE_EXIT_FUNCTION 
#endif

// -----------------------------------------------------
// |                   M E T H O D S                   |
// -----------------------------------------------------

// If some enabled functionality requires function wrappers we set them here. If you want to conditionally add more stuff to the wrapped functions
// (e.g. additional asserts, parameter manipulation etc.) then define them as macros and then include them in the wrapped blocks in the same manner
// that OOP_PROFILE does.
#ifdef _OOP_FUNCTION_WRAPPERS
	#define METHOD(methodNameStr) \
		_oop_methodList pushBackUnique methodNameStr;  \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr), { \
			private _thisClass = nil; \
			private _thisObject = _this select 0; \
			private _methodNameStr = methodNameStr; \
			private _objOrClass = _this select 0; \
			OOP_FUNC_HEADER_PROFILE; \
			OOP_TRACE_ENTER_FUNCTION; \
			private _result = ([0] apply { _this call

	#define ENDMETHOD }) select 0;\
			OOP_TRACE_EXIT_FUNCTION; \
			OOP_FUNC_FOOTER_PROFILE; \
			if !(isNil "_result") then { _result } else { nil } \
		} ]

	#define METHOD_FILE(methodNameStr, path) \
		_oop_methodList pushBackUnique methodNameStr; \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, INNER_METHOD_NAME_STR(methodNameStr)), compile preprocessFileLineNumbers path]; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr), { \
			private _thisClass = nil; \
			private _thisObject = _this select 0; \
			private _methodNameStr = methodNameStr; \
			private _objOrClass = _this select 0; \
			OOP_FUNC_HEADER_PROFILE; \
			OOP_TRACE_ENTER_FUNCTION; \
			private _fn = missionNamespace getVariable CLASS_METHOD_NAME_STR(OBJECT_PARENT_CLASS_STR(_objOrClass), INNER_METHOD_NAME_STR(methodNameStr)); \
			private _result = ([0] apply { _this call _fn }) select 0; \
			OOP_TRACE_EXIT_FUNCTION; \
			OOP_FUNC_FOOTER_PROFILE; \
			if !(isNil "_result") then { _result } else { nil } \
		}]

	#define STATIC_METHOD(methodNameStr) \
		_oop_methodList pushBackUnique methodNameStr; \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr), { \
			private _thisObject = nil; \
			private _thisClass = _this select 0; \
			private _methodNameStr = methodNameStr; \
			private _objOrClass = _this select 0; \
			OOP_FUNC_HEADER_PROFILE_STATIC; \
			OOP_TRACE_ENTER_FUNCTION; \
			private _result = ([0] apply { _this call

	#define STATIC_METHOD_FILE(methodNameStr, path) \
		_oop_methodList pushBackUnique methodNameStr; \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, INNER_METHOD_NAME_STR(methodNameStr)), compile preprocessFileLineNumbers path]; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr), { \
			private _thisObject = nil; \
			private _thisClass = _this select 0; \
			private _methodNameStr = methodNameStr; \
			private _objOrClass = _this select 0; \
			OOP_FUNC_HEADER_PROFILE_STATIC; \
			OOP_TRACE_ENTER_FUNCTION; \
			private _fn = missionNamespace getVariable CLASS_METHOD_NAME_STR(_objOrClass, INNER_METHOD_NAME_STR(methodNameStr)); \
			private _result = ([0] apply { _this call _fn}) select 0; \
			OOP_TRACE_EXIT_FUNCTION; \
			OOP_FUNC_FOOTER_PROFILE; \
			if !(isNil "_result") then { _result } else { nil } \
		}]
#else
	#define METHOD(methodNameStr) \
		_oop_methodList pushBackUnique methodNameStr; \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr),
	#define ENDMETHOD ]

	#define METHOD_FILE(methodNameStr, path) \
		_oop_methodList pushBackUnique methodNameStr; \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr), compile preprocessFileLineNumbers path]

	#define STATIC_METHOD(methodNameStr) \
		_oop_methodList pushBackUnique methodNameStr; \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr),

	#define STATIC_METHOD_FILE(methodNameStr, path) \
		_oop_methodList pushBackUnique methodNameStr; \
		_oop_newMethodList pushBackUnique methodNameStr; \
		missionNamespace setVariable [CLASS_METHOD_NAME_STR(_oop_classNameStr, methodNameStr), compile preprocessFileLineNumbers path]
#endif

// --------------------------------------------------------
// |              C L A S S   C O U N T E R               |
// --------------------------------------------------------
// Every object has a unique ID, and a specific class counter implementation might be different


// Initial value when class is initialized
#define OOP_ID_COUNTER_NEW [0]
// Increases the value and returns a new value
#define OOP_ID_COUNTER_PLUS_ONE(value) (value call { \
	private _this = +_this; \
	private _c = count _this; \
	private _nfound = true; \
	for "_i" from 0 to (_c-1) do { \
		private _num = _this select _i; \
		if (_num < 999999) exitWith { \
			_this set [_i, _num + 1]; \
			_nfound = false; \
		}; \
		_this set [_i, 0]; \
	}; \
	if (_nfound) then {	_this pushBack 1; }; \
	_this \
})

/*
// Plain numeric counters
#define OOP_ID_COUNTER_NEW 0
// Increases the value and returns a new value
#define OOP_ID_COUNTER_PLUS_ONE(value) (value + 1)
*/

// ----------------------------------------
// |              C L A S S               |
// ----------------------------------------

// /*
//  * Technical info:
//  * First we initialize special members of the class, then we initialize new, delete and copy methods.
//  * The name of this class is added to the hierarchy of its base class, if it's not "".
//  * The methods of base class are copied to the methods of the derived class, except for "new" and "delete", because they will be called through the hierarchy anyway.
//  */

#define CLASS(classNameStr, baseClassNames) \
call { \
diag_log TEXT_ format ["CLASS %1 <- %2", classNameStr, baseClassNames]; \
private _oop_classNameStr = classNameStr; \
SET_SPECIAL_MEM(_oop_classNameStr, NEXT_ID_STR, OOP_ID_COUNTER_NEW); \
private _oop_memList = []; \
private _oop_staticMemList = []; \
private _oop_parents = []; \
private _oop_methodList = []; \
private _oop_newMethodList = []; \
private _parentClassNames = if(baseClassNames isEqualType "") then {[baseClassNames]} else {baseClassNames}; \
if (count _parentClassNames > 0) then { \
	{ \
		private _baseClassNameStr = _x; \
		if (_baseClassNameStr != "") then { \
			if (!([_baseClassNameStr, __FILE__, __LINE__] call OOP_assert_class)) then { \
				private _msg = format ["Invalid base class for %1: %2", classNameStr, baseClassNameStr]; \
				FAILURE(_msg); \
			}; \
			{_oop_parents pushBackUnique _x; } forEach GET_SPECIAL_MEM(_baseClassNameStr, PARENTS_STR); \
			_oop_parents pushBackUnique _baseClassNameStr; \
			{ _oop_memList pushBackUnique _x; } forEach GET_SPECIAL_MEM(_baseClassNameStr, MEM_LIST_STR); \
			{ _oop_staticMemList pushBackUnique _x; } forEach GET_SPECIAL_MEM(_baseClassNameStr, STATIC_MEM_LIST_STR); \
			private _oop_addedMethodList = []; \
			{ _oop_methodList pushBackUnique _x; _oop_addedMethodList pushBackUnique _x; } forEach GET_SPECIAL_MEM(_baseClassNameStr, METHOD_LIST_STR); \
			private _oop_topParent = _oop_parents select ((count _oop_parents) - 1); \
			{ private _oop_methodCode = FORCE_GET_METHOD(_oop_topParent, _x); \
				FORCE_SET_METHOD(classNameStr, _x, _oop_methodCode); \
				_oop_methodCode = FORCE_GET_METHOD(_oop_topParent, INNER_METHOD_NAME_STR(_x)); \
				if (!isNil "_oop_methodCode") then { FORCE_SET_METHOD(classNameStr, INNER_METHOD_NAME_STR(_x), _oop_methodCode); }; \
			} forEach (_oop_addedMethodList - ["new", "delete", "copy"]); \
		}; \
	} forEach _parentClassNames; \
}; \
SET_SPECIAL_MEM(_oop_classNameStr, PARENTS_STR, _oop_parents); \
SET_SPECIAL_MEM(_oop_classNameStr, MEM_LIST_STR, _oop_memList); \
SET_SPECIAL_MEM(_oop_classNameStr, STATIC_MEM_LIST_STR, _oop_staticMemList); \
SET_SPECIAL_MEM(_oop_classNameStr, METHOD_LIST_STR, _oop_methodList); \
SET_SPECIAL_MEM(_oop_classNameStr, NAMESPACE_STR, NAMESPACE); \
PROFILER_COUNTER_INIT(_oop_classNameStr); \
METHOD("new") {} ENDMETHOD; \
METHOD("delete") {} ENDMETHOD; \
METHOD("copy") OOP_clone_default ENDMETHOD; \
METHOD("assign") OOP_assign_default ENDMETHOD; \
VARIABLE(OOP_PARENT_STR); \
VARIABLE(OOP_PUBLIC_STR);


// ----------------------------------------
// |           E N D C L A S S            |
// ----------------------------------------

// /*
//  * Technical info:
//  * It just terminates the call block of the CLASS
//  * Also it calculates an array with serializable members
//  */

#define ENDCLASS  \
private _serialVariables = GET_SPECIAL_MEM(_oop_classNameStr, MEM_LIST_STR); \
_serialVariables = _serialVariables select { \
	_x params ["_varName", "_attributes"]; \
	ATTR_SERIALIZABLE in _attributes \
}; \
SET_SPECIAL_MEM(_oop_classNameStr, SERIAL_MEM_LIST_STR, _serialVariables); \
}

// ----------------------------------------------------------------------
// |        C O N S T R U C T O R  O F   E X I S T I N G   O B J E C T  |
// ----------------------------------------------------------------------

// /*
//  * Technical info:
//  * Creates an object with given name, doesn't call its constructor.
//  */

#define NEW_EXISTING(classNameStr, objNameStr) [] call { \
FORCE_SET_MEM(objNameStr, OOP_PARENT_STR, classNameStr); \
objNameStr \
}

#define NEW_PUBLIC_EXISTING(classNameStr, objNameStr) [] call { \
FORCE_SET_MEM(objNameStr, OOP_PARENT_STR, classNameStr); \
FORCE_SET_MEM(objNameStr, OOP_PUBLIC_STR, 1); \
PUBLIC_VAR(objNameStr, OOP_PUBLIC_STR); \
PUBLIC_VAR(objNameStr, OOP_PARENT_STR); \
objNameStr \
}

// ----------------------------------------
// |        C O N S T R U C T O R         |
// ----------------------------------------

// /*
//  * Technical info:
//  * Check the class name if needed.
//  * Increase the object counter for this class.
//  * Call all constructors of the base classes from base to derived classes.
//  */

#ifdef OOP_ASSERT
#define CONSTRUCTOR_ASSERT_CLASS(classNameStr) if (!([classNameStr, __FILE__, __LINE__] call OOP_assert_class)) exitWith {format ["ERROR_NO_CLASS_%1", classNameStr]};
#else
#define CONSTRUCTOR_ASSERT_CLASS(classNameStr)
#endif

#define NEW(classNameStr, extraParams) ([classNameStr, extraParams] call OOP_new)

// -----------------------------------------------------------------------
// |        C O N S T R U C T O R  O F  P U B L I C   O B J E C T        |
// -----------------------------------------------------------------------

// /*
//  * Creates a 'public' object that will also exist across other computers in multiplayer.
//  * Same as constructor, but also marks the object as public with a OOP_PUBLIC_STR variable.
//  * It also transmits oop_parent and oop_public variables with publicVariable.
//  * It doesn't mean the object's variables will be streamed across MP network, you still need to do it yourself.
//  */

#define NEW_PUBLIC(classNameStr, extraParams) ([classNameStr, extraParams] call OOP_new_public) 

// ----------------------------------------
// |         D E S T R U C T O R          |
// ----------------------------------------

// /*
//  * Technical info:
//  * Check object validity if needed.
//  * Call all destructors of the base classes from derived classes to base classes.
//  * Clean (set to nil) all members of this object.
//  * If the object was global, also broadcast this.
//  */

#ifdef OOP_ASSERT
#define DESTRUCTOR_ASSERT_OBJECT(objNameStr) if (!([objNameStr, __FILE__, __LINE__] call OOP_assert_object)) exitWith {};
#else
#define DESTRUCTOR_ASSERT_OBJECT(objNameStr)
#endif

#define DELETE(objNameStr) ([objNameStr] call OOP_delete)

// ----------------------------------------
// |              C L O N E               |
// ----------------------------------------

#define CLONE(objNameStr) ([objNameStr] call OOP_clone)

// ----------------------------------------
// |             A S S I G N              |
// ----------------------------------------

#define ASSIGN(destObjNameStr, srcObjNameStr) CALL_METHOD(destObjNameStr, "assign", [srcObjNameStr])

// ----------------------------------------
// |             U P D A T E              |
// ----------------------------------------
// Same as assign but copies only existing variables of an object (those that are not nil)
#define UPDATE(destObjNameStr, srcObjNameStr) [destObjNameStr, srcObjNameStr, false] call OOP_assign_default;

// ----------------------------------------
// |    U P D A T E   V I A   A T T R     |
// ----------------------------------------
// Same as update but filters by specified attribute (e.g. ATTR_SERIALIZABLE)
#define UPDATE_VIA_ATTR(destObjNameStr, srcObjNameStr, attr) [destObjNameStr, srcObjNameStr, false, attr] call OOP_assign_default;

// ----------------------------------------
// |          S E R I A L I Z E           |
// ----------------------------------------
// Packs variables into an array and returns the array
#define SERIALIZE(objNameStr) ([objNameStr] call OOP_serialize)
#define SERIALIZED_CLASS_NAME(array) (array select 0)
#define SERIALIZED_OBJECT_NAME(array) (array select 1)
#define SERIALIZED_SET_OBJECT_NAME(array, name) array set [1, name]

// Serialize all variables which have a specified attributes
#define SERIALIZE_ATTR(objNameStr, attr) ([objNameStr, attr] call OOP_serialize_attr)
#define SERIALIZE_SAVE(objNameStr) ([objNameStr] call OOP_serialize_save)

// Serialize all variables regardless of their attributes
#define SERIALIZE_ALL(objNameStr) ([objNameStr, 0, true] call OOP_serialize_attr)

// ----------------------------------------
// |        D E S E R I A L I Z E         |
// ----------------------------------------
// Returns ref to the object passed in the array
// Object must exist before you can DESERIALIZE an array into it!
#define DESERIALIZE(objNameStr, array) ([objNameStr, array] call OOP_deserialize)
#define DESERIALIZE_ATTR(objNameStr, array, attr) ([objNameStr, array, attr] call OOP_deserialize_attr)
#define DESERIALIZE_ALL(objNameStr, array) ([objNameStr, array, 0, true] call OOP_deserialize_attr)
#define DESERIALIZE_SAVE(objNameStr, array) ([objNameStr, array] call OOP_deserialize_save)
#define DESERIALIZE_SAVE_VER(objNameStr, array, version) ([objNameStr, array, version] call OOP_deserialize_save)

// ---------------------------------------------
// |         R E F   C O U N T I N G           |
// ---------------------------------------------

#ifdef OOP_LOG_REF_UNREF

#define REF(objNameStr) CALLM0(objNameStr, "ref"); \
diag_log format ["[REF/UNREF]: REF: %1, %2, %3", objNameStr, __FILE__, __LINE__]

#define UNREF(objNameStr) CALLM0(objNameStr, "unref"); \
diag_log format ["[REF/UNREF]: UNREF: %1, %2, %3", objNameStr, __FILE__, __LINE__]

#else
#define REF(objNameStr) CALLM0(objNameStr, "ref")
#define UNREF(objNameStr) CALLM0(objNameStr, "unref")
#endif

// ---------------------------------------------------
// |         T H R E A D I N G    U T I L S          |
// ---------------------------------------------------

#define CRITICAL_SECTION isNil

// ----------------------------------------------------------------------
// |                   L O G G I N G   M A C R O S                      |
// ----------------------------------------------------------------------

#define LOG_SCOPE(logScopeName) private _oop_logScope = logScopeName
#define LOG_0 if((isNil "_thisObject")) then { if(!(isNil "_thisClass")) then {_thisClass} else { if(!(isNil "_oop_logScope")) then { _oop_logScope } else { "NoClass" }} } else { _thisObject }

#ifdef _OOP_FUNCTION_WRAPPERS
#define LOG_1 if (isNil "_methodNameStr") then {"fnc"} else {_methodNameStr}
#else
#define LOG_1 "fnc"
#endif

#ifdef ADE
#define DUMP_CALLSTACK ade_dumpCallstack
#define ADE_HALT halt
#define ADE_ASSERT assert 
#else
#define DUMP_CALLSTACK diag_log "callstack"
#define ADE_HALT diag_log "halt"
#define ADE_ASSERT
#endif

// If ofstream addon is globally enabled
#ifdef OFSTREAM_ENABLE
#define __OFSTREAM_OUT(fileName, text) ((ofstream_new fileName) ofstream_write(text))
#define WRITE_CRITICAL(text) ((ofstream_new "Critical.rpt") ofstream_write(text))
#else

#define __OFSTREAM_OUT(fileName, str) diag_log TEXT_ str
#define WRITE_CRITICAL(str)

#endif

#define _OFSTREAM_FILE OFSTREAM_FILE

#ifdef OFSTREAM_FILE
#define WRITE_LOG(str) __OFSTREAM_OUT(OFSTREAM_FILE, str)
#else
#define WRITE_LOG(str) diag_log TEXT_ str
#endif

#ifdef OOP_PROFILE
#define OOP_PROFILE_MSG(str, a) private _o_str = format ["[%1.%2] PROFILE: %3",LOG_0, LOG_1, format ([str]+a)]; __OFSTREAM_OUT("oop_profile.rpt", _o_str)
#define OOP_PROFILE_0(str) private _o_str = format ["[%1.%2] PROFILE: %3", LOG_0, LOG_1, str]; __OFSTREAM_OUT("oop_profile.rpt", _o_str)
#define OOP_PROFILE_1(str, a) private _o_str = format ["[%1.%2] PROFILE: %3",LOG_0, LOG_1, format [str, a]]; __OFSTREAM_OUT("oop_profile.rpt", _o_str)
#define OOP_PROFILE_2(str, a, b) private _o_str = format ["[%1.%2] PROFILE: %3", LOG_0, LOG_1, format [str, a, b]]; __OFSTREAM_OUT("oop_profile.rpt", _o_str)
#define OOP_PROFILE_3(str, a, b, c) private _o_str = format ["[%1.%2] PROFILE: %3", LOG_0, LOG_1, format [str, a, b, c]]; __OFSTREAM_OUT("oop_profile.rpt", _o_str)
#define OOP_PROFILE_4(str, a, b, c, d) private _o_str = format ["[%1.%2] PROFILE: %3", LOG_0, LOG_1, format [str, a, b, c, d]]; __OFSTREAM_OUT("oop_profile.rpt", _o_str)
#define OOP_PROFILE_5(str, a, b, c, d, e) private _o_str = format ["[%1.%2] PROFILE: %3", LOG_0, LOG_1, format [str, a, b, c, d, e]]; __OFSTREAM_OUT("oop_profile.rpt", _o_str)
#else
#define OOP_PROFILE_MSG(str, a)
#define OOP_PROFILE_0(str)
#define OOP_PROFILE_1(str, a)
#define OOP_PROFILE_2(str, a, b)
#define OOP_PROFILE_3(str, a, b, c)
#define OOP_PROFILE_4(str, a, b, c, d)
#define OOP_PROFILE_5(str, a, b, c, d, e)
#endif

#ifdef OOP_INFO
#define OOP_INFO_MSG(str, a) private _o_str = format ["[%1.%2] INFO: %3",LOG_0, LOG_1, format ([str]+a)]; WRITE_LOG(_o_str)
#define OOP_INFO_0(str) private _o_str = format ["[%1.%2] INFO: %3", LOG_0, LOG_1, str]; WRITE_LOG(_o_str)
#define OOP_INFO_1(str, a) private _o_str = format ["[%1.%2] INFO: %3",LOG_0, LOG_1, format [str, a]]; WRITE_LOG(_o_str)
#define OOP_INFO_2(str, a, b) private _o_str = format ["[%1.%2] INFO: %3", LOG_0, LOG_1, format [str, a, b]]; WRITE_LOG(_o_str)
#define OOP_INFO_3(str, a, b, c) private _o_str = format ["[%1.%2] INFO: %3", LOG_0, LOG_1, format [str, a, b, c]]; WRITE_LOG(_o_str)
#define OOP_INFO_4(str, a, b, c, d) private _o_str = format ["[%1.%2] INFO: %3", LOG_0, LOG_1, format [str, a, b, c, d]]; WRITE_LOG(_o_str)
#define OOP_INFO_5(str, a, b, c, d, e) private _o_str = format ["[%1.%2] INFO: %3", LOG_0, LOG_1, format [str, a, b, c, d, e]]; WRITE_LOG(_o_str)
#define OOP_INFO_6(str, a, b, c, d, e, f) private _o_str = format ["[%1.%2] INFO: %3", LOG_0, LOG_1, format [str, a, b, c, d, e, f]]; WRITE_LOG(_o_str)
#else
#define OOP_INFO_MSG(str, a)
#define OOP_INFO_0(str)
#define OOP_INFO_1(str, a)
#define OOP_INFO_2(str, a, b)
#define OOP_INFO_3(str, a, b, c)
#define OOP_INFO_4(str, a, b, c, d)
#define OOP_INFO_5(str, a, b, c, d, e)
#define OOP_INFO_6(str, a, b, c, d, e, f)
#endif

#ifdef OOP_WARNING
#define OOP_WARNING_MSG(str, a) private _o_str = format ["[%1.%2] WARNING: %3", LOG_0, LOG_1, format ([str]+a)]; WRITE_LOG(_o_str); WRITE_CRITICAL(_o_str)
#define OOP_WARNING_0(str) private _o_str = format ["[%1.%2] WARNING: %3", LOG_0, LOG_1, str]; WRITE_LOG(_o_str); WRITE_CRITICAL(_o_str)
#define OOP_WARNING_1(str, a) private _o_str = format ["[%1.%2] WARNING: %3", LOG_0, LOG_1, format [str, a]]; WRITE_LOG(_o_str); WRITE_CRITICAL(_o_str)
#define OOP_WARNING_2(str, a, b) private _o_str = format ["[%1.%2] WARNING: %3", LOG_0, LOG_1, format [str, a, b]]; WRITE_LOG(_o_str); WRITE_CRITICAL(_o_str)
#define OOP_WARNING_3(str, a, b, c) private _o_str = format ["[%1.%2] WARNING: %3", LOG_0, LOG_1, format [str, a, b, c]]; WRITE_LOG(_o_str); WRITE_CRITICAL(_o_str)
#define OOP_WARNING_4(str, a, b, c, d) private _o_str = format ["[%1.%2] WARNING: %3", LOG_0, LOG_1, format [str, a, b, c, d]]; WRITE_LOG(_o_str); WRITE_CRITICAL(_o_str)
#define OOP_WARNING_5(str, a, b, c, d, e) private _o_str = format ["[%1.%2] WARNING: %3", LOG_0, LOG_1, format [str, a, b, c, d, e]]; WRITE_LOG(_o_str); WRITE_CRITICAL(_o_str)
#else
#define OOP_WARNING_MSG(str, a)
#define OOP_WARNING_0(str)
#define OOP_WARNING_1(str, a)
#define OOP_WARNING_2(str, a, b)
#define OOP_WARNING_3(str, a, b, c)
#define OOP_WARNING_4(str, a, b, c, d)
#define OOP_WARNING_5(str, a, b, c, d, e)
#endif

#ifdef OOP_ERROR
#define OOP_ERROR_MSG(str, a) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, format ([str]+a) ]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#define OOP_ERROR_0(str) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, str]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#define OOP_ERROR_1(str, a) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, format [str, a]]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#define OOP_ERROR_2(str, a, b) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, format [str, a, b]]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#define OOP_ERROR_3(str, a, b, c) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, format [str, a, b, c]]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#define OOP_ERROR_4(str, a, b, c, d) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, format [str, a, b, c, d]]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#define OOP_ERROR_5(str, a, b, c, d, e) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, format [str, a, b, c, d, e]]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#define OOP_ERROR_6(str, a, b, c, d, e, f) private _o_str = format ["[%1.%2] ERROR: %3", LOG_0, LOG_1, format [str, a, b, c, d, e, f]]; WRITE_LOG(_o_str); diag_log _o_str; WRITE_CRITICAL(_o_str); ADE_HALT
#else
#define OOP_ERROR_MSG(str, a)
#define OOP_ERROR_0(str)
#define OOP_ERROR_1(str, a)
#define OOP_ERROR_2(str, a, b)
#define OOP_ERROR_3(str, a, b, c)
#define OOP_ERROR_4(str, a, b, c, d)
#define OOP_ERROR_5(str, a, b, c, d, e)
#define OOP_ERROR_6(str, a, b, c, d, e, f)
#endif

#ifdef OOP_DEBUG
#define OOP_DEBUG_MSG(str, a) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, format ([str]+a) ]; WRITE_LOG(_o_str)
#define OOP_DEBUG_0(str) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, str]; WRITE_LOG(_o_str)
#define OOP_DEBUG_1(str, a) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, format [str, a]]; WRITE_LOG(_o_str)
#define OOP_DEBUG_2(str, a, b) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, format [str, a, b]]; WRITE_LOG(_o_str)
#define OOP_DEBUG_3(str, a, b, c) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, format [str, a, b, c]]; WRITE_LOG(_o_str)
#define OOP_DEBUG_4(str, a, b, c, d) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, format [str, a, b, c, d]]; WRITE_LOG(_o_str)
#define OOP_DEBUG_5(str, a, b, c, d, e) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, format [str, a, b, c, d, e]]; WRITE_LOG(_o_str)
#define OOP_DEBUG_6(str, a, b, c, d, e, f) private _o_str = format ["[%1.%2] DEBUG: %3", LOG_0, LOG_1, format [str, a, b, c, d, e]]; WRITE_LOG(_o_str)
#else
#define OOP_DEBUG_MSG(str, a)
#define OOP_DEBUG_0(str)
#define OOP_DEBUG_1(str, a)
#define OOP_DEBUG_2(str, a, b)
#define OOP_DEBUG_3(str, a, b, c)
#define OOP_DEBUG_4(str, a, b, c, d)
#define OOP_DEBUG_5(str, a, b, c, d, e)
#define OOP_DEBUG_6(str, a, b, c, d, e, f)
#endif

// ----------------------------------------------------------------------
// |                A S S E R T I O N S  A N D   C H E C K S            |
// ----------------------------------------------------------------------
// ASSERT_OBJECT_CLASS(objNameStr, classNameStr)
// Exits current scope if provided object's class doesn't match specified class
#ifdef OOP_ASSERT
	#define ASSERT_OBJECT(objNameStr) ([objNameStr, __FILE__, __LINE__] call OOP_assert_object)
	#define ASSERT_OBJECT_CLASS(objNameStr, classNameStr) ([objNameStr, classNameStr, __FILE__, __LINE__] call OOP_assert_objectClass)
	#define ASSERT_MSG(condition, msg) \
		if (!(condition)) then { \
			private _str = str({ condition; }); \
			OOP_ERROR_2("Assertion failed: %2", _str, msg); \
			DUMP_CALLSTACK; \
			throw [__FILE__, __LINE__, msg]; \
		}
	#define ASSERT(condition) \
		if (!(condition)) then { \
			private _str = str({ condition; }); \
			OOP_ERROR_1("Assertion failed (%1)", _str); \
			DUMP_CALLSTACK; \
			throw [__FILE__, __LINE__, msg]; \
		}
	#define FAILURE(msg) \
		OOP_ERROR_1("Failure: %1", msg); \
		DUMP_CALLSTACK; \
		throw [__FILE__, __LINE__, msg]
#else
	#define ASSERT_OBJECT(object)
	#define ASSERT_OBJECT_CLASS(objNameStr, classNameStr)
	#define ASSERT_MSG(condition, msg)
	#define ASSERT(condition)
	#define FAILURE(msg)
#endif

// Returns true if given object is public, i.e. was created with NEW_PUBLIC
#define IS_PUBLIC(objNameStr) (! (isNil {GET_MEM(objNameStr, OOP_PUBLIC_STR)} ) )

// ----------------------------------------------------------------------
// |                       R E M O T E   E X E C                        |
// ----------------------------------------------------------------------
#define ON_ALL 		0
#define ON_SERVER 	2
#define ON_CLIENTS	([0, -2] select isDedicated)
#define NO_JIP 		false
#define ALWAYS_JIP	true

// ----------------------------------------------------------------------
// |                               M I S C                              |
// ----------------------------------------------------------------------
#define ARG ,

// Index find and findIf return when they don't find anything
#define NOT_FOUND -1
// For use with sort
#define ASCENDING true
#define DESCENDING false
// Is the object handle valid?
//#define NOT_NULL_OBJECT(object) ((object isEqualType "") and {!(object isEqualTo "")})
#define IS_NULL_OBJECT(object) (object isEqualTo "")
// Value to assign to an object handle to indicate it is deliberately invalid.
#define NULL_OBJECT ""
#define OOP_OBJECT_TYPE ""

#define POS_TO_ATL(pos) ([(pos) select 0, (pos) select 1, 0])