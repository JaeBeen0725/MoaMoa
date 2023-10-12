//
//  Layout+Extension.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/11.
//

import UIKit


extension UIViewController {
    
    func collectionViewSetup<T: UICollectionView>(collectionView: T) -> UICollectionView {
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
    }
    
    
}


//    let collectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        let spacing : CGFloat = 8
//        let width = UIScreen.main.bounds.width - (spacing * 3)
//        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
//        layout.itemSize = CGSize(width: width / 2, height: width / 2)
//        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        layout.minimumInteritemSpacing = spacing
//        layout.minimumLineSpacing = spacing
//        
//        return view
//    }()
