local Block = {img = love.graphics.newImage("assets/interactable/block/block.png")}
Block.__index = Block

Block.width = Block.img:getWidth()
Block.height = Block.img:getHeight()

local ActiveBlocks = {}

function Block.new(x,y)
    local instance = setmetatable({}, Block)
    instance.x = x
    instance.y = y
    instance.r = 0

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(25)

    table.insert(ActiveBlocks, instance)
end

function Block:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Block:update(dt)
    self:syncPhysics()
end

function Block:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r, 1, 1, self.width / 2, self.height / 2)
end

function Block:updateAll(dt)
    for i,instance in ipairs(ActiveBlocks) do
        instance:update(dt)
    end
end

function Block:drawAll()
    for i,instance in ipairs(ActiveBlocks) do
        instance:draw()
    end
end

function Block.removeAll()
    for i,v in ipairs(ActiveBlocks) do
        v.physics.body:destroy()
    end

    ActiveBlocks = {}
end


return Block
