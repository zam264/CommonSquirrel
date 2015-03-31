--[[This page allows the user to select from a variety of skins which are unlocked by achieving certain predetermine high scores.
]]
local composer = require( "composer" )
local score = require( "score" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library

-- local variables are located here
local titleText
local backBtn
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local horizontalOffset = contentWidth * .25
local verticalOffset = contentHeight * .2
local skinSheets = {}
local skinSprites = {}
local lockedText = display.newText( "", 0, 0, "fonts/Rufscript010" ,display.contentHeight * .04)--text informing the user when the next skin is unlocked
local options = {
	width = 64,
	height = 64,
	numFrames = 6
}
--sprite sheet sources for the skins
local spriteSheetsSrc = {
	"imgs/squirrelSprite.png",
	"imgs/albinoSquirrelSheet.png",
	"imgs/ninjaSquirrelSheet.png",
	"imgs/coonSheet.png",
	"imgs/spaceSquirrelSheet.png"
}
--animation sequences for the images in the unlock scene
local sequenceData = {
	{name = "staticImage", frames={1}, time=0, loopCount=1},--sequence when skin not selected
	{name = "movingImage", start=1, count=6, time=500, loopCount=0},--skin of currently selected skin
}
--score's which must be achieved to unlock the respective skins
local unlockScore = {
	0,
	50,
	100,
	150,
	200
}
--load the skin from the skinfile.txt located in the project sandbox
--skins are stored in this file as a digit ranging from 1-n
--the digit to a skin at the respective index equal to the digit
function loadSkin()
	local path = system.pathForFile( "skinfile.txt", system.DocumentsDirectory )
	local contents = ""
	local file = io.open( path, "r" )
	if ( file ) then
		-- read all contents of file into a string
		local contents = file:read( "*a" )
		local skin = tonumber(contents)
		io.close( file )
		if(skin == nil)then
			return 1
		else
			return skin
		end
	else
		return 1
	end
	return 0
end
--save the skin value to the sandbox file
function saveSkin(skin)
	local path = system.pathForFile( "skinfile.txt", system.DocumentsDirectory )
	local file = io.open(path, "w")
	if ( file ) then
		local contents = tostring( skin )
		file:write( contents )
		io.close( file )
		return true
	else
		print( "Error: could not read " )
		return false
	end
end
--check if the user taps a skin; if so save this as our new current skin and animate it
local function tap(event)
	if(event.phase == "began")then
		for i=1, #skinSprites do
			if(event.x > skinSprites[i].x-50 and event.x < skinSprites[i].x+50 and event.y > skinSprites[i].y-50 and event.y < skinSprites[i].y+50)then
				skinSprites[loadSkin()]:setSequence("staticImage")
				skinSprites[loadSkin()]:play()
				skinSprites[i]:setSequence( "movingImage" )
				skinSprites[i]:play()
				saveSkin(i)
			end
		end
	end
end
--return us back to the menu
local function onBackBtn()
	sceneInTransition = true
	composer.gotoScene("menu", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	--composer.getScene("menu"):destroy()
    local sceneGroup = self.view
	titleText = display.newText( "Unlockables", 0, 0, "fonts/Rufscript010" ,display.contentHeight * .065)
	titleText.anchorX = 0
	titleText.anchorY = 0
	sceneGroup:insert(titleText)
	--dynamically create and position all of the unlocked skin sprites on the unlockables page, initializing them to the static sequence
	local i = 1
	while i <= #spriteSheetsSrc and loadScore() >= unlockScore[i] do--ensure that score is checked with every iteration to only provide unlocked choices
		skinSheets[i] = graphics.newImageSheet(spriteSheetsSrc[i], options)
		skinSprites[i] = display.newSprite( skinSheets[i], sequenceData )
		sceneGroup:insert(skinSprites[i])
		skinSprites[i].anchorX = .5
		skinSprites[i].anchorY = .5
		if (i % 3 == 0) then
			skinSprites[i].y = verticalOffset 
			skinSprites[i].x = horizontalOffset * 3
			verticalOffset = verticalOffset + verticalOffset
		else
			skinSprites[i].y = verticalOffset
			skinSprites[i].x = horizontalOffset * (i % 3)
		end
		skinSprites[i].xScale = contentWidth * .003
		skinSprites[i].yScale = contentWidth * .003
		skinSprites[i]:setSequence( "staticImage" )
		skinSprites[i]:play()
		i = i + 1
	end
	--if not all of the skins are unlocked, inform the user what score is needed to unlock the next one
	if (#skinSprites < #spriteSheetsSrc) then
 		lockedText.text =  "Next skin unlocked with a\n high score exceeding: " .. unlockScore[i]
		lockedText.x = contentWidth * .5
		lockedText.y = contentHeight * .75
		sceneGroup:insert(lockedText)
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
		skinSprites[loadSkin()]:setSequence( "movingImage" )--set the currently selected sprite to be animated (there will always be 1 skin animated/selected)
		skinSprites[loadSkin()]:play()
		titleText.isVisible = true
		lockedText.isVisible = true
		backBtn.isVisible = true
		for i=1, #skinSprites do
			skinSprites[i].isVisible = true
		end
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
		lockedText.isVisible = false
		backBtn.isVisible = false
		for i=1, #skinSprites do
			skinSprites[i].isVisible = false
		end
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
	skinSheets = {}
	skinSprites = {}
	titleText:removeSelf()
	titleText = nil
	lockedText:removeSelf()
	lockedText = nil
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
Runtime:addEventListener( "touch", tap)

---------------------------------------------------------------------------------

return scene