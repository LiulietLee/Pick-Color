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
        do { try context.save() } catch { print("cannot save") }
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
    
    func saveNewColor(newColor: UIColor, title: String) -> Colors {
        let entity = NSEntityDescription.entity(forEntityName: "Colors", in: context)
        let newItem = Colors(entity: entity!, insertInto: context)
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if newColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
            newItem.alpha = a as NSNumber?
            newItem.red = r as NSNumber?
            newItem.green = g as NSNumber?
            newItem.blue = b as NSNumber?
            newItem.title = title
            
            saveContext()
        } else {
            print("cannot get the rgba of color")
        }
        
        return newItem
    }
    
    func saveEditedColor() {
        saveContext()
    }
    
    func deleteColor(_ color: Colors) {
        let object = color as NSManagedObject
        context.delete(object)
        
        saveContext()
    }
}
