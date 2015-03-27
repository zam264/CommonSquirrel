-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local composer = require "composer"

sceneInTransition = false

composer.gotoScene( "menu" )

--Codes the keys for back button functionality 
local function onKeyEvent(event)
	local phase = event.phase
    local keyName = event.keyName 

	if ( "back" == keyName and phase == "up" and  not sceneInTransition) then
		if ( composer.getCurrentSceneName() == "menu" ) then
			native.requestExit()
		elseif ( composer.getCurrentSceneName() == "pause" ) then
			composer.removeScene( "pause" )
			composer.gotoScene( "game", {effect="fromLeft", time=1000}) 
		elseif ( composer.getCurrentSceneName() == "achievements" or 
				 composer.getCurrentSceneName() == "options" 	  or 
				 composer.getCurrentSceneName() == "unlockables"  or 
				 composer.getCurrentSceneName() == "journal") 	then
			composer.gotoScene("menu", {effect="fromRight", time=1000})
		elseif ( composer.getCurrentSceneName() == "gamecredits") then
			composer.gotoScene("options", {effect="fromRight", time=1000})
		end
	end
	
	return true
end

Runtime:addEventListener( "key", onKeyEvent )