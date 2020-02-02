require "utils"

-- main Game class
Game = {}

function Game:init()
    local ob = {}

    -- first level file
    FILE = "assets/levels/level-1.lua"

    self.__index = self
    return setmetatable(ob, self)
end

function Game:_load()
    music = love.audio.newSource("assets/music.mp3", "stream")
    music:setLooping(true)
    music:play()

    -- background image
    self.bg = love.graphics.newImage("assets/bg.jpg")

    self.ground = love.graphics.newImage("assets/ground.png")

    font = love.graphics.newFont("assets/font.ttf", 30)
    love.graphics.setFont(font)

    -- TODO: ADD ICON TO THE GAME

    self:reset()
end

function Game:reset()
    -- read a level from a "FILE" and load it

    self.level = love.filesystem.load(FILE)()
    self.pause = self.level.meta.pause
    self.info = self.level.meta.info

    self.blocks = {}

    for _, ob in ipairs(self.level.blocks) do
        block = Block:init(ob.x, ob.y)
        table.insert(self.blocks, block)
    end

    self.broken = {}

    for _, ob in ipairs(self.level.broken) do
        broken = Broken:init(ob.x, ob.y)
        table.insert(self.broken, broken)
    end

    self.platforms = {}

    for _, ob in ipairs(self.level.platforms) do
        platform = Platform:init(ob.x, ob.y)
        table.insert(self.platforms, platform)
    end

    self.player = Player:init(20, 200, self)
    end

function Game:draw()
    love.graphics.setColor(255, 255, 255)

    love.graphics.draw(self.bg, 0, 0)
    self.player:draw()

    for i = 0, 33 do
        love.graphics.draw(self.ground, i * 31, 205 + 32)
    end

    for _, ob in ipairs(self.blocks) do
        ob:draw()
    end

    for _, ob in ipairs(self.broken) do
        ob:draw()
    end

    for _, ob in ipairs(self.platforms) do
        ob:draw()
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.info, 350, 300)
end

function Game:update(dt)

    for _, ob in ipairs(self.blocks) do
        ob:update(dt)
    end

    self.player:update(dt, self.pause)

    -- collison detection between player and blocks
    for _, block in ipairs(self.blocks) do
        if collide(self.player, block) then
            -- if there is a collison reset the level
            self:reset()
        end
    end

    for _, _broken in ipairs(self.broken) do
        if collide(self.player, _broken) then
            -- there is a collison
            _broken.broken = false
        end
    end

    on_platform = false

    for _, _platform in ipairs(self.platforms) do
        if collide(self.player, _platform) then
            -- there is a collison
            if(self.player.y < _platform.y) then
                self.player.yv = 0
                on_platform = true
                self.player.y = _platform.y - 32
            else
                self.player.yv = self.player.oyv
            end
        end
    end

    if (not on_platform and self.player.yv == 0 and self.player.y < 200) then
        self.player.yv = self.player.oyv
    end

    if self.player.x > 1000 then
        -- if player passes the level goto next level
        all = true
        for _, _broken in ipairs(self.broken) do
            if _broken.broken then
                all = false
                break
            end
        end
        if all then
            FILE = self.level.meta._next
        end
        self:reset()
    end
end

function Game:keypressed(key)

    -- if yv (y-velocity) == 0 then we are in the ground
    -- only jump if the player is in the ground
    if key == "space" and self.player.yv == 0 then
        self.pause = false
        self.player.yv = -self.player.oyv
    end
end

Player = {}

function Player:init(x, y)
    local ob = {}

    ob.x = x -- x position
    ob.y = y -- y position
    ob.w = 32 -- width
    ob.h = 32 -- height
    ob.xv = 300 -- x-velocity
    ob.yv = 0 -- y-velocity
    ob.oyv = 300 -- original y-velocity
    ob.g = 600 -- gravity

    self.img = love.graphics.newImage("assets/heart.png")

    self.__index = self
    return setmetatable(ob, self)
end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

function Player:update(dt, pause)

    if pause then
        return
    end

    -- apply x-velocity
    self.x = self.x + self.xv * dt

    if self.yv ~= 0 then
        -- if yv ~= 0 then we are jumping

        -- apply y-velocity
        self.y = self.y + self.yv * dt

        -- apply gravity
        self.yv = self.yv + self.g * dt
    end

    -- check collison with the ground
    if self.y > 200 then
        self.y = 200
        self.yv = 0
    end
end


-- A class represent obstcales in the game
Block = {}

function Block:init(x, y)

    local ob = {}

    ob.x = x -- x position
    ob.y = y -- y position
    ob.w = 32 -- width
    ob.h = 32 -- height

    ob.img = love.graphics.newImage("assets/block.png")

    self.__index = self
    return setmetatable(ob, self)
end

function Block:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

function Block:update(dt)
end

-- A class represent Broken hearts in the game
Broken = {}

function Broken:init(x, y)

    local ob = {}

    ob.x = x -- x position
    ob.y = y -- y position
    ob.w = 32 -- width
    ob.h = 32 -- height

    ob.broken = true

    ob.broken_img = love.graphics.newImage("assets/broken.png")
    ob.spark_img = love.graphics.newImage("assets/sparkling-heart.png")

    self.__index = self
    return setmetatable(ob, self)
end

function Broken:draw()
    if self.broken then 
        love.graphics.draw(self.broken_img, self.x, self.y)
    else
        love.graphics.draw(self.spark_img, self.x, self.y)
    end
end

function Broken:update(dt)
end

-- A class represent platforms in the game
Platform = {}

function Platform:init(x, y)

    local ob = {}

    ob.x = x -- x position
    ob.y = y -- y position
    ob.w = 32 -- width
    ob.h = 32 -- height

    ob.img = love.graphics.newImage("assets/ground.png")

    self.__index = self
    return setmetatable(ob, self)
end

function Platform:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

function Platform:update(dt)
end

-- love2d setup

function love.load()
    game = Game:init()
    game:_load()
end

function love.draw()
    game:draw()

end

function love.update(dt)
    game:update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end

    game:keypressed(key)
end
