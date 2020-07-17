//
//  CreateAccountViewController.swift
//  BloodBankApp
//
//  Created by Apple on 1/28/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView


class CreateAccountViewController: UIViewController,UITextFieldDelegate{
    
    
    @IBOutlet weak var confirmSecureEntryOutlet: UIButton!
    @IBOutlet weak var secureEntryOutlet: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var Fullname: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Phonenumber: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Confirmpassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createAccount: UIButton!
    
    @IBOutlet weak var Bloodgroup: UITextField!
    
    var bloodGroupPickerview = UIPickerView()
    let bloodGroupsArray = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secureEntryOutlet.tintColor = UIColor.darkGray
        self.confirmSecureEntryOutlet.tintColor = UIColor.darkGray
        self.addGesture()
        activityIndicator.isHidden = true
        Bloodgroup.inputView = bloodGroupPickerview
        bloodGroupPickerview.delegate = self
        bloodGroupPickerview.dataSource = self
        Age.delegate = self
        Phonenumber.delegate = self
        userImage.roundedImage()

        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacter = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacter)
        let typedCharacterSet = CharacterSet(charactersIn:string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
        
    }
    
    func addGesture(){
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        userImage.addGestureRecognizer(gesture)
        userImage.isUserInteractionEnabled = true
    }
    
    @objc func userImageTapped(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (ok) in
            // Camera option tapped

            self.presentImagePicker(type: .camera)
        }
        
        let photoGallery = UIAlertAction(title: "Gallery", style: .default) { (gallery) in
            // Gallery option tapped
            
            self.presentImagePicker(type: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (Cancel) in
            // cancel option tapped
            
        
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoGallery)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet,animated: true,completion:nil)
        
    }
    
    func presentImagePicker(type:UIImagePickerController.SourceType){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        self.present(imagePickerController,animated: true,completion: nil)
        
        
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
    var passwordToggle2 = true

    @IBAction func confirmSecureEntryBtn(_ sender: UIButton) {
        if (passwordToggle2 == true) {
                          Confirmpassword.isSecureTextEntry = false
                      confirmSecureEntryOutlet.tintColor = UIColor.gray
                      } else {
                          Confirmpassword.isSecureTextEntry = true
                      confirmSecureEntryOutlet.tintColor = UIColor.darkGray
                      }
                      passwordToggle2 = !passwordToggle2
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func Createaccount_btn(_ sender: Any) {
        createAccount.isEnabled = true
        createAccount.tintColor = UIColor.gray
        if Fullname.text!.isEmpty || Age.text!.isEmpty || Email.text!.isEmpty || Phonenumber.text!.isEmpty || Password.text!.isEmpty || Confirmpassword.text!.isEmpty || Bloodgroup.text!.isEmpty{
            
            self.showAlert(controller: self, title: "Failure", message: "please fill required field") { (ok) in
                
            }
            
        }
        else{
            
            createAccount.isEnabled = false
            
            if Password.text != Confirmpassword.text{
                
            self.showAlert(controller: self, title: "Failure", message: "Password not match") { (ok) in

                }
                
            }
            
                else  {
                
                
                
                createAccount.isEnabled = false

                          self.activityIndicator.isHidden = false
                          self.activityIndicator.startAnimating()
                            
            Auth.auth().createUser(withEmail: self.Email.text!, password: self.Password.text!) { (authResult,error) in
                if error == nil {
               // print(authResult?.user.uid as Any)
                                    
                ServerCommunication.sharedDelegate.uploadImage(image: self.userImage.image!, userId: (authResult?.user.uid)!) {(status,response) in
                                        
                if status {
                // image uploaded
                                            
                    let newUser = User(fullName: self.Fullname.text!, imageUrl:response, phoneNumber: self.Phonenumber.text!, bloodGroup: self.Bloodgroup.text!, age: self.Age.text!,userId:(authResult?.user.uid)!, email:self.Email.text!)

                // Assign current user while creating account

                User.sharedRef = newUser
                                            
                ServerCommunication.sharedDelegate.uploadUserData(userData: newUser.getUserDic()) { (status, message) in
                    if status{
                 self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                //move to home screen
                //self.navigationController?.setNavigationBarHidden(true, animated: false)
               self.performSegue(withIdentifier: "ToDashBoards", sender: nil)
                }
                                                
              else{
                        
                        self.createAccount.isEnabled = true
                                                    
            self.showAlert(controller: self, title: "Error", message: message) { (ok) in
                    // ok button pressed
                        }
                    }
                }
             }
            else{
            // self.activityIndicator.isHidden = true
            //self.activityIndicator.stopAnimating()
            // unable to upload image
            self.createAccount.isEnabled = true
            self.showAlert(controller: self, title: "Error", message: response) { (ok) in
            // ok button pressed
                }
            }
        }
    }
            else{
            self.createAccount.isEnabled = true
           //self.activityIndicator.isHidden = true
           //self.activityIndicator.stopAnimating()
           // print(error?.localizedDescription as Any)
                         }
                      }
                }
            }
    }
    
  

}




extension CreateAccountViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.userImage.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CreateAccountViewController:UIPickerViewDelegate,UIPickerViewDataSource  {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodGroupsArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodGroupsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Bloodgroup.text = bloodGroupsArray[row]
 
    func donePicker() {
        
        Bloodgroup.resignFirstResponder()
    }
}
}

