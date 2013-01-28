
module prototype.animation.ease;

import std.math;
import std.traits;


/**
Controls the interpolation
*/
struct Ease
{
	/**
	* The enumeration of ease modes.
	* IN: normal easing.
	* OUT: reverse of IN.
	* INOUT: applies the easing to both the start and end of the animation.
	*/
	enum Mode
	{
		IN,     // IN: normal easing.
		OUT,    // OUT: reverse of IN. 
		INOUT   // INOUT: applies the easing to both the start and end of the animation.
	}

	alias real function (real) EaseFunction;

	Mode mode;
	EaseFunction fn;

	this(EaseFunction fn, Mode mode = Mode.IN) {
		this.mode = mode;
		this.fn = fn;
	}

	auto ease(real time)
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
}

enum LINEAR = Ease(function real(real t) { return t; });
enum SQUARE = Ease(function real(real t) { return t*t; });
enum CUBE = Ease(function real(real t) { return t*t*t; });
enum QUAD = Ease(function real(real t) {
	auto t2 = t*t;
	return t2*t2;
});
enum CIRCLE = Ease(function real(real t) {
	return 1 - sqrt(1 - t*t);
});
enum BACK = Ease(function real(real t) {
	auto t2 = t * t;
	return (t2*t) + t2 - t;
});
enum ELASTIC = Ease(function real(real t) {
	auto t2 = t * t;
	auto t3 = t2 * t;
	auto scale = t2 * (2*t3 + t2 - 4*t + 2);
	auto wave = cast(real)( -sin(t * 3.5 * PI));
	return scale * wave;
});
enum BOUNCE = Ease(function real(real t) {
	return abs(cos( (3*PI * t*t) * (1 - t) ));
});
