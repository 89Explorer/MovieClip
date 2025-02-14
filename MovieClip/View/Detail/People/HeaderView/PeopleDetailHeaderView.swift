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
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let peopleInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인물 정보 🤔"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let peopleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let peopleBirthdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let peoplePlaceOfBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let socialStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 5
        stackView.layer.masksToBounds = true
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
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
    func configure(with people: PeopleDetailInfoWelcome, socialLinks: ExternalID) {
        guard let profilePath = people.profilePath else {
            print("❌ No ProfilePath")
            return
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w400\(profilePath)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
        
        let peopleName = people.name ?? "정보 없음"
        peopleNameLabel.text = "이름: " + peopleName
        
        let peopleBirthday = people.birthday ?? "정보 없음"
        peopleBirthdayLabel.text = "생일: " + peopleBirthday
        
        let peoplePlaceOfBirth = people.placeOfBirth ?? "정보 없음"
        peoplePlaceOfBirthLabel.text = "출생지: " + peoplePlaceOfBirth
        
        // ✅ 기존 소셜 네트워크 아이콘 제거
        socialStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        self.configureSocialButtons(socialLinks: socialLinks)

    }
    
    private func configureSocialButtons(socialLinks: ExternalID) {
        
        var hasSocialMedia: Bool = false     // ✅ 소셜 미디어 버튼 추가 여부 확인
        
        if let facebookID = socialLinks.facebookID {
            addSocialButton(icon: "FacebookLogo", url: "https://www.facebook.com/\(facebookID)")
            hasSocialMedia = true
        }
        
        if let instagramID = socialLinks.instagramID {
            addSocialButton(icon: "InstagramLogo", url: "https://www.instagram.com/\(instagramID)")
            hasSocialMedia = true
        }
        
        if let twitterID = socialLinks.twitterID {
            addSocialButton(icon: "TwitterLogo", url: "https://twitter.com/\(twitterID)")
            hasSocialMedia = true
        }
        
        if let youtubeID = socialLinks.youtubeID {
            addSocialButton(icon: "YoutubeLogo", url: "https://www.youtube.com/\(youtubeID)")
            hasSocialMedia = true
        }
        
        // ✅ 소셜 미디어가 하나도 없는 경우 안내 문구 추가
        if !hasSocialMedia {
            let infoLabel = UILabel()
            infoLabel.text = "No Social Media"
            infoLabel.font = .systemFont(ofSize: 16, weight: .bold)
            infoLabel.textColor = .lightGray
            infoLabel.textAlignment = .center
            socialStackView.addArrangedSubview(infoLabel)
        }
    }
    
    // ✅ 소셜 미디어 버튼 추가 메서드
    private func addSocialButton(icon: String, url: String) {
        
        let button = UIImageView()
        let image = UIImage(named: icon)
        button.image = image   // ✅ 로고 이미지 설정
        button.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSocialButton(_:)))
        button.addGestureRecognizer(tapGesture)
        button.accessibilityHint = url // ✅ URL 저장
        
        socialStackView.addArrangedSubview(button) // ✅ 스택뷰에 추가
    }
    
    
    // MARK: - Action
    /// 버튼 클릭 시 해당 URL을 Safari로 열도록 구현
    @objc private func didTapSocialButton(_ sender: UITapGestureRecognizer) {
        guard let button = sender.view as? UIImageView,
              let urlString = button.accessibilityHint,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(posterImageView)
        basicView.addSubview(peopleInfoTitleLabel)
        basicView.addSubview(peopleNameLabel)
        basicView.addSubview(peopleBirthdayLabel)
        basicView.addSubview(peoplePlaceOfBirthLabel)
        basicView.addSubview(socialStackView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        peopleInfoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        peopleNameLabel.translatesAutoresizingMaskIntoConstraints = false
        peopleBirthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        peoplePlaceOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
        socialStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            posterImageView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 20),
            posterImageView.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 180),
            
            peopleInfoTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            peopleInfoTitleLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            peopleInfoTitleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 10),
            peopleInfoTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            peopleNameLabel.leadingAnchor.constraint(equalTo: peopleInfoTitleLabel.leadingAnchor),
            peopleNameLabel.trailingAnchor.constraint(equalTo: peopleInfoTitleLabel.trailingAnchor),
            peopleNameLabel.topAnchor.constraint(equalTo: peopleInfoTitleLabel.bottomAnchor, constant: 10),
            peopleNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            peopleBirthdayLabel.leadingAnchor.constraint(equalTo: peopleInfoTitleLabel.leadingAnchor),
            peopleBirthdayLabel.trailingAnchor.constraint(equalTo: peopleInfoTitleLabel.trailingAnchor),
            peopleBirthdayLabel.topAnchor.constraint(equalTo: peopleNameLabel.bottomAnchor, constant: 10),
            peopleBirthdayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            peoplePlaceOfBirthLabel.leadingAnchor.constraint(equalTo: peopleInfoTitleLabel.leadingAnchor),
            peoplePlaceOfBirthLabel.trailingAnchor.constraint(equalTo: peopleInfoTitleLabel.trailingAnchor),
            peoplePlaceOfBirthLabel.topAnchor.constraint(equalTo: peopleBirthdayLabel.bottomAnchor, constant: 5),
            peoplePlaceOfBirthLabel.heightAnchor.constraint(equalToConstant: 60),
            
            socialStackView.leadingAnchor.constraint(equalTo: peopleInfoTitleLabel.leadingAnchor),
            //socialStackView.trailingAnchor.constraint(equalTo: peopleInfoTitleLabel.trailingAnchor),
            socialStackView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10),
            socialStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
