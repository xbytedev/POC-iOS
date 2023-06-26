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
	@State private var updatingMessage = "Loading"
	@State private var deleteGroupConfirmation = false
	@State private var deleteMemberConfirmation = false
	@State private var deleteMember: MTTraveller?
	@Environment(\.mtDismissable) var dismiss

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
						title: Text("Are you sure?"), message: Text("Do you want to delete \(deleteMember.name)?"),
						primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
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
						Image(systemName: "trash")
					}
					.roundButton()
				}
				.mtListBackgroundStyle()
			}
		} header: {
			Text(viewModel.group.name ?? "")
				.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
				.foregroundColor(AppColor.theme)
		/*} footer: {
			ZStack {
				// TODO: Add navigation to scanner view
				/*NavigationLink(isActive: $shouldAddNew) {
					ScanQRCodeView(
						viewModel: ScanQRCodeViewModel(group: viewModel.group, provider: AddTravellerAPIProvider()))
					.navigationTitle("QR Code")
				} label: {
					EmptyView()
				}
				.opacity(0)*/
				HStack {
					Spacer()
					VStack {
						MTButton(isLoading: .constant(false), title: "Add Travellers", loadingTitle: "") {
							shouldAddNew = true
						}
						MTButton(isLoading: $isDeleting, title: "Delete Group", loadingTitle: "Deleting group") {
							deleteGroupConfirmation = true
						}
					}
					Spacer()
				}
			}
			.listRowBackground(Color.clear)*/
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
						viewModel: ScanQRCodeViewModel(group: viewModel.group, provider: AddTravellerAPIProvider()))
					.navigationTitle("QR Code")
				} label: {
					EmptyView()
				}
				.opacity(0)
				MTButton(isLoading: .constant(false), title: "Add Travellers", loadingTitle: "") {
					shouldAddNew = true
				}
			}
			Spacer()
		}
	}

	var deleteGroupButton: some View {
		HStack {
			Spacer()
			MTButton(isLoading: $isDeleting, title: "Delete Group", loadingTitle: "Deleting group") {
				deleteGroupConfirmation = true
			}
			Spacer()
		}
		.alert(isPresented: $deleteGroupConfirmation, content: {
			Alert(
				title: Text("Are you sure?"), message: Text("Do you want to delete group?"),
				primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
					deleteGroup()
				}))
		})
	}

	private func deleteGroup() {
		Task {
			do {
				updatingMessage = "Deleting " + (viewModel.group.name ?? "Group")
				isDeleting = true
				configuration.isLoading = true
				try await viewModel.deleteGroup()
				configuration.isLoading = false
				isDeleting = false
				// TODO: Navigate back to 3 screens
				dismiss()
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
				updatingMessage = "Deleting " + (traveller.name)
				isDeleting = true
				try await viewModel.delete(traveller: traveller)
				isDeleting = false
			} catch {
				isDeleting = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}
}

struct GroupEditView_Previews: PreviewProvider {
    static var previews: some View {
		GroupEditView(viewModel: .init(group: .preview, groupDetailProvider: GroupDetailSuccessProvider()))
    }
}
