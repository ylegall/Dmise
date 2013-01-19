
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
			"new game",
			"load game",
			"settings",
			"about",
			"quit"
		];
		alias void delegate() Action;
		Action[string] actions;

		SDL_Texture* logo;
		SDL_Rect logoRect;
		SDL_Texture** menuLabels;

		SDL_Color fgColor = {0, 0, 0};
		SDL_Color bgColor = {0, 255, 0};
		SDL_Color bgSelectedColor = {0, 255, 255};
	}

	this() {
		auto g = getGraphics();
		SDL_Surface* surface = IMG_Load("res/images/logo.png");
		logoRect = SDL_Rect(0, 100, surface.w, surface.h);
		centerHorizontal(logoRect);
		enforce (surface, "surface is null");
		logo = SDL_CreateTextureFromSurface(g.renderer, surface);
		enforce(logo, "could not load logo.png");

		// load actions
		loadMenuActions();

		// draw menu items:
		auto font = g.font;
		menuLabels = cast(SDL_Texture**)malloc(items.length * size_t.sizeof);
		foreach (i; 0 .. items.length) {
			surface = TTF_RenderText_Blended(font, items[i].ptr, fgColor);
			menuLabels[i] = SDL_CreateTextureFromSurface(g.renderer, surface);
		}
		SDL_FreeSurface(surface);
	}

	// setup the actions for each menu item:
	auto loadMenuActions() {
			actions["new game"] = {};
			actions["load game"] = {};
			actions["settings"] = {};
			actions["about"] = {};
			actions["quit"] = { isRunning = false; };
	}

	~this() {
		SDL_DestroyTexture(logo);
		foreach (i; 0 .. items.length) {
			SDL_DestroyTexture(menuLabels[i]);
		}
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
						auto menuItem = items[index];
						actions[menuItem]();
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
		// reder the logo:
		SDL_RenderCopy(g.renderer, logo, null, &logoRect);

		// TODO: render a background:
		SDL_RenderFillRect(g.renderer, &labelRect);

		// render the menu box:


		SDL_Rect labelRect = {logoRect.x, 200, logoRect.w, 30};


		foreach (i; 0 .. items.length) {
			if (i == index) {
				SDL_SetRenderDrawColor(
					g.renderer,
					bgSelectedColor.r,
					bgSelectedColor.g,
					bgSelectedColor.b,
					225);
			} else {
				SDL_SetRenderDrawColor(
					g.renderer,
					bgColor.r,
					bgColor.g,
					bgColor.b,
					200);
			}
			SDL_RenderFillRect(g.renderer, &labelRect);
			SDL_RenderCopy(g.renderer, menuLabels[i], null, &labelRect);
			labelRect.y += 50;
		}
	}
}
