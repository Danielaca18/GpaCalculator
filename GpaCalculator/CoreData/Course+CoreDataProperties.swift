//
//  Course+CoreDataProperties.swift
//  GpaCalculator
//
//  Created by Daniel Castro on 2023-02-15.
//
//

import Foundation
import CoreData
import SwiftUI


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged private var credit: Int32
    @NSManaged private var gpa: Float
    @NSManaged public var id: UUID
    @NSManaged private var name: String
    @NSManaged private var order: Int16
    
    /*
    * Getters and setters for name attribute
    */
    public var Name: String {
        set {name = newValue}
        get {return name}
    }
    
    public var Gpa: Float {
        set {gpa = newValue}
        get {return gpa}
    }
    
    public var Credit: Int {
        set {credit = Int32(newValue)}
        get {return Int(credit)}
    }
    
    public var Order: Int {
        set {order = Int16(newValue)}
        get {Int(order)}
    }

    /*
    * Creates a view binded to course entity
    * @Returns
    * View representing course
    */
}

extension Course : Identifiable {

}
