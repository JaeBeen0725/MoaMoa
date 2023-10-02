//
//  AddAndModifyLink.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/02.
//

import UIKit

class AddAndModifyLink: BaseViewController {
    
    let linkLabel = UILabel()
    let addLinkButton = UIButton()
    
    let titleLabel = UILabel()
    let titleTextView = UITextView()
    let memoLabel = UILabel()
    let memoTextView = UITextView()
    
    let cancleButton = UIButton()
    let addButton = UIButton()
    
    override func configure() {
        super.configure()
        view.backgroundColor = .white
        view.addSubview(linkLabel)
        view.addSubview(addLinkButton)
        view.addSubview(titleLabel)
        view.addSubview(titleTextView)
        view.addSubview(memoLabel)
        view.addSubview(memoTextView)
        view.addSubview(cancleButton)
        view.addSubview(addButton)
        
        linkLabel.backgroundColor = .blue
        addLinkButton.backgroundColor = .blue
        titleLabel.backgroundColor = .blue
        titleTextView.backgroundColor = .blue
        memoLabel.backgroundColor = .blue
        memoTextView.backgroundColor = .blue
        cancleButton.backgroundColor = .blue
        addButton.backgroundColor = .blue
        
        
        
    }
    
    override func setContraints() {
        super.setContraints()
        
        linkLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        addLinkButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(linkLabel.snp.trailing).offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(linkLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        titleTextView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(titleTextView.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        memoTextView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalTo(memoLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(50)
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(50)
        }
    }
}
