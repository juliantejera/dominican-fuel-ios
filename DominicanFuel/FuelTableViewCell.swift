//
//  FuelTableViewCell.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 5/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var signImageView: UIImageView!
    
    var viewModel: FuelViewModel? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel?.text = viewModel?.type
        subtitleLabel?.text = viewModel?.price
    }
}
