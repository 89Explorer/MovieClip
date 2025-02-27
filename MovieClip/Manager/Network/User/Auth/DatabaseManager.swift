//
//  DatabaseManager.swift
//  MovieClip
//
//  Created by 권정근 on 2/27/25.
//

import Foundation
import Firebase
import FirebaseFirestoreCombineSwift
import FirebaseFirestore
import FirebaseAuth
import Combine


class DatabaseManager {
    
    
    // MARK: - Variable
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let userPath: String = "users"
    
    
    // MARK: - Function
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let movieClipUser = MovieClipUser(from: user)
        return db.collection(userPath)
            .document(movieClipUser.id)
            .setData(from: movieClipUser) // ✅ 여기까지, firebase FireStore의 특정 문서에 데이터를 저장하는 비동기 작업
            .map { _ in return true }     // ✅ Firebase에 데이터를 저장한 후, 성공적으로 완료되었음을 나타내는 true 값을 반환
            .eraseToAnyPublisher()        // ✅ 타입을 AnyPublisher<Bool, Error>로 변환하여 외부에서 사용하기 쉽게 만듦
    }
    
}
