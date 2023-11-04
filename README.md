# 모아모아

> 모아모아는 LinkPresentation 기반 링크 관리 앱 입니다.

## 목차
[1.개발 기간](#개발-기간)

[2.개발 환경](#개발-환경)

[3.주요 기능](#주요-기능)

[4.기술스택](#기술스택)

[5.트러블슈팅](#트러블슈팅)

[6.회고](#회고)

[7.추후 업데이트할 내용](#추후-업데이트할-내용)
***
## 개발 기간
> 23.09.23 ~ 23.10.19

## 개발 환경
> Xcode 15.0.0

## 스크린샷

<img width="1013" alt="스크린샷 2023-11-02 오후 5 06 22" src="https://github.com/JaeBeen0725/MoaMoa/assets/105216574/e1e9b920-41e3-478f-b206-91c0669727a4">

## 주요 기능
- 링크별 썸네일 및 제목 자동 생성 기능

- 저장된 링크 검색 기능

- ContextMenu 및 카테고리로 링크 관리

***

## 기술스택
 - **UIKit** : **CodeBase** 기반으로 사용자 인터페이스 구현 및 이벤트 관리
 - **UIContextMenuConfiguration**, **WKWebView** : LongPress방식을 채택하여 링크에 대한 다양한 편의 기능 구현
 - **LinkPresentation** : 저장된 링크를 빠르게 식별할 수 있는 프리뷰 기능 구현
 - **Realm** : 링크 및 카테고리 데이터를 로컬에 저장 및 관리
 - **FileManager** : Link Metadata로 가져온 이미지 파일을 Documents에 저장 및 삭제 기능 구현
 - SafariServices, IQKeyboardManagerSwift, SnapKit, Toast
 - MVVM

## 트러블슈팅
- LpLinkMetaData에 대한 RealmModel Object와 카테고리간의 관계를 고려한 CRUD 작업 시 이슈
→ 카테고리 RealmModel object 추가 생성 및 두 RealModel간의 To-Many Relationship을 고려하여 CRUD 작업 

~~~
class CateGoryRealm: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var detail: List<detailCateGory>
    
    convenience init( title: String) {
        self.init()
        self.title = title
    }
}

class detailCateGory: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var fk: ObjectId
    @Persisted var link: String
    @Persisted var title: String
    @Persisted var searchTitle: String
    @Persisted var memo: String
    @Persisted var likeLink: Bool
    @Persisted var onlyAll: Bool
    
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<CateGoryRealm>
    
    convenience init(link: String, title: String, searchTitle: String ,memo: String, likeLink: Bool, onlyAll: Bool) {
        self.init()
        
        self.fk = _id
        self.link = link
        self.title = title
        self.searchTitle = searchTitle
        self.memo = memo
        self.likeLink = likeLink
        self.onlyAll = onlyAll
        
    }
}
~~~

- 네트워크 통신이 불안정한 상황에서 LinkPresentation 비작동으로 인한 image 출력 이슈
-> FileManager Class를 채택하여 image파일을 지정된 폴더에서 관리

~~~
    func saveIamgeToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch let  error {
            print("file save error", error)
        }
    }
~~~

- CRUD후 모든 CollectionView 객체에게 delegate를 통한 비효율적인 data전달 이슈
-> NotificationCenter를 채택하여 식별된 Observer를 통한 reloadData

~~~
...
NotificationCenter.default.addObserver(self, selector: #selector(collectionViewReloadData), name: NSNotification.Name("reloadData") ,object: nil)
    }
    @objc func collectionViewReloadData() {
        homeCollectionView.reloadData()
    }
...
~~~

~~~
...
NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
...
~~~
## 회고
### Good
- 1인 개발로 진행한 덕분에 기획부터 개발, 디자인 그리고 출시까지 모든 progress를 경험함
- FileManager를 활용하여 예외적인 상황에서도 이미지 출력 가능
- Realm List 활용 하여 데이터를 체계적으로 관리함
- search에 lowercased를 채택하여 서비스적으로 고려함

### Bad
- 공수 산정의 어려움으로 인한 잦은 계획 수정
- 부족한 기획으로 인한 생산성 저하

## 추후 업데이트할 내용
- 카테고리탭 UX 개선
- MVVM 디자인 패턴으로 리팩토링
- Share Extention을 활용하여 외부 플랫폼에서 공유하기 버튼을 누를 시 바로 모아모아 앱으로 저장하기 기능 구현
- 이미지도 저장할 수 있는 기능 구현 및 Pinterest Layout 구현
