//
//  MessagesController.swift
//  BloodBankApp
//
//  Created by Apple on 3/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase

class MessagesController: UIViewController,UITableViewDelegate,UITableViewDataSource {
      var messages = [MessagesClass]()
      var newMessages:MessagesClass?
      var users = [User]()
      var messagesDictionary = [String: MessagesClass]()
    @IBOutlet weak var chatLogsTableView: UITableView!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        //activityIndicatorOutlet.isHidden = true
        self.activityIndicatorOutlet.isHidden = false
        self.activityIndicatorOutlet.startAnimating()
        chatLogsTableView.delegate = self
        chatLogsTableView.dataSource = self
        observeUserMessages()

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           
           super.viewWillAppear(animated)
           self.tabBarController?.tabBar.isHidden = false
       }
    
       func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            
           // print(uid, userId)
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("Messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MessagesClass(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
            }
            
            }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
        var timer: Timer?
        
        @objc func handleReloadTable() {
            self.messages = Array(self.messagesDictionary.values)
            messages.sort()
    //        self.messages.sort(by: { (message1, message2) -> Bool in
    //
    //            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
    //        })
            
            //this will crash because of background thread, so lets call this on dispatch_async main thread
            DispatchQueue.main.async(execute: {
                self.chatLogsTableView.reloadData()
            })
        }
    
    func showChatControllerForUser(_ user: User) {
         //        let chatLogController = ChatLogsViewController()
         //        chatLogController.users = user
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         let chatLogController = storyBoard.instantiateViewController(identifier: "ChatLogsViewController") as! ChatLogsViewController
         chatLogController.users = user
         self.navigationController!.pushViewController(chatLogController, animated: true)
         // navigationController?.pushViewController(chatLogController, animated: true)
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return messages.count
      }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessages") as! MessagesTableViewCell
            //cell.contactUserName.text = users[indexPath.row].firstName
            cell.messageLabel.text = messages[indexPath.row].text
            if let seconds = messages[indexPath.row].timestamp {
                // if let seconds = messages.timeStamp.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: TimeInterval(seconds))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                cell.dateLabel.text = dateFormatter.string(from: timeStampDate)
                //}
            }
           
            if let userid = messages[indexPath.row].chatPartnerId(){
   
                let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: userid).getDocuments { (snapshot, error) in
                    
                    
    
                  
                    
                    if error == nil {
                        
                        if let usersData = snapshot?.documents {
                            // Got Donars
                            //                    var users:Array = [User]()
                            for matchingUser in usersData {
                                let usersDocuments = matchingUser.data()
                                let fullName = usersDocuments["FullName"] as! String
                                let bloodGroup = usersDocuments["BloodGroup"] as! String
                                let imageUrl = usersDocuments["ImageUrl"] as! String
                                let userId = usersDocuments["UserId"] as! String
                                let phoneNumber = usersDocuments["PhoneNumber"] as! String
                                let age = usersDocuments["Age"] as! String
                                let email = usersDocuments["email"] as! String

                                
                             
                                
                                let user = User(fullName:fullName , imageUrl: imageUrl, phoneNumber: phoneNumber, bloodGroup: bloodGroup, age: age,userId: userId, email:email)
                                
                                self.users.append(user)
                                self.chatLogsTableView.reloadData()
                                //self.users = [user]
                                
                                cell.contactUserName.text = user.fullName
                                   // cell.contactUserName.text = user.firstName
                                //dict["First Name"] as! String
                                if let url = URL(string: (user.imageUrl)){
                                    cell.contactImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.activityIndicatorOutlet.isHidden = true
            self.activityIndicatorOutlet.stopAnimating()
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chatLogsTableView.allowsSelection = false
         let message = messages[indexPath.row]
         
         guard let chatPartnerId = message.chatPartnerId() else {
             return
         }
         
         //            let red = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: chatPartnerId).
         let new = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").whereField("UserId", isEqualTo: chatPartnerId).getDocuments { (snapshot, error) in
             
             if error == nil {
             
             if let usersData = snapshot?.documents {
                 // Got Donars
                 //                    var users:Array = [User]()
                 for matchingUser in usersData {
                     let usersDocuments = matchingUser.data()
                     let fullName = usersDocuments["FullName"] as! String
                     let bloodGroup = usersDocuments["BloodGroup"] as! String
                     let imageUrl = usersDocuments["ImageUrl"] as! String
                     let userId = usersDocuments["UserId"] as! String
                     let phoneNumber = usersDocuments["PhoneNumber"] as! String
                     let age = usersDocuments["Age"] as! String
                     let email = usersDocuments["email"] as! String

                     
                    let user = User(fullName:fullName , imageUrl: imageUrl, phoneNumber: phoneNumber, bloodGroup: bloodGroup, age: age,userId: userId, email:email)
                     
                     self.users.append(user)
                     self.showChatControllerForUser(user)
                     }
                 
          
                 }
             }
            self.chatLogsTableView.allowsSelection = true
         }
     }
    
    
    



}
