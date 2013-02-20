
module dmise.game;

import dmise.entity;
import dmise.core;
import dmise.texture;
import dmise.util.stack;
import dmise.util.list;

//import std.container;

class Game : GameState {

	private
	{
		bool isRunning = true;
		Texture sprite;
	}

	PlayerShip playerShip;
	LinkedList!(Entity) entities;

	this() {
		debug writeln("[game] this()");
		playerShip = new PlayerShip(this);
		entities = new LinkedList!(Entity)();

		debug writeln("[game] draw() loading graphics..");
		sprite = getTexture(getGraphics(), "ship-0.gif");
	}

	~this() {
		foreach (entity; entities) {
			delete entity;
		}
		entities.clear();
	}

	void addProjectile(Projectile p) {
		entities.add(p);
	}

	void draw(Graphics g) {
		foreach (entity; entities) {
			entity.draw(g);
		}
		playerShip.draw(g);
	}

	void update(long delta) {
		auto it = entities.getIterator();
		while (it.hasNext()) {
			auto entity = it.next();
			if (entity.isAlive()) {
				entity.update(delta);
			} else {
				it.remove();
			}
		}

		playerShip.update(delta);
	}

	void onEvent(SDL_Event event) {
		playerShip.onEvent(event);
	}

	bool isAlive() {
		return isRunning;
	}
}

