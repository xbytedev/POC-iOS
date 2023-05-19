//
//  SettingsView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
		ScrollView {
			Button {
				MTUserDefaults.currentUser = nil
			} label: {
				Text("Logout")
			}
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
