--[[
RAM Adresses for FireNIce
]]

-- Player position
RAMPlayerPosition = 0x92
--[[ the player x and y are not in RAM but can be obtained from the playerPosition
	player_x = playerPosition % 16
	player_y = math.floor(playerPosition / 16)
]]