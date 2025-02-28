//
//  ProfileDataFormViewModel.swift
//  MovieClip
//
//  Created by 권정근 on 2/27/25.
//

import Foundation
import Combine
import UIKit
import FirebaseAuth
import FirebaseStorage


final class ProfileDataFormViewModel: ObservableObject {
    
    // MARK: - @Published
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String = ""
    @Published var isOnboardingFinished: Bool = false
    
    private var cancelable: Set<AnyCancellable> = []

    
    // MARK: - Function
    /// 프로필 유효성 검사
    func validateUserProfileForm() {
        guard let username = username, username.count > 2,
              let bio = bio, bio.count > 2,
              imageData != nil else {
            isFormValid = false
            return
        }
        isFormValid = true
    }
    
    
    func uploadAvatar() {
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        StorageManager.shared.uploadProfilePhoto(with: userID, image: imageData, metaData: metaData)
            .flatMap { metaData in
                StorageManager.shared.getDownloadURL(for: metaData.path)
            }
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                case .finished:
                    self?.updateUserData()
                }
            } receiveValue: { [weak self] url in
                self?.avatarPath = url.absoluteString
            }
            .store(in: &cancelable)
    }
    
    
    private func updateUserData() {
        guard let username,
              let bio,
              let avatarPath,
              let id = Auth.auth().currentUser?.uid else { return }
        
        let updateFields: [String: Any] = [
            "username": username,
            "bio": bio,
            "avatarPath": avatarPath,
            "isUserOnboarded": true
        ]
        
        DatabaseManager.shared.collectionUsers(updateFields: updateFields, for: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] onboardingState in
                self?.isOnboardingFinished = onboardingState
            }
            .store(in: &cancelable)

    }
}
