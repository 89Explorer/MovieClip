//
//  ReviewPhotoCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import UIKit

class ReviewPhotoCell: UICollectionViewCell, SelfConfiguringReviewCell {
    
    
    // MARK: - Variable
    static var reuseIdentifier: String = "ReviewPhotoCell"
    private var images: [UIImage] = []
    weak var delegate: ReviewPhotoCellDelegate?
    
    
    
    // MARK: - UI Component
    private var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 130, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 15
        collectionView.clipsToBounds = false
        return collectionView
    }()
        
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        
        setupLayout()
        setupCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        images = [] // ✅ 이전 데이터 초기화 방지
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData() // ✅ 다시 렌더링
        }
        
    }
    
    
    // MARK: - Function
    private func setupCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        photoCollectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.reuseIdentifier) // ✅ 버튼용 셀 등록
    }
    
    
    func configure(with item: ReviewSectionItem) {
        if case .photo(let array) = item {
            self.images = array
            print("Received images count:", images.count)
            
            DispatchQueue.main.async {
                self.photoCollectionView.isHidden = false
                self.photoCollectionView.reloadData() // ✅ 데이터 갱신
            }
        }
    }
    
    
    // MARK: - Constraints
    private func setupLayout() {
        contentView.addSubview(photoCollectionView)
        
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 150) // ✅ 고정 높이 설정
        ])
    }
}



extension ReviewPhotoCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(images.count + 1, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < images.count {
            // ✅ 일반 이미지 셀
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: images[indexPath.row])
            return cell
        } else {
            // ✅ 마지막 셀은 추가 버튼 셀
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.reuseIdentifier, for: indexPath) as? AddPhotoCell else {
                return UICollectionViewCell()
            }
            cell.delegate = delegate
            return cell
        }
    }
}



// MARK: - Protocol
protocol ReviewPhotoCellDelegate: AnyObject {
    func didTapSelectedImages()
}
