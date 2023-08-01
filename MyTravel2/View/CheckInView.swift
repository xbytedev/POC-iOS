//
//  CheckInView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct CheckInView: MTAsyncView {
	@State private var searchText: String = ""
	@State private var selectedType: String = "All"
	@ObservedObject var groupViewModel: GroupViewModel
	@StateObject private var viewModel: LocationViewModel // = LocationViewModel()
    @Binding var selection: SegmentItem

	init(groupViewModel: GroupViewModel, provider: LocationProvider, selection: Binding<SegmentItem>) {
		_viewModel = StateObject(wrappedValue: LocationViewModel(provider: provider))
        _selection = selection
		self.groupViewModel = groupViewModel
	}

	var state: MTLoadingState {
		viewModel.state
	}

    var loadedView: some View {
		VStack(alignment: .leading, spacing: 0) {
			VStack(alignment: .leading) {
				Text(selection == .places ? R.string.localizable.places() : R.string.localizable.checkIns())
						.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
						.foregroundColor(AppColor.theme)
						.padding(.top, 24)
					HStack {
						Image(R.image.ic_search)
							.resizable()
							.renderingMode(.template)
							.frame(width: 24.0, height: 24.0)
							.foregroundColor(AppColor.theme)
						TextField(R.string.localizable.search(), text: $searchText)
						if !searchText.isEmpty {
							Button {
								searchText = ""
							} label: {
								Image(R.image.ic_cancel)
							}

						}
					}
					.padding(.vertical, 8)
					.padding(.horizontal, 12)
					.myBackground {
						RoundedRectangle(cornerRadius: 12)
							.foregroundColor(AppColor.Background.white)
							.shadow(radius: 8, y: 4)
					}
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

#if DEBUG
struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
		CheckInView(
			groupViewModel: GroupViewModel(provider: GroupSuccessProvider()), provider: LocationSuccessProvider(),
			selection: .constant(.places))
    }
}
#endif
