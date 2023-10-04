//
//  HomeCollectionViewCell.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/01.
//

import UIKit

class HomeCollectionViewCell: BaseCollectionViewCell {
    
    let testLabel = UILabel()
    

    
    override func configure() {
        contentView.addSubview(testLabel)
//        contentView.translatesAutoresizingMaskIntoConstraints = fals
        contentView.backgroundColor = .cyan
    }
    
    override func setConstraints() {
        testLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
