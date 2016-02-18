//
//  UserPhoto.swift
//  SwiftNudge3
//
//  Created by James Rao on 14/01/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation


class UserPhoto {
    var IsProfile: Bool?
    var PhotoPublicID: String?
    var PhotoUrl: String?
    //var PhotoSecureUrl: String = ""
    
    func toString() -> String {
        return "IsProfile: \(IsProfile) \r\n PhotoPublicID: \(PhotoPublicID) \r\n PhotoUrl: \(PhotoUrl)"
    }
}