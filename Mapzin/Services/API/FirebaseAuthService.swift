//
//  FirebaseAuthProvider.swift
//  Mapzin
//
//  Created by Amir Malamud on 30/05/2024.
//
import Foundation
import FirebaseAuth
import Combine


class FirebaseAuthService {
    func signIn(withEmail email: String, password: String) -> AsyncStream<Result<Void, Error>> {
        return AsyncStream { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.yield(.failure(error))
                } else {
                    continuation.yield(.success(()))
                }
                continuation.finish()
            }
        }
    }

    func createUser(withEmail email: String, password: String) -> AsyncStream<Result<Void, Error>> {
        return AsyncStream { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.yield(.failure(error))
                } else {
                    continuation.yield(.success(()))
                }
                continuation.finish()
            }
        }
    }
}
