//
//  PeriodAndSoundCell.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 28.10.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit

class PeriodAndSoundCell: UITableViewCell {

    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var sound: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
