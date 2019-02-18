function drawLoading()
    love.graphics.draw( splash, gui.width / 2 - 300, gui.height / 2 - 150 )
    love.graphics.setColor(0, 0, 0, 255 - splashTransparency)
    love.graphics.rectangle("fill", 0, 0, gui.width, gui.height)
end

--wechsel zum menüzustand, wenn der splash timer um ist
function updateLoading( dt, changeState )
    if splashTransparency < 255 and not revertSplashTransparency then splashTransparency = splashTransparency + 15 
    elseif splashTransparency >= 255 then splashTransparency = 255 revertSplashTransparency = true end

    if runtime > splashTimer or changeState ~= nil then
        if revertSplashTransparency then splashTransparency = splashTransparency - 15 end
        if splashTransparency <= 0 then state = 2 love.mouse.setCursor( ) end
    end
    print(splashTransparency)
end

function keyLoading( key )
    updateLoading( 0, 1 )  --skip the splash
end

function bgCanvas()
    return love.graphics.newCanvas( (gui.width - 2 * gui.frameX) - 2 * frameWidth, gui.height - 2 * frameWidth, 'normal', fsaa )
end

function uiCoords()
    local _, _, lFlags = love.window.getMode()
    local lWidth, lHeight = love.window.getDesktopDimensions( lFlags.display )
    gui = { flags = lFlags
,           width = lWidth
,           height = lHeight
}   
    gui.frameX = (lWidth - lHeight) / 2

    return gui
end

function loadSprites()
    --general stuff
    splash = love.graphics.newImage('assets/splash.png') 
    icon = love.image.newImageData('assets/icon.png')
    title = love.graphics.newImage('assets/title.png')
    facebook = love.graphics.newImage('assets/facebook.png')

    --fonts
    pundak96 = love.graphics.newFont('assets/Poetsen.ttf', 96)
    pundak40 = love.graphics.newFont('assets/Poetsen.ttf', 40)
    poetsen18 = love.graphics.newFont('assets/Poetsen.ttf', 18)
    poetsen128 = love.graphics.newFont('assets/Poetsen.ttf', 128)
    pundak56 = love.graphics.newFont('assets/Poetsen.ttf', 56)
    notperfect128 = love.graphics.newFont('assets/notperfect.ttf', 128)
    notperfect96 = love.graphics.newFont('assets/notperfect.ttf', 96)

    imgpause = love.graphics.newImage('assets/pause.png') 
    skull = love.graphics.newImage('assets/skull.png') 
    btnback = love.graphics.newImage('assets/back.png') 
    btnbackpressed = love.graphics.newImage('assets/backpressed.png') 
    btnplay = love.graphics.newImage('assets/play.png') 
    btnplaypressed = love.graphics.newImage('assets/playpressed.png') 
    playarrow = love.graphics.newImage('assets/playarrow.png') 
    maxscoreframe = love.graphics.newImage('assets/maxscore.png') 
    maxscorearrow = love.graphics.newImage('assets/maxscorearrow.png') 
    luxPre = love.graphics.newImage('assets/luxPre.png') 
    luxMain = love.graphics.newImage('assets/luxMain.png') 
    --64x64 powerup images
    pwrUrgot =  love.graphics.newImage('assets/pwrUrgot.png') 
    pwrUrgotG =  love.graphics.newImage('assets/pwrUrgotG.png')
    pwrThin =  love.graphics.newImage('assets/pwrThin.png') 
    pwrThinG =  love.graphics.newImage('assets/pwrThinG.png') 
    pwrFat =  love.graphics.newImage('assets/pwrFat.png')
    pwrFatG =  love.graphics.newImage('assets/pwrFatG.png') 
    pwrSpeed =  love.graphics.newImage('assets/pwrSpeed.png')
    pwrSpeedG =  love.graphics.newImage('assets/pwrSpeedG.png')
    pwrSlow =  love.graphics.newImage('assets/pwrSlow.png')
    pwrSlowG = love.graphics.newImage('assets/pwrSlowG.png')
    pwrLux = love.graphics.newImage('assets/pwrLux.png')
end