//
//  ScanQRCodeView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import SwiftUI

struct ScanQRCodeView: View {
	@ObservedObject var viewModel: ScanQRCodeViewModel

    var body: some View {
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
					Text("Point the Camera at the QR Code")
						.font(AppFont.getFont(forStyle: .title3))
						.foregroundColor(AppColor.theme)
						.frame(maxWidth: .infinity)
				}
				MTButton(isLoading: .constant(false), title: "Enter Code Manually", loadingTitle: "") {
				}
			}
			.padding(.top, geometryProxy.frame(in: .local).midY - (width / 2.0))
		}
    }

	var someView: some View {
		GeometryReader { geometryProxy in
			VStack {
				Rectangle()
					.frame(width: geometryProxy.size.width * 0.6, height: geometryProxy.size.width * 0.6)
					.position(x: geometryProxy.frame(in: .local).midX, y: geometryProxy.frame(in: .local).midY)
				Text("Point the Camera at the QR Code")
					.font(AppFont.getFont(forStyle: .body))
				MTButton(isLoading: .constant(false), title: "Enter Code Manually", loadingTitle: "") {
				}
				Spacer()
			}
		}
	}
}

struct ScanQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
		ScanQRCodeView(viewModel: .init())
    }
}
