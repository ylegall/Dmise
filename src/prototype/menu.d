
module prototype.menu;

import prototype.core;
import prototype.ui.label;

import std.algorithm;

// TODO: make this a button
struct MenuItem {
	alias void delegate() Action;
	Label label;
	Action action;
	this(string str, Action action) {
		label = new Label(str);
		this.action = action;
	}
}

/**
 * 
 */
class Menu : GameState
{
	private
	{
		bool isRunning = true;
		int index = 0;

		MenuItem[] menuItems;

		SDL_Texture* logo;
		SDL_Rect logoRect;
		SDL_Rect menuRect;
		SDL_Texture** menuLabels;

		SDL_Color fgColor = {0, 0, 0};
		SDL_Color bgColor = {0, 255, 0};
	}

	this() {
		auto g = getGraphics();
		SDL_Surface* surface = IMG_Load("res/images/logo.png");
		logoRect = SDL_Rect(0, 100, surface.w, surface.h);
		menuRect = SDL_Rect(0, 200, gameInfo.width, 200);
		centerHorizontal(logoRect);
		enforce (surface, "surface is null");
		logo = SDL_CreateTextureFromSurface(g.renderer, surface);
		enforce(logo, "could not load logo.png");

		menuItems = [
			MenuItem("new game", delegate void() {}),
			MenuItem("load game", delegate void() {}),
			MenuItem("settings", delegate void() {}),
			MenuItem("about", delegate void() {}),
			MenuItem("quit", delegate void() { isRunning = false; })
		];

		auto i = 0;
		foreach (item; menuItems) {
			item.label.setLocation(0, menuRect.y + i * 35);
			++i;
		}
	}

	~this() {
		SDL_DestroyTexture(logo);
		foreach (item; menuItems) {
			delete item.label;
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
						auto menuItem = menuItems[index];
						menuItem.action();
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
		index  = min(menuItems.length - 1, index);
		debug writeln("selected text = ", menuItems[index]);
	}

	auto selectPrev() {
		index -= 1;
		index  = max(0, index);
		debug writeln("selected text = ", menuItems[index]);
	}

	bool isAlive() {
		return isRunning;
	}

	void update(double delta) {

	}

	void draw(Graphics g) {
		auto oldColor = g.renderer.getColor();

		// reder the logo:
		SDL_RenderCopy(g.renderer, logo, null, &logoRect);

		// TODO: render background:

		// render the menu box:
		setColor(g.renderer, Colors.DARK_GRAY, 150);
		SDL_RenderFillRect(g.renderer, &menuRect);

		// render the menuItems
		foreach (item; menuItems) {
			item.label.draw(g);
		}

	}
}
