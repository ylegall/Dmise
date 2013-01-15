
module prototype.main;

import prototype.core;

debug
{
	import std.stdio;
}

pragma(lib, "DerelictSDL2");
pragma(lib, "DerelictUtil");
//pragma(lib, "SDL2_image");
pragma(lib, "dl");

enum TITLE = "Prototype";

// private fields:
private
{
	SDL_Renderer* renderer;
    SDL_Surface* bitmapSurface;

    bool isRunning;
    Game game;
    Graphics graphics;
}

// initialize SDL systems:
private auto init()
{
	debug writeln("initializeing SDL ...");
	auto status = SDL_Init(SDL_INIT_VIDEO|SDL_INIT_AUDIO);
	enforce(status == 0, "failed to initialize SDL.");
	enforce(SDL_WasInit(SDL_INIT_VIDEO), "failed to load video system");
	enforce(SDL_WasInit(SDL_INIT_AUDIO), "failed to load audio system");
	debug writeln("done.");

	// Create an application window with the following settings:
	graphics.window = SDL_CreateWindow( 
		TITLE,                             //    window title
		SDL_WINDOWPOS_UNDEFINED,           //    initial x position
	    SDL_WINDOWPOS_UNDEFINED,           //    initial y position
	    1000,                              //    width, in pixels
	    800,                               //    height, in pixels
	    SDL_WINDOW_SHOWN|SDL_WINDOW_OPENGL //|SDL_WINDOW_FULLSCREEN|SDL_WINDOW_BORDERLESS|SDL_WINDOW_MAXIMIZED
    );

    graphics.renderer = SDL_CreateRenderer(graphics.window, -1, SDL_RENDERER_ACCELERATED);

    // initialize SDL_Image:
    auto flags = IMG_INIT_PNG;
    writeln("flags = ", flags);
	status = IMG_Init(flags);
	writeln("status = ", status);
	if ((status & flags) != flags) {
		write("IMG_Init failed: "); printf(IMG_GetError()); writeln();
	}
	enforce((status & flags) == flags, "IMG_Init failed: ");

    game.init();
}


// main game loop
private auto run()
{
	debug writeln("entering main loop");
    
    isRunning = true;
    double delta;
    SDL_Event event;

    while (game.isAlive()) {
        if (SDL_PollEvent(&event)) {
        	debug writeln("received event type: ", event.type);
            if (event.type == SDL_QUIT) {
            	writeln("QUIT");
                break;
            }
	        game.onEvent(event);
        }

        game.update(delta);
        game.draw(graphics);
        SDL_RenderPresent(graphics.renderer);
    }
}

auto getGraphics() {
	return graphics;
}

// cleanup resources:
private auto shutdown()
{
	writeln("shutting down...");
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


	init();
	run();
	shutdown();
	return 0;
}
