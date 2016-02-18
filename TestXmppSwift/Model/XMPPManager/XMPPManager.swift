//
//  XMPPManager.swift
//  TestXmppSwift
//
//  Created by James Rao on 17/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation


class XMPPManager : NSObject {
    
//    var xmppServer: String = "webapi.nudgeus.com"
//    var xmppStream: XMPPStream = XMPPStream()
//    var xmppRosterStorage: XMPPRosterCoreDataStorage?
//    var xmppRoster: XMPPRoster?
//    
//    var friendJIDStr: String?
//    var myJIDStr: String?
    static let sharedXmppServer: String = "webapi.nudgeus.com"
    static var sharedXmppStream: XMPPStream?
    static var sharedMyJIDStr: String?
    static var sharedXmppRosterStorage: XMPPRosterCoreDataStorage?
    static var sharedXmppRoster: XMPPRoster?
    static var sharedXmppReconnect: XMPPReconnect?
    
    
    static func initXMPP() {
        
        if sharedXmppStream == nil {
            //
            sharedXmppStream = XMPPStream()
            sharedXmppStream!.myJID = XMPPJID.jidWithString(sharedMyJIDStr!)
            sharedXmppStream!.hostName = sharedXmppServer
            
            //
            sharedXmppRosterStorage = XMPPRosterCoreDataStorage.init() // too see its .m definition. it would create a default db file which would dealloc when send unavailable presence
            sharedXmppRoster = XMPPRoster.init(rosterStorage: sharedXmppRosterStorage)
            
            sharedXmppRoster!.autoFetchRoster = true
            sharedXmppRoster!.autoAcceptKnownPresenceSubscriptionRequests = true
            sharedXmppRoster!.addDelegate(self, delegateQueue:dispatch_get_main_queue())
            sharedXmppRoster!.activate(sharedXmppStream)
            
//            sharedXmppRosterStorage!.setPhoto(UIImage(named: "test"), forUserWithJID:  XMPPJID.jidWithString(sharedMyJIDStr), xmppStream: sharedXmppStream)
//            sharedXmppRoster!.addUser(XMPPJID.jidWithString(sharedMyJIDStr!), withNickname: nil)
            
            //
            sharedXmppReconnect = XMPPReconnect()
            sharedXmppReconnect!.activate(sharedXmppStream)
        }
    }
    
    
    static func releaseXMPP() {
        
        sharedXmppRoster?.deactivate()
        sharedXmppReconnect?.deactivate()
        sharedXmppStream?.disconnect()
        
        sharedXmppRoster = nil
        sharedXmppReconnect = nil
        sharedXmppStream = nil
        sharedXmppRosterStorage = nil
        //
        //        [xmppReconnect         deactivate];
        //        [xmppRoster            deactivate];
        //        [xmppvCardTempModule   deactivate];
        //        [xmppvCardAvatarModule deactivate];
        //        [xmppCapabilities      deactivate];
        //
        //        [xmppStream disconnect];
        //
        //        xmppStream = nil;
        //        xmppReconnect = nil;
        //        xmppRoster = nil;
        //        xmppRosterStorage = nil;
        //        xmppvCardStorage = nil;
        //        xmppvCardTempModule = nil;
        //        xmppvCardAvatarModule = nil;
        //        xmppCapabilities = nil;
        //        xmppCapabilitiesStorage = nil;
    }
    
    static func setMyJIDStr(userID: String) {
        sharedMyJIDStr = userID + "@" + sharedXmppServer
    }
}