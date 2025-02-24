# MovieClip
<img src = "https://github.com/user-attachments/assets/67893559-0354-4daa-ba7a-168d485b4163" width="200" height="200"/>

<br />
<br />
<br />

## 📌 앱 소개 
- $\huge{\rm{\color{green}MovieClip}}$ 은 TMDB API를 활용하여 최신 영화, TV 프로그램, 배우 정보를 검색하고 관리할 수 있는 iOS 애플리케이션입니다.
- $\huge{\rm{\color{green}async/await}}$ 을 사용하여 보다 직관적이고 유지보수하기 쉬운 코드로 작성했습니다.
- $\huge{\rm{\color{green}UICollectionViewDiffableDataSource}}$ 와 $\huge{\rm{\color{green}CompositionalLayout}}$ 을 활용하여 동적인 UI를 구성했습니다.
- 검색 기능에서는 $\huge{\rm{\color{green}MVVM}}$, $\huge{\rm{\color{green}Combine}}$ 을 적용하여 실시간 검색을 구현하였습니다. 
- $\huge{\rm{\color{green}Google API}}$ 를 활용하여 영화, 티비 프로그램, 인물 관련 개요 부분에 대해 번역 기능을 제공하고 있습니다.

<br />
<br />

## ✨ 주요 기능
- TMDB 에서 제공하는 API를 통해 영화, 티피 프로그램, 인물 정보를 제공합니다.
- 영화 및 티비 프로그램에 대한 상세 정보(개요, 예고편, 포스터), 해당 프로그램과 유사한 작품 목록을 제공합니다.
- 인물에 대한 상세 정보(이름, 출생일, 개요, 소셜미디어, 출연작품)을 제공합니다.
- 프로그램 및 인물 소개 등 TMDB에서 제공하지 않는 "한국어" 서비스 경우, Google API를 통해 번역을 했습니다.

<br />
<br />

## 📸 스크린샷
<img src = "https://github.com/user-attachments/assets/dfaf24fa-0856-433e-ab6b-4397eba29277" height="400"/>
<img src = "https://github.com/user-attachments/assets/8906b69c-76e1-4711-98c6-e293ebd1e685" height="400"/>

<br />
<br />

## 🎥 시연 영상

|홈 화면|영화 화면|티비 화면|검색 화면|
|:---:|:---:|:---:|:---:|
|<img src = "https://github.com/user-attachments/assets/b14c4088-e2a7-4742-bdf0-24684f886b62" height="400"/>|<img src = "https://github.com/user-attachments/assets/71a17d68-d959-47c7-b9a1-fb2689bce852" height="400"/>|<img src = "https://github.com/user-attachments/assets/8ebc8160-baee-4794-8615-5bd9e7a7821e" height="400"/>|<img src = "https://github.com/user-attachments/assets/4c602be0-407a-457a-8986-71013e636da2" height="400"/>|

<br/>

|상세페이지-영화|상세페이지-인물|상세페이지-검색화면|
|:---:|:---:|:---:|
|<img src = "https://github.com/user-attachments/assets/68fad0bd-f511-4d82-90e2-83246c934cb7" height="400"/>|<img src = "https://github.com/user-attachments/assets/cd593d2a-27a5-49b6-9b21-1b8cd529359b" height="400"/>|<img src = "https://github.com/user-attachments/assets/8146f333-c45f-4586-96b2-e662c8447a04" height="400"/>|

<br />
<br />

## 🔧 앱 개발 환경
- 개발 언어: Swift
- 개발 도구: Xcode
- 네트워킹: async/await 활용한 API 호출
- UI 구성: UICollectionViewDiffableDataSource 및 CompositionalLayout 적용
- 검색 기능: MVVM + Combine 적용

<br />
<br />

## ⚙️ 구현 고려사항
- TMDB에서 제공하는 API 호출 함수 및 데이터 모델 준수
- UICollectionViewDiffableDataSource을 활용한 데이터 관리
  > 데이터 스냅샷을 기반으로 변경 사항을 자동으로 반영하여, 수동 UI 업데이트를 최소화하고 성능을 최적화합니다.
- UICollectionViewCompositionalLayout을 통한 유연한 UI 레이아웃 구성
  > 각 섹션별로 독립적인 레이아웃 설계가 가능하여, 다양한 디자인 요구사항을 손쉽게 구현할 수 있습니다.
- Combine을 적용하여 실시간 검색 기능 구현
  > 검색 결과를 섹션 별(영화, 티비 프로그램, 인물) 보여줍니다.
  > 검색 결과는 1페이지에 20개 이며, 검색 결과가 1페이지에 20개 보다 적을 경우는 "더보기" 버튼이 활성화되지 않습니다.
  > 검색 결과 섹션에 검색 결과가 없을 경우, "더보기" 버튼이 활성화되지 않습니다. 
- Google 번역 API를 적용하여 한국어 지원 기능 추가
  > TMDB에서 기본 언어는 한국어로 설정할 수 있지만, 특정 정본는 한국어 제공이 되지 않습니다.
  > Google 번역 API를 통해 영어 ➡️ 한국어로 번역합니다.

<br />
<br />

## 🛠 개발 기간
- 개발 기간: 3주
- 개발 인원: 1인

<br />
<br />

## 👏🏻 회고
이 전에 NetFlix 앱을 클론 코딩하면서 UI 구성을 UITableView 와 UICollectionView 을 활용했습니다. 
UITableView 내부에 UICollectionView 을 삽입하여 행 마다 가로 스크롤 셀을 구현했었고, 
검색 결과를 UICollectionView 을 통해 3열로 poster 이미지만 보여주는 구성으로 만들었습니다. 


이번 MovieClip 앱에서는 UICollectionViewCompositionalLayout 을 활용하여 각 섹션별로 독립적인 레이아웃을 설정했습니다.
이를 통해 복잡한 UI도 훨씬 유연하고 코드의 가독성이 좋게 구성할 수 있었습니다. 특히 가로, 세로 스크르롤을 조합하여 다양한 레이아웃을 적용할 수 있다는 점이 이 전 방식과 비교했을 때 복잡한 UI를 직관적으로 구성할 수 있어 인상적이었습니다. 


예를 들어, 기존 UICollectionViewCompositionalLayout 을 사용했다면 다음과 같이 레이아웃을 설정했다고 한다면?
```swift
let layout = UICollectionViewFlowLayout()
layout.scrollDirection = .horizontal
layout.itemSize = CGSize(width: 120, height: 180)
layout.minimumLineSpacing = 10
collectionView.collectionViewLayout = layout
```


이번 프로젝트에서는 UICollectionViewCompositionalLayout 을 활용하여 더 유연하게 섹션별 레이아웃을 구성할 수 있었습니다.
```swift
let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
let item = NSCollectionLayoutItem(layoutSize: itemSize)

let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

let section = NSCollectionLayoutSection(group: group)
section.orthogonalScrollingBehavior = .continuous

let layout = UICollectionViewCompositionalLayout(section: section)
collectionView.setCollectionViewLayout(layout, animated: true)
```


또한 데이터를 처리하는 방식에서도 이전 NetFlix 앱을 클론 코딩했을 때와 변화가 있습니다. 
기존에는 UICollectionView의 reloadData()를 호출하여 UI를 갱신했지만, 이번 프로젝트에서는 UICollectionViewDiffableDataSource 를 적용하여 데이터 변경 사항을 자동으로 반영했습니다. 
이번 프로젝트에서는 스냅샷(Snapshot) 기반의 데이터 업데이트를 사용하여 개별적인 셀을 추가 / 삭제할 때도 
전체 UI를 다시 그릴 필요 없이 변경된 데이터만 업데이트 할 수 있도록했습니다.



기존의 reloadData() 방식은 다음과 같습니다. 
```swift
var movies: [Movie] = []

func fetchMovies() {
    MovieAPI.getTrendingMovies { [weak self] newMovies in
        self?.movies = newMovies
        DispatchQueue.main.async {
            self?.collectionView.reloadData()
        }
    }
}
```


DiffableDataSource을 활용한 방식은 다음과 같습니다. 
```swift
enum Section {
    case main
}

private var dataSource: UICollectionViewDiffableDataSource<TvTMDBData, TvResultItem>?

private func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<TvTMDBData, TvResultItem>(collectionView: seriesCollectionView) { collectionView, indexPath, item in
        
        let tvTMDBResult = item.tvResult
        let sectionType = self.tvCombineSection.combineTMDB[indexPath.section].type ?? .popular
        
        switch sectionType {
        case .airingToday:
            return self.configure(TvFeaturedCell.self, with: tvTMDBResult, for: indexPath)
        case .onTheAir:
            return self.configure(TVMediumCell.self, with: tvTMDBResult, for: indexPath)
        case .popular:
            return self.configure(TvFeaturedCell.self, with: tvTMDBResult, for: indexPath)
        case .topRated:
            return self.configure(TVSmallCell.self, with: tvTMDBResult, for: indexPath)
        }
    }
    ...
}

private func reloadData() {
    var snapshot = NSDiffableDataSourceSnapshot<TvTMDBData, TvResultItem>()
    snapshot.appendSections(tvCombineSection.combineTMDB)
    for tmdbData in tvCombineSection.combineTMDB {
        let items = tmdbData.results.map {
            TvResultItem(tvResult: $0, sectionType: tmdbData.type ?? .popular)
        }
        snapshot.appendItems(items, toSection: tmdbData)
    }
    dataSource?.apply(snapshot, animatingDifferences: true)
}

private func fetchTvs() {
    Task {
        do {
            ...
            DispatchQueue.main.async {
                self.tvCombineSection = tvs
                self.reloadData()
            }
        } catch {
            print("❌ Error: \(error)")
        }
    }
}
```


네트워크 요청에서도 이전 NetFlix 앱과 다른 점이 있습니다. 이 전에는 Completion Handler 방식을 사용하여 API를 를 요청했지만,
이번에는 async / await 으로 구현하여 코드 가독성이 좋아졌습니다. 
또한 MVVM + Combine 을 활용하여 검색 기능을 구현하여, 비동기 데이터 흐름을 보다 직관적으로 관리할 수 있었습니다. 












