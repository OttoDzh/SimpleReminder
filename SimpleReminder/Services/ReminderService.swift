//
//  ReminderService.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 16.04.2023.
//

import Foundation
import UserNotifications

class ReminderService {
    static func setRemind(name:String,dateMonth:Int,dateDay:Int,dateHour:Int) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let title = "Birthday:\(name)"
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = UNNotificationSound.defaultRingtone
                let dateComp = DateComponents(month:dateMonth,day: dateDay,hour: dateHour)
                print(dateComp)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if error != nil {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
            }
        }
    }
}
