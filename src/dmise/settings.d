
module dmise.settings;

import dmise.core;
import dmise.ui.label;
import dmise.ui.container;
import dmise.game;

import std.algorithm;

/**
Class to display the settings screen
 */
class Settings : GameState
{

	private {
		bool isRunning = true;
	}

	bool isAlive() {
		return isRunning;
	}

	void onEvent(SDL_Event event) {

	}

	void update(long delta) {
	}

	void draw(Graphics g) {
	}
}


