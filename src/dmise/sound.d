
module dmise.sound;

import dmise.core;

// http://www.bfxr.net/


/**
Utility function to load a sound effect.
*/
auto loadSound(string file)
{
	import std.string;
	string path = gameInfo.resourcesDir ~ "sounds/" ~ file;
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

