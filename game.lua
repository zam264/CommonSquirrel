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
local scoreText, distanceText, timePassedBetweenEvents, timePassed, stageTimer, difficultytimer, maxDifficulty, bonusScoreText
local highScore, pauseBtn, damageMask, tutorialText, tutorialBackground, tutorialArrowR, tutorialArrowL, tutorialGroup, btR, bgG, bgB
local screenTop, screenBottom, screenLeft, screenRight, spaceBoundary
local contentHeight = display.contentHeight
local contentWidth = display.contentWidth
local player
local trees = {}
local clouds = {}
local obstacles = {} --Holds obstacles
local yTranslate
local contentHeight = contentHeight
local contentWidth = contentWidth
local playerHit = false
local maskAlpha = 0
local beginX = contentWidth *0.5 	--Used to track swiping movements, represents initial user touch position on screen 
spaceBoundary = 2 --level of difficulty which you enter space
paused = false
playerScore = 0
distance = 0
bgR = 0
bgG = 120
bgB = 171
local difficulty = 1



--Images and sprite setup
--Background
display.setDefault( "background", bgR/255, bgG/255, bgB/255 )
for i = 1, 6, 1 do
	trees[i] = display.newImageRect("imgs/tree" .. i%3+1 .. ".png", contentWidth*.1, contentHeight*2 )
	trees[i].x = contentWidth *.25 * (i%3 + 1)
	if(i<=3)then
		trees[i].y = contentHeight+(-i * contentHeight * .33)
	else
		trees[i].y = trees[i-3].y - (contentHeight * .95) * 2
	end
end
for i = 1, 3, 1 do
	clouds[i] = display.newImageRect("imgs/cloud" .. i .. ".png", contentWidth*.6, contentWidth*.3)
	clouds[i].x = math.random(1, contentWidth)
	clouds[i].y = 0 - math.random(1, contentHeight)
end

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
				bonusScoreText.text ="+" .. math.floor(difficulty * 5)
				bonusScoreText.alpha = 1
				playerScore = playerScore + math.floor(difficulty * 5)
			else
				player:heal(1)
			end
			event.other.alpha = 0
		end
		healthSprite:setSequence("health" .. player.health) --Play a sprite sequence to reflect how much health is left
		healthSprite:play()

		if player.health == 0 then 
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
	
	-- create tutorial
	tutorialGroup = display.newGroup()
	tutorialBackground = display.newImageRect("imgs/tutorialBackground.png", contentWidth *.75, contentWidth * .15  )
	tutorialBackground.x = contentWidth *.5
	tutorialBackground.y = contentHeight *.35
	tutorialBackground.anchorX = .5
	tutorialBackground.anchorY = .5
	tutorialGroup:insert(tutorialBackground)
	if (swipeMovement) then
		tutorialText =  display.newText( "Swipe          to jump Left\nSwipe          to jump Right", contentWidth * .5, contentHeight*.35, "fonts/Rufscript010", contentWidth * .05)
		tutorialText.anchorX = .5
		tutorialText.anchorY = .5
		
		tutorialArrowR = display.newImageRect("imgs/arrow.png", contentWidth*.08, contentWidth*.04)
		tutorialArrowR.x = contentWidth * .42
		tutorialArrowR.y = contentHeight*.335
		tutorialArrowR.anchorX = .5
		tutorialArrowR.anchorY = .5
		tutorialGroup:insert(tutorialArrowR)
		
		tutorialArrowL = display.newImageRect("imgs/arrow.png", contentWidth*.08, contentWidth*.04)
		tutorialArrowL.x = contentWidth * .42
		tutorialArrowL.y = contentHeight*.365
		tutorialArrowL.anchorX = .5
		tutorialArrowL.anchorY = .5
		tutorialArrowL:rotate(180)
		tutorialGroup:insert(tutorialArrowL)
	else
		tutorialText =  display.newText( "    Tap Here      |       Tap Here\n to Jump Left    |    to Jump Right", contentWidth * .5, contentHeight*.35, "fonts/Rufscript010", contentWidth * .05)
		tutorialText.anchorX = .5
		tutorialText.anchorY = .5
	end
	tutorialGroup:insert(tutorialText)
	-- end tutorial

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
	
	scoreText = display.newText( tostring(playerScore), contentWidth * .25, contentHeight*.1, "fonts/Rufscript010", contentHeight * .065)
	bonusScoreText = display.newText( 0, contentWidth * .25, contentHeight*.2, "fonts/Rufscript010", contentHeight * .065)
	bonusScoreText.alpha = 0
	distanceText = display.newText( tostring(distance), contentWidth * .75, contentHeight*.1, "fonts/Rufscript010", contentHeight * .065)

	for i = 1, 3, 1 do
		sceneGroup:insert(clouds[i])
	end
	for i = 1, 6, 1 do
		sceneGroup:insert(trees[i])
	end
	damageMask = display.newImageRect("imgs/damageMask.png", contentWidth, contentHeight)
	damageMask.anchorX = 0
	damageMask.anchorY = 0
	damageMask.alpha = 0
	

	sceneGroup:insert(pauseBtn)
	sceneGroup:insert(damageMask)
	sceneGroup:insert(player.model)
	sceneGroup:insert(scoreText)
	sceneGroup:insert(bonusScoreText)
	sceneGroup:insert(distanceText)
	sceneGroup:insert(healthSprite)
	sceneGroup:insert(tutorialGroup)
end

function main(event)
	--print (event.time - timePassedBetweenEvents)
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
			distanceText.text = distance
		end	
		bonusScoreText.alpha = bonusScoreText.alpha - .003
		if ( event.time - stageTimer > 1250/(difficulty*.5) ) then
			stageTimer = event.time
			generateObstacles(obstacles)
		end	
		if (event.time - difficultyTimer > 3000 and difficulty < maxDifficulty) then
			difficultyTimer = event.time
			difficulty = difficulty +.1
			yTranslate = 10 * difficulty
		end
		
		if (difficulty > 1 and difficulty < 1.5) then
			tutorialGroup:translate(0, yTranslate)
			tutorialGroup.alpha = tutorialGroup.alpha - .015
		end
			
		--On hit mask
		if (playerHit and maskAlpha < 1) then
			maskAlpha = maskAlpha + .2
		elseif (maskAlpha > (3-player.health) * .3) then
			maskAlpha = maskAlpha - .05
		end
		damageMask.alpha = maskAlpha
		
		--Background
		if(difficulty < spaceBoundary)then--stop cloud spawn in space
			for i=1, #clouds do 
				if(clouds[i].y > contentHeight+clouds[i].height/2)then
					clouds[i].x = math.random(1, contentWidth)
					clouds[i].y = 0 - math.random(1, contentHeight)
				else
					clouds[i]:translate(0, yTranslate*.5)
				end
			end
		else --move lingering clouds off-screen 
			for i=1, #clouds do 
				if(clouds[i].y < contentHeight+clouds[i].height/2)then
					clouds[i]:translate(0, yTranslate*.5)
					print("moving cloud")
				end
			end
		end

		if(difficulty > spaceBoundary and (bgG > 1 or bgB > 1))then
			bgG = bgG - .5
			bgB = bgB - .5
			display.setDefault( "background", bgR/255, bgG/255, bgB/255 )
		end

		--Tree Movement
		if(trees[1].y >= 2*contentHeight)then 
			trees[1].y = trees[4].y - (contentHeight * .95) * 2
		elseif (trees[4].y >= 2*contentHeight) then
			trees[4].y = trees[1].y - (contentHeight * .95) * 2
		end
		if (trees[2].y >= 2*contentHeight) then
			trees[2].y = trees[5].y - (contentHeight * .95) * 2
		elseif (trees[5].y >= 2*contentHeight) then
			trees[5].y = trees[2].y - (contentHeight * .95) * 2
		end
		if (trees[3].y >= 2*contentHeight) then
			trees[3].y = trees[6].y - (contentHeight * .95) * 2
		elseif (trees[6].y >= 2*contentHeight) then
			trees[6].y = trees[3].y - (contentHeight * .95) * 2	
		end
		
		for i = 1, #trees do
			trees[i]:translate(0, yTranslate)
		end

		--Obstacle Handling
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
	  	tutorialGroup.isVisible = true
		scoreText.isVisible = true
		bonusScoreText.isVisible = true
		distanceText.isVisible = true
		pauseBtn.isVisible = true
		damageMask.isVisible = true
		for x=1,  #obstacles do
			obstacles[x].model.isVisible = true
		end
		for x=1,  #trees do
			trees[x].isVisible = true
		end
		for i = 1, #clouds do
			clouds[i].isVisible = true
		end
		player.model.isVisible = true
		healthSprite.isVisible = true
		
		

   elseif ( phase == "did" ) then
		paused = false
		Runtime:addEventListener( "touch", move)
		Runtime:addEventListener( "enterFrame", main)
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
		for x=1, #trees do
			trees[x].isVisible = false
		end
		tutorialGroup.isVisible = false
		scoreText.isVisible = false
		bonusScoreText.isVisible = false
		distanceText.isVisible = false
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
		Runtime:removeEventListener( "enterFrame", main)

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
	pauseBtn:removeSelf()
	pauseBtn = nil
	for i = 1, #trees do
		trees[i]:removeSelf()
		trees[i] = nil
	end
	for i = 1, #clouds do
		clouds[i]:removeSelf()
		clouds[i] = nil
	end
	clouds = {}
	damageMask:removeSelf()
	damageMask = nil
	tutorialGroup:removeSelf()
	tutorialGroup = nil
	scoreText:removeSelf()
	scoreText = nil
	bonusScoreText:removeSelf()
	bonusScoreText = nil
	distanceText:removeSelf()
	distanceText = nil

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
