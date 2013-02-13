module dmise.ui.container;

import dmise.core;
import dmise.util.types;


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
abstract class AbstractContainer
{
	protected SDL_Rect rect;

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

	void setRect(int x, int y, int w, int h) {
		rect.x = x;
		rect.y = y;
		rect.w = w;
		rect.h = h;
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
alias AbstractContainer BaseContainer;


/**
Default container implementation.
*/
class Container : AbstractContainer
{
	private {
		Alignment alignment;
		BaseContainer parent;
		BaseContainer[] children;
	}

	LayoutMode layoutMode;
	SizeMode sizeMode;
	int padding = 4;

	this(BaseContainer parent = null,
		LayoutMode layoutMode = LayoutMode.VERTICAL,
		SizeMode = SizeMode.FILL_PARENT,
		Alignment = Alignment.LEFT)
	{
		this.parent = parent;
		this.layoutMode = layoutMode;
		this.sizeMode = sizeMode;
		this.alignment = alignment;
	}

	void add(BaseContainer[] child ...) {
		children ~= child;
	}

	void setLayoutMode(LayoutMode layoutMode) {
		this.layoutMode = layoutMode;
	}

	void setSizeMode(SizeMode sizeMode) {
		this.sizeMode = sizeMode;
	}

	void setAlignment(Alignment alignment) {
		this.alignment = alignment;
	}

	void resize() {
		int x = rect.x;
		int y = rect.y;
		int childHeight = cast(int)((rect.h - (padding * (children.length + 1))) / children.length);
		//writeln("[resize] child height = ", childHeight);
		int childWidth = cast(int)((rect.w - (padding * (children.length + 1))) / children.length);

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

	private auto alignHorizontal(BaseContainer c) {
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

	private auto alignVertical(BaseContainer c) {
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

