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
    private var viewModel = ReviewViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var selectedImages: [UIImage] = []
    
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
        
        setupTapGesture()
        
    }
    
    
    // MARK: - Function
    // ✅ viewModel 바인딩 설정
    private func setupBindings() {
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error {
                    print("❌ 리뷰 저장 오류: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    
    // ✅ 터치하면 키보드가 내려가도록 설정
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss))
        tapGesture.cancelsTouchesInView = false // ✅ 다른 터치 이벤트가 무시되지 않도록 설정
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupCollectionView() {
        reviewCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        reviewCollectionView.backgroundColor = .black
        reviewCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reviewCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(reviewCollectionView)
        
        reviewCollectionView.register(ReviewPhotoCell.self, forCellWithReuseIdentifier: ReviewPhotoCell.reuseIdentifier)
        reviewCollectionView.register(ReviewContentCell.self, forCellWithReuseIdentifier: ReviewContentCell.reuseIdentifier)
        reviewCollectionView.register(ReviewOptionCell.self, forCellWithReuseIdentifier: ReviewOptionCell.reuseIdentifier)
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
            case .content:
                let cell = self.configure(ReviewContentCell.self, with: item, for: indexPath)
                cell.delegate = self
                return cell
            case .options:
                let cell = self.configure(ReviewOptionCell.self, with: item, for: indexPath)
                cell.delegate = self
                return cell
            }
            
        }
    }
    
    
    private func reloadData(for review: ReviewItem) {
        var snapshot = NSDiffableDataSourceSnapshot<ReviewSection, ReviewSectionItem>()
        
        snapshot.appendSections(ReviewSection.allCases)
        
        if let selectedImages = viewModel.selectedImages, !selectedImages.isEmpty {
            snapshot.appendItems([.photo(.image(selectedImages))], toSection: .photos)
        } else {
            snapshot.appendItems([.photo(.string(viewModel.uploadedPhotoURLs))], toSection: .photos)
        }
        
        
        snapshot.appendItems([.content(review.content)], toSection: .content)
        snapshot.appendItems([
            .options(.date(review.date), "시청한 날짜 "),
            .options(.rating(review.rating), "평점 ")
        ], toSection: .options)
        
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
            case .content:
                return self.createContentSection(using: .content)
            case .options:
                return self.createOptionsSection(using: .options)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    
    private func createPhotoSection(using section: ReviewSection) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    
    private func createContentSection(using section: ReviewSection) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    
    private func createOptionsSection(using section: ReviewSection) -> NSCollectionLayoutSection {
        // ✅ 1. 아이템 크기 설정 (가로 전체, 높이 50)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // ✅ 2. 그룹 크기 설정 (세로 방향으로 아이템 2개 배치)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100) // 날짜 & 평점 두 개니까 50 x 2
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        // ✅ 3. 섹션 생성
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        // ✅ 4. 간격 설정 (위/아래 간격 10)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
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
        
        // ✅ "작성 완료" 버튼 추가
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        doneButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapDoneButton() {
        // ✅ 리뷰 데이터 확인
        print("✅ 리뷰 작성 완료")
        print("📸 사진 개수: \(review.photos.count)")
        print("📝 내용: \(review.content)")
        print("📅 날짜: \(formattedDate(review.date))")
        print("⭐ 평점: \(review.rating)")
        
        viewModel.reviewContent = review.content
        viewModel.reviewDate = review.date
        viewModel.reviewRating = review.rating
        
        viewModel.uploadPhoto(reviewID: review.id)
        
        // ✅ 서버로 데이터 전송 or 저장 로직 추가 가능
        navigationController?.popViewController(animated: true) // ✅ 현재 화면 닫기
    }
    
    // ✅ 날짜 포맷 함수
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    /// 사진 선택
    private func didTapAddPhotoButotn() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selection = .ordered
        configuration.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    private func showDatePicker() {
        let alert = UIAlertController(title: "시청한 날짜", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 10, y: 30, width: alert.view.bounds.width - 20, height: 200)
        
        alert.view.addSubview(datePicker)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.review.date = datePicker.date
            self.reloadData(for: self.review)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showRatingPicker() {
        let alert = UIAlertController(title: "평점 선택", message: "\n\n\n", preferredStyle: .actionSheet)
        
        let slider = UISlider(frame: CGRect(x: 10, y: 50, width: alert.view.bounds.width - 40, height: 30))
        slider.minimumValue = 0
        slider.maximumValue = 5
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        
        slider.minimumValueImage = UIImage(systemName: "0.square", withConfiguration: largeConfig)
        slider.maximumValueImage = UIImage(systemName: "5.square", withConfiguration: largeConfig)
        
        slider.maximumTrackTintColor = .systemYellow
        slider.minimumTrackTintColor = .systemGreen
        slider.tintColor = .black
        
        slider.value = Float(review.rating)
        slider.isContinuous = true // ✅ 슬라이더를 특정 값에서 멈추도록 설정
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        alert.view.addSubview(slider)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.review.rating = Double(round(slider.value))
            
            self.reloadData(for: self.review)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    // MARK: - Action
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    // ✅ 슬라이더 값 변경 시 1 단위로 반올림
    @objc private func sliderValueChanged(_ sender: UISlider) {
        sender.value = round(sender.value) // ✅ 1 단위로 값 조정
    }
}


// MARK: - Extension
extension ReviewViewController: ReviewPhotoCellDelegate {
    func didTapSelectedImages() {
        didTapAddPhotoButotn()
    }
}



extension ReviewViewController: ReviewContentCellDelegate {
    func didUpdateContent(_ text: String) {
        if text != "" {    // ✅ 빈 값은 저장하지 않음
            self.review.content = text
        } else {
            self.review.content = ""   // ✅ 안내문구를 저장하지 않도록 빈 값 처리
        }
        viewModel.reviewContent = review.content
        self.reloadData(for: self.review)
    }
}


extension ReviewViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var tempSelectedImages: [UIImage] = [] // 임시 저장
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    tempSelectedImages.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            //self.review.photos = Array(self.selectedImages.keys) // ✅ 경로만 저장
            //self.review.photos = self.viewModel.uploadedPhotoURLs
            self.viewModel.selectedImages = tempSelectedImages
            print("✅ 선택된 이미지 경로: \(self.review.photos)")
            self.reloadData(for: self.review)
        }
    }
    
}


extension ReviewViewController: ReviewOptionCellDelegate {
    func didTapOption(_ type: ReviewOptionType) {
        switch type {
        case .date:
            showDatePicker()
        case .rating:
            showRatingPicker()
        }
    }
}
