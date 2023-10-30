//
//  ShoppingWebViewController.swift
//  SeSACMarket
//
//  Created by Jae Oh on 2023/09/10.
//

import UIKit
import RealmSwift
import WebKit



class WebViewController: BaseViewController, WKUIDelegate {
    
    var shoppingWebView = WKWebView()
    var receiveProductId: String?
    var url = UserDefaults.standard.string(forKey: "aa")!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlSetup(url: url)
      print(url)
       
    }
    func urlSetup(url: String) {
        
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        shoppingWebView.load(request)
    }
    
   

    override func configure() {
        super.configure()
        view.addSubview(shoppingWebView)
      
    }
    
    override func setContraints() {
        super.setContraints()
        shoppingWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
  
    
  
}


