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
    
    @Published var reviews: [ReviewItem] = []
    
    @Published var user: MovieClipUser   // ✅ 유저 정보 (초기값 기본값으로 설정)
    @Published var error: String?
    @Published var isUserDeleted: Bool = false  // ✅ 회원 탈퇴 완료 여부
    
    
    private var cancellable: Set<AnyCancellable> = []
    
    // ✅ 빈 유저로 초기화 후, Firebas에서 업데이트
    init(user: MovieClipUser = MovieClipUser()) {
        self.user = user
        retreiveUser()
        //fetchUserReviews()
    }
    
    
    func fetchUserReviews() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        DatabaseManager.shared.collectionReviews(retrieve: userID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("❌ 리뷰 가져오기 실패.... \(error.localizedDescription)")
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] fetchedReviews in
                self?.reviews = fetchedReviews
                //print("✅ 성공...: \(self?.reviews ??)
            }
            .store(in: &cancellable)
    }
    
//    func fetchUserReviews() -> AnyPublisher<[ReviewItem], Error> {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            return Fail(error: NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인한 사용자가 없습니다."]))
//                .eraseToAnyPublisher()
//        }
//
//        return DatabaseManager.shared.collectionReviews(retrieve: userID)
//            .receive(on: DispatchQueue.main)
//            .handleEvents(receiveOutput: { [weak self] newReviews in
//                self?.reviews = newReviews // ✅ 데이터가 변경될 때 자동으로 UI 업데이트 가능
//            })
//            .eraseToAnyPublisher()
//    }
    
    
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
    
    
    func deleteUser() {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.error = "유저 정보 없음"
            return
        }
        
        StorageManager.shared.deleteProfilePhoto(for: userID)
            .flatMap { DatabaseManager.shared.collectionUsers(deleteUser: userID) }
            .flatMap { AuthManager.shared.deleteUser() }
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = "회원 탈퇴 실패: \(error.localizedDescription)"
                case .finished:
                    self?.isUserDeleted = true  // 회원 탈퇴 완료 처리
                }
            } receiveValue: { }
            .store(in: &cancellable)
    }
}
