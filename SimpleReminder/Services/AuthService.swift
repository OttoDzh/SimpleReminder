//
//  AuthService.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 02.05.2023.
//

import Foundation
import FirebaseAuth
import Firebase


class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    private var currentUser: User? {
        return auth.currentUser
    }

    func signUp(completion: @escaping (Result<User,Error>) -> ()) {
        auth.signInAnonymously { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
