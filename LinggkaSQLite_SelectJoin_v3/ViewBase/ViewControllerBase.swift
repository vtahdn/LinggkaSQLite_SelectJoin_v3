//
//  ViewControllerBase.swift
//  SQLite_Music
//
//  Created by Viet Asc on 12/11/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class ViewControllerBase: UIViewController {
    
    var btn_Title = UIButton()
    var txt_Search = UITextField()
    
    var items = [NSDictionary]()
    var dataBase = DataBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // addBtn_Title()
        titleButton(btn_Title, self)
        
        // addTxt_Search()
        searchTextField(txt_Search, self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setActionForRightBarButton()
        actionForRightBarButton(self)
        
        //        addListViewOrder()
        
    }
    
    @objc func chooseOrder()
    {
        print("Click")
    }
    
    // addBtn_Title()
    var titleButton = { (_ btn_Title: UIButton, _ viewController: UIViewController) in
        btn_Title.setTitle("Linggka Team", for: .normal)
        btn_Title.setTitleColor(.gray, for: .highlighted)
        btn_Title.addTarget(self, action: #selector(chooseOrder), for: .touchUpInside)
        btn_Title.backgroundColor = .black
        viewController.view.addSubview(btn_Title)
        //contraint
        btn_Title.translatesAutoresizingMaskIntoConstraints = false
        let cn1 = NSLayoutConstraint(item: btn_Title, attribute: .leading, relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let cn2 = NSLayoutConstraint(item: btn_Title, attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let cn3 = NSLayoutConstraint(item: btn_Title, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let cn4 = NSLayoutConstraint(item: btn_Title, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1.0, constant: 88)
        NSLayoutConstraint.activate([cn1, cn2, cn3, cn4])
    }
    
    // addTxt_Search
    var searchTextField = { (_ txt_Search: UITextField, _ viewController: UIViewController) in
        txt_Search.isHidden = true
        txt_Search.borderStyle = .roundedRect
        txt_Search.placeholder = "Enter name here"
        txt_Search.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(txt_Search)
        
        //contraint
        let cn1 = NSLayoutConstraint(item: txt_Search, attribute: .leading, relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let cn2 = NSLayoutConstraint(item: txt_Search, attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let cn3 = NSLayoutConstraint(item: txt_Search, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let cn4 = NSLayoutConstraint(item: txt_Search, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1.0, constant: 88)
        NSLayoutConstraint.activate([cn1, cn2, cn3, cn4])
    }
    
    var actionForRightBarButton = { (_ viewController: UIViewController) in
        viewController.tabBarController?.navigationItem.rightBarButtonItem?.target = viewController
        viewController.tabBarController?.navigationItem.rightBarButtonItem?.action = #selector(checkHiddenSearch)
    }
    
    @objc func checkHiddenSearch(){
        if txt_Search.isHidden {
            UIView.transition(with: self.txt_Search, duration: 0.5, options: .transitionCurlDown, animations: nil, completion: nil)
            
        } else {
            UIView.transition(with: self.txt_Search, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        txt_Search.isHidden = !txt_Search.isHidden
        txt_Search.resignFirstResponder()
    }  
    
}
