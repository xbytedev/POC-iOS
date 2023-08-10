//
//  CheckInRowView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/08/23.
//

import SwiftUI

struct CheckInRowView: View {
    var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading) {
				HStack {
					Text("Name of traveller 1")
						.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
						.foregroundColor(AppColor.Text.primary)
					Spacer()
					Text("12/03/2023")
						.font(AppFont.getFont(forStyle: .body))
						.foregroundColor(AppColor.Text.primary)
				}
				Text("Attraction 1 name or partner")
					.font(AppFont.getFont(forStyle: .callout))
					.foregroundColor(AppColor.Text.secondary)
			}
			Image(R.image.ic_arrowRight)
		}
		.mtListBackgroundStyle()
    }
}

struct CheckInRowView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInRowView()
    }
}
