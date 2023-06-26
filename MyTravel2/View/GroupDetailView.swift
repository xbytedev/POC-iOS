//
//  GroupDetailView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 07/06/23.
//

import SwiftUI

struct GroupDetailView: MTAsyncView {
	@ObservedObject var viewModel: GroupDetailViewModel
	@State private var isMakingDefault = false
	@State private var configuration = UIConfiguration()
	@State private var updatingMessage = "Loading"

	var state: MTLoadingState {
		viewModel.state
	}

	var loadingMessage: String? {
		"Loading \(viewModel.group.name ?? "group") details"
	}

	var loadedView: some View {
		dataView
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					NavigationLink {
						GroupEditView(viewModel: viewModel)
					} label: {
						Image(R.image.ic_edit)
							.aspectRatio(contentMode: .fit)
							.frame(width: 16, height: 16)
							.padding(EdgeInsets(top: 8, leading: 10, bottom: 10, trailing: 8))
							.myBackground {
								Circle()
									.foregroundColor(AppColor.Text.tertiary)
									.shadow(radius: 4, x: 2, y: 2)
							}
					}
				}
			}
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

	@ViewBuilder
	var dataView: some View {
		if #available(iOS 15.0, *) {
			listView
				.refreshable(action: viewModel.refreshTravellerList)
		} else {
			listView
		}
	}

	var listView: some View {
		List {
			if #available(iOS 15.0, *) {
				sectionView
					.listSectionSeparator(.hidden)
			} else {
				sectionView
			}
		}
		.listStyle(.plain)
	}

	var sectionView: some View {
		Section {
			ForEach($viewModel.travellers) { traveller in
				Toggle(traveller.name.wrappedValue, isOn: traveller.status)
					.toggleStyle(MTToggleStyle())
					.onChange(of: traveller.status.wrappedValue, perform: { _ in
						changeStatus(of: traveller.wrappedValue)
					})
					.mtListBackgroundStyle()
			}
		} header: {
			Text(viewModel.group.name ?? "")
				.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
				.foregroundColor(AppColor.theme)
		} footer: {
			HStack {
				Spacer()
				if viewModel.group.isDefault != 1 {
					MTButton(
						isLoading: $isMakingDefault, title: R.string.localizable.makeDefault(),
						loadingTitle: R.string.localizable.makingDefault()) {
							makeGroupDefault()
						}
				}
				Spacer()
			}
		}
	}

	func load() {
		Task {
			await viewModel.getPeopleList()
		}
	}

	func changeStatus(of traveller: MTTraveller) {
		Task {
			do {
				updatingMessage = (traveller.status ? "Activating " : "Deactivating ") + traveller.name
				configuration.isLoading = true
				try await viewModel.changeStatus(ofTraveller: traveller)
				configuration.isLoading = false
			} catch {
				configuration.isLoading = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}

	func makeGroupDefault() {
		Task {
			do {
				isMakingDefault = true
				try await viewModel.makingGroupDefault()
				isMakingDefault = false
			} catch {
				isMakingDefault = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
		GroupDetailView(viewModel: .init(group: MTGroup.preview, groupDetailProvider: GroupDetailSuccessProvider()))
    }
}
