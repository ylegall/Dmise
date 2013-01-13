
module prototype.util.point;

import std.math;

struct Point
{
	double x, y;

	double distanceTo(Point other) {
		//auto dx = other.x - x;
		//auto dy = other.y - y;
		//return sqrt(dx*dx + dy*dy);
		return getDistance(this, other);
	}

	auto opBinary(string op)(Point other) {
		static if (op == "+")
			return Point(other.x + x, other.y + y);
		else static if (op == "-")
			return Point(other.x - x, other.y - y);
		else static if (op == "*")
			return Point(other.x - x, other.y - y);
		else static if (op == "/")
			return Point(other.x / x, other.y / y);
		else static assert(0, "Operator "~op~" not implemented");
	}

	void opOpAssign(string op)(Point other) {
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

    string toString() {
		return std.string.format("Point(%f,%f)",x ,y);
    }

}

double getDistance(Point a, Point b) {
	double dx = (b.x - a.x);
	double dy = (b.y - a.y);
	return sqrt(dx*dx + dy*dy);
}

