//
//  SelfConfiguringCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/18/25.
//

import Foundation


protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with data: MainResults)
}


protocol SelfConfiguringTVCell {
    static var reuseIdentifier: String { get }
    func configure(with data: TvTMDBResult)
}


protocol SelfConfiguringSearchCell {
    static var reuseIdentifier: String { get }
    func configure(with data: SearchItem)
}

protocol SelfConfiguringReviewCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ReviewSectionItem)
}
