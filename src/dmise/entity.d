module dmise.entity;

import dmise.core;
import dmise.game;
import dmise.texture;
import dmise.util.types;
import dmise.util.vector;

alias Vector2D!() Vec;

/**
An Entity is a Game object with a position vector.
*/
abstract class Entity : GameObject {
	Vec pos;
	this(Vec pos) {
		this.pos = pos;
	}
	void draw(Graphics g) {}
	void update(long delta) {}
	void onEvent(SDL_Event event) {}
	bool isAlive() { return true; }
}

/**
A MovingEntity has both position and velocity vectors.
*/
class MovingEntity : Entity {
	Vec vel;
	this(Vec pos, Vec vel) {
		super(pos);
		this.vel = vel;
	}
	override void draw(Graphics g) {}

	override void update(long delta) {
		this.pos += this.vel * (cast(real)delta/5.0);
		super.update(delta);
	}
}

/**
Rotation types.
*/
enum Rotation
{
	NONE,
	CLOCKWISE,
	COUNTER_CLOCKWISE
}

/**

*/
class PlayerShip : MovingEntity
{
	protected {
		Vec dir;                      // the ship's acceleration vector
		real angle;                   // the ship's angle in degrees
		real friction;                // not sure if we will use this.
		Rotation rotation;            // rotation direction
		SDL_Rect rect;
		bool isBoosting;
		bool isFiring;
		Texture shipTexture;
		int propulsionVisualPower = 0;

		auto shields = 100;
		auto hullIntegrity = 100;
		auto MAX_VELOCITY = 36;       // TODO: load from configuration
		enum rotationSpeed = 0.03;    // TODO: load from configuration

		enum sinCoef = sin(rotationSpeed);
		enum cosCoef = cos(rotationSpeed);

		Weapon[] weapons;
		uint weaponIndex = 0;
	}

	Game game;

	// TODO: better way to insert projectiles
	this(Vec pos, Vec vel, Game game) {
		super(pos, vel);
		rect = SDL_Rect(0, 0, 48, 48);
		shipTexture = getTexture(getGraphics(), "ship-0.gif");
		dir = Vector(0,-1);

		weapons = [new DefaultWeapon()];

		this.game = game;
	}

	this(Game game) {
		this(Vec(100.0, 100.0), Vec(0.0, 0.0), game);
	}

	~this() {
		SDL_DestroyTexture(shipTexture);
	}

	override void update(long delta) {

		// update the selected weapon:
		weapons[weaponIndex].update(delta);
		auto weapon = weapons[weaponIndex];

		if (weapon.canFire() && isFiring) {
			// get the mouse position:
			Coord mouse = getMousePosition();
			auto center = pos;
			auto v = Vector(mouse.x - center.x, mouse.y - center.y).direction();
			game.addProjectile(weapon.fire(center, v));
			//game.addProjectile(weapon.fire(getCenterPoint(rect), v));
		}

		// update the direction by applying rotation matrix:
		final switch (rotation) {
			case Rotation.CLOCKWISE:
				dir.x = (dir.x * cosCoef) - (dir.y * sinCoef);
				dir.y = (dir.x * sinCoef) + (dir.y * cosCoef);
				break;
			case Rotation.COUNTER_CLOCKWISE:
				dir.x = (dir.x * cosCoef) + (dir.y * sinCoef);
				dir.y = -(dir.x * sinCoef) + (dir.y * cosCoef);
				break;
			case Rotation.NONE:
				break;
		}

		// normalize the direction vector
		dir = dir.direction();

		if (isBoosting) {
			vel += (dir * (delta / 1000.0));

			// limit the maximum velocity:
			if (vel.magnitude() > MAX_VELOCITY) {
				vel = vel.direction() * MAX_VELOCITY;
			}
		}

		super.update(delta);
	};

	override void draw(Graphics g) {
		rect.x = cast(int)pos.x - rect.w/2;
		rect.y = cast(int)pos.y - rect.h/2;

		//SDL_RenderCopy(g.renderer, shipTexture, null, &rect);

		auto angle = radiansToDegrees(atan2(dir.x, -dir.y));

        if (isBoosting)
            propulsionVisualPower = min(propulsionVisualPower+1, 60);
        else
            propulsionVisualPower = max(propulsionVisualPower-1, 0);

        // TODO: can the getTexture() be called in the contructor to preload the textures?
		SDL_RenderCopyEx(g.renderer, getTexture(g, "ship-0.gif",
                    propulsionVisualPower/10).texture, null, &rect, angle, null, SDL_FLIP_NONE);
	};

	void onKeyPress(SDL_KeyboardEvent keyEvent) {
		switch (keyEvent.keysym.sym) {
			case 'w':
				isBoosting = true;
				break;
			case 's':
				// TODO: lower speed if player ship has that upgrade
				break;

			case 'a':
				rotation = Rotation.COUNTER_CLOCKWISE;
				break;
			case 'd':
				rotation = Rotation.CLOCKWISE;
				break;
			default:
				break;
		}
	}

	void onKeyRelease(SDL_KeyboardEvent keyEvent) {
		switch (keyEvent.keysym.sym) {
			case 'w':
				isBoosting = false;
				break;
			case 's':
				break;
			case 'a':
			case 'd':
				rotation = Rotation.NONE;
				break;
			default:
				break;
		}
	}

	void onMouseButtonDown(SDL_MouseButtonEvent mouseEvent) {
		//debug writeln("[PlayerShip] onMouseButtonDown()");
		isFiring = true;
	}

	void onMouseButtonUp(SDL_MouseButtonEvent mouseEvent) {
		//debug writeln("[PlayerShip] onMouseButtonUp()");
		isFiring = false;
		weapons[weaponIndex].prepare();
	}

	override void onEvent(SDL_Event event) {
		switch (event.type) {
			case SDL_KEYUP:
				onKeyRelease(event.key);
				break;
			case SDL_KEYDOWN:
				onKeyPress(event.key);
				break;

			case SDL_MOUSEBUTTONDOWN:
				onMouseButtonDown(event.button);
				break;

			case SDL_MOUSEBUTTONUP:
				onMouseButtonUp(event.button);
				break;

			default:
				break;
		}
	}
}

