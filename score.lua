--[[
score.lua
William Botzer
]]--

--------------------------------------------
--loadScore()
--returns the saved score from the system document directory
--return 0 if it finds no scorefile.txt
--------------------------------------------
function loadScore ()
	local path = system.pathForFile( "scorefile.txt", system.DocumentsDirectory )
	local contents = ""
	local file = io.open( path, "r" )	-- open the scorefile.txt for reading
	if ( file ) then	-- if the file opens correctly
		local contents = file:read( "*a" )	-- read all contents of file into a string
		local score = tonumber(contents)	
		io.close( file )		-- close scorefile.txt
		if score == nil then	-- if the file opens but it's contents are empty
			return 0
		else
			return score
		end
	else	-- scorefile.txt fails to open
		print( "Error: could not read scores")
	end
	return 0	-- return 0 for the default base score (keeps everything running w/o crashing)
end

--------------------------------------------
--saveScore (int)
--takes a value and saves it to scorefile.txt in the system's document directory
--overwrite previous scores
--creates scorefile.txt if it doesn't exists
--------------------------------------------
function saveScore (score)
	local highscore = tonumber(loadScore())	-- get the highscore
	if (tonumber(score) > highscore or tonumber(score)==0) then	-- if the passed score beats the old highscore
		local path = system.pathForFile( "scorefile.txt", system.DocumentsDirectory )
		local file = io.open(path, "w")		-- open scorefile.txt for writing
		if ( file ) then	-- if scorefile.txt opens
			local contents = tostring( score )	-- convert score to a string
			file:write( contents )	-- write the converted score to scorefile.txt
			io.close( file )		-- close scorefile.txt
			return true
		else
			print( "Error: could not write score" )
			return false
		end
	end
end


--------------------------------------------
--loadDistance()
--returns the saved total distance from the system document directory
--return 0 if it finds no distancefile.txt
-- (  similar to loadScore()  )
--------------------------------------------
function loadDistance()
	local path = system.pathForFile( "distancefile.txt", system.DocumentsDirectory )
	local contents = ""
	local file = io.open( path, "r" )	-- open distancefile.txt for reading
	if ( file ) then	-- if distancefile.txt opens correctly
		local contents = file:read( "*a" )	-- read all contents of file into a string
		local distance = tonumber(contents)	-- convert the string to a number
		io.close( file )	-- close distancefile.txt
		return distance		-- return total distance
	else
		print( "Error: could not read distance")
	end
	return 0	-- return 0 for the default base distance (keeps everything running w/o crashing)
end

--------------------------------------------
--addToDistance(float)
--adds the passed distance to the total distance
--  and saves it to the distancefile.txt
--------------------------------------------
function addToDistance(dist)
	local currentTotal = loadDistance() or 0	-- get the total distance or 0 if the loadDistance() screws up (which it shouldn't)
	local newTotal = currentTotal + dist		-- add the passed distance to the current total
	
	local path = system.pathForFile( "distancefile.txt", system.DocumentsDirectory )
	local file = io.open(path, "w")	-- open the distancefile for writing
	if ( file ) then	-- if the file opens
		local contents = tostring( newTotal )	-- convert the new total to a string
		file:write( contents )	-- write the converted distance
		io.close( file )	-- close the distancefile
		return true
	else
		print( "Error: could not write distance" )
		return false
	end
end