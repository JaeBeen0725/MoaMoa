//
//  HomeCollectionViewCell.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/01.
//

import UIKit

class HomeCollectionViewCell: BaseCollectionViewCell, UITextViewDelegate {
    
    let thumbnailImageView = UIImageView()
    let titleLabel = BasePaddingLabel()
    let memoLabel = UITextView()
    let showMemoButton = UIButton()
//    let closeMeMoButton = UIButton()
    let likeImage = UIImageView()


    override func configure() {
        
        layer.cornerRadius = 9
        layer.borderWidth = 0.4
        contentView.layer.cornerRadius = 9
   
        contentView.clipsToBounds = true
       
 
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(showMemoButton)
//        contentView.addSubview(closeMeMoButton)
        contentView.addSubview(likeImage)
//        thumbnailImageView.contentMode = .scaleToFill
       
        labelSetup(label: titleLabel, text: "", backgroundColor: UIColor(named: "CellTitleBackgroundColor")!, textColor: .black, textAlignment: .left)
        if titleLabel.adjustsFontSizeToFitWidth == false {
            titleLabel.adjustsFontSizeToFitWidth = true
               }
      
        
        memoLabel.delegate = self
        memoLabel.font = UIFont.systemFont(ofSize: 14)
        memoLabel.backgroundColor = .black
        memoLabel.layer.opacity = 0.7
        memoLabel.textColor = .white
        memoLabel.isEditable = false
        memoLabel.isSelectable = false
        memoLabel.isHidden = true
       
        
        likeImage.tintColor = UIColor(named: "SignatureColor")
        
        showMemoButton.tintColor = UIColor(named: "reversedSystemBackgroundColor")!
        
        buttonSetup(button: showMemoButton, title: "", image: UIImage(systemName: "ellipsis.circle.fill"), backgrounColor: .clear, hidden: false, selector: #selector(showMemoButtonTapped))
//        buttonSetup(button: cli, title: "", image: nil, backgrounColor: .clear, hidden: true, selector: #selector(closeMeMoButtonTapped))
//       
        NotificationCenter.default.addObserver(self, selector: #selector(offMemo), name: NSNotification.Name( "offMemo"), object: nil)
        
    }
//    @objc func closeMeMoButtonTapped() {
//        memoLabel.isHidden = true
//        showMemoButton.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
////        closeMeMoButton.isHidden = true
////        showMemoButton.isHidden = false
//    }
    
    @objc func offMemo() {
        memoLabel.isHidden = true
        showMemoButton.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
//        closeMeMoButton.isHidden = true
//        showMemoButton.isHidden = false
    }
    
    @objc func showMemoButtonTapped() {
        memoLabel.isHidden.toggle()
        memoLabel.isHidden == true ?   showMemoButton.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal) : showMemoButton.setImage(nil, for: .normal)
        
//        showMemoButton.isHidden = true
//        closeMeMoButton.isHidden = false
    }
    
    

    
    override func setConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
           
            make.size.equalTo(self.snp.width)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            
            
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()

        }
        memoLabel.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        showMemoButton.snp.makeConstraints { make in
            make.size.equalTo(45)
            make.top.equalTo(memoLabel.snp.top)
            make.trailing.equalTo(memoLabel.snp.trailing)
        }
        
//        closeMeMoButton.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        likeImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalToSuperview().inset(4)
            make.bottom.equalTo(titleLabel.snp.top).inset(-4)
        }
        
    }
}
