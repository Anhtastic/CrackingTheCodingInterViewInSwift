//: Playground - noun: a place where people can play

import UIKit

//  Jigsaw: Implement an NxN jigsaw puzzle. Design the data structures and explain an algorithm to solve the puzzle. You can assume that you have a fitsWith method which, when passed two puzzle edges, returns true if the two edges belong together.

enum Shape {
    
    case inner, outer, flat
    
    func getOpposite() -> Shape? {
        switch self {
        case .inner:
            return .outer
        case .outer:
            return .inner
        default:
            return nil
        }
    }
    
}

func ==(lhs: Edge, rhs: Edge) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

class Edge: Equatable {
    private var shape: Shape
    private var code: String
    private var parentPiece: Piece?
    
    init(shape: Shape, code: String) {
        self.shape = shape
        self.code = code
    }
    
    private func getCode() -> String {
        return code
    }
    
    func createMatchingEdge() -> Edge? {
        if shape == .flat { return nil }
        return Edge(shape: shape.getOpposite()!, code: getCode())
    }
    
    func fitsWith(edge: Edge) -> Bool {
        return edge.getCode() == getCode()
    }
    
    func setParentPiece(parentPiece: Piece) {
        self.parentPiece = parentPiece
    }
    
    func getParentPiece() -> Piece? {
        return parentPiece
    }
    
    func getShape() -> Shape {
        return shape
    }
    
    func toString() -> String {
        return code
    }
}

enum Orientation: Int {
    case left = 0, top, right, bottom
    
    static let values = [left, top, right, bottom]

    
    func getOpposite() -> Orientation {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .top:
            return .bottom
        case .bottom:
            return .top
        }
    }
    
}

func ==(lhs: Piece, rhs: Piece) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
class Piece: Equatable {
    
    private let numberOfEdges = 4
    private var edges = [Orientation: Edge]()
    
    init(edgeList: [Edge]) {
        let orientations = Orientation.values
        for i in 0 ..< edgeList.count {
            let edge = edgeList[i]
            edge.setParentPiece(parentPiece: self)
            edges[orientations[i]] = edge
        }
    }
    
    private func getOrientation(edge: Edge) -> Orientation? {
        for entry in edges {
            if entry.value == edge {
                return entry.key
            }
        }
        return nil
    }
    
    func rotateEdgesby(numberRotations: Int) {
        let orientations = Orientation.values
        var rotated = [Orientation: Edge]()
        var numberRotations = numberRotations % numberOfEdges
        if numberRotations < 0 { // CHECK, HOW CAN IT EVER BE LESS THAN 0?
            numberRotations += numberOfEdges
        }
        
        for i in 0 ..< orientations.count {
                let oldOrientation = orientations[(i - numberRotations + numberOfEdges) % numberOfEdges]
            let newOrientation = orientations[i]
            rotated[newOrientation] = edges[oldOrientation]
        }
        edges = rotated
    }
    
    func setEdgeAsOrientation(edge: Edge, orientation: Orientation) {
        let currentOrientation = getOrientation(edge: edge)
        rotateEdgesby(numberRotations: orientation.rawValue - currentOrientation!.rawValue)
    }
    
    func isCorner() -> Bool {
        let orientations = Orientation.values
        for i in 0 ..< orientations.count {
            let current = edges[orientations[i]]?.getShape()
            let next = edges[orientations[(i+1) % numberOfEdges]]?.getShape()
            if current == .flat && next == .flat {
                return true
            }
        }
        return false
    }
    
    func isBorder() -> Bool {
        let orientations = Orientation.values
        for i in 0 ..< orientations.count {
            if edges[orientations[i]]?.getShape() == .flat {
                return true
            }
        }
        return false
    }
    
    func getEdgeWithOrientation(orientation: Orientation) -> Edge {
        return edges[orientation]!
    }
    
    func getMatchingEdge(targetEdge: Edge) -> Edge? {
        for edge in edges.values {
            if targetEdge.fitsWith(edge: edge) {
                return edge
            }
        }
        
        return nil
    }
    
    func toString() -> String {
        var rval = "["
        let orientations = Orientation.values
        for o in orientations {
            rval += ("\(edges[o]!.toString()),\(edges[o]!.getShape()) ")
        }
        
        return rval + "]"
    }
}

class Puzzle {
    private var pieces = [Piece]() // USING LINKEDLIST,  BUT ARRAY FOR NOW
    private var solution = [[Piece]]()
    private var size: Int
    
    init(size: Int, pieces: [Piece]) {
        self.pieces = pieces
        self.size = size
    }
    
    func groupPieces(cornerPieces: inout [Piece], borderPieces: inout [Piece], insidePieces: inout [Piece]) {
        for p in pieces {
            if p.isCorner() {
                cornerPieces.append(p)
            } else if p.isBorder() {
                borderPieces.append(p)
            } else {
                insidePieces.append(p)
            }
        }
        print("\nBeginning to group the pieces by separating into corner, border, and inside pieces:")
        var cornerString = "[ "
        var borderString = "[ "
        var insideString = "[ "
        for p in cornerPieces {
            cornerString.append("\(p.toString()), ")
        }
        for p in borderPieces {
            borderString.append("\(p.toString()), ")
        }
        for p in insidePieces {
            insideString.append("\(p.toString()), ")
        }
        print("Corner Pieces are: \(cornerString)]")
        print("Border Pieces are: \(borderString)]")
        print("Inside Pieces are: \(insideString)]")

    }
    
    func orientTopLeftCorner(piece: Piece) {
        if !piece.isCorner() { return }
        
        let orientations = Orientation.values
        for i in 0 ..< orientations.count {
            let current = piece.getEdgeWithOrientation(orientation: orientations[i])
            let next = piece.getEdgeWithOrientation(orientation: orientations[(i + 1) % orientations.count])
            if current.getShape() == .flat && next.getShape() == .flat {
                piece.setEdgeAsOrientation(edge: current, orientation: .left)
                return
            }
        }
    }
    
    func isBorderIndex(location: Int) -> Bool {
        return location == 0 || location == size - 1
    }
    
    func getMatchingEdge(targetEdge: Edge, pieces: [Piece]) -> Edge? {
        for p in pieces {
            let matchingEdge = p.getMatchingEdge(targetEdge: targetEdge)
            if matchingEdge != nil { return matchingEdge! }
        }
        return nil
    }
    
    func setEdgeInSolution(pieces: inout [Piece], edge: Edge, row: Int, col: Int, orientation: Orientation) {
        let piece = edge.getParentPiece()!
        piece.setEdgeAsOrientation(edge: edge, orientation: orientation)
        for i in 0 ..< pieces.count { // CHECK
            if pieces[i] == piece {
                pieces.remove(at: i)
                break
            }
        }
        solution[row][col] = piece
    }
    
    func getPieceListToSearch(cornerPieces: [Piece], borderPieces: [Piece], insidePieces: [Piece], row: Int, col: Int) -> [Piece] {
        if isBorderIndex(location: row) && isBorderIndex(location: col) {
            return cornerPieces
        } else if isBorderIndex(location: row) || isBorderIndex(location: col) {
            return borderPieces
        } else {
            return insidePieces
        }
    }
    
    func fitNextEdge(piecesToSearch: inout [Piece], row: Int, col: Int) -> Bool {
        if row == 0 && col == 0 {
            let p = piecesToSearch.removeFirst()
            orientTopLeftCorner(piece: p)
            solution[0][0] = p
        } else {
            let pieceToMatch = col == 0 ? solution[row - 1][0] : solution[row][col - 1]
            let orientationToMatch = col == 0 ? Orientation.bottom : Orientation.right
            let edgeToMatch = pieceToMatch.getEdgeWithOrientation(orientation: orientationToMatch)
            
            let edge = getMatchingEdge(targetEdge: edgeToMatch, pieces: piecesToSearch)
            if edge == nil { return false }
            
            let orientation = orientationToMatch.getOpposite()
            setEdgeInSolution(pieces: &piecesToSearch, edge: edge!, row: row, col: col, orientation: orientation)
        }
        return true
    }
    
    func solve() -> Bool {
        var cornerPieces = [Piece]()
        var borderPieces = [Piece]()
        var insidePieces = [Piece]()
        groupPieces(cornerPieces: &cornerPieces, borderPieces: &borderPieces, insidePieces: &insidePieces)
        solution = [[Piece]](repeatElement([Piece](repeatElement(Piece(edgeList: [Edge]()), count: size)), count: size))
        for row in 0 ..< size {
            for column in 0 ..< size {
                var piecesToSearch = getPieceListToSearch(cornerPieces: cornerPieces, borderPieces: borderPieces, insidePieces: insidePieces, row: row, col: column)
                if !fitNextEdge(piecesToSearch: &piecesToSearch, row: row, col: column) {
                    return false
                }
            }
        }
        return true
    }
    
    func getCurrentSolution() -> [[Piece]] {
        return solution
    }
    
}

class Test {
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func createRandomEdge(code: String) -> Edge {
        let random = randomBool()
        var type = Shape.inner
        if random {
            type = .outer
        }
        return Edge(shape: type, code: code)
    }
    
    func createEdges(puzzle: [[Piece]], col: Int, row: Int) -> [Edge] {
        let key = "\(row):\(col):"
        let left = col == 0 ? Edge(shape: .flat, code: key + "h|e") : puzzle[row][col - 1].getEdgeWithOrientation(orientation: .right).createMatchingEdge()
        let top = row == 0 ? Edge(shape: .flat, code: key + "v|e") : puzzle[row - 1][col].getEdgeWithOrientation(orientation: .bottom).createMatchingEdge()
        let right = col == puzzle[row].count - 1 ? Edge(shape: .flat, code: key + "h|e") : createRandomEdge(code: key + "h")
        let bottom = row == puzzle.count - 1 ? Edge(shape: .flat, code: key + "v|e") : createRandomEdge(code: key + "v")
        let edges = [left!, top!, right, bottom]
        return edges
    }
    
    func initializePuzzle(size: Int) -> [Piece] {
        let edges = Edge(shape: .flat, code: "tempHolder")
        var puzzle = [[Piece]](repeatElement([Piece](repeatElement(Piece(edgeList: [edges]), count: size)), count: size))
        for row in 0 ..< size {
            for col in 0 ..< size {
                let edges = createEdges(puzzle: puzzle, col: col, row: row)
                puzzle[row][col] = Piece(edgeList: edges)
            }
        }
        
        
        print("Puzzle being created, the original puzzle is: ")
        var stringOfPuzzles = ""
        for row in puzzle {
            for col in row {
                stringOfPuzzles.append("\(col.toString()), ")
            }
            stringOfPuzzles += "\n"
        }
        print(stringOfPuzzles)
        
        // Shuffle/rotate
        var pieces = [Piece]()
        for row in 0 ..< size {
            for col in 0 ..< size {
                let rotations = Int(arc4random_uniform(4))
                let piece = puzzle[row][col]
                piece.rotateEdgesby(numberRotations: rotations)
                let index = pieces.count == 0 ? 0 : Int(arc4random_uniform(UInt32(pieces.count)))
                pieces.insert(piece, at: index)
            }
        }
        print("After shuffling and rotating the puzzle, the pieces we have:")
        stringOfPuzzles = "["
        for p in pieces {
            stringOfPuzzles.append("\(p.toString()), ")
        }
        print(stringOfPuzzles)
        return pieces
    }
    
    func solutionToString(solution: [[Piece?]]) -> String {
        var rval = ""
        for h in 0 ..< solution.count {
            for w in 0 ..< solution[h].count {
                let p = solution[h][w]
                if p == nil {
                    rval += "nil"
                } else {
                    rval += String(describing: p!.toString())
                }
            }
            rval += "\n"
        }
        return rval
    }
    
    
    func validate(solution: [[Piece?]]) -> Bool {
        for r in 0 ..< solution.count {
            for c in 0 ..< (solution[r].count) {
                let piece = solution[r][c]
                if piece == nil { return false }
                if c > 0 {
                    let left = solution[r][c-1]
                    if !(left?.getEdgeWithOrientation(orientation: .right).fitsWith(edge: (piece?.getEdgeWithOrientation(orientation: .left))!))! {
                        return false
                    }
                }
                if c < (solution[r].count) - 1 {
                    let right = (solution[r][c+1])!
                    if !(right.getEdgeWithOrientation(orientation: .left).fitsWith(edge: (piece?.getEdgeWithOrientation(orientation: .right))!)) {
                        return false
                    }
                }
                if r > 0 {
                    let top = solution[r-1][c]
                    if !(top?.getEdgeWithOrientation(orientation: .bottom).fitsWith(edge: (piece?.getEdgeWithOrientation(orientation: .top))!))! {
                        return false
                    }
                }
                if r < (solution.count) - 1 {
                    let bottom = solution[r+1][c]
                    if !(bottom?.getEdgeWithOrientation(orientation: .top).fitsWith(edge: (piece?.getEdgeWithOrientation(orientation: .bottom))!))! {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func testSize(size: Int) {
        let pieces = initializePuzzle(size: size)
        let puzzle = Puzzle(size: size, pieces: pieces)
        puzzle.solve()
        let solution = puzzle.getCurrentSolution()
        print("\nPrinting Current Solution:")
        print(solutionToString(solution: solution))
        let result = validate(solution: solution)
        if result {
            print("Puzzled Solved! Good Job Anh! You're not that dumb after all!")
        } else {
            print("Puzzle was not solved! Should change your name from Anh to Off")
        }
    }

    
}

let test = Test()
test.testSize(size: 3)




































