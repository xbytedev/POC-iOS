//
//  ScanQRCodeViewModel.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 14/06/23.
//

import Foundation

class ScanQRCodeViewModel: ObservableObject {
	let scanInterval: Double = 1.0
	let qrCodeCameraDelegate = QrCodeCameraDelegate()
	@Published var isTorchOn = false
	@Published var lastQRCode = ""

	func onFound(qrCode: String) {
		lastQRCode = qrCode
	}
}
