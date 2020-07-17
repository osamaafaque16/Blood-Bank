//
//  AddRequestViewController.swift
//  BloodBankApp
//
//  Created by Apple on 2/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddRequestViewController: UIViewController {

    @IBOutlet weak var bloodGroup: UITextField!
    
    var bloodGroupPickerview = UIPickerView()
       let bloodGroupsArray = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
   
    
   // let appDele = UIApplication.shared.delegate as! AppDelegate

    var addRequestprotocol : addRequestDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bloodGroup.inputView = bloodGroupPickerview
        bloodGroupPickerview.delegate = self
        bloodGroupPickerview.dataSource = self


        // Do any additional setup after loading the view.
    }
    
    @IBAction func requestBtn(_ sender: UIButton) {
        
        if bloodGroup.text!.isEmpty{
            
            self.showAlert(controller: self, title: "Failed", message: "Please fill the required field") { (ok) in
                
            }
        }
        
        else{
            
            ServerCommunication.sharedDelegate.addRequest(fullName: User.sharedRef.fullName, bloodGroup: bloodGroup.text!, imageUrl: User.sharedRef.imageUrl, age: User.sharedRef.age, phoneNumber: User.sharedRef.phoneNumber,email:User.sharedRef.email, currentuser: User.sharedRef.bloodGroup) { (status, message) in
                   
            
                   if status{
                       
                       //data is added
                       self.showAlert(controller: self, title: "success", message: message) { (ok) in
                       self.addRequestprotocol?.addRequest()
                           self.navigationController?.popViewController(animated: true)
                           
                       }
                   }
                       
                       else  {
                           //error
                           self.showAlert(controller: self, title: "Failed", message: message) { (ok) in
                               self.navigationController?.popViewController(animated: true)
                           }
                       }
                   }
               }
           }
       }
    
   extension AddRequestViewController:UIPickerViewDelegate,UIPickerViewDataSource  {
       
       
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
           bloodGroup.text = bloodGroupsArray[row]
    
       func donePicker() {
           
           bloodGroup.resignFirstResponder()
       }
   }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
  }


