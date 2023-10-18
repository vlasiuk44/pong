
-- TODO
-- сброс мяча в любом направлении
-- баг - можно играть когда появилась надпись try again
-- переход в меню по завершению партии
-- добавить окошко для победы над ботом

-- game.lua
local Game = {}

-- Начало игры
local gameBackground = love.graphics.newImage("img/bg.png")
local ballImage = love.graphics.newImage("img/ball.png")

-- После поражения
local tryAgainButton = love.graphics.newImage("img/button_tryagain.png")
local gameOverBackground = love.graphics.newImage("img/bg_gameover.png")

Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)
    self.gameStart = false
    self.isGameOver = false
    self.startGameSpeed = 10
    --self.r=math.random(10,11)
    -- if math.random(10,11)==10 then r=1 end
    self.screenWidth = gameBackground:getWidth()
    self.screenHeight = gameBackground:getHeight()

    self.leftPaddleImage = love.graphics.newImage("img/rocket_1.png")
    self.rightPaddleImage = love.graphics.newImage("img/rocket_2.png")
    
    self.flagPause = false
    self.leftFlagStart = false
    self.rightFlagStart = false
    self.autoflag = false
    self.gameSpeed = self.startGameSpeed
    self.autoPaddleSpeed = 7
    self.ballDeflectionByCenterPaddle = 0
    self.rand = math.random(self.gameSpeed/2, self.gameSpeed)
    
    
    
    -- while self.rand == 0 do
    --     self.rand = math.random(-self.gameSpeed, self.gameSpeed)
    -- end

    -- Размеры изображений ракеток
    local leftPaddleImageWidth = self.leftPaddleImage:getWidth()
    local leftPaddleImageHeight = self.leftPaddleImage:getHeight()
    local rightPaddleImageWidth = self.rightPaddleImage:getWidth()
    local rightPaddleImageHeight = self.rightPaddleImage:getHeight()

    -- Отступ ракетки от края экрана
    local paddleMargin = 20

    -- Размеры ракеток на основе размеров изображений
    self.leftPaddle = {
        x = paddleMargin,
        y = self.screenHeight / 2 - leftPaddleImageHeight / 2,
        width = leftPaddleImageWidth,
        height = leftPaddleImageHeight,
        dy = 5
    }

    self.rightPaddle = {
        x = self.screenWidth - rightPaddleImageWidth - paddleMargin,
        y = self.screenHeight / 2 - rightPaddleImageHeight / 2,
        width = rightPaddleImageWidth,
        height = rightPaddleImageHeight,
        dy = 5
    }

    -- Размеры мяча
    self.ball = {
        x = self.screenWidth / 2,
        y = self.screenHeight / 2,
        size = ballImage:getWidth() / 2,
        dx = self.rand,
        dy = self.gameSpeed - self.rand,
        bg = ballImage,
        wickPx = 22
    }

    self.scorePlayer1 = 0
    self.scorePlayer2 = 0

    return self
end

function Game:update(dt)
    -- Обновление положения мяча
    if love.keyboard.isDown("w") or love.keyboard.isDown("s") then
        self.leftFlagStart = true
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("down") then
        self.rightFlagStart = true
    end

    if love.keyboard.isDown("f") then 
        self.flagPause = not self.flagPause 
    end

    if self.leftFlagStart and self.rightFlagStart then
        self.gameStart = true 
    end

    if self.gameStart then
        self.ball.x = self.ball.x + self.ball.dx
        self.ball.y = self.ball.y + self.ball.dy
    end

    -- Обработка столкновения мяча с верхней и нижней стенками
    if self.ball.y - self.ball.size < 0 or self.ball.y + self.ball.size > love.graphics.getHeight() then
        self.ball.dy = -self.ball.dy 
    end

    -- Обработка столкновения мяча с ракетками
    if self.ball.x - self.ball.size < self.leftPaddle.x + self.leftPaddle.width and self.ball.x + self.ball.size >
       self.leftPaddle.x and self.ball.y + self.ball.size > self.leftPaddle.y and self.ball.y - self.ball.size <
       self.leftPaddle.y + self.leftPaddle.height then
        self.gameSpeed = self.gameSpeed + 1 
        self.ball.dx = -self.ball.dx
        self.ballDeflectionByCenterPaddle =  (self.leftPaddle.y + self.leftPaddle.height / 2 - self.ball.y - self.ball.size / 2) / (self.leftPaddle.height / 2)*self.gameSpeed/2
        self.ball.dy = -self.ballDeflectionByCenterPaddle
        self.ball.dx = self.gameSpeed - math.abs(self.ballDeflectionByCenterPaddle)
    end

    if self.ball.x - self.ball.size < self.rightPaddle.x + self.rightPaddle.width and self.ball.x + self.ball.size >
       self.rightPaddle.x and self.ball.y + self.ball.size > self.rightPaddle.y and self.ball.y - self.ball.size <
       self.rightPaddle.y + self.rightPaddle.height then 
        self.gameSpeed = self.gameSpeed + 1 
        self.ball.dx = -self.ball.dx
        self.ballDeflectionByCenterPaddle = (self.rightPaddle.y + self.rightPaddle.height / 2 - self.ball.y - self.ball.size / 2) / (self.rightPaddle.height / 2)*self.gameSpeed/2

        self.ball.dy = -self.ballDeflectionByCenterPaddle
        self.ball.dx = -self.gameSpeed + math.abs(self.ballDeflectionByCenterPaddle)
    end



    -- Обработка движения ракеток

    -- Обработка правой ракетки
    if not self.autoflag then
        if love.keyboard.isDown("up") and self.rightPaddle.y > 0 then
            self.rightPaddle.y = self.rightPaddle.y - self.rightPaddle.dy
        end
        if love.keyboard.isDown("down") and self.rightPaddle.y +
            self.rightPaddle.height < love.graphics.getHeight() then
            self.rightPaddle.y = self.rightPaddle.y + self.rightPaddle.dy
        end
    else
        -- if self.rightPaddle.y + self.rightPaddle.height > self.screenHeight then
        --     self.rightPaddle.y = self.screenHeight - self.rightPaddle.height 
        -- elseif self.rightPaddle.y  < 0  then
        --     self.rightPaddle.y = 0 
        -- else
        if self.ball.y > self.rightPaddle.y + self.rightPaddle.height   then
            self.rightPaddle.y = self.rightPaddle.y + self.autoPaddleSpeed
        elseif self.ball.y < self.rightPaddle.y    then
            self.rightPaddle.y = self.rightPaddle.y - self.autoPaddleSpeed
        end
        --self.rightPaddle.y = self.ball.y - self.rightPaddle.height / 2
        --end
    end

    -- Обработка левой ракетки
    if love.keyboard.isDown("w") and self.leftPaddle.y > 0 then
        self.leftPaddle.y = self.leftPaddle.y - self.leftPaddle.dy
    end
    if love.keyboard.isDown("s") and self.leftPaddle.y + self.leftPaddle.height < love.graphics.getHeight() then
        self.leftPaddle.y = self.leftPaddle.y + self.leftPaddle.dy
    end

    -- Включение авторежима игрока справа (Симулирование игры против бота)
    if love.keyboard.isDown("k") then
        self.autoflag = not self.autoflag
    end

    -- Обновление положение мяча + увеличение счета
    if self.ball.x < 0 then
        self.gameSpeed = self.startGameSpeed
        self.scorePlayer1 = self.scorePlayer1 + 1
        self.leftFlagStart = false
        self.rightFlagStart = false
        self.gameStart = false
        self.ball.x = self.screenWidth / 2
        self.ball.y = self.screenHeight / 2
        self.rand = math.random(self.gameSpeed/2, self.gameSpeed)
        self.ball.dx = self.rand
        self.ball.dy = self.gameSpeed - self.ball.dx
    elseif self.ball.x > self.screenWidth then
        self.gameSpeed = self.startGameSpeed
        self.scorePlayer2 = self.scorePlayer2 + 1
        self.leftFlagStart = false
        self.rightFlagStart = false
        self.gameStart = false
        self.ball.x = self.screenWidth / 2
        self.ball.y = self.screenHeight / 2
        self.rand = math.random(self.gameSpeed/2, self.gameSpeed)
        
        self.ball.dx = self.rand
        self.ball.dy = self.gameSpeed - self.ball.dx
    end
    
    if self.flagPause == true then
        self.ball.dx = 0
        self.ball.dy = 0
    end

    if self.scorePlayer1 >= 3 or self.scorePlayer2 >= 3 then
        self.isGameOver = true
    end    
end

function Game:draw()
    -- Отрисовка поля Pong
    love.graphics.clear()

    -- Отрисовка фона для игры
    love.graphics.draw(gameBackground, 0, 0)

    -- Отрисовка мяча
    love.graphics.draw(self.ball.bg, self.ball.x - self.ball.size, self.ball.y - self.ball.size - self.ball.wickPx)

    -- Отрисовка левой ракетки с фоном
    love.graphics.draw(self.leftPaddleImage, self.leftPaddle.x, self.leftPaddle.y)

    -- Отрисовка правой ракетки с фоном
    love.graphics.draw(self.rightPaddleImage, self.rightPaddle.x, self.rightPaddle.y)

    -- Отладочная отрисовка

    -- Орисовка круга у мяча
    -- love.graphics.circle("line", self.ball.x, self.ball.y, self.ball.size)

    -- Отрисовка прямоугольника вокруг левой ракетки
    -- love.graphics.rectangle("line", self.leftPaddle.x, self.leftPaddle.y, self.leftPaddle.width, self.leftPaddle.height)

    -- Отрисовка прямоугольника вокруг правой ракетки
    -- love.graphics.rectangle("line", self.rightPaddle.x, self.rightPaddle.y, self.rightPaddle.width, self.rightPaddle.height)


    -- Тут я проверяю, что до 3 очков дошла игра и тогда рисую фон и кнопку
    if self.isGameOver then
        love.graphics.draw(gameOverBackground, 0, 0)
        local tryAgainButtonWidth = tryAgainButton:getWidth()
        local tryAgainButtonHeight = tryAgainButton:getHeight()
        local tryAgainButtonX = (self.screenWidth - tryAgainButtonWidth) / 2
        local tryAgainButtonY = (self.screenHeight - tryAgainButtonHeight) / 2
        love.graphics.draw(tryAgainButton, tryAgainButtonX, tryAgainButtonY)
    end
    
    -- Вывод счета игроков
    local fontSize = 48 -- Размер шрифта для отображения счета

    -- Вывод счета игрока 1
    local player1Score = tostring(self.scorePlayer1)
    local player1TextWidth = fontSize * #player1Score
    local player1TextX = self.screenWidth / 4 - player1TextWidth / 2 - 244
    love.graphics.setFont(love.graphics.newFont(fontSize))
    love.graphics.printf(player1Score, player1TextX, 43, player1TextWidth, "center")

    -- Вывод счета игрока 2
    local player2Score = tostring(self.scorePlayer2)
    local player2TextWidth = fontSize * #player2Score
    local player2TextX = 3 * self.screenWidth / 4 - player2TextWidth / 2 + 191
    love.graphics.printf(player2Score, player2TextX, 43, player2TextWidth, "center")

    -- Предыдущий вывод инфы, мб понадобится

    -- love.graphics.print("Player 1: " .. self.scorePlayer1, self.screenWidth / 4,20)
     --love.graphics.print(self.r, 2 * self.screenWidth / 4, 20)
     --love.graphics.print("dx " .. self.ball.dx, 1 * self.screenWidth / 4, 60)
     --love.graphics.print("dy " .. self.ball.dy, 3 * self.screenWidth / 4, 60)
    -- love.graphics.print("Player 2: " .. self.scorePlayer2, 3 * self.screenWidth / 4, 20)
end

return Game
