//
//  PlaceDetailsView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlaceDetailsView: MTAsyncView {

	@ObservedObject var viewModel: PlaceDetailViewModel
	@ObservedObject var groupListViewModel: GroupViewModel
	@State private var defaultGroup: MTGroup?
	@State private var selectedGroup: MTGroup?
	@State private var shouldPresentGroupSelection: Bool = false

	var state: MTLoadingState {
		viewModel.state
	}
	let place: MTPlace

	var loadingMessage: String? {
		"Loading " + (place.name ?? "") + " details"
	}

	var loadedView: some View {
		VStack(spacing: 0) {
			WebImage(from: viewModel.placeDetail.image)
				.resizable()
				.indicator(.activity)
				.aspectRatio(16/9.0, contentMode: .fit)
				.clipped()
				.cornerRadius(8)
				.padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
			 detailView
		}
		.ignoresSafeArea(edges: .bottom)
		.navigationTitle("Places")
		.setThemeBackButton()
		.sheet(isPresented: $shouldPresentGroupSelection) {
			GroupListView(withCurrentSelectedGroup: getSelectedGroup(), and: groupListViewModel) { selectedGroup in
				self.selectedGroup = selectedGroup
				self.shouldPresentGroupSelection = false
			}
		}
	}

	private var detailView: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24) {
				titleView
				descriptionView
				groupView
				groupDetailView
				individualView
				Spacer()
			}
		}
		.frame(maxWidth: .infinity)
		.padding()
		.myBackground {
			AppColor.theme
		}
		.cornerRadius(32, corners: [.topLeft, .topRight])
		.shadow(radius: 8, y: -4)
		.padding(.top, -16)
	}

	private var titleView: some View {
		Text(viewModel.placeDetail.name)
			.foregroundColor(AppColor.Text.tertiary)
			.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
			.padding(.horizontal)
	}

	private var descriptionView: some View {
		VStack(alignment: .leading, spacing: 8) {
			if viewModel.placeDetail.address == nil {
				EmptyView()
			} else {
				Text("Address")
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .title3, forWeight: .semibold))
					.padding(.horizontal)
				Text(viewModel.placeDetail.address ?? "")
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .body))
					.lineLimit(3)
					.padding(.horizontal)
			}
		}
	}

	private var groupView: some View {
		VStack(alignment: .leading) {
			Text("Current Group")
				.foregroundColor(AppColor.Text.tertiary)
				.font(AppFont.getFont(forStyle: .body))
			HStack {
				Text(selectedGroup?.name ?? "")
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.Text.tertiary)
				Spacer()
				Button(action: presentGroupSelection) {
					Text("Change")
						.foregroundColor(AppColor.theme)
						.font(AppFont.getFont(forStyle: .footnote))
				}
				.padding(8)
				.background(AppColor.Background.white)
				.clipShape(Capsule())
			}
		}
		.padding()
		.myBackground {
			VStack {
				topBorder
					.rotationEffect(.degrees(180))
				Spacer()
			}
		}
	}

	private var topBorder: some View {
		ZStack {
			MTBorderShape(type: .outbound)
				.fill(AppColor.Text.tertiary)
				.frame(height: 50)
				.offset(y: 0.75)
			MTBorderShape(type: .inbound)
				.fill(AppColor.theme)
				.frame(height: 50)
		}
	}

	private var groupDetailView: some View {
		ZStack {
			VStack(spacing: 0) {
				HStack {
					Spacer()
					VStack {
						Text("Check-in Group")
							.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
							.foregroundColor(AppColor.theme)
						Text("6 travelers")
							.font(AppFont.getFont(forStyle: .callout))
							.foregroundColor(AppColor.theme)
					}
					.padding(8)
					.padding(.horizontal, 40)
					.background(AppColor.Background.white)
					.cornerRadius(16)
					.shadow(radius: 8, y: 4)
					Spacer()
				}
				.zIndex(2)
				HStack {
					Spacer()
					VStack {
						Text("")
							.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
							.foregroundColor(AppColor.theme)
						Text("Edit Group (6/10)")
							.font(AppFont.getFont(forStyle: .callout, forWeight: .semibold))
							.foregroundColor(AppColor.theme)
					}
					.padding(8)
					.padding(.horizontal, 16)
					.background(AppColor.Background.white)
					.cornerRadius(12)
					Spacer()
				}
				.zIndex(1)
				.offset(y: -12)
			}
		}
	}

	private var individualView: some View {
		VStack {
			HStack {
				Spacer()
				Button {
				} label: {
					Text("Individual Check-in")
						.foregroundColor(AppColor.Text.tertiary)
						.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
				}
				.padding()
				.myOverlay {
					RoundedRectangle(cornerRadius: 12)
						.stroke(AppColor.Background.white, lineWidth: 2)
				}
				Spacer()
			}
			HStack {
				Spacer()
				Text("Check-in travelers not in a group.")
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .body))
					.lineLimit(3)
				Spacer()
			}
		}
	}

	func load() {
		Task {
			await viewModel.getPlaceDetail(of: place)
		}
		_ = getSelectedGroup()
	}

	func getDefaultGroup() -> MTGroup? {
		if _defaultGroup.wrappedValue == nil {
			defaultGroup = groupListViewModel.groupList.first(where: {$0.isDefault == 1})
			return defaultGroup
		} else {
			return defaultGroup
		}
	}

	func getSelectedGroup() -> MTGroup? {
		if _selectedGroup.wrappedValue == nil {
			selectedGroup = getDefaultGroup()
			return selectedGroup
		} else {
			return selectedGroup
		}
	}

	func presentGroupSelection() {
		shouldPresentGroupSelection = true
	}
}

struct PlaceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
		let placeDetailViewModel = PlaceDetailViewModel(with: .preview, and: PlaceDetailSuccessProvider())
		let groupViewModel = GroupViewModel(provider: GroupSuccessProvider())
		PlaceDetailsView(viewModel: placeDetailViewModel, groupListViewModel: groupViewModel, place: .preview)
			.previewDevice("iPhone 14 Pro")
			.previewDisplayName("iPhone 14 Pro")
		PlaceDetailsView(viewModel: placeDetailViewModel, groupListViewModel: groupViewModel, place: .preview)
			.previewDevice("iPhone SE (3rd generation)")
			.previewDisplayName("iPhone SE")
    }
}
