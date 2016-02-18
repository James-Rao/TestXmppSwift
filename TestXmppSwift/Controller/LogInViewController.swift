//
//  ViewController.swift
//  TestXmppSwift
//
//  Created by James Rao on 17/01/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData

class LogInViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, LogInDelegate {
    
    // property
    let logInWebApi = LogInWebApi()
    let mbprogressHUD = MBProgressHUD()

    // controller property
    @IBOutlet weak var labelLogInMessage: UILabel!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textEmailCenterYContraint: NSLayoutConstraint!
    


    var isKeyboardShow: Bool = false
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        
        textPassword.resignFirstResponder()
        textEmail.resignFirstResponder()
        
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        
        if !isKeyboardShow {
            isKeyboardShow = true
            let userInfo: [NSObject : AnyObject] = sender.userInfo!
            let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        
        if isKeyboardShow {
            isKeyboardShow = false
            let userInfo: [NSObject : AnyObject] = sender.userInfo!
            let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
            self.view.frame.origin.y += keyboardSize.height
        }
        
    }
  

    func didReceiveResponseFromLogIn(response: ResponseLogIn) {
        
        print("login finished")
 
        
        //
        if response.statusCode == StatusCode.Success {
            labelLogInMessage.text = "Succeed!"
            print("will navegate")
            self.performSegueWithIdentifier("getFriends", sender: self)
        } else {
            labelLogInMessage.text = response.errorMessage
        }
        
        // 
        mbprogressHUD.hide(true)
    }

    
    @IBAction func LogIn(sender: AnyObject) {
        
        labelLogInMessage.text = ""
        textEmail.resignFirstResponder()
        textPassword.resignFirstResponder()
        
        let requestLogIn = RequestLogIn()
        requestLogIn.deviceToken = "abcdefg"
        requestLogIn.email = textEmail.text!
        requestLogIn.password = textPassword.text!
        logInWebApi.logIn(requestLogIn)
        
        mbprogressHUD.show(true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getFriends"{
//            let obj = segue.destinationViewController as! FriendsViewController
//            obj.logInVC = self
            var destination = segue.destinationViewController 
            if let navVC = destination as? UINavigationController {
                destination = navVC.visibleViewController!
            }
            let obj = destination as! FriendsViewController
            obj.logInVC = self
        }
    }
    
    
    // function
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        
//        
//        //test coredata
//        //write
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        
//        //2
//        let entity =  NSEntityDescription.entityForName("MyDetail", inManagedObjectContext:managedContext)
//        
//        //let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
//        let person = MyDetail(entity: entity!, insertIntoManagedObjectContext: managedContext)
//        
//        //3
//        //person.setValue("James", forKey: "name")
//        person.name = "Mahdi"
//        
//        //4
//        do {
//            try managedContext.save()
//            //5
//            //people.append(person)
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        
//        
//        // read
//        let fetchRequest = NSFetchRequest(entityName: "MyDetail")
////        let predicate1 = NSPredicate(format: "name = %@", "James")
//        let predicate1 = NSPredicate(format: "name CONTAINS[cd] %@ or name CONTAINS[cd] %@", "James", "Mahdi")
//        let compound = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [predicate1])
//        fetchRequest.predicate = compound
//        
////        var request = NSFetchRequest(entityName: "Answers")
////        request.returnsObjectsAsFaults = false;
////        
////        let resultPredicate1 = NSPredicate(format: "qIndex = %i", qIndex)
////        let resultPredicate2 = NSPredicate(format: "formUUID = %s", formUUID)
////        
////        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2])
////        request.predicate = compound
////
//        //3
//        do {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            let persons = results as! [MyDetail]
//            print(persons.count)
//            for item in persons {
//                print(item.name)
//            }
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        
//        
//        
//        
        
        
        logInWebApi.delegate = self
        view.addSubview(mbprogressHUD)
        mbprogressHUD.dimBackground = true
        textEmail.delegate = self
        textPassword.delegate = self
        
        // for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        // add gesture to trigger keyboard
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
        
        //
        self.imageView.image = self.imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageViewTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let userDetail = logInWebApi.responseLogIn.myUserDetail {
            print(userDetail.toString())
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
        
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    func imageViewTapped(recognizer: UITapGestureRecognizer) {
        //imageView.layer.removeAllAnimations()
        //self.imageView.tintColor = UIColor.greenColor()
        imageView.layer.removeAllAnimations()
        imageView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let colorSequence = [UIColor.blueColor(), UIColor.greenColor(), UIColor.redColor()]
//        let colorSequence = [UIColor.grayColor(), UIColor.redColor()]
        let index: Int = -1
        
        myAnimate(colorSequence, index: index)
    }
    
    
    func myAnimate(colorSequence: [UIColor], var index: Int) {

        index++
        if index == colorSequence.count {
            index = 0
        }
        
        UIView.animateWithDuration(2, delay: 0.0, options:[UIViewAnimationOptions.AllowUserInteraction], animations: {
            self.imageView.tintColor = colorSequence[index]
            }, completion: {finished in
                self.myAnimate(colorSequence, index: index)
        })
    }
}


// important. this can be used by setting default tint at the inspector, which can only support 2 colors totally.
//UIView.animateWithDuration(2, delay: 0.0, options:[UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.Repeat, UIViewAnimationOptions.Autoreverse], animations: {
//    //            self.imageView.tintColor = UIColor.redColor()
//    
//    }, completion: nil)

