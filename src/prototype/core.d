
module prototype.core;

public
{
	import derelict.sdl2.sdl;
	import derelict.sdl2.image;

	import prototype.main;
	import prototype.game;
	import prototype.menu;

	//import std.conv;
	import std.exception;
	debug
	{
		import std.stdio;
	}
}

/**
 *
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

struct Graphics
{
	SDL_Window* window;
	SDL_Renderer* renderer;
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