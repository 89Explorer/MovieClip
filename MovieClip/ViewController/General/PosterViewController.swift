//
//  PosterViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/12/25.
//

import UIKit

class PosterViewController: UIViewController {
    
    
    // MARK: - Variable
    private let posterPath: String
    
    // MARK: - UI Component
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0  // ✅ 최대 줌 배율 설정
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit  // ✅ 이미지 비율 유지
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        scrollView.delegate = self
        
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        setupGesture()
        loadImage()
        
        configureConstraints()
    }
    
    
    // MARK: - Init
    init(posterPath: String) {
        self.posterPath = posterPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGesture)
    }

    private func loadImage() {
        let urlString = "https://image.tmdb.org/t/p/original/\(posterPath)"
        if let url = URL(string: urlString) {
            imageView.sd_setImage(with: url, completed: nil)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
    
    
    // MARK: - Action
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(closeButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}


// MARK: - UIScrollViewDelegate
extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
