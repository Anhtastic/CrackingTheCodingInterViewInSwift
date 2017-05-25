import Foundation

class Piece {
    private var color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func flip() {
        if color == .black {
            color = .white
        } else {
            color = .black
        }
    }
    
    func getColor() -> Color {
        return color
    }
}

enum Color: String {
    case black, white
}


func ==(lhs: Player, rhs: Player) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
class Player {
    var color: Color
    var name: String
    
    
    init(color: Color, name: String) {
        self.color = color
        self.name = name
    }
    
    func getScore() -> Int {
        return Game.sharedInstance.getBoard().getScoreForColor(c: color)
    }
    
    func playPiece(row: Int, col: Int) -> Bool {
        return Game.sharedInstance.getBoard().placeColor(row: row, col: col, color: color)
    }
    
    func getColor() -> Color {
        return color
    }
}

enum Direction {
    case left, right, up, down
}

class Location {
    private var row: Int
    private var col: Int
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    func isSameAs(row: Int, col: Int) -> Bool {
        return self.row == row && self.col == col
    }
    
    func getRow() -> Int {
        return row
    }
    
    func getColumn() -> Int {
        return col
    }
}

class Board {
    private var blackCount = 0
    private var whiteCount = 0
    private var board = [[Piece?]]()
    
    init(row: Int, col: Int) {
        board = [[Piece?]](repeatElement([Piece?](repeatElement(nil, count: col)), count: row))
        // Initializing board with 2 whites and 2 blacks
        let middleRow = (board.count - 1) / 2
        let middleCol = (board[middleRow].count - 1) / 2
        board[middleRow][middleCol] = Piece(color: .white)
        board[middleRow + 1][middleCol] = Piece(color: .black)
        board[middleRow + 1][middleCol + 1] = Piece(color: .white)
        board[middleRow][middleCol + 1] = Piece(color: .black)
        blackCount = 2
        whiteCount = 2
    }
    
    func placeColor(row: Int, col: Int, color: Color) -> Bool {
        if board[row][col] != nil { return false }
        
        var res = [Int](repeatElement(0, count: 4))
        res[0] = flipSection(row: row - 1, col: col, color: color, dir: .up)
        res[1] = flipSection(row: row + 1, col: col, color: color, dir: .down)
        res[2] = flipSection(row: row, col: col + 1, color: color, dir: .right)
        res[3] = flipSection(row: row, col: col - 1, color: color, dir: .left)
        
        var flipped = 0
        for r in res {
            if r > 0 { flipped += r }
        }
        
        if flipped < 0 { return false }
        board[row][col] = Piece(color: color)
        updateScore(newColor: color, newPieces: flipped + 1)
        return true
    }
    
    func flipSection(row: Int, col: Int, color: Color, dir: Direction) -> Int {
        var r = 0
        var c = 0
        
        switch dir {
        case .up:
            r = -1
        case .down:
            r = 1
        case .left:
            c = -1
        case .right:
            c = 1
        }
        
        if row < 0 || row >= board.count || col < 0 || col >= board[row].count || board[row][col] == nil {
            return -1
        }
        
        if board[row][col]?.getColor() == color {
            return 0
        }
        let flipped = flipSection(row: row + r, col: col + c, color: color, dir: dir)
        if flipped < 0 { return -1 }
        
        board[row][col]?.flip()
        return flipped + 1
    }
    
    func getScoreForColor(c: Color) -> Int {
        if c == .black {
            return blackCount
        } else {
            return whiteCount
        }
    }
    
    func updateScore(newColor: Color, newPieces: Int) {
        if newColor == .black {
            whiteCount -= newPieces - 1
            blackCount += newPieces
        } else {
            blackCount -= newPieces - 1
            whiteCount += newPieces
        }
    }
    
    func printBoard() {
        var res = ""
        for r in 0 ..< board.count {
            res += "["
            for c in 0 ..< board[r].count {
                if board[r][c] == nil {
                    res += "_"
                } else if board[r][c]?.getColor() == .white {
                    res += "W"
                } else {
                    res += "B"
                }
            }
            res += "]\n"
        }
        print(res)
    }
    
}
struct Constants {
    static let rows = 6
    static let cols = 6
}

class Game {
    private var players = [Player?]()
    static let sharedInstance = Game(playerNames: ["Player 1", "Player 2"])
    private let rows = Constants.rows
    private let cols = Constants.cols
    private var board: Board
    
    private init(playerNames: [String]) {
        board = Board(row: rows, col: cols)
        let blackPlayer = Player(color: .black, name: playerNames[0])
        let whitePlayer = Player(color: .white, name: playerNames[1])
        players = [blackPlayer, whitePlayer]
    }
    
    func createPlayersNames(names: [String]) {
        if names.count != 2 {
            print("Please enter 2 names")
            return
        }
        players[0] = Player(color: .black, name: names[0])
        players[1] = Player(color: .white, name: names[1])
    }
    
    func getBoard() -> Board {
        return board
    }
}

class TestAutomation {
    
    private var players = [Player]()
    private var lastPlayer = Player(color: .white, name: "CurrentPlayer")
    private var remainingMoves = [Location]()
    static let sharedInstance = TestAutomation()
    private let cols = Constants.rows
    private let rows = Constants.cols
    
    private init() {
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                let loc = Location(row: i, col: j)
                remainingMoves.append(loc)
            }
        }
        let playerOne = Player(color: .black, name: "Player 1")
        let playerTwo = Player(color: .white, name: "Player 2")
        players.append(contentsOf: [playerOne, playerTwo])
        lastPlayer = players[1]
    }
    
    func createPlayersNames(names: [String]) {
        if names.count == 2 {
            players[0] = Player(color: .black, name: names[0])
            players[1] = Player(color: .white, name: names[1])
        } else {
            print("Please add in two players")
            return
        }
    }
    
    func shuffle() {
        for i in 0 ..< remainingMoves.count {
            let t = Int(arc4random_uniform(UInt32(remainingMoves.count)))
            let other = remainingMoves[t]
            let current = remainingMoves[i]
            remainingMoves[t] = current
            remainingMoves[i] = other
        }
    }
    
    func removeLocation(row: Int, col: Int) {
        for i in 0 ..< remainingMoves.count {
            let loc = remainingMoves[i]
            if loc.isSameAs(row: row, col: col) {
                remainingMoves.remove(at: i)
            }
        }
    }
    
    func getLocation(index: Int) -> Location {
        return remainingMoves[index]
    }
    
    func playRandom() -> Bool {
        let board = Game.sharedInstance.getBoard()
        shuffle()
        lastPlayer = (lastPlayer == players[0] ) ? players[1] : players[0]
        let color = lastPlayer.getColor().rawValue
        print("Board is:")
        board.printBoard()
        for i in 0 ..< remainingMoves.count {
            let loc = remainingMoves[i]
            let success = lastPlayer.playPiece(row: loc.getRow(), col: loc.getColumn())
            if success {
                print("Success: \(color) move at (\(loc.getColumn()),\(loc.getColumn()))")
                board.printBoard()
                printScores()
                return true
            }
        }
        print("Game Over. No moves found for \(color)")
        return false
    }
    
    func isOver() -> Bool {
        if players[0].getScore() == 0 || players[1].getScore() == 0 {
            return true
        }
        return false
    }
    
    func printScores() {
        print("Score: Name: \(players[0].name) is \(players[0].getColor().rawValue): \(players[0].getScore()), Name: \(players[1].name) is \(players[1].getColor().rawValue): \(players[1].getScore())")
    }
    
    func getPlayers() -> [Player] {
        return players
    }
}

let test = TestAutomation.sharedInstance
test.createPlayersNames(names: ["Anh", "Off"])

while !test.isOver() && test.playRandom() {
    
}




