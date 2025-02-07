//
//  DetailView.swift
//  MovieClip
//
//  Created by 권정근 on 2/7/25.
//

import UIKit
import SDWebImage

class DetailView: UIView {
    
    // MARK: - UI Component
    private let basicScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        return scrollView
    }()
    
    private let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let backdropImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = 0.3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    // 🚗 movie 데이터를 받아 UI 전달 메서드
    func configure(_ movie: MovieDetailInfoWelcome) {
        if let backdropPath = movie.backdropPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)") else { return }
            backdropImage.sd_setImage(with: url, completed: nil)
        }
        
        if let posterPath = movie.posterPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    // 🚗 tv 데이터를 받아 UI 전달 메서드
    func configure(_ tv: TVDetailInfoWelcome) {
        if let backdropPath = tv.backdropPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)") else { return }
            backdropImage.sd_setImage(with: url, completed: nil)
        }
        
        if let posterPath = tv.posterPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImage.sd_setImage(with: url, completed: nil)
        }
        
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        addSubview(basicScrollView)
        basicScrollView.addSubview(basicView)
        basicView.addSubview(backdropImage)
        basicView.addSubview(posterImage)
        
        basicScrollView.translatesAutoresizingMaskIntoConstraints = false
        basicView.translatesAutoresizingMaskIntoConstraints = false
        backdropImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            basicScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            basicView.leadingAnchor.constraint(equalTo: basicScrollView.contentLayoutGuide.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: basicScrollView.contentLayoutGuide.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: basicScrollView.contentLayoutGuide.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: basicScrollView.contentLayoutGuide.bottomAnchor),
            
            basicView.widthAnchor.constraint(equalTo: basicScrollView.frameLayoutGuide.widthAnchor),
            
            //basicView.heightAnchor.constraint(equalToConstant: 1000),
            
            
            backdropImage.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 0),
            backdropImage.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: 0),
            backdropImage.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 0),
            backdropImage.heightAnchor.constraint(equalToConstant: 350),
            
            posterImage.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 20),
            //posterImage.centerYAnchor.constraint(equalTo: backdropImage.centerYAnchor),
            posterImage.widthAnchor.constraint(equalToConstant: 180),
            posterImage.topAnchor.constraint(equalTo: backdropImage.topAnchor, constant: 20),
            posterImage.bottomAnchor.constraint(equalTo: backdropImage.bottomAnchor, constant: -20)
            
        ])
    }
    
}
