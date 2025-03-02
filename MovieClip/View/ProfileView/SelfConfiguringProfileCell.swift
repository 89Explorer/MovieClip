//
//  SelfConfiguringProfileCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/1/25.
//

import Foundation


protocol SelfConfiguringProfileCell {
    static var reuseIdentifier: String { get }
    func configure(with data: ProfileItem)
}
