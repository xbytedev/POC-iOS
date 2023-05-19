//
//  WelcomeView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
		ZStack {
			backgroundImage
			VStack(spacing: 32.0) {
				VStack(alignment: .leading) {
					Text(R.string.localizable.welcome)
						.font(AppFont.getFont(forStyle: .title1))
					Text(MTUserDefaults.currentUser?.name ?? "")
						.font(AppFont.getFont(forStyle: .largeTitle, forWeight: .semibold))
				}
				.foregroundColor(AppColor.Text.tertiary)
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
				VStack {
					NavigationLink {
						AppTabBarView()
					} label: {
						MTButton(isLoading: .constant(false), title: R.string.localizable.manageGroups(), loadingTitle: "") {
						}
						.disabled(true)
					}

					MTButton(isLoading: .constant(false), title: R.string.localizable.checkinTravlers(), loadingTitle: "") {
					}
				}
			}
			.padding()
		}
		.myOverlay(alignment: .top) {
			Image(R.image.img_myTravelLogo)
				.resizable()
				.scaledToFit()
				.frame(height: 128)
				.padding(.vertical)
		}.navigationBarBackButtonHidden()
    }

	var backgroundImage: some View {
		Image(R.image.img_background)
			.resizable()
			.scaledToFill()
			.clipped()
			.frame(minWidth: 0, maxWidth: .infinity)
			.ignoresSafeArea()
	}
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			WelcomeView()
		}
    }
}
