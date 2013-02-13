module dmise.menu;

import dmise.core;
import dmise.ui.label;
import dmise.ui.container;
import dmise.game;

import std.algorithm;

/**
A menu item has a label, an action, and an animation
*/
struct MenuItem {
	alias void delegate() Action;
	Label label;
	Action action;
	Animation!SDL_Color colorAnimation;
	Animation!int sizeAnimation;

	this(string str, Action action) {
		label = new Label(str);
		label.padding = 8;
		this.action = action;
		addAnimations();
	}

	void addAnimations() {
		// create the color animation:
		colorAnimation = AnimationBuilder!(SDL_Color).create(&label.bgColor)
			.from(Colors.DARK_GRAY)
			.to(Colors.SELECTED)
			.lasting(200)
			.ease(Ease(CUBE))
			.build();

		// create the size animation:
		sizeAnimation = AnimationBuilder!(int).create(&label.textLocation.x)
			.from(label.textLocation.x)
			.to(label.textLocation.x + 16)
			.lasting(200)
			.ease(Ease(CUBE, EaseMode.OUT))
			.build();
	}

	void update(long delta) {
		colorAnimation.update(delta);
		if (sizeAnimation) sizeAnimation.update(delta);
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
		Container container;

		SDL_Color fgColor = {0, 0, 0};
		SDL_Color bgColor = {0, 255, 0};

		Mix_Chunk* menuSound;
	}

	this() {
		auto g = getGraphics();
		SDL_Surface* surface = IMG_Load("res/images/logo.png");
		menuSound = Mix_LoadWAV("res/sounds/beep.wav");

		logoRect = SDL_Rect(0, 100, surface.w, surface.h);
		centerHorizontal(logoRect);
		enforce (surface, "surface is null");
		logo = SDL_CreateTextureFromSurface(g.renderer, surface);
		enforce(logo, "could not load logo.png");
		SDL_FreeSurface(surface);

		menuItems = [
			MenuItem("new game", delegate void() { gameStates.pushGameState(new Game()); }),
			MenuItem("load game", delegate void() {}),
			MenuItem("settings", delegate void() {}),
			MenuItem("about", delegate void() {}),
			MenuItem("quit", delegate void() { isRunning = false; })
		];

		container = new Container(null, LayoutMode.VERTICAL, SizeMode.FILL_PARENT);
		container.setRect(16, 200, gameInfo.width - 32, 200);
		foreach (item; menuItems) {
			container.add(item.label);
			item.sizeAnimation.setFrom(container.x + 12);
			item.sizeAnimation.setTo(container.x + 32);
		}
		container.resize();

		menuItems[0].label.bgColor = Colors.SELECTED;
	}

	~this() {
		SDL_DestroyTexture(logo);
		Mix_FreeChunk(menuSound);
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
						Mix_PlayChannel(-1, menuSound, 0);
						selectNext();
						break;

					case SDLK_UP:
					case 'w':
						Mix_PlayChannel(-1, menuSound, 0);
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
			menuItems[index - 1].sizeAnimation.stop();
			menuItems[index].colorAnimation.start();
			menuItems[index].sizeAnimation.start();
		}
	}

	auto selectPrev() {
		index -= 1;
		if (index < 0) {
			index = 0;
		} else {
			menuItems[index + 1].colorAnimation.stop();
			menuItems[index + 1].sizeAnimation.stop();
			menuItems[index].colorAnimation.start();
			menuItems[index].sizeAnimation.start();
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

		// render the menuItems
		foreach (item; menuItems) {
			item.draw(g);
		}
	}

}
