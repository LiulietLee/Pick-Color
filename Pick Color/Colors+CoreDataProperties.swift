//
//  Colors+CoreDataProperties.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 27/8/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Colors {

    @NSManaged var alpha: NSNumber?
    @NSManaged var red: NSNumber?
    @NSManaged var green: NSNumber?
    @NSManaged var blue: NSNumber?
    @NSManaged var title: String?

}
