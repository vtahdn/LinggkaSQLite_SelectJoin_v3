//
//  ViewControllerTableBase.swift
//  SQLite_Music
//
//  Created by Viet Asc on 12/11/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class ViewControllerTableBase: ViewControllerBase {
    
    var myTableView = UITableView()
    var artists = [String]()

    // Add TableView
    var tableView = { (_ controller: ViewControllerTableBase) in
        
        controller.myTableView.backgroundColor = .black
        controller.view.addSubview(controller.myTableView)
        controller.myTableView.translatesAutoresizingMaskIntoConstraints = false
        let cn1 = NSLayoutConstraint(item: controller.myTableView, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let cn2 = NSLayoutConstraint(item: controller.myTableView, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let cn3 = NSLayoutConstraint(item: controller.myTableView, attribute: .top, relatedBy: .equal, toItem: controller.view, attribute: .top, multiplier: 1.0, constant: 128)
        let cn4 = NSLayoutConstraint(item: controller.myTableView, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([cn1, cn2, cn3, cn4])
    }
    
    // Get artists by song ids
    var artistBySongID = { (_ controller: ViewControllerTableBase) in
        
        for song in controller.items {
            let detail = controller.dataBase.viewDataBase("DETAILALBUM", ["ARTISTS.ArtistName"], "JOIN ARTISTS on DETAILALBUM.ArtistID = ARTISTS.ID where SONGID = \(song["ID"]!)", controller.dataBase.getPath())
            controller.artists.append(detail.first!["ArtistName"] as! String)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView(self)
        
    }
    
}
