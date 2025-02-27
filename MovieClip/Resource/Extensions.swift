//
//  Extensions.swift
//  MovieClip
//
//  Created by 권정근 on 2/7/25.
//

import Foundation
import FirebaseAuth


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}



// MARK: Firebase에서 반환하는 Error의 코드
extension AuthErrorCode {
    var errorMessage: String {
        switch self.code {
        case .invalidEmail:
            return "유효하지 않은 이메일 형식입니다."
        case .wrongPassword:
            return "비밀번호가 잘못되었습니다. 다시 확인해주세요."
        case .userNotFound:
            return "등록되지 않은 이메일 주소입니다."
        case .networkError:
            return "네트워크 연결이 원활하지 않습니다. 다시 시도해주세요."
        case .tooManyRequests:
            return "로그인 시도가 너무 많습니다. 잠시 후 다시 시도해주세요."
        case .userDisabled:
            return "이 계정은 사용 중지되었습니다. 관리자에게 문의하세요."
        case .emailAlreadyInUse:
            return "이미 사용 중인 이메일 주소입니다."
        case .weakPassword:
            return "비밀번호는 최소 6자 이상이어야 합니다."
        default:
            return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
        }
    }
}


