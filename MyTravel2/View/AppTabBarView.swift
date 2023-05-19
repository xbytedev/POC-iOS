//
//  AppTabBarView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 11/05/23.
//

import SwiftUI

struct AppTabBarView: View {

	@State var selection: TabItem = .groups
	@Environment(\.mtDismissable) var dismiss

    var body: some View {
		MTTabBarContainerView(selection: $selection) {
			GroupListView()
				.tabBarItem(tab: .groups, selection: $selection)
			CheckInView()
				.tabBarItem(tab: .checkIn, selection: $selection)
			SettingsView()
				.tabBarItem(tab: .settings, selection: $selection)
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button(action: dismiss) {
					Image(systemName: "chevron.backward")
						.padding()
						.myBackground {
							Circle()
								.foregroundColor(AppColor.Text.tertiary)
								.shadow(radius: 4, x: 2, y: 2)
						}
				}
			}
		}
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			AppTabBarView()
				.navigationBarTitleDisplayMode(.inline)
		}
    }
}
