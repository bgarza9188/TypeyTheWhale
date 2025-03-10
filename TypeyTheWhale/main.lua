local utf8 = require("utf8")
local whaleCenterX = 157
local whaleCenterY = 116
local rateOfSwim = 35

function love.load()
	love.window.setTitle("Typey the Whale")
	textXPosition = 0
	centerX = love.graphics.getWidth() / 2
	centerY = love.graphics.getHeight() / 2
	currentWhaleXPosition = centerX - whaleCenterX -- minus because the window starts at 0,0 in the top left
	currentWhaleYPosition = centerY - whaleCenterY
    whale = love.graphics.newImage("whale.png")
	textColorBlack = {0, 0, 0}
	local font = love.graphics.getFont()
	promptText = love.graphics.newText(font, {textColorBlack, "Help Typey the Whale swim as fast as you can type! Press 'Space' to Start!"})
	coloredText = love.graphics.newText(font, {textColorBlack, "..."})
	local r, g, b = love.math.colorFromBytes(132, 193, 238) -- light blue
	love.graphics.setBackgroundColor(r, g, b)
end

function love.draw()
	love.graphics.draw(promptText, 10, 10)
	love.graphics.draw(coloredText, 10, 30)
    love.graphics.draw(whale, currentWhaleXPosition, currentWhaleYPosition)
end

function love.textinput(t)
	textXPosition = textXPosition + coloredText:getWidth()
	if t ~= " " then
		coloredText:add({textColorBlack, t}, textXPosition)
	end
end

function love.update(dt)
   if love.keyboard.isDown("space") then
		-- move the whale back into frame if it gets too close to edge of window
		if currentWhaleXPosition > love.graphics.getWidth() or currentWhaleXPosition < 0 then
			currentWhaleXPosition = whaleCenterX
		end
		if currentWhaleYPosition > love.graphics.getHeight() or currentWhaleYPosition < 0 then
			currentWhaleYPosition = whaleCenterY
		end
		-- calculate a new postion for the whale to move to, move by 25 pixels each update
		currentWhaleXPosition = currentWhaleXPosition + ((25 * math.random(-1, 1)) * (rateOfSwim * dt))
		currentWhaleYPosition = currentWhaleYPosition + ((25 * math.random(-1, 1)) * (rateOfSwim * dt))
   end
end

function love.keypressed(key)
    if key == "space" then
	   textXPosition = 0
	   coloredText:set({textColorBlack, ""})
    end
end