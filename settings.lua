function saveSettings(effects, music, swipe) 
	local path = system.pathForFile( "settings.txt", system.DocumentsDirectory )
	local file = io.open(path, "w")
	if ( file ) then
		local contents = tostring( effects ).."\n"..tostring( music ).."\n"..tostring(swipe)
		file:write( contents )
		io.close( file )
		return true
	else
		print( "Error: could not read " )
		return false
	end
end

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
	else
		print( "Error: could not read scores")
	end
	return 0
end