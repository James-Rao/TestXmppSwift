//
//  UserDetail.swift
//  SwiftNudge3
//
//  Created by James Rao on 14/01/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation


class UserDetail {
    var UserID: String?
    var Name: String?
    var Age: Int?
    var Gender: String?
    var Description: String?
    var Photos: [UserPhoto] = []
    
    func toString() -> String {
        var result = "UserID: \(UserID) \r\n Name: \(Name) \r\n Age: \(Age) \r\n Gender: \(Gender) Description: \(Description) \r\n "
        
        for photo in Photos {
            result += photo.toString()
        }
        
        return result
    }
}
