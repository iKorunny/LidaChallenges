//
//  SimplePagedDataSource.swift
//  LidaChallenges
//
//  Created by Лидия on 17.04.25.
//

final class SimplePagedDataSource {
    private let pageSize: Int
    private let maxCount: Int
    
    private(set) var currentNumberOfItems: Int
    
    /**
            Offset, insertedCount
     */
    var onInsert: ((Int, Int) -> Void)?
    
    init(with pageSize: Int, maxCount: Int) {
        self.pageSize = pageSize
        self.maxCount = maxCount
        currentNumberOfItems = min(pageSize, maxCount)
    }
    
    func didRequestItem(with index: Int) {
        print("SimplePagedDataSource.didRequestItem index: \(index)")
        if currentNumberOfItems != maxCount && (currentNumberOfItems - index) < Int(Double(pageSize) * 0.5) {
            let oldCount = currentNumberOfItems
            
            currentNumberOfItems = min(oldCount + pageSize, maxCount)
            
            onInsert?(oldCount, currentNumberOfItems - oldCount)
            
            print("SimplePagedDataSource.onInsert offset: \(oldCount), count: \(currentNumberOfItems - oldCount)")
        }
    }
}
