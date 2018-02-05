//
//  periodAndSoundCell.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 21.10.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit

class PeriodAndSoundCreationCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1.2
        borderView.layer.borderColor = UIColor.purple.cgColor
        borderView.layer.cornerRadius = 15
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
