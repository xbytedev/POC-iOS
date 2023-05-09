//
//  MTTextField.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 09/05/23.
//

import SwiftUI

public struct MTTextFieldStyle: TextFieldStyle {
	public func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.frame(height: 30)
			.padding(10)
			.background(
				RoundedRectangle(cornerRadius: 6)
					.stroke(AppColor.theme, lineWidth: 2)
			)
			.cornerRadius(6)
	}
}

public struct MTSecureFieldStyle: TextFieldStyle {
	public func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.frame(height: 30)
			.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 48))
			.background(
				RoundedRectangle(cornerRadius: 6)
					.stroke(AppColor.theme, lineWidth: 2)
			)
			.cornerRadius(6)
	}
}

struct MTTextField: View {
	let labelStr: String
	private let isPasswordField: Bool
	@Binding var valueStr: String
	@State private var shouldShow: Bool = false

	init(label: String, valueStr: Binding<String>, isPassword: Bool = false) {
		_valueStr = valueStr
		isPasswordField = isPassword
		self.labelStr = label
	}

    var body: some View {
		if isPasswordField {
			getField()
				.textFieldStyle(MTSecureFieldStyle())
				.overlay(alignment: .topLeading) {
					label
				}
				.overlay(alignment: .trailing, content: {
					btnEye
						.padding(.horizontal)
				})
				.padding(.vertical)
		} else {
			TextField("", text: $valueStr)
				.textFieldStyle(MTTextFieldStyle())
				.overlay(alignment: .topLeading) {
					label
				}
				.padding(.vertical)
		}
    }

	private var label: some View {
		GeometryReader { geo in
			Text(labelStr)
				.padding(.horizontal, 4)
				.background(AppColor.Background.white)
				.foregroundColor(AppColor.theme)
				.font(AppFont.getFont(forStyle: .body))
				.offset(CGSize(width: 10, height: -geo.size.height / 2.0))
				.frame(height: geo.size.height)
		}
	}

	private var btnEye: some View {
		Button {
			shouldShow.toggle()
		} label: {
			Image(systemName: shouldShow ? "eye" : "eye.slash")
				.background(AppColor.Background.white)
		}
	}

	@ViewBuilder private func getField() -> some View {
		if shouldShow {
			TextField("", text: $valueStr).padding(.zero)
		} else {
			SecureField("", text: $valueStr).padding(.zero)
		}
	}
}

struct MTTextField_Previews: PreviewProvider {
	@State static var str: String = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
    static var previews: some View {
		VStack {
			MTTextField(label: "Username", valueStr: $str)
			MTTextField(label: "Password", valueStr: $str, isPassword: true)
		}
    }
}
