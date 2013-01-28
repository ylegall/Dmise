
module prototype.animation.animation;

import prototype.util;
import prototype.animation.ease;
import prototype.animation.interpolate;

import core.time;
import std.stdio;


/**
A simple animation between 2 values.
*/
class Animation(T)
{
	alias void delegate(Animation!T) AnimationEvent;

	private {
		Ease ease;
		T to;
		T from;
		bool isRunning;
		T* value;
		long duration;
		long elapsed;
		AnimationEvent onUpdate;
		AnimationEvent onFinish;
	}

	this(T* value) {
		assert(value);
		this.value = value;
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
		this.duration = duration.fracSec.msecs;
	}
	auto setDuration(long duration) {
		this.duration = duration;
	}

	auto setOnFinish(AnimationEvent fn) {
		this.onFinish = fn;
	}
	auto setOnUpdate(AnimationEvent fn) {
		this.onFinish = fn;
	}

	void start() {
		if (isRunning) {
			return;
		}
		isRunning = true;
	}

	void stop() {
		isRunning = false;
		reset();
	}

	void pause() {
		if (!isRunning) {
			return;
		}
		isRunning = false;
	}

	void reset() {
		elapsed = 0;
		*value = from;
	}

	void pause() {
		if (!isRunning) {
			return;
		}		
		isRunning = false;
	}

	void update(long delta) {
		if (isRunning) {
			elapsed += delta;
			elapsed = clamp(elapsed, 0L, duration);
			real percentComplete = elapsed/(cast(real)duration);
			if (percentComplete >= 1.0) {
				isRunning = false;
				if (onFinish) onFinish(this);
			} else {
				percentComplete = ease.ease(percentComplete);
				*value = scale!T(from, to, percentComplete);
			}
		}
	}

	auto getValue() {
		return value;
	}
}

/**
Utility class for building animations.
*/
class AnimationBuilder(T)
{
	alias void delegate(Animation!T) AnimationEvent;
	Animation!T animation;

	private this(T* value) {
		animation = new Animation!T(value);
	}

	static auto create(T* value) {
		assert(value);
		return new AnimationBuilder(value);
	}

	AnimationBuilder from(T start) {
		assert(animation);
		animation.setFrom(start);
		return this;
	}

	AnimationBuilder to(T to) {
		animation.setTo(to);
		return this;
	}

	auto lasting(Duration duration) {
		animation.setDuration(duration);
		return this;
	}
	auto lasting(long msecs) {
		animation.setDuration(msecs);
		return this;
	}

	auto ease(Ease e) {
		animation.setEase(e);
		return this;
	}

	auto onFinish(AnimationEvent fn) {
		animation.setOnFinish(fn);
		return this;
	}

	auto onUpdate(AnimationEvent fn) {
		animation.setOnUpdate(fn);
		return this;
	}

	auto get() {
		return animation;
	}
}