local LCS = require 'LCS'
require "ObstacleClass" 

Acorn = Obstacle:extends()

function Acorn:init(posX, posY)
	self.damage = 0

	self.model = display.newImage("imgs/acorn.png")
	self.model.type = "acorn"  --Define the type of obstacle for collision detection
	
	--self.model:setSequence("forward")
	self.model.x = posX
	self.model.y = posY
	self.model.width = display.contentWidth * .075
	self.model.height = display.contentWidth * .075

	function Obstacle:delete()
		self.model:removeSelf()
		self.model = nil
		self = nil 
	end
end --End Acorn Class