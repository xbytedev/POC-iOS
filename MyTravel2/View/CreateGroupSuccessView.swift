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
					MTButton(isLoading: .constant(false), title: R.string.localizable.addTravelers(), loadingTitle: "") {
					}
					.inverted()
					Button {
						shouldPresent = false
					} label: {
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
		let group = MTGroup(id: 0, name: "Hammiltons & Friedmmans", partnerID: 0, status: 0, createdAt: nil, updatedAt: nil)
		CreateGroupSuccessView(group: group, shouldPresent: .constant(false))
    }
}
