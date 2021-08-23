love.graphics.setDefaultFilter("nearest", "nearest")
local STI = require("sti")
local Player = require("player")
local Coin = require("coin")
local GUI = require("gui")
local Spike = require("spike")
local Block = require("block")
local Camera = require("camera")

function love.load()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0,2000)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    MapWidth = Map.layers.ground.width * 16
    background1 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night1.png")
    background2 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night2.png")
    background3 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night3.png")
    GUI:load()
    Player:load()
    Coin.new(300, 200)
    Coin.new(400, 200)
    Coin.new(500, 200)
    Spike.new(200, 325)
    Block.new(300, 150)
end



function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
    Spike:updateAll(dt)
    Block:updateAll(dt)
    GUI:update(dt)
    Camera:setPosition(Player.x, 0)
end



function love.draw()
    love.graphics.draw(background1, 0, 0, 0, 2, 2)
    love.graphics.draw(background2, 0, 0, 0, 2, 2)
    love.graphics.draw(background3, 0, 0, 0, 2, 2)
    Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

    Camera:apply()
    Player:draw()
    Coin.drawAll()
    Spike.drawAll()
    Block:drawAll()
    Camera:clear()

    GUI:draw()
end



function love.keypressed(key)
    Player:jump(key)
end



function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    if Spike.beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end