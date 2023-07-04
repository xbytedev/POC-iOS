//
//  ScanQRCodeViewModel.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 14/06/23.
//

import Foundation

protocol AddTravelerDelegate: AnyObject {
	func newTravelerAdded()
}

class ScanQRCodeViewModel: ObservableObject {
	let group: MTGroup
	let provider: AddTravellerProvider
	let scanInterval: Double = 1.0
	let qrCodeCameraDelegate = QrCodeCameraDelegate()
	var tempTraveler: MTTempTraveler?
	@Published var isTorchOn = false
	var lastQRCode = ""
	weak var delegate: AddTravelerDelegate?

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
		tempTraveler = try await provider.checkTraveler(to: group, with: code).get()
	}
}
