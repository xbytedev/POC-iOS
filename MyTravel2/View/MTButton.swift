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
	@State private var foregroundColor: Color = AppColor.Text.tertiary
	@State private var backgroundColor: Color = AppColor.theme
    var body: some View {
		Button(action: action) {
			HStack(spacing: 16) {
				if isLoading {
					ProgressView()
						.transition(.move(edge: .trailing))
						.modifier(ProgressViewModifier(color: AppColor.Text.tertiary))
				}
				Text(isLoading ? loadingTitle : title)
					.transition(.opacity)
					.foregroundColor(foregroundColor)
			}
			.frame(width: 250, height: 20)
			.font(AppFont.getFont(forStyle: .headline, forWeight: .bold))
		}
		.padding()
		.background(backgroundColor)
		.cornerRadius(18)
		.shadow(radius: 7)
		.padding(7)
		.disabled(isLoading)
    }

	func inverted() -> some View {
		var view = self
		view._backgroundColor = State(initialValue: foregroundColor)
		view._foregroundColor = State(initialValue: backgroundColor)
		return view
	}
}

struct MTButton_Previews: PreviewProvider {
    static var previews: some View {
		MTButton(isLoading: .constant(false), title: "Login", loadingTitle: "Loggin in", action: { })
    }
}
