
module dmise.util.properties;

import std.array;
import std.conv;
import std.stdio;
import std.string;

/**
*/
auto loadProperties(string path)
{
	char[] buffer;
	auto inputFile = File(path, "r");
	string[string] props;

	while (inputFile.readln(buffer)) {
		string key;
		string value;

		buffer = strip(buffer);
		if (buffer.length == 0 || buffer[0] == '#') {
			continue;
		}

		buffer = unescape(buffer);
		auto tokens = split(buffer, ":");
		if (tokens.length >= 2) {
			key = text(tokens[0]);
			value = text(stripLeft(join(tokens[1 .. $])));
			//debug writeln("key = '", key, "'");
			//debug writeln("value = '", value, "'");
			props[key] = value;
		}
	}
	return props;
}

private auto unescape(char[] str)
{
	int src = 0; // src index
	int dst = 0; // dst index
	while (src < str.length) {
		char c = str[src++];
		if (c == '\\' && src != (str.length-1)) {
			switch (str[src]) {
				case 't': str[dst++] = '\t'; break;
				case 'n': str[dst++] = '\n'; break;
				case '\\': str[dst++] = '\\'; break;
				default: str[dst++] = c; break;
			}
			src++;
		} else {
			str[dst++] = c;
		}
	}
	return str[0 .. dst];
}

unittest
{
	auto props = loadProperties("res/config/default.properties");
	assert(props["player.rotation.speed"] == "0.03");
}

