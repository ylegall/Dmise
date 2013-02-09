module dmise.util.vector;

import std.math;
import std.traits;

alias Vector2D!real Vector;

/**
Implementation of a 2D vector.
*/
struct Vector2D(T=real)
	if(isNumeric!T)
{
	T x, y;

	this(T x = 0.0, T y = 0.0) {
		this.x = x;
		this.y = y;
	}

	/**
	Copy constructor.
	*/
	this(const Vector2D!T other) {
		x = other.x;
		y = other.y;
	}

	/**
	Support binary operators.
	*/
	auto opBinary(string op)(Vector2D!T other) const {
		Vector2D!T result;
		result.x = mixin("this.x " ~ op ~ "other.x");
		result.y = mixin("this.y " ~ op ~ "other.y");
		return result;
	}

	unittest {
		auto v1 = Vector(1,3);
		auto v2 = Vector(5,8);
		auto v3 = v1 + v2;
		assert(v3.x == 6);
		assert(v3.y == 11);
	}

	/**
	Support binary operators.
	*/
	auto opBinary(string op, C)(C c) const
		if(is(C:T))
	{
		Vector2D!T result;
		result.x = mixin("this.x " ~ op ~ "c");
		result.y = mixin("this.y " ~ op ~ "c");
		return result;
	}

	unittest {
		auto v1 = Vector(1,3);
		v1 = v1 * 2;
		assert(v1.x == 2);
		assert(v1.y == 6);
	}

	/**
	Calculate the magnitude of this vector.
	@return the magnitude as a real.
	*/
	@property
	auto magnitude() const {
		return sqrt(this.dot(this));
	}

	unittest {
		auto v1 = Vector(3,4);
		assert(v1.magnitude() == 5.0);
	}

	/**
	Calculate the dot product of this Vector2D with another.
	@return the dot-product as a real.
	*/
	auto dot(const Vector2D!T other) const {
		return (x * other.x + y * other.y);
	}

	unittest {
		auto v1 = Vector(4,5);
		auto v2 = Vector(2,3);
		assert(v1.dot(v2) == 23);
	}

	/**
	Calculate the dot product of this Vector2D with another.
	@return the dot-product as a real.
	*/
	auto opOpAssign(string op, N)(N num)
		if (is(N:T))
	{
		mixin("this.x " ~ op ~ "= num;");
		mixin("this.y " ~ op ~ "= num;");
	}

	unittest {
		auto v1 = Vector(4,5);
		v1 -= 1.0;
		assert(v1.x == 3);
		assert(v1.y == 4);
	}

	/**
	Get the Vector that is perpindicular to this Vector.
	*/
	auto perpendicular() const {
		return new Vector2D(y, x);
	}

	/**
	Get the signed angle between 2 vectors.
	@param v1 the first vector
	@param v2 the second vector
	@return the signed angle in radians between the two vectors
	*/
	static auto signedAngle(Vector2D!T v1, Vector2D!T v2) {
		auto perpDot = v1.x * v2.y - v1.y * v2.x;
		return atan2(perpDot, v1.dot(v2));
	}

	/**
	Calculate the unit vector in the direction of this Vector2D.
	*/
	const auto direction() {
		auto mag = magnitude();
		return (mag) ? (this * (1.0/mag)) : Vector2D!T();
	}

	unittest {
		auto v1 = Vector(1,0);
		assert(v1.direction == v1);
	}

}
