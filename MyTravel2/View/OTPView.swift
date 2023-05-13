//
//  OTPView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/05/23.
//

import SwiftUI

class ViewModel: ObservableObject {

	@Published var otpField = "" {
		didSet {
			isNextTypedArr = Array(repeating: false, count: 4)
			guard otpField.count <= 4,
				  otpField.last?.isNumber ?? true else {
				otpField = oldValue
				return
			}
			if otpField.count < 4 {
				isNextTypedArr[otpField.count] = true
			}
		}
	}
	var otp1: String {
		guard otpField.count >= 1 else {
			return ""
		}
		return String(Array(otpField)[0])
	}
	var otp2: String {
		guard otpField.count >= 2 else {
			return ""
		}
		return String(Array(otpField)[1])
	}
	var otp3: String {
		guard otpField.count >= 3 else {
			return ""
		}
		return String(Array(otpField)[2])
	}
	var otp4: String {
		guard otpField.count >= 4 else {
			return ""
		}
		return String(Array(otpField)[3])
	}

	@Published var isNextTypedArr = Array(repeating: false, count: 4)
	@Published var borderColor: Color = .black
	@Published var isEditing = false {
		didSet {
			isNextTypedArr = Array(repeating: false, count: 4)
			if isEditing && otpField.count < 4 {
				isNextTypedArr[otpField.count] = true
			}
		}
	}
}

struct OTPView: View {
	@StateObject var viewModel = ViewModel()

	let textBoxWidth = UIScreen.main.bounds.width / 6
	let textBoxHeight = UIScreen.main.bounds.width / 6
	let spaceBetweenLines: CGFloat = 10
	let paddingOfBox: CGFloat = 1
	var textFieldOriginalWidth: CGFloat {
		(textBoxWidth*6)+(spaceBetweenLines*3)+((paddingOfBox*2)*3)
	}

	var body: some View {
		VStack {
			ZStack {
				HStack {
					otpText(text: viewModel.otp1, isNextTyped: $viewModel.isNextTypedArr[0])
					otpText(text: viewModel.otp2, isNextTyped: $viewModel.isNextTypedArr[1])
					otpText(text: viewModel.otp3, isNextTyped: $viewModel.isNextTypedArr[2])
					otpText(text: viewModel.otp4, isNextTyped: $viewModel.isNextTypedArr[3])
				}
				.frame(height: 64)
				.padding(.horizontal, 64)
				TextField("", text: $viewModel.otpField) { isEditing in
					viewModel.isEditing = isEditing
				}
				.frame(width: viewModel.isEditing ? 0 : textFieldOriginalWidth, height: textBoxHeight)
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
    }
}
