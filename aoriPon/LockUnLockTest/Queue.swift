//
//  Queue.swift
//  LockUnLockTest
//
//  Created by M K on 2021/02/08.
//  Copyright © 2021 kmurata seminar. All rights reserved.
//

//サイズmaxのキューを作る

import Foundation

public struct Queue<T>{
    var max = 3 //デフォルト過去3回

    fileprivate var array = [T]()
    
    public var isEmpty: Bool{
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func setmax(num: Int){
        max = num
    }
    
    public mutating func enqueue(_ element: T){
        array.append(element)
        if count > max {
            dequeue()
        }
    }
    
    public mutating func dequeue() -> T?{
        if isEmpty{
            return nil
        }else{
            return array.removeFirst()
        }
    }
    
    public var front: T?{
        return array.first
    }
    
    public var end: T?{
        return array.last
    }
}
