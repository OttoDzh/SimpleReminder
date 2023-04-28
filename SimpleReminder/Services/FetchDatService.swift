//
//  FetchDatService.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 10.04.2023.
//

import Foundation
import CoreData


class FetchData {
    
    static func encodeData(array:[Remind]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(array)
            UserDefaults.standard.set(data, forKey: "reminds")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    static func decode(completion: @escaping(_ remindArray:[Remind]) -> Void) {
        if let data = UserDefaults.standard.data(forKey: "reminds") {
            do {
                let decoder = JSONDecoder()
                let remindArray = try decoder.decode([Remind].self, from: data)
                completion(remindArray)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
          
        }
    }
    
    
}
