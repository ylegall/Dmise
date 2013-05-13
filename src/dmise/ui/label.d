
module dmise.ui.label;

import dmise.core;
import dmise.ui.container;
import dmise.util.types;

/**
A simple label for displaying text on a rectanglular background.
*/
class Label : AbstractContainer, GameObject
{
	private {
		string text;
		TTF_Font* font;
		SDL_Texture* texture;
	}

	int padding = 4;
	SDL_Rect textLocation;
	bool hasBackground = true;
	bool hasBorder = false;
	SDL_Color bgColor = Colors.DARK_GRAY;
	SDL_Color fgColor = Colors.DEFAULT_TEXT;

	this(string text, TTF_Font* f = null) {
		this.text = text.idup;
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
		rect.h = textLocation.h + 2*padding;
		rect.w = textLocation.w + 2*padding;
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

	override
	void setLocation(int x, int y) {
		rect.x = x;
		rect.y = y;
		textLocation.x = rect.x + padding;
		textLocation.y = rect.y + padding;
	}

	void onEvent(SDL_Event event) {}
	void update(long delta) {}

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
