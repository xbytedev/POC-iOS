//
//  AppTabBarView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 11/05/23.
//

import SwiftUI

struct AppTabBarView: View {

	@State var selection: TabItem = .groups

    var body: some View {
		MTTabBarContainerView(selection: $selection) {
			Color.red
				.tabBarItem(tab: .groups, selection: $selection)
			Color.blue
				.tabBarItem(tab: .checkIn, selection: $selection)
			Color.green
				.tabBarItem(tab: .settings, selection: $selection)
		}
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
