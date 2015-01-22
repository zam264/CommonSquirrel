--[[



]]--

local Score = {}

function Score.save(score)
   local path = system.pathForFile( scorefile.txt, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring(score)
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not record highscore ", M.filename, "." )
      return false
   end
end


function Score.load()
	sortScores()

   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local file = io.open( path, "r" )
   if ( file ) then
		local scores = {}
		for line in file:lines() do
			scores[line] = tostring(line)
		end
		io.close( file )
		return scores
      -- read all contents of file into a string  
	  --[[
      local contents = file:read( "*a" )
      local score = tonumber(contents);
      io.close( file )
      return score--]]
   else
      print( "Error: could not read scores from ", M.filename, "." )
   end
   return nil
end

function Score.sortScores()
	local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local file = io.open( path, "r" )
   if ( file ) then
		local scores = {}
		for line in file:lines() do
			scores[line] = tostring(line)
		end
		io.close( file )
   else
      print( "Error: could not read scores from ", M.filename, "." )
   end

   table.sort(scores)
   
   local path = system.pathForFile( scorefile.txt, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
		for file:lines(), file:lines()-5 do
			file:write( scores[x] )
		end
		io.close( file )
   else
      print( "Error: could not record highscore ", M.filename, "." )
   end
end