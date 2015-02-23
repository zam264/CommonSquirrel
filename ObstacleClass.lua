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
		numFrames = 3, 
		sheetContentWidth = 192, 
		sheetContentHeight = 64 
	}

	mySheet = graphics.newImageSheet("imgs/beeSheet.png", spriteOptions)--, 2000, 2000)
	sequenceData = {
		{name = "buzz", frames={1, 2, 3, 2, 1}, time = 150, loopCount = 0},
	}	
	
	-- Display the new sprite at the coordinates passed
	self.model = display.newSprite(mySheet, sequenceData)
	self.model.type = "obstacle"  --Define the type of obstacle for collision detection
	self.model:setSequence("buzz")
	self.model:play()
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