//: Playground - noun: a place where people can play

import UIKit

//  Minesweeper: Design and implement a text-based Minesweeper game. Minesweeper is the classic single-player computer game where an NxN grid has B mines (or bombs) hidden across the grid. The remaining cells are either blank or have a number behind them. The numbers reflect the number of bombs in the surrounding eight cells. The user then uncovers a cell. If it is a bomb, the player loses. If it is a number, the number is exposed. If it is a blank cell, this cell and all adjacent blank cells (up to and including the surrounding numeric cells) are exposed. The player wins when all non-bomb cells are exposed. The player can also flag certain places as potential bombs. This doesn't affect game play, other than to block the user from accidentally clicking a cell that is thought to have a bomb. (Tip for the reader: if you're not familiar with this game, please playa few rounds online first.)

class Cell {
    private var row: Int
    private var col: Int
    private var isBomb = false
    private var number = 0
    private var isExposed = false
    private var isGuess = false
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    func setRowAndColumn(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    func setBomb(bomb: Bool) {
        isBomb = bomb
        number -= 1
    }
    
    func incrementNumber() {
        number += 1
    }
    
    func getRow() -> Int {
        return row
    }
    
    func getColumn() -> Int {
        return col
    }
    
    func isABomb() -> Bool {
        return isBomb
    }
    
    func isBlank() -> Bool {
        return number == 0
    }
    
    func isExpose() -> Bool {
        return isExposed
    }
    
    func flip() -> Bool {
        isExposed = true
        return !isBomb
    }
    
    func toggleGuess() -> Bool {
        if !isExposed {
            isGuess = !isGuess
        }
        return isGuess
    }
    
    func isGuessed() -> Bool {
        return isGuess
    }
    
    func toString() -> String {
        return getUndersideState()
    }
    
    func getSurfaceState() -> String {
        if isExposed {
            return getUndersideState()
        } else if isGuess {
            return "B"
        } else {
            return "?"
        }
    }
    
    func getUndersideState() -> String {
        if isBomb {
            return "*"
        } else if number > 0 {
            return String(number)
        } else {
            return " "
        }
    }
}

class Board {
    var nRows: Int
    var nColumns: Int
    var nBombs = 0
    var cells = [[Cell]]()
    var bombs = [Cell]()
    var numUnexposeRemaining: Int
    
    
    init(row: Int, col: Int, b: Int) {
        nRows = row
        nColumns = col
        nBombs = b
        
        numUnexposeRemaining = nRows * nColumns - nBombs
        initializeBoard()
        shuffleBoard()
    }
    
    func initializeBoard() {
        cells = [[Cell]](repeatElement([Cell](repeatElement(Cell(row: 0, col: 0), count: nRows)), count: nColumns))
        bombs = [Cell](repeatElement(Cell(row: 0, col: 0), count: nBombs))
        for r in 0 ..< nRows {
            for c in 0 ..< nColumns {
                cells[r][c] = Cell(row: r, col: c)
            }
        }
        
        for i in 0 ..< nBombs {
            let r = i / nColumns
            let c = (i - r * nColumns) % nColumns
            bombs[i] = cells[r][c]
            bombs[i].setBomb(bomb: true)
        }
    }
    
    func shuffleBoard() {
        let nCells = nRows * nColumns
        for index1 in 0 ..< nCells {
            let index2 = index1 + Int(arc4random_uniform(UInt32(nCells - index1)))
            if index1 != index2 {
                let row1 = index1/nColumns
                let column1 = (index1 - row1 * nColumns) % nColumns
                let cell1 = cells[row1][column1]
                
                let row2 = index2/nColumns
                let column2 = (index2 - row2 * nColumns) % nColumns
                let cell2 = cells[row2][column2]
                
                cells[row1][column1] = cell2
                cell2.setRowAndColumn(row: row1, col: column1)
                cells[row2][column2] = cell1
                cell1.setRowAndColumn(row: row2, col: column2)
            }
        }
    }
    
    func setNumberedCells() {
        let deltas = [
            [-1, -1], [-1, 0], [-1, 1],
            [ 0, -1],          [ 0, 1],
            [ 1, -1], [ 1, 0], [ 1, 1]
        ]
        
        for bomb in bombs {
            let row = bomb.getRow()
            let col = bomb.getColumn()
            for delta in deltas {
                let r = row + delta[0]
                let c = col + delta[1]
                if inBounds(row: r, col: c) {
                    cells[r][c].incrementNumber()
                }
            }
        }
    }
    
    func printBoard(showUnderside: Bool) {
        var res = String()
        for r in 0 ..< nRows {
            var row = "Row \(r)|"
            for c in 0 ..< nColumns {
                if showUnderside {
                    row.append("\(cells[r][c].getUndersideState())|")
                } else {
                    row.append("\(cells[r][c].getSurfaceState())|")
                }
            }
            res.append(row)
            res.append("\n")
        }
        print(res)
    }
    
    func flipCell(cell: Cell) -> Bool {
        if !cell.isExpose() && !cell.isGuessed() {
            cell.flip()
            numUnexposeRemaining -= 1
            return true
        }
        return false
    }
    
    func inBounds(row: Int, col: Int) -> Bool {
        return row >= 0 && row < nRows && col >= 0 && col < nColumns
    }
    
    func expandBlank(cell: Cell) {
        let deltas = [
            [-1, -1], [-1, 0], [-1, 1],
            [ 0, -1],          [ 0, 1],
            [ 1, -1], [ 1, 0], [ 1, 1]
        ]
        
        var toExplore = [Cell]() // Better to implement a linked list here because removing from head is more efficient!
        toExplore.append(cell)
        while !toExplore.isEmpty {
            let current = toExplore.removeFirst()
            
            for delta in deltas {
                let r = current.getRow() + delta[0]
                let c = current.getColumn() + delta[1]
                if inBounds(row: r, col: c) {
                    let neighbor = cells[r][c]
                    if flipCell(cell: neighbor) && neighbor.isBlank() {
                        toExplore.append(neighbor)
                    }
                }
            }
        }
    }
    
    func playFlip(play: UserPlay) -> UserPlayResult {
        let cell = getCellAtLocation(play: play)
        if cell == nil { return UserPlayResult(successful: false, resultingState: .running) }
        if play.isGuess {
            let guessResult = cell!.toggleGuess()
            return UserPlayResult(successful: guessResult, resultingState: .running)
        }
        let result = flipCell(cell: cell!)
        if cell!.isABomb() {
            return UserPlayResult(successful: result, resultingState: .lost)
        }
        
        if cell!.isBlank() {
            expandBlank(cell: cell!)
        }
        
        if numUnexposeRemaining == 0 {
            return UserPlayResult(successful: result, resultingState: .won)
        }
        
        return UserPlayResult(successful: result, resultingState: .running)
    }
    
    func getCellAtLocation(play: UserPlay) -> Cell? {
        let row = play.getRow()
        let col = play.getColumn()
        if !inBounds(row: row, col: col) {
            return nil
        }
        return cells[row][col]
    }
    
    func getNumRemaining() -> Int {
        return numUnexposeRemaining
    }
}

class UserPlay {
    var row: Int
    var col: Int
    var isGuess: Bool
    
    init(row: Int, col: Int, guess: Bool) {
        self.row = row
        self.col = col
        isGuess = guess
    }

    func isGuessed() -> Bool {
        return isGuess
    }
    
    func isMove() -> Bool {
        return !isMove()
    }
    
    func getColumn() -> Int {
        return col
    }
    
    func setColumn(col: Int) {
        self.col = col
    }
    
    func getRow() -> Int {
        return row
    }
    
    func setRow(row: Int) {
        self.row = row
    }
    
}

class UserPlayResult {
    var successful = false
    var resultingState: Game.GameState
    init(successful: Bool, resultingState: Game.GameState) {
        self.successful = successful
        self.resultingState = resultingState
    }
    
    func successfullMove() -> Bool {
        return successful
    }
    
    func getResultingState() -> Game.GameState {
        return resultingState
    }
}

class Game {
    enum GameState {
        case won, lost, running
    }
    
    private var board: Board?
    private var rows: Int
    private var columns: Int
    private var bombs: Int
    private var state = GameState.running
    
    
    init(rows: Int, columns: Int, bombs: Int) {
        self.rows = rows
        self.columns = columns
        self.bombs = bombs
        
    }
    
    func initialize() -> Bool {
        if board == nil {
            board = Board(row: rows, col: columns, b: bombs)
            board?.setNumberedCells()
            board?.printBoard(showUnderside: true)
            return true
        } else {
            print("Game has already been initialized!")
            return false
        }
    }
    
    
    func start() -> Bool {
        if board == nil { initialize() }
        return playGame()
    }
    
    func printGamestate() {
        if state == .lost {
            board?.printBoard(showUnderside: true)
            print("FAIL")
        } else if state == .won {
            board?.printBoard(showUnderside: true)
            print("WIN")
        } else {
            print("Number remaining: \(board!.getNumRemaining())")
            board?.printBoard(showUnderside: false)
        }
    }
    
    func playGame() -> Bool {
        printGamestate()
        while state == .running {
            let r = Int(arc4random_uniform(UInt32(rows)))
            let c = Int(arc4random_uniform(UInt32(columns)))
            print("Selecting row: \(r), column: \(c)")
            playMove(row: r, col: c, guess: false)
            printGamestate()
        }
        print("Game Over")
        return true
    }
    
    func playMove(row: Int, col: Int, guess: Bool) {
        let userPlay = UserPlay(row: row, col: col, guess: guess)
        let userPlayResult = board?.playFlip(play: userPlay)
        if userPlayResult?.getResultingState() == .lost {
            state = .lost
        } else if userPlayResult?.getResultingState() == .won {
            state = .won
        }
    }
}



//let game = Game(rows: 5, columns: 5, bombs: 3)
//game.start()






















