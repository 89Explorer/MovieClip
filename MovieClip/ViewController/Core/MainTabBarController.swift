//
//  ViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let movieVC = UINavigationController(rootViewController: MovieViewController())
        let seriesVC = UINavigationController(rootViewController: SeriesViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        
        homeVC.tabBarItem.image = UIImage(systemName: "newspaper")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill")
        
        movieVC.tabBarItem.image = UIImage(systemName: "film.stack")
        movieVC.tabBarItem.selectedImage = UIImage(systemName: "film.stack.fill")
        
        seriesVC.tabBarItem.image = UIImage(systemName: "mail.stack")
        seriesVC.tabBarItem.selectedImage = UIImage(systemName: "mail.stack.fill")
        
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        profileVC.tabBarItem.image = UIImage(systemName: "person")
        profileVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        homeVC.tabBarItem.title = "투데이"
        movieVC.tabBarItem.title = "영화"
        seriesVC.tabBarItem.title = "시리즈"
        searchVC.tabBarItem.title = "검색"
        profileVC.tabBarItem.title = "프로필"
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.tintColor = .systemBlue
        
        self.setViewControllers([homeVC, movieVC, seriesVC, searchVC, profileVC], animated: true)
        
    }
}

