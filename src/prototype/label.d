
module prototype.label;

import prototype.core;

class Label : GameObject
{
	private {
		string text;
		SDL_Rect rect;
		SDL_Color bgColor;
		SDL_Color fgColor;
		TTF_Font* font;
	}

	this(string text, TTF_Font* font = null) {
		this.text = text;
		if (!font) {
			font = getGraphics().font;
		}
		resize();
	}

	private void resize() {
		TTF_SizeText(font,"Hello World!",&rect.w, &rect.h);
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
		//SDL_BlitSurface(glyph,NULL,screen,&rect);
	}

}