--[[This page shows the user which achievements they have unlocked.  Unlocked achievements are strictly based on
the players total distance traveled.]]
local composer = require( "composer" )
local score = require( "score" )
local scene = composer.newScene()
local widget = require "widget"		

-- local variable definitions
local titleText1, scrollableachievements, achievementIcon, achievementBorder
local backBtnBtn

--define the distance requirements to unlock achievements
local distance = {
2,		8,
26,		60,
100,	141,
176,	286,
305,	316,
360,	379,
455,	555,
841,	986,
1250,	1451,
2717,	3000,
5280,	9001,
10663,	28000,
29029,	35000,
327000,	1360000,
5443680, 1200000000,
9999999999}--'unachievable' score necessary to avoid out of bounds error when testing

--achievement names
local achievementNames = {
"Tree Sapling",
"Tallest Man",
"Great Wall of China",
"Average Oak Tree",
"Rockefeller Xmas Tree",
"New Years Eve Ball",
"Pine Tree",
"Giant Sequoia Tree",
"Statue of Liberty",
"Big Ben",
"Football Field",
"Record Breaking Redwood",
"Great Pyramid of Giza",
"Washington Monument",
"U.S. Steel Tower",
"Eiffel Tower",
"Empire State Building",
"Sears Tower",
"Burj Khalifa",
"Cumulus Clouds",
"1 Mile Up",
"Power Level",
"Mt. Botzer",
"Lost Balloon",
"Mt. Everest",
"Boeing 757",
"Space",
"ISS",
"Sputnik 2",
"Moon",
"Good Luck..."
}

--achievement descriptions
local achievementDescriptions = {
"Just a sapling",
"High five, mate",
"Squirrels > Mongols",
"I AM GROOT!",
"Rockin' Around the Christmas Tree",
"Dropping the Ball",
"Pine cones aren't enough",
"Neighborhood has really gone downhill",
"Emancipate the squirrels",
"Up high, wanker!",
"The whole 100 yards",
"Big Red",
"On your way to Ra",
"The rent at the top is too dang high",
"Developers! Developers!",
"Do squirrels like cheese?",
"More like Empire Squirrel Building",
"Wish I had brought my windbreaker",
"Are there even squirrels in Dubai?",
"Into the Clouds",
"Mile High Club",
"What does the scouter say?",
"Developers!",
"Super Squirrel will retrieve it",
"I should be hibernating right now",
"Now seating squirrels",
"Where no squirrel has gone before",
"No raccoons allowed",
"Squilnit the Soviet Squirrel",
"One small step for man, one giant leap for a squirrel",
"I think you cheated..."}

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
	while distance[i] < loadDistance()do --find the next unlockable achievement
		i = i+1
	end

	--locked achievement icon informing the user when the next achievement can be unlocked
	achievementIcon = display.newImageRect( "imgs/locked.png", display.contentHeight*.175, display.contentHeight*.175 )
	achievementIcon.anchorX = 0
	achievementIcon.anchorY = 0
	achievementIcon.x = 0
	achievementIcon.y = 0
	scrollableachievements:insert( achievementIcon )
	
	local achievementsText = "LOCKED until " .. distance[i] .. "ft"
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
		local achievementsText = achievementNames[i] .. " " .. distance[i] .. "ft"
		local achievementsTextObject = display.newText(achievementsText, display.contentHeight*.18, (display.contentHeight*.2*(j-1)), "fonts/Rufscript010" ,display.contentHeight * .025)
		achievementsTextObject.anchorX = 0	
		achievementsTextObject.anchorY = 0
		achievementsTextObject:setTextColor(1,1,1)
		scrollableachievements:insert(achievementsTextObject)
		
		local achievementDescriptionTextObject = display.newText(achievementDescriptions[i], display.contentHeight*.2, display.contentHeight*.2*(j-1)+display.contentHeight*.05, "fonts/Rufscript010", display.contentHeight * .02)
		achievementDescriptionTextObject.anchorX = 0
		achievementDescriptionTextObject.anchorY = 0
		scrollableachievements:insert(achievementDescriptionTextObject)

		achievementIcon = display.newImageRect( "achievements/achievement"..i..".png", display.contentHeight*.175, display.contentHeight*.175 )
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