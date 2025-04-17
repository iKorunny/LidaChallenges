//
//  SimplePagedDataSource.swift
//  LidaChallenges
//
//  Created by Лидия on 17.04.25.
//

import Foundation

final class SimplePagedDataSource {
    private let pageSize: Int
    private let maxCount: Int
    
    private(set) var currentNumberOfItems: Int
    
    /**
            Offset, insertedCount
     */
    var onWillInsert: ((Int, Int, (() -> Void)) -> Void)?
    
    init(with pageSize: Int, maxCount: Int) {
        self.pageSize = pageSize
        self.maxCount = maxCount
        currentNumberOfItems = min(pageSize, maxCount)
    }
    
    func didRequestItem(with index: Int) {
        print("SimplePagedDataSource.didRequestItem index: \(index)")
        if currentNumberOfItems != maxCount && (currentNumberOfItems - index) < Int(Double(pageSize) * 0.5) {
            let oldCount = currentNumberOfItems
            
            let newNumberOfItems = min(oldCount + pageSize, maxCount)
            
            guard newNumberOfItems - oldCount > 0 else { return }
            onWillInsert?(oldCount, newNumberOfItems - oldCount, { currentNumberOfItems = newNumberOfItems })
            
            print("SimplePagedDataSource.onWillInsert offset: \(oldCount), count: \(newNumberOfItems - oldCount)")
        }
    }
}
