//
//  ViewController.swift
//  BloodBankApp
//
//  Created by Apple on 1/28/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit



class ViewController: UIViewController{
   
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}



extension UIViewController{
    
    func showAlert(controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            
            // ok button pressed
            completion(true)
        }
        alertController.addAction(okAction)
        controller.present(alertController,animated: true)
        }
    
    func showAlert(controller:UIViewController,title:String,message:String,actionTitle:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Log Out", style: .destructive) { (alertAction) in
            // ok button pressed
            completion(true)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .default) { (alertAction) in
            // ok button pressed
            //completion(false)
        }
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        controller.present(alertController,animated: true)
    }
    
    
    
}

