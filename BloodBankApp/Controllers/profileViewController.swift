//
//  profileViewController.swift
//  BloodBankApp
//
//  Created by Apple on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class profileViewController: UIViewController{
    
//    func passDataBack(emails: String) {
//
//        email.text! = emails
//
//    }
    

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var bloodGroup: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        setupUserProfile()
        userImage.roundedImage()

        // Do any additional setup after loading the view.        
    }
    
    
    

    @IBAction func updateProfileBtn(_ sender: UIButton) {


    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! updatePasswordandEmailViewController
//        vc.delegate = self
//
//    }
    

    
    
    func setupUserProfile(){
        
        self.userName.text = User.sharedRef.fullName
        self.age.text = User.sharedRef.age
        self.phoneNumber.text = User.sharedRef.phoneNumber
        self.bloodGroup.text = User.sharedRef.bloodGroup
        self.email.text = User.sharedRef.email
        
        print(bloodGroup.text)
        
        if let url = URL(string: User.sharedRef.imageUrl){
            
                self.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
      }
    }
  }
    
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        self.showAlert(controller: self, title: "", message: "Are you sure you want to log out out", actionTitle: "") { (ok) in
    
            let firebaseAuth = Auth.auth()
                        do {
                          try firebaseAuth.signOut()
                            print("signout")
                            
                            User.sharedRef = nil
                            self.navigationController?.navigationController?.popToRootViewController(animated: true)
                        } catch let signOutError as NSError {
                          print ("Error signing out: %@", signOutError)
                        }
            
        }
        
        
     
    }
}
