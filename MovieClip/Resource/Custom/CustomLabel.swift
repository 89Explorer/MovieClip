//
//  CustomLabel.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import Foundation
import UIKit


class CustomLabel: UILabel {
    
    // MARK: - Enum
    enum CustomLabelType {
        case title
        case subtitle
        case content
    }
    
    private let textLabelType: CustomLabelType
    
    init(labelType: CustomLabelType) {
        self.textLabelType = labelType
        super.init(frame: .zero)
        
        self.textColor = .black
        
        switch labelType {
        case .title:
            self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        case .subtitle:
            self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        case .content:
            self.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// 라벨 내 padding 적용
class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
