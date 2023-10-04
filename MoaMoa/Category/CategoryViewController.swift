//
//  CategoryViewController.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/01.
//

import UIKit
import RealmSwift

class CategoryViewController: BaseViewController {
    
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
  
    let categoryCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let spacing : CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        view.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(CateGoryRealm.self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCategory))
        categoryCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryCollectionView.reloadData()
    }
    
    @objc func addCategory() {
        
        navigationController?.pushViewController(AddCategoryViewController(), animated: true)
    }
    
    
    override func configure() {
        super.configure()
        view.addSubview(categoryCollectionView)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
    }
    
    override func setContraints() {
        super.setContraints()
        categoryCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}


extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {return UICollectionViewCell()}
        
        let data = list[indexPath.row]
        cell.categoryTitle.text = data.title
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
      
        guard let indexPath = indexPaths.first else { return nil }
        if indexPath.row >= 2 {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                
                
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                }
                
                let deleteAction = UIAction(title: "삭제", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [modifyAction, deleteAction])
                
            }
            return config
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailCategoryCollectionView()
        let allCategoryId = String(describing: realm.objects(CateGoryRealm.self).first?._id)
        let categoryId = String(describing: realm.objects(CateGoryRealm.self)[indexPath.row]._id)
    
        if indexPath.row == 0 {
            
            navigationController?.pushViewController(AllCategoryViewController(), animated: true)
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(LikeCategoryViewController(), animated: true)
        } else {
            
            vc.pk = categoryId
            navigationController?.pushViewController(vc, animated: true)
       
         
        }
        
    }
    
    
    
}