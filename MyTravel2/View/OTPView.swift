//
//  OTPView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/05/23.
//

import SwiftUI

struct OTPView: View {
	let otpDigitCount: Int

	@State private var isEditing = false {
		didSet {
			isNextTypedArr = Array(repeating: false, count: otpDigitCount)
			if isEditing && otpField.count < otpDigitCount {
				isNextTypedArr[otpField.count] = true
			}
		}
	}
	@State private var isNextTypedArr: [Bool]
	@Binding var otpField: String

	init(otpDigitCount: Int, otpString: Binding<String>) {
		isNextTypedArr = Array(repeating: false, count: otpDigitCount)
		self.otpDigitCount = otpDigitCount
		_otpField = otpString
	}

	var body: some View {
		VStack {
			ZStack {
				HStack(spacing: 24) {
					ForEach(0..<otpDigitCount, id: \.self) { index in
						otpText(text: getSingleDigitFromOTP(atIndex: index), isNextTyped: $isNextTypedArr[index])
					}
				}
				.frame(height: 64)
				.padding(.horizontal, 32)
				TextField("", text: $otpField) { isEditing in
					self.isEditing = isEditing
				}
				.frame(maxWidth: isEditing ? 0 : .infinity, minHeight: 64, maxHeight: 64)
				.textContentType(.oneTimeCode)
				.foregroundColor(.clear)
				.accentColor(.clear)
				.background(Color.clear)
				.keyboardType(.numberPad)
			}
		}
		.onChange(of: otpField) { [otpField] newValue in
			isNextTypedArr = Array(repeating: false, count: otpDigitCount)
			guard newValue.count <= otpDigitCount,
				  newValue.last?.isNumber ?? true else {
				self.otpField = otpField
				return
			}
			if newValue.count < otpDigitCount {
				isNextTypedArr[newValue.count] = true
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

	private func getSingleDigitFromOTP(atIndex index: Int) -> String {
		guard otpField.count >= index + 1 else {
			return ""
		}
		return String(otpField[otpField.index(otpField.startIndex, offsetBy: index)])
	}
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
		OTPView(otpDigitCount: 4, otpString: .constant(""))
			.previewDevice("iPhone 14 Pro")
		OTPView(otpDigitCount: 4, otpString: .constant(""))
			.previewDevice("iPhone 8 Plus")
    }
}
