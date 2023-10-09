////
////  MetaController.swift
////  MoaMoa
////
////  Created by Jae Oh on 2023/10/08.
////
//
//import UIKit
//import SnapKit
//
//
//
//final class SearchViewController: UIViewController {
//    
//    private  var stackView = UIStackView()
//    //  private var errorLabel = UILabel()
//    private var urlInputTextField = UITextField()
//    private let activityIndicator = UIActivityIndicatorView()
//    private var linkView = {
//        let view = LPLinkView()
//        
//        return view
//    }()
//    let testLabel = UILabel()
//    var testImage = UIImageView()
//    let searchButton = UIButton()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
////        setUpUI()
//        view.addSubview(stackView)
//        //  view.addSubview(errorLabel)
//        view.addSubview(urlInputTextField)
//        view.addSubview(searchButton)
//        view.addSubview(testLabel)
//        view.addSubview(testImage)
//        testLabel.backgroundColor = .brown
//        testImage.backgroundColor = .red
//        setConstraints()
//        urlInputTextField.backgroundColor = .white
//        searchButton.backgroundColor = .gray
//        fetchMetaData(for: URL(string: "https://n.news.naver.com/article/001/0014250376")!)
////        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
//    }
//    
//    func setConstraints() {
//        stackView.snp.makeConstraints { make in
//            make.size.equalTo(300)
//            make.center.equalTo(view.safeAreaLayoutGuide)
//        }
//        testLabel.snp.makeConstraints { make in
//            make.height.equalTo(50)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalTo(stackView.snp.top).offset(20)
//        }
//        testImage.snp.makeConstraints { make in
//            make.height.equalTo(150)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalTo(testLabel.snp.top).offset(10)
//        }
//        urlInputTextField.snp.makeConstraints { make in
//            make.width.equalTo(400)
//            
//            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//        }
//        searchButton.snp.makeConstraints { make in
//            make.size.equalTo(60)
//            make.leading.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalTo(urlInputTextField.snp.top)
//        }
//    }
//    
////    @objc private func searchButtonDidTap() {
////        hideErrorLabel()
////        activityIndicator.startAnimating()
////        if let requestUrl = urlInputTextField.text {
////            setUpLinkView(for: requestUrl)
////        }
////    }
//    
////    private func setUpUI() {
////        hideErrorLabel()
////        stackView.insertArrangedSubview(activityIndicator, at: 0)
////    }
////    
////    private func hideErrorLabel() {
////        //   errorLabel.isHidden = true
////    }
////    
////    private func setUpLinkView(for stringUrl: String) {
////        guard let url = URL(string: stringUrl) else {
////            handleFailureFetchMetaData()
////            return
////        }
////        
////        linkView.removeFromSuperview()
////        linkView = LPLinkView(url: url)
////        fetchMetaData(for: url)
////        self.stackView.insertArrangedSubview(linkView, at: 0)
////    }
//    
//    private func fetchMetaData(for url: URL) {
//        if let existingMetaData = MetaDataCache.retrieve(urlString: url.absoluteString) {
//            linkView = LPLinkView(metadata: existingMetaData)
//            activityIndicator.stopAnimating()
//        } else {
//            MetaData.fetchMetaData(for: url) { [weak self] metadata in
//                guard let self = self else { return }
//                switch metadata {
//                case .success(let metadata):
//                    if let imageProvider = metadata.imageProvider {
//                        metadata.iconProvider = imageProvider
//                        
//                        imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                            guard error == nil else {
//                                return
//                            }
//                            if let image = image as? UIImage {
//                                
//                                DispatchQueue.main.async { [weak self] in
//                                    guard let self = self else { return }
//                                    
//                                    self.activityIndicator.stopAnimating()
//                                    // self.linkView.metadata = metadata
//                                    self.testLabel.text = metadata.title
//                                    self.testImage.image = image
//                                    
//                                }
//
//                            } else {
//                                print("no image available")
//                            }
//                        }
//                    }
//                    
//                case .failure(let error):
//                    self.handleFailureFetchMetaData(for: error)
//                }
//            }
//        }
//    }
//    
//    private func handleFailureFetchMetaData(for error: LPError? = nil) {
//        //        let errorLabelText = error?.prettyString ?? "잘못된 URL입니다. 다시 입력해주세요!"
//        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            self.activityIndicator.stopAnimating()
//            self.linkView.removeFromSuperview()
//            //    self.errorLabel.text = errorLabelText
//            //  self.errorLabel?.isHidden = false
//        }
//    }
//}
