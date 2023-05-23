//
//  MTBackButton.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/05/23.
//

import SwiftUI

struct MTBackButton: View {
	@Environment(\.mtDismissable) var dismiss

	var body: some View {
		Button(action: dismiss) {
			Image(systemName: "chevron.backward")
				.resizable()
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
}

struct MTBackButton_Previews: PreviewProvider {
    static var previews: some View {
        MTBackButton()
    }
}
