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
						ScanQRCodeView(viewModel: ScanQRCodeViewModel(group: viewModel.group, provider: AddTravellerAPIProvider()))
							.navigationTitle("QR Code")
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
			ForEach($viewModel.travellers) { item in
				Toggle(item.name.wrappedValue, isOn: item.status)
					.toggleStyle(MTToggleStyle())
					.onChange(of: item.status.wrappedValue, perform: { newValue in
						print(newValue)
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
				MTButton(
					isLoading: $isMakingDefault, title: R.string.localizable.makeDefault(),
					loadingTitle: R.string.localizable.makingDefault()) {
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
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
		GroupDetailView(viewModel: .init(group: MTGroup.preview, groupDetailProvider: GroupDetailSuccessProvider()))
    }
}
