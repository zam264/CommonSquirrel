local composer = require( "composer" )
local score = require( "score" )
local options = require("options")
local game = require( "game" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local resumeBtn, quitBtn, movementButton
local titleText, scoreText, highScore, distanceText, scoreT, distanceT
local effectsSlider, musicSlider, effectsText, musicText, movementText


local function onResumeBtn()
	composer.removeScene( "pause" )
	composer.gotoScene( "game", {effect="fromLeft", time=1000})
	return true	-- indicates successful touch
end
local function onQuitBtn()
	composer.removeScene( "game" )
	composer.removeScene( "menu" )
	composer.removeScene( "pause" )
	composer.gotoScene( "menu", {effect="fromLeft", time=1000})
	return true	-- indicates successful touch
end

local function switchMovement()
	swipeMovement = not swipeMovement
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    sceneGroup = self.view

	titleText = display.newText( "Paused" , display.contentWidth*.5, display.contentHeight *.1, native.systemFont,  display.contentHeight * .1)
	titleText.anchorX = .5
	titleText.anchorY = .5
	sceneGroup:insert(titleText)
	
	scoreText = display.newText( "Score: ", display.contentWidth*.025, display.contentHeight *.14, native.systemFont,  display.contentHeight * .05)
	scoreText.anchorX = 0
	scoreText.anchorY = 0
	sceneGroup:insert(scoreText)
	
	scoreT = display.newText(playerScore, display.contentWidth*.975, display.contentHeight *.205, native.systemFont,  display.contentHeight * .05)
	scoreT.anchorX = 1
	scoreT.anchorY = 0
	sceneGroup:insert(scoreT)
	
	distanceText = display.newText ("Distance Travelled: ", display.contentWidth*.025, display.contentHeight *.265, native.systemFont,  display.contentHeight * .05)
	distanceText.anchorX = 0
	distanceText.anchorY = 0
	sceneGroup:insert(distanceText)
	
	distanceT = display.newText (distance.." ft", display.contentWidth*.95, display.contentHeight *.33, native.systemFont,  display.contentHeight * .05)
	distanceT.anchorX = 1
	distanceT.anchorY = 0
	sceneGroup:insert(distanceT)
	
	
	effectsText = display.newText( "Sound Effects", display.contentWidth * .25, display.contentHeight*.375, native.systemFont ,display.contentHeight * .035)
	effectsText.anchorX = 0
	effectsText.anchorY = 0
	sceneGroup:insert(effectsText)
	
	effectsSlider = widget.newSlider
	{
		top = display.contentHeight * .425,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = effectsVolume,
		listener = effectsListener
	}
	sceneGroup:insert(effectsSlider)

	musicText = display.newText( "Music", display.contentWidth * .25, display.contentHeight*.475, native.systemFont ,display.contentHeight * .035)
	musicText.anchorX = 0
	musicText.anchorY = 0
	sceneGroup:insert(musicText)
   
   musicSlider = widget.newSlider
	{
		top = display.contentHeight * .525,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = musicVolume,
		listener = musicListener
	}
	sceneGroup:insert(musicSlider)
	
	movementText = display.newText( "Swipe To Move", display.contentWidth * .175, display.contentHeight * .6, native.systemFont, display.contentHeight * .035)
	movementText.anchorX = 0 
	movementText.anchorY = 0 
	sceneGroup:insert(movementText)

	movementButton = widget.newSwitch
	{
	    left = display.contentWidth * .65,
	    top = display.contentHeight * .61,
	    style = "onOff",
	    initialSwitchState = swipeMovement,
	    onPress = switchMovement
	}
	movementButton.width = display.contentWidth * .4
	movementButton.height = display.contentHeight * .07
	sceneGroup:insert( movementButton )
	
	
	resumeBtn = widget.newButton{
		label="Resume Game",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .50, height=display.contentHeight * .1,
		onRelease = onResumeBtn
	}
	resumeBtn.anchorX = .5
	resumeBtn.anchorY = .5
	resumeBtn.x = display.contentWidth * .50
	resumeBtn.y = display.contentHeight * .75
	sceneGroup:insert(resumeBtn)
	
	
	quitBtn = widget.newButton{
		label="Give up...",
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
	quitBtn.y = display.contentHeight * .9
	sceneGroup:insert(quitBtn)
	
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
		titleText.isVisible = true
		scoreText.isVisible = true
		scoreT.isVisible = true
		distanceText.isVisible = true
		distanceT.isVisible = true
		
		effectsSlider.isVisible = true

		effectsText.isVisible = true
		musicSlider.isVisible = true
		musicText.isVisible = true
		
		movementText.isVisible = true
		movementButton.isVisible = true
		
		resumeBtn.isVisible = true
		quitBtn.isVisible = true
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
		titleText.isVisible = false
		scoreText.isVisible = false
		scoreT.isVisible = false
		distanceText.isVisible = false
		distanceT.isVisible = false
		
		effectsSlider.isVisible = false

		effectsText.isVisible = false
		musicSlider.isVisible = false
		musicText.isVisible = false
		
		movementText.isVisible = false
		movementButton.isVisible = false
		
		resumeBtn.isVisible = false
		quitBtn.isVisible = false
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
	
	effectsSlider:removeSelf()
	effectsSlider = nil
	effectsText:removeSelf()
	effectsText = nil
	musicSlider:removeSelf()
	musicSlider = nil
	musicText:removeSelf()
	musicText = nil	
	
	movementText:removeSelf()
	movementText = nil
	movementButton:removeSelf()
	movementButton = nil
	
	resumeBtn:removeSelf()
	resumeBtn = nil
	quitBtn:removeSelf()
    quitBtn = nil

    --movementButton:removeSelf()
    --movementButton = nil 
    --movementText:removeSelf() 
    --movementText = nil 
	
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