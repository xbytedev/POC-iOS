//
//  CheckInDetailRowView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/08/23.
//

import SwiftUI
import RswiftResources

struct CheckInDetailRowView: View {
	let key: String
	let icon: ImageResource
	let value: String

    var body: some View {
		GeometryReader { geometryProxy in
			HStack(spacing: 20) {
				HStack {
					Text(key)
						.font(AppFont.getFont(forStyle: .subheadline, forWeight: .medium))
					Spacer()
					Image(icon)
				}
				.padding(4)
				.padding(.horizontal, 12)
				.foregroundColor(AppColor.theme)
				.myBackground {
					AppColor.Background.white
				}
				.cornerRadius(16, corners: [.topRight, .bottomRight])
				Text(value)
					.font(AppFont.getFont(forStyle: .body, forWeight: .semibold))
					.foregroundColor(AppColor.Text.tertiary)
					.frame(width: geometryProxy.size.width * 0.6, alignment: .leading)
			}
		}
    }
}

struct CheckInDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
		CheckInDetailRowView(key: "QR", icon: R.image.ic_qrCode, value: "987654321")
    }
}
