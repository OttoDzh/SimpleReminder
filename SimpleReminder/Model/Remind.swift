//
//  Remind.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 25.03.2023.
//

import Foundation


class Remind:Codable {
    let remind: String
    let remindDate: String
    init(remind: String, remindDate: String) {
        self.remind = remind
        self.remindDate = remindDate
    }
}
