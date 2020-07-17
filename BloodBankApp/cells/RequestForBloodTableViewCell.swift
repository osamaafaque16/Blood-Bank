//
//  RequestForBloodTableViewCell.swift
//  BloodBankApp
//
//  Created by Apple on 2/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RequestForBloodTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var bloodGroupLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.roundedImage2()
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
    
    func roundedImage2 () {
        self.layer.cornerRadius = self.frame.size.width / 2.7
        self.clipsToBounds = true
    }
}
