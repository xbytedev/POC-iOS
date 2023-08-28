//
//  CheckInListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 09/08/23.
//

import SwiftUI

struct CheckInListView: MTAsyncView {
	@State private var strSearch: String = ""
	@StateObject private var viewModel: CheckInViewModel

	init(provider: CheckInProvider) {
		_viewModel = StateObject(wrappedValue: CheckInViewModel(withProvider: provider))
	}

	var state: MTLoadingState {
		viewModel.state
	}

    var loadedView: some View {
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
					Image(R.image.ic_filter).setAsThemeIcon()
					Text("Filter")
						.font(AppFont.getFont(forStyle: .headline))
						.foregroundColor(AppColor.Text.primary)
				}
			}
			.applyRoundRectShadowBackground()
			Button(action: handleResetFilterAction) {
				HStack {
					Spacer()
					Text("Reset all Filters")
						.font(AppFont.getFont(forStyle: .headline))
						.foregroundColor(AppColor.Text.primary)
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
		List(viewModel.checkInTravellers) { checkInTraveller in
			ZStack {
				NavigationLink {
					CheckInDetailView()
						.setThemeBackButton()
//						.navigationTitle(R.string.localizable.checkIn())
						.toolbar {
							ToolbarItem(placement: .principal) {
								Text(R.string.localizable.checkIn)
									.foregroundColor(AppColor.Text.tertiary)
							}
						}
				} label: {
					EmptyView()
				}
				.opacity(0)
				CheckInRowView(checkInTraveller: checkInTraveller)
			}
			.mtListBackgroundStyle()
		}
		.listStyle(.plain)
	}

	func load() {
		Task {
			await viewModel.getCheckInTravellers()
		}
	}

	private func handleFilterAction() {

	}

	private func handleResetFilterAction() {

	}
}

#if DEBUG
struct CheckInListView_Previews: PreviewProvider {
    static var previews: some View {
		CheckInListView(provider: CheckInSuccessProvider())
    }
}
#endif
