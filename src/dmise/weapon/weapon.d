
module dmise.weapon.weapon;

import dmise.core;
import dmise.texture;

/**

*/
abstract class Weapon : Updateable
{
	protected {
		int ammo;
	}

	this() {

	}

	bool isEmpty() {
		return ammo == 0;
	}

	override
	void update(long delta) {
		// TODO: e.g. update reload time
	}

	bool canFire();

	void prepare() {}

	/// fire and return a projectile
	Projectile fire(Vector pos, Vector vel);
}


/**

*/
abstract class Projectile : MovingEntity
{
	this(Vec pos, Vec vel) {
		super(pos, vel);
	}

	int getDamage() { return 0; }
}



/**
The standard weapon with which the player is equipped.
*/
class DefaultWeapon : Weapon
{
	private {
		int reloadTime = 0;
	}

	override
	void update(long delta) {
		if (reloadTime < 0) {
			reloadTime = 0;
		} else if (reloadTime > 0) {
			reloadTime -= delta;
		}
	}

	override
	bool canFire() {
		return reloadTime == 0;
	}

	override
	bool isEmpty() {
		return false;
	}

	override
	DefaultShot fire(Vector pos, Vector dir) {
		reloadTime = 256;
		return new DefaultShot(pos, dir);
	}
}

/**
The projectile for the standard weapon.
TODO: rename
*/
class DefaultShot : Projectile
{
	enum MAX_SPEED = 200.0;
	private {
		Texture texture;
		SDL_Rect rect;
		real speed = MAX_SPEED;
	}

	this(Vec pos, Vec dir) {
		super(pos, dir);
		texture = getTexture(getGraphics(), "blueShot-1.png");
		//rect = SDL_Rect(cast(int)pos.x, cast(int)pos.y, 32, speed);
		rect = SDL_Rect(cast(int)pos.x, cast(int)pos.y, 32, 32);
	}

	override
	void update(long delta) {
		this.speed *= 0.92;
		this.pos += (this.vel * (speed * delta/64 ));
		rect.x = cast(int)pos.x;
		rect.y = cast(int)pos.y;
		rect.h = cast(int)(32 + speed/2);
		//rect.h = cast(int)(max(32,speed/2));
	}

	override
	void draw(Graphics g) {
		auto angle = radiansToDegrees(atan2(vel.x, -vel.y));
		SDL_SetTextureAlphaMod(texture, cast(ubyte) (255 * (speed/MAX_SPEED)) );
		SDL_RenderCopyEx(
			g.renderer,
			texture,
			null,
			&rect,
			angle,
			null,
			SDL_FLIP_NONE);
	}

	override
	bool isAlive() {
		return speed > 1;
	}
}



