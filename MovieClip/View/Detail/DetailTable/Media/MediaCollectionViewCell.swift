//
//  MediaCollectionViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/11/25.
//

import UIKit
import SDWebImage

class MediaCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier = "MediaCollectionViewCell"
    weak var delegate: MediaCollectionViewCellDelegate?   // ✅ Delegate 선언
    private var videoKey: String?   // ✅ 클릭 시 YouTube 영상 키 저장
    
    
    // MARK: - UI Component
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill    // ✅ 기본값 설정
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        setupTapGesture() // ✅ 탭 제스처 설정
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil  // ✅ 이전 이미지 초기화
        thumbnailImageView.contentMode = .scaleAspectFill  // ✅ 기본값 설정
        thumbnailImageView.layer.cornerRadius = 0  // ✅ 코너 초기화
        thumbnailImageView.clipsToBounds = true  // ✅ 클립 설정 초기화
        videoKey = nil  // ✅ 이전 비디오 키 초기화
    }
    
    
    // MARK: - Function
    func configure(with content: MediaInfo) {
        let baseUrl = "https://img.youtube.com/vi/"
        
        switch content {
        case .video(let video):
            if let key = video.key {
                let thumbnailUrl = URL(string: "\(baseUrl)\(key)/hqdefault.jpg")
                thumbnailImageView.sd_setImage(with: thumbnailUrl, completed: nil)
                
                // ✅ 비디오 설정 적용
                thumbnailImageView.layer.cornerRadius = 20
                thumbnailImageView.clipsToBounds = true
                
                // ✅ 비디오 키 저장 (탭 시 사용)
                videoKey = key
            
            }
        case .poster(let poster):
            if let posterPath = poster.filePath {
                let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
                thumbnailImageView.sd_setImage(with: posterUrl, completed: nil)
                
                // ✅ 포스터 설정 적용
                thumbnailImageView.contentMode = .scaleAspectFit
                thumbnailImageView.layer.cornerRadius = 0
                thumbnailImageView.clipsToBounds = false
                
            }
        }
    }
    
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapThumbnail))
        thumbnailImageView.isUserInteractionEnabled = true   // ✅ 터치 가능하도록 설정
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Action
    @objc private func didTapThumbnail() {
        guard let videoKey = videoKey else { return }
        delegate?.didTapVideo(with: videoKey)    // ✅ Delegate를 통해 이벤트 전달
    }
    
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
}


// MARK: - Enum: 컬렉션뷰에서 개별 아이템을 저장할 enum
enum MediaInfo {
    case poster(PosterInfoBackdrop)
    case video(VideoInfoResult)
}


// MARK: - Protocol
protocol MediaCollectionViewCellDelegate: AnyObject {
    func didTapVideo(with videoKey: String)
}

