
module dmise.core;

public
{
	import derelict.sdl2.sdl;
	import derelict.sdl2.image;
	import derelict.sdl2.ttf;
	import derelict.sdl2.mixer;

	import dmise.main;
	import dmise.gamestates;
	import dmise.menu;
	import dmise.animation.ease;
	import dmise.animation.animation;

	//import std.conv;

	import std.algorithm;
	import std.c.stdlib;
	import std.datetime;
	import std.exception;
	import std.conv;
	import std.math;
	import std.traits;
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
Allows screens to be pushed and popped.
TODO: rename?
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


/**
Centers a rectangle in the main window
TODO: move to a better location.
*/
auto centerHorizontal(ref SDL_Rect rect)
{
	rect.x = (dmise.core.gameInfo.width)/2 - rect.w/2;
}

/**
Sets the current renderer color.
TODO: move to a better location.
*/
auto setColor(SDL_Renderer* r, SDL_Color c, ubyte a=255)
{
	SDL_SetRenderDrawColor(r, c.r, c.g, c.b, a);
}

/**
Gets the current renderer color.
TODO: move to some better location.
*/
auto getColor(SDL_Renderer* r)
{
	SDL_Color c;
	ubyte a;
	SDL_GetRenderDrawColor(r, &c.r,&c.g, &c.b, &a);
	return c;
}

/**
Utility to make a texture for text.
TODO: move to some better location.
*/
auto makeText(string message, SDL_Color fgColor, SDL_Color bgColor = Colors.BACKGROUND )
{
	SDL_Surface* surface;
	auto g = getGraphics();
	version (textQualityLow) {
		surface = TTF_RenderText_Solid(g.font, message.ptr, fgColor);
	} else version (textQualityHigh) {
		surface = TTF_RenderText_Blended(g.font, message.ptr, fgColor);
	} else {
		surface = TTF_RenderText_Shaded(g.font, message.ptr, fgColor, bgColor);
	}

	assert(surface, "could not render surface");
	return makeTexture(g, surface);
}

/**
Utility to clamp a value between low and high values
TODO: move to some better location.
*/
auto clamp(T)(T val, T low=0, T high=1)
	if(isNumeric!T)
{
	if (val > high) return high;
	if (val < low) return low;
	return val;
}

/**
Utility to clamp a value between low and high values
TODO: move to some better location.
*/
enum DEGREES_PER_RADIAN = 180 / PI;
auto radiansToDegrees(real radians) {
	//return 57.2957795 * radians;
	return DEGREES_PER_RADIAN * radians;
}

/**
Utility to make a texture from a surface
TODO: move to some better location.
*/
auto makeTexture(Graphics g, SDL_Surface* surface)
{
	return SDL_CreateTextureFromSurface(g.renderer, surface);
}

struct Stack(T)
{
	struct Node {
		T data;
		Node* prev;
	}

	private size_t size;
	Node* top;

	this() {
		size = 0;
		top = null;
	}

	T pop() {
		assert(size > 0, "stack is empty");
		auto node = top;
		top = top.prev;
		--size;
		auto retval = node.data;
		delete node;
		return retval;
	}

	void push(T item) {
		Node node = { item, top };
		++size;
		top = node;
	}

	T peek() { assert(size > 0, "stack is empty"); return top.data; }

	@property
	auto length() { return size; }

	bool isEmpty() { return size == 0; }
}

/**
TODO: is this needed?
*/
struct FramerateManager
{
	private {
		StopWatch timer;
		bool isRunning;
		long targetFramerate;
	}

	this(long targetFramerate) {
		this.targetFramerate = targetFramerate;
	}

	void start() {
		isRunning = true;
		timer.start();
	}

	auto elapsed() {
		timer.stop();
		auto retval = timer.peek().msecs;
		timer.start();
		return retval;
	}
}

