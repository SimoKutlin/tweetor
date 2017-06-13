//
//  SavedPlaceViewController.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import UIKit

class SavedPlaceViewCell: UITableViewCell {
    
    // MARK: - UI elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    var locationData: Location? { didSet { updateGUI() } }
    
    
    // MARK: UI - preparation
    
    func updateGUI() {
        nameLabel.text = locationData?.name
        streetLabel.text = locationData?.street
        zipLabel.text = locationData?.zip
        cityLabel.text = locationData?.city
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
