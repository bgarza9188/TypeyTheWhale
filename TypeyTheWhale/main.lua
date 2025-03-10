local utf8 = require("utf8")

function love.load()
	textXPosition = 0
	randomWhaleXPosition = 0
	randomWhaleYPosition = 25 
    whale = love.graphics.newImage("whale.png")
    text = "Type away! -- "
	textColorBlack = {0, 0, 0}
    -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
    love.keyboard.setKeyRepeat(true)
	local font = love.graphics.getFont()
	coloredText = love.graphics.newText(font, {textColorBlack, text})
end

function love.draw()
    -- love.graphics.printf(text, 0, 0, love.graphics.getWidth())
	love.graphics.draw(coloredText, 10, 10)
    love.graphics.draw(whale, randomWhaleXPosition, randomWhaleYPosition)
	local r, g, b = love.math.colorFromBytes(132, 193, 238)
	love.graphics.setBackgroundColor(r, g, b)
end

function love.textinput(t)
	randomWhaleXPosition = math.random(love.graphics.getWidth())
	randomWhaleYPosition = math.random(love.graphics.getHeight())
	textXPosition = textXPosition + coloredText:getWidth()
    coloredText:add({textColorBlack, t}, textXPosition)
	text = text .. t
end

function love.keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
		coloredText:set({textColorBlack, text})
		textXPosition = 0
    end
end