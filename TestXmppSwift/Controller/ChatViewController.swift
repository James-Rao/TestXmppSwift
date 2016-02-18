//
//  ChatViewController.swift
//  TestXmppSwift
//
//  Created by James Rao on 15/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChatDelegate {
    
    // property
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var myMessageTextField: UITextField!
    var allChats: [ChatItemDetail] = []
    let chatWebApi: ChatWebApi = ChatWebApi()
    
//    var xmppServer: String = "webapi.nudgeus.com"
//    var xmppStream: XMPPStream = XMPPStream()
//    var xmppRosterStorage: XMPPRosterCoreDataStorage?
//    var xmppRoster: XMPPRoster?
    
    var friendJIDStr: String?
//    var myJIDStr: String?
    
    
    // func
    @IBAction func sendMessage(sender: AnyObject) {
        
//        let presence = XMPPPresence(type: "unavailable")
//        xmppStream.sendElement(presence)
        
        if let thisMessage = myMessageTextField.text {
            let newIndexPath = NSIndexPath(forRow: allChats.count, inSection: 0)
            let chat = ChatItemDetail()
            chat.isIn = false
            chat.chatMessage = thisMessage
            chat.profileImage = chatWebApi.myMyDetailWithProfileImage?.profileImage //myProfileImage
            allChats.append(chat)
            chatTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
            // send by xmpp
            if thisMessage.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                let body = DDXMLElement.elementWithName("body") as! DDXMLElement
                body.setStringValue(thisMessage)
                let message = DDXMLElement.elementWithName("message") as! DDXMLElement
                message.addAttributeWithName("type", stringValue: "chat") //"chat") // test
                message.addAttributeWithName("to", stringValue: friendJIDStr)
                message.addChild(body)
                XMPPManager.sharedXmppStream!.sendElement(message)
                
                // test for other state
//                let message1 = DDXMLElement.elementWithName("message") as! DDXMLElement
//                message1.addAttributeWithName("type", stringValue: "chat")
//                message1.addAttributeWithName("to", stringValue: friendJIDStr)
//                let composing = DDXMLElement.elementWithName("composing") as! DDXMLElement
//                composing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
//                message1.addChild(composing)
//                xmppStream.sendElement(message1)
            }
        }
    }
    
    
    // for the table view
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChats.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let chatItem = allChats[indexPath.row]
        
        if chatItem.isIn! {
            let cellIdentifier = "chatOutCell"
            if let cell: ChatOutTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ChatOutTableViewCell {
                cell.profileImageView.contentMode = .ScaleAspectFill
                cell.profileImageView.layer.cornerRadius = CGRectGetWidth(cell.profileImageView.frame) / 2.0
                cell.profileImageView.layer.masksToBounds = true;
                cell.profileImageView.image = chatItem.profileImage
                cell.chatMessageLabel.text = chatItem.chatMessage
                return cell
            }
        } else {
            let cellIdentifier = "chatInCell"
            if let cell: ChatInTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ChatInTableViewCell {
                cell.profileImageView.contentMode = .ScaleAspectFill
                cell.profileImageView.layer.cornerRadius = CGRectGetWidth(cell.profileImageView.frame) / 2.0
                cell.profileImageView.layer.masksToBounds = true;
                cell.profileImageView.image = chatItem.profileImage
                cell.chatMessageLabel.text = chatItem.chatMessage
                return cell
            }
        }
        
        return UITableViewCell()
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        // 
        XMPPManager.setMyJIDStr((chatWebApi.myMyDetailWithProfileImage?.userDetail?.UserID!)!)
        XMPPManager.initXMPP()
        
        // 
        XMPPManager.sharedXmppStream?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        XMPPManager.sharedXmppRoster?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
//        // xmpp
//        xmppStream.addDelegate(self, delegateQueue:dispatch_get_main_queue())
//        myJIDStr = (chatWebApi.myMyDetailWithProfileImage?.userDetail?.UserID!)! + "@" + xmppServer
//        xmppStream.myJID = XMPPJID.jidWithString(myJIDStr!)
//        xmppStream.hostName = xmppServer
//        
//        //
//        xmppRosterStorage = XMPPRosterCoreDataStorage.init()//.initWithInMemoryStore()
//        xmppRoster = XMPPRoster.init(rosterStorage: xmppRosterStorage)
//        
//        xmppRoster!.autoFetchRoster = true
//        xmppRoster!.autoAcceptKnownPresenceSubscriptionRequests = true
//        xmppRoster!.addDelegate(self, delegateQueue:dispatch_get_main_queue())
//        xmppRoster!.activate(xmppStream)
//        
//        xmppRoster!.addUser(XMPPJID.jidWithString(myJIDStr!), withNickname: nil)
        
        // 
        friendJIDStr = (chatWebApi.friendWithProfileImage?.userFriend?.userID!)! + "@" + XMPPManager.sharedXmppServer
       
        
        do
        {
            try XMPPManager.sharedXmppStream?.connectWithTimeout(10.00)
        } catch {
            print("Oops, I probably forgot something");
        }
    }
    
    
    func xmppStreamDidRegister(sender: XMPPStream!) {
        print("succeed to register")
        do {
            try XMPPManager.sharedXmppStream?.authenticateWithPassword("abc")
        } catch {
        }
    }
    
    
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        print("fail to register " + error.description)
        do {
            try XMPPManager.sharedXmppStream?.authenticateWithPassword("abc")
        } catch {
        }
    }
    
    func xmppStreamDidAuthenticate(sender:XMPPStream!) {
        
        print("enter did authenticate")
        
        // set presence.  to get message.
        let presence = XMPPPresence()
        XMPPManager.sharedXmppStream?.sendElement(presence)
        
        // test add new buddy
        let newBuddy = XMPPJID.jidWithString(friendJIDStr)
        XMPPManager.sharedXmppRoster?.addUser(newBuddy, withNickname: nil)
        print("**** send request")
    }
    
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print(message.description)
        print("*****************")
//        
//        NSString *msg = [[message elementForName:@"body"] stringValue];
//        NSString *from = [[message attributeForName:@"from"] stringValue];
        
        
        if let messageBody = message.elementForName("body") {
            print("1111")
            
            let messageBodyStr = messageBody.stringValue()
            let newIndexPath = NSIndexPath(forRow: allChats.count, inSection: 0)
            let chat = ChatItemDetail()
            chat.isIn = true
            chat.chatMessage = messageBodyStr
            chat.profileImage = chatWebApi.friendWithProfileImage?.profileImage //myProfileImage
            allChats.append(chat)
            chatTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
        } else if let messageComposing = message.elementForName("composing") {
            print("2222")
        } else if let messagePaused = message.elementForName("paused") {
            print("3333")
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        
        releaseXMPP()
    }
    
    private func releaseXMPP() {
 
        let presence = XMPPPresence(type: "unavailable")
        XMPPManager.sharedXmppStream?.sendElement(presence)
        
        XMPPManager.releaseXMPP()
    }
    
    
    func xmppStream(sender: XMPPStream!, didFailToSendPresence presence: XMPPPresence!, error: NSError!) {
        print("********")
        print("didFailToSendPresence")
        print(error.description)
    }
    
    
    // seems to get all roster
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        print("********")
        print("didReceiveRosterItem ")
        print(item)
    }
    
    
    // seems to only get online roster
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterPush iq: XMPPIQ!) {
        print("********")
        print("didReceiveRosterPush")
        print(iq)
    }
   

    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        print("7777")
        let presenceType = presence.type()
        let presenceFromUser = presence.from()
        
        print(presenceFromUser)
        print(presenceType)
        
        if presenceType == "subscribe" {
            print("7777 go to accept")
            XMPPManager.sharedXmppRoster?.acceptPresenceSubscriptionRequestFrom(presenceFromUser, andAddToRoster: true)
        }
    }
    
    
//    - (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
//    {
//    NSString *presenceType = [presence type]; // online / offline
//    NSString *myUsername = [[sender myJID] user];
//    NSString *presenceFromUser = [[presence from] user];
//    NSString *presencefromStr=[presence fromStr];
//    
//    if  ([presenceType isEqualToString:@"subscribe"]) {
//    if(buttonIndex==1) { // For accept button
//    [xmppRoster acceptPresenceSubscriptionRequestFrom:[tmpPresence from] andAddToRoster:YES];
//    }
//    else { // For reject button
//    [xmppRoster rejectPresenceSubscriptionRequestFrom:[tmpPresence from]];
//    }
//    }
    
    
//    - (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
//    {
//    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
//    
//    NSString *presenceType = [presence type];            // online/offline
//    NSString *myUsername = [[sender myJID] user];
//    NSString *presenceFromUser = [[presence from] user];
//    //
//    //new request from unknow user
//    if (![presenceFromUser isEqualToString:myUsername])
//    {
//    if  ([presenceType isEqualToString:@"subscribe"])
//    {
//    //[_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, kHostName]];
//    NSLog(@"presence user wants to subscribe %@",presenceFromUser);
//    tempPresence = [[XMPPPresence alloc] init];
//    tempPresence = presence;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New request From:" message:presenceFromUser delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
//    [alert show];
//    }
//    }
//    }
    
    func xmppStreamDidConnect(sender: XMPPStream )
    {
        print("12345")

        do {
            try XMPPManager.sharedXmppStream?.registerWithPassword("abc")
        } catch {
            print("cant register")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
