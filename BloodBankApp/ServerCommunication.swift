//
//  File.swift
//  BloodBankApp
//
//  Created by Apple on 2/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth

public class ServerCommunication{
    
    var firebaseFirestore:Firestore!
    var firebaseStorage:Storage!
    
    static var sharedDelegate = ServerCommunication()
    
    private init(){
        
        firebaseFirestore = Firestore.firestore()
        firebaseStorage = Storage.storage()
        
    }
    
    func uploadImage(image:UIImage,userId:String,completion:@escaping(_ status:Bool,_ response:String)->Void){
        // if status is true then downloadurl will be in response

        
        // Data in memory

        guard  let data = image.jpegData(compressionQuality:0.2) else {
            completion(false,"Unable to get data from image")
            return
            }
        // Create a reference to the file you want to upload
        
        let riversRef = firebaseStorage.reference().child("images/\(userId).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
          guard let _ = metadata else {
            // Uh-oh, an error occurred!
            completion(false,error!.localizedDescription)
            return
          }
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
                completion(false,error!.localizedDescription)
              return
            }
            
            completion(true,downloadURL.absoluteString)
            
          }
        }
        
    }
    
    func uploadUserData(userData:[String:Any],completion:@escaping(_ status:Bool, _ message:String)->Void) {
        let userId = userData["UserId"] as! String
        firebaseFirestore.collection("Users").document(userId).setData(userData) { (Error) in
            if Error == nil{
                completion(true,"User data uploaded")
            }
            
            else{
                completion(false,Error!.localizedDescription)
            }
          }
        }
    
    func fetchUserData(userId:String,completion:@escaping(_ status : Bool, _ message:String, _ user:User?)->Void){
        
        firebaseFirestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let snapshot = snapshot{
               // print(snapshot)
                //you get some data
                if let userDic = snapshot.data(){
                    let user = User(userDic: userDic)
                    completion(true,"get user data",user)
                }
                else{
                    completion(false,"Unable to get user data",nil)
                }
                   
            }
            else{
                //you get an error
                completion(false,error!.localizedDescription,nil)
            }
        }
    }
    
   func fetchMatchingDonarsData (completion:@escaping(_ status:Bool, _ message:String, _ users:[User]?) -> Void) {
        
        firebaseFirestore.collection("Users").getDocuments { (snapshot, error) in
            if error == nil {
                // Success
                
                if let usersData = snapshot?.documents {
                    // Got Donars
                    var users:Array = [User]()
                    for matchingUser in usersData {
                        let usersDocuments = matchingUser.data()
                        let userId = usersDocuments["UserId"] as! String
                        if userId == Auth.auth().currentUser?.uid{
                            
                        }else{
                            
                            let fullName = usersDocuments["FullName"] as! String
                            let bloodGroup = usersDocuments["BloodGroup"] as! String
                            let imageUrl = usersDocuments["ImageUrl"] as! String
                            let phoneNumber = usersDocuments["PhoneNumber"] as! String
                            let age = usersDocuments["Age"] as! String
                            let email = usersDocuments["email"] as! String
                            let userId = usersDocuments["UserId"] as! String
                            
                            //let user = User(fullName: fullName, imageUrl: imageUrl, phoneNumber: phoneNumber, bloodGroup: bloodGroup, age: age, userId: userId,email:email)
                            
                            let user = User(fullName: fullName, imageUrl: imageUrl, phoneNumber: phoneNumber, bloodGroup: bloodGroup, age: age, userId: userId, email: email)
                            
                            if User.sharedRef.bloodGroup == "A+"{
                                switch bloodGroup {
                                case "A+", "A-", "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.sharedRef.bloodGroup == "A-"{
                                switch bloodGroup {
                                case "A-", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.sharedRef.bloodGroup == "B+"{
                                switch bloodGroup {
                                case "B+", "B-", "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.sharedRef.bloodGroup == "B-"{
                                switch bloodGroup {
                                case "B-", "O+":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.sharedRef.bloodGroup == "AB+"{
                                switch bloodGroup {
                                case "A+", "A-", "O+", "O-", "B+","B-","AB+","AB-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.sharedRef.bloodGroup == "AB-"{
                                switch bloodGroup {
                                case "A-","O-","B-","AB-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.sharedRef.bloodGroup == "O+"{
                                switch bloodGroup {
                                case "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.sharedRef.bloodGroup == "O-"{
                                switch bloodGroup {
                                case "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }
                            print(users)
                          //  users.append(user)
                        }
                    }
                    completion(true, "Get Donars", users)
                } else {
                    // Donars doc not found
                    completion(false, "Donars Data Not Found", nil)
                }
            } else {
                // faliure
                completion(false, error!.localizedDescription,nil)
            }
        }
    }
    
    func fetchAllDonarsData (completion:@escaping(_ status:Bool, _ message:String, _ users:[User]?) -> Void) {
         firebaseFirestore.collection("Users").getDocuments { (snapshot, error) in
             if error == nil {
                 // Success
                 if let usersData = snapshot?.documents {
                     // Got Donars
                     var users:Array = [User]()
                     for matchingUser in usersData {
                         let usersDocuments = matchingUser.data()
                         let fullName = usersDocuments["FullName"] as! String
                         let bloodGroup = usersDocuments["BloodGroup"] as! String
                         let imageUrl = usersDocuments["ImageUrl"] as! String
                         let userId = usersDocuments["UserId"] as! String
                         let age = usersDocuments["Age"] as! String
                         let phoneNumber = usersDocuments["PhoneNumber"] as! String
                         let email = usersDocuments["email"] as! String
                         
                        let user = User(fullName: fullName, imageUrl: imageUrl, phoneNumber: phoneNumber, bloodGroup: bloodGroup, age: age, userId: userId,email: email)
                         users.append(user)
                     }
                     completion(true, "Get Donars", users)
                 } else {
                     // Donars doc not found
                     completion(false, "Donars Data Not Found", nil)
                 }
             } else {
                 // faliure
                 completion(false, error!.localizedDescription,nil)
             }
         }
     }
    
    func addRequest(fullName:String,bloodGroup:String,imageUrl:String,age:String,phoneNumber:String,email:String,currentuser:String, completion:@escaping(_ status:Bool,_ message:String)-> Void){
        let newRequest = firebaseFirestore.collection("Requests").document()
        newRequest.setData(["FullName" : fullName,"BloodGroup" : bloodGroup,"ImageUrl":imageUrl,"Age":age,"PhoneNumber":phoneNumber, "Id":Auth.auth().currentUser?.uid,"UserId":User.sharedRef.userId,"email":User.sharedRef.email,"currentuserbloodgroup":currentuser]){ (error) in
            
            if error == nil{
                
                //success
                completion(true,"Request is added")
            }
            else{
                //fail
                completion(false,(error!.localizedDescription))
            }
        }
    }
    
    func fetchAllRequest(completion:@escaping(_ status:Bool,_ message:String, _ Request:[Request]?)->Void){
        
        firebaseFirestore.collection("Requests").getDocuments { (snapshot, error) in
            
            if error == nil{
                
                //success
                if let requestsDoc = snapshot?.documents{
                    //got request
                    var requests:Array = [Request]()
                       
                    for requestDoc in requestsDoc{
                        let requestData = requestDoc.data()
                        let fullName = requestData["FullName"] as! String
                        let bloodGroup = requestData["BloodGroup"] as! String
                        let id = requestData["Id"] as! String
                        let imageUrl = requestData["ImageUrl"] as! String
                        let age = requestData["Age"] as! String
                        let phoneNumber = requestData["PhoneNumber"] as! String
                        let email = requestData["email"] as! String
                        let currentUserBloodGroup = requestData["currentuserbloodgroup"] as! String
                        
                        let request = Request(fullName: fullName, bloodGroup: bloodGroup, id: id,imageUrl: imageUrl,age: age,phoneNumber: phoneNumber, email: email, currentUserBlood: currentUserBloodGroup)
                        requests.append(request)
                    }
                    completion(true,"Get Request",requests)
                }
                
                else{
                    // request not found
                    completion(false,"Request data not found",nil)
                    
                }
                
            }
            else{
                //failure
                completion(false,error!.localizedDescription,nil)
            }
        }
    }
    
    func deleteRequest(id:String,completion:@escaping(_ status:Bool, _ message:String)->Void){
        
        
        firebaseFirestore.collection("Requests").document(id).delete { (error) in
            if error == nil{
                completion(true,"Request is deleted")
            }else{
                completion(false,error!.localizedDescription)
            }
        }
        
    }
    
    
}

