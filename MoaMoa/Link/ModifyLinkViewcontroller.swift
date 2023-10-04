//
//  ModifyLinkViewcontroller.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/03.
//

import UIKit
import RealmSwift

class ModifyLinkViewcontroller: BaseViewController {
    
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    var pk: String?
    
    let linkTextView = UITextView()
    
    let titleLabel = UILabel()
    let titleTextView = UITextView()
    let memoLabel = UILabel()
    let memoTextView = UITextView()
    
    let cancleButton = UIButton()
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(CateGoryRealm.self)
     print("@@@", pk)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
     
    }
    
    func existingData() {
        
    }
    
    @objc func addButtonTapped() {
       let allCategoryId: String = String(describing: realm.objects(CateGoryRealm.self).first!._id)
      
        let data = detailCateGory(link: linkTextView.text, title: titleTextView.text, memo: memoTextView.text, likeLink: false, pk: pk ?? "", AllCategory: allCategoryId)
       let addInCategory = list.filter {
            "\($0._id)" == self.pk
        }
        
        if pk == nil {
            
            try! realm.write{
                list.first?.detail.append(data)
            }
        } else {
            try! realm.write{
                list.first?.detail.append(data)
                addInCategory.first?.detail.append(data)
            }
        }
        
      dismiss(animated: true)
    }
    
    
    override func configure() {
        super.configure()
        view.backgroundColor = .white
        view.addSubview(linkTextView)
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextView)
        view.addSubview(memoLabel)
        view.addSubview(memoTextView)
        view.addSubview(cancleButton)
        view.addSubview(addButton)
        
        linkTextView.backgroundColor = .blue
        
        titleLabel.backgroundColor = .blue
        titleTextView.backgroundColor = .blue
        memoLabel.backgroundColor = .blue
        memoTextView.backgroundColor = .blue
        cancleButton.backgroundColor = .blue
        addButton.backgroundColor = .blue
        
        
        
    }
    
    override func setContraints() {
        super.setContraints()
        
        linkTextView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
       
        
        titleLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(linkTextView.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        titleTextView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(titleTextView.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        memoTextView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(memoLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(50)
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(50)
        }
    }
    
    
}
