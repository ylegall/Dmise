
module prototype.menu;

import prototype.core;

import std.algorithm;

/**
 * 
 */
class Menu : GameState
{
	private
	{
		bool isRunning = true;
		int index = 0;

		auto items = [
			"new game ",
			"load game",
			"settings",
			"about"
		];

		SDL_Texture* logo;
	}

	this() {
		auto g = getGraphics();
		SDL_Surface* surface = IMG_Load("res/images/logo.png");
		//SDL_Surface* surface = IMG_Load_RW(SDL_RWFromFile("res/images/logo.png", "rb"), 1);
		if (!surface) throw new Exception("surface is null");
		logo = SDL_CreateTextureFromSurface(g.renderer, surface);
		SDL_FreeSurface(surface);
		enforce(logo, "could not load logo.png");
	}

	~this() {
		SDL_DestroyTexture(logo);
	}

	void onEvent(SDL_Event event)
	{
		switch(event.type)
		{
			case SDL_KEYDOWN:
				switch(event.key.keysym.sym)
				{
					//case SDLK_RIGHT:
					//case SDLK_LEFT:

					case SDLK_DOWN:
					case 's':
						selectNext();
						break;

					case SDLK_UP:
					case 'w':
						selectPrev();
						break;

					case SDLK_RETURN:
						debug writeln("Mainmenu: Keydown RETURN");
						break;

					case 'q':
					case SDLK_ESCAPE:
						debug writeln("Mainmenu: Keydown ESC");
						isRunning = false;
						return;

					default:
						break;
				}
				break;

			default:
				break;
		}
	}

	auto selectNext() {
		index += 1;
		index  = min(items.length - 1, index);
		debug writeln("selected text = ", items[index]);
	}

	auto selectPrev() {
		index -= 1;
		index  = max(0, index);
		debug writeln("selected text = ", items[index]);
	}

	bool isAlive() {
		return isRunning;
	}

	void update(double delta) {

	}

	void draw(Graphics g) {
		SDL_RenderCopy(g.renderer, logo, null, null);
	}

}

