//
//  CreditTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/17/25.
//

import UIKit

class CreditTableViewCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "CreditTableViewCell"
    
    // MediaType을 저장 - 기본값: .video
    private var creditType: CreditType = .movie
    
    // API 데이터 저장 -> 배열로 변경
    private var creditItems: CreditInfos?
    
    weak var delegate: CreditTableViewCellDelegate?
    
    
    private let calledMovieCreditButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        button.setTitle("Movie", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    private let calledTVCreditButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        button.setTitle("TV", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    private let creditCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 180)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        setupCollectionViewDelegate()
        
        self.updateButtonState()
        
        configureConstraints()
        calledMovieCreditButton.addTarget(self, action: #selector(didTapCalledMovie), for: .touchUpInside)
        calledTVCreditButton.addTarget(self, action: #selector(didTapCalledTV), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupCollectionViewDelegate() {
        creditCollectionView.delegate = self
        creditCollectionView.dataSource = self
        creditCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        creditCollectionView.register(CreditCollectionViewCell.self, forCellWithReuseIdentifier: CreditCollectionViewCell.reuseIdentifier)
    }
    
    
    func configure(with creditInfos: CreditInfos, creditType: CreditType) {
        self.creditItems = creditInfos
        self.creditType = creditType
        
        DispatchQueue.main.async {
            self.creditCollectionView.reloadData()
            self.updateButtonState()
        }
    }
    
    // ✅ 버튼 UI 업데이트 함수 추가
    private func updateButtonState() {
        switch creditType {
        case .movie:
            calledMovieCreditButton.backgroundColor = .systemBlue
            calledTVCreditButton.backgroundColor = .systemGray
        case .tv:
            calledMovieCreditButton.backgroundColor = .systemGray
            calledTVCreditButton.backgroundColor = .systemBlue
        }
    }
    
    
    
    // MARK: - Action
    @objc private func didTapCalledMovie() {
        delegate?.didTapCategoryButton()
    }
    
    @objc private func didTapCalledTV() {
        delegate?.didTapCategoryButton()
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(calledMovieCreditButton)
        buttonStackView.addArrangedSubview(calledTVCreditButton)
        
        contentView.addSubview(creditCollectionView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        creditCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            buttonStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonStackView.widthAnchor.constraint(equalToConstant: 120),
            
            creditCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            creditCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            creditCollectionView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 5),
            creditCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            creditCollectionView.heightAnchor.constraint(equalToConstant: 180)
            
        ])
        
    }
    
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension CreditTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch creditItems {
        case .movie(let movie):
            return movie.count
        case .tv(let tv):
            return tv.count
        case .none:
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCollectionViewCell.reuseIdentifier, for: indexPath) as? CreditCollectionViewCell else { return UICollectionViewCell() }
        
        switch creditItems {
        case .movie(let movies):
            let movie = movies[indexPath.item]
            cell.configure(with: .movie(movie))
            cell.delegate = self
        case .tv(let tvs):
            let tv = tvs[indexPath.item]
            cell.configure(with: .tv(tv))
            cell.delegate = self
        case .none:
            break
        }
        return cell
    }
}


extension CreditTableViewCell: CreditCollectionViewCellDelegate {
    
    func didTapImage(with contentID: Int, contentType: ContentType) {
        delegate?.didTapImage(with: contentID, contentType: contentType)
    }
    
}


protocol CreditTableViewCellDelegate: AnyObject {
    func didTapImage(with contentID: Int, contentType: ContentType)
    func didTapCategoryButton()
}




enum CreditType {
    case movie
    case tv
    
    mutating func toggle() {
        self = (self == .movie) ? .tv : .movie
    }
}

enum CreditInfos {
    case movie([MovieCreditCast])
    case tv([TVCreditCast])
}

enum CreditInfo {
    case movie(MovieCreditCast)
    case tv(TVCreditCast)
}
