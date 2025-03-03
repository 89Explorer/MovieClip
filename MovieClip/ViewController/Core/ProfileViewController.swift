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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
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
                cell.delegate = self
                
                return cell
                
            default:
                return self.configure(ProfileCell.self, with: item, for: indexPath)
                
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
    }
    
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileItem>()
        
        // ✅ 프로필 섹션 추가
        snapshot.appendSections([.profile])
        let currentUser = viewModel.user
        snapshot.appendItems([.profile(currentUser)], toSection: .profile)
        
        // ✅ 평점 준 작품,
        snapshot.appendSections([.ratedMovies])
        let ratedMovies = [WorkOfMedia(id: 0, backdropPath: "", posterPath: "", releaseDate: "", voteAverage: 0, overview: "", name: "", title: "", firstAirDate: "")]
        snapshot.appendItems([.ratedMovies(ratedMovies)], toSection: .ratedMovies)
        
        // ✅ 리뷰 작성
        snapshot.appendSections([.myReviews])
        let reviews = [Review(id: 0)]
        snapshot.appendItems([.review(reviews)], toSection: .myReviews)
        
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
            default:
                return self.createFeaturedSection(using: .profile)
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
}


// MARK: - Extension: ProfileCellDelegate 구현
extension ProfileViewController: ProfileCellDelegate {
    func didTapEditButton() {
        navigateToProfileEdit()
    }
}
