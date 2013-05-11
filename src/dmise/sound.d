
module dmise.sound;

import dmise.core;
import dmise.util.rescache;

// http://www.bfxr.net/

mixin ResourceCacheMixin!(Mix_Chunk*);

private Resource loadResource(string k)
{
  Mix_Chunk* v = loadSound(k);
  if (!v)
    return null;
  return new Resource(k, v);
}

private void freeResource(Mix_Chunk *v)
{
  if (v != null)
    Mix_FreeChunk(v);
}

private class Resource
{
  mixin ResourceMixin;
}

alias get getSound;
alias Resource SoundResource;

/**
Utility function to load a sound effect.
*/
auto loadSound(string file)
{
	import std.string;
	string path = gameInfo.resourcesDir ~ "sounds/" ~ file;
        debug writefln("sound.loadSound(\"%s\")", path);
	return Mix_LoadWAV(toStringz(path));
}

/**
Utility function to play a sound effect.
*/
auto playSound(Mix_Chunk* chunk)
{
	// TODO: check for muted setting, or null sound clip
	return Mix_PlayChannel(-1, chunk, 0);
}


alias Mix_Chunk* Sound;

