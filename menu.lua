local composer = require( "composer" )
local score = require( "score" )
require("settings")
require("options")
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
display.setDefault( "background", 0/255, 120/255, 171/255 )

-- local forward references should go here
local playBtn, optionsBtn, achievementsButton, unlockablesButton, homeBG
local titleText1, titleText2, highScoreText, highScore, totalDistance, totalDistanceText
local backgroundMusic = audio.loadStream("sound/Night Calm v0_4.mp3")
effectsVolume = 0
musicVolume = 0


local function onPlayBtn()
	audio.stop(1)
	sceneInTransition = true
	composer.gotoScene( "game", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
local function onAchievementsButton()
	sceneInTransition = true
	composer.gotoScene( "achievements", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
local function onUnlockablesButton()
	sceneInTransition = true
	composer.gotoScene( "unlockables", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
local function onOptionsBtn()
	sceneInTransition = true
	composer.gotoScene( "options", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
local function onJournalBtn()
	sceneInTransition = true
	composer.gotoScene( "journal", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	loadSettings()
	audio.play( backgroundMusic, { channel=1, loops=-1, volume=0} )
	audio.setVolume(0, {channel=1})
	audio.fade( {channel=1, time=5000, volume=musicVolume/100})

    sceneGroup = self.view
	display.setDefault( "background", 0/255, 120/255, 171/255 )
	menuBG = display.newImageRect( "imgs/menuBG2.png", display.contentWidth, display.contentHeight)
	menuBG.x = display.contentWidth*.5
	menuBG.y = display.contentHeight*.5
	titleText1 = display.newText( "Common Squirrel", display.contentWidth * .5, display.contentHeight*.1, "fonts/Rufscript010" ,display.contentHeight * .065)
	titleText2 = display.newText( "Runner", display.contentWidth * .5, display.contentHeight*.16, "fonts/Rufscript010" ,display.contentHeight * .065)
	sceneGroup:insert(menuBG)
	sceneGroup:insert(titleText1)
	sceneGroup:insert(titleText2)
   
   highScoreText = display.newText( "HighScore", display.contentWidth*.5, display.contentHeight *.3, "fonts/Rufscript010",  display.contentHeight * .05)
   highScoreText.anchorX = .5
   highScoreText.anchorY = .5
   sceneGroup:insert(highScoreText)

   highScore = display.newText(loadScore() or 0, display.contentWidth*.5, display.contentHeight *.35, "fonts/Rufscript010",  display.contentHeight * .04)
   highScore.anchorX = .5
   highScore.anchorY = .5
   sceneGroup:insert(highScore)
   
   
   
   totalDistanceText = display.newText( "Total Distance", display.contentWidth*.5, display.contentHeight *.45, "fonts/Rufscript010",  display.contentHeight * .05)
   totalDistanceText.anchorX = .5
   totalDistanceText.anchorY = .5
   sceneGroup:insert(totalDistanceText)

   totalDistance = display.newText(loadDistance() or 0, display.contentWidth*.5, display.contentHeight *.5, "fonts/Rufscript010",  display.contentHeight * .04)
   totalDistance.anchorX = .5
   totalDistance.anchorY = .5
   sceneGroup:insert(totalDistance)
   
   -- Initialize the scene here.
	playBtn = widget.newButton{
		label="Play",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .1,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * 1, height=display.contentHeight * .1,
		onRelease = onPlayBtn
	}
	playBtn.anchorX = .5
	playBtn.anchorY = .5
	playBtn.x = display.contentWidth * .5
	playBtn.y = display.contentHeight * .7
	sceneGroup:insert(playBtn)
	
	
	--achievementsButton, unlockablesButton
	achievementsButton = widget.newButton{
		label="Achievements",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .5, height=display.contentHeight * .1,
		onRelease = onAchievementsButton
	}
	achievementsButton.anchorX = .5
	achievementsButton.anchorY = .5
	achievementsButton.x = display.contentWidth * .25
	achievementsButton.y = display.contentHeight * .8
	sceneGroup:insert(achievementsButton)
	
	
	unlockablesButton = widget.newButton{
		label="Unlockables",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .5, height=display.contentHeight * .1,
		onRelease = onUnlockablesButton
	}
	unlockablesButton.anchorX = .5
	unlockablesButton.anchorY = .5
	unlockablesButton.x = display.contentWidth * .75
	unlockablesButton.y = display.contentHeight * .9
	sceneGroup:insert(unlockablesButton)
	
	journalBtn = widget.newButton{
		label="Squirrel Journal",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .5, height=display.contentHeight * .1,
		onRelease = onJournalBtn
	}
	journalBtn.anchorX = .5
	journalBtn.anchorY = .5
	journalBtn.x = display.contentWidth * .75
	journalBtn.y = display.contentHeight * .8
	sceneGroup:insert(journalBtn)
	
	optionsBtn = widget.newButton{
		label="Options",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .5, height=display.contentHeight * .1,
		onRelease = onOptionsBtn
	}
	optionsBtn.anchorX = .5
	optionsBtn.anchorY = .5
	optionsBtn.x = display.contentWidth * .25
	optionsBtn.y = display.contentHeight * .9
	sceneGroup:insert(optionsBtn)
	
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   		audio.resume(1)
		titleText1.isVisible = true
		titleText2.isVisible = true
		highScoreText.isVisible = true
		highScore.isVisible = true
		totalDistanceText.isVisible = true
		totalDistance.isVisible = true
		playBtn.isVisible = true
		achievementsButton.isVisible = true
		unlockablesButton.isVisible = true
		optionsBtn.isVisible = true
		journalBtn.isVisible = true
		menuBG.isVisible = true
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
		titleText1.isVisible = false
		titleText2.isVisible = false
		highScoreText.isVisible = false
		highScore.isVisible = false
		totalDistanceText.isVisible = false
		totalDistance.isVisible = false
		playBtn.isVisible = false
		achievementsButton.isVisible = false
		unlockablesButton.isVisible = false
		optionsBtn.isVisible = false
		journalBtn.isVisible = false
		menuBG.isVisible = false
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

	titleText1:removeSelf()
	titleText1 = nil
	titleText2:removeSelf()
	titleText2 = nil
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
	achievementsButton:removeSelf()
	achievementsButton = nil
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