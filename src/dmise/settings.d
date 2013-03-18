module dmise.settings;

import dmise.core;
import dmise.ui.label;
import dmise.ui.container;
import dmise.game;

import std.algorithm;

/**

*/
struct SettingsItem {
	Label keyLabel;
	Label valueLabel;
	string[] values;
	Animation!SDL_Color colorAnimation;
	Animation!int sizeAnimation;

	this(string key, string[] values) {
		keyLabel = new Label(key);
		if (values.length) {
			this.values = values;
			valueLabel = new Label(values[0]);
		} else {
			valueLabel = new Label("");
		}
	}

	void addAnimations() {
		// create the color animation:
		colorAnimation = AnimationBuilder!(SDL_Color).create(&keyLabel.bgColor)
			.from(Colors.DARK_GRAY)
			.to(Colors.SELECTED)
			.lasting(200)
			//.ease(Ease(CUBE))
			.build();

		// create the size animation:
		sizeAnimation = AnimationBuilder!(int).create(&keyLabel.textLocation.x)
			.from(keyLabel.textLocation.x)
			.to(keyLabel.textLocation.x + 16)
			.lasting(200)
			//.ease(Ease(CUBE, EaseMode.OUT))
			.build();
	}

	void update(long delta) {
		colorAnimation.update(delta);
		if (sizeAnimation) sizeAnimation.update(delta);
		keyLabel.update(delta);
		valueLabel.update(delta);
	}

	void draw(Graphics g) {
		keyLabel.draw(g);
		valueLabel.draw(g);
	}
}

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


