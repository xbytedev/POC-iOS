//
//  MTLazyView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 24/05/23.
//

import SwiftUI

struct MTLazyView<Content: View>: View {
	let build: () -> Content
	init(_ build: @autoclosure @escaping () -> Content) {
		self.build = build
	}
    var body: some View {
		build()
    }
}
