//
//  RegisterViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/25/25.
//

import UIKit
import Combine


class RegisterViewController: UIViewController {
    
    // MARK: - Variable
    private var viewModel = AuthenticationViewModel()
    private var cancelable = Set<AnyCancellable>()
    
    
    // MARK: - UI Component
    private let registerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your Account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.keyboardType = .emailAddress
        textField.font = .systemFont(ofSize: 12)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.isSecureTextEntry = true
        textField.font = .systemFont(ofSize: 12)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        bindViews()
        resigneKeyboard()
        configureConstraints()
    }
    
    
    // MARK: - Function
    private func bindViews() {
        emailTextField.addTarget(self, action: #selector(didChangedEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangedPassword), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        viewModel.$isAuthenticationFormValid
            .sink { [weak self] validationState in
                self?.registerButton.isEnabled = validationState
            }
            .store(in: &cancelable)
        
        // 회원가입 성공에 따른 화면 이동
        viewModel.$user
            .sink { [weak self] user in
                guard user != nil else { return }
                
                // 현재 RegisterViewController가 띄워진 모든 모달을 닫음 (Onboarding 포함)
                self?.view.window?.rootViewController?.dismiss(animated: true, completion: {
                    // ✅ 모든 화면을 닫은 후, rootViewController를 변경 (MainTabBarController로)
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.window?.rootViewController = MainTabBarController()
                    }
                })
            }
            .store(in: &cancelable)
        
        
    }
    
    /// 빈 곳을 누르면 키보드 내려가게 하는 메서드
    private func resigneKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Action
    @objc private func didChangedEmailField() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    
    @objc private func didChangedPassword() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapRegister() {
        viewModel.createUser()
    }
    
    
    // MARK: - Constraints
    private func configureConstraints() {
        view.addSubview(registerTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        registerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 40),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registerButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
}

