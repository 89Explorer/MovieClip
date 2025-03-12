//
//  ProfileViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/28/25.
//

import UIKit
import Combine
import FirebaseAuth

class ProfileViewController: UIViewController, ProfileDataFormViewControllerDelegate {
    
    
    // MARK: - Variable
    private var dataSource: UICollectionViewDiffableDataSource<ProfileSection, ProfileItem>!
    private var viewModel = ProfileViewModel()
    private var cancelable: Set<AnyCancellable> = []
    
    
    // MARK: - UI Component
    private var profileCollectionView: UICollectionView!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
               
        configureNavigationBarAppearance()
        configureNavigationLeftTitle()
        setupCollectionView()
        createDataSource()

        setupBindings()  // ✅ 사용자 정보 변경 시 자동으로 UI 업데이트
        
        // 로그아웃 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(didTapSetting))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        profileCollectionView.delegate = self
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserReviews()
        DispatchQueue.main.async {
            self.profileCollectionView.reloadData()
        }
    }
    
    
    // MARK: - Function
    private func setupCollectionView() {
        profileCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        profileCollectionView.backgroundColor = .black
        profileCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(profileCollectionView)
        
        profileCollectionView.register(ProfileSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileSectionHeader.reuseIdentifier)
        profileCollectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        profileCollectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.reuseIdentifier)
        
    }
    
    private func configure<T: SelfConfiguringProfileCell>(_ cellType: T.Type, with model: ProfileItem, for indexPath: IndexPath) -> T {
        guard let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else { fatalError("Unable to deque \(cellType)")}
        cell.configure(with: model)
        return cell
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ProfileSection, ProfileItem>(collectionView: profileCollectionView) { collectionView, indexPath, item in
            let section: ProfileSection = ProfileSection.allCases[indexPath.section]
            
            switch section {
            case .profile:
                
                let cell = self.configure(ProfileCell.self, with: item, for: indexPath)
                
                // ✅ ProfileCell 델리게이트 대리자 할당
                cell.delegate = self
                
                return cell
            case .review:
                let cell = self.configure(ReviewCell.self, with: item, for: indexPath)
                return cell
            }
        }
        
        // ✅ 섹션 헤더 추가
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileSectionHeader.reuseIdentifier, for: indexPath) as? ProfileSectionHeader else { return nil }
            
            let sectionTitle = ProfileSection.allCases[indexPath.section].rawValue
            sectionHeader.configure(with: sectionTitle) // ✅ 헤더에 타이틀 전달
            
            return sectionHeader
        }
    }
    
    // ✅ ViewModel의 데이터가 변경될 때 자동으로 UI 업데이트하는 바인딩 설정
    private func setupBindings() {
        viewModel.$user
            .sink { [weak self] _ in
                self?.reloadData()  // ✅ user가 변경될 때 자동으로 데이터 업데이트
            }
            .store(in: &cancelable)
        
        viewModel.$reviews
            .sink { [weak self] item in
                print("리뷰 아이템: \(self?.viewModel.reviews.count)")
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
            .store(in: &cancelable)
        
        viewModel.fetchUserReviews()
    }
    
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileItem>()
        
        // ✅ 프로필 섹션 추가
        snapshot.appendSections([.profile])
        let currentUser = viewModel.user
        snapshot.appendItems([.profile(currentUser)], toSection: .profile)
        
        // ✅ 평점 준 작품,
//        snapshot.appendSections([.ratedMovies])
//        let ratedMovies = [WorkOfMedia(id: 0, backdropPath: "", posterPath: "", releaseDate: "", voteAverage: 0, overview: "", name: "", title: "", firstAirDate: "")]
//        snapshot.appendItems([.ratedMovies(ratedMovies)], toSection: .ratedMovies)
        
        // ✅ 리뷰 작성
        snapshot.appendSections([.review])
        let reviews = viewModel.reviews.map { ProfileItem.review($0) }
        snapshot.appendItems(reviews, toSection: .review)
        print("📸 리뷰 섹션에 추가되는 아이템 개수: \(reviews.count)")
        // ✅ dataSource가 nil이 아닐때만 업데이트 적용
        guard dataSource != nil else { return }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, layoutEnvironment in
            let section = ProfileSection.allCases[sectionIndex]
            
            switch section {
            case .profile:
                return self.createFeaturedSection(using: .profile)
            case .review:
                return self.createReviewSection(using: .review)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
        
    }
    
    
    private func createFeaturedSection(using section: ProfileSection) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        // 섹션 헤더 설정
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    private func createReviewSection(using section: ProfileSection) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem, layoutItem, layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
        
    }
    
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(40))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    
    private func configureNavigationLeftTitle() {
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "My Clip"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        
        let leftBarButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftBarButton
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
    }
    
    
    // ✅ 프로필 수정 화면으로 이동
    func navigateToProfileEdit() {
        let editVC = ProfileDataFormViewController(user: viewModel.user, isInitialProfileSetup: false)
        editVC.delegate = self // ✅ Delegate 설정
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    // ✅ ProfileDataFormViewController에서 수정 완료 후 호출됨
    func didUpdateUser(_ updatedUser: MovieClipUser) {
        viewModel.user = updatedUser  // ✅ ViewModel 업데이트
        reloadData()  // ✅ UI 업데이트
        
        // ✅ Firebase에서 최신 데이터 다시 불러오기 (Optional)
        viewModel.retreiveUser()
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            
            // ✅ 기존의 모든 화면을 닫고, OnboardingViewController로 이동
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                }
            })
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    /// 회원탈퇴
    private func deleteUser() {
        viewModel.deleteUser()
        
        viewModel.$isUserDeleted
            .sink { isDeleted in
                if isDeleted {
                    print("회원 탈퇴")
                    DispatchQueue.main.async {
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                            }
                        })
                    }
                }
            }
            .store(in: &cancelable)
    }
    
    
    // MARK: - Action
    @objc private func didTapSignOut() {
        do {
            try Auth.auth().signOut()
            
            // ✅ 기존의 모든 화면을 닫고, OnboardingViewController로 이동
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                }
            })
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    
    @objc private func didTapSetting() {
        
        let actionSheet = UIAlertController(title: "설정", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { _ in
            print("로그아웃")
            self.signOut()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "회원탈퇴", style: .default, handler: { _ in
            print("회원탈퇴")
            self.deleteUser()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        
        present(actionSheet, animated: true)
    }
}


// MARK: - Extension: ProfileCellDelegate 구현
extension ProfileViewController: ProfileCellDelegate {
    func didTapEditButton() {
        navigateToProfileEdit()
    }
}


extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = ProfileSection.allCases[indexPath.section]
        
        switch section {
        case .profile:
            print("프로필 섹션 눌림")
            return
        case .review:
            let selectedReview = viewModel.reviews[indexPath.item]
            navigateToReviewDetail(with: selectedReview)
        }
    }
    
    
    private func navigateToReviewDetail(with review: ReviewItem) {
        let detailVC = ReviewDetailViewController(review: review)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


