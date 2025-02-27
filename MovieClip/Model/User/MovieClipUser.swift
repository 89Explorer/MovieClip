//
//  MovieClipUser.swift
//  MovieClip
//
//  Created by 권정근 on 2/27/25.
//

import Foundation
import FirebaseAuth
import Firebase



struct MovieClipUser: Codable {
    let id: String
    var username: String = ""
    var createOn: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    var clipMovies: [String] = []
    var isUserOnboarded: Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
    
}
