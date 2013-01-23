
module prototype.ui.label;

import prototype.core;

class Label : GameObject
{
	private {
		string text;
		int padding = 4;
		SDL_Rect rect;
		SDL_Rect textLocation;
		TTF_Font* font;
		SDL_Texture* texture;
	}

	bool hasBackground = true;
	bool hasBorder = false;
	SDL_Color bgColor = Colors.SELECTED;
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
		TTF_SizeText(font, text.ptr, &rect.w, &rect.h);
		rect.h += 2*padding;
		rect.w += 2*padding;
		writeln("label width =", rect.w);
		writeln("label height =", rect.h);

		SDL_Rect textLocation = rect;
		textLocation.x += padding;
		textLocation.y += padding;
	}

	bool isAlive() {
		return true;
	}

	void setBgColor(SDL_Color bgColor) {
		this.bgColor = bgColor;
	}

	void setFgColor(SDL_Color fgColor) {
		this.fgColor = fgColor;
	}

	void setPadding(int padding) {
		this.padding = padding;
		resize();
	}

	void setLocation(int x, int y) {
		rect.x = x;
		rect.y = y;
	}

	void setSize(int width, int height) {
		rect.w = width;
		rect.h = height;
	}

	void setRect(SDL_Rect rect) {
		this.rect = rect;
	}

	void onEvent(SDL_Event event) {

	}

	void update(double delta) {

	}

	void draw(Graphics g) {
		// render the background
		if (hasBackground) {
			SDL_RenderFillRect(g.renderer, &rect);
		}
		// render the text
		SDL_RenderCopy(g.renderer, texture, null, &rect);
	}

}