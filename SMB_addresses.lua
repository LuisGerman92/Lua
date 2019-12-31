----------------------------------------------------------------------------------------------------------------------------------------------------
--RAM Addresses for variables
----------------------------------------------------------------------------------------------------------------------------------------------------
RamNametableHi = 0x20
RamNametableLow = 0x01
RamNametableSize = 0x2BF
RamNametableSolidStart = 0x01

--Screen attributes
RamObjectMapStart = 0x500
RamScreenLayoutPage1 = 0x500
RamScreenLayoutPage2 = 0x5D0
MapTileNum = 208

--Player attributes
RamPlayerX = 0x86
RamPlayerY = 0x3B8
RamPlayerScreenX = 0x6D
RamLives = 0x75A
RamCoins = 0x75E

--Game attributes
RamWorld = 0x75F
RamLevel = 0x760

--Score
RamScoreDigit1 = 0x7D8 --10^5
RamScoreDigit2 = 0x7D9 --10^4
RamScoreDigit3 = 0x7DA --10^3
RamScoreDigit4 = 0x7DB --10^2
RamScoreDigit5 = 0x7DC --10^1

----------------------------------------------------------------------------------------------------------------------------------------------------
--Enemies information
----------------------------------------------------------------------------------------------------------------------------------------------------
--Enemy active. 0 means not active (or drawn) and 1 menas active (or drawn). 
RamEnemyActive = 0x0F -- starting offset for multiple enemies (1 byte each)

--Enemy attributes
RamEnemyType = 0x16 -- starting address in memory for multiple enemies (1 byte each)
RamEnemyX = 0x87	
RamEnemyY = 0xCF
RamEnemyScreenX = 0x6E
EnemyNumSlots = 5
RamEnemyFlag = 0xF	--In Zelda, it's enemy direction used as flag

--Projectile attributes
--RamProjectileX = 0x87	--starting address in memory for multiple enemies
--RamProjectileY = 0xCF
--RamProjectileScreenX = 0x6E
--ProjectileNumSlots = 5
--RamProjectileFlag = 0xF	--In Zelda, it's enemy direction used as flag


-- Player walk animation current frame index
RAMPlayerWalkFrameIndex = 0x070D
