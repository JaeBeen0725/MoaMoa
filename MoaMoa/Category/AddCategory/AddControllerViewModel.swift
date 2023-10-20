//
//  AddControllerViewModel.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/20.
//

import UIKit

class AddCategoryViewModel {
    
    var titleTextFieldChange = Observable("")
    var isValid = false
    
    
    func checkTitleTextField() {
        
        guard !titleTextFieldChange.value.trimmingCharacters(in: .whitespaces).isEmpty == true else {
            
            isValid = false
            return
        }
        
        
        isValid = true
        return 
    }
    
    
    func signIn(completion: @escaping () -> Bool ) {
      
       
        
    
    }
    
}
