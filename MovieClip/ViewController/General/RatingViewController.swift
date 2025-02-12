//
//  RatingViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/12/25.
//

import UIKit

class RatingViewController: UIViewController {
    
    // MARK: - Variable
    weak var delegate: RatingViewControllerDelegate?   // ✅ Delegate 선언
    private var selectedRatingPoint: String = ""       // ✅ 선택한 평점 저장 
    
    
    // MARK: - UI Component
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "평점을 선택해주세요 😁"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        
        slider.minimumValueImage = UIImage(systemName: "0.square", withConfiguration: largeConfig)
        slider.maximumValueImage = UIImage(systemName: "10.square", withConfiguration: largeConfig)
        
        slider.backgroundColor = .black
        slider.thumbTintColor = .systemGray
        slider.value = 0
        
        slider.minimumValue = 0
        slider.maximumValue = 10
        
        slider.maximumTrackTintColor = .systemYellow
        slider.minimumTrackTintColor = .systemGreen
        
        slider.layer.cornerRadius = 10
        slider.layer.masksToBounds = true
        
        slider.isContinuous = true // ✅ 슬라이더를 특정 값에서 멈추도록 설정
        
        return slider
    }()
    
    private let selectedRatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("완료", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        configureConstraints()
    
        slider.addTarget(self, action: #selector(sliderValueChange(_:)), for: .valueChanged)
        
        selectedRatingButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    
    // MARK: - Action
    @objc private func sliderValueChange(_ sender: UISlider) {
        
        let stepValue: Float = 0.5    // ✅ 0.5 단위로 눈금 끊기
        let roundedValue = round(sender.value / stepValue) * stepValue
        sender.value = roundedValue
        
        let showValue = String(format: "%.1f", roundedValue)
        self.selectedRatingPoint = showValue
        
        ratingLabel.text = "평점을 선택해주세요 😁" + "\(showValue)"
    }
    
    // ✅ 완료 버튼 클릭 시 델리게이트를 통해 값 전달
    @objc private func didTapDoneButton() {
        delegate?.didSlidedValue(with: selectedRatingPoint)
        dismiss(animated: true)
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        view.addSubview(ratingLabel)
        view.addSubview(slider)
        view.addSubview(selectedRatingButton)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        selectedRatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ratingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ratingLabel.heightAnchor.constraint(equalToConstant: 30),
            
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            slider.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 30),
            slider.heightAnchor.constraint(equalToConstant: 60),
            
            selectedRatingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            selectedRatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            selectedRatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            selectedRatingButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}

// MARK: - Protocol: RatingViewControllerDelegate
protocol RatingViewControllerDelegate: AnyObject {
    func didSlidedValue(with value: String)
}
