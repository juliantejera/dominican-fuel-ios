//
//  ViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/8/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

extension UIViewController {
    var contentViewController: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController!
        } else {
            return self
        }
    }
}