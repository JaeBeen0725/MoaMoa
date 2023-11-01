# 모아모아

> 모아모아는 통합형 링크 관리 앱입니다.

## 목차
[1.개발 기간](#개발-기간)

[2.개발 환경](#개발-환경)

[3.주요 기능](#주요-기능)

[4.기술스택](#기술스택)

[5.트러블슈팅](#트러블슈팅)

[6.추후 업데이트할 내용](#추후-업데이트할-내용)
***
## 개발 기간
> 23.09.23 ~ 23.10.19

## 개발 환경
> Xcode 15.0.0


## 주요 기능
### 썸네일 및 제목 자동 생성 기능
![링크 추가 001](https://github.com/JaeBeen0725/MoaMoa/assets/105216574/efa08160-d750-40dd-948a-ba55431d5755)

### 링크 검색 기능
![링크 검색 002](https://github.com/JaeBeen0725/MoaMoa/assets/105216574/10966b3a-5847-4cd5-9731-9d83cd0be713)

### 링크 관리 기능
![링크관리 003](https://github.com/JaeBeen0725/MoaMoa/assets/105216574/04caf90c-70d0-44da-ae20-c8ffcc18ffe1)

***

## 기술스택
 - **UIKit** : **CodeBase**로 사용자 인터페이스를 구현하고 이벤트를 관리했습니다.
 - **UIContextMenuConfiguration**, **WebView** : LongPress방식을 채택하여 링크에 대한 다양한 편의 기능들을 구현했습니다.
 - **LinkPresentation** : 사용자에게 어떤 내용이 포함된 링크인지 쉽게 알 수 있도록 프리뷰를 제공했습니다.
 - **Realm** : 링크에 대한 데이터 및 카테고리 데이터 관리를 구현했습니다.
 - **FileManager** : Link Metadata로 가져온 이미지 파일을 Documents에 저장 및 삭제를 구현했습니다.
 - SafariServices, IQKeyboardManagerSwift, SnapKit, Toast
 - MVVM

## 트러블슈팅
### 이슈
카테고리 및 링크에 대한 DB를 CRUD 하기 위해선 한 개의 Table로는 비효율적 이였습니다.
### 해결방안
카테고리와 링크들에 대한 데이터를 효율적으로 관리하기 위해서 기존 한 개였던 Table을 두개로 늘린 후 Realm List를 채택하여 해당 이슈를 해결했습니다.

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


## 추후 업데이트할 내용
- 카테고리탭 UX 개선
- MVVM 디자인 패턴으로 리팩토링
- Share Extention을 활용하여 외부 플랫폼에서 공유하기 버튼을 누를 시 바로 모아모아 앱으로 저장하기 기능 구현
- 이미지도 저장할 수 있는 기능 구현 및 Pinterest Layout 구현
