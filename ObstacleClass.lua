local LCS = require 'LCS'
--require "options"	-- options needed for difficulty variable

Obstacle = LCS.class({damage, spriteOptions, mySheet ,model})

function Obstacle:init(posX, posY)
	-- Initialize creatures base attributes
	local rand = math.random(5)
	
	
	if (rand ==1 ) then
	self.damage = 1
	--Declare and set up Sprite Image Sheet and sequence data
	spriteOptions = {	
		height = 64, 
		width = 64, 
		numFrames = 6, 
		sheetContentWidth = 384, 
		sheetContentHeight = 64 
	}

	mySheet = graphics.newImageSheet("imgs/beeSheet2a.png", spriteOptions)--, 2000, 2000)
	sequenceData = {
		{name = "buzz", frames={1, 6, 4, 5, 3, 2, 6, 3, 4, 5, 1}, time = 300, loopCount = 0},
	}	
	
	-- Display the new sprite at the coordinates passed
	self.model = display.newSprite(mySheet, sequenceData)
	self.model.type = "obstacle"  --Define the type of obstacle for collision detection
	self.model:setSequence("buzz")
	
	elseif (rand == 2) then
		self.damage = 1
		
		spriteOptions = {	
			height = 64, 
			width = 64, 
			numFrames = 1, 
			sheetContentWidth = 64, 
			sheetContentHeight = 64 
		}
		
		mySheet = graphics.newImageSheet("imgs/birdHouse1.png", spriteOptions)--, 2000, 2000)
		sequenceData = {
			{name = "buzz", frames={1}, time = 300, loopCount = 1},
		}	
		
		self.model = display.newSprite(mySheet, sequenceData)
		self.model.type = "obstacle"  --Define the type of obstacle for collision detection
		self.model:setSequence("buzz")
	elseif (rand == 3) then
		self.damage = 1
		
		spriteOptions = {	
			height = 64, 
			width = 64, 
			numFrames = 1, 
			sheetContentWidth = 64, 
			sheetContentHeight = 64 
		}
		
		mySheet = graphics.newImageSheet("imgs/birdHouse2.png", spriteOptions)--, 2000, 2000)
		sequenceData = {
			{name = "buzz", frames={1}, time = 300, loopCount = 1},
		}	
		
		self.model = display.newSprite(mySheet, sequenceData)
		self.model.type = "obstacle"  --Define the type of obstacle for collision detection
		self.model:setSequence("buzz")
	elseif (rand == 4) then 
		self.damage = 1
		
		spriteOptions = {	
			height = 64, 
			width = 64, 
			numFrames = 1, 
			sheetContentWidth = 64, 
			sheetContentHeight = 64 
		}
		
		mySheet = graphics.newImageSheet("imgs/poisenShroom.png", spriteOptions)--, 2000, 2000)
		sequenceData = {
			{name = "buzz", frames={1}, time = 300, loopCount = 1},
		}	
		
		self.model = display.newSprite(mySheet, sequenceData)
		self.model.type = "obstacle"  --Define the type of obstacle for collision detection
		self.model:setSequence("buzz")
	elseif (rand == 5 ) then
		self.damage = 1
		
		spriteOptions = {	
			height = 64, 
			width = 64, 
			numFrames = 2, 
			sheetContentWidth = 128, 
			sheetContentHeight = 64 
		}
		
		mySheet = graphics.newImageSheet("imgs/fireSheet.png", spriteOptions)--, 2000, 2000)
		sequenceData = {
			{name = "buzz", frames={1,2}, time = 100, loopCount = 0},
		}	
		
		self.model = display.newSprite(mySheet, sequenceData)
		self.model.type = "obstacle"  --Define the type of obstacle for collision detection
		self.model:setSequence("buzz")
	end
	
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