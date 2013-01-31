
module dmise.animation.interpolate;

import std.traits;

template scale(T)
{
	T scale(T from, T to, real time)
	{
		return scaleImpl!T(from, to, time);
	}
}

private T scaleImpl(T)(T from, T to, real time)
	if (isNumeric!T)
{
	return cast(T)(from + (to - from) * time);
}

private T scaleImpl(T)(T from, T to, real time)
	if (is(T == struct))
{
	auto copy = from;
	auto froms = from.tupleof;
	auto tos = to.tupleof;
	foreach (i, ref val; copy.tupleof) {
		val = scaleImpl(froms[i], tos[i], time);
	}
	return copy;
}


private T scaleImpl(T)(T from, T to, real time)
	if (isArray!T)
{
	T copy = from;
	foreach(i; 0 .. from.length) {
		copy[i] = scaleImpl(from[i], to[i], time);
	}
	return copy;
}
