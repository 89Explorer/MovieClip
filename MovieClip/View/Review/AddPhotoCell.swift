//
//  AddPhotoCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "AddPhotoCell"
    weak var delegate: ReviewPhotoCellDelegate?
    
    
    // MARK: - UI Component
    private var addPhotoButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemGray6
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .small
        //configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        
        configuration.title = "사진 추가" + "\n" + "최대 10장"
        configuration.titleAlignment = .center
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePlacement = .top
        
        configuration.imagePadding = 10
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(addPhotoButton)
        
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 100),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 120)
            
        ])
        
        addPhotoButton.addTarget(self, action: #selector(didTapAddPhotoButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    @objc private func didTapAddPhotoButton() {
        print("didTapAddPhotoButton called")
        delegate?.didTapSelectedImages()
    }
    
    
}
