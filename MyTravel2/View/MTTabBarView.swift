//
//  MTTabBarView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct MTTabBarView: View {
	private let tabs = TabItem.allCases
	@Binding var selection: TabItem
	@Namespace var namespace

    var body: some View {
		HStack {
			ForEach(tabs, id: \.self) { tab in
				tabView(tab: tab)
					.onTapGesture {
						switchToTab(tab: tab)
					}
			}
		}
		.padding(6)
		.background(AppColor.Text.tertiary)
		.clipShape(Capsule())
		.shadow(radius: 8, y: 4)
		.padding(.horizontal)
    }

	private func tabView(tab: TabItem) -> some View {
		VStack {
			tab.image
				.resizable()
				.renderingMode(.template)
				.foregroundColor(selection == tab ? AppColor.Text.tertiary : AppColor.theme)
				.scaledToFit()
				.frame(height: 20)
		}
		.padding(.vertical, 8)
		.frame(maxWidth: .infinity)
		.myBackground {
			ZStack {
				if selection == tab {
					Circle()
						.foregroundColor(AppColor.theme)
						.shadow(radius: 4)
						.matchedGeometryEffect(id: "background_round", in: namespace)
				}
			}
		}
	}

	func switchToTab(tab: TabItem) {
		withAnimation {
			selection = tab
		}
	}
}

struct MTTabBarView_Previews: PreviewProvider {
	@State static var selection: TabItem = .groups
    static var previews: some View {
		VStack {
			Spacer()
			MTTabBarView(selection: $selection)
		}
    }
}

// TODO: create custom tab bar container view
