module dmise.texture;
import dmise.core;
import std.string : toStringz;
import std.format : appender;

class Texture {
	SDL_Texture* texture;
	this(SDL_Texture* texture) {
		this.texture = texture;
	}
	~this() {
		SDL_DestroyTexture(texture);
	}
}


Texture[string] textures;

Texture getTexture(Graphics graphicsContext, string filename, int gifFrame=-1) {
	filename = "res/images/" ~ filename;

	/* Is the texture already loaded? */
        string textureName = filename;
        if (gifFrame >= 0)
            textureName ~= ":0";
	if (textureName in textures)
		return textures[textureName];

	debug writefln("[texture] loading \"%s\"", filename);

        SDL_Surface *surface;
        SDL_RWops *f;

        scope(exit) { if (surface) SDL_FreeSurface(surface); surface = null; }
        scope(exit) { if (f) SDL_RWclose(f); f = null; }

        do {
            if (gifFrame >= 0) {
                if (gifFrame == 0)
                    f = SDL_RWFromFile(toStringz(filename), "rb");
                enforce(f, "SDL_RWFromFile(\"%s\") failed", filename);

                if (surface)
                    SDL_FreeSurface(surface);
                surface = IMG_LoadGIFFrame_RW(f, gifFrame);
                enforce(surface, "surface is null");

                auto writer = appender!string();
                formattedWrite(writer, "%s:%d", filename, gifFrame);
                textureName = writer.data;
            } else {
                /* Use SDL_Image lib to load the image into an SDL_Surface */
                surface = IMG_Load(toStringz(filename));
                enforce(surface, "surface is null");

                textureName = filename;
            }

            debug writefln("[texture] image dimensions: %dx%d", surface.w, surface.h);

            /* Convert SDL_Surface to SDL_Texture */
            SDL_Texture* texture = SDL_CreateTextureFromSurface(graphicsContext.renderer, surface);
            enforce(texture, "texture is null");

            textures[textureName] = new Texture(texture);
        } while (gifFrame >= 0 && gifFrame < 1 && surface);

	return textures[filename];
}
