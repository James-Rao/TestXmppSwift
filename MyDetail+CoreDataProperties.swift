//
//  MyDetail+CoreDataProperties.swift
//  TestXmppSwift
//
//  Created by James Rao on 18/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyDetail {

    @NSManaged var aboutMe: String?
    @NSManaged var age: NSNumber?
    @NSManaged var email: String?
    @NSManaged var gender: String?
    @NSManaged var name: String?
    @NSManaged var password: String?
    @NSManaged var profileImage: NSData?
    @NSManaged var userID: String?
    @NSManaged var profileImageUrl: String?

}
