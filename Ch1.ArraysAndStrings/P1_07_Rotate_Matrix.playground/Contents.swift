//: Playground - noun: a place where people can play

import UIKit

//  Rotate Matrix: Given an image represented by an NxN matrix, where each pixel in the image is 4
//  bytes, write a method to rotate the image by 90 degrees. Can you do this in place?

func rotateMatrix(matrix: inout [[Int]]) -> [[Int]] {
    if matrix.count == 0 || matrix.count != matrix[0].count { return matrix }
    let length = matrix.count
    
    for layer in 0 ..< length/2 {
        let last = length - 1 - layer
        for i in layer ..< last {
            let offSet = i - layer
            let top = matrix[layer][i] // save top
            matrix[layer][i] = matrix[last - offSet][layer] // top = left
            matrix[last - offSet][layer] = matrix[last][last - offSet] // left = bottom
            matrix[last][last - offSet] = matrix[i][last] // bottom = right
            matrix[i][last] = top // right = saved top
        }
    }
    
    return matrix
}


var matrix = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16]
]
for row in matrix {
    print(row)
}
print("\n")

rotateMatrix(matrix: &matrix)
for row in matrix {
    print(row)
}






























