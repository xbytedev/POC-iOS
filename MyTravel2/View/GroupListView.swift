//
//  GroupListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/05/23.
//

import SwiftUI

struct GroupListView: View {
    var body: some View {
		emptyView
    }

	var dataView: some View {
		List {
			GroupListRow(groupName: "Mrugesh")
				.mtListBackgroundStyle()
			GroupListRow(groupName: "Swati")
				.mtListBackgroundStyle()
			GroupListRow(groupName: "Umang")
				.mtListBackgroundStyle()
			GroupListRow(groupName: "Siddharth")
				.mtListBackgroundStyle()
			GroupListRow(groupName: "Yash")
				.mtListBackgroundStyle()
		}.listStyle(.plain)
	}

	var emptyView: some View {
		GeometryReader { geometryProxy in
			VStack {
				Spacer()
				Image(R.image.img_setupGroup)
					.resizable()
					.scaledToFit()
					.offset(y: 8)
				groupData
					.background(AppColor.theme)
					.cornerRadius(32)
					.shadow(radius: 8, y: -4)
					.frame(height: geometryProxy.size.height * 0.66)
			}
			.ignoresSafeArea(edges: .bottom)
		}
	}

	var groupData: some View {
		VStack(spacing: 36) {
			Text("Groups")
				.font(AppFont.getFont(forStyle: .largeTitle, forWeight: .semibold))
				.foregroundColor(AppColor.Text.tertiary)
				.padding(.top, 48)
			Text("Setup a Group to save time and check-in several travelers at the same time.")
				.multilineTextAlignment(.center)
				.font(AppFont.getFont(forStyle: .title3, forWeight: .medium))
				.foregroundColor(AppColor.Text.tertiary)
			MTButton(isLoading: .constant(false), title: "Setup Group", loadingTitle: "") {
				action()
			}
			.inverted()
			Spacer()
		}
		.padding(.horizontal, 36)
	}

	func action() {

	}
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
		GroupListView()
    }
}