//
//  NewMessagesTableViewCell.swift
//  BloodBankApp
//
//  Created by Apple on 3/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class NewMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactUserName: UILabel!
    @IBOutlet weak var contactBloodGroup: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contactImage.roundedImage()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
