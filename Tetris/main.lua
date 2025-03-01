-- main.lua
local board = {}
local tetrominoes = {}
local currentTetromino = nil
local isPaused = false

-- parametry
local gridWidth = 10
local gridHeight = 20
local tileSize = 30

-- klocki
local shapes = {
    {{1, 1, 1, 1}},  -- I
    {{1, 1}, {1, 1}}, -- O
    {{1, 1, 0}, {0, 1, 1}}, -- S
    {{0, 1, 1}, {1, 1, 0}}, -- Z
}

-- plansza
function initBoard()
    for y = 1, gridHeight do
        board[y] = {}
        for x = 1, gridWidth do
            board[y][x] = 0  -- 0 oznacza pustą komórkę
        end
    end
end

-- rysowanie planszy
function drawBoard()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if board[y][x] ~= 0 then
                love.graphics.setColor(0, 0, 1)
                love.graphics.rectangle("fill", (x-1) * tileSize, (y-1) * tileSize, tileSize, tileSize)
            end
        end
    end
end

function spawnTetromino()
    local shape = shapes[love.math.random(1, #shapes)]
    currentTetromino = {shape = shape, x = 5, y = 1}  -- pozycja startowa
end

-- Rysowanie aktualnego klocka
function drawTetromino()
    local shape = currentTetromino.shape
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] == 1 then
                love.graphics.setColor(1, 0, 0)  -- czerwony
                love.graphics.rectangle("fill", (currentTetromino.x + x - 1) * tileSize, (currentTetromino.y + y - 1) * tileSize, tileSize, tileSize)
            end
        end
    end
end

function love.update(dt)
    if not isPaused then
        -- przesuwanie klocka w dół
        currentTetromino.y = currentTetromino.y + 1
        if checkCollision() then
            placeTetromino()
            spawnTetromino()
        end
    end
end

function love.keypressed(key)
    if key == "left" then
        currentTetromino.x = currentTetromino.x - 1
        if checkCollision() then currentTetromino.x = currentTetromino.x + 1 end
    elseif key == "right" then
        currentTetromino.x = currentTetromino.x + 1
        if checkCollision() then currentTetromino.x = currentTetromino.x - 1 end
    elseif key == "down" then
        currentTetromino.y = currentTetromino.y + 1
        if checkCollision() then
            currentTetromino.y = currentTetromino.y - 1
            placeTetromino()
            spawnTetromino()
        end
    elseif key == "space" then
        currentTetromino.shape = rotateShape(currentTetromino.shape)
        if checkCollision() then
            currentTetromino.shape = rotateShape(currentTetromino.shape, -1)
        end
    end
end

-- sprawdzanie kolizji
function checkCollision()
    local shape = currentTetromino.shape
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] == 1 then
                local newX = currentTetromino.x + x - 1
                local newY = currentTetromino.y + y - 1
                if newX < 1 or newX > gridWidth or newY > gridHeight or board[newY] and board[newY][newX] ~= 0 then
                    return true
                end
            end
        end
    end
    return false
end

-- umieszczenie klocka na planszy
function placeTetromino()
    local shape = currentTetromino.shape
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] == 1 then
                board[currentTetromino.y + y - 1][currentTetromino.x + x - 1] = 1
            end
        end
    end
end

-- obracanie klocka
function rotateShape(shape)
    local newShape = {}
    for y = 1, #shape do
        newShape[y] = {}
        for x = 1, #shape[y] do
            newShape[y][x] = shape[#shape - x + 1][y]
        end
    end
    return newShape
end

function saveGame()
    local saveData = {
        board = board,
        currentTetromino = {
            shape = currentTetromino.shape,
            x = currentTetromino.x,
            y = currentTetromino.y
        }
    }
    local data = love.filesystem.newFile("save.txt", "w")
    data:write(love.data.encode("string", "base64", love.data.compress("string", "zlib", love.serialize("data", saveData))))
    data:close()
    print("Gra zapisana!")
end

function loadGame()
    if not love.filesystem.getInfo("save.txt") then
        print("Brak zapisu gry.")
        return
    end

    local data = love.filesystem.read("save.txt")
    local decoded = love.data.decompress("string", "zlib", love.data.decode("string", "base64", data))
    local saveData = love.deserialize("data", decoded)

    board = saveData.board
    currentTetromino = saveData.currentTetromino
    print("Gra wczytana!")
end


function love.load()
    initBoard()
    spawnTetromino()
end

function love.draw()
    drawBoard()
    drawTetromino()
end
