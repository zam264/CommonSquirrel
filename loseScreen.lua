local composer = require( "composer" )
local score = require( "score" )
local game = require( "game" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local replayBtn, quitBtn
local titleText, scoreText, highScore, distanceText, scoreT, distanceT
local achievementText, achievementIcon, achievementTitle, achivementSubtext, achievementBorder
local achievementDistance = {
	2,		8,
	26,		60,
	100,	141,
	176,	286,
	305,	316,
	360,	379,
	455,	555,
	841,	986,
	1250,	1451,
	2717,	3000,
	5280,	9001,
	10663,	28000,
	29029,	35000,
	327000,	1360000,
	5443680, 1200000000,
	9999999999}--'unachievable' score necessary to avoid out of bounds error when testing
local achievementNames = {
	"Tree Sapling",
	"Tallest Man",
	"Great Wall of China",
	"Average Oak Tree",
	"Rockefellar Xmas Tree",
	"New Years Eve Ball",
	"Pine Tree",
	"Giant Sequoia Tree",
	"Statue of Liberty",
	"Big Ben",
	"Football Field",
	"Record Breaking Redwood",
	"Great Pyramid of Giza",
	"Washington Monument",
	"U.S. Steel Tower",
	"Eiffel Tower",
	"Empire State Building",
	"Sears Tower",
	"Burj Khalifa",
	"Cumulus Clouds",
	"1 Mile Up",
	"Power Level",
	"Mt. Botzer",
	"Lost Balloon",
	"Mt. Everest",
	"Boeing 757",
	"Space",
	"International Space Station",
	"Sputnik 2",
	"Moon",
	"Good Luck..."	}
local achievementDescriptions = {
	"Just a sapling",
	"High five, mate",
	"Squirrels > Mongols",
	"I AM GROOT!",
	"Rockin' Around the \nChristmas Tree",
	"Dropping the Ball",
	"Pine cones aren't enough",
	"Neighborhood has really\n gone downhill",
	"Emancipate the squirrels",
	"Up high, wanker!",
	"The whole 100 yards",
	"Big Red",
	"On your way to Ra",
	"The rent at the top is\n too dang high",
	"Developers! Developers!",
	"Do squirrels like \ncheese?",
	"More like Empire \nSquirrel Building",
	"Wish I had brought my \nwindbreaker",
	"Are there even squirrels\n in Dubai?",
	"Into the Clouds",
	"Mile High Club",
	"What does the scouter \nsay?",
	"Developers!",
	"Super Squirrel will \nretrieve it",
	"I should be hibernating\n right now",
	"Now seating squirrels",
	"Where no squirrel has\n gone before",
	"No racoons allowed",
	"Squilnit the Soviet\n Squirrel",
	"One small step for \nman, one giant leap \nfor a squirrel",
	"I think you cheated..."}
	
local function onReplayBtn()
	audio.stop(2)
	composer.removeScene( "game" )
	composer.removeScene( "loseScreen" )
	sceneInTransition = true
	composer.gotoScene( "game", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
local function onQuitBtn()
	audio.stop(2)
	composer.removeScene( "game" )
	--composer.removeScene( "menu" )
	composer.removeScene( "loseScreen" )
	sceneInTransition = true
	composer.gotoScene( "menu", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    sceneGroup = self.view

	titleText = display.newText( "You Lose" , display.contentWidth*.5, display.contentHeight *.1, "fonts/Rufscript010",  display.contentHeight * .1)
	titleText.anchorX = .5
	titleText.anchorY = .5
	sceneGroup:insert(titleText)
	
	if (loadScore() <= playerScore) then	--new highscore has been set
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
	scoreT = display.newText(playerScore, display.contentWidth*.975, display.contentHeight *.205, "fonts/Rufscript010",  display.contentHeight * .05)
	scoreT.anchorX = 1
	scoreT.anchorY = 0
	sceneGroup:insert(scoreT)
	
	distanceText = display.newText ("Distance Travelled: ", display.contentWidth*.025, display.contentHeight *.265, "fonts/Rufscript010",  display.contentHeight * .05)
	distanceText.anchorX = 0
	distanceText.anchorY = 0
	sceneGroup:insert(distanceText)
	
	distanceT = display.newText (distance.." ft", display.contentWidth*.95, display.contentHeight *.330, "fonts/Rufscript010",  display.contentHeight * .05)
	distanceT.anchorX = 1
	distanceT.anchorY = 0
	sceneGroup:insert(distanceT)
	
	local x = 2
	local totalDist = loadDistance()
	while totalDist > achievementDistance[x] do
		x = x+1
	end
	
	if totalDist - distance < achievementDistance[x-1] then
		composer.removeScene( "achievements" )
		
		achievementText = display.newText( "Achievement Unlocked!" , display.contentWidth*.025, display.contentHeight *.41, "fonts/Rufscript010",  display.contentHeight * .05)
		achievementText.anchorX = 0
		achievementText.anchorY = 0
		sceneGroup:insert(achievementText)
		
		achievementTitle = display.newText( achievementNames[x-1] .. "\n" .. achievementDistance[x-1] .. "ft".."\n"..achievementDescriptions[x-1] , display.contentWidth*.35, display.contentHeight *.48, "fonts/Rufscript010",  display.contentHeight * .035)
		achievementTitle.anchorX = 0
		achievementTitle.anchorY = 0
		sceneGroup:insert(achievementTitle)
		
		--[[achievementSubtext = display.newText( achievementDescriptions[x-1] , display.contentWidth*.35, display.contentHeight *.535, "fonts/Rufscript010",  display.contentHeight * .02)
		achievementSubtext.anchorX = 0
		achievementSubtext.anchorY = 0
		sceneGroup:insert(achievementSubtext)]]
		
		achievementIcon = display.newImageRect( "achievements/achievement" .. x-1 .. ".png", display.contentHeight*.175, display.contentHeight*.15 )
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
		achievementText = display.newText( "Next Achievment At" , display.contentWidth*.025, display.contentHeight *.41, "fonts/Rufscript010",  display.contentHeight * .05)
		achievementText.anchorX = 0
		achievementText.anchorY = 0
		sceneGroup:insert(achievementText)
		
		achievementTitle = display.newText( achievementDistance[x].."ft" , display.contentWidth*.35, display.contentHeight *.48, "fonts/Rufscript010",  display.contentHeight * .035)
		achievementTitle.anchorX = 0
		achievementTitle.anchorY = 0
		sceneGroup:insert(achievementTitle)
		--[[
		achievementSubtext = display.newText( "" , display.contentWidth*.35, display.contentHeight *.535, "fonts/Rufscript010",  display.contentHeight * .035)
		achievementSubtext.anchorX = 0
		achievementSubtext.anchorY = 0
		sceneGroup:insert(achievementSubtext)]]
		
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