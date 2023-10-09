//
//  ChangeCategoryName.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/07.
//

import UIKit
import RealmSwift

class ChangeCategoryName: BaseViewController {

    let titleText = UITextView()
    let addButton = UIButton()
    var delegate: ReloadDataDelegate?
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    
    var categoryPk: ObjectId
    
    init(delegate: ReloadDataDelegate? = nil, categoryPk: ObjectId) {
        self.delegate = delegate
        self.categoryPk = categoryPk
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
        list = realm.objects(CateGoryRealm.self)
        showData()
        addButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        hideKeyboard()
    }
    
    @objc func changeButtonTapped() {
        let category = list.where {
            $0._id == categoryPk
        }
        try! realm.write{
            category.first!.title = titleText.text
        }
        delegate?.recevieCollectionViewReloadData()
       dismiss(animated: true)
        
    }
    func showData() {
        let category = list.where {
            $0._id == categoryPk
        }
        titleText.text = category.first!.title
        
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(titleText)
        titleText.backgroundColor = .brown
        view.addSubview(addButton)
        addButton.backgroundColor = .cyan
     
    }
    
    override func setContraints() {
        super.setContraints()
        
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
        
    }

}
