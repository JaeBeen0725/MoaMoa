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
    let searchController = UISearchController(searchResultsController: nil)
    
    let homeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let spacing : CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        
      
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        searchBar()
        addLink()
        detailCategory = realm.objects(detailCateGory.self)
       
        print(realm.configuration.fileURL)
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewReloadData), name: NSNotification.Name("reloadData") ,object: nil)
       
    }
    @objc func collectionViewReloadData() {
        homeCollectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
   
    func searchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search link"
   
    }
    
    func addLink() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLinkButtonTapped))
    }
    @objc func addLinkButtonTapped() {
        let vc = AddLink(delegate: self, categoryPK: nil)
    
        
       present(vc, animated: true)
    }

    
    override func configure() {
        super.configure()
        view.addSubview(homeCollectionView)
        homeCollectionView.backgroundColor = .systemBackground
        homeCollectionView.keyboardDismissMode = .onDrag
        
        
    }
  

    override func setContraints() {
        super.setContraints()
        
        homeCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = detailCategory.where{
            $0.onlyAll == true
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
        UserDefaults.standard.set(resultData.link, forKey: "aa")
            
            let config = UIContextMenuConfiguration(identifier: indexPath.row as Int as NSCopying, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: linkLike ? "즐겨찾기 해제" : "즐겨찾기", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                        try! self.realm.write {
                            
                            for i in 0...detailData.count - 1{
                                detailData[i].likeLink.toggle()
                            }
                        }
                        collectionView.reloadData()
                    }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let vc = ModifyLinkViewcontroller(fk: resultData._id, delegate: self)

                    self.present(vc, animated: true)
                }
                let addToAnotherCategory = UIAction(title: "카테고리에 추가", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    
                    let vc = AddToAnotherCategoryViewController(fk: resultData._id)
                    
                    self.present(vc, animated: true)
  
                }
                
              
                let realdeletAction = UIAction(title: "삭제", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { _ in
                    let deleteData = self.detailCategory.where {
                        $0.fk == resultData._id
                    }
                    
                    try! self.realm.write {
                        self.realm.delete(deleteData)
           
                    }
                    collectionView.reloadData()
                }
                let parentsRealdeletMenu = UIMenu(options: .displayInline, children: [realdeletAction])
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [likeAction, modifyAction,addToAnotherCategory, parentsRealdeletMenu])
            }
        
            return config
       
        
        
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
        
        if let existingMetaData = MetaDataCache.retrieve(urlString: data.reversed()[indexPath.row].link) {
            
            existingMetaData.imageProvider?.loadObject(ofClass: UIImage.self) { (image, error) in
                    guard error == nil else {
                        return
                    }
                    if let image = image as? UIImage {
                        
                        DispatchQueue.main.async {
                            
                            cell.thumbnailImageView.image = image
                            cell.titleLabel.text = existingMetaData.title
                            
                        }

                    } else {
                        print("no image available")
                    }
                }
            
                
            } else {
                MetaData.fetchMetaData(for: URL(string: data.reversed()[indexPath.row].link)!) {  metadata in
                    
                    switch metadata {
                    case .success(let metadata):
                        if let imageProvider = metadata.imageProvider {
                            metadata.iconProvider = imageProvider
                            
                            imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                                guard error == nil else {
                                    return
                                }
                                if let image = image as? UIImage {
                                    
                                    DispatchQueue.main.async {
                                        
                                        cell.thumbnailImageView.image = image
                                        cell.titleLabel.text = metadata.title

                                    }

                                } else {
                                    print("no image available")
                                }
                            }
                        }
                        
                    case .failure(let error):
//                        self.handleFailureFetchMetaData(for: error)
                        print(error)
                    }
                }
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
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            detailCategory = realm.objects(detailCateGory.self)
            guard let text = searchController.searchBar.text else { return }
            let data = detailCategory.where{
                $0.onlyAll == true && $0.title.contains(text)
            }
            let emptyData = detailCategory.where{
                $0.link.contains("$%^$&")
            }
            
            print(data)
            if data.count >= 1 {
                detailCategory = data
                
                homeCollectionView.reloadData()
            } else {
                detailCategory = emptyData
                homeCollectionView.reloadData()
            }
            
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchController.searchBar.text = ""
            detailCategory = realm.objects(detailCateGory.self)
            homeCollectionView.reloadData()
        }
        
        
    }
    
extension HomeViewController: ReloadDataDelegate {
    func recevieCollectionViewReloadData() {
    
            homeCollectionView.reloadData()
        
    }
    
    
}

