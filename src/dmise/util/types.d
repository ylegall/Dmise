module dmise.util.types;

import dmise.core;

/**
A 2D point in space.
*/
struct PointT(T)
{
	T x, y;
}
alias PointT!real Point;
alias PointT!int Coord;

/**
A 2D Dimension with a width and height.
*/
struct DimensionT(T)
{
	T w, h;
}
alias DimensionT!real Dimension;
alias DimensionT!int Size;

/**
Set the size of an SDL_Rect.
*/
auto setSize(SDL_Rect rect, Size s)
{
	rect.h = s.h;
	rect.w = s.w;
}

/**
Set the location of an SDL_Rect.
*/
auto setLocation(SDL_Rect rect, Point p)
{
	rect.x = cast(int)p.x;
	rect.y = cast(int)p.y;
}

/**
Set the location of an SDL_Rect.
*/
auto setLocation(SDL_Rect rect, int x, int y)
{
	rect.x = x;
	rect.y = y;
}

/**
Get the center point of a rectangle.
*/
auto getCenterPoint(SDL_Rect rect) {
	//return SDL_Point(rect.x + rect.w/2, rect.y + rect.h/2);
	return Vector(rect.x + rect.w/2, rect.y + rect.h/2);
}

/**
Convert a Point and a Size to an SDL_Rect.
TODO: unittest
*/
auto getRect(Point p, Size s)
{
	return SDL_Rect(
		cast(int)p.x,
		cast(int)p.y,
		s.w,
		s.h
	);
}

/**
TODO: unittest
*/
auto getSDLRect(T)(T x, T y, T w, T h) {
	static if(is(T : int)) {
		return SDL_Rect(x, y, w, h);
	} else {
		return SDL_Rect(
			cast(int)x,
			cast(int)y,
			cast(int)w,
			cast(int)h
		);
	}
}

/**
Get a Point from an SDL_Rect.
TODO: unittest
*/
auto getPoint(SDL_Rect rect) {
	return Point(rect.x, rect.y);
}

/**
Get a Size from an SDL_Rect.
TODO: unittest
*/
auto getSize(SDL_Rect rect) {
	return Size(rect.w, rect.h);
}

