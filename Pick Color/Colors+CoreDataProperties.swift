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

extension Colors {
    convenience init?(uiColor: UIColor){
        self.init()
        self.uiColor = uiColor
    }

    func updateColor(fromComponents components: [CGFloat]) {
        red = components[0] as NSNumber?
        green = components[1] as NSNumber?
        blue = components[2] as NSNumber?
        alpha = components[3] as NSNumber?
    }

    var uiColor: UIColor? {
        get {
            if let red = red, let green = green, let blue = blue, let alpha = alpha{
                return UIColor(
                    red: red as CGFloat,
                    green: green as CGFloat,
                    blue: blue as CGFloat,
                    alpha: alpha as CGFloat)
            }
            return nil
        }
        set {
            if let newValue = newValue{
                var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                if newValue.getRed(&r, green: &g, blue: &b, alpha: &a) {
                    alpha = a as NSNumber?
                    red = r as NSNumber?
                    green = g as NSNumber?
                    blue = b as NSNumber?
                } else {
                    print("Unable to get rgba values from \(newValue)")
                }
            }
        }
    }
}
