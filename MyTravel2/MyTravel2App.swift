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
			NavigationView {
				rootView
			}
			.navigationViewStyle(.stack)
//			if #available(iOS 16.0, *) {
//				NavigationStack {
//					rootView
//				}.navigationViewStyle(.columns)
//			} else {
//			}
        }
    }

	@ViewBuilder
	private var rootView: some View {
		let viewModel = AuthViewModel(provider: AuthAPIProvider())
		LoginView(viewModel: viewModel)
//		VerificationView()
		/*ContentView()
			.environment(\.managedObjectContext, persistenceController.container.viewContext)*/
	}
}
