-- main.lua
local Button = require("button")
local Game = require("game")

local buttons = {}
local selectedButtonIndex = 1

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local titleFont = love.graphics.newFont("fonts/VisitorRus.ttf", 48)
local buttonFont = love.graphics.newFont("fonts/EightBits.ttf", 24)

local titleText = "Pong"
local titleWidth = titleFont:getWidth(titleText)
local titleHeight = titleFont:getHeight(titleText)
local titleX = (screenWidth - titleWidth) / 2
local titleY = (screenHeight - titleHeight) / 4

local buttonWidth = 200
local buttonHeight = 50
local buttonX = (screenWidth - buttonWidth) / 2
local buttonSpacing = 60

local game

function love.keypressed(key)
    local buttonCount = #buttons

    if key == "up" then
        buttons[selectedButtonIndex].selected = false
        selectedButtonIndex = selectedButtonIndex - 1
        if selectedButtonIndex < 1 then selectedButtonIndex = buttonCount end
        buttons[selectedButtonIndex].selected = true
    elseif key == "down" then
        buttons[selectedButtonIndex].selected = false
        selectedButtonIndex = selectedButtonIndex + 1
        if selectedButtonIndex > buttonCount then selectedButtonIndex = 1 end
        buttons[selectedButtonIndex].selected = true
    elseif key == "return" then
        if selectedButtonIndex == 1 then
            -- Нажата кнопка "Start game"
            game = Game.new() -- Создаем объект игры
        elseif selectedButtonIndex == 2 then
            -- Нажата кнопка "Exit"
            love.event.quit()
        end
    end
end

function love.load()
    local button1 = Button.new(buttonX, 200, buttonWidth, buttonHeight,
                               "Start game")
    local button2 = Button.new(buttonX, 200 + buttonSpacing, buttonWidth,
                               buttonHeight, "Exit")
    local button3 = Button.new(buttonX, 200 + 2 * buttonSpacing, buttonWidth,
                               buttonHeight, "")
    local button4 = Button.new(buttonX, 200 + 3 * buttonSpacing, buttonWidth,
                               buttonHeight, "")

    table.insert(buttons, button1)
    table.insert(buttons, button2)
    table.insert(buttons, button3)
    table.insert(buttons, button4)

    buttons[selectedButtonIndex].selected = true
end

function love.update(dt)
    if game then
        game:update(dt) -- Обновление игры, если она активна
    end
end

function love.draw()
    if game then
        game:draw() -- Отрисовка игры, если она активна
    else
        for _, button in pairs(buttons) do button:draw() end

        love.graphics.setFont(titleFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(titleText, titleX, titleY)
    end
end
