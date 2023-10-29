//
//  RealmManager.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/26.


import Foundation
import RealmSwift

protocol CateGoryTableRepositoryType: AnyObject {
    
    func fetchCategory() -> Results<CateGoryRealm>
    func fetchDetailCategory() -> Results<detailCateGory>
    func fetchCategoryFilter(pk: ObjectId) -> Results<CateGoryRealm>
    func fetchDetailCategoryFilter(fk: ObjectId) -> Results<detailCateGory>
//    func createCategoryItem(_ item: CateGoryRealm)
//    func createDetailCategoryItem(_ item: detailCateGory)
}

class CateGoryTableRepositary: CateGoryTableRepositoryType {
    
    private let realm = try! Realm()
    
    
    func fetchCategory() -> Results<CateGoryRealm> {
        let categoryData = realm.objects(CateGoryRealm.self)
        return categoryData
    }
    
    func fetchDetailCategory() -> Results<detailCateGory> {
        let detailCategoryData = realm.objects(detailCateGory.self)
        return detailCategoryData
    }
    
    func fetchCategoryFilter(pk: ObjectId) -> Results<CateGoryRealm> {
        let result = realm.objects(CateGoryRealm.self).where {
            $0._id == pk
        }
        return result
    }
    
    func fetchDetailCategoryFilter(fk: ObjectId) -> Results<detailCateGory> {
        let result = realm.objects(detailCateGory.self).where {
            $0._id == fk
        }
        return result
    }
    
//    func createCategoryItem(_ item: CateGoryRealm) {
//        <#code#>
//    }
//    
//    func createDetailCategoryItem(_ item: detailCateGory) {
//        <#code#>
//    }
    
    
   

  
    
 
    
  
    
  
    

    
    
    
}
