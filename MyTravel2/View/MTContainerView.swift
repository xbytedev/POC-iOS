//
//  MTContainerView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 08/05/23.
//

import SwiftUI

struct FormModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding()
			.background {
				ZStack {
					Rectangle()
						.foregroundColor(AppColor.theme)
						.cornerRadius(16)
						.offset(y: 16)
					Rectangle()
						.foregroundColor(AppColor.Background.white)
						.cornerRadius(16)
						.shadow(radius: 8)
				}
				.frame(minWidth: 0, maxWidth: .infinity)
			}
			.padding()
	}
}
