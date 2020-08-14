//
//  BusTableViewCell.swift
//  BusTracker
//
//  Created by Kulyash Konyrova on 5/19/20.
//  Copyright © 2020 Kulyash Konyrova. All rights reserved.
//

import UIKit

class BusTableViewCell: UITableViewCell {
    @IBOutlet weak var BusName: UILabel!
    @IBOutlet weak var BusNumber: UILabel!
    @IBOutlet weak var BusTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
