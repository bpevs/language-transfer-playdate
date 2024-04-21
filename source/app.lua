import 'CoreLibs/timer'

import 'dynamicText'

local fs            <const> = playdate.file
local menu          <const> = playdate.getSystemMenu()
local store         <const> = playdate.datastore.read()
local timer         <const> = playdate.timer
local clock         <const> = DynamicText(200, 120, 'Mikodacs-Clock')
local player        <const> = playdate.sound.fileplayer
local sounds        <const> = {}
local track         <const> = {}
local isPaused      = true
local isPlaying = true
local activeTimer
SoundManager = {}
App = {}

fs.mkdir("/courses/")

for i=1, 90 do
  track[i] = string.format("%02d", i or 1)
  SoundManager[track[i]] = [[Language Transfer - Complete Spanish - Lesson ]] .. track[i]
end

local tracks = store and store.tracks or track[1]

for _, v in pairs(SoundManager) do
    sounds[v] = player.new('courses/spanish/'..v)
end

SoundManager.sounds = sounds

function SoundManager:play(name)
    if self.sounds[name] then self.sounds[name]:play(1) end
end

function SoundManager:pause(name)
    if self.sounds[name] then self.sounds[name]:pause() end
end

function SoundManager:stop(name)
    if self.sounds[name] then
        self.sounds[name]:setOffset(0)
        self.sounds[name]:pause()
    end
end

function SoundManager:getLength(name)
    if self.sounds[name] then
        return math.ceil(self.sounds[name]:getLength())
    end
    return 0
end

-- private functions:

local function millisecondsFromSeconds(minutes)
    return 1000 * minutes
end

local function minutesAndSecondsFromMilliseconds(ms)
    local  s <const> = math.floor(ms / 1000) % 60
    local  m <const> = math.floor(ms / (1000 * 60)) % 60
    return m, s
end

local function addLeadingZero(num)
    if num < 10 then
        return '0'..num
    end
    return num
end

local function resetTimer(ms)
    if activeTimer then
        activeTimer:remove()
    end
    activeTimer = timer.new(ms)
end

local function resetPlayer()
    isPlaying = true
    local trackNum = string.format("%02d", tracks or 1)
    local len = SoundManager:getLength(SoundManager[trackNum])

    resetTimer(millisecondsFromSeconds(len))
    playdate.display.setInverted(true)
end

local function resetRestTimer()
    isPlaying = false
    playdate.display.setInverted(false)
end

local function updateClock()
    local m, s = minutesAndSecondsFromMilliseconds(activeTimer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)
    local text = m..':'..s

    if text ~= clock.content then
        clock:setContent(text)
    end
end

local function changeInterval(resetFn)
    isPaused = true
    resetFn()
    updateClock()
    sprite.update()
end

-- public methods:

function App:setup()
    menu:addOptionsMenuItem('track', track, tracks, function(choice)
        local trackNum = string.format("%02d",tracks or 1)
        local len = SoundManager:stop(SoundManager[trackNum])
        tracks = choice
        changeInterval(resetPlayer)
    end)

    resetPlayer()
    playdate.setAutoLockDisabled(true)
    playdate.display.setRefreshRate(15)
end

function App:pause()
    -- print('pause: '..activeTimer.timeLeft) -- DEBUG
    playdate.setAutoLockDisabled(false)
    playdate.stop() -- prevents the next playdate.update() callback
end

function App:resume()
    -- print('resume: '..activeTimer.timeLeft) -- DEBUG
    resetTimer(activeTimer.timeLeft)
    playdate.setAutoLockDisabled(true)
    playdate.start()
end

function App:update()
    if isPaused then
        self:pause()
    end

    updateClock()

    if activeTimer.timeLeft == 0 then
        isPaused = true

        if isPlaying then
            resetRestTimer()
        else
            resetPlayer()
        end
        -- a timer start automatically when created, let's pause it before the `updateTimers()`
        -- to try and be as precise as possible
        activeTimer:pause()
    end

    sprite.update()
    timer.updateTimers()
end

function App:resumeOrPause()
    isPaused = not isPaused
    local trackNum = string.format("%02d",tracks or 1)
    if isPaused then
        SoundManager:pause(SoundManager[trackNum])
        activeTimer:pause()
    else
        SoundManager:play(SoundManager[trackNum])
        self:resume()
    end
end

function App:write()
    playdate.datastore.write({ tracks = tracks })
end
