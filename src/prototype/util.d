
module prototype.util;

import prototype.core;

import std.traits;
import std.algorithm;

auto centerHorizontal(ref SDL_Rect rect) {
	rect.x = (prototype.core.gameInfo.width)/2 - rect.w/2;
}	

struct Stack(T)
{
	struct Node {
		T data;
		Node* prev;
	}

	private size_t size;
	Node* top;

	this() {
		size = 0;
		top = null;
	}

	T pop() {
		assert(size > 0, "stack is empty");
		auto node = top;
		top = top.prev;
		--size;
		auto retval = node.data;
		delete node;
		return retval;
	}

	void push(T item) {
		Node node = { item, top };
		++size;
		top = node;
	}

	T peek() { assert(size > 0, "stack is empty"); return top.data; }

	@property
	auto length() { return size; }
	
	bool isEmpty() { return size == 0; }
}