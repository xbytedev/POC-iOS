//
//  LoginView.swift
//  MyTravel2
//
//  Created by Mrugesh Tank on 05/05/23.
//

import SwiftUI

struct LoginView: View {
	@State private var usernameStr = ""
	@State private var passwordStr = ""
    var body: some View {
		ZStack {
			Image(uiImage: UIImage(named: "img_background")!)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.clipped()
				.frame(minWidth: 0, maxWidth: .infinity)
				.ignoresSafeArea()
			VStack {
				VStack(spacing: 0) {
					MTTextField(label: "Username", valueStr: $usernameStr)
					MTTextField(label: "Password", valueStr: $passwordStr, isPassword: true)
				}
				VStack(spacing: 16) {
					HStack {
						Spacer()
						NavigationLink {
							Text("Forgot password")
						} label: {
							Text("Forgot Password?")
								.font(AppFont.getFont(forStyle: .subheadline, forWeight: .medium))
								.foregroundColor(AppColor.Text.secondary)
						}
					}
					HStack {
						Spacer()
						Text(getAttrStr())
						/*Text("Don't have an account?")
						NavigationLink {
							Text("Register")
						} label: {
							Text("Register")
								.font(AppFont.getFont(forStyle: .headline, forWeight: .semibold))
								.foregroundColor(AppColor.theme)
						}*/
						Spacer()
					}
				}
			}
			.padding(.vertical, 32)
			.modifier(FormModifier())
		}
    }

	private func getAttrStr() -> AttributedString {
		var str1 = AttributedString("Don't have an account? ")
		str1.font = AppFont.getFont(forStyle: .body)
		str1.foregroundColor = AppColor.Text.secondary

		var str2 = AttributedString("Register")
		str2.font = AppFont.getFont(forStyle: .body, forWeight: .semibold)
		str2.foregroundColor = AppColor.theme
		str2.link = URL(string: "https://google.com")

		return str1 + str2
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
			.previewDevice("iPhone 14 Pro")
			.previewDisplayName("iPhone 14 Pro")
		LoginView()
			.previewDevice("iPhone 8 Plus")
			.previewDisplayName("iPhone 8 Plus")
	}
}
