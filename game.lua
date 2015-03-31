--[[
game.lua by William Botzer, Steven Zamborsky, Zachary Petrusch
]]--
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


-- Global variables
paused = false		-- If the game is paused or not
					-- Paused helps manage timers to prevent the player from manipulating the pause screen
playerScore = 0		-- The players score as a number
distance = 0		-- The players distance as a number

-- Local Variable Declarations
local scoreText, livesText, bonusScoreText	-- General text objects
local tutorialText, tutorialBackground, tutorialArrowR, tutorialArrowL, tutorialGroup	-- Objects specifically for the tutorial
local scoreLabel	-- The text "Score" at the top of the screen ( variable 'scoreText' contains the text of the players score)
local pauseBtn		-- The pause button widget in the top right
local playerHit = false	-- Set to true when the player is hit by an obstacle THAT DOES DAMAGE
local beginX 			-- Used to track swiping movements, represents initial user touch position on screen 

--Game Timers
local timePassedBetweenEvents	-- the amount of time passed between calls to   main(event)
local timePassed		-- Used to check when .25 seconds pass in order to increment score
local stageTimer		-- Used to check when enough time has passed to generate obstacles
local difficultyTimer	-- Used to check when enough time has passed to increase the difficulty

-- Default background colors
local bgR = 0	-- Default red value of the background
local bgG = 120	-- Default green value of the background
local bgB = 171	-- Default blue value of the background

-- Space stage variables
local spaceBoundary = 2		-- Level of difficulty which you enter space
local spaceTransition = .25	-- The rate at which the game transitions to space after the spaceBoundary is reached
local bgClear = false	-- Used to test if the earth stage background is clear before moving the space background on screen

-- Audio
local earthMusic = audio.loadStream("sound/Battle in the winter.mp3")	-- Music for the earth stage
local spaceMusic = audio.loadStream("sound/BMGS_0.mp3")		-- Music for the space stage
local acornSFX = audio.loadSound("sound/Replenish.mp3")		-- Sound effect when a powerup is acquired
local hitSFX = audio.loadSound("sound/atari_boom3.mp3")		-- Sound effect when the player hits an obstacle

-- Constants
local contentHeight = display.contentHeight	-- Local variables were said to improve performance
local contentWidth = display.contentWidth	-- I don't know how much of a difference this actually makes
local highScore = loadScore()		-- The player's current highscore
local maxDifficulty = 3			-- The games max difficulty

-- Collision Objects
local player			-- The players squirrel object
local obstacles = {}	-- Holds obstacles

-- Background object groups
local earthBGGroup, spaceBGGroup, treesBGGroup, starsBGGroup

-- Background images/display objects
local trees = {}	-- Array containing the trees that the squirrel is climbing (there are 6 of these)
local earthBGImgs = {}	-- Array containing the clouds and balloon that are seen before the space stage is reached
local spaceBGImgs = {}	-- Array containing the asteroids and ufo that are seen after reaching space
local stars = {}	-- Array containing the stars in the background of the space stage
local treeBase		-- The grassy ground that appears at the start of each game
local invulnAura	-- The white and gold aura that surrounds the squirrel when a red mushroom is picked up
local damageMask	-- The white border around the screen when the player takes damage

-- Game difficulty and speed variables
local difficulty = 1	-- The current difficulty of the game ranges from [1,3] 
						-- It takes 15 seconds to go from difficulty 1 ->2 and 30 seconds to go from 2 -> 3
local yTranslateModifier = 5	-- Used to assist in calculated how far to move the objects each frame
local yTranslate	-- How far we move the objects each frame (difficulty * yTranslateModifier * gameSpeedModifier)
					-- The background objects use half of this value to create a parallax effect
local gameSpeedModifier = 1		-- Used when "slow" and "speed" mushrooms are hit to adjust the speed of the game

-- Health Sprite sheet variables
local healthSheetOptions = {
	width = 192,
	height = 64,
	numFrames = 4
}
local healthSheet = graphics.newImageSheet("imgs/acornSprites.png", healthSheetOptions)
local healthSheetSequenceData = {
	{name = "health3", start=1, count=1, time=0, loopCount=1},
	{name = "health2", start=2, count=1, time=0, loopCount=1},
	{name = "health1", start=3, count=1, time=0, loopCount=1},
	{name = "health0", start=4, count=1, time=0, loopCount=1}
}
local healthSprite = display.newSprite( healthSheet, healthSheetSequenceData )
	healthSprite.x = contentWidth * .1
	healthSprite.y = contentWidth * .075
	healthSprite.xScale = contentWidth * .001
	healthSprite.yScale = contentWidth * .001
	healthSprite:setSequence( "health" .. 3 )
	healthSprite:play()
local healthBackground
	healthBackground = display.newRoundedRect(healthSprite.x, contentWidth * .09, contentWidth * .19, contentWidth * .115, contentWidth * .1 *.5)
livesText = display.newText( "Lives", healthBackground.x, contentWidth * .12, "fonts/Rufscript010", contentWidth * .05)
	livesText:setFillColor(0,0,0)


-- Earth Background Modifiers
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

-- Space Background Modifiers
local astroidRotation1 = math.random(0,1) - math.random()
local astroidRotation2 = math.random(0,1) - math.random()
local spaceBGSpeed = {}
for i=1, 3 do
	spaceBGSpeed[i] = math.random(0,1) - math.random()
end

-- End of Variable Declarations
---------------------------------------------------------------------------


--------------------------------------------
--moveRight()
-- Moves the players squirrel to the neighboring branch on the right
-- The player can only move if the squirrel is on a branch
--------------------------------------------
local function moveRight() 
	if (player.model.x == contentWidth * .25) then	-- Player is on the left most tree
		-- Rotate the player and the underlying invulnAura to the right
		transition.to(player.model, {rotation=30, time=100/difficulty})
		transition.to(invulnAura, {rotation=30, time=100/difficulty})
		-- Rotate the player and invulnAura back after the squirrel reaches the tree
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
		timer.performWithDelay (200/difficulty, function() transition.to(invulnAura, {rotation=0, time=100/difficulty}) end)
		-- Move the player and the underlying invulnAura right
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.5})
		transition.to(invulnAura, {time=200/difficulty, x=contentWidth*0.5})
	elseif (player.model.x == contentWidth * .5) then	-- Player is on the center tree
		-- Rotate the player and the underlying invulnAura to the right
		transition.to(player.model, {rotation=30, time=100/difficulty})
		transition.to(invulnAura, {rotation=30, time=100/difficulty})
		-- Rotate the player and invulnAura back after the squirrel reaches the tree
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
		timer.performWithDelay (200/difficulty, function() transition.to(invulnAura, {rotation=0, time=100/difficulty}) end)
		-- Move the player and the underlying invulnAura right
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.75})
		transition.to(invulnAura, {time=200/difficulty, x=contentWidth*0.75})
	end
end

--------------------------------------------
--moveLeft()
-- Moves the players squirrel to the neighboring branch on the left
-- The player can only move if the squirrel is on a branch
--------------------------------------------
local function moveLeft() 
	if (player.model.x == contentWidth * .75) then	-- Player is on the right most tree
		-- Rotate the player and the underlying invulnAura to the left
		transition.to(player.model, {rotation=-30, time=100/difficulty})
		transition.to(invulnAura, {rotation=-30, time=100/difficulty})
		-- Rotate the player and invulnAura back after the squirrel reaches the tree
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
		timer.performWithDelay (200/difficulty, function() transition.to(invulnAura, {rotation=0, time=100/difficulty}) end)
		-- Move the player and the underlying invulnAura left
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.5})
		transition.to(invulnAura, {time=200/difficulty, x=contentWidth*0.5})
	elseif (player.model.x == contentWidth * .5) then	-- Player is on the center tree
		-- Rotate the player and the underlying invulnAura to the left
		transition.to(player.model, {rotation=-30, time=100/difficulty})
		transition.to(invulnAura, {rotation=-30, time=100/difficulty})
		-- Rotate the player and invulnAura back after the squirrel reaches the tree
		timer.performWithDelay (200/difficulty, function() transition.to(player.model, {rotation=0, time=100/difficulty}) end)
		timer.performWithDelay (200/difficulty, function() transition.to(invulnAura, {rotation=0, time=100/difficulty}) end)
		-- Move the player and the underlying invulnAura left
		transition.to(player.model, {time=200/difficulty, x=contentWidth*0.25})
		transition.to(invulnAura, {time=200/difficulty, x=contentWidth*0.25})
	end
end

--------------------------------------------
--move(event)
-- Function handles for both movement types and both directions
--------------------------------------------
local function move(event)
	if (swipeMovement) then		-- If the player was swipe to move enabled
		if(event.phase == "began") then
			beginX = event.x 				-- Record the start of the swipe
		elseif(event.phase == "ended") then 
			if(beginX > event.x) then 		-- The swipe ended left of where it started
				moveLeft()
			elseif (beginX < event.x) then	-- The swipe ended right of where it started
				moveRight()
			end
		end
	else		-- Tap to move is enabled
		if(event.phase == "began")then
			if(event.x > contentWidth*0.5)then	-- Player tapped the right side of the screen
				moveRight()
			elseif(event.x < contentWidth*0.5)then	-- Player tapped the left side of the screen
				moveLeft()
			end	
		end	
	end
end

--------------------------------------------
--pauseGame()
-- Set the pause flag to handle the game timers
-- Game will not pause if the player is dead
--------------------------------------------
local function pauseGame ()
	if player.health > 0 then
		paused = true;
		composer.hideOverlay("game")
		composer.gotoScene("pause", {effect="fromRight", time=1000})
	end
end

--------------------------------------------
--hitObstacle(self, event)
--Function handles player collision
--When the player collides with an "obstacle" they should lose health 
--when the player collides with an "acorn" they gain health or score depending on their current health
--when the player collides with a "slow (gold)" mushroom, the game speed is reduced for a short duration
--when the player collides with a "speed (purple)" mushroom, the game speed is increased for a short duration
--When the player collides with a "red" mushroom, the player becomes invulnerable
--------------------------------------------	
local function hitObstacle(self, event)
	if event.phase == "began" then
		if (event.other.type == "obstacle") then   --If obstacle, do damage				
				audio.stop({channel = 4})	-- Stop any old "damage" sound effects
				audio.play( hitSFX, { channel=4, loops=0 } )	-- Play a new "damage" sound effect
				audio.setVolume( effectsVolume/100, {channel=4})	-- Set the sound effects volume
				if (not player.invincible) then
					if vibrate then 
						system.vibrate()	-- Vibrate to signify damage
					end
					playerHit = true		-- Set to use the damageMask
					timer.performWithDelay (200, function() playerHit = false end)	-- Reset the damage mask after .2 seconds
					player:damage(1)	-- Player takes damage
				else	-- Invincibility is on
					event.other.alpha = 0	-- "destroy" the collided object 
				end
		elseif (event.other.type == "acorn") then  --If Acorn
			audio.stop({channel = 3})	-- Stop any old "powerup" sound effects
			audio.play( acornSFX, { channel=3, loops=0 } )	-- Play a new "powerup" sound effect
			audio.setVolume( effectsVolume/100, {channel=3})	-- Set the sound effects volume
			if player.health == 3 then
				bonusScoreText:setFillColor(1,1,1)
				bonusScoreText.text ="+" .. math.floor(difficulty * 5)	-- Display some status text
				bonusScoreText.alpha = 1
				playerScore = playerScore + math.floor(difficulty * 5)	-- Increment player score
			else
				bonusScoreText:setFillColor(1,1,1)
				bonusScoreText.text ="1 up!"		-- Display some status text
				bonusScoreText.alpha = 1
				player:heal(1)
			end
			event.other.alpha = 0	-- "destroy" the collided object 
		elseif (event.other.type == "slow") then
			bonusScoreText:setFillColor(1,1,0)
			bonusScoreText.text ="slow..."		-- Display some status text
			bonusScoreText.alpha = 1
			
			audio.stop({channel = 3})	-- Stop any old "powerup" sound effects
			audio.play( acornSFX, { channel=3, loops=0 } )	-- Play a new "powerup" sound effect
			audio.setVolume( effectsVolume/100, {channel=3})	-- Set the sound effects volume
			event.other.alpha = 0	-- "destroy" the collided object 
			-- Change the gameSpeedModifier to slow down the game
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
			bonusScoreText:setFillColor(.7,0,.7)
			bonusScoreText.text ="SPEED!"		-- dDisplay some status text
			bonusScoreText.alpha = 1
			audio.stop({channel = 3})	-- Stop any old "powerup" sound effects
			audio.play( acornSFX, { channel=3, loops=0 } )	-- Play a new "powerup" sound effect
			audio.setVolume( effectsVolume/100, {channel=3})	-- Set the sound effects volume
			event.other.alpha = 0	-- "destroy" the collided object 
			-- Change the gameSpeedModifier to speed up the game
			gameSpeedModifier = gameSpeedModifier +.05
			timer.performWithDelay (100, function() gameSpeedModifier =  gameSpeedModifier +.05 end)
			timer.performWithDelay (200, function() gameSpeedModifier =  gameSpeedModifier +.05 end)
			timer.performWithDelay (300, function() gameSpeedModifier =  gameSpeedModifier +.05 end)
			timer.performWithDelay (400, function() gameSpeedModifier =  gameSpeedModifier +.05 end)
			timer.performWithDelay (1600, function() gameSpeedModifier =  gameSpeedModifier -.05 end)
			timer.performWithDelay (1700, function() gameSpeedModifier =  gameSpeedModifier -.05 end)
			timer.performWithDelay (1800, function() gameSpeedModifier =  gameSpeedModifier -.05 end)
			timer.performWithDelay (1900, function() gameSpeedModifier =  gameSpeedModifier -.05 end)
			timer.performWithDelay (2000, function() gameSpeedModifier = gameSpeedModifier -.05 end)
		elseif (event.other.type == "red") then 
			bonusScoreText:setFillColor(1,0,0)
			bonusScoreText.text ="INVINCIBLE!"		-- Display some status text
			bonusScoreText.alpha = 1
			audio.stop({channel = 3})	-- Stop any old "powerup" sound effects
			audio.play( acornSFX, { channel=3, loops=0 } )	-- Play a new "powerup" sound effect
			audio.setVolume( effectsVolume/100, {channel=3})	-- Set the sound effects volume
			event.other.alpha = 0		-- "destroy" the collided object 
			player.invincible = true	-- make the player invincible
			timer.performWithDelay(2000, function() player.invincible = false end)	-- After 2 seconds the player is no longer invincible
			-- Make the aura visible then invisible after some time
			transition.to(invulnAura, {time = 100, alpha=1})
			timer.performWithDelay(1500, function() transition.to(invulnAura, {time = 500, alpha=0, transition=easing.outCirc}) end)
		end
		healthSprite:setSequence("health" .. player.health)
		healthSprite:play() --Play a sprite sequence to reflect how much health is left

		if player.health == 0 then 
			saveScore(playerScore)	-- Save the player's score
			addToDistance(distance)	-- Increment the player's distance
			for x=1,  #obstacles do
				obstacles[x]:delete()	-- Remove all obstacles
			end
			obstacles = {}
			-- Wait 2 seconds and go to the loseScreen
			timer.performWithDelay (2000, function() composer.gotoScene( "loseScreen", {effect="fromRight", time=1000}) end)
			
			-- While waiting, send the squirrel spinning off the tree
			physics.setGravity(0,20)
			local xDir = (contentWidth*.5 - player.model.x)
			if xDir > 0 then
				xDir = 1
			else
				xDir = -1
			end
			player.model:applyForce( 5* xDir, -20, player.model.x, player.model.y)
			transition.to(player.model, {rotation=720*xDir, time=2000})		-- Spin the squirrel!
		end
	end
end


-- "scene:create()"
function scene:create( event )
	paused = true	-- keep the game paused until the transition ends

	-- Initialize Timers
	timePassedBetweenEvents = 0
	timePassed = 0
	stageTimer = 0
	difficultyTimer = 0
	
	-- Initialize Player score and distance
	playerScore = 0
	distance = 0
	
	loadSettings()
	audio.setVolume( musicVolume/100, {channel=2})
	audio.play( earthMusic, { channel=2, loops=-1, fadein=5000 } )
	
	local sceneGroup = self.view
	
	--Pause button
   	pauseBtn = widget.newButton{
		label="",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/pauseBtn.png",
		overFile="imgs/pauseBtn.png",
		width=contentWidth * .085, height=contentWidth * .085,
		onRelease = pauseGame,	-- sends the player to pause.lua
		x = contentWidth,
		y = 0
	}
		pauseBtn.anchorX = 1
		pauseBtn.anchorY = 0
	
-- Create tutorial (based on movement type)
	tutorialGroup = display.newGroup()
	tutorialBackground = display.newImageRect("imgs/tutorialBackground.png", contentWidth *.75, contentWidth * .15  )
	tutorialBackground.x = contentWidth *.5
	tutorialBackground.y = contentHeight *.35
	tutorialGroup:insert(tutorialBackground)
	
	if (swipeMovement) then
		tutorialText =  display.newText( "Swipe       to jump Left\nSwipe       to jump Right", contentWidth * .5, contentHeight*.35, "fonts/Rufscript010", contentWidth * .05)
		
		tutorialArrowR = display.newImageRect("imgs/arrow.png", contentWidth*.08, contentWidth*.04)
		tutorialArrowR.x = contentWidth * .42
		tutorialArrowR.y = contentHeight*.335
		tutorialGroup:insert(tutorialArrowR)
		
		tutorialArrowL = display.newImageRect("imgs/arrow.png", contentWidth*.08, contentWidth*.04)
		tutorialArrowL.x = contentWidth * .42
		tutorialArrowL.y = contentHeight*.365
		tutorialArrowL:rotate(180)		-- Rotate the arrow so it points the opposite direction
		tutorialGroup:insert(tutorialArrowL)
	else
		tutorialText =  display.newText( "   Tap Here   |   Tap Here\n to Jump Left  |  to Jump Right", contentWidth * .5, contentHeight*.35, "fonts/Rufscript010", contentWidth * .05)
	end
	tutorialGroup:insert(tutorialText)
-- End tutorial

	--Physics and physics vars
   	physics.start()
   	physics.setGravity(0,0)
	
	--Collision detection
	player = Player(contentWidth*.5, contentHeight*.75)
	player.model.collision = hitObstacle
	player.model:addEventListener("collision", player.model)
	physics.addBody(player.model, "dynamic",{isSensor=true})
	
	-- Create invincibility aura
	invulnAura = display.newImageRect("imgs/invulnAura.png", contentWidth * .2, contentWidth * .35)
	invulnAura.x = player.model.x
	invulnAura.y = player.model.y
	invulnAura.alpha = 0
	
	-- scorelabel only displays the "Score" text at the top of game
	scoreLabel = display.newText( "Score", contentWidth * .5, contentHeight*.05, "fonts/Rufscript010", contentHeight * .045)
	scoreText = display.newText( tostring(playerScore), contentWidth * .5, contentHeight*.1, "fonts/Rufscript010", contentHeight * .065)
	bonusScoreText = display.newText( 0, contentWidth * .5, contentHeight*.2, "fonts/Rufscript010", contentHeight * .065)
	bonusScoreText.alpha = 0
	
	-- set the default Background to a light blue
	display.setDefault( "background", bgR/255, bgG/255, bgB/255 )

	-- Create the ground image
	treeBase = display.newImageRect( "imgs/treeBase.png", display.contentWidth, display.contentHeight)
	treeBase.x = display.contentWidth*.5
	treeBase.y = display.contentHeight*.5
	
	-- Create the stars and insert them into the scene group
	starsBGGroup = display.newGroup()
	for i=1, 100 do
		stars[i] = display.newRect(math.random(1, contentWidth), 0 - math.random(1, contentHeight), 4, 4)
		stars[i].alpha = 0
		starsBGGroup:insert(stars[i])
	end
	
	-- Create the earth background objects and insert them into the earthBGGroup
	earthBGGroup = display.newGroup()
	for i = 1, 4, 1 do
		local sizeMod = .75 + math.random()*.5
		if(i<=3)then
			earthBGImgs[i] = display.newImageRect("imgs/earthBGImg" .. i .. ".png", contentWidth*.6*sizeMod, contentWidth*.3*sizeMod)
			earthBGImgs[i].x = math.random(1, contentWidth)
			earthBGImgs[i].y = 0 - math.random(1, contentHeight)
		else
			earthBGImgs[i] = display.newImageRect("imgs/earthBGImg" .. math.random(4, 7) .. ".png", contentWidth*.3*sizeMod, contentWidth*.3*sizeMod)
			earthBGImgs[i].x = math.random(1, contentWidth)
			earthBGImgs[i].y = 0 - math.random(1, contentHeight)
		end
		earthBGGroup:insert(earthBGImgs[i])
	end
	
	-- Create the space background objects and insert them into the spaceBGGroup
	spaceBGGroup = display.newGroup()
	for i = 1, 3, 1 do
		local sizeMod = .75 + math.random()*.5 
		spaceBGImgs[i] = display.newImageRect("imgs/spaceBGImg" .. i .. ".png", contentWidth*.3*sizeMod, contentWidth*.3*sizeMod)
		spaceBGImgs[i].x = math.random(1, contentWidth)
		spaceBGImgs[i].y = 0 - math.random(contentHeight*.1, contentHeight)
		spaceBGGroup:insert(spaceBGImgs[i])
	end
	
	-- Create the trees and insert them into the treeBGGroup
	-- the trees are created staggered for performance reasons 
	-- trees also are stacked so that only one tree has to reset to the top at a time
	treesBGGroup = display.newGroup()
	for i = 1, 6, 1 do
		trees[i] = display.newImageRect("imgs/tree" .. i%3+1 .. ".png", contentWidth*.1, contentHeight*2 )
		trees[i].x = contentWidth *.25 * (i%3 + 1)
		if(i<=3)then
			trees[i].y = contentHeight+(-i * contentHeight * .33)
		else
			trees[i].y = trees[i-3].y - (contentHeight * .95) * 2
		end
		treesBGGroup:insert(trees[i])
	end

	--create the damage mask
	damageMask = display.newImageRect("imgs/damageMask.png", contentWidth, contentHeight)
	damageMask.anchorX = 0
	damageMask.anchorY = 0
	damageMask.alpha = 0
	
	--insert everything into the scene group
	sceneGroup:insert(treeBase)
	sceneGroup:insert(starsBGGroup)
	sceneGroup:insert(earthBGGroup)
	sceneGroup:insert(spaceBGGroup)
	sceneGroup:insert(treesBGGroup)
	sceneGroup:insert(pauseBtn)
	sceneGroup:insert(damageMask)
	sceneGroup:insert(invulnAura)
	sceneGroup:insert(player.model)
	sceneGroup:insert(scoreLabel)
	sceneGroup:insert(scoreText)
	sceneGroup:insert(bonusScoreText)
	sceneGroup:insert(healthBackground)
	sceneGroup:insert(healthSprite)
	sceneGroup:insert(livesText)
	sceneGroup:insert(tutorialGroup)
end


---------------------------------------------------------------------------------


function main(event)
	if  ( paused ) then --Check if the game is paused
		timePassed = timePassed + (event.time - timePassedBetweenEvents)	-- adjusts variables to keep variable relevant when the game resumes
		stageTimer = stageTimer + (event.time - timePassedBetweenEvents)	-- or else the event.time continues to increase and it can force the game to improperly scale
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

		--update difficulty (when difficulty reaches 2, the game scales at half speed)
		if (event.time - difficultyTimer > math.floor(difficulty) * 1500 and difficulty < maxDifficulty) then
			difficultyTimer = event.time
			difficulty = difficulty +.1
		end
		yTranslate = yTranslateModifier * difficulty * gameSpeedModifier	-- recalculate the yTranslate for moving objects
		
		-- display tutorial for 1.5 seconds and then move it away with fade
		if (difficulty > 1 and difficulty < 1.5) then
			tutorialGroup:translate(0, yTranslate)
			tutorialGroup.alpha = tutorialGroup.alpha - .015
		end
			
		-- Display damage mask when player is hit
		if (playerHit and damageMask.alpha < 1) then
			damageMask.alpha = damageMask.alpha + .2	-- Scale mask into view
		elseif (damageMask.alpha > (3-player.health) * .3) then	-- Scale damage mask away (keeps some mask if health isn't full)
			damageMask.alpha = damageMask.alpha - .05	-- Scale mask out of view
		end
		
		-- Background
		if(difficulty < spaceBoundary)then	-- Spawn normal earth background images
			for i=1, #earthBGImgs do 
				if(earthBGImgs[i].y > contentHeight+earthBGImgs[i].height *.5)then
					if (i == 4) then	-- If the earth background image is a balloon
						local sizeMod = (.75 + math.random()*.5)	-- Give it a random size modifier
						earthBGImgs[i]:removeSelf()		-- Remove the old display object
						earthBGImgs[i] = nil
						-- Create a new display object with a random balloon image, with a width and height based on the size modifier
						earthBGImgs[i] = display.newImageRect("imgs/earthBGImg" .. math.random(4, 7) .. ".png", contentWidth*.3 * sizeMod, contentWidth*.3*sizeMod)
						earthBGGroup:insert(earthBGImgs[i])	-- Insert the new balloon back into the display group
					else	-- All the clouds
						earthBGImgs[i].width =  contentWidth*.6*(.9 + math.random()*.1)		-- Random width
						earthBGImgs[i].height =  contentWidth*.3*(.9 + math.random()*.1)	-- Random height
					end
					if (earthBackgroundMovement > 0) then	-- If the earth background images are moving to the right
						earthBGImgs[i].x = math.random(1, contentWidth*.5)	-- Place them of the left side of the screen
					else	-- Earth background images are moving to the left
						earthBGImgs[i].x = math.random(contentWidth*.5, contentWidth)	-- Place them of the right side of the screen
					end
					earthBGImgs[i].y = 0 - math.random(1, contentHeight)	-- Place them above the top of the screen
					earthBGSpeed[i] = math.random()	-- Give it a new random x velocity
				else
					earthBGImgs[i]:translate(earthBackgroundMovement * earthBGSpeed[i], yTranslate*.5)	-- Move the object if it is not below the screen
				end
			end
		else 
			if(bgClear == false)then -- Clear old earth images
				local count = 0
				for i=1, #earthBGImgs do
					if(earthBGImgs[i].y < contentHeight+earthBGImgs[i].height *.5)then
						earthBGImgs[i]:translate(earthBackgroundMovement * earthBGSpeed[i], yTranslate*.5)  -- Move earth objects that are not below the screen
					else -- When we know all earth images are off screen set bgClear to true
						count = count + 1	-- Increment for each earth image that is moved off screen
						if(count == #earthBGImgs)then
							bgClear = true	-- Earth background objects are all off screen, time to start space
							audio.stop(2)	-- Stop the earth music
							audio.play( spaceMusic, { channel=2, loops=-1, fadein=5000 } )	-- Play the space music
						end
					end
				end
			else  -- Old earth images are cleared, begin to utilize space images	
				for i=1, #spaceBGImgs do 
					if(spaceBGImgs[i].y > contentHeight+spaceBGImgs[i].height *.5)then	-- Space images are below the screen
						spaceBGImgs[i].x = math.random(1, contentWidth)			-- Give space background image random x coordinate
						spaceBGImgs[i].y = 0 - math.random(1, contentHeight)	-- Move space background image back above the top of the screen
						if (i == 1) then
							astroidRotation1 = math.random(0,1) - math.random()			-- Randomize asteroid rotation
							spaceBGImgs[i].width = contentWidth*.3*(.75 + math.random()*.5)	-- Generate a new random width for the asteroid
							spaceBGImgs[i].height = contentWidth*.3*(.75 + math.random()*.5)-- Generate a new random height for the asteroid
						elseif (i == 2) then
							astroidRotation2 = math.random(0,1) - math.random()			-- Randomize asteroid rotation
							spaceBGImgs[i].width = contentWidth*.3*(.75 + math.random()*.5)	-- Generate a new random width for the asteroid
							spaceBGImgs[i].height = contentWidth*.3*(.75 + math.random()*.5)-- Generate a new random height for the asteroid
						else
							local sizeMod = (.75 + math.random()*.5)	-- Randomize size of ufo
							spaceBGImgs[i].width = contentWidth * .3 * sizeMod	-- Set new width for the ufo
							spaceBGImgs[i].height = contentWidth * .3 * sizeMod	-- Set new height for the ufo
						end
						spaceBGSpeed[i] = math.random(0,1) - math.random()	--Set a new x velocity for the off screen image
					else
						spaceBGImgs[i]:translate(spaceBGSpeed[i], yTranslate*.5)	-- Move space images that are still on screen
					end	
				end
				spaceBGImgs[1]:rotate(astroidRotation1)	-- Rotate asteroid1
				spaceBGImgs[2]:rotate(astroidRotation2)	-- Rotate asteroid2
				for i=1, #stars do
					if(stars[i].y > contentHeight)then	-- When a star is off the bottom of the screen
						stars[i].alpha = stars[i].alpha + .2 * gameSpeedModifier	-- Increment the stars alpha till it reaches 1 (makes for a smooth star transition into space)
						stars[i].x = math.random(1, contentWidth)		-- Give the star a new x coordinate
						stars[i].y = 0 - math.random(1, contentHeight)	-- Move the star back above the top of the screen
					else
						stars[i]:translate(0, yTranslate*.4)	-- Move the stars that are still on screen down
					end
				end
			end
		end

		-- Transition the background to black to represent space
		if(difficulty > spaceBoundary and (bgG > 1 or bgB > 1))then
			bgG = bgG - (spaceTransition * gameSpeedModifier)	-- Decrement the green of the background until black
			bgB = bgB - (spaceTransition  * gameSpeedModifier)	-- Decrement the blue of the background until black
			display.setDefault( "background", bgR/255, bgG/255, bgB/255 )
		end

		-- Reset tree location if trees travel off-screen
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
		
		-- Move the trees
		for i = 1, #trees do
			trees[i]:translate(0, yTranslate)
		end

		-- Move the ground that is displayed at the start of the game
		if(treeBase.x > -contentHeight)then
			treeBase:translate(0, yTranslate)
		end

		-- Obstacle Handling
		for x=#obstacles, 1, -1 do
			obstacles[x].model:translate(0,yTranslate)	-- Move all obstacles
			if (obstacles[x].model.y > contentHeight + obstacles[x].model.height) then
				-- kill obstacle that is now off the screen
				physics.removeBody(obstacles[x].model)
				obstacles[x]:delete()
				table.remove(obstacles, x)
			end
		end
	end
	timePassedBetweenEvents = event.time	-- used to maintain the previous time to calculate the time passed between events
end

---------------------------------------------------------------------------------

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      	audio.resume(2)		-- resume the audio when game.lua is returned to
		-- redisplay all the display objects in game
		treeBase.isVisible = true
	  	tutorialGroup.isVisible = true
	  	scoreLabel.isVisible = true
		scoreText.isVisible = true
		bonusScoreText.isVisible = true
		pauseBtn.isVisible = true
		damageMask.isVisible = true
		player.model.isVisible = true
		healthBackground.isVisible = true
		healthSprite.isVisible = true
		livesText.isVisible = true
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
		invulnAura.isVisible = true
   elseif ( phase == "did" ) then
		paused = false	-- declase the game unpause to let the timers continue
		Runtime:addEventListener( "touch", move)	-- re-create the event listeners that were removed on exit
		Runtime:addEventListener( "enterFrame", main)
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
   		treeBase.isVisible = false
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
		healthBackground.isVisible = false
		healthSprite.isVisible = false
		livesText.isVisible = false
		invulnAura.isVisible = false
		paused = true	-- prevents the main game loop from moving obstacles and such
		Runtime:removeEventListener( "touch", move )	-- remove event listeners to prevent actions on other scenes from changing game
		Runtime:removeEventListener( "enterFrame", main)
   elseif ( phase == "did" ) then
   end
end

-- Remove all the scene's display objects
function scene:destroy( event )
	local sceneGroup = self.view
	treeBase:removeSelf()
	treeBase = nil
	-- Remove the trees, ya know, the ones that the squirrel climbs on
	for i = 1, #trees do
		trees[i]:removeSelf()
		trees[i] = nil
	end
	-- Remove the earth stage background images (clouds and balloons)
	for i = 1, #earthBGImgs do
		earthBGImgs[i]:removeSelf()
		earthBGImgs[i] = nil
	end
	earthBGImgs = {}
	-- Remove the space stage background images (asteroids and ufo)
	for i = 1, #spaceBGImgs do
		spaceBGImgs[i]:removeSelf()
		spaceBGImgs[i] = nil
	end
	spaceBGImgs = {}
	-- Remove the space background stars
	for i = 1, #stars do
		stars[i]:removeSelf()
		stars[i] = nil
	end
	stars = {}
	-- Remove the obstacles that the squirrel collides with
	for x=1,  #obstacles do
		obstacles[x]:delete()
	end	
	obstacles = {}
	-- Remove health images
	healthBackground:removeSelf()
	healthBackground = nil
	healthSprite:removeSelf()
	healthSprite = nil
	livesText:removeSelf()
	livesText = nil
	-- Remove damage mask
	damageMask:removeSelf()
	damageMask = nil
	-- Remove the entire tutorial group
	tutorialGroup:removeSelf()
	tutorialGroup = nil
	-- Remove score stuff
	scoreLabel:removeSelf()
	scoreLabel = nil
	scoreText:removeSelf()
	scoreText = nil
	bonusScoreText:removeSelf()
	bonusScoreText = nil
	-- remove the only button on the screen
	pauseBtn:removeSelf()
	pauseBtn = nil
	-- remove the player
	player:delete()
	-- remove the squirrel's invuln aura
	invulnAura:removeSelf()
	invulnAura = nil
	-- Remove event listeners
	Runtime:removeEventListener( "enterFrame", main )
	Runtime:removeEventListener( "touch", move )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "enterFrame", main )
Runtime:addEventListener( "touch", move)

---------------------------------------------------------------------------------

return scene
