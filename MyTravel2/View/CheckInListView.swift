//
//  CheckInListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 09/08/23.
//

import SwiftUI

struct CheckInListView: MTAsyncView {
	@State private var strSearch: String = ""
	@State private var shouldDisplayFilterView = false
	@StateObject private var viewModel: CheckInViewModel
	@State private var dateFilter: ClosedRange<Date>?
	@State private var selectedPartner: String?

	init(provider: CheckInProvider) {
		_viewModel = StateObject(wrappedValue: CheckInViewModel(withProvider: provider))
	}

	var state: MTLoadingState {
		viewModel.state
	}

    var loadedView: some View {
		ZStack {
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
			CheckInFilterView(
				dateFilter: dateFilter, partners: Array(Set(viewModel.displayCheckInTravellers.compactMap({$0.partnerName}))),
				selectedPartner: selectedPartner, isPresenting: $shouldDisplayFilterView) { dateFilter, selectedPartner in
					self.dateFilter = dateFilter
					self.selectedPartner = selectedPartner
				}
		}
		.onChange(of: dateFilter) { newValue in
			viewModel.searchAndFilterTravellers(withSearchText: strSearch, dateFilter: newValue, partnerFilter: selectedPartner)
		}
		.onChange(of: selectedPartner) { newValue in
			viewModel.searchAndFilterTravellers(withSearchText: strSearch, dateFilter: dateFilter, partnerFilter: newValue)
		}
		.onChange(of: strSearch) { newValue in
			viewModel.searchAndFilterTravellers(withSearchText: newValue, dateFilter: dateFilter, partnerFilter: selectedPartner)
		}
    }

	private var filterButton: some View {
		HStack {
			Button(action: handleFilterAction) {
				HStack {
					Image(R.image.ic_filter).setAsThemeIcon()
					Text(R.string.localizable.filter)
						.font(AppFont.getFont(forStyle: .headline))
						.foregroundColor(AppColor.Text.primary)
				}
			}
			.applyRoundRectShadowBackground()
			Button(action: handleResetFilterAction) {
				HStack {
					Spacer()
					Text(R.string.localizable.resetAllFilters)
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
		List {
			ForEach(viewModel.displayCheckInTravellers) { checkInTraveller in
				ZStack {
					NavigationLink {
						CheckInDetailView(viewModel: viewModel, checkInTraveller: checkInTraveller)
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
			if #available(iOS 15.0, *) {
				GeometryReader { geometryProxy in
					Spacer(minLength: geometryProxy.safeAreaInsets.magnitude)
				}
				.listRowSeparator(.hidden)
				.listRowBackground(Color.clear)
			} else {
				GeometryReader { geometryProxy in
					Spacer(minLength: geometryProxy.safeAreaInsets.magnitude)
				}
				.listRowBackground(Color.clear)
			}
		}
		.listStyle(.plain)
		.myOverlay(alignment: .center) {
			VStack {
				if viewModel.displayCheckInTravellers.isEmpty {
					SMErrorView(title: nil, message: R.string.localizable.noCheckInTravellersFound(), retryAction: nil)
				}
			}
		}
	}

	func load() {
		Task {
			await viewModel.getCheckInTravellers()
		}
	}

	private func handleFilterAction() {
		shouldDisplayFilterView = true
	}

	private func handleResetFilterAction() {
		dateFilter = nil
		selectedPartner = nil
	}
}

#if DEBUG
struct CheckInListView_Previews: PreviewProvider {
    static var previews: some View {
		CheckInListView(provider: CheckInSuccessProvider())
    }
}
#endif
