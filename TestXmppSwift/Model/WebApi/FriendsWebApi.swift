//
//  FriendsWebApi.swift
//  TestXmppSwift
//
//  Created by James Rao on 11/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit


class FriendsWebApi
{
    var delegate: FriendsDelegate?
    var myUserDetail: UserDetail?
    var myMyDetailWithProfileImage = MyDetailWithProfileImage()
    let urlString: String = "http://webapipub.nudgeus.com/api/nudge/getfriends"
    var responseGetFriends: ResponseGetFriends = ResponseGetFriends()
    
    
    func getProfileImage1(url: String, completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)
    {
        let imgURL: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: completion)
        
        task.resume()
    }
    
    
    func getMyProfileImage(url: String)
    {
        let imgURL: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let session = NSURLSession.sharedSession()
        
        self.myMyDetailWithProfileImage.userDetail = self.myUserDetail
        
        if isProfileImageChanged() {
            let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                
                if data != nil {
                    self.myMyDetailWithProfileImage.profileImage = UIImage(data: data!)
                    print("going to update")
                    MyDetail.update(self.myMyDetailWithProfileImage)
                }
                
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.delegate?.didReceiveResponseFromGetProfileImage(data!)
                }
            })
            
            task.resume()
        } else {
            print("get data from core data")
            self.delegate?.didReceiveResponseFromGetProfileImage(MyDetail.getMyDetail(myMyDetailWithProfileImage)!.profileImage!)
        }
    }
    
    
    private func isProfileImageChanged() -> Bool {
        
        if let myDetailInstance = MyDetail.getMyDetail(self.myMyDetailWithProfileImage) {
            
            if myDetailInstance.profileImageUrl == myMyDetailWithProfileImage.userDetail?.Photos[0].PhotoUrl {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    
    func getFriends()
    {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        if let _ = myUserDetail?.UserID {
            
            let params: [String:String] = ["userid": myUserDetail!.UserID!]
            //let params: [String:String] = ["userid": "1185"]
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            } catch {
                print("22222222222222")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                var result: NSDictionary!
                do
                {
                    result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                } catch {
                    print("33333333333333333")
                    return;
                }
                
                self.responseGetFriends.errorMessage = result["ErrorMessage"] as? String
                self.responseGetFriends.statusCode = StatusCode(rawValue: (result["StatusCode"] as! Int))
                if let responseGetFriendsFriends = result["Friends"] as? [AnyObject] {
                    self.responseGetFriends.friends = self.parseFriends(responseGetFriendsFriends)
                }
                
                // get each image from cloudinary
                if self.responseGetFriends.friends?.count > 0
                {
                    for friend in self.responseGetFriends.friends!
                    {
                        self.getFriendWithProfileImage(friend)
                    }
                }
            })
            
            task.resume()
        }
    }
    
    
    func getFriendWithProfileImage(friend: UserFriend) {
        
        let userFriendWithProfileImage = UserFriendWithProfileImage()
        userFriendWithProfileImage.userFriend = friend
        
        getProfileImage1(friend.profileImage!, completion: { (data, response, error) in
//            
//            print(data)
//            print(response)
//            print(error)
            
            userFriendWithProfileImage.profileImage = UIImage(data: data!)
            
            // callback to ViewController
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.delegate?.didReceiveResponseFromGetFriends(userFriendWithProfileImage)
            }
            
        })
    }
    
    
    func parseFriends(friends: [AnyObject]) -> [UserFriend]
    {
        print("aaaaaa")
        var result : [UserFriend] = []
        for friend in friends
        {
            let newFriend = UserFriend()
            newFriend.userID = friend["UserID"] as? String
            newFriend.profileImage = friend["ProfileImage"] as? String
            newFriend.lastMessage = friend["LastMessage"] as? String
            result.append(newFriend)
        }
        
        return result
    }
}
