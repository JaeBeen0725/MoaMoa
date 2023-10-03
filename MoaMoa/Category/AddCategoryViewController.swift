//
//  AddCategory.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift

class AddCategory: BaseViewController {

    let titleText = UITextView()
    let addButton = UIButton()
    
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleText)
        titleText.backgroundColor = .brown
        view.addSubview(addButton)
        addButton.backgroundColor = .cyan
        titleText.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalTo(titleText.snp.trailing).offset(10)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        let data = CateGoryRealm(title: titleText.text)
        try! realm.write{
            realm.add(data)
        }
        navigationController?.popViewController(animated: true)
        
    }

    
}
