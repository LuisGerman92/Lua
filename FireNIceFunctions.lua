--[[

Game: FireNIce

Provided a string of moves, this program will follow them in the game FireNIce

]]

require "FireNIce_Adresses"

-- sequence of moves needed to beat level_1_1
str = 'llllllllrrrrr'
frames = 120

function display_player_info()
	-- readand diplay player position
	playerPosition = memory.readbyte(RAMPlayerPosition)
	-- the player x and y can be obtained from the playerPosition
	player_x = playerPosition % 16
	player_y = math.floor(playerPosition / 16)
	gui.text(100, 10, "Position(raw): " .. tostring(playerPosition));
	gui.text(100, 20, "x: " .. tostring(player_x));
	gui.text(100, 30, "y: " .. tostring(player_y));
end

function exec_sequence( moves, frames)
	-- iterate every char in the string
	for i = 1, #moves do
		-- reset any input from previous iteration
		out = {}
		
		local c = moves:sub(i,i)
		-- press corresponding button
		if c == 'l' then
			out['left'] = true
		elseif c == 'r' then
			out['right'] = true
		elseif c == 'u' then
			out['up'] = true
		elseif c == 'd' then
			out['down'] = true
		else--[[any other char means shoot ]]
			out['B'] = true
		end
		
		joypad.write(1, out);
		
		for i = 1, frames do
			display_player_info()
			emu.frameadvance()
		end
	end
end

-- increase emulation speed
emu.speedmode("nothrottle")

emu.print("Executing sequence for level 1-1");
exec_sequence(str, frames)
emu.print("Excution finished");

while true do
	display_player_info()
	emu.frameadvance()
end