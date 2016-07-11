//
//  Reminder+CoreDataProperties.swift
//  HitList
//
//  Created by Catalin David on 30/06/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reminder {

    @NSManaged var taskName: String?
    @NSManaged var taskHoure: String?

}
