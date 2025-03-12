# MovieClip
<img src = "https://github.com/user-attachments/assets/67893559-0354-4daa-ba7a-168d485b4163" width="200" height="200"/>

<br />
<br />
<br />

## 📌 앱 소개 
- MovieClip 은 TMDB API를 활용하여 최신 영화, TV 프로그램, 배우 정보를 검색하고 관리할 수 있는 iOS 애플리케이션입니다.
- async/await 을 사용하여 보다 직관적이고 유지보수하기 쉬운 코드로 작성했습니다.
- UICollectionViewDiffableDataSource 와 CompositionalLayout 을 활용하여 동적인 UI를 구성했습니다.
- 검색 기능에서는 MVVM, Combine 을 적용하여 다양한 비동기 처리 함수로 부터 데이터 처리 흐름을 유연하게 할 수 있도록 구현하였습니다. 
- Google API 를 활용하여 영화, 티비 프로그램, 인물 관련 개요 부분에 대해 번역 기능을 제공하고 있습니다.
  <추가>
- Firebase를 통한 회원관리 서비스를 제공하고 있습니다.
- Firebase 내의 Storage, Database에 리뷰 이미지와 리뷰 작성, 업로드, 수정, 삭제 서비스 제공하고 있습니다. 

<br />
<br />

## ✨ 주요 기능
- TMDB 에서 제공하는 API를 통해 영화, 티피 프로그램, 인물 정보를 제공합니다.
- 영화 및 티비 프로그램에 대한 상세 정보(개요, 예고편, 포스터), 해당 프로그램과 유사한 작품 목록을 제공합니다.
- 인물에 대한 상세 정보(이름, 출생일, 개요, 소셜미디어, 출연작품)을 제공합니다.
- ~~프로그램 및 인물 소개 등 TMDB에서 제공하지 않는 "한국어" 서비스 경우, Google API를 통해 번역을 했습니다.~~
- Firebase를 통해 회원관리 서비스를 제공하고 있습니다.
- Firebase내의 Storage, Database 를 통해 리뷰 이미지, 텍스트 관리 서비스 제공합니다. 

<br />
<br />

## 📸 스크린샷
<img src = "https://github.com/user-attachments/assets/dfaf24fa-0856-433e-ab6b-4397eba29277" height="400"/>
<img src = "https://github.com/user-attachments/assets/8906b69c-76e1-4711-98c6-e293ebd1e685" height="400"/>
<img src = "https://github.com/user-attachments/assets/14cb9ae9-b0c5-4f0c-a85d-7bb8617f5b13" height="400"/>
<img src = "https://github.com/user-attachments/assets/6cb40d88-6f96-4203-85b5-d4a6f87da147" height="400"/>

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

|회원가입-프로필작성|로그인-회원탈퇴|리뷰 작성|리뷰 관리|
|:---:|:----:|:----:|:----:|
|<img src = "https://github.com/user-attachments/assets/f7fe8437-f0ef-43d8-9c26-09cbd0833c8e" height="400"/>|<img src = "https://github.com/user-attachments/assets/51f36038-404c-4f88-8ce7-13ad738bbf7c" height="400"/>|<img src = "https://github.com/user-attachments/assets/aa18d805-133b-4250-b7dc-55a6e8efc440" height="400"/>|<img src = "https://github.com/user-attachments/assets/60fcb6b8-9960-4989-b55a-fbd71b6d91ff" height="400"/>|



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
   - 데이터 스냅샷을 기반으로 변경 사항을 자동으로 반영하여, 수동 UI 업데이트를 최소화하고 성능을 최적화합니다.
- UICollectionViewCompositionalLayout을 통한 유연한 UI 레이아웃 구성
   - 각 섹션별로 독립적인 레이아웃 설계가 가능하여, 다양한 디자인 요구사항을 손쉽게 구현할 수 있습니다.
- Combine을 적용하여 실시간 검색 기능 구현
   - 여러 개의 비동기 API(TMDB, Google, 장르 반환) 호출을 효율적으로 처리  
   - API 요청 ➡️ 번역 ➡️ 데이터 변환 ➡️ UI 업데이트 순으로 체계적인 데이터 흐름 구축
   - async / await을 사용할 경우 : 모든 데이터가 준비된 후 한 번에 UI 업데이트 진행 ➡️ 데이터 로딩이 오래 걸릴 수 있음
   - Combine 을 사용한 경우: 먼저 받아온 데이터부터 즉시 UI 반영 가능
      > 예를 들어 영화 / TV / 인물 데이터 중 "영화" 데이터가 먼저 받아지면, 그 즉시 화면에 표시 이후 받아오는 순서대로 표시 
   - 검색 결과를 더 빠르고 자연스럽게 보여줄 수 있어 사용자 경험(UX) 향상  
- ~~Google 번역 API를 적용하여 한국어 지원 기능 추가~~
   - ~~TMDB에서 기본 언어는 한국어로 설정할 수 있지만, 특정 정본는 한국어 제공이 되지 않습니다.~~
   - ~~Google 번역 API를 통해 영어 ➡️ 한국어로 번역합니다.~~
   - 비용 발생으로 API 정지
 
<추가>
- Firebase를 통한 회원관리 서비스 제공합니다.
   - 이메일, 비밀번호를 통해 회원가입을 하고, 로그인, 로그아웃, 회원탈퇴 및 프로필을 작성하여 Firebase에서 관리할 수 있도록 합니다.
- Firebase 내의 파일 관리 서비스를 제공합니다.

<br />
<br />

## ❌ 문제 해결 
1. 검색 결과의 상세페이지 이동이 안됨...
- 원인: SearchResultViewController는 UISearchController의 searchResultsController로 설정되어 있어서 네비게이션 스택에 포함되지 않음!
- 해결: 기존 네비게이션 흐름을 유지할 목적으로 다음 코드를 사용
  ```
  presentingViewController?.navigationController?.pushViewController(detailVC, animated: true)
  ```
- 주소: https://explorer89.tistory.com/359

<br />

2.  UICollectionViewDiffableDataSource.. 데이터 중복으로 인한 데이터 누락...
- 원인: UICollectionViewDiffableDataSource에서 중복된 item identifier가 추가되었기 때문에 발생한 오류
- 해결: 기존 구조체에서 sectionType을 포함한 별도의 구조체를 생성하여, 동일한 id라도 sectionType이 다르기 때문에 중복으로 인한 데이터 누락이 방지됨
- 주소: https://explorer89.tistory.com/343

<br />

3. 이 외의 프로젝트 기록한 내용은 아래 주소에 있습니다.
- 주소: https://explorer89.tistory.com/category/Project/MovieClip

<br />
<br />

## 🛠 개발 기간
- 개발 기간: 8주
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
또한 검색 기능을 구현할 때는 MVVM + Combine을 활용하여 비동기적으로 처리해야하는 작업(검색 API, 번역 API 등)으로부터 데이터를 가져와 유연하게 UI 업데이트를 처리했습니다. 


기존 Completion Handler 방식:
```swift
func fetchMovies(completion: @escaping ([Movie]) -> Void) {
    let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY")!
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion([])
            return
        }
        let movies = try? JSONDecoder().decode(MovieResponse.self, from: data).results
        completion(movies ?? [])
    }.resume()
}
```

async/await 적용 후:
```swift
func fetchMovies() async throws -> [Movie] {
    let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let movies = try JSONDecoder().decode(MovieResponse.self, from: data).results
    return movies
}
```

🌟 async / await 을 적용하면  { } 가 줄어들어서 코드가 간결해보이고, 가독성이 좋아지는 것 같다. 


이번 프로젝트를 통해 iOS 개발 트렌드을 적용하여 학습할 수 있었고, CompositionalLayout, DiffableDataSource, async/await, Combine 에 대해 좀 더 알게 된 프로젝트이었습니다.
추후 진행 사항에 나온 대로 업데이트할 예정입니다.

<br />
<br />

<추가>
리뷰의 CRUD 기능을 구현하면서 MVVM 패턴과 Combine을 활용한 데이터 흐름 관리의 중요성을 알게 되었습니다. 특히 Firebase를 활용하면서 데이터를 저장하고 불러오는 과정에서 시점 관리의 필요성을 체감했습니다. 

예를 들어, 리뷰를 저장할 때 String, Int 같은 데이터는 바로 저장할 수 있지만, UIImage(사진 데이터)는 바로 저장할 수 없어서 먼저 Firebase Storage에 업로드한 후, 다운로드 URL을 받아 Firestore에 저장해야 했습니다. 이 과정에서 비동기 작업의 순서를 올바르게 설정하지 않으면, URL이 저장되기 전에 Firestore에 기록되어 이미지가 누락되는 문제가 발생할 수 있었습니다. 
이를 해결하고자 flatMap을 활용하여 이미지를 업로드 후 , 이미지의 URL 주소를 반환하여 String 타입으로 Database에 저장했습니다. 

다시 한 번 MVVM 패턴을 사용하면서 ViewController에서 직접 API 호출을 하지 않고, ViewModel을 통해 데이터를 처리하도록 설계하면서 코드의 의존성이 줄어들고 유지보수가 용이했습니다. 이번 프로젝트를 통해 Firebase, MVVM, Combine을 실제로 적용하며 데이터 흐름과 시점 관리의 중요성을 같이 이해할 수 있었습니다. 



### 🔨 추후 진행 사항

1. 회원 가입
   - 소셜 미디어 회원가입 (구글, 카카오, 애플)
   - ~~로그인, 로그아웃, 회원 탈퇴~~ 
   - ~~회원 정보 입력 (프로필 이미지, 닉네임, 소개)~~

2. 즐겨찾기, 평점 부여

3. ~~리뷰 작성~~

4. 리뷰 불러오기 (예: 네이버 영화 리뷰)










