module dmise.ui.oglconsole;

pragma(lib, "DerelictSDL2");
extern(C) void OGLCONSOLE_Create();
extern(C) int OGLCONSOLE_SDLEvent(void *event);
extern(C) void OGLCONSOLE_Draw();

