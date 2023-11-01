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
    var titleTextCount = Observable(0)
    var isValid = Observable(false)
    var addCategoryViewTitle: String?
    var buttonTitle: String?
    var showToast = false
    //    var warningTitleLabel = true
    
    var categoryPk: ObjectId? 
  
 
    
    
    func checkTitleTextField() {
      
        guard !titleTextFieldChange.value.trimmingCharacters(in: .whitespaces).isEmpty == true else {
            showToast  = false
            isValid.value = false
            return
        }
        
        guard cateGoryTableRepositary.fetchCheckDuplicationCategoryTitleFilter(title: titleTextFieldChange.value).count == 0 else {
            isValid.value = false
            showToast  = true
            return
        }
       
        isValid.value = true
        return
    }
    
    
    func checkCategoryPk(){
        
        
        if categoryPk != nil {
           
            let result = cateGoryTableRepositary.fetchCategoryFilter(pk: categoryPk!).first!.title
            titleTextFieldChange.value = result
            titleTextCount.value = result.count
            addCategoryViewTitle = "카테고리 변경하기"
            buttonTitle = "변경"
            
        } else {
            addCategoryViewTitle = "카테고리 추가하기"
            buttonTitle = "추가"
        }
        

        
    }
    
    func buttonTapped()  {
        
        guard isValid.value == true else { return }
      
        
        guard categoryPk == nil else {
            showToast = false
            let result = cateGoryTableRepositary.fetchCategoryFilter(pk: categoryPk!).first
            cateGoryTableRepositary.changeCategoryTitle(result!, title: titleTextFieldChange.value)
            
            return
        }
       
        cateGoryTableRepositary.createCategoryItem(title: titleTextFieldChange.value)
        showToast = false
        
//        if isValid.value == true {
//            showToast = false
//            if cateGoryTableRepositary.fetchCheckDuplicationCategoryTitleFilter(title: titleTextFieldChange.value).count == 0 {
//                
//                if categoryPk != nil {
//                    let result = cateGoryTableRepositary.fetchCategoryFilter(pk: categoryPk!).first
//                    cateGoryTableRepositary.changeCategoryTitle(result!, title: titleTextFieldChange.value)
//                    
//                } else {
//
//                    cateGoryTableRepositary.createCategoryItem(title: titleTextFieldChange.value)
//                }
//            } else {
//                showToast = true
//                
//            }
//            
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
