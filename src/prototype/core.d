
module prototype.core;

public
{
	import derelict.sdl2.sdl;
	import derelict.sdl2.image;
	import derelict.sdl2.ttf;

	import prototype.main;
	import prototype.game;
	import prototype.menu;
	import prototype.util;

	//import std.conv;
	import std.exception;
	import std.c.stdlib;
	debug
	{
		import std.stdio;
	}
}

/**
 *  All game objects will have the following functions:
 */
interface GameObject
{
	bool isAlive();
	void onEvent(SDL_Event event);
	void update(double delta);
	void draw(Graphics g);
}

/**
 * 
 */
abstract class GameState : GameObject
{
	void onHide() {}
	void onShow() {}
}

/**
 * Holds information and meta data about  the game
 */
struct GameInfo
{
	string name = "Prototype";
	int height = 800;
	int width = 800;
	string resourcesDir = "res/";
	string libDir = "lib/";
}

/**
 * Holds references to types needed for graphics
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