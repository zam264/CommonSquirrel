local composer = require( "composer" )
local physics = require("physics")
local score = require( "score" )
require('ObstacleClass')
require('PlayerClass')
require('obstacleGeneration')
local scene = composer.newScene()

--display.setStatusBar( display.HiddenStatusBar )


--Variables
local highScore
local screenTop, screenBottom, screenLeft, screenRight
local player
local bgImg = "imgs/bg1.jpg"
local bg = display.newImageRect( bgImg, display.contentWidth, display.contentHeight )
bg.x = display.contentCenterX
bg.y = display.contentHeight
local bg1 = display.newImageRect( bgImg, display.contentWidth, display.contentHeight )
bg1.x = display.contentCenterX
bg1.y = 0

local  scoreText, timePassed
playerScore = 0
distance = 0

local tut = display.newImageRect("imgs/tutorial.png", display.contentWidth, 100)
tut.x = display.contentCenterX
tut.y = display.contentHeight-50

local obstacles = {} --Holds obstacles 

--Health sprite variables
local options = {
	width = 192,
	height = 64,
	numFrames = 4
}
local healthSheet = graphics.newImageSheet("imgs/acornSprites.png", options)
local sequenceData = {
	{name = "health3", start=1, count=1, time=0, loopCount=1},
	{name = "health2", start=2, count=1, time=0, loopCount=1},
	{name = "health1", start=3, count=1, time=0, loopCount=1},
	{name = "health0", start=4, count=1, time=0, loopCount=1}
}
local healthSprite = display.newSprite( healthSheet, sequenceData )
healthSprite.x = 100
healthSprite.y = 32
healthSprite:setSequence( "health" .. 3 )
healthSprite:play()
--Health sprite variables

local obstacles = {} --Holds obstacles 


function newRect(yPos)
	local obj = Obstacle( display.contentWidth * math.random(3)*.25, yPos-math.random(display.contentHeight*.2))
	physics.addBody(obj.model, "dynamic", {isSensor=true})
	
	return obj
end
local function moveRight() 
	if (player.model.x < display.contentWidth * .75) then
		if (player.model.x < display.contentWidth * .5) then
			transition.to(player.model, {time=200, x=display.contentWidth*0.5})
		else
			transition.to(player.model, {time=200, x=display.contentWidth*0.75})
		end
	end
end
local function moveLeft() 
	if (player.model.x > display.contentWidth * .25) then
		if (player.model.x > display.contentWidth * .5) then
			transition.to(player.model, {time=200, x=display.contentWidth*0.5})
		else
			transition.to(player.model, {time=200, x=display.contentWidth*0.25})
		end
	end
end

local function printTouch(event)
	if(event.phase == "began")then
		if(event.x > display.contentWidth*0.5)then
			moveRight()
		elseif(event.x < display.contentWidth*0.5)then
			moveLeft()
		end	
	end	
end

--Function handles player collision
--When the player collides with an "obstacle" they should lose health 
local function hitObstacle(self, event)
	if event.phase == "began" then
		--print(player.health)
		player:damage(1)

		--Health sprites
		healthSprite:setSequence("health" .. player.health)
		healthSprite:play()
		--Health sprites

		if player.health == 0 then 
			print("Dead") 
			--Do Death stuff here 
			
			saveScore(playerScore)
			addToDistance(distance)
			for x=1,  #obstacles do
				obstacles[x]:delete()
			end
			obstacles = {}
			composer.gotoScene( "loseScreen", fromTop)
		end
	end
end


-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   playerScore = 0
   distance = 0
   timePassed = 0
   highScore = loadScore()

   	physics.start()
   	physics.setGravity(0,0)
	screenTop = display.screenOriginY
	screenBottom = display.viewableContentHeight + display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.viewableContentWidth + display.screenOriginX
	
	for n=1, 9 do
		table.insert(obstacles , newRect(-1 *n*display.contentHeight*.2))
	end
	
	--player = display.newRect( display.contentWidth*.5, display.contentHeight*.75, display.contentWidth*.1, display.contentWidth*.125 )
	player = Player(display.contentWidth*.5, display.contentHeight*.75)
	--Add collision detection to player object
	player.model.collision = hitObstacle
	player.model:addEventListener("collision", player.model)
	physics.addBody(player.model, "dynamic",{isSensor=true})
	
	scoreText = display.newText( tostring(playerScore), display.contentWidth * .5, display.contentHeight*.1, --[["fonts/Rufscript010" or]] native.systemFont ,display.contentHeight * .065)

	sceneGroup:insert(bg1)
	sceneGroup:insert(bg)
	sceneGroup:insert(tut)
	sceneGroup:insert(player.model)
	sceneGroup:insert(scoreText)
	sceneGroup:insert(healthSprite)
end


--[[function obstacles:enterFrame(event)
end]]

function obstacles:enterFrame(event)
	if (player.health > 0) then
		if (event.time - timePassed > 250 and player.health > 0) then
			timePassed = event.time
			playerScore = playerScore + 1
			scoreText.text = playerScore
			distance = distance + 2.64
		end	
		
		

		--Scrolling background
		if(bg.y > display.contentHeight*1.5)then 
			bg.y = display.contentHeight*-0.5
		elseif(bg1.y > display.contentHeight*1.5)then	
			bg1.y = display.contentHeight*-0.5
		else
			bg:translate(0, 3)
			bg1:translate(0, 3)
		end

		generateObstacles(obstacles)
		

		--print (#obstacles)

		--print (#collection)
	end
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view
  tut:removeSelf()
	tut = nil
	bg:removeSelf()
	bg = nil
	bg1:removeSelf()
	bg1 = nil
   
	scoreText:removeSelf()
	scoreText = nil
   
   for x=1,  #obstacles do
   		obstacles[x]:delete()
   end
	--obstacles:removeSelf()
	--obstacles = nil
	
   player:delete()
   
   Runtime:removeEventListener( "enterFrame", obstacles )
   Runtime:removeEventListener( "touch", printTouch )
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "enterFrame", obstacles )
Runtime:addEventListener( "touch", printTouch)

---------------------------------------------------------------------------------

return scene
