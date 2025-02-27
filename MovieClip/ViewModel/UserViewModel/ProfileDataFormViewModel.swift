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

    
}
