// Get T total minutes from date _from to _to
// _from - date
// _to - date
pr0_fnc_getTMinutesDiff = {
	params ["_from", "_to"];
	private _numberDiff = (_from call misc_fnc_dateToNumber) - (_to call misc_fnc_dateToNumber);
	private _futureEvent = true;
	if (_numberDiff < 0) then {
		_numberDiff = -_numberDiff;
		_futureEvent = false;
	};
	#ifndef _SQF_VM
	private _dateDiff = numberToDate [/*_dateNow#0*/0, _numberDiff];
	#else
	private _dateDiff = [0,0,0,0,0];
	#endif
	_dateDiff params ["_y", "_month", "_d", "_h", "_m"];
	_month = _month - 1; // Because month counting starts with 1
	_d = _d - 1; // Because day counting starts with 1
	private _minutes = ((_month * 30 + _d) * 24 + _h) * 60 + _m;
	// T-1 is one minute in the future, T+1 is in the past
	if(_futureEvent) then { 
		-_minutes
	} else {
		_minutes
	}
};

// Get hours and minutes represented by total minutes _t (which can be positive or negative)
// _this - number, total minutes (negative means in the futre, positive means in the past)
pr0_fnc_getHoursMinutes = {
	// [raw, minutes, seconds, future]
	[_this, floor (abs _this / 60), abs floor (abs _this % 60), _this < 0];
};

// Format _date like HH:MM:SS dd/MM/yyyy"
pr0_fnc_formatDate = {
	params ["_date", ["_timeFormat", "HH:MM"]];
	private _ddMMyyyy = format ["%3/%2/%1",
		_date#0,
		(if (_date#1 < 10) then { "0" } else { "" }) + str (_date#1),
		(if (_date#2 < 10) then { "0" } else { "" }) + str (_date#2)];
	format ["%1 %2", [_date#3 + (_date#4) / 60, _timeFormat] call BIS_fnc_timeToString, _ddMMyyyy];
};

// Add minutes to date with normalization
pr0_fnc_addMinutesToDate = {
	params ["_date", "_minutes"];
	private _newDate = +_date;
	_newDate set [4, _newDate#4 + _minutes];
	#ifndef _SQF_VM
	private _n = dateToNumber _newDate;
	numberToDate[_newDate#0, _n]
	#else
	[0,0,0,0,0]
	#endif
};
