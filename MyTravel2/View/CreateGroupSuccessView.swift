//
//  CreateGroupSuccessView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/05/23.
//

import SwiftUI

struct CreateGroupSuccessView: View {
	@Environment (\.mtDismissable) var dismiss
	let group: MTGroup
	@Binding var shouldPresent: Bool
	@State private var shouldAddTraveller: Bool = false
	var addTraveler: () -> Void

    var body: some View {
		ZStack {
			AppColor.theme.ignoresSafeArea()
			VStack(spacing: 72) {
				VStack(spacing: 36) {
					Image(R.image.ic_right)
					Text(R.string.localizable.groupNameCreated(group.name ?? ""))
						.multilineTextAlignment(.center)
						.foregroundColor(AppColor.Text.tertiary)
						.font(AppFont.getFont(forStyle: .largeTitle, forWeight: .medium))
				}
				VStack {
					// TODO: Add Traveller navigation is not working
//					NavigationLink {
//						ScanQRCodeView(
//							viewModel: ScanQRCodeViewModel(group: group, provider: AddTravellerAPIProvider()), shouldNavigateBack: .constant(true))
//						.navigationTitle("QR Code")
//					} label: {
						MTButton(isLoading: .constant(false), title: R.string.localizable.addTravelers(), loadingTitle: "") {
							dismiss()
//							shouldAddTraveller = true
							addTraveler()
						}
						.inverted()
//					}
					Button(action: dismiss) {
						Text(R.string.localizable.cancel)
							.foregroundColor(AppColor.Text.tertiary)
							.font(AppFont.getFont(forStyle: .headline, forWeight: .semibold))
					}
				}
			}
			.padding(.horizontal, 48)
		}
    }
}

struct CreateGroupSuccessView_Previews: PreviewProvider {
    static var previews: some View {
		let group = MTGroup.preview
		CreateGroupSuccessView(group: group, shouldPresent: .constant(false), addTraveler: { })
    }
}
