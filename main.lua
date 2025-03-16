-- main.lua
local Board = require("board")
local Pieces = require("pieces")
local Puzzle = require("puzzle")

-- Global variables
selectedPiece = nil
puzzleNumber = 0
score = 0
moveCount = 0

function getPieceAt(row, col)
    for i, piece in ipairs(Pieces.list) do
        if piece.row == row and piece.col == col then
            return i, piece
        end
    end
    return nil, nil
end

-- Check if a tile is blocked
function isBlockedTile(row, col)
    for _, tile in ipairs(Board.blockedTiles) do
        if tile.row == row and tile.col == col then
            return true
        end
    end
    return false
end

-- King: can move one square in any direction.
function isValidKingMove(piece, targetRow, targetCol)
    local rowDiff = math.abs(targetRow - piece.row)
    local colDiff = math.abs(targetCol - piece.col)
    return rowDiff <= 1 and colDiff <= 1
end

-- Queen: can move in straight lines or diagonals
function isValidQueenMove(piece, targetRow, targetCol)
    local rowDiff = targetRow - piece.row
    local colDiff = targetCol - piece.col

    local stepRow = rowDiff ~= 0 and (rowDiff / math.abs(rowDiff)) or 0
    local stepCol = colDiff ~= 0 and (colDiff / math.abs(colDiff)) or 0

    -- Check if move is straight or diagonal
    if math.abs(rowDiff) ~= math.abs(colDiff) and rowDiff ~= 0 and colDiff ~= 0 then
        return false, "Queen must move straight or diagonally."
    end

    -- Check for pieces in between
    local currentRow, currentCol = piece.row + stepRow, piece.col + stepCol
    while currentRow ~= targetRow or currentCol ~= targetCol do
        local _, blockingPiece = Pieces.getPieceAt(currentRow, currentCol)
        if blockingPiece then
            return false, "Queen cannot jump over pieces."
        end
        currentRow = currentRow + (stepRow ~= 0 and (rowDiff / math.abs(rowDiff)) or 0)
        currentCol = currentCol + (colDiff ~= 0 and (colDiff / math.abs(colDiff)) or 0)
    end

    return true
end


-- Knight: standard L-shaped move.
function isValidKnightMove(piece, targetRow, targetCol)
    local rowDiff = math.abs(targetRow - piece.row)
    local colDiff = math.abs(targetCol - piece.col)
    return (rowDiff == 2 and colDiff == 1) or (rowDiff == 1 and colDiff == 2)
end

-- Bishop: diagonal moves.
function isValidBishopMove(piece, targetRow, targetCol)
    local rowDiff = math.abs(targetRow - piece.row)
    local colDiff = math.abs(targetCol - piece.col)
    if rowDiff == colDiff then
        return true
    else
        return false, "Invalid Move for Bishop."
    end
end

-- Rook: horizontal or vertical moves.
function isValidRookMove(piece, targetRow, targetCol)
    return piece.row == targetRow or piece.col == targetCol
end

-- Pawn: basic forward move (adjust for your rules).
function isValidPawnMove(piece, targetRow, targetCol, targetPiece)
    local direction = piece.color == "white" and -1 or 1
    if targetPiece then
        -- Capture: pawn moves diagonally
        return (math.abs(piece.col - targetCol) == 1 and targetRow - piece.row == direction)
    else
        -- Regular move: move forward one square
        return (piece.col == targetCol and targetRow - piece.row == direction)
    end
end


function love.load()
    -- Set the window size
    love.window.setMode(1000, 600)

    -- Define layout constants
    SCORE_X = 0
    SCORE_Y = 0
    SCORE_WIDTH = 200
    SCORE_HEIGHT = 100

    STOPWATCH_X = 0
    STOPWATCH_Y = SCORE_Y + SCORE_HEIGHT
    STOPWATCH_WIDTH = 200
    STOPWATCH_HEIGHT = 100

    BOARD_X = SCORE_WIDTH
    BOARD_Y = 0
    BOARD_WIDTH = 800
    BOARD_HEIGHT = 600

    -- Initialize the Board module for a 5x5 board
    Board.load(100, 5)  -- cellSize=100, boardSize=5
    Board.blockedTiles = {}  -- clear any blocked tiles

    -- Load pieces, then generate the initial puzzle
    Pieces.load()
    Puzzle.generate(Pieces, Board)

    -- Initialize puzzle counters
    puzzleNumber = 1
    moveCount = 0
    score = 0
end


function love.draw()
    ---------------------------------------------------
    -- 1) Draw Score area
    ---------------------------------------------------
    love.graphics.setColor(0.85, 0.85, 0.85)
    love.graphics.rectangle("fill", SCORE_X, SCORE_Y, SCORE_WIDTH, SCORE_HEIGHT)
    love.graphics.setColor(0, 0, 0)
    -- Show puzzle info, score, and moves in the "score" area
    love.graphics.print("Puzzle: " .. puzzleNumber, SCORE_X + 10, SCORE_Y + 10)
    love.graphics.print("Score: " .. score, SCORE_X + 10, SCORE_Y + 30)
    love.graphics.print("Moves: " .. moveCount, SCORE_X + 10, SCORE_Y + 50)

    ---------------------------------------------------
    -- 2) Draw Stopwatch area
    ---------------------------------------------------
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.rectangle("fill", STOPWATCH_X, STOPWATCH_Y, STOPWATCH_WIDTH, STOPWATCH_HEIGHT)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("STOPWATCH (placeholder)", STOPWATCH_X + 10, STOPWATCH_Y + 10)

    ---------------------------------------------------
    -- 3) Draw Chess Board background
    ---------------------------------------------------
    love.graphics.setColor(0.95, 0.95, 0.95)
    love.graphics.rectangle("fill", BOARD_X, BOARD_Y, BOARD_WIDTH, BOARD_HEIGHT)

    ---------------------------------------------------
    -- 4) Draw the board squares and pieces
    ---------------------------------------------------
    -- Make sure your Board.draw() and Pieces.draw() are defined in their respective modules.
    love.graphics.setColor(1, 1, 1)
    Board.draw(BOARD_X, BOARD_Y, BOARD_WIDTH, BOARD_HEIGHT)    -- e.g., draws 5x5 squares
    Pieces.draw(Board, BOARD_X, BOARD_Y, BOARD_WIDTH, BOARD_HEIGHT) -- draws pieces

    ---------------------------------------------------
    -- 5) Highlight the selected piece
    ---------------------------------------------------
    if selectedPiece then
        love.graphics.setColor(1, 0, 0)
        local cellWidth  = BOARD_WIDTH / Board.boardSize
        local cellHeight = BOARD_HEIGHT / Board.boardSize
        local x = BOARD_X + selectedPiece.col * cellWidth
        local y = BOARD_Y + selectedPiece.row * cellHeight
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", x, y, cellWidth, cellHeight)
    end
end

function love.keypressed(key)
    if key == "r" then
        -- Randomize puzzle
        Puzzle.generate(Pieces, Board)
        puzzleNumber = puzzleNumber + 1
        moveCount = 0
    elseif key == "space" then
        -- Example puzzle completion (scoring) logic
        local pointsAwarded = math.max(100 - (moveCount * 10), 10)
        score = score + pointsAwarded
        print("Puzzle solved! Moves: " .. moveCount .. " | Points awarded: " .. pointsAwarded)
        Puzzle.generate(Pieces, Board)
        puzzleNumber = puzzleNumber + 1
        moveCount = 0
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if x < BOARD_X or y < BOARD_Y or x > (BOARD_X + BOARD_WIDTH) or y > (BOARD_Y + BOARD_HEIGHT) then
            return
        end

        local cellWidth  = BOARD_WIDTH / Board.boardSize
        local cellHeight = BOARD_HEIGHT / Board.boardSize
        local col = math.floor((x - BOARD_X) / cellWidth)
        local row = math.floor((y - BOARD_Y) / cellHeight)

        if not selectedPiece then
            local _, piece = Pieces.getPieceAt(row, col)
            if piece then
                selectedPiece = piece
            end
        else
            local targetIndex, targetPiece = Pieces.getPieceAt(row, col)
            local validMove = false
            local errorMsg = nil

            -- Ensure destination isn't blocked
            if isBlockedTile(row, col) then
                print("Cannot move: square blocked.")
                selectedPiece = nil
                return
            end

            -- Validate move based on piece type
            if selectedPiece.type == "king" then
                validMove = isValidKingMove(selectedPiece, row, col)
                if not validMove then errorMsg = "Invalid Move for King." end
            elseif selectedPiece.type == "queen" then
                validMove = isValidQueenMove(selectedPiece, row, col)
                if not validMove then errorMsg = "Invalid Move for Queen." end
            elseif selectedPiece.type == "knight" then
                validMove = isValidKnightMove(selectedPiece, row, col)
                if not validMove then errorMsg = "Invalid Move for Knight." end
            elseif selectedPiece.type == "bishop" then
                validMove, errorMsg = isValidBishopMove(selectedPiece, row, col)
            elseif selectedPiece.type == "rook" then
                validMove = isValidRookMove(selectedPiece, row, col)
                if not validMove then errorMsg = "Invalid Move for Rook." end
            elseif selectedPiece.type == "pawn" then
                validMove, errorMsg = isValidPawnMove(selectedPiece, row, col, targetPiece)
            end

            -- Prevent moving onto blocked tile
            if isBlockedTile(row, col) then
                validMove = false
                errorMsg = "Square is blocked."
            end

            -- Check if target tile has a friendly piece
            if targetPiece and targetPiece.color == selectedPiece.color then
                validMove = false
                errorMsg = "Cannot capture own piece."
            end

            if validMove then
                -- Capture enemy piece and block tile if enemy present
                if targetPiece and targetPiece.color ~= selectedPiece.color then
                    table.insert(Board.blockedTiles, {row = row, col = col})
                    table.remove(Pieces.list, targetIndex)
                end
                -- Move the selected piece
                selectedPiece.row = row
                selectedPiece.col = col
                moveCount = moveCount + 1
            else
                if errorMsg then
                    print(errorMsg)
                else
                    print("Invalid move for " .. selectedPiece.type)
                end
            end

            selectedPiece = nil
        end
    end
end

