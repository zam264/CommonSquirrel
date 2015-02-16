local composer = require( "composer" )
local physics = require("physics")
local score = require( "score" )
local widget = require "widget"		-- include Corona's "widget" library
require('ObstacleClass')
require('PlayerClass')
require('AcornClass')
require('obstacleGeneration')
local scene = composer.newScene()

--Variables
local scoreText, timePassedBetweenEvents, timePassed, stageTimer
local bgSpeed = 10	--Change the speed of the background (orig. 3) 
local highScore
local screenTop, screenBottom, screenLeft, screenRight
local player
local bgImg = "imgs/bg1.jpg"
local bgTree1 = "imgs/tree1xl.png"
local bgTree2 = "imgs/tree2xl.png"
local bgTree3 = "imgs/tree3xl.png"
local obstacles = {} --Holds obstacles
paused = false
playerScore = 0
distance = 0

--Images and sprite setup
--Background
display.setDefault( "background", 0/255, 120/255, 171/255 )
local tree1 = display.newImageRect(bgTree1, display.contentWidth*.1, display.contentHeight*2)
local tree2 = display.newImageRect(bgTree2, display.contentWidth*.1, display.contentHeight*2)
local tree3 = display.newImageRect(bgTree3, display.contentWidth*.1, display.contentHeight*2)
tree1.x = display.contentWidth*.25
tree1.y = 0
tree2.x = display.contentWidth*.5
tree2.y = 0
tree3.x = display.contentWidth*.75
tree3.y = 0

local tut = display.newImageRect("imgs/tutorial.png", display.contentWidth, 100)
tut.x = display.contentCenterX
tut.y = display.contentHeight-50

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
healthSprite.xScale = display.contentWidth * .001
healthSprite.yScale = display.contentWidth * .001
healthSprite:setSequence( "health" .. 3 )
healthSprite:play()

local function moveRight() 
	--if (player.model.x < display.contentWidth * .75) then
	if (player.model.x == display.contentWidth * .5 or player.model.x == display.contentWidth * .25) then
		if (player.model.x < display.contentWidth * .5) then
			transition.to(player.model, {time=200, x=display.contentWidth*0.5})
		else
			transition.to(player.model, {time=200, x=display.contentWidth*0.75})
		end
	end
end

local function moveLeft() 
	--if (player.model.x > display.contentWidth * .25) then
	if (player.model.x == display.contentWidth * .5 or player.model.x == display.contentWidth * .75) then
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

local function pauseGame ()
	paused = true;
	composer.hideOverlay("game")
	composer.gotoScene("pause")
end

--Function handles player collision
--When the player collides with an "obstacle" they should lose health 
local function hitObstacle(self, event)
	if event.phase == "began" then
		if event.other.type == "obstacle" then   --If obstacle, do damage
			player:damage(1)
		else  --If Acorn, heal the player 
			if player.health == 3 then
				playerScore = playerScore + 10 
			else
				player:heal(1)
			end
			event.other.alpha = 0
		end
		healthSprite:setSequence("health" .. player.health) --Play a sprite sequence to reflect how much health is left
		healthSprite:play()

		if player.health == 0 then 
			print("Dead") 
			saveScore(playerScore)
			addToDistance(distance)
			for x=1,  #obstacles do
				obstacles[x]:delete()
			end
			obstacles = {}
			timer.performWithDelay (2000, function() composer.gotoScene( "loseScreen", fromTop) end)
			physics.setGravity(0,20)
			local xDir = (display.contentWidth*.5 - player.model.x)
			if xDir > 0 then
				xDir = 1
			else
				xDir = -1
			end
			player.model:applyForce( 5* xDir, -20, player.model.x, player.model.y)
			transition.to(player.model, {rotation=720, time=2000})
		end
	end
end


-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   playerScore = 0
   distance = 0
   timePassed = 0
   stageTimer = 0
   highScore = loadScore()
   
   pauseBtn = widget.newButton{
		label="",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/pauseBtn.png",
		overFile="imgs/pauseBtn.png",
		width=display.contentHeight * .05, height=display.contentHeight * .05,
		onRelease = pauseGame
	}
	--Pause button
	pauseBtn.anchorX = .5
	pauseBtn.anchorY = .5
	pauseBtn.x = display.contentWidth * .93
	pauseBtn.y = display.contentHeight * .05

	--Physics and physics vars
   	physics.start()
   	physics.setGravity(0,0)
	screenTop = display.screenOriginY
	screenBottom = display.viewableContentHeight + display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.viewableContentWidth + display.screenOriginX
	
	--Collision detection
	player = Player(display.contentWidth*.5, display.contentHeight*.75)
	player.model.collision = hitObstacle
	player.model:addEventListener("collision", player.model)
	physics.addBody(player.model, "dynamic",{isSensor=true})
	
	scoreText = display.newText( tostring(playerScore), display.contentWidth * .5, display.contentHeight*.1, --[["fonts/Rufscript010" or]] native.systemFont ,display.contentHeight * .065)

	sceneGroup:insert(tree1)
	sceneGroup:insert(tree2)
	sceneGroup:insert(tree3)
	sceneGroup:insert(pauseBtn)
	sceneGroup:insert(tut)
	sceneGroup:insert(player.model)
	sceneGroup:insert(scoreText)
	sceneGroup:insert(healthSprite)
end

function obstacles:enterFrame(event)
	if  ( paused ) then
		timePassed = timePassed + (event.time - timePassedBetweenEvents)
		stageTimer = stageTimer + (event.time - timePassedBetweenEvents)
	elseif (player.health > 0) then
		if (event.time - timePassed > 250) then
			timePassed = event.time
			playerScore = playerScore + 1
			scoreText.text = playerScore
			distance = distance + 2.64
		end	
		if ( event.time - stageTimer > 1250 ) then
			stageTimer = event.time
			generateObstacles(obstacles)
		end	


		if(tree1.y >= display.contentHeight)then 
			tree1.y = 0
			tree2.y = 0
			tree3.y = 0
		else
			tree1:translate(0, bgSpeed)
			tree2:translate(0, bgSpeed)
			tree3:translate(0, bgSpeed)
		end

		for x=#obstacles, 1, -1 do
			obstacles[x].model:translate(0,20)
			if (obstacles[x].model.y > display.contentHeight + 200) then
				-- kill obstacle that is now off the screen
				obstacles[x]:delete()
				table.remove(obstacles, x)
			end
		end
	end
	timePassedBetweenEvents = event.time
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   paused = false
   
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

   for x=1,  #obstacles do
		sceneGroup:insert(obstacles[x].model)
	end
   
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
	tree1:removeSelf()
	tree1 = nil
	tree2:removeSelf()
	tree2 = nil
	tree3:removeSelf()
	tree3 = nil

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
