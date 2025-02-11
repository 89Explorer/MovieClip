//
//  MediaTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/11/25.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "MediaTableViewCell"
    weak var delegate: MediaCollectionViewCellDelegate?   // ✅ Delegate 추가
    
    // video 데이터 저장
    private var videos: [VideoInfoResult] = []
    
    // MediaType을 저장 - 기본값: .video
    private var mediaType: MediaType = .video
    
    // API 데이터 저장 -> 배열로 변경
    private var mediaItems: MediaContent?
    
    
    // MARK: - UI Component
    private let mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.itemSize = CGSize(width: 200, height: 120)  // 기본값: .video 사이즈
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        
        setupCollectionView()
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupCollectionView() {
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.reuseIdentifier)
    }
    
    
    func configure(with contents: MediaContent, type: MediaType) {
        
        DispatchQueue.main.async {
            self.mediaItems = contents
            self.mediaType = type
            
            // ✅ 미디어 타입에 따라 itemSize 변경
            if let layout = self.mediaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                
                switch type {
                case .poster:
                    layout.itemSize = CGSize(width: 150, height: 250)
                case .video:
                    layout.itemSize = CGSize(width: 220, height: 150)
                }
            }
            
            self.mediaCollectionView.reloadData()   // ✅ 데이터 업데이트 후 리로드
        }
        
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(mediaCollectionView)
        
        mediaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mediaCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mediaCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mediaCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mediaCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
    }
}


// MARK: - Extension
extension MediaTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch mediaItems {
        case .poster(let posters):
            return posters.count
        case .video(let videos):
            return videos.count
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.reuseIdentifier, for: indexPath) as? MediaCollectionViewCell else { return UICollectionViewCell() }
        
        switch mediaItems {
        case .poster(let posters):
            let posterItem = posters[indexPath.item]
            cell.configure(with: .poster(posterItem))
        case .video(let videos):
            let videoItem = videos[indexPath.item]
            cell.configure(with: .video(videoItem))
            cell.delegate = self  // ✅ Delegate 설정
        case .none:
            break
        }
        return cell
    }
}


// ✅ 미디어 타입을 구분할 enum
enum MediaType {
    case poster
    case video
}


// ✅ API 응답 데이터를 저장할 enum
enum MediaContent {
    case poster([PosterInfoBackdrop])   // 포스터 데이터 저장하는 배열
    case video([VideoInfoResult])       // 비디오 데이터 저장하는 배열
}


// MARK: - MediaCollectionViewCellDelegate
extension MediaTableViewCell: MediaCollectionViewCellDelegate {
    func didTapVideo(with videoKey: String) {
        delegate?.didTapVideo(with: videoKey) // ✅ 이벤트를 DetailViewController로 전달
    }
}

// ✅ `MediaTableViewCellDelegate` 선언
protocol MediaTableViewCellDelegate: AnyObject {
    func didTapVideo(with videoKey: String)
}
