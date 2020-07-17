//
//  MessagesClass.swift
//  BloodBankApp
//
//  Created by Apple on 3/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import FirebaseAuth

class MessagesClass:Comparable {
    
    static var messagesSharedReference:MessagesClass!
    
    static func == (lhs: MessagesClass, rhs: MessagesClass) -> Bool {
        return true
    }
    
    static func < (lhs: MessagesClass, rhs: MessagesClass) -> Bool {
        lhs.timestamp! > rhs.timestamp!
    }
    
    var fromId:String?
    var text:String?
    var timestamp:Int?
    var toId:String?
    
    init(dictionary: [String: Any]) {
         self.fromId = dictionary["FromID"] as? String
         self.text = dictionary["Message"] as? String
         self.toId = dictionary["ToID"] as? String
         self.timestamp = dictionary["Timestamp"] as? Int
     }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
