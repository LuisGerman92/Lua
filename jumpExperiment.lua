--[[

Game: Super Mario Bros.
Jump Experiment to find out the jump dynamics in super mario bros.

The question is: How long will mario jump, when the jump button is pressed for N frames?

The program runs the experiment starting from 1 frame, up to n.
The jump height is calculated and the results are stored in a file, so that the data can be processed analyzed later.

]]

file_name = "jumpHeight.txt";

-- import all RAM addresses from the following file
require "SMB_addresses"

-- reset the game
emu.softreset()


function advance_Nframes(n)
	for i=1, n do

		emu.frameadvance();
		display_player_info()
	end;
end


advance_Nframes(120);
-- press start button
out = {}
-- the table values c-orrespond to the buttons up, down, left, right, A, B, start, select
out["start"] = true;
joypad.write(1, out);
emu.frameadvance();
advance_Nframes(180);

-- release start button 
out["start"] = nil;
joypad.write(1, out);
emu.frameadvance();

-- create a savestate object
mySavestate = savestate.create(1);
savestate.save(mySavestate)

-- This is where the actual experiment starts.
n = 35; -- the experiment will record the minimum height reached when jumping 1, 2, ..., n frames

-- store the results to an array
results = {}
for i=1, n do
	-- load the savestate (This is done to avoid timeup death).
	savestate.load(mySavestate)
	
	initial_position = memory.readbyte(RamPlayerY) + 16;
	-- capture the min_height as the Y position of mario at the time of start the experiment
	min_height = initial_position;
	
	-- jump for i frames
	for j=0, i do
		gui.text(100, 10, "n: " .. tostring(i));
		gui.text(100, 20, "Y: " .. tostring(playerY));
		gui.text(100, 30, "min: " .. tostring(min_height));
		-- capture min_height from jump
		playerY = memory.readbyte(RamPlayerY) + 16
		if playerY <= min_height then
			min_height = playerY;
		end
		out["A"] = true;
		joypad.write(1, out);
		emu.frameadvance();
	end
	
	
	-- let the experiment run for the remaining frames
	remaining_frames = 120-i
	for j=1, remaining_frames do
		-- release the jump button
		out["A"] = nil;
		joypad.write(1, out);
		emu.frameadvance();
		playerY = memory.readbyte(RamPlayerY) + 16
		gui.text(100, 10, "n: " .. tostring(i));
		gui.text(100, 20, "Y: " .. tostring(playerY));
		gui.text(100, 30, "min: " .. tostring(min_height));
	end
	
	-- append current iteration result to the array
	results[i] = min_height;
	
	emu.print("i: " .. tostring(i) .. ". min: " .. tostring(min_height) .. ". h=" .. tostring(initial_position-min_height));
	
	-- store results in disk
	file = io.open(file_name, "a")
	file:write(tostring(i) .. ", " .. tostring(initial_position-min_height), "\n")
	io.close(file);
end
