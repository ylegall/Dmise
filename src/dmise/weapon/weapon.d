
module dmise.weapon.weapon;

import dmise.core;
import dmise.texture;

/**

*/
abstract class Weapon : Updateable
{
	protected {
		int ammo;
		Mix_Chunk* sound;
	}

	this(string soundFile) {
		sound = loadSound(soundFile);
		enforce(sound, soundFile ~ " sound is null");
	}

	~this() {
		Mix_FreeChunk(sound);
	}

	bool isEmpty() {
		return ammo == 0;
	}

	override
	void update(long delta) {}

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

	this() {
		super("shot1.wav");
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
		playSound(sound);
		return new DefaultShot(pos, dir);
	}
}

/**
The projectile for the standard weapon.
TODO: rename
*/
class DefaultShot : Projectile
{
	enum MAX_SPEED = 200.0/64.0;
        Vec heading;

	private {
		Texture texture;
		SDL_Rect rect;
	}

	this(Vec pos, Vec dir) {
                heading = dir;
		super(pos, dir * MAX_SPEED);
		texture = getTexture(getGraphics(), "blueShot-1.png");
	}

	override
	void update(long delta) {
                super.update(delta);
		this.vel *= 0.92; // "delta" should factor into deceleration
	}

	override
	void draw(Graphics g) {
		rect = SDL_Rect(cast(int)pos.x, cast(int)pos.y, 32, 32);
		rect.h = cast(int)(32 + getSpeed()*32);
		rect.x = cast(int)pos.x;
		rect.y = cast(int)pos.y - rect.h/2;

		auto angle = radiansToDegrees(atan2(vel.x, -vel.y));
		SDL_SetTextureAlphaMod(texture, cast(ubyte) (255 * (getSpeed/MAX_SPEED)) );
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
		return this.vel.magnitude() > 1;
	}

        real getSpeed() {
          return this.vel.magnitude();
        }
}


