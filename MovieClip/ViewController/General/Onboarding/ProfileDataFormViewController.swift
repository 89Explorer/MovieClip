//
//  ProfileDataFormViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/27/25.
//

import UIKit
import PhotosUI
import Combine
import SDWebImage


class ProfileDataFormViewController: UIViewController {
    
    // MARK: - Variable
    private var viewModel = ProfileDataFormViewModel()
    private var cancelable: Set<AnyCancellable> = []
    
    weak var delegate: ProfileDataFormViewControllerDelegate?
    var user: MovieClipUser
    
    
    // MARK: - UI Component
    private let basicScrollView: UIScrollView = UIScrollView()
    private let hintLabel: UILabel = UILabel()
    private let usernameTextField: UITextField = UITextField()
    private let avatarPlaceholderImageView: UIImageView = UIImageView()
    private let bioTextView: UITextView = UITextView()
    private let submitButton: UIButton = UIButton()

    
    // MARK: - Init
    init(user: MovieClipUser, isInitialProfileSetup: Bool = false) {
        self.user = user
        //self.viewModel = ProfileDataFormViewModel()   // viewModel 초기화
        self.viewModel.isInitialProfileSetup = isInitialProfileSetup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        //usernameTextField.delegate = self
        bioTextView.delegate = self
        
        isModalInPresentation = true   // ✅ 창 내리기 방지
        bindViews()
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        configureAvatarImage()
        configureUI()
        
        setUserData()
    }
    
    
    // MARK: - Functio
    private func setUserData() {
        usernameTextField.text = user.username
        bioTextView.text = user.bio
        if let avatarPath = URL(string: user.avatarPath) {
            avatarPlaceholderImageView.sd_setImage(with: avatarPath)
        }
        
        // 기존 프로필 이미지 ViewModel에 저장
        viewModel.existingAvatarPath = user.avatarPath
        
        // viewModel에도 기존 데이터 반영
        viewModel.username = user.username
        viewModel.bio = user.bio
        viewModel.avatarPath = user.avatarPath
    }
    
    
    
    /// 프로필 이미지 선택 메서드
    private func configureAvatarImage() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToUpload))
        avatarPlaceholderImageView.addGestureRecognizer(imageTapGesture)
    }
    
    private func bindViews() {
        usernameTextField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        
        viewModel.$isFormValid
            .sink { [weak self] buttonState in
                self?.submitButton.isEnabled = buttonState
                dump("\(self!.submitButton.isEnabled)")
                self?.submitButton.backgroundColor = buttonState ? .systemBlue : .systemGray
            }
            .store(in: &cancelable)
        
        viewModel.$isOnboardingFinished
            .sink { [weak self] success in
                if success {
                    // ✅ 기존의 모든 화면을 닫고, OnboardingViewController로 이동
                    self?.view.window?.rootViewController?.dismiss(animated: true, completion: {
                        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            sceneDelegate.window?.rootViewController = MainTabBarController()
                        }
                    })
                }
            }
            .store(in: &cancelable)
    }
    
    
    // MARK: - Action
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    @objc private func didTapToUpload() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didUpdateUsername() {
        viewModel.username = usernameTextField.text
        viewModel.validateUserProfileForm()
    }
    
    @objc private func didTapSubmit() {
        viewModel.uploadAvatar()
    }

    
    // MARK: - UI Layout
    private func configureUI() {
        
        // 스크롤뷰 설정
        basicScrollView.alwaysBounceVertical = true
        basicScrollView.keyboardDismissMode = .onDrag
        basicScrollView.isScrollEnabled = true
        basicScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 힌트 라벨 설정
        hintLabel.text = "프로필 작성"
        hintLabel.font = .systemFont(ofSize: 32, weight: .bold)
        hintLabel.textColor = .systemBlue
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 유저이름 라벨 설정
        usernameTextField.keyboardType = .default
        usernameTextField.backgroundColor = .white
        usernameTextField.textColor = .black
        usernameTextField.font = .systemFont(ofSize: 16, weight: .bold)
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.masksToBounds = true
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "사용하실 닉네임을 3자 이상 입력하세요", attributes: [.foregroundColor: UIColor.gray])
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 아바타 프로필 사진 설정
        avatarPlaceholderImageView.layer.cornerRadius = 80
        avatarPlaceholderImageView.layer.masksToBounds = true
        avatarPlaceholderImageView.clipsToBounds = true
        avatarPlaceholderImageView.backgroundColor = .white
        let url = URL(string: "https://ssl.pstatic.net/static/pwe/address/img_profile.png")
        avatarPlaceholderImageView.sd_setImage(with: url)
        avatarPlaceholderImageView.contentMode = .scaleAspectFill
        avatarPlaceholderImageView.tintColor = .gray
        avatarPlaceholderImageView.isUserInteractionEnabled = true
        avatarPlaceholderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 자기소개 설정
        bioTextView.backgroundColor = .white
        bioTextView.layer.cornerRadius = 10
        bioTextView.layer.masksToBounds = true
        bioTextView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        bioTextView.text = "간단한 자기 소개 글을 3자 이상 작성해주세요" + "\n" + "예: 액션 영화를 좋아하는 토끼"
        bioTextView.textColor = viewModel.isInitialProfileSetup ? .gray : .black
        //bioTextView.textColor = .gray
        bioTextView.font = .systemFont(ofSize: 16, weight: .bold)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 제출 버튼 설정
        submitButton.setTitle( "작성 완료", for: .normal)
        submitButton.tintColor = .white
        submitButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        submitButton.backgroundColor = .systemGray
        submitButton.layer.cornerRadius = 10
        submitButton.layer.masksToBounds = true
        submitButton.isEnabled = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 제약조건 설정
        view.addSubview(basicScrollView)
        basicScrollView.addSubview(hintLabel)
        basicScrollView.addSubview(usernameTextField)
        basicScrollView.addSubview(avatarPlaceholderImageView)
        basicScrollView.addSubview(usernameTextField)
        basicScrollView.addSubview(bioTextView)
        basicScrollView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            
            basicScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basicScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basicScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            basicScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hintLabel.centerXAnchor.constraint(equalTo: basicScrollView.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: basicScrollView.topAnchor, constant: 30),
            
            avatarPlaceholderImageView.centerXAnchor.constraint(equalTo: basicScrollView.centerXAnchor),
            avatarPlaceholderImageView.heightAnchor.constraint(equalToConstant: 160),
            avatarPlaceholderImageView.widthAnchor.constraint(equalToConstant: 160),
            avatarPlaceholderImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 30),
            
            usernameTextField.centerXAnchor.constraint(equalTo: basicScrollView.centerXAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: basicScrollView.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: basicScrollView.trailingAnchor, constant: -20),
            usernameTextField.topAnchor.constraint(equalTo: avatarPlaceholderImageView.bottomAnchor, constant: 30),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            bioTextView.centerXAnchor.constraint(equalTo: basicScrollView.centerXAnchor),
            bioTextView.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: bioTextView.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            bioTextView.heightAnchor.constraint(equalToConstant: 150),
            
            submitButton.centerXAnchor.constraint(equalTo: basicScrollView.centerXAnchor),
            submitButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            submitButton.bottomAnchor.constraint(equalTo: basicScrollView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}


// MARK: - Extension: UITextViewDelegate
extension ProfileDataFormViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        basicScrollView.setContentOffset(CGPoint(x: 0, y: bioTextView.bounds.origin.y), animated: true)
        
        if bioTextView.textColor == .gray {
            bioTextView.textColor = .black
            bioTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        basicScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        if bioTextView.text.isEmpty {
            bioTextView.text = "간단한 자기 소개 글을 작성해주세요" + "\n" + "예: 액션 영화를 좋아하는 토끼"
            bioTextView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = bioTextView.text
        viewModel.validateUserProfileForm()
    }
}


extension ProfileDataFormViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self ] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarPlaceholderImageView.image = image
                        self?.viewModel.imageData = image
                        self?.viewModel.validateUserProfileForm()
                    }
                }
            }
        }
    }
}


// MARK: - Protocol
protocol ProfileDataFormViewControllerDelegate: AnyObject {
    func didUpdateUser(_ updatedUser: MovieClipUser)
}
