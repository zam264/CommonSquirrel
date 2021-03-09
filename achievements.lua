--[[This page shows the user which achievements they have unlocked.  Unlocked achievements are strictly based on
the players total distance traveled.]]
local composer = require( "composer" )
local score = require( "score" )
local scene = composer.newScene()
local widget = require "widget"
require "achievements.achievementTable"
-- local variable definitions
local titleText1, scrollableachievements, achievementIcon, achievementBorder
local backBtnBtn

--navigate back to main menu
local function onBackBtn()
	sceneInTransition = true
	composer.gotoScene("menu", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view

	titleText1 = display.newText( "Achievements", 0, 0, "fonts/Rufscript010" ,display.contentHeight * .065)
	titleText1.anchorX = 0
	titleText1.anchorY = 0
	sceneGroup:insert(titleText1)
	
	--a widget to hold all of our achievements
	scrollableachievements = widget.newScrollView {
		left = 0, top = display.contentHeight*.08, --display.contentHeight*.065,
		width = display.contentWidth,
		height = display.contentHeight*.80,
		--topPadding = display.contentHeight * .1,
		bottomPadding = display.contentHeight * .1,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		backgroundColor = {0/255, 120/255, 171/255, 0}
	}
	sceneGroup:insert(scrollableachievements)
	
	
	local i = 1  --used for achievement index
	local j = 1  --used for achievement placement
	while achievementTable[i][1] < loadDistance()do --find the next unlockable achievement
		i = i+1
	end

	--locked achievement icon informing the user when the next achievement can be unlocked
	achievementIcon = display.newImageRect( "imgs/locked.png", display.contentHeight*.175, display.contentHeight*.175 )
	achievementIcon.anchorX = 0
	achievementIcon.anchorY = 0
	achievementIcon.x = 0
	achievementIcon.y = 0
	scrollableachievements:insert( achievementIcon )
	
	local achievementsText = "LOCKED until " .. achievementTable[i][1] .. "ft"
	local achievementsTextObject = display.newText(achievementsText, display.contentHeight*.2, (display.contentHeight*.2*(j-1)), "fonts/Rufscript010" ,display.contentHeight * .025)
	achievementsTextObject.anchorX = 0	
	achievementsTextObject.anchorY = 0
	achievementsTextObject:setTextColor(1,1,1)
	scrollableachievements:insert(achievementsTextObject)
	
	achievementBorder = display.newImageRect("imgs/achievementBorder.png", display.contentHeight*.175, display.contentHeight*.175)
	achievementBorder.anchorX = 0
	achievementBorder.anchorY = 0
	achievementBorder.x = 0
	achievementBorder.y = 0
	scrollableachievements:insert(achievementBorder)
	
	i = i-1
	j = j+1
	--loop through and dynamically create each unlocked achievement using i and j for spacing and achievement names and images
	while i>=1 do
		local achievementsText = achievementTable[i][2] .. " " .. achievementTable[i][1] .. "ft"
		local achievementsTextObject = display.newText(achievementsText, display.contentHeight*.18, (display.contentHeight*.2*(j-1)), "fonts/Rufscript010" ,display.contentHeight * .025)
		achievementsTextObject.anchorX = 0	
		achievementsTextObject.anchorY = 0
		achievementsTextObject:setTextColor(1,1,1)
		scrollableachievements:insert(achievementsTextObject)
		
		local achievementDescriptionTextObject = display.newText(achievementTable[i][3], display.contentHeight*.2, display.contentHeight*.2*(j-1)+display.contentHeight*.05, "fonts/Rufscript010", display.contentHeight * .02)
		achievementDescriptionTextObject.anchorX = 0
		achievementDescriptionTextObject.anchorY = 0
		scrollableachievements:insert(achievementDescriptionTextObject)

		achievementIcon = display.newImageRect( "achievements/"..achievementTable[i][4], display.contentHeight*.175, display.contentHeight*.175 )
		achievementIcon.anchorX = 0
		achievementIcon.anchorY = 0
		achievementIcon.x = 0
		achievementIcon.y = (display.contentHeight*.2*(j-1))
		scrollableachievements:insert( achievementIcon )
		
		achievementBorder = display.newImageRect("imgs/achievementBorder.png", display.contentHeight*.175, display.contentHeight*.175)
		achievementBorder.anchorX = 0
		achievementBorder.anchorY = 0
		achievementBorder.x = 0
		achievementBorder.y = achievementIcon.y
		scrollableachievements:insert(achievementBorder)
		
		i = i-1
		j = j+1
   	end

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
		scrollableachievements.isVisible = true
		backBtn.isVisible = true
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
		scrollableachievements.isVisible = false
		backBtn.isVisible = false
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