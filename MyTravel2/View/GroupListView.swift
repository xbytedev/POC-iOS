//
//  GroupListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/05/23.
//

import SwiftUI

struct GroupListView: MTAsyncView {

	@Binding var isPopupPresented: Bool
	@ObservedObject var viewModel: GroupViewModel
	@Binding var shouldGroupSuccess: Bool
	@Binding var createdGroup: MTGroup?
	@Binding var shouldAddTraveler: Bool
	@State private var navigationHash: [Int: Bool]
	@State private var needToAddTraveler: Bool = false
	private var selectedGroup: MTGroup?
	private var groupSelectionBlock: ((MTGroup) -> Void)?

	init(
		isPopupPresented: Binding<Bool>, viewModel: GroupViewModel, shouldGroupSuccess: Binding<Bool>,
		createdGroup: Binding<MTGroup?> = .constant(nil), shouldAddTraveler: Binding<Bool>) {
			_isPopupPresented = isPopupPresented
			_shouldGroupSuccess = shouldGroupSuccess
			_createdGroup = createdGroup
			_shouldAddTraveler = shouldAddTraveler
			self.viewModel = viewModel
			self.navigationHash = .init()
		}

	init(
		withCurrentSelectedGroup selectedGroup: MTGroup?, and viewModel: GroupViewModel,
		groupSelection: @escaping (MTGroup) -> Void) {
			_isPopupPresented = .constant(false)
			_shouldGroupSuccess = .constant(false)
			_createdGroup = .constant(nil)
			_shouldAddTraveler = .constant(false)
			groupSelectionBlock = groupSelection
			self.selectedGroup = selectedGroup
			self.viewModel = viewModel
			self.navigationHash = .init()
		}

	var state: MTLoadingState {
		viewModel.state
	}

	func load() {
		Task {
			try await viewModel.getGroupList()
			viewModel.groupList.forEach { navigationHash[$0.id] = false }
		}
	}

	func reload() async {
		do {
			try await viewModel.getGroupList()
			viewModel.groupList.forEach { navigationHash[$0.id] = false }
		} catch {
		}
	}

	var loadedView: some View {
		dataView
			.myOverlay {
				Group {
					if viewModel.groupList.isEmpty {
						emptyView
					}
				}
			}
			.fullScreenCover(isPresented: $shouldGroupSuccess) {
				if let group = createdGroup {
					CreateGroupSuccessView(group: group, shouldPresent: .constant(true)) {
						needToAddTraveler = true
					}
				}
			}
			.onChange(of: shouldGroupSuccess) { newValue in
				guard !newValue else { return }
				Task {
					await reload()
					if needToAddTraveler {
						shouldAddTraveler = true
					}
				}
			}
			.myBackground {
				NavigationLink(isActive: $shouldAddTraveler) {
					if let groupToAddTraveler = createdGroup {
						ScanQRCodeView(
							viewModel: ScanQRCodeViewModel(
								group: groupToAddTraveler, provider: AddTravellerAPIProvider(), placeDetailProvider: PlaceDetailAPIProvider()),
							shouldNavigateBack: $shouldAddTraveler, scanFor: .addTraveler, place: nil)
						.navigationTitle(R.string.localizable.qrCode())
					} else {
						EmptyView()
					}
				} label: {
					EmptyView()
				}
				.opacity(0)
			}
	}

	var dataView: some View {
			List {
				ForEach($viewModel.groupList) { item in
					if groupSelectionBlock == nil {
						ZStack {
							NavigationLink(isActive: item.navigateView) {
								let viewModel = GroupDetailViewModel(
									group: item.wrappedValue, groupDetailProvider: GroupDetailAPIProvider(), groupUpdateDelegate: viewModel)
								GroupDetailView(viewModel: viewModel, isPopToGroupList: item.navigateView)
									.navigationTitle(R.string.localizable.groups())
									.setThemeBackButton()
							} label: {
								EmptyView()
							}
							.opacity(0)
							GroupListRow(group: item.wrappedValue, selectedGroup: nil)
						}
						.mtListBackgroundStyle()
					} else {
						GroupListRow(group: item.wrappedValue, selectedGroup: selectedGroup)
							.mtListBackgroundStyle()
							.onTapGesture {
								groupSelectionBlock?(item.wrappedValue)
							}
					}
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
		/*.swipeActions(edge: .trailing, allowsFullSwipe: true) {
		 Button {
		 print("Delete")
		 } label: {
		 Label("Delete", systemImage: "trash")
		 }
		 }*/
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
			Text(R.string.localizable.groups())
				.font(AppFont.getFont(forStyle: .largeTitle, forWeight: .semibold))
				.foregroundColor(AppColor.Text.tertiary)
				.padding(.top, 48)
			Text(R.string.localizable.setupGroupAndCheckinTravelers())
				.multilineTextAlignment(.center)
				.font(AppFont.getFont(forStyle: .title3, forWeight: .medium))
				.foregroundColor(AppColor.Text.tertiary)
			MTButton(isLoading: .constant(false), title: R.string.localizable.setupGroup(), loadingTitle: "") {
				action()
			}
			.inverted()
			Spacer()
		}
		.padding(.horizontal, 36)
	}

	func action() {
		isPopupPresented = true
	}
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = GroupViewModel(provider: GroupSuccessProvider())
		GroupListView(
			isPopupPresented: .constant(false), viewModel: viewModel, shouldGroupSuccess: .constant(true),
			createdGroup: .constant(nil), shouldAddTraveler: .constant(true))
    }
}
