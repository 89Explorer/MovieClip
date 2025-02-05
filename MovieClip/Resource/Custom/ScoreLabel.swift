//
//  ScoreLabel.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import Foundation
import UIKit


class ScoreLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        textAlignment = .center
        font = .systemFont(ofSize: 10, weight: .bold) // 기본 폰트 크기
        backgroundColor = .black
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
        clipsToBounds = true
    }

    /// 점수에 따라 색상 변경하는 메서드
    func configure(with score: Int) {
        let fullText = "\(score)%"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // 점수에 따라 색상 설정
        let scoreColor: UIColor
        switch score {
        case 80...100:
            scoreColor = .green
        case 60..<80:
            scoreColor = .orange
        case 40..<60:
            scoreColor = .yellow
        default:
            scoreColor = .red
        }
        
        // "숫자(점수)" 부분 색상 변경
        attributedString.addAttribute(.foregroundColor, value: scoreColor, range: NSRange(location: 0, length: fullText.count - 1))
        
        // "%" 부분 (작은 크기 유지)
        let smallerFont = UIFont.systemFont(ofSize: 8, weight: .bold)
        attributedString.addAttribute(.font, value: smallerFont, range: NSRange(location: fullText.count - 1, length: 1))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: fullText.count - 1, length: 1))
        
        self.attributedText = attributedString
    }
}

