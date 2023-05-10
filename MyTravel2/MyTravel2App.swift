//
//  MyTravel2App.swift
//  MyTravel2
//
//  Created by Mrugesh Tank on 05/05/23.
//

import SwiftUI

@main
struct MyTravel2App: App {
	// register app delegate
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
			let viewModel = AuthViewModel(provider: AuthAPIProvider())
			LoginView(viewModel: viewModel)
        }
    }
}
