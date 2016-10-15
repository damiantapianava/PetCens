//
//  Responsable+CoreDataProperties.swift
//  PetCens
//
//  Created by Infraestructura on 14/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Responsable {

    @NSManaged var apellidos: String?
    @NSManaged var calleyno: String?
    @NSManaged var colonia: String?
    @NSManaged var estado: String?
    @NSManaged var fechanacimiento: NSDate?
    @NSManaged var municipio: String?
    @NSManaged var nombre: String?

}
