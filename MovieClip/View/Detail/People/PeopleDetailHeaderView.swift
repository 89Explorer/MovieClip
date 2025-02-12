//
//  PeopleDetailHeaderView.swift
//  MovieClip
//
//  Created by 권정근 on 2/13/25.
//

import UIKit
import SDWebImage


class PeopleDetailHeaderView: UIView {
    
    
    // MARK: - UI Component
    private let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "poster")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with people: PeopleDetailInfoWelcome) {
        guard let profilePath = people.profilePath else {
            print("❌ No ProfilePath")
            return
        }
        
        print("선택된 배우 프로필 경로 : \(profilePath)")
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)") else { return }
        
        posterImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(posterImageView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            posterImageView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            posterImageView.topAnchor.constraint(equalTo: basicView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor)
            
        ])
    }
}
