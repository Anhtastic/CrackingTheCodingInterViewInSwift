//: Playground - noun: a place where people can play

import UIKit

//  Zero Matrix: Write an algorithm such that if an element in an MxN matrix is 0, its entire row and column are set to 0.

func padRowWithZeros(matrix: inout [[Int]], row: Int) {
    for j in 0 ..< matrix[0].count {
        matrix[row][j] = 0
    }
    
}

func padColWithZeros(matrix: inout [[Int]], col: Int) {
    for i in 0 ..< matrix.count {
        matrix[i][col] = 0
    }
}

// Solution 1
// Space Usage : O(n)
func zeroMatrix(matrix: inout [[Int]]) {
    
    // Could alternatively do this with Booleans instead of storing indices.
    var rowsWithZeros = [Int]()
    var colsWithZeros = [Int]()
    for i in 0 ..< matrix.count {
        for j in 0 ..< matrix[0].count {
            if matrix[i][j] == 0 {
                if !rowsWithZeros.contains(i) {
                    rowsWithZeros.append(i)
                }
                if !colsWithZeros.contains(i) {
                    colsWithZeros.append(j)
                }
            }
        }
    }
    
    for row in rowsWithZeros {
        padRowWithZeros(matrix: &matrix, row: row)
    }
    for col in colsWithZeros {
        padColWithZeros(matrix: &matrix, col: col)
    }
}

// Solution 2
// Space Usage: O(1)
func zeroMatrixEfficient(matrix: inout [[Int]]) {
    var firstRowHasZero = false
    var firstColHasZero = false
    
    for j in 0 ..< matrix[0].count {
        if matrix[0][j] == 0 {
            firstRowHasZero = true
            break
        }
    }
    
    for i in 0 ..< matrix.count {
        if matrix[i][0] == 0 {
            firstColHasZero = true
            break
        }
    }
    
    for i in 0 ..< matrix.count {
        for j in 0 ..< matrix[0].count {
            if matrix[i][j] == 0 {
                matrix[i][0] = 0
                matrix[0][j] = 0
            }
        }
    }
    
    for j in 0 ..< matrix[0].count {
        if matrix[0][j] == 0 {
            padColWithZeros(matrix: &matrix, col: j)
        }
    }
    
    for i in 0 ..< matrix.count {
        if matrix[i][0] == 0 {
            padRowWithZeros(matrix: &matrix, row: i)
        }
    }
    
    if firstRowHasZero {
        padRowWithZeros(matrix: &matrix, row: 0)
    }
    
    if firstColHasZero {
        padColWithZeros(matrix: &matrix, col: 0)
    }
    
}




var matrix = [
    [0, 1, 1, 1, 1],
    [1, 0, 1, 1, 1],
    [1, 1, 1, 1, 1],
    [1, 1, 1, 0, 1]
]
print("Original Matrix:")
for row in matrix {
    print(row)
}

zeroMatrix(matrix: &matrix)

print("\n")
print("Solution 1:")
for row in matrix {
    print(row)
}


var matrix2 = [
    [0, 1, 1, 1, 1],
    [1, 0, 1, 1, 1],
    [1, 1, 1, 1, 1],
    [1, 1, 1, 0, 1]
]

zeroMatrixEfficient(matrix: &matrix2)

print("\n")
print("Solution 2:")
for row in matrix {
    print(row)
}























