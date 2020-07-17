//
//  CustomCell.swift
//  BloodBankApp
//
//  Created by Apple on 2/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var donarImageView: UIImageView!
    @IBOutlet weak var bloodGroup: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        donarImageView.roundedImage1()
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 12.0
        cardView.layer.shadowOpacity = 0.7
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIImageView {
    
    func roundedImage1 () {
        self.layer.cornerRadius = self.frame.size.width / 2.5
        self.clipsToBounds = true
    }
}
