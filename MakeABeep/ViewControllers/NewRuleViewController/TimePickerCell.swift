//
//  TimeAndSoundPickerCell.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 12.09.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit

class TimePickerCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var fromTimeButton: UIButton!
    @IBOutlet weak var toTimeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
