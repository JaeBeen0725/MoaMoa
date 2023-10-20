//
//  ViewController.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/09/27.
//

import UIKit
import SnapKit
import RealmSwift
import SafariServices



class HomeViewController: BaseViewController, UIViewControllerTransitioningDelegate {
    
    let realm = try! Realm()
    
    var detailCategory: Results<detailCateGory>!
    let linkSearchBar = UISearchBar()

    let largeTitleLabel = {
        let view = UILabel()
        view.text = "모아모아"
        view.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        view.backgroundColor = .clear
        
        return view
    }()
    
    let homeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let spacing : CGFloat = 16
        let width = UIScreen.main.bounds.width - (spacing * 3)
        
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.alwaysBounceVertical = true
        layout.itemSize = CGSize(width: width / 2, height: width / 1.7)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        return view
    }()
    
    let noLinkLabel = {
        let view = UILabel()
        view.text = "링크가 없습니다."
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.textColor = .gray
        view.textAlignment = .center
        view.backgroundColor = .clear
        return view
    }()
    
   lazy var addLinkButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
               let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
               
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.backgroundColor = UIColor(named: "SignatureColor")
        view.layer.cornerRadius = view.layer.frame.size.width / 2
        view.clipsToBounds = true
        
   
        return view
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addLinkButton.layer.cornerRadius = addLinkButton.layer.frame.size.width / 2
        addLinkButton.clipsToBounds = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: largeTitleLabel)
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "reversedSystemBackgroundColor")
        
       
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        searchBar()
        addLink()
        
        detailCategory = realm.objects(detailCateGory.self)
     
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchbuttonTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewReloadData), name: NSNotification.Name("reloadData") ,object: nil)
    }
    
    @objc func searchbuttonTapped() {
        navigationController?.pushViewController(HomeSearchViewController(), animated: true)
        
    }
    
    @objc func collectionViewReloadData() {
        homeCollectionView.reloadData()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        navigationItem.hidesSearchBarWhenScrolling = true
//        
//    }
    
   
    func searchBar() {
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "reversedSystemBackgroundColor")]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as [NSAttributedString.Key : Any] , for: .normal)
        //linkSearchBar.backgroundColor = .red//UIColor(named: "BackgroundColor")
        linkSearchBar.barTintColor = UIColor(named: "BackgroundColor")
        linkSearchBar.showsCancelButton = true
        linkSearchBar.delegate = self
        linkSearchBar.placeholder = "Search link"
        
        self.linkSearchBar.searchBarStyle = .minimal
        
//        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func addLink() {
 
        addLinkButton.addTarget(self, action: #selector(addLinkButtonTapped), for: .touchUpInside)
    }
    @objc func addLinkButtonTapped() {
        let vc = AddLinkViewController(/*delegate: self, */categoryPK: nil)//딜리게이트
        let nav = UINavigationController(rootViewController: vc)
        
       present(nav, animated: true)
    }

    
    override func configure() {
        super.configure()

        view.addSubview(homeCollectionView)
//        view.addSubview(linkSearchBar)
        view.addSubview(noLinkLabel)
        view.addSubview(addLinkButton)
        homeCollectionView.keyboardDismissMode = .onDrag
        
        
    }

    override func setContraints() {
        super.setContraints()
   
//        linkSearchBar.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//            make.height.equalTo(38)
//        
//        }
        homeCollectionView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
//            make.top.equalTo(linkSearchBar.snp.bottom)
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        noLinkLabel.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addLinkButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
        }
        
        
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = detailCategory.where{
            $0.onlyAll == true
        }
        if data.count == 0 {
            noLinkLabel.isHidden = false
        } else {
            noLinkLabel.isHidden = true
        }
        
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let data = detailCategory.where{
            $0.onlyAll == true
        }
        let resultData = data.reversed()[indexPath.row]
        let linkLike =  data.reversed()[indexPath.row].likeLink
        let detailData = self.detailCategory.where {
            $0.fk == resultData._id
        }
        let shareUrl = URL(string: resultData.link)
        UserDefaults.standard.set(resultData.link, forKey: "aa")
            
            let config = UIContextMenuConfiguration(identifier: indexPath.row as Int as NSCopying, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: linkLike ? "즐겨찾기 해제" : "즐겨찾기", subtitle: nil, image: linkLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                        try! self.realm.write {
                            
                            for i in 0...detailData.count - 1{
                                detailData[i].likeLink.toggle()
                            }
                        }
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                    
                    }
                let addToAnotherCategory = UIAction(title: "카테고리에 추가", subtitle: nil, image: UIImage(systemName: "rectangle.badge.plus"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    let vc = AddToAnotherCategoryViewController(fk: resultData._id)
                    let nav = UINavigationController(rootViewController: vc)
                    
                    self.present(nav, animated: true)
  
                }
                
                let shareData = UIAction(title: "공유", subtitle: nil, image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    var shareList = [Any]()
                    shareList.append(shareUrl ?? "")
               
                    let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0))
                    self.showActivityVC(self, activityItems: shareList, sourceRect: cell!.frame)
  
                        
                }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let vc = AddLinkViewController(/*delegate: self, */fk: resultData._id) //딜리게이트
                    let nav = UINavigationController(rootViewController: vc)
                    
                    self.present(nav, animated: true)
                }
               
                
              
                let realdeletAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { _ in
                    self.removeImageFromDocument(fileName: "\(resultData._id)")
                    let deleteData = self.detailCategory.where {
                        $0.fk == resultData._id
                    }
                    
                    try! self.realm.write {
                        self.realm.delete(deleteData)
           
                    }
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                }
                let parentsRealdeletMenu = UIMenu(options: .displayInline, children: [realdeletAction])
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [likeAction,addToAnotherCategory, shareData,modifyAction, parentsRealdeletMenu])
            }
        
            return config
       
        
            
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "offMemo"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
        
           if let identifier = configuration.identifier as? Int {
              
               self.goSafari(indexPath: identifier)
           
            }
     
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        let data = detailCategory.where{
            $0.onlyAll == true
        }
        let result = data.reversed()[indexPath.row]
        
        
        cell.thumbnailImageView.image = self.loadImageFromDocument(fileName: "\(result._id)")
        cell.titleLabel.text = result.title
        cell.memoLabel.text = result.memo
    
        if result.likeLink == true {
            cell.likeImage.image = UIImage(systemName: "heart.fill")
        } else {
            cell.likeImage.image = nil
        }
    
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goSafari(indexPath: indexPath.row)
                
    }
    
    func goSafari(indexPath : Int) {
        let data = self.detailCategory.where{
            $0.onlyAll == true
        }
        guard let url = URL(string: data.reversed()[indexPath].link  ) else { return }
         let safariVC = SFSafariViewController(url: url)
         safariVC.transitioningDelegate = self
         safariVC.modalPresentationStyle = .pageSheet
         
         self.present(safariVC, animated: true, completion: nil)
    }
    
  
 
    
}
    
    
    extension HomeViewController:  UISearchBarDelegate, UISearchControllerDelegate {
        func updateSearchResults(for searchController: UISearchController) {
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            detailCategory = realm.objects(detailCateGory.self)
            guard let lowercasedText = searchBar.text else { return }
        
            let data = detailCategory.where {
                $0.onlyAll == true && $0.searchTitle.contains(lowercasedText.lowercased())
            }
          
            
            let emptyData = detailCategory.where{
                $0.link.contains("$%^$&")
            }
            
//            print(data)
            if data.count >= 1 {
                detailCategory = data
                
                homeCollectionView.reloadData()
            } else {
                detailCategory = emptyData
                homeCollectionView.reloadData()
            }
            
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            let emptyData = detailCategory.where{
                $0.link.contains("$%^$&")
            }
            detailCategory = emptyData
            homeCollectionView.reloadData()
        }
        
        
    }
    
 
    
}


