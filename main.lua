local STI = require("sti")
require("player")

function love.load()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    background1 = love.graphics.newImage("assets/SET1_bakcground_night1.png")
    background2 = love.graphics.newImage("assets/SET1_bakcground_night2.png")
    background3 = love.graphics.newImage("assets/SET1_bakcground_night3.png")
    Player:load()
end



function love.update(dt)
    World:update(dt)
    Player:update(dt)
end



function love.draw()
    love.graphics.draw(background1, 0, 0, 0, 2, 2)
    love.graphics.draw(background2, 0, 0, 0, 2, 2)
    love.graphics.draw(background3, 0, 0, 0, 2, 2)
    Map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)

    Player:draw()

    love.graphics.pop()
end