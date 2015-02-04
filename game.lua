local composer = require( "composer" )
local physics = require("physics")
require('ObstacleClass')
require('PlayerClass')
local scene = composer.newScene()
--display.setStatusBar( display.HiddenStatusBar )


--Variables
local screenTop, screenBottom, screenLeft, screenRight
local player
local bgImg = "imgs/bg1.jpg"
local bg = display.newImageRect( bgImg, display.contentWidth, display.contentHeight )
bg.x = display.contentCenterX
bg.y = display.contentHeight
local bg1 = display.newImageRect( bgImg, display.contentWidth, display.contentHeight )
bg1.x = display.contentCenterX
bg1.y = 0

local tutorial tut = display.newImageRect("imgs/tutorial.png", display.contentWidth, 100)
tut.x = display.contentCenterX
tut.y = display.contentHeight-50


local function newRect(yPos)
	local obj = Obstacle( display.contentWidth * math.random(3)*.25, yPos-math.random(display.contentHeight*.2))
	physics.addBody(obj.model, "dynamic", {isSensor=true})
	
	return obj
end
local function moveRight() 
	if (player.model.x < display.contentWidth * .75) then
		if (player.model.x < display.contentWidth * .5) then
			transition.to(player.model, {time=200, x=display.contentWidth*0.5})
		else
			transition.to(player.model, {time=200, x=display.contentWidth*0.75})
		end
	end
end
local function moveLeft() 
	if (player.model.x > display.contentWidth * .25) then
		if (player.model.x > display.contentWidth * .5) then
			transition.to(player.model, {time=200, x=display.contentWidth*0.5})
		else
			transition.to(player.model, {time=200, x=display.contentWidth*0.25})
		end
	end
end

local function printTouch(event)
	--print("event: " .. event.phase .. "\n x: " .. event.x .. "\n y: " .. event.y)
	if(event.phase == "began")then
		if(event.x > display.contentWidth*0.5)then
			moveRight()
		elseif(event.x < display.contentWidth*0.5)then
			moveLeft()
		end	
	end	
end

local collection = {}

--Function handles player collision
--When the player collides with an "obstacle" they should lose health 
local function hitObstacle(self, event)
	if event.phase == "began" then
		--print(player.health)
		player:damage(1)
		if player.health == 0 then 
			print("Dead") 
			--Do Death stuff here 
		end
	end
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   	physics.start()
   	physics.setGravity(0,0)
	screenTop = display.screenOriginY
	screenBottom = display.viewableContentHeight + display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.viewableContentWidth + display.screenOriginX
	
	for n=1, 9 do
		table.insert(collection , newRect(-1 *n*display.contentHeight*.2))
	end
	
	--player = display.newRect( display.contentWidth*.5, display.contentHeight*.75, display.contentWidth*.1, display.contentWidth*.125 )
	player = Player(display.contentWidth*.5, display.contentHeight*.75)
	--Add collision detection to player object
	player.model.collision = hitObstacle
	player.model:addEventListener("collision", player.model)
	physics.addBody(player.model, "dynamic",{isSensor=true})
end

function collection:enterFrame(event)
	--Scrolling background
	if(bg.y > display.contentHeight*1.5)then 
		bg.y = display.contentHeight*-0.5
	elseif(bg1.y > display.contentHeight*1.5)then	
		bg1.y = display.contentHeight*-0.5
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
	
	--print (#collection)
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


