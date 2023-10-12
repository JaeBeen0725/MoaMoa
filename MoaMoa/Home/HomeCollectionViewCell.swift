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
    let showMemoButton = UIButton()
    let closeMeMoButton = UIButton()


    override func configure() {
        
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 0.18
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(showMemoButton)
        contentView.addSubview(closeMeMoButton)
       
        
        titleLabel.backgroundColor = .white
        titleLabel.sizeToFit()
        contentView.backgroundColor = .cyan
       memoLabel.backgroundColor = .yellow
        showMemoButton.backgroundColor = UIColor(named: "SignatureColor")
        showMemoButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        memoLabel.isHidden = true
        closeMeMoButton.isHidden = true
        showMemoButton.addTarget(self, action: #selector(showMemoButtonTapped), for: .touchUpInside)
        closeMeMoButton.addTarget(self, action: #selector(closeMeMoButtonTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(offMemo), name: NSNotification.Name( "offMemo"), object: nil)
        
    }
    @objc func closeMeMoButtonTapped() {
        memoLabel.isHidden = true
        closeMeMoButton.isHidden = true
        showMemoButton.isHidden = false
    }
    
    @objc func offMemo() {
        memoLabel.isHidden = true
        closeMeMoButton.isHidden = true
        showMemoButton.isHidden = false
    }
    
    @objc func showMemoButtonTapped() {
        memoLabel.isHidden = false
        showMemoButton.isHidden = true
        closeMeMoButton.isHidden = false
    }
    
    override func setConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            
            make.size.equalTo(self.snp.width)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            
            
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
            make.width.equalTo(thumbnailImageView.snp.width)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()

        }
        memoLabel.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        showMemoButton.snp.makeConstraints { make in
            make.size.equalTo(45)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        closeMeMoButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
}
