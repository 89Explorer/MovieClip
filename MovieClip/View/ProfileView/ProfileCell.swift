//
//  ProfileCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/1/25.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell, SelfConfiguringProfileCell {
    
    
    // MARK: - Variable
    static var reuseIdentifier: String = "ProfileCell"
    weak var delegate: ProfileCellDelegate?
    
    
    // MARK: - UI Component
    private let profileImage: UIImageView = UIImageView()
    private let usernameLabel: UILabel = UILabel()
    private let seperator: UIView = UIView()
    private let overviewTextView: UITextView = UITextView()
    private let editButton: UIButton = UIButton(type: .system)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupUI()
        setupEditButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with data: ProfileItem) {
        switch data {
        case .profile(let profile):
            DispatchQueue.main.async {
                if profile.avatarPath != "" {
                    
                    let url = URL(string: "\(profile.avatarPath)")
                    self.profileImage.sd_setImage(with: url)
                    
                } else {
                    
                    self.profileImage.image = UIImage(systemName: "camera.fill")
                    
                }
            }
            
            usernameLabel.text = profile.username
            overviewTextView.text = profile.bio
            
        case .ratedMovies(_):
            break
        case .review(_):
            break
        }
    }
    
    func setupEditButton() {
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    }
    
    
    // MARK: - Action
    @objc private func didTapEditButton() {
        delegate?.didTapEditButton()
    }
    
    // MARK: - Constraints
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        // ✅ 프로필 이미지 UI 설정
        profileImage.layer.cornerRadius = 60
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.systemBlue.cgColor
        profileImage.contentMode = .scaleAspectFill
        profileImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        // ✅ 프로필 이름 UI 설정
        usernameLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .bold))
        usernameLabel.textColor = .black
        
        
        // ✅ 프로필 소개 UI 설정
        //overviewTextView.text = "여기에 텍스트 입력"
        overviewTextView.font = UIFont.systemFont(ofSize: 16)
        overviewTextView.textColor = .black
        overviewTextView.backgroundColor = .clear
        overviewTextView.isScrollEnabled = false // ✅ 크기가 자동 조정되도록 설정
        overviewTextView.isEditable = false // ✅ 사용자 입력 불가능하게 설정
        overviewTextView.isSelectable = false // ✅ 선택 불가능하게 설정
        overviewTextView.textContainerInset = .zero // ✅ 패딩 제거
        overviewTextView.textContainer.lineFragmentPadding = 0 // ✅ 내부 패딩 제거
        
        
        // ✅ 프로필 수정 버튼 UI 설정
        editButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        editButton.tintColor = .black
        editButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        seperator.backgroundColor = .black
        
        
        let innerStackView = UIStackView(arrangedSubviews: [usernameLabel, editButton])
        innerStackView.axis = .horizontal
        innerStackView.alignment = .fill
        innerStackView.spacing = 10
        
        
        let outerStackView = UIStackView(arrangedSubviews: [innerStackView, seperator, overviewTextView])
        outerStackView.axis = .vertical
        outerStackView.distribution = .fill
        outerStackView.spacing = 10
        
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(outerStackView)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImage)
        
        
        NSLayoutConstraint.activate([
            
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImage.widthAnchor.constraint(equalToConstant: 120),
            profileImage.heightAnchor.constraint(equalToConstant: 120),
            
            outerStackView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            editButton.widthAnchor.constraint(equalToConstant: 15)
            
        ])
        
    }
}


// MARK: - Protocol
protocol ProfileCellDelegate: AnyObject {
    func didTapEditButton()
}
