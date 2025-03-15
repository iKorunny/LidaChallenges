//
//  AppNotificationManager.swift
//  LidaChallenges
//
//  Created by Лидия on 8.03.25.
//

import Foundation

protocol AppNotificationManager {
    func resetNotifications()
    func scheduleNotification(for challenge: Challenge)
#if DEBUG
    func scheduleDebugNotification(for challenge: Challenge)
#endif
}

final class AppNotificationManagerImpl: AppNotificationManager {
    private let notificationService: AppNotificationService
    private let databaseService: DatabaseService
    
    private let queue = DispatchQueue(label: "AppNotificationManagerImplQueue", qos: .background, attributes: .concurrent)
    
    init(notificationService: AppNotificationService,
         databaseService: DatabaseService) {
        self.notificationService = notificationService
        self.databaseService = databaseService
    }
    
    func resetNotifications() {
        queue.async { [weak self] in
            self?.databaseService.fetchAllStartedChallenges { [weak self] allStarted in
                self?.queue.async { [weak self] in
                    var components: [DateComponents] = []
                    
                    allStarted?.forEach({ started in
                        let todayDate = Date().start
                        guard !started.isFinished else { return }
                        var componentsValue = Date.dates(for: started.originalChallenge.regularity.map { $0.toAppleValue() }, from: todayDate).map { $0.convertToComponents(hours: 9) }
                        componentsValue.append(contentsOf: Date.dates(for: started.originalChallenge.regularity.map { $0.toAppleValue() }, from: todayDate.dayAfterWeek).map { $0.convertToComponents(hours: 9) })
                        componentsValue.forEach { component in
                            guard !components.contains(component) else { return }
                            components.append(component)
                        }
                    })
                    
                    guard !components.isEmpty else { return }
                    DispatchQueue.main.async { [weak self] in
                        self?.notificationService.rescheduleNotificationsIfNeeded(for: components)
                    }
                }
            }
        }
    }
    
    func scheduleNotification(for challenge: Challenge) {
        queue.async { [weak self] in
            var components: [DateComponents] = []
            let todayDate = Date().start
            var componentsValue = Date.dates(for: challenge.regularity.map { $0.toAppleValue() }, from: todayDate).map { $0.convertToComponents(hours: 9) }
            componentsValue.append(contentsOf: Date.dates(for: challenge.regularity.map { $0.toAppleValue() }, from: todayDate.dayAfterWeek).map { $0.convertToComponents(hours: 9) })
            componentsValue.forEach { component in
                guard !components.contains(component) else { return }
                components.append(component)
            }
            
            DispatchQueue.main.async { [weak self] in
                componentsValue.forEach { self?.notificationService.scheduleNotificationIfNeeded(for: $0) }
            }
        }
    }
    
#if DEBUG
    func scheduleDebugNotification(for challenge: Challenge) {
        queue.async { [weak self] in
            var components: [DateComponents] = []
            let todayDate = Date()
            var componentsValue = [todayDate.adding(seconds: 10).convertToComponentsWithTime()]
            componentsValue.append(contentsOf: [todayDate.adding(seconds: 20).convertToComponentsWithTime()])
            componentsValue.forEach { component in
                guard !components.contains(component) else { return }
                components.append(component)
            }
            
            DispatchQueue.main.async { [weak self] in
                componentsValue.forEach { self?.notificationService.scheduleDebugNotificationIfNeeded(for: $0) }
            }
        }
    }
#endif
}
