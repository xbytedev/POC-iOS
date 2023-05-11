//
//  MTTabBarPreferenceKey.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct MTTabBarPreferenceKey: PreferenceKey {
	static var defaultValue: [TabItem] = []

	static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
		value += nextValue()
	}
}

struct MTTabBarViewModifier: ViewModifier {

	let tab: TabItem
	@Binding var selection: TabItem

	func body(content: Content) -> some View {
		content
			.opacity(selection == tab ? 1.0 : 0.0)
			.preference(key: MTTabBarPreferenceKey.self, value: [tab])
	}
}

extension View {
	func tabBarItem(tab: TabItem, selection: Binding<TabItem>) -> some View {
		modifier(MTTabBarViewModifier(tab: tab, selection: selection))
	}
}
