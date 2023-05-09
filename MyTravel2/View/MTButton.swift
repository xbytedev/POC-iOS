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
			HStack {
				if isLoading {
					ProgressView()
						.transition(.move(edge: .trailing))
				}
				Text(isLoading ? loadingTitle : title)
			}
			.foregroundColor(AppColor.Text.tertiary)
			// TODO: update font
		}
		.padding()
		.frame(minWidth: 0, maxWidth: .infinity)
		.background(AppColor.theme)
		.cornerRadius(18)
		.shadow(radius: 7)
		.padding(7)
    }
}

struct MTButton_Previews: PreviewProvider {
    static var previews: some View {
		MTButton(isLoading: .constant(false), title: "Login", loadingTitle: "Loggin in", action: { })
    }
}
