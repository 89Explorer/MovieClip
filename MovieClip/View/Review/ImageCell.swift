//
//  ImageCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "ImageCell"
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         contentView.addSubview(imageView)
         imageView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
             imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
         ])
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     func configure(with image: UIImage) {
         imageView.image = image
     }
}
