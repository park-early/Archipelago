love.graphics.setDefaultFilter("nearest", "nearest")
local STI = require("sti")
local Player = require("player")
local Coin = require("coin")
local GUI = require("gui")
local Spike = require("spike")

function love.load()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    background1 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night1.png")
    background2 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night2.png")
    background3 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night3.png")
    GUI:load()
    Player:load()
    Coin.new(300, 200)
    Coin.new(400, 200)
    Coin.new(500, 200)
    Spike.new(200, 325)
end



function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
    Spike:updateAll(dt)
    GUI:update(dt)
end



function love.draw()
    love.graphics.draw(background1, 0, 0, 0, 2, 2)
    love.graphics.draw(background2, 0, 0, 0, 2, 2)
    love.graphics.draw(background3, 0, 0, 0, 2, 2)
    Map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)

    Player:draw()
    Coin.drawAll()
    Spike.drawAll()

    love.graphics.pop()
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