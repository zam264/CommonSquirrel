local LCS = require 'LCS'
--require "options"	-- options needed for difficulty variable

Obstacle = LCS.class({damage, spriteOptions, mySheet ,model})

function Obstacle:init(posX, posY)
	-- Initialize creatures base attributes
	self.damage = 1

	--Declare and set up Sprite Image Sheet and sequence data
	spriteOptions = {	
		height = 64, 
		width = 64, 
		numFrames = 273, 
		sheetContentWidth = 832, 
		sheetContentHeight = 1344 
	}

	mySheet = graphics.newImageSheet("skeleton_3.png", spriteOptions, 2000, 2000)
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
	self.model.type = "obstacle"  --Define the type of obstacle for collision detection
	self.model:setSequence("forward")
	self.model.x = posX
	self.model.y = posY
	self.model.xScale = display.contentWidth * .0025
	self.model.yScale = display.contentWidth * .0025

	
	
--[[*****************    Methods    ******************]]--
	function Obstacle:delete()
		self.model:removeSelf()
		self.model = nil
		self = nil 
	end
		
end -- End CreatureClass