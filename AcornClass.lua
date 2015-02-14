local LCS = require 'LCS'
require "ObstacleClass" 

Acorn = Obstacle:extends()

function Acorn:init(posX, posY)
	self.damage = 0
	self.type = "acorn"

	self.model = display.newImageRect("img/acorn.png", display.contentWidth * .0025, display.contentWidth * .0025)
	
	-- Display the new sprite at the coordinates passed
	--self.model:setSequence("forward")
	self.model.x = posX
	self.model.y = posY
	--self.model.xScale = display.contentWidth * .0025
	--self.model.yScale = display.contentWidth * .0025

	function Obstacle:delete()
		self.model:removeSelf()
		self.model = nil
		self = nil 
	end
end --End Acorn Class