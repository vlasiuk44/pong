-- game.lua
local Game = {}
Game.__index = Game


function Game.new()
    local self = setmetatable({}, Game)
    self.gameStart = false
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()
    self.leftFlagStart = false
    self.rightFlagStart = false
    self.ball = {x = self.screenWidth / 2, y = self.screenHeight / 2, size = 10, dx = 5, dy = 5}
    self.leftPaddle = {x = 20, y = self.screenHeight / 2 - 50, width = 20, height = 100, dy = 5}
    self.rightPaddle = {x =self.screenWidth - 40, y = self.screenHeight / 2 - 50, width = 20, height = 100, dy = 5}
    self.scorePlayer1 = 0
    self.scorePlayer2 = 0
    return self
end





function Game:update(dt)
    -- Обновление положения мяча
    if love.keyboard.isDown("w") or love.keyboard.isDown("s") then self.leftFlagStart = true end
    if love.keyboard.isDown("up") or love.keyboard.isDown("down") then self.rightFlagStart = true end
    if self.leftFlagStart and self.rightFlagStart then self.gameStart = true end
    if self.gameStart then
        self.ball.x = self.ball.x + self.ball.dx
        self.ball.y = self.ball.y + self.ball.dy

        -- Обработка столкновения мяча с верхней и нижней стенками
        if self.ball.y - self.ball.size < 0 or self.ball.y + self.ball.size > love.graphics.getHeight() then
            self.ball.dy = -self.ball.dy
        end

        -- Обработка столкновения мяча с ракетками
        if self.ball.x - self.ball.size < self.leftPaddle.x + self.leftPaddle.width and
        self.ball.x + self.ball.size > self.leftPaddle.x and
        self.ball.y + self.ball.size > self.leftPaddle.y and
        self.ball.y - self.ball.size < self.leftPaddle.y + self.leftPaddle.height then
            self.ball.dx = -self.ball.dx
        end

        if self.ball.x - self.ball.size < self.rightPaddle.x + self.rightPaddle.width and
        self.ball.x + self.ball.size > self.rightPaddle.x and
        self.ball.y + self.ball.size > self.rightPaddle.y and
        self.ball.y - self.ball.size < self.rightPaddle.y + self.rightPaddle.height then
            self.ball.dx = -self.ball.dx
        end

        -- Обработка движения ракеток
        if love.keyboard.isDown("w") and self.leftPaddle.y > 0 then
            self.leftPaddle.y = self.leftPaddle.y - self.leftPaddle.dy
        end

        if love.keyboard.isDown("s") and self.leftPaddle.y + self.leftPaddle.height < love.graphics.getHeight() then
            self.leftPaddle.y = self.leftPaddle.y + self.leftPaddle.dy
        end

        if love.keyboard.isDown("up") and self.rightPaddle.y > 0 then
            self.rightPaddle.y = self.rightPaddle.y - self.rightPaddle.dy
        end

        if love.keyboard.isDown("down") and self.rightPaddle.y + self.rightPaddle.height < love.graphics.getHeight() then
            self.rightPaddle.y = self.rightPaddle.y + self.rightPaddle.dy
        end
        
        if self.ball.x < 0 then
            self.scorePlayer1 = self.scorePlayer1 + 1
            self.leftFlagStart=false
            self.rightFlagStart=false
            self.gameStart = false
            self.leftPaddle = {x = 20, y = self.screenHeight / 2 - 50, width = 20, height = 100, dy = 5}
    self.rightPaddle = {x =self.screenWidth - 40, y = self.screenHeight / 2 - 50, width = 20, height = 100, dy = 5}
            self.ball.x = self.screenWidth/2
            self.ball.y = self.screenHeight/2
        elseif self.ball.x > self.screenWidth then
            self.scorePlayer2 = self.scorePlayer2 + 1
            self.leftFlagStart=false
            self.rightFlagStart=false
            self.gameStart = false
            self.leftPaddle = {x = 20, y = self.screenHeight / 2 - 50, width = 20, height = 100, dy = 5}
    self.rightPaddle = {x =self.screenWidth - 40, y = self.screenHeight / 2 - 50, width = 20, height = 100, dy = 5}
            self.ball.x = self.screenWidth/2
            self.ball.y = self.screenHeight/2
        end
    end
    
end



function Game:draw()
    -- Отрисовка поля Pong
    love.graphics.clear()
    
    -- Отрисовка мяча
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', self.ball.x, self.ball.y,  self.ball.size,  self.ball.size)

    -- Отрисовка левой ракетки
    love.graphics.rectangle("fill", self.leftPaddle.x, self.leftPaddle.y, self.leftPaddle.width, self.leftPaddle.height)
    
    -- Отрисовка правой ракетки
    love.graphics.rectangle("fill", self.rightPaddle.x, self.rightPaddle.y, self.rightPaddle.width, self.rightPaddle.height)

    local scoreFont = love.graphics.newFont("fonts/EightBits.ttf", 24)
    love.graphics.setFont(scoreFont)
    love.graphics.print("Player 1: " .. self.scorePlayer1, self.screenWidth / 4, 20)
    love.graphics.print("Player 2: " .. self.scorePlayer2, 3 * self.screenWidth / 4, 20)
end

return Game