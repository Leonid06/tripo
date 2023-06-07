//
//  TripoApp.swift
//  Tripo
//
//  Created by Leonid on 07.06.2023.
//

import SwiftUI

@main
struct TripoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
