# Language Transfer PlayDate (Unofficial)

Basically, because I like using the physical keys for audio playback, so that I can pause/play the audio without looking at a screen. Probably don't use this app yet, since it's hard-coded to Spanish, and you need to compile it yourself to include all the mp3 files.

Todo: update to be an agnostic mp3 player, so that the user can just dump in the folder of whatever download(s) from [language-transfer](https://www.languagetransfer.org/free-courses-1) and load (currently, this is done during compile; it should be done by end-user instead, like  [musik](https://github.com/nanobot567/musik) or [kicooya](https://kicooya.com)).

## Usage

copy audio from [language transfer](https://www.languagetransfer.org/free-courses-1#complete-spanish) and place in `source/Sounds/spanish`

compile: `pdc source/main.lua language-transfer-spanish.pdx`
