-- Typey the Whale is a Love2D typing game for windows written by Ben Garza
-- Import words
local wordsToType = require("words")
local gameTitle = "Typey the Whale"
local whaleCenterX = 157
local whaleCenterY = 116
local windowSize = 800
local listOfKeys = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' }
local typedInWord = "..."
local currentPromptText = "Help Typey the Whale swim as fast as you can type! Press 'Enter' to Start!"
local wrongTryAgainText = "WRONG TRY AGAIN!"
local textColorBlack = { 0, 0, 0 }
local textColorRed = { 255, 0, 0 }
local isDead = false
local gameIsActive = false
local timer = 0
local interval = 60  -- 60 seconds
local wpm = 1
local timeRemaining = 60
local correctWords = 0

function love.load()
    love.window.setTitle(gameTitle)
    love.window.setMode(windowSize, windowSize)
    textXPosition = 0
    centerX = love.graphics.getWidth() / 2
    centerY = love.graphics.getHeight() / 2
    centeredWhaleXPosition = centerX - whaleCenterX -- minus because the window starts at 0,0 in the top left
    centeredWhaleYPosition = centerY - whaleCenterY
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, true)
    whaleObject = {}
    whaleObject.body = love.physics.newBody(world, centeredWhaleXPosition, centeredWhaleYPosition, "dynamic")
    whaleObject.shape = love.physics.newCircleShape(1)
    whaleObject.fixture = love.physics.newFixture(whaleObject.body, whaleObject.shape, 3)
    whaleObject.fixture:setRestitution(0) -- no bounce
    whaleImage = love.graphics.newImage("whale.png")
    deadWhaleImage = love.graphics.newImage("whale.Dead.png")
    gameEndWhaleImage = love.graphics.newImage("game.over.png")
    local font = love.graphics.newFont(20, "mono")
    promptText = love.graphics.newText(font, { textColorBlack, currentPromptText })
    inputText = love.graphics.newText(font, { textColorBlack, typedInWord })
    wrongPromptText = love.graphics.newText(font, { textColorRed, "" })
    timerText = love.graphics.newText(font, { textColorRed, timeRemaining })
    love.graphics.setBackgroundColor(love.math.colorFromBytes { 132, 193, 238 }) -- light blue
    love.keyboard.setTextInput(true)
    math.randomseed(os.time())
end

function love.draw()
    love.graphics.draw(promptText, 10, 10)
    love.graphics.draw(inputText, 10, 30)
    love.graphics.draw(wrongPromptText, 10, 50)
    love.graphics.draw(timerText, windowSize - 60, windowSize - 30)
    if isDead == false then
        love.graphics.draw(whaleImage, whaleObject.body:getX(), whaleObject.body:getY())
    else
        love.graphics.draw(deadWhaleImage, whaleObject.body:getX(), whaleObject.body:getY())
    end
    if timeRemaining < 0 then
        love.graphics.draw(gameEndWhaleImage, centeredWhaleXPosition, centeredWhaleYPosition)
    end
end

function love.textinput(t)
    textXPosition = textXPosition + inputText:getWidth()
    if t ~= " " then
        typedInWord = typedInWord .. t
        inputText:add({ textColorBlack, t }, textXPosition)
    end
end

function love.update(dt)
    if gameIsActive == true then
        timer = timer + dt -- start timer
        timeRemaining = interval - timer
        timerText:set({ textColorRed, timeRemaining })
        world:update(dt) -- this puts the world into motion
        -- make Typey swim!
        if love.keyboard.isDown(listOfKeys) and isDead == false then
            whaleObject.body:applyForce(math.random(1, -3), math.random(-10, 10))
        end
        -- reset Typey to wrap around the world
        if whaleObject.body:getX() < (0 - whaleCenterX) then
            whaleObject.body:setX(love.graphics.getWidth() - whaleCenterX)
        elseif whaleObject.body:getX() > love.graphics.getWidth() - whaleCenterX then
            whaleObject.body:setX(0 - whaleCenterX)
        end
        if whaleObject.body:getY() < (0 - whaleCenterY) then
            whaleObject.body:setY(centerY * 2 - whaleCenterY)
        elseif whaleObject.body:getY() > love.graphics.getHeight() - whaleCenterY then
            whaleObject.body:setY(0 - whaleCenterY)
        end
        -- timer logic
        if timer >= interval then
            wrongPromptText:set({ textColorRed, "GAME OVER!!! ...... WPM: " .. correctWords .. " **YOU DID IT!**" })
            whaleObject.body:setLinearVelocity(0, 0)
            whaleObject.body:setX(centeredWhaleXPosition)
            whaleObject.body:setY(centeredWhaleYPosition)
            gameIsActive = false
        end
    end
end

function love.keypressed(key)
    if key == "return" and gameIsActive == false and timeRemaining > 0 then
        -- initial start of game
        currentPromptText = wordsToType[math.random(#wordsToType)] -- Pick new prompt to type
        promptText:set({ textColorBlack, currentPromptText })
        resetInputTextDisplay()
        gameIsActive = true
    end
    if key == "space" and gameIsActive == true then
        if typedInWord == currentPromptText then
            currentPromptText = wordsToType[math.random(#wordsToType)] -- Pick new prompt to type
            promptText:set({ textColorBlack, currentPromptText })
            wrongPromptText:clear()
            correctWords = correctWords + 1
            isDead = false
        else
            isDead = true
            wrongPromptText:set({ textColorRed, wrongTryAgainText })
            whaleObject.body:setLinearVelocity(10, 0)
        end
        resetInputTextDisplay()
    end
end

function resetInputTextDisplay()
    textXPosition = 0 -- Reset position of 'cursor'
    inputText:clear() -- Reset drawn input text
    typedInWord = "" -- Reset Typed in word
end