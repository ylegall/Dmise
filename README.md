Dmise
=====

A 2D game written in D. Uses 
[Derelict3](https://github.com/aldacron/Derelict3) bindings to 
[SDL2](http://www.libsdl.org/).

Dependencies:
-------------
Building requries the following libraries:

* [SDL_ttf](http://www.libsdl.org/projects/SDL_ttf/).
* [SDL_image](http://www.libsdl.org/projects/SDL_image/).
* [SDL_mixer](http://www.libsdl.org/projects/SDL_mixer/).

Note: If you are building SDL mixer from source you may also need to 
install libasound2-dev and libpulse-dev.

Building on GNU/Linux
---------------------

First download, build, and install all dependencies (SDL, SDL_ttf, 
SDL_image, DMD D compiler, Derelict3 SDL/D bindings.)

SDL
---

    hg clone http://hg.libsdl.org/SDL/ -r c34a64af7751
    cd SDL
    ./configure
    make
    make install

SDL_ttf
---

    hg clone http://hg.libsdl.org/SDL_ttf/ -r 0f39dfa3546e
    cd SDL_ttf
    ./configure
    make
    make install

SDL_image
---

    hg clone http://hg.libsdl.org/SDL_image/ -r 18ab81286e51
    cd SDL_image
    ./configure
    make
    make install

DMD
---
Download and install "dmd" from:
http://dlang.org/download.html

Derelict3
---------
Download and install Derelict3 SDL2 bindings for D:

    git clone git://github.com/aldacron/Derelict3.git
    cd Derelict3/build
    rdmd build.d # rdmd might fail, try dmd

Dmise
-----
Download and build Dmise:

    git clone git@github.com:ylegall/Dmise.git
    cd Dmise
    ln -s ../Derelict3/lib lib # Your path here may be different
    make

TODO
----
* Which revisions of Dmise are most likely to build?
* How to build SDL_mixer.
* Give Dmise a TTF font in res/fonts
* Give Dmise a splash image in res/images
