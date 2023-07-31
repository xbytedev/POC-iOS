//
//  MTTabBarContainerView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct MTTabBarContainerView<V: View>: View {
	enum ListType {
		case places
		case checkIn
	}
	@Binding var selection: TabItem
	let content: V
	@State private var tabs: [TabItem] = []
	@State private var selectionPicker: ListType = .places
	@Binding private var checkInSelection: SegmentItem

	init(selection: Binding<TabItem>, checkInSelection: Binding<SegmentItem>, @ViewBuilder content: () -> V) {
		self.content = content()
		_selection = selection
		_checkInSelection = checkInSelection
	}

    var body: some View {
		ZStack(alignment: .bottom) {
			content.ignoresSafeArea(edges: .bottom)
			MTTabBarView(selection: $selection).padding(.vertical)
		}
		.onPreferenceChange(MTTabBarPreferenceKey.self) { value in
			tabs = value
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				if selection == .checkIn {
					MTSegmentView(selection: $checkInSelection)
						.padding(.trailing, 44)
				} else {
					Text(selection.title)
				}
			}
		}
	}
}

struct MTTabBarContainerView_Previews: PreviewProvider {
	@State static var selection: TabItem = .groups
    static var previews: some View {
		MTTabBarContainerView(selection: $selection, checkInSelection: .constant(.places)) {
			Color.red
				.tabBarItem(tab: .groups, selection: $selection)
		}
    }
}
