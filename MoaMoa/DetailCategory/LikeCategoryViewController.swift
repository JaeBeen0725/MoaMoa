//
//  LikeCategory.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift
import SafariServices

class LikeCategoryViewController: BaseViewController, UIViewControllerTransitioningDelegate {

    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    var detailCategory: Results<detailCateGory>!
  
    let detailCollectionView = {
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
     
     
        list = realm.objects(CateGoryRealm.self)
        detailCollectionView.reloadData()
        detailCategory = realm.objects(detailCateGory.self)
    }
  
    override func configure() {
        super.configure()
        
        view.addSubview(detailCollectionView)
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
    }
    
    
    override func setContraints() {
        super.setContraints()
        
        detailCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension LikeCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        let data = self.detailCategory.where {
            $0.onlyAll == true && $0.likeLink == true
        }
   
        return data.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        
        let data = self.detailCategory.where {
            $0.onlyAll == true && $0.likeLink == true
        }
        let detailData = data.reversed()[indexPath.row]
        if let existingMetaData = MetaDataCache.retrieve(urlString: detailData.link) {
            
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
                MetaData.fetchMetaData(for: URL(string: detailData.link)!) { metadata in
                    
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let data = detailCategory.where{
            $0.onlyAll == true
        }
        let resultData = data.reversed()[indexPath.row]
        let linkLike =  data.reversed()[indexPath.row].likeLink
        let detailData = detailCategory.where {
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

extension LikeCategoryViewController: ReloadDataDelegate {
    func recevieCollectionViewReloadData() {
        detailCollectionView.reloadData()
    }
    
    
}


