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
	@State private var updatingMessage = R.string.localizable.loading()
	@Environment(\.mtDismissable) var dismiss
	@ObservedObject var viewModel: ScanQRCodeViewModel
	let code: Int
	@Binding var shouldNavigateBack: Bool
	let scanFor: ScanFor
	@State private var isCheckingIn: Bool = false
	let place: MTPlace?

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
		.myOverlay {
			Group {
				if configuration.isLoading {
					ZStack {
						Color.black.opacity(0.4)
						VStack {
							ProgressView()
								.modifier(ProgressViewModifier(color: AppColor.Text.tertiary))
							Text(updatingMessage)
								.font(AppFont.getFont(forStyle: .body))
								.foregroundColor(AppColor.Text.tertiary)
						}
					}
				}
			}
		}
    }

	@ViewBuilder
	func dataView(with traveler: MTTempTraveler) -> some View {
		VStack {
			Spacer()
			Image(R.image.img_travel)
			Text(traveler.name)
				.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
			VStack {
				Text(R.string.localizable.cityValue(traveler.residenceCity))
					.font(AppFont.getFont(forStyle: .body))
				Text(R.string.localizable.countryValue(traveler.residenceCountry))
					.font(AppFont.getFont(forStyle: .body))
			}
			.padding()
			if scanFor == .addTraveler {
				VStack {
					Text(R.string.localizable.thereAreNumberOfPeopleTravellingWithTraveller(traveler.otherPeopleCount, traveler.name))
						.font(AppFont.getFont(forStyle: .body))
						.multilineTextAlignment(.center)
				}
				.padding()
				addTypeView.padding()
				addButtonView
			} else {
				checkInButtonView
			}
			Spacer()
		}
		.padding(.horizontal)
		.foregroundColor(AppColor.theme)
		.navigationBarHidden(true)
	}

	var addTypeView: some View {
		VStack(alignment: .leading) {
			Text(R.string.localizable.addTravellersToGroup())
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
					Text(R.string.localizable.allTravellers())
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
					Text(R.string.localizable.onlyThisTraveller())
						.font(AppFont.getFont(forStyle: .body))
				}
				.onTapGesture {
					addType = .single
				}
			}
			.padding(.vertical, 8)
		}
	}

	var addButtonView: some View {
		HStack {
			Button {
				viewModel.lastQRCode = ""
				dismiss()
			} label: {
				HStack(spacing: 16) {
					Text(R.string.localizable.cancel())
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
					Text(R.string.localizable.submit())
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

	var checkInButtonView: some View {
		HStack {
			Spacer()
			VStack {
				MTButton(
					isLoading: $isCheckingIn, title: R.string.localizable.confirmCheckIn(),
					loadingTitle: R.string.localizable.checkingIn(), action: checkIn)
				MTButton(isLoading: .constant(false), title: R.string.localizable.cancel(), loadingTitle: "", action: dismiss)
			}
			Spacer()
		}
	}

	func addTraveler() {
		Task {
			do {
				if addType == .single {
					let travellerName = viewModel.tempTraveler?.name ?? "Traveler"
					let groupName = viewModel.group.name ?? "Group"
					updatingMessage = R.string.localizable.addingTravellerToGroup(travellerName, groupName)
				} else {
					updatingMessage = R.string.localizable.addingAllToGroup(viewModel.group.name ?? "Group")
				}
				configuration.isLoading = true
				try await viewModel.addTraveller(with: code, type: addType)
				viewModel.delegate?.newTravelerAdded()
				configuration.isLoading = false
				shouldNavigateBack = false
			} catch {
				configuration.isLoading = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}

	func checkIn() {
		guard let place else { return }
		Task {
			do {
				isCheckingIn = true
				try await viewModel.checkIn(with: code, to: place)
				isCheckingIn = false
				shouldNavigateBack = false
			} catch {
				isCheckingIn = false
				configuration.errorTitle = R.string.localizable.error()
				configuration.errorMeessage = error.localizedDescription
				configuration.alertPresent = true
			}
		}
	}
}
#if DEBUG
struct TravellerDetailView_Previews: PreviewProvider {
	static var previews: some View {
		TravellerDetailView(
			viewModel: ScanQRCodeViewModel(
				group: .preview, provider: AddTravellerSuccessProvider(), placeDetailProvider: PlaceDetailSuccessProvider()),
			code: 0, shouldNavigateBack: .constant(true), scanFor: .addTraveler, place: .preview)
	}
}
#endif
