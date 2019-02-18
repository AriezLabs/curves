function drawPause()
    --slide-effekt
    if slideOffset ~= 0 then
        drawMenu(gui.width - gui.width - (gui.width - slideOffset))
    end

    --score ausgeben
    love.graphics.setFont( pundak96 )
    for var = 1, #players, 1 do
        love.graphics.setColor(scores[var][2], _, _, 255 )
        love.graphics.printf(scores[var][1], gui.frameX + canvas:getWidth() + 30 + slideOffset, (canvas:getHeight() / 2 - 60 * #players) + 120 * (var - 1), gui.frameX, 'left')
    end

    --canvas zeichnen
    love.graphics.setColor(255, 255, 255, 255 - canvasblendalpha)
    love.graphics.draw(canvas, gui.frameX + slideOffset)

    --spieler (gelbe kreise) zeichnen
    local help = 1
    love.graphics.setColor( 255, 255, 0, 255 - canvasblendalpha )
    while players[help] ~= nil do
        local p = players[help]
        love.graphics.circle( 'fill', p.x + gui.frameX + slideOffset, p.y, p.w )
        help = help + 1
    end

    --powerups zeichnen
    love.graphics.setColor(255, 255, 255, 255 - canvasblendalpha)
    for key,value in pairs(powerups) do
        local pwr = powerups[key]
        love.graphics.draw( pwr.sprite, pwr.x + gui.frameX + slideOffset, pwr.y, 0, 1, 1, 32, 32 )
    end
    love.graphics.setFont( love.graphics.newFont(12) )
    love.graphics.setColor(uicolor, _, _, 255 - canvasblendalpha)

    --zähler links zeichnen
    love.graphics.setFont( pundak40 )
    love.graphics.printf('alive', slideOffset, gui.height / 2 + 15, gui.frameX, 'center')
    love.graphics.setFont( pundak96 )
    love.graphics.printf(alive, slideOffset, gui.height / 2 - 110, gui.frameX, 'center')

    --zurück-knopf
    if btnBackPressed == true then love.graphics.draw(btnbackpressed, 25 + slideOffset, 25)
    else love.graphics.draw(btnback, 25 + slideOffset, 25) end

    --lux powerup
    if drawLuxPowerup ~= nil then
        for var = -pwrLuxChannel, canvas:getWidth() / luxPre:getWidth() + 1, 1 do
            love.graphics.draw(drawLuxPowerup.sprite, drawLuxPowerup.x + gui.frameX + slideOffset, drawLuxPowerup.y, drawLuxPowerup.ori, 1, drawLuxPowerup.scale, -var * luxPre:getWidth() + drawLuxPowerup.offset)
            love.graphics.draw(drawLuxPowerup.sprite, drawLuxPowerup.x + gui.frameX + slideOffset, drawLuxPowerup.y, drawLuxPowerup.ori, 1, -drawLuxPowerup.scale, -var * luxPre:getWidth() + drawLuxPowerup.offset)
        end
    end
    
    --scorelimit ausgeben
    if not singleplayer then
        love.graphics.setColor(uicolor, _, _, 255)
        love.graphics.setFont( pundak56 )
        love.graphics.printf(maxscore, gui.frameX + canvas:getWidth() + slideOffset, 15, gui.frameX, 'center')
        love.graphics.setFont( pundak40 )
        love.graphics.printf('goal', gui.frameX + canvas:getWidth() + slideOffset, 75, gui.frameX, 'center')
    end

    --spielfeld abdunkeln
    love.graphics.setColor(0, 0, 0, canvasDim)
    love.graphics.rectangle('fill', gui.frameX + slideOffset, 0, canvas:getWidth(), gui.height)

    --rahmen zeichnen
    love.graphics.setColor(frameColor, _, _, 255)
    love.graphics.rectangle( 'fill', gui.frameX + slideOffset, 0, canvas:getWidth(), frameWidth )
    love.graphics.rectangle( 'fill', gui.frameX + slideOffset, 0, frameWidth, canvas:getHeight() )
    love.graphics.rectangle( 'fill', gui.frameX + slideOffset, canvas:getHeight() - frameWidth, canvas:getWidth(), frameWidth)
    love.graphics.rectangle( 'fill', gui.frameX + canvas:getWidth() - frameWidth + slideOffset, 0, frameWidth, canvas:getHeight())
    love.graphics.setColor(255, 255, 255, 255)

    --pause zeichen zeichnen
    love.graphics.setFont( poetsen128 )
    --love.graphics.setColor(234, 229, 199, 255 - canvasblendalpha)
    local alpha = canvasDim * 1.9
    if alpha > 255 - canvasblendalpha then alpha = 255 - canvasblendalpha end

    love.graphics.setColor(uicolor[1], uicolor[2], uicolor[3], alpha)
    love.graphics.printf('paused', slideOffset, gui.height / 2 - 96, gui.width, 'center')
    love.graphics.setFont( love.graphics.newFont(12) )
end

function updatePause( dt )
    if canvasblend == false and canvasblendalpha > 0 then canvasblendalpha = canvasblendalpha - blendspeed end

    --slide-effekt vom menü
    if slidetogame == true and slideOffset > 1 then 
        slideOffset = slideOffset - 2 - slidespeed * math.sin((1 - slideOffset / gui.width) * math.pi)
    elseif slidetogame == true and slideOffset <= 1 then 
        slidetogame = false
        slideOffset = 0
    end

    --slide-effekt zum menü
    if slidetomenu == true and slideOffset < gui.width then 
        slideOffset = slideOffset + 2 + slidespeed * math.sin((1 - slideOffset / gui.width) * math.pi)
    elseif slidetomenu == true and slideOffset >= gui.width then 
        slidetomenu = false
        state = 2 
        slideOffset = 0
        for var = 1, #players, 1 do
            players[var].s = 0
        end
    end
end

function keyPause( key )
    if key == btnPause and not blend then pause( false ) end
end