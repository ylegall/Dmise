
module prototype.animation.ease;

import std.math;
import std.traits;

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

alias real function (real) EaseFunction;

/**
Controls the interpolation
*/
struct Ease
{
	EaseMode mode;
	EaseFunction fn;

	this(EaseFunction fn, EaseMode mode = EaseMode.IN) {
		this.mode = mode;
		this.fn = fn;
	}

	auto ease(real time)
	{
		if (time <= 0) return cast(real)0.0;
		if (time >= 1) return cast(real)1.0;

		auto easedT = time;

		final switch (mode) {
			case EaseMode.IN:
				easedT = fn(time);
				break;

			case EaseMode.OUT:
				easedT = 1 - fn(1.0 - time);
				break;

			case EaseMode.INOUT:
				if (time < 0.5) {
					easedT = fn(2 * time)/2;
				} else {
					easedT = 1 - fn(2 - 2 * time)/2;
				}
				break;
		}
		return easedT;
	}
}

enum LINEAR = function real(real t) { return t; };
enum SQUARE = function real(real t) { return t*t; };
enum CUBE = function real(real t) { return t*t*t; };
enum QUAD = function real(real t) {
	auto t2 = t*t;
	return t2*t2;
};
enum CIRCLE = function real(real t) {
	return 1 - sqrt(1 - t*t);
};
enum BACK = function real(real t) {
	auto t2 = t * t;
	return (t2*t) + t2 - t;
};
enum ELASTIC = function real(real t) {
	auto t2 = t * t;
	auto t3 = t2 * t;
	auto scale = t2 * (2*t3 + t2 - 4*t + 2);
	auto wave = cast(real)( -sin(t * 3.5 * PI));
	return scale * wave;
};
enum BOUNCE = function real(real t) {
	return abs(cos( (3*PI * t*t) * (1 - t) ));
};
