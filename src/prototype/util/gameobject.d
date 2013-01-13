
module util.gameobject;

interface Drawable
{
	public void draw();
}

interface GameObject : Drawable
{
	public void update(size_t time);
}

abstract class GameState : GameObject
{
	public bool isRunning();
	void OnEvent(SDL_Event* event);

	void onStart() {}
	void onStop() {}
	void onPause() {}
	void onResume() {}
}

