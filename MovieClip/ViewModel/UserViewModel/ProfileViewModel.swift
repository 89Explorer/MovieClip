//
//  ProfileViewModel.swift
//  MovieClip
//
//  Created by 권정근 on 2/28/25.
//

import Foundation
import Combine
import FirebaseAuth


final class ProfileViewModel: ObservableObject {
    
    @Published var user: MovieClipUser   // ✅ 유저 정보 (초기값 기본값으로 설정)
    @Published var error: String?
    
    
    private var cancellable: Set<AnyCancellable> = []
    
    // ✅ 빈 유저로 초기화 후, Firebas에서 업데이트
    init(user: MovieClipUser = MovieClipUser()) {
        self.user = user
        retreiveUser()
    }
    
    
    func retreiveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                    print(error)
                }
            } receiveValue: { [weak self] user in
                self?.user = user     // ✅ Firebase에서 유저 정보 받아서 업데이트 
            }
            .store(in: &cancellable)
    }
}
