local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local titleText1
local backBtn
local scrollableCredits


local function onBackBtn()
	sceneInTransition = true
	composer.gotoScene("options", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	--composer.getScene("menu"):destroy()

   local sceneGroup = self.view

	titleText1 = display.newText( "Credits", 0, 0, "fonts/Rufscript010" ,display.contentHeight * .065)
	titleText1.anchorX = 0
	titleText1.anchorY = 0
	sceneGroup:insert(titleText1)
	
	
	scrollableCredits = widget.newScrollView {
		left = 0, top = display.contentHeight*.08,
		width = display.contentWidth,
		height = display.contentHeight*.80,
		--topPadding = display.contentHeight * .1,
		--bottomPadding = display.contentHeight * .1,
		horizontalScrollDisabled = false,
		verticalScrollDisabled = false,
		backgroundColor = {0/255, 120/255, 171/255}
	}
	sceneGroup:insert(scrollableCredits)
	local creditsText="Creators:	\nWilliam Botzer	\nZachary Petrusch	\nSteven Zamborsky	\n\nArtwork:	\nCasey Squires	\n\nAchievement images:	\nFortunella_margarita_(small_tree).JPG - Public Domain	\nSimon A. Eugster - Tape_measure_colored.jpeg - CC-BY-SA 3.0	\nJakub Hałun - 20090529 Great Wall 8185.jpg - CC BY-SA 3.0	\nBenjaminb - Quercus stellata.jpg - CC BY 2.5	\nUrban - Rockefeller Center christmas tree.jpg - CC BY-SA 3.0	\nSusan Serra - TSB2010 cropped.jpg - CC BY-SA 2.0	\nMenchi - Pine cones, male and female.jpg - CC BY-SA 3.0	\nAlec Perkins - 47_SAM_3000_(4842775734).jpg - CC BY 2.0	\nStatue of Liberty - Open Source	\nAlvesgaspar - Big Ben 2007-1.jpg - CC BY-SA 3.0	\nbabyknight - New Meadowlands Stadium Mezz Corner.jpg - CC BY 2.0	\nMichael Schweppe - Redwood National Park, fog in the forest.jpg - CC BY-SA 2.0	\nHajor - Egypt.Giza.Menkaure.01.jpg - CC BY-SA 3.0	\nWashington Monument - Open Source	\nUS Steel Tower - Open Source	\nEiffel Tower - Open Source	\nDavid Shankbone - Empire State Building by David Shankbone crop.jpg - CC BY-SA 3.0	\nVinceB - Sears_Tower_ss.jpg - No rights claimed or reserved	\nDonaldytong - Burj Khalifa.jpg - CC BY-SA 3.0	\nPiccoloNamek - GoldenMedows.jpg - CC BY-SA 3.0	\nhttp://imgarcade.com/ - Occupied sign - non-listed	\nAkira Toriyama (Dragon Ball Z, Program creator) - Scouter - Fair Use	\nSvickova - Botzer von Nordosten.JPG - CC BY-SA 3.0	\nBalloons - Public Domain	\nLuca Galuzzi - Everest North Face toward Base Camp Tibet Luca Galuzzi 2006.jpg - CC BY-SA 2.5	\nBarcex - Boeing_757-256_-_Iberia_-_EC-HDU_-_LEMD.jpg - CC BY-SA 3.0	\nAstronaut - Open Source	\nISS - Open Source	\nV. Vizu - Space dogs - CC BY-SA 3.0	\nGregory H. Revera - FullMoon2010.jpg - CC BY-SA 3.0"
	local creditsTextObject = display.newText(creditsText, 0, 0, "fonts/Rufscript010" ,display.contentHeight * .025)
	creditsTextObject.anchorX = 0
	creditsTextObject.anchorY = 0
	creditsTextObject:setTextColor(1,1,1)
	scrollableCredits:insert(creditsTextObject)
   
   -- Initialize the scene here.
	backBtn = widget.newButton{
		label="Back",
		font = "fonts/Rufscript010",
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
	backBtn.y = display.contentHeight * .95
	sceneGroup:insert(backBtn)
	
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
		titleText1.isVisible = true
		backBtn.isVisible = true
		scrollableCredits.isVisible = true
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
		backBtn.isVisible = false
		scrollableCredits.isVisible = false
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
   scrollableCredits:removeSelf()
   scrollableCredits = nil
   backBtn:removeSelf()
   backBtn = nil
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