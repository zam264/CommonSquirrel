--[[
This file handles the saving of settings to a sandbox file on the users phone
All settings (sound, movement, and vibration) are saved so that the settings are remembered from after exiting the screen.
]]
--This function takes for a parameter all the current setting values and saves it to a file called settings.txt on the phone
function saveSettings(effects, music, swipe, vibration) 
	local path = system.pathForFile( "settings.txt", system.DocumentsDirectory )
	local file = io.open(path, "w")
	if ( file ) then
		local contents = tostring( effects ).."\n"..tostring( music ).."\n"..tostring(swipe).."\n"..tostring(vibration)
		file:write( contents )
		io.close( file )
		return true
	else
		print( "Error: could not read " )
		return false
	end
end

--This function loads the settings.txt file and updates the settings variables appropriately 
function loadSettings() 
	local path = system.pathForFile( "settings.txt", system.DocumentsDirectory )
	local contents = ""
	local file = io.open( path, "r" )
	if ( file ) then
		-- read all contents of file into a string
		local contents = file:read()
		effectsVolume = tonumber(contents)
		contents = file:read() 
		musicVolume = tonumber(contents)
		contents = file:read()
		if contents == "true" then 
			swipeMovement = true 
		else 
			swipeMovement = false 
		end 
		contents = file:read()
		if contents == "true" then 
			vibrate = true 
		else
			vibrate = false
		end
		io.close( file )
		if swipeMovement == nil then
			swipeMovement = false 
		end
		if effectsVolume == nil then 
			effectsVolume = 50 
		end 
		if musicVolume == nil then 
			musicVolume = 50 
		end 
		if vibration == nil then 
			vibrate = true
		end
	else
		print( "Error: could not read scores")
	end
	return 0
end