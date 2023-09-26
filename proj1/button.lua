-- button.lua
local Button = {}
Button.__index = Button

local buttonFont = love.graphics.newFont("fonts/EightBits.ttf", 24)

function Button.new(x, y, width, height, text)
    local self = setmetatable({}, Button)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.selected = false
    self.text = text
    self.font = buttonFont
    return self
end

function Button:draw()
    -- Отрисовываем кнопку
    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 1, 1)
    
    if self.selected then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
    
    local textWidth = self.font:getWidth(self.text)
    local textHeight = self.font:getHeight(self.text)
    
    love.graphics.print(self.text, self.x + (self.width - textWidth) / 2, self.y + (self.height - textHeight) / 2)
end

return Button
