//
//  AddControllerViewModel.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/20.
//

import Foundation
import RealmSwift

class AddCategoryViewModel {
    
    
    let cateGoryTableRepositary = CateGoryTableRepositary()
    var titleTextFieldChange = Observable("")
    var isValid = Observable(false)
    var addCategoryViewTitle: String?
    //    var warningTitleLabel = true
    
    var categoryPk: ObjectId? 
  
 
    
    
    func checkTitleTextField() {
        
        guard !titleTextFieldChange.value.trimmingCharacters(in: .whitespaces).isEmpty == true else {
            isValid.value = false
            return
        }
        isValid.value = true
        return
    }
    
    
    func modifyCategory(){
      print("gsdergdergaergadrsgadrsgdfg", categoryPk)
//        let vc = CategoryViewController()
//        vc.completionHandler = {  data in
//            self.categoryPk = data
//            print(data)
            //
            //        }
            //        print(vc.completionHandler!)
            
            //        print( categoryPk)
            //        if categoryPk != nil {
            //            let result = cateGoryTableRepositary.fetchCategoryFilter(pk: categoryPk!)
            //            titleTextFieldChange.value = result.first?.title ?? ""
            //            AddCategoryViewTitle = "카테고리 이름 변경"
            //        }
            
 
        
    }
    
    
    
    
    //if titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
    //
    //    titleUnderBarUIView.backgroundColor = .red
    //    warningTitleLabel.isHidden = false
    //}
    //else {
    //
    //    if categoryPk == nil {
    //
    //
    //        let categorylist = list.where {
    //            $0.title == titleTextField.text ?? ""
    //        }
    //
    //        if categorylist.count == 0 {
    //            let data = CateGoryRealm(title: titleTextField.text ?? "")
    //
    //            try! realm.write{
    //                realm.add(data)
    //            }
    //
    //            //                delegate?.recevieCollectionViewReloadData() //딜리게이트
    //            NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
    //            dismiss(animated: true)
    //        } else {
    //            showtoast(title: "중복된 타이틀입니다.")
    //            titleUnderBarUIView.backgroundColor = .red
    //        }
    //
    //    } else {
    //        let categorylist = list.where {
    //            $0.title == titleTextField.text ?? ""
    //        }
    //        if categorylist.count == 0 {
    //
    //            let category = list.where {
    //                $0._id == categoryPk!
    //            }
    //
    //            try! realm.write{
    //                category.first!.title = titleTextField.text ?? ""
    //            }
    //            //                delegate?.recevieCollectionViewReloadData() //딜리게이트
    //            NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
    //            dismiss(animated: true)
    //        } else {
    //            showtoast(title: "중복된 타이틀입니다.")
    //            titleUnderBarUIView.backgroundColor = .red
    //
    //        }
    //
    //
    //    }
    //
    //
    //}
}
