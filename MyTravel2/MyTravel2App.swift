//
//  MyTravel2App.swift
//  MyTravel2
//
//  Created by Mrugesh Tank on 05/05/23.
//

import SwiftUI

@main
struct MyTravel2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
