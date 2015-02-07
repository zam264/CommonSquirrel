function loadScore ()
   local path = system.pathForFile( "scorefile.txt", system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
		print("read open")
      -- read all contents of file into a string
      local contents = file:read( "*a" )
      local score = tonumber(contents)
      io.close( file )
	return score
   else
      print( "Error: could not read scores")
   end
   return nil
end

function saveScore (score)
	if (score > loadScore()) then
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
	return nil
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