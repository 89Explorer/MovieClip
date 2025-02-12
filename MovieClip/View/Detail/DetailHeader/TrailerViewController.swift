//
//  TrailerViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/9/25.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    // MARK: - Variable
    let trailerTitle: String
    
    
    // MARK: - UI Component
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.addSubview(webView)
        webView.frame = view.bounds
        
        if let url = URL(string: "https://www.youtube.com/results?search_query=\(trailerTitle) + Trailer") {
            webView.load(URLRequest(url: url))
        }
    }
    
    init(trailerTitle: String) {
        self.trailerTitle = trailerTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
