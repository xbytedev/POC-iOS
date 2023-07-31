//
//  GroupEditView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 21/06/23.
//

import SwiftUI

struct GroupEditView: View {
	@ObservedObject var viewModel: GroupDetailViewModel
	@State private var isDeleting = false
	@State private var shouldAddNew = false
	@State private var configuration = UIConfiguration()
	@State private var updatingMessage = R.string.localizable.loading()
	@State private var deleteGroupConfirmation = false
	@State private var deleteMemberConfirmation = false
	@State private var deleteMember: MTTraveller?
	@Environment(\.mtDismissable) var dismiss
	@Binding var isPopToGroupList: Bool

	var body: some View {
		List {
			if #available(iOS 15.0, *) {
				sectionView1
					.listSectionSeparator(.hidden)
				sectionView2
					.listSectionSeparator(.hidden)
			} else {
				sectionView1
				sectionView2
			}
		}
		.listStyle(.plain)
		.alert(isPresented: $deleteMemberConfirmation, content: {
				if let deleteMember {
					return Alert(
						title: Text(R.string.localizable.areYouSure()),
						message: Text(R.string.localizable.doYouWantToDeleteTravelelr(deleteMember.name)),
						primaryButton: .cancel(), secondaryButton: .destructive(Text(R.string.localizable.delete()), action: {
							deleteTraveller(deleteMember)
						}))
				} else {
					return Alert(title: Text(""))
				}
		})
		.setThemeBackButton()
		.showAlert(title: configuration.errorTitle, isPresented: $configuration.alertPresent) {
			Text(configuration.errorMeessage)
		}
		.onAppear {
			if viewModel.state == .idle {
				Task {
					await viewModel.getPeopleList()
				}
			}
		}
		.myOverlay {
			Group {
				if configuration.isLoading {
					ZStack {
						Color.black.opacity(0.4)
						VStack {
							ProgressView()
								.modifier(ProgressViewModifier(color: AppColor.Text.tertiary))
							Text(updatingMessage)
								.font(AppFont.getFont(forStyle: .body))
								.foregroundColor(AppColor.Text.tertiary)
						}
					}
				}
			}
		}
	}

	var sectionView1: some View {
		Section {
			ForEach(viewModel.travellers) { traveller in
				HStack {
					Text("\(traveller.name)")
					Spacer()
					Button {
						deleteMember = traveller
						deleteMemberConfirmation = true
					} label: {
						Image(R.image.ic_delete)
					}
					.roundButton()
				}
				.mtListBackgroundStyle()
			}
		} header: {
			Text(viewModel.group.name ?? "")
				.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
				.foregroundColor(AppColor.theme)
		}
		.listRowBackground(Color.clear)
	}

	var sectionView2: some View {
		Section {
			if #available(iOS 15.0, *) {
				addTravellerButton
					.listRowSeparator(.hidden)
				deleteGroupButton
					.listRowSeparator(.hidden)
			} else {
				addTravellerButton
				deleteGroupButton
			}
		}
		.listRowBackground(Color.clear)
	}

	var addTravellerButton: some View {
		HStack {
			Spacer()
			ZStack {
				NavigationLink(isActive: $shouldAddNew) {
					ScanQRCodeView(
						viewModel: getScanQRViewModel(), shouldNavigateBack: $shouldAddNew, scanFor: .addTraveler, place: nil)
					.navigationTitle(R.string.localizable.qrCode())
				} label: {
					EmptyView()
				}
				.opacity(0)
				MTButton(isLoading: .constant(false), title: R.string.localizable.addTravelers(), loadingTitle: "") {
					shouldAddNew = true
				}
			}
			Spacer()
		}
	}

	var deleteGroupButton: some View {
		HStack {
			Spacer()
			if viewModel.groupUpdateDelegate != nil {
				MTButton(
					isLoading: $isDeleting, title: R.string.localizable.deleteGroup(),
					loadingTitle: R.string.localizable.deletingGroup()) {
						deleteGroupConfirmation = true
					}
			}
			Spacer()
		}
		.alert(isPresented: $deleteGroupConfirmation, content: {
			Alert(
				title: Text(R.string.localizable.areYouSure()), message: Text(R.string.localizable.doYouWantToDeleteGroup()),
				primaryButton: .cancel(), secondaryButton: .destructive(Text(R.string.localizable.delete()), action: {
					deleteGroup()
				}))
		})
	}

	private func deleteGroup() {
		Task {
			do {
				updatingMessage = R.string.localizable.deletingGorupName(viewModel.group.name ?? "Group")
				isDeleting = true
				configuration.isLoading = true
				try await viewModel.deleteGroup()
				configuration.isLoading = false
				isDeleting = false
				isPopToGroupList = false
			} catch {
				configuration.isLoading = false
				isDeleting = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}

	private func deleteTraveller(_ traveller: MTTraveller) {
		Task {
			do {
				updatingMessage = R.string.localizable.deletingTraveller(traveller.name)
				configuration.isLoading = true
				try await viewModel.delete(traveller: traveller)
				configuration.isLoading = false
			} catch {
				configuration.isLoading = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}

	func getScanQRViewModel() -> ScanQRCodeViewModel {
		let viewModel = ScanQRCodeViewModel(
			group: viewModel.group, provider: AddTravellerAPIProvider(), placeDetailProvider: PlaceDetailAPIProvider())
		viewModel.delegate = self.viewModel
		return viewModel
	}
}
#if DEBUG
struct GroupEditView_Previews: PreviewProvider {
    static var previews: some View {
		GroupEditView(
			viewModel: .init(group: .preview, groupDetailProvider: GroupDetailSuccessProvider()),
			isPopToGroupList: .constant(false))
    }
}
#endif
