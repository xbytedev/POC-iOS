//
//  CheckInRowView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/08/23.
//

import SwiftUI

struct CheckInRowView: View {
	let checkInTraveller: MTCheckInTraveller
    var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading) {
				HStack {
					Text(checkInTraveller.peopleName)
						.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
						.foregroundColor(AppColor.Text.primary)
					Spacer()
					Text(DateFormatter.localizedString(from: checkInTraveller.date, dateStyle: .medium, timeStyle: .none))
						.font(AppFont.getFont(forStyle: .body))
						.foregroundColor(AppColor.Text.primary)
				}
				Text(checkInTraveller.placeName ?? checkInTraveller.partnerName)
					.font(AppFont.getFont(forStyle: .callout))
					.foregroundColor(AppColor.Text.secondary)
			}
			Image(R.image.ic_arrowRight)
		}
    }
}

struct CheckInRowView_Previews: PreviewProvider {
    static var previews: some View {
		CheckInRowView(checkInTraveller: .preview)
    }
}
