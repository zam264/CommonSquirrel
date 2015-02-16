local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ("widget")		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local titleText, difficultyText, easyText, normalText, hardText
local creditsBtn, backBtn, effectsSlider, musicSlider, achievmentsBtn
effectsVolume = 50
musicVolume = 50



-- Slider listener
function effectsListener( event )
	effectsVolume = event.value
    print( "Effects Slider at " .. event.value .. "%" )
end
function musicListener ( event )
	musicVolume = event.value
	print( "Music Slider at " .. event.value .. "%" )
end

local function onAchievmentsBtn()
	composer.gotoScene( "achievements", {effect="fromLeft", time=1000})
	return true	-- indicates successful touch
end
local function onCreditsBtn()
	composer.gotoScene( "gamecredits", {effect="fromLeft", time=1000})
	return true	-- indicates successful touch
end
local function onBackBtn()
	composer.gotoScene( "menu", {effect="fromRight", time=1000})
	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	--composer.getScene("menu"):destroy()
   local sceneGroup = self.view

	titleText = display.newText( "Options", 0, 0, native.systemFont ,display.contentHeight * .065)
	titleText.anchorX = 0
	titleText.anchorY = 0
	sceneGroup:insert(titleText)
   
	difficultyText = display.newText( "Volume", display.contentWidth * .15, display.contentHeight*.125, native.systemFont,  display.contentHeight * .04)
	difficultyText.anchorX = 0
	difficultyText.anchorY = 0
	sceneGroup:insert(difficultyText)

   
	effectsText = display.newText( "Sound Effects", display.contentWidth * .25, display.contentHeight*.175, native.systemFont ,display.contentHeight * .035)
	effectsText.anchorX = 0
	effectsText.anchorY = 0
	sceneGroup:insert(effectsText)
	
	effectsSlider = widget.newSlider
	{
		top = display.contentHeight * .225,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = effectsVolume,
		listener = effectsListener
	}
	sceneGroup:insert(effectsSlider)

	musicText = display.newText( "Music", display.contentWidth * .25, display.contentHeight*.275, native.systemFont ,display.contentHeight * .035)
	musicText.anchorX = 0
	musicText.anchorY = 0
	sceneGroup:insert(musicText)
   
   musicSlider = widget.newSlider
	{
		top = display.contentHeight * .325,
		left = display.contentWidth * .25,
		width = display.contentWidth * .5,
		value = musicVolume,
		listener = musicListener
	}
	sceneGroup:insert(musicSlider)
   
   -- Initialize the scene here.
	achievmentsBtn = widget.newButton{
		label="Achievments",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .50, height=display.contentHeight * .1,
		onRelease = onAchievmentsBtn
	}
	achievmentsBtn.anchorX = .5
	achievmentsBtn.anchorY = .5
	achievmentsBtn.x = display.contentWidth * .50
	achievmentsBtn.y = display.contentHeight * .55
	sceneGroup:insert(achievmentsBtn)


	creditsBtn = widget.newButton{
		label="Credits",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .50, height=display.contentHeight * .1,
		onRelease = onCreditsBtn
	}
	creditsBtn.anchorX = .5
	creditsBtn.anchorY = .5
	creditsBtn.x = display.contentWidth * .50
	creditsBtn.y = display.contentHeight * .7
	sceneGroup:insert(creditsBtn)

	backBtn = widget.newButton{
		label="Back",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .50, height=display.contentHeight * .1,
		onRelease = onBackBtn
	}
	backBtn.anchorX = .5
	backBtn.anchorY = .5
	backBtn.x = display.contentWidth * .50
	backBtn.y = display.contentHeight * .85
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
	backBtn.isVisible = true
	achievmentsBtn.isVisible = true
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
	backBtn.isVisible = false
	achievmentsBtn.isVisible = false
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
	backBtn:removeSelf()
	backBtn = nil
	achievmentsBtn:removeSelf()
	achievmentsBtn = nil
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