local LCS = require 'LCS'
--require "options"	-- options needed for difficulty variable

Player = LCS.class({health, spriteOptions, mySheet ,model})

function Player:init(posX, posY)
	-- Initialize creatures base attributes
	self.health = 3; --Scale heath based on level? [easy = 5, medium = 4, hard = 3] or something like that

	--Declare and set up Sprite Image Sheet and sequence data
	--[[
	spriteOptions = {	
		height = 64, 
		width = 64, 
		numFrames = 273, 
		sheetContentWidth = 832, 
		sheetContentHeight = 1344 
	}
	mySheet = graphics.newImageSheet("skeleton_3.png", spriteOptions, 50, 50)
	sequenceData = {
		{name = "forward", frames={105,106,107,108,109,110,111,112}, time = 500, loopCount = 1},
		{name = "right", frames={144,145,146,147,148,149,150,151,152}, time = 500, loopCount = 1}, 
		{name = "back", frames= {131,132,133,134,135,136,137,138,139}, time = 500, loopCount = 1}, 
		{name = "left", frames={118,119,120,121,122,123,124,125,126}, time = 500, loopCount = 1},
		{name = "attackForward", frames={157,158,159,160,161,162}, time = 700, loopCount = 0},
		{name = "attackRight", frames={196,197,198,199,200,201}, time = 700, loopCount = 0},
		{name = "attackBack", frames={183,184,185,186,187,188}, time = 700, loopCount = 0},
		{name = "attackLeft", frames={170,171,172,173,174,175}, time = 700, loopCount = 0},
		{name = "death", frames={261,262,263,264,265,266}, time = 500, loopCount = 1}
	}	
	
	-- Display the new sprite at the coordinates passed
	self.model = display.newSprite(mySheet, sequenceData)
	self.model:setSequence("forward")
	]]

	self.model = display.newRect( posX, posY, display.contentWidth*.1, display.contentWidth*.125 )
	self.model.x = posX
	self.model.y = posY
	
--[[*****************    Methods    ******************]]--
	function Player:delete()
		print ("teeth")
		self.model:removeSelf()
		print ("teeth")
		self.model = nil
	end
		
end -- End CreatureClass