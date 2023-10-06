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
    
    @Persisted var fk: ObjectId
    @Persisted var link: String
    @Persisted var title: String
    @Persisted var memo: String
    @Persisted var likeLink: Bool
    @Persisted var onlyAll: Bool
    
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<CateGoryRealm>
    
    convenience init(link: String, title: String, memo: String, likeLink: Bool, onlyAll: Bool) {
        self.init()
        
        self.fk = _id
        self.link = link
        self.title = title
        self.memo = memo
        self.likeLink = likeLink
        self.onlyAll = onlyAll
        
    }
    
    
}
