//
//  ScanQRCodeViewModel.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 14/06/23.
//

import Foundation

class ScanQRCodeViewModel: ObservableObject {
	let group: MTGroup
	let provider: AddTravellerProvider
	let scanInterval: Double = 1.0
	let qrCodeCameraDelegate = QrCodeCameraDelegate()
	@Published var isTorchOn = false
	@Published var lastQRCode = ""

	init(group: MTGroup, provider: AddTravellerProvider) {
		self.group = group
		self.provider = provider
	}

	func onFound(qrCode: String) {
		lastQRCode = qrCode
	}

	func addTraveller(with code: Int, type: TravelerCodeType) async throws {
		_ = try await provider.addTraveler(to: group, with: code, type: type).get()
	}

	func checkTraveler(with code: Int) async throws {
		_ = try await provider.checkTraveler(to: group, with: code).get()
	}
}
