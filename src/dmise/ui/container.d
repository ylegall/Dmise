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

/**
Determine how child components are sized.
*/
enum LayoutMode
{
	VERTICAL,
	HORIZONTAL
}

/**
Determine how child components are sized.
*/
enum SizeMode
{
	FILL_PARENT,
	WRAP_CONTENT
}

/**
Determine how child components positioned.
*/
enum Alignment
{
	LEFT,
	CENTER,
	RIGHT
}

/**
Implements basic container logic.
*/
mixin template ContainerMixin()
{
	int getWidth() {
		return rect.w;
	}

	int getHeight() {
		return rect.h;
	}

	void setWidth(int w) {
		rect.w = w;
	}

	void setHeight(int h) {
		rect.h = h;
	}

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
		Alignment alignment;
		Container parent;
		Container[] children;
	}
	LayoutMode layoutMode;
	SizeMode sizeMode;
	int padding = 4;

	this(Container parent = null, LayoutMode layoutMode = LayoutMode.VERTICAL) {
		this.parent = parent;
		this.layoutMode = layoutMode;
	}

	void add(Container[] child ...) {
		children ~= child;
		resize();
	}

	void resize() {
		int x = 0;
		int y = 0;
		int childHeight = cast(int)(rect.h - (padding * (children.length + 1)) / children.length);
		int childWidth = cast(int)(rect.w - (padding * (children.length + 1)) / children.length);

		foreach (child; children) {
			if (layoutMode == LayoutMode.VERTICAL) {
				y += padding;
				if (sizeMode == SizeMode.FILL_PARENT) {
					child.setWidth(rect.w);
				}
				x = alignHorizontal(child);
				child.setHeight(childHeight);
				y += childHeight;
			} else {
				x += padding;
				if (sizeMode == SizeMode.FILL_PARENT) {
					child.setHeight(rect.h);
				}
				y = alignVertical(child);
				child.setWidth(childWidth);
				x += childWidth;
			}
			child.setLocation(x,y);
		}
	}

	private auto alignHorizontal(Container c) {
		auto base = rect.x + padding;
		final switch (alignment) {
			case LEFT:
				return c.x = base;
			case CENTER:
				return c.x = rect.w/2 - c.getWidth()/2;
			case RIGHT:
				return c.x = rect.x + rect.w - padding - c.getWidth();
		}
	}

	private auto alignVertical(Container c) {
		auto base = rect.y + padding;
		final switch (alignment) {
			case LEFT:
				return c.y = base;
			case CENTER:
				return c.y = rect.h/2 - c.getHeight()/2;
			case RIGHT:
				return c.y = rect.y + rect.h - padding - c.getHeight();
		}
	}
}

