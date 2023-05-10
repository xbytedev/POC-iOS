//
//  MTButton.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 08/05/23.
//

import SwiftUI

struct MTButton: View {
	@Binding var isLoading: Bool
	let title: String
	let loadingTitle: String
	let action: () -> Void
    var body: some View {
		Button {
			action()
		} label: {
			HStack(spacing: 16) {
				if isLoading {
					ProgressView()
						.transition(.move(edge: .trailing))
						.tint(AppColor.Text.tertiary)
				}
				Text(isLoading ? loadingTitle : title)
					.transition(.opacity)
					.foregroundColor(AppColor.Text.tertiary)
			}
			.frame(minWidth: 0, maxWidth: .infinity)
			.font(AppFont.getFont(forStyle: .headline, forWeight: .bold))
		}
		.padding()
		.background(AppColor.theme)
		.cornerRadius(18)
		.shadow(radius: 7)
		.padding(7)
		.disabled(isLoading)
    }
}

struct MTButton_Previews: PreviewProvider {
    static var previews: some View {
		MTButton(isLoading: .constant(false), title: "Login", loadingTitle: "Loggin in", action: { })
    }
}
