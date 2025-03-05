//
//  ReviewViewController.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import UIKit

class ReviewViewController: UIViewController {

    
    // MARK: - UI Component
    private var reviewCollectionView: UICollectionView!
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    
        configureNavigationBarAppearance()
        setupCollectionView()
        
        
    }

    
    
    // MARK: - Function
    private func setupCollectionView() {
        reviewCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        reviewCollectionView.backgroundColor = .black
        reviewCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reviewCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(reviewCollectionView)
        
    }
    
    
    
    
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // ✅ 네비게이션 바 배경 검은색
        appearance.backgroundColor = .black
        
        // ✅ 큰 타이틀 색상 흰색
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // ✅ 일반 타이틀 색상 흰색
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Write Review"
    }
}
