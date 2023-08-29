//
//  CheckInDetailView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/08/23.
//

import SwiftUI

struct CheckInDetailView: MTAsyncView {
	@State var state: MTLoadingState = .idle
	@State private var checkInTravellerDetail: MTCheckInTravellerDetail?
	@ObservedObject var viewModel: CheckInViewModel
	let checkInTraveller: MTCheckInTraveller

    var loadedView: some View {
		ZStack {
			AppColor.theme.ignoresSafeArea()
			VStack(spacing: 32) {
				Text(checkInTravellerDetail!.peopleName)
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.Text.tertiary)
				VStack(spacing: 4) {
					CheckInDetailRowView(
						key: R.string.localizable.qR(),
						icon: R.image.ic_qrCode, value: checkInTravellerDetail!.peopleCode)
					CheckInDetailRowView(
						key: R.string.localizable.city(), icon: R.image.ic_locationCheckIn, value: checkInTravellerDetail!.peopleCity)
					CheckInDetailRowView(
						key: R.string.localizable.country(), icon: R.image.ic_tab_checkIn, value: checkInTravellerDetail!.peopleCountry)
				}
				Text(checkInTravellerDetail!.placeName ?? checkInTravellerDetail!.parnerName)
					.font(AppFont.getFont(forStyle: .title2, forWeight: .semibold))
					.foregroundColor(AppColor.Text.tertiary)
				VStack(spacing: 4) {
					CheckInDetailRowView(
						key: R.string.localizable.partnerId(), icon: R.image.ic_identity,
						value: NSNumber(value: checkInTravellerDetail!.partnerId).stringValue)
					CheckInDetailRowView(
						key: R.string.localizable.checkIn(), icon: R.image.ic_locationCheckIn,
						value: DateFormatter.localizedString(from: checkInTravellerDetail!.date, dateStyle: .medium, timeStyle: .medium))
				}
				Spacer()
			}
		}
    }

	func load() {
		Task {
			do {
				state = .loading
				checkInTravellerDetail = try await viewModel.getCheckInTravellerDetail(from: checkInTraveller)
				state = .loaded
			} catch {
				state = .failed(error)
			}
		}
	}
}

#if DEBUG
struct CheckInDetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			CheckInDetailView(viewModel: CheckInViewModel(withProvider: CheckInSuccessProvider()), checkInTraveller: .preview)
		}
		.previewDevice("iPhone 8 Plus")
    }
}
#endif
