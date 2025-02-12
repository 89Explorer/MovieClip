//
//  CastCollectionViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/10/25.
//

import UIKit
import SDWebImage

class CastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "CastCollectionViewCell"
    weak var delegate: CastCollectionViewCellDelegate?
    
    private var peopleId: Int?    // ✅ 배우 id 저장
    
    // MARK: - UI Component
    private let basicView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "poster")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캡틴 아메리카"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "캡틴 아메리카 영화"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        
        setupTapGesture()
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with casting: TopBilledCastInfo) {
        let name = casting.name
        let character = casting.character
        
        titleLabel.text = name
        roleLabel.text = character
        
        if let posterPath = casting.profilePath, !posterPath.isEmpty {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
        } else {
            posterImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
        }
        
        self.peopleId = casting.id
    }
    
    /// posterImageView에 탭제스처 적용
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPosterImageView))
        posterImageView.isUserInteractionEnabled = true   // ✅ 터치 가능하도록 설정
        posterImageView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Action
    @objc private func didTapPosterImageView() {
        guard let peopleId = peopleId else {
            print("❌ No PeopleId")
            return
        }
        delegate?.didTapPosterImageView(with: peopleId)
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(posterImageView)
        basicView.addSubview(titleLabel)
        basicView.addSubview(roleLabel)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 0),
            posterImageView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: 0),
            posterImageView.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            roleLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 0),
            roleLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: 0),
            roleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            roleLabel.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: 0)
        ])
    }
}


// MARK: - Protocol
protocol CastCollectionViewCellDelegate: AnyObject {
    func didTapPosterImageView(with peopleId: Int)
}
