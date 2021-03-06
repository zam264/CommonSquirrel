--[[This page allows the user to change option and settings all of which are automatically saved.
This includes the audio options, swipe to move functionality, vibration and the ability to clear distance and score.]]
local composer = require( "composer" )
local unlockables = require( "unlockables" )
local scene = composer.newScene()
local widget = require ("widget")		-- include Corona's "widget" library
require('settings')

-- local variable definition
local titleText, difficultyText, easyText, normalText, hardText, movementText, vibrationText
local creditsBtn, backBtn, effectsSlider, musicSlider, achievmentsBtn, movementButton, vibrationButton, journalBtn
local btnWidth = display.contentWidth * .80 --variable to modify width of all buttons
local btnHeight = display.contentHeight * .09 --variable to modify width of all buttons
local hitSFX = audio.loadSound("sound/atari_boom3.mp3")

swipeMovement = false  --False = Tap to move, True = swipe to move 
vibrate = true  	   --Holds whether vibration is on or off 
widget.setTheme("widget_theme_ios") 
-- Slider listener
function effectsListener( event )
	effectsVolume = event.value
	audio.setVolume(effectsVolume/100, {channel=3})
	audio.setVolume(effectsVolume/100, {channel=4})
	saveSettings(effectsVolume, musicVolume, swipeMovement, vibrate)
	audio.play( hitSFX, { channel=4, loops=0 } )
    --print( "Effects Slider at " .. event.value .. "%" )
end
function musicListener ( event )
	musicVolume = event.value
	audio.setVolume(musicVolume/100, {channel=1})
	audio.setVolume(musicVolume/100, {channel=2})
	saveSettings(effectsVolume, musicVolume, swipeMovement, vibrate)
	--print( "Music Slider at " .. event.value .. "%" )
end
--goto credits screen
local function onCreditsBtn()
	sceneInTransition = true
	composer.gotoScene( "gamecredits", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
--clear score and distance; also resets skins and achievements
local function onClearScoreBtn()
	saveScore(0)
	saveSkin(1)
	addToDistance(loadDistance()*-1)
	sceneInTransition = true
	composer.removeScene( "menu" )
	composer.removeScene( "unlockables" )
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
--go back to main menu
local function onBackBtn()
	sceneInTransition = true
	composer.gotoScene( "menu", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
--Called when the switch for movement type is switched
function switchMovement() 
	swipeMovement = not swipeMovement
	saveSettings(effectsVolume, musicVolume, swipeMovement, vibrate)
end
--Changes vibration setting 
function switchVibrate() 
	vibrate = not vibrate
	saveSettings(effectsVolume, musicVolume, swipeMovement, vibrate)
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   --create text objects
	titleText = display.newText( "Options", 0, 0, "fonts/Rufscript010" ,display.contentHeight * .065)
	titleText.anchorX = 0
	titleText.anchorY = 0
	sceneGroup:insert(titleText)
   
	difficultyText = display.newText( "Volume", display.contentWidth * .15, display.contentHeight*.125, "fonts/Rufscript010",  display.contentHeight * .04)
	difficultyText.anchorX = 0
	difficultyText.anchorY = 0
	sceneGroup:insert(difficultyText)

   
	effectsText = display.newText( "Sound Effects", display.contentWidth * .25, display.contentHeight*.175, "fonts/Rufscript010" ,display.contentHeight * .035)
	effectsText.anchorX = 0
	effectsText.anchorY = 0
	sceneGroup:insert(effectsText)
	
	--Controls the volume of effects (collision sound effects)
	effectsSlider = widget.newSlider
	{
		top = display.contentHeight * .225,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = effectsVolume,
		listener = effectsListener
	}
	sceneGroup:insert(effectsSlider)

	musicText = display.newText( "Music", display.contentWidth * .25, display.contentHeight*.275, "fonts/Rufscript010" ,display.contentHeight * .035)
	musicText.anchorX = 0
	musicText.anchorY = 0
	sceneGroup:insert(musicText)
   
   --Controls the volume of the in-game music
   musicSlider = widget.newSlider
	{
		top = display.contentHeight * .325,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = musicVolume,
		listener = musicListener
	}
	sceneGroup:insert(musicSlider)

	movementText = display.newText( "Swipe To Move", display.contentWidth * .15, display.contentHeight * .4, "fonts/Rufscript010", display.contentHeight * .035)
	movementText.anchorX = 0 
	movementText.anchorY = 0 
	sceneGroup:insert(movementText)

	--Controls whether the movement type is swipe or tap 
	movementButton = widget.newSwitch
	{
	    left = display.contentWidth * .625,
	    top = display.contentHeight * .41,
	    style = "onOff",
	    initialSwitchState = swipeMovement,
	    onPress = switchMovement
	}
	movementButton.width = display.contentWidth * .4
	movementButton.height = display.contentHeight * .07
	sceneGroup:insert( movementButton )

	vibrationText = display.newText( "Vibration", display.contentWidth * .15, display.contentHeight * .5, "fonts/Rufscript010", display.contentHeight * .035)
	vibrationText.anchorX = 0 
	vibrationText.anchorY = 0 
	sceneGroup:insert(vibrationText)

	--Controls whether vibration is on or off
	vibrationButton = widget.newSwitch
	{
	    left = display.contentWidth * .625,
	    top = display.contentHeight * .51,
	    style = "onOff",
	    initialSwitchState = vibrate,
	    onPress = switchVibrate
	}
	vibrationButton.width = display.contentWidth * .4
	vibrationButton.height = display.contentHeight * .07
	sceneGroup:insert( vibrationButton )
	--creation of the option buttons
	creditsBtn = widget.newButton{
		label="Credits",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=btnWidth, height=btnHeight,
		onRelease = onCreditsBtn
	}
	creditsBtn.anchorX = .5
	creditsBtn.anchorY = .5
	creditsBtn.x = display.contentWidth * .50
	creditsBtn.y = display.contentHeight * .68
	sceneGroup:insert(creditsBtn)

	clearScoreBtn = widget.newButton{
		label="Clear Score and Distance",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=btnWidth, height=btnHeight,
		onRelease = onClearScoreBtn
	}
	clearScoreBtn.anchorX = .5
	clearScoreBtn.anchorY = .5
	clearScoreBtn.x = display.contentWidth * .50
	clearScoreBtn.y = display.contentHeight * .76
	sceneGroup:insert(clearScoreBtn)

	backBtn = widget.newButton{
		label="Back",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=btnWidth, height=btnHeight,
		onRelease = onBackBtn
	}
	backBtn.anchorX = .5
	backBtn.anchorY = .5
	backBtn.x = display.contentWidth * .50
	backBtn.y = display.contentHeight * .92
	sceneGroup:insert(backBtn)
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
  	titleText.isVisible = true
	difficultyText.isVisible = true
	effectsText.isVisible = true
	effectsSlider.isVisible = true
	musicText.isVisible = true
	musicSlider.isVisible = true
	creditsBtn.isVisible = true
	clearScoreBtn.isVisible = true
	backBtn.isVisible = true
	movementButton.isVisible = true
	movementText.isVisible = true
	vibrationText.isVisible = true
	vibrationButton.isVisible = true
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
	difficultyText.isVisible = false
	effectsText.isVisible = false
	effectsSlider.isVisible = false
	musicText.isVisible = false
	musicSlider.isVisible = false
	creditsBtn.isVisible = false
	clearScoreBtn.isVisible = false
	backBtn.isVisible = false
	movementButton.isVisible = false
	movementText.isVisible = false
	vibrationText.isVisible = false
	vibrationButton.isVisible = false
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
	difficultyText:removeSelf()
	difficultyText = nil
	effectsText:removeSelf()
	effectsText = nil
	effectsSlider:removeSelf()
	effectsSlider = nil
	musicText:removeSelf()
	musicText = nil
	musicSlider:removeSelf()
	musicSlider = nil
	creditsBtn:removeSelf()
	creditsBtn = nil
	clearScoreBtn:removeSelf()
	clearScoreBtn = nil
	backBtn:removeSelf()
	backBtn = nil
	movementButton:removeSelf()
	movementButton = nil
	movementText:removeSelf()
	movementText = nil
	vibrationText:removeSelf()
	vibrationText = nil
	vibrationButton:removeSelf()
	vibrationButton = nil
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