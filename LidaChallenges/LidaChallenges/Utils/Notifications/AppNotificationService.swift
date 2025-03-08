//
//  AppNotificationService.swift
//  LidaChallenges
//
//  Created by Лидия on 8.03.25.
//

import UserNotifications

protocol AppNotificationService {
    func scheduleNotificationIfNeeded(for date: DateComponents)
    func rescheduleNotificationsIfNeeded(for dates: [DateComponents])
#if DEBUG
    func scheduleDebugNotificationIfNeeded(for date: DateComponents)
#endif
}

final class AppNotificationServiceImpl: AppNotificationService {
    func scheduleNotificationIfNeeded(for date: DateComponents) {
        UNUserNotificationCenter.current().requestAuthorization { [weak self] granted, _ in
            guard granted else { return }
            self?.scheduleNotificationWithAccessGrantedIfNeeded(for: date)
        }
    }
    
    private func scheduleNotificationWithAccessGrantedIfNeeded(for date: DateComponents) {
        let identifier = "ActiveChallengeReminderNotification_date:\(Formatters.formateDefaultReminder(date))"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        let content = UNMutableNotificationContent()
        content.title = "NotificationReminderDefaultTitle".localised()
        content.body = "NotificationReminderDefaultBody".localised()
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func rescheduleNotificationsIfNeeded(for dates: [DateComponents]) {
        UNUserNotificationCenter.current().requestAuthorization { [weak self] granted, _ in
            guard granted else { return }
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            dates.forEach { self?.scheduleNotificationWithAccessGrantedIfNeeded(for: $0) }
        }
    }
    
#if DEBUG
    func scheduleDebugNotificationIfNeeded(for date: DateComponents) {
        UNUserNotificationCenter.current().requestAuthorization { granted, _ in
            guard granted else { return }
            let identifier = "ActiveChallengeReminderDebugNotification_date:\(Formatters.formateDefaultReminder(date))_\(date)"
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            
            let content = UNMutableNotificationContent()
            content.title = "NotificationReminderDefaultTitle".localised()
            content.body = "NotificationReminderDefaultBody".localised()
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
#endif
}
