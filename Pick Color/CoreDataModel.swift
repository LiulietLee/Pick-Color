//
//  CoreDataModel.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 27/8/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit
import CoreData

class CoreDataModel {
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    fileprivate func saveContext() {
        do { try context.save() } catch { print("save failed") }
    }
    
    func fetchColors() -> [Colors] {
        var colorItems = [Colors]()
        let fetchRequest = NSFetchRequest<Colors>(entityName: "Colors")
        
        do {
            try colorItems = context.fetch(fetchRequest)
        } catch {
            print("fetch failed")
        }
        
        return colorItems
    }
    
    func saveNewColor(_ newColor: UIColor, title: String) -> Colors {        
        let entity = NSEntityDescription.entity(forEntityName: "Colors", in: context)!
        let newItem = Colors(entity: entity, insertInto: context)
        newItem.title = title
        newItem.uiColor = newColor
        saveContext()
        return newItem
    }
    
    func saveEditedColor() {
        saveContext()
    }
    
    func deleteColor(_ color: Colors) {
        context.delete(color)
        saveContext()
    }
}
