//
//  SettingsView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct SettingsView: View {
	@Binding var shouldPopToRootView: Bool
	@State private var shouldPresentAlert: Bool = false

    var body: some View {
		List {
			Button {
				shouldPresentAlert = true
			} label: {
				Text(R.string.localizable.logout)
			}
		}
		.alert(isPresented: $shouldPresentAlert) {
			Alert(
				title: Text(R.string.localizable.areYouSure), message: Text(R.string.localizable.doYouWantToLogout),
				primaryButton: .cancel(Text(R.string.localizable.cancel)),
				secondaryButton: .destructive(
					Text(R.string.localizable.logout), action: {
						MTUserDefaults.currentUser = nil
						shouldPopToRootView = false
						WebRequesterSessionProvider.authStorage.refreshToken()
					}
				)
			)
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		SettingsView(shouldPopToRootView: .constant(false))
    }
}
