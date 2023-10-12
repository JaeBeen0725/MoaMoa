//
//  ExtentionGroup.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/07.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func showActivityVC(_ controller: UIViewController,
                         activityItems: [Any],
                         sourceRect: CGRect,
                         completion: (() -> ())? = nil) {
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.postToTwitter, .postToWeibo, .postToVimeo, .postToFlickr, .postToFacebook, .postToTencentWeibo]
        
        
        activityVC.popoverPresentationController?.sourceView = controller.view
        
        activityVC.popoverPresentationController?.sourceRect = sourceRect
        
        controller.present(activityVC, animated: true, completion: completion)
    }
}


//extension UITextField{
//
//    @IBInspectable var doneAccessory: Bool{
//        get{
//            return self.doneAccessory
//        }
//        set (hasDone) {
//            if hasDone{
//                addDoneButtonOnKeyboard()
//            }
//        }
//    }

//    func addDoneButtonOnKeyboard() {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        inputAccessoryView = doneToolbar
//    }
//
//    @objc func doneButtonAction() {
//        endEditing(true)
//    }

//}

