-- board.lua
local Board = {}

function Board.load(cellSize, boardSize)
    -- Defaults if none provided
    Board.cellSize = cellSize or 100
    Board.boardSize = boardSize or 8

    -- Calculate board dimensions and center it in the window
    local window_width, window_height = love.graphics.getDimensions()
    Board.boardWidth = Board.boardSize * Board.cellSize
    Board.boardHeight = Board.boardSize * Board.cellSize

    Board.offsetX = (window_width - Board.boardWidth) / 2
    Board.offsetY = (window_height - Board.boardHeight) / 2
end

function Board.draw()
    -- Define colors (values between 0 and 1)
    local lightColor = {240/255, 217/255, 181/255} -- Light square color
    local darkColor  = {181/255, 136/255, 99/255}  -- Dark square color
    
    -- Draw 8x8 squares
    for row = 0, Board.boardSize - 1 do
        for col = 0, Board.boardSize - 1 do
            local color = ((row + col) % 2 == 0) and lightColor or darkColor
            love.graphics.setColor(color)
            love.graphics.rectangle(
                "fill",
                Board.offsetX + col * Board.cellSize,
                Board.offsetY + row * Board.cellSize,
                Board.cellSize,
                Board.cellSize
            )
        end
    end
end

return Board
