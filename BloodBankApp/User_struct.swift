//
//  File.swift
//  BloodBankApp
//
//  Created by Apple on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct User {
    static var sharedRef:User!
    
    var fullName:String
    var imageUrl:String
    var phoneNumber:String
    var bloodGroup:String
    var age:String
    var userId:String
    var email:String
    
    init(fullName:String,imageUrl:String,phoneNumber:String,bloodGroup:String,age:String,userId:String,email:String) {
        self.fullName = fullName
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
        self.bloodGroup = bloodGroup
        self.age = age
        self.userId = userId
        self.email = email
    }
    
    enum FirebaseKeys:String {
        case FullName = "FullName"
        case ImageUrl = "ImageUrl"
        case PhoneNumber = "PhoneNumber"
        case BloodGroup = "BloodGroup"
        case Age = "Age"
        case UserId = "UserId"
        case email = "email"
    }
    
    
    // this dic is used for fetching data from firebase (fetchuserdata)
    init(userDic:[String:Any]) {
        self.fullName = userDic[FirebaseKeys.FullName.rawValue] as! String
        self.imageUrl = userDic[FirebaseKeys.ImageUrl.rawValue] as! String
        self.phoneNumber = userDic[FirebaseKeys.PhoneNumber.rawValue] as! String
        self.bloodGroup = userDic[FirebaseKeys.BloodGroup.rawValue] as! String
        self.age = userDic[FirebaseKeys.Age.rawValue] as! String
        self.userId = userDic[FirebaseKeys.UserId.rawValue] as! String
        self.email = userDic[FirebaseKeys.email.rawValue] as! String
    }
    
    func getUserDic()->[String:Any]{
        
        return[
        
            FirebaseKeys.FullName.rawValue:self.fullName,
            FirebaseKeys.ImageUrl.rawValue:self.imageUrl,
            FirebaseKeys.PhoneNumber.rawValue:self.phoneNumber,
            FirebaseKeys.BloodGroup.rawValue:self.bloodGroup,
            FirebaseKeys.Age.rawValue:self.age,
            FirebaseKeys.UserId.rawValue:self.userId,
            FirebaseKeys.email.rawValue:self.email
            ]
    }
        
}
