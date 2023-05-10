//
//  BackgroundModifier.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct BackgroundModifier<V: View>: ViewModifier {
	let backgroundView: () -> V
	let alignment: Alignment

	init(alignment: Alignment = .center, backgroundView: @escaping () -> V) {
		self.backgroundView = backgroundView
		self.alignment = alignment
	}

	func body(content: Content) -> some View {
		if #available(iOS 15.0, *) {
			content.background(alignment: alignment, content: backgroundView)
		} else {
			content.background(backgroundView(), alignment: alignment)
		}
	}
}

extension View {
	func myBackground<V: View>(alignment: Alignment = .center, backgroundView: @escaping () -> V) -> some View {
		self.modifier(BackgroundModifier(alignment: alignment, backgroundView: backgroundView))
	}
}
