//
//  DetailCategoryCollectionView.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit
import RealmSwift
import SafariServices

class DetailCategoryViewController: BaseViewController, UIViewControllerTransitioningDelegate {
    let realm = try! Realm()
    var list: Results<CateGoryRealm>!
    var detailCategory: Results<detailCateGory>!
    var categoryPK: ObjectId?
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
    
    let noLinkLabel = {
        let view = UILabel()
        view.text = "링크가 없습니다."
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.textColor = .gray
        view.textAlignment = .center
        view.backgroundColor = .clear
        return view
    }()
    
    init( categoryPK: ObjectId? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.categoryPK = categoryPK
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(CateGoryRealm.self)
        showCategoryTitle()
        
     
        addLink()
        print(#function)
        detailCollectionView.reloadData()
        detailCategory = realm.objects(detailCateGory.self)
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewReloadData), name: NSNotification.Name("reloadData") ,object: nil)
        
      
    }
    func showCategoryTitle() {
        let categoryTitle = list.where {
            $0._id == categoryPK!
        }
    
        title  = categoryTitle.first?.title
    }
    
    
    @objc func collectionViewReloadData() {
        detailCollectionView.reloadData()
    
    }
   
    func addLink() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLinkButtonTapped))
    }
    @objc func addLinkButtonTapped() {
        let vc = AddLink(delegate: self, categoryPK: categoryPK)
        present(vc, animated: true)
        
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(detailCollectionView)
        view.addSubview(noLinkLabel)
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
    }
    
    
    override func setContraints() {
        super.setContraints()
        
        detailCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noLinkLabel.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "offMemo"), object: nil)
    }
}

extension DetailCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        let data = self.list.where {
            $0._id == self.categoryPK!
        }
     
        if data.first!.detail.count == 0 {
            noLinkLabel.isHidden = false
        } else {
            noLinkLabel.isHidden = true
        }
        return data.first!.detail.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        
        let category = list.where {
            $0._id == self.categoryPK!
        }
        let result = category.first!.detail.reversed()[indexPath.row]
     
            
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
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                        collectionView.reloadData()
                    }
                
               
                let addToAnotherCategory = UIAction(title: "카테고리에 추가", subtitle: nil, image: UIImage(systemName: "rectangle.badge.plus"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    
                    let vc = AddToAnotherCategoryViewController(fk: resultData._id)
                    let nav = UINavigationController(rootViewController: vc)
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                    self.present(nav, animated: true)
  
                }
                
                let shareData = UIAction(title: "공유", subtitle: nil, image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    var shareList = [Any]()
                    shareList.append(shareUrl ?? "")
               
                    let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0))
                    self.showActivityVC(self, activityItems: shareList, sourceRect: cell!.frame)
  
                        
                }
                let modifyAction = UIAction(title: "편집", subtitle: nil, image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let vc = AddLink(delegate: self, fk: resultData._id)
                    let nav = UINavigationController(rootViewController: vc)
                    
                    self.present(nav, animated: true)
                }
                
                let deletInrCategory = UIAction(title: "카테고리에서 삭제", subtitle: nil, image: UIImage(systemName: "rectangle.badge.minus"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    let category = self.list.where {
                        $0._id == self.categoryPK!
                    }
                    
                    let categoryData = category.first!.detail.reversed()[indexPath.row]
                   
                    
                    try! self.realm.write{
                        self.realm.delete(categoryData)
                    }
                    NotificationCenter.default.post(name:Notification.Name("reloadData"), object: nil )
                    collectionView.reloadData()
                }
                
              
                let realdeletAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { _ in
                    let deleteData = self.detailCategory.where {
                        $0.fk == resultData.fk
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
                              children: [likeAction, shareData,modifyAction, addToAnotherCategory, deletInrCategory, parentsRealdeletMenu])
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

extension DetailCategoryViewController: ReloadDataDelegate {
    func recevieCollectionViewReloadData() {
        detailCollectionView.reloadData()
    }
    
    
}


