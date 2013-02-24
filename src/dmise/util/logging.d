
module dmise.util.logging;


/**
Template to create a logger using the provided type.
*/
mixin template GetLogger(alias type)
{
	void log(string message) {
		debug writefln("[%s] (line %d): %s", type.stringof, message);
	}
}

/**
Mixin to insert a log function into the enclosing scope.
*/
mixin template Logger()
{
	mixin GetLogger!(typeof(this));
}

