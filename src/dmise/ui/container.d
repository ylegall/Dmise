module dmise.ui.container;

import dmise.core;
import dmise.util.types;


/**
A simple container to control the layout of ui components.
*/
interface IContainer : GameObject
{
	int getWidth();
	int getHeight();
	void setWidth(int w);
	void setHeight(int h);

	void setLocation(int x, int y);
	Coord getLocation();
	void setSize(int w, int h);
	Size getSize();
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
Implements basic container logic.
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
		return Coord(rect.x, rect.y);
	}

	void setSize(int w, int h) {
		rect.w = w; rect.h = h;
	}

	void setSize(Coord c) {
		rect.w = c.w;
		rect.h = c.h;
	}

	Size getSize() {
		return Size(rect.w, rect.h);
	}
}


/**
Default container implementation.
*/
class Container : IContainer
{
	mixin ContainerMixin;

	private {
		SDL_Rect rect;
		LayoutMode layoutMode;
		SizeMode sizeMode;
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

	// TODO: add logic for alignment
	void resize() {
		if (layoutMode == LayoutMode.VERTICAL) {
			resizeVertical();
		} else {
			resizeHorizontal();
		}
	}

	private void resizeVertical() {
		int childHeight = cast(int)(rect.h - (padding * (children.length + 1))/children.length);
		int x = padding;
		int y = 0;
		foreach (child; children) {
			y += padding;
			child.setLocation(x,y);
			if (sizeMode == SizeMode.FILL_PARENT) {
				child.setHeight(childHeight);
				y += childHeight;
			} else {
				y += child.getHeight();
			}
			child.setWidth(rect.w);
		}
	}

	private void resizeHorizontal() {
		// calculate the width for each component:
		int childWidth = cast(int)(rect.w - (padding * (children.length + 1))/children.length);
		int x = 0;
		int y = padding;
		foreach (child; children) {
			x += padding;
			child.setLocation(x,y);
			if (sizeMode == SizeMode.FILL_PARENT) {
				child.setWidth(childWidth);
				x += childWidth;
			} else {
				x += child.getWidth();
			}
			child.setHeight(rect.h);
		}
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
}


