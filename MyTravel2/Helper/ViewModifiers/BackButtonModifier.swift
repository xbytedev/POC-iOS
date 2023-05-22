//
//  BackButtonModifier.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/05/23.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.navigationBarBackButtonHidden()
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					MTBackButton()
				}
			}
	}
}

extension View {
	func setThemeBackButton() -> some View {
		modifier(BackButtonModifier())
	}
}
