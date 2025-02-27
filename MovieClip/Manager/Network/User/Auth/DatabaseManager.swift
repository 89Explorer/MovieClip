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
    /// 회원정보를 fireStore에 저장하는 메서드
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let movieClipUser = MovieClipUser(from: user)
        return db.collection(userPath)
            .document(movieClipUser.id)
            .setData(from: movieClipUser) // ✅ 여기까지, firebase FireStore의 특정 문서에 데이터를 저장하는 비동기 작업
            .map { _ in return true }     // ✅ Firebase에 데이터를 저장한 후, 성공적으로 완료되었음을 나타내는 true 값을 반환
            .eraseToAnyPublisher()        // ✅ 타입을 AnyPublisher<Bool, Error>로 변환하여 외부에서 사용하기 쉽게 만듦
    }
    
    /// 회원정보를 반환하는 메서드
    func collectionUsers(retrieve id: String) -> AnyPublisher<MovieClipUser, Error> {
        db.collection(userPath)
            .document(id)
            .getDocument()                                        // ✅ 여기까지 Firestore에서 특정 문서를 가져오는 비동기 작업
            .tryMap { try $0.data(as: MovieClipUser.self) }       // ✅ DocumentSnapshot을 MovieClipUser 모델로 변환, 변환 실패하면 tryMap이 자동으로 에러를 throw (map은 단순 변환만 가능, 에러 throw 불가능)
            .eraseToAnyPublisher()
    }
    
}
