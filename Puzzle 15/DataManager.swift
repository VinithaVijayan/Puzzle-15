//
//  DataManager.swift
//  Puzzle 15
//
//  Created by Vinitha Vijayan on 2/22/18.
//  Copyright © 2018 Vinitha Vijayan. All rights reserved.
//

import Foundation


class DataManager {
    static let intstance = DataManager()
    var data = [Int]()
    var dataArray = [[Int]]()
    
    func prepareDefaultData() {
        createData()
        formDataSource()
    }
    
    func getData() -> [[Int]] {
        return dataArray
    }
    
    func isMoveSuccess(row: Int, column: Int) -> Bool {
        if let position = getNextPosition(row: row, column: column) {
            dataArray[position.0][position.1] = dataArray[row][column]
            dataArray[row][column] = 0
            return true
        }
        
        return false
    }
    
    func isGameOver() -> Bool {
        return dataArray[0] == [1,2,3,4] && dataArray[1] == [5,6,7,8] &&  dataArray[2] == [9,10,11,12] && dataArray[3] == [13,14,15,16]
    }
    
    func shuffleData() {
        if let index = data.index(of: 0) {
            data.remove(at: index)
        }
        
        var last = data.count - 1
        
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            data.swapAt(last, rand)
            last -= 1
        }
        
        data.append(0)
        formDataSource()
    }
    
    func formDataSource() {
        dataArray.removeAll()
        
        var currentData = data
        for _ in 0...kSize-1 {
            let row = Array(currentData.prefix(4))
            currentData = Array(currentData.dropFirst(4))
            dataArray.append(row)
        }
    }
    
    func createData() {
        data.removeAll()
        
        var number = 0
        for i in 0...kSize - 1 {
            for j in 0...kSize - 1 {
                number += 1
                
                if i == kSize - 1 && j == kSize - 1 {
                    number = 0
                }
                
                data.append(number)
            }
        }
    }
    
    func getNextPosition(row: Int, column: Int) -> (Int, Int)? {
        let positions = getPossiblePositions(row: row, column: column)
        
        for position in positions {
            if dataArray[position.0][position.1] == 0 {
                return (position.0, position.1)
            }
        }
        
        return nil
    }
    
    func checkPositionEmpty(row: Int, column: Int) -> Bool {
        return dataArray[row][column] == 0
    }
    
    func getPossiblePositions(row: Int, column: Int) -> [(Int,Int)] {
        var array = [(Int,Int)]()
        var new = (0,0)
        if row > 0 {
            new = (row - 1, column)
            array.append(new)
        }
        
        if column > 0 {
            new = (row, column - 1)
            array.append(new)
        }
        
        if row + 1 < kSize {
            new = (row + 1, column)
            array.append(new)
        }
        
        if column + 1 < kSize {
            new = (row, column + 1)
            array.append(new)
        }
        
        return array
    }
}
