function loadScore ()
	local path = system.pathForFile( "scorefile.txt", system.DocumentsDirectory )
	local contents = ""
	local file = io.open( path, "r" )
	if ( file ) then
		-- read all contents of file into a string
		local contents = file:read( "*a" )
		local score = tonumber(contents)
		io.close( file )
		if score == nil then
			return 0
		else
			return score
		end
	else
		print( "Error: could not read scores")
	end
	return 0
end

function saveScore (score)
	if (tonumber(score) > tonumber(loadScore())) then
		local path = system.pathForFile( "scorefile.txt", system.DocumentsDirectory )
		local file = io.open(path, "w")
		if ( file ) then
			local contents = tostring( score )
			file:write( contents )
			io.close( file )
			return true
		else
			print( "Error: could not read " )
			return false
		end
	end
end




function loadDistance()
	local path = system.pathForFile( "distancefile.txt", system.DocumentsDirectory )
	local contents = ""
	local file = io.open( path, "r" )
	if ( file ) then
		print("read open")
		-- read all contents of file into a string
		local contents = file:read( "*a" )
		local distance = tonumber(contents)
		io.close( file )
		return distance
	else
		print( "Error: could not read scores")
	end
	return 0
end


function addToDistance(dist)
	local currentTotal = loadDistance() or 0
	local newTotal = currentTotal + dist
	
	local path = system.pathForFile( "distancefile.txt", system.DocumentsDirectory )
	local file = io.open(path, "w")
	if ( file ) then
		local contents = tostring( newTotal )
		file:write( contents )
		io.close( file )
		return true
	else
		print( "Error: could not read " )
		return false
	end
end