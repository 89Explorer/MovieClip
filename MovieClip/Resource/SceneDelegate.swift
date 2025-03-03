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
        
        // ✅ 1️⃣ 먼저 스플래시 화면을 띄운 후, Firebase 인증 확인을 비동기로 실행
        self.window?.rootViewController = SplashViewController()
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    // ✅ Firebase 인증 체크를 비동기적으로 수행하여 UI 블로킹 방지
    private func checkAuthentication() {
        DispatchQueue.global().async { [weak self] in
            let isAuthenticated = Auth.auth().currentUser != nil
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if isAuthenticated {
                    if !(self.window?.rootViewController is MainTabBarController) {
                        self.gotoController(with: MainTabBarController(), animated: false)
                    }
                } else {
                    self.gotoController(with: UINavigationController(rootViewController: OnboardingViewController()), animated: false)
                }
            }
        }
    }
    
    // ✅ 화면 전환 시, 필요할 때만 애니메이션 적용
    private func gotoController(with viewController: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            }, completion: nil)
        } else {
            window.rootViewController = viewController
        }
    }

}


/*
 class SceneDelegate: UIResponder, UIWindowSceneDelegate {
 
 var window: UIWindow?
 
 
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 
 self.setupWindow(with: scene)
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
 */
