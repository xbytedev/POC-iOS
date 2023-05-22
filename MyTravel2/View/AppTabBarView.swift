//
//  AppTabBarView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 11/05/23.
//

import SwiftUI

struct AppTabBarView: View {

	@State var selection: TabItem = .groups
	@Binding var rootIsActive: Bool

    var body: some View {
		MTTabBarContainerView(selection: $selection) {
			GroupListView()
				.tabBarItem(tab: .groups, selection: $selection)
			CheckInView()
				.tabBarItem(tab: .checkIn, selection: $selection)
			SettingsView(shouldPopToRootView: $rootIsActive)
				.tabBarItem(tab: .settings, selection: $selection)
		}
		.setThemeBackButton()
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
		AppTabBarView(rootIsActive: .constant(false))
    }
}
