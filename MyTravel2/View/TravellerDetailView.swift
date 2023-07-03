//
//  TravellerDetailView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 26/06/23.
//

import SwiftUI

struct TravellerDetailView: View {
	@State private var addType: TravelerCodeType = .all
	@State private var configuration = UIConfiguration()
	@Environment(\.mtDismissable) var dismiss
	@ObservedObject var viewModel: ScanQRCodeViewModel
	let code: Int

    var body: some View {
		Group {
			if let traveler = viewModel.tempTraveler {
				dataView(with: traveler)
			} else {
				EmptyView()
			}
		}
		.showAlert(title: configuration.errorTitle, isPresented: $configuration.alertPresent) {
			Text(configuration.errorMeessage)
		}
    }

	@ViewBuilder
	func dataView(with traveler: MTTempTraveler) -> some View {
		VStack {
			Image(R.image.img_travel)
			Text(traveler.name)
				.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
			VStack {
				Text("City: " + traveler.residenceCity)
					.font(AppFont.getFont(forStyle: .body))
				Text("Country: " + traveler.residenceCountry)
					.font(AppFont.getFont(forStyle: .body))
			}
			.padding()
			VStack {
				Text("There are \(traveler.otherPeopleCount) people travelling with \(traveler.name)")
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
							.foregroundColor(addType == .all ? AppColor.theme : Color.clear)
							.padding(2)
							.myOverlay(overlayView: {
								Circle()
									.stroke(AppColor.Text.secondary)
							})
						Text("All Travelers")
							.font(AppFont.getFont(forStyle: .body))
					}
					.onTapGesture {
						addType = .all
					}
					HStack {
						Circle()
							.frame(width: 12)
							.foregroundColor(addType == .single ? AppColor.theme : Color.clear)
							.padding(2)
							.myOverlay {
								Circle()
									.stroke(AppColor.Text.secondary)
							}
						Text("Only this traveler")
							.font(AppFont.getFont(forStyle: .body))
					}
					.onTapGesture {
						addType = .single
					}
				}
				.padding(.vertical, 8)
			}
			.padding()
			HStack {
				Button {
					viewModel.lastQRCode = ""
					dismiss()
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
					addTraveler()
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

	func addTraveler() {
		Task {
			do {
				try await viewModel.addTraveller(with: code, type: addType)
				// TODO: navigate back to group detail screen or group list
			} catch {
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}
}

struct TravellerDetailView_Previews: PreviewProvider {
    static var previews: some View {
		TravellerDetailView(viewModel: ScanQRCodeViewModel(group: .preview, provider: AddTravellerSuccessProvider()), code: 0)
    }
}
