//
//  ScanQRCodeView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import SwiftUI

enum ScanFor {
	case addTraveler
	case checkIn
}

struct ScanQRCodeView: View {
	@State private var shouldTravelDetail: Bool = false
	@State private var isPresenting: Bool = false
	@State private var configuration = UIConfiguration()
	@State private var foundQR: String = ""
	@Environment(\.mtDismissable) var dismiss
	@ObservedObject var viewModel: ScanQRCodeViewModel
	@Binding var shouldNavigateBack: Bool
	let scanFor: ScanFor
	let place: MTPlace?

    var body: some View {
		ZStack {
			NavigationLink(isActive: $shouldTravelDetail) {
				TravellerDetailView(
					viewModel: viewModel, code: Int(foundQR) ?? 0, shouldNavigateBack: $shouldNavigateBack, scanFor: scanFor,
					place: place)
			} label: {
				EmptyView()
			}
			.opacity(0)
			GeometryReader { geometryProxy in
				let width = geometryProxy.size.width * 0.6
				VStack(spacing: 48) {
					VStack(spacing: 24) {
						QRCodeScannerView(delegate: viewModel.qrCodeCameraDelegate)
							.found({ foundStr in
								foundQR = foundStr
							})
//							.found(viewModel.onFound(qrCode:))
							.tourchLight(isOn: viewModel.isTorchOn)
							.interval(delay: viewModel.scanInterval)
							.frame(width: width, height: width)
						Text(R.string.localizable.pointTheCameraAtTheQrCode())
							.font(AppFont.getFont(forStyle: .title3))
							.foregroundColor(AppColor.theme)
							.frame(maxWidth: .infinity)
					}
					MTButton(isLoading: .constant(false), title: R.string.localizable.enterCodeManually(), loadingTitle: "") {
						isPresenting = true
					}
				}
				.padding(.top, geometryProxy.frame(in: .local).midY - (width / 2.0))
			}
			EnterCodeView(isPresenting: $isPresenting) { code
				in
				foundQR = code
			}
		}
		.setThemeBackButton()
		.onChange(of: foundQR) { newValue in
			guard let code = Int(newValue),
				  Validator.shared.isValid(travellerCode: newValue) else { return }
			Task {
				do {
					switch scanFor {
					case .addTraveler:
						try await viewModel.checkTraveler(with: code)
					case .checkIn:
						try await viewModel.checkIndividualCheckIn(with: code)
					}
					shouldTravelDetail = true
//					foundQR = ""
					//					try await viewModel.addTraveller(with: code, type: .single)
					//					dismiss()
				} catch {
					configuration.errorTitle = R.string.localizable.error()
					configuration.errorMeessage = error.localizedDescription
					configuration.alertPresent = true
				}
			}
		}
		.showAlert(title: configuration.errorTitle, isPresented: $configuration.alertPresent) {
			Text(configuration.errorMeessage)
		}

    }
}
#if DEBUG
struct ScanQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
		ScanQRCodeView(
			viewModel: .init(
				group: .preview, provider: AddTravellerSuccessProvider(), placeDetailProvider: PlaceDetailSuccessProvider()),
			shouldNavigateBack: .constant(true), scanFor: .addTraveler, place: .preview)
	}
}
#endif
