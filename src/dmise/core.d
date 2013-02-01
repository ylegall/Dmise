
module dmise.core;

public
{
	import derelict.sdl2.sdl;
	import derelict.sdl2.image;
	import derelict.sdl2.ttf;
	import derelict.sdl2.mixer;

	import dmise.main;
	import dmise.game;
	import dmise.menu;
	import dmise.util;
	import dmise.animation.ease;
	import dmise.animation.animation;

	//import std.conv;
	import std.algorithm;
	import std.c.stdlib;
	import std.datetime;
	import std.exception;
	import std.typecons;
	debug
	{
		import std.stdio;
	}
}

interface Drawable
{
	void draw(Graphics g);
}

interface Updateable
{
	void update(long delta);
}

/**
All game objects will have the following functions:
 */
interface GameObject : Drawable, Updateable
{
	bool isAlive();
	void onEvent(SDL_Event event);
}

/**

 */
abstract class GameState : GameObject
{
	void onHide() {}
	void onShow() {}
}

/**
Holds game information and metadata.
 */
struct GameInfo
{
	string name = "Prototype";
	int height = 800;
	int width = 800;
	int padding = 20;
	string resourcesDir = "res/";
	string libDir = "lib/";
	//string fontName = "digitek.ttf";
	string fontName = "UbuntuMono-R.ttf";
}

/**
Global colors.
TODO: read from configuration?
 */
struct Colors {
	enum BLUE = SDL_Color(0, 128, 255);
	enum DARK_GRAY = SDL_Color(64, 64, 64);
	enum DEFAULT_TEXT = SDL_Color(255,255,255);
	enum SELECTED = SDL_Color(0,128,255);
	enum BACKGROUND = SDL_Color(0, 0, 0);
}

/**
Holds references to types needed for graphics
 */
struct Graphics
{
	SDL_Window* window;
	SDL_Renderer* renderer;
	TTF_Font* font;
}

/**
 *
 */
struct GameStack(int Size=4)
{
	private size_t index;
	private GameState[Size] states;

	void push(GameState state) {
		assert(index < Size - 1, "game stack is full.");
		auto top = states[index];
		if (top) {
			top.onHide();
		}
		states[index] = state;
		index += 1;
		state.onShow();
	}

	void pop() {
		assert(index > 0, "game stack is empty");
		index -= 1;
		auto top = states[index];
		top.onHide();
		delete states[index];
		states[index] = null;
	}

	@property
	GameState top() {
		if (index > 0) {
			return states[index - 1];
		} else {
			return null;
		}
	}

	bool isEmpty() {
		return index == 0;
	}
}

alias Tuple!(int,int) Point;
alias Tuple!(int,int) Dimension;

