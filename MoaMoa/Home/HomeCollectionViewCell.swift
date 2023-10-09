//
//  HomeCollectionViewCell.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/01.
//

import UIKit

class HomeCollectionViewCell: BaseCollectionViewCell {
    
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
   
    
    override func configure() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)

        contentView.backgroundColor = .cyan
    }
    
    override func setConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.4)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(thumbnailImageView.snp.bottom)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
    }
}
