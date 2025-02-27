//
//  HomeViewModel.swift
//  MovieClip
//
//  Created by 권정근 on 2/27/25.
//

import Foundation
import Combine
import FirebaseAuth


final class HomeViewModel: ObservableObject {
    
    // MARK: - @Published
    @Published var user: MovieClipUser?
    @Published var error: String?
    
    
    // MARK: - Variable
    private var cancelable: Set<AnyCancellable> = []
    
    
    // MARK: - Function
    /// FireStore 내에 id를 통해 회원정보를 가져오는 메서드 
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        DatabaseManager.shared.collectionUsers(retrieve: id)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                case .finished:
                    print("회원정보 가져오기 성공")
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancelable)

    }
}
