--This function randomly generates obstacles and unique items and adds them to the passed collection array 
--The collection array is the array which all the items currently on the trees are stored in 
function generateObstacles(collection)
	local rand = math.random(10)  --Generate a random # 1-10 
	local obstacle 
	if rand <= 2 then    --If the number is 1 or 2 (so 20% chance) create a unique item instead of an obstacle
		obstacle = createItem()
	elseif				--Create an obstacle the other 80% of the time
		obstacle = createObstacle()
	end
	table.insert(collection, obstacle)  --Insert the item created into the array 
end
--Creates an obstacle on one of the three trees randomly 
function createObstacle()
	local yPos = -150
	local col = math.random(3)
	--X Pos is determined by col which is randomly generated # between 1 and 3, representing the three trees
	--The tree number times 1/4*contentWidth places the item onto the tree properly 
	--Y Pos is slighlty off screen (the obstacles will be moved down in game.lua)
	local obj = Obstacle( display.contentWidth * .25 * col, yPos)   --Creates an obstacle that damages the player (see Obstacle Class for more info)
	physics.addBody(obj.model, "dynamic", {isSensor=true})  --Add physics to this item so that collision can be detected 
	return obj
end
--Create either a unique item or leave the space blank (50% chance of unique item)
function createItem()
	local rand = math.random(4)
	local yPos = -150
	local obj
	if rand > 3 then
		local col = math.random(3)    --Randomly pick one of the three trees to place item on (same as in createObstacle)
		obj = Acorn(display.contentWidth * .25 * col, yPos)	  --Creates a unique item (see Acorn Class for more info)
		physics.addBody(obj.model, "dynamic", {isSensor=true})		
	end
	return obj
end

--[[
--OLD OBSTACLE GENERATION --- NOT USED
function generateObstacles(collection)
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
	if random <= 3 then 
		obj = Acorn(display.contentWidth * .25 * col, yPos)
	else
		obj = Obstacle( display.contentWidth * .25 * col, yPos)
	end
	physics.addBody(obj.model, "dynamic", {isSensor=true})
	table.insert(collection, obj)
	
	return obj
end
]]--