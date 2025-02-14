//
//  PeopleOverviewTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/13/25.
//

import UIKit

class PeopleOverviewTableViewCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "PeopleOverviewTableViewCell"
    weak var delegate: PeopleOverviewTableViewCellDelegate?
    
    private var isExpanded: Bool = false   // ✅ 현재 셀의 확장 상태 저장
    
    
    // MARK: - UI Component
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 5    // ✅ 기본적으로 5줄까지만 표시
        label.textColor = .white
        label.clipsToBounds = true // ✅ 초과 내용 숨김
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        
        expandButton.addTarget(self, action: #selector(didTapExpandButton), for: .touchUpInside)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with content: String, isExpanded: Bool) {
        overviewLabel.text = content
        self.isExpanded = isExpanded
        
        overviewLabel.numberOfLines = isExpanded ? 0 : 5   // // ✅ 확장 여부에 따라 줄 수 변경
        expandButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
    }
    
    
    // MARK: - Action
    @objc private func didTapExpandButton() {
        delegate?.didTapExpandButton(in: self)
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(overviewLabel)
        contentView.addSubview(expandButton)
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            overviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            //expandButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            expandButton.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
}


// MARK: - Protocol: PeopleOverviewTableViewCellDelegate
protocol PeopleOverviewTableViewCellDelegate: AnyObject {
    func didTapExpandButton(in cell: PeopleOverviewTableViewCell)
}
