local STI = require("sti")
require("player")
require("coin")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    background1 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night1.png")
    background2 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night2.png")
    background3 = love.graphics.newImage("assets/bg_tilesets/SET1_bakcground_night3.png")
    Player:load()
    Coin.new(300, 200)
    Coin.new(400, 200)
    Coin.new(500, 200)
end



function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
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

    love.graphics.pop()
end



function love.keypressed(key)
    Player:jump(key)
end



function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end