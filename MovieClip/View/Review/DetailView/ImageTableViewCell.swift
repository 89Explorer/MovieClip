//
//  ImageTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/10/25.
//

import UIKit
import SDWebImage

class ImageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ImageTableViewCell"
    
    private var images: [String] = []
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // ✅ 여기서 layout 사용
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ReviewImageCell.self, forCellWithReuseIdentifier: ReviewImageCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        
        layout.itemSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
        layout.invalidateLayout()
    }
    
    func configure(images: [String]){
        DispatchQueue.main.async {
            self.images = images
            dump(images)
            self.collectionView.reloadData()
        } 
        
    }
    
}


extension ImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageCell.reuseIdentifier, for: indexPath) as? ReviewImageCell else { return UICollectionViewCell() }
        let image = images[indexPath.item]
        cell.configure(imageURL: image)
        return cell
        
    }
}
