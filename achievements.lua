local composer = require( "composer" )
local score = require( "score" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local titleText1, scrollableachievements, background
local backBtnBtn



local function onBackBtn()
	composer.gotoScene("options")
	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	--composer.getScene("menu"):destroy()

   local sceneGroup = self.view

	titleText1 = display.newText( "Achievements", 0, 0, native.systemFont ,display.contentHeight * .065)
	titleText1.anchorX = 0
	titleText1.anchorY = 0
	sceneGroup:insert(titleText1)
	
	
	 


   -- Initialize the scene here.
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
   	scrollableachievements = widget.newScrollView {
		left = 0, top = display.contentHeight*.065,
		width = display.contentWidth,
		height = display.contentHeight*.73,
		--topPadding = display.contentHeight * .1,
		bottomPadding = display.contentHeight * .1,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		backgroundColor = {.1,.1,.1}
	}
	sceneGroup:insert(scrollableachievements)

	local distance = {500, 1000, 1500, 5000, 10000, 15000, 999999999} --'unachievable' score necessary to avoid out of bounds error when testing
	local achievementNames = {"First", "Second", "Third", "Fourth", "Fifth"}
	local i = 1
	while distance[i] < loadDistance() do
		
		local achievementsText = achievementNames[i] .. " " .. distance[i] .. "ft+"
		local achievementsTextObject = display.newText(achievementsText, 225, (250*(i-1)), native.systemFont ,display.contentHeight * .025)
		achievementsTextObject.anchorX = 0	
		achievementsTextObject.anchorY = 0
		achievementsTextObject:setTextColor(1,1,1)
		scrollableachievements:insert(achievementsTextObject)


		background = display.newImageRect( "imgs/achievement" .. i ..".png", 200, 200 )
		background.x = 100
		background.y = 100+(250*(i-1))
		scrollableachievements:insert( background )
		i = i+1
   	end
	local achievementsText = "LOCKED until " .. distance[i] .. "ft+"
	local achievementsTextObject = display.newText(achievementsText, 225, (250*(i-1)), native.systemFont ,display.contentHeight * .025)
	achievementsTextObject.anchorX = 0	
	achievementsTextObject.anchorY = 0
	achievementsTextObject:setTextColor(1,1,1)
	scrollableachievements:insert(achievementsTextObject)
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