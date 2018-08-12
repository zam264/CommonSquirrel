local font = "fonts/Rufscript010"
local textOptions = {
    menuTitleTextOptions = {
        text = "Common Squirrel\nRunner",
        x = display.contentWidth * .5,
        y = display.contentHeight * .1,
        font = font,
        fontSize = display.contentHeight * .065,
        align = "center"
    },

    menuHighScoreTextOptions = {
        text = "HighScore",
        x = display.contentWidth * .5,
        y = display.contentHeight * .3,
        font = font,
        fontSize = display.contentHeight * .05,
        align = "center" 
    },

    menuHighScoreNumberOptions = {
        text = loadScore() or 0,
        x = display.contentWidth * .5,
        y = display.contentHeight * .35,
        font = font,
        fontSize = display.contentHeight * .04,
        align = "center" 
    },

    menuTotalDistanceTextOptions = {
        text = "Total Distance",
        x = display.contentWidth * .5,
        y = display.contentHeight * .45,
        font = font,
        fontSize = display.contentHeight * .05,
        align = "center" 
    },

    menuTotalDistanceNumberOptions = {
        text = loadDistance() or 0,
        x = display.contentWidth * .5,
        y = display.contentHeight * .5,
        font = font,
        fontSize = display.contentHeight * .04,
        align = "center" 
    }
}
return textOptions