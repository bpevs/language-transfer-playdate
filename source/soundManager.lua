local player <const> = playdate.sound.fileplayer

SoundManager = {}

SoundManager.kPause    = [[Language Transfer - Complete Spanish - Lesson 01]]
SoundManager.kResume   = [[Language Transfer - Complete Spanish - Lesson 01]]
SoundManager.kTimerEnd = [[Language Transfer - Complete Spanish - Lesson 01]]

local sounds <const> = {}

for _, v in pairs(SoundManager) do
    sounds[v] = player.new('Sounds/spanish/'..v)
    print(v, sounds[v])
end

SoundManager.sounds = sounds

function SoundManager:play(name)
    self.sounds[name]:play(1)
end
