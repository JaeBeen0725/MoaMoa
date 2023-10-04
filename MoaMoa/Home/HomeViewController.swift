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

class HomeViewController: BaseViewController {

    let realm = try! Realm()
    var list: Results<detailCateGory>!
    let searchController = UISearchController(searchResultsController: nil)
    var searchFilter: [String] = []
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
        list = realm.objects(detailCateGory.self)
       
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
        let vc = AddLink()
        vc.modalPresentationStyle = .fullScreen
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
      
        return list.count
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let result = self.list[indexPath.row]
        UserDefaults.standard.set(result.link, forKey: "aa")
        
        if result.likeLink == true {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: "즐겨찾기 해제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        result.likeLink.toggle()
                    }
                    collectionView.reloadData()
                }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    collectionView.reloadData()
                }
                
                let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        self.realm.delete(result)
                    }
                    collectionView.reloadData()
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [likeAction, modifyAction, deleteAction])
            }
            return config
        } else {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: "즐겨찾기", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        result.likeLink.toggle()
                    }
                    collectionView.reloadData()
                }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    collectionView.reloadData()
                }
                
                let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        self.realm.delete(result)
                    }
                    collectionView.reloadData()
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [likeAction, modifyAction, deleteAction])
            }
            return config
        }
              
    }
    
   
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        

        cell.testLabel.text = list[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WebViewController()
        vc.url =  list[indexPath.row].link
    let nav = UINavigationController(rootViewController: vc)
        

        present(nav, animated: true)
       
    }
    
//    func safari() {
//        guard let url = URL(string: "https://www.youtube.com/watch?v=zdXJFzEEAMU") else { return }
//        let safariVC = SFSafariViewController(url: url)
//        // 🔥 delegate 지정 및 presentation style 설정.
//        safariVC.transitioningDelegate = self
//        safariVC.modalPresentationStyle = .pageSheet
//        
//        present(safariVC, animated: true, completion: nil)
//
//    }
//    private func addInteraction(toCell cell: UICollectionViewCell) {
//            let interaction = UIContextMenuInteraction(delegate: self)
//            cell.addInteraction(interaction)
//        print("@@@@",cell)
//    }
    
//    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
//            let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
//                
//                let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
//                    print("edit button clicked")
//                }
//                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
//                    print("delete button clicked")
//                }
//                
//                return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
//                
//            }
//            return context
//        }
    
}


extension HomeViewController:  UISearchBarDelegate, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            guard let text = searchController.searchBar.text else { return }
            let task = list.where {
                $0.title.contains(text)
            }
            
            if task.count >= 1 {
                list = task
                collectionView.reloadData()
            } else {
                collectionView.reloadData()
            }
            
        }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        list = realm.objects(detailCateGory.self)
        collectionView.reloadData()
    }
        
        //    func updateSearchResults(for searchController: UISearchController) {
        //
        //        self.searchFilter = self.list.filter{$0.title.contains(text)}
        //    }
        
    
}
/*
extension HomeViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
      
        return UIContextMenuConfiguration(identifier: nil, previewProvider: ShoppingWebViewController.init) { suggestedActions in
            
            return self.makeDefaultDemoMenu()
            
        }
        
    }
   
    
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            
            if let viewController = animator.previewViewController {
                
                self.show(viewController, sender: ShoppingWebViewController())
                
            }
        
        }
    }
    func makeDefaultDemoMenu() -> UIMenu {

           // Create a UIAction for sharing
           let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
               // Show system share sheet
           }

           // Create an action for renaming
           let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in
               // Perform renaming
           }
        let safari = UIAction(title: "사파리로 보기", image: UIImage(systemName: "square.and.pencil")) { action in
            guard let url = URL(string: "https://www.youtube.com/watch?v=zdXJFzEEAMU") else { return }
            let safariVC = SFSafariViewController(url: url)
            // 🔥 delegate 지정 및 presentation style 설정.
            safariVC.transitioningDelegate = self
            safariVC.modalPresentationStyle = .pageSheet
            
            self.present(safariVC, animated: true, completion: nil)
            
        }

           // Here we specify the "destructive" attribute to show that it’s destructive in nature
           let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
               // Perform delete
           }

           // Create and return a UIMenu with all of the actions as children
           return UIMenu(title: "", children: [share, rename, safari,delete])
       }
    
}


extension HomeViewController: UIViewControllerTransitioningDelegate { }
*/
