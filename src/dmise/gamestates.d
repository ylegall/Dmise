
module dmise.gamestates;

import dmise.core;
import dmise.util.stack;


/**

*/
struct GameStates
{
	private {
		bool alive;
		Stack!GameState stack;
	}

	auto checkAlive() {
		if (stack.peek() && !stack.peek().isAlive()) {
			stack.pop();
			alive = !stack.isEmpty();
		}
	}

	void init() {
		pushGameState(new Menu());
		alive = true;
	}

	bool isAlive() {
		return alive;
	}

	void onEvent(SDL_Event event) {
		if (!stack.isEmpty()) {
			stack.peek().onEvent(event);
		}
	}

	void update(long delta){
		checkAlive();
		if (!stack.isEmpty) {
			stack.peek().update(delta);
		}
	}

	void draw(Graphics g) {
		if (!stack.isEmpty()) {
			stack.peek().draw(g);
		}
	}

	void shutdown() {
		alive = false;
		while (!stack.isEmpty()) {
			auto state = stack.pop();
		}
		assert(stack.isEmpty());
	}

	void pushGameState(GameState gameState) {
		stack.push(gameState);
		gameState.onShow();
	}

	void popGameState() {
		auto state = stack.pop();
		state.onHide();
		delete state;
	}
}

