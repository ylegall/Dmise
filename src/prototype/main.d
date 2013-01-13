
module prototype.main;

import prototype.core;

debug
{
	import std.stdio;
}

pragma(lib, "DerelictSDL2");
pragma(lib, "DerelictUtil");
pragma(lib, "dl");

enum TITLE = "Prototype";

// private fields:
private
{
	SDL_Window* window;
	SDL_Renderer* renderer;
    SDL_Texture* bitmapTex;
    SDL_Surface* bitmapSurface;

    bool isRunning;
    Game game;
}

// initialize SDL systems:
private auto init()
{
	debug writeln("initializeing SDL ...");
	auto status = SDL_Init(SDL_INIT_VIDEO|SDL_INIT_AUDIO);
	assert(status == 0, "failed to initialize SDL.");
	assert(SDL_WasInit(SDL_INIT_VIDEO), "failed to load video system");
	assert(SDL_WasInit(SDL_INIT_AUDIO), "failed to load audio system");
	debug writeln("done.");

	// Create an application window with the following settings:
	window = SDL_CreateWindow( 
		TITLE,                             //    window title
		SDL_WINDOWPOS_UNDEFINED,           //    initial x position
	    SDL_WINDOWPOS_UNDEFINED,           //    initial y position
	    1000,                              //    width, in pixels
	    800,                               //    height, in pixels
	    SDL_WINDOW_SHOWN|SDL_WINDOW_OPENGL //|SDL_WINDOW_FULLSCREEN|SDL_WINDOW_BORDERLESS|SDL_WINDOW_MAXIMIZED
    );

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

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

        game.draw();

        game.update(delta);

	    SDL_RenderClear(renderer);
	    SDL_RenderCopy(renderer, bitmapTex, null, null);
	    SDL_RenderPresent(renderer);
    }
}


// cleanup resources:
private auto shutdown()
{
	writeln("shutting down...");
    SDL_DestroyTexture(bitmapTex);
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window); 
	SDL_Quit();
}


int main(string[] args)
{
	// load derelict bindings:
	DerelictSDL2.load();
	
	init();
	run();
	shutdown();
	return 0;
}
