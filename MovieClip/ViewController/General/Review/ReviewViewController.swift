//
//  ReviewViewController.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import UIKit
import Combine
import PhotosUI


class ReviewViewController: UIViewController {
    
    
    // MARK: - Variable
    private var dataSource: UICollectionViewDiffableDataSource<ReviewSection, ReviewSectionItem>?
    private var review: ReviewItem = ReviewItem()
    
    
    // MARK: - UI Component
    private var reviewCollectionView: UICollectionView!
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        configureNavigationBarAppearance()
        setupCollectionView()
        
        createDataSource()
        reloadData(for: review)
    }
    
    
    // MARK: - Function
    private func setupCollectionView() {
        reviewCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        reviewCollectionView.backgroundColor = .black
        reviewCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reviewCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(reviewCollectionView)
        
        reviewCollectionView.register(ReviewPhotoCell.self, forCellWithReuseIdentifier: ReviewPhotoCell.reuseIdentifier)
        reviewCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    
    private func configure<T: SelfConfiguringReviewCell>(_ cellType: T.Type, with model: ReviewSectionItem, for indexPath: IndexPath) -> T {
        guard let cell = reviewCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else { fatalError("Unable to deque: \(cellType)")}
        cell.configure(with: model)
        return cell
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ReviewSection, ReviewSectionItem>(collectionView: reviewCollectionView) { collectionView, indexPath, item in
            
            let section: ReviewSection = ReviewSection.allCases[indexPath.section]
            
            switch section {
            case .photos:
                let cell = self.configure(ReviewPhotoCell.self, with: item, for: indexPath)
                cell.delegate = self
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                return cell
            }
            
        }
    }
    
    
    private func reloadData(for review: ReviewItem) {
        var snapshot = NSDiffableDataSourceSnapshot<ReviewSection, ReviewSectionItem>()
        
        snapshot.appendSections(ReviewSection.allCases)
        
        snapshot.appendItems([.photo(review.photos)], toSection: .photos)
        snapshot.appendItems([.content(review.content)], toSection: .content)
        snapshot.appendItems([.date(review.date)], toSection: .date)
        snapshot.appendItems([.rating(review.rating)], toSection: .rating)
        
        print("Applying snapshot with \(review.photos.count) photos")
        
        dataSource?.apply(snapshot, animatingDifferences: true) {
            DispatchQueue.main.async {
                self.reviewCollectionView.reloadData()
            }
        }
    }
    
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = ReviewSection.allCases[sectionIndex]
            
            switch section {
            case .photos:
                return self.createPhotoSection(using: .photos)
            default:
                return self.createDefaultSection() 
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    
    
    private func createPhotoSection(using section: ReviewSection) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    
    // ✅ 기본적인 레이아웃 섹션 추가
    private func createDefaultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // ✅ 네비게이션 바 배경 검은색
        appearance.backgroundColor = .black
        
        // ✅ 큰 타이틀 색상 흰색
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // ✅ 일반 타이틀 색상 흰색
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Write Review"
    }
    
    
    private func didTapAddPhotoButotn() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}


// MARK: - Extension
extension ReviewViewController: ReviewPhotoCellDelegate {
    func didTapSelectedImages() {
        didTapAddPhotoButotn()
    }
}


extension ReviewViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var selectedImages: [UIImage] = []
        
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    selectedImages.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.review.photos = selectedImages
            print("Updated photos count: \(self.review.photos.count)")
            self.reloadData(for: self.review)
        }
    }
    
}
