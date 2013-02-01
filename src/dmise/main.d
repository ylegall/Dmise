module dmise.main;

import dmise.core;


debug
{
	import std.stdio;
}

pragma(lib, "DerelictSDL2");
pragma(lib, "DerelictUtil");
pragma(lib, "dl");

// private fields:
private
{
	SDL_Renderer* renderer;
	bool isRunning;
	Game game;
	Graphics graphics;
}

package {
	GameInfo gameInfo;
}

auto getWindowSize() {
	return tuple(gameInfo.width, gameInfo.height);
}

// initialize SDL systems:
// TODO: load settings
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
		write("IMG_Init failed: "); printf(IMG_GetError()); writeln();
		assert(false, "IMG_Init failed");
	}

	// initialize SDL_Mixer
	flags = MIX_INIT_MP3;
	status = Mix_Init(flags);
	if((status & flags) != flags) {
		write("MIX_Init failed: "); printf(IMG_GetError()); writeln();
		assert(false, "MIX_Init failed");
	}
	// open 22.05KHz, signed 16bit, system byte order, stereo audio, using 1024 byte chunks
	if(Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 2, 1024) == -1) {
	    printf("Mix_OpenAudio: %s\n", Mix_GetError());
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

    game.init();
}

private auto delay(long elapsed)
{
	//writeln(elapsed);
	auto remaining = max(2, 17 - elapsed);
	//debug writeln("sleeping for ", remaining);
	SDL_Delay(cast(uint)remaining);
}

// main game loop
private auto run()
{
	debug writeln("entering main loop");

    isRunning = true;
    SDL_Event event;
    StopWatch timer;

    timer.start();
    while (game.isAlive()) {
        if (SDL_PollEvent(&event)) {
        	//debug writeln("received event type: ", event.type);
            if (event.type == SDL_QUIT) {
            	game.shutdown();
            	break;
            }
	        game.onEvent(event);
        }

        timer.stop();
        auto elapsed = timer.peek().msecs;
        game.update(elapsed);
        timer.reset();
        timer.start();
        game.draw(graphics);
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
	writeln("shutting down...");
	TTF_Quit();
	
	Mix_CloseAudio();
	Mix_Quit();
	
	IMG_Quit();
	SDL_DestroyRenderer(graphics.renderer);
	SDL_DestroyWindow(graphics.window);
	SDL_Quit();
}

int main(string[] args)
{
	// load derelict bindings:
	DerelictSDL2.load();
	//DerelictSDL2Image.load();
	DerelictSDL2Image.load("lib/libSDL2_image.so");
	DerelictSDL2ttf.load("lib/libSDL2_ttf.so");
	DerelictSDL2Mixer.load("lib/libSDL2_mixer.so");

	init();
	run();
	shutdown();
	return 0;
}
