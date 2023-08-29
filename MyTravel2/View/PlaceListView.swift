//
//  PlaceListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 09/08/23.
//

import SwiftUI

struct PlaceListView: MTAsyncView {
	@ObservedObject var groupViewModel: GroupViewModel
	@StateObject private var viewModel: LocationViewModel // = LocationViewModel()
	@State private var searchText: String = ""
	@State private var selectedType: String = "All"

	init(groupViewModel: GroupViewModel, provider: PlaceProvider) {
		_viewModel = StateObject(wrappedValue: LocationViewModel(provider: provider))
		self.groupViewModel = groupViewModel
	}

	var state: MTLoadingState {
		viewModel.state
	}

	var loadedView: some View {
		VStack(alignment: .leading, spacing: 0) {
			VStack(alignment: .leading) {
				Text(R.string.localizable.places())
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.theme)
					.padding(.top, 24)
				MTSearchView(searchText: $searchText)
				HStack {
					Text(R.string.localizable.placeType)
						.font(AppFont.getFont(forStyle: .title3))
						.foregroundColor(AppColor.theme)
					Spacer()
					Picker(selection: $selectedType) {
						ForEach(viewModel.types, id: \.self) { type in
							Text(type)
								.tag(type)
						}
					} label: {
						HStack {
							Text("Allfgf")
							Image(R.image.ic_arrowRight)
								.renderingMode(.template)
								.rotationEffect(.degrees(90))
						}
					}
					.pickerStyle(.menu)
				}
				.padding(.top, 24)
			}
			.padding(.horizontal)
			.padding(.horizontal)
			refreshableListView
		}
		.onChange(of: searchText) { newValue in
			viewModel.searchPlace(with: newValue, withFilter: selectedType)
		}
		.onChange(of: selectedType) { newValue in
			viewModel.searchPlace(with: searchText, withFilter: newValue)
		}
	}

	private var listView: some View {
		List {
			Section {
				ForEach(viewModel.displayPlaces) { place in
					ZStack {
						NavigationLink {
							let viewModel = PlaceDetailViewModel(with: place, and: PlaceDetailAPIProvider())
							PlaceDetailsView(viewModel: viewModel, groupListViewModel: groupViewModel, place: place)
						} label: {
							EmptyView()
						}
						.opacity(0)
						HStack {
							Text(place.name ?? "")
							Spacer()
							Image(R.image.ic_arrowRight)
						}
					}
					.mtListBackgroundStyle()
				}
			}
		}
		.listStyle(.plain)
	}

	@ViewBuilder
	private var refreshableListView: some View {
		if #available(iOS 15.0, *) {
			listView
				.refreshable(action: viewModel.refreshPlaceList)
		} else {
			listView
		}
	}

	func load() {
		Task {
			await viewModel.getPlaceList()
		}
	}
}

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
		PlaceListView(
			groupViewModel: .init(provider: GroupSuccessProvider()),
			provider: PlaceSuccessProvider())
    }
}