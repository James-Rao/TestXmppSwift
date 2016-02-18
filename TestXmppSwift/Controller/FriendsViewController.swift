//
//  FriendsViewController.swift
//  TestXmppSwift
//
//  Created by James Rao on 11/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, FriendsDelegate, UITableViewDataSource, UITableViewDelegate {

    var logInVC: LogInViewController? // from login viewcontroller
    let friendsWebApi = FriendsWebApi()
    var userFriendsWithProfileImage: [UserFriendWithProfileImage] = []
    var isEnterPoint: Bool = false
    
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var tableViewFriends: UITableView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showChat" {
            var destination = segue.destinationViewController
            if let navVC = destination as? UINavigationController {
                destination = navVC.visibleViewController!
            }
            let obj = destination as! ChatViewController
            obj.chatWebApi.myMyDetailWithProfileImage = self.friendsWebApi.myMyDetailWithProfileImage
            
            if let selectedCell = sender as? FriendTableViewCell {
                let indexPath = tableViewFriends.indexPathForCell(selectedCell)
                let selectedFriend = userFriendsWithProfileImage[(indexPath?.row)!]
                obj.chatWebApi.friendWithProfileImage = selectedFriend
            }
        }
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("enter friends")
        if !isEnterPoint {
            friendsWebApi.myUserDetail = logInVC?.logInWebApi.responseLogIn.myUserDetail
        }
        
        friendsWebApi.delegate = self
        tableViewFriends.dataSource = self
        tableViewFriends.delegate = self
        
        myProfileImageView.layer.cornerRadius = CGRectGetWidth(myProfileImageView.frame)/2.0
        myProfileImageView.layer.masksToBounds = true
        
        // download profile image
        getProfileImage()
        
        // test
        getFriends()
    }
    
    
    func getProfileImage()
    {
        if let thisPhotos = friendsWebApi.myUserDetail?.Photos {
//            for photo in thisPhotos
//            {
//                if photo.IsProfile
//                {
                    friendsWebApi.getMyProfileImage(thisPhotos[0].PhotoUrl!)
                //}
            //}
        }
    }
    
    
    func didReceiveResponseFromGetProfileImage(image: NSData)
    {
        self.myProfileImageView.image = UIImage(data: image)
    }
    
    
    func getFriends()
    {
        friendsWebApi.getFriends()
    }
    
    
    func didReceiveResponseFromGetFriends(response: UserFriendWithProfileImage)
    {
        let newIndexPath = NSIndexPath(forRow: userFriendsWithProfileImage.count, inSection: 0)
        userFriendsWithProfileImage.append(response)
        tableViewFriends.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
    }
    
    
    // for the table view
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFriendsWithProfileImage.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "friendCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FriendTableViewCell
        
        let friend = userFriendsWithProfileImage[indexPath.row]
//        
//        cell.nameLabel.text = meal.name
//        cell.photoImageView.image = meal.photo
//        cell.ratingControl.rating = meal.rating
        
        cell.imageViewProfile.contentMode = .ScaleAspectFill
       
        //let testImage = UIImage(named: "test")
        cell.imageViewProfile.layer.cornerRadius = CGRectGetWidth(cell.imageViewProfile.frame) / 2.0
        cell.imageViewProfile.layer.masksToBounds = true;
        cell.imageViewProfile.image = friend.profileImage
        
        cell.labelChatMessage.text = friend.userFriend?.lastMessage
        
        return cell
    }
}
