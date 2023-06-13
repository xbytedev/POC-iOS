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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
						Button {
//							isPopupPresented = true
						} label: {
							Image(systemName: "plus")
								.roundButton()
						}
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
