//
//  updatePasswordandEmailViewController.swift
//  BloodBankApp
//
//  Created by Apple on 3/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

//protocol updateEmail {
//    func passDataBack(emails:String)
//}

class updatePasswordandEmailViewController: UIViewController {

    @IBOutlet weak var confirmSecureEntryOutlet: UIButton!
    @IBOutlet weak var secureEntryOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
//    var delegate:updateEmail?
    
    override func viewDidLoad() {
       // updateEmail.delegate = self
        super.viewDidLoad()
        //changeEmail()
    

        // Do any additional setup after loading the view.
    }

    
    @IBAction func updateBtn(_ sender: UIButton) {
        
        if emailTextField.text!.isEmpty&&newPasswordTextField.text!.isEmpty||confirmPasswordTextField.text!.isEmpty{
            
            self.showAlert(controller: self, title: "FAilure", message: "Please fill empty Field") { (ok) in
                
            }
        }
        else{
            
            if newPasswordTextField.text! != confirmPasswordTextField.text!{
                
                self.showAlert(controller: self, title: "Failed", message: "Password Does not Match") { (ok) in
                    
                }
            }
            
            else{
        
        let changePassword = Auth.auth().currentUser
        changePassword?.updatePassword(to: newPasswordTextField.text!, completion: { (error) in
            if let error = error{
                
              print(error)
            }
            else{
                print("password changed")
                //self.navigationController?.popViewController(animated: true)
                
            }
        })
        
        let changeEmail = Auth.auth().currentUser
        changeEmail?.updateEmail(to: emailTextField.text!, completion: { (error) in
            if let  error = error{
                
                self.showAlert(controller: self, title: "", message: error.localizedDescription) { (ok) in
                    
                }
            }
            
            else{
                
            //    self.delegate?.passDataBack(emails: self.emailTextField.text!)
                
                let reference = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").document(User.sharedRef.userId).updateData(["email" : self.emailTextField.text]) { (error) in
                    if  let error = error {
                        self.showAlert(controller: self, title: "Enable to update email", message: error.localizedDescription) { (ok) in

                        }
                    }

                    else{
                        print("email changed")


                    }
                }

                print("email changed ")
                self.showAlert(controller: self, title: "success", message: "please login with new email or password") { (Ok) in





                                            let firebaseAuth = Auth.auth()
                                                        do {
                                                          try firebaseAuth.signOut()
                                                            User.sharedRef = nil
                                                            self.navigationController?.navigationController?.popToRootViewController(animated: true)
                                                        } catch let signOutError as NSError {
                                                          print ("Error signing out: %@", signOutError)
                                                        }

                                        }
                self.navigationController?.popViewController(animated: true)
            }
        })
        
            }
        
    }
       
    
       
    }
    var passwordToggle = true

    @IBAction func secureEntryBtn(_ sender: UIButton) {
        
        if (passwordToggle == true) {
                            newPasswordTextField.isSecureTextEntry = false
                        secureEntryOutlet.tintColor = UIColor.blue
                        } else {
                            newPasswordTextField.isSecureTextEntry = true
                        secureEntryOutlet.tintColor = UIColor.gray
                        }
                        passwordToggle = !passwordToggle
        
    }
    var passwordToggle1 = true

    @IBAction func confirmSecureEntryBtn(_ sender: UIButton) {
        
        if (passwordToggle1 == true) {
                          confirmPasswordTextField.isSecureTextEntry = false
                      confirmSecureEntryOutlet.tintColor = UIColor.blue
                      } else {
                          confirmPasswordTextField.isSecureTextEntry = true
                      confirmSecureEntryOutlet.tintColor = UIColor.gray
                      }
                      passwordToggle1 = !passwordToggle1

    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
              self.navigationController?.popViewController(animated: true)
          }
    
    
    
    
    
    
    
    
    
}
