function right( player, dt )
	player.o = player.o + dt * turnspeed
	--powerups berücksichtigen
	
end

function left( player, dt )
	player.o = player.o - dt * turnspeed
	--powerups berücksichtigen
end

function newPTable()
	--		 LINKS		RECHTS	PNKTE 	TOT?	  	NAME	 PWRUPS  X 		Y 	 	ORI		GESCHWINDIGKEIT		NAME 2
	s = {  { l = '',	r = '',	s = 0,	t = false,	n = '1', p = {}, x = 0,	y = 0,	o = 0,	spd = basespeed,	name = 'green',
	--		 FARBE (RGB)			LÜCKE      LTIMER  LMAX									BREITE				BUG WORKAROUND
			 rgb = menurgb( 1 ),	lb = true, lt = 0, lm = randomfloat(gapMin, gapMax),	w = playerWidth,	sa = false

},			{ l = '',	r = '',	s = 0,	t = false,	n = '2', p = {}, x = 0,	y = 0,	o = 0,	spd = basespeed,	name = 'red',
			 rgb = menurgb( 2 ),	lb = true, lt = 0, lm = randomfloat(gapMin, gapMax),	w = playerWidth,	sa = false
},
			{ l = '',	r = '',	s = 0,	t = false,	n = '3', p = {}, x = 0,	y = 0,	o = 0,	spd = basespeed,	name = 'blue',
			 rgb = menurgb( 3 ),	lb = true, lt = 0, lm = randomfloat(gapMin, gapMax),	w = playerWidth,	sa = false
},
			{ l = '',	r = '',	s = 0,	t = false,	n = '4', p = {}, x = 0,	y = 0,	o = 0,	spd = basespeed,	name = 'yellow',
			 rgb = menurgb( 4 ),	lb = true, lt = 0, lm = randomfloat(gapMin, gapMax),	w = playerWidth,	sa = false
},
			{ l = '',	r = '',	s = 0,	t = false,	n = '5', p = {}, x = 0,	y = 0,	o = 0,	spd = basespeed,	name = 'purple',
			 rgb = menurgb( 5 ),	lb = true, lt = 0, lm = randomfloat(gapMin, gapMax),	w = playerWidth,	sa = false
}

}	s.total = tablelength(s)
	return s
end

--neuen spieler hinzufügen
function addPlayer( table, color )
	if tablelength(table) <= maxPlayers then 
		local lName = 'player'
			if color == 1 then lName = 'red'
		elseif color == 2 then lName = 'blue'
		elseif color == 3 then lName = 'yellow'
		elseif color == 4 then lName = 'purple'
		end
		--		 				 LINKS		RECHTS	PNKTE 	TOT?	  	NAME								BREITE				GESCHWINDIGKEIT
		table.insert( table, { l = '',	r = '',	s = 0,	t = false,	n = tostring(tablelength(table)),	w = playerWidth,	spd = basespeed,
		--						 PWRUPS  	X 		Y 	 	ORI		FARBE (RGB)								 LÜCKE	   LTIMER  LMAX
								 p = {},	x = 0,	y = 0,	o = 0,	rgb = randomrgb(tablelength(table)), lb = true, lt = 0, lm = randomfloat(gapMin, gapMax),
		--						 BUG WORKAROUND	NAME 2
								 sa = false,	name = lName
} ) end
end

--nächsten spieler im menü auswählen
function nextPlayer()
	if selectedPlayer < tablelength(menuplayers) - 1 and next(menuplayers, selectedPlayer) ~= nil then selectedPlayer = selectedPlayer + 1 end
end

--vorherigen spieler im menü auswählen
function prevPlayer()
	if selectedPlayer - 2 > -1 and next(menuplayers, selectedPlayer - 2) ~= nil then selectedPlayer = selectedPlayer - 1 end
end

function removePlayer()
	menuplayers[selectedPlayer].l = ''
	menuplayers[selectedPlayer].r = ''
end

function emptyPlayer(player)
	if players[player].l == '' or players[player].r == '' then return true end
	return false
end

function addScore( player )
	if not player.t then player.s = player.s + 1 end
end

function sortScores()
	local s = {}

	for var = 1, #players, 1 do
        table.insert( s, { players[var].s, randomrgb(tonumber(players[var].n)) } )
    end

	local itemCount = #s
	local hasChanged
	repeat
		hasChanged = false
		itemCount=itemCount - 1
		for i = 1, itemCount do
			if s[i][1] < s[i + 1][1] then
				s[i], s[i + 1] = s[i + 1], s[i]
				hasChanged = true
			end
		end
	until hasChanged == false

	return s
end