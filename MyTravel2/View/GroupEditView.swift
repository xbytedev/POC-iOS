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
				NavigationLink(isActive: $shouldAddNew) {
					ScanQRCodeView(
						viewModel: ScanQRCodeViewModel(group: viewModel.group, provider: AddTravellerAPIProvider()))
					.navigationTitle("QR Code")
				} label: {
					EmptyView()
				}
				.opacity(0)
				HStack {
					Spacer()
					VStack {
						MTButton(isLoading: .constant(false), title: "Add Travellers", loadingTitle: "") {
							shouldAddNew = true
						}
						MTButton(isLoading: $isDeleting, title: "Delete Group", loadingTitle: "Deleting group") {
						}
					}
					Spacer()
				}
			}
			.listRowBackground(Color.clear)
		}
	}
}

struct GroupEditView_Previews: PreviewProvider {
    static var previews: some View {
		GroupEditView(viewModel: .init(group: .preview, groupDetailProvider: GroupDetailSuccessProvider()))
    }
}
