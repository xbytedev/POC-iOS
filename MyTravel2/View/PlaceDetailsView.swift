//
//  PlaceDetailsView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import SwiftUI

struct PlaceDetailsView: View {
	var body: some View {
		GeometryReader { geometryProxy in
			VStack {
				Image(R.image.img_setupGroup)
					.resizable()
					.aspectRatio(16/9.0, contentMode: .fill)
					.frame(height: 120)
					.offset(y: 8)
					.padding(.horizontal)
				detailView
			}
			.ignoresSafeArea(edges: .bottom)
		}
		.navigationTitle("Places")
		.setThemeBackButton()
	}

	private var detailView: some View {
		VStack(alignment: .leading, spacing: 24) {
			titleView
			descriptionView
			groupView
			groupDetailView
			individualView
			Spacer()
		}
		.frame(maxWidth: .infinity)
		.padding()
		.myBackground {
			AppColor.theme
		}
		.cornerRadius(32, corners: [.topLeft, .topRight])
		.shadow(radius: 8, y: -4)
	}

	private var titleView: some View {
		Text("Attraction, Partner Name Location, Address")
			.foregroundColor(AppColor.Text.tertiary)
			.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
			.padding(.horizontal)
	}

	private var descriptionView: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Description")
				.foregroundColor(AppColor.Text.tertiary)
				.font(AppFont.getFont(forStyle: .title3, forWeight: .semibold))
				.padding(.horizontal)
			Text("description of this attraction or partner based on information on the backoffice. if it is long... more...")
				.foregroundColor(AppColor.Text.tertiary)
				.font(AppFont.getFont(forStyle: .body))
				.lineLimit(3)
				.padding(.horizontal)
		}
	}

	private var groupView: some View {
		VStack(alignment: .leading) {
			Text("Current Group")
				.foregroundColor(AppColor.Text.tertiary)
				.font(AppFont.getFont(forStyle: .body))
			HStack {
				Text("Hammintons & Friends")
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.Text.tertiary)
				Spacer()
				Button {
				} label: {
					Text("Change")
						.foregroundColor(AppColor.theme)
						.font(AppFont.getFont(forStyle: .footnote))
				}
				.padding(8)
				.background(AppColor.Background.white)
				.clipShape(Capsule())
			}
		}
		.padding()
		.myBackground {
			VStack {
				topBorder
					.rotationEffect(.degrees(180))
				Spacer()
			}
		}
	}

	private var topBorder: some View {
		ZStack {
			MTBorderShape(type: .outbound)
				.fill(AppColor.Text.tertiary)
				.frame(height: 50)
				.offset(y: 0.75)
			MTBorderShape(type: .inbound)
				.fill(AppColor.theme)
				.frame(height: 50)
		}
	}

	private var groupDetailView: some View {
		ZStack {
			VStack(spacing: 0) {
				HStack {
					Spacer()
					VStack {
						Text("Check-in Group")
							.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
							.foregroundColor(AppColor.theme)
						Text("6 travelers")
							.font(AppFont.getFont(forStyle: .callout))
							.foregroundColor(AppColor.theme)
					}
					.padding(8)
					.padding(.horizontal, 40)
					.background(AppColor.Background.white)
					.cornerRadius(16)
					.shadow(radius: 8, y: 4)
					Spacer()
				}
				.zIndex(2)
				HStack {
					Spacer()
					VStack {
						Text("")
							.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
							.foregroundColor(AppColor.theme)
						Text("Edit Group (6/10)")
							.font(AppFont.getFont(forStyle: .callout, forWeight: .semibold))
							.foregroundColor(AppColor.theme)
					}
					.padding(8)
					.padding(.horizontal, 16)
					.background(AppColor.Background.white)
					.cornerRadius(12)
					Spacer()
				}
				.zIndex(1)
				.offset(y: -12)
			}
		}
	}

	private var individualView: some View {
		VStack {
			HStack {
				Spacer()
				Button {
				} label: {
					Text("Individual Check-in")
						.foregroundColor(AppColor.Text.tertiary)
						.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
				}
				.padding()
				.myOverlay {
					RoundedRectangle(cornerRadius: 12)
						.stroke(AppColor.Background.white, lineWidth: 2)
				}
				Spacer()
			}
			HStack {
				Spacer()
				Text("Check-in travelers not in a group.")
					.foregroundColor(AppColor.Text.tertiary)
					.font(AppFont.getFont(forStyle: .body))
					.lineLimit(3)
				Spacer()
			}
		}
	}
}

struct PlaceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
		PlaceDetailsView()
			.previewDevice("iPhone 14 Pro")
			.previewDisplayName("iPhone 14 Pro")
		PlaceDetailsView()
			.previewDevice("iPhone SE (3rd generation)")
			.previewDisplayName("iPhone SE")
    }
}