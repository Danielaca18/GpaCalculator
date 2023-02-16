//
//  GpaCalculatorApp.swift
//  GpaCalculator
//
//  Created by Daniel Castro on 2023-02-15.
//

import SwiftUI

@main
struct GpaCalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
