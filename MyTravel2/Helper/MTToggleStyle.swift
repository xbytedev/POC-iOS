//
//  MTToggleStyle.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 20/06/23.
//

import SwiftUI

struct MTToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			configuration.label
			Spacer()
			RoundedRectangle(cornerRadius: 16)
				.fill(configuration.isOn ? AppColor.theme : AppColor.Background.white)
				.myOverlay {
					Circle()
						.fill(configuration.isOn ? AppColor.Background.white : AppColor.theme)
						.padding(4)
						.offset(x: configuration.isOn ? 10 : -10)
				}
				.frame(width: 40, height: 20)
				.shadow(radius: 4, x: 2, y: 2)
				.onTapGesture {
					withAnimation(.spring()) {
						configuration.isOn.toggle()
					}
				}
		}
	}
}
