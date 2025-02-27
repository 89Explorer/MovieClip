//
//  AuthenticationViewModel.swift
//  MovieClip
//
//  Created by 권정근 on 2/25/25.
//

import Foundation
import FirebaseAuth
import Combine


final class AuthenticationViewModel: ObservableObject {
    
    // MARK: - Variable
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    private var cancelable: Set<AnyCancellable> = []
    
    
    // MARK: - Function
    /// 이메일, 비밀번호 입력 유효성 검사 메서드 
    func validateAuthenticationForm() {
        guard let email = email,
              let password = password else {
                isAuthenticationFormValid = false
                  return }
        
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 8
    }
    
    /// email 양식 검토 메서드
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /// 이메일, 비밀번호로 회원가입하는 메서드 
    func createUser() {
        guard let email = email,
              let password = password else { return }
        
        AuthManager.shared.registerUser(email: email, password: password)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                case .finished:
                    print("회원가입 성공")
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancelable)

    }
    
    func loginUser() {
        guard let email = email,
              let password = password else { return }
        
        AuthManager.shared.loginUser(email: email, password: password)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                case .finished:
                    print("회원가입 성공")
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancelable)

    }
}

