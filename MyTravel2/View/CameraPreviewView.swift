//
//  CameraPreviewView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 14/06/23.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
	private var label: UILabel?

	var previewLayer: AVCaptureVideoPreviewLayer?
	let session: AVCaptureSession
	weak var delegate: QrCodeCameraDelegate?

	init(session: AVCaptureSession) {
		self.session = session
		super.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		fatalError("Not yet implemented")
	}

	func createSimulatorView(delegate: QrCodeCameraDelegate) {
		self.delegate = delegate
		backgroundColor = .black
		label = UILabel(frame: bounds)
		label?.text = "Click here to simulate scan"
		label?.textColor = .white
		label?.textAlignment = .center
		if let label {
			addSubview(label)
		}
		let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
		addGestureRecognizer(gesture)
	}

	@objc func onClick() {
		delegate?.onSimulateScanning()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		#if targetEnvironment(simulator)
		label?.frame = bounds
		#else
		previewLayer?.frame = bounds
		#endif
	}
}
