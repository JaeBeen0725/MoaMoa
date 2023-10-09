//
//  AddCategory.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift

class AddCategoryViewController: BaseViewController {

    let titleText = UITextView()
    let addButton = UIButton()
    var delegate: ReloadDataDelegate?
    let realm = try! Realm()
    
    
    init(delegate: ReloadDataDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        hideKeyboard()
    }
    
    @objc func addButtonTapped() {
        let data = CateGoryRealm(title: titleText.text)
        try! realm.write{
            realm.add(data)
        }
        delegate?.recevieCollectionViewReloadData()
       dismiss(animated: true)
        
    }

}


