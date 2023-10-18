-- TODO
-- Добавить в меню кнопки запуска ии, изменение скорости игры
-- скейл

-- main.lua

-- Изображения для фоновых картинок
local mainMenuBackground = love.graphics.newImage("img/bg_menu.png")

-- Изображение для кнопки начать игру
local buttonStart = love.graphics.newImage("img/button_play.png")

-- Изображение для кнопки выйти из игры
local buttonExit = love.graphics.newImage("img/button_exit.png")

local Button = require("button")
local Game = require("game")

local buttons = {}
local selectedButtonIndex = 1

love.window.setMode(mainMenuBackground:getWidth(), mainMenuBackground:getHeight())

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local buttonWidth = buttonStart:getWidth()
local buttonHeight = buttonStart:getHeight()
local buttonX = (screenWidth - buttonWidth) / 2
local buttonY = (screenHeight - buttonHeight) / 2

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
    -- Тут из-за кнопки return срабатывает try_again кнопка и без дополнительной ее обработки в game.lua
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

    local buttonsMargin = 25

    local buttonStartGame = Button.new(buttonX, buttonY - buttonsMargin, buttonWidth, buttonHeight, "", buttonStart)
    local buttonExitFromGame = Button.new(buttonX, buttonY + buttonHeight, buttonWidth, buttonHeight, "", buttonExit)

    table.insert(buttons, buttonStartGame)
    table.insert(buttons, buttonExitFromGame)

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
        -- Отрисовка фона для главного меню
        love.graphics.draw(mainMenuBackground, 0, 0)
        
        -- Затем отрисовка кнопок и текста меню
        for _, button in pairs(buttons) do 
            button:draw() 
        end
    end
end
