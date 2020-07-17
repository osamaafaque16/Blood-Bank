//
//  RequestTableViewController.swift
//  BloodBankApp
//
//  Created by Apple on 2/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth

protocol addRequestDelegate {
    func addRequest()
}
class RequestTableViewController: UIViewController,addRequestDelegate {

    
    @IBOutlet weak var RequestTableView: UITableView!
    @IBOutlet weak var activityIndicatoroutlet: UIActivityIndicatorView!
    
    var donar = [User]()

    
    @IBOutlet weak var cardView: UIView!
    var requests:Array = [Request]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatoroutlet.isHidden = false
        activityIndicatoroutlet.startAnimating()
       // RequestTableView.separatorInset = .zero
        //RequestTableView.separatorColor = UIColor.darkGray
        
        fetchAllRequest()
    }
    

    
  

    
    func addRequest() {
          self.fetchAllRequest()
          //self.requests.append()
          //self.RequestTableView.reloadData()
      }
    
    func fetchAllRequest(){
        
        ServerCommunication.sharedDelegate.fetchAllRequest { (status, message,requests) in
            if status{
                //success
                self.requests.removeAll()
                self.requests = requests!
                self.RequestTableView.reloadData()
                self.activityIndicatoroutlet.isHidden = true
                self.activityIndicatoroutlet.stopAnimating()
            }
                
          
            else{
                
                //failure
                self.showAlert(controller: self, title: "Failure", message: message) { (ok) in
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          fetchAllRequest()
       // fetchUserData()
      }

}

  

extension RequestTableViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return requests.count
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTableViewCell") as! RequestForBloodTableViewCell
        cell.bloodGroupLabel.text = requests[indexPath.row].bloodGroup
        cell.nameLabel.text = requests[indexPath.row].fullName
        
        if let url = URL(string: requests[indexPath.row].imageUrl){
                
            cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
          }
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        RequestTableView.allowsSelection = false
        RequestTableView.deselectRow(at: indexPath, animated: true)
        
        let userID = self.requests[indexPath.row].id
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let donarProfileController = storyBoard.instantiateViewController(identifier: "viewRequestedUserProfileViewController") as! viewRequestedUserProfileViewController
        ServerCommunication.sharedDelegate.fetchUserData(userId: userID) { (status, message, user) in
            if status{
                donarProfileController.donar = user
                self.navigationController!.pushViewController(donarProfileController, animated: true)
                
            }else{
            }
            self.RequestTableView.allowsSelection = true
        }
    }

    
    

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let cell = storyBoard.instantiateViewController(withIdentifier: "viewRequestedUserProfileViewController") as! viewRequestedUserProfileViewController
//
//
//        cell.mainUserBloodGroup = requests[indexPath.row].bloodGroup
//        cell.mainUserName = requests[indexPath.row].fullName
//        cell.mainUserPhoneNumber = requests[indexPath.row].phoneNumber
//        cell.mainUserAge = requests[indexPath.row].age
//        cell.mainUserEmail = requests[indexPath.row].email
//        //cell.requestUserImage = requests[indexPath.row].imageUrl
//
//
//
//        if let url = URL(string: requests[indexPath.row].imageUrl){
//
//            cell.requestUserImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
//                }
//              }
//        //cell.requestedBloodGroup = self.requests[indexPath.row].currentUserBlood
//
//       self.navigationController?.pushViewController(cell, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.showAlert(controller: self, title: "Delete Request", message: "Do you really want to delete this Request", actionTitle: "Delete") {
                (isDelete) in
                if isDelete{
                    ServerCommunication.sharedDelegate.deleteRequest(id: self.requests[indexPath.row].id) { (status, message) in
                        if status{
                            self.showAlert(controller: self, title: "Success", message: message) { (ok) in
                                self.requests.remove(at: indexPath.row)
                                self.RequestTableView.reloadData()
                            }
                        }else{
                            self.showAlert(controller: self, title: "Fail", message: message) { (ok) in
                                
                            }
                        }
                    }
                }
            }
            
        }
    }
    
}


