module dmise.texture;
import dmise.core;
import std.string : toStringz;
import std.format : appender;

/**

*/
class Texture {
	SDL_Texture* texture;
	alias texture this;

	this(SDL_Texture* texture) {
		this.texture = texture;
	}

	~this() {
		SDL_DestroyTexture(texture);
	}
}

/**
Manages and caches textures in memory.
*/
struct TextureManager
{
	private {
		Texture[string] textures;
	}

	void shutdown() {
		foreach (texture; textures) {
			delete texture;
		}
	}

	/// load a texture resource from the specified path
	auto getTexture(Graphics graphicsContext, string filename, int gifFrame=0) {
		filename = "res/images/" ~ filename;

		/* Is the texture already loaded? */
		string textureName;
		if (gifFrame > 0) {
			auto writer = appender!string;
			formattedWrite(writer, "%s:%d", filename, gifFrame);
			textureName = writer.data;
		} else {
			textureName = filename;
		}
		//debug writefln("[texture] looking for texture named \"%s\"", textureName);
		if (textureName in textures)
			return textures[textureName];

		debug writefln("[texture] loading \"%s\"", filename);

		SDL_Surface *surface;
		SDL_RWops *f;
		Texture texture;

		scope(exit) { if (surface) SDL_FreeSurface(surface); surface = null; }
		scope(exit) { if (f) SDL_RWclose(f); f = null; }

		if (gifFrame > 0) {
			f = SDL_RWFromFile(toStringz(filename), "rb");
			enforce(f, "SDL_RWFromFile(\"%s\") failed", filename);
		}

		do {
			if (gifFrame > 0) {
				debug writefln("[texture] IMG_LoadGIFFrame_RW()");

				if (surface)
					SDL_FreeSurface(surface);
				surface = IMG_LoadGIFFrame_RW(f, gifFrame);

				auto writer = appender!string();
				formattedWrite(writer, "%s:%d", filename, gifFrame);
				textureName = writer.data;
			} else {
				/* Use SDL_Image lib to load the image into an SDL_Surface */
				debug writefln("[texture] IMG_Load()");
				surface = IMG_Load(toStringz(filename));
				textureName = filename;
			}

			debug writefln("[texture] surface = %x", surface);
			if (!surface)
				return texture;

			debug writefln("[texture] image dimensions: %dx%d", surface.w, surface.h);

			/* Convert SDL_Surface to SDL_Texture */
			SDL_Texture* sdlTexture = SDL_CreateTextureFromSurface(graphicsContext.renderer, surface);

			debug writefln("[texture] storing frame %d from \"%s\" as \"%s\"", gifFrame, filename, textureName);
			texture = new Texture(sdlTexture);
			textures[textureName] = texture;

		} while (gifFrame > 0 && surface);

		return textures[filename];
	}
}

