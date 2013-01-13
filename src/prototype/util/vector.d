
module prototype.util.vector;

import std.math;

struct Vector
{
	double x;
	double y;

	auto opBinary(string op)(Vector other) {
		static if (op == "+")
			return Vector(other.x + x, other.y + y);
		else static if (op == "-")
			return Vector(other.x - x, other.y - y);
		else static if (op == "*")
			return Vector(other.x - x, other.y - y);
		else static if (op == "/")
			return Vector(other.x / x, other.y / y);
		else static assert(0, "Operator "~op~" not implemented");
	}

	void opOpAssign(string op)(Vector other) {
		static if (op == "+") {
			x += other.x;
			y += other.y;
		} else static if (op == "-") {
			x -= other.x;
			y -= other.y;
		} else static if (op == "*") {
			x *= other.x;
			y *= other.y;
		} else static if (op == "/") {
			x /= other.x;
			y /= other.y;
		} else {
			static assert(0, "Operator "~op~" not implemented");
		}
	}

	double dot(Vector other) {
		return (x*other.x + y*other.y);
	}

	double magnitude() {
		return sqrt(this.dot(this));
	}

	Vector getPerpendicular() {
		return Vector(y,x);
	}

	Vector getScaled(T)(T amount) {
		return Vector(x*amount, y*amount);
	}

    Vector direction() {
        double mag = this.magnitude();
        return (mag == 0) ? Vector() : getScaled(1.0f / mag);
    }

	double distanceTo(Vector other) {
		return Vector(this - other).magnitude();
	}

    string toString() {
		return std.string.format("Vector(%f,%f)",x ,y);
    }
}

double signedAngle(Vector v1, Vector v2) {
	double perpDot = v1.x*v2.y - v1.y*v2.x;
	return atan2(perpDot, v1.dot(v2));
}


