//
//  PersonModel.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 09.04.2023.
//

import Foundation
import UIKit

class Person {
    let id: String
    let name: String
    let birthday: String
    let personImage: UIImageView
    
    init(id:String,name: String, birthday: String,personImage: UIImageView) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.personImage = personImage 
    }
}
