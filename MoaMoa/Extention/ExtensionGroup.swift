//
//  ExtentionGroup.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/07.
//

import UIKit

extension UIViewController {
    
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
    
    func labelSetup<T: UILabel>(label: T, text: String, backgroundColor: UIColor, textColor: UIColor, textAlignment: NSTextAlignment) {
        
        label.text = text
        label.backgroundColor = backgroundColor
      
        label.textColor = textColor
        label.textAlignment = textAlignment
//        if label.adjustsFontSizeToFitWidth == false {
//            label.adjustsFontSizeToFitWidth = true
//        }
        
    }
    
    func buttonSetup<T: UIButton>(button: T, title: String, image: UIImage?, backgrounColor: UIColor, hidden: Bool, selector: Selector){
        button.backgroundColor = backgrounColor
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.isHidden = hidden
        button.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    func textFieldSetup<T: UITextField>(textField: T , textAlignment: NSTextAlignment, textColor: UIColor ) {
        
   
        textField.textAlignment = textAlignment
        textField.textColor = textColor
    }
    
}


extension UICollectionViewCell {
    
    func labelSetup<T: UILabel>(label: T, text: String, backgroundColor: UIColor, textColor: UIColor, textAlignment: NSTextAlignment) {
        
        label.text = text
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = textAlignment
//        if label.adjustsFontSizeToFitWidth == false {
//            label.adjustsFontSizeToFitWidth = true
//        }
        
    }
    
    func buttonSetup<T: UIButton>(button: T, title: String, image: UIImage?, backgrounColor: UIColor, hidden: Bool, selector: Selector){
        button.backgroundColor = backgrounColor
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.isHidden = hidden
        button.addTarget(self, action: selector, for: .touchUpInside)
    }
    
}




//extension UIImage {
//    func resize(newWidth: CGFloat) -> UIImage {
//        let scale = newWidth / self.size.width
//        let newHeight = self.size.height * scale
//
//        let size = CGSize(width: newWidth, height: newHeight)
//        let render = UIGraphicsImageRenderer(size: size)
//        let renderImage = render.image { context in
//            self.draw(in: CGRect(origin: .zero, size: size))
//        }
//        
//        print("화면 배율: \(UIScreen.main.scale)")// 배수
//        print("origin: \(self), resize: \(renderImage)")
//       
//        return renderImage
//    }
//}
//extension UIColor {
//    static let backgroundColorAsset = UIColor(named: "reversedSystemBackgroundColor")
//}

extension UITextField {
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
    
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
            let clearButton = UIButton(type: .custom)
            clearButton.setImage(image, for: .normal)
            clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            clearButton.contentMode = .scaleAspectFit
            clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
            self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
            self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
            self.rightView = clearButton
            self.rightViewMode = mode
        }
        
        @objc
        private func displayClearButtonIfNeeded() {
            self.rightView?.isHidden = (self.text?.isEmpty) ?? true
        }
        
        @objc
        private func clear(sender: AnyObject) {
            self.text = ""
            sendActions(for: .editingChanged)
        }
}
