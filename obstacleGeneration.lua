local emptyCols = {}
function generateObstacles(collection)
	--print("Calling generate")
	for i = 0, 4 do 
		if i > 0 then 
			if i == 1 then 
				generateRow(0, 50, 50, countEmptyCols(), i, collection)
			else
				numEmpty = countEmptyCols()
				if numEmpty == 1 then
					generateRow(10, 80, 10, numEmpty, i, collection)
				elseif numEmpty == 2 then 
					generateRow(0, 50, 50, numEmpty, i, collection)
				else 
					generateRow(0, 35, 65, numEmpty, i, collection)
				end
			end
		else 
			emptyCols[1] = true
			emptyCols[2] = true
			emptyCols[3] = true
		end
	end
end

function generateRow(chance0, chance1, chance2, empty, row, collection) 
	local random = math.random(100) 
	if random < chance0 then --place nothing
		emptyCols[1] = true
		emptyCols[2] = true
		emptyCols[3] = true
	elseif random < chance0 + chance1 then -- place 1 obstacle
		if empty == 1 then 
			random = math.random(3)
			if emptyCols[random] == false then 
				newObstacle(row, random, collection)
			else 
				newObstacle(row, ((random + math.random(0,1)) % 3 ) + 1, collection)
			end
		end
	else -- place 2 obstacles
		if numEmpty == 1 then
			for i=1, #emptyCols do
				if ( not emptyCols[i]) then
					newObstacle(row, i, collection)
				end
			end

		elseif numEmpty == 2 then
			for i=1, #emptyCols do
				if ( not emptyCols[i]) then
					newObstacle(row, i, collection)
					newObstacle(row, ((i + math.random(0,1)) % 3 ) + 1, collection)
				end
			end
		else
			random = math.random(3)
			-- put obstacle at random
			newObstacle(row, ((random + math.random(0,1)) % 3 ) + 1, collection)
		end
	end 
	--Return array of 3 (columns)
end

function countEmptyCols()
	local count = 0 
	for i = 1, 3 do 
		if emptyCols[i] then 
			count = count + 1 
		end
	end
	return count 
end

--Generates a new obstacle at the row/col passed
function newObstacle(row, col, collection)
	yPos = row*display.contentWidth*.25 - display.contentHeight
	local obj
	--An obstacle has ~% chance of being an Acorn 
	local random = math.random(100)
	if random <= 10 then 
		obj = Acorn(display.contentWidth * .25 * col, yPos)
	else
		obj = Obstacle( display.contentWidth * .25 * col, yPos)
	end
	physics.addBody(obj.model, "dynamic", {isSensor=true})
	table.insert(collection, obj)
	
	return obj
end