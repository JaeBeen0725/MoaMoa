//
//  LikeCategory.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift

class LikeCategoryViewController: BaseViewController {

    let realm = try! Realm()
    var list: Results<detailCateGory>!
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
        
        list = realm.objects(detailCateGory.self)
        collectionView.delegate = self
        collectionView.dataSource = self
      
        searchBar()
        addLink()
       
          
      
        
        collectionView.reloadData()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    func searchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search link"
   
    }
    
    func addLink() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLinkButtonTapped))
    }
    @objc func addLinkButtonTapped() {
        navigationController?.pushViewController(AddLink(), animated: true)
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

extension LikeCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let data = list.where {
            $0.likeLink == true
        }
        print(data)
        
        return  data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        let data = list.where {
            $0.likeLink == true
        }
        
        cell.testLabel.text = data[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
              let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                  
                  let shareAction = UIAction(title: "공유", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                      
                  }
                  
                  let likeAction = UIAction(title: "즐겨찾기", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                      
                  }
                  
                  let addCategoryAction = UIAction(title: "카테고리에 추가", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                      
                  }
                  
                  let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                      
                  }
                      
                  let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                      
                  }
                  
                  return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [shareAction, likeAction, addCategoryAction, modifyAction, deleteAction])
              }
              return config
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = WebViewController()
//        vc.url =  list[indexPath.row].link
//    let nav = UINavigationController(rootViewController: vc)
//        
//
//        present(nav, animated: true)
//       
//    }
    
    
    
    
}


