
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

	void draw() {
		
	}

}

