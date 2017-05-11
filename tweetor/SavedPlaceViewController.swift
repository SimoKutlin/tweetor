//
//  SavedPlaceViewController.swift
//  tweetor
//
//  Created by admin on 11.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import UIKit

class SavedPlaceViewController: UITableViewCell {
    
    // UI Elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var locationData: Location? { didSet { updateGUI() } }
    
    func updateGUI() {
        nameLabel.text = locationData?.name
        streetLabel.text = locationData?.street
        zipLabel.text = locationData?.zip
        cityLabel.text = locationData?.city
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
