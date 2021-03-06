//
//  SettingsViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 7/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
        }
    }
    @IBOutlet weak var headerImageView: UIImageView! {
        didSet {
//            self.headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        }
    }
    
    
    let defaultHeaderImageViewHeight: CGFloat = 200.0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let offsetY = -scrollView.contentOffset.y
//        if offsetY > 0 {
//            var frame = self.headerImageView.frame
//            frame.origin.y = scrollView.contentOffset.y
//            frame.size.height = defaultHeaderImageViewHeight + offsetY
//            self.headerImageView.frame = frame
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath) 
        return cell
    }

}
