local font = "fonts/Rufscript010"
require("btnActions")

local btnOptions = {
    menuPlayBtnOptions = {
        label = "Play",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .1,
		labelColor = { 
            default = { 255 }, 
            over = { 128}  
        },
		defaultFile = "imgs/button.png",
		overFile = "imgs/button-over.png",
        width = display.contentWidth, 
        height = display.contentHeight * .125,
        onRelease = onPlayBtn,
        x = display.contentWidth * .5,
        y = display.contentHeight * .7
    },
    
    menuAchievementsBtnOptions = {
		label = "Achievements",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default = { 255 }, 
            over = { 128 } 
        },
		defaultFile = "imgs/button.png",
		overFile = "imgs/button-over.png",
        width = display.contentWidth * .5, 
        height = display.contentHeight * .1,
        onRelease = onAchievementsButton,
        x = display.contentWidth * .25,
        y = display.contentHeight * .8      
    },

    menuUnlockablesBtnOptions = {
		label = "Unlockables",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default = { 255 }, 
            over = { 128 } 
        },
		defaultFile ="imgs/button.png",
		overFile ="imgs/button-over.png",
        width = display.contentWidth * .5,
        height = display.contentHeight * .1,
        onRelease = onUnlockablesButton,
        x = display.contentWidth * .75,
        y = display.contentHeight * .9
    },

    menuJournalBtnOptions = {
        label = "Squirrel Journal",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default = { 255 }, 
            over = { 128 } 
        },
		defaultFile = "imgs/button.png",
		overFile = "imgs/button-over.png",
        width = display.contentWidth * .5, 
        height = display.contentHeight * .1,
        onRelease = onJournalBtn,
        x = display.contentWidth * .75,
        y = display.contentHeight * .8
    },

    menuOptionsBtnOptions = {
        label = "Options",
		font = "fonts/Rufscript010",
		fontSize = display.contentWidth * .05,
		labelColor = { 
            default={ 255 }, 
            over={ 128 } 
        },
		defaultFile = "imgs/button.png",
		overFile = "imgs/button-over.png",
        width = display.contentWidth * .5, 
        height = display.contentHeight * .1,
        onRelease = onOptionsBtn,
        x = display.contentWidth * .25,
        y = display.contentHeight * .9
    }
}
return btnOptions