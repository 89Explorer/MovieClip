//
//  SearchViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            do {
                let test1 = try await NetworkManager.shared.fetchAllTvs()
                DispatchQueue.main.async {
                    dump(test1)
                }
            } catch {
                print("error")
            }
        }
    }
    

}
