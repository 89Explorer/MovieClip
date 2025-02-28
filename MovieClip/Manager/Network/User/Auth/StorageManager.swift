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
}


enum FireStorageError: Error {
    case invalidImageID
}
