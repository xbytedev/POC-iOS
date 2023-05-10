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
