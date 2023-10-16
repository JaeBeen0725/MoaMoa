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
        let spacing : CGFloat = 5
        let width = UIScreen.main.bounds.width - (spacing * 3)
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        view.backgroundColor = UIColor(named: "BackgroundColor")
        layout.itemSize = CGSize(width: width / 2, height: width / 1.7)
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "offMemo"), object: nil)
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
        let result = data.reversed()[indexPath.row]
        
       
        cell.thumbnailImageView.image = self.loadImageFromDocument(fileName: "\(result.fk)")
        cell.titleLabel.text = result.title
        cell.memoLabel.text = result.memo
    
        if result.likeLink == true {
            cell.likeImage.image = UIImage(systemName: "heart.fill")
        } else {
            cell.likeImage.image = nil
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
        let shareUrl = URL(string: resultData.link)
        
        UserDefaults.standard.set(resultData.link, forKey: "aa")
            
            let config = UIContextMenuConfiguration(identifier: indexPath.row as Int as NSCopying, previewProvider: WebViewController.init) { _ in
                
                let likeAction = UIAction(title: linkLike ? "즐겨찾기 해제" : "즐겨찾기", subtitle: nil, image: linkLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    try! self.realm.write {
                        
                        for i in 0...detailData.count - 1{
                            detailData[i].likeLink.toggle()
                        }
                    }
                        collectionView.reloadData()
                    
                }
                    
                let addToAnotherCategory = UIAction(title: "카테고리에 추가", subtitle: nil, image: UIImage(systemName: "rectangle.badge.plus"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    
                    let vc = AddToAnotherCategoryViewController(fk: resultData._id)
                    
                    self.present(vc, animated: true)
  
                }
              
                
                let shareData = UIAction(title: "공유", subtitle: nil, image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    var shareList = [Any]()
                    shareList.append(shareUrl ?? "")
               
                    let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0))
                    self.showActivityVC(self, activityItems: shareList, sourceRect: cell!.frame)
  
                        
                }
               
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let vc = AddLink(delegate: self, fk: resultData._id)

                    self.present(vc, animated: true)
                }
              
                let realdeletAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { _ in
                    let deleteData = self.detailCategory.where {
                        $0.fk == resultData._id
                    }
                    self.removeImageFromDocument(fileName: "\(resultData._id)")
                    try! self.realm.write {
                        self.realm.delete(deleteData)
           
                    }
                    collectionView.reloadData()
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                }
                let parentsRealdeletMenu = UIMenu(options: .displayInline, children: [realdeletAction])
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline,
                              children: [likeAction, addToAnotherCategory ,shareData, modifyAction, parentsRealdeletMenu])
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


