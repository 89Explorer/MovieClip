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
    private let reviewTitleTextField: UITextField = UITextField(frame: .zero)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        
        
        reviewTextView.delegate = self
        reviewTitleTextField.delegate = self // ✅ UITextField 델리게이트 추가

        
        reviewTextView.backgroundColor = .systemGray6
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.layer.masksToBounds = true
        reviewTextView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        reviewTextView.font = .systemFont(ofSize: 18, weight: .bold)
        reviewTextView.textColor = .gray
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        
        reviewTitleTextField.font = .systemFont(ofSize: 18, weight: .bold)
        reviewTitleTextField.placeholder = "영화나 티비를 보고 한 줄 평을 남겨주세요"
        reviewTitleTextField.leftViewMode = .always
        reviewTitleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        reviewTitleTextField.textColor = .black
        reviewTitleTextField.backgroundColor = .white
        reviewTitleTextField.layer.cornerRadius = 10
        reviewTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(reviewTextView)
        contentView.addSubview(reviewTitleTextField)
        
        NSLayoutConstraint.activate([
            
            reviewTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reviewTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            reviewTextView.bottomAnchor.constraint(equalTo: reviewTitleTextField.topAnchor, constant: -20),
            
            reviewTitleTextField.heightAnchor.constraint(equalToConstant: 50),
            reviewTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewTitleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reviewTitleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with item: ReviewSectionItem) {
        if case .content(let string) = item {
            if string.reviewContent.isEmpty || string.reviewContent == placeholderText {
                reviewTextView.text = placeholderText
                reviewTextView.textColor = .gray
            } else {
                reviewTextView.text = string.reviewContent
                reviewTextView.textColor = .black
            }
            
            reviewTitleTextField.text = string.reviewTitle
        }
    }
    
    private func moveViewForKeyboard(up: Bool) {
        let movement: CGFloat = up ? -150 : 150 // ✅ 키보드 크기에 맞춰 조정
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame.origin.y += movement
        })
    }
}



extension ReviewContentCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.textColor == .gray {
            reviewTextView.text = ""
            reviewTextView.textColor = .black
        }
        
        moveViewForKeyboard(up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text.isEmpty {
            reviewTextView.text = placeholderText
            reviewTextView.textColor = .gray
        }
        
        moveViewForKeyboard(up: false)
        
        delegate?.didUpdateContent(ReviewContent(reviewTitle: reviewTitleTextField.text ?? "", reviewContent: reviewTextView.text ?? ""))
    }
}


extension ReviewContentCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("📝 텍스트 필드 입력 시작됨: \(textField.text ?? "")")
        moveViewForKeyboard(up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("✅ 텍스트 필드 입력 완료: \(textField.text ?? "")")
        moveViewForKeyboard(up: false)
    }
}


protocol ReviewContentCellDelegate: AnyObject {
    func didUpdateContent(_ content: ReviewContent)
}
