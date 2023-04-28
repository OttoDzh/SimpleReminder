//
//  FirestoreService.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 11.04.2023.
//

import Foundation
import FirebaseFirestore
import UIKit

class FirestoreService {
    
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    private var personRef: CollectionReference {
        return db.collection("persons")
    }
    
    //MARK: Delete task
    func deletePerson(id:String, completion: @escaping(Result<String,Error>) -> Void) {
        let docRef = personRef.document(id)
        docRef.delete {  error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(id))
            }
        }
    }
    
    //MARK: Save person profile
    
    func savePerson(id:String,
                    name: String,
                    birthday: String,
                    personImage: Data,
                    phoneNumber:String,
                    completion: @escaping(Result<Person,Error>) -> Void) {
        
        let person = Person(id: id, name: name, birthday: birthday, personImage: personImage,phoneNumber: phoneNumber)
        personRef.document(person.id).setData(["id": id,
                                               "name":name,
                                               "birthday":birthday,
                                               "personImage":personImage,
                                               "phoneNumber":phoneNumber]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(person))
            }
        }
        
    }
    //MARK: Get personsArray from Firebase
    
    func getPersons(completion: @escaping(Result<[Person],Error>) -> Void) {
        var persons = [Person]()
        personRef.getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                for doc in  querySnapshot!.documents {
                    guard let person = Person(snap:doc) else {
                        return
                    }
                    persons.append(person)
                }
                completion(.success(persons))
            }
        }
    }
    
//    func getPersonData(userId:String,
//                       completion: @escaping (Result<PersonCheck,Error>) -> Void) {
//
//        let personRef = personRef.document(userId)
//        personRef.getDocument { docSnap, error in
//            if let docSnap = docSnap {
//
//
//
//            } else if let error = error {
//                print(error.localizedDescription)
//                completion(.failure(error))
//            }
//        }
//    }

    
}
