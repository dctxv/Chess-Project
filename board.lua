-- board.lua
local Board = {}

function Board.load(cellSize, boardSize)
    Board.cellSize = cellSize or 100
    Board.boardSize = boardSize or 5  -- now a 5x5 board

    local window_width, window_height = love.graphics.getDimensions()
    Board.boardWidth = Board.boardSize * Board.cellSize
    Board.boardHeight = Board.boardSize * Board.cellSize

    Board.offsetX = (window_width - Board.boardWidth) / 2
    Board.offsetY = (window_height - Board.boardHeight) / 2

    -- Table for blocked tiles (each entry is a table {row, col})
    Board.blockedTiles = {}
end

function Board.draw(boardX, boardY, boardWidth, boardHeight)
    local cellW = boardWidth / Board.boardSize
    local cellH = boardHeight / Board.boardSize

    -- Draw the board squares.
    for row = 0, Board.boardSize - 1 do
        for col = 0, Board.boardSize - 1 do
            local color = ((row + col) % 2 == 0) and {0.8, 0.8, 0.8} or {0.6, 0.6, 0.6}
            love.graphics.setColor(color)
            love.graphics.rectangle("fill", boardX + col * cellW, boardY + row * cellH, cellW, cellH)
        end
    end

    -- Draw blocked tiles with a semi-transparent red overlay.
    love.graphics.setColor(1, 0, 0, 0.6)
    for _, tile in ipairs(Board.blockedTiles) do
        love.graphics.rectangle("fill", boardX + tile.col * cellW, boardY + tile.row * cellH, cellW, cellH)
    end
    love.graphics.setColor(1, 1, 1)
end




return Board
