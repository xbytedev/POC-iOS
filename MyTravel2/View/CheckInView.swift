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

    var loadedView: some View {
		VStack(alignment: .leading, spacing: 0) {
			VStack(alignment: .leading) {
				Text(selection == .places ? "Places" : "Check-ins")
						.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
						.foregroundColor(AppColor.theme)
						.padding(.top, 24)
					HStack {
						Image(R.image.ic_search)
							.resizable()
							.renderingMode(.template)
							.frame(width: 24.0, height: 24.0)
							.foregroundColor(AppColor.theme)
						TextField("Search", text: $searchText)
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
					Text("Place Type")
						.font(AppFont.getFont(forStyle: .title3))
						.foregroundColor(AppColor.theme)
					Spacer()
					Picker(selection: $selectedType) {
						Text("All")
							.tag("all")
						Text("None")
							.tag("None")
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
		.onChange(of: searchText) { newValue in
			viewModel.searchPlace(with: newValue)
		}
//		.padding()
    }

	var state: MTLoadingState {
		viewModel.state
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
