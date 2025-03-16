-- puzzle.lua
local Puzzle = {}

-- Helper function: Fisher-Yates shuffle
local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

local pieceTypes = {"queen", "knight", "bishop", "rook", "pawn"}
local colors = {"white", "black"}

function Puzzle.generate(Pieces, Board)
    Pieces.list = {}
    Board.blockedTiles = {}

    local positions = {}
    for row = 0, Board.boardSize - 1 do
        for col = 0, Board.boardSize - 1 do
            table.insert(positions, {row = row, col = col})
        end
    end

    shuffle(positions)

    -- Mandatory pieces (Kings)
    local whiteKingPos = table.remove(positions, 1)
    table.insert(Pieces.list, {
        type = "king", color = "white",
        image = Pieces.king_white,
        row = whiteKingPos.row, col = whiteKingPos.col
    })

    local blackKingPos = table.remove(positions, 1)
    table.insert(Pieces.list, {
        type = "king", color = "black",
        image = Pieces.king_black,
        row = blackKingPos.row, col = blackKingPos.col
    })

    -- Randomize additional pieces (up to 7 total)
    local totalPieces = 2 -- already placed kings
    while totalPieces < 7 and #positions > 0 do
        local pos = table.remove(positions, 1)
        local pieceType = pieceTypes[math.random(#pieceTypes)]
        local color = colors[math.random(#colors)]
        local imageKey = pieceType .. "_" .. color
        table.insert(Pieces.list, {
            type = pieceType, color = color,
            image = Pieces[ pieceType .. "_" .. color ],
            row = pos.row, col = pos.col
        })
        totalPieces = totalPieces + 1
    end

    print("New puzzle generated with " .. #Pieces.list .. " pieces.")
end

return Puzzle -- Important: return the Puzzle table at the end
