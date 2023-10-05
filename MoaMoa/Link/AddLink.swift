//
//  AddAndModifyLink.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift

class AddLink: BaseViewController {
    
    let beforeCollectionView: UICollectionView
    
    let linkViewModel = LinkViewModel()
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    
    var categoryPK: ObjectId?
    
    let linkTextField = UITextField()
    
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let titleTextCountLabel = UILabel()
    
    let memoLabel = UILabel()
    let memoTextField = UITextField()
    let memoTextCountLabel = UILabel()
    
    let cancelButton = UIButton()
    let addButton = UIButton()
    
    init(categoryPK: ObjectId? = nil, beforeCollectionView: UICollectionView) {
        self.categoryPK = categoryPK
        self.beforeCollectionView = beforeCollectionView
        super.init(nibName: nil, bundle: nil)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(CateGoryRealm.self)

        addTargetSetup()
        checkBind()
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
       cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
       
    }
    
    
    func checkBind() {
        linkViewModel.linkURL.bind { text in
            self.linkTextField.text = text
        }
        linkViewModel.linkTitle.bind { text in
            self.titleTextField.text = text
        }
        linkViewModel.linkMemo.bind { text in
            self.memoTextField.text = text
        }
        
        linkViewModel.isValid.bind { bool in
            
        }

    }
    
    
    
    func addTargetSetup() {
        linkTextField.addTarget(self, action: #selector(linkTextChanged), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)
        memoTextField.addTarget(self, action: #selector(memoTextChanged), for: .editingChanged)
    }
    
    @objc func linkTextChanged() {
        linkViewModel.linkURL.value = linkTextField.text ?? ""
        linkViewModel.checkValidation()
    }
    @objc func titleTextChanged() {
        linkViewModel.linkTitle.value = String(titleTextField.text!.prefix(10))
    
        titleTextCountLabel.text = "\(linkViewModel.linkTitle.value.count)/10"
        linkViewModel.checkValidation()

    }
    @objc func memoTextChanged() {
        linkViewModel.linkMemo.value = String(memoTextField.text!.prefix(10))
        memoTextCountLabel.text = "\(linkViewModel.linkMemo.value.count) /10"
        linkViewModel.checkValidation()

    }
    
    @objc func cancelButtonTapped() {
        print(#function)
        dismiss(animated: true)
    }
  
    
    @objc func addButtonTapped() {
        
        let allcategory = list.first!.detail
        
        let data = detailCateGory(fk: "",link: linkTextField.text!, title: titleTextField.text!, memo: memoTextField.text ?? "" , likeLink: false, onlyAll: true)

        if categoryPK == nil {
            
            try! realm.write{
                allcategory.append(data)
              
            }
        } else {
            let detailCategory = list.where {
                $0._id == categoryPK!
            }
            try! realm.write{
                allcategory.append(data)
                let realLink = allcategory.last!._id
                detailCategory.first!.detail.append(detailCateGory(fk: String(describing: realLink), link: linkTextField.text!, title: titleTextField.text!, memo: memoTextField.text ?? "", likeLink: false, onlyAll: false))
            }
        }
         beforeCollectionView.reloadData()
      dismiss(animated: true)
    }
    
    
    override func configure() {
        super.configure()
        view.backgroundColor = .white
        view.addSubview(linkTextField)
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleTextCountLabel)
        view.addSubview(memoLabel)
        view.addSubview(memoTextField)
        view.addSubview(memoTextCountLabel)
        view.addSubview(cancelButton)
        view.addSubview(addButton)
        
        linkTextField.backgroundColor = .blue
        
        titleLabel.backgroundColor = .blue
        titleTextField.backgroundColor = .blue
        memoLabel.backgroundColor = .blue
        memoTextField.backgroundColor = .blue
        cancelButton.backgroundColor = .brown
        addButton.backgroundColor = .blue
        titleTextCountLabel.backgroundColor = .blue
        memoTextCountLabel.backgroundColor = .blue
        
    }
    
    override func setContraints() {
        super.setContraints()
        
        linkTextField.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
       
        
        titleLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(linkTextField.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        titleTextField.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        titleTextCountLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalTo(titleTextField.snp.trailing).offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        
        memoLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        memoTextField.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(memoLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        memoTextCountLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalTo(memoTextField.snp.trailing).offset(16)
            make.top.equalTo(memoLabel.snp.bottom).offset(8)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(200)
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(50)
        }
    }
    
    
}


