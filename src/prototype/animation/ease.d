
module prototype.animation.ease;

import std.math;
import std.traits;


alias real function (real) Ease;

/**
The enumeration of ease modes.
IN: normal easing.
OUT: reverse of IN.
INOUT: applies the easing to both the start and end of the animation.
*/
enum EaseMode
{
	IN,
	OUT,
	INOUT
}

/**
Common easing functions.
*/
struct Ease{
	enum linear = function real(real t) { return t; };
	enum square = function real(real t) { return t*t; };
	enum cube = function real(real t) { return t*t*t; };
	enum quad = function real(real t) {
		auto t2 = t*t;
		return t2*t2;
	};
	enum circle = function real(real t) {
		return 1 - sqrt(1 - t*t);
	};
	enum back = function real(real t) {
		auto t2 = t * t;
		return (t2*t) + t2 - t;
	};
	enum elastic = function real(real t) {
		auto t2 = t * t;
		auto t3 = t2 * t;
		auto scale = t2 * (2*t3 + t2 - 4*t + 2);
		auto wave = cast(real)( -sin(t * 3.5 * PI));
		return scale * wave;
	};
	enum bounce = function real(real t) {
		return abs(cos(3 * PI * t * t) * (1 - t));
	};
}

/**
Function to ease the time of an animation.
*/
auto ease(real time, Ease fn = linear, Mode mode = Mode.IN)
{
	if (time <= 0) return cast(real)0.0;
	if (time >= 1) return cast(real)1.0;

	auto easedT = time;

	final switch (mode) {
		case Mode.IN:
			easedT = fn(time);
			break;

		case Mode.OUT:
			easedT = 1 - fn(1.0 - time);
			break;

		case Mode.INOUT:
			if (time < 0.5) {
				easedT = fn(2 * time)/2;
			} else {
				easedT = 1 - fn(2 - 2 * time)/2;
			}
			break;
	}
	return easedT;
}
