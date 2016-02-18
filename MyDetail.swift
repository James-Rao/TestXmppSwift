//
//  MyDetail.swift
//  TestXmppSwift
//
//  Created by James Rao on 18/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import CoreData


class MyDetail: NSManagedObject {
    
    static let _entityName = "MyDetail"
    static var _managedObjectContext : NSManagedObjectContext?
    
    
    static func setManagedObjectContext(moc: NSManagedObjectContext) {
        
        MyDetail._managedObjectContext = moc
    }
    
    static private func createMyDetail(me: MyDetailWithProfileImage) {
        
        guard _managedObjectContext != nil else {
            print("no managedobjectcontext")
            return
        }
        
        guard let myDetail = NSEntityDescription.insertNewObjectForEntityForName(_entityName, inManagedObjectContext: _managedObjectContext!) as? MyDetail else {
            print("no such entity: " + _entityName)
            return
        }
        
        clone(me, destination: myDetail)
        
        save()
    }
    
    
    private static func save() {
        
        do {
            try _managedObjectContext!.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    private static func clone(source: MyDetailWithProfileImage, destination: MyDetail) {
        
        destination.name = source.userDetail!.Name
        destination.userID = source.userDetail!.UserID
        destination.gender = source.userDetail!.Gender
        destination.aboutMe = source.userDetail!.Description
        destination.profileImage = UIImagePNGRepresentation(source.profileImage!)
        destination.email = source.email
        destination.password = source.password
        destination.profileImageUrl = source.userDetail?.Photos[0].PhotoUrl
    }
    
    
    static func clone(source: MyDetail) -> MyDetailWithProfileImage? {
        
        let destination = MyDetailWithProfileImage()
        destination.userDetail = UserDetail()
        destination.userDetail!.Name = source.name
        destination.userDetail!.UserID = source.userID
        destination.userDetail!.Gender = source.gender
        destination.userDetail!.Description = source.aboutMe
        destination.profileImage = UIImage(data: source.profileImage!)
        destination.email = source.email
        destination.password = source.password
        let userPhoto = UserPhoto()
        userPhoto.PhotoUrl = source.profileImageUrl
        destination.userDetail!.Photos.append(userPhoto)
        return destination
    }
    
    
    static func getMyDetail() -> MyDetail? {
        
        let fetchRequest = NSFetchRequest(entityName: _entityName)
        
        do {
            let results = try _managedObjectContext!.executeFetchRequest(fetchRequest)
            let mes = results as! [MyDetail]
            print(mes.count)
            for item in mes {
                print(item.email)
            }
            if mes.count == 0 {
                return nil
            } else {
                return mes[0]
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    
    static func getMyDetail(email: String) -> MyDetail? {
        
        let fetchRequest = NSFetchRequest(entityName: _entityName)
        let predicate1 = NSPredicate(format: "email = %@", email)
        //let predicate1 = NSPredicate(format: "name CONTAINS[cd] %@ or name CONTAINS[cd] %@", "James", "Mahdi")
        let compound = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [predicate1])
        fetchRequest.predicate = compound
        
        do {
            let results = try _managedObjectContext!.executeFetchRequest(fetchRequest)
            let mes = results as! [MyDetail]
            print(mes.count)
            for item in mes {
                print(item.email)
            }
            if mes.count == 0 {
                return nil
            } else {
                return mes[0]
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    
    static func getMyDetail(me: MyDetailWithProfileImage) -> MyDetail? {
        
        let fetchRequest = NSFetchRequest(entityName: _entityName)
        let predicate1 = NSPredicate(format: "userID = %@", me.userDetail!.UserID!)
        //let predicate1 = NSPredicate(format: "name CONTAINS[cd] %@ or name CONTAINS[cd] %@", "James", "Mahdi")
        let compound = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [predicate1])
        fetchRequest.predicate = compound
        
        do {
            let results = try _managedObjectContext!.executeFetchRequest(fetchRequest)
            let mes = results as! [MyDetail]
            print(mes.count)
            for item in mes {
                print(item.name)
            }
            if mes.count == 0 {
                return nil
            } else {
                return mes[0]
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    
    static func update(me: MyDetailWithProfileImage) {
        
        guard _managedObjectContext != nil else {
            print("no managedobjectcontext")
            return
        }
        
        if let myDetail = getMyDetail(me) {
            clone(me, destination: myDetail)
        } else {
            createMyDetail(me)
        }
        
        save()
    }
}
