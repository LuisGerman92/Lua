--[[

This script displays useful information about mario, the enemies and the state of the game on the screen.

]]

-- import all RAM addresses.
require "SMB_addresses"
require "agent1"

-- display the name of the agent for the given amount of milliseconds
emu.exec_time(3000, emu.message("Loading Agent 1."));

-- display seconds counter on the screen
seconds_counter = 0;

-- display information
function display_player_info()
	-- print the x and y coordinates of the player.
	playerX = memory.readbyte(RamPlayerX) + memory.readbyte(RamPlayerScreenX)*0x100 + 4
	playerY = memory.readbyte(RamPlayerY) + 16
	gui.text(100, 10, "x: " .. tostring(playerX) .. ", y: " .. tostring(playerY));
	playerRawX = memory.readbyte(RamPlayerX)
	gui.text(130, 20, "Raw x: " .. tostring(playerRawX));
	playerScreenX = memory.readbyte(RamPlayerScreenX)
	gui.text(130, 30, "Screen X: " .. tostring(playerScreenX));
	
	-- print the number of lives left
	playerLives = memory.readbyte(RamLives);
	gui.text(200, 10, "Lives: " .. tostring(playerLives));
	
	-- print the current level and world in the screen
	level = memory.readbyte(RamLevel);
	world = memory.readbyte(RamWorld);
	gui.text(200, 20, "Level: " .. tostring(level));
	gui.text(200, 30, "World: " .. tostring(world));
	
	-- display elapsed time in the top left corner of the screen in every frame
	gui.text(10,10, "Time: " .. tostring(seconds_counter));
end

function display_enemy_info()
	-- display x and y coords on enemy
	for i=0, 4 do
		enemy_X = memory.readbyte(RamEnemyX + i) + memory.readbyte(RamEnemyScreenX + i)*0x100 + 4
		enemy_Y = memory.readbyte(RamEnemyY + i)
		enemy_flag = memory.readbyte(RamEnemyFlag + i)
		enemyType = memory.readbyte(RamEnemyType + i)
		gui.text(10, 20+10*i, tostring(i) .. ": " .. tostring(enemy_flag) .. ", " .. tostring(enemy_X) .. ", " .. tostring(enemy_Y) .. ", " .. tostring(enemyType))
	end
end

function draw_map()
	-- initialize empty table
	map1 = {}
	map2 = {}
	
	-- read and store every map tile
	for i=0, MapTileNum do
		map1[i] = memory.readbyte(RamScreenLayoutPage1 + i)
	end
	
	for i=0, MapTileNum do
		map2[i] = memory.readbyte(RamScreenLayoutPage2 + i)
	end
	
	
	scaleFactor = 2
	init_x = 120
	init_y = 40
	-- draw page 1
	for i=0, 12 do
		for j=0, 15 do
			y = init_y+scaleFactor*i
			x = init_x+scaleFactor*j
			--x = 16 * j
			--y = 16 * i + 32
			
			-- emu.print(tostring(i) .. ", " .. tostring(j) .. " :" .. tostring(color));
			-- gui.text(x, y, tostring(j))
			tile = map1[16*i+j]
			if tile ~= 0 then
				gui.drawbox(x,y,x+scaleFactor,y+scaleFactor, "RED");
			else
				gui.drawbox(x,y,x+scaleFactor,y+scaleFactor, "BLUE");
			end
		end
	end
	
	-- draw page 2
	for i=0, 12 do
		for j=0, 15 do
			y = init_y+scaleFactor*i 
			x = init_x+scaleFactor*j + scaleFactor*16
			--x = 16 * j
			--y = 16 * i + 32
			
			-- emu.print(tostring(i) .. ", " .. tostring(j) .. " :" .. tostring(color));
			-- gui.text(x, y, tostring(j))
			tile = map2[16*i+j]
			if tile ~= 0 then
				gui.drawbox(x,y,x+scaleFactor,y+scaleFactor, "RED");
			else
				gui.drawbox(x,y,x+scaleFactor,y+scaleFactor, "BLUE");
			end
		end
	end
	
	-- display player on map
	playerRawX = memory.readbyte(RamPlayerX)
	playerY = memory.readbyte(RamPlayerY) + 16
	y = init_y + playerY/8 - 4
	x = init_x + playerRawX/8
	-- if the screen value is an odd number, add 256 to the value of player
	playerScreenX = memory.readbyte(RamPlayerScreenX)
	if playerScreenX % 2 == 1 then
		 x = x + 256/8
	end
	gui.drawbox(x, y, x+1, y+1, "GREEN");
	
	-- display enemies on map
	for i=0, 4 do
		enemyScreenX = memory.readbyte(RamEnemyScreenX + i)
		enemy_X = memory.readbyte(RamEnemyX + i) + memory.readbyte(RamEnemyScreenX + i)*0x100 + 4
		enemy_Y = memory.readbyte(RamEnemyY + i)
		enemy_flag = memory.readbyte(RamEnemyFlag + i)
		enemyType = memory.readbyte(RamEnemyType + i)
		y = init_y + enemy_Y/8 - 4
		x = init_x + ((enemy_X % (16*16))/8)
		if (enemyScreenX % 2) == 1 then
			x = x + 256/8
		end
		-- draw only if enemy is active (its flag ~! 0)
		if enemy_flag ~= 0 then
			gui.drawbox(x, y, x+1, y+1, "YELLOW");
		end
	end
end


-- main loop
while true do
	-- advance the game 60 frames
	for i=1, 60 do
	
		-- call agent1
		--input = randomAgent()
		--player = 1;
		--joypad.write(player, input);
		
		emu.frameadvance();
		display_player_info()
		display_enemy_info()
		draw_map()
	end;
	
	-- increase counter 
	seconds_counter = seconds_counter + 1;
	
	
	-- log the information to the console in the Lua Scripting Window. Useful for debugging.
	-- emu.print("Running for " .. tostring(seconds_counter) .. " seconds.");
end;
