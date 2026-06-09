-- Typey the Whale is a Love2D typing game for windows written by Ben Garza
local utf8 = require("utf8")
local whaleCenterX = 157
local whaleCenterY = 116
-- Table aka 'array' start from 1
local wordsToType = { "then", "before", "swimmer", "often", "after", "another", "into", "that", "have", "innocent", "help", "me", "please", "also", "because", "window", "chair", "type", "whale", "swim", "fast", "win", "slow", "water" }
local listOfKeys = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' }
local typedInWord = "..."
local currentPromptText = "Help Typey the Whale swim as fast as you can type! Press 'Space' to Start!"
local textColorBlack = {0, 0, 0}
local textColorRed = {255, 0, 0}
local isDead = false

function love.load()
	love.window.setTitle("Typey the Whale")
	love.window.setMode(800, 800)
	textXPosition = 0
	centerX = love.graphics.getWidth() / 2
	centerY = love.graphics.getHeight() / 2
	currentWhaleXPosition = centerX - whaleCenterX -- minus because the window starts at 0,0 in the top left
	currentWhaleYPosition = centerY - whaleCenterY
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	ball = {}
	ball.body = love.physics.newBody(world, currentWhaleXPosition, currentWhaleYPosition, "dynamic")
	ball.shape = love.physics.newCircleShape(1)
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 3)
	ball.fixture:setRestitution(0) -- no bounce
	whale = love.graphics.newImage("whale.png")
	deadWhale = love.graphics.newImage("whale.Dead.png")
	local font = love.graphics.newFont(20, "mono")
	promptText = love.graphics.newText(font, {textColorBlack, currentPromptText})
	coloredText = love.graphics.newText(font, {textColorBlack, typedInWord})
	wrongPromptText = love.graphics.newText(font, {textColorRed, ""})
	r, g, b = love.math.colorFromBytes{132, 193, 238}
	love.graphics.setBackgroundColor(r, g, b) -- light blue
	love.keyboard.setTextInput(true)
end

function love.draw()
	love.graphics.draw(promptText, 10, 10)
	love.graphics.draw(coloredText, 10, 30)
	love.graphics.draw(wrongPromptText, 10, 50)
	if isDead == false then
		love.graphics.draw(whale, ball.body:getX(), ball.body:getY())
	else
		love.graphics.draw(deadWhale, ball.body:getX(), ball.body:getY())
	end
end

function love.textinput(t)
	textXPosition = textXPosition + coloredText:getWidth()
	if t ~= " " then -- ~= means 'Not Equal'
		typedInWord = typedInWord .. t
		coloredText:add({textColorBlack, t}, textXPosition)
	end
end

function love.update(dt)
	world:update(dt) --this puts the world into motion
	-- make typey swim!
	if love.keyboard.isDown(listOfKeys) and isDead == false then
		ball.body:applyForce(math.random(1, -3), math.random(-10, 10))
	end
	-- reset typey to wrap around the world
	if ball.body:getX() < (0 - whaleCenterX) then
		ball.body:setX(love.graphics.getWidth() - whaleCenterX)
	elseif ball.body:getX() > love.graphics.getWidth() - whaleCenterX then
		ball.body:setX(0 - whaleCenterX)
	end

	if ball.body:getY() < (0 - whaleCenterY) then
		ball.body:setY(centerY * 2 - whaleCenterY)
	elseif ball.body:getY() > love.graphics.getHeight() - whaleCenterY then
		ball.body:setY(0 - whaleCenterY)
	end
end

function love.keypressed(key)
	if key == "return" or key == "space" then
		textXPosition = 0 -- Reset position of 'cursor'
		coloredText:clear() -- Reset drawn input text
		if typedInWord == "..." or typedInWord == currentPromptText then
			currentPromptText = wordsToType[math.random(#wordsToType)] -- Pick new prompt to type
			promptText:set({textColorBlack, currentPromptText})
			wrongPromptText:clear()
			isDead = false
		else
			isDead = true
			wrongPromptText:set({textColorRed, "WRONG TRY AGAIN!"})
			ball.body:setLinearVelocity(10, 0)
		end
		typedInWord = "" -- Reset Typed in word
	end
end