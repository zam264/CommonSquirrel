local composer = require( "composer" )

function onPlayBtn()
    -- enter the game screen
	audio.stop(1)
	sceneInTransition = true
	composer.gotoScene( "game", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end

function onAchievementsButton()
    -- go to the achievements screen
	sceneInTransition = true
	composer.gotoScene( "achievements", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end

function onUnlockablesButton()
    -- go to the unlockable skins screen
	sceneInTransition = true
	composer.gotoScene( "unlockables", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end

function onOptionsBtn()
    -- go to ghe options screen
	sceneInTransition = true
	composer.gotoScene( "options", {effect="fromLeft", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end

function onJournalBtn()
    -- go to ghe journal screen
	sceneInTransition = true
	composer.gotoScene( "journal", {effect="fromRight", time=1000})
	timer.performWithDelay (1000, function() sceneInTransition = false end)
	return true	-- indicates successful touch
end