//
//  ScanQRCodeView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import SwiftUI

struct ScanQRCodeView: View {
	@State private var isPresenting: Bool = false
	@ObservedObject var viewModel: ScanQRCodeViewModel

    var body: some View {
		ZStack {
			GeometryReader { geometryProxy in
				let width = geometryProxy.size.width * 0.6
				VStack(spacing: 48) {
					VStack(spacing: 24) {
						QRCodeScannerView(delegate: viewModel.qrCodeCameraDelegate)
							.found(viewModel.onFound(qrCode:))
							.tourchLight(isOn: viewModel.isTorchOn)
							.interval(delay: viewModel.scanInterval)
							.frame(width: width, height: width)
						Text(viewModel.lastQRCode)
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
				viewModel.onFound(qrCode: code)
			}
		}
		.setThemeBackButton()
		.onChange(of: viewModel.lastQRCode) { newValue in
			guard let code = Int(newValue) else { return }
			Task {
				do {
					try await viewModel.addTraveller(with: code)
				} catch {
					print(error.localizedDescription)
				}
			}
		}
    }
}

struct ScanQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
		ScanQRCodeView(viewModel: .init(group: .preview, provider: AddTravellerSuccessProvider()))
    }
}
