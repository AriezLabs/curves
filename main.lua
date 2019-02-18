function love.load()
	math.randomseed(os.time())
	--ausgelagerte funktionen laden
	require 'sLoading'
	require 'sMenu'
	require 'sIngame'
	require 'sPause'
	require 'player'
	--andere dinge laden
	state = 1					--state: 1 laden, 2 menü, 3 spiel, 4 pause
	bindKey = 0					--zusätzlicher state, 1 oder 2 wenn die linke bzw rechte steuerung im menü festgelegt wird
	runtime = 0					--laufzeit in sekunden
	menuplayers = newPTable()   --tabelle mit allen spieler"objekten"
	players = {}				--spieler
	gui = uiCoords()			--koordinaten etc. für die oberfläche
	canvas = bgCanvas()			--canvas aka spielfeld
	loadSprites() 				--daten laden
	love.window.setIcon( icon )	--icon setzen
	alive = 0 					--anzahl an lebenden spielern
	winner = nil 				--gewinner der runde
	menuY = gui.height / 2 - 255--y offset vom menü
	lastX, lastY = love.mouse.getPosition( ) --letzte x/y koordinate der maus
	--powerups
	powerups = {}				--alle powerups, die momentan auf dem spielfeld sind
	poweruptimer = 0 			--spawntimer vom nächsten powerup
	powerupmax = randomfloat( powerupMin, powerupMax ) --teil des spawntimers
	collpowerups = 0 			--keine ahnung
	--menürelevante dinge laden
	selectedPlayer = 1 			--momentan ausgewählter spieler im menü
	selectedDir = true 			--ka
	--technisches zeug
	love.graphics.setLineStyle('smooth')
	slidetogame = false 		--slideanimation richtung spiel aktiv?
	slidetomenu = false			--slide richtung menü aktiv?
	canvasblend = false 		--fadeout bei ende einer runde
	canvasblendalpha = 0 		--aktuelle transparenz von fadeout
	slideOffset = 0 			--aktuelle x koordinate der slide animation
	btnBackPressed = false
	btnPlayPressed = false
	playArrowX = 269 			--koordianten vom pfeil auf dem play knopf
	playArrowY = 31
	playArrowDir = "left" 		--richtung der animation vom pfeil
	maxscore = 30
	scorearrowAddOffs = 0 		--offset vom add button des score zählers, gebraucht für feedback beim anklicken
	scorearrowSubOffs = 0 		--offset subtract button
	maxScoreReached = false
	drawLuxPowerup = nil 		--spezielles zeug für ein spezielles powerup
	limiterFontColor = { menurgb( maxscore / 10 ), _, _ } --font farbe vom score limiter
	collectGarbage = 0
	resetTimer()
	showPlayTransparency = 0
	showPlay = false
	canvasDim = 0
	dimCanvas = false
	splashTransparency = 0
	revertSplashTransparency = false
	emptyCursor = love.mouse.newCursor( 'assets/cursor.png', 0, 0 )
	love.mouse.setCursor( emptyCursor )

	local _, _, flags = love.window.getMode()
    local width, height = love.window.getDesktopDimensions( flags.display )

    if love.system.getOS( ) == 'Windows' then
        love.window.setMode( width, height, {fullscreentype = 'normal', borderless = true, display = flags.display} )
    else
        love.window.setMode( width, height )
        love.window.setFullscreen( true )
    end

    --recalculate canvas etc.
    canvas = bgCanvas()
    gui = uiCoords()
end

function love.update( dt )
	runtime = runtime + dt

		if state == 1 then updateLoading()
	elseif state == 2 then updateMenu( dt )
	elseif state == 3 then updateIngame( dt )
	elseif state == 4 then updatePause( dt )
	else print('ERROR: UNKNOWN STATE') 
	end

	--ab und zu garbagecollection ausführen, um memory leak zu fixen
	collectGarbage = collectGarbage + dt
	if collectGarbage > collectGarbageMax then
		collectgarbage()
		collectGarbage = 0
	end

	if lastX == love.mouse.getX() and lastY == love.mouse.getY() then
		mouseMoved = false
	else
		mouseMoved = true
		lastX = love.mouse.getX() 
		lastY = love.mouse.getY()
	end

	if dimCanvas and canvasDim < 128 then canvasDim = canvasDim + 16
    elseif not dimCanvas and canvasDim > 0 then canvasDim = canvasDim - 16 end
end

function love.draw()
		if state == 1 then drawLoading()
	elseif state == 2 then drawMenu()
	elseif state == 3 then drawIngame()
	elseif state == 4 then drawPause()
	else print('ERROR: UNKNOWN STATE') 
	end
	love.graphics.setColor(255, 255, 255, 255)
end

function love.keypressed( key )
	if key == btnQuit then 
		if state < 3 then 
			love.event.quit() 
		elseif slideOffset == 0 then
			if not canvasblend and not alldead then pause(true) end
			slidetomenu = true
			btnBackPressed = true
		end
	end

	if bindKey == 0 then

	    	if state == 1 then keyLoading( key )	--splash überspringen
	    elseif state == 2 then keyMenu( key )		--menüspezifische eingaben
	    elseif state == 3 then keyIngame( key )		--spielspezifische eingaben
	    elseif state == 4 then keyPause( key ) 		--pausenspezifische eingaben
	    end

	else
		defineCtrls( key )
	end
end

function love.keyreleased( key )
	if key == 'escape' then
    	btnBackPressed = false
    elseif key == ' ' then
    	btnPlayPressed = false
    end
end

function love.resize()

end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function pause( p )
		if p == true  then state = 4 dimCanvas = true
	elseif p == false then state = 3 dimCanvas = false
	elseif state == 3 then state = 4 dimCanvas = true
	elseif state == 4 then state = 3 dimCanvas = false end
end

function randomrgb( num )
	--	if num == 3 then return { 25, 200, 200 }
	--elseif num == 5 then return { 90, 25, 210 }
	--elseif num == 2 then return { 200, 90, 90 }
	--elseif num == 4 then return { 200, 150, 0 }
	--elseif num == 1 then return { 90, 200, 15 }
	--else return {math.random(25, 255), math.random(25, 255), math.random(25, 255)}
	--end
		if num == 3 then return { 119, 201, 171 }
	elseif num == 5 then return { 151, 114, 176 }
	elseif num == 2 then return { 206, 146, 116 }
	elseif num == 4 then return { 206, 176, 71 }
	elseif num == 1 then return { 151, 201, 79 }
	else return {math.random(25, 255), math.random(25, 255), math.random(25, 255)}
	end
end

function menurgb( num )
		if num == 3 then return { 119, 201, 171 }
	elseif num == 5 then return { 151, 114, 176 }
	elseif num == 2 then return { 206, 146, 116 }
	elseif num == 4 then return { 206, 176, 71 }
	elseif num == 1 then return { 151, 201, 79 }
	else return {math.random(25, 255), math.random(25, 255), math.random(25, 255)}
	end
end

function love.mousepressed(x, y, button)
	--ingame buttons
	if state >= 3 then
		--wenn auf den zurück-knopf geklickt wurde
		if x > 29 + slideOffset and x < 125 + slideOffset 
		and y > 25 and y < 121 then
			btnBackPressed = true
		end

	--menü buttons
	elseif state == 2 then
		if  x > gui.width / 2 - btnplay:getWidth() / 2 + slideOffset 
		and x < gui.width / 2 + btnplay:getWidth() / 2 + slideOffset 
		and y > gui.height - btnPlayY
		and y < gui.height - btnPlayY + btnplay:getHeight() then
			btnPlayPressed = true

		--spielerauswahl
    	elseif bindKey == 0 and x > gui.width / 3 - 70 and x < gui.width / 3 + gui.width / 3 + 70
		and y > 75 + menuY and y < 75 + menuY + fontSize * #menuplayers then 
			if button == mouseAdd then bindKey = 1
			elseif button == mouseRemove then removePlayer()
			end

		--score limiter rechts
		elseif  x > gui.width / 2 + 350 + 150
		and x < gui.width / 2 + 350 + maxscorearrow:getWidth() + 150
		and y > gui.height / 2 - 94
		and y < gui.height / 2 - 94 + maxscorearrow:getHeight() then
			if maxscore < 90 then 
				maxscore = maxscore + 10 
				newLimiterFontColor()
			end
			scorearrowAddOffs = 3

		elseif  x > gui.width / 2 + 350 + 145
		and x < gui.width / 2 + 350 + maxscorearrow:getWidth() + 145
		and y > gui.height / 2 + 40
		and y < gui.height / 2 + 40 + maxscorearrow:getHeight() then
			if maxscore > 10 then 
				maxscore = maxscore - 10 
				newLimiterFontColor()
			end
			scorearrowSubOffs = 3
		end
	end
end

function love.mousereleased(x, y, button)
	--ingame buttons
	if state >= 3 then
		if x > 29 + slideOffset and x < 125 + slideOffset 
		and y > 25 and y < 121
		and not slidetogame and btnBackPressed == true then
			slidetomenu = true
		end
		btnBackPressed = false

	--menü buttons
	elseif state == 2 then
		--play-button
		if btnPlayPressed == true and bindKey == 0 
		and x > gui.width / 2 - btnplay:getWidth() / 2 + slideOffset 
		and x < gui.width / 2 + btnplay:getWidth() / 2 + slideOffset 
		and y > gui.height - btnPlayY
		and y < gui.height - btnPlayY + btnplay:getHeight() then
			for var = 1, #menuplayers, 1 do
				if menuplayers[var].r ~= '' then
					makePlayerTable()
					slidetogame = true
		    		slideOffset = gui.width
		    		startGame()
				end
			end
		end
    	btnPlayPressed = false
    	scorearrowAddOffs = 0
    	scorearrowSubOffs = 0
	end
end

function makePlayerTable()
	players = {}
	for var = 1, #menuplayers, 1 do
		if menuplayers[var].r ~= '' then
			table.insert(players, menuplayers[var])
		end
	end
end

function randomfloat( min, max )
	return min + ((max - min) * math.random())
end

function vectorlength(x, y)
    return math.sqrt( x * x + y * y )
end

function newLimiterFontColor()
	local rgb = maxscore / 10
	if rgb > 5 then rgb = rgb - 5 end
	limiterFontColor = { menurgb( rgb ), _, _ }
end

function resetTimer()
	stime = love.timer.getTime()
end

function printTimer(string)
	etime = love.timer.getTime()
	print(string .. ':\t' .. 1000*(etime - stime))
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end