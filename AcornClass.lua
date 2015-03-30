local LCS = require 'LCS'
require "ObstacleClass" 

Acorn = Obstacle:extends()

--[[Acorn class is actual a class that spawns unique obstacles that do not damage the enemy (not just acorns)
Currently the 3 obstacles this class spawns are: 
 Acorns - Which heal the player and award points 
 Slow Shrooms - Which slow the game down for a small amount of time 
 Speed Shrooms - Which speed the game up for a small amount of time 
 Invincible Shrooms - Grant the player temporary invulnerability 
]]
function Acorn:init(posX, posY)
	local rand = math.random(4)
	self.damage = 0 --These obstacles do not damage the player 

	--[[
	--Select one of the 4 unique obstacles to spawn randomly  
	1 = Speed 
	2 = Slow 
	3 = Invincible
	4 = Acorn
	]]
	--Spawn an acorn (heals)
	if (rand == 4) then
		self.model = display.newImage("imgs/acorn.png")
		self.model.type = "acorn"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .075
		self.model.height = display.contentWidth * .075
	--Spawn a special mushroom (slows time)
	elseif (rand == 2) then
		self.model = display.newImage("imgs/slowShroom.png")
		self.model.type = "slow"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .1
		self.model.height = display.contentWidth * .1
	--Spawns a special mushroom (speeds up time)
	elseif(rand == 1) then
		self.model = display.newImage("imgs/speedShroom.png")
		self.model.type = "speed"  --Define the type of obstacle for collision detection
		self.model.width = display.contentWidth * .1
		self.model.height = display.contentWidth * .1
	--Creates a special mushroom (causes invincibility)
	elseif(rand == 3) then
		self.model = display.newImage("imgs/healthShroom.png")
		self.model.type = "red"  --Define the type of obstacle for collision detection
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