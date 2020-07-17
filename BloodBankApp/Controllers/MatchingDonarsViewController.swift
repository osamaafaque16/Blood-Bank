//
//  MatchingDonarsViewController.swift
//  BloodBankApp
//
//  Created by Apple on 2/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class MatchingDonarsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var user = [User]()
    

    
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var donar = [User]()
    
    override func viewDidLoad() {
    
     
        super.viewDidLoad()
        activityIndicatorOutlet.isHidden = false
        activityIndicatorOutlet.startAnimating()
        fetchMatchingDonarsData()
        fetchDonarData()
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchDonarData()
//    }
    
    
    func fetchDonarData () {
            if User.sharedRef == nil {
                
                if let user = Auth.auth().currentUser{
                    ServerCommunication.sharedDelegate.fetchUserData(userId: user.uid) { (status, message, user) in
                      //  print (user?.userId)
                        if status {
                            User.sharedRef = user!
                            self.fetchMatchingDonarsData()
                        } else {
                            print("Could not find User Data")
                            self.showAlert(controller: self, title: "failed", message: "enable to get donars data") { (ok) in
                                
                            }
                          
                        }
                    }
                }else{
                 
                  //  self.fetchMatchingDonarsData()
                }
            }else{
               
               // self.fetchMatchingDonarsData()
        }
    }
        
    

        
        func fetchMatchingDonarsData () {
            ServerCommunication.sharedDelegate.fetchMatchingDonarsData{ (status, message, users) in
                
                if status {
                    // Success
                  
                                self.donar = users!
                                self.tableView.reloadData()
                    self.activityIndicatorOutlet.isHidden = true
                               self.activityIndicatorOutlet.stopAnimating()
                            } else {
                               
                                // faliure
                                print ("Could not find Data")
                    self.showAlert(controller: self, title: "failed", message:"check your connection") { (ok) in
                        
                    }
                            }
              self.activityIndicatorOutlet.isHidden = true
              self.activityIndicatorOutlet.stopAnimating()
                        }
            }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.bloodGroup.text = donar[indexPath.row].bloodGroup
        cell.userName.text = donar[indexPath.row].fullName
    
        
        if let url = URL(string: donar[indexPath.row].imageUrl){
            
            cell.donarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
        
        
    }
    
        
        
           // let userID = self.user[indexPath.row].userId
            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
                tableView.allowsSelection = false
                tableView.deselectRow(at: indexPath, animated: true)
                
                let userID = self.donar[indexPath.row].userId
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let donarProfileController = storyBoard.instantiateViewController(identifier: "viewRequestedUserProfileViewController") as! viewRequestedUserProfileViewController
                ServerCommunication.sharedDelegate.fetchUserData(userId: userID) { (status, message, user) in
                    if status{
                        donarProfileController.donar = user
                        self.navigationController!.pushViewController(donarProfileController, animated: true)
                        
                    }else{
                        
                        //tableView.allowsSelection = true
                    }
                    tableView.allowsSelection = true
                }
            }

//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let cell = storyBoard.instantiateViewController(withIdentifier: "viewRequestedUserProfileViewController") as! viewRequestedUserProfileViewController
//
//            ServerCommunication.sharedDelegate.fetchUserData(userId: userID) { (status, message, user) in
//                     if status{
//                        cell.donar = user
//                         self.navigationController!.pushViewController(cell, animated: true)
//
//                     }else{
//                     }
//                 }
            
//            cell.mainUserBloodGroup = donar[indexPath.row].bloodGroup
//            cell.mainUserName = donar[indexPath.row].fullName
//            cell.mainUserPhoneNumber = donar[indexPath.row].phoneNumber
//            cell.mainUserAge = donar[indexPath.row].age
//            cell.mainUserEmail = donar[indexPath.row].email
       
//            if let url = URL(string: donar[indexPath.row].imageUrl){
//
//                cell.requestUserImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
//                    }
//                  }
            
//            self.navigationController?.pushViewController(cell, animated: true)
//        }
    


}


