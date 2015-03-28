local LCS = require 'LCS'
local unlockables = require( "unlockables" )
--require "options"	-- options needed for difficulty variable

Player = LCS.class({health, spriteOptions, mySheet ,model})

function Player:init(posX, posY)
	-- Initialize creatures base attributes
	self.health = 3; 

	--Declare and set up Sprite Image Sheet and sequence data
	spriteOptions = {	
		height = 64, 
		width = 64, 
		numFrames = 6, 
		sheetContentWidth = 384, 
		sheetContentHeight = 64 
	}
	local spriteSheets = {
		"imgs/squirrelSprite.png",
		"imgs/albinoSquirrelSheet.png",
		"imgs/ninjaSquirrelSheet.png",
		"imgs/coonSheet.png",
		"imgs/spaceSquirrelSheet.png"
	}
	mySheet = graphics.newImageSheet(spriteSheets[loadSkin()], spriteOptions, 50, 50)

	sequenceData = {
		{name = "forward", frames={1,2,3,4,5,6}, time = 500, loopCount = 0}
	}	
	
	-- Display the new sprite at the coordinates passed
	self.model = display.newSprite(mySheet, sequenceData)
	self.model:setSequence("forward")
	self.model:play()
	self.model.xScale = display.contentWidth * .003
	self.model.yScale = display.contentWidth * .003
	
	self.model.x = posX
	self.model.y = posY


	--self.model = display.newRect( posX, posY, display.contentWidth*.1, display.contentWidth*.125 )
	--self.model.x = posX
	--self.model.y = posY
	
--[[*****************    Methods    ******************]]--
	function Player:damage(amt)
		self.health = self.health - amt
		--Dont let health drop below 0 
		if self.health < 0 then 
			self.health = 0 
		end
	end

	function Player:heal(amt)
		self.health = self.health + 1 
		if self.health > 3 then
			self.health = 3 
		end
	end

	function Player:delete()
		self.model:removeSelf()
		self.model = nil
		self = nil
	end
		
end -- End CreatureClass