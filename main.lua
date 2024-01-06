local love = require "love"
local Game = require "states/Game"
local button = require "Button"
local checkEvent = require "events"
local coordinates = require "coordinates"
local spawnpoint = coordinates.spawnpoint
local levelData = coordinates.levelData

gameMaps = {}
local walls = {}

local level = 1
local Score = 0
local Deathcount = 0
local Winner = false
local distanceThreshold = 50
--In case i want to make a checkpoint in the future : local checkpoint1 = {x = 1781.00, y = 275.50}

local buttons = {
    menu_state = {},
    ended_state = {}
}

local sounds = {}
sounds.music = love.audio.newSource("sounds/music.mp3", "stream")
sounds.death = love.audio.newSource("sounds/gameover.mp3","static")
sounds.win = love.audio.newSource("sounds/victory.mp3","static")
sounds.death:setVolume(0.2)
sounds.win:setVolume(0.2)
sounds.music:setVolume(0.1)
sounds.music:setLooping(true)
local volume = sounds.music:getVolume()
-- Loads all the forest maps to use inside the love.load later
local mapPaths = {
    'maps/forest.lua',
    'maps/forest2.lua'
}

local function playGame()
    game:changeGameState("running")
    sounds.music:play()
end
local function gotoMenu()
    game:changeGameState("menu")
    sounds.music:stop()
end
local function gotoSettings()
    game:changeGameState("settings")
end

--switch the current map
local function switchMap(index)
    if index <= #gameMaps then
        gameMap = gameMaps[index]
    else
        print("Map index out of range")
    end
end
function createWallsForMap(map)
    if map.layers['Walls'] then
        for i, obj in pairs(map.layers['Walls'].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end
function clearColliders()
    for i, wall in ipairs(walls) do
        wall:destroy()
    end
    walls= {}
end
local function resetPlayer()
    myPlayer.x = spawnpoint[level].x
    myPlayer.y = spawnpoint[level].y
    myPlayer.collider:setPosition(myPlayer.x, myPlayer.y)
end
local function startNewGame()
    level = 1
    switchMap(1)
    clearColliders()
    createWallsForMap(gameMaps[level])
    resetPlayer()
    game:changeGameState("running")
end

function love.mousepressed(x, y, button)
    if not game.state.running then
        if button == 1 then
            if game.state.menu or game.state.paused  then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y, myPlayer.grid)
                end
            elseif game.state.ended or game.state.settings then
                for index in pairs(buttons.ended_state) do
                    buttons.ended_state[index]:checkPressed(x, y, myPlayer.grid)
                end
            end
        end
    end
end
function love.keypressed(key)

    if game.state.running then
        if key == "m" then
            if sounds.music then
                sounds.music:stop()
            end
        elseif key == "n" then
            if sounds.music then
                sounds.music:play()
            end
        elseif key == "." then
            if sounds.music then
                volume = volume + 0.1
                sounds.music:setVolume(volume)
            end
        elseif key == "," then
            if sounds.music then
                volume = volume - 0.1
                sounds.music:setVolume(volume)
            end
        end
        if key == "escape" then
            game:changeGameState("paused")
            if  not game.state.running  then
                sounds.music:pause()
            end
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
            sounds.music:play()
        end
    end
end
--local function updateWinSpots()
  --  local randomIndex = love.math.random(1,#deathSpots)
    --winSpots = {
      --  {x = deathSpots[randomIndex].x,y = deathSpots[randomIndex].y}
    --}
--end
local function playerWins()
    sounds.win:play()
    if #spawnpoint > level then
    level = level + 1
    end
    switchMap(level)
    clearColliders()
    createWallsForMap(gameMaps[level])
    Score = Score + 1
    sounds.music:stop()
    --updateWinSpots()
    resetPlayer()
    game:changeGameState("ended")
end
local function playerLoses()
    sounds.death:play()
    resetPlayer()
    Deathcount = Deathcount + 1
    game:changeGameState("ended")
    sounds.music:stop()
end
function love.load()
    game = Game()
    youwinImage = love.graphics.newImage("images/youwin.png")
    gameoverImage = love.graphics.newImage("images/gameover.png")
    startImage = love.graphics.newImage("images/menu.png")
    love.window.setTitle("Elf In the Woods")
    buttons.menu_state.resume_game = button("Resume Game", playGame, nil, 120, 40)
    buttons.menu_state.play_game = button("Play Game", playGame, nil, 120, 40)
    buttons.menu_state.settings = button("Settings", gotoSettings, nil, 120, 40)
    buttons.menu_state.exit_game = button("Exit Game", love.event.quit, nil, 120, 40)
    

    buttons.ended_state.new_game = button("New game",startNewGame, nil, 120, 40)
    buttons.ended_state.next_map= button("Next Map", playGame, nil, 120, 40)
    buttons.ended_state.replay_game = button("Replay", playGame, nil, 120, 40)
    buttons.ended_state.menu = button("Menu", gotoMenu, nil, 120, 40)
    buttons.ended_state.exit_game = button("Quit", love.event.quit, nil, 120, 40)

    camera = require 'libraries/camera'
    cam = camera()
    cam.radius = 150

    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0)
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")
    myPlayer = {}
    myPlayer.x = spawnpoint[level].x
    myPlayer.y = spawnpoint[level].y
    myPlayer.collider = world:newBSGRectangleCollider(myPlayer.x, myPlayer.y, 35, 35, 10)
    myPlayer.collider:setFixedRotation(true)

    myPlayer.speed = 200
    myPlayer.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    myPlayer.grid = anim8.newGrid( 96, 104, myPlayer.spriteSheet:getWidth(),myPlayer.spriteSheet:getHeight() )

    myPlayer.animations = {}
    myPlayer.animations.down = anim8.newAnimation( myPlayer.grid("1-10", 5), 0.1 )
    myPlayer.animations.left = anim8.newAnimation(myPlayer.grid("1-10", 6), 0.1)
    myPlayer.animations.right = anim8.newAnimation(myPlayer.grid("1-10", 8), 0.1)
    myPlayer.animations.up = anim8.newAnimation(myPlayer.grid("1-10", 7), 0.1)
    myPlayer.anim = myPlayer.animations.left
    sti = require 'libraries/sti'
    for i, path in ipairs(mapPaths) do
        gameMaps[i] = sti(path)
    end
    gameMap = gameMaps[1]
    createWallsForMap(gameMaps[1],walls)
end

function love.update(dt)
    local isMoving = false
        local vx = 0
        local vy = 0

    if game.state.ended then
        resetPlayer()
    end
    if game.state.running then
        if love.keyboard.isDown('w') then
            vy = myPlayer.speed * -1
            myPlayer.anim = myPlayer.animations.up
            isMoving = true
        elseif love.keyboard.isDown('s') then
            vy = myPlayer.speed 
            myPlayer.anim = myPlayer.animations.down
            isMoving = true
        end
        if love.keyboard.isDown('a') then
            vx = myPlayer.speed * -1
            myPlayer.anim = myPlayer.animations.left
            isMoving = true
        elseif love.keyboard.isDown('d') then
            vx = myPlayer.speed
            myPlayer.anim = myPlayer.animations.right
            isMoving = true
        end
        local len = math.sqrt(vx * vx + vy * vy)
        if len > myPlayer.speed then
            local normalizeFactor = myPlayer.speed / len
            vx = vx * normalizeFactor
            vy = vy * normalizeFactor
        end
        myPlayer.collider:setLinearVelocity(vx, vy)

        if isMoving == false then
            myPlayer.anim:gotoFrame(1)
        end

        world:update(dt)
        myPlayer.x = myPlayer.collider:getX()
        myPlayer.y = myPlayer.collider:getY()

        myPlayer.anim:update(dt)
        cam:lookAt(myPlayer.x,myPlayer.y)
        local w = love.graphics.getWidth()
        local h = love.graphics.getHeight()

        if cam.x < w/2 then
            cam.x = w/2
        end
        if cam.y < h/2 then
            cam.y = h/2
        end

        local mapW = gameMap.width * gameMap.tilewidth
        local mapH = gameMap.height * gameMap.tileheight
        if cam.x > (mapW - w/2) then
            cam.x = (mapW - w/2)
        end
        if cam.y > (mapH - h/2) then
            cam.y = (mapH - h/2)
        end
        if checkEvent.checkWin(myPlayer.x, myPlayer.y, levelData[level].winSpots, distanceThreshold) then
            Winner = true
            playerWins()
        end
        if checkEvent.checkGameover(myPlayer.x, myPlayer.y, levelData[level].deathSpots, distanceThreshold) then
            Winner = false
            playerLoses()
        end
        
    end

end
function love.draw()
    love.graphics.printf("FPS: "..love.timer.getFPS(), love.graphics.newFont(16), 10, love.graphics.getHeight()- 30,
    love.graphics.getWidth())
    love.graphics.printf("Death Count: "..Deathcount, love.graphics.newFont(16), 10, love.graphics.getHeight()- 50,
    love.graphics.getWidth())
    if (game.state.menu or game.state.paused) then
        love.graphics.reset()
        love.graphics.draw(startImage, 0,0,0,0.46,0.69)
        love.graphics.printf("FPS: "..love.timer.getFPS(), love.graphics.newFont(16), 10, love.graphics.getHeight()- 30,
        love.graphics.getWidth())
        if game.state.menu then
            buttons.menu_state.play_game:draw(330, 220, 17, 10)
        else
            buttons.menu_state.resume_game:draw(330, 220, 17, 10)
        end
        buttons.menu_state.settings:draw(330, 270, 17, 10)
        buttons.menu_state.exit_game:draw(330, 320, 17, 10)
        if Score >= 1 then
            love.graphics.printf("Wins: "..Score, love.graphics.newFont(30), 330, love.graphics.getHeight()- 480,
            love.graphics.getWidth())    
        end
    end
    if (game.state.settings) then
        love.graphics.reset()
        love.graphics.draw(startImage, 0,0,0,0.46,0.69)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("Keybindings", love.graphics.newFont(40), 240, love.graphics.getHeight()- 600,
        love.graphics.getWidth())
        love.graphics.printf("w - moves the player up", love.graphics.newFont(30), 160, love.graphics.getHeight()- 550,
        love.graphics.getWidth())
        love.graphics.printf("s - moves the player down", love.graphics.newFont(30), 160, love.graphics.getHeight()- 510,
        love.graphics.getWidth())
        love.graphics.printf("a - moves the player left", love.graphics.newFont(30), 160, love.graphics.getHeight()- 470,
        love.graphics.getWidth())
        love.graphics.printf("d - moves the player right", love.graphics.newFont(30), 160, love.graphics.getHeight()- 430,
        love.graphics.getWidth())
        love.graphics.printf("< - lowers the volume of the forest song", love.graphics.newFont(29), 160, love.graphics.getHeight()- 390,
        love.graphics.getWidth())
        love.graphics.printf("> - increases the volume of the forest song", love.graphics.newFont(29), 160, love.graphics.getHeight()- 350,
        love.graphics.getWidth())
        love.graphics.printf("m - stops the sound inside the forest", love.graphics.newFont(30), 160, love.graphics.getHeight()- 310,
        love.graphics.getWidth())
        love.graphics.printf("n - plays the sound inside the forest", love.graphics.newFont(30), 160, love.graphics.getHeight()- 270,
        love.graphics.getWidth())
        love.graphics.printf("escape  - brings up the menu", love.graphics.newFont(30), 160, love.graphics.getHeight()- 230,
        love.graphics.getWidth())

        buttons.ended_state.menu:draw(330, 420, 17, 10)
    end
    if (game.state.ended) then
        love.graphics.reset()
        if Winner == true then
            love.graphics.draw(youwinImage,50,0)
            if level < 3 then 
                buttons.ended_state.next_map:draw(330, 220, 17, 10)
            end
        else
            love.graphics.draw(gameoverImage, 150, 100)
            buttons.ended_state.replay_game:draw(330, 220, 17, 10)
        end
        buttons.ended_state.new_game:draw(330, 270, 17, 10)
        buttons.ended_state.exit_game:draw(330, 320, 17, 10)
        
    end
    if (game.state.running) then
        cam:attach()
            love.graphics.stencil(function()love.graphics.circle("fill", myPlayer.x, myPlayer.y, cam.radius)
            end, "replace", 1)
            love.graphics.setStencilTest("greater", 0)
            love.graphics.setColor(255, 255, 255)
            love.graphics.circle("fill", myPlayer.x, myPlayer.y, cam.radius)
            gameMap:drawLayer(gameMap.layers["Road"])
            myPlayer.anim:draw(myPlayer.spriteSheet, myPlayer.x, myPlayer.y, nil, 0.5,nil,50,50)
            love.graphics.reset()
            love.graphics.printf("FPS: "..love.timer.getFPS(), love.graphics.newFont(16), 10, love.graphics.getHeight()- 30,
            love.graphics.getWidth())
            love.graphics.printf("Find the correct hidden stash inside the forest !", love.graphics.newFont(16), 100, love.graphics.getHeight()- 30,
            love.graphics.getWidth())
            -- use it to see the collision walls--->      world:draw()       
        cam:detach()
    end
end

