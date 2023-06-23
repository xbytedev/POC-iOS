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
	@State private var isConfirmation = false
	@Environment(\.mtDismissable) var dismiss

	var body: some View {
		List {
			if #available(iOS 15.0, *) {
				sectionView
					.listSectionSeparator(.hidden)
			} else {
				sectionView
			}
		}
		.listStyle(.plain)
		.setThemeBackButton()
		.showAlert(title: configuration.errorTitle, isPresented: $configuration.alertPresent) {
			Text(configuration.errorMeessage)
		}
		.alert(isPresented: $isConfirmation, content: {
			Alert(
				title: Text("Are you sure?"), message: Text("Do you want to delete group?"),
				primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
					deleteGroup()
				}))
		})
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

	var sectionView: some View {
		Section {
			ForEach(viewModel.travellers) { traveller in
				HStack {
					Text("\(traveller.name)")
					Spacer()
					Button {
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
		} footer: {
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
							isConfirmation = true
						}
					}
					Spacer()
				}
			}
			.listRowBackground(Color.clear)
		}
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
}

struct GroupEditView_Previews: PreviewProvider {
    static var previews: some View {
		GroupEditView(viewModel: .init(group: .preview, groupDetailProvider: GroupDetailSuccessProvider()))
    }
}
