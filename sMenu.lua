function drawMenu( lSlideOffset )
	if lSlideOffset == nil then lSlideOffset = 0 end

	--titel
	love.graphics.setBackgroundColor( bgcolor, _, _ )
	love.graphics.setColor(fontcolor, _, _)
	love.graphics.setFont( notperfect128 )
	love.graphics.printf('C urve Fever', lSlideOffset, 40, gui.width, "center" ) 

	--spieler
	love.graphics.setFont( pundak40 )
	love.graphics.printf('player', gui.width / 2 - 250 + lSlideOffset, menuY + 10, 0, 'center')
	love.graphics.printf('left', gui.width / 2 + 25 + lSlideOffset, menuY + 10, 0, 'center')
	love.graphics.printf('right', gui.width / 2 + 250 + lSlideOffset, menuY + 10, 0, 'center')

	love.graphics.setColor( playerframecolor, _, _ )
	love.graphics.rectangle('fill', gui.width / 2 - 400 + lSlideOffset, 70 + menuY, 800, fontSize * #menuplayers + 30)

	--hauptteil
	for var = 1, #menuplayers, 1 do
		local p = menuplayers[var]
		local localrgb = menurgb(var)

		if p == menuplayers[selectedPlayer] then 
			love.graphics.setColor( selectcolor, _, _ )
			love.graphics.rectangle('fill', gui.width / 2 - 385 + lSlideOffset, 21 + var * fontSize + menuY, 770 , fontSize)
			love.graphics.setFont( poetsen18 )
			if bindKey == 1 then 
				love.graphics.setColor( fontcolor, _, _)--uicolor, _, _, 255 )
				--love.graphics.printf('binding player ' .. p.n .. ' left key', 0 + lSlideOffset, menuY + 103 + #menuplayers * fontSize, gui.width, 'center')
				p.l = ''
				love.graphics.setFont( pundak40 )
				love.graphics.printf('?', gui.width / 2 + 25 + lSlideOffset, 30 + var * fontSize + menuY, 0, 'center')
			elseif bindKey == 2 then
				love.graphics.setColor( fontcolor, _, _)--uicolor, _, _, 255 )
				--love.graphics.printf('binding player ' .. p.n .. ' right key', 0 + lSlideOffset, menuY + 103 + #menuplayers * fontSize, gui.width, 'center')
				p.r = ''
				love.graphics.setFont( pundak40 )
				love.graphics.printf('?', gui.width / 2 + 250 + lSlideOffset, 30 + var * fontSize + menuY, 0, 'center')
			end
			love.graphics.setFont( pundak40 )
		end

		love.graphics.setColor(localrgb, _, _)
		love.graphics.printf(p.name, gui.width / 2 - 250 + lSlideOffset, 30 + var * fontSize + menuY, 0, 'center')
		love.graphics.printf(p.l, gui.width / 2 + 25 + lSlideOffset, 30 + var * fontSize + menuY, 0, 'center')
		love.graphics.printf(p.r, gui.width / 2 + 250 + lSlideOffset, 30 + var * fontSize + menuY, 0, 'center')
	end

	--score limiter
	love.graphics.setColor( uicolor, _, _, 255 )
	love.graphics.draw(maxscoreframe, gui.width / 2 + 350 - maxscoreframe:getWidth() / 2 + lSlideOffset + 175, gui.height / 2 - maxscoreframe:getHeight() / 2 - 14) 
	love.graphics.draw( maxscorearrow, 
					    gui.width / 2 + 350 - maxscoreframe:getWidth() / 2 + lSlideOffset + 220 - scorearrowAddOffs, 
					    gui.height / 2 - maxscoreframe:getHeight() / 2 - 50 + scorearrowAddOffs) 
	love.graphics.draw( maxscorearrow, 
						gui.width / 2 + 350 - maxscoreframe:getWidth() / 2 + lSlideOffset + 270 - scorearrowSubOffs, 
						gui.height / 2 - maxscoreframe:getHeight() / 2 + 113 + scorearrowSubOffs,
						math.pi) 
	love.graphics.setColor( limiterFontColor[1], _, _, 255 )
	love.graphics.setFont( pundak56 )
	love.graphics.printf(maxscore, gui.width / 2 + 350 - maxscoreframe:getWidth() / 2 + lSlideOffset + 175, gui.height / 2 - maxscoreframe:getHeight() / 2 - 5, maxscoreframe:getWidth(), 'center')

	--play-knopf
	love.graphics.setFont( notperfect96 )
    --if btnPlayPressed == true then
    if showPlay then
    	if showPlayTransparency < 255 then showPlayTransparency = showPlayTransparency + 15 end 
    	love.graphics.setColor(fontcolor[1],fontcolor[2],fontcolor[3], showPlayTransparency)
    	love.graphics.printf("P lay", lSlideOffset, gui.height - btnPlayY, gui.width, 'center')

		love.graphics.setFont( poetsen18 )
		love.graphics.setColor(uicolor[1], uicolor[2], uicolor[3], showPlayTransparency)
    	love.graphics.printf("push space", lSlideOffset, gui.height - btnPlayY + 100, gui.width, 'center')
    else
    	if showPlayTransparency > 0 then showPlayTransparency = showPlayTransparency - 15 end  
    	love.graphics.setColor(fontcolor[1],fontcolor[2],fontcolor[3], showPlayTransparency)
    	love.graphics.printf("P lay", lSlideOffset, gui.height - btnPlayY, gui.width, 'center')

    	love.graphics.setFont( poetsen18 )
		love.graphics.setColor(uicolor[1], uicolor[2], uicolor[3], showPlayTransparency)
    	love.graphics.printf("push space", lSlideOffset, gui.height - btnPlayY + 100, gui.width, 'center')
    end

    --fb bs
    love.graphics.setColor(uicolor, _, _)
    love.graphics.draw(facebook, 16 + lSlideOffset, gui.height - 110)

    --fadein am anfang
    love.graphics.setColor(0, 0, 0, 255 - splashTransparency)
    love.graphics.rectangle("fill", 0, 0, gui.width, gui.height)
end

function updateMenu( dt )
	for var = 1, #menuplayers, 1 do
		if menuplayers[var].r ~= '' then
			showPlay = true
			break
		else showPlay = false end
	end

	if bindKey == 0 
	and mouseMoved 
	and love.mouse.getX() > gui.width / 3 - 70 
	and love.mouse.getX() < gui.width / 3 + gui.width / 3 + 70
	and love.mouse.getY() > 75 + menuY 
	and love.mouse.getY() < 75 + menuY + fontSize * #menuplayers then 
		y = love.mouse.getY() - menuY
		for var = 0, #menuplayers + 1, 1 do
			if y < 21 + var * fontSize then 
				selectedPlayer = var - 1
				if selectedPlayer == 0 then selectedPlayer = 1 end
				break
			end
		end
	end

	if splashTransparency < 255 then splashTransparency = splashTransparency + 15 
	elseif splashTransparency > 255 then splashTransparency = 255 end
end

function keyMenu( key )
    	if key == btnPause 
       and not slidetogame 		then playPressed()
    elseif key == btnBind       then bindKey = 1
    elseif key == btnPrev       then prevPlayer()
    elseif key == btnNext       then nextPlayer()
    elseif key == btnRemove		then removePlayer()
    end
end

function defineCtrls( key )
	if selectedDir then menuplayers[selectedPlayer].l = key
	else menuplayers[selectedPlayer].r = key end

	selectedDir = not selectedDir
	bindKey = bindKey + 1
	if bindKey >= 3 then bindKey = 0 end
end

function playPressed()
	btnPlayPressed = true
	for var = 1, #menuplayers, 1 do
		if menuplayers[var].r ~= '' then
			makePlayerTable()
			slidetogame = true
			canvasblendalpha = 0
			canvasblend = false
    		slideOffset = gui.width
    		startGame()
    		break
		end
	end
end

function startGame()
	if players[1].l ~= '' then
		--canvas leeren
		love.graphics.setCanvas(canvas)
	    local width, height = canvas:getDimensions( )
	    canvas:clear()
	    
	    --powerups zurücksetzen
	    powerups = {}
	    poweruptimer = 0
	    powerupmax =  randomfloat( powerupMin, powerupMax )
	    collpowerups = 0 

		local help = 1
	    while players[help] ~= nil do
	        local p = players[help]
	        --'leere' spieler löschen
	        if p.l == '' then players[help] = nil
	        else
		        --spieler an einer zufälligen sicheren stelle im feld platzieren
		        p.x = math.random(canvas:getWidth( ) - 2 * frameWidth - 200) + frameWidth + 100
		        p.y = math.random(canvas:getHeight( ) - 2 * frameWidth - 200) + frameWidth + 100
		        p.o = math.random() * 2 * math.pi

		        --werte auf standard zurücksetzen
		        p.w = playerWidth
		        p.spd = basespeed
		        p.p = {}
		        p.t = false
		        p.rgb = randomrgb(tonumber(p.n))
		        p.sa = false
		        lb = true
		        lt = 0
		        lm = randomfloat(gapMin, gapMax)

		        --kurze linie hinter spieler zeichnen
	            love.graphics.setColor( p.rgb, _, _, 255 )
	            love.graphics.setLineWidth(p.w * 2)
	            love.graphics.line( p.x, p.y, p.x - math.cos( p.o ) * 25, p.y - math.sin( p.o ) * 25)
	        end

	        help = help + 1
	    end
	    alldead = false
	    lastalive = false
	    scores = sortScores()
	    love.graphics.setCanvas()
	    love.graphics.setColor(255, 255, 255, 255)
	    if #players == 1 then 
	    	singleplayer = true 
	    	players[1].s = 0
	    else singleplayer = false end
	    scores = sortScores()
	    alive = #players
	    winner = nil
	    maxScoreReached = false
	    drawLuxPowerup = nil 
	    love.graphics.setBackgroundColor( 0, 0, 0 )
		state = 3
		pointTaken = false
		canvasDim = 128

		pause()
	end
end