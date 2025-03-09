//
//  TodayCollectionViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/19/25.
//


import UIKit
import SDWebImage

class TodayCollectionViewCell: UICollectionViewCell,SelfConfiguringCell {
    
    static var reuseIdentifier: String = "TodayCollectionViewCell"
    
    let tagline = UILabel()
    let title = UILabel()
    let overview = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        let seperator = UIView(frame:.zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .quaternaryLabel
        
        tagline.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagline.textColor = .systemRed
        
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.textColor = .white
        
        overview.font = UIFont.preferredFont(forTextStyle: .footnote)
        overview.numberOfLines = 2
        overview.textColor = .white
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [tagline, title, overview, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        stackView.setCustomSpacing(10, after: seperator)
        stackView.setCustomSpacing(5, after: overview)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: MainResults) {
        
        // guard let model = model.results.first else { return }
        guard let vote = model.vote_average else { return }
        if vote <= 0 {
            tagline.text = "평점: 0.0"
        } else {
            let rountVote = String(format: "%.1f", vote)
            tagline.text = "평점: " + rountVote
        }
        
        // tagline.text = model.release_date
        if model.overview.count == 0 {
            overview.text = "아직 소개 글이 없어요 😅"
        } else {
            overview.text = model.overview
        }
        title.text = model.title
        guard let posterPath = model.poster_path else { return }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
        
        imageView.sd_setImage(with: url, completed: nil)
        
        // 비동기적으로 번역 수행
        Task {
//            let translatedText = await GoogleTranslateAPI.translateText(model.overview)
            DispatchQueue.main.async {
                self.overview.text = model.overview
            }
        }
    }
}
