
module prototype.animation.animation;

import core.time;

/**

*/
class Animation(T)
{
	private {
		Ease ease;
		T To;
		T From;
		bool isRunning
		T value;
		long duration;
	}

	this() {

	}

	auto setTo(T to) {
		this.to = to;
	}
	
	auto setFrom(T from) {
		this.from = from;
	}

	auto setEase(Ease e) {
		this.ease = e;
	}

	auto setDuration(Duration duration) {
		this.duration = duration.get!"msecs";
	}

	void start() {
		if (isRunning) {
			return;
		}
		isRunning = true;
	}

	void stop() {
		if (!isRunning) {
			return;
		}
		isRunning = false;
	}

	void pause() {
		if (!isRunning) {
			return;
		}		
		isRunning = false;
	}

	void update(real delta) {
		if (isRunning) {

		}
	}
}

/**
Animation builder class
*/
class AnimationBuilder(T)
{
	Animation!T animation;

	private this() {
		animation = new Animation();
	}

	static auto create() {
		AnimationBuilder builder = new AnimationBuilder();
		return builder;
	}

	auto from(T start) {
		assert(animation)
		animation.setFrom(start);
		return this;
	}

	auto to(T to) {
		animation.setTo(to);
		return this;
	}

	auto lasting(Duration duration) {
		animation.setDuration(duration);
	}

	auto ease(Ease e) {
		animation.setEase(e);
	}

	auto create() {
		auto retval = this.animation
	}
}