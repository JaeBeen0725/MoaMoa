//
//  AddToAnotherCategoryViewController.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/06.
//

import UIKit
import RealmSwift

class AddToAnotherCategoryViewController: CategoryViewController {
    
    var result : Results<detailCateGory>!
    var fk: ObjectId
    
    init(fk: ObjectId) {
        self.fk = fk
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count - 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {return UICollectionViewCell()}
        
        let data = list[indexPath.row + 2]
        cell.categoryTitle.text = data.title
 
        return cell
      
    }
  
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        result = realm.objects(detailCateGory.self)
        let data = result.where {
            $0._id == fk
        }
        let category = list[indexPath.row + 2].detail.where {
            $0.fk == data.first!._id
        }
        
        if category.count == 0 {
            
            let addData = detailCateGory(link: data.first!.link, title: data.first!.title, memo: data.first!.memo, likeLink: data.first!.likeLink, onlyAll: false)
            try! realm.write {
                list[indexPath.row + 2].detail.append(addData)
                list[indexPath.row + 2].detail.last!.fk = data.first!._id
            }
        }
        dismiss(animated: true)
//        navigationController?.popViewController(animated: false)
    }
    
}


