//
//  MTTabBarContainerView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct MTTabBarContainerView<V: View>: View {
	@Binding var selection: TabItem
	let content: V
	@State private var tabs: [TabItem] = []

	init(selection: Binding<TabItem>, @ViewBuilder content: () -> V) {
		self.content = content()
		_selection = selection
	}

    var body: some View {
		ZStack(alignment: .bottom) {
			content.ignoresSafeArea(edges: .bottom)
			MTTabBarView(selection: $selection)
		}
		.onPreferenceChange(MTTabBarPreferenceKey.self) { value in
			tabs = value
		}
		.navigationTitle(selection.title)
    }
}

struct MTTabBarContainerView_Previews: PreviewProvider {
	@State static var selection: TabItem = .groups
    static var previews: some View {
		MTTabBarContainerView(selection: $selection) {
			Color.red
				.tabBarItem(tab: .groups, selection: $selection)
		}
    }
}
