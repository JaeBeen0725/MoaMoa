//
//  BaseViewController.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/01.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setContraints()
    }
    
    func configure() { }
    func setContraints() { }
}
