--[[This page gives the player the ability to navigate to any of the resources in the game including the game itself,
	achievements, options, unlockables as well as the journal.]]
require("settings")
require("options")
local textOptions = require ("textOptions")
local btnOptions = require ("btnOptions")
local composer = require( "composer" )
local score = require( "score" )
local widget = require "widget"		-- include Corona's "widget" library
local scene = composer.newScene()
display.setDefault( "background", 0/255, 120/255, 171/255 )

-- local variable definitions
local playBtn, optionsBtn, achievementsBtn, unlockablesButton, homeBG
local titleText, highScoreText, highScore, totalDistance, totalDistanceText
local backgroundMusic = audio.loadStream("sound/Night Calm v0_4.mp3")
local color = 
{
    highlight = { r=0, g=0, b=0 },
    shadow = { r=0, g=0, b=0 }
}
effectsVolume = 0
musicVolume = 0


---------------------------------------------------------------------------------

function scene:create( event )
	
	-- set our background color
	display.setDefault( "background", 0/255, 120/255, 171/255 )

	-- create our scene
	sceneGroup = self.view

	-- TODO: break out into options file
	-- load in our background images
	menuBG = display.newImageRect( "imgs/menuBG.png", display.contentWidth, display.contentHeight)
	menuBG.x = display.contentWidth*.5
	menuBG.y = display.contentHeight*.5
	sceneGroup:insert(menuBG)

	-- create text on the screen
	titleText = 		display.newEmbossedText(textOptions.menuTitleTextOptions); sceneGroup:insert(titleText)
	highScoreText = 	display.newEmbossedText(textOptions.menuHighScoreTextOptions); sceneGroup:insert(highScoreText)
	highScore = 		display.newEmbossedText(textOptions.menuHighScoreNumberOptions); sceneGroup:insert(highScore)
	totalDistanceText = display.newEmbossedText(textOptions.menuTotalDistanceTextOptions); sceneGroup:insert(totalDistanceText)
	totalDistance =		display.newEmbossedText(textOptions.menuTotalDistanceNumberOptions); sceneGroup:insert(totalDistance)

	-- sound settings
	loadSettings()--load our saved settings
	audio.play( backgroundMusic, { channel=1, loops=-1, volume=0} )--play our looping background music
	audio.setVolume(0, {channel=1})
	audio.fade( {channel=1, time=5000, volume=musicVolume/100})
	   
	playBtn = 				widget.newButton(btnOptions.menuPlayBtnOptions); sceneGroup:insert(playBtn)
	achievementsBtn = 		widget.newButton(btnOptions.menuAchievementsBtnOptions); sceneGroup:insert(achievementsBtn)
	unlockablesButton = 	widget.newButton(btnOptions.menuUnlockablesBtnOptions); sceneGroup:insert(unlockablesButton)
	journalBtn = 			widget.newButton(btnOptions.menuJournalBtnOptions); sceneGroup:insert(journalBtn)
	optionsBtn = 			widget.newButton(btnOptions.menuOptionsBtnOptions); sceneGroup:insert(optionsBtn)
end

function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
   		audio.resume(1)
		titleText.isVisible = true
		highScoreText.isVisible = true
		highScore.isVisible = true
		highScore.text = loadScore()
		totalDistanceText.isVisible = true
		totalDistance.isVisible = true
		totalDistance.text = loadDistance()
		playBtn.isVisible = true
		achievementsBtn.isVisible = true
		unlockablesButton.isVisible = true
		optionsBtn.isVisible = true
		journalBtn.isVisible = true
		menuBG.isVisible = true
		transition.to( menuBG, { time=1000, alpha=1 } )
		display.setDefault( "background", 0/255, 120/255, 171/255)
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
		highScoreText.isVisible = false
		highScore.isVisible = false
		totalDistanceText.isVisible = false
		totalDistance.isVisible = false
		playBtn.isVisible = false
		achievementsBtn.isVisible = false
		unlockablesButton.isVisible = false
		optionsBtn.isVisible = false
		journalBtn.isVisible = false
		--menuBG.isVisible = false
		transition.to( menuBG, { time=1000, alpha=0 } )
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
	highScoreText:removeSelf()
	highScoreText = nil
	highScore:removeSelf()
	highScore = nil
	totalDistanceText:removeSelf()
	totalDistanceText = nil
	totalDistance:removeSelf()
	totalDistance = nil
	playBtn:removeSelf()
	playBtn = nil
	achievementsBtn:removeSelf()
	achievementsBtn = nil
	unlockablesButton:removeSelf()
	unlockablesButton = nil
	optionsBtn:removeSelf()
    optionsBtn = nil
    journalBtn:removeSelf() 
    optionsBtn = nil 
    menuBG:removeSelf()
    menuBG = nil
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