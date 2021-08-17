Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500
    self.gravity = 1500
    self.jumpAmount = -500

    self.graceTime = 0
    self.graceDuration = 0.1

    self.grounded = false
    self.hasDoubleJump = false

    self.state = "idle"
    self.direction = "right"

    self:loadAssets()

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:loadAssets()
    self.animation = {timer = 0, rate = 0.1}

    self.animation.idle = {total = 8, current = 1, img = {}}
    for i=1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/"..i..".png")
    end

    self.animation.run = {total = 8, current = 1, img = {}}
    for i=1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/run/"..i..".png")
    end

    self.animation.jump = {total = 2, current = 1, img = {}}
    for i=1, self.animation.jump.total do
        self.animation.jump.img[i] = love.graphics.newImage("assets/player/jump/"..i..".png")
    end

    self.animation.fall = {total = 2, current = 1, img = {}}
    for i=1, self.animation.fall.total do
        self.animation.fall.img[i] = love.graphics.newImage("assets/player/fall/"..i..".png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end




function Player:update(dt)
    self:setState()
    self:setDirection()
    self:animate(dt)
    self:decreaseGraceTime(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
end



function Player:setState()
    if not self.grounded and (self.yVel < 0) then
        self.state = "jump"
    elseif not self.grounded and (self.yVel > 0) then
        self.state = "fall"
    elseif self.xVel ~= 0 then
        self.state = "run"
    else
        self.state = "idle"
    end
end

function Player:setDirection()
    if self.xVel > 0 then
        self.direction = "right"
    elseif self.xVel < 0 then
        self.direction = "left"
    end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if (self.animation.timer > self.animation.rate) then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Player:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current == anim.total then
        anim.current = 1
    else
        anim.current = anim.current + 1
    end
    self.animation.draw = anim.img[anim.current]
end






function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") then
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
    else
        Player:applyFriction(dt)
    end
end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.max(self.xVel - self.friction * dt, 0)
    elseif self.xVel < 0 then
        self.xVel = math.min(self.xVel + self.friction * dt, 0)
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:beginContact(a, b, collision)
    if self.grounded then
        return
    end

    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yVel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.yVel = 0
        end
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
end

function Player:jump(key)
    if (key == "w" or key == "up") then
        if self.grounded or self.graceTime > 0 then
            self.yVel = self.jumpAmount
            self.graceTime = 0
        elseif self.hasDoubleJump then
            self.hasDoubleJump = false
            self.yVel = self.jumpAmount * 0.8
        end
    end
end

function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end




function Player:draw()
    local scaleX = 1
    if self.direction == "left" then
        scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, self.animation.height / 2)
end