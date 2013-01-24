
module prototype.game;

import prototype.core;


struct Game
{
	private
	{
		bool alive;
		GameStack!4 stack;
	}

	auto checkAlive() {
		if (stack.top && !stack.top.isAlive()) {
			stack.pop();
			alive = !stack.isEmpty();
		}
	}

	void init()
	{
		stack.push(new Menu());
		assert(stack.top, "stack top should not be null");
		alive = true;
	}

	bool isAlive()
	{
		return alive;
	}

	/**
	 * handles SDL events such as mouse, keyboard, etc.
	 */
	void onEvent(SDL_Event event) {
		if (!stack.isEmpty()) {
			stack.top.onEvent(event);
		}
	}

	void update(real delta)
	{
		checkAlive();
	}

	void draw(Graphics g)
	{
		if (!stack.isEmpty()) {
			stack.top.draw(g);
		}
	}

	void shutdown() {
		alive = false;
		while (!stack.isEmpty()) {
			stack.pop();
		}
	}
}

