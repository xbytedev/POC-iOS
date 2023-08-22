//
//  CheckInDetailView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/08/23.
//

import SwiftUI

struct CheckInDetailView: View {
    var body: some View {
		ZStack {
			AppColor.theme.ignoresSafeArea()
			VStack(spacing: 32) {
				Text("Manuel Hernandez")
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.Text.tertiary)
				VStack(spacing: 4) {
					CheckInDetailRowView(key: "QR", icon: R.image.ic_qrCode, value: "987654321")
					CheckInDetailRowView(key: "City", icon: R.image.ic_locationCheckIn, value: "Cidad Juarez")
					CheckInDetailRowView(key: "Country", icon: R.image.ic_tab_checkIn, value: "Mexico")
				}
				Text("Attraction 5 name or partner")
				VStack(spacing: 4) {
					CheckInDetailRowView(key: "Partner ID", icon: R.image.ic_identity, value: "123456789")
					CheckInDetailRowView(key: "Check-In", icon: R.image.ic_locationCheckIn, value: "12/03/2023 12:45:12")
				}
				Spacer()
			}
		}

    }
}

struct CheckInDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInDetailView()
    }
}
