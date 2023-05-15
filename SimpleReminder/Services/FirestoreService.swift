//
//  FirestoreService.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 11.04.2023.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseAuth


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
                    userId:String,
                    completion: @escaping(Result<Person,Error>) -> Void) {
        let person = Person(id: id, name: name, birthday: birthday, personImage: personImage,phoneNumber: phoneNumber,userId: userId)
        personRef.document(person.id).setData(["id": id,
                                               "name":name,
                                               "birthday":birthday,
                                               "personImage":personImage,
                                               "phoneNumber":phoneNumber,
                                               "userId":userId]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(person))
            }
        }
    }
    //MARK: Get personsArray from Firebase
    func getPersons(completion: @escaping(Result<[Person],Error>) -> Void) {
        let userId = Auth.auth().currentUser?.uid
        var persons = [Person]()
        personRef.whereField("userId", isEqualTo: userId as Any).getDocuments { querySnapshot, error in
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
}
