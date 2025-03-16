-- main.lua
local Board = require("board")
local Pieces = require("pieces")

-- Global variable to track the currently selected piece
selectedPiece = nil

function love.load()
    -- Create an 800×800 window
    love.window.setMode(800, 800)

    -- Initialize the board (8x8, each cell is 100 pixels)
    Board.load(100, 8)

    -- Load the chess pieces (e.g., kings)
    Pieces.load()
end

function love.draw()
    -- Draw the chessboard squares
    Board.draw()

    -- Draw the pieces on top of the board
    Pieces.draw(Board)

    -- If a piece is selected, draw a red outline around its cell
    if selectedPiece then
        love.graphics.setColor(1, 0, 0)  -- red color for highlight
        local x = Board.offsetX + selectedPiece.col * Board.cellSize
        local y = Board.offsetY + selectedPiece.row * Board.cellSize
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", x, y, Board.cellSize, Board.cellSize)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then  -- left mouse button
        -- Ensure the click is within the board boundaries
        if x < Board.offsetX or y < Board.offsetY or
           x > (Board.offsetX + Board.boardWidth) or y > (Board.offsetY + Board.boardHeight) then
            return
        end

        -- Convert mouse coordinates to board coordinates (col, row)
        local col = math.floor((x - Board.offsetX) / Board.cellSize)
        local row = math.floor((y - Board.offsetY) / Board.cellSize)

        if not selectedPiece then
            -- If no piece is selected, check if a piece exists at the clicked square
            for _, piece in ipairs(Pieces.list) do
                if piece.row == row and piece.col == col then
                    selectedPiece = piece
                    break
                end
            end
        else
            -- If a piece is selected, move it to the clicked square
            selectedPiece.row = row
            selectedPiece.col = col
            selectedPiece = nil  -- Clear selection after moving
        end
    end
end
