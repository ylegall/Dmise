module dmise.texture;
import dmise.core;
import std.string : toStringz;

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

Texture getTexture(Graphics graphicsContext, string filename) {
	filename = "res/images/" ~ filename;

	/* Is the texture already loaded? */
	if (filename in textures)
		return textures[filename];

	debug writefln("[textures] loading \"%s\"", filename);

	/* Use SDL_Image lib to load the image into an SDL_Surface */
	SDL_Surface *surface = IMG_Load(toStringz(filename));
	enforce(surface, "surface is null");
	scope(exit) SDL_FreeSurface(surface);

	/* Convert SDL_Surface to SDL_Texture */
	SDL_Texture* texture = SDL_CreateTextureFromSurface(graphicsContext.renderer, surface);
	enforce(texture, "texture is null");

	textures[filename] = new Texture(texture);
	return textures[filename];
}
