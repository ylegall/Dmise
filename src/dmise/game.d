
module dmise.game;

import dmise.entity;
import dmise.core;
import dmise.texture;
import dmise.util.stack;

import std.container;

class Game : GameState {

	private
	{
		bool isRunning = true;
	}

	PlayerShip playerShip;
	SList!(Entity) entities;

	this() {
		debug writeln("[game] this()");
		playerShip = new PlayerShip();
		entities.insert(playerShip);
	}

	~this() {
		foreach (entity; entities) {
			delete entity;
		}
	}

	/* TODO refactor this to occur elsewhere */
	bool loadedGraphics = false;
	Texture sprite;

	void draw(Graphics graphicsContext) {
		if (!loadedGraphics) {
			debug writeln("[game] draw() loading graphics..");
			sprite = getTexture(graphicsContext, "ship-0.gif");
			loadedGraphics = true;
		}

		foreach (entity; entities) {
			entity.draw(graphicsContext);
		}
	}

	void update(long delta) {
		foreach (entity; entities) {
			entity.update(delta);
		}
	}

	void onEvent(SDL_Event event) {
		playerShip.onEvent(event);
	}

	bool isAlive() {
		return isRunning;
	}
}

