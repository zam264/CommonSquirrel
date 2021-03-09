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
local titleText, scoreText, highScore, distanceText, scoreT, distanceT
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

    --Display text telling the player that they lost
	titleText = display.newText( "You Lose" , display.contentWidth*.5, display.contentHeight *.1, "fonts/Rufscript010",  display.contentHeight * .1)
	titleText.anchorX = .5
	titleText.anchorY = .5
	sceneGroup:insert(titleText)
	
	--The score stored on the players device is lower than their current score -> so a new score has been achieved
	if (loadScore() <= playerScore) then	--new highscore has been set -> Inform the player
		scoreText = display.newText( "New HighScore!" , display.contentWidth*.025, display.contentHeight *.14, "fonts/Rufscript010",  display.contentHeight * .05)
		scoreText.anchorX = 0
		scoreText.anchorY = 0
		sceneGroup:insert(scoreText)
		composer.removeScene( "unlockables" )
	else
		scoreText = display.newText( "Score: ", display.contentWidth*.025, display.contentHeight *.14, "fonts/Rufscript010",  display.contentHeight * .05)
		scoreText.anchorX = 0
		scoreText.anchorY = 0
		sceneGroup:insert(scoreText)
	end
	--Displays the score of the player
	scoreT = display.newText(playerScore, display.contentWidth*.975, display.contentHeight *.205, "fonts/Rufscript010",  display.contentHeight * .05)
	scoreT.anchorX = 1
	scoreT.anchorY = 0
	sceneGroup:insert(scoreT)
	
	--Display the total distance traveled -> Distance accumulates to unlock achievements
	distanceText = display.newText ("Distance Traveled: ", display.contentWidth*.025, display.contentHeight *.265, "fonts/Rufscript010",  display.contentHeight * .05)
	distanceText.anchorX = 0
	distanceText.anchorY = 0
	sceneGroup:insert(distanceText)
	
	distanceT = display.newText (distance.." ft", display.contentWidth*.95, display.contentHeight *.330, "fonts/Rufscript010",  display.contentHeight * .05)
	distanceT.anchorX = 1
	distanceT.anchorY = 0
	sceneGroup:insert(distanceT)
	
	local x = 2
	local totalDist = loadDistance()
	while totalDist > achievementTable[x][1] do
		x = x+1
	end
	
	if totalDist - distance < achievementTable[x-1][1] then
		composer.removeScene( "achievements" )
		
		achievementText = display.newText( "Achievement Unlocked!" , display.contentWidth*.025, display.contentHeight *.41, "fonts/Rufscript010",  display.contentHeight * .05)
		achievementText.anchorX = 0
		achievementText.anchorY = 0
		sceneGroup:insert(achievementText)
		
		achievementTitle = display.newText( achievementTable[x-1][2] .. "\n" .. achievementTable[x-1][1] .. "ft".."\n"..achievementTable[x-1][3] , display.contentWidth*.35, display.contentHeight *.48, "fonts/Rufscript010",  display.contentHeight * .035)
		achievementTitle.anchorX = 0
		achievementTitle.anchorY = 0
		sceneGroup:insert(achievementTitle)
		
		achievementIcon = display.newImageRect( "achievements/"..achievementTable[x-1][4], display.contentHeight*.175, display.contentHeight*.15 )
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
		achievementText = display.newText( "Next Achievement At" , display.contentWidth*.025, display.contentHeight *.41, "fonts/Rufscript010",  display.contentHeight * .05)
		achievementText.anchorX = 0
		achievementText.anchorY = 0
		sceneGroup:insert(achievementText)
		
		achievementTitle = display.newText( achievementTable[x][1].."ft" , display.contentWidth*.35, display.contentHeight *.48, "fonts/Rufscript010",  display.contentHeight * .035)
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
		label="Play Again",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .50, height=display.contentHeight * .1,
		onRelease = onReplayBtn
	}
	replayBtn.anchorX = .5
	replayBtn.anchorY = .5
	replayBtn.x = display.contentWidth * .50
	replayBtn.y = display.contentHeight * .75
	sceneGroup:insert(replayBtn)
	
	
	quitBtn = widget.newButton{
		label="Give up...",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .5, height=display.contentHeight * .1,
		onRelease = onQuitBtn
	}
	quitBtn.anchorX = .5
	quitBtn.anchorY = .5
	quitBtn.x = display.contentWidth * .50
	quitBtn.y = display.contentHeight * .85
	sceneGroup:insert(quitBtn)
	
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
	  titleText.isVisible = true
	  scoreText.isVisible = true
	  scoreT.isVisible = true
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
	  scoreT.isVisible = false
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
	scoreT:removeSelf()
	scoreT = nil
	distanceText:removeSelf()
	distanceText = nil
	distanceT:removeSelf()
	distanceT = nil
	
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