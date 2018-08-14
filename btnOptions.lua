local font = "fonts/Rufscript010"
local defaultFile = "imgs/button.png"
local overFile = "imgs/button-over.png"
require("btnActions")

local btnOptions = {
    menuPlayBtnOptions = {
        label = "Play",
		font = font,
		fontSize = display.contentWidth * .1,
		labelColor = { 
            default = { 255 }, 
            over = { 128 }  
        },
		defaultFile = defaultFile,
		overFile = overFile,
        width = display.contentWidth, 
        height = display.contentHeight * .125,
        onRelease = onPlayBtn,
        x = display.contentWidth * .5,
        y = display.contentHeight * .7
    },
    
    menuAchievementsBtnOptions = {
		label = "Achievements",
		font = font,
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default = { 255 }, 
            over = { 128 } 
        },
		defaultFile = defaultFile,
		overFile = overFile,
        width = display.contentWidth * .5, 
        height = display.contentHeight * .1,
        onRelease = onAchievementsButton,
        x = display.contentWidth * .25,
        y = display.contentHeight * .8      
    },

    menuUnlockablesBtnOptions = {
		label = "Unlockables",
		font = font,
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default = { 255 }, 
            over = { 128 } 
        },
		defaultFile =defaultFile,
		overFile = overFile,
        width = display.contentWidth * .5,
        height = display.contentHeight * .1,
        onRelease = onUnlockablesButton,
        x = display.contentWidth * .75,
        y = display.contentHeight * .9
    },

    menuJournalBtnOptions = {
        label = "Squirrel Journal",
		font = font,
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default = { 255 }, 
            over = { 128 } 
        },
		defaultFile = defaultFile,
		overFile = overFile,
        width = display.contentWidth * .5, 
        height = display.contentHeight * .1,
        onRelease = onJournalBtn,
        x = display.contentWidth * .75,
        y = display.contentHeight * .8
    },

    menuOptionsBtnOptions = {
        label = "Options",
		font = font,
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default={ 255 }, 
            over={ 128 } 
        },
		defaultFile = defaultFile,
		overFile = overFile,
        width = display.contentWidth * .5, 
        height = display.contentHeight * .1,
        onRelease = onOptionsBtn,
        x = display.contentWidth * .25,
        y = display.contentHeight * .9
    }
}
return btnOptions