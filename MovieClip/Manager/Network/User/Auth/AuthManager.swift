//
//  AuthManager.swift
//  MovieClip
//
//  Created by 권정근 on 2/26/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseAuthCombineSwift
import Combine


class AuthManager {
    
    // MARK: - Variable
    static let shared = AuthManager()
    
    private init() { }
    
    
    // MARK: - Function
    
    /// 이메일과 비밀번호로 회원가입 하는 함수 <Future는 필수가 아님>
    func registerUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))  // ❌ 실패 시 에러 반환
                } else if let user = authResult?.user {
                    promise(.success(user))   // ✅ 성공 시 User 반환
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// 이메일과 비밀번호로 로그인하는 함수
    func loginUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }

    
//    func register(email: String, password: String) -> AnyPublisher<User, Error> {
//        return Auth.auth().createUser(withEmail: email, password: password)
//            .map(\.user)
//            .eraseToAnyPublisher()
//    }
    
}
