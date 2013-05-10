
module dmise.camera;

import dmise.core;
import dmise.entity;
import dmise.texture;
import dmise.util.types;

/**

*/
class Camera : GameObject
{

	private {
		Texture background;
		Coord pos;
		const w = gameInfo.width;
		const h = gameInfo.height;
	}

	this() {
		background = getTexture(getGraphics(), "bg.png");
	}

	~this() {
		delete background;
	}

	void setPosition(Vector2D!real p) {
		pos.x = cast(int)p.x;
		pos.y = cast(int)p.y;
	}

	override
	void draw(Graphics g) {

		// TODO: ship coordinates should wrap
		auto x = pos.x;
		if (x < 0) x += gameInfo.width;
		x %= gameInfo.width;
		auto y = pos.x;
		if (y < 0) y += gameInfo.height;
		y %= gameInfo.height;
		assert(x >= 0);
		assert(y >= 0);

		// top left
		SDL_Rect srcRect = getSDLRect(x, y, w-x, h-y);
		SDL_Rect dstRect = getSDLRect(0, 0, w-x, h-y);
		SDL_RenderCopy(g.renderer, background, &srcRect, &dstRect);

		// top right
		srcRect = getSDLRect(0, y, x, h-y);
		dstRect = getSDLRect(w-x, 0, x, h-y);
		SDL_RenderCopy(g.renderer, background, &srcRect, &dstRect);

		// bottom left
		srcRect = getSDLRect(x, 0, w-x, y);
		dstRect = getSDLRect(0, h-y, w-x, y);
		SDL_RenderCopy(g.renderer, background, &srcRect, &dstRect);

		// bottom right
		srcRect = getSDLRect(0, 0, x, y);
		dstRect = getSDLRect(w-x, h-y, x, y);
		SDL_RenderCopy(g.renderer, background, &srcRect, &dstRect);
	}

	override
	void update(long delta) {
	}

	void onEvent(SDL_Event event) {
	}

	bool isAlive() {
		return true;
	}
}

