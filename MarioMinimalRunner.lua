--[[

Game: Super Mario Bros.
This program attempts to beat the first game of super mario bros by using the minimal input possible:

Rules are:
- No running allowed (except maybe for long jumps which cannot be made otherwise)
- No stopping (always walk forward)
- Press the jump button the minimum amount of frames possible.

]]

-- import all RAM addresses from the following file
require "SMB_addresses"

-- reset the game
emu.softreset()

-- the table values c-orrespond to the buttons up, down, left, right, A, B, start, select
out = {}
-- press start button
out["start"] = true;
joypad.write(1, out);
emu.frameadvance();

-- advance 180 frames
for i=0, 180 do
	emu.frameadvance();
end

-- start game
out["start"] = true;
joypad.write(1, out);
emu.frameadvance();

out["start"] = nil;

-- Mario starts moving here.

-- the number of frames that mario requires to jump will depend on the obstacle
goomba = 1;
pipe2blocks = 10;
pipe3blocks = 16;
pipe4blocks = 26;
pit2blocks = 1;
pit3blocks = 5;
turtle = 1;
stairs = 1;

-- the number of distance in x that mario needs before jumping into an obstacle
xgoomba = 9;
xpipe2blocks = 18;
xpipe3blocks = 18;
xpipe4blocks = 32;
xpit2blocks = 2;
xpit3blocks = 2;
xturtle = 10;
xstairs = 5;


-- the jumps mario will make will be stored in an array, where the key is the x position and the value is the number of frames to perform the jump
jumps = {}
jumps[1] = {299 - xgoomba, goomba};
jumps[2] = {438 - xpipe2blocks, pipe2blocks};
jumps[3] = {598 - xpipe3blocks, pipe3blocks};
jumps[4] = {726 - xpipe4blocks, pipe4blocks};
jumps[5] = {902 - xpipe4blocks, pipe4blocks};
jumps[6] = {1104 - xpit2blocks, pit2blocks};
jumps[7] = {1376 - xpit3blocks, pit3blocks};
jumps[8] = {1515 - xgoomba, goomba};
jumps[9] = {1662 - xturtle, turtle};
jumps[10] = {1787 - xgoomba, goomba};
jumps[11] = {1949 - xgoomba, goomba};
jumps[12] = {2134 - xstairs, stairs};
jumps[13] = {2166 - xstairs, stairs};
jumps[14] = {2182 - xstairs, stairs};
jumps[15] = {2208 - xpit2blocks, pit2blocks};
jumps[16] = {2358 - xstairs, stairs};
jumps[17] = {2390 - xstairs, stairs};
jumps[18] = {2448 - xpit2blocks, pit2blocks};
jumps[19] = {2598 - xpipe2blocks, pipe2blocks};
jumps[20] = {2750 - xgoomba, goomba};
jumps[21] = {2854 - xpipe2blocks, pipe2blocks};
jumps[22] = {2918 - xstairs, stairs};
jumps[23] = {2950 - xstairs, stairs};
jumps[24] = {2982 - xstairs, stairs};
jumps[25] = {3138 - xstairs, stairs};


for i=1, table.getn(jumps) do
	
	nextX = jumps[i][1]
	nextFrames = jumps[i][2]
	emu.print("Next jump x: " .. tostring(nextX) .. " for " .. tostring(nextFrames) .. " frames.");
	
	-- read marios X position and display it
	marioX = memory.readbyte(RamPlayerX) + memory.readbyte(RamPlayerScreenX)*0x100 + 4
	gui.text(100, 10, "x: " .. tostring(marioX));
	
	-- walk right until you reach the jump position
	while marioX < nextX do
		-- read marios X position and display it
		marioX = memory.readbyte(RamPlayerX) + memory.readbyte(RamPlayerScreenX)*0x100 + 4
		gui.text(100, 10, "x: " .. tostring(marioX));
		
		-- walk right and advance one frame
		out["right"] = true;
		out["A"] = nil;
		joypad.write(1, out);
		emu.frameadvance();
	end
	
	-- at this point, mario is in a jump position
	for j=0, nextFrames do
		-- read marios X position and display it
		marioX = memory.readbyte(RamPlayerX) + memory.readbyte(RamPlayerScreenX)*0x100 + 4
		gui.text(100, 10, "x: " .. tostring(marioX));
		
		-- walk right, jump and advance one frame
		out["right"] = true;
		out["A"] = true;
		joypad.write(1, out);
		emu.frameadvance();
	end
end

while true do
	-- read marios X position and display it
	marioX = memory.readbyte(RamPlayerX) + memory.readbyte(RamPlayerScreenX)*0x100 + 4
	gui.text(100, 10, "x: " .. tostring(marioX));
	emu.frameadvance();
end