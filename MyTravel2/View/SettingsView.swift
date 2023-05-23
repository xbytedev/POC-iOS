//
//  SettingsView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct SettingsView: View {
	@Binding var shouldPopToRootView: Bool

    var body: some View {
		List {
			Button {
				MTUserDefaults.currentUser = nil
				shouldPopToRootView = false
			} label: {
				Text("Logout")
			}
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		SettingsView(shouldPopToRootView: .constant(false))
    }
}
