local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local playBtn, optionsBtn
local titleText1, titleText2, highScoreText, box



local function onPlayBtn()
	composer.gotoScene( "game")

	return true	-- indicates successful touch
end
local function onOptionsBtn()
	composer.gotoScene( "options")

	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    sceneGroup = self.view

	titleText1 = display.newText( "Common Squirrel", display.contentWidth * .5, display.contentHeight*.1, "fonts/Rufscript010" ,display.contentHeight * .065)
	titleText2 = display.newText( "Runner", display.contentWidth * .5, display.contentHeight*.16, "fonts/Rufscript010" ,display.contentHeight * .065)
	sceneGroup:insert(titleText1)
	sceneGroup:insert(titleText2)
   
   highScoreText = display.newText( "HighScores", display.contentWidth*.5, display.contentHeight *.3, native.systemFont,  display.contentHeight * .05)
   highScoreText.anchorX = .5
   highScoreText.anchorY = .5
   sceneGroup:insert(highScoreText)
   
   box = display.newRect( display.contentWidth*.5, display.contentHeight*.475, display.contentWidth*.5, display.contentHeight*.275 )
   box:setFillColor( 0 )
   box.strokeWidth = 3
   box:setStrokeColor(255,0,0)
   sceneGroup:insert(box)
   
   -- Initialize the scene here.
	playBtn = widget.newButton{
		label="Play",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .50, height=display.contentHeight * .1,
		onRelease = onPlayBtn
	}
	playBtn.anchorX = .5
	playBtn.anchorY = .5
	playBtn.x = display.contentWidth * .50
	playBtn.y = display.contentHeight * .7
	sceneGroup:insert(playBtn)
	
	optionsBtn = widget.newButton{
		label="Options",
		fontSize = display.contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=display.contentWidth * .5, height=display.contentHeight * .1,
		onRelease = onOptionsBtn
	}
	playBtn.anchorX = .5
	playBtn.anchorY = .5
	optionsBtn.x = display.contentWidth * .50
	optionsBtn.y = display.contentHeight * .85
	sceneGroup:insert(optionsBtn)
	
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
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
	box:removeSelf()
	box = nil
	playBtn:removeSelf()
	playBtn = nil
	optionsBtn:removeSelf()
    optionsBtn = nil
	
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