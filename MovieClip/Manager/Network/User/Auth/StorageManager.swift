//
//  StorageManager.swift
//  MovieClip
//
//  Created by 권정근 on 2/28/25.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageCombineSwift
import Combine


final class StorageManager {
    
    
    // MARK: - Variable
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    
    // MARK: - Function
    /// 프로필 이미지를 firestore에 저장하는 메서드
    func uploadProfilePhoto(with userID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        
        return storage
            .reference()
            .child("images/\(userID)/profileImage/profileImage.jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else { return Fail(error: FireStorageError.invalidImageID).eraseToAnyPublisher() }
        
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    
    /// 특정 유저 ID를 받아 해당 유저의 프로필 이미지를 Firebase Storage에서 삭제
    func deleteProfilePhoto(for userID: String) -> AnyPublisher<Void, Error> {
        return getDownloadURL(for: "images/\(userID)/profileImage/profileImage.jpg") // ✅ Firebase에서 이미지 URL 가져오기
            .flatMap { imageURL in
                let reference = Storage.storage().reference(forURL: imageURL.absoluteString)
                
                return Future<Void, Error> { promise in
                    reference.delete { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))  // ✅ 성공 시 Void 반환
                        }
                    }
                }
            }
            .catch { _ in Just(()).setFailureType(to: Error.self) } // ✅ 이미지가 없을 경우 삭제 실패해도 계속 진행
            .eraseToAnyPublisher()
    }
}


enum FireStorageError: Error {
    case invalidImageID
}
