//
//  AddCategory.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift

class AddCategoryView: BaseViewController, UITextFieldDelegate  {
    
    let titleLabel = {
       let view = UILabel()
        view.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
        view.textAlignment = .center
        view.textColor = .systemBackground
        view.text = "카테고리 추가"
        view.font = UIFont.systemFont(ofSize: 20)
        
        return view
    }()
    let titleTextField = {
        let view = UITextField()
        view.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
        view.setClearButton(with: UIImage(systemName: "x.circle.fill")!, mode: .whileEditing)
        view.tintColor = .gray
        view.textColor = .systemBackground
        
        view.placeholder = "제목을 적어주세요."
        view.setPlaceholder(color: .gray)
      return view
    }()
    let titleTextCountLabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
        view.textColor = .gray
        view.textAlignment = .right
        if view.adjustsFontSizeToFitWidth == false {
            view.adjustsFontSizeToFitWidth = true
               }
        view.text = "(0/15)"
        return view
    }()
    
    let titleUnderBarUIView = {
      let view =  UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    let backgroundView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
        return view
    }()
    let cancleButton = {
       let view = UIButton()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(named: "SignatureColor")
        view.setTitle("취소", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 19)
        return view
    }()
    let addButton = {
        let view = UIButton()
         view.layer.cornerRadius = 15
         view.backgroundColor = UIColor(named: "SignatureColor")
        view.setTitle("추가", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 19)
         return view
     }()
    
    let warningTitleLabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13)
        view.text = "제목을 입력해 주세요."
        view.textColor = .red
        view.isHidden = true
        return view
    }()
  
    

    let realm = try! Realm()
    var categoryPk : ObjectId?
    var list: Results<CateGoryRealm>!
    
    let addCategoryViewModel = AddCategoryViewModel()
    
    init(categoryPk: ObjectId? = nil) {

        self.categoryPk = categoryPk
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.0)
        view.isOpaque = false
        titleTextField.becomeFirstResponder()
        
        list = realm.objects(CateGoryRealm.self)
        
        showData()
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChanged), for: .touchUpInside)
        
        
    }
  
    @objc func titleTextFieldDidChanged() {
        
        titleUnderBarUIView.backgroundColor = .systemBackground
        warningTitleLabel.isHidden = true
        if titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            titleTextField.setPlaceholder(color: .gray)
            titleTextField.placeholder = "제목을 적어주세요."
        }
        titleTextField.text = String(titleTextField.text!.prefix(20))
        titleTextCountLabel.text = "(\(String(describing: titleTextField.text!.count))/20)"
    }

    
    
    @objc func cancelButtonTapped() {
       
       dismiss(animated: true)
        
    }
    @objc func addButtonTapped() {
        if titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            
            titleUnderBarUIView.backgroundColor = .red
            warningTitleLabel.isHidden = false
        }
        else {
            
            if categoryPk == nil {
                
                
                let categorylist = list.where {
                    $0.title == titleTextField.text ?? ""
                }
                
                if categorylist.count == 0 {
                    let data = CateGoryRealm(title: titleTextField.text ?? "")
                    
                    try! realm.write{
                        realm.add(data)
                    }
                    
                    //                delegate?.recevieCollectionViewReloadData() //딜리게이트
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                    dismiss(animated: true)
                } else {
                    showtoast(title: "중복된 타이틀입니다.")
                    titleUnderBarUIView.backgroundColor = .red
                }
                
            } else {
                let categorylist = list.where {
                    $0.title == titleTextField.text ?? ""
                }
                if categorylist.count == 0 {
                    
                    let category = list.where {
                        $0._id == categoryPk!
                    }
                    
                    try! realm.write{
                        category.first!.title = titleTextField.text ?? ""
                    }
                    //                delegate?.recevieCollectionViewReloadData() //딜리게이트
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                    dismiss(animated: true)
                } else {
                    showtoast(title: "중복된 타이틀입니다.")
                    titleUnderBarUIView.backgroundColor = .red
                    
                }
        
                
            }
            
            
        }
    }
    
    
    func showData() {
        if categoryPk != nil {
            let category = list.where {
                $0._id == categoryPk!
            }
            titleTextField.text = category.first!.title
            titleLabel.text = "카테고리 이름 변경"
            addButton.setTitle("변경 완료", for: .normal)
        }
        
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
       
    }
    
    func showtoast(title: String) {
        self.view.makeToast(title, duration: 1.5,
                            position: .center)
    }
   
    
    
    
    
    override func configure() {
        super.configure()
        titleTextField.delegate = self
       
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleTextCountLabel)
        view.addSubview(titleUnderBarUIView)
        view.addSubview(cancleButton)
        view.addSubview(addButton)
        view.addSubview(warningTitleLabel)
        
        
    }
    
    
    override func setContraints() {
        super.setContraints()
        
        
        backgroundView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.height.equalTo(view.snp.height).multipliedBy(0.225)
            make.center.equalToSuperview()
          
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(backgroundView.snp.width).multipliedBy(0.6)
            make.height.equalTo(45)
            make.top.equalTo(backgroundView.snp.top).inset(8)
            make.centerX.equalTo(backgroundView)
        }
        
        titleTextField.snp.makeConstraints { make in
           
            make.height.equalTo(backgroundView.snp.height).multipliedBy(0.2)
            make.leading.trailing.equalTo(backgroundView).inset(8)
            make.center.equalTo(backgroundView)

        }
        
        titleTextCountLabel.snp.makeConstraints { make in
            make.width.equalTo(titleTextField.snp.width).multipliedBy(0.2)
            make.top.equalTo(titleTextField.snp.bottom)
            make.trailing.equalTo(titleTextField.snp.trailing)
            make.bottom.equalTo(addButton.snp.top).offset(-8)
        }
        titleUnderBarUIView.snp.makeConstraints { make in
            make.width.equalTo(titleTextField.snp.width)
            make.height.equalTo(0.7)
            make.bottom.equalTo(titleTextField.snp.bottom)
            make.centerX.equalTo(titleTextField)
        }

        addButton.snp.makeConstraints { make in
            
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(40)
            make.bottom.equalTo(backgroundView.snp.bottom).inset(8)
            make.trailing.equalTo(titleTextField.snp.trailing)
           }
        
        cancleButton.snp.makeConstraints { make in
            make.width.equalTo(addButton.snp.width)
            make.height.equalTo(40)
            make.bottom.equalTo(backgroundView.snp.bottom).inset(8)
            make.leading.equalTo(titleTextField.snp.leading)
        }
        
        warningTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(titleTextField.snp.width).multipliedBy(0.7)
            make.leading.equalTo(backgroundView.snp.leading).inset(8)
            make.height.equalTo(titleTextField.snp.height).multipliedBy(0.5)
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
        }
        
    }
    
    
    
}



