//
//  MovieViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class MovieViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        Task {
            do {
                let movieNowPlaying = try await NetworkManager.shared.fetchAllMovies()
                dump(movieNowPlaying)
            }
            catch {
                print("❌ 에러발생 \(error)")
            }
        }
    }
}
