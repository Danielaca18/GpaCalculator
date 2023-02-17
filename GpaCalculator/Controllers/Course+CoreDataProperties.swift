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

    @NSManaged public var credit: Int32
    @NSManaged public var gpa: Float
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var order: Int16

    /*
    * Creates a view binded to course entity
    * @Returns
    * View representing course
    */
    func view(Name: Binding<String>, Gpa: Binding<Float>, Credit: Binding<Int>) -> some View {
        
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        
        return HStack {
            TextField("", text: Name)
                .multilineTextAlignment(.center)
                .onSubmit{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            TextField("", value: Gpa, formatter: decimalFormatter)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .onSubmit{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            TextField("", value: Credit, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .onSubmit{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }.listRowBackground(Color.clear)
    }
    
}

extension Course : Identifiable {

}
