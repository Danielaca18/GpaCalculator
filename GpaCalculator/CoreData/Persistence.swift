//
//  Persistence.swift
//  GpaCalculator
//
//  Created by Daniel Castro on 2023-02-15.
//

import CoreData

// Class responsible for data persistence
struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for x in 0..<4 {
            let newCourse = Course(context: viewContext)
            newCourse.id = UUID()
            newCourse.name = "Course"
            newCourse.gpa = Float(x)
            newCourse.credit = Int32(x)
        }
        do { try viewContext.save() }
        catch {
            viewContext.rollback()
            print(error)
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GpaCalculator")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
