
module dmise.game;

import dmise.core;


/**

*/
struct Game
{
	private {
		bool alive;
		GameStack!4 stack;
	}

	auto checkAlive() {
		if (stack.top && !stack.top.isAlive()) {
			stack.pop();
			alive = !stack.isEmpty();
		}
	}

	void init() {
		stack.push(new Menu());
		assert(stack.top, "stack top should not be null");
		alive = true;
	}

	bool isAlive() {
		return alive;
	}

	void onEvent(SDL_Event event) {
		if (!stack.isEmpty()) {
			stack.top.onEvent(event);
		}
	}

	void update(long delta){
		checkAlive();
		if (!stack.isEmpty) {
			stack.top.update(delta);
		}
	}

	void draw(Graphics g) {
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

        void pushGameState(GameState gameState) {
		stack.push(gameState);
        }
}

