
module util.stack;

import std.string;
import std.conv;

interface Stack(T)
{
	void push(T item);

	T pop();

	T peek();
}

class Stack(T)
{
	T[] data;
	size_t size;

	this(size_t cap = 8) {
		data.length = cap;
		size = 0;
	}

	void push(T item) {
		if (size >= data.length) {
			data.length *= 2;
		}
		data[size] = item;
		size++;
	}
	alias push add;

	T pop() {
		if (size < data.length/2) {
			data.length /= 2;
		}
		size--;
		return data[size];
	}

	@property
	auto length() { return size; }

	override
	string toString() {
		return to!string(data[0..size]);
	}

	void opOpAssign(string op)(T item) {
		static if (op == "+") {
			push(item);
		}
	}

	void opIndexAssign(T item, size_t index) {
		data[index] = item;
	}

	void opIndexOpAssign(string op)(T item, size_t index) {
		mixin("data[index]" ~ op ~ "= item;");
	}

	int opApply(int delegate (ref T) d) {
		int result = 0;
		for (int i=0; i < size; ++i) {
			result = d(data[i]);
			if (result) return result;
		}
		return result;
	}
}


version (single)
{
	import std.stdio;
	void main()
	{
		auto s = new Stack!int();

		foreach (i; 0 .. 10) {
			s.push(i);
		}
		writeln(s);

		foreach (item; s) {
			writeln("item = ", item);
		}
	}
}

