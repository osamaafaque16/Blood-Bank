//
//  SignInViewController.swift
//  BloodBankApp
//
//  Created by Apple on 1/28/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class SignInViewController: UIViewController {
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var secureEntryOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        signIn.tintColor = UIColor.black
        //Password.isSecureTextEntry == true
        secureEntryOutlet.tintColor = UIColor.darkGray
      
        let emailImage = UIImage(named:"Email")
        addLeftImageTo(txtField: Email, andImage: emailImage!)
        let passwordImage = UIImage(named:"Password")
        addLeftImageTo(txtField: Password, andImage: passwordImage!)

        // Do any additional setup after loading the view.
    }
    var passwordToggle = true
    @IBAction func secureEntryBtn(_ sender: UIButton) {
          if (passwordToggle == true) {
                Password.isSecureTextEntry = false
            secureEntryOutlet.tintColor = UIColor.gray
            } else {
                Password.isSecureTextEntry = true
            secureEntryOutlet.tintColor = UIColor.darkGray
            }
            passwordToggle = !passwordToggle
        }
    
    
    func addLeftImageTo(txtField:UITextField,andImage img : UIImage){

        let leftImageView = UIImageView(frame: CGRect(x: 0.0 , y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always



    }
    
    
    @IBAction func forgetPasswordBtn(_ sender: Any) {
        
      
        
        if Email.text!.isEmpty{
                   
                   self.showAlert(controller: self, title: "Failure", message: "please enter your email!") { (ok) in
                       }
                    }
            
            else{
            
            let email = Email.text
                 Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                     if let error = error
                     {
                    
                        self.showAlert(controller: self, title: "Failure", message: error.localizedDescription) { (ok) in
                            
                        }
                         
                      
                     }
                     else{
                            self.showAlert(controller: self, title: "success", message: "please check your email") { (ok) in}
                         
                         print("password reset email sent")
                     }
                   }
               }
        
        }
    
    @IBAction func Signin_btn(_ sender: UIButton) {
        signIn.tintColor = UIColor.gray
        signIn.isEnabled = true
        
        
        if Email.text!.isEmpty || Password.text!.isEmpty{
            
            self.showAlert(controller: self, title: "Failure", message: "please fill required field") { (ok) in
                
            }
        }
        
        else{
            signIn.isEnabled = false

            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            
            Auth.auth().signIn(withEmail: Email.text!, password: Password.text!) { [weak self] authResult , error in
            if error == nil{
                //user logged in
                
                
                self!.signIn.isEnabled = false
                ServerCommunication.sharedDelegate.fetchUserData(userId: (authResult?.user.uid)!) {(status,message,user) in
                    if status{
                        self!.signIn.isEnabled = false
                        self!.activityIndicator.isHidden = true
                        self!.activityIndicator.stopAnimating()
                        //assign user while login
                        User.sharedRef = user!
                      //  print(authResult?.user.uid as Any)
                       // self?.navigationController?.setNavigationBarHidden(true, animated: true)
                         self?.performSegue(withIdentifier: "ToDashBoards", sender: nil)
                        }
                        
                    else{
                        self!.signIn.isEnabled = true
                        self!.activityIndicator.isHidden = true
                        self!.activityIndicator.stopAnimating()
                        self?.showAlert(controller: self!, title: "Failure", message: message, actionTitle: "ok", completion: { (okBtnPressed) in
                            
                        })
                    }
                    
                }
                
            }
            else{
                //error
                self!.signIn.isEnabled = true
                self!.activityIndicator.isHidden = true
                self!.activityIndicator.stopAnimating()
              //  print(error?.localizedDescription as Any)
                self?.showAlert(controller: self!, title: "Failure", message: error!.localizedDescription) { (ok) in

                    
            
                }
            }
        }

}
}
} 
    
