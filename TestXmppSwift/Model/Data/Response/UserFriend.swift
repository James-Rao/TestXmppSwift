//
//  UserFriend.swift
//  TestXmppSwift
//
//  Created by James Rao on 12/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation


class UserFriend
{
    var userID: String?
    var name: String?
    var profileImage: String? = ""
    var relation: Int? = 0
    var isOnline: Bool = false
    var isLogIn: Bool = false
    var lastMessage: String? = ""
    var lastMessageTimeBigInt: Int64? = 0
    var lastMessageTime: String? = ""
}