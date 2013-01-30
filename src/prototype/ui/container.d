
module prototype.ui.container;

import prototype.core;


/**

*/
interface IContainer : GameObject
{
	int getWidth();
	int getHeight();
	void setWidth(int w);
	void setHeight(int h);

	void setLocation(int x, int y);
	Point getLocation();
	void setSize(int w, int h);
	Point getSize();
}

enum LayoutMode
{
	VERTICAL,
	HORIZONTAL
}

enum SizeMode
{
	FILL_PARENT,
	WRAP_CONTENT
}

/**

*/
mixin template ContainerMixin()
{
	int getWidth() { return rect.w; }

	int getHeight() { return rect.h; }

	void setWidth(int w) { rect.w = w; }

	void setHeight(int h) { rect.h = h; }

	void setLocation(int x, int y) {
		rect.x = x; rect.y = y;
	}

	Point getLocation() {
		return tuple(rect.x, rect.y);
	}

	void setSize(int w, int h) {
		rect.w = w; rect.h = h;
	}

	Point getSize() {
		return tuple(rect.w, rect.h);
	}
}



/**

*/
class Container : IContainer
{
	private {
		SDL_Rect rect;
		LayoutMode layoutMode;
		Container parent;
		Container[] children;
	}
	int padding = 4;

	this(Container parent = null, LayoutMode layoutMode = LayoutMode.VERTICAL) {
		this.parent = parent;
		this.layoutMode = layoutMode;
	}

	void add(Container child) {
		children ~= [child];
		// TODO:
		resize();
	}

	void resize() {
		if (layoutMode == LayoutMode.VERTICAL) {
			resizeVertical();
		} else {
			resizeHorizontal();
		}
	}

	private void resizeVertical() {
		int childHeight = cast(int)(rect.h - (padding * (children.length + 1))/children.length);
		int x = 0;
		int y = padding;
		foreach (child; children) {
			x += padding;
			child.setLocation(x,y);
			child.setHeight(childHeight);
			child.setWidth(rect.w);
			x += childHeight;
		}
	}

	private void resizeHorizontal() {
		// TODO
	}

	void onEvent(SDL_Event event) {
		// TODO
	}

	void draw(Graphics g) {
		foreach(child; children) {
			child.draw(g);
		}
	}

	void update(long delta) {
		foreach(child; children) {
			child.update(delta);
		}
	}

	bool isAlive() { return true; }

	mixin ContainerMixin;
}


