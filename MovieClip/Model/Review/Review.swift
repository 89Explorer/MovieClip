//
//  Review.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import Foundation
import UIKit


// ✅ 리뷰 화면의 섹션을 정의하는 열거형
enum ReviewSection: CaseIterable {
    case photos
    case content
    case options    // 하나의 섹션으로 날짜 & 평점 포함
}


// ✅ 한 개의 리뷰를 저장하는 모델
struct ReviewItem: Codable {
    let id: String
    var photos: [String]     // 여러 개의 사진
    var content: String       // 리뷰 내용
    var date: Date            // 작성 날짜
    var rating: Double        // 별점
    
    init(id: String = UUID().uuidString, photos: [String] = [], content: String = "", date: Date = Date(), rating: Double = 0.0) {
        self.id = id
        self.photos = photos
        self.content = content
        self.date = date
        self.rating = rating
    }
}


// ✅ 각 셀에서 받을 데이터 타입을 정의 하는 열거형
enum ReviewSectionItem: Hashable {
    case photo(PhotoType)
    case content(String)
    case options(ReviewOptionType, String)    // 날짜 & 평점 타입을 포함
}

enum PhotoType: Hashable {
    case image([UIImage])
    case string([String])
}


enum ReviewOptionType: Hashable {
    case date(Date)
    case rating(Double)
}

// MARK: - enum ProfileItem 에서 Hashable, Equatable 프로토콜을 준수하기 위함
extension ReviewItem: Hashable {
    static func == (lhs: ReviewItem, rhs: ReviewItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

