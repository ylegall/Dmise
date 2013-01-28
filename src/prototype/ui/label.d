
module prototype.ui.label;

import prototype.core;

/**
A simple label for displaying text on a rectanglular background.
*/
class Label : GameObject
{
	private {
		string text;
		int padding = 4;
		SDL_Rect textLocation;
		TTF_Font* font;
		SDL_Texture* texture;
	}

	SDL_Rect rect;
	bool hasBackground = true;
	bool hasBorder = false;
	SDL_Color bgColor = Colors.DARK_GRAY;
	SDL_Color fgColor = Colors.DEFAULT_TEXT;

	this(string text, TTF_Font* f = null) {
		this.text = text;
		auto g = getGraphics();
		if (!f) {
			this.font = g.font;
		}
		texture = makeText(text, fgColor);
		resize();
	}

	~this() {
		SDL_DestroyTexture(texture);
	}

	private void resize() {
		TTF_SizeText(font, text.ptr, &textLocation.w, &textLocation.h);
		rect.h += 2*padding;
		rect.w += 2*padding;
		textLocation.x += padding;
		textLocation.y += padding;
	}

	bool isAlive() {
		return true;
	}

	void setBgColor(SDL_Color color) {
		this.bgColor = color;
	}

	void setFgColor(SDL_Color color) {
		this.fgColor = color;
	}

	void setPadding(int padding) {
		this.padding = padding;
		resize();
	}

	void setLocation(int x, int y) {
		rect.x = x;
		rect.y = y;
		textLocation.x = rect.x + padding;
		textLocation.y = rect.y + padding;
	}

	void setSize(int width, int height) {
		rect.w = width;
		rect.h = height;
	}

	@property
	auto height(int height) { return rect.h = height; }
	@property
	auto height() { return rect.h; }

	@property
	auto width(int width) { return rect.w = width; }
	@property
	auto width() { return rect.w; }

	void setRect(SDL_Rect rect) {
		this.rect = rect;
	}

	void onEvent(SDL_Event event) {

	}

	void update(long delta) {

	}

	void draw(Graphics g) {
		// render the background
		if (hasBackground) {
			//auto oldColor = getColor(g.renderer);
			setColor(g.renderer, bgColor);
			SDL_RenderFillRect(g.renderer, &rect);
			//setColor(g.renderer, oldColor);
		}
		// render the text
		SDL_RenderCopy(g.renderer, texture, null, &textLocation);
	}

}