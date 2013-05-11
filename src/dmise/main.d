module dmise.main;

import std.stdio : writefln, writeln;
import dmise.core;
import core.memory : GC;


debug
{
	import std.stdio;
	import std.array : appender;
	import std.format : formattedWrite;
	import std.conv : to;
}

pragma(lib, "DerelictSDL2");
pragma(lib, "DerelictUtil");
pragma(lib, "dl");

// private fields:
private
{
	SDL_Renderer* renderer;
	Graphics graphics;
}

/// manages the stack of game states.
GameStates gameStates;

TextureManager textureManager;
auto getTexture(Graphics g, string filename, int gifFrame=0) {
	return textureManager.getTexture(g, filename, gifFrame);
}

package {
	GameInfo gameInfo;
}

auto getWindowSize() {
	return tuple(gameInfo.width, gameInfo.height);
}

// initialize SDL systems:
private auto init()
{
	// load game data:

	debug writeln("initializeing SDL ...");
	auto status = SDL_Init(SDL_INIT_VIDEO|SDL_INIT_AUDIO);
	enforce(status == 0, "failed to initialize SDL.");
	enforce(SDL_WasInit(SDL_INIT_VIDEO), "failed to load video system");
	enforce(SDL_WasInit(SDL_INIT_AUDIO), "failed to load audio system");
	debug writeln("done.");

	// Create an application window with the following settings:
	graphics.window = SDL_CreateWindow(
		gameInfo.name.ptr,              //    window title
		SDL_WINDOWPOS_UNDEFINED,        //    initial x position
		SDL_WINDOWPOS_UNDEFINED,        //    initial y position
		gameInfo.width,                 //    width, in pixels
		gameInfo.height,                //    height, in pixels
		SDL_WINDOW_SHOWN|SDL_WINDOW_OPENGL //|SDL_WINDOW_FULLSCREEN|SDL_WINDOW_BORDERLESS|SDL_WINDOW_MAXIMIZED
    );

    graphics.renderer = SDL_CreateRenderer(graphics.window, -1, SDL_RENDERER_ACCELERATED);

    // initialize SDL_Image:
    auto flags = IMG_INIT_PNG;
	status = IMG_Init(flags);
	if ((status & flags) != flags) {
		writefln("IMG_Init failed: %s", IMG_GetError());
		assert(false, "IMG_Init failed");
	}

	// initialize SDL_Mixer
	// open 22.05KHz, signed 16bit, system byte order, stereo audio, using 1024 byte chunks

	/* Let's do a little inspection of which audio drivers are available.
	 * This may not turn out to be totally useless in the long run...
	 */
	debug {
		int numAudioDrivers = SDL_GetNumAudioDrivers();
		writefln("[debug] SDL_GetNumAudioDrivers() = %d", numAudioDrivers);
		foreach (int n; 0..numAudioDrivers) {
			writefln("[debug]     driver # %d: \"%s\"", n, to!string(SDL_GetAudioDriver(n)));
		}
	}

	if(Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 2, 256) == -1) {
	    writefln("Mix_OpenAudio failed: %s", Mix_GetError());
	    exit(2);
	}

	// initialize font SDL_TTF:
	status = TTF_Init();
	enforce(status == 0, "TTF_Init failed.");

	graphics.font = TTF_OpenFont((gameInfo.resourcesDir ~ "fonts/" ~ gameInfo.fontName).ptr, 24);
	if (!graphics.font) {
	    writefln("TTF_OpenFont failed: %s", TTF_GetError());
	    assert(false);
	}

    gameStates.init();
}

enum frameDuration = 1.0/60.0;
private auto delay(long elapsed)
{
	auto remaining = max(2, 17 - elapsed);
	SDL_Delay(cast(uint)remaining);
}

// main game loop
private auto run()
{
	debug writeln("entering main loop");

	SDL_Event event;
	StopWatch timer;

	timer.start();
	while (gameStates.isAlive()) {
		while (SDL_PollEvent(&event)) {
			//debug writeln("received event type: ", event.type);
			if (event.type == SDL_QUIT) {
				return;
			}

                        gameStates.onEvent(event);
		}

		timer.stop();
		auto elapsed = timer.peek().msecs;
		gameStates.update(elapsed);
		timer.reset();
		timer.start();
		gameStates.draw(graphics);
		delay(elapsed);
		SDL_RenderPresent(graphics.renderer);
		setColor(graphics.renderer, Colors.BACKGROUND);
		SDL_RenderClear(graphics.renderer);
    }
}

/**
Get the global graphics context.
*/
auto getGraphics() {
	return graphics;
}

// cleanup resources:
private auto shutdown()
{
	gameStates.shutdown();
	textureManager.shutdown();

	debug {
		auto shutdownLogWriter = appender!string();
		string shutdownSystem = "";
		StopWatch timer;
		void shutdownLog(string name) {
			if (shutdownSystem.length) {
				auto elapsed = timer.peek().msecs;
				formattedWrite(shutdownLogWriter, "[shutdown] %s %dms\n", shutdownSystem, elapsed);
				timer.reset();
			} else {
				timer.start();
			}
			shutdownSystem = name;
		}
	}

        GC.collect();

	TTF_CloseFont(graphics.font);
	debug shutdownLog("TTF_Quit");
	TTF_Quit();
	debug shutdownLog("Mix_CloseAudio");
	Mix_CloseAudio();
	debug shutdownLog("Mix_Quit");
	Mix_Quit();
	debug shutdownLog("IMG_Quit");
	IMG_Quit();
	debug shutdownLog("SDL_DestroyRenderer");
	SDL_DestroyRenderer(graphics.renderer);
	debug shutdownLog("SDL_DestroyWIndow");
	SDL_DestroyWindow(graphics.window);
	debug shutdownLog("SDL_Quit");
	SDL_Quit();
	debug shutdownLog("done");
	debug writeln(shutdownLogWriter.data);
	writeln("shutted down...");
}

int main(string[] args)
{
	// load derelict bindings:
	DerelictSDL2.load();
	DerelictSDL2Image.load("lib/libSDL2_image.so");
	DerelictSDL2ttf.load("lib/libSDL2_ttf.so");
	DerelictSDL2Mixer.load("lib/libSDL2_mixer.so");

	init();
	run();
	shutdown();
	return 0;
}

