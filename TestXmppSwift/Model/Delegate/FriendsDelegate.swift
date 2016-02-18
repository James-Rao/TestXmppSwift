//
//  FriendsDelegate.swift
//  TestXmppSwift
//
//  Created by James Rao on 11/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation

protocol FriendsDelegate {
    func didReceiveResponseFromGetFriends(response: UserFriendWithProfileImage)
    func didReceiveResponseFromGetProfileImage(image: NSData)
}