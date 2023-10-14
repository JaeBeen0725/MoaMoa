//
//  AddAndModifyLink.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift
import LinkPresentation


protocol RealmPassDataDelegate{
    func receviePkData(data: ObjectId)
}

protocol ReloadDataDelegate{
    func recevieCollectionViewReloadData()
    
}

class AddLink: BaseViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var delegate: ReloadDataDelegate?
    
    let linkViewModel = LinkViewModel()
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    var categoryPK: ObjectId?
    
    let linkTitleLabel = UILabel()
    let linkTextField = UITextField()
    let linkUnderBarUIView = UIView()
    let linkPasteButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.imagePlacement = .trailing

       
        let button = UIButton(configuration: configuration, primaryAction: nil)
      
        
        return button
    }()
    
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let receiveTitleButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.imagePlacement = .trailing

       
        let button = UIButton(configuration: configuration, primaryAction: nil)
      
        
        return button
    }()
    let titleUnderBarUIView = UIView()
    let titleTextCountLabel = UILabel()
    
    let memoTitleLabel = UILabel()
    let memoTextField = UITextView()
    let memoTextCountLabel = UILabel()
    var temporaryUIImageData : UIImage?
    var temporaryTitleData: String?
    let addButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.imagePlacement = .trailing

       
        let button = UIButton(configuration: configuration, primaryAction: nil)
      
        
        return button
    }()
    var getTitleValid = false
    init(delegate: ReloadDataDelegate? = nil, categoryPK: ObjectId? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.categoryPK = categoryPK
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
        linkPasteButton.addTarget(self, action: #selector(pasteButtonTapped), for: .touchUpInside)


        
        titleTextField.delegate = self
        memoTextField.delegate = self
        
        linkUnderBarUIView.backgroundColor = .black
        titleUnderBarUIView.backgroundColor = .black
        memoTextCountLabel.text = "0/100"
        
        
        titleTextCountLabel.font = UIFont.systemFont(ofSize: 10)
        UITextField.appearance().clearButtonMode = .whileEditing
    }
 

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func checkBind() {
        linkViewModel.linkURL.bind { text in
            self.linkTextField.text = text
        }
        linkViewModel.linkTitle.bind { text in
            self.titleTextField.text = text
        }
    
        
        linkViewModel.isValid.bind { bool in
            if bool {
                self.addButton.isEnabled = bool
                self.addButton.setTitle("저장", for: .normal)
            } else {
            
                self.addButton.isEnabled = bool
                
            }
        }

    }
    
    
    
    func addTargetSetup() {
        linkTextField.addTarget(self, action: #selector(linkTextChanged), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)
    
        receiveTitleButton.addTarget(self, action: #selector(receiveTitleButtonTapped), for: .touchUpInside)
       
    }
    @objc func receiveTitleButtonTapped(){
        
        if getTitleValid == true{
            titleTextField.text = temporaryTitleData
            linkViewModel.linkTitle.value = titleTextField.text ?? ""
            linkViewModel.checkValidation()
        } else {
            showAlert(err: "링크주소를 입력해 주세요")
        }

    }
    
    
    @objc func pasteButtonTapped()  {
        linkPasteButton.configuration?.showsActivityIndicator = true
        
        if linkTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ==  true {
            linkTextField.text = ""
            guard let pasteString = UIPasteboard.general.string else {
                showAlert(err: "url 입력해")
                return }
            linkTextField.text = pasteString
            
            receiveMetaData(url: pasteString)
        } else {
            receiveMetaData(url: linkTextField.text ?? "")
        }
        
        linkPasteButton.configuration?.showsActivityIndicator = false
        linkViewModel.linkURL.value = linkTextField.text ?? ""
        linkViewModel.checkValidation()
        
    }
    
    @objc func linkTextChanged() {
        linkViewModel.linkURL.value = linkTextField.text ?? ""
        linkViewModel.checkValidation()
    }
    @objc func titleTextChanged() {
        linkViewModel.linkTitle.value = String(titleTextField.text!.prefix(100))
    
        titleTextCountLabel.text = "\(linkViewModel.linkTitle.value.count)/10"
        linkViewModel.checkValidation()

    }
    
    
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let currentText = memoTextField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false}
//        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
//        memoTextCountLabel.text = "\(changedText.count)/100"
//        return true
//    }
    
    

    @objc func addButtonTapped() {
        addButton.configuration?.showsActivityIndicator = true
        
        let allcategory = list.first!.detail
        let data = detailCateGory(link: linkTextField.text!, title: titleTextField.text!, memo: memoTextField.text ?? "" , likeLink: false, onlyAll: true)
        
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
                    detailCategory.first!.detail.append(detailCateGory(link: linkTextField.text!, title: titleTextField.text!, memo: memoTextField.text ?? "", likeLink: false, onlyAll: false))
                    detailCategory.first!.detail.last!.fk = realLink
         
                }
            }
     
            self.saveIamgeToDocument(fileName: "\(allcategory.last!._id)", image: (temporaryUIImageData ?? UIImage(named: "NOPickture"))!)
         
            delegate!.recevieCollectionViewReloadData()
            NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
            addButton.configuration?.showsActivityIndicator = false
            
          dismiss(animated: true)
 
    }
    
    
    func receiveMetaData(url: String) {
        MetaData.fetchMetaData(for: URL(string: url )! ) {  metadata in
            
            switch metadata {
            case .success(let metadata):
                
                if let imageProvider = metadata.imageProvider {
                    metadata.imageProvider = imageProvider
                    
                    
                    imageProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        guard error == nil else {
                            return
                        }
                        guard let self = self else {return}
                        if let image = image as? UIImage {
   
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                self.temporaryUIImageData = image
                                self.temporaryTitleData = metadata.title ?? ""
                                getTitleValid = true
                                linkPasteButton.configuration?.showsActivityIndicator = false
                                
                            }
                            
                        } else {
                            print("no image available")
                        }
                    }
                }
                
                
            case .failure(let error):
                self.handleFailureFetchMetaData(for: error)
            }
        }
    }
    private func handleFailureFetchMetaData(for error: LPError? = nil) {
        let errorLabelText = error?.prettyString ?? "잘못된 URL입니다. 다시 입력해주세요!"
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            linkPasteButton.configuration?.showsActivityIndicator = false
            print(errorLabelText)
            showAlert(err: errorLabelText)
        }
    }
    
    func showAlert(err: String) {
           
           let alert = UIAlertController(title: err, message: "URL를 확인하세요", preferredStyle: .actionSheet)
           let ok = UIAlertAction(title: "확인", style: .default)
           alert.addAction(ok)
           present(alert, animated: true)
       }
    
    override func configure() {
        super.configure()
        view.backgroundColor = .white
        view.addSubview(linkTitleLabel)
        view.addSubview(linkTextField)
        view.addSubview(linkUnderBarUIView)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleUnderBarUIView)
        view.addSubview(receiveTitleButton)
        view.addSubview(titleTextCountLabel)
        view.addSubview(memoTitleLabel)
        view.addSubview(memoTextField)
        view.addSubview(memoTextCountLabel)
        
        view.addSubview(addButton)
        view.addSubview(linkPasteButton)
        
        
        titleLabel.backgroundColor = .blue
        titleTextField.backgroundColor = .systemBackground
       
        memoTitleLabel.backgroundColor = .blue
        memoTextField.backgroundColor = .blue
        
        addButton.backgroundColor = .blue
        titleTextCountLabel.backgroundColor = .cyan
        memoTextCountLabel.backgroundColor = .cyan
        linkPasteButton.backgroundColor = .lightGray
        receiveTitleButton.backgroundColor = .green
        linkTitleLabel.backgroundColor = .brown
    }
    
    
    override func setContraints() {
        super.setContraints()
        
        linkTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.17)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.04)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(70)
        }
        
        linkTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(linkTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.trailing.equalTo(linkPasteButton.snp.leading).offset(-4)
        }
        linkUnderBarUIView.snp.makeConstraints { make in
            make.width.equalTo(linkTextField)
            make.height.equalTo(1)
            make.bottom.equalTo(linkTextField.snp.bottom)
            make.centerX.equalTo(linkTextField)
        }
        linkPasteButton.snp.makeConstraints { make in
            make.size.equalTo(linkTextField.snp.height)
            make.top.equalTo(linkTitleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(linkTitleLabel.snp.width)
            make.height.equalTo(linkTitleLabel.snp.height)
            make.top.equalTo(linkTextField.snp.bottom).offset(35)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(linkTextField.snp.height)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.trailing.equalTo(titleTextCountLabel.snp.leading)
        }
        
        titleUnderBarUIView.snp.makeConstraints { make in
            make.leading.equalTo(titleTextField.snp.leading)
            make.trailing.equalTo(titleTextCountLabel.snp.trailing)
            make.height.equalTo(1)
            make.bottom.equalTo(titleTextField.snp.bottom)
         
        }
        
        titleTextCountLabel.snp.makeConstraints { make in
            make.width.equalTo(titleTextField.snp.width).multipliedBy(0.1)
            make.height.equalTo(titleTextField.snp.height).multipliedBy(0.5)
            make.trailing.equalTo(receiveTitleButton.snp.leading).offset(-4)
            make.centerY.equalTo(titleTextField)
        
        }
        receiveTitleButton.snp.makeConstraints { make in
            make.size.equalTo(linkPasteButton.snp.width)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
         
        
        
     
        memoTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(linkTitleLabel.snp.width)
            make.height.equalTo(linkTitleLabel.snp.height)
            make.top.equalTo(titleTextField.snp.bottom).offset(35)
        }
        
        memoTextCountLabel.snp.makeConstraints { make in
            make.width.equalTo(titleTextCountLabel.snp.width)
            make.height.equalTo(titleTextCountLabel.snp.height)
            make.trailing.equalTo(memoTextField.snp.trailing)
            make.bottom.equalTo(memoTextField.snp.bottom)
        }
        memoTextField.snp.makeConstraints { make in
          
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
     
        addButton.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.1)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
  
    
}


