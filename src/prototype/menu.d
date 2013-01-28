
module prototype.menu;

import prototype.core;
import prototype.ui.label;

import std.algorithm;

/**
A menu item has a label, an action, and an animation
*/
struct MenuItem {
	alias void delegate() Action;
	Label label;
	Action action;
	Animation!SDL_Color colorAnimation;
	//Animation!int sizeAnimation;

	this(string str, Action action) {
		label = new Label(str);
		this.action = action;

		// create the color animation:
		colorAnimation = AnimationBuilder!(SDL_Color).create(&label.bgColor)
			.from(Colors.DARK_GRAY)
			.to(Colors.SELECTED)
			.lasting(200)
			.ease(CUBE)
			.get();

		//// create the size animation:
		//sizeAnimation = AnimationBuilder!(int).create(&label.rect.h)
		//	.from(label.rect.h)
		//	.to(label.rect.h + 10)
		//	.lasting(200)
		//	.ease(CUBE)
		//	.get();
	}

	void update(long delta) {
		colorAnimation.update(delta);
		//sizeAnimation.update(delta);
		label.update(delta);
	}

	void draw(Graphics g) {
		label.draw(g);
	}

}

/**
Class to display the main menu screen
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
		SDL_Rect menuRect;		// TODO remove

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
			item.label.setLocation(16, menuRect.y + i * 40);
			item.label.width = 500;
			item.label.height = 30;
			++i;
		}
		menuItems[0].label.bgColor = Colors.SELECTED;
	}

	~this() {
		SDL_DestroyTexture(logo);
		foreach (item; menuItems) {
			delete item.label;
		}
	}

	void onEvent(SDL_Event event)
	{
		switch(event.type) {

			case SDL_KEYDOWN:
				switch(event.key.keysym.sym) {

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
		if (index >= menuItems.length) {
			index = cast(int)(menuItems.length - 1);
		} else {
			menuItems[index - 1].colorAnimation.stop();
			//menuItems[index - 1].sizeAnimation.stop();
			menuItems[index].colorAnimation.start();
			//menuItems[index].sizeAnimation.start();
		}
	}

	auto selectPrev() {
		index -= 1;
		if (index < 0) {
			index = 0;
		} else {
			menuItems[index + 1].colorAnimation.stop();
			//menuItems[index - 1].sizeAnimation.stop();
			menuItems[index].colorAnimation.start();
			//menuItems[index].sizeAnimation.start();
		}
	}

	bool isAlive() {
		return isRunning;
	}

	void update(long delta) {
		foreach (item; menuItems) {
			item.update(delta);
		}
	}

	void draw(Graphics g) {
		auto oldColor = g.renderer.getColor();

		// reder the logo:
		SDL_RenderCopy(g.renderer, logo, null, &logoRect);

		// TODO: render background:

		// render the menuItems
		foreach (item; menuItems) {
			item.draw(g);
		}
	}

}
