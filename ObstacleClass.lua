local LCS = require 'LCS'
--[[
This class defines an obstacle that can appear on the trees, when hit obstacles cause the player to lose a life
Creation of an obstacle is done by calling Obstacle(x, y) - this places the obstacle at the passed x and y coord
]]

Obstacle = LCS.class({damage, spriteOptions, mySheet ,model})

function Obstacle:init(posX, posY)
	-- Initialize creatures base attributes
	local rand = math.random(5) --Randomly pick which obstacle will spawn - currently all have equal chance as they all only do 1 damage
	
	--Creates a Bee Hive
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
	
	--Creates a Bird House 
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

	--Creates a different colored bird house
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
	--Creates a Poison Mushroom
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
	--Creates a fire
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
	
	self.model:play()    --Play the animation 
	self.model.x = posX  --Place the sprite at the passed X Coord
	self.model.y = posY  --Place the sprite at the passed Y Coord
	--Scale the x and y of the sprite 
	self.model.xScale = display.contentWidth * .0025  
	self.model.yScale = display.contentWidth * .0025
	
--[[*****************    Methods    ******************]]--
	--Remove the sprite
	function Obstacle:delete()
		self.model:removeSelf()
		self.model = nil
		self = nil 
	end
		
end -- End CreatureClass