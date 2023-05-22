//
//  CreateGroupSuccessView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/05/23.
//

import SwiftUI

struct CreateGroupSuccessView: View {
	@Environment (\.mtDismissable) var dismiss
    var body: some View {
		ZStack {
			AppColor.theme.ignoresSafeArea()
			VStack(spacing: 72) {
				VStack(spacing: 36) {
					Image(R.image.ic_right)
					Text("Group\n" + "Hammiltons & Friedmmans" + "\ncreated!")
						.multilineTextAlignment(.center)
						.foregroundColor(AppColor.Text.tertiary)
						.font(AppFont.getFont(forStyle: .largeTitle, forWeight: .medium))
				}
				VStack {
					MTButton(isLoading: .constant(false), title: "Add Travelers", loadingTitle: "") {
					}
					.inverted()
					Button {
						dismiss()
					} label: {
						Text("Cancel")
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
		CreateGroupSuccessView()
    }
}
