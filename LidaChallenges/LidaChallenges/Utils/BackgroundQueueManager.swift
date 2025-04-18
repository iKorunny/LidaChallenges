//
//  BackgroundQueueManager.swift
//  LidaChallenges
//
//  Created by Лидия on 18.04.25.
//

import Foundation

final class BackgroundQueueManager {
    private let workingQueue = DispatchQueue(label: "BackgroundQueueManager_workingQueue", qos: .userInteractive)
    
    func add(task: @escaping (() -> Void)) {
        
        workingQueue.async {
            task()
        }
    }
}
