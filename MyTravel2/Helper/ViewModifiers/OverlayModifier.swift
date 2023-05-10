//
//  OverlayModifier.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct OverlayModifier<V: View>: ViewModifier {
	let overlayView: () -> V
	let alignment: Alignment

	init(alignment: Alignment = .center, @ViewBuilder overlayView content: @escaping () -> V) {
		self.overlayView = content
		self.alignment = alignment
	}

	func body(content: Content) -> some View {
		if #available(iOS 15.0, *) {
			content.overlay(alignment: alignment, content: overlayView)
		} else {
			content.overlay(overlayView(), alignment: alignment)
		}
	}
}

extension View {
	func myOverlay<V: View>(alignment: Alignment = .center, overlayView: @escaping () -> V) -> some View {
		self.modifier(OverlayModifier(alignment: alignment, overlayView: overlayView))
	}
}
