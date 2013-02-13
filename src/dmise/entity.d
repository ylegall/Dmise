module dmise.entity;
import dmise.util.vector;
import dmise.core;
import dmise.texture;

alias Vector2D!() Vec;

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

class MovingEntity : Entity {
	Vec vel;
	this(Vec pos, Vec vel) {
		super(pos);
		this.vel = vel;
	}
	override void draw(Graphics g) {}

	override void update(long delta) {
		this.pos = this.pos + this.vel;
		super.update(delta);
	}
}

class PlayerShip : MovingEntity {
	this(Vec pos, Vec vel) {
		super(pos, vel);
		rect = SDL_Rect(0, 0, 17*2, 17*2);
	}
	this() {
		this(Vec(0.0, 0.0), Vec(0.0, 0.0));
	}

	override void update(long delta) {
		super.update(delta);
	};

	SDL_Rect rect;
	override void draw(Graphics graphicsContext) {
		// reder the logo:
		rect.x = cast(int)pos.x;
		rect.y = cast(int)pos.y;

                int frame = this.vel.x ? 4 : 0;
		SDL_RenderCopy(graphicsContext.renderer,
                    getTexture(graphicsContext, "ship-0.gif", frame).texture, null, &rect);
	};
	override void onEvent(SDL_Event event) {
		switch (event.type) {
			case SDL_KEYUP:
			case SDL_KEYDOWN:
				switch (event.key.keysym.sym) {
					case 'w':
						this.vel.y = event.key.state?-1:0;
						break;
					case 's':
						this.vel.y = event.key.state?1:0;
						break;
					case 'a':
						this.vel.x = event.key.state?-1:0;
						break;
					case 'd':
						this.vel.x = event.key.state?1:0;
						break;
					default:
				}
				break;
			default:
		}
	}
}
