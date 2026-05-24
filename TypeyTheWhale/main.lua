-- Typey the Whale is a Love2D typing game for windows written by Ben Garza
local utf8 = require("utf8")
local whaleCenterX = 157
local whaleCenterY = 116
local rateOfSwim = 60
-- Table aka 'array' start from 1
local wordsToType = { "the", "be", "to", "of", "and", "a", "in", "that", "have", "I", "help", "me", "please", "also", "because", "window", "chair", "type", "whale", "swim", "fast", "win" }
local listOfKeys = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' }
local typedInWord = "..."
local currentPromptText = "Help Typey the Whale swim as fast as you can type! Press 'Space' to Start!"

function love.load()
	love.window.setTitle("Typey the Whale")
	textXPosition = 0
	centerX = love.graphics.getWidth() / 2
	centerY = love.graphics.getHeight() / 2
	currentWhaleXPosition = centerX - whaleCenterX -- minus because the window starts at 0,0 in the top left
	currentWhaleYPosition = centerY - whaleCenterY
    whale = love.graphics.newImage("whale.png")
	textColorBlack = {0, 0, 0}
	textColorRed = {255, 0, 0}
	local font = love.graphics.newFont(20, "mono")
	promptText = love.graphics.newText(font, {textColorBlack, currentPromptText})
	coloredText = love.graphics.newText(font, {textColorBlack, typedInWord})
	wrongPromptText = love.graphics.newText(font, { textColorRed, ""})
	local r, g, b = love.math.colorFromBytes(132, 193, 238) -- light blue
	love.graphics.setBackgroundColor(r, g, b)
	love.keyboard.setTextInput(true)
end

function love.draw()
	love.graphics.draw(promptText, 10, 10)
	love.graphics.draw(coloredText, 10, 30)
	love.graphics.draw(wrongPromptText, 10, 50)
    love.graphics.draw(whale, currentWhaleXPosition, currentWhaleYPosition)
end

function love.textinput(t)
	textXPosition = textXPosition + coloredText:getWidth()
	if t ~= " " then -- ~= means 'Not Equal'
		typedInWord = typedInWord .. t
		coloredText:add({textColorBlack, t}, textXPosition)
	end
end

function love.update(dt)
   if love.keyboard.isDown(listOfKeys) then
		-- move the whale back into frame if it gets too close to edge of window
		if currentWhaleXPosition > love.graphics.getWidth() or currentWhaleXPosition < 0 then
			currentWhaleXPosition = whaleCenterX
		end
		if currentWhaleYPosition > love.graphics.getHeight() or currentWhaleYPosition < 0 then
			currentWhaleYPosition = whaleCenterY
		end
		-- calculate a new position for the whale to move to
		currentWhaleXPosition = currentWhaleXPosition + (25 * math.random(-1, 1) * (rateOfSwim * dt))
		currentWhaleYPosition = currentWhaleYPosition + (25 * math.random(-1, 1) * (rateOfSwim * dt))
   end
end

function love.keypressed(key)
	if key == "space" then
		textXPosition = 0 -- Reset position of 'cursor'
		coloredText:clear() -- Reset drawn input text
		if typedInWord == "..." or typedInWord == currentPromptText then
			currentPromptText = wordsToType[math.random(#wordsToType)] -- Pick new prompt to type
			promptText:set({textColorBlack, currentPromptText})
			wrongPromptText:clear()
		else
			wrongPromptText:set({textColorRed, "WRONG TRY AGAIN!"})
		end
		typedInWord = "" -- Reset Typed in word
	end
end