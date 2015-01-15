--display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "background", 80/255 )
local bg = display.newImageRect( "bg1.jpg", 1080, 1920 )
bg.x = display.contentCenterX
bg.y = display.contentHeight
local bg1 = display.newImageRect( "bg1.jpg", 1080, 1920 )
bg1.x = display.contentCenterX
bg1.y = 0


local function newRect(params)
	local rect = display.newRect(params.xpos, params.ypos, params.width, params.height)
	rect:setFillColor(params.r, params.g, params.b, 255)
	rect.xdir = params.xdir
	rect.ydir = params.ydir
	rect.speed = params.speed
	
	return rect
end


local w = 100
local h = 100
local s = 1
local y = 10
local params = {
	{xpos=display.contentWidth*0.25, ypos=display.contentHeight*.25, width=w, height=h, ydir=y, r=255, g=0, b=0, speed=s},
	{xpos=display.contentWidth*0.5, ypos=display.contentHeight*.5, width=w, height=h, ydir=y, r=255, g=0, b=0, speed=s},
	{xpos=display.contentWidth*0.75, ypos=display.contentHeight*.75, width=w, height=h, ydir=y, r=255, g=0, b=0, speed=s},
	{xpos=0, ypos=display.contentHeight*0.85, width=w, height=h, ydir=0, r=0, g=255, b=0, speed=0}
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
	if(bg.y-960 > display.contentHeight)then 
		bg.y = -960
	elseif(bg1.y-960 > display.contentHeight)then	
		bg1.y = -960
	else
		bg:translate(0, 3)
		bg1:translate(0, 3)
	end

	for _,rect in ipairs(collection) do
		local dy = (rect.ydir*rect.speed)
		local yNew = rect.y + dy
		local player = table.maxn(collection)
		local width, height = rect.width, rect.height

		if(yNew > screenBottom - height/2 ) then
			rect.y = -50
			rect.speed = math.random( 1, 10 )/10+1
		elseif(rect.x == collection[player].x and rect.y+50 > collection[player].y-50 and rect.y-50 < collection[player].y+50 and rect ~= collection[player])then
			collection[player].x = 0
		end

		rect:translate(0, dy)
	end
end

local function printTouch(event)
	print("event: " .. event.phase .. "\n x: " .. event.x .. "\n y: " .. event.y)
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