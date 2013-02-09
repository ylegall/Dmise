module dmise.util.vector;

import std.math;
import std.traits;

/**
Implementation of a 2D vector.
*/
struct Vector2D(T=real)
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
	const auto opBinary(string op)(Vector2D!T other) {
		Vector2D!T result;
		result.x = mixin("this.x " ~ op ~ "other.x");
		result.y = mixin("this.y " ~ op ~ "other.y");
		return result;
	}

	/**
	Support binary operators.
	*/
	const auto opBinary(string op, C)(C c)
		if(isNumeric!C)
	{
		Vector2D!T result;
		result.x = mixin("this.x " ~ op ~ "c");
		result.y = mixin("this.y " ~ op ~ "c");
		return result;
	}

	/**
	Calculate the magnitude of this vector.
	@return the magnitude as a real.
	*/
	const auto magnitude() {
		return sqrt(this.dot(this));
	}

	/**
	Calculate the dot product of this Vector2D with another.
	@return the dot-product as a real.
	*/
	const auto dot(const Vector2D!T other) {
		return (x * other.x + y * other.y);
	}

	/**
	Calculate the dot product of this Vector2D with another.
	@return the dot-product as a real.
	*/
	void opOpAssign(string op, N)(N num)
		if (isNumeric!N)
	{
		mixin("this.x " ~ op ~ "= num");
		mixin("this.y " ~ op ~ "= num");
	}

	/**
	Get the Vector that is perpindicular to this Vector.
	*/
	const auto perpendicular() {
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
}
