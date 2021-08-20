local Coin = {}
Coin.__index = Coin
local ActiveCoins = {}
local Player = require("player")

function Coin.new(x,y)
    local instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y
    instance.toBeRemoved = false

    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.spin = {total = 6, current = math.random(1,6), img = {}}
    for i=1, instance.animation.spin.total do
        instance.animation.spin.img[i] = love.graphics.newImage("assets/interactable/coin/"..i..".png")
    end
    instance.animation.draw = instance.animation.spin.img[instance.animation.spin.current]
    instance.width = instance.animation.draw:getWidth()
    instance.height = instance.animation.draw:getHeight()

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    table.insert(ActiveCoins, instance)
end

function Coin:update(dt)
    self:animate(dt)
    self:checkRemove()
end

function Coin:draw()
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function Coin:updateAll(dt)
    for i,instance in ipairs(ActiveCoins) do
        instance:update(dt)
    end
end

function Coin:drawAll()
    for i,instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

function Coin:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if (self.animation.timer > self.animation.rate) then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Coin:setNewFrame()
    if self.animation.spin.current == self.animation.spin.total then
        self.animation.spin.current = 1
    else
        self.animation.spin.current = self.animation.spin.current + 1
    end
    self.animation.draw = self.animation.spin.img[self.animation.spin.current]
end

function Coin.beginContact(a, b, collision)
    for i,instance in ipairs(ActiveCoins) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

function Coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

function Coin:remove()
    for i,instance in ipairs(ActiveCoins) do
        if instance == self then
            Player:incrementCoins()
            self.physics.body:destroy()
            table.remove(ActiveCoins, i)
        end
    end
end


return Coin
