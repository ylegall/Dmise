
module dmise.sound;



//auto init()
//{
//	// Prototype of our callback function
//	void my_audio_callback(void *userdata, Uint8 *stream, int len);

//	SDL_AudioSpec desired, obtained;    // open the audio device
//	desired.freq = 22050;                 // 22050Hz - FM Radio quality
//	desired.format = AUDIO_S16SYS;        // 16-bit signed audio
//	desired.channels = 2;                 // stereo

//	/* Large audio buffer reduces risk of dropouts but increases response time */
//	desired.samples=4096;

//	/* Our callback function */
//	desired.callback = my_audio_callback;
//	desired.userdata = null;

//	// Open the audio device:
//	if (SDL_OpenAudio(&desired, &obtained) < 0 ) {
//		writeln("could not open audio: ", SDL_GetError());
//		assert(false);
//	}

//	/* Prepare callback for playing */

//	/* Start playing */

//	SDL_PauseAudio(0);
//}

//auto playSound()
//{
//	SDL_AudioSpec wav_spec;
//	Uint32 wav_length;
//	Uint8 *wav_buffer;

//	/* Load the WAV */
//	if( SDL_LoadWAV("test.wav", &wav_spec, &wav_buffer, &wav_length) == NULL ){
//		fprintf(stderr, "Could not open test.wav: %s\n", SDL_GetError());
//		exit(-1);
//	}

//	/* Do stuff with the WAV */

//	/* Free It */

//	SDL_FreeWAV(wav_buffer);
//}


//void audioCallback(void* udata, Uint8* stream, int len)
//{
//	CallbackData d = *(CallbackData *)udata;
//	if (d.isEnabled) {
//		if (d.bufCurr < d.bufMax) {
//			if (d.bufCurr+len > d.bufMax) {
//				len = d.bufMax - d.bufCurr;
//			}
//			((CallbackData *)udata)->bufCurr += len;
//			SDL_MixAudio(stream, d.bufCurr, len, SDL_MIX_MAXVOLUME);
//		} else {
//			d.isEnabled = 0; /* disable self */
//			SDL_SemPost(d.playEnded);
//		}
//	}
//}

//struct Clip
//{
//	SDL_AudioSpec wav_spec;
//	Uint32 wav_length;
//	Uint8 *wav_buffer;

//	void load(string path) {

//	}

//	void play()
//}
