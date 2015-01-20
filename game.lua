local composer = require( "composer" )
require('ObstacleClass')
local scene = composer.newScene()
--display.setStatusBar( display.HiddenStatusBar )


--Variables
local screenTop, screenBottom, screenLeft, screenRight
local player

local bg = display.newImageRect( "imgs/bg1.jpg", 1080, 1920 )
bg.x = display.contentCenterX
bg.y = display.contentHeight
local bg1 = display.newImageRect( "imgs/bg1.jpg", 1080, 1920 )
bg1.x = display.contentCenterX
bg1.y = 0


local function newRect(yPos)
	local obj = Obstacle( display.contentWidth * math.random(3)*.25, yPos-math.random(display.contentHeight*.2))
	
	return obj
end
local function moveRight() 
	if (player.x < display.contentWidth * .75) then
		player.x = player.x + display.contentWidth*0.25
	end
end
local function moveLeft() 
	if (player.x > display.contentWidth * .25) then
		player.x = player.x - display.contentWidth*0.25	
	end
end
local function printTouch(event)
	print("event: " .. event.phase .. "\n x: " .. event.x .. "\n y: " .. event.y)
	if(event.phase == "began")then
		if(event.x > display.contentWidth*0.55)then
			moveRight()
		elseif(event.x < display.contentWidth*0.45)then
			moveLeft()
		end	
	end	
end




local collection = {}

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
	screenTop = display.screenOriginY
	screenBottom = display.viewableContentHeight + display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.viewableContentWidth + display.screenOriginX
	
	for n=1, 9 do
		table.insert(collection , newRect(-1 *n*display.contentHeight*.2))
	end
	
	player = display.newRect( display.contentWidth*.5, display.contentHeight*.75, display.contentWidth*.1, display.contentWidth*.125 )
end

function collection:enterFrame(event)
	if(bg.y-960 > display.contentHeight)then 
		bg.y = -960
	elseif(bg1.y-960 > display.contentHeight)then	
		bg1.y = -960
	else
		bg:translate(0, 3)
		bg1:translate(0, 3)
	end

	for x=1,  #collection do
		collection[x].model.y = collection[x].model.y + 10 + collection[x].speedModifier
		if (collection[x].model.y > display.contentHeight +200) then
			-- kill rectangle
			--collection[x].delete()
			-- spawn new one
			--newRect(params)
			
			table.insert(collection , newRect(-100))
			table.remove(collection, x)
			x = x-1
		end
		--collection[x]:translate(0,)
		
		
	end
	
	print (#collection)
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
Runtime:addEventListener( "enterFrame", collection )
Runtime:addEventListener( "touch", printTouch)

---------------------------------------------------------------------------------

return scene


