//
//  SceneDelegate.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        self.setupWindow(with: scene)
        checkAuthentication()
        
        // 로그아웃 시 화면 변경을 위한 Notifiation 설정
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: NSNotification.Name("UserDidLogout"), object: nil)
        
        
        // 회원가입 성공 후 처리
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserCreated), name: NSNotification.Name("CreateUserSuccess"), object: nil)
    }
    
    
    @objc private func handleLogout() {
        checkAuthentication()
    }
    
    @objc private func handleUserCreated() {
        checkAuthentication()
    }
    
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            self.gotoController(with: UINavigationController(rootViewController: OnboardingViewController()))
        } else {
            
            // ✅ 기존에 MainTabBarController가 있으면 새로 만들지 않음
            if !(window?.rootViewController is MainTabBarController) {
                gotoController(with: MainTabBarController())
            }
        }
    }
    
    
    private func gotoController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                let vc = viewController
                vc.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = vc
                
                UIView.animate(withDuration: 0.3) {
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
}

