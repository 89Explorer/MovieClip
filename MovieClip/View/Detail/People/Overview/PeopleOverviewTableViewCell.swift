//
//  PeopleOverviewTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/13/25.
//

import UIKit

class PeopleOverviewTableViewCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "PeopleOverviewTableViewCell"
    
    
    // MARK: - UI Component
    
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
