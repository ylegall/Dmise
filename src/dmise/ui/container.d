module dmise.ui.container;

import dmise.core;
import dmise.util.types;


/**
A simple container to control the layout of ui components.
*/
interface IContainer
{
	int getWidth();
	int getHeight();
	void setWidth(int w);
	void setHeight(int h);
	void setLocation(int x, int y);
	Coord getLocation();
	void setSize(int w, int h);
	Size getSize();
	@property int x(int x);
	@property int x();
	@property int y(int y);
	@property int y();
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

	@property
	int x(int x) {
		return rect.x = x;
	}
	@property
	int x() {
		return rect.x;
	}
	@property
	int y(int y) {
		return rect.y = y;
	}
	@property
	int y() {
		return rect.y;
	}

	void setLocation(int x, int y) {
		rect.x = x; rect.y = y;
	}

	Coord getLocation() {
		return Coord(rect.x, rect.y);
	}

	void setSize(int w, int h) {
		rect.w = w; rect.h = h;
	}

	void setSize(Size c) {
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
		IContainer parent;
		IContainer[] children;
	}
	LayoutMode layoutMode;
	SizeMode sizeMode;
	int padding = 4;

	this(IContainer parent = null, LayoutMode layoutMode = LayoutMode.VERTICAL) {
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

	private auto alignHorizontal(IContainer c) {
		auto base = rect.x + padding;
		final switch (alignment) {
			case Alignment.LEFT:
				return c.x = base;
			case Alignment.CENTER:
				return c.x = rect.w/2 - c.getWidth()/2;
			case Alignment.RIGHT:
				return c.x = rect.x + rect.w - padding - c.getWidth();
		}
	}

	private auto alignVertical(IContainer c) {
		auto base = rect.y + padding;
		final switch (alignment) {
			case Alignment.LEFT:
				return c.y = base;
			case Alignment.CENTER:
				return c.y = rect.h/2 - c.getHeight()/2;
			case Alignment.RIGHT:
				return c.y = rect.y + rect.h - padding - c.getHeight();
		}
	}
}

