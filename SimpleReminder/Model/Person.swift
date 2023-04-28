//
//  PersonCheck.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 11.04.2023.
//

import Foundation
import FirebaseFirestore

class Person {
    let id: String
    let name: String
    let birthday: String
    let personImage: Data
    let phoneNumber: String

    internal init(id: String, name: String, birthday: String, personImage: Data,phoneNumber:String) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.personImage = personImage
        self.phoneNumber = phoneNumber
    }
    
    init?(snap:DocumentSnapshot) {
        guard let data = snap.data() else {return nil}
        guard let id = data["id"] as? String else { return nil }
        guard let name = data["name"] as? String else { return nil }
        guard let birthday = data["birthday"] as? String else { return nil }
        guard let personImage = data["personImage"] as? Data else { return nil }
        guard let phoneNumber = data["phoneNumber"] as? String else { return nil }
        
        
        self.id = id
        self.name = name
        self.birthday = birthday
        self.personImage = personImage
        self.phoneNumber = phoneNumber
    }
}
