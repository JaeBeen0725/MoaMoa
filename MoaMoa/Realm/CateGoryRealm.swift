//
//  CateGoryRealm.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/01.
//

import Foundation
import RealmSwift

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
    
    @Persisted var link: String
    @Persisted var title: String
    @Persisted var memo: String
    @Persisted var likeLink: Bool
    @Persisted var AllCategory: String
    @Persisted var pk: String
    
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<CateGoryRealm>
    
    convenience init( link: String, title: String, memo: String, likeLink: Bool, pk: String, AllCategory: String) {
        self.init()
        
        self.link = link
        self.title = title
        self.memo = memo
        self.likeLink = likeLink
        self.pk = pk
        self.AllCategory = AllCategory
    }
    
    
}
