//
//  DetailCategoryCollectionView.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift

class DetailCategoryCollectionView: BaseViewController {
    let realm = try! Realm()
    var list: Results<detailCateGory>!
    var pk = ""
    
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
        addLink()
       print("[====]", pk)
        list = realm.objects(detailCateGory.self)
        collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func addLink() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLinkButtonTapped))
    }
    @objc func addLinkButtonTapped() {
        let vc = AddLink()
        vc.pk = pk
        present(vc, animated: true)
        
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    override func setContraints() {
        super.setContraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension DetailCategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        let data = list.where {
            $0.pk == self.pk
        }
       
        print("=====", data)
        return data.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        
        let data = list.where {
            $0.pk == self.pk
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("호호호", indexPath.row)
    }
    
}


