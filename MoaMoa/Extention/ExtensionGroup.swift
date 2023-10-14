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
