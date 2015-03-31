--[[This page lists all of the objects that the player can potentially come into interaction with during game-play]]
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library

-- local forward references should go here
local titleText1, scrollableJournal, backBtn
local background
--image sources for the journal
local journalImages = {
"imgs/beeHive.png", 
"imgs/acorn.png", 
"imgs/birdHouse1.png", 
"imgs/poisenShroom.png", 
"imgs/slowShroom.png",
"imgs/speedShroom.png",
"imgs/fire1.png",
"imgs/healthShroom.png"
}
--names for the journal entries
local journalEntries = {
"Bee Hive",
"Acorn", 
"Bird House",
"Poisonous Mushroom", 
"Time Slowing Mushroom",
"Time Accelerating Mushroom",
"Forrest Fire",
"Invincibility Mushroom"
}
--descriptions for the journal entries
local journalDescriptions = {
"A dangerous bee hive, avoid it",
"A delicious acorn, restores 1 health", 
"A well made bird house, don't hit", 
"A 'shroom that is highly toxic , avoid it",
"A 'shroom that slows time, helpful", 
"A 'shroom that speeds time, avoid it",
"A forest fire caused by a stray flame, \navoid it",
"A 'shroom that makes the squirrel \ninvincible to damage, helpful"
}
--navigate us back to the menu
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
	titleText1 = display.newText( "Journal", 0, 0, "fonts/Rufscript010" ,display.contentHeight * .065)
	titleText1.anchorX = 0
	titleText1.anchorY = 0
	sceneGroup:insert(titleText1)
	scrollableJournal = widget.newScrollView {
		left = 0, top = display.contentHeight*.08, --display.contentHeight*.065,
		width = display.contentWidth,
		height = display.contentHeight*.80,
		--topPadding = display.contentHeight * .1,
		bottomPadding = display.contentHeight * .1,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		backgroundColor = {0/255, 120/255, 171/255, 0}
	}
	sceneGroup:insert(scrollableJournal)
	
	
	local i = 1  --used for journal index
	local j = 1  --used for journal placement
	--loop through and dynamically create the journal entries including the journal title, image and description using i and j to traverse arrays and place items
	while i <= #journalImages do
		local journalText = journalEntries[i] 
		local journalTextObject = display.newText(journalText, display.contentHeight*.18, (display.contentHeight*.2*(j-1)), "fonts/Rufscript010" ,display.contentHeight * .025)
		journalTextObject.anchorX = 0	
		journalTextObject.anchorY = 0
		journalTextObject:setTextColor(1,1,1)
		scrollableJournal:insert(journalTextObject)
		
		local journalDescriptionTextObject = display.newText(journalDescriptions[i], display.contentHeight*.2, display.contentHeight*.2*(j-1)+display.contentHeight*.05, "fonts/Rufscript010", display.contentHeight * .02)
		journalDescriptionTextObject.anchorX = 0
		journalDescriptionTextObject.anchorY = 0
		scrollableJournal:insert(journalDescriptionTextObject)

		background = display.newImageRect( journalImages[i], display.contentHeight*.175, display.contentHeight*.175 )
		background.anchorX = 0
		background.anchorY = 0
		background.x = 0
		background.y = (display.contentHeight*.2*(j-1))
		scrollableJournal:insert( background )
		i = i+1
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
		scrollableJournal.isVisible = true
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
		scrollableJournal.isVisible = false
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
   scrollableJournal:removeSelf()
   scrollableJournal = nil
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