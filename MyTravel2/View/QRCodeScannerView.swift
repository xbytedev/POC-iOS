//
//  QRCodeScannerView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 14/06/23.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewRepresentable {

	private let session: AVCaptureSession
	private let delegate: QrCodeCameraDelegate
	private let metadataOutput: AVCaptureMetadataOutput
	private let backCamera: AVCaptureDevice?
	private let supportedBarcodeTypes: [AVMetadataObject.ObjectType]

	init(delegate: QrCodeCameraDelegate) {
		supportedBarcodeTypes = [.qr]
		session = AVCaptureSession()
		self.delegate = delegate
		metadataOutput = AVCaptureMetadataOutput()
		let session = AVCaptureDevice.DiscoverySession(
			deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
		let devices = session.devices.compactMap { $0 }
		backCamera = devices.first // AVCaptureDevice.default(for: .video)
	}

	func tourchLight(isOn: Bool) -> QRCodeScannerView {
		guard let backCamera, backCamera.hasTorch else { return self }
		try? backCamera.lockForConfiguration()
		backCamera.torchMode = isOn ? .on : .off
		backCamera.unlockForConfiguration()
		return self
	}

	func interval(delay: Double) -> QRCodeScannerView {
		delegate.scanInterval = delay
		return self
	}

	func found(_ result: @escaping (String) -> Void) -> QRCodeScannerView {
		delegate.onResult = result
		return self
	}

	func simulator(mockBarCode: String) -> QRCodeScannerView {
		delegate.mockData = mockBarCode
		return self
	}

	func setupCamera(_ uiView: CameraPreviewView) {
		guard let backCamera, let input = try? AVCaptureDeviceInput(device: backCamera) else { return }
		session.sessionPreset = .photo

		if session.canAddInput(input) {
			session.addInput(input)
		}
		if session.canAddOutput(metadataOutput) {
			session.addOutput(metadataOutput)
			if metadataOutput.availableMetadataObjectTypes.contains(.qr) {
				metadataOutput.metadataObjectTypes = supportedBarcodeTypes
			}
			metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
		}
		let previewLayer = AVCaptureVideoPreviewLayer(session: session)
		uiView.backgroundColor = .gray
		previewLayer.videoGravity = .resizeAspectFill
		uiView.layer.addSublayer(previewLayer)
		uiView.previewLayer = previewLayer
		DispatchQueue.global(qos: .background).async {
			session.startRunning()
		}
	}

	func makeUIView(context: Context) -> CameraPreviewView {
		let cameraView = CameraPreviewView(session: session)
		#if targetEnvironment(simulator)
		cameraView.createSimulatorView(delegate: delegate)
		#else
		checkCameraAuthorization(andSetUpCamera: cameraView)
		#endif
		return cameraView
	}
	static func dismantleUIView(_ uiView: CameraPreviewView, coordinator: ()) {
		uiView.session.stopRunning()
	}

	func updateUIView(_ uiView: CameraPreviewView, context: Context) {
		uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
	}

	private func checkCameraAuthorization(andSetUpCamera cameraPreview: CameraPreviewView) {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .notDetermined:
			DispatchQueue.main.async {
				AVCaptureDevice.requestAccess(for: .video) { _ in
					checkCameraAuthorization(andSetUpCamera: cameraPreview)
				}
			}
		case .authorized:
			DispatchQueue.main.async {
				setupCamera(cameraPreview)
			}
		case .denied: break
		case .restricted: break
		@unknown default: break
		}
	}
}
