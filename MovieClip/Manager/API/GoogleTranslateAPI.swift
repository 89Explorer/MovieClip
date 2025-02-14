//
//  GoogleTranslateAPI.swift
//  MovieClip
//
//  Created by 권정근 on 2/15/25.
//

import Foundation

struct GoogleTranslateAPI {
    
    // MARK: - Variable
    static let googleAPI_KEY = "AIzaSyCFdYxCxHXF07ssuM2ie9rEm6EQ6EDyJ0o"
    
    
    // MARK: - Function
    // 구글 클라우드 번역 API를 통해 번역하는 메서드
    static func translateText(_ text: String) async -> String {
        let targetLanguage = "ko" // 한국어(Korean)로 번역
        let sourceLanguage = "en" // 영어(English)로부터 번역
        
        // ✅ API 요청 URL 생성
        let urlString = "https://translation.googleapis.com/language/translate/v2?key=\(GoogleTranslateAPI.googleAPI_KEY)"
        guard let url = URL(string: urlString) else {
            return text         // ✅ 번역 실패 시 원본 반환
        }
        
        // ✅ 요청 데이터 설정 (JSON Body)
        let parameters: [String: Any] = [
            "q": text, // 번역할 텍스트
            "source": sourceLanguage, // 원본 언어
            "target": targetLanguage, // 번역할 언어
            "format": "text"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            return text
        }
        
        // ✅ URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
    
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let data = json?["data"] as? [String: Any],
               let translations = data["translations"] as? [[String: Any]],
               let translatedText = translations.first?["translatedText"] as? String {
                return translatedText // ✅ 번역 결과 반환
            } else {
                return text // ✅ 번역 실패 시 원본 반환
            }
        } catch {
            return text
        }
    }
    
}
