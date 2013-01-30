module prototype.types;

import prototype.core;

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
Convert a Point and a Size to an SDL_Rect.
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
Get a Point from an SDL_Rect.
*/
auto getPoint(SDL_Rect rect)
{
	return Point(rect.x, rect.y);
}

/**
Get a Size from an SDL_Rect.
*/
auto getSize(SDL_Rect rect)
{
	return Size(rect.w, rect.h);
}
