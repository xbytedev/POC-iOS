//
//  TravellerDetailView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 26/06/23.
//

import SwiftUI

struct TravellerDetailView: View {
	let traveler: MTTraveller
	let city: String
	let country: String
	let otherCount: Int

    var body: some View {
		VStack {
			Image(R.image.img_travel)
			Text(traveler.name)
				.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
			VStack {
				Text("City: " + city)
					.font(AppFont.getFont(forStyle: .body))
				Text("Country: " + country)
					.font(AppFont.getFont(forStyle: .body))
			}
			.padding()
			VStack {
				Text("There are \(otherCount) people travelling with \(traveler.name)")
					.font(AppFont.getFont(forStyle: .body))
					.multilineTextAlignment(.center)
			}
			.padding()
			VStack(alignment: .leading) {
				Text("Add Travelers to Group")
					.font(AppFont.getFont(forStyle: .body, forWeight: .semibold))
				VStack(alignment: .leading) {
					HStack {
						Circle()
							.frame(width: 12)
							.padding(2)
							.myOverlay(overlayView: {
								Circle()
									.stroke(AppColor.Text.secondary)
							})
						Text("All Travelers")
							.font(AppFont.getFont(forStyle: .body))
					}
					HStack {
						Circle()
							.frame(width: 12)
							.foregroundColor(.clear)
							.padding(2)
							.myOverlay {
								Circle()
									.stroke(AppColor.Text.secondary)
							}
						Text("Only this traveler")
							.font(AppFont.getFont(forStyle: .body))
					}
				}
				.padding(.vertical, 8)
			}
			.padding()
			HStack {
				Button {
				} label: {
					HStack(spacing: 16) {
						Text("Cancle")
							.transition(.opacity)
							.foregroundColor(AppColor.theme)
					}
					.frame(width: 120, height: 16)
					.font(AppFont.getFont(forStyle: .headline, forWeight: .bold))
				}
				.padding()
				.myOverlay(overlayView: {
					RoundedRectangle(cornerRadius: 18)
						.stroke(AppColor.theme)
						.shadow(radius: 7)
				})
				.padding(7)
				Button {
				} label: {
					HStack(spacing: 16) {
						Text("Submit")
							.transition(.opacity)
							.foregroundColor(AppColor.Text.tertiary)
					}
					.frame(width: 120, height: 16)
					.font(AppFont.getFont(forStyle: .headline, forWeight: .bold))
				}
				.padding()
				.background(AppColor.theme)
				.cornerRadius(18)
				.shadow(radius: 7)
				.padding(7)

			}
		}
		.padding(.horizontal)
		.foregroundColor(AppColor.theme)
		.navigationBarHidden(true)
    }
}

struct TravellerDetailView_Previews: PreviewProvider {
    static var previews: some View {
		TravellerDetailView(traveler: .preview, city: "Cidade Juare", country: "Mexico", otherCount: 5)
    }
}
