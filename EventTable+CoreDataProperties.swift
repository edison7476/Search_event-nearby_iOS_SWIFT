//
//  EventTable+CoreDataProperties.swift
//  project19_mapKit
//
//  Created by Jia Wang on 7/26/16.
//  Copyright © 2016 Jia Wang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EventTable {

    @NSManaged var title: String?
    @NSManaged var time: String?
    @NSManaged var venue: String?
    @NSManaged var address: String?

}
