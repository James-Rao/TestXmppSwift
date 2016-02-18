//
//  LogInApi.swift
//  SwiftNudge3
//
//  Created by James Rao on 14/01/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import CoreData


class LogInWebApi// : LogInProtocol
{
    var delegate: LogInDelegate?
    let urlString: String = "http://webapipub.nudgeus.com/api/login/login"
    var responseLogIn: ResponseLogIn = ResponseLogIn()
    
    
    func logIn(requestLogIn: RequestLogIn) {
        
        if let re = MyDetail.getMyDetail(requestLogIn.email) {
            
        } else {
            print("nonono")
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let params: [String:String] = ["email": requestLogIn.email, "password": requestLogIn.password, "DeviceToken": requestLogIn.deviceToken]
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("22222222222222")
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var result: NSDictionary!
            do {
                result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            } catch {
                print("33333333333333333")
                return
            }
            
            self.responseLogIn.errorMessage = result["ErrorMessage"] as? String
            self.responseLogIn.statusCode = StatusCode(rawValue: (result["StatusCode"] as! Int))
            if let responseLogInUserDetail = result["UserDetail"] as? NSDictionary {
                self.responseLogIn.myUserDetail = self.parseUserDetail(responseLogInUserDetail)
            }
            
            // callback to ViewController
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.delegate?.didReceiveResponseFromLogIn(self.responseLogIn)
            }
        })
        
        task.resume()
    }
    
    private func parseUserDetail(userDetail: NSDictionary) -> UserDetail{
        let result = UserDetail()
        result.Age = userDetail["Age"] as? Int
        result.Description = userDetail["Description"] as! String
        result.Gender = userDetail["Gender"] as! String
        result.Name = userDetail["Name"] as? String
        result.UserID = userDetail["UserID"] as? String
        
        // photos
        let photos = userDetail["Photos"] as! NSArray
        for photo in photos {
            let photoItem = photo as! NSDictionary
            let userPhoto = UserPhoto()
            userPhoto.IsProfile = photoItem["IsProfile"] as! Bool
            userPhoto.PhotoPublicID = photoItem["PhotoPublicID"] as! String
            userPhoto.PhotoUrl = photoItem["PhotoUrl"] as! String
            result.Photos.append(userPhoto)
        }
        
        return result
    }
}