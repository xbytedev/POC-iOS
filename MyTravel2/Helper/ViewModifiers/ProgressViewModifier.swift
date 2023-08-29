//
//  ProgressViewModifier.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct ProgressViewModifier: ViewModifier {
	let color: Color

	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content.tint(color)
		} else {
			content.progressViewStyle(CircularProgressViewStyle(tint: color))
		}
	}
}

struct RoundRectShadowBackgroundModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(.vertical, 8)
			.padding(.horizontal, 12)
			.myBackground {
				RoundedRectangle(cornerRadius: 12)
					.foregroundColor(AppColor.Background.white)
					.shadow(radius: 8, y: 4)
			}
	}
}
