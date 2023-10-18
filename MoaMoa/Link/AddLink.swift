//
//  AddAndModifyLink.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift
import LinkPresentation
import Toast

//protocol RealmPassDataDelegate{ //딜리게이트
//    func receviePkData(data: ObjectId)
//}
//
//protocol ReloadDataDelegate{
//    func recevieCollectionViewReloadData()
//    
//}

class AddLink: BaseViewController, UITextFieldDelegate, UITextViewDelegate {
    
//    var delegate: ReloadDataDelegate? //딜리게이트
    var detailResult: Results<detailCateGory>!
    let linkViewModel = LinkViewModel()
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    var categoryPK: ObjectId?
    var fk: ObjectId?
    
    let addLinkTitle = {
        
    }
    
    let linkTitleLabel = {
        let view = UILabel()
         view.backgroundColor = UIColor(named: "BackgroundColor")
         view.textAlignment = .left
         view.textColor = UIColor(named: "reversedSystemBackgroundColor")
         view.text = "링크"
//         view.font = UIFont.systemFont(ofSize: 21)
        view.font = UIFont.boldSystemFont(ofSize: 21)
         return view
     }()

    let linkTextField = {
        let view = UITextField()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.setClearButton(with: UIImage(systemName: "x.circle.fill")!, mode: .whileEditing)
        view.tintColor = .gray
        view.textColor = UIColor(named: "reversedSystemBackgroundColor")
        
        view.placeholder = "링크를 입력해 주세요.(필수)"
        view.setPlaceholder(color: .gray)
      return view
    }()
    
    let linkUnderBarUIView = {
        let view =  UIView()
          view.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
          return view
      }()
    
    let warningLinkLabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13)
        view.text = "링크를 입력해 주세요."
        view.textColor = .red
        view.isHidden = true
        return view
    }()
    
    let linkPasteButton = {
        let button = UIButton()
            
            var attString = AttributedString("불러오기")
            attString.font = .systemFont(ofSize: 15, weight: .bold)
        attString.foregroundColor = .white
            
            
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = attString

        configuration.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            configuration.baseBackgroundColor =  UIColor(named: "SignatureColor")
            button.configuration = configuration
            return button
    }()
    
    let titleLabel = {
        let view = UILabel()
         view.backgroundColor = UIColor(named: "BackgroundColor")
         view.textAlignment = .left
         view.textColor = UIColor(named: "reversedSystemBackgroundColor")
         view.text = "제목"
        view.font = UIFont.boldSystemFont(ofSize: 21)//.systemFont(ofSize: 21)
         
   
         return view
     }()
    var titleTextField = {
        let view = UITextField()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.setClearButton(with: UIImage(systemName: "x.circle.fill")!, mode: .whileEditing)
        view.tintColor = .gray
        view.textColor = UIColor(named: "reversedSystemBackgroundColor")
        
        view.placeholder = "제목을 입력해 주세요.(필수)"
        view.setPlaceholder(color: .gray)
      return view
    }()

    let titleUnderBarUIView = {
        let view =  UIView()
          view.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
          return view
      }()
    
    let warningTitleLabel = {
        let view = UILabel()
        
        view.text = "제목을 입력해 주세요."
        view.font = UIFont.systemFont(ofSize: 13)
        view.textColor = .red
        view.isHidden = true
        return view
    }()
    
    let titleTextCountLabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.textColor = .gray
        view.textAlignment = .right
        view.text = "(0/30)"
        if view.adjustsFontSizeToFitWidth == false {
            view.adjustsFontSizeToFitWidth = true
               }
        return view
    }()
    
    let memoTitleLabel = {
        let view = UILabel()
         view.backgroundColor = UIColor(named: "BackgroundColor")
         view.textAlignment = .left
         view.textColor = UIColor(named: "reversedSystemBackgroundColor")
         view.text = "메모"
        view.font = UIFont.boldSystemFont(ofSize: 21)
//         view.font = UIFont.systemFont(ofSize: 21)
         
    
         return view
     }()
    let memoTextView = {
        let view = UITextView()
        let layer = CALayer()
        view.backgroundColor = UIColor(named: "BackgroundColor")
  
        view.tintColor = .gray
        view.textColor = UIColor(named: "reversedSystemBackgroundColor")
        view.font = UIFont.systemFont(ofSize: 18)
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.6
      
        
       
      return view
    }()
    let memoTextCountLabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.textColor = .gray
        view.textAlignment = .right
        view.text = "(0/100)"
        if view.adjustsFontSizeToFitWidth == false {
            view.adjustsFontSizeToFitWidth = true
               }
        return view
    }()
    
    var temporaryUIImageData: UIImage?
    var temporaryTitleData: String?
    
    
    let addButton = {

        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(named: "SignatureColor")
        button.setTitleColor(.white, for: .normal)
        button.setTitle("작성 완료", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
    
        return button
    }()
    
    var validd = false
    var activateButton = false
    var linkBool = Bool()
    var titleBool = Bool()
    init(/*delegate: ReloadDataDelegate? = nil,*/ categoryPK: ObjectId? = nil, fk: ObjectId? = nil) { //딜리게이트
//        self.delegate = delegate
        self.categoryPK = categoryPK
        self.fk = fk
       super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let color = UIColor(named: "reversedSystemBackgroundColor")!
              let resolvedColor = color.resolvedColor(with: traitCollection)
              memoTextView.layer.borderColor = resolvedColor.cgColor
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "링크 추가하기"
        list = realm.objects(CateGoryRealm.self)
        detailResult = realm.objects(detailCateGory.self)
        addTargetSetup()
        checkBind()

        titleTextField.delegate = self
        memoTextView.delegate = self
        
        linkPasteButton.configuration?.attributedTitle?.font  = .system(size: 11)
        showData()
        

    }
    func showData() {
        
        if fk != nil {
            let originalData = detailResult.where {
                $0._id == fk!
            }
            linkPasteButton.configuration?.attributedTitle = ""
            linkPasteButton.configuration?.image = UIImage(systemName: "checkmark")
            
            linkTextField.isEnabled = false
            linkPasteButton.isEnabled = false
            
            addButton.setTitle("변경 완료", for: .normal)
            addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
            linkTextField.text = originalData.first!.link
            titleTextField.text = originalData.first!.title
            memoTextView.text = originalData.first!.memo
            titleTextCountLabel.text = "\(titleTextField.text!.count)/30"
            memoTextCountLabel.text = "\(memoTextView.text!.count) /100"
            linkViewModel.linkTitle.value = titleTextField.text ?? ""
            
            linkViewModel.checkValidation()
        }
        
        
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
    
        linkViewModel.linkBool.bind { bool in
            self.linkBool = bool
        }
        
        linkViewModel.titleBool.bind { bool in
            self.titleBool = bool
        }
        
        linkViewModel.isValid.bind { bool in
            self.validd = bool


        }

    }
    
    
    
    func addTargetSetup() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        linkPasteButton.addTarget(self, action: #selector(pasteButtonTapped), for: .touchUpInside)
        linkTextField.addTarget(self, action: #selector(linkTextChanged), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)

    }
    
    
    @objc func pasteButtonTapped()  {
        linkPasteButton.configuration?.attributedTitle = ""
        linkPasteButton.configuration?.showsActivityIndicator = true
   
        

        if linkTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ==  true {
            linkTextField.text = ""
            guard let pasteString = UIPasteboard.general.string else {
                linkTextField.placeholder = "링크를 입력해 주세요.(필수)"
                linkTextField.setPlaceholder(color: .gray)
                linkPasteButton.configuration?.showsActivityIndicator = false
                pasteButtonSetup()
                return }
            linkTextField.text = pasteString
            
            
            receiveMetaData(url: pasteString)
        } else {
            if linkTextField.text?.contains("https://") == true {
                receiveMetaData(url: linkTextField.text ?? "")
            } else {
                receiveMetaData(url: "https://\(linkTextField.text ?? "")")
                linkTextField.text = "https://\(linkTextField.text ?? "" )"
            }
        }
        
       
        linkViewModel.linkURL.value = linkTextField.text ?? ""
        linkViewModel.checkValidation()
        
    }

    
    @objc func linkTextChanged() {
           activateButton = false
        linkPasteButton.isEnabled = true
        pasteButtonSetup()
        linkPasteButton.configuration?.image = nil
        warningLinkLabel.isHidden = true
        linkUnderBarUIView.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
        if linkTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            linkTextField.placeholder = "링크를 입력해 주세요.(필수)"
            linkTextField.setPlaceholder(color: .gray)
        }
        linkUnderBarUIView.backgroundColor = .gray
        linkViewModel.linkURL.value = linkTextField.text ?? ""
        linkViewModel.checkValidation()
    }
    @objc func titleTextChanged() {
        
        linkViewModel.linkTitle.value = String(titleTextField.text!.prefix(30))
        titleUnderBarUIView.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
        warningTitleLabel.isHidden = true
        titleTextCountLabel.text = "(\(linkViewModel.linkTitle.value.count)/30)"
        linkViewModel.linkURL.value = linkTextField.text ?? ""
        linkViewModel.checkValidation()

    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = memoTextView.text else { return }
     
               let maxLength = 100
               if text.count > maxLength {
                   memoTextView.text = String(text.prefix(maxLength))
               }
          
        memoTextCountLabel.text = "(\(memoTextView.text.count)/100)"
    }
    

    

    @objc func addButtonTapped(canTap: Bool) {
        if fk == nil {
            if activateButton == true {
                
                if validd == true {
                    
                    let allcategory = list.first!.detail
                    let data = detailCateGory(link: linkTextField.text! ,title: titleTextField.text!, searchTitle: titleTextField.text!.lowercased(), memo: memoTextView.text ?? "" , likeLink: false, onlyAll: true)
                    
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
                            detailCategory.first!.detail.append(detailCateGory(link: linkTextField.text!, title: titleTextField.text!, searchTitle: titleTextField.text!.lowercased(), memo: memoTextView.text ?? "", likeLink: false, onlyAll: false))
                            detailCategory.first!.detail.last!.fk = realLink
                            
                        }
                    }
                    
                    self.saveIamgeToDocument(fileName: "\(allcategory.last!._id)", image: (temporaryUIImageData ?? UIImage(named: "NOPickture"))!)
                    
                    //                    delegate!.recevieCollectionViewReloadData() //딜리게이트
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                    
                    
                    dismiss(animated: true)
                    
                    
                    
                }
                else {
                    
                    showtoast(title: "제목을 입력해 주세요.")
                    warningTitleLabel.isHidden = false
                    titleUnderBarUIView.backgroundColor = .red
                }
            }
            
            else {
                linkUnderBarUIView.backgroundColor = .red
                showtoast(title: "불러오기 버튼을 눌러주세요.")
                linkUnderBarUIView.backgroundColor = .red
                warningLinkLabel.isHidden = false
            }
            
        }
        else {
            
            if  titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
                showtoast(title: "제목을 입력해 주세요.")
                titleUnderBarUIView.backgroundColor = .red
                warningTitleLabel.isHidden = false
               return
           }
            else {
                print("있다 제목")
                    
                let data = detailResult.where {
                    $0.fk == fk!
                }
                try! realm.write {
                    for i in 0...data.count - 1{
                        data[i].title = titleTextField.text!
                        data[i].memo = memoTextView.text ?? ""
                        data[i].searchTitle = titleTextField.text!.lowercased()
                    }
                }
                
                
                //                    delegate?.recevieCollectionViewReloadData() //딜리게이트
                NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                
                dismiss(animated: true)
                
                
            }
            
        }
        
    }
    
    
    func receiveMetaData(url: String) {
        activateButton = false
        MetaData.fetchMetaData(for: (URL(string: url) ?? URL(string: "url" )!) ) {  metadata in
            
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
                                self.temporaryTitleData = metadata.title
                                
                                linkUnderBarUIView.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
                                warningLinkLabel.isHidden = true
                                showAlertHandle()
                           
                                activateButton = true
                                linkPasteButton.configuration?.showsActivityIndicator = false
                                linkPasteButton.configuration?.image = UIImage(systemName: "checkmark")
                                linkPasteButton.isEnabled = false
                            }
                            
                        } else {
                            print("no image available")
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.temporaryTitleData = metadata.title
                        showAlertHandle()
                   
                        activateButton = true
                        linkUnderBarUIView.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
                        linkPasteButton.configuration?.showsActivityIndicator = false
                        linkPasteButton.configuration?.image = UIImage(systemName: "checkmark")
                        linkPasteButton.isEnabled = false
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
            pasteButtonSetup()
            print(errorLabelText)
            showAlert(err: errorLabelText, message: "")
        }
    }
    
    func showAlert(err: String, message: String) {
           
           let alert = UIAlertController(title: err, message: message, preferredStyle: .alert)
           let ok = UIAlertAction(title: "확인", style: .default)
           alert.addAction(ok)
           present(alert, animated: true)
       }
            func showtoast(title: String) {
                self.view.makeToast(title, duration: 1.5,
                                    position: .center)
            }
            
            
    func showAlertHandle() {
        
        let alertController = UIAlertController(title: "제목을 자동생성 하시겠습니까?", message: nil, preferredStyle: .alert)
        let actionDefault = UIAlertAction(title: "네", style: .default) { [self] action in
            self.titleTextField.text = self.temporaryTitleData
            linkViewModel.linkTitle.value = String(titleTextField.text!.prefix(30))
            titleTextCountLabel.text = "\(titleTextField.text?.count ?? 0)/30"
            titleUnderBarUIView.backgroundColor = UIColor(named: "reversedSystemBackgroundColor")
            warningTitleLabel.isHidden = true
            linkViewModel.checkValidation()
        }
        
        let actionCancel = UIAlertAction(title: "아니오", style: .destructive)
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionDefault)
        self.present(alertController, animated: true)
    }
    
    func pasteButtonSetup() {
        linkPasteButton.configuration?.attributedTitle = AttributedString("불러오기")
        linkPasteButton.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ attr in
            var new = attr
            
            new.font = .systemFont(ofSize: 15, weight: .bold)
                        
                        
            return new
        })
    }
    
    
    
    override func configure() {
        super.configure()
        
        view.addSubview(linkTitleLabel)
        view.addSubview(linkTextField)
        view.addSubview(linkUnderBarUIView)
        view.addSubview(warningLinkLabel)
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleUnderBarUIView)
        view.addSubview(warningTitleLabel)
        
        view.addSubview(titleTextCountLabel)
        view.addSubview(memoTitleLabel)
        view.addSubview(memoTextView)
        view.addSubview(memoTextCountLabel)
        
        view.addSubview(addButton)
        view.addSubview(linkPasteButton)
        
        
        
        
    }
    
    override func setContraints() {
        super.setContraints()
        
        linkTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.17)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.04)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        linkTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(linkTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(linkPasteButton.snp.leading).offset(-8)
        }
        linkUnderBarUIView.snp.makeConstraints { make in
            make.width.equalTo(linkTextField.snp.width)
            make.height.equalTo(0.7)
            make.top.equalTo(linkTextField.snp.bottom)
            make.centerX.equalTo(linkTextField)
        }
        linkPasteButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(linkTextField)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        warningLinkLabel.snp.makeConstraints { make in
            make.width.equalTo(linkTextField.snp.width)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(linkTextField.snp.height).multipliedBy(0.5)
            make.top.equalTo(linkTextField.snp.bottom).offset(4)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(linkTitleLabel.snp.width)
            make.height.equalTo(linkTitleLabel.snp.height)
            make.top.equalTo(linkTextField.snp.bottom).offset(55)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(linkTextField.snp.height)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        titleUnderBarUIView.snp.makeConstraints { make in
            make.width.equalTo(titleTextField.snp.width)
            make.height.equalTo(0.7)
            make.bottom.equalTo(titleTextField.snp.bottom)
            make.centerX.equalTo(titleTextField)
         
        }
        
        warningTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(titleTextField.snp.width).multipliedBy(0.7)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(titleTextField.snp.height).multipliedBy(0.5)
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
        }
        
        titleTextCountLabel.snp.makeConstraints { make in
            make.width.equalTo(titleTextField.snp.width).multipliedBy(0.1)
            make.height.equalTo(titleTextField.snp.height).multipliedBy(0.5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(titleTextField.snp.bottom)
        
        }
  

        memoTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(linkTitleLabel.snp.width)
            make.height.equalTo(linkTitleLabel.snp.height)
            make.top.equalTo(titleTextField.snp.bottom).offset(55)
        }
        
        memoTextCountLabel.snp.makeConstraints { make in
            
            make.width.equalTo(titleTextField.snp.width).multipliedBy(0.11)
            make.height.equalTo(titleTextField.snp.height).multipliedBy(0.51)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(memoTextView.snp.bottom)

        }
        memoTextView.snp.makeConstraints { make in
          
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.115)
        }
     
        addButton.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.06)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
  
    
}


