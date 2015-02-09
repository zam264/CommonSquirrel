function generateObstacles(collection)
	--print("Calling generate")
	for x=1,  #collection do
		collection[x].model.y = collection[x].model.y + 10 + collection[x].speedModifier
		if (collection[x].model.y > display.contentHeight +200) then
			-- kill rectangle
			collection[x]:delete()
			-- spawn new one
			--newRect(params)
			print("Exiting stage")
			table.insert(collection , newRect(-100))
			table.remove(collection, x)
			x = x-1
		end
		--collection[x]:translate(0,)
	end
end