module dmise.game;

import dmise.entity;
import dmise.camera;
import dmise.core;
import dmise.texture;
import dmise.util.stack;
import dmise.util.list;


class Game : GameState {

	private
	{
		bool isRunning = true;
		SDL_Rect bgRect;
	}

	Camera camera;
	PlayerShip playerShip;
	LinkedList!(Entity) entities;

	this() {
		debug writeln("[game] this()");
		playerShip = new PlayerShip(this);
		camera = new Camera();
		entities = new LinkedList!(Entity)();
		bgRect = SDL_Rect(0,0, gameInfo.width, gameInfo.height);
	}

	~this() {
		/* hdon sez gc
                foreach (entity; entities) {
			delete entity;
		}
		entities.clear();
		delete playerShip;
		delete camera;*/
	}

	void addProjectile(Projectile p) {
		entities.add(p);
	}

	void draw(Graphics g) {

		// draw the background. eventually this may be different for each level:
		//SDL_RenderCopy(g.renderer, background, null, &bgRect);
		camera.draw(g);

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
		camera.update(delta);
		camera.setPosition(playerShip.getPosition());
		// update background
	}

	void onEvent(SDL_Event event) {
		playerShip.onEvent(event);
	}

	bool isAlive() {
		return isRunning;
	}
}

