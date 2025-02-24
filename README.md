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
- Google 번역 API를 적용하여 한국어 지원 기능 추가

<br />
<br />

## 🛠 개발 기간
- 개발 기간: 3주
- 개발 인원: 1인

<br />
<br />

## 👏🏻 회고







