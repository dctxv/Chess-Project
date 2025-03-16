-- pieces.lua
local Pieces = {}
Pieces.list = {}

function Pieces.load()
    -- Load piece images (ensure these files exist in the assets folder)
    Pieces.king_white = love.graphics.newImage("assets/king_white.png")
    Pieces.king_black = love.graphics.newImage("assets/king_black.png")

    -- Add two kings to demonstrate positioning
    table.insert(Pieces.list, {
        type  = "king",
        color = "white",
        image = Pieces.king_white,
        row   = 7,
        col   = 4
    })
    table.insert(Pieces.list, {
        type  = "king",
        color = "black",
        image = Pieces.king_black,
        row   = 0,
        col   = 4
    })
end

function Pieces.draw(Board)
    for _, piece in ipairs(Pieces.list) do
        -- Calculate position in pixels based on the board's offset and cell size
        local x = Board.offsetX + piece.col * Board.cellSize
        local y = Board.offsetY + piece.row * Board.cellSize
        
        -- Reset color so the piece image is drawn accurately
        love.graphics.setColor(1, 1, 1)

        -- Scale the piece to fit into the cell
        local scaleX = Board.cellSize / piece.image:getWidth()
        local scaleY = Board.cellSize / piece.image:getHeight()

        -- Draw the piece
        love.graphics.draw(piece.image, x, y, 0, scaleX, scaleY)
    end
end

return Pieces
