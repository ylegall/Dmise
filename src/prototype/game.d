
module prototype.game;

import prototype.core;


struct Game
{
	private
	{
		bool isRunning;
		GameStack!4 stack;
	}

	auto checkAlive() {
		if (stack.top && !stack.top.isAlive()) {
			stack.pop();
			isRunning = !stack.isEmpty();
		}
	}

	void init()
	{
		stack.push(new Menu());
		assert(stack.top, "stack top should not be null");
		isRunning = true;
	}

	bool isAlive()
	{
		return isRunning;
	}

	/**
	 * handles SDL events such as mouse, keyboard, etc.
	 */
	void onEvent(SDL_Event event) {
		if (!stack.isEmpty()) {
			stack.top.onEvent(event);
		}

		//switch(event.type) {			
		//	case SDL_KEYDOWN:
		//		switch(event.key.keysym.sym) {
		//			case 'p':
		//				debug writeln("pause");
		//				break;

		//			case 'q':
		//				debug writeln("quit");
		//				break;

		//			case SDLK_ESCAPE:
		//				debug writeln("ESC");
		//				isRunning = false;
		//				return;

		//			default:
		//				break;
		//		}
		//		break;

		//	default:
		//		break;
		//}
	}

	void update(double delta)
	{
		checkAlive();
	}

	void draw(Graphics g)
	{
		if (!stack.isEmpty()) {
			stack.top.draw(g);
		}
	}

}

