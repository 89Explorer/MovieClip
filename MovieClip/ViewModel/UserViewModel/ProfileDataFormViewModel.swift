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
    
}
