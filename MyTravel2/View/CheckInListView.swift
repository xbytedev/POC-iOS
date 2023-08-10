//
//  CheckInListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 09/08/23.
//

import SwiftUI

struct CheckInListView: View {
	@State private var strSearch: String = ""
    var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			VStack(alignment: .leading) {
				Text(R.string.localizable.checkIns())
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.theme)
					.padding(.top, 24)
				MTSearchView(searchText: $strSearch)
				filterButton
			}
			.padding(.horizontal)
			.padding(.horizontal)
			refreshableListView
		}
    }

	private var filterButton: some View {
		HStack {
			Button(action: handleFilterAction) {
				HStack {
					Image(systemName: "gear").setAsThemeIcon()
					Text("Filter")
				}
			}
			.applyRoundRectShadowBackground()
			Button(action: handleResetFilterAction) {
				HStack {
					Spacer()
					Text("Reset all Filters")
					Spacer()
				}
			}
			.applyRoundRectShadowBackground()
		}
		.padding(.top, 20)
	}

	@ViewBuilder
	private var refreshableListView: some View {
		if #available(iOS 15.0, *) {
			listView
//				.refreshable(action: viewModel.refreshPlaceList)
		} else {
			listView
		}
	}

	private var listView: some View {
		List {
			CheckInRowView()
			CheckInRowView()
			CheckInRowView()
			CheckInRowView()
		}
		.listStyle(.plain)
	}

	private func handleFilterAction() {

	}

	private func handleResetFilterAction() {

	}
}

struct CheckInListView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInListView()
    }
}
