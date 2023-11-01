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
        layer.borderColor = UIColor(named: "reversedSystemBackground")?.cgColor
        contentView.layer.cornerRadius = 9
        
        contentView.clipsToBounds = true
       
 
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(likeImage)
        contentView.addSubview(memoLabel)
        contentView.addSubview(showMemoButton)
//        contentView.addSubview(closeMeMoButton)
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
   

        var config = UIImage.SymbolConfiguration(paletteColors: [.darkGray, .lightGray])
        config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20.0)))
     let showButtonImage = UIImage(systemName: "m.circle")?.withConfiguration(config)
        showMemoButton.setImage(showButtonImage, for: .normal)
        showMemoButton.addTarget(self, action: #selector(showMemoButtonTapped), for: .touchUpInside)
      
        NotificationCenter.default.addObserver(self, selector: #selector(offMemo), name: NSNotification.Name( "offMemo"), object: nil)
        
    }

    
    @objc func offMemo() {
        var config = UIImage.SymbolConfiguration(paletteColors: [.darkGray, .lightGray])
        config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20.0)))
     let showButtonImage = UIImage(systemName: "m.circle")?.withConfiguration(config)
        memoLabel.isHidden = true
        showMemoButton.setImage(showButtonImage, for: .normal)
//        closeMeMoButton.isHidden = true
//        showMemoButton.isHidden = false
    }
    
    @objc func showMemoButtonTapped() {
        var config = UIImage.SymbolConfiguration(paletteColors: [.darkGray, .lightGray])
        config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20.0)))
     let showButtonImage = UIImage(systemName: "m.circle")?.withConfiguration(config)
        memoLabel.isHidden.toggle()
        memoLabel.isHidden == true ? showMemoButton.setImage(showButtonImage, for: .normal): showMemoButton.setImage(nil, for: .normal)
        
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
            make.leading.equalTo(thumbnailImageView.snp.leading).inset(4)
            make.bottom.equalTo(titleLabel.snp.top).inset(-4)
        }
        
    }
}
