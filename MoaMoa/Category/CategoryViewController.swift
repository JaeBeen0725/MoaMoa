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
    var resultt: Results<detailCateGory>!

    let addCategoryViewModel = AddCategoryViewModel()
    
    let largeTitleLabel = {
        let view = UILabel()
        view.text = "카테고리"
        view.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        view.backgroundColor = .clear
        
        return view
    }()
    let categoryCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let spacing : CGFloat = 16
        let width = UIScreen.main.bounds.width - (spacing * 3)
        
        view.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.alwaysBounceVertical = true
        layout.itemSize = CGSize(width: width / 2, height: width / 1.7)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        return view
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "카테고리"
//        navigationItem.title = "카테고리"
//        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: largeTitleLabel)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "reversedSystemBackgroundColor")
        
        list = realm.objects(CateGoryRealm.self)
        resultt = realm.objects(detailCateGory.self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCategory))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewReloadData), name: NSNotification.Name("reloadData") ,object: nil)
    }
    
    
    @objc func collectionViewReloadData() {
        categoryCollectionView.reloadData()
    }

    
   

    
    @objc func addCategory() {       
        let vc =  AddCategoryView()
      
        vc.modalPresentationStyle = .overFullScreen
     
        present( vc, animated: true)
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
//            make.top.equalTo(largeTitleLabel.snp.bottom)
//            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
        let likeData = resultt.where{
            $0.likeLink == true
        }
        if indexPath.row == 1 {
            if likeData.count == 0 {
                cell.thumbnailImageView.image = nil
                cell.categoryTitle.text = data.title
            } else {
                cell.thumbnailImageView.image = self.loadImageFromDocument(fileName: String(describing: likeData.last!.fk))
                cell.categoryTitle.text = data.title
            }
        } else {
            
            if let thumbnailImageData = data.detail.last {
                cell.thumbnailImageView.image = self.loadImageFromDocument(fileName: String(describing: thumbnailImageData.fk))
                cell.categoryTitle.text = data.title
            } else {
                cell.thumbnailImageView.image = nil
                cell.categoryTitle.text = data.title
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
      
        guard let indexPath = indexPaths.first else { return nil }
        if indexPath.row >= 2 {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                
                
                let modifyAction = UIAction(title: "카테고리 이름 변경", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let vc = AddCategoryView()
                    vc.addCategoryViewModel.categoryPk = self.list[indexPath.row]._id
//
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
                
                let deleteCategory = UIAction(title: "카테고리 삭제", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { _ in
                    let data = self.list[indexPath.row].detail
                    
                    try! self.realm.write{
                        self.realm.delete(data)
                        self.realm.delete(self.list[indexPath.row])
                    }
                    collectionView.reloadData()
                }
                let parentsRealdeletMenu = UIMenu(options: .displayInline, children: [deleteCategory])
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [modifyAction, parentsRealdeletMenu])
                
            }
            return config
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
    
        if indexPath.row == 0 {
            let vc = AllCategoryViewcontroller()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(LikeCategoryViewController(), animated: true)
        } else {
            let vc = DetailCategoryViewController(categoryPK: list[indexPath.row]._id)
      
        
            navigationController?.pushViewController(vc, animated: true)
       
         
        }
        
    }
    
}

//extension CategoryViewController: ReloadDataDelegate { //딜리게이트 
//    func recevieCollectionViewReloadData() {
//        categoryCollectionView.reloadData()
//    }
//    
//    
//}
