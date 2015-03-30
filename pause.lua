local composer = require( "composer" )
local score = require( "score" )
local options = require("options")
local game = require( "game" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------

----------
-- LOCAL VARIABLE DECLARATIONS
local resumeBtn, quitBtn, movementButton, vibrationButton	--local buttons and switches
local titleText, scoreText, highScore, distanceText, scoreT, distanceT, effectsText, musicText, movementText, vibrationText
local effectsSlider, musicSlider	-- local sliders

--------------------------------------------
--onResumeBtn()
--send the player back to the game and remove the pause scene to force the score and distance to reload
--------------------------------------------
local function onResumeBtn()
	composer.removeScene( "pause" )	-- remove pause so that if used again it will reload score and distance
	
	sceneInTransition = true	-- set the global "sceneInTransition = true" which prevents use of the back button
	timer.performWithDelay (1000, function() sceneInTransition = false end)	-- reset "sceneInTransition" when the scene is done transitioning

	composer.gotoScene( "game", {effect="fromLeft", time=1000})	-- transition back to game
	return true	-- indicates successful touch
end

--------------------------------------------
--onQuitBtn()
--quits the game and sends the player back to the menu
-- remove the game, pause, and options scenes to force them to reload
--------------------------------------------
local function onQuitBtn()	--When the player chooses to quit remove all the scenes and go back to the menu screen 
	composer.removeScene( "game" )		-- remove game so that the player can start a new game from the menu
	composer.removeScene( "pause" )		-- remove pause so that it can be remade by game
	composer.removeScene( "options" )	-- remove options to force it to reload and update settings
	
	sceneInTransition = true	-- set the global "sceneInTransition = true" which prevents use of the back button 
	timer.performWithDelay (1000, function() sceneInTransition = false end)	-- reset "sceneInTransition" when the scene is done transitioning
	
	audio.stop(2)	-- stop the games music because we are leaving to the menu
	composer.gotoScene( "menu", {effect="fromLeft", time=1000})	-- transition back to the menu
	return true	-- indicates successful touch
end

---------------------------------------------------------------------------------

--Creates the Pause Menu Screen 
function scene:create( event )
    sceneGroup = self.view

--Create the visuals for the Pause screen 
	composer.removeScene( "options" )

	-- Create the title text for the Pause screen
	titleText = display.newText( "Paused" , display.contentWidth*.5, display.contentHeight *.1, "fonts/Rufscript010",  display.contentHeight * .1)
	titleText.anchorX = .5
	titleText.anchorY = .5
	sceneGroup:insert(titleText)
	
	-- Create the score "header"
	scoreText = display.newText( "Score: ", display.contentWidth*.025, display.contentHeight *.14, "fonts/Rufscript010",  display.contentHeight * .05)
	scoreText.anchorX = 0
	scoreText.anchorY = 0
	sceneGroup:insert(scoreText)
	-- Create the players current in game score
	scoreT = display.newText(playerScore, display.contentWidth*.975, display.contentHeight *.205, "fonts/Rufscript010",  display.contentHeight * .05)
	scoreT.anchorX = 1
	scoreT.anchorY = 0
	sceneGroup:insert(scoreT)
	
	-- Create the distance "header"
	distanceText = display.newText ("Distance Travelled: ", display.contentWidth*.025, display.contentHeight *.265, "fonts/Rufscript010",  display.contentHeight * .05)
	distanceText.anchorX = 0
	distanceText.anchorY = 0
	sceneGroup:insert(distanceText)
	-- Create the players current in-game distance
	distanceT = display.newText (distance.." ft", display.contentWidth*.95, display.contentHeight *.33, "fonts/Rufscript010",  display.contentHeight * .05)
	distanceT.anchorX = 1
	distanceT.anchorY = 0
	sceneGroup:insert(distanceT)
	
	-- Create the sound effects "header"
	effectsText = display.newText( "Sound Effects", display.contentWidth * .25, display.contentHeight*.375, "fonts/Rufscript010" ,display.contentHeight * .035)
	effectsText.anchorX = 0
	effectsText.anchorY = 0
	sceneGroup:insert(effectsText)
	
	--Slider to control the sound of effects (ex: collision sound)
	effectsSlider = widget.newSlider
	{
		top = display.contentHeight * .425,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = effectsVolume,
		listener = effectsListener	-- this calls the global function declared in options.lua
	}
	sceneGroup:insert(effectsSlider)

	-- Create the music "header"
	musicText = display.newText( "Music", display.contentWidth * .25, display.contentHeight*.475, "fonts/Rufscript010" ,display.contentHeight * .035)
	musicText.anchorX = 0
	musicText.anchorY = 0
	sceneGroup:insert(musicText)
   
   --Slider to control the sound of the in-game music
   musicSlider = widget.newSlider
	{
		top = display.contentHeight * .525,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = musicVolume,
		listener = musicListener	-- this calls the global function declared in options.lua
	}
	sceneGroup:insert(musicSlider)
	
	-- Creates the movement "header"
	movementText = display.newText( "Swipe To Move", display.contentWidth * .175, display.contentHeight * .6, "fonts/Rufscript010", display.contentHeight * .035)
	movementText.anchorX = 0 
	movementText.anchorY = 0 
	sceneGroup:insert(movementText)
	--A switch which allows the user to choose swipe or tap mode for movement of the squirrel 
	movementButton = widget.newSwitch
	{
	    left = display.contentWidth * .65,
	    top = display.contentHeight * .61,
	    style = "onOff",
	    initialSwitchState = swipeMovement,	-- swipeMovement is a global
	    onPress = switchMovement			-- uses the global "switchMovement" function declared in options.lua
	}
	movementButton.width = display.contentWidth * .4
	movementButton.height = display.contentHeight * .07
	sceneGroup:insert( movementButton )
	
	-- Creates the vibration "header"
	vibrationText = display.newText( "Vibration", display.contentWidth * .175, display.contentHeight * .68, "fonts/Rufscript010", display.contentHeight * .035)
	vibrationText.anchorX = 0 
	vibrationText.anchorY = 0 
	sceneGroup:insert(vibrationText)
	--A switch which turns vibration (on collision) on or off 
	vibrationButton = widget.newSwitch
	{
	    left = display.contentWidth * .65,
	    top = display.contentHeight * .69,
	    style = "onOff",
	    initialSwitchState = vibrate,	-- vibrate is a global
	    onPress = switchVibrate			-- uses the global "switchVibrate" function declared in options.lua
	}
	vibrationButton.width = display.contentWidth * .4
	vibrationButton.height = display.contentHeight * .07
	sceneGroup:insert( vibrationButton )
	
	-- Creates a button that will resume the game where the player left off
	resumeBtn = widget.newButton{
		label="Resume Game",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .50, height=display.contentHeight * .1,
		onRelease = onResumeBtn		-- takes the player back to game.lua
	}
	resumeBtn.anchorX = .5
	resumeBtn.anchorY = .5
	resumeBtn.x = display.contentWidth * .50
	resumeBtn.y = display.contentHeight * .80
	sceneGroup:insert(resumeBtn)
	
	-- Creates a button that quits out of the game and returns the player to the menu
	quitBtn = widget.newButton{
		label="Give up...",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .5, height=display.contentHeight * .1,
		onRelease = onQuitBtn	-- takes the player to menu.lua
	}
	quitBtn.anchorX = .5
	quitBtn.anchorY = .5
	quitBtn.x = display.contentWidth * .50
	quitBtn.y = display.contentHeight * .93
	sceneGroup:insert(quitBtn)
end

-- "scene:show()"
function scene:show( event )
	--Display everything when the scene is transitioned to 

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
		-- show text 
		titleText.isVisible = true
		scoreText.isVisible = true
		scoreT.isVisible = true
		distanceText.isVisible = true
		distanceT.isVisible = true
		-- show sliders and slider related text
		effectsSlider.isVisible = true		
		effectsText.isVisible = true
		musicSlider.isVisible = true
		musicText.isVisible = true
		-- show switches and switch related text
		movementText.isVisible = true
		movementButton.isVisible = true
		vibrationText.isVisible = true
		vibrationButton.isVisible = true
		-- show buttons
		resumeBtn.isVisible = true
		quitBtn.isVisible = true
   elseif ( phase == "did" ) then
   end
end

-- "scene:hide()"
function scene:hide( event )
	--Hide everything when the scene is left 
   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
		-- hide text
		titleText.isVisible = false
		scoreText.isVisible = false
		scoreT.isVisible = false
		distanceText.isVisible = false
		distanceT.isVisible = false
		-- hide sliders and related text
		effectsSlider.isVisible = false
		effectsText.isVisible = false
		musicSlider.isVisible = false
		musicText.isVisible = false
		-- hide switches and related text
		movementText.isVisible = false
		movementButton.isVisible = false
		vibrationText.isVisible = false
		vibrationButton.isVisible = false
		-- hide buttons
		resumeBtn.isVisible = false
		quitBtn.isVisible = false
   elseif ( phase == "did" ) then
   end
end

-- "scene:destroy()"
function scene:destroy( event )

	--Destory everything when the scene is destroyed 
   local sceneGroup = self.view
	-- destroy text
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
	-- destroy sliders and related text
	effectsSlider:removeSelf()
	effectsSlider = nil
	effectsText:removeSelf()
	effectsText = nil
	musicSlider:removeSelf()
	musicSlider = nil
	musicText:removeSelf()
	musicText = nil	
	-- destroy switches and related text
	movementText:removeSelf()
	movementText = nil
	movementButton:removeSelf()
	movementButton = nil
	vibrationText:removeSelf()
	vibrationText = nil
	vibrationButton:removeSelf()
	vibrationButton = nil
	-- destroy buttons
	resumeBtn:removeSelf()
	resumeBtn = nil
	quitBtn:removeSelf()
    quitBtn = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene