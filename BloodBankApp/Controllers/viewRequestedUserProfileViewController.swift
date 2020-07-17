//
//  viewRequestedUserProfileViewController.swift
//  BloodBankApp
//
//  Created by Apple on 2/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class viewRequestedUserProfileViewController: UIViewController {
    
    @IBOutlet weak var requestedUserUserName: UILabel!
    @IBOutlet weak var requestedUserBloodGroup: UILabel!
    @IBOutlet weak var requestedUserAge: UILabel!
    @IBOutlet weak var requestedUserPhoneNumber: UILabel!
    @IBOutlet weak var requestUserImage: UIImageView!
    @IBOutlet weak var requestedUserEmail: UILabel!
    
    //var user = [Request]()
    
   var mainUserName:String!
//    var mainUserBloodGroup:String!
//    var mainUserAge:String!
//    var mainUserPhoneNumber:String!
//    var mainUserEmail:String!
//    var requestedBloodGroup:String!
    var donar:User!
   // var mainUserImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        requestUserImage.roundedImage3()
        requestedUserUserName.text = donar.fullName
        requestedUserBloodGroup.text = donar.bloodGroup
        requestedUserAge.text = donar.age
        requestedUserPhoneNumber.text = donar.phoneNumber
        requestedUserEmail.text = donar.email
        
        
        
        if let url = URL(string: donar.imageUrl){
                
                    self.requestUserImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
          }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func viewDiseasesBtn(_ sender: UIButton) {
        
        
        
        performSegue(withIdentifier: "moveToViewDiseases", sender: nil)
        
    }
    


    
    
 
    

  override func viewWillDisappear(_ animated: Bool) {
       self.navigationController?.popViewController(animated: true)
   }
 

}

extension UIImageView {
    
    func roundedImage3 () {
        self.layer.cornerRadius = self.frame.size.width / 2.1
        self.clipsToBounds = true
    }
}
