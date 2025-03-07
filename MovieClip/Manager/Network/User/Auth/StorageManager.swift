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
import UIKit


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
    
    
    /// Firebase Storage에 리뷰 이미지 저장
    /// ✅ 각 이미지 데이터를 users/{userID}/reviews/{reviewID}/에 저장
    /// ✅ 모든 이미지 업로드 후 URL 리스트 반환
    func uploadReviewPhotos(with userID: String, reviewID: String, images: [Data], metaData: StorageMetadata) -> AnyPublisher<[String], Error> {
        
        let storageRef = Storage.storage().reference()
        var uploadedURLs: [String] = []
        
        let dispatchGroup = DispatchGroup()
        
        return Future<[String], Error> { promise in
            for (index, imageData) in images.enumerated() {
                dispatchGroup.enter()
                
                let imageName = "image_\(index).jpg"
                let imagePath = "images/\(userID)/reviews/\(reviewID)/\(imageName)"
                let imageRef = storageRef.child(imagePath)
                
                imageRef.putData(imageData, metadata: metaData) { metadata, error in
                    if let error = error {
                        print("❌ 이미지 업로드 실패: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    imageRef.downloadURL { url, error in
                        if let url = url {
                            uploadedURLs.append(url.absoluteString)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if uploadedURLs.isEmpty {
                    promise(.failure(FireStorageError.uploadFailed))
                } else {
                    print("✅ 모든 이미지 업로드 완료: \(uploadedURLs)")
                    promise(.success(uploadedURLs))
                }
            }
        }
        .eraseToAnyPublisher()
    }


    
    
    /// ✅ Firebase Storage의 listAll()을 활용하여 동적으로 이미지 목록을 불러옴
    func getReviewPhotosURL(userID: String, reviewID: String) -> AnyPublisher<[String], Error> {
        
        let storageRef = storage.reference()
        let folderPath = "users/\(userID)/reviews/\(reviewID)/"
        
        return Future<[String], Error> { promise in
            let reviewFolderRef = storageRef.child(folderPath)
            
            reviewFolderRef.listAll { result, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let items = result?.items,
                      !items.isEmpty else {
                    promise(.failure(NSError(domain: "FirebaseStorageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지가 없습니다."])))
                    return
                }
                
                var downloadURLs: [String] = []
                let dispatchGroup = DispatchGroup()
                
                for item in items {
                    dispatchGroup.enter()
                    
                    item.downloadURL { url, error in
                        if let url = url {
                            downloadURLs.append(url.absoluteString)
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    promise(.success(downloadURLs))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}


enum FireStorageError: Error {
    case invalidImageID
    case uploadFailed
}
