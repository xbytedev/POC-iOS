//
//  MTRoundButtonModifier.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 24/05/23.
//

import SwiftUI

struct MTRoundButtonModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.aspectRatio(contentMode: .fit)
			.frame(width: 16, height: 16)
			.padding(8)
			.myBackground {
				Circle()
					.foregroundColor(AppColor.Text.tertiary)
					.shadow(radius: 4, x: 2, y: 2)
			}
	}
}

extension View {
	func roundButton() -> some View {
		modifier(MTRoundButtonModifier())
	}
}
