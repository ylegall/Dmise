
module dmise.util.stack;

/**
Stack utility
*/
struct Stack(T)
{
	private	{
		struct Node	{
			T data;
			Node* prev;
		}

		size_t size = 0;
		Node* top = null;
	}

	T pop() {
		assert(size, "stack is empty");
		auto node = top;
		top = top.prev;
		--size;
		auto retval = node.data;
		//delete node;
		return retval;
	}

	void push(T item) {
		Node* node = new Node(item, top);
		++size;
		top = node;
	}

	T peek() {
		assert(size, "stack is empty");
		return top.data;
	}

	@property
	auto length() {
		return size;
	}

	bool isEmpty() {
		return size == 0;
	}
}

