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
    case date
    case rating
}


// ✅ 한 개의 리뷰를 저장하는 모델
struct ReviewItem: Hashable {
    let id: String
    var photos: [UIImage]     // 여러 개의 사진
    var content: String       // 리뷰 내용
    var date: Date            // 작성 날짜
    var rating: Double        // 별점
    
    init(id: String = UUID().uuidString, photos: [UIImage] = [], content: String = "", date: Date = Date(), rating: Double = 0.0) {
        self.id = id
        self.photos = photos
        self.content = content
        self.date = date
        self.rating = rating
    }
}


// ✅ 각 셀에서 받을 데이터 타입을 정의 하는 열거형
enum ReviewSectionItem: Hashable {
    case photo([UIImage])
    case content(String)
    case date(Date)
    case rating(Double)
}
