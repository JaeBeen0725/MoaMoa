//
//  AllCategoryViewController.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift

class AllCategoryViewController: BaseViewController {
    
 
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

extension AllCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        
         UserDefaults.standard.set(result[indexPath.row].link, forKey: "aa")
        
        if result[indexPath.row].likeLink == true {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: "즐겨찾기 해제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        self.result[indexPath.row].likeLink.toggle()
                    }
                    collectionView.reloadData()
                }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    collectionView.reloadData()
                }
                
                let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let deleteData = self.result.where {
                        $0.fk == data[indexPath.row]._id
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
        } else {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: "즐겨찾기", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        self.result[indexPath.row].likeLink.toggle()
                    }
                    collectionView.reloadData()
                }
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    collectionView.reloadData()
                }
                
                let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let deleteData = self.result.where {
                        $0.fk == data[indexPath.row]._id
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
    
   
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        let data = result.where{
            $0.onlyAll == true
        }

        cell.testLabel.text = data[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WebViewController()
        let data = result.where{
            $0.onlyAll == true
        }
     
        vc.url =  data[indexPath.row].link
    let nav = UINavigationController(rootViewController: vc)
        

        present(nav, animated: true)
       
    }
    

    
}

