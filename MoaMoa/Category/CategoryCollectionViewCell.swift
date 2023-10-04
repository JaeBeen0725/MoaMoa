//
//  CategoryCollectionViewCell.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    let categoryTitle = UILabel()
    
    override func configure() {
        super.configure()
        
        contentView.addSubview(categoryTitle)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        categoryTitle.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

