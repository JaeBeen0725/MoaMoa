//
//  Layout+Extension.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/11.
//

import UIKit

class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 3.0, left: 5.0, bottom: 3.0, right: 5.0)

    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}


