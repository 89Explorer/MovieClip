//
//  ReviewContentCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import UIKit

class ReviewContentCell: UICollectionViewCell, SelfConfiguringReviewCell {

    
    // MARK: - Variable
    static let reuseIdentifier: String = "ReviewContentCell"
    weak var delegate: ReviewContentCellDelegate?
    private let placeholderText = "영화나 티비를 보고, 감상 및 평가하는 공간입니다. 여러분의 평이 영화나 TV 프로그램을 더 좋게 만듭니다. 평을 남기신 분들은, 평을 남긴 후에도 이 공간에서 더 많은 평을 남길 수 있습니다."

    
    
    // MARK: - UI Component
    private let reviewTextView: UITextView = UITextView()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        
        reviewTextView.delegate = self
        
        reviewTextView.backgroundColor = .systemGray6
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.layer.masksToBounds = true
        reviewTextView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        reviewTextView.font = .systemFont(ofSize: 16, weight: .bold)
        reviewTextView.textColor = .gray
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(reviewTextView)
        
        NSLayoutConstraint.activate([
            
            reviewTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reviewTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            reviewTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with item: ReviewSectionItem) {
        if case .content(let string) = item {
            if string.isEmpty || string == placeholderText {
                reviewTextView.text = placeholderText
                reviewTextView.textColor = .gray
            } else {
                reviewTextView.text = string
                reviewTextView.textColor = .black
            }
        }
    }
}



extension ReviewContentCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.textColor == .gray {
            reviewTextView.text = ""
            reviewTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text.isEmpty {
            reviewTextView.text = placeholderText
            reviewTextView.textColor = .gray
        }
        
        delegate?.didUpdateContent(reviewTextView.text == placeholderText ? "" : reviewTextView.text)  // 델리게이트 호출
    }
}


protocol ReviewContentCellDelegate: AnyObject {
    func didUpdateContent(_ text: String)
}
