//
//  QrCodeCameraDelegate.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 14/06/23.
//

import Foundation
import AVFoundation

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
	var scanInterval: Double = 1.0
	var lastTime = Date.distantPast

	var onResult: (String) -> Void = { _  in }
	var mockData: String?
//

	func metadataOutput(
		_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
		from connection: AVCaptureConnection) {
			if let metadataObject = metadataObjects.first {
				guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
				guard let stringValue = readableObject.stringValue else { return }
				foundBarcode(stringValue)
			}
		}

	@objc func onSimulateScanning() {
		foundBarcode(mockData ?? "Simulate QR code")
	}

	func foundBarcode(_ string: String) {
		let now = Date()
		if now.timeIntervalSince(lastTime) >= scanInterval {
			lastTime = now
			self.onResult(string)
		}
	}
}
