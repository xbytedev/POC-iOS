//
//  GroupDetailView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 07/06/23.
//

import SwiftUI

struct GroupDetailView: MTAsyncView {
	@ObservedObject var viewModel: GroupDetailViewModel

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
						Image(systemName: "plus")
							.roundButton()
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
			ForEach($viewModel.travellers) { item in
				Toggle(item.name.wrappedValue, isOn: item.status)
					.onChange(of: item.status.wrappedValue, perform: { newValue in
						print(newValue)
					})
					.mtListBackgroundStyle()
			}
			.onDelete { index in
			}
		}
		.listStyle(.plain)
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
