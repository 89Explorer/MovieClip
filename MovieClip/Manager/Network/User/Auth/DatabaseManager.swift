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
    
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            self.db.collection(self.userPath).document(id).updateData(updateFields) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// 특정 유저 ID를 받아 해당 유저의 Firestore 데이터를 삭제
    func collectionUsers(deleteUser userID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            self.db.collection(self.userPath).document(userID).delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Review 관리
    func collectionReviews(updateFields: [String: Any], userID: String, reviewID: String) -> AnyPublisher<Bool, Error> {
        
        let reviewPath = "\(userID)/reviews/\(reviewID)"
        
        return Future<Bool, Error> { promise in
            self.db.collection(self.userPath).document(reviewPath).updateData(updateFields) {
                error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        
        .eraseToAnyPublisher()
    }
    
    
    func collectionReviews(add review: ReviewItem) -> AnyPublisher<Bool, Error> {
        guard let userID = Auth.auth().currentUser?.uid else {
            return Fail(error: NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인한 사용자가 없습니다."]))
                .eraseToAnyPublisher()
        }
        
        let reviewID = review.id
        
        return db.collection("users") // ✅ users 컬렉션
            .document(userID) // ✅ 특정 유저
            .collection("reviews") // ✅ 해당 유저의 리뷰 목록
            .document(reviewID) // ✅ 특정 리뷰 문서
            .setData(from: review) // ✅ Firestore에 저장
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    
    func collectionReviews(delete reviewID: String) -> AnyPublisher<Void, Error> {
        guard let userID = Auth.auth().currentUser?.uid else {
            return Fail(error: NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인한 사용자가 없습니다."]))
                .eraseToAnyPublisher()
        }
        
        return Future<Void, Error> { promise in
            self.db.collection("users")
                .document(userID)
                .collection("reviews")
                .document(reviewID)
                .delete { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
        
    }
    
    
    
    /// Firestore에서 리뷰 목록을 가져오는 메서드
    func collectionReviews(retrieve userID: String) -> AnyPublisher<[ReviewItem], Error> {
        db.collection(userPath)
            .document(userID)
            .collection("reviews")
            .getDocuments()
            .tryMap { snapshot in
                try snapshot.documents.map { document in      // Firestore에서 데이터를 가져오는 과정
                    try document.data(as: ReviewItem.self)    // 가져온 데이터를 ReviewItem으로 변환
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    
}
