//
//  PlaceDetailsView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlaceDetailsView: MTAsyncView {
	@Environment(\.mtDismissable) var dismiss
	@ObservedObject var viewModel: PlaceDetailViewModel
	@ObservedObject var groupListViewModel: GroupViewModel
	@State private var selectedGroup: MTGroup?
	@State private var shouldPresentGroupSelection: Bool = false
	@State private var groupCheckingIn: Bool = false
	@State private var configuration = UIConfiguration()
	@State private var showSuccessAlert: Bool = false
	@State private var individualCheckIn: Bool = false
	@State private var isPopupPresented: Bool = false
	@State private var shouldEditGroup = false

	var state: MTLoadingState {
		viewModel.state
	}
	let place: MTPlace

	var loadingMessage: String? {
		R.string.localizable.loadingContentDetails(place.name ?? "")
	}

	var loadedView: some View {
		ZStack {
			VStack(spacing: 0) {
				WebImage(from: viewModel.placeDetail.image)
					.resizable().indicator(.activity)
					.aspectRatio(16/9.0, contentMode: .fit).clipped().cornerRadius(8)
					.padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
				detailView
					.showAlert(title: configuration.errorTitle, isPresented: $showSuccessAlert, action: dismiss) {
						Text(configuration.errorMeessage)
					}
			}
			.ignoresSafeArea(edges: .bottom)
			CreateGroupView(
				isPresenting: $isPopupPresented, viewModel: groupListViewModel) { group in
					selectedGroup = group
				}
		}
		.navigationTitle(R.string.localizable.places())
		.setThemeBackButton()
		.sheet(isPresented: $shouldPresentGroupSelection) {
			GroupListView(withCurrentSelectedGroup: getSelectedGroup(), and: groupListViewModel) { selectedGroup in
				self.selectedGroup = selectedGroup
				self.shouldPresentGroupSelection = false
			}
		}
		.showAlert(title: configuration.errorTitle, isPresented: $configuration.alertPresent) {
			Text(configuration.errorMeessage)
		}
		.onAppear {
			if shouldEditGroup {
				Task {
					try await groupListViewModel.getGroupList()
					_ = getSelectedGroup()
					shouldEditGroup = false
				}
			} else {
				_ = getSelectedGroup()
			}
		}
	}

	private var detailView: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24) {
				titleView
				descriptionView
				groupView
				if selectedGroup == nil {
					setupGroupView
				} else {
					groupDetailView
				}
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
			.lineLimit(2)
	}

	private var descriptionView: some View {
		VStack(alignment: .leading, spacing: 8) {
			if viewModel.placeDetail.address != nil {
				Text(R.string.localizable.address)
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .title3, forWeight: .semibold)).padding(.horizontal)
				Text(viewModel.placeDetail.address ?? "")
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .body)).lineLimit(3).padding(.horizontal)
			}
		}
	}

	private var groupView: some View {
		VStack(alignment: .leading) {
			if selectedGroup == nil {
				Text(R.string.localizable.setupGroupAndCheckinTravelers)
					.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
					.foregroundColor(AppColor.Text.tertiary)
					.multilineTextAlignment(.center).lineLimit(3)
			} else {
				Text(R.string.localizable.currentGroup)
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .body))
				HStack {
					Text(selectedGroup?.name ?? "")
						.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
						.foregroundColor(AppColor.Text.tertiary)
					Spacer()
					Button(action: presentGroupSelection) {
						Text(R.string.localizable.change)
							.foregroundColor(AppColor.theme)
							.font(AppFont.getFont(forStyle: .footnote))
					}
					.padding(8).background(AppColor.Background.white).clipShape(Capsule())
				}
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
					Button(action: groupCheckIn) {
						VStack {
							HStack {
								if groupCheckingIn {
									ProgressView()
										.foregroundColor(AppColor.theme)
								}
								Text(groupCheckingIn ? R.string.localizable.checkingInGroup : R.string.localizable.checkInGroup)
									.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
									.foregroundColor(AppColor.theme)
							}
							Text(R.string.localizable.countTraveller(traveller: selectedGroup?.travellerCount ?? 0))
								.font(AppFont.getFont(forStyle: .callout))
								.foregroundColor(AppColor.theme)
						}
						.padding(8).padding(.horizontal, 40)
						.background(AppColor.Background.white).cornerRadius(16).shadow(radius: 8, y: 4)
					}
					Spacer()
				}
				.zIndex(2)
				HStack {
					Spacer()
					NavigationLink {
						if selectedGroup == nil {
							EmptyView()
						} else {
							let groupEditViewModel = GroupDetailViewModel(
								group: selectedGroup!, groupDetailProvider: GroupDetailAPIProvider())
							GroupEditView(viewModel: groupEditViewModel, isPopToGroupList: .constant(false)) {
								_ = getSelectedGroup()
								shouldEditGroup = true
							}
						}
					} label: {
						VStack {
							Text("")
								.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
								.foregroundColor(AppColor.theme)
							Text(R.string.localizable.editGroup)
								.font(AppFont.getFont(forStyle: .callout, forWeight: .semibold))
								.foregroundColor(AppColor.theme)
						}
						.padding(8).padding(.horizontal, 16)
						.background(AppColor.Background.white).cornerRadius(12)
					}
					.isDetailLink(false)
					Spacer()
				}
				.zIndex(1)
				.offset(y: -12)
			}
		}
	}

	private var setupGroupView: some View {
		HStack {
			Spacer()
			Button(action: doSetupGroup) {
					HStack {
						Text(R.string.localizable.setupGroup)
							.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
							.foregroundColor(AppColor.theme)
					}
				.padding().padding(.horizontal, 40)
				.background(AppColor.Background.white).cornerRadius(12).shadow(radius: 8, y: 4)
			}
			Spacer()
		}
	}

	private var individualView: some View {
		VStack {
			HStack {
				Spacer()
				ZStack {
					NavigationLink(isActive: $individualCheckIn) {
						ScanQRCodeView(
							viewModel: getScanQRViewModel(), shouldNavigateBack: $individualCheckIn, scanFor: .checkIn, place: place)
						.navigationTitle(R.string.localizable.qrCode())
					} label: {
						EmptyView()
					}
					.opacity(0)
					Button {
						individualCheckIn = true
					} label: {
						Text(R.string.localizable.individualCheckIn)
							.foregroundColor(AppColor.Text.tertiary)
							.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
					}
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
				Text(R.string.localizable.checkinTravellersNotInGroup)
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .body)).lineLimit(3)
				Spacer()
			}
		}
	}
}
extension PlaceDetailsView {
	func load() {
		Task {
			await viewModel.getPlaceDetail(of: place)
		}
	}

	func getSelectedGroup() -> MTGroup? {
		if selectedGroup == nil {
			selectedGroup = groupListViewModel.groupList.first(where: {$0.isDefault == 1})
			if selectedGroup == nil { // If no group is default then select first group
				selectedGroup = groupListViewModel.groupList.first
			}
			return selectedGroup
		} else {
			selectedGroup = groupListViewModel.groupList.first(where: {$0.id == selectedGroup?.id})
			return selectedGroup
		}
	}

	func presentGroupSelection() {
		shouldPresentGroupSelection = true
	}
	func groupCheckIn() {
		guard let selectedGroup else { return }
		Task {
			do {
				groupCheckingIn = true
				try await viewModel.checkIn(group: selectedGroup)
				groupCheckingIn = false
				configuration.errorTitle = R.string.localizable.success()
				configuration.errorMeessage = R.string.localizable.groupCheckinSuccessfully()
				showSuccessAlert = true
			} catch {
				groupCheckingIn = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}

	func getScanQRViewModel() -> ScanQRCodeViewModel {
		if let selectedGroup {
			let viewModel = ScanQRCodeViewModel(
				group: selectedGroup, provider: AddTravellerAPIProvider(), placeDetailProvider: PlaceDetailAPIProvider())
			//		viewModel.delegate = self.viewModel
			return viewModel
		} else {
			let viewModel = ScanQRCodeViewModel(
				group: .dummy, provider: AddTravellerAPIProvider(), placeDetailProvider: PlaceDetailAPIProvider())
			//		viewModel.delegate = self.viewModel
			return viewModel
		}
	}

	func doSetupGroup() {
		isPopupPresented = true
	}
}

#if DEBUG
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
#endif
