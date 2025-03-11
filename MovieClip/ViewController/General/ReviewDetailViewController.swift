//
//  ReviewDetailViewController.swift
//  MovieClip
//
//  Created by 권정근 on 3/10/25.
//

import UIKit

class ReviewDetailViewController: UIViewController {
    
    private var selectedReview: ReviewItem?
    
    // MARK: - UI Component
    private var reviewDetailTableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    
    
    init(review: ReviewItem) {
        self.selectedReview = review
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(reviewDetailTableView)
        view.backgroundColor = .black
        
        reviewDetailTableView.backgroundColor = .black
        
        reviewDetailTableView.delegate = self
        reviewDetailTableView.dataSource = self
        
        reviewDetailTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.reuseIdentifier)
        reviewDetailTableView.register(TitleTableCell.self, forCellReuseIdentifier: TitleTableCell.reuseIdentifier)
        reviewDetailTableView.register(ContentTableCell.self, forCellReuseIdentifier: ContentTableCell.reuseIdentifier)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reviewDetailTableView.frame = view.bounds
    }
    
}

extension ReviewDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseIdentifier, for: indexPath) as? ImageTableViewCell else {
                return UITableViewCell()
            }
            
            if let selectedReviewIamge = selectedReview?.photos {
                cell.configure(images: selectedReviewIamge)
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableCell.reuseIdentifier, for: indexPath) as? TitleTableCell else { return UITableViewCell() }
            
            if let reviewItem = selectedReview {
                cell.configure(reviewItem: reviewItem)
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableCell.reuseIdentifier, for: indexPath) as? ContentTableCell else { return UITableViewCell() }
            
            if let reviewItem = selectedReview {
                cell.configure(reviewItem: reviewItem)
            }
            
            return cell 
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 80
        case 2:
            return 300
        default:
            return 100
        }
    }
}
