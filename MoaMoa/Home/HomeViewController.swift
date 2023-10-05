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
    
    var result: Results<detailCateGory>!
    let searchController = UISearchController(searchResultsController: nil)
    
    let collectionView = {
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
        searchBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addLink() 
        result = realm.objects(detailCateGory.self)
       
        print(realm.configuration.fileURL)
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    func searchBar() {
        
        navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search link"
   
    }
    
    func addLink() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLinkButtonTapped))
    }
    @objc func addLinkButtonTapped() {
        let vc = AddLink(beforeCollectionView: collectionView)

       present(vc, animated: true)
    }

    
    override func configure() {
        super.configure()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .brown
        
    }

    override func setContraints() {
        super.setContraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = result.where{
            $0.onlyAll == true
        }
        
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let data = result.where{
            $0.onlyAll == true
        }
        let detailData = self.result.where {
            $0.fk == String(describing: data[indexPath.row]._id)
        }
        UserDefaults.standard.set(data[indexPath.row].link, forKey: "aa")
        
        if data[indexPath.row].likeLink == true {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: "즐겨찾기 해제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    try! self.realm.write {
                        data[indexPath.row].likeLink.toggle()
                        for i in 0...detailData.count - 1{
                            detailData[i].likeLink.toggle()
                        }
                    }
                    collectionView.reloadData()
                }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let vc = ModifyLinkViewcontroller(beforeCollectionView: collectionView)

                    self.present(vc, animated: true)
                    collectionView.reloadData()
                }
                
                let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    
                    try! self.realm.write {
                        self.realm.delete(detailData)
                        self.realm.delete(data[indexPath.row])
                        
                    }
                    collectionView.reloadData()
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [likeAction, modifyAction, deleteAction])
            }
            return config
        } else {
            
            
            let config = UIContextMenuConfiguration(identifier: indexPath.row as Int as NSCopying, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: "즐겨찾기", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        data[indexPath.row].likeLink.toggle()
                        for i in 0...detailData.count - 1{
                            detailData[i].likeLink.toggle()
                        }
                    }
                    collectionView.reloadData()
                }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let vc = ModifyLinkViewcontroller(beforeCollectionView: collectionView)
                    vc.pk = data[indexPath.row]._id
                    self.present(vc, animated: true)
                    
                    collectionView.reloadData()
                }
                
                let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let deleteData = self.result.where {
                        $0.fk == String(describing: data[indexPath.row]._id)
                    }
                    
                    try! self.realm.write {
                        self.realm.delete(deleteData)
                        self.realm.delete(self.result[indexPath.row])
                        
                    }
                    collectionView.reloadData()
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [likeAction, modifyAction, deleteAction])
            }
            return config
        }
        
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
        let data = result.where{
            $0.onlyAll == true
        }
        
        cell.testLabel.text = data[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goSafari(indexPath: indexPath.row)
                
    }
    
    func goSafari(indexPath : Int) {
        let data = self.result.where{
            $0.onlyAll == true
        }
        guard let url = URL(string: data[indexPath].link  ) else { return }
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
            result = realm.objects(detailCateGory.self)
            guard let text = searchController.searchBar.text else { return }
            let data = result.where{
                $0.onlyAll == true && $0.title.contains(text)
            }
            let emptyData = result.where{
                $0.fk.contains("비어있다")
            }
            
            print(data)
            if data.count >= 1 {
                result = data
                
                collectionView.reloadData()
            } else {
                result = emptyData
                collectionView.reloadData()
            }
            
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchController.searchBar.text = ""
            result = realm.objects(detailCateGory.self)
            collectionView.reloadData()
        }
        
        
    }
    

