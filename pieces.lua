-- pieces.lua
local Pieces = {}
Pieces.list = {}  -- This will hold the active pieces

function Pieces.load()
    -- Load piece images from your assets folder.
    Pieces.king_white    = love.graphics.newImage("assets/king_white.png")
    Pieces.king_black    = love.graphics.newImage("assets/king_black.png")
    Pieces.queen_white   = love.graphics.newImage("assets/queen_white.png")
    Pieces.queen_black   = love.graphics.newImage("assets/queen_black.png")
    Pieces.knight_white  = love.graphics.newImage("assets/knight_white.png")
    Pieces.knight_black  = love.graphics.newImage("assets/knight_black.png")
    Pieces.bishop_white  = love.graphics.newImage("assets/bishop_white.png")
    Pieces.bishop_black  = love.graphics.newImage("assets/bishop_black.png")
    Pieces.rook_white    = love.graphics.newImage("assets/rook_white.png")
    Pieces.rook_black    = love.graphics.newImage("assets/rook_black.png")
    Pieces.pawn_white    = love.graphics.newImage("assets/pawn_white.png")
    Pieces.pawn_black    = love.graphics.newImage("assets/pawn_black.png")
    
    -- (Optionally, initialize Pieces.list with default pieces if needed)
end

function Pieces.draw(Board, boardX, boardY, boardWidth, boardHeight)
    local cellW = boardWidth / Board.boardSize
    local cellH = boardHeight / Board.boardSize
    for _, piece in ipairs(Pieces.list) do
        local x = boardX + piece.col * cellW
        local y = boardY + piece.row * cellH
        love.graphics.setColor(1, 1, 1)
        local scaleX = cellW / piece.image:getWidth()
        local scaleY = cellH / piece.image:getHeight()
        love.graphics.draw(piece.image, x, y, 0, scaleX, scaleY)
    end
end

function Pieces.getPieceAt(row, col)
    for i, piece in ipairs(Pieces.list) do
        if piece.row == row and piece.col == col then
            return i, piece
        end
    end
    return nil, nil
end


return Pieces
