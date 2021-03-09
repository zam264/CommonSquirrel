local composer = require( "composer" )
local score = require( "score" )
local game = require( "game" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
require "achievements.achievementTable"
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local replayBtn, quitBtn
local titleText, scoreText, highScore, distanceText
local achievementText, achievementIcon, achievementTitle, achivementSubtext, achievementBorder

--When the replay button is clicked, restart the game
local function onReplayBtn()
	audio.stop(2)
	composer.removeScene( "game" )
	composer.removeScene( "loseScreen" )
	sceneInTransition = true
	composer.gotoScene( "game", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
--When the quit button is clicked, return to the menu screen 
local function onQuitBtn()
	audio.stop(2)
	composer.removeScene( "game" )
	composer.removeScene( "loseScreen" )
	sceneInTransition = true
	composer.gotoScene( "menu", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

--Creates the lose screen
function scene:create( event )
    sceneGroup = self.view

	--[[
		Start: Setup the general information section of the lose screen.
	]]

	local titleTextOptions = {
		text 		= "You Lose", 
		x 			= display.contentWidth  * .5, 
		y 			= display.contentHeight * .1, 
		font 		= "fonts/Rufscript010", 
		fontSize 	= display.contentHeight * .1
	}

	local scoreTextOptions = {
		text 		= "", 
		x 			= display.contentWidth  * .025, 
		y 			= titleTextOptions["y"] + (display.contentHeight * .05), 
		font 		= "fonts/Rufscript010", 
		fontSize 	= display.contentHeight * .05
	}

	local distanceTextOptions = {
		text 		= "", 
		x 			= display.contentWidth  * .025, 
		y 			= scoreTextOptions["y"] + (display.contentHeight * .05), 
		font 		= "fonts/Rufscript010", 
		fontSize 	= display.contentHeight * .05
	}

    --Display text telling the player that they lost
	titleText = display.newText(titleTextOptions)
	sceneGroup:insert(titleText)
	
	--The score stored on the players device is lower than their current score -> so a new score has been achieved
	if (loadScore() <= playerScore) then	--new highscore has been set -> Inform the player
		scoreTextOptions["text"] = "New HighScore: " .. playerScore
		composer.removeScene( "unlockables" )
	else
		scoreTextOptions["text"] = "Score: " .. playerScore
	end
	scoreText = display.newText(scoreTextOptions)
	scoreText.anchorX = 0
	scoreText.anchorY = 0
	sceneGroup:insert(scoreText)

	--Display the distance traveled during gameplay -> Distance accumulates to unlock achievements
	distanceTextOptions["text"] = "Distance: " .. distance .. " ft"
	distanceText = display.newText(distanceTextOptions)
	distanceText.anchorX = 0
	distanceText.anchorY = 0
	sceneGroup:insert(distanceText)
	
	--[[
		End: Setup the general information section of the lose screen.
	]]

	--[[
		Start: Setup the achievement section of the lose screen.
	]]
	
	-- Determine which achievemnt the player is working towards
	-- achievementText = display.newText( "Achievement Unlocked!" , display.contentWidth*.025, display.contentHeight *.41, "fonts/Rufscript010",  display.contentHeight * .05)

	local achievementDistance 		= 1
	local achievementName 			= 2
	local achievementDescription 	= 3
	local achievementImage 			= 4

	local achievementTitleTextOptions = {
		text 		= "", 
		x 			= display.contentWidth  * .025, 
		y 			= distanceTextOptions["y"] + (display.contentHeight * .05), 
		font 		= "fonts/Rufscript010", 
		fontSize 	= display.contentHeight * .05
	}
	
	-- Initialize our nextAchievement at 1 - we will increment this until we find our true next achievement
	local nextAchievement = 1
	
	-- Load distance so that we can determine what our next achievement is
	local totalDist = loadDistance()
	
	-- Loop until we find our true next achievement, the achievement we haven't yet achieved
	while totalDist > achievementTable[nextAchievement][achievementDistance] do
		nextAchievement = nextAchievement + 1
	end

	-- We get our current (most recent) achievement by going back one
	local currentAchievement = nextAchievement - 1
	
	-- Check if we just unlocked the current achievement
	if currentAchievement ~= 0 and (totalDist - distance) < achievementTable[currentAchievement][achievementDistance] then
		composer.removeScene( "achievements" )
		
		achievementTitleTextOptions["text"] = "Achievement Unlocked!"
		achievementText = display.newText(achievementTitleTextOptions)
		achievementText.anchorX = 0
		achievementText.anchorY = 0
		sceneGroup:insert(achievementText)
		
		achievementTitle = display.newText( achievementTable[currentAchievement][achievementName] .. "\n" .. achievementTable[currentAchievement][achievementDistance] .. "ft".."\n"..achievementTable[currentAchievement][achievementDescription] , display.contentWidth*.35, display.contentHeight *.48, "fonts/Rufscript010",  display.contentHeight * .035)
		achievementTitle.anchorX = 0
		achievementTitle.anchorY = 0
		sceneGroup:insert(achievementTitle)
		
		achievementIcon = display.newImageRect( "achievements/"..achievementTable[currentAchievement][achievementImage], display.contentHeight*.175, display.contentHeight*.15 )
		achievementIcon.anchorX = 0
		achievementIcon.anchorY = 0
		achievementIcon.x = 0
		achievementIcon.y = display.contentHeight*.47
		sceneGroup:insert( achievementIcon )
		
		achievementBorder = graphics.newMask("imgs/achievementMask.png", display.contentHeight*.175, display.contentHeight*.15)
		achievementIcon:setMask(achievementBorder)
		achievementIcon.maskScaleX = display.contentHeight*.175 /130
		achievementIcon.maskScaleY = display.contentHeight*.175 /130
	else	
		achievementTitleTextOptions["text"] = "Next Achievement At"
		achievementText = display.newText(achievementTitleTextOptions)
		achievementText.anchorX = 0
		achievementText.anchorY = 0
		sceneGroup:insert(achievementText)
		
		achievementTitle = display.newText( achievementTable[nextAchievement][achievementDistance].."ft" , display.contentWidth*.35, display.contentHeight *.48, "fonts/Rufscript010",  display.contentHeight * .035)
		achievementTitle.anchorX = 0
		achievementTitle.anchorY = 0
		sceneGroup:insert(achievementTitle)
		
		achievementIcon = display.newImageRect( "imgs/locked.png", display.contentHeight*.175, display.contentHeight*.15 )
		achievementIcon.anchorX = 0
		achievementIcon.anchorY = 0
		achievementIcon.x = 0
		achievementIcon.y = display.contentHeight*.47
		sceneGroup:insert( achievementIcon )
		
		achievementBorder = graphics.newMask("imgs/achievementMask.png", 124, 124)
		achievementIcon:setMask(achievementBorder)
		achievementIcon.maskScaleX = display.contentHeight*.175 /130
		achievementIcon.maskScaleY = display.contentHeight*.175 /130
		
	end
	
	
	replayBtn = widget.newButton{
		label 		= "Play Again",
		font 		= "fonts/Rufscript010",
		fontSize 	= display.contentWidth * .05,
		labelColor 	= { default={255}, over={128} },
		defaultFile = "imgs/button.png",
		overFile 	= "imgs/button-over.png",
		width 		= display.contentWidth * .50, 
		height 		= display.contentHeight * .1,
		onRelease 	= onReplayBtn
	}
	replayBtn.anchorX = .5
	replayBtn.anchorY = .5
	replayBtn.x = display.contentWidth * .25
	replayBtn.y = display.contentHeight * .95
	sceneGroup:insert(replayBtn)
	
	
	quitBtn = widget.newButton{
		label 		= "Give up...",
		font 		= "fonts/Rufscript010",
		fontSize 	= display.contentWidth * .05,
		labelColor 	= { default={255}, over={128} },
		defaultFile = "imgs/button.png",
		overFile 	= "imgs/button-over.png",
		width 		= display.contentWidth * .50, 
		height 		= display.contentHeight * .1,
		onRelease 	= onQuitBtn
	}
	quitBtn.anchorX = .5
	quitBtn.anchorY = .5
	quitBtn.x = display.contentWidth * .75
	quitBtn.y = display.contentHeight * .95
	sceneGroup:insert(quitBtn)
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
	  titleText.isVisible = true
	  scoreText.isVisible = true
	  distanceText.isVisible = true
	  achievementText.isVisible = true
	  achievementTitle.isVisible = true
	  --achievementSubtext.isVisible = true
	  achievementIcon.isVisible = true
	  --achievementBorder.isVisible = true
	  replayBtn.isVisible = true
	  quitBtn.isVisible = true
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
      titleText.isVisible = false
	  scoreText.isVisible = false
	  distanceText.isVisible = false
	  achievementText.isVisible = false
	  achievementTitle.isVisible = false
	  --achievementSubtext.isVisible = false
	  achievementIcon.isVisible = false
	  --achievementBorder.isVisible = false
	  replayBtn.isVisible = false
	  quitBtn.isVisible = false
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

	titleText:removeSelf()
	titleText = nil
	scoreText:removeSelf()
	scoreText = nil
	distanceText:removeSelf()
	distanceText = nil
	
	achievementText:removeSelf()
	achievementText = nil
	achievementTitle:removeSelf()
	achievementTitle = nil
	--achievementSubtext:removeSelf()
	--achievementSubtext = nil
	achievementIcon:removeSelf()
	achievementIcon = nil
	--achievementBorder:removeSelf()
	--achievementBorder = nil
	
	replayBtn:removeSelf()
	replayBtn = nil
	quitBtn:removeSelf()
    quitBtn = nil
	
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

---------------------------------------------------------------------------------

return scene