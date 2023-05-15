//
//  OTPView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/05/23.
//

import SwiftUI

class ViewModel: ObservableObject {

	let otpDigitCount = 4

	@Published var otpField = "" {
		didSet {
			isNextTypedArr = Array(repeating: false, count: otpDigitCount)
			guard otpField.count <= otpDigitCount,
				  otpField.last?.isNumber ?? true else {
				otpField = oldValue
				return
			}
			if otpField.count < otpDigitCount {
				isNextTypedArr[otpField.count] = true
			}
		}
	}

	@Published var isNextTypedArr = Array(repeating: false, count: 4) // otpDigitCount
	@Published var isEditing = false {
		didSet {
			isNextTypedArr = Array(repeating: false, count: otpDigitCount)
			if isEditing && otpField.count < otpDigitCount {
				isNextTypedArr[otpField.count] = true
			}
		}
	}

	func getSingleDigitFromOTP(atIndex index: Int) -> String {
		guard otpField.count >= index + 1 else {
			return ""
		}
		return String(otpField[otpField.index(otpField.startIndex, offsetBy: index)])
	}
}

struct OTPView: View {
	@StateObject var viewModel = ViewModel()

	var body: some View {
		VStack {
			ZStack {
				HStack(spacing: 24) {
					ForEach(0..<viewModel.otpDigitCount, id: \.self) { index in
						otpText(text: viewModel.getSingleDigitFromOTP(atIndex: index), isNextTyped: $viewModel.isNextTypedArr[index])
					}
				}
				.frame(height: 64)
				.padding(.horizontal, 32)
				TextField("", text: $viewModel.otpField) { isEditing in
					viewModel.isEditing = isEditing
				}
				.frame(width: viewModel.isEditing ? 0 : .infinity, height: 64)
				.textContentType(.oneTimeCode)
				.foregroundColor(.clear)
				.accentColor(.clear)
				.background(Color.clear)
				.keyboardType(.numberPad)
			}
		}
	}

	private func otpText(text: String, isNextTyped: Binding<Bool>) -> some View {
		return GeometryReader { geo in
			Text(text)
				.font(.title)
				.frame(width: geo.size.height, height: geo.size.height)
				.background(
					RoundedRectangle(cornerRadius: 12)
						.foregroundColor(AppColor.Text.tertiary)
						.shadow(radius: 4)
				)
		}
	}
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
		OTPView()
			.previewDevice("iPhone 14 Pro")
		OTPView()
			.previewDevice("iPhone 8 Plus")
    }
}
