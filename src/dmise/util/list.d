
module dmise.util.list;

import std.array;
import std.exception;
import core.memory;

version (unittest) {
	import std.stdio;
}

/**
Implements a basic linked list with constant time append and remove operations.
*/
class LinkedList(T)
{
	private struct Node
	{
		T val;
		Node* next;
	}

	private {
		Node* head;
		Node* tail;
		size_t size;
	}

	this() {
		clear();
	}

	this(T[] items ...) {
		this();
		add(items);
	}

	/// clear all items from this list.
	auto clear() {
		Node* temp;
		Node* current = head;
		while (current) {
			temp = current;
			current = current.next;
			deleteNode(temp);
		}
		head = tail = null;
		this.size = 0;
	}
	unittest {
		auto list = new LinkedList!int();
		list.add(1,2,3);
		list.clear();
		assert(list.isEmpty());
	}

	// utility function to allocate a new Node
	private auto newNode(T val, Node* next = null) {
		Node* node = cast(Node*)GC.malloc(Node.sizeof);
		node.val = val;
		node.next = next;
		return node;
	}

	// utility function to deallocate a Node
	private auto deleteNode(Node* node) {
		GC.free(cast(void*)node);
	}

	/// get the number of elements in this LinkedList.
	@property
	auto length() const {
		return this.size;
	}
	unittest {
		auto list = new LinkedList!int();
		assert(list.length == 0);
		list.add(1,2,3);
		assert(list.length == 3);
	}

	/// determine if this list is empty.
	bool isEmpty() const {
		return size == 0;
	}
	unittest {
		auto list = new LinkedList!int();
		assert(list.isEmpty());
		list.add(3);
		assert(!list.isEmpty());
	}

	/// add one or more items to this list.
	auto add(T[] items ...) {
		if (size == 0) {
			head = tail = newNode(items[0]);
			items = items[1 .. $];
			++size;
		}
		foreach (item; items) {
			_add(item);
		}
	}

	private auto _add(T item) {
		auto node = newNode(item);
		tail.next = node;
		tail = tail.next;
		++size;
	}
	unittest {
		auto list = new LinkedList!int();
		list.add(1);
		assert(list.length == 1);
		list.add(2,3,4,5,6);
		assert(list.length == 6);
	}

	// adds support for 'foreach' statements
	int opApply(int delegate(ref T) dg) {
		int result = 0;
		Node* current = head;
		while (current) {
			result = dg(current.val);
			if (result) {
				break;
			}
			current = current.next;
		}
		return result;
	}
	unittest {
		auto array = [1,2,3,4,5];
		auto list = new LinkedList!int(1,2,3,4,5);
		int i = 0;
		foreach (item; list) {
			assert(item == array[i]);
			++i;
		}
		assert(i == 5);
	}

	/**
	Gets an iterator for this list which can be used to traverse
	elements and remove elements in O(1) time.
	*/
	auto getIterator() {
		return new Iterator(head);
	}

	override
	string toString() {
		import std.conv;
		auto str = appender("[");
		Node* current = head;
		if (current) {
			str.put(text(current.val));
			current = current.next;
		}
		while (current) {
			str.put(",");
			str.put(text(current.val));
			current = current.next;
		}
		str.put("]");
		return str.data;
	}
	unittest {
		auto list = new LinkedList!int(1,2,3,4,5);
		assert(list.toString == "[1,2,3,4,5]");
		list = new LinkedList!int();
		assert(list.toString == "[]");
	}

	/// provides an iterator for traversal and deletion
	class Iterator {
		Node* prev;
		Node* current;
		Node dummy;

		this(Node* node = head) {
			dummy.next = node;
			current = &dummy;
			prev = current;
		}

		/// return true if this iterator has more items.
		bool hasNext() {
			return current.next != null;
		}

		/// get the current list element.
		T next() {
			enforce(current, "current list node is null.");
			prev = current;
			current = current.next;
			return current.val;
		}

		/// remove and return the current list element:
		T remove() {
			enforce(current, "current list node is null.");
			Node* oldNode = current;
			auto result = oldNode.val;
			if (current == head) {
				head = head.next;
			} else if (current == tail) {
				tail = prev;
			}
			prev.next = current.next;
			current = prev;
			deleteNode(oldNode);
			--size;
			return result;
		}
	}

	// test iteration
	unittest {
		auto array = [1,2,3,4,5];
		auto list = new LinkedList!int(1,2,3,4,5);
		auto it = list.getIterator();
		auto i = 0;
		while (it.hasNext()) {
			auto item = it.next();
			assert(item == array[i]);
			++i;
		}
	}

	// test removal
	unittest {
		auto array = [1,2,3,4,5];
		auto list = new LinkedList!int(1,2,3,4,5);
		auto it = list.getIterator();
		auto i = 0;
		while (it.hasNext()) {
			auto item = it.next();
			assert(item == array[i]);
			it.remove();
			++i;
		}
		// writeln(list);
		assert(list.isEmpty());
	}
}

