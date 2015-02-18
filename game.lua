local composer = require( "composer" )
local physics = require("physics")
local score = require( "score" )
local widget = require "widget"		-- include Corona's "widget" library
require('ObstacleClass')
require('PlayerClass')
require('AcornClass')
require('obstacleGeneration')
require('options')
local scene = composer.newScene()

--Variables
local scoreText, timePassedBetweenEvents, timePassed, stageTimer, difficultytimer, maxDifficulty
local highScore, pauseBtn, damageMask
local screenTop, screenBottom, screenLeft, screenRight
local contentHeight = display.contentHeight
local contentWidth = display.contentWidth
local player
local bgImg = "imgs/bg1.jpg"
local bgTree1 = "imgs/tree1xl.png"
local bgTree2 = "imgs/tree2xl.png"
local bgTree3 = "imgs/tree3xl.png"
local clouds = {}
local obstacles = {} --Holds obstacles
local yTranslate
local contentHeight = contentHeight
local contentWidth = contentWidth
local playerHit = false
local maskAlpha = 0
local beginX = contentWidth *0.5 	--Used to track swiping movements, represents initial user touch position on screen 
paused = false
playerScore = 0
distance = 0
local difficulty = 1

--Images and sprite setup
--Background
display.setDefault( "background", 0/255, 120/255, 171/255 )
local tree1 = display.newImageRect(bgTree1, contentWidth*.1, contentHeight*2)
local tree2 = display.newImageRect(bgTree2, contentWidth*.1, contentHeight*2)
local tree3 = display.newImageRect(bgTree3, contentWidth*.1, contentHeight*2)
for i = 1, 3, 1 do
	clouds[i] = display.newImageRect("imgs/achievement" .. i .. ".png", 128, 128)
	clouds[i].x = math.random(1, contentWidth)
	clouds[i].y = 0 - math.random(1, contentHeight)
end
tree1.x = contentWidth*.25
tree1.y = 0
tree2.x = contentWidth*.5
tree2.y = 0
tree3.x = contentWidth*.75
tree3.y = 0

local tut = display.newImageRect("imgs/tutorial.png", contentWidth, 100)
tut.x = display.contentCenterX
tut.y = contentHeight-50

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
healthSprite.xScale = contentWidth * .001
healthSprite.yScale = contentWidth * .001
healthSprite:setSequence( "health" .. 3 )
healthSprite:play()

local function moveRight() 
	if (player.model.x == contentWidth * .25) then
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.5})
	else
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.75})
	end
end

local function moveLeft() 
	if (player.model.x == contentWidth * .75) then
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.5})
	else
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.25})
	end
end

local function move(event)
	if (swipeMovement) then
		if(event.phase == "began") then
			beginX = event.x 
		elseif(event.phase == "ended") then 
			if(beginX > event.x) then 
				moveLeft()
			elseif (beginX < event.x) then
				moveRight()
			end
		end
	else
		if(event.phase == "began")then
			if(event.x > contentWidth*0.5)then
				moveRight()
			elseif(event.x < contentWidth*0.5)then
				moveLeft()
			end	
		end	
	end
end

local function pauseGame ()
	paused = true;
	composer.hideOverlay("game")
	composer.gotoScene("pause", {effect="fromRight", time=1000})
end

--Function handles player collision
--When the player collides with an "obstacle" they should lose health 
local function hitObstacle(self, event)
	if event.phase == "began" then
		if event.other.type == "obstacle" then   --If obstacle, do damage
			playerHit = true
			timer.performWithDelay (200, function() playerHit = false end)
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
			timer.performWithDelay (2000, function() composer.gotoScene( "loseScreen", {effect="fromRight", time=1000}) end)
			physics.setGravity(0,20)
			local xDir = (contentWidth*.5 - player.model.x)
			if xDir > 0 then
				xDir = 1
			else
				xDir = -1
			end
			player.model:applyForce( 5* xDir, -20, player.model.x, player.model.y)
			transition.to(player.model, {rotation=720*xDir, time=2000})
		end
	end
end


-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   paused = true
   timePassedBetweenEvents = 0
   playerScore = 0
   distance = 0
   timePassed = 0
   stageTimer = 0
   difficultyTimer = 0
	yTranslate = 10 * difficulty
	highScore = loadScore()
	maxDifficulty = 5 + math.floor(highScore *.01)
   
   pauseBtn = widget.newButton{
		label="",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/pauseBtn.png",
		overFile="imgs/pauseBtn.png",
		width=contentHeight * .05, height=contentHeight * .05,
		onRelease = pauseGame
	}
	--Pause button
	pauseBtn.anchorX = .5
	pauseBtn.anchorY = .5
	pauseBtn.x = contentWidth * .93
	pauseBtn.y = contentHeight * .05

	--Physics and physics vars
   	physics.start()
   	physics.setGravity(0,0)
	screenTop = display.screenOriginY
	screenBottom = display.viewableContentHeight + display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.viewableContentWidth + display.screenOriginX
	
	--Collision detection
	player = Player(contentWidth*.5, contentHeight*.75)
	player.model.collision = hitObstacle
	player.model:addEventListener("collision", player.model)
	physics.addBody(player.model, "dynamic",{isSensor=true})
	
	scoreText = display.newText( tostring(playerScore), contentWidth * .5, contentHeight*.1, "fonts/Rufscript010", contentHeight * .065)

	for i = 1, 3, 1 do
		sceneGroup:insert(clouds[i])
	end
	damageMask = display.newImageRect("imgs/damageMask.png", contentWidth, contentHeight)
	damageMask.anchorX = 0
	damageMask.anchorY = 0
	damageMask.alpha = 0
	
	sceneGroup:insert(tree1)
	sceneGroup:insert(tree2)
	sceneGroup:insert(tree3)
	sceneGroup:insert(pauseBtn)
	sceneGroup:insert(tut)
	sceneGroup:insert(player.model)
	sceneGroup:insert(scoreText)
	sceneGroup:insert(healthSprite)
	sceneGroup:insert(damageMask)
end

function main(event)
	if  ( paused ) then
		timePassed = timePassed + (event.time - timePassedBetweenEvents)
		stageTimer = stageTimer + (event.time - timePassedBetweenEvents)
		difficultyTimer = difficultyTimer + (event.time - timePassedBetweenEvents)
	elseif (player.health > 0) then
		if (event.time - timePassed > 250) then
			timePassed = event.time
			playerScore = playerScore + 1
			scoreText.text = playerScore
			distance = distance + difficulty
		end	
		if ( event.time - stageTimer > 1250/(difficulty*.5) ) then
			stageTimer = event.time
			generateObstacles(obstacles)
		end	
		if (event.time - difficultyTimer > 3000 and difficulty < maxDifficulty) then
			difficultyTimer = event.time
			difficulty = difficulty +.1
			yTranslate = 10 * difficulty
		end

		--On hit mask
		if (playerHit and maskAlpha < 1) then
			maskAlpha = maskAlpha + .2
		elseif (maskAlpha > 0) then
			maskAlpha = maskAlpha - .05
		end
		
		damageMask.alpha = maskAlpha
		
		--Background
		for i=1, #clouds do 
			if(clouds[i].y > contentHeight)then
				clouds[i].x = math.random(1, contentWidth)
				clouds[i].y = 0 - math.random(1, contentHeight)
			else
				clouds[i]:translate(0, yTranslate*.5)
			end
		end

		if(tree1.y >= contentHeight)then 
			tree1.y = tree1.y - contentHeight
			tree2.y = tree2.y - contentHeight
			tree3.y = tree3.y - contentHeight
		else
			tree1:translate(0,yTranslate)
			tree2:translate(0,yTranslate)
			tree3:translate(0,yTranslate)
		end

		for x=#obstacles, 1, -1 do
			obstacles[x].model:translate(0,yTranslate)
			if (obstacles[x].model.y > contentHeight + 100) then
				-- kill obstacle that is now off the screen
				physics.removeBody(obstacles[x].model)
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

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
	  tut.isVisible = true
		tree1.isVisible = true
		tree2.isVisible = true
		tree3.isVisible = true
		scoreText.isVisible = true
		pauseBtn.isVisible = true
		damageMask.isVisible = true
		for x=1,  #obstacles do
			obstacles[x].model.isVisible = true
		end
		for i = 1, #clouds do
			clouds[i].isVisible = true
		end
		player.model.isVisible = true
		healthSprite.isVisible = true
		
		

   elseif ( phase == "did" ) then
		paused = false
		Runtime:addEventListener( "touch", move)
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
		tut.isVisible = false
		tree1.isVisible = false
		tree2.isVisible = false
		tree3.isVisible = false
		scoreText.isVisible = false
		pauseBtn.isVisible = false
		damageMask.isVisible = false
		for x=1, #obstacles do
			obstacles[x].model.isVisible = false
		end
		for i = 1, #clouds do
			clouds[i].isVisible = false
		end
		player.model.isVisible = false
		healthSprite.isVisible = false
		Runtime:removeEventListener( "touch", move )

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
	pauseBtn:removeSelf()
	pauseBtn = nil
	for i = 1, #clouds do
		clouds[i]:removeSelf()
		clouds[i] = nil
	end
	clouds = {}
	damageMask:removeSelf()
	damageMask = nil
	scoreText:removeSelf()
	scoreText = nil

	for x=1,  #obstacles do
		obstacles[x]:delete()
	end
	--obstacles:removeSelf()
	--obstacles = nil

	player:delete()

	Runtime:removeEventListener( "enterFrame", main )

	Runtime:removeEventListener( "touch", move )

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
Runtime:addEventListener( "enterFrame", main )
--Runtime:addEventListener( "touch", swipeMove)
Runtime:addEventListener( "touch", move)


---------------------------------------------------------------------------------

return scene
