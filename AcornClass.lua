local LCS = require 'LCS'
require "ObstacleClass" 

Acorn = Obstacle:extends()

function Acorn:init(posX, posY)
	local rand = math.random(5)
	self.damage = 0

	if (rand > 3) then
		self.model = display.newImage("imgs/acorn.png")
		self.model.type = "acorn"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .075
		self.model.height = display.contentWidth * .075
	elseif (rand > 1 and rand <= 3) then
		self.model = display.newImage("imgs/slowShroom.png")
		self.model.type = "slow"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .1
	self.model.height = display.contentWidth * .1
	else
		self.model = display.newImage("imgs/speedShroom.png")
		self.model.type = "speed"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .1
	self.model.height = display.contentWidth * .1
	end
	self.model.x = posX
	self.model.y = posY
	

	function Obstacle:delete()
		self.model:removeSelf()
		self.model = nil
		self = nil 
	end
end --End Acorn Class