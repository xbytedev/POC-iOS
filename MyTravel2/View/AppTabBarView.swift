//
//  AppTabBarView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 11/05/23.
//

import SwiftUI

struct AppTabBarView: View {

	@State private var isPopupPresented: Bool = false
	@State var selection: TabItem = .groups
	@Binding var rootIsActive: Bool
	@State private var shouldGroupSuccess: Bool = false
	@State private var createdGroup: MTGroup?
	@State private var shouldAddTraveler: Bool = false
	@State private var checkInSelection = SegmentItem.places
	@StateObject private var groupViewModel = GroupViewModel(provider: GroupAPIProvider())

    var body: some View {
		ZStack {
			MTTabBarContainerView(selection: $selection, checkInSelection: $checkInSelection) {
				GroupListView(
					isPopupPresented: $isPopupPresented, viewModel: groupViewModel,
					shouldGroupSuccess: $shouldGroupSuccess, createdGroup: $createdGroup, shouldAddTraveler: $shouldAddTraveler)
					.tabBarItem(tab: .groups, selection: $selection)
				LocationView(groupViewModel: groupViewModel, selection: $checkInSelection)
					.tabBarItem(tab: .checkIn, selection: $selection)
				SettingsView(shouldPopToRootView: $rootIsActive)
					.tabBarItem(tab: .settings, selection: $selection)
			}
			CreateGroupView(
				isPresenting: $isPopupPresented, viewModel: groupViewModel) { group in
					self.createdGroup = group
					shouldGroupSuccess = true
				}
		}
		.setThemeBackButton()
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				if selection == .groups {
					Button {
						isPopupPresented = true
					} label: {
						Image(systemName: "plus")
							.roundButton()
					}
				}
			}
		}
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			AppTabBarView(rootIsActive: .constant(false))
		}
    }
}
