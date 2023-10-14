//
//  File.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/04.
//

import Foundation


class LinkViewModel {
    
    var linkURL = Observable("")
    var linkTitle = Observable("")
    
    var isValid = Observable(false)
    
    func checkValidation() {
        
        guard !linkURL.value.contains("http:") && !linkURL.value.trimmingCharacters(in: .whitespaces).isEmpty else {
            isValid.value = false
            print("링크 놉")
            return
        }
                
        guard !linkTitle.value.trimmingCharacters(in: .whitespaces).isEmpty else{
            isValid.value = false
            print("타이틀놉")
            return
        }
    
        isValid.value = true
        print("예에에스")
    }
    

    
}
