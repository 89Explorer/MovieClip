//
//  ReviewViewModel.swift
//  MovieClip
//
//  Created by 권정근 on 3/7/25.
//

import Foundation
import Combine
import UIKit
import FirebaseAuth
import FirebaseStorage


final class ReviewViewModel: ObservableObject {
    
    // 리뷰 작성 시 필요한 데이터
    @Published var reviewContent: ReviewContent = ReviewContent(reviewTitle: "", reviewContent: "")
    @Published var selectedImages: [UIImage]?
    @Published var uploadedPhotoURLs: [String] = []
    @Published var reviewDate: Date = Date()
    @Published var reviewRating: Double = 0.0
    @Published var isUploading: Bool = false
    @Published var errorMessage: String?
    @Published var isReviewSuccess: Bool = false
    @Published var error: String?
    
    @Published var isUserReviewDeleted: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // 🔹 Firestore에 리뷰 저장
    func uploadPhoto(reviewID: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorMessage = "로그인 정보를 확인해주세요"
            return
        }
        
        // ✅ 선택된 이미지를 JPEG 데이터로 변환
        let imageData = selectedImages?.compactMap { $0.jpegData(compressionQuality: 0.5) } ?? []
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        // ✅ 이미지가 없으면 바로 리뷰 저장 (텍스트 리뷰만 저장하는 경우)
        if imageData.isEmpty {
            updateReview(reviewID: reviewID)
            return
        }
        
        // ✅ 이미지 업로드 시작
        isUploading = true
        uploadedPhotoURLs = [] // 🔹 기존 URL 초기화
        
        StorageManager.shared.uploadReviewPhotos(with: userID, reviewID: reviewID, images: imageData, metaData: metaData)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("❌ 이미지 업로드 실패: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("✅ 리뷰 이미지 저장 성공")
                    self?.updateReview(reviewID: reviewID) // 🔹 리뷰 저장 실행
                }
            } receiveValue: { [weak self] urlList in
                self?.uploadedPhotoURLs = urlList // 🔹 업로드된 URL 배열 업데이트
            }
            .store(in: &cancellables)
    }
    
    // 🔹 작성된 리뷰 Firestore에 저장
    func updateReview(reviewID: String) {
        
        let newReview = ReviewItem(
            id: reviewID,
            photos: uploadedPhotoURLs, // 🔹 업데이트된 이미지 URL 배열
            content: reviewContent,
            date: reviewDate,
            rating: reviewRating
        )

        DatabaseManager.shared.collectionReviews(add: newReview)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("❌ 리뷰 저장 실패: \(error)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] reviewState in
                self?.isReviewSuccess = reviewState
                print("✅ 리뷰 저장 성공")
            }
            .store(in: &cancellables)
    }
    
    
    func deleteUserReview(reviewID: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.error = "유저 정보 없음 "
            return
        }
        
        StorageManager.shared.deleteReviewPhotos(userID: userID, reviewID: reviewID)
            .flatMap {
                DatabaseManager.shared.collectionReviews(delete: reviewID)
            }
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = "리뷰 삭제 실패: \(error.localizedDescription)"
                case .finished:
                    
                    self?.isUserReviewDeleted = true
                }
            } receiveValue: {[weak self] in
                self?.isUserReviewDeleted = true
            }
            .store(in: &cancellables)
    }
    
    
    func fetchReviewImages(reviewID: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        StorageManager.shared.getReviewImages(userID: userID, reviewID: reviewID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("❌ 이미지 불러오기 실패: \(error.localizedDescription)")
                    self?.errorMessage = "이미지 불러오기 실패: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] images in
                print("✅ Storage에서 이미지 가져오기 성공: \(images.count)개")
                self?.selectedImages = images // ✅ 로드된 이미지 저장
            }
            .store(in: &cancellables)
    }
    
    
}
