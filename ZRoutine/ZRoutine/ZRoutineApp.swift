//
//  ZRoutineApp.swift
//  ZRoutine
//
//  Created by Daniella Stokic on 1/25/21.
//

import SwiftUI

@main
struct ZRoutineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
