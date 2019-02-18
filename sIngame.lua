function drawIngame()
    --slide-effekt
    if slideOffset ~= 0 then
        drawMenu(gui.width - gui.width - (gui.width - slideOffset))
    end

    --totenkopf/zähler links
    love.graphics.setColor(uicolor, _, _, 255)
    love.graphics.setFont( pundak40 )
    if alldead then
        love.graphics.draw(skull, gui.frameX / 2 - skull:getWidth() / 2 + 5 + slideOffset, gui.height / 2 - skull:getHeight() / 3 * 2 - 15)
        if not singleplayer then 
            local s = ''
            if winner ~= nil then
                love.graphics.setColor( winner.rgb, _, _, 255 )
                s = winner.name
            else
                love.graphics.setColor(uicolor, _, _, 255 )
                s = 'nobody'
            end
            love.graphics.printf(s .. ' wins', slideOffset, gui.height / 2 + skull:getHeight() / 2 - 35, gui.frameX, 'center') 
            love.graphics.setColor(uicolor, _, _, 255)
        end
    else
        love.graphics.printf('alive', slideOffset, gui.height / 2 + 15, gui.frameX, 'center')
        love.graphics.setFont( pundak96 )
        love.graphics.printf(alive, slideOffset, gui.height / 2 - 110, gui.frameX, 'center')
    end

    --score ausgeben
    love.graphics.setFont( pundak96 )
    for var = 1, #players, 1 do
        love.graphics.setColor(scores[var][2], _, _, 255 )
        love.graphics.print(scores[var][1], gui.frameX + canvas:getWidth() + 30 + slideOffset, (canvas:getHeight() / 2 - 60 * #players) + 120 * (var - 1))
    end
    love.graphics.setFont( love.graphics.newFont(12) )

    --scorelimit anzeigen
    if not singleplayer then
        love.graphics.setColor(uicolor, _, _, 255)
        love.graphics.setFont( pundak56 )
        love.graphics.printf(maxscore, gui.frameX + canvas:getWidth() + slideOffset, 15, gui.frameX, 'center')
        love.graphics.setFont( pundak40 )
        love.graphics.printf('goal', gui.frameX + canvas:getWidth() + slideOffset, 75, gui.frameX, 'center')
    end

    --canvas zeichnen
    love.graphics.setColor(255, 255, 255, 255 - canvasblendalpha)
    love.graphics.draw(canvas, gui.frameX + slideOffset)

    --spieler (gelbe kreise) zeichnen
    local help = 1
    love.graphics.setColor(255, 255, 0, 255 - canvasblendalpha)
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

    --lux powerup
    if drawLuxPowerup ~= nil then
        for var = -pwrLuxChannel, canvas:getWidth() / luxPre:getWidth() + 1, 1 do
            love.graphics.draw(drawLuxPowerup.sprite, drawLuxPowerup.x + gui.frameX + slideOffset, drawLuxPowerup.y, drawLuxPowerup.ori, 1, drawLuxPowerup.scale, -var * luxPre:getWidth() + drawLuxPowerup.offset)
            love.graphics.draw(drawLuxPowerup.sprite, drawLuxPowerup.x + gui.frameX + slideOffset, drawLuxPowerup.y, drawLuxPowerup.ori, 1, -drawLuxPowerup.scale, -var * luxPre:getWidth() + drawLuxPowerup.offset)
        end
    end

    --ggf spielfeld aufhellen
    love.graphics.setColor(0, 0, 0, canvasDim)
    love.graphics.rectangle('fill', gui.frameX + slideOffset, 0, canvas:getWidth(), gui.height)

    --ggf pause zeichen zeichnen
    love.graphics.setFont( poetsen128 )
    --love.graphics.setColor(234, 229, 199, 255 - canvasblendalpha)
    local alpha = canvasDim * 1.9
    if alpha > 255 - canvasblendalpha then alpha = 255 - canvasblendalpha end

    love.graphics.setColor(uicolor[1], uicolor[2], uicolor[3], alpha)
    if canvasDim > 0 then love.graphics.printf('paused', slideOffset, gui.height / 2 - 96, gui.width, 'center') end
    love.graphics.setFont( love.graphics.newFont(12) )

    --rahmen zeichnen
    love.graphics.setColor(frameColor, _, _, 255)
    love.graphics.rectangle( 'fill', gui.frameX + slideOffset, 0, canvas:getWidth(), frameWidth )
    love.graphics.rectangle( 'fill', gui.frameX + slideOffset, -frameWidth, frameWidth, canvas:getHeight() )
    love.graphics.rectangle( 'fill', gui.frameX + slideOffset, canvas:getHeight() - frameWidth, canvas:getWidth(), frameWidth)
    love.graphics.rectangle( 'fill', gui.frameX + canvas:getWidth() - frameWidth + slideOffset, 0, frameWidth, canvas:getHeight())
    love.graphics.setColor(bgcolor, _, _, 255)
    love.graphics.rectangle( 'fill', gui.frameX + slideOffset, canvas:getHeight(), canvas:getWidth(), frameWidth * 2)
    love.graphics.setColor(255, 255, 255, 255)

    --jemand gewinnt
    if canvasblend and not singleplayer and scores[1][1] >= maxscore and scores[1][1] > scores[2][1] then
        love.graphics.setColor(0, 0, 0, canvasblendalpha)
        love.graphics.rectangle( 'fill', slideOffset, 0, gui.width, gui.height )
        love.graphics.setColor( scores[1][2][1], scores[1][2][2], scores[1][2][3], canvasblendalpha )
        love.graphics.setFont( notperfect128 )
        local max = 1
        for var = max, #players, 1 do
            if players[var].s > players[max].s then max = var end
        end
        love.graphics.printf(firstToUpper(players[max].name) .. ' wins!', slideOffset, gui.height / 2 - 64, gui.width, 'center')
    end

    --zurück-knopf
    love.graphics.setColor(uicolor, _, _, 255)
    if btnBackPressed == true then love.graphics.draw(btnbackpressed, 25 + slideOffset, 25)
    else love.graphics.draw(btnback, 25 + slideOffset, 25) end
end

function updateIngame( dt )
    --neues powerup spawnen
    poweruptimer = poweruptimer + dt
    if poweruptimer > powerupmax then
        poweruptimer = 0
        powerupmax =  randomfloat( powerupMin, powerupMax ) 
        if not alldead then spawnPowerup() end
    end

    --spieler aktualisieren
    local dead = 1
    local help = 1
    local canvasImgData = canvas:getImageData()
    while players[help] ~= nil do
        local p = players[help]

        love.graphics.setLineWidth(p.w * 2)

        --powerups aktualisieren
        updatePowerups( p, dt )

        --wenn der spieler nicht tot ist, dann...
        if not p.t then

            --position aktualisieren
            local oldx = p.x
            local oldy = p.y
            p.x = p.x + p.spd * math.cos( p.o ) * dt
            p.y = p.y + p.spd * math.sin( p.o ) * dt

            --kollisionen mit wänden überprüfen
            local width = p.w
            if width <= 2 then width = 2 end
            if p.x > frameWidth + width and p.x < canvas:getWidth() - frameWidth - width and p.y > frameWidth + width and p.y < canvas:getHeight() - frameWidth - width then
                for var = -1, 1, 1 do
                    local x = p.x + width * math.cos( p.o + (var * math.pi * collStrictness) )
                    local y = p.y + width * math.sin( p.o + (var * math.pi * collStrictness) )
                    local r, g, b, a = canvasImgData:getPixel( x, y )
                    --spieler killen
                    if r ~= 0 or g ~= 0 or b ~= 0 and p.lb then 
                        p.t = true 
                        p.lt = 0
                        p.lb = true
                        updatePowerups( p, 0 )
                        --für jeden spieler, der noch lebt:
                        if not p.sa then
                            for var = 1, #players, 1 do
                                addScore(players[var])
                            end
                            p.sa = true
                        end
                        --scores aktualisieren
                        scores = sortScores()
                    end
                end
            else
                p.t = true 
                p.lt = 0
                p.lb = true
                updatePowerups( p, 0 )
                --für jeden spieler, der noch lebt:
                if not p.sa then
                    for var = 1, #players, 1 do
                        addScore(players[var])
                    end
                    p.sa = true
                end
                --scores aktualisieren
                scores = sortScores()
            end

            --kollisionen mit powerups überprüfen
            for var, val in pairs(powerups) do
                local pwr = powerups[var]
                if math.abs(vectorlength(p.x - pwr.x, p.y - pwr.y)) - p.w <= pwr.sprite:getWidth() / 2 then
                    applyPowerup( pwr.pwrtype, p )
                    collpowerups = collpowerups + 1
                    table.remove(powerups, var)
                    --im singleplayer score erhöhen
                    if singleplayer then p.s = p.s + 1 end
                    --scores aktualisieren
                    scores = sortScores()
                end
            end

            --kollisionen mit anderen spielern überprüfen
            for var, val in pairs(players) do
                local ply = players[var]
                if math.abs(vectorlength(p.x - ply.x, p.y - ply.y)) - p.w <= playerWidth and p ~= ply then
                    p.t = true 
                    p.lt = 0
                    p.lb = true
                    updatePowerups( p, 0 )
                    --für jeden spieler, der noch lebt:
                    if not p.sa then
                        for var = 1, #players, 1 do
                            addScore(players[var])
                        end
                        p.sa = true
                    end
                    --scores aktualisieren
                    scores = sortScores()
                end
            end

            --ausrichtung zurücksetzen
            if p.o >= 2 * math.pi then p.o = p.o - 2 * math.pi end

            --eingaben umsetzen
            if     love.keyboard.isDown( p.l ) then left( p, dt ) end
            if love.keyboard.isDown( p.r ) then right( p, dt )    end

            --lücke
            p.lt = p.lt + dt                            --lückenzähler erhöhen
            if p.lt >= p.lm then                        --wenn maximum erreicht, dann:
                p.lb = false                            --zeichne den spieler nicht
                if p.lt >= p.lm + gapSize then          --wenn die lücke lang genug ist, dann:
                    p.lb = true                         --zeichne den spieler wieder
                    p.lt = 0                            --zähler zurücksetzen
                    p.lm = randomfloat(gapMin, gapMax)  --neues maximum setzen
                end
            end

            --zeichnen
            if p.lb then
                love.graphics.setCanvas(canvas)
                love.graphics.setColor( p.rgb, _, _, 255 )
                love.graphics.line( oldx, oldy, p.x, p.y )
                love.graphics.setCanvas()
            end

        else dead = dead + 1 end
        help = help + 1
    end

    --globale variable zum neustart
    if not alldead then
        alive = help - dead
            if dead == help then alldead = true
        elseif dead == help - 1 and not singleplayer then 
            for var = 1, #players, 1 do
                if players[var].t == false then winner = players[var] end
                players[var].t = true
            end
        end
    end

    --ausblend-effekt bei neustart der runde
    if canvasblend == false and canvasblendalpha > 0 then canvasblendalpha = canvasblendalpha - blendspeed end
    if canvasblend == true and canvasblendalpha < 255 then canvasblendalpha = canvasblendalpha + blendspeed
    elseif canvasblend == true and canvasblendalpha >= 255 then 
        if singleplayer or scores[1][1] < maxscore or scores[1][1] <= scores[2][1] then
            startGame() 
            canvasblend = false
        else
            --in draw() entsprechenden Code einfügen
            maxScoreReached = true
        end
    end

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

    love.graphics.setColor(255, 255, 255, 255)
end

--neustart, wenn alle tot sind
function keyIngame( key )
    if key == btnPause then 
        if alldead then canvasblend = true else pause() end
    end
end

function spawnPowerup()
    local x1 = math.random(canvas:getWidth( ) - 64) + 32
    local y1 = math.random(canvas:getHeight( ) - 64) + 32
    local ptype = math.random(1, 107)
    local spr = nil

        if ptype < PSpawnUrgot  then 
            ptype = 'urgot' 
            spr = pwrUrgot
    elseif ptype < PSpawnUrgotG then 
            ptype = 'globalurgot'
            spr = pwrUrgotG
    elseif ptype < PSpawnThin   then 
            ptype = 'thin' 
            spr = pwrThin
    elseif ptype < PSpawnThinG  then 
            ptype = 'globalthin'
            spr = pwrThinG
    elseif ptype < PSpawnFat    then 
            ptype = 'fat'
            spr = pwrFat
    elseif ptype < PSpawnFatG   then 
            ptype = 'globalfat'
            spr = pwrFatG
    elseif ptype < PSpawnSpeed  then 
            ptype = 'speedup'
            spr = pwrSpeed
    elseif ptype < PSpawnSpeedG then 
            ptype = 'globalspeedup'
            spr = pwrSpeedG
    elseif ptype < PSpawnSlow   then 
            ptype = 'slow' 
            spr = pwrSlow
    elseif ptype <= PSpawnSlowG  then 
            ptype = 'globalslow' 
            spr = pwrSlowG
    elseif ptype <= PSpawnLux  then 
            ptype = 'lux' 
            spr = pwrLux

    else print('ERROR: TRYING TO SPAWN UNKNOWN POWERUP TYPE') 
    end

    local pwr = {x = x1, y = y1, pwrtype = ptype, sprite = spr} 

    table.insert( powerups, pwr )
end

--beim aufheben von powerups aufgerufen
function applyPowerup( pwrtype, player )
    --urgot ulti
    if pwrtype == 'urgot' then
        if not singleplayer then
            --such einen zufälligen spieler raus
            local hp2 = 1
            while players[hp2].n == player.n or players[hp2].t do 
                hp2 = math.random(#players) end
            --bau eine passende tabelle
            table.insert( player.p, {pwrtype = 'urgot', p2 = hp2, swap = 0} )
        end

    --'globale' urgot ulti
    elseif pwrtype == 'globalurgot' then
        local alive = 0
        for var = 1, #players, 1 do
            if not players[var].t then alive = alive + 1 end
        end
        if alive <3 then --tu nix
        else 
            --such zwei zufällige spieler raus
            local p1 = 1
            local p2 = 2
            while players[p1].n == player.n or players[p1].t do 
                p1 = math.random(#players) 
            end
            while players[p2].n == player.n or players[p2].n == players[p1].n or players[p2].t do 
                p2 = math.random(#players) 
            end
            --bau eine passende tabelle
            table.insert( players[p1].p, {pwrtype = 'urgot', p2 = p2, swap = 0} )
        end

    --dünn
    elseif pwrtype == 'thin' then
        table.insert( player.p, {pwrtype = 'thin', timer = 0, max = effectTimer} )
        player.w = player.w / fatMult

    --'global' dünn
    elseif pwrtype == 'globalthin' then
        --für jeden spieler:
        for var = 1, #players, 1 do
            --wenn der spieler nicht tot ist und nicht derjenige ist, der das powerup getriggert hat:
            if not players[var].t and players[var].n ~= player.n then
                --werde dünn
                table.insert( players[var].p, {pwrtype = 'thin', timer = 0, max = effectTimer} )
                players[var].w = players[var].w / fatMult
            end
        end

    --fett
    elseif pwrtype == 'fat' then
        table.insert( player.p, {pwrtype = 'fat', timer = 0, max = effectTimer} )
        player.w = player.w * fatMult
    --'global' fett
    elseif pwrtype == 'globalfat' then
        --für jeden spieler:
        for var = 1, #players, 1 do
            --wenn der spieler nicht tot ist und nicht derjenige ist, der das powerup getriggert hat:
            if not players[var].t and players[var].n ~= player.n then
                --werde fett
                table.insert( players[var].p, {pwrtype = 'fat', timer = 0, max = effectTimer} )
                players[var].w = players[var].w * fatMult
            end
        end

    --schneller
    elseif pwrtype == 'speedup' then
        table.insert( player.p, {pwrtype = 'speedup', timer = 0, max = effectTimer / 2} )
        player.spd = player.spd * spdBoost

    --'global' schneller
    elseif pwrtype == 'globalspeedup' then
        --für jeden spieler:
        for var = 1, #players, 1 do
            --wenn der spieler nicht tot ist und nicht derjenige ist, der das powerup getriggert hat:
            if not players[var].t and players[var].n ~= player.n then
                --werde schnell
                table.insert( players[var].p, {pwrtype = 'speedup', timer = 0, max = effectTimer / 2} )
                players[var].spd = players[var].spd * 2
            end
        end

    --langsamer
    elseif pwrtype == 'slow' then
        table.insert( player.p, {pwrtype = 'slow', timer = 0, max = effectTimer / 2} )
        player.spd = player.spd / spdBoost

    --'global' langsamer
    elseif pwrtype == 'globalslow' then
        --für jeden spieler:
        for var = 1, #players, 1 do
            --wenn der spieler nicht tot ist und nicht derjenige ist, der das powerup getriggert hat:
            if not players[var].t and players[var].n ~= player.n then
                --werde schnell
                table.insert( players[var].p, {pwrtype = 'slow', timer = 0, max = effectTimer / 2} )
                players[var].spd = players[var].spd / 2
            end
        end

    --lux ulti
    elseif pwrtype == 'lux' then
        if math.random() > 1 then --momentan nur y-achse, da x implementierung irgendwo scheisse ist
            local axis = 'y'
            local x = 0
            local y = math.random(100, canvas:getWidth() - 100)
            local ori = (math.pi * math.random() - math.pi / 2)

            table.insert( player.p, {pwrtype = 'lux', phase = 'red', x = x, y = y, ori = ori, offset = 0, axis = axis, ticks = 0} )
        else
            local axis = 'x'
            local x = math.random(100, canvas:getWidth() - 100)
            local y = 0
            local ori = math.pi * (math.random() - 0.5) / 10 + math.pi / 2

            table.insert( player.p, {pwrtype = 'lux', phase = 'red', x = x, y = y, ori = ori, offset = 0, axis = axis, ticks = 0} )
        end

    --sonst fehler
    else print('ERROR: TRYING TO APPLY UNKNOWN POWERUP TYPE') 
    end
end

--jeden tick aufgerufen
function updatePowerups( player, dt )
    for key,value in pairs(player.p) do
        local pwr = player.p[key]

        --urgot ulti, code ist 10/10
        if pwr.pwrtype == 'urgot' then
            --wenn beide spieler leben:
            if not player.t and not players[pwr.p2].t then
                --wenn beide spieler noch nicht weiß sind:
                if pwr.swap == 0 then

                    --farbe von spieler 1 an weiß annähern
                        if player.rgb[1] < 255 then player.rgb[1] = player.rgb[1] + 1 end
                        if player.rgb[2] < 255 then player.rgb[2] = player.rgb[2] + 1 end
                        if player.rgb[3] < 255 then player.rgb[3] = player.rgb[3] + 1 end
                    
                    --farbe von spieler 2 an weiß annähern
                        if players[pwr.p2].rgb[1] < 255 then players[pwr.p2].rgb[1] = players[pwr.p2].rgb[1] + 1 end
                        if players[pwr.p2].rgb[2] < 255 then players[pwr.p2].rgb[2] = players[pwr.p2].rgb[2] + 1 end
                        if players[pwr.p2].rgb[3] < 255 then players[pwr.p2].rgb[3] = players[pwr.p2].rgb[3] + 1 end

                    --wenn beide weiß sind:
                    if  player.rgb[1] == 255 and players[pwr.p2].rgb[1] == 255 
                    and player.rgb[2] == 255 and players[pwr.p2].rgb[2] == 255
                    and player.rgb[3] == 255 and players[pwr.p2].rgb[3] == 255 then 
                        --wechsele in den zweiten modus
                        pwr.swap = pwr.swap + dt
                    end
                --wenn beide spieler weiß sind:
                else
                    --variable aktualisieren
                    pwr.swap = pwr.swap + dt
                    --wenn die channel zeit überschritten ist, dann:
                    if pwr.swap > pwrUrgotChannel then
                        --position und ausrichtung vertauschen
                        local helpx = player.x
                        local helpy = player.y
                        local helpo = player.o
                        player.x = players[pwr.p2].x
                        player.y = players[pwr.p2].y
                        player.o = players[pwr.p2].o
                        players[pwr.p2].x = helpx
                        players[pwr.p2].y = helpy
                        players[pwr.p2].o = helpo
                        --farben zurücksetzen 
                        player.rgb = randomrgb(tonumber(player.n))
                        players[pwr.p2].rgb = randomrgb(tonumber(players[pwr.p2].n))
                        --pwrup entfernen
                        player.p[key] = nil
                    end
                end
            --wenn einer von beiden draufgegangen ist:
            else
                --alles rückgängig machen
                player.rgb = randomrgb(tonumber(player.n))
                players[pwr.p2].rgb = randomrgb(tonumber(players[pwr.p2].n))
                player.p[key] = nil
            end

        --fett
        elseif pwr.pwrtype == 'fat' then
            pwr.timer = pwr.timer + dt
            if pwr.timer >= pwr.max then 
                player.w = player.w / fatMult 
                player.p[key] = nil
            end

        --dünn
        elseif pwr.pwrtype == 'thin' then
            pwr.timer = pwr.timer + dt
            if pwr.timer >= pwr.max then 
                player.w = player.w * fatMult 
                player.p[key] = nil
            end

        --schneller
        elseif pwr.pwrtype == 'speedup' then
            pwr.timer = pwr.timer + dt
            if pwr.timer >= pwr.max then 
                player.spd = player.spd / spdBoost 
                player.p[key] = nil
            end

        --langsamer
        elseif pwr.pwrtype == 'slow' then
            pwr.timer = pwr.timer + dt
            if pwr.timer >= pwr.max then 
                player.spd = player.spd * spdBoost 
                player.p[key] = nil
            end

        --lux
        elseif pwr.pwrtype == 'lux' and not alldead then
            if pwr.phase == 'red' then
                if 1 + (pwr.offset / luxPre:getWidth() / 2) > 0 then
                    drawLuxPowerup = {x = pwr.x, y = pwr.y, ori = pwr.ori, sprite = luxPre, offset = pwr.offset, scale =  1 + (pwr.offset / luxPre:getWidth() / 2)}
                    
                    pwr.offset = pwr.offset - pwrLuxChannel
                else
                    pwr.phase = 'main'
                    pwr.offset = 0
                    drawLuxPowerup = nil
                    love.graphics.setCanvas(canvas)
                    love.graphics.setColor( 255, 255, 255, 255 )
                    for var = -pwrLuxChannel, canvas:getWidth() / luxMain:getWidth() + 1, 1 do
                        love.graphics.draw(luxMain, pwr.x, pwr.y, pwr.ori, 1, 1.3, -var * luxPre:getWidth() + pwr.offset)
                        love.graphics.draw(luxMain, pwr.x, pwr.y, pwr.ori, 1, -1.3, -var * luxPre:getWidth() + pwr.offset)
                    end
                    love.graphics.setCanvas()
                end
            else
                if pwr.ticks > pwrLuxMainFade then
                    pwr.offset = pwr.offset - pwrLuxChannel
                    love.graphics.setCanvas(canvas)
                    love.graphics.setColor( 0, 0, 0, 255 )
                    for var = -pwrLuxChannel, canvas:getWidth() / luxMain:getWidth() + 1, 1 do
                        love.graphics.draw(luxMain, pwr.x, pwr.y, pwr.ori, 1, 1.3, -var * luxPre:getWidth() + pwr.offset)
                        love.graphics.draw(luxMain, pwr.x, pwr.y, pwr.ori, 1, -1.3, -var * luxPre:getWidth() + pwr.offset)
                    end
                    love.graphics.setCanvas()
                end
                local scale = 1.3 - pwrLuxChannel * 2 * (pwr.offset / luxPre:getWidth()) * (pwr.offset / luxPre:getWidth())
                if scale > 0 then
                    drawLuxPowerup = {x = pwr.x, y = pwr.y, ori = pwr.ori, sprite = luxMain, offset = pwr.offset, scale = scale}
                else 
                    drawLuxPowerup = nil
                    player.p[key] = nil
                end
                pwr.ticks = pwr.ticks + 1
            end

        --sonst fehler
        else print('ERROR: TRYING TO UPDATE UNKNOWN POWERUP TYPE') 
        end
    end
end