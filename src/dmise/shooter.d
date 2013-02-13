module dmise.shooter;
import dmise.entity;
import dmise.core;
import dmise.texture;
import std.container;

class Shooter : GameState {
	PlayerShip playerShip;
	SList!(Entity) entities;

	this() {
		debug writeln("[shooter] this()");
		playerShip = new PlayerShip();
		entities.insert(playerShip);
	}

	/* TODO refactor this to occur elsewhere */
	bool loadedGraphics = false;
	Texture sprite;

	void draw(Graphics graphicsContext) {
		if (!loadedGraphics) {
			debug writeln("[shooter] draw() loading graphics..");
			sprite = getTexture(graphicsContext, "ship-0.gif", 0);
			loadedGraphics = true;
		}

		foreach (Entity entity; entities) {
			entity.draw(graphicsContext);
		}
	}

	void update(long delta) {
		foreach (Entity entity; entities) {
			entity.update(delta);
		}
	}

	void onEvent(SDL_Event event) {
		playerShip.onEvent(event);
	}

	bool isAlive() {
		return true;
	}
}
