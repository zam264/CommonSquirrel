local function newRect(params)
	local rect = display.newRect(params.xpos, params.ypos, params.width, params.height)
	rect:setFillColor(params.r, params.g, params.b, 255)
	rect.xdir = params.xdir
	rect.ydir = params.ydir
	
	return rect
end

local params = {
	{xpos=display.contentWidth*0.25, ypos=display.contentHeight*.25, width=50, height=50, xdir=1, ydir=1, r=255, g=0, b=0},
	{xpos=display.contentWidth*0.5, ypos=display.contentHeight*.5, width=50, height=50, xdir=1, ydir=1, r=255, g=0, b=0},
	{xpos=display.contentWidth*0.75, ypos=display.contentHeight*.75, width=50, height=50, xdir=1, ydir=1, r=255, g=0, b=0},
	{xpos=0, ypos=1100, width=50, height=50, xdir=0, ydir=0, r=0, g=255, b=0}
}

local collection = {}

for _,item in ipairs(params) do
	local rect = newRect(item)
	collection[#collection + 1] = rect
end

local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX

function collection:enterFrame(event)
	for _,rect in ipairs(collection) do
		local dx = (0*rect.xdir)
		local dy = (10*rect.ydir)
		local xNew, yNew = rect.x + dx, rect.y + dy
		local player = table.maxn(collection)
		
		local width, height = rect.width, rect.height
		if(yNew > screenBottom - height/2 or yNew < screenTop + height/2) then
			--rect.ydir = -rect.ydir
			rect.y = 25
		elseif(rect.x == collection[player].x and rect.y+50 > collection[player].y and rect.y < collection[player].y+50 and rect ~= collection[player])then
			collection[player].x = 0
		end
		
		rect:translate(dx, dy)
	end
end

local function printTouch(event)
	print("event: " .. event.phase .. "\n x: " .. event.x .. "\n y: " .. event.y)
	print("array size:" .. table.maxn(collection))
	local player = table.maxn(collection)
	if(event.phase == "began")then
		if(event.x > display.contentWidth*0.5 and collection[player].x <= display.contentWidth*0.5)then
			collection[player].x = collection[player].x + display.contentWidth*0.25
		elseif(event.x < display.contentWidth*0.5 and collection[player].x >= display.contentWidth*0.5)then
			collection[player].x = collection[player].x - display.contentWidth*0.25	
		end	
	end	
end

Runtime:addEventListener( "enterFrame", collection )
Runtime:addEventListener( "touch", printTouch)