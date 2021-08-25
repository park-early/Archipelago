local Map = {}
local STI = require("sti")
local Coin = require("coin")
local Spike = require("spike")
local Block = require("block")
local Enemy = require("enemy")

function Map:load()
    self.currentLevel = 1
    
    World = love.physics.newWorld(0,2000)
    World:setCallbacks(beginContact, endContact)
    
    self:init()
end

function Map:init()
    self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})
    self.level:box2d_init(World)
    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.ground
    self.entityLayer = self.level.layers.entity

    self.solidLayer.visible = false
    self.solidLayer.visible = false
    MapWidth = self.groundLayer.width * 16

    self:spawnEntities()
end

function Map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1
    self:init()
end

function Map:clean()
    self.level:box2d_removeLayer("solid")
    Coin.removeAll()
    Spike.removeAll()
    Block.removeAll()
    Enemy.removeAll()
end

function Map:spawnEntities()
    for i,v in ipairs(self.entityLayer.objects) do
        if v.type == "spike" then
            Spike.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "block" then
            Block.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "coin" then
            Coin.new(v.x, v.y)
        elseif v.type == "enemy" then
            Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end


return Map