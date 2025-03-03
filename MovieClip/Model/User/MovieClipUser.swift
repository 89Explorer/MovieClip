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
    var username: String
    var createOn: Date
    var bio: String
    var avatarPath: String
    var clipMovies: [String]
    var isUserOnboarded: Bool
    
    
    // ✅ 기본 생성자 (중복 없이 깔끔하게 설정)
    init(id: String = UUID().uuidString,
         username: String = "",
         avatarPath: String = "",
         clipMovies: [String] = [],
         bio: String = "",
         createOn: Date = Date(),
         isUserOnboarded: Bool = false) {
        self.id = id
        self.username = username
        self.avatarPath = avatarPath
        self.clipMovies = clipMovies
        self.bio = bio
        self.createOn = createOn
        self.isUserOnboarded = isUserOnboarded
    }
    
    // ✅ Firebase 유저로부터 생성하는 별도 init 유지
    init(from user: User) {
        self.id = user.uid
        self.username = ""
        self.avatarPath = ""
        self.clipMovies = []
        self.bio = ""
        self.createOn = Date()
        self.isUserOnboarded = false
    }
}


// MARK: - enum ProfileItem 에서 Hashable, Equatable 프로토콜을 준수하기 위함
extension MovieClipUser: Hashable {
    static func == (lhs: MovieClipUser, rhs: MovieClipUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

