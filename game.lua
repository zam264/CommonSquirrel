local composer = require( "composer" )
local physics = require("physics")
local score = require( "score" )
local widget = require "widget"		-- include Corona's "widget" library
require('ObstacleClass')
require('PlayerClass')
require('AcornClass')
require('obstacleGeneration')
require('options')
require( "unlockables" )
local scene = composer.newScene()

--Variables
local scoreText,  timePassedBetweenEvents, timePassed, stageTimer, difficultytimer, maxDifficulty, bonusScoreText, scoreLabel
local highScore, pauseBtn, damageMask, tutorialText, tutorialBackground, tutorialArrowR, tutorialArrowL, tutorialGroup, bgR, bgG, bgB
local screenTop, screenBottom, screenLeft, screenRight, spaceBoundary, spaceTransition, balloon
local earthMusic = audio.loadStream("sound/Battle in the winter.mp3")
local spaceMusic = audio.loadStream("sound/At the dimensional gate_0.mp3")
local acornSFX = audio.loadSound("sound/Replenish.mp3")
local hitSFX = audio.loadSound("sound/atari_boom3.mp3")
local contentHeight = display.contentHeight
local contentWidth = display.contentWidth
local player
local trees = {}
local earthBGImgs = {}
local spaceBGImgs = {}
local stars = {}
local obstacles = {} --Holds obstacles
local yTranslate
local contentHeight = contentHeight
local contentWidth = contentWidth
local playerHit = false
local maskAlpha = 0
local bgClear = false
local beginX = contentWidth *0.5 	--Used to track swiping movements, represents initial user touch position on screen 
spaceBoundary = 2 --level of difficulty which you enter space
spaceTransition = .25
paused = false
playerScore = 0
distance = 0
bgR = 0
bgG = 120
bgB = 171
local difficulty = 1
local yTranslateModifier = 5
gameSpeedModifier = 1
--[[ Earth Background Modifiers ]]--
local earthBackgroundMovement = math.random(0,1)
if (earthBackgroundMovement == 0) then
	earthBackgroundMovement = -1
else
	earthBackgroundMovement = 1
end
local earthBGSpeed = {}
for i=1, 4 do
	earthBGSpeed[i] = math.random()
end
local earthBGGroup
--[[ Space Background Modifiers ]]--
local astroidRotation1 = math.random(0,1) - math.random()
local astroidRotation2 = math.random(0,1) - math.random()
local spaceBGSpeed = {}
for i=1, 3 do
	spaceBGSpeed[i] = math.random(0,1) - math.random()
end

--Images and sprite setup
--Background
display.setDefault( "background", bgR/255, bgG/255, bgB/255 )
--create the trees
for i = 1, 6, 1 do
	trees[i] = display.newImageRect("imgs/tree" .. i%3+1 .. ".png", contentWidth*.1, contentHeight*2 )
	trees[i].x = contentWidth *.25 * (i%3 + 1)
	if(i<=3)then
		trees[i].y = contentHeight+(-i * contentHeight * .33)
	else
		trees[i].y = trees[i-3].y - (contentHeight * .95) * 2
	end
end
--create the earth images
for i = 1, 4, 1 do
	local sizeMod = .75 + math.random()/2 
	if(i<=3)then
		earthBGImgs[i] = display.newImageRect("imgs/earthBGImg" .. i .. ".png", contentWidth*.6*sizeMod, contentWidth*.3*sizeMod)
		earthBGImgs[i].x = math.random(1, contentWidth)
		earthBGImgs[i].y = 0 - math.random(1, contentHeight)
	else
		earthBGImgs[i] = display.newImageRect("imgs/earthBGImg" .. math.random(4, 7) .. ".png", contentWidth*.3*sizeMod, contentWidth*.3*sizeMod)
		earthBGImgs[i].x = math.random(1, contentWidth)
		earthBGImgs[i].y = 0 - math.random(1, contentHeight)
	end
end
--create the space images
for i = 1, 3, 1 do
	local sizeMod = .75 + math.random()*.5 
	spaceBGImgs[i] = display.newImageRect("imgs/spaceBGImg" .. i .. ".png", contentWidth*.3*sizeMod, contentWidth*.3*sizeMod)
	spaceBGImgs[i].x = math.random(1, contentWidth)
	spaceBGImgs[i].y = 0 - math.random(50, contentHeight)
end
--create the stars
for i = 1, 100, 1 do
	stars[i] = display.newRect(math.random(1, contentWidth), 0 - math.random(1, contentHeight), 4, 4)
	stars[i].alpha = 0
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
healthSprite.anchorX = 0
healthSprite.anchorY = 0
healthSprite.x = contentWidth * .005
healthSprite.y = contentWidth * .015
healthSprite.xScale = contentWidth * .001
healthSprite.yScale = contentWidth * .001
healthSprite:setSequence( "health" .. 3 )
healthSprite:play()

local function moveRight() 
	if (player.model.x == contentWidth * .25) then
		transition.to(player.model, {rotation=30, time=100/difficulty})
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.5})
	elseif (player.model.x == contentWidth * .5) then
		transition.to(player.model, {rotation=30, time=100/difficulty})
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.75})
	end
end

local function moveLeft() 
	if (player.model.x == contentWidth * .75) then
		transition.to(player.model, {rotation=-30, time=100/difficulty})
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.5})
	elseif (player.model.x == contentWidth * .5) then
		transition.to(player.model, {rotation=-30, time=100/difficulty})
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
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
	if player.health > 0 then
		paused = true;
		composer.hideOverlay("game")
		composer.gotoScene("pause", {effect="fromRight", time=1000})
	end
end
	
--Function handles player collision
--When the player collides with an "obstacle" they should lose health 
local function hitObstacle(self, event)
	if event.phase == "began" then
		if event.other.type == "obstacle" then   --If obstacle, do damage
			audio.stop({channel = 4})
			audio.play( hitSFX, { channel=4, loops=0 } )
			audio.setVolume( effectsVolume, {channel=4})
			if vibrate then 
				system.vibrate()
			end
			playerHit = true
			timer.performWithDelay (200, function() playerHit = false end)
			player:damage(1)
		elseif (event.other.type == "acorn") then  --If Acorn, heal the player 
			audio.stop({channel = 3})
			audio.play( acornSFX, { channel=3, loops=0 } )
			audio.setVolume( effectsVolume, {channel=3})
			if player.health == 3 then
				bonusScoreText.text ="+" .. math.floor(difficulty * 5)
				bonusScoreText.alpha = 1
				playerScore = playerScore + math.floor(difficulty * 5)
			else
				player:heal(1)
			end
			event.other.alpha = 0
		elseif (event.other.type == "slow") then
			audio.stop({channel = 3})
			audio.play( acornSFX, { channel=3, loops=0 } )
			audio.setVolume( effectsVolume, {channel=3})
			event.other.alpha = 0
			gameSpeedModifier = gameSpeedModifier -.1
			timer.performWithDelay (100, function() gameSpeedModifier = gameSpeedModifier -.1 end)
			timer.performWithDelay (200, function() gameSpeedModifier = gameSpeedModifier -.1 end)
			timer.performWithDelay (300, function() gameSpeedModifier = gameSpeedModifier -.1 end)
			timer.performWithDelay (400, function() gameSpeedModifier = gameSpeedModifier -.1 end)
			timer.performWithDelay (1600, function() gameSpeedModifier = gameSpeedModifier +.1 end)
			timer.performWithDelay (1700, function() gameSpeedModifier = gameSpeedModifier +.1 end)
			timer.performWithDelay (1800, function() gameSpeedModifier = gameSpeedModifier +.1 end)
			timer.performWithDelay (1900, function() gameSpeedModifier = gameSpeedModifier +.1 end)
			timer.performWithDelay (2000, function() gameSpeedModifier = gameSpeedModifier +.1 end)
		elseif (event.other.type == "speed") then
			audio.stop({channel = 3})
			audio.play( acornSFX, { channel=3, loops=0 } )
			audio.setVolume( effectsVolume, {channel=3})
			event.other.alpha = 0
			gameSpeedModifier = gameSpeedModifier +.1
			timer.performWithDelay (100, function() gameSpeedModifier =  gameSpeedModifier +.1 end)
			timer.performWithDelay (200, function() gameSpeedModifier =  gameSpeedModifier +.1 end)
			timer.performWithDelay (300, function() gameSpeedModifier =  gameSpeedModifier +.1 end)
			timer.performWithDelay (400, function() gameSpeedModifier =  gameSpeedModifier +.1 end)
			timer.performWithDelay (1000, function() gameSpeedModifier =  gameSpeedModifier -.1 end)
			timer.performWithDelay (1100, function() gameSpeedModifier =  gameSpeedModifier -.1 end)
			timer.performWithDelay (1200, function() gameSpeedModifier =  gameSpeedModifier -.1 end)
			timer.performWithDelay (1300, function() gameSpeedModifier =  gameSpeedModifier -.1 end)
			timer.performWithDelay (1400, function() gameSpeedModifier = gameSpeedModifier -.1 end)
			
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
	loadSettings()
	audio.setVolume( musicVolume/100, {channel=2})
	audio.play( earthMusic, { channel=2, loops=-1, fadein=5000 } )
	
	local sceneGroup = self.view
	paused = true
	timePassedBetweenEvents = 0
	playerScore = 0
	distance = 0
	timePassed = 0
	stageTimer = 0
	difficultyTimer = 0
	yTranslate = yTranslateModifier * difficulty
	highScore = loadScore()
	maxDifficulty = 3
   
   	pauseBtn = widget.newButton{
		label="",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/pauseBtn.png",
		overFile="imgs/pauseBtn.png",
		width=contentWidth * .085, height=contentWidth * .085,
		onRelease = pauseGame
	}
	--Pause button
	pauseBtn.anchorX = 1
	pauseBtn.anchorY = 0
	pauseBtn.x = contentWidth
	pauseBtn.y = 0
	
	-- create tutorial
	tutorialGroup = display.newGroup()
	tutorialBackground = display.newImageRect("imgs/tutorialBackground.png", contentWidth *.75, contentWidth * .15  )
	tutorialBackground.x = contentWidth *.5
	tutorialBackground.y = contentHeight *.35
	tutorialBackground.anchorX = .5
	tutorialBackground.anchorY = .5
	tutorialGroup:insert(tutorialBackground)
	if (swipeMovement) then
		tutorialText =  display.newText( "Swipe       to jump Left\nSwipe       to jump Right", contentWidth * .5, contentHeight*.35, "fonts/Rufscript010", contentWidth * .05)
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
		tutorialText =  display.newText( "   Tap Here   |   Tap Here\n to Jump Left  |  to Jump Right", contentWidth * .5, contentHeight*.35, "fonts/Rufscript010", contentWidth * .05)
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
	
	scoreLabel = display.newText( "Score", contentWidth * .5, contentHeight*.05, "fonts/Rufscript010", contentHeight * .045)
	scoreText = display.newText( tostring(playerScore), contentWidth * .5, contentHeight*.1, "fonts/Rufscript010", contentHeight * .065)
	bonusScoreText = display.newText( 0, contentWidth * .5, contentHeight*.2, "fonts/Rufscript010", contentHeight * .065)
	bonusScoreText.alpha = 0

	--insert everything into the scene group
	for i=1, #stars do
		sceneGroup:insert(stars[i])
	end
	earthBGGroup = display.newGroup()
	for i = 1, 4, 1 do
		earthBGGroup:insert(earthBGImgs[i])
	end
	sceneGroup:insert(earthBGGroup)
	for i = 1, 3, 1 do
		sceneGroup:insert(spaceBGImgs[i])
	end
	for i = 1, 6, 1 do
		sceneGroup:insert(trees[i])
	end

	--create the image mask
	damageMask = display.newImageRect("imgs/damageMask.png", contentWidth, contentHeight)
	damageMask.anchorX = 0
	damageMask.anchorY = 0
	damageMask.alpha = 0

	sceneGroup:insert(pauseBtn)
	sceneGroup:insert(damageMask)
	sceneGroup:insert(player.model)
	sceneGroup:insert(scoreLabel)
	sceneGroup:insert(scoreText)
	sceneGroup:insert(bonusScoreText)
	sceneGroup:insert(healthSprite)
	sceneGroup:insert(tutorialGroup)
end

function main(event)
	if  ( paused ) then --Check if the game is paused
		timePassed = timePassed + (event.time - timePassedBetweenEvents)
		stageTimer = stageTimer + (event.time - timePassedBetweenEvents)
		difficultyTimer = difficultyTimer + (event.time - timePassedBetweenEvents)
	elseif (player.health > 0) then --Game isn't paused; Normal Gameplay

		--update gameplay variables
		if (event.time - timePassed > 250) then 
			timePassed = event.time
			playerScore = playerScore + 1
			scoreText.text = playerScore
			distance = distance + (difficulty * gameSpeedModifier)
		end	
		bonusScoreText.alpha = bonusScoreText.alpha - .003

		--generate obstacles
		if ( event.time - stageTimer > 550/(difficulty)/gameSpeedModifier ) then
			stageTimer = event.time
			generateObstacles(obstacles)
		end	

		--update difficulty and scroll speed
		if (event.time - difficultyTimer > math.floor(difficulty) * 1500 and difficulty < maxDifficulty) then
			difficultyTimer = event.time
			difficulty = difficulty +.1
		end
		yTranslate = yTranslateModifier * difficulty * gameSpeedModifier
		
		--move the tutorial away
		if (difficulty > 1 and difficulty < 1.5) then
			tutorialGroup:translate(0, yTranslate)
			tutorialGroup.alpha = tutorialGroup.alpha - .015
		end
			
		--display mask on hit
		if (playerHit and maskAlpha < 1) then
			maskAlpha = maskAlpha + .2
		elseif (maskAlpha > (3-player.health) * .3) then
			maskAlpha = maskAlpha - .05
		end
		damageMask.alpha = maskAlpha
		
		--background
		--spawn normal earthly background images
		if(difficulty < spaceBoundary)then
			for i=1, #earthBGImgs do 
				if(earthBGImgs[i].y > contentHeight+earthBGImgs[i].height *.5)then
					if (i == 4) then	
						local sizeMod = (.75 + math.random()*.5)
						earthBGImgs[i]:removeSelf()
						earthBGImgs[i] = display.newImageRect("imgs/earthBGImg" .. math.random(4, 7) .. ".png", contentWidth*.3 * sizeMod, contentWidth*.3*sizeMod)
						earthBGGroup:insert(earthBGImgs[i])
						
					else
						earthBGImgs[i].width =  contentWidth*.6*(.9 + math.random()*.1)
						earthBGImgs[i].height =  contentWidth*.3*(.9 + math.random()*.1)
					end
					if (earthBackgroundMovement > 0) then
						earthBGImgs[i].x = math.random(1, contentWidth*.5)
					else
						earthBGImgs[i].x = math.random(contentWidth*.5, contentWidth)
					end
					earthBGImgs[i].y = 0 - math.random(1, contentHeight)
					earthBGSpeed[i] = math.random()
				else
					earthBGImgs[i]:translate(earthBackgroundMovement * earthBGSpeed[i], yTranslate*.5)
				end
			end
		else 
			if(bgClear == false)then --clear old earth images
				local count = 0
				for i=1, #earthBGImgs do --move earth images off screen
					if(earthBGImgs[i].y < contentHeight+earthBGImgs[i].height *.5)then
						earthBGImgs[i]:translate(earthBackgroundMovement * earthBGSpeed[i], yTranslate*.5)
					else --when we know all earth images are off screen set bgClear to true
						count = count + 1
						if(count == #earthBGImgs)then
							bgClear = true			
							audio.stop(2)
							audio.play( spaceMusic, { channel=2, loops=-1, fadein=5000 } )
						end
					end
				end
			else  --old images are cleared, begin to utilize space images	
				for i=1, #spaceBGImgs do 
					if(spaceBGImgs[i].y > contentHeight+spaceBGImgs[i].height *.5)then
						spaceBGImgs[i].x = math.random(1, contentWidth)
						spaceBGImgs[i].y = 0 - math.random(1, contentHeight)			
						if (i == 1) then
							astroidRotation1 = math.random(0,1) - math.random()
							spaceBGImgs[i].width = contentWidth*.3*(.75 + math.random()*.5)
							spaceBGImgs[i].height = contentWidth*.3*(.75 + math.random()*.5)
						elseif (i == 2) then
							astroidRotation2 = math.random(0,1) - math.random()
							spaceBGImgs[i].width = contentWidth*.3*(.75 + math.random()*.5)
							spaceBGImgs[i].height = contentWidth*.3*(.75 + math.random()*.5)
						else
							local sizeMod = (.75 + math.random()*.5)
							spaceBGImgs[i].width = contentWidth*.3*sizeMod
							spaceBGImgs[i].height = contentWidth*.3*sizeMod
						end
						spaceBGSpeed[i] = math.random(0,1) - math.random()
					else
						spaceBGImgs[i]:translate(spaceBGSpeed[i], yTranslate*.5)
					end	
				end
				spaceBGImgs[1]:rotate(astroidRotation1)
				spaceBGImgs[2]:rotate(astroidRotation2)
				for i=1, #stars do
					if(stars[i].y > contentHeight)then
						stars[i].alpha = stars[i].alpha + .2 * gameSpeedModifier
						stars[i].x = math.random(1, contentWidth)
						stars[i].y = 0 - math.random(1, contentHeight)
					else
						stars[i]:translate(0, yTranslate*.5)
					end
				end
			end
		end

		--transition the background to black to represent space
		if(difficulty > spaceBoundary and (bgG > 1 or bgB > 1))then
			bgG = bgG - (spaceTransition * gameSpeedModifier)
			bgB = bgB - (spaceTransition  * gameSpeedModifier)
			display.setDefault( "background", bgR/255, bgG/255, bgB/255 )
		end

		--reset tree location if trees travel off-screen
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
		
		--move the trees
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
      	audio.resume(2)
	  	tutorialGroup.isVisible = true
	  	scoreLabel.isVisible = true
		scoreText.isVisible = true
		bonusScoreText.isVisible = true
		pauseBtn.isVisible = true
		damageMask.isVisible = true
		player.model.isVisible = true
		healthSprite.isVisible = true
		for x=1,  #obstacles do
			obstacles[x].model.isVisible = true
		end
		for x=1,  #trees do
			trees[x].isVisible = true
		end
		for i = 1, #earthBGImgs do
			earthBGImgs[i].isVisible = true
		end
		for i = 1, #spaceBGImgs do
			spaceBGImgs[i].isVisible = true
		end
		for i = 1, #stars do
			stars[i].isVisible = true
		end
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
		scoreLabel.isVisible = false
		scoreText.isVisible = false
		bonusScoreText.isVisible = false
		pauseBtn.isVisible = false
		damageMask.isVisible = false
		for x=1, #obstacles do
			obstacles[x].model.isVisible = false
		end
		for i = 1, #earthBGImgs do
			earthBGImgs[i].isVisible = false
		end
		for i = 1, #spaceBGImgs do
			spaceBGImgs[i].isVisible = false
		end
		for i = 1, #stars do
			stars[i].isVisible = false
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

	for i = 1, #trees do
		trees[i]:removeSelf()
		trees[i] = nil
	end
	for i = 1, #earthBGImgs do
		earthBGImgs[i]:removeSelf()
		earthBGImgs[i] = nil
	end
	for i = 1, #spaceBGImgs do
		spaceBGImgs[i]:removeSelf()
		spaceBGImgs[i] = nil
	end
	for i = 1, #stars do
		stars[i]:removeSelf()
		stars[i] = nil
	end
	for x=1,  #obstacles do
		obstacles[x]:delete()
	end	
	earthBGImgs = {}
	spaceBGImgs = {}
	stars = {}
	damageMask:removeSelf()
	damageMask = nil
	tutorialGroup:removeSelf()
	tutorialGroup = nil
	scoreLabel:removeSelf()
	scoreLabel = nil
	scoreText:removeSelf()
	scoreText = nil
	bonusScoreText:removeSelf()
	bonusScoreText = nil
	pauseBtn:removeSelf()
	pauseBtn = nil
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
