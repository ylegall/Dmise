
module prototype.util.menu;

class Menu(T)
{
	private uint index;
	private T[] items;

	this(T[] items) {
		index = 0;
		this.items = items;
	}

	void next() {
		index++;
		index %= items.length;
		debug_menu();
	}

	void prev() {
		index--;
		if (index < 0) {
			index += items.length;
		}
		debug_menu();
	}

	@property
	T active() {
		debug_menu();
		return items[index];
	}

	uint getIndex() {
		return index;
	}

	int opApply (int delegate(ref T ) dg)
	{
		int result = 0;
		foreach (i; items) {
			result = dg(i);
			if (result) break;
		}
		return result;
	}
}

