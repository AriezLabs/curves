--ui settings
splashTimer = 2
blendspeed = 15
slidespeed = 100
frameWidth = 3
frameColor = { 64, 64, 64 }
uicolor = { 100,100,100 }
bgcolor = { 0,0,0 }
playerframecolor = { 20,20,20 }
selectcolor = { 40,40,40 }
canvascolor = { 0, 0, 0 }
fontcolor = {235,227,170}
btnPlayY = 200
menuY = 225 --changed in love.load()
playerWidth = 3
maxPlayers = 5
fontSize = 64

basespeed = 125
turnspeed = 3

--antialiasing
fsaa = 8

--garbagecollection intervall in sec - je laenger, desto eher kommen lagspikes
collectGarbageMax = 0.02

--lücken
gapMin = 1
gapMax = 2
gapSize = 0.2

--spawnintervall der powerups
powerupMin = 3
powerupMax = 5

--spawnwahrscheinlichkeiten
PSpawnUrgot = 7
PSpawnUrgotG = 12
PSpawnThin = 25
PSpawnThinG = 35
PSpawnFat = 45
PSpawnFatG = 60
PSpawnSpeed = 70
PSpawnSpeedG = 80
PSpawnSlow = 90
PSpawnSlowG = 100
PSpawnLux = 107

--timer für dick/dünn/schnell
effectTimer = 10
--geschwindigkeitsboost
spdBoost = 1.7
--dick/dünn multi
fatMult = 2
--channel zeit von der urgot ulti
pwrUrgotChannel = 0.2
--channel geschwindigkeit von lux ulti
pwrLuxChannel = 3
pwrLuxMainFade = 5

--werte über 0.3 machen alles kapott
collStrictness = 0.25

--steuerung
btnQuit = 'escape'
btnBind = 'return'
btnPrev = 'up'
btnNext = 'down'
btnPause = ' '
btnRemove = 'r'
mouseAdd = 'l'
mouseRemove = 'r'

function love.conf( t )
	--window size
	t.window.resizable = false
	t.window.width = 750
	t.window.height = 325
    --display mode
	t.window.borderless = true
	t.window.fullscreen = false
	t.window.vsync = true
    t.window.fsaa = 8
    t.window.highdpi = false
    t.window.srgb = false    
	--window properties
	t.window.icon = nil
	t.title = "Curve Fever"
	--modules
	t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.thread = true
    t.modules.timer = true
    t.modules.window = true
end