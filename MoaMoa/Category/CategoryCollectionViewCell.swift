//
//  CategoryCollectionViewCell.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    let thumbnailImageView = UIImageView()
    
    let categoryTitle = BasePaddingLabel()
    
    override func configure() {
        super.configure()
     
        
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.layer.borderWidth = 0.4
        
        contentView.addSubview(categoryTitle)
        contentView.addSubview(thumbnailImageView)
//        contentView.clipsToBounds = true
        if categoryTitle.adjustsFontSizeToFitWidth == false {
            categoryTitle.adjustsFontSizeToFitWidth = true
               }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let color = UIColor(named: "reversedSystemBackgroundColor")!
              let resolvedColor = color.resolvedColor(with: traitCollection)
        thumbnailImageView.layer.borderColor = resolvedColor.cgColor
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        thumbnailImageView.snp.makeConstraints { make in
           
            make.size.equalTo(self.snp.width)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            
            
        }
        categoryTitle.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()

        }
    }
}

