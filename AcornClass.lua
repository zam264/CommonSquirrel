local LCS = require 'LCS'
require "ObstacleClass" 

Acorn = Obstacle:extends()

--[[Acorn class is actual a class that spawns unique obstacles that do not damage the enemy (not just acorns)
Currently the 3 obstacles this class spawns are: 
 Acorns - Which heal the player and award points 
 Slow Shrooms - Which slow the game down for a small amount of time 
 Speed Shrooms - Which speed the game up for a small amount of time 
]]
function Acorn:init(posX, posY)
	local rand = math.random(5)
	self.damage = 0 --These obstacles do not damage the player 

	--Select one of the 3 unique obstacles to spawn randomly (equal chance) 
	--Spawn an acorn (heals)
	if (rand > 3) then
		self.model = display.newImage("imgs/acorn.png")
		self.model.type = "acorn"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .075
		self.model.height = display.contentWidth * .075
	--Spawn a special mushroom (slows time)
	elseif (rand > 1 and rand <= 3) then
		self.model = display.newImage("imgs/slowShroom.png")
		self.model.type = "slow"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .1
		self.model.height = display.contentWidth * .1
	--Spawns a special mushroom (speeds up time)
	else
		self.model = display.newImage("imgs/speedShroom.png")
		self.model.type = "speed"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .1
		self.model.height = display.contentWidth * .1
	end
	self.model.x = posX
	self.model.y = posY
	

	--Removes the obstacle 
	function Obstacle:delete()
		self.model:removeSelf()
		self.model = nil
		self = nil 
	end
end --End Acorn Class