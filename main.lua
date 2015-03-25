-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local composer = require "composer"

-- load menu screen
local rect
holding = {}
inUse = {}

composer.gotoScene( "menu" )

--Codes the keys for back button functionality 
local function onKeyEvent(event)
	local phase = event.phase
    local keyName = event.keyName 

    if ( "back" == keyName and phase == "up" ) then
		if ( composer.getCurrentSceneName() == "menu" ) then
        	native.requestExit()
        elseif ( composer.getCurrentSceneName() == "pause" ) then
        	composer.removeScene( "pause" )
			composer.gotoScene( "game", {effect="fromLeft", time=1000}) 
		elseif ( composer.getCurrentSceneName() == "achievements" or 
				 composer.getCurrentSceneName() == "options" 	  or 
				 composer.getCurrentSceneName() == "unlockables") 	then
			composer.gotoScene("menu", {effect="fromRight", time=1000})
		elseif ( composer.getCurrentSceneName() == "gamecredits" or composer.getCurrentSceneName() == "journal") then
			composer.gotoScene("options", {effect="fromRight", time=1000})
        end
		return true	-- indicates successful touch
		
	else 
		return false ; 
	end
	
 
end

Runtime:addEventListener( "key", onKeyEvent )